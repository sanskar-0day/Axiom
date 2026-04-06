import std/[asyncdispatch, asynchttpserver, json, strutils]
import ws
import protocol, packages, nixedit, rebuild, sysinfo, graphdb, config

var clients: seq[WebSocket] = @[]

proc broadcast(msg: string) {.async.} =
  var alive: seq[WebSocket] = @[]
  for c in clients:
    try:
      await c.send(msg)
      alive.add(c)
    except:
      discard
  clients = alive

proc handleRequest(req: Request) {.async.} =
  case req.kind
  of rkSearchPackages:
    let q = req.payload["query"].getStr()
    let results = searchPackages(q)
    await broadcast(makeResult(req.id, results))

  of rkInstallPackage:
    let name = req.payload["name"].getStr()
    await broadcast(makeProgress(req.id, 10, "Editing configuration..."))
    let ok = addPackage(name)
    if not ok:
      await broadcast(makeError(req.id, "Failed to add package"))
      return
    await broadcast(makeProgress(req.id, 30, "Rebuilding..."))
    let rebuildOk = await rebuildSystem(proc(p: int, m: string): Future[void] {.async.} =
      await broadcast(makeProgress(req.id, 30 + (p * 65 div 100), m))
    )
    if rebuildOk:
      await broadcast(makeResult(req.id, %*{"success": true}))
    else:
      await broadcast(makeError(req.id, "Rebuild failed"))

  of rkRemovePackage:
    let name = req.payload["name"].getStr()
    let ok = removePackage(name)
    if ok:
      await broadcast(makeResult(req.id, %*{"success": true}))
    else:
      await broadcast(makeError(req.id, "Failed to remove package"))

  of rkGetOption:
    let path = req.payload["path"].getStr()
    try:
      let val = readOption(path)
      await broadcast(makeResult(req.id, %*{"value": val}))
    except:
      await broadcast(makeError(req.id, "Failed to read option"))

  of rkSetOption:
    let path = req.payload["path"].getStr()
    let val = req.payload["value"].getStr()
    let ok = writeOption(path, val)
    if ok:
      await broadcast(makeResult(req.id, %*{"success": true}))
    else:
      await broadcast(makeError(req.id, "Failed to set option"))

  of rkGetOptionTree:
    let root = req.payload.getOrDefault("root").getStr("")
    let tree = getOptionTree(root)
    await broadcast(makeResult(req.id, tree))

  of rkGetDependencies:
    let opt = req.payload["option"].getStr()
    let deps = getDependencies(opt)
    await broadcast(makeResult(req.id, deps))

  of rkGetSystemInfo:
    let info = getSystemInfo()
    await broadcast(makeResult(req.id, info))

  of rkRebuild:
    await broadcast(makeProgress(req.id, 0, "Starting rebuild..."))
    let ok = await rebuildSystem(proc(p: int, m: string): Future[void] {.async.} =
      await broadcast(makeProgress(req.id, p, m))
    )
    if ok:
      await broadcast(makeResult(req.id, %*{"success": true}))
    else:
      await broadcast(makeError(req.id, "Rebuild failed"))

  of rkListInstalled:
    let pkgs = listPackages()
    await broadcast(makeResult(req.id, %*pkgs))

proc startServer*(port: int) {.async.} =
  echo "Axiom Engine starting on ws://localhost:", port

  var server = newAsyncHttpServer()

  proc callback(req: Request) {.async.} =
    if req.headers.hasKey("Upgrade") and
       req.headers["Upgrade"].toLowerAscii() == "websocket":
      try:
        let ws = await newWebSocket(req)
        echo "Client connected"
        clients.add(ws)
        while ws.readyState == Open:
          let (opcode, data) = await ws.receivePacket()
          if opcode == Text:
            try:
              let request = parseRequest(data)
              await handleRequest(request)
            except Exception as e:
              echo "Error: ", e.msg
              await ws.send(makeError("unknown", e.msg))
          elif opcode == Close:
            break
        echo "Client disconnected"
      except:
        echo "WebSocket error"
    else:
      await req.respond(Http200, """{"status":"running","engine":"axiom"}""",
                        newHttpHeaders([("Content-Type", "application/json")]))

  server.listen(Port(port))
  echo "Listening on port ", port

  while true:
    if server.shouldAcceptRequest():
      await server.acceptRequest(callback)
    else:
      await sleepAsync(500)
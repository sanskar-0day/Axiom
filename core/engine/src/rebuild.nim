import std/[asyncdispatch, osproc, streams, strutils, json]

type
  RebuildCallback* = proc(percent: int, message: string): Future[void]

proc rebuildSystem*(onProgress: RebuildCallback): Future[bool] {.async.} =
  let process = startProcess(
    "nixos-rebuild",
    args = ["switch"],
    options = {poUsePath, poStdErrToStdOut}
  )

  let stream = process.outputStream()
  var lineCount = 0

  while not stream.atEnd():
    let line = stream.readLine()
    inc lineCount
    let percent = min(95, lineCount)
    await onProgress(percent, line)
    await sleepAsync(1)

  let exitCode = process.waitForExit()
  process.close()

  if exitCode == 0:
    await onProgress(100, "Rebuild complete")
    return true
  else:
    await onProgress(-1, "Rebuild failed with exit code " & $exitCode)
    return false
import std/json

type
  RequestKind* = enum
    rkSearchPackages = "search_packages"
    rkInstallPackage = "install_package"
    rkRemovePackage = "remove_package"
    rkGetOption = "get_option"
    rkSetOption = "set_option"
    rkGetOptionTree = "get_option_tree"
    rkGetDependencies = "get_dependencies"
    rkGetSystemInfo = "get_system_info"
    rkRebuild = "rebuild"
    rkListInstalled = "list_installed"

  Request* = object
    id*: string
    kind*: RequestKind
    payload*: JsonNode

proc parseRequest*(raw: string): Request =
  let j = parseJson(raw)
  let id = j["id"].getStr()
  let kindStr = j["type"].getStr()

  var kind: RequestKind
  case kindStr
  of "search_packages": kind = rkSearchPackages
  of "install_package": kind = rkInstallPackage
  of "remove_package": kind = rkRemovePackage
  of "get_option": kind = rkGetOption
  of "set_option": kind = rkSetOption
  of "get_option_tree": kind = rkGetOptionTree
  of "get_dependencies": kind = rkGetDependencies
  of "get_system_info": kind = rkGetSystemInfo
  of "rebuild": kind = rkRebuild
  of "list_installed": kind = rkListInstalled
  else:
    raise newException(ValueError, "Unknown request type: " & kindStr)

  return Request(id: id, kind: kind, payload: j)

proc makeResult*(id: string, data: JsonNode): string =
  $ %*{"id": id, "type": "result", "data": data}

proc makeError*(id: string, message: string): string =
  $ %*{"id": id, "type": "error", "message": message}

proc makeProgress*(id: string, percent: int, message: string): string =
  $ %*{"id": id, "type": "progress", "percent": percent, "message": message}
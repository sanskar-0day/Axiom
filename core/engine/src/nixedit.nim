import std/[osproc, strutils]
import config

proc runNixEditor(args: seq[string]): tuple[output: string, success: bool] =
  let cmd = "nix-editor " & args.join(" ")
  let (output, exitCode) = execCmdEx(cmd)
  return (output: output.strip(), success: exitCode == 0)

proc addPackage*(name: string): bool =
  for ch in name:
    if ch notin Letters + Digits + {'-', '_', '.'}:
      return false
  let (_, ok) = runNixEditor(@[
    getConfigPath(), "write",
    "environment.systemPackages", "--add", name
  ])
  return ok

proc removePackage*(name: string): bool =
  let (_, ok) = runNixEditor(@[
    getConfigPath(), "write",
    "environment.systemPackages", "--remove", name
  ])
  return ok

proc readOption*(path: string): string =
  let (output, ok) = runNixEditor(@[getConfigPath(), "read", path])
  if ok: return output
  else: raise newException(IOError, "Failed to read: " & path)

proc writeOption*(path: string, value: string): bool =
  let (_, ok) = runNixEditor(@[
    getConfigPath(), "write", path, "--val", value
  ])
  return ok

proc listPackages*(): seq[string] =
  try:
    let raw = readOption("environment.systemPackages")
    let inner = raw.split('[')[^1].split(']')[0]
    for word in inner.splitWhitespace():
      if word notin ["with", "pkgs;", "pkgs", ";"]:
        result.add(word)
  except:
    result = @[]
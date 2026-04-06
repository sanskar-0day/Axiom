import std/[json, strutils, algorithm, osproc, os, times]
import config

type
  Package* = object
    name*: string
    version*: string
    description*: string

var packageDb: seq[Package] = @[]
var loaded = false

proc loadPackages*() =
  let cacheFile = packageCachePath

  if not fileExists(cacheFile) or
     (getTime() - getLastModificationTime(cacheFile)).inSeconds > cacheMaxAge:
    echo "Generating package database..."
    let (output, code) = execCmdEx("nix search nixpkgs --json \"\"")
    if code == 0:
      writeFile(cacheFile, output)

  if not fileExists(cacheFile):
    echo "Warning: no package cache available"
    loaded = true
    return

  echo "Loading packages..."
  let raw = parseJson(readFile(cacheFile))
  packageDb = @[]
  for key, val in raw.pairs:
    packageDb.add(Package(
      name: val["pname"].getStr(),
      version: val["version"].getStr(),
      description: val.getOrDefault("description").getStr("")
    ))
  loaded = true
  echo "Loaded ", packageDb.len, " packages"

proc searchPackages*(query: string): JsonNode =
  if not loaded: loadPackages()

  let q = query.toLowerAscii()
  var scored: seq[tuple[score: int, pkg: Package]] = @[]

  for pkg in packageDb:
    let n = pkg.name.toLowerAscii()
    let d = pkg.description.toLowerAscii()
    var score = 0

    if n == q: score = 1000
    elif n.startsWith(q): score = 500
    elif n.contains(q): score = 200
    elif d.contains(q): score = 50
    else: continue

    score += max(0, 100 - pkg.name.len)
    scored.add((score, pkg))

  scored.sort(proc(a, b: auto): int = b.score - a.score)

  var results = newJArray()
  for i in 0 ..< min(50, scored.len):
    results.add(%*{
      "name": scored[i].pkg.name,
      "version": scored[i].pkg.version,
      "description": scored[i].pkg.description
    })
  return results
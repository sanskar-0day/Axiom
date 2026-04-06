import std/[json, osproc, strutils, os]
import config

proc runKuzu(query: string): string =
  let (output, exitCode) = execCmdEx(
    "kuzu \"" & graphDbPath & "\" -c \"" & query.replace("\"", "\\\"") & "\""
  )
  if exitCode != 0:
    raise newException(IOError, "Kuzu error: " & output)
  return output

proc initGraphDb*() =
  if not dirExists(graphDbPath):
    createDir(graphDbPath)

  try:
    discard runKuzu("CREATE NODE TABLE IF NOT EXISTS Option (name STRING, type STRING, description STRING, PRIMARY KEY (name))")
    discard runKuzu("CREATE REL TABLE IF NOT EXISTS DEPENDS_ON (FROM Option TO Option)")
    discard runKuzu("CREATE REL TABLE IF NOT EXISTS CHILD_OF (FROM Option TO Option)")
  except:
    echo "Warning: Graph DB initialization failed. Some features will be limited."

proc ingestOptions*(jsonPath: string) =
  if not fileExists(jsonPath):
    echo "Options JSON not found: ", jsonPath
    return

  let raw = parseJson(readFile(jsonPath))
  for name, opt in raw.pairs:
    let desc = opt.getOrDefault("description").getStr("").replace("'", "''")
    let optType = opt.getOrDefault("type").getStr("")
    try:
      discard runKuzu("CREATE (o:Option {name: '" & name & "', type: '" & optType & "', description: '" & desc & "'})")
    except:
      discard

proc getDependencies*(optionName: string): JsonNode =
  try:
    let output = runKuzu(
      "MATCH (a:Option {name: '" & optionName & "'})-[:DEPENDS_ON*1..5]->(b:Option) RETURN b.name, b.type, b.description"
    )
    return parseJson(output)
  except:
    return %*{"nodes": [], "edges": []}

proc getOptionTree*(root: string): JsonNode =
  try:
    let output = runKuzu(
      "MATCH (o:Option) WHERE o.name STARTS WITH '" & root & "' RETURN o.name, o.type ORDER BY o.name LIMIT 500"
    )
    return parseJson(output)
  except:
    return newJArray()
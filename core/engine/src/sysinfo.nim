import std/[osproc, strutils, json, os]

proc getSystemInfo*(): JsonNode =
  let hostname = try: readFile("/etc/hostname").strip() except: "unknown"
  let kernel = try: execCmdEx("uname -r")[0].strip() except: "unknown"
  let uptime = try: execCmdEx("uptime -p")[0].strip() except: "unknown"

  let nixosVersion = try:
    execCmdEx("nixos-version")[0].strip()
  except: "unknown"

  let cpuInfo = try:
    let raw = readFile("/proc/cpuinfo")
    var model = ""
    for line in raw.splitLines():
      if line.startsWith("model name"):
        model = line.split(':')[1].strip()
        break
    model
  except: "unknown"

  let memInfo = try:
    let raw = readFile("/proc/meminfo")
    var total, available: string
    for line in raw.splitLines():
      if line.startsWith("MemTotal"):
        total = line.split(':')[1].strip()
      elif line.startsWith("MemAvailable"):
        available = line.split(':')[1].strip()
    (total, available)
  except: ("unknown", "unknown")

  return %*{
    "hostname": hostname,
    "nixosVersion": nixosVersion,
    "kernel": kernel,
    "uptime": uptime,
    "cpu": cpuInfo,
    "memoryTotal": memInfo[0],
    "memoryUsed": memInfo[1]
  }
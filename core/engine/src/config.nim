import std/[os, strutils]

const
  defaultPort* = 1337
  defaultConfigPath* = "/etc/nixos/configuration.nix"
  packageCachePath* = "/tmp/axiom-packages.json"
  graphDbPath* = "/var/lib/axiom/graphdb"
  cacheMaxAge* = 24 * 3600  # 24 hours in seconds

proc getConfigPath*(): string =
  getEnv("AXIOM_CONFIG_PATH", defaultConfigPath)

proc getPort*(): int =
  let portStr = getEnv("AXIOM_PORT", $defaultPort)
  try:
    return parseInt(portStr)
  except ValueError:
    return defaultPort
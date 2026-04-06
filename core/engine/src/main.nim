import std/asyncdispatch
import server, packages, graphdb, config

proc main() =
  echo "Axiom OS Engine v0.1.0"
  echo "======================"

  # Load package database
  echo "Loading package database..."
  loadPackages()

  # Initialize graph database
  echo "Initializing graph database..."
  initGraphDb()

  # Start WebSocket server
  let port = getPort()
  waitFor startServer(port)

main()
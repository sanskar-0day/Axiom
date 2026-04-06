import std/[os, osproc]
import webview

const
  defaultGuiPath = "../../apps/gui/dist/index.html"

proc main() =
  # Resolve GUI path
  let guiPath = if paramCount() > 0: paramStr(1)
                else: getAppDir() / defaultGuiPath

  let absGuiPath = absolutePath(guiPath)

  if not fileExists(absGuiPath):
    echo "Error: GUI not found at ", absGuiPath
    echo "Run 'cd apps/gui && pnpm build' first."
    quit(1)

  # Start the engine in background
  echo "Starting Axiom Engine..."
  let enginePath = getAppDir() / "../engine/main"

  var engineProcess: Process
  if fileExists(enginePath):
    engineProcess = startProcess(enginePath)
    sleep(800)  # give engine time to start
  else:
    echo "Warning: Engine binary not found. GUI will start without backend."

  # Open the webview
  echo "Opening Axiom OS..."
  let w = newWebView(
    title = "Axiom OS",
    width = 1280,
    height = 800,
    resizable = true,
    debug = defined(debug)
  )

  w.navigate("file://" & absGuiPath)
  w.run()

  # Cleanup
  echo "Shutting down..."
  if engineProcess != nil:
    engineProcess.terminate()
    engineProcess.close()

main()
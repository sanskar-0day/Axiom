import os
import webview

proc main() =
  # Use absolute path to the built Svelte app
  let guiPath = "/home/sanskar/DEV/Axiom/apps/gui/dist/index.html"
  let url = "file://" + guiPath
  
  let w = webview.create("Axiom OS", true)
  w.set_size(1280, 720, webview.HINT_NONE)
  w.navigate(url)
  w.run()

if isMainModule:
  main()

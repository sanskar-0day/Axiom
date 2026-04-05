# Axiom Bridge

The Bridge is a Nim wrapper around the `webview` library that hosts the Svelte GUI.

## Prerequisites

You need the following system dependencies:
- `webkitgtk`
- `gtk3`
- `pkg-config`

## How to run

1. Build the GUI:
   ```bash
   cd apps/gui
   npm install
   npm run build
   ```

2. Run the bridge:
   ```bash
   nim c -r core/bridge/main.nim
   ```

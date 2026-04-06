#!/usr/bin/env bash
set -euo pipefail

# Wine auto-configuration for common Windows apps
APP_NAME="${1:-}"

if [ -z "$APP_NAME" ]; then
  echo "Usage: wine-setup.sh <app-name>"
  echo "Available: photoshop, office, cad"
  exit 1
fi

WINEPREFIX="$HOME/.wine-$APP_NAME"
export WINEPREFIX

echo "Setting up Wine prefix for $APP_NAME at $WINEPREFIX"

# Create new prefix
WINEARCH=win64 wineboot --init

case "$APP_NAME" in
  photoshop)
    winetricks corefonts vcrun2019 gdiplus
    echo "Photoshop prefix ready. Install manually into $WINEPREFIX"
    ;;
  office)
    winetricks corefonts msxml6 riched20 dotnet48
    echo "Office prefix ready. Install manually into $WINEPREFIX"
    ;;
  cad)
    winetricks corefonts vcrun2019 dotnet48 d3dx9
    echo "CAD prefix ready. Install manually into $WINEPREFIX"
    ;;
  *)
    echo "Unknown app: $APP_NAME"
    exit 1
    ;;
esac

echo "Done. Run your app with: WINEPREFIX=$WINEPREFIX wine <exe>"
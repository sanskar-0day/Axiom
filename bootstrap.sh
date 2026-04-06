#!/usr/bin/env bash
set -e

echo "🚀 Axiom OS - One-Click Bootstrap"
echo "=================================="
echo "This script will:"
echo " 1. Install Nix (if missing)"
echo " 2. Clone the Axiom Repository"
echo " 3. Setup Nim, Node, and Build the App"
echo "=================================="

# 1. Install Nix
if ! command -v nix &> /dev/null; then
    echo "📦 Installing Nix..."
    sh <(curl --proto '=https' --tlsv1.2 -sSfL https://nixos.org/nix/install)
    source ~/.nix-profile/etc/profile.d/nix.sh || source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    echo "✅ Nix Installed"
fi

# 2. Enable Flakes
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf; then
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# 3. Clone Repo
REPO="https://github.com/sanskar-0day/Axiom"
FOLDER="a0_axiom"

if [ ! -d "$FOLDER" ]; then
    echo "🔽 Cloning Axiom..."
    git clone "$REPO" "$FOLDER"
fi

cd "$FOLDER"

# 4. Enter Dev Shell & Build
echo "🛠️ Building Axiom OS..."
echo "Using Flakes to setup Nim, Node, pnpm..."
nix develop . --command bash -c '
    echo "✅ Environment Active"
    pnpm install
    pnpm -r build
    cd core/engine && nimble build -y || echo "Nim build warning"
    cd ../..
    echo "✨ Setup Complete! Run: nix develop && pnpm dev:gui"
'

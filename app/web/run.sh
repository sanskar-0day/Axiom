#!/usr/bin/env bash
# run.sh - Universal Setup & Management Script for Axiom Web
# Usage: ./run.sh [preview|build|broadcast]

set -e

INSTALL_DIR="$(pwd)/.tools"
BIN_DIR="$INSTALL_DIR/bin"
export PATH="$BIN_DIR:$PATH"

MODE="${1:-preview}"
PORT=4200

setup_cloudflared() {
    if ! command -v cloudflared &> /dev/null; then
        echo "[cloudflared] not found. Installing local version..."

        ARCH=$(uname -m)
        if [ "$ARCH" = "x86_64" ]; then
            CF_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
        elif [ "$ARCH" = "aarch64" ]; then
            CF_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
        else
            echo "Unsupported architecture: $ARCH"
            exit 1
        fi

        mkdir -p "$BIN_DIR"
        curl -L -o "$BIN_DIR/cloudflared" "$CF_URL"
        chmod +x "$BIN_DIR/cloudflared"

        echo "cloudflared installed to $BIN_DIR/cloudflared"
    else
        echo "cloudflared detected"
    fi
}

kill_port() {
    echo "Cleaning up port $PORT..."

    PID=$(ss -lptn "sport = :$PORT" 2>/dev/null | grep pid= || true)
    PID=$(echo "$PID" | sed -e 's/.*pid=//g' -e 's/,.*//g' | head -n 1)

    if [ -n "$PID" ]; then
        echo "   Killing existing process (PID: $PID)..."
        kill -9 "$PID" 2>/dev/null || true
    fi

    sleep 1
}

if ! command -v bun &> /dev/null; then
    echo "bun is required but not found in PATH."
    echo "   Install bun: https://bun.sh"
    exit 1
fi

if [ "$MODE" = "build" ]; then
    echo "Installing dependencies with bun..."
    bun install

    echo "Building SvelteKit site (Production Mode)..."
    bun run build

    echo "Build complete."

elif [ "$MODE" = "preview" ]; then
    echo "Ensuring dependencies..."
    bun install

    kill_port
    echo "Starting SvelteKit Dev Server on http://localhost:$PORT..."
    echo "   (Press Ctrl+C to stop)"
    bun run dev -- --port $PORT

elif [ "$MODE" = "broadcast" ]; then
    setup_cloudflared

    echo "Ensuring dependencies..."
    bun install

    echo "Starting Broadcast Mode..."
    kill_port

    echo "   1. Starting SvelteKit Dev Server (Background)..."
    bun run dev -- --port $PORT &
    VITE_PID=$!

    echo "   Waiting for preview server..."
    sleep 5

    echo "   2. Starting Cloudflare Tunnel..."
    echo ""

    "$BIN_DIR/cloudflared" tunnel --url "http://localhost:$PORT"

    kill "$VITE_PID"

else
    echo "Unknown mode: $MODE"
    echo "   Usage: ./run.sh [preview|build|broadcast]"
    exit 1
fi

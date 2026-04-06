#!/usr/bin/env bash
set -euo pipefail

# Initialize a Distrobox container for accessing other distro's tools
DISTRO="${1:-ubuntu}"

echo "Creating Distrobox container: axiom-$DISTRO"

case "$DISTRO" in
  ubuntu)
    distrobox create --name "axiom-ubuntu" --image ubuntu:24.04
    ;;
  fedora)
    distrobox create --name "axiom-fedora" --image fedora:40
    ;;
  arch)
    distrobox create --name "axiom-arch" --image archlinux:latest
    ;;
  *)
    echo "Unknown distro: $DISTRO"
    echo "Available: ubuntu, fedora, arch"
    exit 1
    ;;
esac

echo "Container created. Enter with: distrobox enter axiom-$DISTRO"
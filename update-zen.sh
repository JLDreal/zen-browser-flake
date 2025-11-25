#!/usr/bin/env bash

# Script to update Zen Browser to the latest version
set -euo pipefail

echo "Fetching latest Zen Browser release..."

# Get latest release tag
LATEST_VERSION=$(curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')

echo "Latest version: $LATEST_VERSION"

# Get download URLs
SPECIFIC_URL="https://github.com/zen-browser/desktop/releases/download/$LATEST_VERSION/zen.linux-x86_64.tar.xz"
GENERIC_URL="https://github.com/zen-browser/desktop/releases/download/$LATEST_VERSION/zen.linux-x86_64.tar.xz"

echo "Fetching hashes..."

# Get hashes
SPECIFIC_HASH=$(nix-prefetch-url --type sha256 "$SPECIFIC_URL")
GENERIC_HASH=$(nix-prefetch-url --type sha256 "$GENERIC_URL")

echo "Specific hash: $SPECIFIC_HASH"
echo "Generic hash: $GENERIC_HASH"

# Update flake.nix
sed -i "s/version = \".*\";/version = \"$LATEST_VERSION\";/" flake.nix
sed -i "s|sha256 = \"sha256:.*\";|sha256 = \"sha256:$SPECIFIC_HASH\";|" flake.nix

echo "Updated flake.nix to version $LATEST_VERSION"

# Update flake.lock
nix flake update

echo "Done! Zen Browser updated to $LATEST_VERSION"
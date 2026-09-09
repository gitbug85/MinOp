#!/usr/bin/env bash
MINOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "export PATH=\"$MINOP_DIR:\$PATH\"" >> "$HOME/.bashrc"
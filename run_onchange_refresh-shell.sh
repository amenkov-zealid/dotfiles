#!/usr/bin/env bash
set -euo pipefail

if command -v fish >/dev/null 2>&1; then
  fish -c 'fish_add_path /opt/homebrew/bin >/dev/null 2>&1; true'
fi

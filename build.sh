#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Generating deepBlack themes..."
"$ROOT/tools/generate_themes.py"

echo "Build complete."

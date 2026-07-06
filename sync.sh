#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$ROOT/build.sh"

if [ -d "$ROOT/source/dwl" ]; then
  cp "$ROOT/generated/dwl/design_tokens.h" "$ROOT/source/dwl/design_tokens.h"
  echo "Synced design_tokens.h -> source/dwl/"
fi

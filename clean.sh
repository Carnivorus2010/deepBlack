#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

rm -rf "$ROOT/generated"

rm -f \
  "$ROOT/source/dwl/design_tokens.h" \
  "$ROOT/source/dwl/machine_profile.h"

echo "Cleaned generated files and transient dwl headers."

#!/bin/bash
# Clean up E2E test artifacts
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Cleaning up E2E test artifacts..."

# Remove token files
rm -f "$SCRIPT_DIR/.tokens.json"

# Remove result files
rm -f "$SCRIPT_DIR/.result_*.json"

# Remove Maestro screenshots
rm -f "$SCRIPT_DIR/../.maestro/e2e/*.png"

echo "Cleanup complete."

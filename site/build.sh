#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CATALOG_FILE="$REPO_ROOT/catalog.yaml"
OUTPUT_DIR="$SCRIPT_DIR/data"
OUTPUT_FILE="$OUTPUT_DIR/catalog.json"

if [[ ! -f "$CATALOG_FILE" ]]; then
  echo "ERROR: catalog.yaml not found at $CATALOG_FILE" >&2
  exit 1
fi

if ! command -v yq &>/dev/null; then
  echo "ERROR: yq is required but not installed" >&2
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

yq -o=json "$CATALOG_FILE" > "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE from $CATALOG_FILE"

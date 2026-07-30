#!/usr/bin/env bash
set -euo pipefail

# Example patch apply script.
# Receives env vars: STEAM_DIR, STEAMID64, PATCH_DATA_DIR, STATE_DIR, COMPAT_DIR, GAME_DIR

MARKER_DIR="${HOME}/.local/share/deck-patcher/applied"
MARKER="${MARKER_DIR}/example-patch.marker"

mkdir -p "${MARKER_DIR}"

# Idempotent: safe to run multiple times
if [[ -f "${MARKER}" ]]; then
    echo "example-patch: already applied, skipping"
    exit 0
fi

echo "example-patch: applying"
touch "${MARKER}"
echo "example-patch: done"

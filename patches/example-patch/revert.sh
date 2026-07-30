#!/usr/bin/env bash
set -euo pipefail

# Example patch revert script.
# Receives env vars: STEAM_DIR, STEAMID64, PATCH_DATA_DIR, STATE_DIR, COMPAT_DIR, GAME_DIR

MARKER="${HOME}/.local/share/deck-patcher/applied/example-patch.marker"

if [[ ! -f "${MARKER}" ]]; then
    echo "example-patch: not applied, nothing to revert"
    exit 0
fi

echo "example-patch: reverting"
rm -f "${MARKER}"
echo "example-patch: done"

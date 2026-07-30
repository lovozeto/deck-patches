# Example Patch

This is a minimal test patch included with Deck Patcher to verify that the apply/revert
workflow is functioning correctly.

## What it does

Creates a single marker file at `~/.local/share/deck-patcher/applied/example-patch.marker`.
No game files are modified.

## Requirements

None. Steam and the game do not need to be closed.

## How to revert

Apply → Revert in the Deck Patcher UI, or run `revert.sh` manually.

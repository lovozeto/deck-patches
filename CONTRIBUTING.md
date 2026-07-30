# Contributing to deck-patches

Thank you for contributing to the Deck Patcher community patch registry.

---

## How to create a patch

Each patch lives in its own directory under `patches/`. The directory name must match the patch `id`.

### Directory structure

```
patches/
└── your-patch-id/
    ├── patch.json     # required — metadata and declarations
    ├── apply.sh       # required — idempotent apply logic
    ├── revert.sh      # required when reversible: true
    └── README.md      # required — human-readable description
```

### Patch naming convention

Use kebab-case: `game-name-description`. Keep it specific enough to be unique.

Good examples:
- `forza-horizon-6-profile-switch`
- `greenlight-flatpak-controller`
- `elden-ring-easy-anticheat-disable`

Avoid:
- Generic names like `fix` or `patch`
- Starting with a number
- Uppercase or underscores

---

## patch.json fields reference

See [`schemas/patch-schema.json`](schemas/patch-schema.json) for the authoritative schema.

| Field | Type | Required | Description |
|---|---|---|---|
| `id` | string | yes | Must match the directory name. Pattern: `^[a-z0-9-]+$` |
| `name` | string | yes | Human-readable display name |
| `description` | string | yes | One or two sentences describing what the patch does |
| `game` | string | yes | Name of the game or app |
| `appid` | string | yes | Steam AppID (numeric) or Flatpak ID |
| `version` | string | yes | Semantic version, e.g. `1.0.0` |
| `author` | string | yes | Your GitHub username |
| `category` | enum | yes | `game` or `app` |
| `type` | enum | yes | `proton-prefix`, `flatpak-config`, `system-service`, `launch-options`, or `mixed` |
| `tags` | string[] | yes | Freeform tags for filtering |
| `min_steamos` | string | yes | Minimum SteamOS version required, e.g. `3.5` |
| `reversible` | boolean | yes | `true` if the patch includes a `revert.sh` |
| `auto_reapply` | boolean | yes | `true` if Deck Patcher should re-apply after OS updates |
| `requirements` | object | yes | Pre-conditions: `steam_closed`, `game_closed` (both optional booleans) |
| `markers` | array | yes | At least one check to determine if the patch is applied |
| `modifications` | array | no | Declarative list of what the patch changes (informational) |
| `app_setup` | object | no | Non-Steam app configuration (Flatpak, Steam shortcut, etc.) |

**Marker types:** `file_exists`, `dir_exists`, `symlink_target`, `service_active`, `launch_options_contains`

**Modification actions:** `creates_symlink`, `installs_file`, `creates_directory`, `creates_service`, `edits_vdf`, `edits_registry`, `copies_file`, `sets_launch_options`

---

## Shell script requirements

Both `apply.sh` and `revert.sh` must:

1. Start with `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Pass `shellcheck --severity=warning` with no errors or warnings.
3. Be **idempotent**: running the script twice must produce the same result as running it once.
4. Print a short status line at start and end (see `patches/example-patch/apply.sh`).

### Environment variables available to scripts

The Deck Patcher app injects these before calling your script:

| Variable | Description |
|---|---|
| `STEAM_DIR` | Path to the Steam installation (`~/.steam/steam`) |
| `STEAMID64` | The active Steam user's 64-bit ID |
| `PATCH_DATA_DIR` | Path to any bundled data files shipped with the patch |
| `STATE_DIR` | Persistent state directory for this patch |
| `COMPAT_DIR` | Path to the game's Proton compatibility data directory |
| `GAME_DIR` | Path to the game's install directory |

---

## How to test locally

Before opening a PR, test your patch manually on your Steam Deck:

```bash
# From the patch directory
bash apply.sh
# Verify the marker or expected outcome exists
bash apply.sh   # run again — should say "already applied, skipping"
bash revert.sh
bash revert.sh  # run again — should say "nothing to revert"
```

Run ShellCheck locally:
```bash
shellcheck --severity=warning patches/your-patch-id/apply.sh
shellcheck --severity=warning patches/your-patch-id/revert.sh
```

Validate patch.json against the schema:
```bash
pip install jsonschema
python3 -c "
import json, jsonschema
from pathlib import Path
schema = json.loads(Path('schemas/patch-schema.json').read_text())
data = json.loads(Path('patches/your-patch-id/patch.json').read_text())
jsonschema.validate(data, schema)
print('OK')
"
```

---

## PR process

1. Fork the repository and create a branch named `patch/your-patch-id`.
2. Add the patch directory with all required files.
3. Update `index.json` to include your patch entry (the `generate-index.yml` workflow will regenerate it on merge, but including it in your PR helps reviewers).
4. Open a pull request. The `validate.yml` workflow will run automatically.
5. A maintainer will review the patch logic, script safety, and schema compliance.

### What reviewers check

- Script is idempotent and handles missing files gracefully.
- No hardcoded paths that would break on other users' systems.
- Markers accurately reflect whether the patch is applied.
- `reversible: true` patches include a working `revert.sh`.
- No destructive actions without confirmation in the script.

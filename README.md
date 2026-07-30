# deck-patches

Community patch registry for [Deck Patcher](https://github.com/lovozeto/deck-patcher) — a Steam Deck patch manager.

This repository stores patch metadata, apply/revert scripts, and the `index.json` that the Deck Patcher app reads to discover available patches.

---

## Available patches

| ID | Game / App | Description |
|---|---|---|
| `example-patch` | Example | Minimal test patch — verifies the apply/revert workflow |

---

## How to contribute a patch

See [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Directory structure and required files
- Naming conventions
- Shell script requirements (idempotent, ShellCheck-clean)
- `patch.json` fields reference
- How to test locally before opening a PR

---

## How to request a patch

Open an issue using the **Patch request** template:
[github.com/lovozeto/deck-patches/issues/new/choose](https://github.com/lovozeto/deck-patches/issues/new/choose)

Include the game name, Steam AppID, and a description of the problem you want the patch to solve. Links to ProtonDB reports or forum workarounds are especially helpful.

---

## License

MIT — see [LICENSE](LICENSE).

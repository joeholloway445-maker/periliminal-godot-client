# Periliminal Godot Client

Standalone Godot **4.3+** client for Periliminal.Space.

Open `project.godot` in Godot 4.3 or 4.7. Press F5. Green = Debugger → Errors has **zero SCRIPT ERROR**.

Repo: https://github.com/joeholloway445-maker/periliminal-godot-client

## Spine

boot wizard → six layers → world movement → combat/capture → NPCs/word-of-mouth → always-on HOPE → silent KNOLL → consistency → doors → Recall Walk body memory → local + bridge persistence

- Projector: sex × 20 races × 20 frames × 20 mods = **16,000** compositions (`OmniDexTables.compose`). No 16k scenes.
- Six currencies: coins, chips, fragments, tokens, charges, prestige.
- Periliminal entry is Liminal pull or dev key 6. No countdown.
- Superliminal hidden door has no mesh.
- Casino chips leave the engine on `POST /api/casino/ticket`. Settlement is web-only.

## Connectors

Default base `https://periliminal-rebuild-slice.vercel.app` (override `--bridge=` or `user://bridge.json`).

| Autoload | Route |
|---|---|
| CasinoBridge | POST /api/casino/ticket, /api/casino/settle |
| HopeBridge | POST /api/hope |
| VoteBridge | POST /api/vote |
| SecretBridge | POST /api/secret |
| PersistBridge | POST /api/persist |
| NakamaBridge | POST /api/nakama |
| SupabaseBridge | POST /api/supabase |
| Handoff | `--player-id=` `--return-to=` |

## Keys

WASD move, mouse look, click strike or talk, E door/cabinet, C casino ticket, H help deed, V vote, N cycle DFW city, P persist snapshot, CTRL crouch, 1–6 force layer, ESC mouse.

Blessing door in Periliminal returns to Subliminal and banks prestige.

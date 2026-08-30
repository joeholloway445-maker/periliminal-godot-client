# Periliminal Godot Client

Standalone Godot **4.3+** client for Periliminal.Space. Not the 324MB monorepo.

Open `project.godot` in Godot 4.3 or 4.7. Press F5.

## What this client is

- Projector body: sex × 20 races × 20 frames × 20 mods (`OmniDexTables.combo_count()` = 16000)
- Six layers with AGENTS.md rules (Periliminal only via Liminal pull or dev key 6)
- Six currencies on `Wallet`
- HOPE speaks. KNOLL never speaks.
- Consistency meter drives Periliminal difficulty
- Entity party 0–3, capture on attack
- Casino: chips leave the engine via `CasinoBridge` ticket. No in-engine payout RNG
- Story vote + HOPE telemetry HTTP connectors
- HDV handoff args `--player-id=` `--return-to=`

## Keys

- WASD move, mouse look, E use
- 1–6 force layer (dev)
- C casino ticket (Hyperliminal, or force with 4 then C)
- H help deed / G attack deed
- V story vote
- ESC frees mouse

## Bridge

Default base: `https://periliminal-rebuild-slice.vercel.app`

Override:

```
godot -- --bridge=https://your-host
```

or `user://bridge.json` → `{ "bridge_base": "https://..." }`

Routes the client posts:

- `POST /api/casino/ticket`
- `POST /api/casino/settle`
- `POST /api/hope`
- `POST /api/vote`
- `POST /api/secret`

## Green

Debugger → Errors = 0 SCRIPT ERROR after import. That is green. Then F5.

# levelgen: Phase 1 level generator

Builds and checks the levels in `assets/levels/phase_1.json` (L41–L500). Related docs: [02 Level Progression](../../phases/phase_1/02_LEVEL_PROGRESSION_0001_0500.md) · [03 Obstacle Catalog](../../phases/phase_1/03_OBSTACLE_CATALOG_PHASE_1.md) · [Level tasks](../../handoff/LEVEL_TASKS.md)

Run from `game_1_snakes_slither/`:

| Command | What it does |
|---|---|
| `dart run tools/levelgen/main.dart gen A B` | Rebuild levels A..B and write them into the level file (`--dry` = print only) |
| `dart run tools/levelgen/main.dart check A B` | Draft check + play every solution in the simulator + recompute D |
| `dart run tools/levelgen/main.dart same A B` | Rebuild A..B in memory and list levels that differ from the file |

Set `LEVELS=path` to work on another file.

## How it works
- `core.dart`: rules simulator for M001–M049, written from the 03 cards and the move order in 01 §5.9, plus a solver (fewest moves, never a bonk). Cells a card does not define (lever cell, empty lilypad, empty stump cell, egg cell before the hatch, mist before it clears) count as "not allowed", so no solution depends on them.
- `build.dart`: one level = static obstacles → snakes placed in reverse exit order (a plain exit order always exists, chain C steered to a target) → dynamic mechanics placed around that order → solver finds the real `solution` → D computed → kept only if the real `LevelDraftCheck` passes, the block's new mechanic is used in the solution, and D sits in the slot's window.
- Each level has a fixed seed (from its number), so the same code always rebuilds the same file.
- `io.dart`: schema v3 read/write and D = 0.6·P + 1.5·C + 2·O + 3·N + S.

Open points for the engine are listed in [CHANGE_REQUESTS.md](../../handoff/CHANGE_REQUESTS.md) ("Levels → logic").

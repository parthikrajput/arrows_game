Source docs: phases/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md, phases/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §12, §16.17, §17.24, §17.38. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-7-signature-system.md.

# Spec: Gameplay — Phase 8 Signature System (Overgrown Garden)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 8 signature system "Overgrown Garden" (Growth): an organic spreading puzzle model incorporating procedural vine expansion, tile-activated pruning mechanics, delayed seed pod germination, and weed-clearance bloom locks across Levels 3501–4000.

## Current State
Design documented in `phases/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md`, `phases/phase_8/01_PHASE_8_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases featured static obstacles, moving obstacles, or rotating sub-grids.
- Phase 8 introduces dynamic multi-cell entity growth that occupies previously passable floor tiles unless pruned by player actions.

## Proposed Change
Extend `packages/puzzle_core` with organic growth simulation pipelines, directional neighbor search algorithms, and pruning event triggers:

### 1. Dynamic Vine Spread & Growth Simulation
- **Growth Tick Interval:** Wild vines evaluate expansion every $N$ completed player moves (default $N = 3$).
- **Deterministic Directional Search:**
  - Expanding vine tips search adjacent orthogonal neighbor cells in fixed priority order:
    $$\text{Up} \to \text{Right} \to \text{Down} \to \text{Left}$$
  - The vine claims the first 2 free floor cells found.
- **Growth Blockers & Invariants:**
  - Vines **cannot grow onto cells occupied by snake bodies**, walls, static obstacles, or active power-ups.
  - If all 4 neighbors are blocked, growth in that branch is suppressed.
  - **Growth Cap:** Total vine cells per level are hard-capped at $\le 8\text{ cells}$ to prevent unbounded board obstruction.

---

### 2. Pruning Mechanics & Terrain Clearing
- **Pruning Trigger:** When any exiting snake's path crosses a Pruning Shears Tile (M352):
  - A pruning pulse clears all Wild Vine (M351) segments located within Manhattan distance $r \le 1$ of the pruner tile.
  - Cleared cells revert to standard passable Plain Floor immediately.
- **Hammer Interaction (Standard §16.18):** Magic Stone Hammer can target and smash individual Wild Vine cells directly, providing emergency clearing.

---

### 3. Turn Pipeline & Tick Order Integration (Standard §16.17)
Growth and pruning updates execute deterministically during Step 3 of the move resolution lifecycle:
```
1. Action resolve:
   - Snake slithers forward along exit lane.
   - If snake crosses Pruning Shears Tile (M352): execute immediate localized vine cut.
   - If Seed-Carrier Snake (M353) exits: drop seed pod at its designated origin cell.
2. moveCount += 1.
3. Growth Step:
   a. Decrement sprout counters on all active Seed Pods.
   b. Seed Pods reaching 0 sprout into Wild Vine blockers.
   c. If moveCount % spreadInterval == 0:
      - Evaluate growth candidate tips.
      - Spawn up to 2 new vine segments along U->R->D->L order (up to maxCap).
4. Derived states & Bloom Gate (M354) validation (unlocks if all linked vines = 0).
5. Star and Win condition check.
```

## Affected Files
- `packages/puzzle_core/lib/src/growth/vine_spreader.dart` — to be created
- `packages/puzzle_core/lib/src/growth/pruning_manager.dart` — to be created
- `packages/puzzle_core/lib/src/models/board_state.dart` — changed
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` — changed

## Risks and Open Questions
- **Softlock via Rapid Overgrowth:** If vines grow into a corridor containing the last remaining snake, the board could become unsolvable.
  - *Solver Invariant:* CI generator simulates all growth branches; levels are rejected if vine growth can permanently box in an active snake before the pruner can be reached.


# Spec: Phase 8 Signature System — Bloom Season (Growth)

Source docs: phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-7-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 8 Signature System — Bloom Season (Growth) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 8 (Levels 3501–4000) |

---

## Goal

Introduce a living board where plant obstacles grow dynamically with each player move, forcing players to time routes and use pruning tools before expanding Morning Glory Vines block key exit lanes.

---

## Current State

Design documented in phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md and phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, not yet implemented.

Key facts:
- Signature system name: **Bloom Season** (Growth architecture).
- Vine expansion is move-based and turn-synchronous (not timer-based).
- Expansion fires after player's move completes, during the tick order defined in SHARED_CORE_STANDARD.md §16.17.
- Four base mechanics introduced: M351 Morning Glory Vine, M352 Garden Shears, M353 Seed-Dropping Line, M354 Pollination Gate.
- All prior phase mechanics (M001–M304) remain active.

---

## Proposed Change

### 1. Cross-Expansion Algorithm
- Every `N` moves completed (`moveCount % params.growEvery == 0`), all existing vine cells check their 4 orthogonal neighbours (order: Up → Right → Down → Left).
- If a neighbour cell is completely empty (no line, blocker, or wall), a new vine cell grows there.
- New cells added in a single turn do **not** expand again that same turn (step-wise synchronous expansion).
- Default `N = 3`; configurable per level via `params.growEvery`.
- Maximum vine cells per level: `p8_vine_max_spread_cells = 48` (Remote Config key).

### 2. Pruning Logic
- When any line's path passes over a Garden Shears tile (M352), the shears activate immediately.
- All vine cells (M351) orthogonally adjacent to the shears tile are permanently removed.
- Shears tile itself remains on the board after activation (does not disappear).

### 3. Tick Order (per SHARED_CORE_STANDARD.md §16.17)
1. Player commits move (line placed or adjusted).
2. Line exit checks and scoring fire.
3. Seed countdown decrements (M353).
4. Vine expansion BFS fires if `moveCount % growEvery == 0`.
5. Pollination gate checks (M354) fire.
6. Board state written; UI updated.

### 4. Signature System Interaction with Prior Systems
- Vine cells block ant ground paths and (when `tall: true`) bee flight lanes.
- Vine cells do not block canopy scout bee layer unless `tall: true`.
- Leaf Blower booster clears entire vine cluster in one use.
- Vine expansion never crushes an already-placed line (expansion blocked by line cells).

### Acceptance Criteria
- [ ] Vine expansion BFS runs in ≤ 0.4 ms on a 14×14 grid.
- [ ] Vine never expands into cells occupied by lines, walls, or other blockers.
- [ ] New vine cells placed this turn do not re-expand until the next qualifying turn.
- [ ] Pruning via M352 removes all orthogonally adjacent vines instantly.
- [ ] `p8_vine_max_spread_cells` Remote Config key is respected; vines stop expanding once cap reached.
- [ ] L3501 tutorial overlay fires: "Bloom Season — Living vines and flowers grow dynamically as you make moves!"

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/bloom_season.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/morning_glory_vine.dart` | To be created |
| `packages/puzzle_core/lib/tick_order.dart` | Changed (add vine expansion step) |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed (vine-aware expansion) |
| `assets/phase_8/` | To be created |

---

## API / Remote Config Changes

| Key | Default | Purpose |
|---|---|---|
| `maxPhase` | `7` → `8` | Unlock Phase 8 content |
| `p8_vine_max_spread_cells` | `48` | Per-level vine cell cap |
| `params.growEvery` | `3` | Per-level expansion interval (seed param) |

---

## Risks and Open Questions

1. **Vine cap vs. level solvability:** If vine spreads to 48 cells before all lines exit, the level may become unsolvable. CI solver must verify all 500 seeds account for max-cap edge cases.
2. **Tall vine and bee interaction:** Docs specify `tall: true` blocks bee lanes; exact per-instance flag assignment must be specified in each level seed.
3. **Shears after activation:** Whether shears tile persists or disappears after snipping is stated as "remains" in §03 but should be confirmed in SHARED_CORE_STANDARD.md §11.

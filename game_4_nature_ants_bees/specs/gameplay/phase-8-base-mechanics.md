# Spec: Phase 8 Base Mechanics — M351 to M354 (Bloom Season)

Source docs: phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md, phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §17.24, §17.28, §17.34, §17.38. Depends on: specs/gameplay/phase-8-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 8 Base Mechanics — M351 to M354 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 8 (Levels 3501–4000) |

---

## Goal

Define the four new base mechanics introduced in Phase 8 (Bloom Season): Morning Glory Vine, Garden Shears, Seed-Dropping Line, and Pollination Gate — each with their exact rule, parameters, edge cases, solver impact, and intro level.

---

## Current State

Design documented in phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md, not yet implemented.

---

## Proposed Change

### M351 — Morning Glory Vine (Vine Spread+)
| Field | Value |
|---|---|
| ID | `M351` |
| Themed Name | Morning Glory Vine |
| Generic | Vine Spread+ |
| Category | B / T — Expanding Blocker |
| Intro Level | **L3511** (Block 2 x1) |

**Rule:**
- A live vine with purple morning glory blossoms. Every `N` moves (default `N = 3`, set via `params.growEvery`), it expands 1 cell into every free orthogonal direction (Up, Right, Down, Left).
- Expansion blocked by: lines, walls, other blockers, or board edge.
- Ants cannot pass through vine cells (ground layer full blocker).
- When `tall: true`, vine also blocks bee flight lanes (air and canopy).
- When `tall: false` (default), bees can fly over vine cells.
- Hammerable: Yes — Leaf Blower booster clears the entire connected vine cluster.
- Non-Monotone: Yes (board state changes after placement).

**Edge Cases:**
- Vine never pushes or crushes an already-placed line.
- Vine expanding into the sole exit cell of an ant locks that ant; CI solver must confirm this never happens in any of the 500 level seeds.
- Two vine clusters that meet do not merge into a single cluster; each tracks independently.

**Solver Impact:** Solver must model vine expansion up to `params.growEvery` steps ahead; BFS tree branches on all possible vine states at each grow tick.

---

### M352 — Garden Shears (Pruner Tile)
| Field | Value |
|---|---|
| ID | `M352` |
| Themed Name | Garden Shears |
| Generic | Pruner Tile |
| Category | T — Reactive Clearing Tile |
| Intro Level | **L3631** (Block 14 x1) |

**Rule:**
- A small shears tile placed on the board. When any ant or bee line passes through this cell, the shears activate (snip) instantly.
- All vine cells (M351) orthogonally adjacent to the shears tile are permanently removed from the board.
- Trigger: any line on any layer (ground, air, canopy) that crosses this cell.
- `tall: true` — both ground and air layer lines activate it.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Shears tile itself remains on board after snipping (only vines are removed).
- If no vine cells are adjacent at snip time, shears activates with no visible effect (no error).
- A Frozen vine (M351 × `Frozen`) adjacent to shears: confirm whether Frozen status prevents removal — flag as Open Question.

**Solver Impact:** Solver must check shears-triggered vine removal as part of the move consequence chain before re-evaluating reachability.

---

### M353 — Seed-Dropping Line (Seed Path)
| Field | Value |
|---|---|
| ID | `M353` |
| Themed Name | Seed-Dropping Line |
| Generic | Seed Path |
| Category | P / T — Delayed Hazard Line |
| Intro Level | **L3751** (Block 26 x1) |

**Rule:**
- A special line that, when it exits the board successfully, drops a seed token on its start head cell.
- A countdown of `N` moves begins on the seed token (default `N` defined per level in seed params).
- If no same-layer line passes over the seed token within `N` moves, the seed sprouts permanently into a pebble blocker.
- If a same-layer line passes over the seed before it sprouts, the seed is safely consumed (no blocker formed).
- Ground (ant) lines drop ground seeds; air/canopy (bee) lines drop canopy seed pods.
- Hammerable: No (seed token is not hammerable).
- Non-Monotone: Yes.

**Edge Cases:**
- If the start head cell is already occupied when the line exits (e.g., another line placed there), seed is dropped on the nearest free orthogonal cell — or blocked entirely. Exact rule: flag as Open Question.
- Multiple Seed-Dropping Lines can create multiple active seeds simultaneously.
- Seed countdown pauses while the level's move counter is paused (no timers; purely move-based).

**Solver Impact:** Solver must track all active seed tokens and their countdown values as part of board state; solving path must account for trampling seeds before they sprout.

---

### M354 — Pollination Gate (Bloom Gate)
| Field | Value |
|---|---|
| ID | `M354` |
| Themed Name | Pollination Gate |
| Generic | Bloom Gate |
| Category | G — Cumulative Exit Gate |
| Intro Level | **L3871** (Block 38 x1) |

**Rule:**
- A floral gate (closed bud form) placed on the board. Opening requires `K` lines (default `K = 2` or `3` per level) to exit successfully from cells orthogonally adjacent to the gate.
- Each qualifying adjacent exit increments the pollen counter; when count reaches `K`, the gate permanently blooms open.
- Both ground ant lines and flying bee lines count toward the pollen counter.
- `tall: true` or `false` per instance (both layers count regardless).
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Same line cannot contribute to the pollen counter more than once (only first exit counts).
- If `K = 3` and only 2 adjacent exit cells exist in the level layout, level is unsolvable — CI solver must catch this.
- Gate opening does not clear any adjacent vines; it only removes the gate blocker itself.

**Solver Impact:** Solver must track per-gate pollen count as board state; solving path must route `K` lines adjacent to each gate in the correct order.

---

## Acceptance Criteria (All Four Mechanics)
- [ ] M351 intro fires at L3511; tutorial card shown once.
- [ ] M352 intro fires at L3631; shears tutorial card shown once.
- [ ] M353 intro fires at L3751; seed-dropping tutorial card shown once.
- [ ] M354 intro fires at L3871; pollination gate tutorial card shown once.
- [ ] All 500 seeds (L3501–4000) pass CI solver with 0 hearts lost, 0 boosters required.
- [ ] Each mechanic renders correctly at Low / Mid / High particle tiers.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/morning_glory_vine.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/garden_shears.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/seed_dropping_line.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/pollination_gate.dart` | To be created |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed |
| `assets/phase_8/mechanics/` | To be created |

---

## Risks and Open Questions

1. **Frozen vine + shears interaction:** Does `Frozen` status on an M351 vine prevent it from being pruned by M352? Not specified in source docs.
2. **Seed drop on occupied head cell:** Exact fallback behaviour when the start head cell is occupied at exit time is not defined. Needs clarification before M353 implementation.
3. **Pollination gate K value per level:** Default K (2 or 3) is level-specific; each level seed must declare K. Confirm K is always achievable given the level layout.
4. **Vine cap interaction with solver:** With `p8_vine_max_spread_cells = 48`, solver must handle levels where max cap is reached mid-game.

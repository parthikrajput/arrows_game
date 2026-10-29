# Spec: Phase 13 Base Mechanics — M601 to M604 (Mystery Meadow)

Source docs: phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md, phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §17.24, §17.28, §17.34, §17.38. Depends on: specs/gameplay/phase-13-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 13 Base Mechanics — M601 to M604 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 13 (Levels 6001–6500) |

---

## Goal

Define the four new base mechanics for Phase 13 (Mystery Meadow): Scout Ant, Mirage Mist, Painted Pebble, and Sunlit Plate — detailing their operational rules, parameters, edge conditions, solver implications, and intro levels.

---

## Current State

Design documented in `phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md`, not yet implemented.

---

## Proposed Change

### M601 — Scout Ant (Scout Path)
| Field | Value |
|---|---|
| ID | `M601` |
| Themed Name | Scout Ant |
| Generic | Scout Path |
| Category | P / T — Reconnaissance Insect Line |
| Intro Level | **L6011** (Block 2 x1) |

**Rule:**
- An alert scout insect fitted with a golden antenna visor.
- Always starts visible and interactive outside the fog shroud.
- When it exits the board successfully, all fogged tiles within Chebyshev distance $\le 2$ of its traversed path are permanently cleared.
- Both ants and bees can act as Scout insects.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If a Scout Ant collides before reaching exit, no fog is cleared along its aborted path.
- Multiple Scout Ants can uncover different sectors of the board.

**Solver Impact:** Solver treats Scout Ant exits as prerequisite state unlocks in the topological dependency graph.

---

### M602 — Mirage Mist (Mimic Fog)
| Field | Value |
|---|---|
| ID | `M602` |
| Themed Name | Mirage Mist |
| Generic | Mimic Fog |
| Category | D / T — Reactive Concealment Tile |
| Intro Level | **L6131** (Block 14 x1) |

**Rule:**
- A deceitful patch of lawn resembling standard walkable grass.
- When any insect line passes orthogonally adjacent to this tile, it erupts into a dense 3×3 fog bank.
- Any insect lines within that 3×3 perimeter become shrouded and untappable until re-scouted.
- Affects both ground and air layers (`tall: true`).
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- The triggering line that provoked the mist continues its exit move unimpeded; shroud only affects other resting lines caught in the 3×3 radius.

**Solver Impact:** Solver must account for secondary fog generation to avoid accidental re-cloaking of critical lines.

---

### M603 — Painted Pebble (False Wall)
| Field | Value |
|---|---|
| ID | `M603` |
| Themed Name | Painted Pebble |
| Generic | False Wall |
| Category | B / T — Illusionary Obstacle |
| Intro Level | **L6251** (Block 26 x1) |

**Rule:**
- An illusionary painted pebble mimicking a solid stone blocker.
- Insect lines moving toward it pass cleanly through without collision or heart loss.
- Scent Trail Preview displays a yellow "?" glyph indicating the tile is passable.
- Upon passage, the illusion crumbles, permanently turning the cell into clear lawn.
- Hammerable: Yes (Leaf Blower booster scatters it).
- Non-Monotone: Yes.

**Edge Cases:**
- A Painted Pebble situated at an exit gate dissolves upon line contact, permitting exit in the same continuous move.

**Solver Impact:** Solver treats false walls as open nodes in graph traversal while tracking their visual state for player telemetry.

---

### M604 — Sunlit Plate (Reveal Plate)
| Field | Value |
|---|---|
| ID | `M604` |
| Themed Name | Sunlit Plate |
| Generic | Reveal Plate |
| Category | T / D — Persistent Cross-Axis Reveal Tile |
| Intro Level | **L6371** (Block 38 x1) |

**Rule:**
- An engraved sun-wheel brass pressure plate embedded in the soil.
- As long as an ant line body segment rests on this plate, its entire orthogonal crosshair (all cells in its row and column) is illuminated and interactive.
- When the insect vacates the plate, non-permanent fog returns to shroud those cells.
- Ground layer activation (`Ants only`); illuminated benefits apply to all insect layers.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Multiple plates can illuminate overlapping crosshair corridors.

**Solver Impact:** Solver evaluates stationary ant placement as intermediate tactical holds to unlock moves for other lines.

---

## Acceptance Criteria
- [ ] M601 intro fires at L6011; scout path tutorial displayed once.
- [ ] M602 intro fires at L6131; mirage mist tutorial displayed once.
- [ ] M603 intro fires at L6251; painted pebble tutorial displayed once.
- [ ] M604 intro fires at L6371; sunlit plate tutorial displayed once.
- [ ] All 500 seeds (L6001–6500) verified solvable by CI solver with 0 hearts lost.
- [ ] Scent Trail Preview flags Painted Pebbles with "?" marker.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/scout_ant.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/mirage_mist.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/painted_pebble.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/sunlit_plate.dart` | To be created |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed |

---

## Risks and Open Questions

1. **Re-fogging deadlocks via M602:** If Mirage Mist re-shrouds the only remaining scout ant, the board enters an unsolvable deadlock. CI validator must assert that no level layout allows permanent re-shrouding of all scout lines.

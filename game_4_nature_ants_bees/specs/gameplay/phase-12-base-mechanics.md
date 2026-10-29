# Spec: Phase 12 Base Mechanics — M551 to M554 (Falling Leaves)

Source docs: phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md, phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §17.24, §17.28, §17.34, §17.38. Depends on: specs/gameplay/phase-12-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 12 Base Mechanics — M551 to M554 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 12 (Levels 5501–6000) |

---

## Goal

Define the four new base mechanics for Phase 12 (Falling Leaves): Wind-Vane Lever, Falling Acorns, Dandelion Puff Tile, and Heavy Beetle Line — specifying their behavior, parameters, edge conditions, solver implications, and intro levels.

---

## Current State

Design documented in `phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md`, not yet implemented.

---

## Proposed Change

### M551 — Wind-Vane Lever (Gravity Lever)
| Field | Value |
|---|---|
| ID | `M551` |
| Themed Name | Wind-Vane Lever |
| Generic | Gravity Lever |
| Category | C / T — Directional Gravity Controller |
| Intro Level | **L5511** (Block 2 x1) |

**Rule:**
- A wooden cockerel weather-vane lever tile situated on the board.
- Tapping the lever costs 1 Move and cycles the global gravity vector $\vec{g}$ to the next orthogonal direction in sequence: Down → Left → Up → Right.
- Affects the entire board; immediately triggers a settlement cycle for all gravity-sensitive objects.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If player taps lever repeatedly without moving insects, gravity continues cycling and shifting loose objects.
- Lever itself is fixed in place and immune to gravity.

**Solver Impact:** Solver branches on lever interactions, treating directional gravity shifts as explicit move options.

---

### M552 — Falling Acorns (Falling Blockers)
| Field | Value |
|---|---|
| ID | `M552` |
| Themed Name | Falling Acorns |
| Generic | Falling Blockers |
| Category | B / T — Gravity-Sensitive Blocker |
| Intro Level | **L5631** (Block 14 x1) |

**Rule:**
- Spherical acorns detached from oak trees.
- Following each player move, if the adjacent tile in direction $\vec{g}$ is empty, the acorn falls 1 cell forward.
- Halts upon encountering walls, static blockers, or insects (does not crush).
- Ground layer blocker; if `tall: true`, also obstructs flying bees.
- Hammerable: Yes (Leaf Blower booster dislodges and clears it).
- Non-Monotone: Yes.

**Edge Cases:**
- Stacked acorns: Two acorns in a column fall sequentially if the leading acorn has clear space ahead.
- An acorn pushed against an exit tile remains an obstacle unless dislodged by gravity rotation or booster.

**Solver Impact:** Solver must simulate deterministic acorn settlement as a consequence of every candidate move.

---

### M553 — Dandelion Puff Tile (Anti-grav Tile)
| Field | Value |
|---|---|
| ID | `M553` |
| Themed Name | Dandelion Puff Tile |
| Generic | Anti-grav Tile |
| Category | D — Anti-Gravity Floating Sanctuary |
| Intro Level | **L5751** (Block 26 x1) |

**Rule:**
- A patch of downy white dandelion seeds.
- Any object or insect resting on this tile is shielded from gravity; it remains stationary regardless of $\vec{g}$ shifts.
- Provides a haven to park heavy beetles or trap falling acorns.
- Ground level only (`tall: false`).
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- An acorn that falls onto a Dandelion Puff Tile immediately halts and will not fall further until pushed or moved off the tile.

**Solver Impact:** Safe resting zones simplify path planning by neutralizing dynamic settlement hazards.

---

### M554 — Heavy Beetle Line (Weight Path)
| Field | Value |
|---|---|
| ID | `M554` |
| Themed Name | Heavy Beetle Line |
| Generic | Weight Path |
| Category | P / T — Gravity-Drifting Insect Line |
| Intro Level | **L5871** (Block 38 x1) |

**Rule:**
- A robust, heavily armoured beetle line traversing the ground layer.
- If the adjacent space ahead of its segments in direction $\vec{g}$ is unoccupied, the entire beetle line drifts 1 cell along $\vec{g}$ following each move.
- Players must leverage gravity shifts to guide the beetle line toward exit portals without colliding into hazards.
- Ground ants only; flying bees are unaffected by gravity.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If part of the beetle line rests on a Dandelion Puff Tile while other segments do not: the entire line is anchored, or only free segments slide? Rule specifies: line moves as a rigid body; if any segment is anchored, the line halts.

**Solver Impact:** Solver evaluates passive beetle translation alongside active line drags.

---

## Acceptance Criteria
- [ ] M551 intro fires at L5511; gravity lever tutorial displayed once.
- [ ] M552 intro fires at L5631; falling acorn tutorial displayed once.
- [ ] M553 intro fires at L5751; dandelion tile tutorial displayed once.
- [ ] M554 intro fires at L5871; heavy beetle line tutorial displayed once.
- [ ] All 500 seeds (L5501–6000) verified solvable by CI solver with 0 hearts lost.
- [ ] Leaf Blower clears M552 acorns cleanly.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/wind_vane_lever.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/falling_acorns.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/dandelion_puff_tile.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/heavy_beetle_line.dart` | To be created |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed |

---

## Risks and Open Questions

1. **Rigid Body vs Flexible Drift:** Confirm that M554 Heavy Beetle Line shifts as a cohesive unit and cannot break or stretch segments when encountering obstacles.
2. **Settlement Animation Timing:** When multiple acorns fall across different lanes, all slide animations must play simultaneously within `p12_gravity_slide_anim_ms = 150` ms to avoid turn lag.

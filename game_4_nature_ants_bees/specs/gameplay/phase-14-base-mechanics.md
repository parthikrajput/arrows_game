# Spec: Phase 14 Base Mechanics — M651 to M654 (Reflecting Pond)

Source docs: phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md, phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §17.24, §17.28, §17.34, §17.38. Depends on: specs/gameplay/phase-14-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 14 Base Mechanics — M651 to M654 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 14 (Levels 6501–7000) |

---

## Goal

Define the four new base mechanics for Phase 14 (Reflecting Pond): Pond Axis, Reflection Lock, Twin Pond, and Upside-Down Line — detailing their rules, parameters, edge conditions, solver considerations, and intro levels.

---

## Current State

Design documented in `phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md`, not yet implemented.

---

## Proposed Change

### M651 — Pond Axis (Mirror Axis)
| Field | Value |
|---|---|
| ID | `M651` |
| Themed Name | Pond Axis |
| Generic | Mirror Axis |
| Category | T / P — Bilateral Mirror Symmetry Axis |
| Intro Level | **L6511** (Block 2 x1) |

**Rule:**
- A shimmering blue water axis running down the center of the board (vertical or horizontal).
- Divides the board into two shores; every insect line on Shore A has a mirrored twin on Shore B.
- Tapping a line initiates movement for both twins simultaneously along mirrored trajectories.
- Both must navigate safely to exits. A collision by either yields a single bonk (−1 Heart).
- Ant lines mirror with ant lines; bee lines mirror with bee lines (same layer).
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- An insect crossing the axis itself: traversal across the water axis is permissible if exit gates are located on the opposite shore.

**Solver Impact:** Solver treats twin lines as a unified state entity; valid actions require clearance across dual mirrored paths.

---

### M652 — Reflection Lock (Reflect Lock)
| Field | Value |
|---|---|
| ID | `M652` |
| Themed Name | Reflection Lock |
| Generic | Reflect Lock |
| Category | K / T — Mirrored Counterpart Lock |
| Intro Level | **L6631** (Block 14 x1) |

**Rule:**
- A water-lily thorn lock located on one side of the Pond Axis.
- Cannot be unlocked by local keys; opens only when the designated key insect across the axis completes its exit.
- Ground ants blocked by default; if `tall: true`, bee flight is also obstructed.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If the mirrored key insect is blocked or destroyed, the Reflection Lock remains permanently impassable.

**Solver Impact:** Introduces strict cross-axis topological dependencies in the solving graph.

---

### M653 — Twin Pond (Twin Board)
| Field | Value |
|---|---|
| ID | `M653` |
| Themed Name | Twin Pond |
| Generic | Twin Board |
| Category | T / C — Synchronized Dual Pond Controller |
| Intro Level | **L6751** (Block 26 x1) |

**Rule:**
- A dual-pond board layout where player input to one pond automatically dispatches an identical tap to the corresponding coordinates in the second pond.
- Requires players to find moves that are simultaneously valid in both distinct pond layouts.
- Both ponds share the 3-heart failure pool.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If a tapped coordinate has an insect in Pond 1 but clear water in Pond 2, the move only executes in Pond 1.

**Solver Impact:** Solver evaluates parallel constraint satisfaction across two distinct tile matrices.

---

### M654 — Upside-Down Line (Inverse Path)
| Field | Value |
|---|---|
| ID | `M654` |
| Themed Name | Upside-Down Line |
| Generic | Inverse Path |
| Category | P — Inverted Direction Vector Line |
| Intro Level | **L6871** (Block 38 x1) |

**Rule:**
- An insect line displaying an inverted kinetic vector due to optical water distortion.
- Visually faces direction $\vec{d}$ (e.g. Up), but when tapped, dashes in direction $-\vec{d}$ (e.g. Down).
- Decorated with animated aquatic ripples on its body segments to signal inversion.
- Applies to both ants and bees.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Inverted line interacting with M651 Pond Axis: its mirrored twin also moves with inverted kinetic logic.

**Solver Impact:** Direction vector inversion is applied at the input interpreter layer; pathfinding logic accounts for negated step vectors.

---

## Acceptance Criteria
- [ ] M651 intro fires at L6511; pond axis tutorial displayed once.
- [ ] M652 intro fires at L6631; reflection lock tutorial displayed once.
- [ ] M653 intro fires at L6751; twin pond tutorial displayed once.
- [ ] M654 intro fires at L6871; upside-down line tutorial displayed once.
- [ ] All 500 seeds (L6501–7000) verified solvable by CI solver with 0 hearts lost.
- [ ] Collision by either twin line results in exactly single bonk penalty (−1 Heart).

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/pond_axis.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/reflection_lock.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/twin_pond.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/upside_down_line.dart` | To be created |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed |

---

## Risks and Open Questions

1. **Upside-Down Line Visual Clarity:** An insect moving opposite to its head sprite can confuse players without strong visual feedback. Animated water ripples on carapace and an explicit reverse orientation chevron must be clearly rendered.

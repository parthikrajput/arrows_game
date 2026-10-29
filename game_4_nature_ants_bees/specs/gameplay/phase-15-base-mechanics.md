# Spec: Phase 15 Base Mechanics — M701 to M704 (Brook & Rails)

Source docs: phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md, phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §17.24, §17.28, §17.34, §17.38. Depends on: specs/gameplay/phase-15-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 15 Base Mechanics — M701 to M704 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 15 (Levels 7001–7500) |

---

## Goal

Define the four new base mechanics for Phase 15 (Brook & Rails): Brook Fork, Tide Brook, Sluice Lever, and Lazy River — specifying their behavior, parameters, edge conditions, solver considerations, and intro levels.

---

## Current State

Design documented in `phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md`, not yet implemented.

---

## Proposed Change

### M701 — Brook Fork (Belt Junction)
| Field | Value |
|---|---|
| ID | `M701` |
| Themed Name | Brook Fork |
| Generic | Belt Junction |
| Category | T — Water Conveyor Branch Junction |
| Intro Level | **L7011** (Block 2 x1) |

**Rule:**
- A stream split tile where water current diverges into two separate branches (e.g. Left vs Right).
- A pivoting wooden guide paddle directs drifting ants down the active branch.
- State can be toggled by a Sluice Lever (M703).
- Ground layer only (`Ants only`); flying bees cross without diverting.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- An ant entering from a branch against the current: stream blocks backwards movement (treated as a 1-way current).

**Solver Impact:** Solver tracks junction paddle state as part of board configuration.

---

### M702 — Tide Brook (Reversible Belt)
| Field | Value |
|---|---|
| ID | `M702` |
| Themed Name | Tide Brook |
| Generic | Reversible Belt |
| Category | T — Move-Periodic Reversing Current |
| Intro Level | **L7131** (Block 14 x1) |

**Rule:**
- A tidal stream tile whose flow vector inverts $180^\circ$ every $N$ player moves (`moveCount % params.reverseEvery == 0`, default $N = 3$ or $4$).
- Drifting ants move forward during high tide turns and backward during ebb turns.
- Ground layer only (`Ants only`).
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Ant resting on Tide Brook when it reverses: ant is carried in the new direction on subsequent settlement turns.

**Solver Impact:** Solver models cyclical $180^\circ$ flow states, planning moves during favorable flow phases.

---

### M703 — Sluice Lever (Belt Lever)
| Field | Value |
|---|---|
| ID | `M703` |
| Themed Name | Sluice Lever |
| Generic | Belt Lever |
| Category | C / T — Flow Gate Controller |
| Intro Level | **L7251** (Block 26 x1) |

**Rule:**
- An interactive wooden canal valve lever.
- Tapping the lever costs 1 Move and toggles connected Brook Fork guide paddles (M701) or stops water current in a canal segment (still water).
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Tapping lever with no ants on brooks: still advances move counter and toggles valve states.

**Solver Impact:** Solver branches on lever toggles as discrete action options in the decision tree.

---

### M704 — Lazy River (Track Loop)
| Field | Value |
|---|---|
| ID | `M704` |
| Themed Name | Lazy River |
| Generic | Track Loop |
| Category | T — Closed Loop Water Carousel |
| Intro Level | **L7371** (Block 38 x1) |

**Rule:**
- A closed circular water circuit ($3\times 3$ or $4\times 4$ tiles).
- Any ant entering the loop is carried in continuous clockwise orbital circulation, advancing 1 cell per turn.
- The ant remains trapped in the loop until the player taps it while facing an open exit canal, launching it out of the circuit.
- Ground ants only; bees fly freely over the loop.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Multiple ants entering the loop: follow each other around the carousel at fixed spacing. If leading ant is blocked, trailing ants halt behind it.

**Solver Impact:** Carousel circulation functions as a dynamic delay buffer, allowing players to synchronize departure timings.

---

## Acceptance Criteria
- [ ] M701 intro fires at L7011; brook fork tutorial displayed once.
- [ ] M702 intro fires at L7131; tide brook tutorial displayed once.
- [ ] M703 intro fires at L7251; sluice lever tutorial displayed once.
- [ ] M704 intro fires at L7371; lazy river tutorial displayed once.
- [ ] All 500 seeds (L7001–7500) verified solvable by CI solver with 0 hearts lost.
- [ ] Bees pass over all conveyor mechanics without drift.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/brook_fork.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/tide_brook.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/sluice_lever.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/lazy_river.dart` | To be created |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed |

---

## Risks and Open Questions

1. **Loop Ejection Precision:** Exiting an ant from M704 requires tapping when the ant reaches an exit tile. The solver must guarantee that the ant reaches the exit cell at an exact turn when its target lane is unobstructed.

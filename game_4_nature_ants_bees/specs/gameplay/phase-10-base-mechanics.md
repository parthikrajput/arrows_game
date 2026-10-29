# Spec: Phase 10 Base Mechanics — M451 to M454 (Garden Rhythm)

Source docs: phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md, phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §17.24, §17.28, §17.34, §17.38. Depends on: specs/gameplay/phase-10-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 10 Base Mechanics — M451 to M454 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 10 (Levels 4501–5000) |

---

## Goal

Define the four new base mechanics for Phase 10 (Garden Rhythm): Cricket Gate, Bead-String Lock, Queue Hedge, and Echo Bloom — detailing operational rules, parameters, edge conditions, solver considerations, and intro levels.

---

## Current State

Design documented in `phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md`, not yet implemented.

---

## Proposed Change

### M451 — Cricket Gate (Rhythm Gate)
| Field | Value |
|---|---|
| ID | `M451` |
| Themed Name | Cricket Gate |
| Generic | Rhythm Gate |
| Category | G / T — Modulo-Timed Gate |
| Intro Level | **L4511** (Block 2 x1) |

**Rule:**
- A musical floral gate featuring a cricket flute emblem.
- Opens when $\text{moveCount} \bmod P \in S$ (default $P = 3, S = \{0\}$). In other states, it is closed and blocks movement.
- Move counter increments only on valid player moves (no wall-clock timer).
- When closed: blocks ground ants. If `tall: true`, also blocks flying bees.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If an insect is traversing across a Cricket Gate tile when it transitions to closed: traversal must complete atomically within that move before state updates.
- If $P = 1$, the gate is permanently open (degenerated case; generator must reject $P < 2$).

**Solver Impact:** Solver tracks $\text{moveCount} \bmod P$ as part of the state tuple; paths must time arrival at the gate on qualifying modulo steps.

---

### M452 — Bead-String Lock (Pattern Lock)
| Field | Value |
|---|---|
| ID | `M452` |
| Themed Name | Bead-String Lock |
| Generic | Pattern Lock |
| Category | K / S — Color Sequence Lock |
| Intro Level | **L4631** (Block 14 x1) |

**Rule:**
- A decorative floral lock adorned with a string of $k$ coloured beads (e.g. Red → Blue → Yellow).
- When $k$ consecutive lines exit the board matching the target colour sequence exactly, the lock opens permanently.
- Any line exiting with a non-matching colour resets the consecutive progress buffer to 0.
- Both ant and bee exits contribute to the sequence.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- Lines without an assigned colour (neutral lines) do not match any colour bead and trigger a sequence reset.
- A level seed must provide at least enough lines of each required colour to satisfy the pattern.

**Solver Impact:** Solver evaluates permutations of line exit orders, pruning branches that trigger unintended pattern resets.

---

### M453 — Queue Hedge (Order Edge)
| Field | Value |
|---|---|
| ID | `M453` |
| Themed Name | Queue Hedge |
| Generic | Order Edge |
| Category | B / S — Strict Numerical Order Edge |
| Intro Level | **L4751** (Block 26 x1) |

**Rule:**
- A perimeter hedge wall marked with sequence numbers 1, 2, 3...
- Enforces strict sequential departures: line 1 must exit before line 2, line 2 before line 3, etc.
- An out-of-order departure attempt results in collision bonk (−1 Heart) and immediate move cancellation.
- Ground ants blocked by default; if `tall: true`, bee departures are also constrained.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If line 1 is physically blocked from reaching the exit, all subsequent queued lines are trapped.
- Unnumbered lines on the board are exempt from queue ordering constraints.

**Solver Impact:** Solver constrains topological search space; queued lines must be solved in strictly increasing order.

---

### M454 — Echo Bloom (Echo Sequence)
| Field | Value |
|---|---|
| ID | `M454` |
| Themed Name | Echo Bloom |
| Generic | Echo Sequence |
| Category | S / G — Memory Playback Gate |
| Intro Level | **L4871** (Block 38 x1) |

**Rule:**
- A resonant purple blossom. In Phase 1 (Recording), the first $k$ lines exiting the board have their colours recorded onto the flower's petals.
- In Phase 2 (Playback), the next $k$ lines must exit in the exact same recorded colour sequence to open the central gate.
- Tapping or routing an out-of-sequence line during Phase 2 triggers a gentle warning shake ("Out of tune!") with zero heart loss, preventing an invalid move.
- Hammerable: No.
- Non-Monotone: Yes.

**Edge Cases:**
- If total lines of matching colours in Phase 2 do not match Phase 1 recording, level generation is invalid.
- Neutral lines cannot participate in echo recording.

**Solver Impact:** Solver treats Phase 1 exits as an assignment problem that defines constraints for Phase 2.

---

## Acceptance Criteria
- [ ] M451 Cricket Gate intro fires at L4511; tutorial card displayed once.
- [ ] M452 Bead-String Lock intro fires at L4631; pattern lock tutorial displayed once.
- [ ] M453 Queue Hedge intro fires at L4751; queue order tutorial displayed once.
- [ ] M454 Echo Bloom intro fires at L4871; echo sequence tutorial displayed once.
- [ ] All 500 seeds (L4501–5000) verified solvable by CI solver with 0 hearts lost.
- [ ] Modulo gate transitions synchronously only on valid player moves.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/cricket_gate.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/bead_string_lock.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/queue_hedge.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/echo_bloom.dart` | To be created |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed |

---

## Risks and Open Questions

1. **Echo Bloom Tap Guard vs Bonk:** M454 rule specifies zero heart loss on incorrect tap during Phase 2, differing from standard bonk (−1 Heart). Verify exception handling in `game_session.dart`.
2. **Bead sequence reset feedback:** When M452 resets due to an out-of-order colour, UI must clearly display which bead failed to avoid player confusion.

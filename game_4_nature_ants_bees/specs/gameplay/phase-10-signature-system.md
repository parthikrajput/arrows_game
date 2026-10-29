# Spec: Phase 10 Signature System — Garden Rhythm (Sequencing)

Source docs: phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-9-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 10 Signature System — Garden Rhythm (Sequencing) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 10 (Levels 4501–5000) |

---

## Goal

Introduce temporal rhythm and exit ordering constraints to puzzle mechanics: gate states cycle predictably based on move-count modulo arithmetic, and locks require strict FIFO colour matching and numeric queue sequences.

---

## Current State

Design documented in `phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md` and `phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md`, not yet implemented.

Key facts:
- Signature system name: **Garden Rhythm** (Sequencing architecture).
- Strictly turn-based; zero real-time / wall-clock timers. Rhythm advances solely via committed player moves.
- Four base mechanics introduced: M451 Cricket Gate, M452 Bead-String Lock, M453 Queue Hedge, M454 Echo Bloom.
- All prior phase mechanics (M001–M404) remain fully active.

---

## Proposed Change

### 1. Rhythm Cycle Evaluation (M451)
- Each Cricket Gate defines a cycle period $P$ (e.g. $P = 3$) and open state set $S$ (e.g. $S = \{0\}$).
- The gate is open if and only if:
  $$\text{moveCount} \bmod P \in S$$
- In all other states, the gate acts as an impassable obstacle.
- The gate UI displays a rhythmic countdown badge indicating moves until next opening.

### 2. Colour Sequence FIFO Tracking (M452)
- Bead-String Locks define a target pattern of length $k$ (e.g. `[Red, Blue, Yellow]`).
- Board exit events append exiting insect colours to an in-memory FIFO buffer.
- When the last $k$ exited line colours match the target string consecutively, the lock permanently unlocks.
- If an exiting insect has an incorrect colour, the consecutive match sequence resets to 0.

### 3. Queue Order Enforcement (M453)
- Queue Hedges carry explicit numeric exit badges (1, 2, 3...).
- The hedge requires line 1 to exit before line 2 can exit, and line 2 before line 3.
- Attempting to exit out of sequence triggers a collision bonk (−1 Heart) and halts the line.

### 4. Tick Order (per SHARED_CORE_STANDARD.md §16.17)
1. Player commits line move.
2. Queue hedge order verification fires (M453); aborts with bonk if out of order.
3. Line reaches exit: colour logged to FIFO sequence buffer.
4. Bead-string lock (M452) and Echo bloom (M454) pattern matchers evaluate.
5. Move count increments (`moveCount++`).
6. Cricket Gate (M451) rhythm states update according to `moveCount % P`.
7. UI/HUD indicators and gate sprites refresh.

### 5. Interaction with Previous Systems
- Modulo rhythm applies to lines exiting through split twigs (Phase 9 M402) and merged caravans (Phase 9 M401).
- Vine expansion (Phase 8 M351) continues on its own `params.growEvery` cycle, interleaved with the rhythm cycle.

### Acceptance Criteria
- [ ] Cricket Gate opens strictly when `moveCount % P in S`; remains closed otherwise.
- [ ] Rhythm moves advance solely on valid player moves, never on idle wall-clock time.
- [ ] Bead-String Lock unlocks upon matching $k$ consecutive exit colours; resets on mismatch.
- [ ] Queue Hedge bonks (−1 Heart) when out-of-order exit is attempted.
- [ ] L4501 tutorial overlay fires: "Garden Rhythm — Timing and exit order make the garden hum in harmony!"
- [ ] `p10_rhythm_pulse_intensity = 1.0` Remote Config key respected in shader glow.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/garden_rhythm.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/cricket_gate.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/bead_string_lock.dart` | To be created |
| `packages/puzzle_core/lib/tick_order.dart` | Changed (add rhythm evaluation) |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed (sequence/rhythm aware) |

---

## API / Remote Config Changes

| Key | Default | Purpose |
|---|---|---|
| `maxPhase` | `9` → `10` | Unlock Phase 10 content |
| `p10_rhythm_pulse_intensity` | `1.0` | Rhythm UI pulse shader scale |

---

## Risks and Open Questions

1. **Solver state-space explosion:** Modulo rhythm ($P \in [2, 4]$) multiplied by FIFO colour sequences creates higher state cardinality. Solver must memoize `(board_state, moveCount % P, fifo_buffer_hash)`.
2. **Multi-gate synchronization:** Levels with multiple Cricket Gates with differing periods ($P_1 = 3, P_2 = 4$) must be verified solvable within target move budgets.

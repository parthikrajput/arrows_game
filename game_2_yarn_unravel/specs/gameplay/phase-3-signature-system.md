Source docs: phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md, phase/phase_3/01_PHASE_3_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 3 Signature System: Day & Night Loom (Cycles)

## Status
Draft

## Type
New Feature

## Goal
Implement the Day & Night Loom (Cycles) signature system for Yarn Unravel Phase 3 (Levels 1001–1500), governing the 5-move periodic board state oscillation between State A (Day Loom) and State B (Night Loom), resolution tick order hooks, and cycle-driven environmental state updates.

## Current State
Design documented in `phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md` and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 2 in `specs/gameplay/phase-2-scope-and-rules.md` established static and move-counter obstacles without global environmental board state shifts.
- Phase 3 introduces global periodic cycles where the entire loom switches state every 5 valid player Moves.

## Proposed Change
Extend `packages/puzzle_core` with the Cycles state machine:

### 1. Cycle Periodicity & State Machine
- **Cycle Period:** Exactly **5 valid Moves** per phase (`CYCLE_PERIOD = 5`).
- **State Calculation:**
  ```dart
  CycleState getCycleState(int moveCount) {
    return (moveCount ~/ 5) % 2 == 0 ? CycleState.stateA : CycleState.stateB;
  }
  ```
  - `State A (Day Loom)`: Active on moves 0–4, 10–14, 20–24, …
  - `State B (Night Loom)`: Active on moves 5–9, 15–19, 25–29, …
- **Move Counting Rule:** Only valid moves (successful thread unravelling, snag bumps, or interactive obstacle taps) advance `moveCount`. Locked taps, gesture pans/pinches, and Thread Peek long-presses do NOT advance the counter.

### 2. Move Resolution Order Integration (Tick Step 4)
Per standard §16.17, the cycle transition is evaluated at Step 4:
1. Action resolve on pre-move state (thread exit, snag, push, or lever toggle).
2. `moveCount += 1`.
3. Standard counter ticks (M007 -> M017 -> M031 -> M025 -> M027 -> M047 -> M041 -> Phase 2 counters).
4. **Cycle State Transition:** If `moveCount % 5 == 0`, toggle global Cycle state (`A <-> B`).
5. **Derived States Update:** Recompute cycle-dependent mechanics:
   - Loom Latch (M101): Open in active state, solid blocker in opposite state.
   - Day Bridge (M102): Stitch Bridge in State A, solid blocker in State B.
   - Night Pompom (M103): Active portal in State B, solid blocker in State A.
   - Twilight Eyelet (M104): Filters for `colorA` in State A; filters for `colorB` in State B.
6. Heart loss & Shields calculation.
7. Win check (all threads cleared) / Loss check (0 hearts).

### 3. State Preservation & Solver Impact
- Solver state representation includes `cycleState` or `moveCount % 10` (since cycle period is 5 moves with 2 alternating states, period LCM = 10).
- Solvers calculate future cycle transitions deterministically: `movesUntilToggle = 5 - (moveCount % 5)`.

## Affected Files
- `packages/puzzle_core/lib/src/models/cycle_state.dart` (to be created: enum and helper functions)
- `packages/puzzle_core/lib/src/logic/move_resolver.dart` (changed: integrate Step 4 cycle hook)
- `packages/puzzle_core/lib/src/solver/state_key.dart` (changed: append cycle phase 0..9)

## Risks
- Players being surprised by cycle transitions causing snags. Mitigated by HUD countdown stitch dots (5..1) and soft warning pulse at 1 move remaining.

## Open Questions
None. Cycle period (5 moves) and state machine match `SHARED_CORE_STANDARD.md` §11.

Source docs: phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md, phase_3/01_PHASE_3_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-2-scope-and-rules.md, specs/gameplay/core-concept-and-rules.md.

# Spec: Gameplay — Phase 3 Signature System (Day & Night Garden Cycles)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 3 signature system "Day & Night Garden" (Cycles): a global board state machine that alternates between State A (Day) and State B (Night) every 5 valid Moves, updating cyclic mechanics, the HUD Sun/Moon dial, and solver heuristics.

## Current State
Design documented in `phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md`, `phase_3/01_PHASE_3_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 1 and 2 had static ambient lighting and moves-based periodic gates with localized intervals (e.g. M057, M058, M090).
- There was no board-wide alternating cycle governing terrain traversability.

## Proposed Change
Extend `packages/puzzle_core` with a global `CycleState` manager integrated into the turn pipeline:

### 1. Cycle Period & State Machine Rules
- **Cycle Period:** Exactly **5 valid Moves** per phase state (standard §11). A full day/night cycle takes 10 moves.
- **States:**
  - `State A (Day)`: Moves 1–5, 11–15, 21–25, ... (Initial state at `moveCount = 0`).
  - `State B (Night)`: Moves 6–10, 16–20, 26–30, ...
- **Cycle Trigger:** State toggles `A ↔ B` immediately after a valid Move is applied when `moveCount % 5 == 0`.
- **Invalid Actions:** Bumps, locked taps, camera adjustments, zoom/pan gestures, and booster activations do NOT increment `moveCount` and therefore do NOT advance the cycle.

### 2. Turn Pipeline & Tick Order Integration (standard §16.17)
The cycle transitions in Step 4 of the move resolution lifecycle:
```
1. Action resolve: Snake slithers out or interactive obstacle toggled.
2. moveCount += 1.
3. Move counters tick: M007, M017 ... Phase 2 periodic counters tick.
4. Cycle Transition Step:
   if (moveCount % 5 == 0) {
     activeCycle = (activeCycle == Day) ? Night : Day;
     updateCyclicMechanics(activeCycle); // M101, M102, M103, M104
   }
5. Derived states evaluated (beams, plates, cages, locks).
6. Heart loss & shields resolved.
7. Win condition check.
```

### 3. Solver Heuristics & Determinism
- Stateful solver (IDA* / BFS) tracks cycle phase in state key: `(remainingSnakes, mechanicStates, moveCount % 10)`.
- Reverse construction validator verifies that every snake's exit lane opens during a reachable cycle window without forcing booster use.

## Affected Files
- `packages/puzzle_core/lib/src/engine/cycle_manager.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` (changed to include cycle transition step)
- `packages/puzzle_core/lib/src/models/board_state.dart` (changed to include `currentCycle` and `movesUntilCycleSwap`)

## Design
- HUD element: Sun/Moon dial in top bar with 5 pip segments filling clockwise on each valid Move.
- Visual transition: 300 ms ambient color tween (Day warm amber `#FFF9C4` / Night mystic indigo `#1A237E`).

## Risks
- Cyclic deadlocks where all free snakes are blocked in one cycle state and player has no legal moves to advance the cycle counter. Mitigated by validator check: every board must have a solvable path sequence.

## Open Questions
- None. Cycle period (5 moves) and state rules are strictly defined by `SHARED_CORE_STANDARD.md` §11.

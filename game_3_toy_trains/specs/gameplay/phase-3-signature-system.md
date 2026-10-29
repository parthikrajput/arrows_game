Source docs: phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md, phase/phase_3/01_PHASE_3_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-2-scope-and-rules.md, specs/gameplay/core-concept-and-rules.md.

# Spec: Gameplay — Phase 3 Signature System (Day & Night Timetable Cycles)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 3 signature system "Day & Night Timetable" (Cycles `S03`): a global board state machine that alternates between State A (Day Service) and State B (Night Service) every 5 valid Moves, updating cyclic railway mechanics, the HUD Sun/Moon dial, and solver heuristics for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md`, `phase/phase_3/01_PHASE_3_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phases 1 and 2 operated under fixed daytime ambient tabletop lighting with localized move counters (e.g. M057, M058, M090).
- There was no board-wide cyclic state machine governing track traversability and timetable rules.

## Proposed Change
Extend `packages/puzzle_core` with a global `CycleManager` integrated into the deterministic turn resolution pipeline:

### 1. Cycle Period & State Machine Rules
- **Cycle Period:** Exactly **5 valid Moves** per phase state (standard §11). A full day/night cycle takes 10 valid moves.
- **Service States:**
  - `State A (Day Service)`: Moves 1–5, 11–15, 21–25, ... (Initial state at `moveCount = 0`).
  - `State B (Night Service)`: Moves 6–10, 16–20, 26–30, ...
- **Cycle Transition Trigger:** State flips `A ↔ B` immediately after a valid Move completes when `moveCount % 5 == 0`.
- **Non-Advancing Actions:** Buffer clack bumps, locked taps, Route Peek long-presses, camera pan/zoom gestures, and booster uses do NOT increment `moveCount` and do NOT advance the cycle.

### 2. Turn Pipeline & Tick Order Integration (standard §16.17)
The cycle transitions during Step 4 of the move resolution lifecycle:
```dart
// 1. Action resolve: train departure or interactive cell tap
// 2. moveCount += 1
// 3. Move counters tick (Phase 1 & Phase 2 periodic counters)
// 4. Cycle Transition Step:
if (moveCount % 5 == 0) {
  activeCycle = (activeCycle == DayService) ? NightService : DayService;
  updateCyclicMechanics(activeCycle); // M101, M102, M103, M104
}
// 5. Derived states evaluated (plates, light beams, sensor boxes, gates)
// 6. Heart loss & Cowcatcher Shield evaluation
// 7. Win condition evaluation
```

### 3. Solver Heuristics & Determinism
- Stateful solver (IDA* / BFS) tracks cycle phase in state key: `(remainingTrains, mechanicStates, moveCount % 10)`.
- Reverse construction validator ensures every train has a reachable departure window during its valid cycle state without forcing booster usage.

## Affected Files
- `packages/puzzle_core/lib/src/engine/cycle_manager.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` (changed: integrate cycle transition step)
- `packages/puzzle_core/lib/src/models/board_state.dart` (changed: add `currentCycle` and `movesUntilCycleSwap`)

## Design
- HUD Element: Sun/Moon dial in top bar with 5 pip segments filling clockwise on each valid Move.
- Visual Transition: 300 ms ambient color tween (Day warm honey tabletop `#F5E6CA` / Night cozy lantern amber `#2C1E14`).

## Risks
- Cyclic deadlocks where all free trains are blocked in one cycle state and player has no legal moves to advance the cycle counter. Mitigated by CI validator solvability check.

## Open Questions
- None. Cycle period, tick order, and state transitions match `phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md` and `SHARED_CORE_STANDARD.md` §11.


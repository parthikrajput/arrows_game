Source docs: phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md, phase/phase_3/01_PHASE_3_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-2-scope-and-rules.md, specs/gameplay/core-concept-and-rules.md.

# Spec: Gameplay — Phase 3 Signature System (Day & Night Garden Cycles)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 3 signature system "Day & Night Garden" (Cycles): a deterministic board-wide state machine that alternates between State A (Day) and State B (Night) every 5 valid Moves, driving cyclic mechanics, HUD Sun/Moon dial updates, layer traversability, and solver heuristics.

## Current State
Design documented in `phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md`, `phase/phase_3/01_PHASE_3_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 1 and 2 operate in static lighting with local periodic gates (e.g. M057, M058, M090).
- There is no board-wide alternating cycle governing multi-layer traversability.

## Proposed Change
Extend `packages/puzzle_core` with a global `CycleState` manager integrated into the turn pipeline:

### 1. Cycle Period & State Machine Rules
- **Cycle Period:** Exactly **5 valid Moves** per state (Standard §11). A full day/night cycle takes 10 moves.
- **States:**
  - `State A (Day)`: Moves 1–5, 11–15, 21–25, ... (Initial state at `moveCount = 0`). Golden sunlight, daytime flora.
  - `State B (Night)`: Moves 6–10, 16–20, 26–30, ... Mystic moonlight, nocturnal luminescence.
- **Formula:** `cycleState = (moveCount / 5) % 2` (0 = Day/A, 1 = Night/B).
- **Cycle Trigger:** State toggles `A ↔ B` immediately after a valid Move is applied when `moveCount % 5 == 0`.
- **Invalid Actions:** Bonks, locked taps, pinch-zoom/pan gestures, preview long-presses, and booster activations do NOT increment `moveCount` and therefore do NOT advance the cycle.

### 2. Multi-Layer Interaction (Ants, Bees, Canopy Scouts)
- **Ground Ants (Layer 0):** Directly affected by cyclic ground terrain (M101 Sunrise Gate, M102 Moonlit Bridge, M103 Dawn Burrow, M104 Day-Bloom Line).
- **Worker Bees (Layer 1):** Ignore ground-level cyclic state changes unless the obstacle has `tall: true` (e.g. Tall Sunrise Gate).
- **Canopy Scout Bees (Layer 2):** Fly above standard bridges and burrows; affected only by full-height cyclic barriers.

### 3. Turn Pipeline & Tick Order Integration (Standard §16.17)
The cycle transitions deterministically in Step 4 of the move resolution lifecycle:
```
1. Action resolve: Insect line dashes out or interactive obstacle toggles.
2. moveCount += 1.
3. Move counters tick: M007, M017 ... Phase 2 periodic counters tick.
4. Cycle Transition Step:
   if (moveCount % 5 == 0) {
     activeCycle = (activeCycle == Day) ? Night : Day;
     updateCyclicMechanics(activeCycle); // M101, M102, M103, M104
   }
5. Derived states evaluated (beams, switches, petal gates, locks).
6. Heart loss & shields resolved.
7. Win condition check.
```

### 4. Solver Heuristics & Determinism
- Stateful solver (IDA* / BFS) tracks cycle phase in state key: `(remainingLines, mechanicStates, moveCount % 10)`.
- Reverse construction validator verifies that every line's exit lane opens during a reachable cycle window with 0 hearts lost and 0 boosters used.

## Affected Files
- `packages/puzzle_core/lib/src/engine/cycle_manager.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` (changed to include cycle transition step)
- `packages/puzzle_core/lib/src/models/board_state.dart` (changed to include `currentCycle` and `movesUntilCycleSwap`)

## Design
- Top HUD element: Sun/Moon dial adjacent to Move counter with 5 pip segments filling clockwise on each valid Move.
- Visual transition: 300 ms ambient color sweep (Day golden green `#81C784` $\rightarrow$ Night twilight slate `#37474F`).

## Risks
- Cyclic deadlocks where all free lines are blocked in one cycle state and the player has no legal moves to advance the cycle counter. Mitigated by CI reverse-construction validator guaranteeing at least one valid path forward.

## Open Questions
- None. Cycle period (5 moves) and state rules are strictly defined by `SHARED_CORE_STANDARD.md` §11.

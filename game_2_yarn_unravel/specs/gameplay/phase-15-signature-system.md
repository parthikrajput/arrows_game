Source docs: phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md, phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 15 Signature System: Conveyors & Tracks (Feed Dog Factory)

## Status
Draft

## Type
New Feature

## Goal
Specify the Feed Dog conveyor kinetics, track loops, mechanical junction switching, directional reversing, and move resolution tick order integration for Yarn Unravel Phase 15 (Levels 7001–7500).

## Current State
Design documented in `phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md` and `phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md`, not yet implemented.
- Prior levels maintained static thread coordinates until explicit player unravel taps or gravity vector translations.
- Phase 15 introduces Conveyors & Tracks (Feed Dog Factory), where motorized sewing machine feed dog belts and closed track circuits translate resting thread segments by 1 cell per valid move.

## Proposed Change
Implement the Conveyors & Tracks system within `packages/puzzle_core`:

### 1. Conveyor Kinetics & Movement Rules
- **Feed Dog Conveyor Belts:**
  - Steel-toothed conveyor tracks embedded in the crafting board linen.
  - Directional vector: $\text{Up} (0, -1)$, $\text{Down} (0, 1)$, $\text{Left} (-1, 0)$, or $\text{Right} (1, 0)$.
  - Any thread body cell or needle head resting on a conveyor translates 1 cell along the belt vector after every valid player turn.
  - **Obstruction Handling:** If the target destination cell along the conveyor vector is blocked by another thread or obstacle, translation halts harmlessly (no snag, no heart loss penalty).
- **Belt Switch (M701):**
  - Tappable branch switch at track intersections; costs 1 move to toggle route directions (e.g. straight vs 90° right turn).
- **Reversing Belt (M702):**
  - Segmented belt with move counter; every $N$ (3–5) player moves, belt orientation automatically inverts 180°.
- **Belt Lever (M703):**
  - Board-edge clutch lever; costs 1 move to toggle linked belts between Active (running) and Halted (static).
- **Track Loop (M704):**
  - Closed circuit track (e.g. $4\times 4$ cells). Threads cycle 1 cell clockwise per turn; can only unravel when needle head aligns with the dedicated exit cell.

### 2. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Player unravels a thread OR taps a Belt Switch / Clutch Lever (1 move).
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):** M007, M017, M031, M253, M353 decrement.
- **Step 4 (Conveyor & Track Step Execution):**
  1. Active Belt Levers (M703) and Switches (M701) apply current route configurations.
  2. Reversing Belts (M702) evaluate move interval: if $m \pmod N == 0$, flip directional vector 180°.
  3. Conveyor belts translate resting threads 1 cell forward if target cells are unoccupied.
  4. Track Loops (M704) cycle occupying threads 1 step clockwise along circuit.
- **Step 5 (Collision & Blocker Update):** Resolve any pin/blocker shifts.
- **Step 6 (Heart Loss & Shield Resolution):** Evaluate snags from player unravel action.
- **Step 7 (Win / Loss Evaluation):** Check remaining threads and board clearance.

### 3. Solver Integration (IDA*)
- In the IDA* puzzle solver:
  - Board states include `(conveyor_positions, switch_states, reversing_counters, loop_indices)`.
  - Solvability verification guarantees that rotating belts never trap threads in unsolvable infinite cycles or deadlocks.

## Affected Files
- `packages/puzzle_core/lib/src/models/conveyor_state.dart` (to be created: conveyor and track loop models)
- `packages/puzzle_core/lib/src/logic/conveyor_controller.dart` (to be created: movement push and loop rotation logic)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: dynamic conveyor state expansion)
- `packages/puzzle_core/lib/src/generator/level_generator.dart` (changed: conveyor network placement)

## Risks and Open Questions
- None. System kinetics and tick order conform to `SHARED_CORE_STANDARD.md` §11 and §16.17.

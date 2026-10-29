Source docs: phase/phase_15/04_VARIANTS_AND_MODIFIERS_PHASE_15.md, phase/phase_15/02_LEVEL_PLAN_7001_7500.md, ../../SCALING_TO_10000_LEVELS.md §7, §8. Depends on: specs/gameplay/phase-15-base-mechanics.md.

# Spec: Gameplay — Phase 15 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slot combinations and 10 craft modifiers applied to Phase 15 base mechanics (M701–M704) across Levels 7001–7500.

## Current State
Documented in `phase/phase_15/04_VARIANTS_AND_MODIFIERS_PHASE_15.md`, not yet implemented in code.

## Proposed Change
Implement the 10 craft modifier rules and variant definitions in `packages/puzzle_core`:

### 1. Conveyor Craft Modifiers
The 10 craft modifiers configure M701–M704 behaviors as follows:

| # | Modifier | Yarn Flavour Name | Functional Rule on Conveyor Mechanics |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Belt switch is locked; requires $K$ threads to unravel before branch can be flipped. |
| 2 | `Colored(c)` | **Dyed** | Conveyor belt moves only threads matching specific color $c$; other threads remain static. |
| 3 | `Fluffed` | **Fluffed** | Track loop exit point is hidden under dense wool fluff until cleared. |
| 4 | `Chained` | **Ribbon-Tied** | Two separate conveyor belts are mechanically linked, operating in unison. |
| 5 | `Countdown(N)` | **Basting** | After $N$ player moves, conveyor belt deactivates permanently and becomes regular linen. |
| 6 | `Phasing` | **Sheer Silk** | Conveyor runs at full speed on odd moves and pauses completely on even moves. |
| 7 | `Armored` | **Brass-Plated** | Belt clutch lever is heavily fortified and immune to booster shears/hammer bypass. |
| 8 | `Layered` | **Tulle** | Conveyor translation applies only to threads situated on a specific fabric layer. |
| 9 | `Mirrored` | **Mirror-Stitched** | Left-side belt moves clockwise while right-side belt moves counter-clockwise symmetrically. |
| 10 | `Growing` | **Belt-Expanding** | Conveyor belt extends its track length by 1 cell every 10 player moves. |

### 2. 45 Variant Slot Distribution
- **Blocks 3–13 (Levels 7021–7130):** M701 Belt Switch variants (Knotted Switches, Dyed Conveyors, Phasing Junctions).
- **Blocks 15–25 (Levels 7141–7250):** M702 Reversing Belt variants (Fluffed Reversers, Chained Belts, Basting Reversers).
- **Blocks 27–37 (Levels 7261–7370):** M703 Belt Lever variants (Brass-Plated Levers, Mirrored Clutches, Layered Belts).
- **Blocks 39–49 (Levels 7381–7490):** M704 Track Loop variants and composite High-Speed Conveyor Networks (Switches + Reversers + Loops).

### 3. Solver Constraints
- Every variant configuration must be validated in CI by the IDA* solver.
- 0-hearts solvable invariant: Rotating belts must not produce infinite looping states or unavoidable deadlocks.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/conveyor_modifiers.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/modifier_applier.dart` (changed: apply Phase 15 modifiers to M701–M704)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: dynamic conveyor state transitions)

## Risks and Open Questions
- None. Behaviors strictly adhere to `SCALING_TO_10000_LEVELS.md` §7.

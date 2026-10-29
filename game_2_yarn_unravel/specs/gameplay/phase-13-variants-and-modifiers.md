Source docs: phase/phase_13/04_VARIANTS_AND_MODIFIERS_PHASE_13.md, phase/phase_13/02_LEVEL_PLAN_6001_6500.md, ../../SCALING_TO_10000_LEVELS.md §7, §8. Depends on: specs/gameplay/phase-13-base-mechanics.md.

# Spec: Gameplay — Phase 13 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slot combinations and 10 craft modifiers applied to Phase 13 base mechanics (M601–M604) across Levels 6001–6500.

## Current State
Documented in `phase/phase_13/04_VARIANTS_AND_MODIFIERS_PHASE_13.md`, not yet implemented in code.

## Proposed Change
Implement the 10 craft modifier rules and variant definitions in `packages/puzzle_core`:

### 1. Hidden Info Craft Modifiers
The 10 craft modifiers configure M601–M604 behaviors as follows:

| # | Modifier | Yarn Flavour Name | Functional Rule on Hidden Info Mechanics |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Scout Thread is locked under a knot; requires $K$ prior thread unravels before it can be tapped. |
| 2 | `Colored(c)` | **Dyed** | Lantern Plate only illuminates fog if a thread of matching color $c$ is resting on it. |
| 3 | `Fluffed` | **Fluffed** | Painted Wall is hidden under a layer of dense fluff; must be revealed before chalk lines are seen. |
| 4 | `Chained` | **Ribbon-Tied** | Two Scout Threads are tied together; unraveling both executes an expanded $2\times$ fog clearance blast. |
| 5 | `Countdown(N)` | **Basting** | Decoy Fluff dissolves automatically after $N$ player moves, regardless of thread passage. |
| 6 | `Phasing` | **Sheer Silk** | Painted Wall alternates between solid blocker (odd moves) and illusion passage (even moves). |
| 7 | `Armored` | **Brass-Plated** | Decoy Fluff resists booster scissors/hammer; can only be cleared by direct thread pull. |
| 8 | `Layered` | **Tulle** | Scout Thread only clears the top-layer tulle fluff; deeper underlying threads require a secondary scout. |
| 9 | `Mirrored` | **Mirror-Stitched** | Clearing fog on the left half of the board automatically mirrors clearance on the symmetric right sector. |
| 10 | `Growing` | **Mist-Expanding** | If a thread leaves a Lantern Plate, uncleared fog clusters expand by 1 cell every 5 moves. |

### 2. 45 Variant Slot Distribution
- **Blocks 3–13 (Levels 6021–6130):** M601 Scout Thread variants (Knotted Scouts, Chained Scouts, Tulle Scouts, Mirrored Scouts).
- **Blocks 15–25 (Levels 6141–6250):** M602 Decoy Fluff variants (Dyed Decoys, Basting Fluffs, Brass-Plated Decoys).
- **Blocks 27–37 (Levels 6261–6370):** M603 Painted Wall variants (Phasing Chalks, Mirrored False Walls, Fluffed Trompe-l'œils).
- **Blocks 39–49 (Levels 6381–6490):** M604 Lantern Plate variants and composite Mystery Basket deductions (Scouts + Lanterns + False Walls).

### 3. Solver Constraints
- Every variant configuration must be validated in CI by the IDA* solver.
- 0-hearts solvable invariant: No level may require players to gamble on whether a wall is real or painted; solvable deterministic paths must always exist.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/hidden_info_modifiers.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/modifier_applier.dart` (changed: apply Phase 13 modifiers to M601–M604)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: modifier state transitions)

## Risks and Open Questions
- None. All modifier behaviors strictly correspond to `SCALING_TO_10000_LEVELS.md` §7.


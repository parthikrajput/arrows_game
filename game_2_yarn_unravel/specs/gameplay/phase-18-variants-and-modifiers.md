Source docs: phase/phase_18/04_VARIANTS_AND_MODIFIERS_PHASE_18.md, phase/phase_18/02_LEVEL_PLAN_8501_9000.md, ../../SCALING_TO_10000_LEVELS.md §7, §8. Depends on: specs/gameplay/phase-18-base-mechanics.md.

# Spec: Gameplay — Phase 18 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slot combinations and 10 craft modifiers applied to Phase 18 combo mechanics (M851–M854) across Levels 8501–9000.

## Current State
Documented in `phase/phase_18/04_VARIANTS_AND_MODIFIERS_PHASE_18.md`, not yet implemented in code.

## Proposed Change
Implement the 10 craft modifier rules and variant definitions in `packages/puzzle_core`:

### 1. Remix A Craft Modifiers
The 10 craft modifiers configure M851–M854 behaviors as follows:

| # | Modifier | Yarn Flavour Name | Functional Rule on Remix A Mechanics |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Cycle crate is knotted; requires $K$ threads to unravel before it can switch or slide. |
| 2 | `Colored(c)` | **Dyed** | Floor beam penetrates downward only through tinted glass of matching color $c$. |
| 3 | `Fluffed` | **Fluffed** | Target clasp for the satin charm crate is concealed beneath dense wool fluff. |
| 4 | `Chained` | **Ribbon-Tied** | Two cycle crates are tied together, translating in parallel when pushed. |
| 5 | `Countdown(N)` | **Basting** | After $N$ moves, floor beam extinguishes permanently. |
| 6 | `Phasing` | **Sheer Silk** | Fogged stair alternates between solid (odd moves) and phantom (even moves). |
| 7 | `Armored` | **Brass-Plated** | Satin crate is reinforced and immune to booster shears/hammer. |
| 8 | `Layered` | **Tulle** | Combo mechanics operate strictly within a designated fabric layer. |
| 9 | `Mirrored` | **Mirror-Stitched** | Pushing a crate on the left side slides a mirrored crate oppositely on the right. |
| 10 | `Growing` | **Mass-Expanding** | Crate expands its footprint by 1 cell every 5 moves if stationary. |

### 2. 45 Variant Slot Distribution
- **Blocks 3–13 (Levels 8521–8630):** M851 Cycle Crate variants (Knotted Cycle Crates, Phasing Crates, Ribbon-Tied Push Blocks).
- **Blocks 15–25 (Levels 8641–8750):** M852 Floor Beam variants (Dyed Floor Beams, Chained Optics, Basting Beams).
- **Blocks 27–37 (Levels 8761–8870):** M853 Fogged Stair variants (Mirrored Stairs, Fluffed Stairs, Tulle Elevators).
- **Blocks 39–49 (Levels 8871–8990):** M854 Satin Charm Crate variants and Multi-System Synthesis (Crates + Optics + Stairs).

### 3. Solver Constraints
- Every variant configuration must be validated in CI by the IDA* solver.
- 0-hearts solvable invariant: Cross-system combinations must maintain search complexity $\le 1.5\text{M}$ nodes and zero deadlocks.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/remix_a_modifiers.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/modifier_applier.dart` (changed: apply Phase 18 modifiers to M851–M854)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: multi-system DAG heuristics)

## Risks and Open Questions
- None. Behaviors strictly adhere to `SCALING_TO_10000_LEVELS.md` §7.

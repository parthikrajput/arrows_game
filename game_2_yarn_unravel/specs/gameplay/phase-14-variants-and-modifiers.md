Source docs: phase/phase_14/04_VARIANTS_AND_MODIFIERS_PHASE_14.md, phase/phase_14/02_LEVEL_PLAN_6501_7000.md, ../../SCALING_TO_10000_LEVELS.md §7, §8. Depends on: specs/gameplay/phase-14-base-mechanics.md.

# Spec: Gameplay — Phase 14 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slot combinations and 10 craft modifiers applied to Phase 14 base mechanics (M651–M654) across Levels 6501–7000.

## Current State
Documented in `phase/phase_14/04_VARIANTS_AND_MODIFIERS_PHASE_14.md`, not yet implemented in code.

## Proposed Change
Implement the 10 craft modifier rules and variant definitions in `packages/puzzle_core`:

### 1. Mirror Worlds Craft Modifiers
The 10 craft modifiers configure M651–M654 behaviors as follows:

| # | Modifier | Yarn Flavour Name | Functional Rule on Mirror Worlds Mechanics |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Mirror seam is locked; requires $K$ threads to unravel before twin pulls are unlocked. |
| 2 | `Colored(c)` | **Dyed** | Reflect Clasp requires a key of matching color $c$ to trigger resonant unlock. |
| 3 | `Fluffed` | **Fluffed** | Inverse thread or reflect clasp is hidden beneath dense wool fluff. |
| 4 | `Chained` | **Ribbon-Tied** | Two pairs of twin threads are tied together; all 4 threads unravel simultaneously. |
| 5 | `Countdown(N)` | **Basting** | After $N$ player moves, the mirror seam dissolves and threads become independent. |
| 6 | `Phasing` | **Sheer Silk** | Inverse thread alternates between solid blocker (odd moves) and phantom thread (even moves). |
| 7 | `Armored` | **Brass-Plated** | Reflect Clasp is reinforced and immune to booster hammer. |
| 8 | `Layered` | **Tulle** | Reflection symmetry is restricted to a single fabric layer. |
| 9 | `Mirrored` | **Double-Reflected** | Creates 4-way quadrant symmetry (both horizontal and vertical axes active). |
| 10 | `Growing` | **Echo-Expanding** | Inverse thread grows by 1 knot after every player move until unraveled. |

### 2. 45 Variant Slot Distribution
- **Blocks 3–13 (Levels 6521–6630):** M651 Mirror Seam variants (Knotted Twins, Basting Seams, Tulle Mirrors, Mirrored Double-Axes).
- **Blocks 15–25 (Levels 6641–6750):** M652 Reflect Clasp variants (Dyed Reflectors, Brass-Plated Clasps, Fluffed Clasps).
- **Blocks 27–37 (Levels 6761–6870):** M653 Twin Quilt variants (Chained Toggles, Phasing Quilts, Double-Reflected Boards).
- **Blocks 39–49 (Levels 6881–6990):** M654 Inverse Thread variants and composite Looking-Glass Symmetry mixes.

### 3. Solver Constraints
- Every variant configuration must be validated in CI by the IDA* solver.
- 0-hearts solvable invariant: Mutual headlocks between twin threads or inverse paths must never occur in generated levels.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/mirror_modifiers.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/modifier_applier.dart` (changed: apply Phase 14 modifiers to M651–M654)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: modifier symmetry pruning)

## Risks and Open Questions
- None. Behaviors strictly align with `SCALING_TO_10000_LEVELS.md` §7.


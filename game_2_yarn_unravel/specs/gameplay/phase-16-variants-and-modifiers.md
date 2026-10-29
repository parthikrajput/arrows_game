Source docs: phase/phase_16/04_VARIANTS_AND_MODIFIERS_PHASE_16.md, phase/phase_16/02_LEVEL_PLAN_7501_8000.md, ../../SCALING_TO_10000_LEVELS.md §7, §8. Depends on: specs/gameplay/phase-16-base-mechanics.md.

# Spec: Gameplay — Phase 16 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slot combinations and 10 craft modifiers applied to Phase 16 base mechanics (M751–M754) across Levels 7501–8000.

## Current State
Documented in `phase/phase_16/04_VARIANTS_AND_MODIFIERS_PHASE_16.md`, not yet implemented in code.

## Proposed Change
Implement the 10 craft modifier rules and variant definitions in `packages/puzzle_core`:

### 1. Keys Deluxe Craft Modifiers
The 10 craft modifiers configure M751–M754 behaviors as follows:

| # | Modifier | Yarn Flavour Name | Functional Rule on Keys Deluxe Mechanics |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Skeleton charm is knotted; requires $K$ threads to unravel before the key can be mobilized. |
| 2 | `Colored(c)` | **Dyed** | Charm crafting requires threads of specific matching dye color $c$ to forge the key. |
| 3 | `Fluffed` | **Fluffed** | Half-charm or swap hoop is hidden under dense wool fluff until revealed. |
| 4 | `Chained` | **Ribbon-Tied** | Two charm chains are tied together, progressing in parallel. |
| 5 | `Countdown(N)` | **Basting** | After $N$ moves, skeleton key dissolves into a standard thread. |
| 6 | `Phasing` | **Sheer Silk** | Swap hoop alternates between active (odd moves) and dormant (even moves). |
| 7 | `Armored` | **Brass-Plated** | Skeleton charm is reinforced and immune to booster shears/hammer. |
| 8 | `Layered` | **Tulle** | Charm swapping is restricted to threads situated on a specific fabric layer. |
| 9 | `Mirrored` | **Mirror-Stitched** | Collecting a charm on the left half triggers a resonant clasp release on the right half. |
| 10 | `Growing` | **Chain-Expanding** | If uncollected for 8 moves, charm chain inserts an additional link into the sequence. |

### 2. 45 Variant Slot Distribution
- **Blocks 3–13 (Levels 7521–7630):** M751 Charm Chain variants (Knotted Chains, Phasing Chains, Chained Multi-Links).
- **Blocks 15–25 (Levels 7641–7750):** M752 Charm Crafting variants (Fluffed Halves, Dyed Synthesis, Basting Halves).
- **Blocks 27–37 (Levels 7761–7870):** M753 Skeleton Charm variants (Brass-Plated Skeletons, Tulle Master Keys).
- **Blocks 39–49 (Levels 7871–7990):** M754 Charm Swap Hoop variants and Master Locksmith Networks (Chains + Crafting + Swap Hoops).

### 3. Solver Constraints
- Every variant configuration must be validated in CI by the IDA* solver.
- 0-hearts solvable invariant: Every key chain and crafting requirement must maintain at least one valid, unblocked resolution sequence.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/keys_deluxe_modifiers.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/modifier_applier.dart` (changed: apply Phase 16 modifiers to M751–M754)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: key order dependency pruning)

## Risks and Open Questions
- None. Behaviors strictly adhere to `SCALING_TO_10000_LEVELS.md` §7.

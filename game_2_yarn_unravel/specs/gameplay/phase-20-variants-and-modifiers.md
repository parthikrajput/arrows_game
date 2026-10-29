Source docs: phase/phase_20/04_VARIANTS_AND_MODIFIERS_PHASE_20.md, phase/phase_20/02_LEVEL_PLAN_9501_10000.md, ../../SCALING_TO_10000_LEVELS.md §7, §8. Depends on: specs/gameplay/phase-20-base-mechanics.md.

# Spec: Gameplay — Phase 20 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slot combinations and 10 craft modifiers applied to Phase 20 master mechanics (M951–M954) across Levels 9501–10,000.

## Current State
Documented in `phase/phase_20/04_VARIANTS_AND_MODIFIERS_PHASE_20.md`, not yet implemented in code.

## Proposed Change
Implement the 10 craft modifier rules and variant definitions in `packages/puzzle_core`:

### 1. Grand Master Craft Modifiers
The 10 craft modifiers configure M951–M954 behaviors as follows:

| # | Modifier | Yarn Flavour Name | Functional Rule on Grand Master Mechanics |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Moving guardian is locked; requires $K$ threads to unravel before patrol movement begins. |
| 2 | `Colored(c)` | **Dyed** | Omni gate permits passage only to threads matching color $c$. |
| 3 | `Fluffed` | **Fluffed** | Grand loom spool is hidden under dense wool fluff until cleared. |
| 4 | `Chained` | **Ribbon-Tied** | Two moving guardians are tied together, patrolling in synchronized formation. |
| 5 | `Countdown(N)` | **Basting** | After $N$ player moves, omni gate unlocks automatically. |
| 6 | `Phasing` | **Sheer Silk** | Omni gate alternates between solid (odd moves) and phantom (even moves). |
| 7 | `Armored` | **Brass-Plated** | Master weaver key is reinforced and immune to booster shears/hammer. |
| 8 | `Layered` | **Tulle** | Moving guardian is restricted to patrolling a single fabric layer. |
| 9 | `Mirrored` | **Mirror-Stitched** | Moving guardian's steps are mirrored by an opposing guardian across the seam axis. |
| 10 | `Growing` | **Omni-Expanding** | Grand loom spool dispenses an extra length knot on subsequent thread unrolls. |

### 2. 45 Variant Slot Distribution
- **Blocks 3–13 (Levels 9521–9630):** M951 Moving Guardian variants (Knotted Guardians, Phasing Bosses, Ribbon-Tied Patrols).
- **Blocks 15–25 (Levels 9641–9750):** M952 Omni Gate variants (Dyed Omni Gates, Basting Gates, Mirrored Gates).
- **Blocks 27–37 (Levels 9761–9870):** M953 Grand Loom Spool variants (Fluffed Spools, Tulle Bobbins, Chained Spools).
- **Blocks 39–49 (Levels 9871–9990):** M954 Master Weaver Key variants and All-Systems Tapestry Climax (M951 + M952 + M954 combinations).

### 3. Solver Constraints
- Every variant configuration and the Level 10,000 Grand Finale must be validated in CI by the IDA* solver.
- 0-hearts solvable invariant: All 500 levels are 100% solvable with 0 hearts lost and 0 boosters required.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/grand_master_modifiers.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/modifier_applier.dart` (changed: apply Phase 20 modifiers to M951–M954)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: master synthesis heuristics)

## Risks and Open Questions
- None. Behaviors strictly adhere to `SCALING_TO_10000_LEVELS.md` §7.


Source docs: phase/phase_19/04_VARIANTS_AND_MODIFIERS_PHASE_19.md, phase/phase_19/02_LEVEL_PLAN_9001_9500.md, ../../SCALING_TO_10000_LEVELS.md §7, §8. Depends on: specs/gameplay/phase-19-base-mechanics.md.

# Spec: Gameplay — Phase 19 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slot combinations and 10 craft modifiers applied to Phase 19 combo mechanics (M901–M904) across Levels 9001–9500.

## Current State
Documented in `phase/phase_19/04_VARIANTS_AND_MODIFIERS_PHASE_19.md`, not yet implemented in code.

## Proposed Change
Implement the 10 craft modifier rules and variant definitions in `packages/puzzle_core`:

### 1. Remix B Craft Modifiers
The 10 craft modifiers configure M901–M904 behaviors as follows:

| # | Modifier | Yarn Flavour Name | Functional Rule on Remix B Mechanics |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Twirl thread is knotted; requires $K$ threads to unravel before rotation and falling begin. |
| 2 | `Colored(c)` | **Dyed** | Rhythm belt advances only threads of matching dye color $c$. |
| 3 | `Fluffed` | **Fluffed** | Seam edge split point is hidden beneath dense wool fluff until cleared. |
| 4 | `Chained` | **Ribbon-Tied** | Two hoop rotors are mechanically tied; rotating one turns both in synchrony. |
| 5 | `Countdown(N)` | **Basting** | After $N$ moves, ivy roots wither and rotor becomes a standard passive disc. |
| 6 | `Phasing` | **Sheer Silk** | Rhythm belt alternates between active (odd moves) and dormant (even moves). |
| 7 | `Armored` | **Brass-Plated** | Twirl thread is reinforced and immune to booster scissors/hammer. |
| 8 | `Layered` | **Tulle** | Cross-board split applies only to threads situated on a specific fabric layer. |
| 9 | `Mirrored` | **Mirror-Stitched** | Left-side rotor turns clockwise while right-side rotor turns counter-clockwise. |
| 10 | `Growing` | **Ivy-Expanding** | Rotated roots sprout secondary tendrils every 4 moves. |

### 2. 45 Variant Slot Distribution
- **Blocks 3–13 (Levels 9021–9130):** M901 Twirl Weighted variants (Knotted Twirls, Phasing Spools, Mirrored Falls).
- **Blocks 15–25 (Levels 9141–9250):** M902 Ivy Hoop Rotor variants (Fluffed Rotors, Basting Vines, Chained Rotors).
- **Blocks 27–37 (Levels 9261–9370):** M903 Rhythm Belt variants (Dyed Rhythm Belts, Brass-Plated Tracks, Sheer Beats).
- **Blocks 39–49 (Levels 9371–9490):** M904 Seam Edge Split variants and Kinematic Tapestry Orchestrations (Twirls + Rotors + Splits).

### 3. Solver Constraints
- Every variant configuration must be validated in CI by the IDA* solver.
- 0-hearts solvable invariant: Multi-kinematic combinations must not generate cyclic infinite states or unsolvable orbital loops.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/remix_b_modifiers.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/modifier_applier.dart` (changed: apply Phase 19 modifiers to M901–M904)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: multi-system kinematic heuristics)

## Risks and Open Questions
- None. Behaviors strictly adhere to `SCALING_TO_10000_LEVELS.md` §7.


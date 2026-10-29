Source docs: phase/phase_17/04_VARIANTS_AND_MODIFIERS_PHASE_17.md, phase/phase_17/02_LEVEL_PLAN_8001_8500.md, ../../SCALING_TO_10000_LEVELS.md §7, §8. Depends on: specs/gameplay/phase-17-base-mechanics.md.

# Spec: Gameplay — Phase 17 Variants and Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slot combinations and 10 craft modifiers applied to Phase 17 base mechanics (M801–M804) across Levels 8001–8500.

## Current State
Documented in `phase/phase_17/04_VARIANTS_AND_MODIFIERS_PHASE_17.md`, not yet implemented in code.

## Proposed Change
Implement the 10 craft modifier rules and variant definitions in `packages/puzzle_core`:

### 1. Guardians Craft Modifiers
The 10 craft modifiers configure M801–M804 behaviors as follows:

| # | Modifier | Yarn Flavour Name | Functional Rule on Guardians Mechanics |
|---|---|---|---|
| 1 | `Frozen(K)` | **Knotted** | Pincushion guardian is knotted; requires $K$ threads to unravel before pins can be extracted. |
| 2 | `Colored(c)` | **Dyed** | Guardian takes damage only from threads matching its specific fabric dye color $c$. |
| 3 | `Fluffed` | **Fluffed** | Guardian's core cell or status badge is hidden under dense wool fluff until cleared. |
| 4 | `Chained` | **Ribbon-Tied** | Two guardians are linked by a decorative ribbon; their HP levels equalize after each hit. |
| 5 | `Countdown(N)` | **Basting** | After $N$ player moves, the guardian dissolves automatically without requiring full pin extraction. |
| 6 | `Phasing` | **Sheer Silk** | Armoured shield alternates between solid (odd moves) and phantom (even moves). |
| 7 | `Armored` | **Double-Plated** | Pincushion has dual plating, requiring twice as many pin extractions (HP $\times 2$). |
| 8 | `Layered` | **Tulle** | Guardian is damaged only by threads unravelling on a specific fabric layer. |
| 9 | `Mirrored` | **Mirror-Stitched** | Damaging a guardian automatically applies equal damage to its symmetrical counterpart. |
| 10 | `Growing` | **Pin-Regenerating** | If undamaged for 6 consecutive moves, the guardian regenerates +1 HP. |

### 2. 45 Variant Slot Distribution
- **Blocks 3–13 (Levels 8021–8130):** M801 Twin Pincushions variants (Knotted Guardians, Dyed Twins, Phasing Twins).
- **Blocks 15–25 (Levels 8141–8250):** M802 Armoured Pincushion variants (Fluffed Shields, Basting Levers, Double-Plated Shields).
- **Blocks 27–37 (Levels 8261–8370):** M803 Seeding Pincushion variants (Chained Spawners, Fast Sprouters, Tulle Spawners).
- **Blocks 39–49 (Levels 8371–8490):** M804 Heart Pincushion variants and Royal Court Multi-Guardian Battles (Twins + Shields + Cores).

### 3. Solver Constraints
- Every variant configuration must be validated in CI by the IDA* solver.
- 0-hearts solvable invariant: Spawner buttons and pin regeneration must never outpace valid thread extractions.

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/guardian_modifiers.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/modifier_applier.dart` (changed: apply Phase 17 modifiers to M801–M804)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: dynamic guardian damage pruning)

## Risks and Open Questions
- None. Behaviors strictly adhere to `SCALING_TO_10000_LEVELS.md` §7.

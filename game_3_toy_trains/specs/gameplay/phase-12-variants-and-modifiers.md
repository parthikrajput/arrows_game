Source docs: phase/phase_12/04_VARIANTS_AND_MODIFIERS_PHASE_12.md, phase/phase_12/02_LEVEL_PLAN_5501_6000.md, ../../SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-12-base-mechanics.md.

# Spec: Gameplay — Phase 12 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant mechanic slots combining Phase 12 base mechanics (M551–M554) with the 10 standard modifiers, establishing their stacking semantics, generator keys, and solver constraints.

## Current State
Design documented in `phase/phase_12/04_VARIANTS_AND_MODIFIERS_PHASE_12.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the modifier combination matrix and variant registry in `packages/puzzle_core`:

### 1. 10 Standard Modifier Compatibility Matrix
| Modifier | Hill Line Gravity Semantics | Target Mechanics |
|---|---|---|
| `Countdown(N)` | Lever locks or crate disintegrates after N moves. | M551, M552, M553, M554 |
| `Frozen(K)` | Lever frozen or crate encased in ice until K trains exit. | M551, M552, M553, M554 |
| `Colored` | Crate or ballast train passes only through matching colored barriers. | M551, M552, M553, M554 |
| `Fogged` | Incline lever or loose crate obscured under mountain steam cloud. | All M55x |
| `Chained` | Dual tilt levers or chained crates sliding together. | M551, M552, M554 |
| `Phasing` | Incline lever or balloon pad active only on even move turns. | M551, M552, M553, M554 |
| `Armored` | Steel reinforced crate immune to crane hammer removal. | M551, M552, M554 |
| `Layered` | Incline lever situated on upper wooden viaduct floor. | M551, M552, M553, M554 |
| `Mirrored` | Crates slide in inverted counter-gravity direction. | M551, M552, M553, M554 |
| `Growing` | Foliage vines anchor loose crates in place until pruned. | M551, M552, M553, M554 |

### 2. 45 Variant Slots Overview
- **V01–V10 (Tilt Lever M551):** `M551~CNT5`, `M551~FRZ2`, `M551~COL`, `M551~FOG`, `M551~CHN`, `M551~PHS`, `M551~ARM`, `M551~LAY`, `M551~MIR`, `M551~GRW`.
- **V11:** `M001~CNT6` Last Call Shunting Bumper.
- **V12–V21 (Loose Crates M552):** `M552~CNT5`, `M552~FRZ2`, `M552~COL`, `M552~FOG`, `M552~CHN`, `M552~PHS`, `M552~ARM`, `M552~LAY`, `M552~MIR`, `M552~GRW`.
- **V22:** `M018~FRZ2` Snowbound Mountain Switch.
- **V23–V32 (Balloon Pad M553):** `M553~CNT5`, `M553~FRZ2`, `M553~COL`, `M553~FOG`, `M553~CHN`, `M553~PHS`, `M553~ARM`, `M553~LAY`, `M553~MIR`, `M553~GRW`.
- **V33:** `M013~FOG` Steamy Rotary Yard.
- **V34–V43 (Ballast Train M554):** `M554~CNT5`, `M554~FRZ2`, `M554~COL`, `M554~FOG`, `M554~CHN`, `M554~PHS`, `M554~ARM`, `M554~MIR`, `M554~LAY`, `M554~GRW`.
- **V44:** `M045~CHN` Linked Master Gear Incline.
- **V45:** `M021~CNT5` Last Call Crossing Signal.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/variants_registry_phase_12.dart` (to be created)

## Risks
- Unexpected infinite crate cycles if mirrored gravity opposes active tilt. Mitigation: Generator rejects opposing mirror vectors on mobile crates.

## Open Questions
- None. Variant slots match `phase/phase_12/04_VARIANTS_AND_MODIFIERS_PHASE_12.md`.

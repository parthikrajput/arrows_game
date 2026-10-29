Source docs: phase/phase_18/04_VARIANTS_AND_MODIFIERS_PHASE_18.md, phase/phase_18/02_LEVEL_PLAN_8501_9000.md, ../../SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-18-base-mechanics.md.

# Spec: Gameplay — Phase 18 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant mechanic slots combining Phase 18 base combo mechanics (M851–M854) with the 10 standard modifiers, establishing their stacking semantics, generator keys, and solver constraints.

## Current State
Design documented in `phase/phase_18/04_VARIANTS_AND_MODIFIERS_PHASE_18.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the modifier combination matrix and variant registry in `packages/puzzle_core`:

### 1. 10 Standard Modifier Compatibility Matrix
| Modifier | Remix A Early Era Synergy Semantics | Target Mechanics |
|---|---|---|
| `Countdown(N)` | Lift motor fails or optical prism shatters after N moves. | M851, M852, M853, M854 |
| `Frozen(K)` | Ticket cart or goods chute encased in frost until K trains exit. | M851, M852, M853, M854 |
| `Colored` | Elevator or chute accepts carts only matching designated paint livery. | M851, M852, M853, M854 |
| `Fogged` | Station floor chute or prism beam obscured under steam fog. | All M85x |
| `Chained` | Linked dual lifts moving synchronously between floors. | M851, M852, M853 |
| `Phasing` | Optical sensor or goods chute active only on alternating moves. | M851, M852, M853, M854 |
| `Armored` | Steel reinforced cart chute immune to crane removal. | M851, M852, M853, M854 |
| `Layered` | Elevator connects 3 floors (F1, F2, F3) rather than 2. | M851, M852, M853, M854 |
| `Mirrored` | Compound reflection across central axis during lift transfer. | M851, M852, M853, M854 |
| `Growing` | Botanical vines bind elevator cables until cleared by a train. | M851, M852, M853, M854 |

### 2. 45 Variant Slots Overview
- **V01–V10 (Day/Night Ticket Cart M851):** `M851~CNT5`, `M851~FRZ2`, `M851~COL`, `M851~FOG`, `M851~CHN`, `M851~PHS`, `M851~ARM`, `M851~LAY`, `M851~MIR`, `M851~GRW`.
- **V11:** `M001~CNT6` Last Call Shunting Bumper.
- **V12–V21 (Floor Shunting Lift M852):** `M852~CNT5`, `M852~FRZ2`, `M852~COL`, `M852~FOG`, `M852~CHN`, `M852~PHS`, `M852~ARM`, `M852~LAY`, `M852~MIR`, `M852~GRW`.
- **V22:** `M018~FRZ2` Snowbound Mountain Switch.
- **V23–V32 (Prism Signal Sensor M853):** `M853~CNT5`, `M853~FRZ2`, `M853~COL`, `M853~FOG`, `M853~CHN`, `M853~PHS`, `M853~ARM`, `M853~LAY`, `M853~MIR`, `M853~GRW`.
- **V33:** `M013~FOG` Steamy Rotary Yard.
- **V34–V43 (Ice Blackout Chute M854):** `M854~CNT5`, `M854~FRZ2`, `M854~COL`, `M854~FOG`, `M854~CHN`, `M854~PHS`, `M854~ARM`, `M854~MIR`, `M854~LAY`, `M854~GRW`.
- **V44:** `M045~CHN` Linked Master Gear Incline.
- **V45:** `M021~CNT5` Last Call Crossing Signal.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/variants_registry_phase_18.dart` (to be created)

## Risks
- Multi-modifier deadlock if Countdown triggers before cart reaches elevator. Mitigation: Generator guarantees minimum 8 moves margin on all Countdown carts.

## Open Questions
- None. Variant slots match `phase/phase_18/04_VARIANTS_AND_MODIFIERS_PHASE_18.md`.

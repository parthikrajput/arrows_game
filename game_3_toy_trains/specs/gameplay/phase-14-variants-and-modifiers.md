Source docs: phase/phase_14/04_VARIANTS_AND_MODIFIERS_PHASE_14.md, phase/phase_14/02_LEVEL_PLAN_6501_7000.md, ../../SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-14-base-mechanics.md.

# Spec: Gameplay — Phase 14 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant mechanic slots combining Phase 14 base mechanics (M651–M654) with the 10 standard modifiers, establishing their stacking semantics, generator keys, and solver constraints.

## Current State
Design documented in `phase/phase_14/04_VARIANTS_AND_MODIFIERS_PHASE_14.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the modifier combination matrix and variant registry in `packages/puzzle_core`:

### 1. 10 Standard Modifier Compatibility Matrix
| Modifier | Alpine Pass Symmetry Semantics | Target Mechanics |
|---|---|---|
| `Countdown(N)` | Mirror track de-synchronizes or reflection lock freezes after N moves. | M651, M652, M653, M654 |
| `Frozen(K)` | Mirror twin or reverse engine encased in glacier ice until K trains exit. | M651, M652, M653, M654 |
| `Colored` | Paired engines must match designated enamel livery colors. | M651, M652, M653, M654 |
| `Fogged` | Reflection axis obscured under thick alpine snowstorm mist. | All M65x |
| `Chained` | Quadruple linked mirror engines moving in 4-way symmetry. | M651, M652, M653 |
| `Phasing` | Mirror track active only on even move turns. | M651, M652, M653, M654 |
| `Armored` | Steel-clad glacial barrier gates immune to crane demolition. | M651, M652, M653, M654 |
| `Layered` | Upper mountain pass viaduct reflecting across high trestles. | M651, M652, M653, M654 |
| `Mirrored` | Compound reflection across secondary horizontal transverse axis. | M651, M652, M653, M654 |
| `Growing` | Glacial frost creep spreads along mirror rails unless kept clear. | M651, M652, M653, M654 |

### 2. 45 Variant Slots Overview
- **V01–V10 (Mirror Rail Axis M651):** `M651~CNT5`, `M651~FRZ2`, `M651~COL`, `M651~FOG`, `M651~CHN`, `M651~PHS`, `M651~ARM`, `M651~LAY`, `M651~MIR`, `M651~GRW`.
- **V11:** `M001~CNT6` Last Call Shunting Bumper.
- **V12–V21 (Reflection Lock M652):** `M652~CNT5`, `M652~FRZ2`, `M652~COL`, `M652~FOG`, `M652~CHN`, `M652~PHS`, `M652~ARM`, `M652~LAY`, `M652~MIR`, `M652~GRW`.
- **V22:** `M018~FRZ2` Snowbound Mountain Switch.
- **V23–V32 (Alpine Twin Yard M653):** `M653~CNT5`, `M653~FRZ2`, `M653~COL`, `M653~FOG`, `M653~CHN`, `M653~PHS`, `M653~ARM`, `M653~LAY`, `M653~MIR`, `M653~GRW`.
- **V33:** `M013~FOG` Steamy Rotary Yard.
- **V34–V43 (Reverse Engine M654):** `M654~CNT5`, `M654~FRZ2`, `M654~COL`, `M654~FOG`, `M654~CHN`, `M654~PHS`, `M654~ARM`, `M654~MIR`, `M654~LAY`, `M654~GRW`.
- **V44:** `M045~CHN` Linked Master Gear Incline.
- **V45:** `M021~CNT5` Last Call Crossing Signal.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/variants_registry_phase_14.dart` (to be created)

## Risks
- Double symmetry (X and Y reflection) creating deadlocked circular paths. Mitigation: Compound reflection restricted to max 2 concurrent pairs per level.

## Open Questions
- None. Variant slots match `phase/phase_14/04_VARIANTS_AND_MODIFIERS_PHASE_14.md`.

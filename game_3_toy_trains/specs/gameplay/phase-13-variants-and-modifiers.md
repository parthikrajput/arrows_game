Source docs: phase/phase_13/04_VARIANTS_AND_MODIFIERS_PHASE_13.md, phase/phase_13/02_LEVEL_PLAN_6001_6500.md, ../../SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-13-base-mechanics.md.

# Spec: Gameplay — Phase 13 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant mechanic slots combining Phase 13 base mechanics (M601–M604) with the 10 standard modifiers, establishing their stacking semantics, generator keys, and solver constraints.

## Current State
Design documented in `phase/phase_13/04_VARIANTS_AND_MODIFIERS_PHASE_13.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the modifier combination matrix and variant registry in `packages/puzzle_core`:

### 1. 10 Standard Modifier Compatibility Matrix
| Modifier | Weather Station Fog Semantics | Target Mechanics |
|---|---|---|
| `Countdown(N)` | Lantern extinguishes or draisine derails after N moves. | M601, M602, M603, M604 |
| `Frozen(K)` | Scout draisine or lantern plate frozen until K trains exit. | M601, M602, M603, M604 |
| `Colored` | Scout draisine clears only fog matching its enamel paint color. | M601, M602, M603, M604 |
| `Fogged` | Recursive dense fog layer requiring multiple scout passes. | All M60x |
| `Chained` | Linked lantern plates requiring dual trains parked simultaneously. | M601, M603, M604 |
| `Phasing` | Mirage decoy or backdrop wall solidifies on alternating moves. | M601, M602, M603, M604 |
| `Armored` | Heavy ironclad scout draisine resistant to derailments. | M601, M602, M603, M604 |
| `Layered` | Elevated viaduct lantern illuminating both upper and ground floors. | M601, M602, M603, M604 |
| `Mirrored` | Scout draisine exit mirrors fog reveal across central symmetry axis. | M601, M602, M603, M604 |
| `Growing` | Foliage vines creep over lantern glass, dimming illuminated radius. | M601, M602, M603, M604 |

### 2. 45 Variant Slots Overview
- **V01–V10 (Scout Draisine M601):** `M601~CNT5`, `M601~FRZ2`, `M601~COL`, `M601~FOG`, `M601~CHN`, `M601~PHS`, `M601~ARM`, `M601~LAY`, `M601~MIR`, `M601~GRW`.
- **V11:** `M001~CNT6` Last Call Shunting Bumper.
- **V12–V21 (Mirage Steam M602):** `M602~CNT5`, `M602~FRZ2`, `M602~COL`, `M602~FOG`, `M602~CHN`, `M602~PHS`, `M602~ARM`, `M602~LAY`, `M602~MIR`, `M602~GRW`.
- **V22:** `M018~FRZ2` Snowbound Mountain Switch.
- **V23–V32 (Painted Backdrop M603):** `M603~CNT5`, `M603~FRZ2`, `M603~COL`, `M603~FOG`, `M603~CHN`, `M603~PHS`, `M603~ARM`, `M603~LAY`, `M603~MIR`, `M603~GRW`.
- **V33:** `M013~FOG` Steamy Rotary Yard.
- **V34–V43 (Lantern Plate M604):** `M604~CNT5`, `M604~FRZ2`, `M604~COL`, `M604~FOG`, `M604~CHN`, `M604~PHS`, `M604~ARM`, `M604~MIR`, `M604~LAY`, `M604~GRW`.
- **V44:** `M045~CHN` Linked Master Gear Incline.
- **V45:** `M021~CNT5` Last Call Crossing Signal.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/variants_registry_phase_13.dart` (to be created)

## Risks
- Excessive visual obscurity from stacking fog modifiers. Mitigation: Level generator enforces minimum 40% initial grid visibility.

## Open Questions
- None. Variant slots match `phase/phase_13/04_VARIANTS_AND_MODIFIERS_PHASE_13.md`.

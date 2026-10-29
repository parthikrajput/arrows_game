Source docs: phase/phase_17/04_VARIANTS_AND_MODIFIERS_PHASE_17.md, phase/phase_17/02_LEVEL_PLAN_8001_8500.md, ../../SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-17-base-mechanics.md.

# Spec: Gameplay — Phase 17 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant mechanic slots combining Phase 17 base mechanics (M801–M804) with the 10 standard modifiers, establishing their stacking semantics, generator keys, and solver constraints.

## Current State
Design documented in `phase/phase_17/04_VARIANTS_AND_MODIFIERS_PHASE_17.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the modifier combination matrix and variant registry in `packages/puzzle_core`:

### 1. 10 Standard Modifier Compatibility Matrix
| Modifier | Clock Towers Guardian Semantics | Target Mechanics |
|---|---|---|
| `Countdown(N)` | Tower enrages or spawns double hazards after N moves. | M801, M802, M803, M804 |
| `Frozen(K)` | Tower encased in permafrost; damage immune until K trains exit. | M801, M802, M803, M804 |
| `Colored` | Tower accepts damage exclusively from trains matching active livery. | M801, M802, M803, M804 |
| `Fogged` | Tower HP bar or spawn counter obscured under industrial smoke. | All M80x |
| `Chained` | Linked triple towers requiring damage distribution across all three. | M801, M802, M803 |
| `Phasing` | Tower vulnerable to damage only on alternating move turns. | M801, M802, M803, M804 |
| `Armored` | Tower armor plating requires double damage hits to breach. | M801, M802, M803, M804 |
| `Layered` | Citadel tower spans multiple vertical floors simultaneously. | M801, M802, M803, M804 |
| `Mirrored` | Tower damage reflects to mirrored boss entity across midline. | M801, M802, M803, M804 |
| `Growing` | Foliage overgrowth binds tower walls, regenerating 1 HP per 5 moves. | M801, M802, M803, M804 |

### 2. 45 Variant Slots Overview
- **V01–V10 (Twin Clock Towers M801):** `M801~CNT5`, `M801~FRZ2`, `M801~COL`, `M801~FOG`, `M801~CHN`, `M801~PHS`, `M801~ARM`, `M801~LAY`, `M801~MIR`, `M801~GRW`.
- **V11:** `M001~CNT6` Last Call Shunting Bumper.
- **V12–V21 (Armoured Clock Tower M802):** `M802~CNT5`, `M802~FRZ2`, `M802~COL`, `M802~FOG`, `M802~CHN`, `M802~PHS`, `M802~ARM`, `M802~LAY`, `M802~MIR`, `M802~GRW`.
- **V22:** `M018~FRZ2` Snowbound Mountain Switch.
- **V23–V32 (Depot Tower M803):** `M803~CNT5`, `M803~FRZ2`, `M803~COL`, `M803~FOG`, `M803~CHN`, `M803~PHS`, `M803~ARM`, `M803~LAY`, `M803~MIR`, `M803~GRW`.
- **V33:** `M013~FOG` Steamy Rotary Yard.
- **V34–V43 (Clock Core M804):** `M804~CNT5`, `M804~FRZ2`, `M804~COL`, `M804~FOG`, `M804~CHN`, `M804~PHS`, `M804~ARM`, `M804~MIR`, `M804~LAY`, `M804~GRW`.
- **V44:** `M045~CHN` Linked Master Gear Incline.
- **V45:** `M021~CNT5` Last Call Crossing Signal.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/variants_registry_phase_17.dart` (to be created)

## Risks
- Growing modifier regenerating HP causing endless levels. Mitigation: HP regeneration capped at maximum initial HP, with maximum 2 regenerations per level.

## Open Questions
- None. Variant slots match `phase/phase_17/04_VARIANTS_AND_MODIFIERS_PHASE_17.md`.

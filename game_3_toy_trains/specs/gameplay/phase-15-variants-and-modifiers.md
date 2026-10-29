Source docs: phase/phase_15/04_VARIANTS_AND_MODIFIERS_PHASE_15.md, phase/phase_15/02_LEVEL_PLAN_7001_7500.md, ../../SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-15-base-mechanics.md.

# Spec: Gameplay — Phase 15 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant mechanic slots combining Phase 15 base mechanics (M701–M704) with the 10 standard modifiers, establishing their stacking semantics, generator keys, and solver constraints.

## Current State
Design documented in `phase/phase_15/04_VARIANTS_AND_MODIFIERS_PHASE_15.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the modifier combination matrix and variant registry in `packages/puzzle_core`:

### 1. 10 Standard Modifier Compatibility Matrix
| Modifier | Moving Platforms Semantics | Target Mechanics |
|---|---|---|
| `Countdown(N)` | Conveyor motor burns out or reverses automatically after N moves. | M701, M702, M703, M704 |
| `Frozen(K)` | Belt drive frozen solid until K trains clear the yard. | M701, M702, M703, M704 |
| `Colored` | Conveyor belt activates only when carrying matching colored cars. | M701, M702, M703, M704 |
| `Fogged` | Motorized belt hidden under automated factory steam exhaust. | All M70x |
| `Chained` | Dual parallel conveyor belts driven by synchronous gearing. | M701, M702, M703 |
| `Phasing` | Motorized belt engages drive only on alternating moves. | M701, M702, M703, M704 |
| `Armored` | Heavy industrial steel roller bed immune to crane removal. | M701, M702, M703, M704 |
| `Layered` | Upper-level elevated conveyor viaduct bridging over ground lines. | M701, M702, M703, M704 |
| `Mirrored` | Symmetrical conveyor loops flowing in mirrored rotation. | M701, M702, M703, M704 |
| `Growing` | Factory overgrowth creeping into conveyor gears unless cleared. | M701, M702, M703, M704 |

### 2. 45 Variant Slots Overview
- **V01–V10 (Belt Switch M701):** `M701~CNT5`, `M701~FRZ2`, `M701~COL`, `M701~FOG`, `M701~CHN`, `M701~PHS`, `M701~ARM`, `M701~LAY`, `M701~MIR`, `M701~GRW`.
- **V11:** `M001~CNT6` Last Call Shunting Bumper.
- **V12–V21 (Reversing Belt M702):** `M702~CNT5`, `M702~FRZ2`, `M702~COL`, `M702~FOG`, `M702~CHN`, `M702~PHS`, `M702~ARM`, `M702~LAY`, `M702~MIR`, `M702~GRW`.
- **V22:** `M018~FRZ2` Snowbound Mountain Switch.
- **V23–V32 (Belt Stop Lever M703):** `M703~CNT5`, `M703~FRZ2`, `M703~COL`, `M703~FOG`, `M703~CHN`, `M703~PHS`, `M703~ARM`, `M703~LAY`, `M703~MIR`, `M703~GRW`.
- **V33:** `M013~FOG` Steamy Rotary Yard.
- **V34–V43 (Loop Belt M704):** `M704~CNT5`, `M704~FRZ2`, `M704~COL`, `M704~FOG`, `M704~CHN`, `M704~PHS`, `M704~ARM`, `M704~MIR`, `M704~LAY`, `M704~GRW`.
- **V44:** `M045~CHN` Linked Master Gear Incline.
- **V45:** `M021~CNT5` Last Call Crossing Signal.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/variants_registry_phase_15.dart` (to be created)

## Risks
- Perpetual rotation cycles on loop belts preventing win condition. Mitigation: Generator ensures loop exits are reachable within par moves.

## Open Questions
- None. Variant slots match `phase/phase_15/04_VARIANTS_AND_MODIFIERS_PHASE_15.md`.

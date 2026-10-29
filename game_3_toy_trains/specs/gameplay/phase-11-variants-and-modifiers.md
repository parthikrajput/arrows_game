Source docs: phase/phase_11/04_VARIANTS_AND_MODIFIERS_PHASE_11.md, phase/phase_11/02_LEVEL_PLAN_5001_5500.md, ../../SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-11-base-mechanics.md.

# Spec: Gameplay — Phase 11 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant mechanic slots combining Phase 11 base mechanics (M501–M504) with the 10 standard modifiers, establishing their stacking semantics, generator keys, and solver constraints.

## Current State
Design documented in `phase/phase_11/04_VARIANTS_AND_MODIFIERS_PHASE_11.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the modifier combination matrix and variant registry in `packages/puzzle_core`:

### 1. 10 Standard Modifier Compatibility Matrix
| Modifier | Twin Tables Semantics | Target Mechanics |
|---|---|---|
| `Countdown(N)` | Bridge closes or tunnel mouth locks after N moves. | M501, M502, M503, M504 |
| `Frozen(K)` | Bridge or ticket unlocks only after K trains clear the board. | M501, M502, M503, M504 |
| `Colored` | Only trains matching the designated enamel color can use the bridge or portal. | M501, M502, M503, M504 |
| `Fogged` | Hidden bridge lane or portal mouth obscured by atmospheric steam. | All M50x |
| `Chained` | Dual parallel bridges or dual tickets that must be triggered together. | M501, M502, M503 |
| `Phasing` | Bridge or mirror engine active only on even move turns. | M501, M502, M503, M504 |
| `Armored` | Reinforced bridge pier or ticket barrier immune to crane removal. | M501, M502, M503, M504 |
| `Layered` | Elevated trestle connects upper deck of Table A to upper deck of Table B. | M501, M502, M503, M504 |
| `Mirrored` | Bridge or relay portal applies inverted directional exit vector. | M501, M502, M503, M504 |
| `Growing` | Wooden overgrowth vines spread along bridge piers unless cleared. | M501, M502, M503, M504 |

### 2. 45 Variant Slots Overview
- **V01–V10 (Table Bridge M501):** `M501~CNT5`, `M501~FRZ2`, `M501~COL`, `M501~FOG`, `M501~CHN`, `M501~PHS`, `M501~ARM`, `M501~LAY`, `M501~MIR`, `M501~GRW`.
- **V11:** `M001~CNT6` Last Call Shunting Bumper.
- **V12–V21 (Inter-table Ticket M502):** `M502~CNT5`, `M502~FRZ2`, `M502~COL`, `M502~FOG`, `M502~CHN`, `M502~PHS`, `M502~ARM`, `M502~LAY`, `M502~MIR`, `M502~GRW`.
- **V22:** `M013~FRZ2` Snowbound Rotary Junction.
- **V23–V32 (Mirror Table M503):** `M503~CNT5`, `M503~FRZ2`, `M503~COL`, `M503~FOG`, `M503~CHN`, `M503~PHS`, `M503~ARM`, `M503~LAY`, `M503~MIR`, `M503~GRW`.
- **V33:** `M018~FOG` Steamy Branch Switch.
- **V34–V43 (Relay Tunnel M504):** `M504~CNT5`, `M504~FRZ2`, `M504~COL`, `M504~FOG`, `M504~CHN`, `M504~PHS`, `M504~ARM`, `M504~MIR`, `M504~LAY`, `M504~GRW`.
- **V44:** `M045~CHN` Linked Master Gear Bridge.
- **V45:** `M021~CNT5` Last Call Crossing Signal.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/variants_registry_phase_11.dart` (to be created)

## Risks
- Combinatorial complexity when chaining Countdown with Mirror Trains. Mitigation: Generator rejects double countdowns on linked mirror pairs.

## Open Questions
- None. All variant slots match `phase/phase_11/04_VARIANTS_AND_MODIFIERS_PHASE_11.md`.

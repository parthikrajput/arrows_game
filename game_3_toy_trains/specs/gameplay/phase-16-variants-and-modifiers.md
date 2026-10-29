Source docs: phase/phase_16/04_VARIANTS_AND_MODIFIERS_PHASE_16.md, phase/phase_16/02_LEVEL_PLAN_7501_8000.md, ../../SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-16-base-mechanics.md.

# Spec: Gameplay — Phase 16 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant mechanic slots combining Phase 16 base mechanics (M751–M754) with the 10 standard modifiers, establishing their stacking semantics, generator keys, and solver constraints.

## Current State
Design documented in `phase/phase_16/04_VARIANTS_AND_MODIFIERS_PHASE_16.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the modifier combination matrix and variant registry in `packages/puzzle_core`:

### 1. 10 Standard Modifier Compatibility Matrix
| Modifier | Ticket Office Keys Semantics | Target Mechanics |
|---|---|---|
| `Countdown(N)` | Ticket key dissolves or punch booth closes after N moves. | M751, M752, M753, M754 |
| `Frozen(K)` | Ticket car or punch booth encased in ice until K trains exit. | M751, M752, M753, M754 |
| `Colored` | Ticket punch operates only with matching chromatic ticket stubs. | M751, M752, M753, M754 |
| `Fogged` | Chained barrier or punch booth obscured under steam cloud. | All M75x |
| `Chained` | Multi-lock barriers requiring simultaneous key inputs. | M751, M752, M754 |
| `Phasing` | Swap pad or master pass locomotive active only on alternating moves. | M751, M752, M753, M754 |
| `Armored` | Steel reinforced ticket barrier immune to crane demolition. | M751, M752, M753, M754 |
| `Layered` | Elevated ticket office on upper deck connecting to lower gates. | M751, M752, M753, M754 |
| `Mirrored` | Paired ticket booths crafting twin keys symmetrically. | M751, M752, M753, M754 |
| `Growing` | Wooden ivy creeping over ticket slots unless pruned. | M751, M752, M753, M754 |

### 2. 45 Variant Slots Overview
- **V01–V10 (Ticket Chain M751):** `M751~CNT5`, `M751~FRZ2`, `M751~COL`, `M751~FOG`, `M751~CHN`, `M751~PHS`, `M751~ARM`, `M751~LAY`, `M751~MIR`, `M751~GRW`.
- **V11:** `M001~CNT6` Last Call Shunting Bumper.
- **V12–V21 (Ticket Punch M752):** `M752~CNT5`, `M752~FRZ2`, `M752~COL`, `M752~FOG`, `M752~CHN`, `M752~PHS`, `M752~ARM`, `M752~LAY`, `M752~MIR`, `M752~GRW`.
- **V22:** `M018~FRZ2` Snowbound Mountain Switch.
- **V23–V32 (Master Pass M753):** `M753~CNT5`, `M753~FRZ2`, `M753~COL`, `M753~FOG`, `M753~CHN`, `M753~PHS`, `M753~ARM`, `M753~LAY`, `M753~MIR`, `M753~GRW`.
- **V33:** `M013~FOG` Steamy Rotary Yard.
- **V34–V43 (Ticket Swap Pad M754):** `M754~CNT5`, `M754~FRZ2`, `M754~COL`, `M754~FOG`, `M754~CHN`, `M754~PHS`, `M754~ARM`, `M754~MIR`, `M754~LAY`, `M754~GRW`.
- **V44:** `M045~CHN` Linked Master Gear Incline.
- **V45:** `M021~CNT5` Last Call Crossing Signal.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/variants_registry_phase_16.dart` (to be created)

## Risks
- Combinatorial explosion in branching when multiple Master Passes coexist. Mitigation: Maximum 1 Master Pass entity per level.

## Open Questions
- None. Variant slots match `phase/phase_16/04_VARIANTS_AND_MODIFIERS_PHASE_16.md`.

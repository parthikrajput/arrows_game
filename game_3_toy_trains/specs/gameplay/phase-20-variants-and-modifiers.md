Source docs: phase/phase_20/04_VARIANTS_AND_MODIFIERS_PHASE_20.md, phase/phase_20/02_LEVEL_PLAN_9501_10000.md, ../../SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-20-base-mechanics.md.

# Spec: Gameplay — Phase 20 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant mechanic slots combining Phase 20 base supreme mechanics (M951–M954) with the 10 standard modifiers, establishing their stacking semantics, generator keys, and solver constraints.

## Current State
Design documented in `phase/phase_20/04_VARIANTS_AND_MODIFIERS_PHASE_20.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the modifier combination matrix and variant registry in `packages/puzzle_core`:

### 1. 10 Standard Modifier Compatibility Matrix
| Modifier | Grand Master Omni-Convergence Semantics | Target Mechanics |
|---|---|---|
| `Countdown(N)` | Conveyor ring breaks or arch closes permanently after N moves. | M951, M952, M953, M954 |
| `Frozen(K)` | Conveyor guardian or prism arch encased in ice until K trains exit. | M951, M952, M953, M954 |
| `Colored` | Master pass or prism arch requires matching chromatic train or beam. | M951, M952, M953, M954 |
| `Fogged` | Entire boss citadel or mirror relay concealed in dense alpine fog. | All M95x |
| `Chained` | Linked triple conveyor guardians requiring simultaneous strikes. | M951, M952, M953 |
| `Phasing` | Master pass or prism arch active only on alternating moves. | M951, M952, M953, M954 |
| `Armored` | Steel reinforced guardian casing immune to crane hammer demolition. | M951, M952, M953, M954 |
| `Layered` | Citadel boss spans multiple floors connecting through Goods Lifts. | M951, M952, M953, M954 |
| `Mirrored` | Boss movements and conveyor flows reflect symmetrically across axis. | M951, M952, M953, M954 |
| `Growing` | Foliage spreads over conveyor rails, slowing train circulation speed. | M951, M952, M953, M954 |

### 2. 45 Variant Slots Overview
- **V01–V10 (Conveyor Guardian M951):** `M951~CNT5`, `M951~FRZ2`, `M951~COL`, `M951~FOG`, `M951~CHN`, `M951~PHS`, `M951~ARM`, `M951~LAY`, `M951~MIR`, `M951~GRW`.
- **V11:** `M001~CNT6` Last Call Shunting Bumper.
- **V12–V21 (Gravity Mirror Relay M952):** `M952~CNT5`, `M952~FRZ2`, `M952~COL`, `M952~FOG`, `M952~CHN`, `M952~PHS`, `M952~ARM`, `M952~LAY`, `M952~MIR`, `M952~GRW`.
- **V22:** `M018~FRZ2` Snowbound Mountain Switch.
- **V23–V32 (Night Master Pass M953):** `M953~CNT5`, `M953~FRZ2`, `M953~COL`, `M953~FOG`, `M953~CHN`, `M953~PHS`, `M953~ARM`, `M953~LAY`, `M953~MIR`, `M953~GRW`.
- **V33:** `M013~FOG` Steamy Rotary Yard.
- **V34–V43 (Prism Bloom Arch M954):** `M954~CNT5`, `M954~FRZ2`, `M954~COL`, `M954~FOG`, `M954~CHN`, `M954~PHS`, `M954~ARM`, `M954~MIR`, `M954~LAY`, `M954~GRW`.
- **V44:** `M045~CHN` Linked Master Gear Incline.
- **V45:** `M021~CNT5` Last Call Crossing Signal.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/variants_registry_phase_20.dart` (to be created)

## Risks
- Cascading complexity across 19 systems. Mitigation: Generator uses IDA* solver with strict move budget bounds ($\le 50$ moves).

## Open Questions
- None. Variant slots match `phase/phase_20/04_VARIANTS_AND_MODIFIERS_PHASE_20.md`.

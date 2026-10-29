Source docs: phase/phase_19/04_VARIANTS_AND_MODIFIERS_PHASE_19.md, phase/phase_19/02_LEVEL_PLAN_9001_9500.md, ../../SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-19-base-mechanics.md.

# Spec: Gameplay — Phase 19 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant mechanic slots combining Phase 19 base combo mechanics (M901–M904) with the 10 standard modifiers, establishing their stacking semantics, generator keys, and solver constraints.

## Current State
Design documented in `phase/phase_19/04_VARIANTS_AND_MODIFIERS_PHASE_19.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.

## Proposed Change
Implement the modifier combination matrix and variant registry in `packages/puzzle_core`:

### 1. 10 Standard Modifier Compatibility Matrix
| Modifier | Remix B Mid-Era Synergy Semantics | Target Mechanics |
|---|---|---|
| `Countdown(N)` | Turntable rotor locks or seed wagon derails after N moves. | M901, M902, M903, M904 |
| `Frozen(K)` | Turntable or split train frozen in permafrost until K trains exit. | M901, M902, M903, M904 |
| `Colored` | Pruner split train or metronome gate accepts matching colored trains only. | M901, M902, M903, M904 |
| `Fogged` | Incline seed path or bridge metronome hidden under dense steam mist. | All M90x |
| `Chained` | Synchronized dual turntable rotors or paired metronome gates. | M901, M902, M903 |
| `Phasing` | Split train blades or bridge metronome active only on alternating moves. | M901, M902, M903, M904 |
| `Armored` | Heavy armored seed wagon immune to crane hammer removal. | M901, M902, M903, M904 |
| `Layered` | Elevated turntable rotor situated on high viaduct connecting floors. | M901, M902, M903, M904 |
| `Mirrored` | Turntable rotation or pruner split mirrors across symmetry axis. | M901, M902, M903, M904 |
| `Growing` | Rapid ivy growth accelerates spore sprouting from 3 moves to 1 move. | M901, M902, M903, M904 |

### 2. 45 Variant Slots Overview
- **V01–V10 (Turntable Coupling M901):** `M901~CNT5`, `M901~FRZ2`, `M901~COL`, `M901~FOG`, `M901~CHN`, `M901~PHS`, `M901~ARM`, `M901~LAY`, `M901~MIR`, `M901~GRW`.
- **V11:** `M001~CNT6` Last Call Shunting Bumper.
- **V12–V21 (Incline Seed Wagon M902):** `M902~CNT5`, `M902~FRZ2`, `M902~COL`, `M902~FOG`, `M902~CHN`, `M902~PHS`, `M902~ARM`, `M902~LAY`, `M902~MIR`, `M902~GRW`.
- **V22:** `M018~FRZ2` Snowbound Mountain Switch.
- **V23–V32 (Cross Metronome Gate M903):** `M903~CNT5`, `M903~FRZ2`, `M903~COL`, `M903~FOG`, `M903~CHN`, `M903~PHS`, `M903~ARM`, `M903~LAY`, `M903~MIR`, `M903~GRW`.
- **V33:** `M013~FOG` Steamy Rotary Yard.
- **V34–V43 (Hedge Split Pruner M904):** `M904~CNT5`, `M904~FRZ2`, `M904~COL`, `M904~FOG`, `M904~CHN`, `M904~PHS`, `M904~ARM`, `M904~MIR`, `M904~LAY`, `M904~GRW`.
- **V44:** `M045~CHN` Linked Master Gear Incline.
- **V45:** `M021~CNT5` Last Call Crossing Signal.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/variants_registry_phase_19.dart` (to be created)

## Risks
- Rapid ivy overgrowth completely blocking the seed wagon's own path. Mitigation: Seed wagon maintains cowcatcher front that destroys existing ivy in its forward path.

## Open Questions
- None. Variant slots match `phase/phase_19/04_VARIANTS_AND_MODIFIERS_PHASE_19.md`.

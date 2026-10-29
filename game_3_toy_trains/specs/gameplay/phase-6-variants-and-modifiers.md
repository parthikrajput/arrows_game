Source docs: phase/phase_6/04_VARIANTS_AND_MODIFIERS_PHASE_6.md, ../../SCALING_TO_10000_LEVELS.md §7, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-6-base-mechanics.md, specs/gameplay/phase-5-variants-and-modifiers.md.

# Spec: Gameplay — Phase 6 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slots and procedural modifier rules for Phase 6 (Levels 2501–3000) of Toy Trains: Wooden Railway Puzzle, establishing Base × Modifier compositions across the Signal Lights+ optical rail system.

## Current State
Design documented in `phase/phase_6/04_VARIANTS_AND_MODIFIERS_PHASE_6.md` and `../../SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Earlier phases applied modifiers to shunting carts, multi-floor elevators, and cyclic gates.
- Phase 6 integrates procedural modifiers with optical lenses, timers, sensor locks, and blackout areas.

## Proposed Change
Extend `packages/puzzle_core/lib/src/modifiers/` to support Phase 6 variant slots:

### 1. Optical Modifier Integrations
- `Frozen(K)`: Optical lens frosted over; light cannot pass through until $K$ adjacent trains depart.
- `Colored`: Chromatic beam emitter that produces strict monochromatic rays.
- `Fogged`: Signal lamp sensor hidden under steam fog until adjacent track clears.
- `Chained`: Linked signal lamps that toggle beam directions synchronously.
- `Countdown(N)`: Optical beam permanently burns out or activates after $N$ moves.
- `Phasing`: Beam that turns on and off on alternating moves.
- `Armored`: Heavy reinforced sensor housing immune to Track Crane removal.
- `Layered`: Optical light beam projecting across elevated viaduct decks (Layer 1 or 2).
- `Mirrored`: Dual signal lamps with mirrored reflection angles across the grid.
- `Growing`: Blackout shadows creeping into adjacent cells every $N$ moves.

### 2. Forty-Five Variant Slots Mapping (Blocks 3–49 x1)
Every block x1 without a base mechanic intro hosts a designated procedural variant:
- Block 3 (L2521): `M001~CNT5` Last Call Buffer Stop
- Block 4 (L2531): `M002~FRZ2` Snowbound Cargo Crates
- Block 5 (L2541): `M005~COL` Painted Platform Gate
- Block 6 (L2551): `M007~FOG` Steamy Level Crossing
- Block 7 (L2561): `M009~CHN` Linked Signal Levers
- Block 8 (L2571): `M013~PHS` Phantom Turntable
- Block 9 (L2581): `M016~ARM` Iron-clad Rock Pile
- Block 10 (L2591): `M018~LAY` Deck Track Switch
- Block 11 (L2601): `M015~MIR` Looking-glass Overpass
- Block 12 (L2611): `M027~GRW` Sprouting Ivy Yard
- Block 13 (L2621): `M251~CNT6` Last Call Coloured Lens
- Block 15 (L2641): `M251~FRZ1` Snowbound Coloured Lens
- Block 16 (L2651): `M251~FOG` Steamy Coloured Lens
- Block 17 (L2661): `M251~CHN` Linked Coloured Lenses
- Block 18 (L2671): `M251~PHS` Phantom Coloured Lens
- Block 19 (L2681): `M251~LAY` Deck Coloured Lens
- Block 20 (L2691): `M251~MIR` Looking-glass Coloured Lens
- Block 21 (L2701): `M252~ARM` Iron-clad Twin Sensor Gate
- Block 22 (L2711): `M074~ARM` Iron-clad Girder Wall
- Block 23 (L2721): `M002~GRW` Sprouting Cargo Depot
- Block 24 (L2731): `M252~CNT5` Last Call Twin Sensor Gate
- Block 25 (L2741): `M252~FRZ2` Snowbound Twin Sensor Gate
- Block 27 (L2761): `M253~FOG` Steamy Lamp Timer
- Block 28 (L2771): `M253~CHN` Linked Lamp Timers
- Block 29 (L2781): `M253~PHS` Phantom Lamp Timer
- Block 30 (L2791): `M253~COL` Painted Lamp Timer
- Block 31 (L2801): `M253~LAY` Deck Lamp Timer
- Block 32 (L2811): `M253~MIR` Looking-glass Lamp Timer
- Block 33 (L2821): `M029~ARM` Iron-clad Table Fence
- Block 34 (L2831): `M047~GRW` Sprouting Track Section
- Block 35 (L2841): `M253~CNT6` Last Call Lamp Timer
- Block 36 (L2851): `M253~FRZ1` Snowbound Lamp Timer
- Block 37 (L2861): `M034~FOG` Steamy Rotary Yard
- Block 39 (L2881): `M254~CHN` Linked Blackout Patches
- Block 40 (L2891): `M254~PHS` Phantom Blackout Patch
- Block 41 (L2901): `M254~COL` Painted Blackout Patch
- Block 42 (L2911): `M254~LAY` Deck Blackout Patch
- Block 43 (L2921): `M254~MIR` Looking-glass Blackout Patch
- Block 44 (L2931): `M042~ARM` Iron-clad Water Tower
- Block 45 (L2941): `M010~GRW` Sprouting Steam Clouds
- Block 46 (L2951): `M254~CNT5` Last Call Blackout Patch
- Block 47 (L2961): `M254~FRZ2` Snowbound Blackout Patch
- Block 48 (L2971): `M254~FOG` Steamy Blackout Patch
- Block 49 (L2981): `M254~ARM` Iron-clad Blackout Patch

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/optical_modifier_rules.dart` (to be created)

## Risks
- Combinatorial edge cases with Phasing Blackout Patches causing blinking track states. Mitigated by strict phase alignment during Step 3 of turn execution.

## Open Questions
- None. All 45 variant slot definitions match `phase/phase_6/04_VARIANTS_AND_MODIFIERS_PHASE_6.md` and `SCALING_TO_10000_LEVELS.md` §7.

Source docs: phase/phase_7/04_VARIANTS_AND_MODIFIERS_PHASE_7.md, ../../SCALING_TO_10000_LEVELS.md §7, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-7-base-mechanics.md, specs/gameplay/phase-6-variants-and-modifiers.md.

# Spec: Gameplay — Phase 7 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slots and procedural modifier rules for Phase 7 (Levels 3001–3500) of Toy Trains: Wooden Railway Puzzle, establishing Base × Modifier compositions across the Turntable Yards+ rotational system.

## Current State
Design documented in `phase/phase_7/04_VARIANTS_AND_MODIFIERS_PHASE_7.md` and `../../SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Earlier phases applied modifiers to optical signals, shunting carts, and multi-floor tracks.
- Phase 7 couples procedural modifiers with 4x4 sub-board rotors, moving exits, and clockwork spinning engines.

## Proposed Change
Extend `packages/puzzle_core/lib/src/modifiers/` to support Phase 7 variant slots:

### 1. Rotational Modifier Integrations
- `Frozen(K)`: Turntable rotor iced over; cannot rotate until $K$ adjacent trains depart.
- `Colored`: Color-coded turntable that rotates only when triggered by matching livery trains.
- `Fogged`: Sub-board rotor lever shrouded in steam fog until cleared.
- `Chained`: Linked 4x4 rotors that rotate simultaneously in opposite directions (geared sync).
- `Countdown(N)`: Rotor mechanism locks permanently after $N$ rotations.
- `Phasing`: Rotating exit gap that appears and vanishes on alternating moves.
- `Armored`: Reinforced rotor housing immune to Track Crane removal.
- `Layered`: Rotating turntable section situated on an elevated viaduct deck.
- `Mirrored`: Rotational lever that inverts rotation direction (CCW instead of CW).
- `Growing`: Ivy weeds accumulating around rotor gears every $N$ moves.

### 2. Forty-Five Variant Slots Mapping (Blocks 3–49 x1)
Every block x1 without a base mechanic intro hosts a designated procedural variant:
- Block 3 (L3021): `M001~CNT5` Last Call Buffer Stop
- Block 4 (L3031): `M002~FRZ2` Snowbound Cargo Crates
- Block 5 (L3041): `M005~COL` Painted Platform Gate
- Block 6 (L3051): `M007~FOG` Steamy Level Crossing
- Block 7 (L3061): `M009~CHN` Linked Signal Levers
- Block 8 (L3071): `M013~PHS` Phantom Turntable
- Block 9 (L3081): `M016~ARM` Iron-clad Rock Pile
- Block 10 (L3091): `M018~LAY` Deck Track Switch
- Block 11 (L3101): `M015~MIR` Looking-glass Overpass
- Block 12 (L3111): `M027~GRW` Sprouting Ivy Yard
- Block 13 (L3121): `M301~CNT6` Last Call Rotating Yard Block
- Block 15 (L3141): `M301~FRZ1` Snowbound Rotating Yard Block
- Block 16 (L3151): `M301~FOG` Steamy Rotating Yard Block
- Block 17 (L3161): `M301~CHN` Linked Rotating Yard Blocks
- Block 18 (L3171): `M301~PHS` Phantom Rotating Yard Block
- Block 19 (L3181): `M301~LAY` Deck Rotating Yard Block
- Block 20 (L3191): `M301~MIR` Looking-glass Rotating Yard Block
- Block 21 (L3201): `M302~ARM` Iron-clad Spinning Station Exits
- Block 22 (L3211): `M074~ARM` Iron-clad Girder Wall
- Block 23 (L3221): `M002~GRW` Sprouting Cargo Depot
- Block 24 (L3231): `M302~CNT5` Last Call Spinning Station Exits
- Block 25 (L3241): `M302~FRZ2` Snowbound Spinning Station Exits
- Block 27 (L3261): `M303~FOG` Steamy Spinner Engine
- Block 28 (L3271): `M303~CHN` Linked Spinner Engines
- Block 29 (L3281): `M303~PHS` Phantom Spinner Engine
- Block 30 (L3291): `M303~COL` Painted Spinner Engine
- Block 31 (L3301): `M303~LAY` Deck Spinner Engine
- Block 32 (L3311): `M303~MIR` Looking-glass Spinner Engine
- Block 33 (L3321): `M029~ARM` Iron-clad Table Fence
- Block 34 (L3331): `M047~GRW` Sprouting Track Section
- Block 35 (L3341): `M303~CNT6` Last Call Spinner Engine
- Block 36 (L3351): `M303~FRZ1` Snowbound Spinner Engine
- Block 37 (L3361): `M034~FOG` Steamy Rotary Yard
- Block 39 (L3381): `M304~CHN` Linked Turntable Locks
- Block 40 (L3391): `M304~PHS` Phantom Turntable Lock
- Block 41 (L3401): `M304~COL` Painted Turntable Lock
- Block 42 (L3411): `M304~LAY` Deck Turntable Lock
- Block 43 (L3421): `M304~MIR` Looking-glass Turntable Lock
- Block 44 (L3431): `M042~ARM` Iron-clad Water Tower
- Block 45 (L3441): `M010~GRW` Sprouting Steam Clouds
- Block 46 (L3451): `M304~CNT5` Last Call Turntable Lock
- Block 47 (L3461): `M304~FRZ2` Snowbound Turntable Lock
- Block 48 (L3471): `M304~FOG` Steamy Turntable Lock
- Block 49 (L3481): `M304~ARM` Iron-clad Turntable Lock

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/rotational_modifier_rules.dart` (to be created)

## Risks
- Orientation conflicts when Mirrored modifiers invert rotation vectors inside linked chained rotors. Mitigated by explicit CCW mathematical matrix inversion.

## Open Questions
- None. All 45 variant slot definitions match `phase/phase_7/04_VARIANTS_AND_MODIFIERS_PHASE_7.md` and `SCALING_TO_10000_LEVELS.md` §7.

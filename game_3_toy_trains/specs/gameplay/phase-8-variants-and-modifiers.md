Source docs: phase/phase_8/04_VARIANTS_AND_MODIFIERS_PHASE_8.md, ../../SCALING_TO_10000_LEVELS.md §7, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-8-base-mechanics.md, specs/gameplay/phase-7-variants-and-modifiers.md.

# Spec: Gameplay — Phase 8 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slots and procedural modifier rules for Phase 8 (Levels 3501–4000) of Toy Trains: Wooden Railway Puzzle, establishing Base × Modifier compositions across the Overgrown Branch Line botanical rail system.

## Current State
Design documented in `phase/phase_8/04_VARIANTS_AND_MODIFIERS_PHASE_8.md` and `../../SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Earlier phases applied modifiers to rotational yards, optical beams, and shunting carts.
- Phase 8 integrates procedural modifiers with spreading ivy, pruning attachments, seed wagons, and blooming trellises.

## Proposed Change
Extend `packages/puzzle_core/lib/src/modifiers/` to support Phase 8 variant slots:

### 1. Botanical Modifier Integrations
- `Frozen(K)`: Ivy vine encased in winter frost; dormant until $K$ adjacent trains depart.
- `Colored`: Color-specific vine that can only be trimmed by matching livery locomotives.
- `Fogged`: Pruner attachment hidden under steam fog until cleared.
- `Chained`: Linked Flower Arches that require simultaneous botanical contact to open.
- `Countdown(N)`: Dormant seed sprouts into overgrown briars after exactly $N$ moves.
- `Phasing`: Overgrown vines that phase in and out of existence on alternating moves.
- `Armored`: Iron-clad thorny briars immune to Track Crane removal.
- `Layered`: Wild ivy creeping up vertical trestles onto elevated viaduct decks.
- `Mirrored`: Pruning scythes that clear the opposite side of the track.
- `Growing`: Accelerated multi-cell ivy growth bursts.

### 2. Forty-Five Variant Slots Mapping (Blocks 3–49 x1)
Every block x1 without a base mechanic intro hosts a designated procedural variant:
- Block 3 (L3521): `M001~CNT5` Last Call Buffer Stop
- Block 4 (L3531): `M002~FRZ2` Snowbound Cargo Crates
- Block 5 (L3541): `M005~COL` Painted Platform Gate
- Block 6 (L3551): `M007~FOG` Steamy Level Crossing
- Block 7 (L3561): `M009~CHN` Linked Signal Levers
- Block 8 (L3571): `M013~PHS` Phantom Turntable
- Block 9 (L3581): `M016~ARM` Iron-clad Rock Pile
- Block 10 (L3591): `M018~LAY` Deck Track Switch
- Block 11 (L3601): `M015~MIR` Looking-glass Overpass
- Block 12 (L3611): `M027~GRW` Sprouting Ivy Yard
- Block 13 (L3621): `M351~CNT6` Last Call Wild Ivy
- Block 15 (L3641): `M351~FRZ1` Snowbound Wild Ivy
- Block 16 (L3651): `M351~FOG` Steamy Wild Ivy
- Block 17 (L3661): `M351~CHN` Linked Wild Ivy
- Block 18 (L3671): `M351~PHS` Phantom Wild Ivy
- Block 19 (L3681): `M351~LAY` Deck Wild Ivy
- Block 20 (L3691): `M351~MIR` Looking-glass Wild Ivy
- Block 21 (L3701): `M352~ARM` Iron-clad Hedge Trimmer
- Block 22 (L3711): `M074~ARM` Iron-clad Girder Wall
- Block 23 (L3721): `M002~GRW` Sprouting Cargo Depot
- Block 24 (L3731): `M352~CNT5` Last Call Hedge Trimmer
- Block 25 (L3741): `M352~FRZ2` Snowbound Hedge Trimmer
- Block 27 (L3761): `M353~FOG` Steamy Seed Wagon
- Block 28 (L3771): `M353~CHN` Linked Seed Wagons
- Block 29 (L3781): `M353~PHS` Phantom Seed Wagon
- Block 30 (L3791): `M353~COL` Painted Seed Wagon
- Block 31 (L3801): `M353~LAY` Deck Seed Wagon
- Block 32 (L3811): `M353~MIR` Looking-glass Seed Wagon
- Block 33 (L3821): `M029~ARM` Iron-clad Table Fence
- Block 34 (L3831): `M047~GRW` Sprouting Track Section
- Block 35 (L3841): `M353~CNT6` Last Call Seed Wagon
- Block 36 (L3851): `M353~FRZ1` Snowbound Seed Wagon
- Block 37 (L3861): `M034~FOG` Steamy Rotary Yard
- Block 39 (L3881): `M354~CHN` Linked Flower Arches
- Block 40 (L3891): `M354~PHS` Phantom Flower Arch
- Block 41 (L3901): `M354~COL` Painted Flower Arch
- Block 42 (L3911): `M354~LAY` Deck Flower Arch
- Block 43 (L3921): `M354~MIR` Looking-glass Flower Arch
- Block 44 (L3931): `M042~ARM` Iron-clad Water Tower
- Block 45 (L3941): `M010~GRW` Sprouting Steam Clouds
- Block 46 (L3951): `M354~CNT5` Last Call Flower Arch
- Block 47 (L3961): `M354~FRZ2` Snowbound Flower Arch
- Block 48 (L3971): `M354~FOG` Steamy Flower Arch
- Block 49 (L3981): `M354~ARM` Iron-clad Flower Arch

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/botanical_modifier_rules.dart` (to be created)

## Risks
- Unexpected ivy growth rate spikes with Growing modifiers. Mitigated by strict cellular automata max spread clamps per turn.

## Open Questions
- None. All 45 variant slot definitions match `phase/phase_8/04_VARIANTS_AND_MODIFIERS_PHASE_8.md` and `SCALING_TO_10000_LEVELS.md` §7.

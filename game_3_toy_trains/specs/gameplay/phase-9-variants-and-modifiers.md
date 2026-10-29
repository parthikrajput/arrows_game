Source docs: phase/phase_9/04_VARIANTS_AND_MODIFIERS_PHASE_9.md, ../../SCALING_TO_10000_LEVELS.md §7, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-9-base-mechanics.md, specs/gameplay/phase-8-variants-and-modifiers.md.

# Spec: Gameplay — Phase 9 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slots and procedural modifier rules for Phase 9 (Levels 4001–4500) of Toy Trains: Wooden Railway Puzzle, establishing Base × Modifier compositions across the Couple & Uncouple train composition system.

## Current State
Design documented in `phase/phase_9/04_VARIANTS_AND_MODIFIERS_PHASE_9.md` and `../../SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Earlier phases applied modifiers to botanical overgrowth, rotational turntables, and optical beams.
- Phase 9 couples procedural modifiers with coupling pads, twin split trains, segment locks, and rejoin arches.

## Proposed Change
Extend `packages/puzzle_core/lib/src/modifiers/` to support Phase 9 variant slots:

### 1. Composition Modifier Integrations
- `Frozen(K)`: Coupling pad mechanism iced over; cannot merge trains until $K$ adjacent trains depart.
- `Colored`: Color-coded coupling pads that merge only trains with matching enamel liveries.
- `Fogged`: Twin split train shrouded in steam fog until cleared by adjacent track movement.
- `Chained`: Linked coupling pads that activate simultaneously across different track lines.
- `Countdown(N)`: Coupling clamp locks permanently after $N$ moves, preventing further uncoupling.
- `Phasing`: Rejoin arch that phases between solid and open states on alternating moves.
- `Armored`: Heavy reinforced segment lock immune to Track Crane removal.
- `Layered`: Coupling pads situated on elevated viaduct decks (Layer 1 or 2).
- `Mirrored`: Twin split train whose halves diverge in mirrored opposite directions upon split.
- `Growing`: Rust accumulation jamming coupling knuckles every $N$ moves.

### 2. Forty-Five Variant Slots Mapping (Blocks 3–49 x1)
Every block x1 without a base mechanic intro hosts a designated procedural variant:
- Block 3 (L4021): `M001~CNT5` Last Call Buffer Stop
- Block 4 (L4031): `M002~FRZ2` Snowbound Cargo Crates
- Block 5 (L4041): `M005~COL` Painted Platform Gate
- Block 6 (L4051): `M007~FOG` Steamy Level Crossing
- Block 7 (L4061): `M009~CHN` Linked Signal Levers
- Block 8 (L4071): `M013~PHS` Phantom Turntable
- Block 9 (L4081): `M016~ARM` Iron-clad Rock Pile
- Block 10 (L4091): `M018~LAY` Deck Track Switch
- Block 11 (L4101): `M015~MIR` Looking-glass Overpass
- Block 12 (L4111): `M027~GRW` Sprouting Ivy Yard
- Block 13 (L4121): `M401~CNT6` Last Call Coupling Pad
- Block 15 (L4141): `M401~FRZ1` Snowbound Coupling Pad
- Block 16 (L4151): `M401~FOG` Steamy Coupling Pad
- Block 17 (L4161): `M401~CHN` Linked Coupling Pads
- Block 18 (L4171): `M401~PHS` Phantom Coupling Pad
- Block 19 (L4181): `M401~LAY` Deck Coupling Pad
- Block 20 (L4191): `M401~MIR` Looking-glass Coupling Pad
- Block 21 (L4201): `M402~ARM` Iron-clad Twin Split Train
- Block 22 (L4211): `M074~ARM` Iron-clad Girder Wall
- Block 23 (L4221): `M002~GRW` Sprouting Cargo Depot
- Block 24 (L4231): `M402~CNT5` Last Call Twin Split Train
- Block 25 (L4241): `M402~FRZ2` Snowbound Twin Split Train
- Block 27 (L4261): `M403~FOG` Steamy Coupling Lock
- Block 28 (L4271): `M403~CHN` Linked Coupling Locks
- Block 29 (L4281): `M403~PHS` Phantom Coupling Lock
- Block 30 (L4291): `M403~COL` Painted Coupling Lock
- Block 31 (L4301): `M403~LAY` Deck Coupling Lock
- Block 32 (L4311): `M403~MIR` Looking-glass Coupling Lock
- Block 33 (L4321): `M029~ARM` Iron-clad Table Fence
- Block 34 (L4331): `M047~GRW` Sprouting Track Section
- Block 35 (L4341): `M403~CNT6` Last Call Coupling Lock
- Block 36 (L4351): `M403~FRZ1` Snowbound Coupling Lock
- Block 37 (L4361): `M034~FOG` Steamy Rotary Yard
- Block 39 (L4381): `M404~CHN` Linked Rejoin Arches
- Block 40 (L4391): `M404~PHS` Phantom Rejoin Arch
- Block 41 (L4401): `M404~COL` Painted Rejoin Arch
- Block 42 (L4411): `M404~LAY` Deck Rejoin Arch
- Block 43 (L4421): `M404~MIR` Looking-glass Rejoin Arch
- Block 44 (L4431): `M042~ARM` Iron-clad Water Tower
- Block 45 (L4441): `M010~GRW` Sprouting Steam Clouds
- Block 46 (L4451): `M404~CNT5` Last Call Rejoin Arch
- Block 47 (L4461): `M404~FRZ2` Snowbound Rejoin Arch
- Block 48 (L4471): `M404~FOG` Steamy Rejoin Arch
- Block 49 (L4481): `M404~ARM` Iron-clad Rejoin Arch

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/composition_modifier_rules.dart` (to be created)

## Risks
- Combinatorial deadlocks with Frozen split trains trapped on obstructed tracks. Mitigated by validator check: split trains cannot be frozen while adjacent exit cells are occupied.

## Open Questions
- None. All 45 variant slot definitions match `phase/phase_9/04_VARIANTS_AND_MODIFIERS_PHASE_9.md` and `SCALING_TO_10000_LEVELS.md` §7.

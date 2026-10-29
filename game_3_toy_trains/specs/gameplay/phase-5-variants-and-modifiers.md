Source docs: phase/phase_5/04_VARIANTS_AND_MODIFIERS_PHASE_5.md, ../../SCALING_TO_10000_LEVELS.md §7, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-5-base-mechanics.md, specs/gameplay/phase-4-variants-and-modifiers.md.

# Spec: Gameplay — Phase 5 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slots and procedural modifier rules for Phase 5 (Levels 2001–2500) of Toy Trains: Wooden Railway Puzzle, establishing Base × Modifier compositions across the Yard Shunting+ shunting puzzle system.

## Current State
Design documented in `phase/phase_5/04_VARIANTS_AND_MODIFIERS_PHASE_5.md` and `../../SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Earlier phases applied modifiers to static tracks, cycles, and multi-floor components.
- Phase 5 couples procedural modifiers with dynamic pushable shunting wagons and track pits.

## Proposed Change
Extend `packages/puzzle_core/lib/src/modifiers/` to support Phase 5 variant slots:

### 1. Shunting Modifier Combinations
The 10 standardized railway modifiers enhance shunting mechanics:
- `Frozen(K)`: Cart frozen in ice; cannot be pushed until $K$ adjacent trains depart.
- `Colored`: Color-coded cart that can only be pushed by matching livery locomotives.
- `Fogged`: Wagon hidden under steam cloud until surveyed by an adjacent train.
- `Chained`: Mechanically linked carts that shift simultaneously when either is shoved.
- `Countdown(N)`: Cart wheels lock after $N$ moves, becoming an immovable obstacle.
- `Phasing`: Cart that turns intangible on odd moves, allowing trains to pass through it.
- `Armored`: Heavy reinforced cart immune to Track Crane removal.
- `Layered`: Shunting wagon situated on an elevated viaduct deck.
- `Mirrored`: Shunting wagon that moves in reverse direction when impacted.
- `Growing`: Ballast pile expanding outward into adjacent track cells every $N$ moves.

### 2. Forty-Five Variant Slots Mapping (Blocks 3–49 x1)
Every block x1 without a base mechanic intro hosts a designated procedural variant:
- Block 3 (L2021): `M001~CNT5` Last Call Buffer Stop
- Block 4 (L2031): `M002~FRZ2` Snowbound Cargo Crates
- Block 5 (L2041): `M005~COL` Painted Platform Gate
- Block 6 (L2051): `M007~FOG` Steamy Level Crossing
- Block 7 (L2061): `M009~CHN` Linked Signal Levers
- Block 8 (L2071): `M013~PHS` Phantom Turntable
- Block 9 (L2081): `M016~ARM` Iron-clad Rock Pile
- Block 10 (L2091): `M018~LAY` Deck Track Switch
- Block 11 (L2101): `M015~MIR` Looking-glass Overpass
- Block 12 (L2111): `M027~GRW` Sprouting Ivy Yard
- Block 13 (L2121): `M201~CNT6` Last Call Cart Pit
- Block 15 (L2141): `M202~FRZ1` Snowbound Ice Cart
- Block 16 (L2151): `M202~FOG` Steamy Ice Cart
- Block 17 (L2161): `M202~CHN` Linked Ice Carts
- Block 18 (L2171): `M202~PHS` Phantom Ice Cart
- Block 19 (L2181): `M202~COL` Painted Ice Cart
- Block 20 (L2191): `M202~LAY` Deck Ice Cart
- Block 21 (L2201): `M202~MIR` Looking-glass Ice Cart
- Block 22 (L2211): `M202~ARM` Iron-clad Ice Cart
- Block 23 (L2221): `M002~GRW` Sprouting Cargo Depot
- Block 24 (L2231): `M201~CNT5` Last Call Cart Pit
- Block 25 (L2241): `M201~FRZ2` Snowbound Cart Pit
- Block 27 (L2261): `M203~FOG` Steamy Ticket Cart
- Block 28 (L2271): `M203~CHN` Linked Ticket Carts
- Block 29 (L2281): `M203~PHS` Phantom Ticket Cart
- Block 30 (L2291): `M203~COL` Painted Ticket Cart
- Block 31 (L2301): `M203~LAY` Deck Ticket Cart
- Block 32 (L2311): `M203~MIR` Looking-glass Ticket Cart
- Block 33 (L2321): `M029~ARM` Iron-clad Table Fence
- Block 34 (L2331): `M047~GRW` Sprouting Track Section
- Block 35 (L2341): `M203~CNT6` Last Call Ticket Cart
- Block 36 (L2351): `M203~FRZ1` Snowbound Ticket Cart
- Block 37 (L2361): `M034~FOG` Steamy Rotary Yard
- Block 39 (L2381): `M204~CHN` Linked Ballast Carts
- Block 40 (L2391): `M204~PHS` Phantom Ballast Cart
- Block 41 (L2401): `M204~COL` Painted Ballast Cart
- Block 42 (L2411): `M204~LAY` Deck Ballast Cart
- Block 43 (L2421): `M204~MIR` Looking-glass Ballast Cart
- Block 44 (L2431): `M204~ARM` Iron-clad Ballast Cart
- Block 45 (L2441): `M010~GRW` Sprouting Steam Clouds
- Block 46 (L2451): `M204~CNT5` Last Call Ballast Cart
- Block 47 (L2461): `M204~FRZ2` Snowbound Ballast Cart
- Block 48 (L2471): `M204~FOG` Steamy Ballast Cart
- Block 49 (L2481): `M204~CHN` Linked Ballast Carts

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/shunting_modifier_rules.dart` (to be created)

## Risks
- Ice carts sliding across chained switches triggering uncontrollable chain-reaction collisions. Mitigated by atomic move resolution and collision bounding boxes.

## Open Questions
- None. All 45 variant slot definitions match `phase/phase_5/04_VARIANTS_AND_MODIFIERS_PHASE_5.md` and `SCALING_TO_10000_LEVELS.md` §7.


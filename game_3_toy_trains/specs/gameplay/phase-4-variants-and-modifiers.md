Source docs: phase/phase_4/04_VARIANTS_AND_MODIFIERS_PHASE_4.md, ../../SCALING_TO_10000_LEVELS.md §7, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-4-base-mechanics.md, specs/gameplay/phase-3-variants-and-modifiers.md.

# Spec: Gameplay — Phase 4 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slots and procedural modifier rules for Phase 4 (Levels 1501–2000) of Toy Trains: Wooden Railway Puzzle, establishing Base × Modifier compositions across the multi-floor station architecture.

## Current State
Design documented in `phase/phase_4/04_VARIANTS_AND_MODIFIERS_PHASE_4.md` and `../../SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Phase 3 established procedural modifier decoration for planar and cyclic mechanics.
- Phase 4 integrates the 10 standard modifiers with vertical transport mechanics (M151–M154).

## Proposed Change
Extend `packages/puzzle_core/lib/src/modifiers/` to support Phase 4 variant slots:

### 1. Multi-Floor Modifier Integration
The 10 standardized railway modifiers adapt naturally to Station Floors:
- `Frozen(K)` (Snowbound): Station stairs or lift frozen until $K$ adjacent trains depart.
- `Colored` (Painted): Glass platform or chute accepting only matching livery trains.
- `Fogged` (Steamy): Multi-floor elevator hidden under steam cloud until surveyed.
- `Chained` (Linked): Linked lifts that rise and descend inversely across floors.
- `Countdown(N)` (Last Call): Stairs that collapse into drop holes after $N$ moves.
- `Phasing` (Phantom): Glass platform that becomes solid/transparent on alternating moves.
- `Armored` (Iron-clad): Unbreakable platform barrier requiring elevator transport to bypass.
- `Layered` (Deck): Multi-tiered viaduct platforms mounted directly on F2 or F3.
- `Mirrored` (Looking-glass): Dual stair shafts with inverted destination coordinates.
- `Growing` (Sprouting): Cargo crates accumulating in lower floor drop zones.

### 2. Forty-Five Variant Slots Mapping (Blocks 3–49 x1)
Every block x1 without a base mechanic intro hosts a designated procedural variant:
- Block 3 (L1521): `M001~CNT6` Last Call Buffer Stop
- Block 4 (L1531): `M002~FRZ2` Snowbound Cargo Crates
- Block 5 (L1541): `M005~COL` Painted Platform Gate
- Block 6 (L1551): `M007~FOG` Steamy Level Crossing
- Block 7 (L1561): `M009~CHN` Linked Signal Levers
- Block 8 (L1571): `M013~PHS` Phantom Turntable
- Block 9 (L1581): `M016~ARM` Iron-clad Rock Pile
- Block 10 (L1591): `M018~LAY` Deck Track Switch
- Block 11 (L1601): `M015~MIR` Looking-glass Overpass
- Block 12 (L1611): `M027~GRW` Sprouting Ivy Yard
- Block 13 (L1621): `M151~CNT5` Last Call Station Stairs
- Block 15 (L1641): `M151~FRZ1` Snowbound Station Stairs
- Block 16 (L1651): `M152~FOG` Steamy Glass Platform
- Block 17 (L1661): `M151~CHN` Linked Station Stairs
- Block 18 (L1671): `M152~PHS` Phantom Glass Platform
- Block 19 (L1681): `M152~COL` Painted Glass Platform
- Block 20 (L1691): `M151~LAY` Deck Station Stairs
- Block 21 (L1701): `M151~MIR` Looking-glass Station Stairs
- Block 22 (L1711): `M074~ARM` Iron-clad Girder Wall
- Block 23 (L1721): `M002~GRW` Sprouting Cargo Depot
- Block 24 (L1731): `M152~CNT5` Last Call Glass Platform
- Block 25 (L1741): `M152~FRZ2` Snowbound Glass Platform
- Block 27 (L1761): `M153~FOG` Steamy Goods Chute
- Block 28 (L1771): `M153~CHN` Linked Goods Chutes
- Block 29 (L1781): `M153~PHS` Phantom Goods Chute
- Block 30 (L1791): `M153~COL` Painted Goods Chute
- Block 31 (L1801): `M153~LAY` Deck Goods Chute
- Block 32 (L1811): `M153~MIR` Looking-glass Goods Chute
- Block 33 (L1821): `M029~ARM` Iron-clad Table Fence
- Block 34 (L1831): `M047~GRW` Sprouting Track Section
- Block 35 (L1841): `M153~CNT6` Last Call Goods Chute
- Block 36 (L1851): `M153~FRZ1` Snowbound Goods Chute
- Block 37 (L1861): `M034~FOG` Steamy Rotary Yard
- Block 39 (L1881): `M154~CHN` Linked Goods Lifts
- Block 40 (L1891): `M154~PHS` Phantom Goods Lift
- Block 41 (L1901): `M154~COL` Painted Goods Lift
- Block 42 (L1911): `M154~LAY` Deck Goods Lift
- Block 43 (L1921): `M154~MIR` Looking-glass Goods Lift
- Block 44 (L1931): `M042~ARM` Iron-clad Water Tower
- Block 45 (L1941): `M010~GRW` Sprouting Steam Clouds
- Block 46 (L1951): `M154~CNT5` Last Call Goods Lift
- Block 47 (L1961): `M154~FRZ2` Snowbound Goods Lift
- Block 48 (L1971): `M154~FOG` Steamy Goods Lift
- Block 49 (L1981): `M154~ARM` Iron-clad Goods Lift

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/vertical_modifier_rules.dart` (to be created)

## Risks
- Vertical portal loops where stairs and chutes cycle a train infinitely between floors. Mitigated by validator check rejecting cyclical vertical transport loops.

## Open Questions
- None. All 45 variant slot definitions match `phase/phase_4/04_VARIANTS_AND_MODIFIERS_PHASE_4.md` and `SCALING_TO_10000_LEVELS.md` §7.


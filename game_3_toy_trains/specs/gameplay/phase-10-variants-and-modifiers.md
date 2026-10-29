Source docs: phase/phase_10/04_VARIANTS_AND_MODIFIERS_PHASE_10.md, ../../SCALING_TO_10000_LEVELS.md §7, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-10-base-mechanics.md, specs/gameplay/phase-9-variants-and-modifiers.md.

# Spec: Gameplay — Phase 10 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 45 variant slots and procedural modifier rules for Phase 10 (Levels 4501–5000) of Toy Trains: Wooden Railway Puzzle, establishing Base × Modifier compositions across the Timetable Master sequencing system.

## Current State
Design documented in `phase/phase_10/04_VARIANTS_AND_MODIFIERS_PHASE_10.md` and `../../SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Earlier phases applied modifiers to coupling pads, botanical growth, and rotational turntables.
- Phase 10 couples procedural modifiers with metronome gates, pattern locks, platform orders, and echo signals.

## Proposed Change
Extend `packages/puzzle_core/lib/src/modifiers/` to support Phase 10 variant slots:

### 1. Sequencing Modifier Integrations
- `Frozen(K)`: Metronome gate frozen in current state until $K$ adjacent trains depart.
- `Colored`: Departure code lock requiring specific dual-color gradient trains.
- `Fogged`: Platform departure order number hidden under steam fog until cleared.
- `Chained`: Linked metronome gates operating on synchronous or inverted rhythms.
- `Countdown(N)`: Departure code lock expires permanently after $N$ total moves.
- `Phasing`: Echo signal that checks sequence only on alternating moves.
- `Armored`: Heavy reinforced metronome gate frame immune to Track Crane removal.
- `Layered`: Platform order exits situated on elevated viaduct decks.
- `Mirrored`: Departure code that must be fulfilled in reverse order.
- `Growing`: Rust accumulating across metronome gear pendulums every $N$ moves.

### 2. Forty-Five Variant Slots Mapping (Blocks 3–49 x1)
Every block x1 without a base mechanic intro hosts a designated procedural variant:
- Block 3 (L4521): `M001~CNT5` Last Call Buffer Stop
- Block 4 (L4531): `M002~FRZ2` Snowbound Cargo Crates
- Block 5 (L4541): `M005~COL` Painted Platform Gate
- Block 6 (L4551): `M007~FOG` Steamy Level Crossing
- Block 7 (L4561): `M009~CHN` Linked Signal Levers
- Block 8 (L4571): `M013~PHS` Phantom Turntable
- Block 9 (L4581): `M016~ARM` Iron-clad Rock Pile
- Block 10 (L4591): `M018~LAY` Deck Track Switch
- Block 11 (L4601): `M015~MIR` Looking-glass Overpass
- Block 12 (L4611): `M027~GRW` Sprouting Ivy Yard
- Block 13 (L4621): `M451~CNT6` Last Call Metronome Gate
- Block 15 (L4641): `M451~FRZ1` Snowbound Metronome Gate
- Block 16 (L4651): `M451~FOG` Steamy Metronome Gate
- Block 17 (L4661): `M451~CHN` Linked Metronome Gates
- Block 18 (L4671): `M451~PHS` Phantom Metronome Gate
- Block 19 (L4681): `M451~LAY` Deck Metronome Gate
- Block 20 (L4691): `M451~MIR` Looking-glass Metronome Gate
- Block 21 (L4701): `M452~ARM` Iron-clad Departure Code Lock
- Block 22 (L4711): `M074~ARM` Iron-clad Girder Wall
- Block 23 (L4721): `M002~GRW` Sprouting Cargo Depot
- Block 24 (L4731): `M452~CNT5` Last Call Departure Code Lock
- Block 25 (L4741): `M452~FRZ2` Snowbound Departure Code Lock
- Block 27 (L4761): `M453~FOG` Steamy Platform Order Exit
- Block 28 (L4771): `M453~CHN` Linked Platform Order Exits
- Block 29 (L4781): `M453~PHS` Phantom Platform Order Exit
- Block 30 (L4791): `M453~COL` Painted Platform Order Exit
- Block 31 (L4801): `M453~LAY` Deck Platform Order Exit
- Block 32 (L4811): `M453~MIR` Looking-glass Platform Order Exit
- Block 33 (L4821): `M029~ARM` Iron-clad Table Fence
- Block 34 (L4831): `M047~GRW` Sprouting Track Section
- Block 35 (L4841): `M453~CNT6` Last Call Platform Order Exit
- Block 36 (L4851): `M453~FRZ1` Snowbound Platform Order Exit
- Block 37 (L4861): `M034~FOG` Steamy Rotary Yard
- Block 39 (L4881): `M454~CHN` Linked Echo Signals
- Block 40 (L4891): `M454~PHS` Phantom Echo Signal
- Block 41 (L4901): `M454~COL` Painted Echo Signal
- Block 42 (L4911): `M454~LAY` Deck Echo Signal
- Block 43 (L4921): `M454~MIR` Looking-glass Echo Signal
- Block 44 (L4931): `M042~ARM` Iron-clad Water Tower
- Block 45 (L4941): `M010~GRW` Sprouting Steam Clouds
- Block 46 (L4951): `M454~CNT5` Last Call Echo Signal
- Block 47 (L4961): `M454~FRZ2` Snowbound Echo Signal
- Block 48 (L4971): `M454~FOG` Steamy Echo Signal
- Block 49 (L4981): `M454~ARM` Iron-clad Echo Signal

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/sequencing_modifier_rules.dart` (to be created)

## Risks
- Frustration from chained echo signals causing compounding sequence resets. Mitigated by validator ensuring generous fallback paths.

## Open Questions
- None. All 45 variant slot definitions match `phase/phase_10/04_VARIANTS_AND_MODIFIERS_PHASE_10.md` and `SCALING_TO_10000_LEVELS.md` §7.

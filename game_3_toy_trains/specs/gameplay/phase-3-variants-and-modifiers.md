Source docs: phase/phase_3/04_VARIANTS_AND_MODIFIERS_PHASE_3.md, ../../SCALING_TO_10000_LEVELS.md §7, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-3-base-mechanics.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 3 Variants & Modifiers

## Status
Draft

## Type
New Feature

## Goal
Specify the 10 standardized railway modifiers and the 45 variant slots for Phase 3 (Levels 1001–1500) of Toy Trains: Wooden Railway Puzzle, establishing procedural modifier rules, compatibility matrices, and JSON syntax.

## Current State
Design documented in `phase/phase_3/04_VARIANTS_AND_MODIFIERS_PHASE_3.md` and `../../SCALING_TO_10000_LEVELS.md` §7, not yet implemented.
- Phases 1 and 2 used explicit mechanic definitions without generalized combinatorial modifiers.
- Phase 3 introduces procedural composition: Base Mechanics × Standardized Modifiers, enabling 45 distinct variants in the 50-block rhythm.

## Proposed Change
Implement the modifier decoration engine in `packages/puzzle_core/lib/src/modifiers/`:

### 1. Ten Standard Railway Modifiers
| Modifier Tag | Themed Name | Gameplay Rule Specification | Valid Categories |
|---|---|---|---|
| `Frozen(K)` | Snowbound | Mechanism or train is frozen in ice; becomes active/interactive only after $K$ adjacent trains have departed. | T, C, D, G, P |
| `Colored` | Painted | Restricts interaction to matching train liveries; acts as solid blocker to all other colors. | D, G, L, T |
| `Fogged` | Steamy | Hidden beneath steam fog cloud (M010); revealed only when adjacent track is cleared. | All non-X |
| `Chained` | Linked | Mechanically coupled to a partner element; operating one triggers the partner simultaneously. | T, P, D |
| `Countdown(N)` | Last Call | State changes permanently after $N$ valid player Moves (gates close, helpers expire into blockers). | B, K, D, G, L |
| `Phasing` | Phantom | Materializes on even Move counts; transparent and intangible on odd Move counts. | B, D, T, G |
| `Armored` | Iron-clad | Immune to Track Crane (Hammer); must be solved purely via spatial path routing. | B, X, P |
| `Layered` | Deck | Elevated to Layer 1 or Layer 2; affects only trains traveling on that specific layer. | B, D, T, G, K |
| `Mirrored` | Looking-glass | Inverts departure vectors and turntable rotations across the vertical grid axis. | D, T, P |
| `Growing` | Sprouting | Expands by 1 wooden blocker crate into an adjacent empty track cell every $N$ Moves. | B, C |

### 2. Forty-Five Variant Slots Mapping (Blocks 3–49 x1)
Every block x1 without a new base mechanic hosts a designated Base × Modifier variant:
- Block 3 (L1021): `M001~CNT5` Last Call Buffer Stop
- Block 4 (L1031): `M002~FRZ2` Snowbound Cargo Crates
- Block 5 (L1041): `M005~COL` Painted Platform Gate
- Block 6 (L1051): `M007~FOG` Steamy Level Crossing
- Block 7 (L1061): `M009~CHN` Linked Signal Levers
- Block 8 (L1071): `M013~PHS` Phantom Turntable
- Block 9 (L1081): `M016~ARM` Iron-clad Rock Pile
- Block 10 (L1091): `M018~LAY` Deck Track Switch
- Block 11 (L1101): `M015~MIR` Looking-glass Overpass
- Block 12 (L1111): `M027~GRW` Sprouting Ivy Yard
- Block 13 (L1121): `M038~CNT6` Last Call Signal Gate
- Block 15 (L1141): `M013~FRZ1` Snowbound Turntable
- Block 16 (L1151): `M019~FOG` Steamy Weighbridge Plate
- Block 17 (L1161): `M018~CHN` Linked Track Switches
- Block 18 (L1171): `M020~PHS` Phantom Engine Shed
- Block 19 (L1181): `M030~COL` Painted Station Exit
- Block 20 (L1191): `M032~LAY` Deck Viaduct Crossing
- Block 21 (L1201): `M008~MIR` Looking-glass Tunnel
- Block 22 (L1211): `M025~ARM` Iron-clad Handcar Patrol
- Block 23 (L1221): `M002~GRW` Sprouting Cargo Depot
- Block 24 (L1231): `M102~CNT5` Last Call Day/Night Overpass
- Block 25 (L1241): `M101~FRZ2` Snowbound Day/Night Gate
- Block 27 (L1261): `M102~FOG` Steamy Day/Night Overpass
- Block 28 (L1271): `M101~CHN` Linked Day/Night Gates
- Block 29 (L1281): `M101~PHS` Phantom Day/Night Gate
- Block 30 (L1291): `M103~COL` Painted Tunnel Portal
- Block 31 (L1301): `M103~LAY` Deck Day/Night Tunnel
- Block 32 (L1311): `M101~MIR` Looking-glass Day/Night Gate
- Block 33 (L1321): `M029~ARM` Iron-clad Table Fence
- Block 34 (L1331): `M047~GRW` Sprouting Track Section
- Block 35 (L1341): `M103~CNT6` Last Call Day/Night Tunnel
- Block 36 (L1351): `M103~FRZ1` Snowbound Day/Night Tunnel
- Block 37 (L1361): `M034~FOG` Steamy Rotary Yard
- Block 39 (L1381): `M102~CHN` Linked Day/Night Overpasses
- Block 40 (L1391): `M103~PHS` Phantom Day/Night Tunnel
- Block 41 (L1401): `M104~COL` Painted Day/Night Livery
- Block 42 (L1411): `M104~LAY` Deck Day/Night Livery
- Block 43 (L1421): `M102~MIR` Looking-glass Day/Night Overpass
- Block 44 (L1431): `M042~ARM` Iron-clad Water Tower
- Block 45 (L1441): `M010~GRW` Sprouting Steam Clouds
- Block 46 (L1451): `M104~CNT5` Last Call Day/Night Livery
- Block 47 (L1461): `M104~FRZ2` Snowbound Day/Night Livery
- Block 48 (L1471): `M104~FOG` Steamy Day/Night Livery
- Block 49 (L1481): `M104~CHN` Linked Day/Night Liveries

## Affected Files
- `packages/puzzle_core/lib/src/modifiers/modifier.dart` (to be created)
- `packages/puzzle_core/lib/src/modifiers/modifier_registry.dart` (to be created)

## Risks
- Combinatorial deadlocks if incompatible modifiers are generated together. Mitigation: Modifier compatibility matrix enforces category validity rules.

## Open Questions
- None. All 10 modifiers and 45 slot mappings match `phase/phase_3/04_VARIANTS_AND_MODIFIERS_PHASE_3.md` and `SCALING_TO_10000_LEVELS.md` §7.


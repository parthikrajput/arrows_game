Source docs: phase_3/02_LEVEL_PLAN_1001_1500.md, ../../SCALING_TO_10000_LEVELS.md §3.5, §6, ../../SHARED_CORE_STANDARD.md §9, §11, §17.38. Depends on: specs/gameplay/level-progression-0501-1000.md.

# Spec: Gameplay — Phase 3 Level Plan (Levels 1001–1500)

## Status
Draft

## Type
Improvement (extends level progression into the on-device generated plateau tier P3-A/P3-B)

## Goal
Specify the slot mapping, tier boundaries, difficulty plateau targets (D 60–76), generation parameter constraints, review level, and Phase 3 Finale for Levels 1001 to 1500.

## Current State
Design documented in `phase_3/02_LEVEL_PLAN_1001_1500.md`, `SCALING_TO_10000_LEVELS.md` §3.5, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 2 concluded at Level 1000 with tier P2-B climbing to D 70.
- Phase 3 initiates the on-device deterministic generation plateau spanning Levels 1001 to 1500.

## Proposed Change
Configure generator slot profiles and progression models for Phase 3:

### 1. Difficulty Plateau Architecture (standard §17.24)
- **Fixed Plateau Band:** D band is strictly **60 to 76** across all 50 blocks. Difficulty increases through system mechanics and modifier depth rather than unplayable board density.
- **x9 Hard Multiplier:** Slot `x9` levels target `bandMax * 1.1` ≈ **84**.
- **Phase Finale Multiplier:** Level 1500 targets `bandMax * 1.2` ≈ **91**.

### 2. Tier Breakdown & Biomes
| Tier | Levels | Biome | Tint Token | Grid Size | Snakes ($P$) | Max Obstacles ($O$) | D Band |
|---|---|---|---|---|---|---|---|
| **P3-A** | 1001–1250 | Twilight Grove | `#F3E5F5` | 12×12–13×13 | 28–34 | 8–12 | 60–68 |
| **P3-B** | 1251–1500 | Midnight Canopy | `#EDE7F6` | 13×13–14×14 | 32–40 | 10–14 | 66–76 |

### 3. Slot Map Architecture (50 Blocks × 10 Levels)
- **Block 1 x1 (L1001):** Signature System Intro — Day & Night Garden (Sun/Moon Dial HUD).
- **Block 2 x1 (L1011):** Base Mechanic 1 Intro — M101 Sun-Moon Gate.
- **Block 14 x1 (L1131):** Base Mechanic 2 Intro — M102 Moonlight Root Bridge.
- **Block 26 x1 (L1251):** Base Mechanic 3 Intro — M103 Day-Night Burrows.
- **Block 38 x1 (L1371):** Base Mechanic 4 Intro — M104 Twilight Flower Gate.
- **45 Variant Slots:** `x1` slots of remaining blocks (3–13, 15–25, 27–37, 39–49).
- **Block 50 x1 (L1491):** Review Level ("Mastery Mix") — synthesizes Cycles with M101–M104 (no new mechanic or variant).
- **Block 50 x0 (L1500):** Phase 3 Finale — "Day & Night Temple".

### 4. Phase 3 Finale: Level 1500 ("Day & Night Temple")
- **Grid:** 14×14 grid, 3 layers.
- **Paths:** 38 snakes.
- **Mechanics:** M101 (Sun-Moon Gate) ×2, M102 (Moonlight Bridge) ×2, M103 (Day-Night Burrows) ×1 pair, M104 (Twilight Flower Gate) ×2, M098 (Prowling Mongoose) ×1, M053 (Rolling Coconut) ×2.
- **Difficulty:** Target D ≈ 91.
- **Reward Sequence:** Jungle Treasure Chest (1,000 coins + 2 of each booster + Phase 3 Master Badge) -> Golden Slither Rush #20 -> Phase 3 Complete celebration.

## Affected Files
- `packages/puzzle_core/lib/src/generator/slot_profiles/phase_3_slots.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/biome_config.dart` (added Twilight Grove and Midnight Canopy)
- `lib/features/map/presentation/widgets/phase_3_map_section.dart` (to be created)

## Risks
- Low-end device memory pressure on 14x14 boards in P3-B tier. Guarded by fitCell >= 22 dp and picture caching rules.

## Open Questions
- None. Slot mappings, biome tints, and plateau bands strictly follow `SHARED_CORE_STANDARD.md` §11 and §17.38.

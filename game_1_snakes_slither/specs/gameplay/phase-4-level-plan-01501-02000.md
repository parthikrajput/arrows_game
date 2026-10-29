Source docs: phase_4/02_LEVEL_PLAN_1501_2000.md, phase_4/01_PHASE_4_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3.5, §6, ../../SHARED_CORE_STANDARD.md §9, §11, §17.24, §17.38. Depends on: specs/gameplay/phase-3-level-plan-01001-01500.md, specs/gameplay/phase-4-signature-system.md, specs/gameplay/phase-4-base-mechanics.md.

# Spec: Gameplay — Phase 4 Level Plan (Levels 1501–2000)

## Status
Draft

## Type
Improvement (extends level progression and slot architecture into Levels 1501–2000)

## Goal
Specify the slot mapping, tier boundaries (P4-A / P4-B), difficulty plateau targets (D 60–76), grid sizes, path counts, review level (L1991), and Phase 4 Finale (L2000 "Great Tree Canopy Crown") across Levels 1501 to 2000.

## Current State
Design documented in `phase_4/02_LEVEL_PLAN_1501_2000.md`, `SCALING_TO_10000_LEVELS.md` §3.5, §6, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 3 covered Levels 1001–1500 ending at L1500 "Day & Night Temple".
- Phase 4 governs the second 500-level plateau section spanning Levels 1501 to 2000.

## Proposed Change
Implement the generator slot configuration, tier definitions, and progression parameters for Phase 4:

### 1. Difficulty Plateau Architecture (Standard §17.24)
- **Fixed Plateau Band:** Target difficulty $D$ remains strictly **60 to 76** across all blocks. Complexity arises from multi-floor routing and modifier combinations rather than inflated board dimensions.
- **x9 Hard Multiplier:** Slot `x9` levels target `bandMax * 1.1` ≈ **84**.
- **Phase Finale Multiplier:** Level 2000 targets `bandMax * 1.2` ≈ **91**.

### 2. Tier Breakdown & Biomes
| Tier | Levels | Biome Name | Tint Token | Grid Size per Floor | Floors | Snakes ($P$) | Obstacles ($O$) | D Band |
|---|---|---|---|---|---|---|---|---|
| **P4-A** | 1501–1750 | Giant Root Cavern | `#EFEBE9` | 12×12–13×13 | 2 floors | 28–34 | 8–12 | 60–68 |
| **P4-B** | 1751–2000 | Cloud Canopy Terrace | `#E0F7FA` | 13×13–14×14 | 2–3 floors | 32–40 | 10–14 | 66–76 |

### 3. 50-Block Structure & Slot Mapping (Standard §17.38)
- **Block 1 x1 (L1501):** Signature System Intro — Great Tree Floors & Floor Tabs HUD ($D = 60.5$).
- **Block 2 x1 (L1511):** Base Mechanic 1 Intro — M151 Root Stairs ($D = 61.0$).
- **Block 14 x1 (L1631):** Base Mechanic 2 Intro — M152 Dewglass Floor ($D = 63.0$).
- **Block 26 x1 (L1751):** Base Mechanic 3 Intro — M153 Knot Hole ($D = 65.0$).
- **Block 38 x1 (L1871):** Base Mechanic 4 Intro — M154 Vine Lift ($D = 67.0$).
- **45 Variant Slots:** `x1` slots of blocks 3–13, 15–25, 27–37, 39–49 (and block 49 x5 / L1985 for V45).
- **Block 50 x1 (L1991):** Review Level ("Mastery Mix") — synthesizes multi-floor puzzles with M151–M154 with no new item ($D = 71.0$).
- **Block 50 x0 (L2000):** Phase 4 Finale — "Great Tree Canopy Crown" ($D \approx 91.0$).

### 4. 10-Level Block Internal Cadence (Standard §9.2)
Every 10-level block $N1\dots N0$ (e.g. 1511–1520) follows the standard role distribution:
- `x1`: Intro level (Band Low)
- `x2–x4`: Practice levels (Low → Mid)
- `x5`: Breather level (Tag Easy, 15 coins reward)
- `x6–x8`: Ramp levels (Mid → High)
- `x9`: Hard level (Red badge, High +10%, Tag Hard, 30 coins reward)
- `x0`: Milestone level (Gift Basket, Tag Normal, 20 coins reward)

### 5. Phase 4 Finale: Level 2000 ("Great Tree Canopy Crown")
- **Floors:** 3 stacked floors (F1 Giant Root Cavern, F2 Tree Trunk, F3 Cloud Canopy Terrace).
- **Grid Dimensions:** 14×14 per floor.
- **Paths ($P$):** 40 total snakes distributed across all 3 floors.
- **Mechanics Composition:**
  - M151 Root Stairs × 2 pairs
  - M152 Dewglass Floor × 4 cells
  - M153 Knot Hole × 2 instances
  - M154 Vine Lift × 2 platforms
  - M098 Prowling Mongoose × 1 guardian
- **Difficulty:** Target $D \approx 91.0$.
- **Reward Sequence:**
  1. Jungle Treasure Chest (1,000 coins + 2 Hint + 2 Shield + 2 Hammer + Phase 4 Master Badge).
  2. Golden Slither Rush #40 unlocked.
  3. Phase 4 Complete cinematic celebration.

## Affected Files
- `packages/puzzle_core/lib/src/generator/slot_profiles/phase_4_slots.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/biome_config.dart` (register Giant Root Cavern and Cloud Canopy Terrace)
- `lib/features/map/presentation/widgets/phase_4_map_section.dart` (to be created)

## Risks
- Board rendering memory footprint on 3 stacked 14×14 grids. Guarded by off-screen floor static layer picture caching and zoom fitCell $\ge 22\text{ dp}$.

## Open Questions
- None. Level ranges, slot mappings, difficulty targets, and tier parameters strictly follow `phase_4/02_LEVEL_PLAN_1501_2000.md` and `SHARED_CORE_STANDARD.md` §11.

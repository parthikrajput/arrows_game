Source docs: phase_5/02_LEVEL_PLAN_2001_2500.md, phase_5/01_PHASE_5_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3.5, §6, ../../SHARED_CORE_STANDARD.md §9, §11, §17.24, §17.38. Depends on: specs/gameplay/phase-4-level-plan-01501-02000.md, specs/gameplay/phase-5-signature-system.md, specs/gameplay/phase-5-base-mechanics.md.

# Spec: Gameplay — Phase 5 Level Plan (Levels 2001–2500)

## Status
Draft

## Type
Improvement (extends level progression and slot architecture into Levels 2001–2500)

## Goal
Specify the slot mapping, tier boundaries (P5-A / P5-B), difficulty plateau targets (D 60–76), grid sizes, path counts, review level (L2491), and Phase 5 Finale (L2500 "Ancient Coconut Shrine") across Levels 2001 to 2500.

## Current State
Design documented in `phase_5/02_LEVEL_PLAN_2001_2500.md`, `SCALING_TO_10000_LEVELS.md` §3.5, §6, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 4 concluded at Level 2000 with "Great Tree Canopy Crown".
- Phase 5 governs the third 500-level plateau section spanning Levels 2001 to 2500.

## Proposed Change
Implement the generator slot configuration, tier definitions, and progression parameters for Phase 5:

### 1. Difficulty Plateau Architecture (Standard §17.24)
- **Fixed Plateau Band:** Target difficulty $D$ remains strictly **60 to 76** across all blocks. Complexity arises from push routing, sliding inertia, and pit filling rather than arbitrary density inflation.
- **x9 Hard Multiplier:** Slot `x9` levels target `bandMax * 1.1` ≈ **84**.
- **Phase Finale Multiplier:** Level 2500 targets `bandMax * 1.2` ≈ **91**.

### 2. Tier Breakdown & Biomes
| Tier | Levels | Biome Name | Tint Token | Grid Size | Snakes ($P$) | Obstacles ($O$) | D Band |
|---|---|---|---|---|---|---|---|
| **P5-A** | 2001–2250 | Coconut Grove Oasis | `#FFF8E1` | 12×12–13×13 | 28–34 | 8–12 | 60–68 |
| **P5-B** | 2251–2500 | Sunken Stone Shrine | `#EFEBE9` | 13×13–14×14 | 32–40 | 10–14 | 66–76 |

### 3. 50-Block Structure & Slot Mapping (Standard §17.38)
- **Block 1 x1 (L2001):** Signature System Intro — Coconut Grove Physics (Push Mechanics) ($D = 60.5$).
- **Block 2 x1 (L2011):** Base Mechanic 1 Intro — M201 Coconut Pit ($D = 61.0$).
- **Block 14 x1 (L2131):** Base Mechanic 2 Intro — M202 Dew-Slick Coconut ($D = 63.0$).
- **Block 26 x1 (L2251):** Base Mechanic 3 Intro — M203 Key Coconut ($D = 65.0$).
- **Block 38 x1 (L2371):** Base Mechanic 4 Intro — M204 Jackfruit Boulder ($D = 67.0$).
- **45 Variant Slots:** `x1` slots of blocks 3–13, 15–25, 27–37, 39–49 (and block 49 x5 / L2485 for V45).
- **Block 50 x1 (L2491):** Review Level ("Mastery Mix") — synthesizes push physics with M201–M204 with no new item ($D = 71.0$).
- **Block 50 x0 (L2500):** Phase 5 Finale — "Ancient Coconut Shrine" ($D \approx 91.0$).

### 4. 10-Level Block Internal Cadence (Standard §9.2)
Every 10-level block $N1\dots N0$ (e.g. 2011–2020) follows the standard role distribution:
- `x1`: Intro level (Band Low)
- `x2–x4`: Practice levels (Low → Mid)
- `x5`: Breather level (Tag Easy, 15 coins reward)
- `x6–x8`: Ramp levels (Mid → High)
- `x9`: Hard level (Red badge, High +10%, Tag Hard, 30 coins reward)
- `x0`: Milestone level (Gift Basket, Tag Normal, 20 coins reward)

### 5. Phase 5 Finale: Level 2500 ("Ancient Coconut Shrine")
- **Grid Dimensions:** 14×14 grid.
- **Paths ($P$):** 40 total snakes.
- **Mechanics Composition:**
  - M201 Coconut Pit × 4 instances
  - M202 Dew-Slick Coconut × 3 instances
  - M203 Key Coconut × 2 instances + matching gate locks
  - M204 Jackfruit Boulder × 2 instances
  - M098 Prowling Mongoose × 1 guardian
- **Difficulty:** Target $D \approx 91.0$.
- **Reward Sequence:**
  1. Jungle Treasure Chest (1,000 coins + 2 Hint + 2 Shield + 2 Hammer + Phase 5 Master Badge).
  2. Golden Slither Rush #60 unlocked.
  3. Phase 5 Complete cinematic celebration.

## Affected Files
- `packages/puzzle_core/lib/src/generator/slot_profiles/phase_5_slots.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/biome_config.dart` (register Coconut Grove Oasis and Sunken Stone Shrine)
- `lib/features/map/presentation/widgets/phase_5_map_section.dart` (to be created)

## Risks
- Puzzle solver complexity on 14×14 boards with multiple sliding blocks and pit transformations. Guarded by IDA* node limit of 2M (CI) and reverse-construction guarantees.

## Open Questions
- None. Level ranges, slot mappings, difficulty targets, and tier parameters strictly follow `phase_5/02_LEVEL_PLAN_2001_2500.md` and `SHARED_CORE_STANDARD.md` §11.

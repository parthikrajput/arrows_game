Source docs: phases/phase_8/02_LEVEL_PLAN_3501_4000.md, phases/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §9, §11, §17.24, §17.38, ../../SCALING_TO_10000_LEVELS.md §3, §6. Depends on: specs/gameplay/phase-8-signature-system.md, specs/gameplay/phase-8-base-mechanics.md, specs/gameplay/phase-7-level-plan-03001-03500.md.

# Spec: Gameplay — Phase 8 Level Progression Plan (Levels 3501–4000)

## Status
Draft

## Type
New Feature

## Goal
Define the 50-block level progression plan, difficulty plateau calibration ($D \in [60, 76]$), tier boundaries (P8-A and P8-B), intro slots, variant placement, review level, and Phase Finale for Levels 3501–4000.

## Current State
Design documented in `phases/phase_8/02_LEVEL_PLAN_3501_4000.md` and `SCALING_TO_10000_LEVELS.md` §3 & §6, not yet implemented.
- Phase 7 covered Levels 3001–3500 (Whirlwind Valley).
- Phase 8 covers Levels 3501–4000, introducing organic growth expansion, pruning clearing, and seed-dropping snakes.

## Proposed Change
Implement the Phase 8 level generation slot mappings and validator rules in `packages/puzzle_core/lib/src/generator/`:

### 1. 50-Block Slot Architecture (Standard §17.38)
- **Total Levels:** 500 levels organized into 50 contiguous 10-level blocks.
- **Slot Roles per 10-Level Block:**
  - `x1`: New Intro Mechanic OR Variant Slot.
  - `x2–x4`: Core practice, route finding, and growth containment.
  - `x5`: Breather Level ($D \le 64$, relaxed density, 0-heart accessible).
  - `x6–x8`: Multi-element complexity scaling (vines + shears + earlier mechanics).
  - `x9`: Hard Challenge Level ($D \approx 72–76$, tight weed control windows).
  - `x0`: Milestone Level ($D \approx 70–74$) awarding the Jungle Gift Basket.

---

### 2. Tier Breakdown & Board Parameters

| Tier | Level Range | Grid Size Range | Snake Count | Obstacle Count | Target Difficulty ($D$) |
|---|---|---|---|---|---|
| **Tier P8-A** | L3501–3750 | 12×12 to 13×13 | 28–34 snakes | 8–11 instances | $D \in [60, 74]$ |
| **Tier P8-B** | L3751–4000 | 13×13 to 14×14 | 32–40 snakes | 10–14 instances | $D \in [64, 76]$ |
| **Finale** | L4000 | 14×14 | 38 snakes | 14 instances | $D \approx 91$ |

---

### 3. Key Milestone & Intro Slots

- **L3501 (Block 1 x1):** Signature System Intro — Overgrown Garden (basic vine sprawl and containment).
- **L3510 (Block 1 x0):** First Phase 8 Gift Basket (300 coins + Hint booster).
- **L3511 (Block 2 x1):** Intro M351 Wild Vine.
- **L3525 (Rush #1):** First Phase 8 Golden Slither Rush (30s bonus round).
- **L3631 (Block 14 x1):** Intro M352 Pruning Shears Tile.
- **L3751 (Block 26 x1):** Intro M353 Seed-Carrier Snake.
- **L3871 (Block 38 x1):** Intro M354 Bloom Gate.
- **L3991 (Block 50 x1):** Mastery Mix (Comprehensive review synthesizing all 4 growth mechanics; no new items).
- **L4000 (Block 50 x0):** Phase Finale — "Heart of the Overgrowth" + Phase Chest unbox.

---

### 4. Difficulty Plateau Pacing ($D \in [60, 76]$)
- Governed strictly by the standard difficulty formula:
  $$D = 0.35 \times \text{DecisionDensity} + 0.25 \times \text{InterlockFactor} + 0.20 \times \text{FailurePenalty} + 0.20 \times \text{SpatialTightness}$$
- Growth adds dynamic spatial tightness over time, requiring players to plan pruning actions early while maintaining puzzle solving flow.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_8_slot_map.dart` — to be created
- `packages/puzzle_core/lib/src/generator/level_generator.dart` — changed

## Risks and Open Questions
- **Uncontrolled Sprawl in High Difficulty Blocks:** In Blocks 40–49, aggressive vine growth could choke exit lanes.
  - *Mitigation:* Cap total vine segments at 8 cells per level; every level with M351 must provide at least 1 reachable M352 Pruner Tile.


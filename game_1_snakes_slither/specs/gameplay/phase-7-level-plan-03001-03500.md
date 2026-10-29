Source docs: phases/phase_7/02_LEVEL_PLAN_3001_3500.md, phases/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §9, §11, §17.24, §17.38, ../../SCALING_TO_10000_LEVELS.md §3, §6. Depends on: specs/gameplay/phase-7-signature-system.md, specs/gameplay/phase-7-base-mechanics.md, specs/gameplay/phase-6-level-plan-02501-03000.md.

# Spec: Gameplay — Phase 7 Level Progression Plan (Levels 3001–3500)

## Status
Draft

## Type
New Feature

## Goal
Define the 50-block level progression plan, difficulty plateau calibration ($D \in [60, 76]$), tier boundaries (P7-A and P7-B), intro slots, variant placement, review level, and Phase Finale for Levels 3001–3500.

## Current State
Design documented in `phases/phase_7/02_LEVEL_PLAN_3001_3500.md` and `SCALING_TO_10000_LEVELS.md` §3 & §6, not yet implemented.
- Phase 6 covered Levels 2501–3000 (Sun Temple Light).
- Phase 7 covers Levels 3001–3500, introducing rotational sub-grids and shifting border mechanics.

## Proposed Change
Implement the Phase 7 level generation slot mappings and validator rules in `packages/puzzle_core/lib/src/generator/`:

### 1. 50-Block Slot Architecture (Standard §17.38)
- **Total Levels:** 500 levels organized into 50 contiguous 10-level blocks.
- **Slot Roles per 10-Level Block:**
  - `x1`: New Intro Mechanic OR Variant Slot.
  - `x2–x4`: Core practice, route finding, and turn timing.
  - `x5`: Breather Level ($D \le 64$, relaxed density, 0-heart accessible).
  - `x6–x8`: Multi-element complexity scaling (rotors + earlier mechanics).
  - `x9`: Hard Challenge Level ($D \approx 72–76$, tight rotational sequences).
  - `x0`: Milestone Level ($D \approx 70–74$) awarding the Jungle Gift Basket.

---

### 2. Tier Breakdown & Board Parameters

| Tier | Level Range | Grid Size Range | Snake Count | Obstacle Count | Target Difficulty ($D$) |
|---|---|---|---|---|---|
| **Tier P7-A** | L3001–3250 | 12×12 to 13×13 | 28–34 snakes | 8–11 instances | $D \in [60, 74]$ |
| **Tier P7-B** | L3251–3500 | 13×13 to 14×14 | 32–40 snakes | 10–14 instances | $D \in [64, 76]$ |
| **Finale** | L3500 | 14×14 | 38 snakes | 14 instances | $D \approx 91$ |

---

### 3. Key Milestone & Intro Slots

- **L3001 (Block 1 x1):** Signature System Intro — Whirlwind Valley (introducing basic 4×4 sub-board rotation).
- **L3010 (Block 1 x0):** First Phase 7 Gift Basket (300 coins + Hint booster).
- **L3011 (Block 2 x1):** Intro M301 Island Spinner.
- **L3025 (Rush #1):** First Phase 7 Golden Slither Rush (30s bonus round).
- **L3131 (Block 14 x1):** Intro M302 Turning Hedges (shifting perimeter wall).
- **L3251 (Block 26 x1):** Intro M303 Spinning Snake (auto-rotating snake direction).
- **L3371 (Block 38 x1):** Intro M304 Gear Lock (rotor-coupled gate).
- **L3491 (Block 50 x1):** Mastery Mix (Comprehensive review synthesizing all 4 rotation mechanics; no new items).
- **L3500 (Block 50 x0):** Phase Finale — "Whirlwind Summit Shrine" + Phase Chest unbox.

---

### 4. Difficulty Plateau Pacing ($D \in [60, 76]$)
- Governed strictly by the standard difficulty formula:
  $$D = 0.35 \times \text{DecisionDensity} + 0.25 \times \text{InterlockFactor} + 0.20 \times \text{FailurePenalty} + 0.20 \times \text{SpatialTightness}$$
- Rotational moves require anticipatory planning (e.g. visualizing snake heading after two 90° turns), creating rich intellectual depth without inflating numbers or timing pressure.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_7_slot_map.dart` — to be created
- `packages/puzzle_core/lib/src/generator/level_generator.dart` — changed

## Risks and Open Questions
- **Straddle Trap Generation:** Procedural generation could inadvertently place snakes across the 4×4 boundary in an un-slitherable arrangement, locking the rotor indefinitely.
  - *Validator Invariant:* CI generator asserts that in any state where the rotor is straddled, the straddling snake has an immediately unobstructed exit lane or valid step to clear the rotor boundary.


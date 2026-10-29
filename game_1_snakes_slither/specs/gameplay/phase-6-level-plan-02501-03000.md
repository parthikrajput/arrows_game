Source docs: phases/phase_6/02_LEVEL_PLAN_2501_3000.md, phases/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §9, §11, §17.24, §17.38, ../../SCALING_TO_10000_LEVELS.md §3, §6. Depends on: specs/gameplay/phase-6-signature-system.md, specs/gameplay/phase-6-base-mechanics.md, specs/gameplay/phase-5-level-plan-02001-02500.md.

# Spec: Gameplay — Phase 6 Level Progression Plan (Levels 2501–3000)

## Status
Draft

## Type
New Feature

## Goal
Define the 50-block level progression architecture, difficulty plateau pacing ($D \in [60, 76]$), tier boundaries (P6-A and P6-B), intro slots, variant placement, review level, and Phase Finale for Levels 2501–3000.

## Current State
Design documented in `phases/phase_6/02_LEVEL_PLAN_2501_3000.md` and `SCALING_TO_10000_LEVELS.md` §3 & §6, not yet implemented.
- Phase 5 covered Levels 2001–2500.
- Phase 6 covers Levels 2501–3000, utilizing on-device procedural generation from pre-validated deterministic seeds.

## Proposed Change
Implement the Phase 6 level generation slot mappings and validator rules in `packages/puzzle_core/lib/src/generator/`:

### 1. 50-Block Slot Architecture (Standard §17.38)
- **Total Levels:** 500 levels arranged into 50 contiguous 10-level blocks.
- **Slot Roles per 10-Level Block:**
  - `x1`: New Intro Mechanic OR Variant Slot.
  - `x2–x4`: Core practice and progressive routing.
  - `x5`: Breather Level ($D \le 64$, relaxed density, 0-heart accessible).
  - `x6–x8`: Multi-element complexity scaling.
  - `x9`: Hard Challenge Level ($D \approx 72–76$, tight tolerances).
  - `x0`: Milestone Level ($D \approx 70–74$) awarding the Jungle Gift Basket.

### 2. Tier Breakdown & Board Parameters

| Tier | Level Range | Grid Size Range | Snake Count | Obstacle Count | Target Difficulty ($D$) |
|---|---|---|---|---|---|
| **Tier P6-A** | L2501–2750 | 12×12 to 13×13 | 28–34 snakes | 8–11 instances | $D \in [60, 74]$ |
| **Tier P6-B** | L2751–3000 | 13×13 to 14×14 | 32–40 snakes | 10–14 instances | $D \in [64, 76]$ |
| **Finale** | L3000 | 14×14 | 38 snakes | 14 instances | $D \approx 91$ |

### 3. Key Milestone & Intro Slots

- **L2501 (Block 1 x1):** Signature System Intro — Sun Temple Light (introducing basic ray casting and reflection).
- **L2510 (Block 1 x0):** First Phase 6 Gift Basket (300 coins + Hint booster).
- **L2511 (Block 2 x1):** Intro M251 Petal Filter (Ruby wavelength).
- **L2525 (Rush #1):** First Phase 6 Golden Slither Rush (30s bonus round).
- **L2631 (Block 14 x1):** Intro M252 Prism Lock (2-beam convergence).
- **L2751 (Block 26 x1):** Intro M253 Sundial Receiver (3 consecutive moves).
- **L2871 (Block 38 x1):** Intro M254 Shade Leaves (dark cell waking).
- **L2991 (Block 50 x1):** Mastery Mix (Comprehensive review synthesizing all 4 mechanics; no new items).
- **L3000 (Block 50 x0):** Phase Finale — "Sun Temple Grand Sanctum" + Phase Chest unbox.

### 4. Difficulty Plateau Pacing ($D \in [60, 76]$)
- Difficulty is computed per formula in `SCALING_TO_10000_LEVELS.md §3`:
  $$D = 0.35 \times \text{DecisionDensity} + 0.25 \times \text{InterlockFactor} + 0.20 \times \text{FailurePenalty} + 0.20 \times \text{SpatialTightness}$$
- Levels remain within $D \in [60, 76]$, preventing difficulty inflation while introducing cognitive variety through optics.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_6_slot_map.dart` — to be created
- `packages/puzzle_core/lib/src/generator/level_generator.dart` — changed

## Risks and Open Questions
- **14×14 Viewport Density:** On smaller mobile screens (360 dp width), 14×14 grids require pinch-to-zoom and fluid drag panning.
  - *Standard Check:* Handled cleanly by Phase 2 viewport navigation module (`specs/tech/frontend-and-qa-phase-2.md`).

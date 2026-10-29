Source docs: phases/phase_12/02_LEVEL_PLAN_5501_6000.md, phases/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §17.38, ../../SCALING_TO_10000_LEVELS.md §3.5, §6. Depends on: specs/gameplay/phase-12-signature-system.md, specs/gameplay/phase-12-base-mechanics.md, specs/gameplay/phase-12-variants-and-modifiers.md.

# Spec: Gameplay — Phase 12 Level Plan (Levels 5501–6000)

## Status
Draft

## Type
New Feature

## Goal
Establish the comprehensive level generation roadmap, difficulty distribution, slot allocation, and milestone architecture for Phase 12 (Levels 5501 to 6000) across 50 10-level blocks.

## Current State
Design documented in `phases/phase_12/02_LEVEL_PLAN_5501_6000.md`, `phases/phase_12/01_PHASE_12_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §3.5, §6, not yet implemented.
- Spans Blocks 551 to 600 (50 blocks total, 500 levels).
- Reaches the 6,000-level project milestone.
- Difficulty conforms to the fixed plateau band $D \in [60, 76]$, featuring $D \approx 82\text{--}85$ block hard peaks and the $D \approx 91$ Grand Finale at Level 6000.

## Proposed Change
Implement the procedural generator configuration and seed rules in `packages/puzzle_core/lib/src/generator/phase_12/`:

### 1. 50-Block Macro Layout
- **Block 551 (5501–5510):** Signature System Intro (*Monsoon Breeze*).
- **Block 552 (5511–5520):** M551 Wind Lever Intro (L5511 x1).
- **Blocks 553–563 (5521–5630):** Variants V01 to V11 (M551 variations).
- **Block 564 (5631–5640):** M552 Falling Fruit Intro (L5631 x1).
- **Blocks 565–575 (5641–5750):** Variants V12 to V22 (M552 variations).
- **Block 576 (5751–5760):** M553 Floaty Lily Intro (L5751 x1).
- **Blocks 577–587 (5761–5870):** Variants V23 to V33 (M553 variations).
- **Block 588 (5871–5880):** M554 Heavy Python Intro (L5871 x1).
- **Blocks 589–599 (5881–5990):** Variants V34 to V44 (M554 variations).
- **Block 600 (5991–6000):** Mastery Mix Review (L5991), Variant 45 (L5995), and Grand Finale (L6000).

---

### 2. Standard 10-Level Block Template
Each block of 10 levels adheres strictly to the standardized cadence:
- **x1 (Feature / Variant Intro):** $D \in [60, 64]$. Pristine introduction of new mechanic/modifier with zero clutter.
- **x2 (Standard Easy):** $D \in [60, 62]$. Basic practice and pattern reinforcement.
- **x3 (Standard Normal):** $D \in [63, 66]$. Minor obstacle combination with dynamic gravity.
- **x4 (Easy Breather):** $D \in [61, 63]$. Low-stress flow level with clear egress.
- **x5 (Standard Normal):** $D \in [65, 68]$. 2–3 snake coordination around falling fruits.
- **x6 (Mid Normal):** $D \in [67, 70]$. Tight corridor turns and spatial contention.
- **x7 (Upper Normal):** $D \in [69, 72]$. Dynamic lever rotation and gravity path clearing.
- **x8 (High Normal):** $D \in [72, 75]$. Whole-board synchronization across multiple physics shifts.
- **x9 (Hard Level):** $D \in [82, 85]$. High constraint requiring deterministic planning.
- **x0 (Milestone Gate):** $D \in [70, 74]$. Milestone level awarding Gift Basket (300 coins + cycling booster).

---

### 3. Tiers, Board Dimensions, and Parameters
- **Tier P12-A (Levels 5501–5750 — Monsoon Canopy):**
  - Grid: $12 \times 12$ to $13 \times 13$.
  - Snakes: 28 to 34 initial snakes.
  - Falling Fruits: 4 to 8 instances; 1 M551 Wind Lever.
  - Background: `#E0F2F1` (Monsoon Canopy).
- **Tier P12-B (Levels 5751–6000 — Storm Ridge):**
  - Grid: $13 \times 13$ to $14 \times 14$.
  - Snakes: 32 to 42 initial snakes.
  - Falling Fruits: 8 to 15 instances; up to 2 levers + M553 Lilies + M554 Pythons.
  - Background: `#B2DFDB` (Storm Ridge).

---

### 4. Curated Hand-Tuned Key Levels
1. **L5501 (Monsoon Breeze):** Introduction to downward gravity arrow and initial fruit settling ($D = 60$).
2. **L5511 (M551 Tutorial):** First interactive tutorial on tapping the Wind Lever to rotate gravity $90^\circ$ CW ($D = 61$).
3. **L5631 (M552 Tutorial):** Demonstrates falling fruits filling vacancies and opening exit routes ($D = 62$).
4. **L5751 (M553 Tutorial):** Demonstration of Floaty Lily suspending a fruit above an active snake corridor ($D = 63$).
5. **L5871 (M554 Tutorial):** Demonstrates Heavy Python autonomously sliding downward to clear a path ($D = 64$).
6. **L5959 (Hard Peak):** 4 wind levers, 8 falling fruits, and 2 heavy pythons on a $14 \times 14$ grid ($D = 85$).
7. **L5991 (Review Level — Mastery Mix):** Harmonious combination of M551, M552, M553, and M554 ($D = 75$).
8. **L6000 (Grand Finale — Eye of the Monsoon):** Epic 42-snake masterpiece featuring 360-degree rotating monsoon winds and cascading obstacles ($D = 91$).

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_12/phase_12_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_12/phase_12_level_plan.dart` (to be created)
- `assets/levels/phase_12_hand_tuned.json` (to be created)
- `test/generator/phase_12_plan_test.dart` (to be created)

## Risks and Open Questions
- **Move Budget Calibration on Lever Levels:** Rotating the wind lever consumes a move. Level move limits must account for required lever taps ($+3\text{--}6$ bonus moves) to ensure players are not penalized for necessary gravity shifts.

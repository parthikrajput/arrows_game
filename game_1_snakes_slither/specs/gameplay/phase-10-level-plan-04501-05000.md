Source docs: phases/phase_10/02_LEVEL_PLAN_4501_5000.md, phases/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §17.38, ../../SCALING_TO_10000_LEVELS.md §3.5, §6. Depends on: specs/gameplay/phase-10-signature-system.md, specs/gameplay/phase-10-base-mechanics.md, specs/gameplay/phase-10-variants-and-modifiers.md.

# Spec: Gameplay — Phase 10 Level Plan (Levels 4501–5000)

## Status
Draft

## Type
New Feature

## Goal
Establish the comprehensive level generation roadmap, difficulty distribution, block architecture, and milestone pacing for Phase 10 (Levels 4501 to 5000), culminating in the historic Level 5,000 Grand Halfway Finale.

## Current State
Design documented in `phases/phase_10/02_LEVEL_PLAN_4501_5000.md`, `phases/phase_10/01_PHASE_10_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §3.5, §6, not yet implemented.
- Spans Blocks 451 to 500 (50 blocks total, 500 levels).
- Reaches the exact midpoint of the 10,000-level project journey.
- Difficulty conforms to the fixed plateau band $D \in [60, 76]$, featuring $D \approx 82\text{--}85$ block hard peaks and the $D \approx 91$ Grand Halfway Finale at Level 5000.

## Proposed Change
Implement the procedural generator configuration and seed rules in `packages/puzzle_core/lib/src/generator/phase_10/`:

### 1. 50-Block Macro Layout
- **Block 451 (4501–4510):** Signature System Intro (*Drum Festival Prelude*).
- **Block 452 (4511–4520):** M451 Drum Gate Intro (L4511 x1).
- **Blocks 453–463 (4521–4630):** Variants V01 to V11 (M451 variations).
- **Block 464 (4631–4640):** M452 Totem Pattern Lock Intro (L4631 x1).
- **Blocks 465–475 (4641–4750):** Variants V12 to V22 (M452 variations).
- **Block 476 (4751–4760):** M453 Parade Exit Intro (L4751 x1).
- **Blocks 477–487 (4761–4870):** Variants V23 to V33 (M453 variations).
- **Block 488 (4871–4880):** M454 Echo Frogs Intro (L4871 x1).
- **Blocks 489–499 (4881–4990):** Variants V34 to V44 (M454 variations).
- **Block 500 (4991–5000):** Mastery Mix Review (L4991), Variant 45 (L4995), and Grand Halfway Finale (L5000).

---

### 2. Standard 10-Level Block Template
Each 10-level block adheres to the core progression curve:
- **x1 (Feature / Variant Intro):** $D \in [60, 64]$. Pristine introduction of new mechanic/modifier with zero clutter.
- **x2 (Standard Easy):** $D \in [60, 62]$. Basic practice and pattern reinforcement.
- **x3 (Standard Normal):** $D \in [63, 66]$. Minor obstacle combination.
- **x4 (Easy Breather):** $D \in [61, 63]$. Quick, satisfying flow puzzle.
- **x5 (Standard Normal):** $D \in [65, 68]$. 2–3 snake coordination.
- **x6 (Mid Normal):** $D \in [67, 70]$. Tight corridor turns and spatial contention.
- **x7 (Upper Normal):** $D \in [69, 72]$. Multi-snake color coordination and rhythm timing.
- **x8 (High Normal):** $D \in [72, 75]$. Whole-board rhythm and parade synchronization.
- **x9 (Hard Level):** $D \in [82, 85]$. High constraint puzzle requiring deterministic planning.
- **x0 (Milestone Gate):** $D \in [70, 74]$. Milestone level awarding Gift Basket (300 coins + cycling booster).

---

### 3. Tiers, Board Dimensions, and Parameters
- **Tier P10-A (Levels 4501–4750 — Festival Grounds):**
  - Grid: $12 \times 12$ to $13 \times 13$.
  - Snakes: 28 to 34 initial snakes.
  - Max Active Rhythm Gates: 2.
  - Background: `#FFF3E0` (Warm Festival Grounds).
- **Tier P10-B (Levels 4751–5000 — Sacred Totem Grove):**
  - Grid: $13 \times 13$ to $14 \times 14$.
  - Snakes: 32 to 42 initial snakes.
  - Max Active Rhythm Gates: 3; Parade Max Index: 5.
  - Background: `#FFE0B2` (Sacred Golden Totem Grove).

---

### 4. Curated Hand-Tuned Key Levels
1. **L4501 (Festival Prelude):** Introduction to turn-based move cadence ($D = 60$).
2. **L4511 (M451 Tutorial):** Clean interactive demo of `[OPEN, CLOSED]` drum gate cycle ($D = 61$).
3. **L4631 (M452 Tutorial):** Tutorial on 3-color Totem sequence: Red $\to$ Green $\to$ Yellow ($D = 62$).
4. **L4751 (M453 Tutorial):** Demonstration of numbered parade evacuation: 1, 2, 3 ($D = 63$).
5. **L4871 (M454 Tutorial):** Echo Frogs tutorial: Group B replicating Group A ($D = 64$).
6. **L4959 (Hard Peak):** 3 drum gates synchronized with a 4-color totem pillar on a $14 \times 14$ grid ($D = 85$).
7. **L4991 (Review Level — Mastery Mix):** Flawless integration of M451, M452, M453, and M454 ($D = 75$).
8. **L5000 (Grand Halfway Finale — Festival of Ten Thousand Drums):** Epic 40-snake masterpiece featuring synchronized drum gates, triple totems, and a 5-snake grand parade celebrating the 5,000-level midpoint ($D = 91$).

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_10/phase_10_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_10/phase_10_level_plan.dart` (to be created)
- `assets/levels/phase_10_hand_tuned.json` (to be created)
- `test/generator/phase_10_plan_test.dart` (to be created)

## Risks and Open Questions
- **Grid Viewport at 14×14:** On compact mobile screens, a $14 \times 14$ grid requires responsive tile sizing and smooth pan/pinch navigation per Standard §9.3. Must ensure badge legibility on parade snakes.

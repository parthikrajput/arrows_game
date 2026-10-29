Source docs: phases/phase_9/02_LEVEL_PLAN_4001_4500.md, phases/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §17.38, ../../SCALING_TO_10000_LEVELS.md §3.5, §6. Depends on: specs/gameplay/phase-9-signature-system.md, specs/gameplay/phase-9-base-mechanics.md, specs/gameplay/phase-9-variants-and-modifiers.md.

# Spec: Gameplay — Phase 9 Level Plan (Levels 4001–4500)

## Status
Draft

## Type
New Feature

## Goal
Establish the comprehensive level generation roadmap, difficulty distribution, slot allocation, and milestone architecture for Phase 9 (Levels 4001 to 4500) across 50 10-level blocks.

## Current State
Design documented in `phases/phase_9/02_LEVEL_PLAN_4001_4500.md`, `phases/phase_9/01_PHASE_9_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §3.5, §6, not yet implemented.
- The phase spans Blocks 401 to 450 (50 blocks total, 500 levels).
- Operating under the endgame plateau band $D \in [60, 76]$, with periodic $D \approx 82\text{--}85$ hard peaks and $D \approx 91$ at Grand Finale Level 4500.

## Proposed Change
Implement the procedural generator configuration and seed tables in `packages/puzzle_core/lib/src/generator/phase_9/`:

### 1. 50-Block Macro Layout
- **Block 401 (4001–4010):** Signature System Intro (*Twin Rivers Concept*).
- **Block 402 (4011–4020):** M401 Merger Pad Intro (L4011 x1).
- **Blocks 403–413 (4021–4130):** Variants V01 to V11 (M401 variations).
- **Block 414 (4131–4140):** M402 Twin Splitter Intro (L4131 x1).
- **Blocks 415–425 (4141–4250):** Variants V12 to V22 (M402 variations).
- **Block 426 (4251–4260):** M403 Segment Lock Intro (L4251 x1).
- **Blocks 427–437 (4261–4370):** Variants V23 to V33 (M403 variations).
- **Block 438 (4371–4380):** M404 Reunion Gate Intro (L4371 x1).
- **Blocks 439–449 (4381–4490):** Variants V34 to V44 (M404 variations).
- **Block 450 (4491–4500):** Mastery Mix Review (L4491), Variant 45 (L4495), and Grand Finale (L4500).

---

### 2. Standard 10-Level Block Template
Each block of 10 levels adheres strictly to the standardized cadence:
- **x1 (Feature / Variant Intro):** $D \in [60, 64]$. Pristine introduction of new mechanic/modifier with zero clutter.
- **x2 (Standard Easy):** $D \in [60, 62]$. Basic practice and pattern reinforcement.
- **x3 (Standard Normal):** $D \in [63, 66]$. Minor obstacle combination.
- **x4 (Easy Breather):** $D \in [61, 63]$. Low-stress flow level with clear egress.
- **x5 (Standard Normal):** $D \in [65, 68]$. 2–3 snake coordination.
- **x6 (Mid Normal):** $D \in [67, 70]$. Tight corridor turns and spatial contention.
- **x7 (Upper Normal):** $D \in [69, 72]$. Segment length gating and split/merge interactions.
- **x8 (High Normal):** $D \in [72, 75]$. Whole-board synchronization.
- **x9 (Hard Level):** $D \in [82, 85]$. High topological constraint requiring deterministic move sequencing.
- **x0 (Milestone Gate):** $D \in [70, 74]$. Satisfying resolution awarding Gift Basket (300 coins + cycling booster).

---

### 3. Tiers, Board Dimensions, and Parameters
- **Tier P9-A (Levels 4001–4250):**
  - Grid: $10 \times 10$ to $12 \times 12$.
  - Snakes: 3 to 6 active initial entities.
  - Max Active Children: 4.
  - Target Path Length: 12–20 tiles.
- **Tier P9-B (Levels 4251–4500):**
  - Grid: $12 \times 12$ to $14 \times 14$.
  - Snakes: 5 to 9 active initial entities.
  - Max Active Children: 6.
  - Target Path Length: 18–30 tiles.

---

### 4. Curated Hand-Tuned Key Levels
1. **L4001 (Signature Hook):** 2 snakes navigate opposing riverbanks to merge on central Hug Pad ($D = 60$).
2. **L4011 (M401 Tutorial):** Clean interactive tutorial introducing Merger Pad mechanics ($D = 61$).
3. **L4131 (M402 Tutorial):** Interactive demonstration of Fork Stump splitting and dual-clearance rule ($D = 62$).
4. **L4251 (M403 Tutorial):** Demonstration of Bead Lock requiring 6 cumulative segments ($D = 63$).
5. **L4371 (M404 Tutorial):** Twin child snakes navigate divergent routes to open Reunion Gate ($D = 64$).
6. **L4459 (Hard Peak):** 3 splitters and 2 merger pads on a $13 \times 13$ river delta ($D = 85$).
7. **L4491 (Review Level — Mastery Mix):** Integrates M401, M402, M403, and M404 without introducing new modifiers ($D = 74$).
8. **L4500 (Grand Finale — Twin Waters Convergence):** 42 snakes (initial + split children) navigating a massive $14 \times 14$ twin river basin ($D = 91$).

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_9/phase_9_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_9/phase_9_level_plan.dart` (to be created)
- `assets/levels/phase_9_hand_tuned.json` (to be created)
- `test/generator/phase_9_plan_test.dart` (to be created)

## Risks and Open Questions
- **Branching Factor:** Bifurcation in P9-B can generate up to 6 simultaneous child entities. If multiple children are trapped in tight channels, the A* state search tree expands significantly. The generator must reject topologies where child paths cross before reaching exits.

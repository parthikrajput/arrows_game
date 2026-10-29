Source docs: phases/phase_14/02_LEVEL_PLAN_6501_7000.md, phases/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §17.38, ../../SCALING_TO_10000_LEVELS.md §3.5, §6. Depends on: specs/gameplay/phase-14-signature-system.md, specs/gameplay/phase-14-base-mechanics.md, specs/gameplay/phase-14-variants-and-modifiers.md.

# Spec: Gameplay — Phase 14 Level Plan (Levels 6501–7000)

## Status
Draft

## Type
New Feature

## Goal
Establish the comprehensive level generation roadmap, difficulty distribution, slot allocation, and milestone architecture for Phase 14 (Levels 6501 to 7000) across 50 10-level blocks.

## Current State
Design documented in `phases/phase_14/02_LEVEL_PLAN_6501_7000.md`, `phases/phase_14/01_PHASE_14_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §3.5, §6, not yet implemented.
- Spans Blocks 651 to 700 (50 blocks total, 500 levels).
- Reaches the 7,000-level mark.
- Difficulty conforms to the fixed plateau band $D \in [60, 76]$, featuring $D \approx 82\text{--}85$ block hard peaks and the $D \approx 91$ Grand Finale at Level 7000.

## Proposed Change
Implement the procedural generator configuration and seed rules in `packages/puzzle_core/lib/src/generator/phase_14/`:

### 1. 50-Block Macro Layout
- **Block 651 (6501–6510):** Signature System Intro (*Reflective Calm*).
- **Block 652 (6511–6520):** M651 Pond Axis Intro (L6511 x1).
- **Blocks 653–663 (6521–6630):** Variants V01 to V11 (M651 variations).
- **Block 664 (6631–6640):** M652 Reflection Lock Intro (L6631 x1).
- **Blocks 665–675 (6641–6750):** Variants V12 to V22 (M652 variations).
- **Block 676 (6751–6760):** M653 Twin Board Intro (L6751 x1).
- **Blocks 677–687 (6761–6870):** Variants V23 to V33 (M653 variations).
- **Block 688 (6871–6880):** M654 Upside-down Snake Intro (L6871 x1).
- **Blocks 689–699 (6881–6990):** Variants V34 to V44 (M654 variations).
- **Block 700 (6991–7000):** Mastery Mix Review (L6991), Variant 45 (L6995), and Grand Finale (L7000).

---

### 2. Standard 10-Level Block Template
Each block of 10 levels adheres strictly to the standardized cadence:
- **x1 (Feature / Variant Intro):** $D \in [60, 64]$. Pristine introduction of new mechanic/modifier with zero clutter.
- **x2 (Standard Easy):** $D \in [60, 62]$. Basic practice and pattern reinforcement.
- **x3 (Standard Normal):** $D \in [63, 66]$. Minor obstacle combination with mirror axis symmetry.
- **x4 (Easy Breather):** $D \in [61, 63]$. Low-stress flow level with clear egress.
- **x5 (Standard Normal):** $D \in [65, 68]$. 2–3 snake coordination across reflection plane.
- **x6 (Mid Normal):** $D \in [67, 70]$. Tight corridor turns and spatial contention.
- **x7 (Upper Normal):** $D \in [69, 72]$. Dynamic cross-shore unlocking and inverse vector planning.
- **x8 (High Normal):** $D \in [72, 75]$. Whole-board bilateral synchronization.
- **x9 (Hard Level):** $D \in [82, 85]$. High constraint requiring deterministic planning.
- **x0 (Milestone Gate):** $D \in [70, 74]$. Milestone level awarding Gift Basket (300 coins + cycling booster).

---

### 3. Tiers, Board Dimensions, and Parameters
- **Tier P14-A (Levels 6501–6750 — Crystal Pool):**
  - Grid: $12 \times 12$ to $13 \times 13$.
  - Snakes: 28 to 34 initial snakes (14–17 bilateral pairs).
  - Axis: Fixed horizontal or vertical center line.
  - Background: `#E1F5FE` (Crystal Pool).
- **Tier P14-B (Levels 6751–7000 — Obsidian Reflection):**
  - Grid: $13 \times 13$ to $14 \times 14$.
  - Snakes: 32 to 42 initial snakes (16–21 bilateral pairs).
  - Axis: M653 Twin Boards + M654 Inverse Snakes.
  - Background: `#B3E5FC` (Obsidian Reflection).

---

### 4. Curated Hand-Tuned Key Levels
1. **L6501 (Reflective Calm):** Introduction to central water axis and bilateral movement ($D = 60$).
2. **L6511 (M651 Tutorial):** Clean interactive demo of synchronous mirror slither across the axis ($D = 61$).
3. **L6631 (M652 Tutorial):** Liberating the key snake on Shore B dissolves the reflection lock on Shore A ($D = 62$).
4. **L6751 (M653 Tutorial):** Twin boards tutorial: maintaining identical move sequence across both grids ($D = 63$).
5. **L6871 (M654 Tutorial):** Demonstrates Upside-down Snake slithering in opposite vector to partner ($D = 64$).
6. **L6959 (Hard Peak):** 2 inverse snakes and 3 reflection locks on a $14 \times 14$ grid ($D = 85$).
7. **L6991 (Review Level — Mastery Mix):** Harmonious combination of M651, M652, M653, and M654 ($D = 75$).
8. **L7000 (Grand Finale — Obsidian Mirror Convergence):** Epic 42-snake bilateral masterpiece celebrating the 7,000-level achievement ($D = 91$).

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_14/phase_14_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_14/phase_14_level_plan.dart` (to be created)
- `assets/levels/phase_14_hand_tuned.json` (to be created)
- `test/generator/phase_14_plan_test.dart` (to be created)

## Risks and Open Questions
- **Axis Line Centering on Odd-Dimension Grids:** If grid size is odd (e.g. $13 \times 13$), the water axis occupies a 1-tile center channel rather than a seamless border seam. Procedural generator must enforce even grid dimensions ($12 \times 12$ or $14 \times 14$) on levels with physical boundary axes.

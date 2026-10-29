Source docs: phases/phase_13/02_LEVEL_PLAN_6001_6500.md, phases/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §17.38, ../../SCALING_TO_10000_LEVELS.md §3.5, §6. Depends on: specs/gameplay/phase-13-signature-system.md, specs/gameplay/phase-13-base-mechanics.md, specs/gameplay/phase-13-variants-and-modifiers.md.

# Spec: Gameplay — Phase 13 Level Plan (Levels 6001–6500)

## Status
Draft

## Type
New Feature

## Goal
Establish the comprehensive level generation roadmap, difficulty distribution, slot allocation, and milestone architecture for Phase 13 (Levels 6001 to 6500) across 50 10-level blocks.

## Current State
Design documented in `phases/phase_13/02_LEVEL_PLAN_6001_6500.md`, `phases/phase_13/01_PHASE_13_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §3.5, §6, not yet implemented.
- Spans Blocks 601 to 650 (50 blocks total, 500 levels).
- Reaches the 6,500-level mark.
- Difficulty conforms to the fixed plateau band $D \in [60, 76]$, featuring $D \approx 82\text{--}85$ block hard peaks and the $D \approx 91$ Grand Finale at Level 6500.

## Proposed Change
Implement the procedural generator configuration and seed rules in `packages/puzzle_core/lib/src/generator/phase_13/`:

### 1. 50-Block Macro Layout
- **Block 601 (6001–6010):** Signature System Intro (*Mist Veil*).
- **Block 602 (6011–6020):** M601 Scout Gecko Intro (L6011 x1).
- **Blocks 603–613 (6021–6130):** Variants V01 to V11 (M601 variations).
- **Block 614 (6131–6140):** M602 Trick Mist Intro (L6131 x1).
- **Blocks 615–625 (6141–6250):** Variants V12 to V22 (M602 variations).
- **Block 626 (6251–6260):** M603 Painted Wall Intro (L6251 x1).
- **Blocks 627–637 (6261–6370):** Variants V23 to V33 (M603 variations).
- **Block 638 (6371–6380):** M604 Glow Stone Intro (L6371 x1).
- **Blocks 639–649 (6381–6490):** Variants V34 to V44 (M604 variations).
- **Block 650 (6491–6500):** Mastery Mix Review (L6491), Variant 45 (L6495), and Grand Finale (L6500).

---

### 2. Standard 10-Level Block Template
Each block of 10 levels adheres strictly to the standardized cadence:
- **x1 (Feature / Variant Intro):** $D \in [60, 64]$. Pristine introduction of new mechanic/modifier with zero clutter.
- **x2 (Standard Easy):** $D \in [60, 62]$. Basic practice and pattern reinforcement.
- **x3 (Standard Normal):** $D \in [63, 66]$. Minor obstacle combination with fog elements.
- **x4 (Easy Breather):** $D \in [61, 63]$. Low-stress flow level with clear egress.
- **x5 (Standard Normal):** $D \in [65, 68]$. 2–3 snake coordination around obscured tiles.
- **x6 (Mid Normal):** $D \in [67, 70]$. Tight corridor turns and spatial contention.
- **x7 (Upper Normal):** $D \in [69, 72]$. Dynamic scouting and false wall bypass maneuvers.
- **x8 (High Normal):** $D \in [72, 75]$. Whole-board visibility coordination.
- **x9 (Hard Level):** $D \in [82, 85]$. High constraint requiring deterministic planning.
- **x0 (Milestone Gate):** $D \in [70, 74]$. Milestone level awarding Gift Basket (300 coins + cycling booster).

---

### 3. Tiers, Board Dimensions, and Parameters
- **Tier P13-A (Levels 6001–6250 — Shrouded Glade):**
  - Grid: $12 \times 12$ to $13 \times 13$.
  - Snakes: 28 to 34 initial snakes.
  - Fog Coverage: 20% to 35% of floor cells; 1 M601 Scout Gecko.
  - Background: `#ECEFF1` (Shrouded Glade).
- **Tier P13-B (Levels 6251–6500 — Phantom Woods):**
  - Grid: $13 \times 13$ to $14 \times 14$.
  - Snakes: 32 to 42 initial snakes.
  - Fog Coverage: 35% to 50% of floor cells; up to 3 M603 Painted Walls + M604 Glow Stones.
  - Background: `#CFD8DC` (Phantom Woods).

---

### 4. Curated Hand-Tuned Key Levels
1. **L6001 (Mist Veil):** Gentle introduction to semi-transparent fog and long-press raycast preview ($D = 60$).
2. **L6011 (M601 Tutorial):** First interactive tutorial demonstrating permanent scout lane clearing ($D = 61$).
3. **L6131 (M602 Tutorial):** Demonstrates trick mist re-cloaking vacated floor space ($D = 62$).
4. **L6251 (M603 Tutorial):** Demonstrates long-pressing to penetrate an M603 Painted Wall ($D = 63$).
5. **L6371 (M604 Tutorial):** Tactile pressure plate tutorial; parking a snake on a Glow Stone illuminates a $3 \times 3$ area ($D = 64$).
6. **L6459 (Hard Peak):** 3 painted walls and dense rolling mist across a $14 \times 14$ grid ($D = 85$).
7. **L6491 (Review Level — Mastery Mix):** Seamless integration of M601, M602, M603, and M604 ($D = 75$).
8. **L6500 (Grand Finale — Heart of the Phantom Mists):** Epic 42-snake masterpiece featuring sweeping scout paths and shifting phantom labyrinths ($D = 91$).

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_13/phase_13_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_13/phase_13_level_plan.dart` (to be created)
- `assets/levels/phase_13_hand_tuned.json` (to be created)
- `test/generator/phase_13_plan_test.dart` (to be created)

## Risks and Open Questions
- **Solver State Caching with Fog:** Because visibility state shifts dynamically upon snake exits, the solver state hash must incorporate the `VisibilityGrid` bitmask to avoid treating two functionally different visibility states as equivalent.

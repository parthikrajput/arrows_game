Source docs: phases/phase_11/02_LEVEL_PLAN_5001_5500.md, phases/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §17.38, ../../SCALING_TO_10000_LEVELS.md §3.5, §6. Depends on: specs/gameplay/phase-11-signature-system.md, specs/gameplay/phase-11-base-mechanics.md, specs/gameplay/phase-11-variants-and-modifiers.md.

# Spec: Gameplay — Phase 11 Level Plan (Levels 5001–5500)

## Status
Draft

## Type
New Feature

## Goal
Establish the comprehensive level generation roadmap, difficulty pacing, block architecture, and milestone distribution for Phase 11 (Levels 5001 to 5500) across 50 10-level blocks.

## Current State
Design documented in `phases/phase_11/02_LEVEL_PLAN_5001_5500.md`, `phases/phase_11/01_PHASE_11_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §3.5, §6, not yet implemented.
- Spans Blocks 501 to 550 (50 blocks total, 500 levels).
- Replaces the monolithic single-grid board with two linked mini-boards.
- Difficulty conforms to the fixed plateau band $D \in [60, 76]$, featuring $D \approx 82\text{--}85$ block hard peaks and the $D \approx 91$ Grand Finale at Level 5500.

## Proposed Change
Implement the procedural generator configuration and seed rules in `packages/puzzle_core/lib/src/generator/phase_11/`:

### 1. 50-Block Macro Layout
- **Block 501 (5001–5010):** Signature System Intro (*Two Ponds Genesis*).
- **Block 502 (5011–5020):** M501 Vine Bridge Intro (L5011 x1).
- **Blocks 503–513 (5021–5130):** Variants V01 to V11 (M501 variations).
- **Block 514 (5131–5140):** M502 Messenger Key Intro (L5131 x1).
- **Blocks 515–525 (5141–5250):** Variants V12 to V22 (M502 variations).
- **Block 526 (5251–5260):** M503 Pond Reflection / Mirror Board Intro (L5251 x1).
- **Blocks 527–537 (5261–5370):** Variants V23 to V33 (M503 variations).
- **Block 538 (5371–5380):** M504 Relay Burrow Intro (L5371 x1).
- **Blocks 539–549 (5381–5490):** Variants V34 to V44 (M504 variations).
- **Block 550 (5491–5500):** Mastery Mix Review (L5491), Variant 45 (L5495), and Grand Finale (L5500).

---

### 2. Standard 10-Level Block Template
Each block of 10 levels adheres strictly to the standardized cadence:
- **x1 (Feature / Variant Intro):** $D \in [60, 64]$. Pristine introduction of new mechanic/modifier with zero clutter.
- **x2 (Standard Easy):** $D \in [60, 62]$. Basic practice and pattern reinforcement.
- **x3 (Standard Normal):** $D \in [63, 66]$. Minor obstacle combination across boards.
- **x4 (Easy Breather):** $D \in [61, 63]$. Low-stress flow level with clear egress.
- **x5 (Standard Normal):** $D \in [65, 68]$. 2–3 snake coordination between ponds.
- **x6 (Mid Normal):** $D \in [67, 70]$. Tight corridor turns and spatial contention.
- **x7 (Upper Normal):** $D \in [69, 72]$. Inter-board transit and lock sequencing.
- **x8 (High Normal):** $D \in [72, 75]$. Whole-board synchronization across both sub-grids.
- **x9 (Hard Level):** $D \in [82, 85]$. High constraint requiring deterministic planning.
- **x0 (Milestone Gate):** $D \in [70, 74]$. Milestone level awarding Gift Basket (300 coins + cycling booster).

---

### 3. Tiers, Board Dimensions, and Parameters
- **Tier P11-A (Levels 5001–5250 — Twin Lily Ponds):**
  - Layout: Dual mini-boards ($6 \times 6$ to $7 \times 7$ each).
  - Snakes: 24 to 32 total snakes (distributed ~12–16 per board).
  - Bridges: 1 active M501 Vine Bridge.
  - Background: `#E8F5E9` (Twin Lily Ponds).
- **Tier P11-B (Levels 5251–5500 — Mirror Marsh):**
  - Layout: Dual mini-boards ($7 \times 7$ to $8 \times 8$ each).
  - Snakes: 30 to 42 total snakes (distributed ~15–21 per board).
  - Bridges: Up to 2 bridges + M504 Burrows + M503 Mirror pairs.
  - Background: `#C8E6C9` (Mirror Marsh).

---

### 4. Curated Hand-Tuned Key Levels
1. **L5001 (Two Ponds Genesis):** Introduction to dual stacked $5 \times 5$ sub-grids ($D = 60$).
2. **L5011 (M501 Tutorial):** Clean interactive demo of continuous vine bridge transit ($D = 61$).
3. **L5131 (M502 Tutorial):** Liberating the Messenger Snake on Board 1 unlocks Board 2 gate ($D = 62$).
4. **L5251 (M503 Tutorial):** Demonstration of simultaneous mirror movement and dual-clearance safety ($D = 63$).
5. **L5371 (M504 Tutorial):** Demonstration of underground burrow wormhole between boards ($D = 64$).
6. **L5459 (Hard Peak):** 2 mirror pairs, 1 cross-board key, and 2 vine bridges on dual $8 \times 8$ boards ($D = 85$).
7. **L5491 (Review Level — Mastery Mix):** Harmonious combination of M501, M502, M503, and M504 ($D = 75$).
8. **L5500 (Grand Finale — Mirror of the Deep Water):** 42 snakes across dual $8 \times 8$ ponds featuring interconnected bridges, burrows, and reflection pairs ($D = 91$).

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_11/phase_11_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_11/phase_11_level_plan.dart` (to be created)
- `assets/levels/phase_11_hand_tuned.json` (to be created)
- `test/generator/phase_11_plan_test.dart` (to be created)

## Risks and Open Questions
- **Dual Mini-Grid Sizing on Tablets vs Phones:** On tablets, two mini-grids can be arranged side-by-side (landscape), while on phones they are stacked vertically (portrait). Generator and renderer must support dynamic orientation adaptation per Standard §9.3.

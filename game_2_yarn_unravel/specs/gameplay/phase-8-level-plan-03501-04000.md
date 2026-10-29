Source docs: phase/phase_8/02_LEVEL_PLAN_3501_4000.md, phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3, §6. Depends on: specs/gameplay/level-progression-0001-0500.md, specs/gameplay/phase-8-signature-system.md, specs/gameplay/phase-8-base-mechanics.md.

# Spec: Gameplay — Phase 8 Level Plan (Levels 3501–4000)

## Status
Draft

## Type
New Feature

## Goal
Specify the 500-level architectural progression plan, 50-block slot distribution, tier parameters, difficulty curve ($D \in [76, 92]$), and milestone rewards for Yarn Unravel Phase 8 (Levels 3501–4000).

## Current State
Design documented in `phase/phase_8/02_LEVEL_PLAN_3501_4000.md`, not yet implemented.

## Proposed Change
Implement the 500-level generation parameters for Phase 8 in `tools/levelgen`:

### 1. 50-Block Progression Architecture
Phase 8 spans 50 blocks of 10 levels each ($L \in [3501, 4000]$):
- **Block 1 (L3501–3510):** Growth Signature System Intro:
  - L3501: Basic Spreading Vine onboarding (unravel before vine expands into exit channel).
  - L3502–3508: Ramp-up with gentle vine spread rates.
  - L3509: Block 1 Hard Level ($D \approx 83$).
  - L3510: Milestone Level + Craft Basket grant.
- **Block 2 (L3511–3520):** Base Mechanic 1 Intro:
  - L3511: M351 Ivy Yarn onboarding (clockwise spreading priority).
  - L3520: Milestone Level + Craft Basket grant.
- **Blocks 3–13 (L3521–3630):** M351 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 14 (L3631–3640):** Base Mechanic 2 Intro:
  - L3631: M352 Snip Tile onboarding (clearing surrounding 8 cells of vine growth).
  - L3640: Milestone Level + Craft Basket grant.
- **Blocks 15–25 (L3641–3750):** M352 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 26 (L3751–3760):** Base Mechanic 3 Intro:
  - L3751: M353 Seed Bead Thread onboarding (3-move countdown button germination).
  - L3760: Milestone Level + Craft Basket grant.
- **Blocks 27–37 (L3761–3870):** M353 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 38 (L3871–3880):** Base Mechanic 4 Intro:
  - L3871: M354 Blossom Gate onboarding (clearing $K$ ivy cells to bloom open gate).
  - L3880: Milestone Level + Craft Basket grant.
- **Blocks 39–49 (L3881–3990):** M354 Variant Progression & Full Blooming Garden Mix (11 variant slots at x1; baskets at x0).
- **Block 50 (L3991–4000):** Review & Finale:
  - L3991: Review Level ("Garden Knitting Mastery", combines M351–M354).
  - L3992–3998: Climax momentum ramp.
  - L3999: Super Hard Level ($D \approx 101$).
  - L4000: Phase Finale "The Blooming Quilt" ($D \approx 110$).

### 2. Tier Partitioning & Parameters
Difficulty adheres strictly to the Plateau Formula: $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.

| Parameter | Tier P8-A (L3501–3750) | Tier P8-B (L3751–4000) |
|---|---|---|
| **Level Range** | 3501–3750 (250 levels) | 3751–4000 (250 levels) |
| **Grid Size** | 12×12 to 13×13 | 13×13 to 14×14 |
| **Thread Count ($P$)** | 28 – 34 | 32 – 40 |
| **Growth Roots & Obstacles ($O$)** | 8 – 11 (1–2 roots) | 10 – 14 (2–3 roots) |
| **Target $D$ Band** | **76 – 84** | **84 – 92** |
| **x9 Hard Target $D$** | $\approx 92$ ($84 \times 1.10$) | $\approx 101$ ($92 \times 1.10$) |
| **Finale Target $D$** | N/A | $\approx 110$ ($92 \times 1.20$) |

### 3. Intro-Level Constraints
- In intro levels (L3501, L3511, L3631, L3751, L3871):
  - No countdown modifiers (`Countdown(N)`), sheer silk ghosts, or compound multi-roots.
  - Generous move allowances ($M \ge \text{par} + 6$).
  - Modal onboarding tutorial card on turn 1.

### 4. Milestone & Finale Level Specifications
- **Every x0 Level (49 total):** Grants Craft Basket (300 Coins + 1 rotating booster).
- **Review Level (L3991):** Comprehensive test combining Ivy Roots (M351), Snip Tiles (M352), Seed Beads (M353), and Blossom Gates (M354) on a 14×14 board.
- **Finale Level (L4000):** "The Blooming Quilt", 14×14 board, 40 threads, 3 spreader roots, 4 blossom gates, target $D = 110.0$, 0-hearts solvable. Grants Grand Sewing Chest and unlocks Phase 8 Master Badge.

## Affected Files
- `tools/levelgen/lib/src/configs/phase_8_config.dart` (to be created: Phase 8 tier and slot map definition)
- `packages/puzzle_core/lib/src/models/level_definition.dart` (changed: validate Phase 8 params)

## Risks
- Board overcrowding if ivy spread speed exceeds player clearance. Mitigated by setting spread intervals $\ge 3$ moves and capping max live vine cells.

## Open Questions
None. Progression curve and tier parameters match SCALING §6 and Phase 8 docs.

Source docs: phase/phase_10/02_LEVEL_PLAN_4501_5000.md, phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3, §6. Depends on: specs/gameplay/level-progression-0001-0500.md, specs/gameplay/phase-10-signature-system.md, specs/gameplay/phase-10-base-mechanics.md.

# Spec: Gameplay — Phase 10 Level Plan (Levels 4501–5000)

## Status
Draft

## Type
New Feature

## Goal
Specify the 500-level architectural progression plan, 50-block slot distribution, tier parameters, difficulty curve ($D \in [82, 98]$), and milestone rewards for Yarn Unravel Phase 10 (Levels 4501–5000).

## Current State
Design documented in `phase/phase_10/02_LEVEL_PLAN_4501_5000.md`, not yet implemented.

## Proposed Change
Implement the 500-level generation parameters for Phase 10 in `tools/levelgen`:

### 1. 50-Block Progression Architecture
Phase 10 spans 50 blocks of 10 levels each ($L \in [4501, 5000]$):
- **Block 1 (L4501–4510):** Sequencing Signature System Intro:
  - L4501: Basic Exit Sequence onboarding (demonstrating ordered thread removal).
  - L4502–4508: Ramp-up with 2-color sequence cues.
  - L4509: Block 1 Hard Level ($D \approx 89$).
  - L4510: Milestone Level + Craft Basket grant.
- **Block 2 (L4511–4520):** Base Mechanic 1 Intro:
  - L4511: M451 Metronome Gate onboarding (rhythmic move-based gate).
  - L4520: Milestone Level + Craft Basket grant.
- **Blocks 3–13 (L4521–4630):** M451 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 14 (L4631–4640):** Base Mechanic 2 Intro:
  - L4631: M452 Pattern Clasp onboarding (color-order brooch unlock).
  - L4640: Milestone Level + Craft Basket grant.
- **Blocks 15–25 (L4641–4750):** M452 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 26 (L4751–4760):** Base Mechanic 3 Intro:
  - L4751: M453 Ordered Hem onboarding (ascending numbered exit border).
  - L4760: Milestone Level + Craft Basket grant.
- **Blocks 27–37 (L4761–4870):** M453 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 38 (L4871–4880):** Base Mechanic 4 Intro:
  - L4871: M454 Echo Card onboarding (repeating thread color prefix).
  - L4880: Milestone Level + Craft Basket grant.
- **Blocks 39–49 (L4881–4990):** M454 Variant Progression & Full Pattern Book Mix (11 variant slots at x1; baskets at x0).
- **Block 50 (L4991–5000):** Review & Finale:
  - L4991: Review Level ("Pattern Book Mastery", combines M451–M454).
  - L4992–4998: Climax momentum ramp.
  - L4999: Super Hard Level ($D \approx 108$).
  - L5000: Phase Finale "The Master Pattern" ($D \approx 118$).

### 2. Tier Partitioning & Parameters
Difficulty adheres strictly to the Plateau Formula: $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.

| Parameter | Tier P10-A (L4501–4750) | Tier P10-B (L4751–5000) |
|---|---|---|
| **Level Range** | 4501–4750 (250 levels) | 4751–5000 (250 levels) |
| **Grid Size** | 12×12 to 13×13 | 13×13 to 14×14 |
| **Thread Count ($P$)** | 28 – 34 | 32 – 40 |
| **Sequence Items ($O$)** | 8 – 11 (1–2 rhythm gates/clasps) | 10 – 14 (2–4 rhythm gates/clasps) |
| **Target $D$ Band** | **82 – 90** | **90 – 98** |
| **x9 Hard Target $D$** | $\approx 99$ ($90 \times 1.10$) | $\approx 108$ ($98 \times 1.10$) |
| **Finale Target $D$** | N/A | $\approx 118$ ($98 \times 1.20$) |

### 3. Intro-Level Constraints
- In intro levels (L4501, L4511, L4631, L4751, L4871):
  - No countdown modifiers (`Countdown(N)`), sheer silk ghosts, or compound multi-rhythms.
  - Generous move allowances ($M \ge \text{par} + 6$).
  - Modal onboarding tutorial card on turn 1.

### 4. Milestone & Finale Level Specifications
- **Every x0 Level (49 total):** Grants Craft Basket (300 Coins + 1 rotating booster).
- **Review Level (L4991):** Comprehensive test combining Metronome Gates (M451), Pattern Clasps (M452), Ordered Hems (M453), and Echo Cards (M454) on a 14×14 board.
- **Finale Level (L5000):** "The Master Pattern", 14×14 board, 40 threads, 4 metronome gates, 3 pattern clasps, 1 ordered hem, target $D = 118.0$, 0-hearts solvable. Grants Grand Sewing Chest and unlocks Phase 10 Master Badge.

## Affected Files
- `tools/levelgen/lib/src/configs/phase_10_config.dart` (to be created: Phase 10 tier and slot map definition)
- `packages/puzzle_core/lib/src/models/level_definition.dart` (changed: validate Phase 10 params)

## Risks
- Players missing rhythm transitions. Mitigated by animated pendulum indicator showing upcoming open/closed intervals.

## Open Questions
None. Progression curve and tier parameters match SCALING §6 and Phase 10 docs.

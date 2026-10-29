Source docs: phase/phase_9/02_LEVEL_PLAN_4001_4500.md, phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3, §6. Depends on: specs/gameplay/level-progression-0001-0500.md, specs/gameplay/phase-9-signature-system.md, specs/gameplay/phase-9-base-mechanics.md.

# Spec: Gameplay — Phase 9 Level Plan (Levels 4001–4500)

## Status
Draft

## Type
New Feature

## Goal
Specify the 500-level architectural progression plan, 50-block slot distribution, tier parameters, difficulty curve ($D \in [79, 95]$), and milestone rewards for Yarn Unravel Phase 9 (Levels 4001–4500).

## Current State
Design documented in `phase/phase_9/02_LEVEL_PLAN_4001_4500.md`, not yet implemented.

## Proposed Change
Implement the 500-level generation parameters for Phase 9 in `tools/levelgen`:

### 1. 50-Block Progression Architecture
Phase 9 spans 50 blocks of 10 levels each ($L \in [4001, 4500]$):
- **Block 1 (L4001–4010):** Split & Merge Signature System Intro:
  - L4001: Basic Ply & Twist Split onboarding (demonstrating half-ply parallel trajectories).
  - L4002–4008: Ramp-up with single-thread split channels.
  - L4009: Block 1 Hard Level ($D \approx 86$).
  - L4010: Milestone Level + Craft Basket grant.
- **Block 2 (L4011–4020):** Base Mechanic 1 Intro:
  - L4011: M401 Twisting Pad onboarding (merging two threads into one).
  - L4020: Milestone Level + Craft Basket grant.
- **Blocks 3–13 (L4021–4130):** M401 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 14 (L4131–4140):** Base Mechanic 2 Intro:
  - L4131: M402 Double Split onboarding (twin parallel splitting).
  - L4140: Milestone Level + Craft Basket grant.
- **Blocks 15–25 (L4141–4250):** M402 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 26 (L4251–4260):** Base Mechanic 3 Intro:
  - L4251: M403 Stitch Lock onboarding (clearing key-thread to release locked body segment).
  - L4260: Milestone Level + Craft Basket grant.
- **Blocks 27–37 (L4261–4370):** M403 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 38 (L4371–4380):** Base Mechanic 4 Intro:
  - L4371: M404 Rejoin Gate onboarding (routing both child plies through buckle gate).
  - L4380: Milestone Level + Craft Basket grant.
- **Blocks 39–49 (L4381–4490):** M404 Variant Progression & Full Ply-Twist Mix (11 variant slots at x1; baskets at x0).
- **Block 50 (L4491–4500):** Review & Finale:
  - L4491: Review Level ("Ply & Twist Mastery", combines M401–M404).
  - L4492–4498: Climax momentum ramp.
  - L4499: Super Hard Level ($D \approx 104$).
  - L4500: Phase Finale "The Grand Tapestry Knot" ($D \approx 114$).

### 2. Tier Partitioning & Parameters
Difficulty adheres strictly to the Plateau Formula: $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.

| Parameter | Tier P9-A (L4001–4250) | Tier P9-B (L4251–4500) |
|---|---|---|
| **Level Range** | 4001–4250 (250 levels) | 4251–4500 (250 levels) |
| **Grid Size** | 12×12 to 13×13 | 13×13 to 14×14 |
| **Thread Count ($P$)** | 28 – 34 | 32 – 40 |
| **Splice & Merge Items ($O$)** | 8 – 11 (1–2 pads/splitters) | 10 – 14 (2–4 pads/splitters) |
| **Target $D$ Band** | **79 – 87** | **87 – 95** |
| **x9 Hard Target $D$** | $\approx 96$ ($87 \times 1.10$) | $\approx 104$ ($95 \times 1.10$) |
| **Finale Target $D$** | N/A | $\approx 114$ ($95 \times 1.20$) |

### 3. Intro-Level Constraints
- In intro levels (L4001, L4011, L4131, L4251, L4371):
  - No countdown modifiers (`Countdown(N)`), sheer silk ghosts, or compound multi-splits.
  - Generous move allowances ($M \ge \text{par} + 6$).
  - Modal onboarding tutorial card on turn 1.

### 4. Milestone & Finale Level Specifications
- **Every x0 Level (49 total):** Grants Craft Basket (300 Coins + 1 rotating booster).
- **Review Level (L4491):** Comprehensive test combining Twisting Pads (M401), Double Splits (M402), Stitch Locks (M403), and Rejoin Gates (M404) on a 14×14 board.
- **Finale Level (L4500):** "The Grand Tapestry Knot", 14×14 board, 40 threads, 4 twisting pads, 3 rejoin gates, target $D = 114.0$, 0-hearts solvable. Grants Grand Sewing Chest and unlocks Phase 9 Master Badge.

## Affected Files
- `tools/levelgen/lib/src/configs/phase_9_config.dart` (to be created: Phase 9 tier and slot map definition)
- `packages/puzzle_core/lib/src/models/level_definition.dart` (changed: validate Phase 9 params)

## Risks
- Thread identification difficulty after multiple splitting and merging steps. Mitigated by continuous color family preservation across child plies.

## Open Questions
None. Progression curve and tier parameters match SCALING §6 and Phase 9 docs.

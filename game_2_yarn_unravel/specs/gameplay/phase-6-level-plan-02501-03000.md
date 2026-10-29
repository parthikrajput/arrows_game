Source docs: phase/phase_6/02_LEVEL_PLAN_2501_3000.md, phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3, §6. Depends on: specs/gameplay/level-progression-0001-0500.md, specs/gameplay/phase-6-signature-system.md, specs/gameplay/phase-6-base-mechanics.md.

# Spec: Gameplay — Phase 6 Level Plan (Levels 2501–3000)

## Status
Draft

## Type
New Feature

## Goal
Specify the 500-level architectural progression plan, 50-block slot distribution, tier parameters, difficulty curve ($D \in [70, 86]$), and milestone rewards for Yarn Unravel Phase 6 (Levels 2501–3000).

## Current State
Design documented in `phase/phase_6/02_LEVEL_PLAN_2501_3000.md`, not yet implemented.

## Proposed Change
Implement the 500-level generation parameters for Phase 6 in `tools/levelgen`:

### 1. 50-Block Progression Architecture
Phase 6 spans 50 blocks of 10 levels each ($L \in [2501, 3000]$):
- **Block 1 (L2501–2510):** Light & Beams Signature System Intro:
  - L2501: Continuous Lamp Beam onboarding (unravel thread to allow beam to reach receiver).
  - L2502–2508: Basic beam corridor navigation.
  - L2509: Block 1 Hard Level ($D \approx 77$).
  - L2510: Milestone Level + Craft Basket grant.
- **Block 2 (L2511–2520):** Base Mechanic 1 Intro:
  - L2511: M251 Tinted Glass onboarding (filter neutral light into colored beam).
  - L2520: Milestone Level + Craft Basket grant.
- **Blocks 3–13 (L2521–2630):** M251 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 14 (L2631–2640):** Base Mechanic 2 Intro:
  - L2631: M252 Prism Clasp onboarding (intersect 2 beams to open clasp).
  - L2640: Milestone Level + Craft Basket grant.
- **Blocks 15–25 (L2641–2750):** M252 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 26 (L2751–2760):** Base Mechanic 3 Intro:
  - L2751: M253 Hourglass Lamp onboarding (move-based periodic beams).
  - L2760: Milestone Level + Craft Basket grant.
- **Blocks 27–37 (L2761–2870):** M253 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 38 (L2871–2880):** Base Mechanic 4 Intro:
  - L2871: M254 Shadow Pocket onboarding (dark cells locking threads until illuminated).
  - L2880: Milestone Level + Craft Basket grant.
- **Blocks 39–49 (L2881–2990):** M254 Variant Progression & Full Atelier Optical Mix (11 variant slots at x1; baskets at x0).
- **Block 50 (L2991–3000):** Review & Finale:
  - L2991: Review Level ("Atelier Mastery", combines M251–M254).
  - L2992–2998: Climax momentum ramp.
  - L2999: Super Hard Level ($D \approx 95$).
  - L3000: Phase Finale "Atelier Chandelier Tapestry" ($D \approx 103$).

### 2. Tier Partitioning & Parameters
Difficulty adheres strictly to the Plateau Formula: $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.

| Parameter | Tier P6-A (L2501–2750) | Tier P6-B (L2751–3000) |
|---|---|---|
| **Level Range** | 2501–2750 (250 levels) | 2751–3000 (250 levels) |
| **Grid Size** | 12×12 to 13×13 | 13×13 to 14×14 |
| **Thread Count ($P$)** | 28 – 34 | 32 – 40 |
| **Lamps & Obstacles ($O$)** | 8 – 11 (2–3 lamps) | 10 – 14 (3–5 lamps) |
| **Target $D$ Band** | **70 – 78** | **78 – 86** |
| **x9 Hard Target $D$** | $\approx 86$ ($78 \times 1.10$) | $\approx 95$ ($86 \times 1.10$) |
| **Finale Target $D$** | N/A | $\approx 103$ ($86 \times 1.20$) |

### 3. Intro-Level Constraints
- In intro levels (L2501, L2511, L2631, L2751, L2871):
  - No countdown modifiers (`Countdown(N)`), sheer silk ghosts, or expanding knit blocks.
  - Generous move allowances ($M \ge \text{par} + 6$).
  - Modal onboarding tutorial card on turn 1.

### 4. Milestone & Finale Level Specifications
- **Every x0 Level (49 total):** Grants Craft Basket (300 Coins + 1 rotating booster).
- **Review Level (L2991):** Comprehensive test combining Tinted Glass (M251), Prism Clasps (M252), Hourglass Lamps (M253), and Shadow Pockets (M254) on a 14×14 board.
- **Finale Level (L3000):** "Atelier Chandelier Tapestry", 14×14 board, 40 threads, 5 lamps, complex prismatic ray convergence, target $D = 103.2$, 0-hearts solvable. Grants Grand Sewing Chest and unlocks Phase 6 Master Badge.

## Affected Files
- `tools/levelgen/lib/src/configs/phase_6_config.dart` (to be created: Phase 6 tier and slot map definition)
- `packages/puzzle_core/lib/src/models/level_definition.dart` (changed: validate Phase 6 params)

## Risks
- Excessive visual contrast between bright beam paths and dark shadow cells causing visual fatigue. Mitigated by soft vignette alpha clamped to 0.40.

## Open Questions
None. Progression curve and tier parameters match SCALING §6 and Phase 6 docs.

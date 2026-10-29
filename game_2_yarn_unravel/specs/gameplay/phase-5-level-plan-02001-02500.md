Source docs: phase/phase_5/02_LEVEL_PLAN_2001_2500.md, phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3, §6. Depends on: specs/gameplay/level-progression-0001-0500.md, specs/gameplay/phase-5-signature-system.md, specs/gameplay/phase-5-base-mechanics.md.

# Spec: Gameplay — Phase 5 Level Plan (Levels 2001–2500)

## Status
Draft

## Type
New Feature

## Goal
Specify the 500-level architectural progression plan, 50-block slot distribution, tier parameters, difficulty curve ($D \in [67, 83]$), and milestone rewards for Yarn Unravel Phase 5 (Levels 2001–2500).

## Current State
Design documented in `phase/phase_5/02_LEVEL_PLAN_2001_2500.md`, not yet implemented.

## Proposed Change
Implement the 500-level generation parameters for Phase 5 in `tools/levelgen`:

### 1. 50-Block Progression Architecture
Phase 5 spans 50 blocks of 10 levels each ($L \in [2001, 2500]$):
- **Block 1 (L2001–2010):** Push Physics Signature System Intro:
  - L2001: Standard Notions Crate intro (1-cell push kinetics onboarding).
  - L2002–2008: Ramp-up with gentle path crossings.
  - L2009: Block 1 Hard Level ($D \approx 74$).
  - L2010: Milestone Level + Craft Basket grant.
- **Block 2 (L2011–2020):** Base Mechanic 1 Intro:
  - L2011: M201 Crate Pit onboarding (push crate into pit to clear path).
  - L2020: Milestone Level + Craft Basket grant.
- **Blocks 3–13 (L2021–2130):** M201 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 14 (L2131–2140):** Base Mechanic 2 Intro:
  - L2131: M202 Satin Crate onboarding (ice-sliding crates).
  - L2140: Milestone Level + Craft Basket grant.
- **Blocks 15–25 (L2141–2250):** M202 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 26 (L2251–2260):** Base Mechanic 3 Intro:
  - L2251: M203 Charm Crate onboarding (key crates unlocking clasps).
  - L2260: Milestone Level + Craft Basket grant.
- **Blocks 27–37 (L2261–2370):** M203 Variant Progression (11 variant slots at x1; baskets at x0).
- **Block 38 (L2371–2380):** Base Mechanic 4 Intro:
  - L2371: M204 Iron Crate onboarding (heavy crates requiring Chenille M024 / Ribbon Pairs M011).
  - L2380: Milestone Level + Craft Basket grant.
- **Blocks 39–49 (L2381–2490):** M204 Variant Progression & Full Workshop Mix (11 variant slots at x1; baskets at x0).
- **Block 50 (L2491–2500):** Review & Finale:
  - L2491: Review Level ("Crate Workshop Mastery", combines M201–M204).
  - L2492–2498: Pre-finale momentum ramp.
  - L2499: Super Hard Level ($D \approx 91$).
  - L2500: Phase Finale "Master Workshop Tapestry" ($D \approx 100$).

### 2. Tier Partitioning & Parameters
Difficulty adheres strictly to the Plateau Formula: $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.

| Parameter | Tier P5-A (L2001–2250) | Tier P5-B (L2251–2500) |
|---|---|---|
| **Level Range** | 2001–2250 (250 levels) | 2251–2500 (250 levels) |
| **Grid Size** | 12×12 to 13×13 | 13×13 to 14×14 |
| **Thread Count ($P$)** | 28 – 34 | 32 – 40 |
| **Crates & Obstacles ($O$)** | 8 – 11 (2–4 crates) | 10 – 14 (3–6 crates) |
| **Target $D$ Band** | **67 – 75** | **75 – 83** |
| **x9 Hard Target $D$** | $\approx 83$ ($75 \times 1.10$) | $\approx 91$ ($83 \times 1.10$) |
| **Finale Target $D$** | N/A | $\approx 100$ ($83 \times 1.20$) |

### 3. Intro-Level Constraints
- In intro levels (L2001, L2011, L2131, L2251, L2371):
  - No countdown modifiers (`Countdown(N)`), sheer silk ghosts, or dark fog cells.
  - Generous move allowances ($M \ge \text{par} + 6$).
  - Direct visual tutorial card pop-up on first turn explaining the mechanic.

### 4. Milestone & Finale Level Specifications
- **Every x0 Level (49 total):** Grants Craft Basket (300 Coins + 1 rotating booster).
- **Review Level (L2491):** Comprehensive test incorporating Pits (M201), Satin Sliders (M202), Charm Keys (M203), and Heavy Iron Crates (M204) on a 14×14 board.
- **Finale Level (L2500):** "Master Workshop Tapestry", 14×14 board, 40 threads, 6 movable crates, target $D = 99.8$, 0-hearts solvable. Grants Grand Sewing Chest and unlocks Phase 5 Master Badge.

## Affected Files
- `tools/levelgen/lib/src/configs/phase_5_config.dart` (to be created: Phase 5 tier and slot map definition)
- `packages/puzzle_core/lib/src/models/level_definition.dart` (changed: validate Phase 5 params)

## Risks
- Board density becoming visually overcrowded with large crates on smaller 12×12 grids. Mitigated by minimum 22 dp cell sizing and zoom/pan capability.

## Open Questions
None. Progression curve and tier parameters match SCALING §6 and Phase 5 docs.

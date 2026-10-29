Source docs: phase/phase_15/02_LEVEL_PLAN_7001_7500.md, phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-15-signature-system.md, specs/gameplay/phase-15-base-mechanics.md.

# Spec: Gameplay — Phase 15 Level Plan (Levels 7001–7500)

## Status
Draft

## Type
New Feature

## Goal
Specify the 50-block slot map, tier boundaries, difficulty targets ($D$), board sizes, path counts, and milestone levels for Yarn Unravel Phase 15 (Levels 7001–7500).

## Current State
Documented in `phase/phase_15/02_LEVEL_PLAN_7001_7500.md`, not yet implemented in code.

## Proposed Change
Implement the Phase 15 level generation parameters and slot definitions in `packages/puzzle_core`:

### 1. Tier Partitioning & Parameters
Phase 15 covers 500 levels structured into two progression tiers:

| Tier | Levels | Grid Dimensions | Threads ($P$) | Conveyor Elements ($O$) | Target $D$ Band |
|---|---|---|---|---|---|
| **P15-A** | 7001–7250 | 12×12 – 13×13 | 28–34 | 8–11 | **97 – 105** |
| **P15-B** | 7251–7500 | 13×13 – 14×14 | 32–40 | 10–14 | **105 – 113** |

- **Difficulty Metric:** $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.
- **Hard Levels (x9):** Every block's x9 level (L7019, L7029 ... L7499) targets $D \approx 124$ ($113 \times 1.10$).
- **Finale Level (L7500):** Targets $D \approx 135$ ($113 \times 1.20$).

### 2. 50-Block Architecture & Progression Map
- **Block 1 (L7001–7010):** Signature Intro (L7001: Basic Conveyor Belt translation, $D \approx 97$).
- **Block 2 (L7011–7020):** Base Mechanic 1 Intro (L7011: M701 Belt Switch, $D \approx 98$).
- **Blocks 3–13 (L7021–7130):** M701 Belt Switch variant ramp ($D$ 99–104).
- **Block 14 (L7131–7140):** Base Mechanic 2 Intro (L7131: M702 Reversing Belt, $D \approx 101$).
- **Blocks 15–25 (L7141–7250):** M702 Reversing Belt variant ramp ($D$ 103–106).
- **Block 26 (L7251–7260):** Base Mechanic 3 Intro (L7251: M703 Belt Lever, $D \approx 105$).
- **Blocks 27–37 (L7261–7370):** M703 Belt Lever variant ramp ($D$ 106–110).
- **Block 38 (L7371–7380):** Base Mechanic 4 Intro (L7371: M704 Track Loop, $D \approx 108$).
- **Blocks 39–49 (L7381–7490):** M704 Track Loop variants and composite Conveyor Networks ($D$ 109–113).
- **Block 50 (L7491–7500):**
  - Level 7491: Review Level ("Feed Dog Factory Mastery", $D \approx 113$).
  - Level 7500: Phase Finale "The Feed Dog Engine" ($D \approx 135$).

### 3. Finale Level 7500 ("The Feed Dog Engine")
- Board layout: 14×14 linen canvas featuring 4 conveyor belts, 2 reversing gears, 2 track loops, and 3 switch junctions forming an intricate mechanized sewing factory.
- Target $D$: 135.0 (CI pre-validated, 0 hearts & 0 boosters solvable).
- Rewards: Unlocks Phase 15 Master Badge, 1,000 Coins, 2 of each booster, and unlocks L7500 Golden Bobbin Rush.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_15_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/slot_allocator.dart` (changed: Phase 15 slot assignments)

## Risks and Open Questions
- None. Parameter limits conform to `SHARED_CORE_STANDARD.md` §11 and `SCALING_TO_10000_LEVELS.md` §6.

Source docs: phase/phase_17/02_LEVEL_PLAN_8001_8500.md, phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-17-signature-system.md, specs/gameplay/phase-17-base-mechanics.md.

# Spec: Gameplay — Phase 17 Level Plan (Levels 8001–8500)

## Status
Draft

## Type
New Feature

## Goal
Specify the 50-block slot map, tier boundaries, difficulty targets ($D$), board sizes, path counts, and milestone levels for Yarn Unravel Phase 17 (Levels 8001–8500).

## Current State
Documented in `phase/phase_17/02_LEVEL_PLAN_8001_8500.md`, not yet implemented in code.

## Proposed Change
Implement the Phase 17 level generation parameters and slot definitions in `packages/puzzle_core`:

### 1. Tier Partitioning & Parameters
Phase 17 covers 500 levels structured into two progression tiers:

| Tier | Levels | Grid Dimensions | Threads ($P$) | Guardian Elements ($O$) | Target $D$ Band |
|---|---|---|---|---|---|
| **P17-A** | 8001–8250 | 12×12 – 13×13 | 28–34 | 8–11 | **103 – 111** |
| **P17-B** | 8251–8500 | 13×13 – 14×14 | 32–40 | 10–14 | **111 – 119** |

- **Difficulty Metric:** $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.
- **Hard Levels (x9):** Every block's x9 level (L8019, L8029 ... L8499) targets $D \approx 130$ ($119 \times 1.10$).
- **Finale Level (L8500):** Targets $D \approx 142$ ($119 \times 1.20$).

### 2. 50-Block Architecture & Progression Map
- **Block 1 (L8001–8010):** Signature Intro (L8001: Basic Pincushion Guardian introduction, $D \approx 103$).
- **Block 2 (L8011–8020):** Base Mechanic 1 Intro (L8011: M801 Twin Pincushions, $D \approx 104$).
- **Blocks 3–13 (L8021–8130):** M801 Twin Pincushions variant ramp ($D$ 105–110).
- **Block 14 (L8131–8140):** Base Mechanic 2 Intro (L8131: M802 Armoured Pincushion, $D \approx 107$).
- **Blocks 15–25 (L8141–8250):** M802 Armoured Pincushion variant ramp ($D$ 109–112).
- **Block 26 (L8251–8260):** Base Mechanic 3 Intro (L8251: M803 Seeding Pincushion, $D \approx 111$).
- **Blocks 27–37 (L8261–8370):** M803 Seeding Pincushion variant ramp ($D$ 112–116).
- **Block 38 (L8371–8380):** Base Mechanic 4 Intro (L8371: M804 Heart Pincushion, $D \approx 114$).
- **Blocks 39–49 (L8371–8490):** M804 Heart Pincushion variants and Royal Court Battles ($D$ 115–119).
- **Block 50 (L8491–8500):**
  - Level 8491: Review Level ("Pincushion Court Mastery", $D \approx 119$).
  - Level 8500: Phase Finale "The Pincushion Sovereign" ($D \approx 142$).

### 3. Finale Level 8500 ("The Pincushion Sovereign")
- Board layout: 14×14 linen canvas featuring a central $3\times 3$ royal velvet sovereign guardian (12 HP), flanked by 2 armoured shield pincushions and 2 seeding spawners.
- Target $D$: 142.0 (CI pre-validated, 0 hearts & 0 boosters solvable).
- Rewards: Unlocks Phase 17 Master Badge, 1,000 Coins, 2 of each booster, and unlocks L8500 Golden Bobbin Rush.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_17_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/slot_allocator.dart` (changed: Phase 17 slot assignments)

## Risks and Open Questions
- None. Parameter limits conform to `SHARED_CORE_STANDARD.md` §11 and `SCALING_TO_10000_LEVELS.md` §6.

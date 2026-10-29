Source docs: phase/phase_13/02_LEVEL_PLAN_6001_6500.md, phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-13-signature-system.md, specs/gameplay/phase-13-base-mechanics.md.

# Spec: Gameplay — Phase 13 Level Plan (Levels 6001–6500)

## Status
Draft

## Type
New Feature

## Goal
Specify the 50-block slot map, tier boundaries, difficulty targets ($D$), board sizes, path counts, and milestone levels for Yarn Unravel Phase 13 (Levels 6001–6500).

## Current State
Documented in `phase/phase_13/02_LEVEL_PLAN_6001_6500.md`, not yet implemented in code.

## Proposed Change
Implement the Phase 13 level generation parameters and slot definitions in `packages/puzzle_core`:

### 1. Tier Partitioning & Parameters
Phase 13 covers 500 levels structured into two progression tiers:

| Tier | Levels | Grid Dimensions | Threads ($P$) | Concealment Items ($O$) | Target $D$ Band |
|---|---|---|---|---|---|
| **P13-A** | 6001–6250 | 12×12 – 13×13 | 28–34 | 8–11 | **91 – 99** |
| **P13-B** | 6251–6500 | 13×13 – 14×14 | 32–40 | 10–14 | **99 – 107** |

- **Difficulty Metric:** $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.
- **Hard Levels (x9):** Every block's x9 level (L6019, L6029 ... L6499) targets $D \approx 118$ ($107 \times 1.10$).
- **Finale Level (L6500):** Targets $D \approx 128$ ($107 \times 1.20$).

### 2. 50-Block Architecture & Progression Map
- **Block 1 (L6001–6010):** Signature Intro (L6001: Basic Wool Fluff fog introduction, $D \approx 91$).
- **Block 2 (L6011–6020):** Base Mechanic 1 Intro (L6011: M601 Scout Thread, $D \approx 92$).
- **Blocks 3–13 (L6021–6130):** M601 Scout Thread variant ramp ($D$ 93–98).
- **Block 14 (L6131–6140):** Base Mechanic 2 Intro (L6131: M602 Decoy Fluff, $D \approx 95$).
- **Blocks 15–25 (L6141–6250):** M602 Decoy Fluff variant ramp ($D$ 97–100).
- **Block 26 (L6251–6260):** Base Mechanic 3 Intro (L6251: M603 Painted Wall, $D \approx 99$).
- **Blocks 27–37 (L6261–6370):** M603 Painted Wall variant ramp ($D$ 100–104).
- **Block 38 (L6371–6380):** Base Mechanic 4 Intro (L6371: M604 Lantern Plate, $D \approx 102$).
- **Blocks 39–49 (L6381–6490):** M604 Lantern Plate variants and composite Mystery Basket levels ($D$ 103–107).
- **Block 50 (L6491–6500):**
  - Level 6491: Review Level ("Mystery Basket Mastery", $D \approx 107$).
  - Level 6500: Phase Finale "The Unveiled Motif" ($D \approx 128$).

### 3. Finale Level 6500 ("The Unveiled Motif")
- Board layout: 14×14 linen canvas featuring 4 extensive Wool Fluff fog zones, 3 Scout Threads, 2 Lantern Plates, and Painted Walls.
- Unraveling the complete board exposes an intricate embroidered motif beneath the wool fluff.
- Yields the Phase 13 Master Badge, 1,000 Coins, 2 of each booster, and unlocks L6500 Golden Bobbin Rush.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_13_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/slot_allocator.dart` (changed: Phase 13 slot assignments)

## Risks and Open Questions
- None. Parameter limits comply with `SHARED_CORE_STANDARD.md` §11 and `SCALING_TO_10000_LEVELS.md` §6.


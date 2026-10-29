Source docs: phase/phase_20/02_LEVEL_PLAN_9501_10000.md, phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §6, §9. Depends on: specs/gameplay/phase-20-signature-system.md, specs/gameplay/phase-20-base-mechanics.md.

# Spec: Gameplay — Phase 20 Level Plan (Levels 9501–10,000)

## Status
Draft

## Type
New Feature

## Goal
Specify the 50-block slot map, tier boundaries, difficulty targets ($D$), board sizes, path counts, Level 10,000 Grand Finale, and milestone rewards for Yarn Unravel Phase 20 (Levels 9501–10,000).

## Current State
Documented in `phase/phase_20/02_LEVEL_PLAN_9501_10000.md`, not yet implemented in code.

## Proposed Change
Implement the Phase 20 level generation parameters and slot definitions in `packages/puzzle_core`:

### 1. Tier Partitioning & Parameters
Phase 20 covers 500 levels structured into two progression tiers:

| Tier | Levels | Grid Dimensions | Threads ($P$) | Master Items ($O$) | Target $D$ Band |
|---|---|---|---|---|---|
| **P20-A** | 9501–9750 | 12×12 – 13×13 | 28–34 | 8–11 | **112 – 120** |
| **P20-B** | 9751–10,000 | 13×13 – 14×14 | 32–40 | 10–14 | **120 – 128** |

- **Difficulty Metric:** $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.
- **Hard Levels (x9):** Every block's x9 level (L9519, L9529 ... L9999) targets $D \approx 140$ ($128 \times 1.10$).
- **Grand Finale Level 10,000:** Targets $D \approx 154$ ($128 \times 1.20$).

### 2. 50-Block Architecture & Progression Map
- **Block 1 (L9501–9510):** Signature Intro (L9501: The Endless Tapestry Prelude, $D \approx 112$).
- **Block 2 (L9511–9520):** Master Mechanic 1 Intro (L9511: M951 Moving Guardian, $D \approx 113$).
- **Blocks 3–13 (L9521–9630):** M951 Moving Guardian variant ramp ($D$ 114–119).
- **Block 14 (L9631–9640):** Master Mechanic 2 Intro (L9631: M952 Omni Gate, $D \approx 116$).
- **Blocks 15–25 (L9641–9750):** M952 Omni Gate variant ramp ($D$ 118–121).
- **Block 26 (L9751–9760):** Master Mechanic 3 Intro (L9751: M953 Grand Loom Spool, $D \approx 120$).
- **Blocks 27–37 (L9761–9870):** M953 Grand Loom Spool variant ramp ($D$ 121–125).
- **Block 38 (L9871–9880):** Master Mechanic 4 Intro (L9871: M954 Master Weaver Key, $D \approx 123$).
- **Blocks 39–49 (L9871–9990):** M954 Master Weaver Key variants and Ultimate Symphony Challenges ($D$ 124–128).
- **Block 50 (L9991–10,000):**
  - Level 9991: Review Level ("Grand Master Review", $D \approx 128$).
  - Level 10,000: **Grand Finale Level 10,000 "The Endless Tapestry"** ($D \approx 154$).

### 3. Grand Finale Level 10,000 ("The Endless Tapestry")
- Board layout: Supreme $14\times 14$ masterwork canvas integrating Moving Guardians, Chromatic Omni Gates, Infinity Bobbins, Mirror Seams, Optical Light Beams, and Day/Night cycles.
- Target $D$: 154.0 (CI pre-validated, 0 hearts & 0 boosters solvable).
- Rewards: Unlocks the permanent "Grand Master Weaver" title, Golden Purl Mascot Badge, 1,000 Coins, 2 of each booster, followed by L10,000 Golden Bobbin Rush.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_20_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/slot_allocator.dart` (changed: Phase 20 slot assignments)

## Risks and Open Questions
- None. Parameter limits conform to `SHARED_CORE_STANDARD.md` §11 and `SCALING_TO_10000_LEVELS.md` §6, §9.


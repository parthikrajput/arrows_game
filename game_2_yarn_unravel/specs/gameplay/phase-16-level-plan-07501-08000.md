Source docs: phase/phase_16/02_LEVEL_PLAN_7501_8000.md, phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-16-signature-system.md, specs/gameplay/phase-16-base-mechanics.md.

# Spec: Gameplay — Phase 16 Level Plan (Levels 7501–8000)

## Status
Draft

## Type
New Feature

## Goal
Specify the 50-block slot map, tier boundaries, difficulty targets ($D$), board sizes, path counts, and milestone levels for Yarn Unravel Phase 16 (Levels 7501–8000).

## Current State
Documented in `phase/phase_16/02_LEVEL_PLAN_7501_8000.md`, not yet implemented in code.

## Proposed Change
Implement the Phase 16 level generation parameters and slot definitions in `packages/puzzle_core`:

### 1. Tier Partitioning & Parameters
Phase 16 covers 500 levels structured into two progression tiers:

| Tier | Levels | Grid Dimensions | Threads ($P$) | Key Items ($O$) | Target $D$ Band |
|---|---|---|---|---|---|
| **P16-A** | 7501–7750 | 12×12 – 13×13 | 28–34 | 8–11 | **100 – 108** |
| **P16-B** | 7751–8000 | 13×13 – 14×14 | 32–40 | 10–14 | **108 – 116** |

- **Difficulty Metric:** $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.
- **Hard Levels (x9):** Every block's x9 level (L7519, L7529 ... L7999) targets $D \approx 127$ ($116 \times 1.10$).
- **Finale Level (L8000):** Targets $D \approx 139$ ($116 \times 1.20$).

### 2. 50-Block Architecture & Progression Map
- **Block 1 (L7501–7510):** Signature Intro (L7501: Basic Key Chain progression, $D \approx 100$).
- **Block 2 (L7511–7520):** Base Mechanic 1 Intro (L7511: M751 Charm Chain, $D \approx 101$).
- **Blocks 3–13 (L7521–7630):** M751 Charm Chain variant ramp ($D$ 102–107).
- **Block 14 (L7631–7640):** Base Mechanic 2 Intro (L7631: M752 Charm Crafting, $D \approx 104$).
- **Blocks 15–25 (L7641–7750):** M752 Charm Crafting variant ramp ($D$ 106–109).
- **Block 26 (L7751–7760):** Base Mechanic 3 Intro (L7751: M753 Skeleton Charm, $D \approx 108$).
- **Blocks 27–37 (L7761–7870):** M753 Skeleton Charm variant ramp ($D$ 109–113).
- **Block 38 (L7871–7880):** Base Mechanic 4 Intro (L7871: M754 Charm Swap Hoop, $D \approx 111$).
- **Blocks 39–49 (L7881–7990):** M754 Charm Swap Hoop variants and composite Locksmith Networks ($D$ 112–116).
- **Block 50 (L7991–8000):**
  - Level 7991: Review Level ("Jewel Box Mastery", $D \approx 116$).
  - Level 8000: Phase Finale "The Master Jewel Box" ($D \approx 139$).

### 3. Finale Level 8000 ("The Master Jewel Box")
- Board layout: 14×14 linen canvas featuring 1 Charm Chain (3 links), 2 Crafting Altars, 1 Skeleton Key, and 2 Swap Hoops forming a grand royal locksmith puzzle.
- Target $D$: 139.0 (CI pre-validated, 0 hearts & 0 boosters solvable).
- Rewards: Unlocks Phase 16 Master Badge, 1,000 Coins, 2 of each booster, and unlocks L8000 Golden Bobbin Rush.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_16_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/slot_allocator.dart` (changed: Phase 16 slot assignments)

## Risks and Open Questions
- None. Parameter limits conform to `SHARED_CORE_STANDARD.md` §11 and `SCALING_TO_10000_LEVELS.md` §6.

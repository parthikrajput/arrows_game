Source docs: phase/phase_14/02_LEVEL_PLAN_6501_7000.md, phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-14-signature-system.md, specs/gameplay/phase-14-base-mechanics.md.

# Spec: Gameplay — Phase 14 Level Plan (Levels 6501–7000)

## Status
Draft

## Type
New Feature

## Goal
Specify the 50-block slot map, tier boundaries, difficulty targets ($D$), board sizes, path counts, and milestone levels for Yarn Unravel Phase 14 (Levels 6501–7000).

## Current State
Documented in `phase/phase_14/02_LEVEL_PLAN_6501_7000.md`, not yet implemented in code.

## Proposed Change
Implement the Phase 14 level generation parameters and slot definitions in `packages/puzzle_core`:

### 1. Tier Partitioning & Parameters
Phase 14 covers 500 levels structured into two progression tiers:

| Tier | Levels | Grid Dimensions | Threads ($P$) | Reflection Items ($O$) | Target $D$ Band |
|---|---|---|---|---|---|
| **P14-A** | 6501–6750 | 12×12 – 13×13 | 28–34 | 8–11 | **94 – 102** |
| **P14-B** | 6751–7000 | 13×13 – 14×14 | 32–40 | 10–14 | **102 – 110** |

- **Difficulty Metric:** $D = 0.6P + 1.5C + 2.0O + 3.0N + 1.0S$.
- **Hard Levels (x9):** Every block's x9 level (L6519, L6529 ... L6999) targets $D \approx 121$ ($110 \times 1.10$).
- **Finale Level (L7000):** Targets $D \approx 132$ ($110 \times 1.20$).

### 2. 50-Block Architecture & Progression Map
- **Block 1 (L6501–6510):** Signature Intro (L6501: Basic Mirror Seam reflection introduction, $D \approx 94$).
- **Block 2 (L6511–6520):** Base Mechanic 1 Intro (L6511: M651 Mirror Seam, $D \approx 95$).
- **Blocks 3–13 (L6521–6630):** M651 Mirror Seam variant ramp ($D$ 96–101).
- **Block 14 (L6631–6640):** Base Mechanic 2 Intro (L6631: M652 Reflect Clasp, $D \approx 98$).
- **Blocks 15–25 (L6641–6750):** M652 Reflect Clasp variant ramp ($D$ 100–103).
- **Block 26 (L6751–6760):** Base Mechanic 3 Intro (L6751: M653 Twin Quilt, $D \approx 102$).
- **Blocks 27–37 (L6761–6870):** M653 Twin Quilt variant ramp ($D$ 103–107).
- **Block 38 (L6871–6880):** Base Mechanic 4 Intro (L6871: M654 Inverse Thread, $D \approx 105$).
- **Blocks 39–49 (L6881–6990):** M654 Inverse Thread variants and composite Looking-Glass Symmetry levels ($D$ 106–110).
- **Block 50 (L6991–7000):**
  - Level 6991: Review Level ("Looking-Glass Quilt Mastery", $D \approx 110$).
  - Level 7000: Phase Finale "The Looking-Glass Masterpiece" ($D \approx 132$).

### 3. Finale Level 7000 ("The Looking-Glass Masterpiece")
- Board layout: 14×14 linen canvas featuring full bilateral symmetry across a central mirror seam, 4 Reflect Clasps, 2 Twin Quilt toggles, and 6 synchronized/inverse thread pairs.
- Unraveling the complete board exposes an intricate mirrored stained-glass quilt pattern.
- Yields the Phase 14 Master Badge, 1,000 Coins, 2 of each booster, and unlocks L7000 Golden Bobbin Rush.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_14_generator_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/slot_allocator.dart` (changed: Phase 14 slot assignments)

## Risks and Open Questions
- None. Limits strictly comply with `SHARED_CORE_STANDARD.md` §11 and `SCALING_TO_10000_LEVELS.md` §6.


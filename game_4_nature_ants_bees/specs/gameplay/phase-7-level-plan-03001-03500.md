Source docs: phase/phase_7/02_LEVEL_PLAN_3001_3500.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-7-base-mechanics.md, specs/gameplay/phase-7-signature-system.md.

# Spec: Gameplay — Phase 7 Level Plan (Levels 3001–3500)

## Status
Draft

## Type
New Feature

## Goal
Define the 500-level progression architecture for Phase 7 (Levels 3001–3500), specifying the 50-block slot map, difficulty plateau bands (D 60–76), rotation tier scaling, line counts, hand-tuned milestone levels, and the L3500 Whirling Blossom Gala Finale.

## Current State
Design documented in `phase/phase_7/02_LEVEL_PLAN_3001_3500.md` and `SHARED_CORE_STANDARD.md` §17.38, not yet implemented.
- Phase 6 established optical raycasting procedural levels.
- Rotational sub-grid transformations and shifting perimeter walls across Levels 3001–3500 are introduced in Phase 7.

## Proposed Change
Establish the level progression parameters and generator constraints for Levels 3001–3500:

### 1. Tiers and Progression Parameters
- **Tier P7-A (Levels 3001–3250):**
  - Grid Sizes: $12\times 12$ to $13\times 13$.
  - Line Count: 28 to 34 lines.
  - Rotation Complexity: Single $4\times 4$ turntable, basic perimeter shifting.
  - Target Difficulty: Plateau band $D \in [60, 68]$.
- **Tier P7-B (Levels 3251–3500):**
  - Grid Sizes: $13\times 13$ to $14\times 14$.
  - Line Count: 32 to 40 lines.
  - Rotation Complexity: Multiple turntables, spinning lines, pinned daisy locks.
  - Target Difficulty: Plateau band $D \in [68, 76]$ (L3500 Finale $D \approx 93$).

### 2. 10-Level Block Slot Structure (Standard §17.38)
Every 10-level block $[B \times 10 + 1, (B+1) \times 10]$ follows an immutable slot template:
| Slot | Role | Target Difficulty | Coin Clear | Reward |
|---|---|---|---|---|
| `x1` | Intro (Signature, Base, or Variant) | Band low (60–63) | 20 | 1-line Tutorial Card |
| `x2–x4` | Practice (Mix with earlier mechanics) | Band mid (64–68) | 20 | — |
| `x5` | Breather (Simpler chains, $\le 25\%$ bees)| Band low (60–62) | 15 | — |
| `x6–x8` | Ramp (Denser boards, rotational timing) | Band high (69–73) | 20 | — |
| `x9` | Hard (Red badge, +10% target D) | Band high $\times 1.1$ (74–76)| 30 | — |
| `x0` | Milestone (Thematic culmination) | Band mid (65–68) | 20 | **Queen's Gift Box** (300 coins + 1 booster)|
| `L3500` | Phase Finale (Whirling Blossom Gala) | Band high $\times 1.2$ ($\approx 93$) | 50 | **Royal Honey Chest** (1,000 coins + 6 boosters)|

### 3. Hand-Tuned Levels
The following levels are pre-designed or seed-pinned to guarantee optimal tutorial pedagogy:
- **L3001:** Signature Intro — Whirling Garden ($12\times 12$, 28 lines, D 60).
- **L3011:** Base 1 Intro — M301 Flower-Bed Turntable ($12\times 12$, 28 lines, D 61).
- **L3131:** Base 2 Intro — M302 Turning Hedge ($13\times 13$, 32 lines, D 65).
- **L3251:** Base 3 Intro — M303 Spinning Top Line ($13\times 13$, 34 lines, D 68).
- **L3371:** Base 4 Intro — M304 Pinned Daisy ($14\times 14$, 36 lines, D 71).
- **L3491:** Review Level — Mastery Mix ($14\times 14$, 40 lines, D 76).
- **L3500:** Phase Finale — Whirling Blossom Gala ($14\times 14$, 40 lines, D 93, all 4 Phase 7 mechanics active).

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_7_level_provider.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/rotation_level_construction.dart` (to be created)

## Risks
- Reverse construction cycle entrapment: Turntable reverse steps generating unsolvable orientation loops. Mitigated by forward solver verification in CI pre-validation pipeline.

## Open Questions
- None. Level progression numbers and slot templates strictly conform to `SHARED_CORE_STANDARD.md` §17.38.

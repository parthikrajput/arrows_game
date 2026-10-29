Source docs: phase/phase_3/02_LEVEL_PLAN_1001_1500.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-3-base-mechanics.md, specs/gameplay/phase-3-signature-system.md.

# Spec: Gameplay — Phase 3 Level Plan (Levels 1001–1500)

## Status
Draft

## Type
New Feature

## Goal
Define the 500-level progression architecture for Phase 3 (Levels 1001–1500), specifying the 50-block slot map, difficulty plateau bands (D 60–76), grid scaling, line counts, hand-tuned milestone levels, and the L1500 Queen's Solstice Gala Finale.

## Current State
Design documented in `phase/phase_3/02_LEVEL_PLAN_1001_1500.md` and `SHARED_CORE_STANDARD.md` §17.38, not yet implemented.
- Phase 1 (L1–500) and Phase 2 (L501–1000) are bundled static JSON archives.
- Phase 3 is the first phase generated procedurally via seeded reverse-construction on device.

## Proposed Change
Establish the level progression parameters and generator constraints for Levels 1001–1500:

### 1. Tiers and Progression Parameters
- **Tier P3-A (Levels 1001–1250):**
  - Grid Sizes: $12\times 12$ to $13\times 13$.
  - Line Count: 28 to 34 lines across ground and air layers.
  - Target Difficulty: Plateau band $D \in [60, 68]$.
- **Tier P3-B (Levels 1251–1500):**
  - Grid Sizes: $13\times 13$ to $14\times 14$.
  - Line Count: 32 to 40 lines.
  - Target Difficulty: Plateau band $D \in [68, 76]$ (L1500 Finale $D \approx 91$).

### 2. 10-Level Block Slot Structure (Standard §17.38)
Every 10-level block $[B \times 10 + 1, (B+1) \times 10]$ follows an immutable slot template:
| Slot | Role | Target Difficulty | Coin Clear | Reward |
|---|---|---|---|---|
| `x1` | Intro (Signature, Base, or Variant) | Band low (60–63) | 20 | 1-line Tutorial Card |
| `x2–x4` | Practice (Mix with earlier mechanics) | Band mid (64–68) | 20 | — |
| `x5` | Breather (Simpler chains, $\le 25\%$ bees)| Band low (60–62) | 15 | — |
| `x6–x8` | Ramp (Denser boards, tighter cycles) | Band high (69–73) | 20 | — |
| `x9` | Hard (Red badge, +10% target D) | Band high $\times 1.1$ (74–76)| 30 | — |
| `x0` | Milestone (Thematic culmination) | Band mid (65–68) | 20 | **Queen's Gift Box** (300 coins + 1 booster)|
| `L1500` | Phase Finale (Queen's Solstice Gala) | Band high $\times 1.2$ ($\approx 91$) | 50 | **Royal Honey Chest** (1,000 coins + 6 boosters)|

### 3. Hand-Tuned Levels
The following levels are pre-designed or seed-pinned to guarantee optimal tutorial pedagogy:
- **L1001:** Signature Intro — Day & Night Cycles ($12\times 12$, 28 lines, D 60).
- **L1011:** Base 1 Intro — M101 Sunrise Gate ($12\times 12$, 28 lines, D 61).
- **L1131:** Base 2 Intro — M102 Moonlit Twig Bridge ($13\times 13$, 32 lines, D 65).
- **L1251:** Base 3 Intro — M103 Dawn Burrow ($13\times 13$, 34 lines, D 68).
- **L1371:** Base 4 Intro — M104 Day-Bloom Line ($14\times 14$, 36 lines, D 71).
- **L1491:** Review Level — Mastery Mix ($14\times 14$, 40 lines, D 76).
- **L1500:** Phase Finale — Queen's Solstice Gala ($14\times 14$, 40 lines, D 91, all 4 Phase 3 mechanics active).

## Affected Files
- `packages/puzzle_core/lib/src/generator/level_plan_provider.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/slot_template.dart` (to be created)

## Risks
- Solver timeout on high-density $14\times 14$ boards with 40 lines. Mitigated by CI pre-validation ensuring all 500 seeds solve in $\le 50\text{ ms}$ on generator test harness.

## Open Questions
- None. Level progression numbers and slot templates strictly conform to `SHARED_CORE_STANDARD.md` §17.38.

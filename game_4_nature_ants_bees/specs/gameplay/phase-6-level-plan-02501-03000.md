Source docs: phase/phase_6/02_LEVEL_PLAN_2501_3000.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-6-base-mechanics.md, specs/gameplay/phase-6-signature-system.md.

# Spec: Gameplay — Phase 6 Level Plan (Levels 2501–3000)

## Status
Draft

## Type
New Feature

## Goal
Define the 500-level progression architecture for Phase 6 (Levels 2501–3000), specifying the 50-block slot map, difficulty plateau bands (D 60–76), optical tier scaling, line counts, hand-tuned milestone levels, and the L3000 Midsummer Solstice Festival Finale.

## Current State
Design documented in `phase/phase_6/02_LEVEL_PLAN_2501_3000.md` and `SHARED_CORE_STANDARD.md` §17.38, not yet implemented.
- Phase 5 established push physics procedural levels.
- Optical raycasting puzzles and light-dependent awakening mechanics across Levels 2501–3000 are introduced in Phase 6.

## Proposed Change
Establish the level progression parameters and generator constraints for Levels 2501–3000:

### 1. Tiers and Progression Parameters
- **Tier P6-A (Levels 2501–2750):**
  - Grid Sizes: $12\times 12$ to $13\times 13$.
  - Line Count: 28 to 34 lines.
  - Optical Complexity: 1 to 2 emitters, single reflections, basic petal filters.
  - Target Difficulty: Plateau band $D \in [60, 68]$.
- **Tier P6-B (Levels 2751–3000):**
  - Grid Sizes: $13\times 13$ to $14\times 14$.
  - Line Count: 32 to 40 lines.
  - Optical Complexity: Multi-emitters, twin-sun gates, sundial timers, dark shade sectors.
  - Target Difficulty: Plateau band $D \in [68, 76]$ (L3000 Finale $D \approx 93$).

### 2. 10-Level Block Slot Structure (Standard §17.38)
Every 10-level block $[B \times 10 + 1, (B+1) \times 10]$ follows an immutable slot template:
| Slot | Role | Target Difficulty | Coin Clear | Reward |
|---|---|---|---|---|
| `x1` | Intro (Signature, Base, or Variant) | Band low (60–63) | 20 | 1-line Tutorial Card |
| `x2–x4` | Practice (Mix with earlier mechanics) | Band mid (64–68) | 20 | — |
| `x5` | Breather (Simpler chains, $\le 25\%$ bees)| Band low (60–62) | 15 | — |
| `x6–x8` | Ramp (Denser boards, optical redirects) | Band high (69–73) | 20 | — |
| `x9` | Hard (Red badge, +10% target D) | Band high $\times 1.1$ (74–76)| 30 | — |
| `x0` | Milestone (Thematic culmination) | Band mid (65–68) | 20 | **Queen's Gift Box** (300 coins + 1 booster)|
| `L3000` | Phase Finale (Midsummer Solstice Festival)| Band high $\times 1.2$ ($\approx 93$) | 50 | **Royal Honey Chest** (1,000 coins + 6 boosters)|

### 3. Hand-Tuned Levels
The following levels are pre-designed or seed-pinned to guarantee optimal tutorial pedagogy:
- **L2501:** Signature Intro — Sunlit Garden ($12\times 12$, 28 lines, D 60).
- **L2511:** Base 1 Intro — M251 Petal Filter ($12\times 12$, 28 lines, D 61).
- **L2631:** Base 2 Intro — M252 Twin-Sun Lock ($13\times 13$, 32 lines, D 65).
- **L2751:** Base 3 Intro — M253 Sundial Lens ($13\times 13$, 34 lines, D 68).
- **L2871:** Base 4 Intro — M254 Shade Patch ($14\times 14$, 36 lines, D 71).
- **L2991:** Review Level — Mastery Mix ($14\times 14$, 40 lines, D 76).
- **L3000:** Phase Finale — Midsummer Solstice Festival ($14\times 14$, 40 lines, D 93, all 4 Phase 6 mechanics active).

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_6_level_provider.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/optical_level_construction.dart` (to be created)

## Risks
- Raycast calculation bottleneck during reverse construction solver search. Mitigated by using 2D bitmask ray projection for instant line-of-sight checks.

## Open Questions
- None. Level progression numbers and slot templates strictly conform to `SHARED_CORE_STANDARD.md` §17.38.

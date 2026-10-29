Source docs: phase/phase_5/02_LEVEL_PLAN_2001_2500.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-5-base-mechanics.md, specs/gameplay/phase-5-signature-system.md.

# Spec: Gameplay — Phase 5 Level Plan (Levels 2001–2500)

## Status
Draft

## Type
New Feature

## Goal
Define the 500-level progression architecture for Phase 5 (Levels 2001–2500), specifying the 50-block slot map, difficulty plateau bands (D 60–76), grid scaling, line counts, hand-tuned milestone levels, and the L2500 Autumn Harvest Festival Finale.

## Current State
Design documented in `phase/phase_5/02_LEVEL_PLAN_2001_2500.md` and `SHARED_CORE_STANDARD.md` §17.38, not yet implemented.
- Phase 4 established multi-floor seeded levels.
- Push physics complexity and momentum constraints across Levels 2001–2500 are introduced in Phase 5.

## Proposed Change
Establish the level progression parameters and generator constraints for Levels 2001–2500:

### 1. Tiers and Progression Parameters
- **Tier P5-A (Levels 2001–2250):**
  - Grid Sizes: $12\times 12$ to $13\times 13$.
  - Line Count: 28 to 34 lines.
  - Target Difficulty: Plateau band $D \in [60, 68]$.
- **Tier P5-B (Levels 2251–2500):**
  - Grid Sizes: $13\times 13$ to $14\times 14$.
  - Line Count: 32 to 40 lines.
  - Target Difficulty: Plateau band $D \in [68, 76]$ (L2500 Finale $D \approx 92$).

### 2. 10-Level Block Slot Structure (Standard §17.38)
Every 10-level block $[B \times 10 + 1, (B+1) \times 10]$ follows an immutable slot template:
| Slot | Role | Target Difficulty | Coin Clear | Reward |
|---|---|---|---|---|
| `x1` | Intro (Signature, Base, or Variant) | Band low (60–63) | 20 | 1-line Tutorial Card |
| `x2–x4` | Practice (Mix with earlier mechanics) | Band mid (64–68) | 20 | — |
| `x5` | Breather (Simpler chains, $\le 25\%$ bees)| Band low (60–62) | 15 | — |
| `x6–x8` | Ramp (Denser boards, multi-block push) | Band high (69–73) | 20 | — |
| `x9` | Hard (Red badge, +10% target D) | Band high $\times 1.1$ (74–76)| 30 | — |
| `x0` | Milestone (Thematic culmination) | Band mid (65–68) | 20 | **Queen's Gift Box** (300 coins + 1 booster)|
| `L2500` | Phase Finale (Autumn Harvest Festival) | Band high $\times 1.2$ ($\approx 92$) | 50 | **Royal Honey Chest** (1,000 coins + 6 boosters)|

### 3. Hand-Tuned Levels
The following levels are pre-designed or seed-pinned to guarantee optimal tutorial pedagogy:
- **L2001:** Signature Intro — Acorn Physics ($12\times 12$, 28 lines, D 60).
- **L2011:** Base 1 Intro — M201 Mole Hole ($12\times 12$, 28 lines, D 61).
- **L2131:** Base 2 Intro — M202 Dewdrop Marble ($13\times 13$, 32 lines, D 65).
- **L2251:** Base 3 Intro — M203 Seed Key Pod ($13\times 13$, 34 lines, D 68).
- **L2371:** Base 4 Intro — M204 Stone Pumpkin ($14\times 14$, 36 lines, D 71).
- **L2491:** Review Level — Mastery Mix ($14\times 14$, 40 lines, D 76).
- **L2500:** Phase Finale — Autumn Harvest Festival ($14\times 14$, 40 lines, D 92, all 4 Phase 5 mechanics active).

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_5_level_provider.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/push_level_construction.dart` (to be created)

## Risks
- Accidental push block pinning: Pushing a required key block into a corner where no line can reach it. Mitigated by solver tracking irreversible corner states and pruning non-solvable candidate seeds.

## Open Questions
- None. Level progression numbers and slot templates strictly conform to `SHARED_CORE_STANDARD.md` §17.38.


Source docs: phase/phase_4/02_LEVEL_PLAN_1501_2000.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-4-base-mechanics.md, specs/gameplay/phase-4-signature-system.md.

# Spec: Gameplay — Phase 4 Level Plan (Levels 1501–2000)

## Status
Draft

## Type
New Feature

## Goal
Define the 500-level progression architecture for Phase 4 (Levels 1501–2000), specifying the 50-block slot map, difficulty plateau bands (D 60–76), multi-floor tier scaling (2 to 3 floors), line counts, and the L2000 Terrace Summit Gala Finale.

## Current State
Design documented in `phase/phase_4/02_LEVEL_PLAN_1501_2000.md` and `SHARED_CORE_STANDARD.md` §17.38, not yet implemented.
- Phase 3 established procedural seeded generation for single-floor boards.
- Multi-floor level schemas and floor progression allocations are introduced in Phase 4.

## Proposed Change
Establish the level progression parameters and generator constraints for Levels 1501–2000:

### 1. Tiers and Progression Parameters
- **Tier P4-A (Levels 1501–1750):**
  - Floors: Exactly 2 floors (Lower Terrace, Main Garden).
  - Grid Sizes: $12\times 12$ to $13\times 13$ per floor.
  - Line Count: 28 to 34 lines across all floors and layers.
  - Target Difficulty: Plateau band $D \in [60, 68]$.
- **Tier P4-B (Levels 1751–2000):**
  - Floors: 2 to 3 floors (introducing Upper Canopy at L1751).
  - Grid Sizes: $13\times 13$ to $14\times 14$ per floor.
  - Line Count: 32 to 40 lines across all floors and layers.
  - Target Difficulty: Plateau band $D \in [68, 76]$ (L2000 Finale $D \approx 92$).

### 2. 10-Level Block Slot Structure (Standard §17.38)
Every 10-level block $[B \times 10 + 1, (B+1) \times 10]$ follows an immutable slot template:
| Slot | Role | Target Difficulty | Coin Clear | Reward |
|---|---|---|---|---|
| `x1` | Intro (Signature, Base, or Variant) | Band low (60–63) | 20 | 1-line Tutorial Card |
| `x2–x4` | Practice (Mix with earlier mechanics) | Band mid (64–68) | 20 | — |
| `x5` | Breather (Simpler chains, $\le 25\%$ bees)| Band low (60–62) | 15 | — |
| `x6–x8` | Ramp (Denser boards, inter-floor transit) | Band high (69–73) | 20 | — |
| `x9` | Hard (Red badge, +10% target D) | Band high $\times 1.1$ (74–76)| 30 | — |
| `x0` | Milestone (Thematic culmination) | Band mid (65–68) | 20 | **Queen's Gift Box** (300 coins + 1 booster)|
| `L2000` | Phase Finale (Terrace Summit Gala) | Band high $\times 1.2$ ($\approx 92$) | 50 | **Royal Honey Chest** (1,000 coins + 6 boosters)|

### 3. Hand-Tuned Levels
The following levels are pre-designed or seed-pinned to guarantee optimal tutorial pedagogy:
- **L1501:** Signature Intro — Garden Terraces ($12\times 12$, 2 floors, 28 lines, D 60).
- **L1511:** Base 1 Intro — M151 Root Stairs ($12\times 12$, 2 floors, 28 lines, D 61).
- **L1631:** Base 2 Intro — M152 Dew-Glass Terrace ($13\times 13$, 2 floors, 32 lines, D 65).
- **L1751:** Base 3 Intro — M1751 Rabbit Hole & 3-Floor Canopy Onboarding ($13\times 13$, 3 floors, 34 lines, D 68).
- **L1871:** Base 4 Intro — M154 Acorn Lift ($14\times 14$, 3 floors, 36 lines, D 71).
- **L1991:** Review Level — Mastery Mix ($14\times 14$, 3 floors, 40 lines, D 76).
- **L2000:** Phase Finale — Terrace Summit Gala ($14\times 14$, 3 floors, 40 lines, D 92, all 4 Phase 4 mechanics active).

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_4_level_provider.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/multi_floor_construction.dart` (to be created)

## Risks
- Search space explosion in IDA* solver when branching across 3 independent floors. Mitigated by partitioning line dependencies per floor and using floor-reachability pruning heuristics.

## Open Questions
- None. Level progression numbers and slot templates strictly conform to `SHARED_CORE_STANDARD.md` §17.38.


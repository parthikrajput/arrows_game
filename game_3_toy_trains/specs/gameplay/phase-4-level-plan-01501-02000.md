Source docs: phase/phase_4/02_LEVEL_PLAN_1501_2000.md, ../../SHARED_CORE_STANDARD.md §11, §17.24, §17.38. Depends on: specs/gameplay/phase-4-signature-system.md, specs/gameplay/phase-3-level-plan-01001-01500.md.

# Spec: Gameplay — Phase 4 Level Plan 1501–2000

## Status
Draft

## Type
New Feature

## Goal
Establish the 500-level procedural generation architecture for Phase 4 (Levels 1501–2000) of Toy Trains: Wooden Railway Puzzle, establishing the fixed difficulty plateau (D 60–76), procedural slot map across vertical floors, review level L1991, and L2000 Multi-Tier Central Depot Finale.

## Current State
Design documented in `phase/phase_4/02_LEVEL_PLAN_1501_2000.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 3 introduced on-device procedural generation for cyclic boards.
- Phase 4 expands procedural generation to partition board layouts across up to 3 vertical station floors.

## Proposed Change
Implement generator parameters and floor distribution constraints in `tools/levelgen` and `packages/puzzle_core`:

### 1. Tiers & Difficulty Plateau (D 60–76)
Adheres strictly to standard §17.24 fixed difficulty plateau:

| Tier | Levels | Grid Dimensions | Floors | Train Count | Max Obstacles | Difficulty Target ($D$) | x9 Hard Target |
|---|---|---|---|---|---|---|---|
| **P4-A** | 1501–1750 | 12x12 to 13x13 | 2 Floors | 30–38 | 8–14 | **60–68** (Low 60–62.7, Mid 62.7–65.3, High 65.3–68) | 74 ±3 |
| **P4-B** | 1751–2000 | 12x12 to 14x14 | 2–3 Floors | 34–44 | 10–16 | **68–76** (Low 68–70.7, Mid 70.7–73.3, High 73.3–76) | 82 ±3 |

- **L2000 Finale Target:** Target $D \approx 76 \times 1.2 = \mathbf{91 \pm 3}$.
- **Floor Distribution:** In Tier P4-A, levels span 2 floors (F1 & F2); in Tier P4-B, levels utilize 3 floors (F1, F2, & F3).

### 2. Slot Mapping Across 50 Blocks
- **Block 1, x1 (L1501):** Signature System Intro (`S04` Station Floors intro level, 2 floors, 0 other new mechanics).
- **Block 2, x1 (L1511):** Base Mechanic M151 Station Stairs intro.
- **Block 14, x1 (L1631):** Base Mechanic M152 Glass Platform intro.
- **Block 26, x1 (L1751):** Base Mechanic M153 Goods Chute intro.
- **Block 38, x1 (L1871):** Base Mechanic M154 Goods Lift intro.
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1):** 45 Multi-Floor Variant Slots.
- **Block 50, x1 (L1991):** Review Level ("Mastery Mix" — 0 new items, multi-floor multi-mechanic synthesis).
- **Block 50, x0 (L2000):** Milestone Finale "Multi-Tier Central Depot".

### 3. Solvability & Reverse Construction Rules
- Reverse construction places trains on their destination floors first, ensuring all vertical chutes, stairs, and lifts have open departure lanes.
- Each intro level ($x1$) contains strictly the intro mechanic plus $\le 1$ earlier mechanic.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_4_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/multi_floor_reverse_constructor.dart` (to be created)

## Risks
- Trains rendered inaccessible if lower floor exit lanes are permanently blocked by unmovable upper-layer drop columns. Mitigated by solver dependency tree check.

## Open Questions
- None. All parameters match `phase/phase_4/02_LEVEL_PLAN_1501_2000.md` and `SHARED_CORE_STANDARD.md`.


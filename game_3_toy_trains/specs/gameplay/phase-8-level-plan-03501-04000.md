Source docs: phase/phase_8/02_LEVEL_PLAN_3501_4000.md, ../../SHARED_CORE_STANDARD.md §11, §17.24, §17.38. Depends on: specs/gameplay/phase-8-signature-system.md, specs/gameplay/phase-7-level-plan-03001-03500.md.

# Spec: Gameplay — Phase 8 Level Plan 3501–4000

## Status
Draft

## Type
New Feature

## Goal
Establish the 500-level procedural generation architecture for Phase 8 (Levels 3501–4000) of Toy Trains: Wooden Railway Puzzle, establishing the fixed difficulty plateau (D 60–76), botanical branch line slot distribution, review level L3991, and L4000 Botanical Terminal Garden Finale.

## Current State
Design documented in `phase/phase_8/02_LEVEL_PLAN_3501_4000.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases developed procedural layouts for planar cycles, multi-floor tracks, shunting carts, optical beams, and 4x4 rotors.
- Phase 8 integrates cellular automata growth expansion constraints into procedural level generation.

## Proposed Change
Implement generator parameters and botanical growth constraints in `tools/levelgen` and `packages/puzzle_core`:

### 1. Tiers & Difficulty Plateau (D 60–76)
Adheres strictly to standard §17.24 fixed difficulty plateau:

| Tier | Levels | Grid Dimensions | Train Count | Botanical Obstacles | Difficulty Target ($D$) | x9 Hard Target |
|---|---|---|---|---|---|---|
| **P8-A** | 3501–3750 | 12x12 to 13x13 | 30–38 | 8–14 | **60–68** (Low 60–62.7, Mid 62.7–65.3, High 65.3–68) | 74 ±3 |
| **P8-B** | 3751–4000 | 12x12 to 14x14 | 34–44 | 10–16 | **68–76** (Low 68–70.7, Mid 70.7–73.3, High 73.3–76) | 82 ±3 |

- **L4000 Finale Target:** Target $D \approx 76 \times 1.2 = \mathbf{91 \pm 3}$.
- **Pinch-Zoom / Pan:** Permanently active across all levels (grid $\ge 12\times 12$).

### 2. Slot Mapping Across 50 Blocks
- **Block 1, x1 (L3501):** Signature System Intro (`S08` Overgrown Branch Line intro level, basic ivy growth, 0 other new mechanics).
- **Block 2, x1 (L3511):** Base Mechanic M351 Wild Ivy+ intro.
- **Block 14, x1 (L3631):** Base Mechanic M352 Hedge Trimmer Car intro.
- **Block 26, x1 (L3751):** Base Mechanic M353 Seed Wagon intro.
- **Block 38, x1 (L3871):** Base Mechanic M354 Flower Arch intro.
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1):** 45 Botanical Variant Slots.
- **Block 50, x1 (L3991):** Review Level ("Mastery Mix" — 0 new items, complex overgrown junction matrix).
- **Block 50, x0 (L4000):** Milestone Finale "Botanical Terminal Garden".

### 3. Solvability & Growth Simulation Rules
- Reverse construction simulates backward vine retraction and pruning clearing passes, ensuring provable solvability.
- Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_8_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/growth_reverse_constructor.dart` (to be created)

## Risks
- Solver path pruning failures if branching ivy creates vast cellular permutations. Mitigation: Bounding box growth envelope restricts potential expansion cells.

## Open Questions
- None. All parameters match `phase/phase_8/02_LEVEL_PLAN_3501_4000.md` and `SHARED_CORE_STANDARD.md`.

Source docs: phase/phase_9/02_LEVEL_PLAN_4001_4500.md, ../../SHARED_CORE_STANDARD.md §11, §17.24, §17.38. Depends on: specs/gameplay/phase-9-signature-system.md, specs/gameplay/phase-8-level-plan-03501-04000.md.

# Spec: Gameplay — Phase 9 Level Plan 4001–4500

## Status
Draft

## Type
New Feature

## Goal
Establish the 500-level procedural generation architecture for Phase 9 (Levels 4001–4500) of Toy Trains: Wooden Railway Puzzle, establishing the fixed difficulty plateau (D 60–76), dynamic train composition slot distribution, review level L4491, and L4500 Grand Junction Coupling Yard Finale.

## Current State
Design documented in `phase/phase_9/02_LEVEL_PLAN_4001_4500.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases developed procedural layouts for planar cycles, multi-floor tracks, shunting carts, optical beams, 4x4 rotors, and botanical vines.
- Phase 9 incorporates runtime train entity merging and splitting constraints into procedural level generation.

## Proposed Change
Implement generator parameters and train composition constraints in `tools/levelgen` and `packages/puzzle_core`:

### 1. Tiers & Difficulty Plateau (D 60–76)
Adheres strictly to standard §17.24 fixed difficulty plateau:

| Tier | Levels | Grid Dimensions | Train Count | Composition Obstacles | Difficulty Target ($D$) | x9 Hard Target |
|---|---|---|---|---|---|---|
| **P9-A** | 4001–4250 | 12x12 to 13x13 | 30–38 | 8–14 | **60–68** (Low 60–62.7, Mid 62.7–65.3, High 65.3–68) | 74 ±3 |
| **P9-B** | 4251–4500 | 12x12 to 14x14 | 34–44 | 10–16 | **68–76** (Low 68–70.7, Mid 70.7–73.3, High 73.3–76) | 82 ±3 |

- **L4500 Finale Target:** Target $D \approx 76 \times 1.2 = \mathbf{91 \pm 3}$.
- **Pinch-Zoom / Pan:** Permanently active across all levels (grid $\ge 12\times 12$).

### 2. Slot Mapping Across 50 Blocks
- **Block 1, x1 (L4001):** Signature System Intro (`S09` Couple & Uncouple intro level, basic coupling pad merge, 0 other new mechanics).
- **Block 2, x1 (L4011):** Base Mechanic M401 Coupling Pad intro.
- **Block 14, x1 (L4131):** Base Mechanic M402 Twin Split Train intro.
- **Block 26, x1 (L4251):** Base Mechanic M403 Coupling Lock intro.
- **Block 38, x1 (L4371):** Base Mechanic M404 Rejoin Arch intro.
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1):** 45 Train Composition Variant Slots.
- **Block 50, x1 (L4491):** Review Level ("Mastery Mix" — 0 new items, complex multi-coupling junction matrix).
- **Block 50, x0 (L4500):** Milestone Finale "Grand Junction Coupling Yard".

### 3. Solvability & Composition Simulation Rules
- Reverse construction unmerges trains backwards and merges split pairs, guaranteeing strictly provable solutions.
- Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_9_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/composition_reverse_constructor.dart` (to be created)

## Risks
- Entity ID management conflicts when newly split trains generate new runtime identifiers. Mitigation: Deterministic sub-ID naming scheme (`${parentPathId}_a` and `${parentPathId}_b`).

## Open Questions
- None. All parameters match `phase/phase_9/02_LEVEL_PLAN_4001_4500.md` and `SHARED_CORE_STANDARD.md`.

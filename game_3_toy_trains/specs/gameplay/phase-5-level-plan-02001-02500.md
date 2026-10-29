Source docs: phase/phase_5/02_LEVEL_PLAN_2001_2500.md, ../../SHARED_CORE_STANDARD.md §11, §17.24, §17.38. Depends on: specs/gameplay/phase-5-signature-system.md, specs/gameplay/phase-4-level-plan-01501-02000.md.

# Spec: Gameplay — Phase 5 Level Plan 2001–2500

## Status
Draft

## Type
New Feature

## Goal
Establish the 500-level procedural generation architecture for Phase 5 (Levels 2001–2500) of Toy Trains: Wooden Railway Puzzle, establishing the fixed difficulty plateau (D 60–76), shunting puzzle slot distribution, review level L2491, and L2500 Shunting Master Yard Finale.

## Current State
Design documented in `phase/phase_5/02_LEVEL_PLAN_2001_2500.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases developed procedural layouts for planar cycles and multi-floor environments.
- Phase 5 configures procedural reverse construction to simulate shunting displacement dependencies.

## Proposed Change
Implement generator parameters and shunting layout constraints in `tools/levelgen` and `packages/puzzle_core`:

### 1. Tiers & Difficulty Plateau (D 60–76)
Adheres strictly to standard §17.24 fixed difficulty plateau:

| Tier | Levels | Grid Dimensions | Train Count | Obstacles & Carts | Difficulty Target ($D$) | x9 Hard Target |
|---|---|---|---|---|---|---|
| **P5-A** | 2001–2250 | 12x12 to 13x13 | 30–38 | 8–14 | **60–68** (Low 60–62.7, Mid 62.7–65.3, High 65.3–68) | 74 ±3 |
| **P5-B** | 2251–2500 | 12x12 to 14x14 | 34–44 | 10–16 | **68–76** (Low 68–70.7, Mid 70.7–73.3, High 73.3–76) | 82 ±3 |

- **L2500 Finale Target:** Target $D \approx 76 \times 1.2 = \mathbf{91 \pm 3}$.
- **Pinch-Zoom / Pan:** Permanently active across all levels (grid $\ge 12\times 12$).

### 2. Slot Mapping Across 50 Blocks
- **Block 1, x1 (L2001):** Signature System Intro (`S05` Yard Shunting+ intro level, basic cart push, 0 other new mechanics).
- **Block 2, x1 (L2011):** Base Mechanic M201 Cart Pit intro.
- **Block 14, x1 (L2131):** Base Mechanic M202 Ice Block Cart intro.
- **Block 26, x1 (L2251):** Base Mechanic M203 Ticket Cart intro.
- **Block 38, x1 (L2371):** Base Mechanic M204 Ballast Cart intro.
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1):** 45 Shunting Variant Slots.
- **Block 50, x1 (L2491):** Review Level ("Mastery Mix" — 0 new items, complex multi-cart shunting yard).
- **Block 50, x0 (L2500):** Milestone Finale "Shunting Master Yard".

### 3. Solvability & Shunting Validation Rules
- Reverse construction simulates backward cart pulls from pits and sensor pads, guaranteeing reachable solutions.
- Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_5_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/shunting_reverse_constructor.dart` (to be created)

## Risks
- Excessive state search depth for IDA* solver due to movable carts expanding branching factor. Mitigation: Heuristic weighting prioritizing train exit progress over cart position changes.

## Open Questions
- None. All parameters match `phase/phase_5/02_LEVEL_PLAN_2001_2500.md` and `SHARED_CORE_STANDARD.md`.


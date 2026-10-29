Source docs: phase/phase_7/02_LEVEL_PLAN_3001_3500.md, ../../SHARED_CORE_STANDARD.md §11, §17.24, §17.38. Depends on: specs/gameplay/phase-7-signature-system.md, specs/gameplay/phase-6-level-plan-02501-03000.md.

# Spec: Gameplay — Phase 7 Level Plan 3001–3500

## Status
Draft

## Type
New Feature

## Goal
Establish the 500-level procedural generation architecture for Phase 7 (Levels 3001–3500) of Toy Trains: Wooden Railway Puzzle, establishing the fixed difficulty plateau (D 60–76), rotational yard slot distribution, review level L3491, and L3500 Grand Rotary Central Yard Finale.

## Current State
Design documented in `phase/phase_7/02_LEVEL_PLAN_3001_3500.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases developed procedural layouts for planar cycles, multi-floor tracks, shunting carts, and optical signals.
- Phase 7 configures procedural reverse construction to simulate multi-train sub-board rotational dependencies.

## Proposed Change
Implement generator parameters and rotational layout constraints in `tools/levelgen` and `packages/puzzle_core`:

### 1. Tiers & Difficulty Plateau (D 60–76)
Adheres strictly to standard §17.24 fixed difficulty plateau:

| Tier | Levels | Grid Dimensions | Train Count | Rotational Obstacles | Difficulty Target ($D$) | x9 Hard Target |
|---|---|---|---|---|---|---|
| **P7-A** | 3001–3250 | 12x12 to 13x13 | 30–38 | 8–14 | **60–68** (Low 60–62.7, Mid 62.7–65.3, High 65.3–68) | 74 ±3 |
| **P7-B** | 3251–3500 | 12x12 to 14x14 | 34–44 | 10–16 | **68–76** (Low 68–70.7, Mid 70.7–73.3, High 73.3–76) | 82 ±3 |

- **L3500 Finale Target:** Target $D \approx 76 \times 1.2 = \mathbf{91 \pm 3}$.
- **Pinch-Zoom / Pan:** Permanently active across all levels (grid $\ge 12\times 12$).

### 2. Slot Mapping Across 50 Blocks
- **Block 1, x1 (L3001):** Signature System Intro (`S07` Turntable Yards+ intro level, basic 4x4 rotor, 0 other new mechanics).
- **Block 2, x1 (L3011):** Base Mechanic M301 Rotating Yard Block intro.
- **Block 14, x1 (L3131):** Base Mechanic M302 Spinning Station Exits intro.
- **Block 26, x1 (L3251):** Base Mechanic M303 Spinner Engine intro.
- **Block 38, x1 (L3371):** Base Mechanic M304 Turntable Lock intro.
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1):** 45 Rotational Variant Slots.
- **Block 50, x1 (L3491):** Review Level ("Mastery Mix" — 0 new items, complex multi-rotor yard matrix).
- **Block 50, x0 (L3500):** Milestone Finale "Grand Rotary Central Yard".

### 3. Solvability & Rotational Validation Rules
- Reverse construction rotates placed trains backwards across rotor angles, ensuring all departures remain strictly reachable.
- Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_7_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/rotational_reverse_constructor.dart` (to be created)

## Risks
- Solver branching explosion from 4x4 rotors altering up to 6 trains' headings simultaneously. Mitigation: Rotor rotations treated as atomic transitions with pre-computed dependency checks.

## Open Questions
- None. All parameters match `phase/phase_7/02_LEVEL_PLAN_3001_3500.md` and `SHARED_CORE_STANDARD.md`.

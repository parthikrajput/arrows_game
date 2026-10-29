Source docs: phase/phase_6/02_LEVEL_PLAN_2501_3000.md, ../../SHARED_CORE_STANDARD.md §11, §17.24, §17.38. Depends on: specs/gameplay/phase-6-signature-system.md, specs/gameplay/phase-5-level-plan-02001-02500.md.

# Spec: Gameplay — Phase 6 Level Plan 2501–3000

## Status
Draft

## Type
New Feature

## Goal
Establish the 500-level procedural generation architecture for Phase 6 (Levels 2501–3000) of Toy Trains: Wooden Railway Puzzle, establishing the fixed difficulty plateau (D 60–76), optical rail slot distribution, review level L2991, and L3000 Signal Master Grand Junction Finale.

## Current State
Design documented in `phase/phase_6/02_LEVEL_PLAN_2501_3000.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases developed procedural layouts for planar cycles, multi-floor tracks, and shunting carts.
- Phase 6 incorporates line-of-sight optical ray constraints into procedural layout generation.

## Proposed Change
Implement generator parameters and optical layout constraints in `tools/levelgen` and `packages/puzzle_core`:

### 1. Tiers & Difficulty Plateau (D 60–76)
Adheres strictly to standard §17.24 fixed difficulty plateau:

| Tier | Levels | Grid Dimensions | Train Count | Optical Obstacles | Difficulty Target ($D$) | x9 Hard Target |
|---|---|---|---|---|---|---|
| **P6-A** | 2501–2750 | 12x12 to 13x13 | 30–38 | 8–14 | **60–68** (Low 60–62.7, Mid 62.7–65.3, High 65.3–68) | 74 ±3 |
| **P6-B** | 2751–3000 | 12x12 to 14x14 | 34–44 | 10–16 | **68–76** (Low 68–70.7, Mid 70.7–73.3, High 73.3–76) | 82 ±3 |

- **L3000 Finale Target:** Target $D \approx 76 \times 1.2 = \mathbf{91 \pm 3}$.
- **Pinch-Zoom / Pan:** Permanently active across all levels (grid $\ge 12\times 12$).

### 2. Slot Mapping Across 50 Blocks
- **Block 1, x1 (L2501):** Signature System Intro (`S06` Signal Lights+ intro level, basic lamp & sensor gate, 0 other new mechanics).
- **Block 2, x1 (L2511):** Base Mechanic M251 Coloured Lens intro.
- **Block 14, x1 (L2631):** Base Mechanic M252 Twin Sensor Gate intro.
- **Block 26, x1 (L2751):** Base Mechanic M253 Lamp Timer intro.
- **Block 38, x1 (L2871):** Base Mechanic M254 Blackout Patch intro.
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1):** 45 Optical Variant Slots.
- **Block 50, x1 (L2991):** Review Level ("Mastery Mix" — 0 new items, complex optical puzzle matrix).
- **Block 50, x0 (L3000):** Milestone Finale "Signal Master Grand Junction".

### 3. Solvability & Optical Validation Rules
- Reverse construction projects optical rays backwards from sensors to lamps, ensuring all gates can be opened.
- Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_6_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/optical_reverse_constructor.dart` (to be created)

## Risks
- Raycast validation latency during automated seed testing. Mitigation: Bounding-box early exit for unobstructed corridors.

## Open Questions
- None. All parameters match `phase/phase_6/02_LEVEL_PLAN_2501_3000.md` and `SHARED_CORE_STANDARD.md`.

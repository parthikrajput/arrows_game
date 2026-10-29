Source docs: phase/phase_10/02_LEVEL_PLAN_4501_5000.md, ../../SHARED_CORE_STANDARD.md §11, §17.24, §17.38. Depends on: specs/gameplay/phase-10-signature-system.md, specs/gameplay/phase-9-level-plan-04001-04500.md.

# Spec: Gameplay — Phase 10 Level Plan 4501–5000

## Status
Draft

## Type
New Feature

## Goal
Establish the 500-level procedural generation architecture for Phase 10 (Levels 4501–5000) of Toy Trains: Wooden Railway Puzzle, establishing the fixed difficulty plateau (D 60–76), dispatch sequencing slot distribution, review level L4991, and L5000 Master Timetable Clock Tower Finale.

## Current State
Design documented in `phase/phase_10/02_LEVEL_PLAN_4501_5000.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases developed procedural layouts for planar cycles, multi-floor tracks, shunting carts, optical beams, 4x4 rotors, botanical growth, and coupling pads.
- Phase 10 incorporates chronological and rhythmic dispatch constraints into procedural level generation.

## Proposed Change
Implement generator parameters and sequencing constraints in `tools/levelgen` and `packages/puzzle_core`:

### 1. Tiers & Difficulty Plateau (D 60–76)
Adheres strictly to standard §17.24 fixed difficulty plateau:

| Tier | Levels | Grid Dimensions | Train Count | Sequencing Obstacles | Difficulty Target ($D$) | x9 Hard Target |
|---|---|---|---|---|---|---|
| **P10-A** | 4501–4750 | 12x12 to 13x13 | 30–38 | 8–14 | **60–68** (Low 60–62.7, Mid 62.7–65.3, High 65.3–68) | 74 ±3 |
| **P10-B** | 4751–5000 | 12x12 to 14x14 | 34–44 | 10–16 | **68–76** (Low 68–70.7, Mid 70.7–73.3, High 73.3–76) | 82 ±3 |

- **L5000 Finale Target:** Target $D \approx 76 \times 1.2 = \mathbf{91 \pm 3}$.
- **Pinch-Zoom / Pan:** Permanently active across all levels (grid $\ge 12\times 12$).

### 2. Slot Mapping Across 50 Blocks
- **Block 1, x1 (L4501):** Signature System Intro (`S10` Timetable Master intro level, basic metronome gate, 0 other new mechanics).
- **Block 2, x1 (L4511):** Base Mechanic M451 Metronome Gate intro.
- **Block 14, x1 (L4631):** Base Mechanic M452 Departure Code Lock intro.
- **Block 26, x1 (L4751):** Base Mechanic M453 Platform Order Exit intro.
- **Block 38, x1 (L4871):** Base Mechanic M454 Echo Signal intro.
- **Blocks 3–13, 15–25, 27–37, 39–49 (x1):** 45 Sequencing Variant Slots.
- **Block 50, x1 (L4991):** Review Level ("Mastery Mix" — 0 new items, complex clockwork rhythm matrix).
- **Block 50, x0 (L5000):** Milestone Finale "Master Timetable Clock Tower".

### 3. Solvability & Chronological Validation Rules
- Reverse construction places trains according to verified chronological dispatch order, ensuring no deadlock occurs.
- Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.

## Affected Files
- `packages/puzzle_core/lib/src/generator/phase_10_config.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/sequencing_reverse_constructor.dart` (to be created)

## Risks
- Metronome cycle mismatch causing exponential solver depth. Mitigation: Metronome pattern length bounded to max 4 steps.

## Open Questions
- None. All parameters match `phase/phase_10/02_LEVEL_PLAN_4501_5000.md` and `SHARED_CORE_STANDARD.md`.

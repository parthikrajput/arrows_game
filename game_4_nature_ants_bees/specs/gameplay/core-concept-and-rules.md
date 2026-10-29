Source docs: phase_1/01_GAME_CONCEPT_AND_RULES.md, SHARED_CORE_STANDARD.md

# Spec: Core Concept and Gameplay Rules

## Status
Draft

## Type
New Feature

## Goal
Implement the core turn-based puzzle rules, two-layer board representation (Ants on ground, Bees in air), line movement and bonk mechanics, life and star systems, and move resolution lifecycle for Ants & Bees: Garden Trails Phase 1.

## Current State
Design documented in phase_1/01_GAME_CONCEPT_AND_RULES.md and SHARED_CORE_STANDARD.md, not yet implemented.
- Turn-based deterministic logic puzzle with no wall-clock timer in the puzzle itself.
- Board grid from 4x4 up to 11x11 square cells; ant and bee lines occupy ordered cells where head insect is body[0].
- Ground layer (ants) and Air layer (bees) never collide with each other. Tall obstacles (`tall: true`) block both layers.
- 3 hearts per attempt; bonking costs 1 heart; 0 hearts triggers Second Chance popup.
- Rewarded ad revive allowed once per level number; Honey Heart Refill costs 120 coins (max 2 per attempt).
- Free Scent Trail Preview via long-press (>= 350 ms).
- Strict deterministic move resolution order on each turn.

## Proposed Change
Build the core pure-Dart engine rules in `packages/puzzle_core` and hook them into Flutter state management (`GameBloc`):

### 1. Board & Line Model
- **Grid Coordinates:** Origin `(0, 0)` at top-left, `x` increasing right, `y` increasing down. Phase 1 board sizes range from 4x4 up to 11x11. Cell size is >= 29 dp on 360 dp screens without pinch-to-zoom.
- **Line (`Path`):** An ordered list of contiguous orthogonal cells `body`, where `body[0]` is the head insect. Directions are strictly orthogonal: `U`, `D`, `L`, `R`. Line length ranges from 2 to 8 cells.
- **Two Layers:**
  - `layer: 0` = Ground Layer (Ant lines). Rendered on ground with contact shadow.
  - `layer: 1` = Air Layer (Bee lines). Rendered with 6 dp upward offset, transparent wings, 12 Hz wing flutter, and soft offset shadow. Introduced at Level 41.
- **Exit Lane:** The ray of cells starting immediately in front of `body[0]` in direction `dir` continuing to the board boundary, evaluated within the line's own layer and against tall obstacles.

### 2. The Layer Rules (LR-1 to LR-9)
1. **LR-1:** Ants = Ground layer (`layer: 0`). Bees = Air layer (`layer: 1`).
2. **LR-2 (Non-Collision):** Ants and bees never collide with each other. Ant lane is not blocked by bee bodies; bee lane is not blocked by ant bodies.
3. **LR-3 (Ant Lane Blocker):** Ant lane is blocked by any ant line body cell, all blocking obstacles (`tall: false` and `tall: true`), and ant-blocking edge walls.
4. **LR-4 (Bee Lane Blocker):** Bee lane is blocked strictly by bee line body cells and `tall: true` obstacles. `tall: false` obstacles are completely ignored by bees.
5. **LR-5 (Non-Blocking Mechanics):** Non-blocking cell mechanics (one-way tubes, portals, deflectors, switches, mud, springs) affect bees ONLY if marked `tall: true`. Fixed `tall: false` mechanics are ant-only.
6. **LR-6 (Cover Lock):** An ant line having any body cell directly covered by a bee line body cell is locked (produces locked tap) until all covering bee lines exit.
7. **LR-7 (Tap Priority):** When a cell contains both a bee body and an ant body, tapping the cell targets the bee line (air layer priority).
8. **LR-8 (Cell Occupancy):** Within a single layer, a cell can contain at most 1 line body cell. A bee body cannot occupy a cell with a `tall: true` obstacle.
9. **LR-9 (Introduction Schedule):** Levels 1–40 contain ant lines only (`layers: 1`). Bees enter at Level 41 (`layers: 2`).

### 3. Move Definition & Input Priority
- A **Move** is any player action mutating board state: tapping an ant or bee line (resulting in exit or bump) or tapping an interactive obstacle (e.g. Twig Lever, Spinning Daisy, Clover Switch, Lily-Pad Rotor).
- Boosters, long-press previews, pauses, and settings adjustments do not count as Moves.
- **Single Move at a time:** Move animation runs for <= 450 ms. Simultaneous inputs are blocked. Input queue capacity is 1: only the latest tap arriving during active animation is queued; any earlier queued tap is dropped.
- **Tap Priority Resolution:**
  1. Interactive control cells (Twig Lever, Clover Switch, Spinning Daisy head, Lily-Pad Rotor hub) take priority over any line body sharing coordinates.
  2. Air layer line body cell (Bee line) per LR-7.
  3. Ground layer line body cell (Ant line).
  4. Empty space / non-interactive cells: ignored (no Move, no audio).

### 4. March/Fly Out (Exit) & Head Bonk (Bump)
- **March Out (Ants) / Fly Out (Bees):** If all cells along the exit lane are completely free of blockers:
  - Ant line marches forward with leg cycling animation; bee line flies with wing flutter and subtle sine bob.
  - Body follows the head path; duration is 250 to 450 ms based on lane distance.
  - Line clears the board edge and is removed from the active board.
  - Move counter increments by 1. Audio event `path_exit` (`path_exit_ground` or `path_exit_air`) and light haptic trigger.
  - Combo streak increments (3+ consecutive exits trigger `path_exit_combo` pitch-up steps 1–5).
- **Head Bonk (Bump):** If the exit lane contains a blocker:
  - Head insect moves forward to the cell adjacent to the obstacle (or 0.25 cell forward if immediately adjacent), plays cute "bonk" squash animation with 3-cycle shake, and retreats to original position.
  - Board state remains unchanged, but Move counter increments by 1 (move-based obstacle counters tick).
  - 1 Heart is deducted (or 1 Shield charge is consumed if Queen's Royal Shield is active).
  - Combo streak resets to 0.
  - Audio event `bump` and medium haptic trigger; blocker displays a 120 ms red flash with blocker-specific hit SFX.

### 5. Locked Taps & Scent Trail Preview
- **Locked Tap:** If a line is temporarily locked (Dew-Stuck M003, Morning Mist M010, Marching Order M028, Cover-Locked LR-6, Flower-Bud Cage M033, Brood Line M035, Ring-Around Line M046, or Hide-and-Seek ghost phase M021):
  - Tap produces a soft side wobble (<= 200 ms), "tsk" chirp audio `locked_tap`, and selection haptic.
  - A contextual lock reason tooltip appears for 600 ms (e.g. "A bee is resting on this line").
  - No heart lost; Move counter does not increment.
- **Scent Trail Preview:** Long-pressing a line for >= 350 ms renders a dotted trajectory along its prospective exit lane:
  - Ant line renders straight dotted trail; Bee line renders wavy dotted trail.
  - Green dotted trail with checkmark icon for clear path; Red dotted trail with ✕ icon on blocking obstacle (color-blind accessible).
  - Traces through tunnels (M008) and leaf deflectors (M014). Stops with grey "?" at fog boundaries.
  - Releasing touch cancels preview with 0 moves spent and no tap triggered.

### 6. Hearts, Revive & Fail Lifecycle
- **3 Hearts Max:** Each attempt starts with 3 hearts.
- **Second Chance:** When hearts reach 0, gameplay pauses and Second Chance modal displays with a 10-second circular countdown ring:
  - **Rewarded Ad Revive:** Grants +1 Heart. Limited strictly to **1 use per level number** (`adReviveUsed[level]`; restart does not reset; resets only upon level completion).
  - **Honey Heart Refill:** Grants +1 Heart for **120 coins**. Allowed **max 2 times per attempt**.
  - **Timeout or "No Thanks":** Triggers Level Failed modal.
- **Level Failed:** Player can choose Retry (starts fresh attempt with 3 hearts, 0 coins cost) or return to Level Map / Home.
- **Post-Revive Resume:** Board state is preserved exactly as it was when the lethal bonk occurred.

### 7. Star Rating (★★★)
- ★★★ (3 Stars): Cleared with 0 hearts lost.
- ★★ (2 Stars): Cleared with 1 heart lost.
- ★ (1 Star): Cleared with 2+ hearts lost OR any revive used (ad revive or Honey Heart Refill).
- Note: Bumps absorbed by Queen's Royal Shield do not count as hearts lost.

### 8. Victory Condition & Fairness
- **Victory:** All ant and bee lines exit the board AND level-specific objectives are fulfilled (e.g. Sugar Crumbs & Nectar Drops M026 collected).
- 300 ms garden sparkle victory flourish before Level Complete modal appears.
- **CI Guarantee:** Every level must be solvable with 0 hearts lost and 0 boosters used under pure turn-based forward simulation.

## Affected Files
- `packages/puzzle_core/lib/src/models/board.dart` (to be created)
- `packages/puzzle_core/lib/src/models/path.dart` (to be created)
- `packages/puzzle_core/lib/src/models/cell.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/move_resolver.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/layer_rules.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/solver.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/bloc/game_bloc.dart` (to be created)

## Risks
- Incorrect layer collision checking could break the core USP where bees fly over ground obstacles and ants.
- Long-press preview must reliably distinguish between a quick tap (<= 350 ms) and a held preview to avoid accidental moves.

## Open Questions
- None. Core rules and layer specifications are fully aligned with SHARED_CORE_STANDARD.md and phase_1/01_GAME_CONCEPT_AND_RULES.md.

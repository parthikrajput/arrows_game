Source docs: phases/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md, phases/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.5, §16.17, §16.18, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-13-signature-system.md, specs/gameplay/phase-12-base-mechanics.md.

# Spec: Gameplay — Phase 13 Base Mechanics (M601–M604)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 13 (Levels 6001–6500) — M601 Scout Gecko (Scout Path), M602 Trick Mist (Mimic Fog), M603 Painted Wall (False Wall), and M604 Glow Stone (Reveal Plate) — detailing permanent visibility dissipation, reactive re-cloaking, optical illusion penetration, and tactile pressure illumination.

## Current State
Design documented in `phases/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md`, `phases/phase_13/01_PHASE_13_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Previous mechanics operated under fully visible board conditions.
- Phase 13 introduces dynamic fog-of-war layers that interact with entity movements, tactile pressure plates, and long-press raycast probes.

## Proposed Change
Implement mechanics M601 through M604 in `packages/puzzle_core/lib/src/mechanics/phase_13/`:

### 1. Mechanic Specifications

#### A. M601: Scout Gecko / Scout Path
- **Intro Level:** L6011 (Block 602, x1 slot).
- **Category:** Visibility Dissipation Entity (`D`).
- **Visual:** A slender, nimble snake adorned with a golden gecko crest on its head and bioluminescent chartreuse scales.
- **Rule:**
  - Operates as an active snake selectable by the player.
  - When the Scout Gecko slithers off the board:
    1. Every cell along its entire egress path, plus all adjacent orthogonal cells within a 1-cell radius, has its fog permanently cleared (`CellVisibility.permanentlyRevealed`).
    2. These cells are permanently immune to subsequent re-cloaking by M602 Trick Mist.
  - The generator guarantees that the Scout Gecko has a viable initial departure route or can be liberated within $\le 3$ moves.
- **JSON Format:**
  ```json
  {
    "id": "s601_1",
    "type": "M601",
    "cells": [[5, 3], [5, 4], [5, 5]],
    "params": {"isScout": true, "revealRadius": 1},
    "hammerable": false
  }
  ```

#### B. M602: Trick Mist / Mimic Fog
- **Intro Level:** L6131 (Block 614, x1 slot).
- **Category:** Reactive Occlusion System (`D`).
- **Visual:** Swirling translucent grey-lavender fog wisps that roll over vacated cells.
- **Rule:**
  - When any standard (non-scout) snake completely vacates its initial coordinates, 1 designated vacated cell re-cloaks under Trick Mist.
  - Veils the underlying tile surface (obscuring ice, mud, or floor switches) without altering cell passability.
  - **Immunity Invariant:** If the cell was previously marked `permanentlyRevealed` by an M601 Scout Gecko, Trick Mist cannot spawn on it.
- **JSON Format:**
  ```json
  {
    "id": "o602_1",
    "type": "M602",
    "cells": [[4, 7]],
    "params": {"reCloakOnExit": true},
    "hammerable": false
  }
  ```

#### C. M603: Painted Wall / False Wall
- **Intro Level:** L6251 (Block 626, x1 slot).
- **Category:** Optical Illusion Passage (`D`).
- **Visual:** Renders visually as a jagged mossy stone barrier, indistinguishable at a glance from an impassable perimeter wall.
- **Rule:**
  - Physically passable: snakes can slither straight through it as if it were Plain Floor.
  - **Tongue-Flick Probe Detection:** When a player performs a long-press ($\ge 350\text{ ms}$) on a snake aimed toward the wall, the raycast line penetrates through the wall, turning from red to shimmering gold, revealing that the barrier is hollow canvas.
  - Once a snake passes through it, the painted illusion dissolves permanently into floating canvas scraps.
- **JSON Format:**
  ```json
  {
    "id": "o603_1",
    "type": "M603",
    "cells": [[2, 6]],
    "params": {"isHollow": true, "revealed": false},
    "hammerable": true
  }
  ```

#### D. M604: Glow Stone / Reveal Plate
- **Intro Level:** L6371 (Block 638, x1 slot).
- **Category:** Tactile Illumination Plate (`D`).
- **Visual:** An ancient circular jade floor plate carved with radiant sunburst grooves that glow emerald when compressed.
- **Rule:**
  - Passive floor plate that does not block movement.
  - While any segment of a resting snake rests on this plate, all fog within a $3 \times 3$ bounding box centered on the plate temporarily lifts (`CellVisibility.scouted`).
  - When the snake completely departs and leaves the plate uncovered, the illuminated cells re-cloak under fog (unless previously permanently cleared by M601).
- **JSON Format:**
  ```json
  {
    "id": "o604_1",
    "type": "M604",
    "cells": [[7, 7]],
    "params": {"revealRadius": 1, "isPressed": false},
    "hammerable": false
  }
  ```

---

### 2. Solver & Fairness Verification
1. **Zero-Guessing Solvability:** A* offline verification ensures that a player utilizing long-press previews and scout paths can solve every level with 100% deterministic certainty, losing 0 hearts and using 0 boosters.
2. **Scout Priority Guarantee:** Procedural levels never place the Scout Gecko behind a wall that requires blind guesswork to open.
3. **Head-Bonk Safety:** Slithering blindly into an unrevealed wall causes an immediate harmless return (0 hearts lost).

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_13/scout_gecko.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_13/trick_mist.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_13/painted_false_wall.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_13/glow_stone_plate.dart` (to be created)
- `test/mechanics/phase_13_mechanics_test.dart` (to be created)

## Risks and Open Questions
- **Painted Wall Discovery Affordance:** If a player never uses the long-press preview, they may believe they are completely stuck. A subtle shimmering particle gleam must emanate from painted walls every 8 seconds to visually hint at their illusory nature.

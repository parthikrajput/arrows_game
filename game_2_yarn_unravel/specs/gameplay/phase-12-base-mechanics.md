Source docs: phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md, phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/obstacle-catalog-phase-1.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-12-signature-system.md.

# Spec: Gameplay — Phase 12 Base Mechanics (M551–M554)

## Status
Draft

## Type
New Feature

## Goal
Specify the rules, attributes, JSON schemas, solver constraints, and edge case behaviors for the 4 Phase 12 craft base mechanics: M551 Plumb Lever, M552 Dropping Buttons, M553 Float Patch, and M554 Weighted Thread.

## Current State
Design documented in `phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md`, not yet implemented.

## Proposed Change
Implement M551 through M554 in `packages/puzzle_core`:

### 1. Catalog Cards

#### M551 — Plumb Lever (Gravity Lever)
- **ID:** `M551`
- **Themed Name:** Plumb Lever
- **Generic Equivalent:** Gravity Lever
- **Intro Level:** L5511
- **Category:** Dynamic / Ground (D/G)
- **Hammerable:** No.
- **Rule:** A polished brass plumb-bob lever anchored to the wooden frame. Tapping the lever (costs 1 move) rotates the board's gravity vector to the next clockwise cardinal direction ($\text{Down} \to \text{Left} \to \text{Up} \to \text{Right} \to \text{Down}$). All loose objects immediately fall in the new direction during Step 4.
- **Edge Cases:** The lever's base cell acts as an immovable blocker.
- **JSON Schema:**
  ```json
  {
    "id": "m551_1",
    "type": "M551",
    "cells": [[0, 6]],
    "params": {
      "initialDir": "down",
      "cycle": ["down", "left", "up", "right"]
    },
    "hammerable": false
  }
  ```

#### M552 — Dropping Buttons (Falling Blockers)
- **ID:** `M552`
- **Themed Name:** Dropping Buttons
- **Generic Equivalent:** Falling Blockers
- **Intro Level:** L5631
- **Category:** Blocker / Physics (B/P)
- **Hammerable:** Yes (Golden Scissors snips button in 1 strike).
- **Rule:** Loose wooden buttons on the fabric surface. Following every valid player move, buttons slide continuously in the active gravity direction until blocked by another button, wall, or thread. While stationary, they function as standard single-cell blockers (M001).
- **Edge Cases:** If a button slides into an unraveling thread's planned exit route before the thread moves, the thread snags (-1 Heart).
- **JSON Schema:**
  ```json
  {
    "id": "m552_1",
    "type": "M552",
    "cells": [[4, 7]],
    "params": {},
    "hammerable": true
  }
  ```

#### M553 — Float Patch (Anti-grav Tile)
- **ID:** `M553`
- **Themed Name:** Float Patch
- **Generic Equivalent:** Anti-grav Tile
- **Intro Level:** L5751
- **Category:** Dynamic / Surface (D)
- **Hammerable:** No.
- **Rule:** A square patch of woven silk fabric that negates gravity. Any Dropping Button (M552) or Weighted Thread (M554) resting on a Float Patch remains locked in position and does NOT slide or fall, regardless of current gravity orientation.
- **Edge Cases:** If an object is pushed off the Float Patch, it immediately falls under active gravity on the next move.
- **JSON Schema:**
  ```json
  {
    "id": "m553_1",
    "type": "M553",
    "cells": [[8, 8]],
    "params": {},
    "hammerable": false
  }
  ```

#### M554 — Weighted Thread (Weight Path)
- **ID:** `M554`
- **Themed Name:** Weighted Thread
- **Generic Equivalent:** Weight Path
- **Intro Level:** L5871
- **Category:** Path (P)
- **Hammerable:** Yes (Golden Scissors snips thread).
- **Rule:** A heavy thread woven around a flexible wire core. At the end of every player move, if the entire thread's parallel adjacent cells along the gravity vector are completely unoccupied, the thread translates 1 cell in the gravity direction. The player can tap it at any point to unravel it normally.
- **Edge Cases:** If any cell along the destination vector is blocked, translation does not occur.
- **JSON Schema:**
  ```json
  {
    "id": "m554_1",
    "type": "M554",
    "cells": [[2, 3], [2, 4], [2, 5]],
    "params": {
      "weightClass": "heavy"
    },
    "hammerable": true
  }
  ```

### 2. Solver Integration
- Reverse generation in `tools/levelgen`:
  - M551: Reverse unwinds gravity shifts, ensuring initial resting spots for buttons leave open unravelling corridors.
  - M552: Validates that sliding buttons do not permanently seal exit paths required for remaining threads.
  - M553: Uses Float Patches as anchor points to isolate key sections from gravity chaos.
  - M554: Enforces translation predictability during IDA* tree search.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m551_plumb_lever.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m552_dropping_buttons.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m553_float_patch.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m554_weighted_thread.dart` (to be created)
- `tools/levelgen/lib/src/generators/mechanics_factory.dart` (changed: register M551–M554)

## Risks
- Falling buttons landing unexpectedly on user-selected paths. Mitigated by distinct visual trajectory preview lines when gravity changes.

## Open Questions
None. Catalog cards, parameters, and intro levels match Phase 12 documentation.

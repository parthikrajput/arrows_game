Source docs: phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md, ../../SHARED_CORE_STANDARD.md §10, §11. Depends on: specs/gameplay/phase-4-signature-system.md, specs/gameplay/phase-3-base-mechanics.md.

# Spec: Gameplay — Phase 4 Base Mechanics (M151–M154)

## Status
Draft

## Type
New Feature

## Goal
Specify the 4 new base mechanics introduced in Yarn Unravel Phase 4 (M151 Spiral Spool Stair, M152 Organza Floor, M153 Drop Hole, and M154 Bobbin Lift), their transition mechanics, priority rules, solver hooks, and JSON schema v3 representations.

## Current State
Design documented in `phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md` and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 3 mechanics (M101–M104) operated on periodic cycle shifts within a single floor.
- Phase 4 mechanics govern vertical transfer, cross-floor transparency, and multi-floor relocation.

## Proposed Change
Implement mechanic controllers in `packages/puzzle_core/lib/src/mechanics/phase_4/`:

### 1. M151 — Spiral Spool Stair (Stairs)
- **ID:** `M151` | **Themed Name:** Spiral Spool Stair | **Generic:** Stairs | **Category:** Deflector/Layer (D/L) | **Hammerable:** No | **Intro Level:** L1511.
- **Rule:** A vertical steel spool spiral stair situated on a board coordinate. A thread whose pull lane enters this cell instantly transitions to the target floor (`targetFloor`) at the exact same `(x, y)` coordinate, continuing its exit along the same direction vector.
- **Bump/Snag:** If the exit lane on the target floor is obstructed by a thread or blocker, the needle snags at the stair threshold on the origin floor (-1 Heart).
- **JSON Schema v3:**
  ```json
  {
    "id": "m151_1",
    "type": "M151",
    "cells": [[3, 5]],
    "params": { "targetFloor": 2 },
    "hammerable": false
  }
  ```

### 2. M152 — Organza Floor (Glass Floor)
- **ID:** `M152` | **Themed Name:** Organza Floor | **Generic:** Glass Floor | **Category:** Layer (L) | **Hammerable:** No | **Intro Level:** L1631.
- **Rule:** A sheer, transparent silk patch on an upper floor. Threads located on the floor immediately below this organza section are visible from the upper floor and can be directly tapped to unravel without manually switching camera view.
- **Tap Priority:** If both the upper floor and lower floor contain a thread occupying the organza cell, the upper-floor thread receives the tap first.
- **JSON Schema v3:**
  ```json
  {
    "id": "m152_1",
    "type": "M152",
    "cells": [[5, 5], [5, 6], [6, 5], [6, 6]],
    "params": { "seeThroughFloor": 1 },
    "hammerable": false
  }
  ```

### 3. M153 — Drop Hole (Drop Hole)
- **ID:** `M153` | **Themed Name:** Drop Hole | **Generic:** Drop Hole | **Category:** Deflector/Layer (D/L) | **Hammerable:** No | **Intro Level:** L1751.
- **Rule:** A circular cut-out hole in the fabric backing. When a thread's needle pulls forward into this cell, it drops through the hole, landing on the floor immediately below (`destinationFloor`) at coordinate `(x, y)`:
  - This move costs 1 Move and relocates the thread to the lower floor.
  - The thread remains on the lower floor in its current direction, ready to be pulled on a subsequent tap.
  - If the landing cell on the lower floor is blocked, the thread snags on the origin floor (-1 Heart).
- **JSON Schema v3:**
  ```json
  {
    "id": "m153_1",
    "type": "M153",
    "cells": [[7, 7]],
    "params": { "destinationFloor": 1 },
    "hammerable": false
  }
  ```

### 4. M154 — Bobbin Lift (Elevator)
- **ID:** `M154` | **Themed Name:** Bobbin Lift | **Generic:** Elevator | **Category:** Trigger (T) | **Hammerable:** No | **Intro Level:** L1871.
- **Rule:** An interactive vertical lift platform:
  - When a thread's needle head rests on the lift cell, tapping the lift mechanism transports the thread vertically to the linked floor (`linkedFloors`). This action costs 1 Move.
  - If no needle occupies the lift, tapping it displays a locked wobble (0 Moves, no Heart loss).
- **JSON Schema v3:**
  ```json
  {
    "id": "m154_1",
    "type": "M154",
    "cells": [[4, 4]],
    "params": { "linkedFloors": [1, 2] },
    "hammerable": false
  }
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_4/m151_spool_stair.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_4/m152_organza_floor.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_4/m153_drop_hole.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_4/m154_bobbin_lift.dart` (to be created)
- `packages/puzzle_core/test/mechanics/m151_test.dart` through `m154_test.dart` (to be created)

## Risks
- Drop holes dropping a thread onto a coordinate where another thread's body already exists. Prevented by solver and validator verifying clear drop target cells in solution sequences.

## Open Questions
None. Mechanics specifications match Phase 4 documentation and `SHARED_CORE_STANDARD.md` §11.

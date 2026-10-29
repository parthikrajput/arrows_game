Source docs: phases/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md, phases/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.4, §16.17, §16.18, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-14-signature-system.md, specs/gameplay/phase-13-base-mechanics.md.

# Spec: Gameplay — Phase 14 Base Mechanics (M651–M654)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 14 (Levels 6501–7000) — M651 Pond Axis (Mirror Axis), M652 Reflection Lock (Reflect Lock), M653 Twin Pond (Twin Board), and M654 Upside-down Snake (Inverse Path) — detailing bilateral coordinate reflections, cross-shore triggers, twin-board parity, and inverse-vector polarities.

## Current State
Design documented in `phases/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md`, `phases/phase_14/01_PHASE_14_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Previous mechanics operated on independent snake pathing or general multi-boards.
- Phase 14 introduces rigid mathematical reflection planes, cross-axis trigger dependencies, and reverse-directional movement coupling.

## Proposed Change
Implement mechanics M651 through M654 in `packages/puzzle_core/lib/src/mechanics/phase_14/`:

### 1. Mechanic Specifications

#### A. M651: Pond Axis / Mirror Axis
- **Intro Level:** L6511 (Block 652, x1 slot).
- **Category:** Environmental Reflection Plane (`D`).
- **Visual:** A shimmering, crystalline water line traversing the center of the board with caustic light patterns.
- **Rule:**
  - Bisects the puzzle grid horizontally or vertically.
  - Entities on Shore A are paired with symmetric counterparts on Shore B.
  - Tapping either partner commands both snakes to advance along their reflected trajectories.
  - **Synchronous Safety Constraint:** If either partner encounters a blockage, neither snake moves. Both execute a synchronized bump ripple at rest with 0 hearts lost.
- **JSON Format:**
  ```json
  {
    "id": "o651_1",
    "type": "M651",
    "cells": [],
    "params": {
      "orientation": "horizontal",
      "axisIndex": 6,
      "reflectionMode": "bilateral"
    },
    "hammerable": false
  }
  ```

#### B. M652: Reflection Lock / Reflect Lock
- **Intro Level:** L6631 (Block 664, x1 slot).
- **Category:** Cross-Axis Barrier Gate (`D`).
- **Visual:** A crystalline water gate on Shore A inscribed with an ethereal mirror frame that reflects the key snake resting on Shore B.
- **Rule:**
  - Located on Shore A blocking passage or perimeter exit.
  - Paired with a specific key snake entity located on Shore B (`crossKeySnakeId: "s_key_b"`).
  - Unlocks permanently only when the Shore B key snake successfully departs the board.
  - When unlocked, a luminous aquatic wave surges across the axis and dissolves the gate into sparkling water foam.
- **JSON Format:**
  ```json
  {
    "id": "o652_1",
    "type": "M652",
    "cells": [[2, 10]],
    "params": {
      "shore": "A",
      "linkedKeySnakeId": "s_key_b",
      "isUnlocked": false
    },
    "hammerable": false
  }
  ```

#### C. M653: Twin Pond / Twin Board
- **Intro Level:** L6751 (Block 676, x1 slot).
- **Category:** Identical Dual-Grid Parity (`D`).
- **Visual:** Two side-by-side or stacked boards with identical terrain, rock formations, and initial snake placements.
- **Rule:**
  - Two distinct grids (Pond 1 and Pond 2) initialized with identical entity configurations.
  - Tapping a snake on Pond 1 executes an identical move on the corresponding snake in Pond 2.
  - Challenges the player to navigate obstacles such that moves resolve cleanly on both identical boards simultaneously without collision.
- **JSON Format:**
  ```json
  {
    "id": "o653_1",
    "type": "M653",
    "cells": [],
    "params": {
      "twinBoardLayout": "mirrored",
      "sharedMoveInput": true
    },
    "hammerable": false
  }
  ```

#### D. M654: Upside-down Snake / Inverse Path
- **Intro Level:** L6871 (Block 688, x1 slot).
- **Category:** Reverse Polarity Reflection Entity (`D`).
- **Visual:** A vibrant snake whose dorsal scales feature inverted chevron arrows pointing backward toward its tail.
- **Rule:**
  - Linked to a partner snake across the reflection axis.
  - Moves in the exact **opposite vector** of its reflection partner:
    - Partner moves North $\implies$ Inverse Snake moves South.
    - Partner moves East $\implies$ Inverse Snake moves West.
  - Both snakes still require simultaneously unblocked paths. If either forward cell is occupied, both snakes safely halt (0 hearts lost).
- **JSON Format:**
  ```json
  {
    "id": "s654_1",
    "type": "M654",
    "cells": [[8, 4], [8, 5], [8, 6]],
    "params": {
      "pairedSnakeId": "s651_partner",
      "isInverse": true,
      "polarity": "opposite"
    },
    "hammerable": false
  }
  ```

---

### 2. Solver & Synchronous Invariants
1. **Zero-Damage Deadlock Prevention:** The generator verifies that mirror twins and inverse snakes never encounter mutual collision deadlocks where neither can move without the other already being clear.
2. **Deterministic Parity:** A* solver tracks paired entity positions in search nodes, confirming that every level is solvable in 0 boosters.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_14/pond_axis.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_14/reflection_lock.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_14/twin_pond_board.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_14/inverse_snake.dart` (to be created)
- `test/mechanics/phase_14_mechanics_test.dart` (to be created)

## Risks and Open Questions
- **Inverse Snake Visual Clarity:** Players might forget which snake is an inverse mover. The reversed chevron scale texture must continuously animate with an inward directional pulse to clearly telegraph its reverse movement vector.

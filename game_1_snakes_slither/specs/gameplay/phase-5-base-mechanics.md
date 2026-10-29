Source docs: phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md, phase_5/01_PHASE_5_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, §16.18, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-5-signature-system.md, specs/gameplay/phase-4-base-mechanics.md.

# Spec: Gameplay — Phase 5 Base Mechanics (M201–M204)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 5 (Levels 2001–2500) — M201 Coconut Pit, M202 Dew-Slick Coconut, M203 Key Coconut, and M204 Jackfruit Boulder — including displacement physics, terrain conversion rules, key socketing logic, and solver representations.

## Current State
Design documented in `phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md`, `phase_5/01_PHASE_5_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Earlier phases provided basic static blockers, 1-cell push blocks, and directional gates.
- Phase 5 introduces interactive terrain targets, inertia sliding blocks, object-carried keys, and heavy resistance obstacles.

## Proposed Change
Implement mechanics M201 through M204 in `packages/puzzle_core/lib/src/mechanics/phase_5/`:

### 1. Mechanic Specifications

#### A. M201: Coconut Pit (Crate Holes)
- **Intro Level:** L2011 (Block 2 x1).
- **Category:** Terrain Hole / Push Target (`B` / `D`).
- **Visual:** A deep circular earthen hollow carved into the jungle floor.
- **Rule:**
  - **Empty State:** Operates as a solid impassable blocker. A snake attempting to slither over an empty pit bonks and loses 1 Heart Berry.
  - **Filling State:** When any pushable coconut (M053, M202, M203) is pushed into the pit cell:
    1. The coconut falls in, permanently settling flush with the surface.
    2. The cell immediately transforms into standard **Plain Floor**.
    3. The coconut is consumed and can no longer be pushed.
  - **Filled State:** All subsequent snakes can slither freely across the filled pit cell without obstruction.
- **JSON Format:**
  ```json
  {
    "id": "o201_1",
    "type": "M201",
    "cells": [[5, 5]],
    "params": {"filled": false},
    "hammerable": false
  }
  ```
- **Hammerable:** `false` (standard §16.18 — pits and terrain holes cannot be hammered).

#### B. M202: Dew-Slick Coconut (Sliding Ice Crates)
- **Intro Level:** L2131 (Block 14 x1).
- **Category:** Pushable Block / Momentum (`D`).
- **Visual:** Smooth, polished green coconut glistening with morning dew.
- **Rule:**
  - Unlike standard 1-cell coconuts, pushing a Dew-Slick Coconut causes it to slide along the push vector $\vec{v}$ **continuously until it encounters an obstruction**.
  - **Obstructions:** Halts immediately in front of walls, other snakes, static blockers, or board boundaries.
  - **Pit Interaction:** If the slide path intersects an empty M201 Coconut Pit, the sliding coconut drops into the pit, instantly halting and converting the pit to Plain Floor.
  - **Open Edge Fall:** If pushed toward an open board boundary, the coconut slides cleanly off the board and is discarded (standard §17.29).
  - Can be pushed diagonally if struck by a diagonal snake head (M051).
- **JSON Format:**
  ```json
  {
    "id": "o202_1",
    "type": "M202",
    "cells": [[4, 8]],
    "params": {},
    "hammerable": true
  }
  ```
- **Hammerable:** `true` (standard §16.18 — pushable crate/coconut blocks are hammerable).

#### C. M203: Key Coconut (Crate Keys)
- **Intro Level:** L2251 (Block 26 x1).
- **Category:** Pushable Key Token (`D` / `K`).
- **Visual:** Weathered coconut bound with brass bands featuring a glowing golden key emblem.
- **Rule:**
  - Acts as a 1-cell pushable block carrying an integrated key token.
  - Cannot be picked up directly by a snake's mouth or body.
  - Must be pushed into a designated matching Lock Cell (`targetLockId`).
  - **Lock Trigger:** When M203 lands on the lock cell, the linked gate/lock permanently latches open, emitting a burst effect.
  - Once socketed, M203 ceases to be a key and behaves as an immovable fixture or regular floor depending on level design.
- **JSON Format:**
  ```json
  {
    "id": "o203_1",
    "type": "M203",
    "cells": [[8, 3]],
    "params": {"targetLockId": "lock_1"},
    "hammerable": false
  }
  ```
- **Hammerable:** `false` (key-bearing objects are protected from hammer destruction to prevent soft-locks).

#### D. M204: Jackfruit Boulder (Heavy Crate)
- **Intro Level:** L2371 (Block 38 x1).
- **Category:** Heavy Pushable Blocker (`B` / `D`).
- **Visual:** Enormous spiky wild jackfruit with dense woody heft.
- **Rule:**
  - Possesses heavy mass. A single standard snake attempting to push M204 cannot move it; the snake bonks and loses 1 Heart Berry ("Too Heavy!" visual cue).
  - **Valid Push Conditions:**
    1. **Giant Anaconda (M049):** A 2-wide snake head has sufficient power to displace M204 by 1 cell.
    2. **Chained Group Push:** Two snakes moving in tandem under the `Chained` modifier executing a simultaneous push.
  - When moved, displaces by exactly 1 cell along the push vector into free floor.
- **JSON Format:**
  ```json
  {
    "id": "o204_1",
    "type": "M204",
    "cells": [[7, 7]],
    "params": {"requiredPower": "heavy"},
    "hammerable": false
  }
  ```
- **Hammerable:** `false` (standard §16.18).

### 2. Solver Integration & Solvability Guarantees
- **State Representation:** IDA* state space incorporates dynamic block positions: `(remainingSnakes, blockPositions, pitStates, lockStates)`.
- **Reverse Construction Placement:** In reverse construction, filled pits are initialized as floor cells, and the solver traces block trajectories backward from pit/socket locations to their starting coordinates, guaranteeing 0-heart solvability without requiring booster use.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_5/m201_coconut_pit.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_5/m202_dew_slick_coconut.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_5/m203_key_coconut.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_5/m204_jackfruit_boulder.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/mechanic_registry.dart` (register M201–M204)

## Risks
- Multi-block chain pushes (pushing a coconut into another coconut). Governed by rule: pushes propagate at most 1 block unless explicitly chained; pushing into another blocked coconut triggers a bump.
- Soft-locks where key coconut is pushed into an unrecoverable corner. Prevented by generator validation rules that forbid dead-end push configurations without a solution path.

## Open Questions
- None. Rules, IDs, and behaviors match `phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md` and `SHARED_CORE_STANDARD.md` §11.

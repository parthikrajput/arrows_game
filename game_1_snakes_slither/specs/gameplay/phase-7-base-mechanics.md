Source docs: phases/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md, phases/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, §16.18, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-7-signature-system.md, specs/gameplay/phase-6-base-mechanics.md.

# Spec: Gameplay — Phase 7 Base Mechanics (M301–M304)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base rotation mechanics for Phase 7 (Levels 3001–3500) — M301 Island Spinner, M302 Turning Hedges, M303 Spinning Snake, and M304 Gear Lock — including sub-board rotation, shifting border obstacles, dynamic snake auto-rotation, and gear alignment locking.

## Current State
Design documented in `phases/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md`, `phases/phase_7/01_PHASE_7_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Earlier phases operated with fixed snake exit trajectories and static boundary hedges.
- Phase 7 introduces dynamic orientation shifts, moving exit apertures, and gear-coupled gates.

## Proposed Change
Implement mechanics M301 through M304 in `packages/puzzle_core/lib/src/mechanics/phase_7/`:

### 1. Mechanic Specifications

#### A. M301: Island Spinner (Sub-board Rotor)
- **Intro Level:** L3011 (Block 2 x1).
- **Category:** Interactive Sub-grid Rotation (`T` / `D`).
- **Visual:** A 4×4 stone turntable disc with mossy carvings and an interactive central wooden wheel handle.
- **Rule:**
  - Tapping the central handle costs 1 Move and rotates the entire 4×4 zone 90° Clockwise.
  - **Enclosed Entities:** All snake segments completely within the 4×4 boundaries have their coordinates and directions transformed 90° CW.
  - **Boundary Invariant:** If any snake straddles the boundary (partially inside, partially outside), the rotor is hard-locked. Tapping yields a **Locked Tap** (0 hearts lost, 0 moves spent).
  - **Tangled Invariant:** If rotation causes a snake's heading vector to collide with its own body, it becomes Tangled (locked tap).
- **JSON Format:**
  ```json
  {
    "id": "o301_1",
    "type": "M301",
    "cells": [[4, 4], [7, 7]],
    "params": {"currentAngle": 0},
    "hammerable": false
  }
  ```
- **Hammerable:** `false` (standard §16.18 — sub-board rotors cannot be hammered).

#### B. M302: Turning Hedges (Rotating Edges)
- **Intro Level:** L3131 (Block 14 x1).
- **Category:** Dynamic Border Blocker (`B`).
- **Visual:** Dense thorn hedge barriers positioned along the outer board perimeter.
- **Rule:**
  - After each valid player move (Step 3: Counters tick), the hedge wall segments advance **1 cell clockwise** along the perimeter track.
  - As hedges advance, openings (gaps) in the perimeter shift positions.
  - A snake attempting to exit when a hedge occupies its exit lane bonks (−1 Heart Berry).
  - Players must time snake slithering moves so the snake reaches the perimeter exactly when a hedge gap is aligned.
- **JSON Format:**
  ```json
  {
    "id": "o302_1",
    "type": "M302",
    "cells": [[0, 2], [0, 3], [0, 4]],
    "params": {"shiftInterval": 1},
    "hammerable": false
  }
  ```
- **Hammerable:** `false`.

#### C. M303: Spinning Snake (Spin Path)
- **Intro Level:** L3251 (Block 26 x1).
- **Category:** Dynamic Path Behavior (`D`).
- **Visual:** An agile serpent bearing a distinctive golden spiral crest on its head.
- **Rule:**
  - After any valid move on the board (whether another snake slithered or a rotor turned), this snake's head direction `dir` automatically rotates **90° Clockwise**:
    $$\text{Up} \to \text{Right} \to \text{Down} \to \text{Left} \to \text{Up}$$
  - The snake's body segments remain in their current cell positions; only the prospective exit direction vector rotates.
  - If the new direction has an unobstructed exit lane, the player can tap the snake to exit immediately.
  - If unaddressed, subsequent moves continue rotating its heading vector, potentially closing previously open exit corridors.
- **JSON Format:**
  ```json
  {
    "id": "p_spin_1",
    "color": "amber",
    "dir": "R",
    "body": [[5, 5], [5, 6], [5, 7]],
    "mods": {"spin": true}
  }
  ```
- **Hammerable:** Normal snake rules apply (Magic Stone Hammer can smash obstacles blocking its path, but not the snake itself).

#### D. M304: Gear Lock (Rotation Lock)
- **Intro Level:** L3371 (Block 38 x1).
- **Category:** Orientation-Coupled Lock (`G`).
- **Visual:** A massive interlocking stone gate driven by meshed mechanical gears connected to a rotor.
- **Rule:**
  - Operates as a solid impassable obstacle until unlocked.
  - Linked to a specific Island Spinner via `linkedRotorId`.
  - **Open Condition:** The gate lowers and remains passable **only while the linked rotor is set to its designated target angle** (e.g. `unlockAngle = 180°`).
  - If the rotor turns to any other angle (e.g. 0°, 90°, 270°), the gate raises back up and blocks the path.
- **JSON Format:**
  ```json
  {
    "id": "o304_1",
    "type": "M304",
    "cells": [[10, 6]],
    "params": {"linkedRotorId": "o301_1", "unlockAngle": 180},
    "hammerable": false
  }
  ```
- **Hammerable:** `false`.

### 2. Solver & Validator Integration (Standard §12)
- **Rotational State Hashing:** IDA* transposition tables incorporate 4-state rotor orientations ($0^\circ, 90^\circ, 180^\circ, 270^\circ$), shifting hedge coordinates, and M303 spin phases.
- **Pruning Invariants:**
  - States attempting rotor turns while straddled are pruned immediately (invalid move).
  - States generating tangled self-collisions are assigned infinite cost.
- **Zero-Heart Guarantee:** Every generated level must have an optimal 0-heart solution requiring zero booster reliance.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_7/island_spinner.dart` — to be created
- `packages/puzzle_core/lib/src/mechanics/phase_7/turning_hedges.dart` — to be created
- `packages/puzzle_core/lib/src/mechanics/phase_7/spinning_snake.dart` — to be created
- `packages/puzzle_core/lib/src/mechanics/phase_7/gear_lock.dart` — to be created
- `packages/puzzle_core/lib/src/solver/state_evaluator.dart` — changed

## Risks and Open Questions
- **M302 Perimeter Clockwise Drift Sync:** In corners of non-square boards (e.g. 12×14), perimeter tracks must handle corner transitions smoothly without dropping coordinate cells.
  - *Implementation:* Perimeter path is modeled as an ordered closed 1D coordinate ring array.


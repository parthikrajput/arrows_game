Source docs: phases/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md, phases/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, §16.18, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-12-signature-system.md, specs/gameplay/phase-11-base-mechanics.md.

# Spec: Gameplay — Phase 12 Base Mechanics (M551–M554)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 12 (Levels 5501–6000) — M551 Wind Lever (Gravity Lever), M552 Falling Fruit (Falling Blockers), M553 Floaty Lily (Anti-grav Tile), and M554 Heavy Python (Weight Path) — detailing rotation triggers, falling cascade collision logic, anti-gravity suspension, and autonomous mass sliding.

## Current State
Design documented in `phases/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md`, `phases/phase_12/01_PHASE_12_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Previous mechanics relied on static board fixtures or manual snake taps.
- Phase 12 introduces environmental manipulation via wind levers and autonomous reactive entities that shift under gravity.

## Proposed Change
Implement mechanics M551 through M554 in `packages/puzzle_core/lib/src/mechanics/phase_12/`:

### 1. Mechanic Specifications

#### A. M551: Wind Lever / Gravity Lever
- **Intro Level:** L5511 (Block 552, x1 slot).
- **Category:** Environmental State Actuator (`D`).
- **Visual:** A carved stone pedestal with an ancient bronze windmill lever that spins upon interaction.
- **Rule:**
  - Located on a fixed board cell (`cells: [[r, c]]`).
  - Tapping the lever consumes 1 move (`Move += 1`) and shifts directional gravity $90^\circ$ clockwise:
    $$\text{Down} \to \text{Right} \to \text{Up} \to \text{Left} \to \text{Down}$$
  - Triggers an immediate post-move falling cascade across all active M552 fruits and M554 heavy pythons.
  - Can only be tapped when unobstructed. If a snake rests across the lever cell, the lever is unclickable until the snake moves.
- **JSON Format:**
  ```json
  {
    "id": "o551_1",
    "type": "M551",
    "cells": [[6, 6]],
    "params": {"initialDirection": "down", "rotationDegrees": 90},
    "hammerable": false
  }
  ```

#### B. M552: Falling Fruit / Falling Blockers
- **Intro Level:** L5631 (Block 564, x1 slot).
- **Category:** Dynamic Gravity Obstacle (`B` / `D`).
- **Visual:** Heavy spherical jungle coconuts/durians with thick fibrous husks.
- **Rule:**
  - Occupies 1 cell. Impassable to snakes while resting.
  - After any valid move or lever rotation, if the cell immediately adjacent in the active gravity direction is vacant, the fruit falls into that cell.
  - Falls sequentially until resting against a board perimeter wall, another fruit, or a resting snake.
  - **Zero Damage Rule:** Resting on or falling against a snake body causes no damage and costs 0 hearts. The snake acts as a solid support platform.
  - **Hammerable:** `true` (Standard §16.18 — individual falling fruits can be destroyed using the Magic Stone Hammer).
- **JSON Format:**
  ```json
  {
    "id": "o552_1",
    "type": "M552",
    "cells": [[1, 4]],
    "params": {"weight": 1, "isFalling": false},
    "hammerable": true
  }
  ```

#### C. M553: Floaty Lily / Anti-grav Tile
- **Intro Level:** L5751 (Block 576, x1 slot).
- **Category:** Physics Negation Tile (`D`).
- **Visual:** A glowing violet floating lily pad with anti-gravity pollen motes hovering above the cell.
- **Rule:**
  - Passive floor tile that does not obstruct snake movement.
  - Any M552 Falling Fruit resting on this tile completely defies gravity; it remains suspended in place regardless of current gravity direction.
  - When an exiting snake slithers across this tile, it pushes the suspended fruit off the tile into an adjacent cell, restoring normal gravity physics to the fruit.
- **JSON Format:**
  ```json
  {
    "id": "o553_1",
    "type": "M553",
    "cells": [[3, 3]],
    "params": {"suspendedEntityId": "o552_1"},
    "hammerable": false
  }
  ```

#### D. M554: Heavy Python / Weight Path
- **Intro Level:** L5871 (Block 588, x1 slot).
- **Category:** Autonomous Mass Slither Entity (`D`).
- **Visual:** A thick, armored python with heavyweight obsidian scales and sleepy golden slit eyes.
- **Rule:**
  - Can be tapped to slither off the board normally like standard snakes.
  - In addition, during the post-move physics settling phase:
    - If **all** cells directly beneath the python's entire body (aligned with the gravity vector) are simultaneously vacant, the heavy python autonomously shifts 1 cell in the gravity direction.
    - Halts immediately if any portion of its body contacts a wall, fruit, or another snake.
- **JSON Format:**
  ```json
  {
    "id": "s554_1",
    "type": "M554",
    "cells": [[2, 5], [2, 6], [2, 7]],
    "params": {"color": "obsidian", "isHeavy": true, "slideDirection": "down"},
    "hammerable": false
  }
  ```

---

### 2. Solver & Cascade Verification
1. **Cascade Termination:** The settling loop executes in topological gravity order to guarantee termination in $\le \max(\text{Rows}, \text{Cols})$ passes without oscillation.
2. **Deterministic A* Simulation:** Search states track `(boardState, gravityDirection, fruitPositions, pythonPositions)`. The solver verifies that every level is solvable in 0 boosters with full gravity utilization.
3. **No Irreversible Blocker Jams:** The generator verifies that fruit descents never permanently seal remaining snakes into unresolvable dead ends.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_12/wind_lever.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_12/falling_fruit.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_12/floaty_lily.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_12/heavy_python.dart` (to be created)
- `test/mechanics/phase_12_mechanics_test.dart` (to be created)

## Risks and Open Questions
- **Simultaneous Autonomous Slides:** If multiple heavy pythons are eligible to fall on the same turn, scan order priority must be strictly deterministic (processing closest to the downward boundary first) to prevent inconsistent collision resolutions.

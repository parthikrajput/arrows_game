Source docs: phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md, phase_4/01_PHASE_4_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, §16.18, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-4-signature-system.md, specs/gameplay/phase-3-base-mechanics.md.

# Spec: Gameplay — Phase 4 Base Mechanics (M151–M154)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 4 (Levels 1501–2000) — M151 Root Stairs, M152 Dewglass Floor, M153 Knot Hole, and M154 Vine Lift — including collision models, inter-floor link parameters, locked tap safety rules, hammerable properties, and solver graph representations.

## Current State
Design documented in `phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md`, `phase_4/01_PHASE_4_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Phase 1–3 established base mechanics M001–M049, M051–M099, and M101–M104.
- Phase 4 introduces 4 mechanics specifically designed for vertical inter-floor navigation within the Great Tree Floors signature system.

## Proposed Change
Implement mechanics M151 through M154 in `packages/puzzle_core/lib/src/mechanics/phase_4/`:

### 1. Mechanic Specifications

#### A. M151: Root Stairs (Stairs)
- **Intro Level:** L1511 (Block 2 x1).
- **Category:** Inter-Floor Connector (`D`).
- **Visual:** Massive intertwining tree roots spiraling between floors with directional leafy steps.
- **Rule:**
  - Links a source cell `[x1, y1]` on `floorFrom` to a destination cell `[x2, y2]` on `floorTo` (usually adjacent floors, e.g. F1 ↔ F2 or F2 ↔ F3).
  - When a snake's lane enters the stairs cell, movement does not stop; the lane continues seamlessly on `floorTo` starting from `linkedCell` in the same orientation (`dir`).
  - **Obstruction & Bump Rule:** If the continuation lane on `floorTo` is blocked by an obstacle or another snake's body, the snake does not ascend/descend; it bonks against the stairs on `floorFrom` and slides back to its original position (−1 Heart Berry).
  - Can be bidirectional unless modified by a directional parameter.
- **JSON Format:**
  ```json
  {
    "id": "o151_1",
    "type": "M151",
    "cells": [[4, 5]],
    "params": {"floorFrom": 1, "floorTo": 2, "linkedCell": [4, 5]},
    "hammerable": false
  }
  ```
- **Hammerable:** `false` (standard §16.18 — inter-floor connectors and tiles are non-hammerable).

#### B. M152: Dewglass Floor (Glass Floor)
- **Intro Level:** L1631 (Block 14 x1).
- **Category:** Occlusion / Vision Tile (`D`).
- **Visual:** Transparent crystalline sheet covered with morning dew set into the tree floor.
- **Rule:**
  - Placed on an upper floor (F2 or F3) directly above a lower floor cell.
  - **See-Through & Non-Blocking Invariant:** A snake occupying a Dewglass Floor cell on an upper floor does NOT lock or obstruct a snake positioned on the lower floor directly beneath it.
  - Snakes on both floors can traverse their respective cells independently without vertical collision.
  - Provides total visual clarity into the lower floor from above, rendering a subtle translucent highlight.
- **JSON Format:**
  ```json
  {
    "id": "o152_1",
    "type": "M152",
    "cells": [[7, 7]],
    "params": {"floor": 2},
    "hammerable": false
  }
  ```
- **Hammerable:** `false`.

#### C. M153: Knot Hole (Drop Hole)
- **Intro Level:** L1751 (Block 26 x1).
- **Category:** Gravity Drop / One-Way Descent (`D`).
- **Visual:** A smooth hollow cavity bore into the ancient tree trunk leading downward into the depths.
- **Rule:**
  - One-way vertical drop from an upper floor (`fromFloor`: F2 or F3) to a lower floor (`toFloor`: F1 or F2) at the identical `[x, y]` coordinate cell.
  - When a snake's lane enters the Knot Hole, the snake drops vertically under gravity to the floor below and continues forward in its original direction (`dir`).
  - **Strict One-Way Invariant:** A snake on the lower floor cannot enter the Knot Hole to ascend; from below, the hole appears as a solid overhead ceiling.
  - **Landing Bump Rule:** If the landing cell or continuation lane on the lower floor is blocked, the snake bonks on the upper floor before dropping and retreats (−1 Heart Berry).
- **JSON Format:**
  ```json
  {
    "id": "o153_1",
    "type": "M153",
    "cells": [[5, 8]],
    "params": {"fromFloor": 2, "toFloor": 1},
    "hammerable": false
  }
  ```
- **Hammerable:** `false`.

#### D. M154: Vine Lift (Elevator)
- **Intro Level:** L1871 (Block 38 x1).
- **Category:** Interactive Platform (`T` / `D`).
- **Visual:** Sturdy bark platform suspended by woven jungle vines with pulley brackets.
- **Rule:**
  - Interactive tap mechanic: Tapping the Vine Lift platform costs **1 valid Move** (`moveCount += 1`).
  - **Full-Body Occupation Rule:** When tapped, if a snake's body is **entirely on the platform cells**, both the platform and the passenger snake shift vertically by 1 floor (direction alternates sequentially: F1 → F2 → F1, or F2 → F3 → F2).
  - **Empty Lift:** If no snake is on the platform, tapping moves the empty platform to the target floor (costs 1 Move).
  - **Locked Tap Safety Invariant (Standard §16.19):** If a snake is only partially resting on the lift platform (e.g. head on lift, tail on regular floor), tapping triggers a **Locked Tap** (denied nudge animation, 0 moves consumed, 0 hearts lost; snake body is never sheared or chopped).
- **JSON Format:**
  ```json
  {
    "id": "o154_1",
    "type": "M154",
    "cells": [[6, 6], [6, 7]],
    "params": {"currentFloor": 1, "targetFloor": 2},
    "hammerable": false
  }
  ```
- **Hammerable:** `false`.

### 2. Solver Representation & Determinism
- **3D Spatial Routing:** The IDA* / BFS solver models the board as a layered directed graph where M151 adds bidirectional inter-floor edges, M153 adds unidirectional downward edges, and M154 represents a dynamic state toggle.
- **Reverse Construction Feasibility:** Generator places snakes in reverse exit order. For multi-floor levels, paths exiting through stairs or drop holes are laid starting from the destination floor backward to the source floor, guaranteeing 100% solvable forward paths without deadlock.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_4/m151_root_stairs.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_4/m152_dewglass_floor.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_4/m153_knot_hole.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_4/m154_vine_lift.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/mechanic_registry.dart` (register M151–M154)

## Risks
- Boundary collision bugs when a snake enters M151 or M153 while another snake on the destination floor moves on the same tick. Resolved by turn pipeline ordering where moves resolve sequentially per tap.
- Player confusion over M154 Vine Lift locked tap behavior. Addressed by clear visual cue and tutorial card at L1871.

## Open Questions
- None. Rules, IDs, and parameters strictly conform to `phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md` and `SHARED_CORE_STANDARD.md` §11.

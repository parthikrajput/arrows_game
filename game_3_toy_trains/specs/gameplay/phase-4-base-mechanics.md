Source docs: phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md, phase/phase_4/01_PHASE_4_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-4-signature-system.md, specs/gameplay/phase-3-base-mechanics.md.

# Spec: Gameplay — Phase 4 Base Mechanics (M151–M154)

## Status
Draft

## Type
New Feature

## Goal
Specify the four new base railway mechanics (M151–M154) introduced in Phase 4 (Levels 1501–2000) of Toy Trains: Wooden Railway Puzzle, establishing their rules, collision dynamics, interactive states, hammerability, solver implications, and JSON schemas.

## Current State
Design documented in `phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases handled planar track networks and cyclic switches.
- Phase 4 introduces vertical traversal mechanics between station floors (`S04`).

## Proposed Change
Implement the 4 base vertical mechanics in `packages/puzzle_core/lib/src/mechanics/phase_4/`:

### 1. M151 · Station Stairs (Stairs)
- **Intro Level:** L1511 (Block 2, x1).
- **Category:** D (Directional / Vertical Portal).
- **Exact Rule:** Incline railway stair ramp. When an exiting train encounters this cell, it transitions immediately to the linked floor specified by `params.targetFloor` at the identical `(x, y)` coordinate, continuing its forward exit trajectory. If the destination cell on the target floor is obstructed, it results in a buffer clack bump (-1 heart).
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M151", "cells": [[4, 6]], "params": {"targetFloor": 2}, "hammerable": false}
  ```

### 2. M152 · Glass Platform (Glass Floor)
- **Intro Level:** L1631 (Block 14, x1).
- **Category:** L (Layer / Platform).
- **Exact Rule:** Transparent reinforced glass station deck. Operates as normal track on the upper floor. Critically, trains on the lower floor beneath the glass remain visible and directly tappable through the glass deck without occlusion or tap locking.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M152", "cells": [[6, 6], [6, 7]], "params": {}, "hammerable": false}
  ```

### 3. M153 · Goods Chute (Drop Hole)
- **Intro Level:** L1751 (Block 26, x1).
- **Category:** D (Directional / Relocation).
- **Exact Rule:** Freight drop chute. When an exiting train travels over this cell, it drops down to the lower floor (`targetFloor`) landing on the same `(x, y)` coordinate (counts as 1 relocation Move). The train stops on the lower floor and requires a subsequent tap to resume departure in its heading direction.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M153", "cells": [[8, 3]], "params": {"targetFloor": 1}, "hammerable": false}
  ```

### 4. M154 · Goods Lift (Elevator)
- **Intro Level:** L1871 (Block 38, x1).
- **Category:** T (Interactive / Transport).
- **Exact Rule:** Heavy-duty railway freight elevator platform. When a train rests fully within the lift boundary cells, tapping the lift mechanism lever (1 Move) moves the lift platform and resting train vertically to the linked target floor. Tapping while a train is partially positioned across the lift boundary results in a locked tap (soft wobble, no move, 0 hearts).
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M154", "cells": [[5, 5], [5, 6]], "params": {"targetFloor": 2, "initialFloor": 1}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_4/m151_stairs.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_4/m152_glass_floor.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_4/m153_drop_hole.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_4/m154_elevator.dart` (to be created)

## Risks
- Collision conflicts if a train drops through M153 into another train passing beneath on the lower floor. Mitigated by validator check: exit lanes underneath drop chutes must be cleared before the dropping train moves.

## Open Questions
- None. All mechanics match `phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md` and `SHARED_CORE_STANDARD.md` §11.


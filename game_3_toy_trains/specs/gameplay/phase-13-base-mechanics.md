Source docs: phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md, phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §16.17. Depends on: specs/gameplay/phase-13-signature-system.md.

# Spec: Gameplay — Phase 13 Base Mechanics (M601–M604)

## Status
Draft

## Type
New Feature

## Goal
Specify the formal rules, parameters, data models, edge cases, and solver representations for the 4 base mechanics of Phase 13 (Weather Station): M601 Scout Draisine, M602 Mirage Steam, M603 Painted Backdrop, and M604 Lantern Plate.

## Current State
Design documented in `phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md` and `../../SHARED_CORE_STANDARD.md` §16.17, not yet implemented.

## Proposed Change
Implement the 4 base mechanic types in `packages/puzzle_core`:

### 1. M601 · Scout Draisine (Scout Path)
- **Intro Level:** L6011 (Block 2, x1).
- **Category:** P (Reconnaissance Handcart).
- **Rule:** A lightweight wooden handcart locomotive. When dispatched cleanly off the board, all fogged tiles within a 1-cell radius of its departure path are permanently cleared and revealed.
- **Hammerable:** Yes (Track Crane removes the scout draisine).
- **Data Model:**
  ```json
  {"id": "p_scout", "type": "path", "cells": [[4, 2], [4, 3]], "dir": "U", "params": {"revealRadius": 1}}
  ```

### 2. M602 · Mirage Steam (Mimic Fog)
- **Intro Level:** L6131 (Block 14, x1).
- **Category:** B / C (Illusion Cloud).
- **Rule:** Dense cloud of steam displaying a ghost train decoy silhouette inside. Looks like an impassable obstacle to players, but real trains drive right through it without obstruction. Route Peek reveals an open green path.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o2", "type": "M602", "cells": [[6, 7]], "params": {"decoyDir": "R"}, "hammerable": false}
  ```

### 3. M603 · Painted Backdrop (False Wall)
- **Intro Level:** L6251 (Block 26, x1).
- **Category:** B (Illusory Wooden Wall).
- **Rule:** Stage scenery prop painted to resemble a wooden railway fence. Does not collide with trains; trains drive through effortlessly. Route Peek displays clear green track arrows across the fence.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o3", "type": "M603", "cells": [[3, 5]], "params": {}, "hammerable": false}
  ```

### 4. M604 · Lantern Plate (Reveal Plate)
- **Intro Level:** L6371 (Block 38, x1).
- **Category:** T (Pressure Lantern Switch).
- **Rule:** A weighted track plate equipped with an oil lantern. While any train is stationary on this tile, all fog within a 2-cell radius is illuminated and cleared. Once the train departs, un-scouted tiles re-shroud in fog.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o4", "type": "M604", "cells": [[8, 8]], "params": {"radius": 2}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m601_scout_draisine.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m602_mirage_steam.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m603_painted_backdrop.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m604_lantern_plate.dart` (to be created)

## Risks
- Player hesitation due to false walls. Mitigated by prominent Route Peek tutorial prompting players to long-press suspicious obstacles.

## Open Questions
- None. Rules match `phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md`.

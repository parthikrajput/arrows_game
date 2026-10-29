Source docs: phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md, phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §16.17. Depends on: specs/gameplay/phase-12-signature-system.md.

# Spec: Gameplay — Phase 12 Base Mechanics (M551–M554)

## Status
Draft

## Type
New Feature

## Goal
Specify the formal rules, parameters, data models, edge cases, and solver representations for the 4 base mechanics of Phase 12 (Hill Line): M551 Tilt Lever, M552 Loose Crates, M553 Balloon Pad, and M554 Ballast Train.

## Current State
Design documented in `phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md` and `../../SHARED_CORE_STANDARD.md` §16.17, not yet implemented.

## Proposed Change
Implement the 4 base mechanic types in `packages/puzzle_core`:

### 1. M551 · Tilt Lever (Gravity Lever)
- **Intro Level:** L5511 (Block 2, x1).
- **Category:** S / L (Gravity Direction Switch).
- **Rule:** A wooden fulcrum lever mounted on track ballast. Tapping it consumes 1 move and rotates the board's gravity vector 90° clockwise (`Down -> Left -> Up -> Right`).
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o1", "type": "M551", "cells": [[4, 4]], "params": {"currentDir": "D"}, "hammerable": false}
  ```

### 2. M552 · Loose Crates (Falling Blockers)
- **Intro Level:** L5631 (Block 14, x1).
- **Category:** B / D (Gravity-Driven Blocker).
- **Rule:** Free-standing cargo crates on rails. In Step 3 of each turn tick, each loose crate shifts 1 cell along the active gravity vector if the cell is clear. If obstructed, it remains stationary. Trains colliding into a crate take a buffer clack bump (-1 heart).
- **Hammerable:** Yes (Track Crane shatters crate into wooden splinters).
- **Data Model:**
  ```json
  {"id": "o2", "type": "M552", "cells": [[6, 2]], "params": {"weight": 1}, "hammerable": true}
  ```

### 3. M553 · Balloon Pad (Anti-grav Tile)
- **Intro Level:** L5751 (Block 26, x1).
- **Category:** P / S (Suspension Tile).
- **Rule:** Special air cushion pad marked with a hot air balloon emblem. Any loose crate sliding onto this pad suspends in place, anchoring against gravity until bumped by a train.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o3", "type": "M553", "cells": [[6, 8]], "params": {"holdingCrate": false}, "hammerable": false}
  ```

### 4. M554 · Ballast Train (Weight Path)
- **Intro Level:** L5871 (Block 38, x1).
- **Category:** P / B (Autonomous Rolling Engine).
- **Rule:** Heavy ballast cargo locomotive. When facing parallel to the gravity vector and track ahead is clear, it automatically advances 1 cell during Step 3 of each turn without requiring a player tap.
- **Hammerable:** Yes (Track Crane removes the ballast engine).
- **Data Model:**
  ```json
  {"id": "p_ballast_1", "type": "path", "cells": [[3, 2], [3, 3]], "dir": "D", "params": {"isAutonomous": true}}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m551_tilt_lever.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m552_loose_crates.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m553_balloon_pad.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m554_ballast_train.dart` (to be created)

## Risks
- Cascade movements of multiple crates pushing each other. Mitigation: Crates evaluated in topological order matching gravity direction.

## Open Questions
- None. Rules match `phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md`.

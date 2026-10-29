Source docs: phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md, phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §16.17. Depends on: specs/gameplay/phase-15-signature-system.md.

# Spec: Gameplay — Phase 15 Base Mechanics (M701–M704)

## Status
Draft

## Type
New Feature

## Goal
Specify the formal rules, parameters, data models, edge cases, and solver representations for the 4 base mechanics of Phase 15 (Moving Platforms): M701 Belt Switch, M702 Reversing Belt, M703 Belt Stop Lever, and M704 Continuous Loop Belt.

## Current State
Design documented in `phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md` and `../../SHARED_CORE_STANDARD.md` §16.17, not yet implemented.

## Proposed Change
Implement the 4 base mechanic types in `packages/puzzle_core`:

### 1. M701 · Belt Switch (Belt Junction)
- **Intro Level:** L7011 (Block 2, x1).
- **Category:** S / C (Conveyor Junction Switch).
- **Rule:** A mechanized conveyor track junction. Tapping consumes 1 move and toggles the conveyor flow direction between Left and Right output tracks.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o1", "type": "M701", "cells": [[4, 5]], "params": {"flowDir": "L", "options": ["L", "R"]}, "hammerable": false}
  ```

### 2. M702 · Reversing Belt (Reversible Belt)
- **Intro Level:** L7131 (Block 14, x1).
- **Category:** S / R (Direction Inversion Belt).
- **Rule:** A conveyor line wired to a central reversal lever. Tapping the lever consumes 1 move and inverts the movement vector of all connected conveyor tiles by 180° (`Forward <-> Backward`).
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o2", "type": "M702", "cells": [[2, 4], [2, 5], [2, 6]], "params": {"currentDir": "D", "reversed": false}, "hammerable": false}
  ```

### 3. M703 · Belt Stop Lever (Belt Lever)
- **Intro Level:** L7251 (Block 26, x1).
- **Category:** S / B (Pneumatic Conveyor Brake).
- **Rule:** A track-side pneumatic brake lever. Tapping it halts motorized movement along linked conveyor belts (Pause state). Tapping again re-engages conveyor drive.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o3", "type": "M703", "cells": [[6, 8]], "params": {"isHalted": false, "linkedBeltIds": ["belt_zone_1"]}, "hammerable": false}
  ```

### 4. M704 · Loop Belt (Continuous Loop)
- **Intro Level:** L7371 (Block 38, x1).
- **Category:** C / L (Continuous Shunting Ring).
- **Rule:** A 4 to 8 cell closed conveyor loop. Trains entering the ring circulate clockwise 1 tile per turn automatically until tapped by the player to exit onto an unblocked tangent spur.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o4", "type": "M704", "cells": [[5, 5], [5, 6], [6, 6], [6, 5]], "params": {"rotation": "CW"}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m701_belt_switch.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m702_reversing_belt.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m703_belt_stop_lever.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m704_loop_belt.dart` (to be created)

## Risks
- Trains entering loop belts simultaneously colliding. Mitigation: Step 3 conveyor tick serializes entries, granting priority to trains already occupying the loop.

## Open Questions
- None. Rules match `phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md`.

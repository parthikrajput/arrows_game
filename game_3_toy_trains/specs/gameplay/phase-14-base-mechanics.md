Source docs: phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md, phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §16.17. Depends on: specs/gameplay/phase-14-signature-system.md.

# Spec: Gameplay — Phase 14 Base Mechanics (M651–M654)

## Status
Draft

## Type
New Feature

## Goal
Specify the formal rules, parameters, data models, edge cases, and solver representations for the 4 base mechanics of Phase 14 (Alpine Pass): M651 Mirror Rail Axis, M652 Reflection Lock, M653 Alpine Twin Yard, and M654 Reverse Engine.

## Current State
Design documented in `phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md` and `../../SHARED_CORE_STANDARD.md` §16.17, not yet implemented.

## Proposed Change
Implement the 4 base mechanic types in `packages/puzzle_core`:

### 1. M651 · Mirror Rail Axis (Alpine Mirror Track)
- **Intro Level:** L6511 (Block 2, x1).
- **Category:** P / B (Symmetrical Mirror Pair).
- **Rule:** A central glacial reflection axis dividing the tabletop railway. Tapping a locomotive on the left half causes its mirrored twin on the right half to execute an identical, horizontally reflected move ($L \leftrightarrow R$). Both routes must be clear; a collision on either side aborts the move and causes a bump (-1 heart).
- **Hammerable:** Yes (Track Crane removes one twin; partner reverts to an independent single train).
- **Data Model:**
  ```json
  {"id": "p_mirror_left", "type": "path", "cells": [[3, 3], [3, 4]], "dir": "L", "params": {"mirrorPartner": "p_mirror_right", "axisX": 6.5}}
  ```

### 2. M652 · Reflection Lock (Glacier Lock)
- **Intro Level:** L6631 (Block 14, x1).
- **Category:** K / L (Paired Symmetry Barrier).
- **Rule:** Paired glacial barrier gates placed symmetrically across the mirror axis. Both gates unlock simultaneously only when twin keys or trains arrive at their respective trigger pads.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o2", "type": "M652", "cells": [[5, 2], [5, 11]], "params": {"axisX": 6.5, "paired": true}, "hammerable": false}
  ```

### 3. M653 · Alpine Twin Yard (Mirror Board)
- **Intro Level:** L6751 (Block 26, x1).
- **Category:** B / T (Synchronized Yard Grid).
- **Rule:** Symmetrical yard sector where interacting with a switch, turntable, or buffer stop automatically reflects the interaction to the corresponding element on the opposite side of the glacier axis.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o3", "type": "M653", "cells": [[8, 2], [8, 11]], "params": {"syncRotation": true}, "hammerable": false}
  ```

### 4. M654 · Reverse Engine (Inverse Path)
- **Intro Level:** L6871 (Block 38, x1).
- **Category:** P (Direction Inversion Locomotive).
- **Rule:** Inverted locomotive engine marked with a looking-glass icon. When tapped, it travels backward along its track alignment, reversing its default facing orientation.
- **Hammerable:** Yes (Track Crane removes the reverse engine).
- **Data Model:**
  ```json
  {"id": "p_reverse", "type": "path", "cells": [[10, 8], [10, 9]], "dir": "R", "params": {"invertedDir": true}}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m651_mirror_rail_axis.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m652_reflection_lock.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m653_alpine_twin_yard.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m654_reverse_engine.dart` (to be created)

## Risks
- Double collision edge cases during simultaneous reflections. Mitigation: Atomic pre-flight check validates both movement corridors before committing board mutations.

## Open Questions
- None. Rules match `phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md`.

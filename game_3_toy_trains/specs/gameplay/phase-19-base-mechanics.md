Source docs: phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md, phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §16.17. Depends on: specs/gameplay/phase-19-signature-system.md.

# Spec: Gameplay — Phase 19 Base Mechanics (M901–M904)

## Status
Draft

## Type
New Feature

## Goal
Specify the formal rules, parameters, data models, edge cases, and solver representations for the 4 base combo mechanics of Phase 19 (Remix B): M901 Turntable Coupling Pad, M902 Incline Seed Wagon, M903 Cross-Table Metronome Gate, and M904 Hedge-Trimming Split Train.

## Current State
Design documented in `phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md` and `../../SHARED_CORE_STANDARD.md` §16.17, not yet implemented.

## Proposed Change
Implement the 4 base mechanic types in `packages/puzzle_core`:

### 1. M901 · Turntable Coupling Pad (Rotating Coupler)
- **Intro Level:** L9011 (Block 2, x1).
- **Category:** T / P (Rotation + Coupling Fusion).
- **Rule:** A 4x4 sub-board turntable equipped with magnetic coupling pads. Candidate trains cannot merge until the turntable is rotated by 90° CW to align with exterior approach rails.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o1_rotor_coupler", "type": "M901", "cells": [[4, 4], [4, 5], [5, 4], [5, 5]], "params": {"currentAngle": 0, "targetAngle": 90}, "hammerable": false}
  ```

### 2. M902 · Incline Seed Wagon (Gravity Spore Train)
- **Intro Level:** L9131 (Block 14, x1).
- **Category:** P / B (Gravity + Botanical Growth Fusion).
- **Rule:** A seed wagon stationed on an inclined track slope. Rolls downhill autonomously 1 cell per turn (Step 3 tick). As it rolls, it drops seeds on traversed track cells that sprout into obstructive ivy after 3 turns.
- **Hammerable:** Yes (Track Crane removes the seed wagon).
- **Data Model:**
  ```json
  {"id": "p_incline_seed", "type": "path", "cells": [[8, 2], [8, 3]], "dir": "D", "params": {"sproutDelay": 3, "autoRoll": true}}
  ```

### 3. M903 · Cross-Table Metronome Gate (Twin Table Rhythm)
- **Intro Level:** L9251 (Block 26, x1).
- **Category:** G / E (Linked Boards + Sequencing Fusion).
- **Rule:** A rhythmic metronome gate governing the Table Bridge connecting Table A and Table B. Operates on a cyclic rhythm pattern (e.g. `["open", "closed", "open"]`); trains attempting cross-table transit when closed collide and lose 1 heart.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o3_bridge_metro", "type": "M903", "cells": [[7, 4]], "params": {"bridgeBoard": "A", "targetBoard": "B", "pattern": ["open", "closed", "open"]}, "hammerable": false}
  ```

### 4. M904 · Hedge-Trimming Split Train (Twin Split Pruner)
- **Intro Level:** L9371 (Block 38, x1).
- **Category:** P / T (Split & Merge + Ivy Pruning Fusion).
- **Rule:** Tandem locomotive that divides into two parallel pruner engines when tapped. As both engines advance down parallel tracks, their mounted scythe blades clear all wild ivy on adjacent cells.
- **Hammerable:** Yes (Track Crane removes the train).
- **Data Model:**
  ```json
  {"id": "p_split_prune", "type": "path", "cells": [[3, 5], [3, 6], [4, 5], [4, 6]], "dir": "R", "params": {"pruneRadius": 1}}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m901_turntable_coupling.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m902_incline_seed_wagon.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m903_cross_metronome_gate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m904_split_pruner.dart` (to be created)

## Risks
- Unintended pruning of essential ivy barrier puzzles. Mitigation: Solver validates that pruning is confined strictly to designated obstructive corridors.

## Open Questions
- None. Rules match `phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md`.

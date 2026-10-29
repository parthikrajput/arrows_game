Source docs: phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md, phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/phase-19-signature-system.md.

# Spec: Gameplay — Phase 19 Base Mechanics (M901–M904)

## Status
Draft

## Type
New Feature

## Goal
Define the data models, mechanical behaviors, interaction rules, and JSON schemas for the four Phase 19 combo mechanics: Twirl Weighted Thread (M901), Ivy Hoop Rotor (M902), Rhythm Belt (M903), and Seam Edge Split (M904).

## Current State
Documented in `phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md`, not yet implemented in code.

## Proposed Change
Implement four new base mechanics in `packages/puzzle_core/lib/src/mechanics/`:

### 1. M901 — Twirl Weighted Thread
- **Catalog Metadata:** ID `M901` | Themed Name: Twirl Weighted Thread | Generic: Twirl Weighted Thread | Intro: Level 9011 | Category: P | Hammerable: Yes (1 thread per snip)
- **Behavior:**
  - Combines Thread Rotation (M303) and Gravity Translation (M554).
  - Rotates 90° clockwise after every valid player move.
  - Subsequently slides 1 cell along the active gravity vector if the destination cell is unoccupied.
- **JSON Schema:**
  ```json
  {
    "id": "m901_1",
    "type": "M901",
    "cells": [[5, 5], [5, 6]],
    "params": {
      "dir": "up",
      "rotatesCW": true,
      "fallsWithGravity": true
    },
    "hammerable": true
  }
  ```

### 2. M902 — Ivy Hoop Rotor
- **Catalog Metadata:** ID `M902` | Themed Name: Ivy Hoop Rotor | Generic: Ivy Hoop Rotor | Intro: Level 9131 | Category: D/C | Hammerable: No
- **Behavior:**
  - Combines Organic Growth (M351) with Hoop Rotors (M301).
  - A $4\times 4$ circular disc housing embedded ivy root origin points.
  - Tapping rotates the disc 90° clockwise (costs 1 move), shifting root orientations so that subsequent vine growth expands into new board sectors.
- **JSON Schema:**
  ```json
  {
    "id": "m902_1",
    "type": "M902",
    "cells": [[2, 2], [2, 5], [5, 2], [5, 5]],
    "params": {
      "size": 4,
      "rootOffsets": [[1, 1]]
    },
    "hammerable": false
  }
  ```

### 3. M903 — Rhythm Belt
- **Catalog Metadata:** ID `M903` | Themed Name: Rhythm Belt | Generic: Rhythm Belt | Intro: Level 9251 | Category: T/B | Hammerable: No
- **Behavior:**
  - Combines Conveyors (M701) with Sequencing Metronomes (M451).
  - Translates resting threads 1 cell only on active metronome beat pulses (e.g. `[1, 0]` pattern: advances on move 1, pauses on move 2).
- **JSON Schema:**
  ```json
  {
    "id": "m903_1",
    "type": "M903",
    "cells": [[8, 4], [8, 5], [8, 6], [8, 7]],
    "params": {
      "beatPattern": [1, 0],
      "dir": "left"
    },
    "hammerable": false
  }
  ```

### 4. M904 — Seam Edge Split
- **Catalog Metadata:** ID `M904` | Themed Name: Seam Edge Split | Generic: Seam Edge Split | Intro: Level 9371 | Category: T/E | Hammerable: No
- **Behavior:**
  - Combines Linked Boards (M501) with Split-Ply Threads (M401).
  - When a thread crosses the boundary seam from Hoop A into Hoop B, it automatically splits into two parallel half-ply strands on Hoop B.
- **JSON Schema:**
  ```json
  {
    "id": "m904_1",
    "type": "M904",
    "cells": [[7, 0]],
    "params": {
      "targetBoard": "hoop_b",
      "splitOnCross": true
    },
    "hammerable": false
  }
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m901_twirl_weighted.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m902_ivy_hoop_rotor.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m903_rhythm_belt.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m904_seam_edge_split.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/mechanic_registry.dart` (changed: register M901–M904 factory handlers)

## Risks and Open Questions
- None. Catalog parameters match `SHARED_CORE_STANDARD.md` §10 and Phase 19 source documents.


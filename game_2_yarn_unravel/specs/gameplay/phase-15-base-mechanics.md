Source docs: phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md, phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/phase-15-signature-system.md.

# Spec: Gameplay — Phase 15 Base Mechanics (M701–M704)

## Status
Draft

## Type
New Feature

## Goal
Define the data models, mechanical behaviors, interaction rules, and JSON schemas for the four Phase 15 base mechanics: Belt Switch (M701), Reversing Belt (M702), Belt Lever (M703), and Track Loop (M704).

## Current State
Documented in `phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md`, not yet implemented in code.

## Proposed Change
Implement four new base mechanics in `packages/puzzle_core/lib/src/mechanics/`:

### 1. M701 — Belt Switch (Belt Junction)
- **Catalog Metadata:** ID `M701` | Themed Name: Belt Switch | Generic: Belt Junction | Intro: Level 7011 | Category: D/G | Hammerable: No
- **Behavior:**
  - Track junction switch embedded into the board.
  - Tapping the switch costs 1 player move and toggles the active branch (e.g. `straight` vs `right`).
  - Threads arriving at the junction follow the currently active branch.
- **JSON Schema:**
  ```json
  {
    "id": "m701_1",
    "type": "M701",
    "cells": [[5, 5]],
    "params": {
      "branches": ["straight", "right"],
      "activeBranch": "straight"
    },
    "hammerable": false
  }
  ```

### 2. M702 — Reversing Belt (Reversible Belt)
- **Catalog Metadata:** ID `M702` | Themed Name: Reversing Belt | Generic: Reversible Belt | Intro: Level 7131 | Category: T/E | Hammerable: No
- **Behavior:**
  - Conveyor track segment equipped with a mechanical counter.
  - Direction vector automatically inverts 180° every $N$ (3–5) player moves.
  - Features an on-screen numerical counter badge displaying remaining moves until the next directional flip.
- **JSON Schema:**
  ```json
  {
    "id": "m702_1",
    "type": "M702",
    "cells": [[4, 2], [4, 3], [4, 4], [4, 5]],
    "params": {
      "flipInterval": 4,
      "currentDir": "right"
    },
    "hammerable": false
  }
  ```

### 3. M703 — Belt Lever (Belt Lever)
- **Catalog Metadata:** ID `M703` | Themed Name: Belt Lever | Generic: Belt Lever | Intro: Level 7251 | Category: D/G | Hammerable: No
- **Behavior:**
  - Wooden clutch lever mounted at the edge of the crafting board.
  - Tapping costs 1 player move and halts/resumes linked conveyor belts.
  - When belts are halted, occupying threads remain completely stationary.
- **JSON Schema:**
  ```json
  {
    "id": "m703_1",
    "type": "M703",
    "cells": [[0, 8]],
    "params": {
      "linkedBeltIds": ["belt_1", "belt_2"],
      "active": true
    },
    "hammerable": false
  }
  ```

### 4. M704 — Track Loop (Track Loop)
- **Catalog Metadata:** ID `M704` | Themed Name: Track Loop | Generic: Track Loop | Intro: Level 7371 | Category: P/T | Hammerable: No
- **Behavior:**
  - Continuous closed-circuit track loop.
  - Occupying threads cycle 1 cell clockwise along the loop after each player move.
  - The thread can only unravel and exit when its needle head reaches the designated exit cell with an unobstructed escape path.
- **JSON Schema:**
  ```json
  {
    "id": "m704_1",
    "type": "M704",
    "cells": [[6, 8], [6, 9], [7, 9], [8, 9], [8, 8], [7, 8]],
    "params": {
      "exitCell": [6, 8],
      "dir": "up"
    },
    "hammerable": false
  }
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m701_belt_switch.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m702_reversing_belt.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m703_belt_lever.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m704_track_loop.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/mechanic_registry.dart` (changed: register M701–M704 factory handlers)

## Risks and Open Questions
- None. Behaviors match catalog definitions in `phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md`.

Source docs: phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md, phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/phase-20-signature-system.md.

# Spec: Gameplay — Phase 20 Base Mechanics (M951–M954)

## Status
Draft

## Type
New Feature

## Goal
Define the data models, mechanical behaviors, interaction rules, and JSON schemas for the four Phase 20 master mechanics: Moving Guardian (M951), Omni Gate (M952), Grand Loom Spool (M953), and Master Weaver Key (M954).

## Current State
Documented in `phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md`, not yet implemented in code.

## Proposed Change
Implement four new base mechanics in `packages/puzzle_core/lib/src/mechanics/`:

### 1. M951 — Moving Guardian (Living Tapestry)
- **Catalog Metadata:** ID `M951` | Themed Name: Moving Guardian | Generic: Moving Guardian | Intro: Level 9511 | Category: X/B | Hammerable: No
- **Behavior:**
  - A dynamic $2\times 2$ velvet boss pincushion (8 HP).
  - Advances 1 cell along a predefined patrol loop every 2 player moves (`moveInterval: 2`).
  - Adjacent unravelling thread pulls extract pins (-1 HP); upon reaching 0 HP, it permanently collapses into ribbons and vacates the board.
- **JSON Schema:**
  ```json
  {
    "id": "m951_1",
    "type": "M951",
    "cells": [[4, 4], [4, 5], [5, 4], [5, 5]],
    "params": {
      "hp": 8,
      "moveInterval": 2,
      "patrolPath": [[4, 4], [4, 8], [8, 8], [8, 4]]
    },
    "hammerable": false
  }
  ```

### 2. M952 — Omni Gate (Chromatic Prism Gate)
- **Catalog Metadata:** ID `M952` | Themed Name: Omni Gate | Generic: Chromatic Prism Gate | Intro: Level 9631 | Category: B | Hammerable: No
- **Behavior:**
  - Ultimate multi-conditional obstacle gate.
  - Unlocks only when 3 concurrent criteria are fulfilled: active intersecting light beam (`requiredBeam: true`), matching thread dye color (`requiredColor: "red"`), and active Day/Night cycle state (`requiredCycle: "A"`).
- **JSON Schema:**
  ```json
  {
    "id": "m952_1",
    "type": "M952",
    "cells": [[6, 7]],
    "params": {
      "requiredBeam": true,
      "requiredColor": "red",
      "requiredCycle": "A"
    },
    "hammerable": false
  }
  ```

### 3. M953 — Grand Loom Spool (Infinity Bobbin)
- **Catalog Metadata:** ID `M953` | Themed Name: Grand Loom Spool | Generic: Infinity Bobbin | Intro: Level 9751 | Category: P/T | Hammerable: No
- **Behavior:**
  - Central multi-thread bobbin dispenser.
  - Stores a queue of 2–3 threads. As soon as the active thread completely exits the board, the next stored thread dispenses and populates the board canvas.
- **JSON Schema:**
  ```json
  {
    "id": "m953_1",
    "type": "M953",
    "cells": [[2, 8]],
    "params": {
      "storedThreads": ["t_inner_1", "t_inner_2"]
    },
    "hammerable": false
  }
  ```

### 4. M954 — Master Weaver Key (Grand Skeleton Charm)
- **Catalog Metadata:** ID `M954` | Themed Name: Master Weaver Key | Generic: Grand Skeleton Charm | Intro: Level 9871 | Category: K | Hammerable: Yes (1 key per snip)
- **Behavior:**
  - The supreme golden key thread.
  - Upon successful unravelling and exit from the board, it sends a universal unlock pulse that opens every lock, clasp, and gate on the entire level.
- **JSON Schema:**
  ```json
  {
    "id": "m954_1",
    "type": "M954",
    "cells": [[9, 3], [9, 4], [9, 5]],
    "params": {
      "unlocksAll": true
    },
    "hammerable": true
  }
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m951_moving_guardian.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m952_omni_gate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m953_grand_loom_spool.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m954_master_weaver_key.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/mechanic_registry.dart` (changed: register M951–M954 factory handlers)

## Risks and Open Questions
- None. Catalog parameters match `SHARED_CORE_STANDARD.md` §10 and Phase 20 source documents.


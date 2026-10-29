Source docs: phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md, phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/phase-14-signature-system.md.

# Spec: Gameplay — Phase 14 Base Mechanics (M651–M654)

## Status
Draft

## Type
New Feature

## Goal
Define the data models, mechanical behaviors, interaction rules, and JSON schemas for the four Phase 14 base mechanics: Mirror Seam (M651), Reflect Clasp (M652), Twin Quilt (M653), and Inverse Thread (M654).

## Current State
Documented in `phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md`, not yet implemented in code.

## Proposed Change
Implement four new base mechanics in `packages/puzzle_core/lib/src/mechanics/`:

### 1. M651 — Mirror Seam (Mirror Axis)
- **Catalog Metadata:** ID `M651` | Themed Name: Mirror Seam | Generic: Mirror Axis | Intro: Level 6511 | Category: T/E | Hammerable: No
- **Behavior:**
  - A gleaming silver stitched axis across the center of the board (vertical or horizontal).
  - Pairs opposing threads as twin reflections.
  - Tapping either twin initiates a synchronized pull where both must exit cleanly; if either is obstructed, both snag with a single -1 Heart penalty.
- **JSON Schema:**
  ```json
  {
    "id": "m651_1",
    "type": "M651",
    "cells": [[0, 7], [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7], [8, 7], [9, 7], [10, 7], [11, 7]],
    "params": {
      "axis": "vertical",
      "x": 7
    },
    "hammerable": false
  }
  ```

### 2. M652 — Reflect Clasp (Reflect Lock)
- **Catalog Metadata:** ID `M652` | Themed Name: Reflect Clasp | Generic: Reflect Lock | Intro: Level 6631 | Category: K/B | Hammerable: No
- **Behavior:**
  - A symmetrical pair of embroidery clasps positioned equidistant from the mirror seam.
  - Applying a key to either clasp unlocks both clasps simultaneously via a mirrored resonant pulse.
- **JSON Schema:**
  ```json
  {
    "id": "m652_1",
    "type": "M652",
    "cells": [[4, 3], [4, 11]],
    "params": {
      "twinClaspId": "m652_1_b"
    },
    "hammerable": false
  }
  ```

### 3. M653 — Twin Quilt (Twin Board)
- **Catalog Metadata:** ID `M653` | Themed Name: Twin Quilt | Generic: Twin Board | Intro: Level 6751 | Category: D/G | Hammerable: No
- **Behavior:**
  - An interactive toggle patch on one side of the mirror seam.
  - Tapping the patch (costs 1 move) immediately flips its state and synchronizes its mirrored twin on the opposing side of the axis.
- **JSON Schema:**
  ```json
  {
    "id": "m653_1",
    "type": "M653",
    "cells": [[2, 4], [2, 10]],
    "params": {
      "linkedToggle": "m653_1_b"
    },
    "hammerable": false
  }
  ```

### 4. M654 — Inverse Thread (Inverse Path)
- **Catalog Metadata:** ID `M654` | Themed Name: Inverse Thread | Generic: Inverse Path | Intro: Level 6871 | Category: P | Hammerable: Yes
- **Behavior:**
  - Linked contra-directionally to a primary thread.
  - When the primary thread unravels along direction $D$, the inverse thread travels in $\text{opposite}(D)$ (180° inversion).
  - Can be snipped with golden scissors/hammer.
- **JSON Schema:**
  ```json
  {
    "id": "m654_1",
    "type": "M654",
    "cells": [[8, 2], [8, 3], [8, 4]],
    "params": {
      "primaryThreadId": "t_08",
      "inverse": true
    },
    "hammerable": true
  }
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m651_mirror_seam.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m652_reflect_clasp.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m653_twin_quilt.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m654_inverse_thread.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/mechanic_registry.dart` (changed: register M651–M654 factory handlers)

## Risks and Open Questions
- None. Catalog parameters match `SHARED_CORE_STANDARD.md` §10 and Phase 14 source documents.


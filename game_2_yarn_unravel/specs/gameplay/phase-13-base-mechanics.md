Source docs: phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md, phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/phase-13-signature-system.md.

# Spec: Gameplay — Phase 13 Base Mechanics (M601–M604)

## Status
Draft

## Type
New Feature

## Goal
Define the data models, mechanical behaviors, interaction rules, and JSON schemas for the four Phase 13 base mechanics: Scout Thread (M601), Decoy Fluff (M602), Painted Wall (M603), and Lantern Plate (M604).

## Current State
Documented in `phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md`, not yet implemented in code.

## Proposed Change
Implement four new base mechanics in `packages/puzzle_core/lib/src/mechanics/`:

### 1. M601 — Scout Thread (Scout Path)
- **Catalog Metadata:** ID `M601` | Themed Name: Scout Thread | Generic: Scout Path | Intro: Level 6011 | Category: P | Hammerable: Yes
- **Behavior:**
  - A thread featuring a gleaming silver needle tip.
  - Upon successful unraveling and exit from the board, it clears all Wool Fluff fog within a 1-cell radius (Chebyshev distance $\le 1$) along its entire pull path.
  - Revealing fog immediately unlocks previously obscured thread heads for player interaction.
- **JSON Schema:**
  ```json
  {
    "id": "m601_1",
    "type": "M601",
    "cells": [[4, 2], [4, 3], [4, 4]],
    "params": {
      "revealRadius": 1
    },
    "hammerable": true
  }
  ```

### 2. M602 — Decoy Fluff (Mimic Fog)
- **Catalog Metadata:** ID `M602` | Themed Name: Decoy Fluff | Generic: Mimic Fog | Intro: Level 6131 | Category: B | Hammerable: Yes (1 fluff per snip)
- **Behavior:**
  - Visual clone of dense Wool Fluff fog, simulating an obstacle or hidden cluster.
  - Contains no underlying blockers or hazards; completely hollow.
  - When an unraveling thread’s trajectory touches the cell, the decoy fluff dissolves instantly into wool fibers with no movement penalty or collision.
- **JSON Schema:**
  ```json
  {
    "id": "m602_1",
    "type": "M602",
    "cells": [[7, 6]],
    "params": {},
    "hammerable": true
  }
  ```

### 3. M603 — Painted Wall (False Wall)
- **Catalog Metadata:** ID `M603` | Themed Name: Painted Wall | Generic: False Wall | Intro: Level 6251 | Category: B | Hammerable: No
- **Behavior:**
  - Trompe-l'œil fabric painting mimicking a solid wooden ruler blocker (M002).
  - Threads can pass straight through without snagging.
  - Upon the first thread crossing its cell, the painted wall sheds its 3D shading and renders as a faint white chalk line on the linen canvas.
- **JSON Schema:**
  ```json
  {
    "id": "m603_1",
    "type": "M603",
    "cells": [[5, 9]],
    "params": {},
    "hammerable": false
  }
  ```

### 4. M604 — Lantern Plate (Reveal Plate)
- **Catalog Metadata:** ID `M604` | Themed Name: Lantern Plate | Generic: Reveal Plate | Intro: Level 6371 | Category: D | Hammerable: No
- **Behavior:**
  - A round, embossed brass plate set into the crafting board.
  - While any thread segment rests on the plate, all Wool Fluff fog on the board drops to 40% opacity (`revealOpacity: 0.4`), illuminating underlying board items.
  - If the thread unravels off the plate, fog opacity returns to 100% (unless already permanently cleared by M601).
- **JSON Schema:**
  ```json
  {
    "id": "m604_1",
    "type": "M604",
    "cells": [[8, 3]],
    "params": {
      "revealOpacity": 0.4
    },
    "hammerable": false
  }
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m601_scout_thread.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m602_decoy_fluff.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m603_painted_wall.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m604_lantern_plate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/mechanic_registry.dart` (changed: register M601–M604 factory handlers)

## Risks and Open Questions
- **Risk:** Visual similarity between real Ruler Blockers (M002) and Painted Walls (M603) might feel unfair.
  - *Mitigation:* Subtle stitching brushstroke differences and tutorial card introduction at Level 6251 teach players the perceptual difference.


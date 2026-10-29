Source docs: phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md, phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/phase-17-signature-system.md.

# Spec: Gameplay — Phase 17 Base Mechanics (M801–M804)

## Status
Draft

## Type
New Feature

## Goal
Define the data models, mechanical behaviors, interaction rules, and JSON schemas for the four Phase 17 base mechanics: Twin Pincushions (M801), Armoured Pincushion (M802), Seeding Pincushion (M803), and Heart Pincushion (M804).

## Current State
Documented in `phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md`, not yet implemented in code.

## Proposed Change
Implement four new base mechanics in `packages/puzzle_core/lib/src/mechanics/`:

### 1. M801 — Twin Pincushions (Twin Guardian)
- **Catalog Metadata:** ID `M801` | Themed Name: Twin Pincushions | Generic: Twin Guardian | Intro: Level 8011 | Category: X/B | Hammerable: No
- **Behavior:**
  - A pair of $2\times 2$ velvet pincushions sharing a synchronized HP pool (e.g. 6 HP).
  - Unravelling a thread adjacent to either entity extracts a pin from the shared pool.
  - Upon reaching 0 HP, both pincushions collapse simultaneously, vacating their combined footprints.
- **JSON Schema:**
  ```json
  {
    "id": "m801_1",
    "type": "M801",
    "cells": [[2, 2], [2, 3], [3, 2], [3, 3]],
    "params": {
      "sharedHp": 6,
      "twinId": "m801_2"
    },
    "hammerable": false
  }
  ```

### 2. M802 — Armoured Pincushion (Shield Guardian)
- **Catalog Metadata:** ID `M802` | Themed Name: Armoured Pincushion | Generic: Shield Guardian | Intro: Level 8131 | Category: X/B | Hammerable: No
- **Behavior:**
  - A $2\times 2$ pincushion fitted with an impenetrable brass cap.
  - Immune to pin extractions while its linked clutch lever is in the "Shielded" mode.
  - Tapping the linked lever (costs 1 move) lowers the shield, making the pincushion vulnerable to thread-pull damage.
- **JSON Schema:**
  ```json
  {
    "id": "m802_1",
    "type": "M802",
    "cells": [[5, 8], [5, 9], [6, 8], [6, 9]],
    "params": {
      "hp": 5,
      "linkedLeverId": "lever_armour_1"
    },
    "hammerable": false
  }
  ```

### 3. M803 — Seeding Pincushion (Spawner Guardian)
- **Catalog Metadata:** ID `M803` | Themed Name: Seeding Pincushion | Generic: Spawner Guardian | Intro: Level 8251 | Category: X/B | Hammerable: No
- **Behavior:**
  - A $2\times 2$ pincushion with active button buds.
  - Every $N$ (4) moves, spawns a single wooden button blocker (M001) in the first available adjacent empty cell in directional order ($U \to R \to D \to L$).
  - Spawning permanently terminates when guardian HP reaches 0.
- **JSON Schema:**
  ```json
  {
    "id": "m803_1",
    "type": "M803",
    "cells": [[7, 2], [7, 3], [8, 2], [8, 3]],
    "params": {
      "hp": 4,
      "spawnInterval": 4
    },
    "hammerable": false
  }
  ```

### 4. M804 — Heart Pincushion (Guardian Core)
- **Catalog Metadata:** ID `M804` | Themed Name: Heart Pincushion | Generic: Guardian Core | Intro: Level 8371 | Category: X/B | Hammerable: No
- **Behavior:**
  - A large $3\times 3$ royal guardian featuring a designated central core cell (`[5, 5]`).
  - Takes damage from adjacent thread extractions only when an active light beam (Phase 6 Lamplight) is directed onto its core cell.
- **JSON Schema:**
  ```json
  {
    "id": "m804_1",
    "type": "M804",
    "cells": [[4, 4], [4, 5], [4, 6], [5, 4], [5, 5], [5, 6], [6, 4], [6, 5], [6, 6]],
    "params": {
      "coreCell": [5, 5],
      "hp": 8
    },
    "hammerable": false
  }
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m801_twin_pincushions.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m802_armoured_pincushion.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m803_seeding_pincushion.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m804_heart_pincushion.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/mechanic_registry.dart` (changed: register M801–M804 factory handlers)

## Risks and Open Questions
- None. Catalog parameters match `SHARED_CORE_STANDARD.md` §10 and Phase 17 source documents.

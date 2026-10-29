Source docs: phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md, phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/obstacle-catalog-phase-1.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-5-signature-system.md.

# Spec: Gameplay — Phase 5 Base Mechanics (M201–M204)

## Status
Draft

## Type
New Feature

## Goal
Specify the rules, attributes, JSON schemas, solver constraints, and edge case behaviors for the 4 Phase 5 craft base mechanics: M201 Crate Pit, M202 Satin Crate, M203 Charm Crate, and M204 Iron Crate.

## Current State
Design documented in `phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md`, not yet implemented.

## Proposed Change
Implement M201 through M204 in `packages/puzzle_core`:

### 1. Catalog Cards

#### M201 — Crate Pit (Crate Holes)
- **ID:** `M201`
- **Themed Name:** Crate Pit
- **Generic Equivalent:** Crate Holes
- **Intro Level:** L2011
- **Category:** Board / Ground (B/G)
- **Hammerable:** No (pit cell is indestructible); Crates pushed into it are hammerable prior to filling.
- **Rule:** A recessed hole in the linen fabric acting as a static blocker. When any pushable crate (standard or modifier variant) is displaced into the pit cell, the crate drops into and fills the pit. Both the crate and the pit are consumed and become a standard, walkable linen cell over which threads can freely unravel.
- **Edge Cases:** If a thread unravelling tries to push into an already occupied pit, it snags; threads cannot enter an unfilled pit.
- **JSON Schema:**
  ```json
  {
    "id": "m201_1",
    "type": "M201",
    "cells": [[4, 7]],
    "params": {
      "filled": false
    },
    "hammerable": false
  }
  ```

#### M202 — Satin Crate (Sliding Ice Crates)
- **ID:** `M202`
- **Themed Name:** Satin Crate
- **Generic Equivalent:** Sliding Ice Crates
- **Intro Level:** L2131
- **Category:** Board / Ground (B/G)
- **Hammerable:** Yes (Golden Scissors snips crate in 1 strike).
- **Rule:** A sleek crate wrapped in glossy satin fabric. When pushed by an unraveling thread, it does NOT stop after 1 cell; it continues sliding forward in the push direction until it encounters an immovable blocker, another crate, a board boundary, or falls into a Crate Pit (M201).
- **Edge Cases:** If the immediate adjacent cell is blocked, no slide occurs and the pushing thread snags. If it hits an unfilled pit during sliding, it immediately falls in and fills the pit, stopping all further movement.
- **JSON Schema:**
  ```json
  {
    "id": "m202_1",
    "type": "M202",
    "cells": [[6, 3]],
    "params": {
      "sliding": true
    },
    "hammerable": true
  }
  ```

#### M203 — Charm Crate (Crate Keys)
- **ID:** `M203`
- **Themed Name:** Charm Crate
- **Generic Equivalent:** Crate Keys
- **Intro Level:** L2251
- **Category:** Key (K)
- **Hammerable:** No.
- **Rule:** A wooden crate bearing an embossed metallic charm key. When pushed onto the coordinate of its matching clasp lock (M004 Clasp Lock with matching `charmColor`), the clasp permanently unlocks and opens, and the Charm Crate is consumed and removed from the board with a sparkling golden chime.
- **Edge Cases:** Pushing a charm crate onto a non-matching clasp or mismatched blocker results in a snag collision.
- **JSON Schema:**
  ```json
  {
    "id": "m203_1",
    "type": "M203",
    "cells": [[2, 8]],
    "params": {
      "charmColor": "gold",
      "targetClaspId": "m004_2"
    },
    "hammerable": false
  }
  ```

#### M204 — Iron Crate (Heavy Crate)
- **ID:** `M204`
- **Themed Name:** Iron Crate
- **Generic Equivalent:** Heavy Crate
- **Intro Level:** L2371
- **Category:** Blocker (B)
- **Hammerable:** No.
- **Rule:** A heavy cast-iron notions chest with industrial rivets. Standard threads lack sufficient pulling force and will snag upon colliding with it (-1 Heart). It can ONLY be displaced 1 cell by heavy-pull thread types: Chunky Chenille threads (M024) or Ribbon-Tied Pairs (M011).
- **Edge Cases:** If a Chunky Chenille thread pushes an Iron Crate but the cell behind it is blocked, the thread still snags.
- **JSON Schema:**
  ```json
  {
    "id": "m204_1",
    "type": "M204",
    "cells": [[8, 8]],
    "params": {
      "weight": "heavy"
    },
    "hammerable": false
  }
  ```

### 2. Solver Integration
- Reverse generation in `tools/levelgen` accounts for crate rollback:
  - For M201: generator generates level with filled pit, then un-fills pit by rolling back crate.
  - For M202: slider raycast reverse unwinds to potential initial positions.
  - For M203: key-lock dependency guarantees charm crate is pushable to clasp prior to locked threads needing clearance.
  - For M204: heavy pulling thread assignment enforces thread type compatibility.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m201_crate_pit.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m202_satin_crate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m203_charm_crate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m204_iron_crate.dart` (to be created)
- `tools/levelgen/lib/src/generators/mechanics_factory.dart` (changed: register M201–M204)

## Risks
- Sliding crates (M202) overshooting intended target cells in user mental model. Mitigated by clear trajectory preview when Thread Peek is active.

## Open Questions
None. Catalog cards and parameters match Phase 5 documentation.

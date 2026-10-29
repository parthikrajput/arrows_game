Source docs: phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md, phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/phase-18-signature-system.md.

# Spec: Gameplay — Phase 18 Base Mechanics (M851–M854)

## Status
Draft

## Type
New Feature

## Goal
Define the data models, mechanical behaviors, interaction rules, and JSON schemas for the four Phase 18 combo mechanics: Cycle Crate (M851), Floor Beam (M852), Fogged Stair (M853), and Satin Charm Crate (M854).

## Current State
Documented in `phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md`, not yet implemented in code.

## Proposed Change
Implement four new base mechanics in `packages/puzzle_core/lib/src/mechanics/`:

### 1. M851 — Cycle Crate
- **Catalog Metadata:** ID `M851` | Themed Name: Cycle Crate | Generic: Cycle Crate | Intro: Level 8511 | Category: C/D | Hammerable: Yes (1 crate per snip)
- **Behavior:**
  - Wooden pushable crate linked to the Day/Night cycle.
  - In Day phase (`activeCycle: "A"`), behaves as a standard pushable crate (M201).
  - In Night phase (`activeCycle: "B"`), latches to the loom frame and acts as an immovable single blocker.
- **JSON Schema:**
  ```json
  {
    "id": "m851_1",
    "type": "M851",
    "cells": [[4, 4]],
    "params": {
      "activeCycle": "A"
    },
    "hammerable": true
  }
  ```

### 2. M852 — Floor Beam
- **Catalog Metadata:** ID `M852` | Themed Name: Floor Beam | Generic: Floor Beam | Intro: Level 8631 | Category: O/D | Hammerable: No
- **Behavior:**
  - Optical light ray that projects downward through translucent organza floor layers (Floor 1 $\to$ Floor 2).
  - Illuminates lower-floor sun-catchers.
  - If a thread or obstacle blocks the beam on Floor 1, the projection to Floor 2 is severed immediately.
- **JSON Schema:**
  ```json
  {
    "id": "m852_1",
    "type": "M852",
    "cells": [[6, 6]],
    "params": {
      "sourceFloor": 1,
      "targetFloor": 2
    },
    "hammerable": false
  }
  ```

### 3. M853 — Fogged Stair
- **Catalog Metadata:** ID `M853` | Themed Name: Fogged Stair | Generic: Fogged Stair | Intro: Level 8751 | Category: T/B | Hammerable: No
- **Behavior:**
  - Multi-floor staircase transition cell covered by dense wool fluff fog.
  - Invisible from upper perspective until an unravelling thread touches or crosses the cell, permanently clearing the fog and revealing the stairs.
- **JSON Schema:**
  ```json
  {
    "id": "m853_1",
    "type": "M853",
    "cells": [[3, 8]],
    "params": {
      "linkedFloor": 2,
      "revealed": false
    },
    "hammerable": false
  }
  ```

### 4. M854 — Satin Charm Crate
- **Catalog Metadata:** ID `M854` | Themed Name: Satin Charm Crate | Generic: Satin Charm Crate | Intro: Level 8871 | Category: C/K | Hammerable: Yes
- **Behavior:**
  - Sliding crate wrapped in polished satin that houses an embedded golden charm key.
  - Pushing the crate into its target clasp permanently unlocks the clasp and dissolves the crate into the linen weave.
- **JSON Schema:**
  ```json
  {
    "id": "m854_1",
    "type": "M854",
    "cells": [[8, 3]],
    "params": {
      "targetClaspId": "clasp_satin_1"
    },
    "hammerable": true
  }
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m851_cycle_crate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m852_floor_beam.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m853_fogged_stair.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m854_satin_charm_crate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/mechanic_registry.dart` (changed: register M851–M854 factory handlers)

## Risks and Open Questions
- None. Catalog parameters match `SHARED_CORE_STANDARD.md` §10 and Phase 18 source documents.

Source docs: phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md, phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/obstacle-catalog-phase-1.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-11-signature-system.md.

# Spec: Gameplay — Phase 11 Base Mechanics (M501–M504)

## Status
Draft

## Type
New Feature

## Goal
Specify the rules, attributes, JSON schemas, solver constraints, and edge case behaviors for the 4 Phase 11 craft base mechanics: M501 Seam Edge, M502 Cross Charm, M503 Mirror Hoop, and M504 Relay Pompom.

## Current State
Design documented in `phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md`, not yet implemented.

## Proposed Change
Implement M501 through M504 in `packages/puzzle_core`:

### 1. Catalog Cards

#### M501 — Seam Edge (Board Link Edge)
- **ID:** `M501`
- **Themed Name:** Seam Edge
- **Generic Equivalent:** Board Link Edge
- **Intro Level:** L5011
- **Category:** Transition / Edge (T/E)
- **Hammerable:** No.
- **Rule:** A stitched basting seam joining the perimeter border of Hoop A to the entry edge of Hoop B. When an unravelling thread exits through a Seam Edge cell on Hoop A, it teleports seamlessly into the designated entry cell on Hoop B, maintaining its velocity and direction. If the target entry cell on Hoop B is obstructed, the thread collides and snags on the seam (-1 Heart).
- **Edge Cases:** If a thread traverses the seam and exits the outer boundary of Hoop B, it successfully completes its unraveling.
- **JSON Schema:**
  ```json
  {
    "id": "m501_1",
    "type": "M501",
    "cells": [[7, 0]],
    "params": {
      "targetBoard": "hoop_b",
      "targetCell": [0, 0],
      "dir": "right"
    },
    "hammerable": false
  }
  ```

#### M502 — Cross Charm (Cross-board Key)
- **ID:** `M502`
- **Themed Name:** Cross Charm
- **Generic Equivalent:** Cross-board Key
- **Intro Level:** L5131
- **Category:** Key (K)
- **Hammerable:** Yes (Golden Scissors snips charm in 1 strike).
- **Rule:** An engraved metallic craft charm located on Hoop A. When the thread carrying this charm completely unravels from Hoop A, its matching clasp lock (`linkedClaspId`) located across on Hoop B permanently unlocks and frees its cell.
- **Edge Cases:** Snipping the charm with scissors unlocks the linked clasp immediately.
- **JSON Schema:**
  ```json
  {
    "id": "m502_1",
    "type": "M502",
    "cells": [[3, 4]],
    "params": {
      "sourceBoard": "hoop_a",
      "targetBoard": "hoop_b",
      "linkedClaspId": "clasp_b_1"
    },
    "hammerable": true
  }
  ```

#### M503 — Mirror Hoop (Mirror Board)
- **ID:** `M503`
- **Themed Name:** Mirror Hoop
- **Generic Equivalent:** Mirror Board
- **Intro Level:** L5251
- **Category:** Path / Linked (P)
- **Hammerable:** No.
- **Rule:** Synchronized twin threads split across Hoop A and Hoop B. Tapping the thread on Hoop A triggers simultaneous unraveling of its mirror twin on Hoop B (and vice versa). Both paths must be completely unobstructed; if either thread encounters a collision, both threads recoil to their starting positions and exactly 1 Heart is deducted.
- **Edge Cases:** Booster Needle Glow illuminates paths on both hoops simultaneously.
- **JSON Schema:**
  ```json
  {
    "id": "m503_1",
    "type": "M503",
    "cells": [[2, 2]],
    "params": {
      "twinBoard": "hoop_b",
      "twinThreadId": "t_b_04"
    },
    "hammerable": false
  }
  ```

#### M504 — Relay Pompom (Relay Portal)
- **ID:** `M504`
- **Themed Name:** Relay Pompom
- **Generic Equivalent:** Relay Portal
- **Intro Level:** L5371
- **Category:** Transition / Portal (T)
- **Hammerable:** No.
- **Rule:** A pair of fluffy yarn pompom portals connecting distant cells across hoops (one pompom on Hoop A, one on Hoop B). When a thread enters the pompom on Hoop A, its needle immediately emerges from the paired pompom on Hoop B with preserved heading, continuing its unravel route.
- **Edge Cases:** If the destination pompom exit vector is blocked, the thread snags upon entering the portal (-1 Heart).
- **JSON Schema:**
  ```json
  {
    "id": "m504_1",
    "type": "M504",
    "cells": [[5, 5]],
    "params": {
      "sourceBoard": "hoop_a",
      "linkedBoard": "hoop_b",
      "linkedCell": [2, 2]
    },
    "hammerable": false
  }
  ```

### 2. Solver Integration
- Reverse generation in `tools/levelgen`:
  - M501: Validates that seam exits correspond to open reception channels on the sister hoop.
  - M502: Enforces topological order: Key Thread (Hoop A) $\rightarrow$ Unlock Clasp (Hoop B) $\rightarrow$ Dependent Threads (Hoop B).
  - M503: Verifies parity of dual-clear paths across both canvases.
  - M504: Prevents portal routing cycles (A $\to$ B $\to$ A infinite loops).

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m501_seam_edge.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m502_cross_charm.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m503_mirror_hoop.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m504_relay_pompom.dart` (to be created)
- `tools/levelgen/lib/src/generators/mechanics_factory.dart` (changed: register M501–M504)

## Risks
- Player confusion tracking threads moving across disconnected boards. Mitigated by animated golden stitch paths and simultaneous camera auto-framing.

## Open Questions
None. Catalog cards, parameters, and intro levels match Phase 11 documentation.

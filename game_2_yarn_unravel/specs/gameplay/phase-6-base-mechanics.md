Source docs: phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md, phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/obstacle-catalog-phase-1.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-6-signature-system.md.

# Spec: Gameplay — Phase 6 Base Mechanics (M251–M254)

## Status
Draft

## Type
New Feature

## Goal
Specify the rules, attributes, JSON schemas, solver constraints, and edge case behaviors for the 4 Phase 6 craft base mechanics: M251 Tinted Glass, M252 Prism Clasp, M253 Hourglass Lamp, and M254 Shadow Pocket.

## Current State
Design documented in `phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md`, not yet implemented.

## Proposed Change
Implement M251 through M254 in `packages/puzzle_core`:

### 1. Catalog Cards

#### M251 — Tinted Glass (Color Filter)
- **ID:** `M251`
- **Themed Name:** Tinted Glass
- **Generic Equivalent:** Color Filter
- **Intro Level:** L2511
- **Category:** Blocker / Dynamic (B/D)
- **Hammerable:** Yes (Golden Scissors shatters glass in 1 strike).
- **Rule:** A pane of translucent tinted glass set into the linen board. When a standard neutral light beam passes through it, the emerging ray adopts the filter's chromatic spectrum (e.g., Red, Blue, Green, Amber). Chromatic Sun-Catchers only open when illuminated by their exact matching color. Threads attempting to cross through tinted glass snag (-1 Heart).
- **Edge Cases:** Multiple filters along a single beam ray combine subtractively or overwrite based on standard primary pigment combinations.
- **JSON Schema:**
  ```json
  {
    "id": "m251_1",
    "type": "M251",
    "cells": [[5, 4]],
    "params": {
      "filterColor": "green"
    },
    "hammerable": true
  }
  ```

#### M252 — Prism Clasp (Beam Splitter Lock)
- **ID:** `M252`
- **Themed Name:** Prism Clasp
- **Generic Equivalent:** Beam Splitter Lock
- **Intro Level:** L2631
- **Category:** Key (K)
- **Hammerable:** No.
- **Rule:** A multi-faceted optical crystal clasp locking down surrounding threads. Acts as an impenetrable blocker until at least 2 distinct light beams (e.g., incident from orthogonal directions) simultaneously strike the crystal at the end of a turn. Once illuminated by $\ge 2$ beams, the clasp permanently unlocks, shatters into golden light particles, and vacates its cell.
- **Edge Cases:** If only 1 beam strikes the prism, it remains locked and displays an indicator badge (`1/2`).
- **JSON Schema:**
  ```json
  {
    "id": "m252_1",
    "type": "M252",
    "cells": [[7, 7]],
    "params": {
      "requiredBeams": 2
    },
    "hammerable": false
  }
  ```

#### M253 — Hourglass Lamp (Beam Timer)
- **ID:** `M253`
- **Themed Name:** Hourglass Lamp
- **Generic Equivalent:** Beam Timer
- **Intro Level:** L2751
- **Category:** Timer / Controller (T/C)
- **Hammerable:** No.
- **Rule:** A brass atelier lantern controlled strictly by player move turns. It maintains an active beam emission for $N$ valid player moves, then turns OFF for $N$ player moves (e.g., 3 moves ON, 3 moves OFF). Completely turn-based; zero real-time wall-clock dependencies. The lamp housing is an immovable blocker.
- **Edge Cases:** Taps that result in bumps or invalid moves do NOT advance the move counter or toggle the lamp.
- **JSON Schema:**
  ```json
  {
    "id": "m253_1",
    "type": "M253",
    "cells": [[2, 2]],
    "params": {
      "interval": 3,
      "initialState": "ON"
    },
    "hammerable": false
  }
  ```

#### M254 — Shadow Pocket (Dark Cells)
- **ID:** `M254`
- **Themed Name:** Shadow Pocket
- **Generic Equivalent:** Dark Cells
- **Intro Level:** L2871
- **Category:** Controller / Key (C/K)
- **Hammerable:** No.
- **Rule:** An unlit, darkened region of the craft board. Any thread that has any part of its body residing inside an active Shadow Pocket is visually cloaked and **locked** (tapping the thread triggers a soft wobble + tactile tick, 0 hearts lost). When any light beam shines across the shadow cell, the darkness dissipates, and all encompassed threads immediately become selectable.
- **Edge Cases:** If a beam is re-occluded, the cell returns to darkness on the next tick, re-locking threads if they have not yet unraveled.
- **JSON Schema:**
  ```json
  {
    "id": "m254_1",
    "type": "M254",
    "cells": [[8, 4], [8, 5], [9, 4], [9, 5]],
    "params": {
      "illuminated": false
    },
    "hammerable": false
  }
  ```

### 2. Solver Integration
- Reverse level generation in `tools/levelgen`:
  - M251: Solver ensures at least one valid path permits unblocking the beam before the colored Sun-Catcher must open.
  - M252: Forward simulator verifies that concurrent beam intersections are reachable without requiring booster interventions.
  - M253: Modulo parity checks guarantee solvability regardless of start move phase.
  - M254: Establishes clear prerequisite chains (Light Beam Source $\rightarrow$ Unravel Blocker $\rightarrow$ Clear Shadow $\rightarrow$ Select Thread).

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m251_tinted_glass.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m252_prism_clasp.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m253_hourglass_lamp.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m254_shadow_pocket.dart` (to be created)
- `tools/levelgen/lib/src/generators/mechanics_factory.dart` (changed: register M251–M254)

## Risks
- Players mistaking M253 Hourglass Lamp for a real-time countdown timer. Mitigated by explicit Move Counter pip display on the lamp base (`3/3 moves`).

## Open Questions
None. Catalog cards, parameters, and intro levels match Phase 6 documentation.

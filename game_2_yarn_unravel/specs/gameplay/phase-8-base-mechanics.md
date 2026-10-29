Source docs: phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md, phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/obstacle-catalog-phase-1.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-8-signature-system.md.

# Spec: Gameplay — Phase 8 Base Mechanics (M351–M354)

## Status
Draft

## Type
New Feature

## Goal
Specify the rules, attributes, JSON schemas, solver constraints, and edge case behaviors for the 4 Phase 8 craft base mechanics: M351 Ivy Yarn, M352 Snip Tile, M353 Seed Bead Thread, and M354 Blossom Gate.

## Current State
Design documented in `phase/phase_8/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md`, not yet implemented.

## Proposed Change
Implement M351 through M354 in `packages/puzzle_core`:

### 1. Catalog Cards

#### M351 — Ivy Yarn (Vine Spread+)
- **ID:** `M351`
- **Themed Name:** Ivy Yarn
- **Generic Equivalent:** Vine Spread+
- **Intro Level:** L3511
- **Category:** Dynamic Blocker / Spreader (C)
- **Hammerable:** Yes (1 Golden Scissors snip destroys 1 target vine cell).
- **Rule:** A green woolen vine sprout root. Every $N$ player moves (default: 3 moves), it generates 2 new vine segments into adjacent empty cells following clockwise direction priority ($U \to R \to D \to L$). If all adjacent cells are blocked, it temporarily pauses expansion until space frees up.
- **Edge Cases:** If a vine attempts to spread into an occupied cell, that branch stalls.
- **JSON Schema:**
  ```json
  {
    "id": "m351_1",
    "type": "M351",
    "cells": [[6, 6]],
    "params": {
      "spreadInterval": 3,
      "spreadCount": 2
    },
    "hammerable": true
  }
  ```

#### M352 — Snip Tile (Pruner Tile)
- **ID:** `M352`
- **Themed Name:** Snip Tile
- **Generic Equivalent:** Pruner Tile
- **Intro Level:** L3631
- **Category:** Dynamic / Ground (D/G)
- **Hammerable:** No.
- **Rule:** An embroidered shears insignia on the linen canvas. When any thread's unravel trajectory crosses over this tile, all ivy vine cells within the surrounding 8 cells ($3 \times 3$ bounding box centered on the tile) are instantly pruned, snipped, and removed from the board, releasing wool trimmings.
- **Edge Cases:** Threads passing diagonally across the tile trigger the prune effect synchronously during Step 1.
- **JSON Schema:**
  ```json
  {
    "id": "m352_1",
    "type": "M352",
    "cells": [[5, 8]],
    "params": {
      "pruneRadius": 1
    },
    "hammerable": false
  }
  ```

#### M353 — Seed Bead Thread (Seed Path)
- **ID:** `M353`
- **Themed Name:** Seed Bead Thread
- **Generic Equivalent:** Seed Path
- **Intro Level:** L3751
- **Category:** Path (P)
- **Hammerable:** Yes (Golden Scissors snips thread).
- **Rule:** A thread carrying a small polished wooden seed bead at its tail coordinate. When this thread completely unravels and leaves the board, the seed bead remains behind on the tail's cell, starting a 3-move countdown timer. If the countdown reaches 0 and the cell remains vacant, the bead germinates into a permanent **Wooden Button (M001)** obstacle. If another thread unravels across the cell before countdown reaches 0, the seed bead is crushed and destroyed.
- **Edge Cases:** Seed beads on board cells can be destroyed with Golden Scissors before germinating.
- **JSON Schema:**
  ```json
  {
    "id": "m353_1",
    "type": "M353",
    "cells": [[3, 3], [3, 4], [3, 5]],
    "params": {
      "seedDelay": 3
    },
    "hammerable": true
  }
  ```

#### M354 — Blossom Gate (Bloom Gate)
- **ID:** `M354`
- **Themed Name:** Blossom Gate
- **Generic Equivalent:** Bloom Gate
- **Intro Level:** L3871
- **Category:** Blocker / Gate (B)
- **Hammerable:** No.
- **Rule:** A closed floral bud barrier blocking threads. It is linked to $K$ designated adjacent ivy cells (`requiredPrunes`). When all $K$ ivy cells are successfully pruned (via Snip Tiles or Scissors), the bud blossoms into an open floral embroidered gate, permanently freeing the cell for unraveling threads.
- **Edge Cases:** If ivy regrows into adjacent cells before the gate opens, the counter does not reset; only total pruned count is tracked.
- **JSON Schema:**
  ```json
  {
    "id": "m354_1",
    "type": "M354",
    "cells": [[7, 9]],
    "params": {
      "requiredPrunes": 3
    },
    "hammerable": false
  }
  ```

### 2. Solver Integration
- Reverse generation in `tools/levelgen`:
  - M351: Simulates board reverse expansion to calculate safe pruning checkpoints.
  - M352: Validates that Snip Tiles are placed along required exit paths before vine spread overwhelms key corridors.
  - M353: Enforces move-order sequences so seed beads do not mature into blockers along unvisited exit routes.
  - M354: Dependency graph verifies prune quota is achievable before thread unravelling requires passage through the gate.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m351_ivy_yarn.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m352_snip_tile.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m353_seed_bead_thread.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m354_blossom_gate.dart` (to be created)
- `tools/levelgen/lib/src/generators/mechanics_factory.dart` (changed: register M351–M354)

## Risks
- Vine expansion timing variance causing level unplayability. Mitigated by strictly deterministic move counters (zero real-time variance).

## Open Questions
None. Catalog cards, parameters, and intro levels match Phase 8 documentation.

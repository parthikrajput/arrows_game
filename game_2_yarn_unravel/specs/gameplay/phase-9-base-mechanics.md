Source docs: phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md, phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/obstacle-catalog-phase-1.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-9-signature-system.md.

# Spec: Gameplay — Phase 9 Base Mechanics (M401–M404)

## Status
Draft

## Type
New Feature

## Goal
Specify the rules, attributes, JSON schemas, solver constraints, and edge case behaviors for the 4 Phase 9 craft base mechanics: M401 Twisting Pad, M402 Double Split, M403 Stitch Lock, and M404 Rejoin Gate.

## Current State
Design documented in `phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md`, not yet implemented.

## Proposed Change
Implement M401 through M404 in `packages/puzzle_core`:

### 1. Catalog Cards

#### M401 — Twisting Pad (Merger Pad)
- **ID:** `M401`
- **Themed Name:** Twisting Pad
- **Generic Equivalent:** Merger Pad
- **Intro Level:** L4011
- **Category:** Dynamic / Ground (D/G)
- **Hammerable:** No.
- **Rule:** A specialized wool spinning pad occupying 2 adjacent cells `[(x1, y1), (x2, y2)]`. When two compatible thread needle heads occupy these cells, the pad activates with a golden pulse. Tapping the pad (costs 1 move) merges both threads into a single consolidated thread, twisting their fibers together. The new thread adopts the leading needle's direction and the combined length.
- **Edge Cases:** If only 1 needle is on the pad, tapping plays a soft denial wobble (0 moves expended).
- **JSON Schema:**
  ```json
  {
    "id": "m401_1",
    "type": "M401",
    "cells": [[4, 5], [4, 6]],
    "params": {
      "orientation": "horizontal"
    },
    "hammerable": false
  }
  ```

#### M402 — Double Split (Twin Splitter)
- **ID:** `M402`
- **Themed Name:** Double Split
- **Generic Equivalent:** Twin Splitter
- **Intro Level:** L4131
- **Category:** Path / Transform (P/T)
- **Hammerable:** No.
- **Rule:** A dual-eyelet embroidery guide positioned on the board canvas. When a thread's needle head traverses through the tile, the thread splits into two independent half-ply threads. Both child threads continue moving forward along the original heading (`dir`) on adjacent parallel tracks.
- **Edge Cases:** If one of the parallel child tracks is blocked, the thread cannot enter the splitter and snags (-1 Heart).
- **JSON Schema:**
  ```json
  {
    "id": "m402_1",
    "type": "M402",
    "cells": [[7, 8]],
    "params": {
      "axis": "forward"
    },
    "hammerable": false
  }
  ```

#### M403 — Stitch Lock (Segment Lock)
- **ID:** `M403`
- **Themed Name:** Stitch Lock
- **Generic Equivalent:** Segment Lock
- **Intro Level:** L4251
- **Category:** Key / Lock (K/L)
- **Hammerable:** Yes (Golden Scissors snips lock in 1 strike).
- **Rule:** A steel safety clip fastened to a specific segment $k$ along a thread's body. The locked thread cannot be unraveled until its designated key-thread (`keyThreadId`) completely exits the board. Tapping the locked thread produces a locked denial haptic (0 hearts lost).
- **Edge Cases:** If the key-thread has unraveled, the lock pops open with a metallic chime.
- **JSON Schema:**
  ```json
  {
    "id": "m403_1",
    "type": "M403",
    "cells": [[5, 3]],
    "params": {
      "keyThreadId": "t_12",
      "segmentIndex": 2
    },
    "hammerable": true
  }
  ```

#### M404 — Rejoin Gate (Rejoin Gate)
- **ID:** `M404`
- **Themed Name:** Rejoin Gate
- **Generic Equivalent:** Rejoin Gate
- **Intro Level:** L4371
- **Category:** Blocker / Gate (B)
- **Hammerable:** No.
- **Rule:** A brass buckle craft gate acting as a solid blocker. It is keyed to a specific split thread (`requiredParentThreadId`). When both child plies of that thread have successfully traversed through the gate opening, the gate snaps open permanently, clearing the cell for all subsequent threads.
- **Edge Cases:** Unrelated threads cannot pass through the gate while closed.
- **JSON Schema:**
  ```json
  {
    "id": "m404_1",
    "type": "M404",
    "cells": [[8, 4]],
    "params": {
      "requiredParentThreadId": "t_05"
    },
    "hammerable": false
  }
  ```

### 2. Solver Integration
- Reverse generation in `tools/levelgen`:
  - M401: Validates that merger actions do not combine threads whose collective length creates immediate downstream snags.
  - M402: Generates parallel exit paths for child plies before positioning parent thread.
  - M403: Constructs topological dependency chain: Key Thread $\rightarrow$ Unlock Segment $\rightarrow$ Target Thread Unravel.
  - M404: Ensures both child plies are solvable and reach the Rejoin Gate in valid move sequences.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m401_twisting_pad.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m402_double_split.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m403_stitch_lock.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m404_rejoin_gate.dart` (to be created)
- `tools/levelgen/lib/src/generators/mechanics_factory.dart` (changed: register M401–M404)

## Risks
- Parallel split threads colliding if parallel channels are too narrow. Mitigated by grid validation requiring at least 1 free empty track per split channel.

## Open Questions
None. Catalog cards, parameters, and intro levels match Phase 9 documentation.

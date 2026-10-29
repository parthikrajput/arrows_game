Source docs: phases/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md, phases/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, §16.18, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-11-signature-system.md, specs/gameplay/phase-10-base-mechanics.md.

# Spec: Gameplay — Phase 11 Base Mechanics (M501–M504)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 11 (Levels 5001–5500) — M501 Vine Bridge Edge (Board Link Edge), M502 Messenger Key (Cross-Board Key), M503 Pond Reflection (Mirror Board), and M504 Relay Burrow (Relay Portal) — coordinating inter-board edge transit, remote cross-board unlocks, synchronized mirror movement, and dual-grid subterranean portals.

## Current State
Design documented in `phases/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md`, `phases/phase_11/01_PHASE_11_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Previous mechanics operated within the coordinate space of a single board grid.
- Phase 11 introduces topological linking where entity positions, keys, and player inputs cross boundaries between two distinct sub-grids.

## Proposed Change
Implement mechanics M501 through M504 in `packages/puzzle_core/lib/src/mechanics/phase_11/`:

### 1. Mechanic Specifications

#### A. M501: Vine Bridge Edge / Board Link Edge
- **Intro Level:** L5011 (Block 502, x1 slot).
- **Category:** Inter-Board Transit Link (`D`).
- **Visual:** A lush braided vine suspension bridge spanning the water channel between Board 1 and Board 2.
- **Rule:**
  - Connects an exit cell on Board 1 (`exitCell: [r1, c1]`) to an entry cell on Board 2 (`entryCell: [r2, c2]`).
  - When a snake exits through the bridge cell, it does not leave the puzzle; its head immediately enters Board 2 along the specified entry vector.
  - Body segments continuously span across the bridge. Segment collision flags are maintained on both boards simultaneously until the tail vacates Board 1.
  - Zero-Damage Guard: If the entry cell or immediate onward vector on Board 2 is occupied or blocked, the snake halts safely at the Board 1 bridgehead (0 hearts lost).
- **JSON Format:**
  ```json
  {
    "id": "o501_1",
    "type": "M501",
    "cells": [[7, 3]],
    "params": {
      "sourceBoard": 1,
      "destBoard": 2,
      "sourceCell": [7, 3],
      "destCell": [0, 3],
      "exitDir": "down",
      "entryDir": "down"
    },
    "hammerable": false
  }
  ```

#### B. M502: Messenger Key / Cross-Board Key
- **Intro Level:** L5131 (Block 514, x1 slot).
- **Category:** Inter-Board Remote Trigger (`D`).
- **Visual:** A golden lotus key emblem embedded in the forehead crest of a specific snake entity, linked to a matching stone flower lock on the opposite board.
- **Rule:**
  - Assigned to a specific snake on either Board 1 or Board 2 (`messengerSnakeId: "s_key_1"`).
  - When this snake successfully evacuates its home board, a luminous golden pollen spark travels across the inter-board gap and permanently unlocks the paired lock on the opposing board.
  - Establishes a mandatory cross-board dependency: Board 2 cannot be resolved until the Messenger Snake on Board 1 is liberated.
- **JSON Format:**
  ```json
  {
    "id": "o502_1",
    "type": "M502",
    "cells": [[2, 5]],
    "params": {
      "keySnakeId": "s_key_1",
      "targetBoard": 2,
      "targetLockId": "lock_cross_1",
      "isUnlocked": false
    },
    "hammerable": false
  }
  ```

#### C. M503: Pond Reflection / Mirror Board
- **Intro Level:** L5251 (Block 526, x1 slot).
- **Category:** Synchronized Dual-Grid Movement (`D`).
- **Visual:** Identically colored snake twins on Board 1 and Board 2 surrounded by shimmering water ripples, representing water reflections.
- **Rule:**
  - Pairs Snake A (on Board 1) and Snake B (on Board 2) as reflection partners (`mirrorPairId: "pair_m1"`).
  - Tapping either partner commands **both** snakes to slither simultaneously in their respective forward vectors.
  - **Synchronized Safety:** If either snake's forward trajectory is blocked by any wall or obstacle, **neither snake moves**. Both snakes execute a synchronized head-bonk animation and remain at rest (0 hearts lost).
  - The pair must both have unobstructed egress before either can exit.
- **JSON Format:**
  ```json
  {
    "id": "o503_1",
    "type": "M503",
    "cells": [],
    "params": {
      "pairId": "pair_m1",
      "snakeAId": "s1_mirror",
      "snakeBId": "s2_mirror",
      "motionType": "parallel"
    },
    "hammerable": false
  }
  ```

#### D. M504: Relay Burrow / Relay Portal
- **Intro Level:** L5371 (Block 538, x1 slot).
- **Category:** Inter-Board Wormhole Fixture (`D`).
- **Visual:** Glowing submerged mossy caves that shimmer with concentric water ripples on both boards.
- **Rule:**
  - Forms an instant underground water conduit between Board 1 (`inCell: [r1, c1]`) and Board 2 (`outCell: [r2, c2]`).
  - When a snake enters the burrow on Board 1, it teleports seamlessly to Board 2, maintaining its exact speed and orientation.
  - Operates with zero wall-clock delay. If the exit burrow on Board 2 is occupied, entry is safely rejected.
- **JSON Format:**
  ```json
  {
    "id": "o504_1",
    "type": "M504",
    "cells": [[4, 6]],
    "params": {
      "sourceBoard": 1,
      "destBoard": 2,
      "entryCell": [4, 6],
      "exitCell": [2, 1],
      "exitDir": "right"
    },
    "hammerable": false
  }
  ```

---

### 2. Solver & Heuristic Guarantees
1. **DAG Bridge Graph:** Vine bridges between Board 1 and Board 2 are directed acyclic paths. Circular infinite loops ($1 \to 2 \to 1$) are prohibited by generator rules.
2. **Buffer Capacity:** Generator enforces that Board 2 possesses at least $L_{\text{snake}} + 2$ unblocked cells along the entry lane before placing an M501 bridge.
3. **Deterministic Search Space:** A* solver searches a combined state tuple `(board1_state, board2_state, transit_queue)` ensuring deterministic completion in $< 50{,}000$ search nodes.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_11/vine_bridge_edge.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_11/messenger_key.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_11/mirror_board_twins.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_11/relay_burrow_portal.dart` (to be created)
- `test/mechanics/phase_11_mechanics_test.dart` (to be created)

## Risks and Open Questions
- **Dual Snake Selection Highlighting:** When tapping a mirror twin (M503), the UI must instantly highlight both snakes across both boards so the player understands both are about to move simultaneously.

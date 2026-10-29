Source docs: phases/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md, phases/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, §16.18, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-10-signature-system.md, specs/gameplay/phase-9-base-mechanics.md.

# Spec: Gameplay — Phase 10 Base Mechanics (M451–M454)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 10 (Levels 4501–5000) — M451 Drum Gate (Rhythm Gate), M452 Totem Pattern Lock (Pattern Lock), M453 Parade Exit (Order Edge), and M454 Echo Frogs (Echo Sequence) — detailing movement modulo logic, chromatic window matching, ordinal egress verification, and group echo constraints.

## Current State
Design documented in `phases/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md`, `phases/phase_10/01_PHASE_10_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Previous phases employed spatial obstacles, dynamic spreaders, and topological bisection.
- Phase 10 introduces temporal turn-state cycles, FIFO chromatic sequence detection, ordinal badge prioritization, and dual-group mirror evacuation.

## Proposed Change
Implement mechanics M451 through M454 in `packages/puzzle_core/lib/src/mechanics/phase_10/`:

### 1. Mechanic Specifications

#### A. M451: Drum Gate / Rhythm Gate
- **Intro Level:** L4511 (Block 452, x1 slot).
- **Category:** Move-Modulo Periodic Barrier (`D`).
- **Visual:** A tribal wooden drum barrier carved with glowing acoustic resonance rings that alternate between lowered (open) and raised (closed) states.
- **Rule:**
  - Placed on a specific board cell blocking transit or perimeter exit.
  - Configured with a discrete cyclic boolean pattern (e.g., `[OPEN, OPEN, CLOSED]`, length $L = 3$).
  - Evaluated on every player move:
    $$\text{State}(\text{Move}) = \text{Pattern}[\text{Move} \pmod L]$$
  - When OPEN, snakes pass through freely.
  - When CLOSED, behaves as an impassable wall. Snakes attempting movement into it trigger a harmless head-bonk with 0 hearts lost.
- **JSON Format:**
  ```json
  {
    "id": "o451_1",
    "type": "M451",
    "cells": [[3, 7]],
    "params": {"pattern": ["open", "open", "closed"], "initialOffset": 0},
    "hammerable": false
  }
  ```

#### B. M452: Totem Pattern Lock / Pattern Lock
- **Intro Level:** L4631 (Block 464, x1 slot).
- **Category:** Trailing Chromatic Window Gate (`D`).
- **Visual:** A tall carved redwood totem pole inscribed with a stack of colored tribal bands (e.g., Red $\to$ Blue $\to$ Green).
- **Rule:**
  - Guards an exit corridor or perimeter threshold.
  - Defines a target color sequence of length $k$ (e.g., `["red", "blue", "yellow"]`).
  - Evaluates the game engine's `ExitHistoryBuffer`:
    $$\text{Match} \iff [E_{n-k+1.\text{color}}, \dots, E_{n.\text{color}}] == \text{TargetPattern}$$
  - When the exact sequence is fulfilled by the most recent $k$ consecutive snake departures, the totem unseals and lowers permanently.
  - If an unlisted or out-of-order color exits, the progress window resets without penalty.
- **JSON Format:**
  ```json
  {
    "id": "o452_1",
    "type": "M452",
    "cells": [[6, 2]],
    "params": {"targetPattern": ["red", "blue", "yellow"], "windowSize": 3},
    "hammerable": false
  }
  ```

#### C. M453: Parade Exit / Order Edge
- **Intro Level:** L4751 (Block 476, x1 slot).
- **Category:** Ordinal Perimeter Egress Gate (`D`).
- **Visual:** A celebratory archway festooned with festival flags and a luminescent numerical ordinal badge (`1`, `2`, `3`...).
- **Rule:**
  - Located on a board edge exit tile.
  - Snakes assigned to this exit bear numerical badges on their dorsal scales ($1, 2, \dots, N$).
  - The gate only accepts departures in strictly ascending sequence ($1 \to 2 \to 3$).
  - Snake #2 cannot exit while Snake #1 remains on the board. Attempting to evacuate an out-of-order snake causes a harmless bump and turns the snake back (0 hearts lost).
- **JSON Format:**
  ```json
  {
    "id": "o453_1",
    "type": "M453",
    "cells": [[0, 5]],
    "params": {"expectedIndex": 1, "maxIndex": 4},
    "hammerable": false
  }
  ```

#### D. M454: Echo Frogs / Echo Sequence
- **Intro Level:** L4871 (Block 488, x1 slot).
- **Category:** Macro Sequence Duplication System (`D`).
- **Visual:** A sacred lagoon guarded by stone frog totems that echo melodic drum beats across two mirrored board sectors.
- **Rule:**
  - Divides snakes into Group A (Master Choir) and Group B (Echo Choir).
  - Group A snakes may be evacuated in any player-selected valid order. Their chromatic exit sequence is recorded into an array $S_A = [C_1, C_2, \dots, C_m]$.
  - Group B gates remain sealed until all Group A members have departed.
  - Once Group B becomes active, Group B snakes must exit in the exact identical chromatic sequence:
    $$\text{Valid}(B_j) \iff \text{Color}(B_j) == S_A[j]$$
  - Selecting an out-of-sequence Group B snake results in a harmless refusal bump.
- **JSON Format:**
  ```json
  {
    "id": "o454_1",
    "type": "M454",
    "cells": [[8, 8]],
    "params": {"masterGroupId": "A", "echoGroupId": "B", "groupSize": 3},
    "hammerable": false
  }
  ```

---

### 2. Solver & Heuristic Guarantees
1. **Parade Reachability:** The generator guarantees that Snake #1 always has an unobstructed initial path to the exit or can be unblocked within 2 moves of other non-conflicting snakes.
2. **Deterministic Sequence Solvability:** A* search state maintains a tuple `(boardState, currentMove, lastKExits, nextParadeIndex, echoBufferIndex)` ensuring complete $0$-booster solvability under $< 50{,}000$ search nodes.
3. **No Turn Deadlocks:** Levels featuring M451 Rhythm Gates provide sufficient neutral moves or cycling room to avoid parity traps.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_10/drum_gate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_10/totem_pattern_lock.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_10/parade_exit.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_10/echo_sequence.dart` (to be created)
- `test/mechanics/phase_10_mechanics_test.dart` (to be created)

## Risks and Open Questions
- **Echo Sequence Feedback Clarity:** If Group A consists of 4 snakes, players need clear UI breadcrumbs showing the recorded sequence when executing Group B. Solved via the Echo Track HUD widget specified in `phase-10-ui-additions.md`.

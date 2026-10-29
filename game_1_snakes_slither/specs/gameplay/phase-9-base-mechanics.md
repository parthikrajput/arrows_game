Source docs: phases/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md, phases/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, §16.18, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-9-signature-system.md, specs/gameplay/phase-8-base-mechanics.md.

# Spec: Gameplay — Phase 9 Base Mechanics (M401–M404)

## Status
Draft

## Type
New Feature

## Goal
Implement the 4 new base mechanics for Phase 9 (Levels 4001–4500) — M401 Merger Pad (Hug Pad), M402 Twin Splitter (Fork Stump), M403 Segment Lock (Bead Lock), and M404 Rejoin Gate (Reunion Gate) — including topological snake splitting, fusion re-indexing, segment counting locks, and twin-completion gates.

## Current State
Design documented in `phases/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md`, `phases/phase_9/01_PHASE_9_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Previous phases maintained fixed snake entities throughout each level.
- Phase 9 introduces dynamic entity decomposition (splitting 1 snake into 2 children) and entity synthesis (merging 2 snakes into 1 unified snake), altering entity rosters and path requirements mid-puzzle.

## Proposed Change
Implement mechanics M401 through M404 in `packages/puzzle_core/lib/src/mechanics/phase_9/`:

### 1. Mechanic Specifications

#### A. M401: Merger Pad / Hug Pad
- **Intro Level:** L4011 (Block 402, x1 slot).
- **Category:** Entity Fusion Floor Fixture (`D`).
- **Visual:** A dual-chambered stone pad with interlocked serpentine groove runes that glow cyan when primed.
- **Rule:**
  - Occupies 2 adjacent orthogonal cells (`cells: [[r1, c1], [r2, c2]]`).
  - Activates when two distinct snakes rest with their Heads simultaneously occupying the 2 pad cells.
  - When the player taps the primed pad (or commands the leading snake), fusion occurs:
    $$\text{Merged Snake} = \text{Head}_A + \text{Body}_A + \text{Body}_B$$
  - The resulting unified snake adopts Snake A's trajectory and color, appending Snake B's body segments behind Snake A's tail. Snake B's original head converts into a body segment.
  - Fusion only executes if Snake A's forward exit vector is unobstructed. If blocked, fusion delays until path clearance is achieved without penalty (Zero Damage rule).
- **JSON Format:**
  ```json
  {
    "id": "o401_1",
    "type": "M401",
    "cells": [[4, 4], [4, 5]],
    "params": {"exitDir": "up"},
    "hammerable": false
  }
  ```

#### B. M402: Twin Splitter / Fork Stump
- **Intro Level:** L4131 (Block 414, x1 slot).
- **Category:** Entity Bifurcation Fixture (`D`).
- **Visual:** A carved twin-fork wooden stump embossed with diverging river carvings and glowing emerald bifurcation nodes.
- **Rule:**
  - Placed on a single board cell.
  - When a snake slithers across this tile, it bifurcates into two child snakes: Left Child ($90^\circ$ turn left) and Right Child ($90^\circ$ turn right).
  - **Segment Division (Odd Segments):**
    - For initial length $N$:
      $$\text{Len}_{\text{Left}} = \lceil N / 2 \rceil, \quad \text{Len}_{\text{Right}} = \lfloor N / 2 \rfloor$$
    - The leading head leads the Left branch; the Right branch instantiates a new child head entity.
  - **Zero Damage Invariant:** Bifurcation requires **both** left and right forward tiles to be vacant simultaneously. If either branch is obstructed, the parent snake bonks harmlessly, halts on the threshold, and loses 0 hearts.
- **JSON Format:**
  ```json
  {
    "id": "o402_1",
    "type": "M402",
    "cells": [[5, 5]],
    "params": {"entryDir": "up", "leftDir": "left", "rightDir": "right"},
    "hammerable": false
  }
  ```

#### C. M403: Segment Lock / Bead Lock
- **Intro Level:** L4251 (Block 426, x1 slot).
- **Category:** Cumulative Metric Gate (`D`).
- **Visual:** A river watergate carved with a string of circular bead sockets that fill with glowing sapphire droplets.
- **Rule:**
  - Operates as an impassable gate blocking snake passage.
  - Tracks the total cumulative count of **body segments** that have exited the board across all snakes, rather than the count of full snakes.
  - Unlocks permanently when $\sum \text{ExitedSegments} \ge N_{\text{target}}$.
  - Example: A target of 12 segments can be fulfilled by three 4-segment snakes or two 6-segment snakes.
- **JSON Format:**
  ```json
  {
    "id": "o403_1",
    "type": "M403",
    "cells": [[7, 3]],
    "params": {"targetSegments": 12, "currentSegments": 0},
    "hammerable": false
  }
  ```

#### D. M404: Rejoin Gate / Reunion Gate
- **Intro Level:** L4371 (Block 438, x1 slot).
- **Category:** Pair Synchronization Gate (`D`).
- **Visual:** A dual-arch stone portal connected by an ethereal silver arc of light that bridges two riverbanks.
- **Rule:**
  - Cryptographically linked to a specific M402 Twin Splitter instance (`splitPairId: "pair_402_1"`).
  - Remains impassable while either twin child snake is active on the board.
  - Unlocks permanently only when **both** child halves generated by that splitter have exited the puzzle board.
  - Prevents puzzle completion or opens critical downstream bypass corridors.
- **JSON Format:**
  ```json
  {
    "id": "o404_1",
    "type": "M404",
    "cells": [[2, 6]],
    "params": {"splitPairId": "pair_402_1", "leftExited": false, "rightExited": false},
    "hammerable": false
  }
  ```

---

### 2. Tick Sequence Integration (§16.17)
1. **Player Action Phase:** Player selects and commands a snake to slither.
2. **Path Clearance Phase:** Trajectory validated against walls, barriers, and split/merge prerequisites.
3. **Entity Transformation Phase:**
   - On M401 trigger: Remove entity B, extend entity A, reassign segment coordinates.
   - On M402 trigger: Create child entity B, bisect segments, assign fork vectors.
4. **Exit Verification Phase:**
   - Departing segments increment active M403 Segment Locks.
   - Departing child entities mark corresponding M404 Reunion Gate flags.
5. **Gate Resolution Phase:** Gates meeting unlock thresholds play retraction VFX/SFX and clear cell collision flags.

---

### 3. Solver & Generator Invariants
1. **Solvability Guarantee:** A* solver maintains a dynamic entity roster. Fork and merger operations are reversible in search nodes to guarantee 0-booster deterministic completion.
2. **Segment Sufficiency:** Total segments across all snakes on the board must satisfy $\sum \text{Segments}_{\text{all}} \ge \sum \text{Target}_{\text{M403}}$ with a minimum safety margin of $+2$ segments.
3. **Deadlock Free Bifurcation:** The procedural generator verifies that twin children never form mutual collision bottlenecks at exit bottlenecks.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_9/merger_pad.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_9/twin_splitter.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_9/segment_lock.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_9/rejoin_gate.dart` (to be created)
- `packages/puzzle_core/lib/src/solver/phase_9_solver_heuristics.dart` (to be created)
- `test/mechanics/phase_9_mechanics_test.dart` (to be created)

## Risks and Open Questions
- **Entity ID Collisions:** Dynamically spawned child snakes from M402 must allocate deterministic unique IDs (`s_id_L`, `s_id_R`) to prevent state desync during undo/redo or level resets.
- **Segment Lock Counter Representation:** For color-blind accessibility, M403 counters must display numerical digits on the lock body in addition to glowing bead rings.

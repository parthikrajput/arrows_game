# Spec: Phase 11 Signature System — Twin Gardens (Linked Boards)

Source docs: phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-10-signature-system.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 11 Signature System — Twin Gardens (Linked Boards) |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 11 (Levels 5001–5500) |

---

## Goal

Introduce multi-board puzzle gameplay where levels consist of two interconnected mini-boards (Garden A and Garden B), allowing cross-board edge transfers, remote cross-board key triggers, synchronized mirror lines, and subterranean relay tunnels.

---

## Current State

Design documented in `phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md` and `phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md`, not yet implemented.

Key facts:
- Signature system name: **Twin Gardens** (Linked Boards architecture).
- Two active mini-boards (Board A and Board B) per level; 12×12 to 14×14 grid dimensions per board.
- Dual-viewport camera switching (smooth 250 ms pan or full zoom-out).
- Four base mechanics introduced: M501 Garden Gate Link, M502 Pen-Pal Key, M503 Reflecting Pond Board, M504 Relay Burrow.
- All prior phase mechanics (M001–M454) remain active across boards.

---

## Proposed Change

### 1. Cross-Board Boundary Link Rules (M501)
- When a line exits Board A via linked edge coordinate $(x_A, y_A)$, it transitions immediately into the corresponding entry coordinate $(x_B, y_B)$ on Board B, preserving velocity and orientation.
- **Atomic Obstruction Check:** If the destination entrance tile on Board B or its immediate forward path is obstructed by a blocker or another line, the move cannot execute; the line bonks on Board A (−1 Heart) with zero displacement across the link.

### 2. Remote Cross-Board Key Logic (M502)
- Key insects on Board A hold explicit metadata linking them to target obstacles on Board B (`params.targetLock: "B_lock_1"`).
- When the key insect exits Board A successfully, the remote thorn lock on Board B dissolves permanently.

### 3. Synchronized Mirror Lines Across Boards (M503)
- An insect line on Board A and its counterpart on Board B form a coupled twin pair.
- Tapping the line on Board A simultaneously moves its twin on Board B.
- Both insects must navigate to valid exits safely; if either encounters an obstacle, the move fails with collision bonk (−1 Heart).

### 4. Relay Burrow Teleportation (M504)
- Linked ground tunnels connect an entrance burrow on Board A with an exit burrow on Board B.
- Ant lines entering the burrow on Board A submerge and instantly emerge on Board B.
- Ground layer only (`Ants only`, `tall: false`). Bees cannot enter subterranean burrows.

### 5. Tick Order (per SHARED_CORE_STANDARD.md §16.17)
1. Player taps/initiates move on active board.
2. If synchronized mirror pair (M503), parallel clearance check evaluates on both Board A and Board B.
3. Cross-board boundary entrance check evaluates (M501 / M504).
4. Lines advance: cross-board transitions execute atomically.
5. Exit evaluations: if key line (M502), trigger unlock event on linked destination board.
6. Board states update; camera smoothly focuses or flags active board events.

### Acceptance Criteria
- [ ] Line exiting Board A via Gate Link appears at matching Board B edge tile seamlessly.
- [ ] If Board B entry is blocked, line bonks on Board A with 0 progress and −1 Heart.
- [ ] Remote key exit on Board A instantly dissolves linked lock on Board B.
- [ ] Synchronized twin lines move in parallel; collision on either board triggers bonk.
- [ ] Bees cannot enter Relay Burrow tunnels; ants traverse safely.
- [ ] Camera switch between Board A and Board B completes within `p11_board_pan_ms = 250` ms.
- [ ] L5001 tutorial overlay fires: "Twin Gardens — Two interconnected gardens! Switch between boards to solve the dual puzzle."

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/mechanics/twin_gardens.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/garden_gate_link.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/pen_pal_key.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/reflecting_pond_board.dart` | To be created |
| `packages/puzzle_core/lib/mechanics/relay_burrow.dart` | To be created |
| `packages/puzzle_core/lib/tick_order.dart` | Changed (dual-board resolution) |
| `packages/puzzle_core/lib/solver/bfs_solver.dart` | Changed (cross-board state tuple) |

---

## API / Remote Config Changes

| Key | Default | Purpose |
|---|---|---|
| `maxPhase` | `10` → `11` | Unlock Phase 11 content |
| `p11_board_pan_ms` | `250` | Board camera transition duration |

---

## Risks and Open Questions

1. **Solver State Space across Dual Boards:** Managing two active 14×14 boards doubles spatial memory footprint. The solver must represent state as a compact compound bitmask `(board_a_mask, board_b_mask, active_keys)`.
2. **Camera Focus on Remote Events:** When an action on Board A triggers an unlock or arrival on Board B, camera panning must not disorient the player. A dual mini-map preview is required.

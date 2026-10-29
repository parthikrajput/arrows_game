Source docs: phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md, phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 11 Signature System: Linked Boards (Twin Hoops)

## Status
Draft

## Type
New Feature

## Goal
Specify the dual-board coordinate architecture, cross-hoop thread traversal kinetics, seam edge transitions, camera auto-framing, and step tick integration for Yarn Unravel Phase 11 (Levels 5001–5500).

## Current State
Design documented in `phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md` and `phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md`, not yet implemented.
- Previous phases executed gameplay on a single monolithic rectangular or multi-floor canvas.
- Phase 11 introduces Linked Boards (Twin Hoops), displaying two concurrent circular mini boards (Hoop A and Hoop B) that interact via stitched seam boundaries, cross-board keys, and relay portals.

## Proposed Change
Implement the Linked Boards system within `packages/puzzle_core`:

### 1. Dual-Board Architecture & Data Model
- **Board Identifiers:** Boards are addressed as `HoopId.hoopA` and `HoopId.hoopB`.
- **Sub-Grid Dimensions:** Each mini hoop spans $8 \times 8$ to $10 \times 10$ cells, totaling 128 to 200 cells across both boards (equivalent footprint to a single $12 \times 12$–$14 \times 14$ board).
- **Coordinate Space:** Coordinates are qualified by hoop ID: `(hoopId, x, y)`.
- **Global Concurrency:** Both hoops are fully interactive simultaneously; players can tap active needles on either Hoop A or Hoop B at any turn without switching costs.

### 2. Cross-Hoop Traversal & Seam Kinetics
1. **Seam Edge Traversal (M501):**
   - When a thread's needle unravels toward an active Seam Edge on Hoop A:
     - Instead of exiting the level, the needle projects seamlessly into the corresponding entry cell on Hoop B.
     - Heading vector (`dir`) is preserved.
     - If the entry cell or subsequent corridor on Hoop B contains a blocker, obstacle, or thread body, the thread snags on the seam (-1 Heart) and snaps back to its origin.
2. **Synchronized Mirror Threads (M503):**
   - Paired threads linked between Hoop A and Hoop B unravel concurrently when either thread is tapped.
   - If either thread encounters a collision, both recoil; only 1 Heart is deducted.

### 3. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Selected thread unravels; seam transitions and mirror pairs evaluate cross-hoop movements.
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):** Periodic counters decrement.
- **Step 4 (Derived States / Cross-Hoop Pass):**
  1. Cross Charm keys (M502) cleared on Hoop A unlock clasps on Hoop B.
  2. Relay Pompoms (M504) evaluate jump connections.
- **Step 5 (Win / Loss Evaluation):** Level win triggers only when **both Hoop A and Hoop B** are completely cleared of threads.

### 4. Solver Integration (IDA*)
- In the IDA* puzzle solver:
  - State representation encodes combined bitboards for Hoop A and Hoop B.
  - Cross-board dependency graphs are verified as Directed Acyclic Graphs (DAGs) to prevent cyclic cross-hoop deadlocks.
  - Zero-heart solvability verified across all seeds.

## Affected Files
- `packages/puzzle_core/lib/src/models/dual_board_state.dart` (to be created: twin hoop state model)
- `packages/puzzle_core/lib/src/engine/seam_resolver.dart` (to be created: cross-hoop kinetics)
- `packages/puzzle_core/lib/src/engine/puzzle_engine.dart` (changed: integrate twin hoop dispatch)
- `tools/levelgen/lib/src/solver/ida_star_solver.dart` (changed: multi-board DAG validator)

## Risks
- Camera viewport clipping on narrow aspect ratios. Mitigated by dynamic bounding-box auto-framing with smooth pinch-zoom and pan support.

## Open Questions
None. Dual-board architecture and tick order integration match Phase 11 documentation.

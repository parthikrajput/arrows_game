Source docs: phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md, phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-10-signature-system.md, specs/tech/on-device-level-generation.md.

# Spec: Gameplay — Phase 11 Signature System (Twin Tables Linked Boards)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 11 signature system "Twin Tables" (Linked Boards `S11`): two interconnected tabletop railway boards (Table A and Table B) linked via connecting wooden bridges, cross-board ticket locks, synchronized mirror trains, and inter-table relay tunnels for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md`, `phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases operated within a single contiguous 2D or multi-deck board.
- Phase 11 introduces dual distinct sub-boards sharing coordinated move triggers and cross-table transit.

## Proposed Change
Extend `packages/puzzle_core` with a dual-board session and transit topology:

### 1. Dual Board Topology & Tick Order
- **State Representation:**
  - Board state models two discrete grid planes: `boards: {"A": BoardGrid, "B": BoardGrid}`.
  - Cell references use qualified coordinate format: `(boardId, col, row)`.
- **Cross-Table Transit (Move Step 1):**
  - Moving across a Table Bridge (M501) transfers train position from Table A edge to Table B entrance cell within the same continuous move.
  - If the entrance cell on Table B is occupied, the transit halts at the bridge boundary, triggering a collision bump (-1 heart).
- **Cross-Table Triggers (Move Step 2):**
  - Inter-table Ticket (M502) collected on Table A immediately broadcasts an unlock event to the designated barrier gate on Table B.
- **Synchronous Mirror Dynamics (Move Step 1):**
  - Mirror Train (M503) links two trains across Table A and Table B. Tapping either train dispatches both simultaneously in mirrored trajectories (horizontal or vertical reflection). Both paths must be completely unobstructed; obstruction of either train aborts the move and causes a bump (-1 heart).

### 2. Solver Graph Expansion
- Puzzle graph expands cross-board edges connecting Table A boundary nodes to Table B entry nodes.
- Synchronized actions evaluated atomically in solver branch state: `(stateA, stateB)`.

## Affected Files
- `packages/puzzle_core/lib/src/models/twin_board_state.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/cross_board_router.dart` (to be created)

## Risks
- Double board state increases solver search space. Mitigation: Sub-boards capped at 8x8 to 9x9, keeping branching factor manageable.

## Open Questions
- None. Twin table rules match `phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md` and `SHARED_CORE_STANDARD.md` §11.

Source docs: phases/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md, phases/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-10-signature-system.md.

# Spec: Gameplay — Phase 11 Signature System (Two Ponds: Linked Boards)

## Status
Draft

## Type
New Feature

## Goal
Implement the Two Ponds (Linked Boards) signature system for Phase 11 (Levels 5001–5500), partitioning the playfield into dual mini-boards (Board 1 and Board 2) connected via continuous vine bridge transitions, cross-board messenger locks, mirrored twin synchronizations, and inter-board portals.

## Current State
Design documented in `phases/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md`, `phases/phase_11/01_PHASE_11_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Previous phases executed on single unified grids up to $14 \times 14$.
- Phase 11 splits the viewport into two stacked mini-grids ($7 \times 7$ to $8 \times 8$ each), requiring inter-board state coordination, dual-viewport rendering, and continuous cross-grid entity transfer.

## Proposed Change
Implement the dual-board system architecture within `packages/puzzle_core/lib/src/systems/phase_11/`:

### 1. Dual-Board Architecture
```
+--------------------+
|      BOARD 1       |
|  [Snake A] ------> | ---> [M501 VINE BRIDGE]
+--------------------+             |
                                   V
+--------------------+ <-----------+
|      BOARD 2       | (Snake enters and continues lane)
|                    |
+--------------------+
```
1. **DualBoardState Data Model:**
   ```dart
   class DualBoardState {
     final GridState board1;
     final GridState board2;
     final List<BoardLinkBridge> bridges;
     final List<CrossBoardLock> crossLocks;
     final List<MirrorPair> mirrorPairs;
   }
   ```
2. **Continuous Inter-Grid Transfer:**
   - When a snake slithers across an M501 Vine Bridge from Board 1, its head enters the corresponding entry tile on Board 2 while its body segments smoothly trail across the inter-board chasm.
   - The snake is simultaneously resident across both boards until its tail completely vacates Board 1.
3. **Cross-Board Dependencies:**
   - Actions on Board 1 (e.g., freeing an M502 Messenger Snake) trigger state changes on Board 2 (retracting a stone lock).
4. **Mirror Twin Concurrency (M503):**
   - Paired snakes on Board 1 and Board 2 move in tandem upon tapping either partner.
   - Synchronized Safety: If either snake is obstructed, both snakes halt at origin with 0 hearts lost.

---

### 2. Engine Tick Integration (§16.17)
Each move tick resolves according to the unified dual-board sequence:
```
Step 1: Player Tap Input -> Active Snake Selection (identifying owner: Board 1 or Board 2)
Step 2: Partner Evaluation -> If Mirror Snake (M503), identify paired partner on sibling board
Step 3: Path Clearance Verification -> Validate forward trajectories on BOTH boards simultaneously
Step 4: Movement Execution:
        - If crossing M501 Bridge -> Transfer segments across inter-grid boundary
        - If entering M504 Portal -> Teleport coordinates from source board to destination board
Step 5: Board Exit Detection:
        - If Messenger Snake (M502) exits -> Dispatch unlock message to linked lock on opposite board
Step 6: Board Settled -> Settle both GridStates, verify victory criteria across both boards.
```

---

### 3. Interaction Matrix with Earlier Systems
- **M451 (Drum Gates):** Rhythm state cycles synchronously across both boards on every move.
- **M402 (Twin Splitter):** Splitter on Board 1 can project one branch within Board 1 and the other branch across a Vine Bridge directly into Board 2.
- **M351 (Wild Vines):** Vines can independently spread within Board 1 or Board 2, but cannot cross vine bridges unless a bridge tile becomes overgrown.
- **M091 (Ice Lanes):** Frictionless ice channels can bridge across boards for uninterrupted continuous glides.

---

### 4. Zero Damage & Buffer Space Guarantees
- **Clearance Prior to Transit:** A snake will not depart Board 1 onto an M501 Bridge unless Board 2's entry tile and minimum run-out corridor are clear.
- **Non-blocking Reversible Undo:** Reversing a cross-board transit rewinds segments back onto Board 1 with complete state fidelity.

## Affected Files
- `packages/puzzle_core/lib/src/systems/phase_11/dual_board_state.dart` (to be created)
- `packages/puzzle_core/lib/src/systems/phase_11/inter_board_transit_controller.dart` (to be created)
- `packages/puzzle_core/lib/src/systems/phase_11/mirror_pair_coordinator.dart` (to be created)
- `test/systems/phase_11_dual_board_test.dart` (to be created)

## Risks and Open Questions
- **Vertical Screen Space on Portrait Phones:** Rendering two stacked $8 \times 8$ boards simultaneously on narrow portrait devices requires optimized tile scaling and minimal vertical separation padding ($16\text{ dp}$ gap) to prevent out-of-screen overflow. Addressed in `phase-11-ui-additions.md`.

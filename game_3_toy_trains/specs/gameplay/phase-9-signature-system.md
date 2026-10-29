Source docs: phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md, phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-8-signature-system.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 9 Signature System (Couple & Uncouple Split & Merge)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 9 signature system "Couple & Uncouple" (Split & Merge `S09`): dynamic train composition operations where locomotives couple together into extended multi-car trains or split apart into parallel single-width engines to navigate constrained railway junction layouts for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md`, `phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases operated with fixed-length immutable train bodies (length 2–5).
- Phase 9 introduces runtime restructuring of train entities (merging 2 trains into 1, or splitting 1 train into 2).

## Proposed Change
Extend `packages/puzzle_core` with dynamic train composition mechanics:

### 1. Coupling & Splitting Lifecycle
- **Coupling Merger (M401 Coupling Pad):**
  - When two independent trains have their locomotive heads resting on adjacent coupling pads:
  - Tapping the pad (1 Move) merges them into a single articulated train (Lead Engine + Trailing Wagons).
  - The unified train moves as one entity upon subsequent departure.
  - Tapping the pad when both pads are not correctly occupied triggers locked tap feedback (0 moves, 0 hearts).
- **Twin Splitting (M402 Twin Split Train):**
  - A double-width or articulated train splits into two independent parallel single trains upon being tapped (1 Move).
  - Requires parallel adjacent track cells to be clear; if obstructed, splitting is blocked and a buffer clack bump animation plays (-1 heart).
- **Segment Lock (M403):**
  - Restricts coupling/uncoupling operations until a designated key locomotive departs from the board.

### 2. Solver Heuristics & Determinism
- Stateful solver dynamically handles variable entity counts within state keys: `(activeTrains, trainCompositions, segmentLockStates)`.
- Reverse construction guarantees that all required splitting paths have sufficient spatial track clearance before the split move is executed.

## Affected Files
- `packages/puzzle_core/lib/src/engine/train_composition_manager.dart` (to be created)
- `packages/puzzle_core/lib/src/models/train_entity.dart` (changed: add dynamic split/merge methods)

## Risks
- Collision edge cases if a newly split train immediately occupies cells belonging to another moving entity. Mitigated by immediate spatial reservation during the split transaction.

## Open Questions
- None. Dynamic train composition rules and tick orders match `phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md` and `SHARED_CORE_STANDARD.md` §11.

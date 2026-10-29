Source docs: phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md, phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-14-signature-system.md, specs/tech/on-device-level-generation.md.

# Spec: Gameplay — Phase 15 Signature System (Moving Platforms Conveyors)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 15 signature system "Moving Platforms" (Conveyor Tracks `S15`): motorized conveyor track belts, junction routing switches, directional reversing levers, brake stop levers, and continuous looping shunting rings for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md`, `phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases operated passive static track networks.
- Phase 15 introduces dynamic conveyor belts that transport stationary carriages autonomously during Step 3 of each move tick.

## Proposed Change
Extend `packages/puzzle_core` with conveyor motion resolution and automated yard shunting:

### 1. Conveyor Belt Lifecycle & Rules
- **Conveyor Shift (Move Step 3 Tick):**
  - Any locomotive or carriage resting on a conveyor tile automatically shifts 1 cell along the belt's flow vector at turn completion.
  - If the destination cell is blocked by a wall, obstacle, or stationary train, the belt slips under the train; the train remains stationary without bump penalty or heart loss.
- **Belt Switch (M701):**
  - Divergent conveyor junction. Tapping toggles conveyor flow direction between Left and Right branches.
- **Reversing Belt (M702):**
  - Directional lever linked to conveyor belt lines. Tapping reverses belt translation vector by 180° (`Forward <-> Backward`).
- **Belt Stop Lever (M703):**
  - Pneumatic brake lever. Toggling pauses or resumes motorized belt operation.
- **Loop Belt (M704):**
  - Closed 4–8 cell continuous track loop. Trains circulate clockwise until tapped to exit onto tangential sidings.

### 2. Solver Graph Representation
- Solver models conveyor step transitions as deterministic end-of-turn positional translations.
- Lookahead evaluates multi-train belt queueing without infinite loops.

## Affected Files
- `packages/puzzle_core/lib/src/engine/conveyor_manager.dart` (to be created)
- `packages/puzzle_core/lib/src/models/conveyor_belt.dart` (to be created)

## Risks
- Unexpected train pile-ups on conveyor choke points. Mitigation: Solver validates non-deadlocking exit routes for all conveyor branches.

## Open Questions
- None. Rules match `phase/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md` and `SHARED_CORE_STANDARD.md` §11.

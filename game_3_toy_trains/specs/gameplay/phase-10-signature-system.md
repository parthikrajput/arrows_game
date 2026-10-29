Source docs: phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md, phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-9-signature-system.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 10 Signature System (Timetable Master Sequencing)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 10 signature system "Timetable Master" (Sequencing `S10`): clockwork station master dispatch control where train departures are governed by rhythmic metronome gates, chronological platform arrival sequences, chromatic departure codes, and echo memory signals for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md`, `phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases permitted trains to depart in any spatial order provided exit lanes were clear.
- Phase 10 introduces temporal sequencing rules where departure validity depends on chronological order and move cadence.

## Proposed Change
Extend `packages/puzzle_core` with a sequence and timetable evaluation pipeline:

### 1. Sequencing Lifecycle & Rules
- **Metronome Rhythm Gates (M451):**
  - Follows a cyclic boolean rhythm array (e.g. `["open", "open", "closed"]`).
  - Advances 1 step on every valid Move completed across the board (Step 3 tick).
  - Exiting through a closed metronome gate causes a buffer clack bump (-1 heart).
- **Departure Code Locks (M452):**
  - Requires trains of specific enamel colors to depart in exact sequence (e.g. `Red -> Blue -> Green`).
  - Dispatches matching the sequence advance the lock code; dispatches violating the sequence reset the sequence to 0 without penalty.
  - Completing the sequence opens the gate barrier permanently.
- **Platform Order Exits (M453):**
  - Platform edge exits stamped with order numbers (1, 2, 3...).
  - Trains must depart in strictly ascending numeric order; out-of-order attempts collide with closed barriers (-1 heart).
- **Echo Memory Signals (M454):**
  - Tracks the color history of the last $N$ cleared trains, requiring subsequent departures to replicate the identical color cadence.

### 2. Solver Heuristics & Determinism
- Stateful solver models departure order within state key: `(remainingTrains, metronomePointer, sequenceProgress, echoQueue)`.
- Solver prunes sequences that violate chronological platform order.

## Affected Files
- `packages/puzzle_core/lib/src/engine/timetable_sequencer.dart` (to be created)
- `packages/puzzle_core/lib/src/models/dispatch_sequence.dart` (to be created)

## Risks
- Frustration if sequence resets without clear player feedback. Mitigated by prominent HUD indicator displaying the active expected departure sequence.

## Open Questions
- None. Sequencing rules match `phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md` and `SHARED_CORE_STANDARD.md` §11.

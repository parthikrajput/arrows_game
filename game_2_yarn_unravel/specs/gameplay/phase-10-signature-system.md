Source docs: phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md, phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 10 Signature System: Sequencing (Pattern Book)

## Status
Draft

## Type
New Feature

## Goal
Specify the move-synchronized rhythmic gate sequencing, chronological exit ordering, color pattern clasp verification, and step tick integration for Yarn Unravel Phase 10 (Levels 4501–5000).

## Current State
Design documented in `phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md` and `phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md`, not yet implemented.
- Previous phases permitted thread unravelling in any topologically legal sequence.
- Phase 10 introduces Sequencing (Pattern Book), enforcing chromatic exit cadences, move-indexed metronome gates, and strict order requirements for designated board boundaries.

## Proposed Change
Implement the Sequencing system within `packages/puzzle_core`:

### 1. Sequencing Rules & Data Model
- **Metronome Gate State Engine (M451):**
  - Parameterized by pattern array `pattern: List<GateState>` (e.g. `[Open, Closed, Closed]`) and an initial `offset`.
  - At any valid move $m$, current state is derived deterministically:
    $$\text{state}(m) = \text{pattern}[(m + \text{offset}) \pmod{\text{pattern.length}}]$$
  - When in `Closed` state, the gate acts as an impassable blocker; when in `Open` state, threads pass through freely.
- **Pattern Clasp Chronology (M452):**
  - Requires threads to exit in a predefined sequence of colors:
    $$C_1 \to C_2 \to \dots \to C_k$$
  - Exiting a thread with a non-matching color when the clasp is pending a specific color does not break the level, but halts progression toward unlocking the clasp.
- **Ordered Hem Constraints (M453):**
  - Exit hem cells permit passage only if the unravelling thread bears the matching expected sequence rank ($1 \to 2 \to 3$). Out-of-order attempts trigger a snag (-1 Heart).

### 2. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Selected thread unravels; verifies Ordered Hem rank if traversing border.
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):**
  - Metronome Gate (M451) advances to next rhythm state.
  - Echo Card (M454) updates exit history buffer.
- **Step 4 (Derived States / Sequencing Pass):**
  - Pattern Clasps (M452) evaluate matching color submissions; if sequence completes, clasp snaps open permanently.
- **Step 5 (Win / Loss Evaluation):** Check remaining threads and board clearance.

### 3. Solver Integration (IDA*)
- In the IDA* puzzle solver:
  - Sequence requirements strictly constrain search branch pruning.
  - Solvability graph verifies that the rhythm sequence and exit orders never form a deadlock where required color threads are blocked behind gates that require those same threads to open.
  - 100% solvable with 0 hearts and 0 boosters.

## Affected Files
- `packages/puzzle_core/lib/src/models/sequence_tracker.dart` (to be created: sequence tracker model)
- `packages/puzzle_core/lib/src/engine/rhythm_engine.dart` (to be created: metronome rhythm engine)
- `packages/puzzle_core/lib/src/engine/puzzle_engine.dart` (changed: integrate sequence verification into Step 4)
- `tools/levelgen/lib/src/solver/ida_star_solver.dart` (changed: prune invalid sequence branches)

## Risks
- Players feeling punished by rhythmic timing if move consequences are unclear. Mitigated by explicit visual metronome indicators and color sequence trackers.

## Open Questions
None. Sequencing rules and tick integration match Phase 10 documentation.

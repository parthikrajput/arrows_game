Source docs: phase/phase_10/06_UI_AND_QA_PHASE_10.md, phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-9-qa-and-rollout.md, specs/gameplay/phase-10-level-plan-04501-05000.md.

# Spec: Tech — Phase 10 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI timetable sequencing solver pipeline, binary metadata serialization (`phase_10_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 10 (Levels 4501–5000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_10/06_UI_AND_QA_PHASE_10.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases verified train splitting, botanical growth, optical beams, and multi-floor tracks.
- Phase 10 requires CI verification of rhythmic metronome transitions, chromatic departure sequences, and ordered platform constraints.

## Proposed Change
Implement the Phase 10 build pipeline and QA verification harness:

### 1. CI Timetable Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 4501$ to $5000$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - Rhythm gates must not create deadlock cycles under optimal play.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_10_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `sequencer_flags`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per sequencing level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per sequencing level.
- **Memory Footprint:** Sequencing queue and timetable lookahead allocated statically; zero dynamic allocation during gameplay tick.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 10`, level map locks Level 4501 with "Phase 10 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 10)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **P10-QA-01** | CI Solvability | All 500 Phase 10 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **P10-QA-02** | Metronome Gate Cycle | Gate opens/closes in strict cadence with moves; closed gate blocks train with bump (-1 heart). | Not run |
| **P10-QA-03** | Departure Code Sequence | Gate opens permanently when trains depart in target color order; incorrect color resets code to 0. | Not run |
| **P10-QA-04** | Platform Order Enforce | Numbered platform exits enforce ascending numeric order; premature departures trigger bump. | Not run |
| **P10-QA-05** | Echo Signal Matching | Echo signal accepts matching color cadence; pattern violation turns signal red and blocks path. | Not run |
| **P10-QA-06** | Multi-Modifier Stacking | Frozen or colored trains interact predictably with metronome gates and platform sequences. | Not run |
| **P10-QA-07** | Clockwork 60 fps | Pendulum swing and ribbon UI maintain 60 fps on low-tier mobile devices. | Not run |
| **P10-QA-08** | L5000 Finale | Master Timetable Clock Tower incorporates metronomes and multi-code gates; awards Grand Central Chest and Badge. | Not run |
| **P10-QA-09** | Hammer Interaction | Track Crane destroys a train without corrupting active timetable departure sequence index. | Not run |
| **P10-QA-10** | Rollout Gating | Setting `maxPhase = 9` locks Level 4501 cleanly with modal dialog. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_10.dart` (to be created)
- `packages/puzzle_core/test/engine/timetable_sequencer_test.dart` (to be created)

## Risks
- Metronome state desync between presentation pendulum and core game logic. Mitigation: Both bind directly to `GameSession.moveCount % rhythmLength`.

## Open Questions
- None. QA checklist and rollout parameters match `phase/phase_10/06_UI_AND_QA_PHASE_10.md` and `SHARED_CORE_STANDARD.md`.

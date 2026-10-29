Source docs: phase/phase_14/06_UI_AND_QA_PHASE_14.md, phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-13-qa-and-rollout.md, specs/gameplay/phase-14-level-plan-06501-07000.md.

# Spec: Tech — Phase 14 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI bilateral symmetry solver validation pipeline, binary metadata serialization (`phase_14_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 14 (Levels 6501–7000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_14/06_UI_AND_QA_PHASE_14.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases verified fog visibility bitmasks and directional incline physics.
- Phase 14 requires CI verification of bilateral mirror topologies, paired barrier triggers, and reverse locomotion trajectories.

## Proposed Change
Implement the Phase 14 build pipeline and QA verification harness:

### 1. CI Symmetry Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 6501$ to $7000$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - Symmetrical mirror twins must never deadlock against each other across the axis.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_14_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `symmetry_axis_pos`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per alpine level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per alpine level.
- **Symmetry Optimization:** Reverse construction generator generates half-board graph and reflects it across midline; generation time reduced by ~40%.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 14`, level map locks Level 6501 with "Phase 14 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 14)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **P14-QA-01** | CI Solvability | All 500 Phase 14 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **P14-QA-02** | Mirror Twin Dispatch | Tapping left-half engine moves both twins symmetrically; collision on either aborts move. | Not run |
| **P14-QA-03** | Reflection Lock Drop | Paired glacier gates drop simultaneously when both reflection keys arrive at pads. | Not run |
| **P14-QA-04** | Alpine Twin Switch | Flipping a switch on one side automatically flips its reflection counterpart. | Not run |
| **P14-QA-05** | Reverse Engine Travel | Reverse locomotive travels backward along track alignment, counter to arrow heading. | Not run |
| **P14-QA-06** | Symmetry Collision | Unaligned mirror paths cause atomic bump animation and deduct 1 heart cleanly. | Not run |
| **P14-QA-07** | 60 fps Performance | Symmetrical particle rendering and glacier shader maintain 60 fps on low-tier mobile devices. | Not run |
| **P14-QA-08** | L7000 Finale | Great Alpine Pass Mountain Junction combines all symmetry mechanics; awards Grand Central Chest and Badge. | Not run |
| **P14-QA-09** | Hammer Interaction | Track Crane removes one twin locomotive, reverting partner to an independent normal train. | Not run |
| **P14-QA-10** | Rollout Gating | Setting `maxPhase = 13` locks Level 6501 cleanly with modal dialog. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_14.dart` (to be created)
- `packages/puzzle_core/test/engine/mirror_axis_evaluator_test.dart` (to be created)

## Risks
- Floating point inaccuracies during reflection coordinate calculation. Mitigation: Discrete grid coordinate integers used exclusively ($X' = 2 \times X_{\text{mid}} - X$).

## Open Questions
- None. QA checklist and rollout parameters match `phase/phase_14/06_UI_AND_QA_PHASE_14.md` and `SHARED_CORE_STANDARD.md`.

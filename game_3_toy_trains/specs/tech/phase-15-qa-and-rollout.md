Source docs: phase/phase_15/06_UI_AND_QA_PHASE_15.md, phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-14-qa-and-rollout.md, specs/gameplay/phase-15-level-plan-07001-07500.md.

# Spec: Tech — Phase 15 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI conveyor simulation solver validation pipeline, binary metadata serialization (`phase_15_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 15 (Levels 7001–7500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_15/06_UI_AND_QA_PHASE_15.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases verified bilateral mirror symmetry and vision masks.
- Phase 15 requires CI verification of conveyor belt queueing, flow switches, brake levers, and cyclic loops.

## Proposed Change
Implement the Phase 15 build pipeline and QA verification harness:

### 1. CI Conveyor Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 7001$ to $7500$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - Conveyor shifts must never trap all trains in an un-exit-able circulating state.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_15_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `conveyor_belt_count`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per conveyor level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per conveyor level.
- **Conveyor Memory Pools:** Static belt array pre-allocated per level; zero allocation during Step 3 translation tick.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 15`, level map locks Level 7001 with "Phase 15 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 15)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **P15-QA-01** | CI Solvability | All 500 Phase 15 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **P15-QA-02** | Conveyor Move Step 3 | Train on conveyor tile advances 1 cell automatically along flow vector at turn end. | Not run |
| **P15-QA-03** | Obstruction Slip | Train halted by forward obstacle slips on belt cleanly with 0 damage and 0 hearts lost. | Not run |
| **P15-QA-04** | Belt Switch Toggle | Tapping M701 alters conveyor branch routing; subsequent trains follow new route. | Not run |
| **P15-QA-05** | Reversing Lever | Tapping M702 inverts belt flow 180°; trains immediately shift backward on next tick. | Not run |
| **P15-QA-06** | Brake Lever Hold | Tapping M703 pauses belt motion; trains remain stationary until brake released. | Not run |
| **P15-QA-07** | Loop Belt Circulation | Trains in M704 ring circulate clockwise indefinitely until player dispatches them. | Not run |
| **P15-QA-08** | 60 fps Performance | Conveyor tread UV animation maintains solid 60 fps on low-tier mobile devices. | Not run |
| **P15-QA-09** | L7500 Finale | Automated Transshipment Yard combines all conveyor systems; awards Grand Central Chest and Badge. | Not run |
| **P15-QA-10** | Rollout Gating | Setting `maxPhase = 14` locks Level 7001 cleanly with modal dialog. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_15.dart` (to be created)
- `packages/puzzle_core/test/engine/conveyor_manager_test.dart` (to be created)

## Risks
- Animation desync if train departure animation overlaps conveyor advance tick. Mitigation: Input and conveyor ticks serialized sequentially.

## Open Questions
- None. QA checklist and rollout parameters match `phase/phase_15/06_UI_AND_QA_PHASE_15.md` and `SHARED_CORE_STANDARD.md`.

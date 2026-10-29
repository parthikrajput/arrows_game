Source docs: phase/phase_9/06_UI_AND_QA_PHASE_9.md, phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-8-qa-and-rollout.md, specs/gameplay/phase-9-level-plan-04001-04500.md.

# Spec: Tech — Phase 9 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI dynamic train composition solver validation pipeline, binary metadata serialization (`phase_9_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 9 (Levels 4001–4500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_9/06_UI_AND_QA_PHASE_9.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases validated 2D cycles, vertical multi-floor grids, shunting carts, optical beams, 4x4 rotors, and botanical growth.
- Phase 9 requires CI verification of dynamic split and merge train entity lifecycle state mutations.

## Proposed Change
Implement the Phase 9 build pipeline and QA verification harness:

### 1. CI Train Composition Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 4001$ to $4500$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - No splitting collisions (split engines obstructed by obstacles or boundaries).
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_9_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `composition_count`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per composition level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per composition level.
- **Entity Allocation:** Runtime splitting creates pre-allocated pooled train instances; zero GC pauses.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 9`, level map locks Level 4001 with "Phase 9 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 9)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **QA-P9-01** | Coupling Merge | Tapping coupling pad with 2 heads present merges them into 1 long train (1 move, 0 hearts). | Not run |
| **QA-P9-02** | Invalid Merge | Tapping coupling pad when heads are misaligned triggers locked tap (0 moves, 0 hearts). | Not run |
| **QA-P9-03** | M402 Twin Split | Tapping split train divides it into 2 parallel trains (1 move); obstructed track triggers bump. | Not run |
| **QA-P9-04** | M403 Clamp Lock | Segment clamp remains locked until designated key train departs from board. | Not run |
| **QA-P9-05** | M404 Rejoin | Rejoin arch unlocks permanently after both split train halves pass through. | Not run |
| **QA-P9-06** | Solvability | All 500 Phase 9 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **QA-P9-07** | Hammerable Train| Track Crane removes un-split twin train cleanly as a single entity. | Not run |
| **QA-P9-08** | Generation Speed | Levels generate in < 250 ms on low-tier hardware. | Not run |
| **QA-P9-09** | L4500 Finale | Grand Junction Coupling Yard features multi-split puzzle; awards Grand Central Chest and Badge. | Not run |
| **QA-P9-10** | Rollout Gating | Setting `maxPhase = 8` locks Level 4001 cleanly with modal. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_9.dart` (to be created)
- `assets/levels/phase_9_meta.bin` (to be generated)

## Risks
- Entity reference leaks when split trains exit independently. Mitigation: Garbage collector safely unregisters sub-IDs from active entity table.

## Open Questions
- None. All parameters and test cases match `phase/phase_9/06_UI_AND_QA_PHASE_9.md` and `SHARED_CORE_STANDARD.md`.

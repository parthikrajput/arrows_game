Source docs: phase/phase_12/06_UI_AND_QA_PHASE_12.md, phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-11-qa-and-rollout.md, specs/gameplay/phase-12-level-plan-05501-06000.md.

# Spec: Tech — Phase 12 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI gravity physics solver validation pipeline, binary metadata serialization (`phase_12_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 12 (Levels 5501–6000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_12/06_UI_AND_QA_PHASE_12.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases verified static grid and twin-table graph topologies.
- Phase 12 requires CI verification of dynamic directional sliding simulation, suspension tiles, and rolling engine states.

## Proposed Change
Implement the Phase 12 build pipeline and QA verification harness:

### 1. CI Incline Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 5501$ to $6000$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - Crate slide movements must terminate deterministically without infinite bouncing cycles.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_12_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `initial_gravity_dir`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per incline level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per incline level.
- **Physics Simulation:** Discrete integer tile raycasting; zero floating-point physics overhead.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 12`, level map locks Level 5501 with "Phase 12 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 12)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **P12-QA-01** | CI Solvability | All 500 Phase 12 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **P12-QA-02** | Tilt Lever Rotation | Tapping M551 rotates gravity vector 90° clockwise; updates compass and shifts crates. | Not run |
| **P12-QA-03** | Loose Crate Motion | Crates slide along active gravity vector until colliding with wall, train, or blocker. | Not run |
| **P12-QA-04** | Balloon Pad Catch | Sliding crate landing on Balloon Pad arrests motion and stays suspended against gravity. | Not run |
| **P12-QA-05** | Ballast Train Roll | Ballast engine facing downhill rolls forward 1 cell autonomously per turn if track clear. | Not run |
| **P12-QA-06** | Crate Train Bump | Train attempting to drive into unyielding crate collides and loses 1 heart. | Not run |
| **P12-QA-07** | 60 fps Incline | Smooth sliding animations maintain 60 fps on low-tier hardware with 10+ crates sliding. | Not run |
| **P12-QA-08** | L6000 Finale | Hill Climb Mountain Terminal combines all incline mechanics; awards Grand Central Chest and Badge. | Not run |
| **P12-QA-09** | Hammer Interaction | Track Crane destroys a loose crate cleanly, freeing blocked track immediately. | Not run |
| **P12-QA-10** | Rollout Gating | Setting `maxPhase = 11` locks Level 5501 cleanly with modal dialog. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_12.dart` (to be created)
- `packages/puzzle_core/test/engine/gravity_simulator_test.dart` (to be created)

## Risks
- Desynchronization between visual crate sliding animation and core physics tick. Mitigation: Player input locked until all sliding crate animations settle (max 250 ms).

## Open Questions
- None. QA checklist and rollout parameters match `phase/phase_12/06_UI_AND_QA_PHASE_12.md` and `SHARED_CORE_STANDARD.md`.

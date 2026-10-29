Source docs: phase/phase_6/06_UI_AND_QA_PHASE_6.md, phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-5-qa-and-rollout.md, specs/gameplay/phase-6-level-plan-02501-03000.md.

# Spec: Tech — Phase 6 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI optical raycast validation pipeline, binary metadata serialization (`phase_6_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 6 (Levels 2501–3000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_6/06_UI_AND_QA_PHASE_6.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases validated 2D cycles, vertical multi-floor layouts, and shunting carts.
- Phase 6 requires CI verification of optical raycasting, chromatic filtering, and blackout activation states.

## Proposed Change
Implement the Phase 6 build pipeline and QA verification harness:

### 1. CI Optical Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 2501$ to $3000$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - No optical deadlocks (e.g. unlit blackout cells without an unblocked light beam path).
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_6_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `optical_flags`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per optical level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per optical level.
- **Ray-Trace Execution:** Line-of-sight ray intersections calculated in $\le 2\ \text{ms}$ per turn.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 6`, level map locks Level 2501 with "Phase 6 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and performance telemetry.

### 5. QA Acceptance Checklist (Phase 6)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **QA-P6-01** | Optical Raycast | Signal lamps cast continuous ray until occluded by train, obstacle, or wall. | Not run |
| **QA-P6-02** | M251 Lens | Beam entering colored lens transforms to filter color; only matching sensors trigger. | Not run |
| **QA-P6-03** | M252 Twin Gate | Dual-sensor gate unlocks if and only if both sensors receive active beam simultaneously. | Not run |
| **QA-P6-04** | M253 Timer | Lamp timer toggles on/off every N valid Moves; unlit state extinguishes beam. | Not run |
| **QA-P6-05** | M254 Blackout | Trains in dark cells locked; beam passing over cell illuminates track and activates train. | Not run |
| **QA-P6-06** | Solvability | All 500 Phase 6 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **QA-P6-07** | Raycast Perf | Optical raycast recomputation executes in <= 2 ms without UI frame drops. | Not run |
| **QA-P6-08** | Generation Speed | Levels generate in < 250 ms on low-tier hardware. | Not run |
| **QA-P6-09** | L3000 Finale | Signal Master Grand Junction features multi-beam puzzle; awards Grand Central Chest and Badge. | Not run |
| **QA-P6-10** | Rollout Gating | Setting `maxPhase = 5` locks Level 2501 cleanly with modal. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_6.dart` (to be created)
- `assets/levels/phase_6_meta.bin` (to be generated)

## Risks
- Recursive reflection loops with multiple opposing mirrors. Mitigation: Ray tracer limits reflections to max 16 bounces before terminating beam.

## Open Questions
- None. All parameters and test cases match `phase/phase_6/06_UI_AND_QA_PHASE_6.md` and `SHARED_CORE_STANDARD.md`.

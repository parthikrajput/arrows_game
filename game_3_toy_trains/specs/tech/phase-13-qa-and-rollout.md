Source docs: phase/phase_13/06_UI_AND_QA_PHASE_13.md, phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-12-qa-and-rollout.md, specs/gameplay/phase-13-level-plan-06001-06500.md.

# Spec: Tech — Phase 13 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI fog-of-war reconnaissance solver validation pipeline, binary metadata serialization (`phase_13_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 13 (Levels 6001–6500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_13/06_UI_AND_QA_PHASE_13.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases verified incline sliding and twin-table bipartite graphs.
- Phase 13 requires CI verification of hidden vision masks, scout reveal propagation, and pass-through illusions.

## Proposed Change
Implement the Phase 13 build pipeline and QA verification harness:

### 1. CI Fog Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 6001$ to $6500$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - Solver verifies that fog never causes blind trial-and-error traps under optimal play.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_13_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `initial_fog_mask`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per fog level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per fog level.
- **Fog Memory Representation:** Compact 64-bit word bitmask; zero dynamic memory allocations for vision evaluation.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 13`, level map locks Level 6001 with "Phase 13 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 13)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **P13-QA-01** | CI Solvability | All 500 Phase 13 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **P13-QA-02** | Scout Draisine Reveal | Dispatched scout draisine clears fog across 1-cell radius along its entire exit path. | Not run |
| **P13-QA-03** | Mirage Pass-through | Real trains traverse through Mirage Steam clouds without obstruction or heart loss. | Not run |
| **P13-QA-04** | Painted Wall Pass-through | Trains pass directly through Painted Backdrop false walls effortlessly. | Not run |
| **P13-QA-05** | Lantern Plate Glow | Parking train on Lantern Plate illuminates 2-cell radius; fog restores when vacated. | Not run |
| **P13-QA-06** | Route Peek Accuracy | Long-press accurately projects true path in green through mirages and false walls. | Not run |
| **P13-QA-07** | 60 fps Fog Rendering | Fog shader and particle dispersion maintain 60 fps on low-tier mobile devices. | Not run |
| **P13-QA-08** | L6500 Finale | Weather Station Observatory combines all fog mechanics; awards Grand Central Chest and Badge. | Not run |
| **P13-QA-09** | Hammer Interaction | Track Crane removes scout draisine cleanly without corrupting fog bitmask state. | Not run |
| **P13-QA-10** | Rollout Gating | Setting `maxPhase = 12` locks Level 6001 cleanly with modal dialog. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_13.dart` (to be created)
- `packages/puzzle_core/test/engine/fog_vision_manager_test.dart` (to be created)

## Risks
- Bitmask desynchronization between UI fog overlay and game logic. Mitigation: UI binds directly to observable stream of `BitGrid` updates from session engine.

## Open Questions
- None. QA checklist and rollout parameters match `phase/phase_13/06_UI_AND_QA_PHASE_13.md` and `SHARED_CORE_STANDARD.md`.

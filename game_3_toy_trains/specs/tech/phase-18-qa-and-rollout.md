Source docs: phase/phase_18/06_UI_AND_QA_PHASE_18.md, phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-17-qa-and-rollout.md, specs/gameplay/phase-18-level-plan-08501-09000.md.

# Spec: Tech — Phase 18 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI multi-system synergy solver validation pipeline, binary metadata serialization (`phase_18_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 18 (Levels 8501–9000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_18/06_UI_AND_QA_PHASE_18.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases verified isolated single-system mechanics.
- Phase 18 requires CI verification of inter-system cross-triggers, vertical cart physics, and optical prismatic routing.

## Proposed Change
Implement the Phase 18 build pipeline and QA verification harness:

### 1. CI Synergy Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 8501$ to $9000$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - Cross-system interactions must never create un-solvable cyclic deadlocks.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_18_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `synergy_flags`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per synergy level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per synergy level.
- **State Space Caching:** Multi-floor coordinate hashes and optical cache reuse prevent GC thrashing.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 18`, level map locks Level 8501 with "Phase 18 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 18)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **P18-QA-01** | CI Solvability | All 500 Phase 18 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **P18-QA-02** | Day/Night Cart Stamp | Pushing ticket cart through tunnel updates its cycle state and unlocks matching gate. | Not run |
| **P18-QA-03** | Station Lift Transfer | Station elevator carries mobile cargo carts between floors without losing cart physics state. | Not run |
| **P18-QA-04** | Prism Sensor Unlock | Steered optical beam through prism activates sensor gate and lowers drawbridge permanently. | Not run |
| **P18-QA-05** | Ice Chute Void Fill | Pushing sliding ice cart into chute lands cleanly into lower blackout pit, forming track. | Not run |
| **P18-QA-06** | Synergy Deadlock Free | Multi-system levels never deadlock when player solves mechanics in valid sequence. | Not run |
| **P18-QA-07** | 60 fps Performance | Prism shader and multi-floor transitions maintain 60 fps on low-tier mobile hardware. | Not run |
| **P18-QA-08** | L9000 Finale | Grand Terminus of the First Era combines P1–P6 systems; awards Grand Central Chest and Badge. | Not run |
| **P18-QA-09** | Hammer Interaction | Track Crane destroys a cart cleanly without corrupting multi-system trigger states. | Not run |
| **P18-QA-10** | Rollout Gating | Setting `maxPhase = 17` locks Level 8501 cleanly with modal dialog. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_18.dart` (to be created)
- `packages/puzzle_core/test/engine/remix_a_adapter_test.dart` (to be created)

## Risks
- Solver combinatorial blowup on multi-floor optical puzzles. Mitigation: Pruning eliminates raycast checks that cannot hit active sensor gates.

## Open Questions
- None. QA checklist and rollout parameters match `phase/phase_18/06_UI_AND_QA_PHASE_18.md` and `SHARED_CORE_STANDARD.md`.

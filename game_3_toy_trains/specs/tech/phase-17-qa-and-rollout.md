Source docs: phase/phase_17/06_UI_AND_QA_PHASE_17.md, phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-16-qa-and-rollout.md, specs/gameplay/phase-17-level-plan-08001-08500.md.

# Spec: Tech — Phase 17 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI guardian boss health and spawner solver validation pipeline, binary metadata serialization (`phase_17_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 17 (Levels 8001–8500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_17/06_UI_AND_QA_PHASE_17.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases verified key DAG dependencies and conveyor simulation.
- Phase 17 requires CI verification of multi-cell guardian HP pools, spawner interval convergence, and light beam core interactions.

## Proposed Change
Implement the Phase 17 build pipeline and QA verification harness:

### 1. CI Guardian Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 8001$ to $8500$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - Spawner towers must not induce grid exhaustion or deadlocks before player can reduce tower HP to 0.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_17_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `boss_initial_hp`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per boss level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per boss level.
- **Boss State Footprint:** Guardian entities pre-instantiated in memory pool; zero dynamic heap allocations during damage ticks.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 17`, level map locks Level 8001 with "Phase 17 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 17)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **P17-QA-01** | CI Solvability | All 500 Phase 17 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **P17-QA-02** | Twin Tower Shared HP | Damage dealt to either tower decrements shared HP pool; collapses both at HP 0. | Not run |
| **P17-QA-03** | Shield Sequence Damage | Armoured tower takes damage only when trains depart in matching sequence order. | Not run |
| **P17-QA-04** | Depot Spawner Logic | Spawns Buffer Stop on empty neighbor tile every N moves until HP reaches 0. | Not run |
| **P17-QA-05** | Clock Core Dissolve | Core persists at HP 0 until struck directly by a Signal Light Beam, then disappears. | Not run |
| **P17-QA-06** | Boss Grid Collision | Trains moving toward undefeated tower tiles trigger collision bump (-1 heart). | Not run |
| **P17-QA-07** | 60 fps Performance | 2x2 tower rendering, HP bars, and pendulums maintain 60 fps on low-tier mobile devices. | Not run |
| **P17-QA-08** | L8500 Finale | Citadel of the Grand Clock Tower combines all guardian mechanics; awards Grand Central Chest and Badge. | Not run |
| **P17-QA-09** | Hammer Interaction | Track Crane destroys a spawned buffer stop cleanly without crashing boss cooldown timer. | Not run |
| **P17-QA-10** | Rollout Gating | Setting `maxPhase = 16` locks Level 8001 cleanly with modal dialog. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_17.dart` (to be created)
- `packages/puzzle_core/test/engine/guardian_manager_test.dart` (to be created)

## Risks
- Desync between UI HP meter display and core guardian health state. Mitigation: UI binds directly to state stream from `GuardianManager`.

## Open Questions
- None. QA checklist and rollout parameters match `phase/phase_17/06_UI_AND_QA_PHASE_17.md` and `SHARED_CORE_STANDARD.md`.

Source docs: phase/phase_20/06_UI_AND_QA_PHASE_20.md, phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-19-qa-and-rollout.md, specs/gameplay/phase-20-level-plan-09501-10000.md.

# Spec: Tech — Phase 20 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI omni-system and Level 10,000 Marching Boss solver validation pipeline, binary metadata serialization (`phase_20_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 20 (Levels 9501–10000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_20/06_UI_AND_QA_PHASE_20.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases verified intermediate synergies and 500-level plateau blocks.
- Phase 20 requires complete 10,000-level CI solver validation, marching boss state machine verification, and lifetime economy reconciliation.

## Proposed Change
Implement the Phase 20 build pipeline and QA verification harness:

### 1. CI Omni-System & Climax Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 9501$ to $10000$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - Level 10,000 Climax Boss must provably be defeated within par moves before marching off the bottom of the board.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_20_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `boss_marching_cadence`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per omni-system level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per omni-system level.
- **Memory Footprint:** Level 10,000 grid and 56 train entities reuse pre-allocated object pools; zero runtime garbage collection pauses.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 20`, level map locks Level 9501 with "Phase 20 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 20)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **P20-QA-01** | CI Solvability | All 500 Phase 20 seeds (L9501–10000) provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **P20-QA-02** | Conveyor Guardian | Exiting train from conveyor ring deals 1 damage to 6 HP boss; collapses at HP 0. | Not run |
| **P20-QA-03** | Gravity Mirror Relay | Lever changes gravity in opposite directions on Table A (Down) and Table B (Up). | Not run |
| **P20-QA-04** | Night Master Pass | In Night Phase B, master pass unlocks all barriers along route without consumption. | Not run |
| **P20-QA-05** | Prism Bloom Arch | Arch unlocks when $\ge 4$ ivy tiles connect to foundation and beam strikes prism. | Not run |
| **P20-QA-06** | L10000 Marching Boss | 3x3 boss steps downward 1 cell every 5 moves, crushing track beneath footprint. | Not run |
| **P20-QA-07** | L10000 Climax Defeat | Dealing 12 damage to marching boss triggers grand collapse, awards Crown and 5,000 coins. | Not run |
| **P20-QA-08** | 60 fps Performance | 14x14 grid with 56 trains and marching boss maintains 60 fps on low-tier mobile hardware. | Not run |
| **P20-QA-09** | Lifetime Economy Audit | Total lifetime coin grants across all 10,000 levels balance strictly to ~868,000 coins. | Not run |
| **P20-QA-10** | Rollout Gating | Setting `maxPhase = 19` locks Level 9501 cleanly with modal dialog. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_20.dart` (to be created)
- `packages/puzzle_core/test/engine/omni_system_engine_test.dart` (to be created)
- `packages/puzzle_core/test/engine/marching_boss_test.dart` (to be created)

## Risks
- Level 10000 boss marching onto player trains causing unpreventable heart loss. Mitigation: Boss warns 1 turn in advance with flashing red danger grid overlay.

## Open Questions
- None. QA checklist and rollout parameters match `phase/phase_20/06_UI_AND_QA_PHASE_20.md` and `SHARED_CORE_STANDARD.md`.

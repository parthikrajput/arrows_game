Source docs: phase/phase_8/06_UI_AND_QA_PHASE_8.md, phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-7-qa-and-rollout.md, specs/gameplay/phase-8-level-plan-03501-04000.md.

# Spec: Tech — Phase 8 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI botanical growth solver validation pipeline, binary metadata serialization (`phase_8_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 8 (Levels 3501–4000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_8/06_UI_AND_QA_PHASE_8.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases validated 2D cycles, vertical multi-floor grids, shunting carts, optical rays, and 4x4 rotors.
- Phase 8 requires CI verification of cellular automata vine growth, pruning corridors, and floral bloom triggers.

## Proposed Change
Implement the Phase 8 build pipeline and QA verification harness:

### 1. CI Botanical Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 3501$ to $4000$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - No irreversible suffocating growth loops where all departure lanes are blocked before pruning is possible.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_8_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `growth_rate`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per botanical level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per botanical level.
- **Automata Execution:** Ivy growth expansion step executes in $\le 1.5\ \text{ms}$ per turn.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 8`, level map locks Level 3501 with "Phase 8 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 8)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **QA-P8-01** | Ivy Spread | Wild Ivy expands up to 2 empty adjacent cells every N moves in Up->Right->Down->Left order. | Not run |
| **QA-P8-02** | Ivy Collision | Train colliding with overgrown vine cell triggers buffer clack bump (-1 heart). | Not run |
| **QA-P8-03** | M352 Trimmer | Train departing through hedge trimmer slices and clears all adjacent vine cells immediately. | Not run |
| **QA-P8-04** | M353 Seed Wagon | Seed wagon leaves seed upon departing; seed sprouts into active vine after N moves. | Not run |
| **QA-P8-05** | M354 Flower Arch | Trellis arch blossoms and permanently opens when contacted by K ivy cells. | Not run |
| **QA-P8-06** | Solvability | All 500 Phase 8 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **QA-P8-07** | Hammerable Ivy | Track Crane lifts and clears 1 target wild ivy cell as expected. | Not run |
| **QA-P8-08** | Generation Speed | Levels generate in < 250 ms on low-tier hardware. | Not run |
| **QA-P8-09** | L4000 Finale | Botanical Terminal Garden features complex overgrown maze; awards Grand Central Chest and Badge. | Not run |
| **QA-P8-10** | Rollout Gating | Setting `maxPhase = 7` locks Level 3501 cleanly with modal. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_8.dart` (to be created)
- `assets/levels/phase_8_meta.bin` (to be generated)

## Risks
- Growth algorithm exponential branching during solver search. Mitigation: Bounding box search limits and bitmask state compaction.

## Open Questions
- None. All parameters and test cases match `phase/phase_8/06_UI_AND_QA_PHASE_8.md` and `SHARED_CORE_STANDARD.md`.

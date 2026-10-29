Source docs: phase/phase_16/06_UI_AND_QA_PHASE_16.md, phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-15-qa-and-rollout.md, specs/gameplay/phase-16-level-plan-07501-08000.md.

# Spec: Tech — Phase 16 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI key dependency graph solver validation pipeline, binary metadata serialization (`phase_16_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 16 (Levels 7501–8000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_16/06_UI_AND_QA_PHASE_16.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases verified conveyor transport and bilateral mirror symmetry.
- Phase 16 requires CI verification of topological key acyclicity, stub crafting invariants, and skeleton key consumption.

## Proposed Change
Implement the Phase 16 build pipeline and QA verification harness:

### 1. CI Key DAG Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 7501$ to $8000$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - Key dependencies must form a strict Directed Acyclic Graph (DAG) with no unresolvable circular locks.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_16_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `key_chain_depth`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per key-network level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per key-network level.
- **Topological Solver Performance:** Cycle detection and DAG resolution execute in $< 15\text{ ms}$ on low-tier CPUs.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 16`, level map locks Level 7501 with "Phase 16 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 16)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **P16-QA-01** | CI Solvability | All 500 Phase 16 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **P16-QA-02** | Ticket Chain Release | Unlocking Barrier A frees nested Ticket Car B; Barrier B unlocks only after Car B arrives. | Not run |
| **P16-QA-03** | Ticket Punch Crafting | Delivering Left and Right stubs into punch station crafts 1 Golden Ticket and unlocks gate. | Not run |
| **P16-QA-04** | Master Pass Universal | Master Pass engine unlocks any single colored barrier along route; pass consumed upon use. | Not run |
| **P16-QA-05** | Ticket Swap Pad | Parking two key trains on swap pads exchanges their held key tokens cleanly (1 move). | Not run |
| **P16-QA-06** | Invalid Gate Collision | Train attempting to cross closed barrier without matching key triggers bump (-1 heart). | Not run |
| **P16-QA-07** | 60 fps Performance | Key chain tracer rendering and punch confetti maintain 60 fps on low-tier mobile devices. | Not run |
| **P16-QA-08** | L8000 Finale | Master Ticket Bureau Terminal combines all ticket mechanics; awards Grand Central Chest and Badge. | Not run |
| **P16-QA-09** | Hammer Interaction | Track Crane removes master pass train cleanly; remaining trains retain valid win path. | Not run |
| **P16-QA-10** | Rollout Gating | Setting `maxPhase = 15` locks Level 7501 cleanly with modal dialog. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_16.dart` (to be created)
- `packages/puzzle_core/test/engine/ticket_office_manager_test.dart` (to be created)

## Risks
- False positive unsolvability due to multiple branch possibilities with Master Pass. Mitigation: IDA* solver branches on Master Pass target choice exhaustively.

## Open Questions
- None. QA checklist and rollout parameters match `phase/phase_16/06_UI_AND_QA_PHASE_16.md` and `SHARED_CORE_STANDARD.md`.

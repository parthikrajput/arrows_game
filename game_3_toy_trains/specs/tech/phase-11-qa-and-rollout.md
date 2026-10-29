Source docs: phase/phase_11/06_UI_AND_QA_PHASE_11.md, phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-10-qa-and-rollout.md, specs/gameplay/phase-11-level-plan-05001-05500.md.

# Spec: Tech — Phase 11 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI dual-board graph solver validation pipeline, binary metadata serialization (`phase_11_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 11 (Levels 5001–5500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_11/06_UI_AND_QA_PHASE_11.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases verified single-grid and multi-deck timetable graphs.
- Phase 11 requires CI verification of bipartite table graphs, cross-board triggers, and atomic mirror moves.

## Proposed Change
Implement the Phase 11 build pipeline and QA verification harness:

### 1. CI Dual-Board Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 5001$ to $5500$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - Bridge transit must never create un-routable deadlocks between sub-boards.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_11_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `twin_board_layout_flags`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per twin-board level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per twin-board level.
- **Memory Footprint:** Dual sub-board memory pools reused across levels; zero GC allocations during level generation.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 11`, level map locks Level 5001 with "Phase 11 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 11)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **P11-QA-01** | CI Solvability | All 500 Phase 11 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **P11-QA-02** | Table Bridge Entry/Exit | Train exiting Table A bridge edge enters Table B connected cell; bump if blocked (-1 heart). | Not run |
| **P11-QA-03** | Inter-table Ticket Unlock | Traversing ticket on Table A unlocks corresponding barrier gate on Table B permanently. | Not run |
| **P11-QA-04** | Mirror Train Simultanous Move | Tapping twin train moves both in mirrored trajectories; bump if either path is blocked. | Not run |
| **P11-QA-05** | Relay Tunnel Transfer | Train entering mouth on Table A instantly exits corresponding mouth on Table B. | Not run |
| **P11-QA-06** | Dual Viewport Rendering | Dual sub-boards render smoothly without visual clipping or texture flicker in landscape/portrait. | Not run |
| **P11-QA-07** | 60 fps Performance | Game loop maintains 60 fps on low-tier mobile devices with 35+ trains active across both boards. | Not run |
| **P11-QA-08** | L5500 Finale | Twin Grand Central Terminals combines all twin-table mechanics; awards Grand Central Chest and Badge. | Not run |
| **P11-QA-09** | Hammer Interaction | Track Crane removes one twin locomotive, reverting partner to an independent train. | Not run |
| **P11-QA-10** | Rollout Gating | Setting `maxPhase = 10` locks Level 5001 cleanly with modal dialog. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_11.dart` (to be created)
- `packages/puzzle_core/test/engine/twin_board_router_test.dart` (to be created)

## Risks
- Asynchronous animation desync between sub-boards. Mitigation: Single animation controller drives both board canvases simultaneously.

## Open Questions
- None. QA checklist and rollout parameters match `phase/phase_11/06_UI_AND_QA_PHASE_11.md` and `SHARED_CORE_STANDARD.md`.

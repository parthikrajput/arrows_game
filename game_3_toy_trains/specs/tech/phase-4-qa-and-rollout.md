Source docs: phase/phase_4/06_UI_AND_QA_PHASE_4.md, phase/phase_4/01_PHASE_4_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-3-qa-and-rollout.md, specs/gameplay/phase-4-level-plan-01501-02000.md.

# Spec: Tech — Phase 4 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI multi-floor seed validation pipeline, binary metadata serialization (`phase_4_meta.bin`), multi-floor generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 4 (Levels 1501–2000) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_4/06_UI_AND_QA_PHASE_4.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 3 established procedural generation on 2D cyclic grids.
- Phase 4 requires multi-floor 3D validation and floor-switching memory management.

## Proposed Change
Implement the Phase 4 build pipeline and QA verification harness:

### 1. CI Multi-Floor Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 1501$ to $2000$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - No vertical transport deadlock (trains dropped into an obstructed lower floor).
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_4_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `floor_count` (2 or 3 floors).

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per multi-floor level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per multi-floor level.
- **Memory Footprint:** Inactive floor textures cached as lightweight vector paths; raster memory capped at $\le 15\ \text{MB}$ total for all 3 floors.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 4`, level map locks Level 1501 with "Phase 4 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring crash metrics and completion rates.

### 5. QA Acceptance Checklist (Phase 4)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **QA-P4-01** | Floor Switching | Tapping F1/F2/F3 tabs smoothly slides viewport to target floor; costs 0 Moves and 0 hearts. | Not run |
| **QA-P4-02** | Floor Badging | Each floor button accurately counts remaining active trains on that specific floor level. | Not run |
| **QA-P4-03** | M151 Stairs | Train climbs stairs to target floor; resumes departure along heading; blocked destination causes bump. | Not run |
| **QA-P4-04** | M152 Glass | Glass platform transparent; lower floor trains visible and directly tappable through the glass deck. | Not run |
| **QA-P4-05** | M153 Chute | Train drops through chute to lower floor (1 move); requires subsequent tap to exit lower platform. | Not run |
| **QA-P4-06** | M154 Lift | Tapping lift with train fully aboard moves train to target floor (1 move); partial train blocks tap. | Not run |
| **QA-P4-07** | Solvability | All 500 Phase 4 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **QA-P4-08** | Memory Budget | Active multi-floor board consumes <= 15 MB texture memory on low-tier hardware. | Not run |
| **QA-P4-09** | L2000 Finale | Multi-Tier Central Depot features 3-floor puzzle; awards Grand Central Chest and Badge. | Not run |
| **QA-P4-10** | Rollout Gating | Setting `maxPhase = 3` locks Level 1501 cleanly with modal. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_4.dart` (to be created)
- `assets/levels/phase_4_meta.bin` (to be generated)

## Risks
- Frame drop when switching between floors with 40+ trains. Mitigation: Render inactive floors to low-res static pictures until camera settles.

## Open Questions
- None. All parameters and test cases match `phase/phase_4/06_UI_AND_QA_PHASE_4.md` and `SHARED_CORE_STANDARD.md`.


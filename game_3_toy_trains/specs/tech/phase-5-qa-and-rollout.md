Source docs: phase/phase_5/06_UI_AND_QA_PHASE_5.md, phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-4-qa-and-rollout.md, specs/gameplay/phase-5-level-plan-02001-02500.md.

# Spec: Tech — Phase 5 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI shunting simulation seed validation pipeline, binary metadata serialization (`phase_5_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 5 (Levels 2001–2500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_5/06_UI_AND_QA_PHASE_5.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases validated 2D cycles and multi-floor transports.
- Phase 5 requires CI verification of shunting displacement physics, continuous ice sliding, and pit filling.

## Proposed Change
Implement the Phase 5 build pipeline and QA verification harness:

### 1. CI Shunting Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 2001$ to $2500$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - No irreversible shunting soft-locks where carts become trapped against boundaries without required moves.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_5_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `cart_count`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per shunting level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per shunting level.
- **Memory Footprint:** Dynamic shunting cart objects pooled in memory; zero garbage collection pauses during active push animations.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 5`, level map locks Level 2001 with "Phase 5 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and player retention.

### 5. QA Acceptance Checklist (Phase 5)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **QA-P5-01** | Shunting Push | Pushing cart advances it 1 cell if clear behind; train halts in place; counts as 1 Move and 0 hearts lost. | Not run |
| **QA-P5-02** | Blocked Push | Pushing cart into wall, obstacle, or stationary train causes buffer clack bump (-1 heart). | Not run |
| **QA-P5-03** | M201 Pit Fill | Pushing cart into pit fills the excavation; converted cell behaves as permanent standard track. | Not run |
| **QA-P5-04** | M202 Ice Slide | Pushing ice cart causes continuous frictionless slide until obstacle or pit collision occurs. | Not run |
| **QA-P5-05** | M203 Ticket Pad | Shoving ticket cart onto matching color pad permanently unlocks linked railway signal barrier. | Not run |
| **QA-P5-06** | M204 Ballast | Single standard engine cannot push ballast cart (bump -1 heart); Wide Load or Coupled train pushes successfully. | Not run |
| **QA-P5-07** | Solvability | All 500 Phase 5 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **QA-P5-08** | Generation Speed | Levels generate in < 250 ms on low-tier hardware without frame drops. | Not run |
| **QA-P5-09** | L2500 Finale | Shunting Master Yard features complex multi-cart puzzle; awards Grand Central Chest and Badge. | Not run |
| **QA-P5-10** | Rollout Gating | Setting `maxPhase = 4` locks Level 2001 cleanly with "Coming Soon" modal. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_5.dart` (to be created)
- `assets/levels/phase_5_meta.bin` (to be generated)

## Risks
- Frame stutter during multi-cell continuous ice sliding animations. Mitigation: Pre-calculate complete slide path and run linear tween on GPU layer.

## Open Questions
- None. All parameters and test cases match `phase/phase_5/06_UI_AND_QA_PHASE_5.md` and `SHARED_CORE_STANDARD.md`.


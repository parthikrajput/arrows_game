Source docs: phase/phase_19/06_UI_AND_QA_PHASE_19.md, phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-18-qa-and-rollout.md, specs/gameplay/phase-19-level-plan-09001-09500.md.

# Spec: Tech — Phase 19 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI kinetic synergy solver validation pipeline, binary metadata serialization (`phase_19_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 19 (Levels 9001–9500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_19/06_UI_AND_QA_PHASE_19.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases verified early-era multi-floor and optical synergies.
- Phase 19 requires CI verification of rotating coupling platforms, incline spore lifecycles, and split train pruning coverage.

## Proposed Change
Implement the Phase 19 build pipeline and QA verification harness:

### 1. CI Kinetic Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 9001$ to $9500$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - Spore overgrowth must not close the sole exit path before pruner trains can arrive.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_19_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `kinetic_flags`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per kinetic level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per kinetic level.
- **Rotor & Spore Memory:** Rotary matrices and spore lists pre-allocated; zero dynamic object creation during turn evaluation.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 19`, level map locks Level 9001 with "Phase 19 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 19)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **P19-QA-01** | CI Solvability | All 500 Phase 19 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **P19-QA-02** | Turntable Coupler | Trains merge on coupling pads only when turntable rotor is fully aligned with exit tracks. | Not run |
| **P19-QA-03** | Incline Spore Roll | Seed wagon rolls downhill automatically each turn; seeds sprout into ivy after 3 turns. | Not run |
| **P19-QA-04** | Bridge Metronome | Cross-table transit permitted only during 'open' metronome beats; closed beat triggers bump. | Not run |
| **P19-QA-05** | Split Pruner Train | Tapping split engine divides it into 2 pruners that chop adjacent wild ivy along route. | Not run |
| **P19-QA-06** | Kinetic Integrity | Moving spore wagons and rotating turntables never corrupt board tile coordinates. | Not run |
| **P19-QA-07** | 60 fps Performance | Rotor rotation and particle emission maintain 60 fps on low-tier mobile hardware. | Not run |
| **P19-QA-08** | L9500 Finale | Mid-Era Alpine Concourse combines P7–P12 kinetic mechanics; awards Grand Central Chest and Badge. | Not run |
| **P19-QA-09** | Hammer Interaction | Track Crane removes seed wagon cleanly without corrupting active spore timers. | Not run |
| **P19-QA-10** | Rollout Gating | Setting `maxPhase = 18` locks Level 9001 cleanly with modal dialog. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_19.dart` (to be created)
- `packages/puzzle_core/test/engine/remix_b_adapter_test.dart` (to be created)

## Risks
- Rotor rotation timing desync with train tap. Mitigation: Turn execution locks touch inputs while turntable animation is active (max 180 ms).

## Open Questions
- None. QA checklist and rollout parameters match `phase/phase_19/06_UI_AND_QA_PHASE_19.md` and `SHARED_CORE_STANDARD.md`.

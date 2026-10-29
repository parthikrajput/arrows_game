Source docs: phase/phase_7/06_UI_AND_QA_PHASE_7.md, phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/phase-6-qa-and-rollout.md, specs/gameplay/phase-7-level-plan-03001-03500.md.

# Spec: Tech — Phase 7 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI rotational solver validation pipeline, binary metadata serialization (`phase_7_meta.bin`), runtime generation performance budgets, Remote Config rollout gating, and QA acceptance test checklist for Phase 7 (Levels 3001–3500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_7/06_UI_AND_QA_PHASE_7.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Earlier phases validated 2D cycles, multi-floor vertical links, shunting carts, and optical beams.
- Phase 7 requires CI verification of 4x4 sub-board rotor transformations, tangled train detection, and moving border exits.

## Proposed Change
Implement the Phase 7 build pipeline and QA verification harness:

### 1. CI Rotational Seed Validation (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 3001$ to $3500$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - No irreversible tangled deadlocks inside 4x4 rotors.
  - Intro levels ($x1$) contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Overrides:** Overrides committed directly to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_7_meta.bin`)
- Compressed binary metadata file bundled with the app (~4 KB for 500 levels).
- Encodes `par_moves`, `min_moves`, `difficulty` ($D \times 2$), and `rotor_count`.

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Hardware: $\le \mathbf{250\ ms}$ total generation time per rotational level.
  - Mid/High-Tier Hardware: $\le \mathbf{120\ ms}$ total generation time per rotational level.
- **Matrix Calculations:** 4x4 coordinate rotation executes in $\le 0.5\ \text{ms}$.

### 4. Remote Config Staged Rollout
- Gated via Remote Config key `maxPhase`:
  - When `maxPhase < 7`, level map locks Level 3001 with "Phase 7 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring completion rates and retention metrics.

### 5. QA Acceptance Checklist (Phase 7)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **QA-P7-01** | 4x4 Rotor | Tapping center lever rotates all 16 cells and internal trains 90° CW (1 move); partial train blocks tap. | Not run |
| **QA-P7-02** | Tangled State | Train facing own carriage inside rotor enters tangled state (locked tap, no heart, 0 moves). | Not run |
| **QA-P7-03** | M302 Moving Exits| Border gaps advance 1 segment CW every N moves; misaligned exit causes buffer clack (-1 heart). | Not run |
| **QA-P7-04** | M303 Spinner | Clockwork engine rotates heading 90° CW on every valid Move completed on board. | Not run |
| **QA-P7-05** | M304 Lock | Turntable lever locked until linked key train departs; unlocks permanently after clear. | Not run |
| **QA-P7-06** | Solvability | All 500 Phase 7 seeds provably solvable in CI with 0 hearts and 0 boosters. | Not run |
| **QA-P7-07** | Easing Animation| Rotor rotates with smooth 300 ms easeOutBack curve without visual artifacts. | Not run |
| **QA-P7-08** | Generation Speed | Levels generate in < 250 ms on low-tier hardware. | Not run |
| **QA-P7-09** | L3500 Finale | Grand Rotary Central Yard features multi-rotor puzzle; awards Grand Central Chest and Badge. | Not run |
| **QA-P7-10** | Rollout Gating | Setting `maxPhase = 6` locks Level 3001 cleanly with modal. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_7.dart` (to be created)
- `assets/levels/phase_7_meta.bin` (to be generated)

## Risks
- Orientation glitches if 8-direction diagonal trains are inside a rotating 4x4 rotor. Mitigation: Diagonal rotation mapping explicitly defined: `UL -> UR -> DR -> DL -> UL`.

## Open Questions
- None. All parameters and test cases match `phase/phase_7/06_UI_AND_QA_PHASE_7.md` and `SHARED_CORE_STANDARD.md`.

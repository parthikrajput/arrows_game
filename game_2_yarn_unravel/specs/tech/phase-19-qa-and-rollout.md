Source docs: phase/phase_19/06_UI_AND_QA_PHASE_19.md, phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md, ../../PERFORMANCE_OPTIMIZATION.md. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 19 QA and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the automated CI seed validation, test suites, kinematic performance budgets, metadata packing (`phase_19_meta.bin`), and Remote Config rollout gate for Phase 19 (Levels 9001–9500).

## Current State
Documented in `phase/phase_19/06_UI_AND_QA_PHASE_19.md` and `phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md`, not yet implemented in code.

## Proposed Change
Implement QA validation pipelines and rollout infrastructure:

### 1. Automated CI Validation & Solvability
- **Seed Validation:**
  - CI runs headless IDA* solver across all 500 seeds (9001–9500).
  - Every level must verify as 100% solvable with 0 hearts lost and 0 boosters required.
  - Failures automatically append valid replacements to `assets/levels/seed_overrides.json`.
- **Generation & Solver Performance:**
  - Level generation time on target device must not exceed 100 ms in background isolates.
  - Multi-kinematic solver search node budget strictly enforced at $\le 1.5\text{M}$ nodes per seed.
- **Metadata Compilation:**
  - Par moves, rotor coordinates, rhythm patterns, thread counts, and tier tags packed into binary format at `assets/levels/phase_19_meta.bin`.

### 2. QA Acceptance Checklist
- **QA-P19-01 (Twirl Weighted):** Thread rotates 90° CW and translates 1 cell along active gravity vector after every valid move.
- **QA-P19-02 (Ivy Hoop Rotor):** Disc rotation correctly re-orients ivy roots and accurately redirects subsequent expansion.
- **QA-P19-03 (Rhythm Belt):** Conveyor advances occupying threads only on active metronome beats; remains stationary on off-beats.
- **QA-P19-04 (Seam Edge Split):** Crossing boundary seam cleanly instantiates paired half-ply thread entities on the destination board.
- **QA-P19-05 (0-Hearts Solvability):** All 500 levels verified solvable without guessing or booster reliance.
- **QA-P19-06 (Kinematic Performance):** Maintains stable 60 fps on low-end 2 GB RAM baseline devices during concurrent rotations and growth.
- **QA-P19-07 (Remote Config Rollout):** Levels 9001–9500 remain strictly locked if `maxPhase < 19`.
- **QA-P19-08 (Milestones & Finale):** Review Level 9491 and Finale Level 9500 execute correctly with badge and reward delivery.

### 3. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer).
- **Default:** 18.
- **Staged Rollout:**
  - Internal testing: `maxPhase = 19` for QA testers.
  - Production rollout: Increment to 19 upon CI seed verification pass.

## Affected Files
- `test/phases/phase_19_validation_test.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_19_validator.dart` (to be created)
- `assets/levels/phase_19_meta.bin` (to be created by build script)

## Risks and Open Questions
- None. Meets all standard CI and rollout safety requirements.


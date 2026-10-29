Source docs: phase/phase_14/06_UI_AND_QA_PHASE_14.md, phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../PERFORMANCE_OPTIMIZATION.md. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 14 QA and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the automated CI seed validation, test suites, performance budgets, metadata packing (`phase_14_meta.bin`), and Remote Config rollout gate for Phase 14 (Levels 6501–7000).

## Current State
Documented in `phase/phase_14/06_UI_AND_QA_PHASE_14.md` and `phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md`, not yet implemented in code.

## Proposed Change
Implement QA validation pipelines and rollout infrastructure:

### 1. Automated CI Validation & Solvability
- **Seed Validation:**
  - CI runs headless IDA* solver across all 500 seeds (6501–7000).
  - Every level must verify as 100% solvable with 0 hearts lost and 0 boosters required.
  - Failures automatically append valid replacements to `assets/levels/seed_overrides.json`.
- **Generation Performance:**
  - Level generation time on target device must not exceed 100 ms in background isolates.
- **Metadata Compilation:**
  - Par moves, reflection axes, twin pairings, thread counts, and tier tags packed into binary format at `assets/levels/phase_14_meta.bin`.

### 2. QA Acceptance Checklist
- **QA-P14-01 (Mirror Seam):** Twin threads unravel in parallel when both paths are unobstructed.
- **QA-P14-02 (Twin Snag):** If either twin thread is obstructed, both threads snag with a single -1 Heart penalty.
- **QA-P14-03 (Reflect Clasp):** Unlocking one clasp immediately unlocks its mirrored counterpart across the seam.
- **QA-P14-04 (Inverse Thread):** Advancing a primary thread causes linked inverse thread to move in the exact opposite direction.
- **QA-P14-05 (0-Hearts Solvability):** All 500 levels verified solvable without guessing or booster reliance.
- **QA-P14-06 (Frame Budget):** Maintains stable 60 fps on low-end 2 GB RAM baseline devices during twin unravel animations.
- **QA-P14-07 (Remote Config Rollout):** Levels 6501–7000 remain strictly locked if `maxPhase < 14`.
- **QA-P14-08 (Milestones & Finale):** Review Level 6991 and Finale Level 7000 execute correctly with badge and reward delivery.

### 3. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer).
- **Default:** 13.
- **Staged Rollout:**
  - Internal testing: `maxPhase = 14` for QA testers.
  - Production rollout: Increment to 14 upon CI seed verification pass.

## Affected Files
- `test/phases/phase_14_validation_test.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_14_validator.dart` (to be created)
- `assets/levels/phase_14_meta.bin` (to be created by build script)

## Risks and Open Questions
- None. Meets all standard CI and rollout safety requirements.


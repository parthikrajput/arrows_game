Source docs: phase/phase_13/06_UI_AND_QA_PHASE_13.md, phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../PERFORMANCE_OPTIMIZATION.md. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 13 QA and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the automated CI seed validation, test suites, performance budgets, metadata packing (`phase_13_meta.bin`), and Remote Config rollout gate for Phase 13 (Levels 6001–6500).

## Current State
Documented in `phase/phase_13/06_UI_AND_QA_PHASE_13.md` and `phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md`, not yet implemented in code.

## Proposed Change
Implement QA validation pipelines and rollout infrastructure:

### 1. Automated CI Validation & Solvability
- **Seed Validation:**
  - CI runs headless IDA* solver across all 500 seeds (6001–6500).
  - Every level must verify as 100% solvable with 0 hearts lost and 0 boosters required.
  - Failures automatically append valid replacements to `assets/levels/seed_overrides.json`.
- **Generation Performance:**
  - Level generation time on target device must not exceed 100 ms in background isolates.
- **Metadata Compilation:**
  - Par moves, initial fog masks, thread counts, and tier tags packed into binary format at `assets/levels/phase_13_meta.bin`.

### 2. QA Acceptance Checklist
- **QA-P13-01 (Scout Thread):** Unraveling M601 clears fog in a 1-cell Chebyshev radius along its entire pull path.
- **QA-P13-02 (Decoy Fluff):** Thread bodies pass cleanly through M602, dissolving fluff into fibers without collision.
- **QA-P13-03 (Painted Wall):** Thread bodies pass cleanly through M603, converting wall to a 2D chalk line without snags.
- **QA-P13-04 (Lantern Plate):** Thread resting on M604 drops fog opacity to 40%; lifting the thread restores 100% opacity.
- **QA-P13-05 (0-Hearts Solvability):** All 500 levels verified solvable without guessing or booster reliance.
- **QA-P13-06 (Frame Budget):** Maintains stable 60 fps on low-end 2 GB RAM baseline devices during active fog reveals.
- **QA-P13-07 (Remote Config Rollout):** Levels 6001–6500 remain strictly locked if `maxPhase < 13`.
- **QA-P13-08 (Milestones & Finale):** Review Level 6491 and Finale Level 6500 execute correctly with badge and reward delivery.

### 3. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer).
- **Default:** 12.
- **Staged Rollout:**
  - Internal testing: `maxPhase = 13` for QA testers.
  - Production rollout: Increment to 13 upon CI seed verification pass.

## Affected Files
- `test/phases/phase_13_validation_test.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_13_validator.dart` (to be created)
- `assets/levels/phase_13_meta.bin` (to be created by build script)

## Risks and Open Questions
- None. Meets all standard CI and rollout safety requirements.


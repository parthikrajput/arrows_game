Source docs: phase/phase_16/06_UI_AND_QA_PHASE_16.md, phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md, ../../PERFORMANCE_OPTIMIZATION.md. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 16 QA and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the automated CI seed validation, test suites, performance budgets, metadata packing (`phase_16_meta.bin`), and Remote Config rollout gate for Phase 16 (Levels 7501–8000).

## Current State
Documented in `phase/phase_16/06_UI_AND_QA_PHASE_16.md` and `phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md`, not yet implemented in code.

## Proposed Change
Implement QA validation pipelines and rollout infrastructure:

### 1. Automated CI Validation & Solvability
- **Seed Validation:**
  - CI runs headless IDA* solver across all 500 seeds (7501–8000).
  - Every level must verify as 100% solvable with 0 hearts lost and 0 boosters required.
  - Failures automatically append valid replacements to `assets/levels/seed_overrides.json`.
- **Generation Performance:**
  - Level generation time on target device must not exceed 100 ms in background isolates.
- **Metadata Compilation:**
  - Par moves, chain order mappings, key pairing tables, thread counts, and tier tags packed into binary format at `assets/levels/phase_16_meta.bin`.

### 2. QA Acceptance Checklist
- **QA-P16-01 (Charm Chain):** Charms collect strictly in designated sequence ($1 \to 2 \to 3$); tapping out of order returns a locked vibration.
- **QA-P16-02 (Charm Crafting):** Both half-charm threads unraveling triggers the forging animation and unlocks the target Grand Clasp.
- **QA-P16-03 (Skeleton Charm):** Skeleton key unlocks any encountered clasp, bypassing color matching.
- **QA-P16-04 (Charm Swap Hoop):** Tapping the hoop consumes 1 move and correctly swaps key colors between linked threads.
- **QA-P16-05 (0-Hearts Solvability):** All 500 levels verified solvable without guessing or booster reliance.
- **QA-P16-06 (Frame Budget):** Maintains stable 60 fps on low-end 2 GB RAM baseline devices during key forging animations.
- **QA-P16-07 (Remote Config Rollout):** Levels 7501–8000 remain strictly locked if `maxPhase < 16`.
- **QA-P16-08 (Milestones & Finale):** Review Level 7991 and Finale Level 8000 execute correctly with badge and reward delivery.

### 3. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer).
- **Default:** 15.
- **Staged Rollout:**
  - Internal testing: `maxPhase = 16` for QA testers.
  - Production rollout: Increment to 16 upon CI seed verification pass.

## Affected Files
- `test/phases/phase_16_validation_test.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_16_validator.dart` (to be created)
- `assets/levels/phase_16_meta.bin` (to be created by build script)

## Risks and Open Questions
- None. Meets all standard CI and rollout safety requirements.

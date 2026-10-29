Source docs: phase/phase_15/06_UI_AND_QA_PHASE_15.md, phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md, ../../PERFORMANCE_OPTIMIZATION.md. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 15 QA and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the automated CI seed validation, test suites, performance budgets, metadata packing (`phase_15_meta.bin`), and Remote Config rollout gate for Phase 15 (Levels 7001–7500).

## Current State
Documented in `phase/phase_15/06_UI_AND_QA_PHASE_15.md` and `phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md`, not yet implemented in code.

## Proposed Change
Implement QA validation pipelines and rollout infrastructure:

### 1. Automated CI Validation & Solvability
- **Seed Validation:**
  - CI runs headless IDA* solver across all 500 seeds (7001–7500).
  - Every level must verify as 100% solvable with 0 hearts lost and 0 boosters required.
  - Failures automatically append valid replacements to `assets/levels/seed_overrides.json`.
- **Generation Performance:**
  - Level generation time on target device must not exceed 100 ms in background isolates.
- **Metadata Compilation:**
  - Par moves, conveyor layouts, switch routes, thread counts, and tier tags packed into binary format at `assets/levels/phase_15_meta.bin`.

### 2. QA Acceptance Checklist
- **QA-P15-01 (Feed Dog Conveyors):** Threads resting on active belts translate 1 cell in the designated direction after each valid player move.
- **QA-P15-02 (Belt Switch):** Tapping the switch consumes 1 move and redirects conveyor paths accurately.
- **QA-P15-03 (Reversing Belt):** Belt direction inverts 180° every $N$ moves, accurately updating countdown badges.
- **QA-P15-04 (Track Loop):** Thread cycles along loop correctly and unravels only when aligned with the exit cell.
- **QA-P15-05 (0-Hearts Solvability):** All 500 levels verified solvable without guessing or booster reliance.
- **QA-P15-06 (Frame Budget):** Maintains stable 60 fps on low-end 2 GB RAM baseline devices during concurrent conveyor movements.
- **QA-P15-07 (Remote Config Rollout):** Levels 7001–7500 remain strictly locked if `maxPhase < 15`.
- **QA-P15-08 (Milestones & Finale):** Review Level 7491 and Finale Level 7500 execute correctly with badge and reward delivery.

### 3. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer).
- **Default:** 14.
- **Staged Rollout:**
  - Internal testing: `maxPhase = 15` for QA testers.
  - Production rollout: Increment to 15 upon CI seed verification pass.

## Affected Files
- `test/phases/phase_15_validation_test.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_15_validator.dart` (to be created)
- `assets/levels/phase_15_meta.bin` (to be created by build script)

## Risks and Open Questions
- None. Meets all standard CI and rollout safety requirements.

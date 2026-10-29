Source docs: phase/phase_17/06_UI_AND_QA_PHASE_17.md, phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md, ../../PERFORMANCE_OPTIMIZATION.md. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 17 QA and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the automated CI seed validation, test suites, performance budgets, metadata packing (`phase_17_meta.bin`), and Remote Config rollout gate for Phase 17 (Levels 8001–8500).

## Current State
Documented in `phase/phase_17/06_UI_AND_QA_PHASE_17.md` and `phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md`, not yet implemented in code.

## Proposed Change
Implement QA validation pipelines and rollout infrastructure:

### 1. Automated CI Validation & Solvability
- **Seed Validation:**
  - CI runs headless IDA* solver across all 500 seeds (8001–8500).
  - Every level must verify as 100% solvable with 0 hearts lost and 0 boosters required.
  - Failures automatically append valid replacements to `assets/levels/seed_overrides.json`.
- **Generation Performance:**
  - Level generation time on target device must not exceed 100 ms in background isolates.
- **Metadata Compilation:**
  - Par moves, guardian coordinates, HP initializations, thread counts, and tier tags packed into binary format at `assets/levels/phase_17_meta.bin`.

### 2. QA Acceptance Checklist
- **QA-P17-01 (Pincushion HP):** Unravelling a thread through an adjacent cell deducts exactly 1 HP from valid pincushions.
- **QA-P17-02 (Twin Guardians):** Pulling pins from either twin correctly decrements the shared HP pool until both collapse.
- **QA-P17-03 (Armoured Shield):** While lever is in shielded state, no adjacent pulls inflict HP damage.
- **QA-P17-04 (Seeding Pincushion):** Spawner generates 1 button in correct directional order every 4 moves while active.
- **QA-P17-05 (Heart Core):** Core pincushion takes damage only when illuminated by an active light beam.
- **QA-P17-06 (0-Hearts Solvability):** All 500 levels verified solvable without guessing or booster reliance.
- **QA-P17-07 (Frame Budget):** Maintains stable 60 fps on low-end 2 GB RAM baseline devices during multi-cell guardian collapse.
- **QA-P17-08 (Remote Config Rollout):** Levels 8001–8500 remain strictly locked if `maxPhase < 17`.
- **QA-P17-09 (Milestones & Finale):** Review Level 8491 and Finale Level 8500 execute correctly with badge and reward delivery.

### 3. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer).
- **Default:** 16.
- **Staged Rollout:**
  - Internal testing: `maxPhase = 17` for QA testers.
  - Production rollout: Increment to 17 upon CI seed verification pass.

## Affected Files
- `test/phases/phase_17_validation_test.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_17_validator.dart` (to be created)
- `assets/levels/phase_17_meta.bin` (to be created by build script)

## Risks and Open Questions
- None. Meets all standard CI and rollout safety requirements.

Source docs: phase/phase_18/06_UI_AND_QA_PHASE_18.md, phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md, ../../PERFORMANCE_OPTIMIZATION.md. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 18 QA and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the automated CI seed validation, test suites, multi-system performance budgets, metadata packing (`phase_18_meta.bin`), and Remote Config rollout gate for Phase 18 (Levels 8501–9000).

## Current State
Documented in `phase/phase_18/06_UI_AND_QA_PHASE_18.md` and `phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md`, not yet implemented in code.

## Proposed Change
Implement QA validation pipelines and rollout infrastructure:

### 1. Automated CI Validation & Solvability
- **Seed Validation:**
  - CI runs headless IDA* solver across all 500 seeds (8501–9000).
  - Every level must verify as 100% solvable with 0 hearts lost and 0 boosters required.
  - Failures automatically append valid replacements to `assets/levels/seed_overrides.json`.
- **Generation & Solver Performance:**
  - Level generation time on target device must not exceed 100 ms in background isolates.
  - Multi-system solver search node budget strictly enforced at $\le 1.5\text{M}$ nodes per seed.
- **Metadata Compilation:**
  - Par moves, composite system mappings, thread counts, and tier tags packed into binary format at `assets/levels/phase_18_meta.bin`.

### 2. QA Acceptance Checklist
- **QA-P18-01 (Cycle Crate):** Crate slides smoothly during Day phase; latches into an immovable blocker during Night phase.
- **QA-P18-02 (Floor Beam):** Light ray projects accurately through translucent organza and illuminates lower-floor sun-catchers.
- **QA-P18-03 (Fogged Stair):** Unravelling a thread through the wool fluff permanently clears fog and reveals the stair.
- **QA-P18-04 (Satin Charm Crate):** Sliding the crate into its target clasp unlocks the clasp and removes the crate.
- **QA-P18-05 (0-Hearts Solvability):** All 500 levels verified solvable without guessing or booster reliance.
- **QA-P18-06 (Multi-System Performance):** Maintains stable 60 fps on low-end 2 GB RAM baseline devices during concurrent multi-system operations.
- **QA-P18-07 (Remote Config Rollout):** Levels 8501–9000 remain strictly locked if `maxPhase < 18`.
- **QA-P18-08 (Milestones & Finale):** Review Level 8991 and Finale Level 9000 execute correctly with badge and reward delivery.

### 3. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer).
- **Default:** 17.
- **Staged Rollout:**
  - Internal testing: `maxPhase = 18` for QA testers.
  - Production rollout: Increment to 18 upon CI seed verification pass.

## Affected Files
- `test/phases/phase_18_validation_test.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_18_validator.dart` (to be created)
- `assets/levels/phase_18_meta.bin` (to be created by build script)

## Risks and Open Questions
- None. Meets all standard CI and rollout safety requirements.

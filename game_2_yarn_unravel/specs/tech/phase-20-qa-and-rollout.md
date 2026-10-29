Source docs: phase/phase_20/06_UI_AND_QA_PHASE_20.md, phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md, ../../PERFORMANCE_OPTIMIZATION.md. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 20 QA and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the automated CI seed validation, test suites, Level 10,000 verification, endgame loop transition integrity, metadata packing (`phase_20_meta.bin`), and Remote Config rollout gate for Phase 20 (Levels 9501–10,000).

## Current State
Documented in `phase/phase_20/06_UI_AND_QA_PHASE_20.md` and `phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md`, not yet implemented in code.

## Proposed Change
Implement QA validation pipelines and rollout infrastructure:

### 1. Automated CI Validation & Solvability
- **Seed Validation:**
  - CI runs headless IDA* solver across all 500 seeds (9501–10,000).
  - Every level must verify as 100% solvable with 0 hearts lost and 0 boosters required.
  - Failures automatically append valid replacements to `assets/levels/seed_overrides.json`.
- **Level 10,000 Grand Finale Deep Verification:**
  - Seed for Level 10,000 is verified with exhaustive solver verification, ensuring zero deadlocks across all active systems.
- **Generation Performance:**
  - Level generation time on target device must not exceed 100 ms in background isolates.
- **Metadata Compilation:**
  - Par moves, master layouts, moving guardian patrol paths, thread counts, and tier tags packed into binary format at `assets/levels/phase_20_meta.bin`.

### 2. QA Acceptance Checklist
- **QA-P20-01 (Moving Guardian):** Boss pincushion traverses its designated patrol path, advancing 1 cell every 2 player moves.
- **QA-P20-02 (Omni Gate):** Gate opens only upon concurrent fulfillment of light beam, color match, and cycle state criteria.
- **QA-P20-03 (Grand Loom Spool):** Dispenses the next stored thread cleanly onto the canvas immediately upon clearing active thread.
- **QA-P20-04 (Master Weaver Key):** Exit of master key triggers immediate, universal unlock across all board clasps.
- **QA-P20-05 (Level 10,000 Solvability):** Grand Finale verified 100% solvable with 0 hearts lost and 0 boosters used.
- **QA-P20-06 (Endgame Transition):** Clearing Level 10,000 transitions smoothly into the infinite endgame loop (Daily Stitch, Weekly Star Race) without state corruption or crashes.
- **QA-P20-07 (Remote Config Rollout):** Levels 9501–10,000 remain strictly locked if `maxPhase < 20`.
- **QA-P20-08 (Performance Budget):** Maintains stable 60 fps on low-end 2 GB RAM baseline devices during full-system operation.

### 3. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer).
- **Default:** 19.
- **Staged Rollout:**
  - Internal testing: `maxPhase = 20` for QA testers.
  - Production rollout: Increment to 20 upon CI seed verification pass.

## Affected Files
- `test/phases/phase_20_validation_test.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/phase_20_validator.dart` (to be created)
- `assets/levels/phase_20_meta.bin` (to be created by build script)

## Risks and Open Questions
- None. Meets all standard CI and rollout safety requirements.


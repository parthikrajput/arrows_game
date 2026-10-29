Source docs: phases/phase_14/06_UI_AND_QA_PHASE_14.md, phases/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §13, §14, ../../SCALING_TO_10000_LEVELS.md §10. Depends on: specs/tech/on-device-level-generation.md, specs/tech/phase-13-qa-and-rollout.md.

# Spec: Tech — Phase 14 QA, Release Prerequisites and Rollout

## Status
Draft

## Type
New Feature

## Goal
Establish the CI seed pre-validation pipeline, binary metadata compilation (`phase_14_meta.bin`), runtime performance budgets, Remote Config staged rollout flags, and QA verification checklist for Phase 14 (Levels 6501–7000).

## Current State
Design documented in `phases/phase_14/06_UI_AND_QA_PHASE_14.md`, `phases/phase_14/01_PHASE_14_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §10, not yet implemented.
- CI pipeline verified levels up to 6500 with `maxPhase = 13`.
- Phase 14 introduces bilateral symmetry and paired movement registries, requiring verification of synchronized safety constraints, integer vector math determinism, and bundling `phase_14_meta.bin`.

## Proposed Change
Extend test harnesses, CI runners, and deployment configurations:

### 1. CI Pre-Validation Pipeline (Standard §12)
- **Deterministic Batch Generation:**
  - CI generates all 500 levels (L6501–7000) using the PRNG seed formula:
    $$\text{seed} = \text{xoshiro128**}(\text{levelNumber}, \text{phase} = 14)$$
- **Zero-Booster Headless Solver:**
  - Every seed must be solved by headless A* search maintaining bilateral reflection pair constraints with **0 hearts lost** and **0 boosters consumed**.
  - Any seed exceeding search budgets ($> 50{,}000$ states evaluated or $> 500\text{ ms}$ solve latency) is regenerated with seed salt increments; persistent outliers are registered in `assets/levels/seed_overrides.json`.
- **Binary Metadata Compilation:**
  - Validated par moves, axis parameters, and SHA-256 level hashes are serialized into `assets/levels/phase_14_meta.bin` ($\approx 2.5\text{ KB}$ gzipped).

---

### 2. Runtime Performance Budgets (Standard §13)
- **On-Device Level Generation:**
  - High/Mid-Tier devices: $\le 150\text{ ms}$
  - Low-Tier devices (Android Go, 2GB RAM): $\le 250\text{ ms}$
- **Bilateral Movement Calculation:**
  - Dual-vector reflection lookup and collision checking must resolve in $\le 1\text{ ms}$ per tap.
  - Low-Tier hardware uses standard 2D matrix scale transforms (`scale(-1, 1)`) for rendering reflections.
  - Total puzzle core memory usage during continuous play: $\le 90\text{ MB}$ (Low-Tier), $\le 110\text{ MB}$ (Mid-Tier).
- **Frame Rate Target:** Stable 60 FPS across all tiers, min 50 FPS during dual-snake synchronized slither on Low-Tier devices.

---

### 3. Remote Config & Staged Rollout Strategy
Rollout is governed by Firebase Remote Config parameters:
- `max_phase_unlocked`: Incremented from `13` to `14` according to the rollout schedule:
  - Day 1: Internal QA & Canary (1%)
  - Day 3: 5% staged rollout
  - Day 7: 25% staged rollout
  - Day 14: 100% full production rollout
- `phase_14_axis_caustic_enabled`: Boolean parameter (default `true`) allowing kill-switch disablement of animated caustic shaders on low-end chipsets.

---

### 4. QA Verification Matrix (P14-QA-01 to P14-QA-10)
- [ ] **P14-QA-01 (M651 Symmetrical Mirroring):** Tapping Snake A commands partner Snake B to advance along its mirrored reflection trajectory.
- [ ] **P14-QA-02 (M651 Dual Blockage Safety):** Obstructing either partner halts both snakes simultaneously at rest with 0 hearts lost.
- [ ] **P14-QA-03 (M652 Cross-Axis Unlock):** Reflection lock on Shore A unseals if and only if the key snake on Shore B completely exits.
- [ ] **P14-QA-04 (M653 Twin Board Match):** Shared move inputs execute cleanly across both mirrored grids without coordinate desync.
- [ ] **P14-QA-05 (M654 Inverse Motion):** Upside-down Snake slithers in the exact opposite directional vector of its partner.
- [ ] **P14-QA-06 (Deadlock Prevention):** Reflected snakes never create mutual circular wait conditions at exit lanes.
- [ ] **P14-QA-07 (Undo Mirror Integrity):** Tapping Undo restores previous move, snake positions, and lock states across both shores simultaneously.
- [ ] **P14-QA-08 (Level 7000 Finale):** Completing Level 7000 awards 1,000 coins, 6 boosters, Phase 14 profile badge, and unlocks Phase 15.
- [ ] **P14-QA-09 (Memory Leak Profile):** 50 consecutive mirror level clears maintain stable heap below 120MB.
- [ ] **P14-QA-10 (CI Binary Verification):** `phase_14_meta.bin` integrity confirmed via checksum before release packaging.

## Affected Files
- `packages/puzzle_core/lib/src/tech/phase_14_meta_loader.dart` (to be created)
- `assets/levels/phase_14_meta.bin` (to be generated)
- `test/tech/phase_14_qa_test.dart` (to be created)
- `tool/ci/validate_phase_14_seeds.dart` (to be created)

## Risks and Open Questions
- **Undo Operation on Paired Entities:** Tapping undo while two snakes are in motion must simultaneously rewind both snakes and restore their linked pairing references without orphaning partner IDs.

Source docs: phases/phase_12/06_UI_AND_QA_PHASE_12.md, phases/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §13, §14, ../../SCALING_TO_10000_LEVELS.md §10. Depends on: specs/tech/on-device-level-generation.md, specs/tech/phase-11-qa-and-rollout.md.

# Spec: Tech — Phase 12 QA, Release Prerequisites and Rollout

## Status
Draft

## Type
New Feature

## Goal
Establish the CI seed pre-validation pipeline, binary metadata compilation (`phase_12_meta.bin`), runtime performance budgets, Remote Config rollout strategy, and QA verification checklist for Phase 12 (Levels 5501–6000).

## Current State
Design documented in `phases/phase_12/06_UI_AND_QA_PHASE_12.md`, `phases/phase_12/01_PHASE_12_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §10, not yet implemented.
- CI pipeline verified levels up to 5500 with `maxPhase = 11`.
- Phase 12 introduces environmental physics simulation, requiring verification of cascade termination, collision determinism, and bundling `phase_12_meta.bin`.

## Proposed Change
Extend test harnesses, CI runners, and deployment configurations:

### 1. CI Pre-Validation Pipeline (Standard §12)
- **Deterministic Batch Generation:**
  - CI generates all 500 levels (L5501–6000) using the PRNG seed formula:
    $$\text{seed} = \text{xoshiro128**}(\text{levelNumber}, \text{phase} = 12)$$
- **Zero-Booster Headless Solver:**
  - Every seed must be solved by headless A* search incorporating gravity vector states with **0 hearts lost** and **0 boosters consumed**.
  - Any seed exceeding search budgets ($> 50{,}000$ states evaluated or $> 500\text{ ms}$ solve latency) is regenerated with seed salt increments; persistent outliers are registered in `assets/levels/seed_overrides.json`.
- **Binary Metadata Compilation:**
  - Validated par moves, lever initial orientations, and SHA-256 level hashes are serialized into `assets/levels/phase_12_meta.bin` ($\approx 2.5\text{ KB}$ gzipped).

---

### 2. Runtime Performance Budgets (Standard §13)
- **On-Device Level Generation:**
  - High/Mid-Tier devices: $\le 150\text{ ms}$
  - Low-Tier devices (Android Go, 2GB RAM): $\le 250\text{ ms}$
- **Physics Settling Loop Budget:**
  - Post-move cascade loop must terminate in $\le 3\text{ ms}$ on 2GB RAM Android devices.
  - Total puzzle core memory usage during continuous play: $\le 90\text{ MB}$ (Low-Tier), $\le 110\text{ MB}$ (Mid-Tier).
- **Frame Rate Target:** Stable 60 FPS across all tiers, min 50 FPS during multi-fruit cascade drops on Low-Tier devices.

---

### 3. Remote Config & Staged Rollout Strategy
Rollout is governed by Firebase Remote Config parameters:
- `max_phase_unlocked`: Incremented from `11` to `12` according to the rollout schedule:
  - Day 1: Internal QA & Canary (1%)
  - Day 3: 5% staged rollout
  - Day 7: 25% staged rollout
  - Day 14: 100% full production rollout
- `phase_12_fruit_fall_speed_ms`: Integer parameter (default `150`, range `100..250`) controlling the duration of fruit falling animations per cell.

---

### 4. QA Verification Matrix (P12-QA-01 to P12-QA-10)
- [ ] **P12-QA-01 (M551 90-Deg Rotation):** Tapping the Wind Lever rotates directional gravity exactly $90^\circ$ clockwise and uses 1 move.
- [ ] **P12-QA-02 (M552 Falling Bounds):** Falling fruits never pass through perimeter boundary walls or escape grid bounds.
- [ ] **P12-QA-03 (M552 Snake Cushioning):** Falling fruits halt cleanly on top of resting snakes without inflicting damage or deducting hearts.
- [ ] **P12-QA-04 (M553 Anti-Grav Hold):** Fruits placed on Floaty Lily tiles remain suspended regardless of active gravity orientation.
- [ ] **P12-QA-05 (M554 Python Slide):** Heavy pythons shift downward 1 cell if and only if all cells below their body are vacant.
- [ ] **P12-QA-06 (Deadlock Prevention):** Falling fruit configurations never permanently seal all exits of remaining snakes.
- [ ] **P12-QA-07 (Undo Physics Equilibrium):** Tapping Undo restores previous gravity direction and rewinds all fallen fruit positions.
- [ ] **P12-QA-08 (Level 6000 Finale):** Completing Level 6000 awards 1,000 coins, 6 boosters, Phase 12 profile badge, and unlocks Phase 13.
- [ ] **P12-QA-09 (Memory Leak Profile):** 50 consecutive gravity level clears maintain stable heap below 120MB.
- [ ] **P12-QA-10 (CI Binary Verification):** `phase_12_meta.bin` integrity confirmed via checksum before release packaging.

## Affected Files
- `packages/puzzle_core/lib/src/tech/phase_12_meta_loader.dart` (to be created)
- `assets/levels/phase_12_meta.bin` (to be generated)
- `test/tech/phase_12_qa_test.dart` (to be created)
- `tool/ci/validate_phase_12_seeds.dart` (to be created)

## Risks and Open Questions
- **Cascade Undo Complexity:** Because multiple fruits may drop through varying distances during a single turn, the undo state must snapshot complete coordinate sets for all movable entities rather than attempting differential coordinate arithmetic.

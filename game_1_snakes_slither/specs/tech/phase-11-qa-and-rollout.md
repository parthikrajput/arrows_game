Source docs: phases/phase_11/06_UI_AND_QA_PHASE_11.md, phases/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §13, §14, ../../SCALING_TO_10000_LEVELS.md §10. Depends on: specs/tech/on-device-level-generation.md, specs/tech/phase-10-qa-and-rollout.md.

# Spec: Tech — Phase 11 QA, Release Prerequisites and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed pre-validation pipeline, dual-board metadata artifact generation (`phase_11_meta.bin`), runtime performance budgets, Remote Config staged rollout flags, and QA verification checklist for Phase 11 (Levels 5001–5500).

## Current State
Design documented in `phases/phase_11/06_UI_AND_QA_PHASE_11.md`, `phases/phase_11/01_PHASE_11_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §10, not yet implemented.
- CI pipeline verified levels up to 5000 with `maxPhase = 10`.
- Phase 11 introduces a dual-grid state model (`DualBoardState`), requiring multi-board solver heuristics, cross-grid transit verification, and bundling `phase_11_meta.bin`.

## Proposed Change
Extend test harnesses, CI runners, and deployment configurations:

### 1. CI Pre-Validation Pipeline (Standard §12)
- **Deterministic Batch Generation:**
  - CI generates all 500 levels (L5001–5500) using the PRNG seed formula:
    $$\text{seed} = \text{xoshiro128**}(\text{levelNumber}, \text{phase} = 11)$$
- **Zero-Booster Multi-Board Solver:**
  - Every seed must be solved by headless A* search across both sub-grids with **0 hearts lost** and **0 boosters consumed**.
  - Any seed exceeding search budgets ($> 50{,}000$ states evaluated or $> 500\text{ ms}$ solve latency) is regenerated with seed salt increments; persistent outliers are registered in `assets/levels/seed_overrides.json`.
- **Binary Metadata Compilation:**
  - Validated par moves, bridge parameters, and SHA-256 level hashes are serialized into `assets/levels/phase_11_meta.bin` ($\approx 2.5\text{ KB}$ gzipped).

---

### 2. Runtime Performance Budgets (Standard §13)
- **On-Device Level Generation:**
  - High/Mid-Tier devices: $\le 150\text{ ms}$
  - Low-Tier devices (Android Go, 2GB RAM): $\le 250\text{ ms}$
- **Dual-Grid Rendering & Draw Calls:**
  - Render both mini-boards within $\le 12$ draw calls in a single canvas frame.
  - Total puzzle core memory usage during continuous play: $\le 90\text{ MB}$ (Low-Tier), $\le 110\text{ MB}$ (Mid-Tier).
- **Frame Rate Target:** Stable 60 FPS across all tiers, min 50 FPS during cross-board transits on Low-Tier devices.

---

### 3. Remote Config & Staged Rollout Strategy
Rollout is governed by Firebase Remote Config parameters:
- `max_phase_unlocked`: Incremented from `10` to `11` according to the rollout schedule:
  - Day 1: Internal QA & Canary (1%)
  - Day 3: 5% staged rollout
  - Day 7: 25% staged rollout
  - Day 14: 100% full production rollout
- `phase_11_bridge_transfer_speed`: Double parameter (default `1.0`, range `0.8..1.5`) controlling the slither speed multiplier across vine bridges.

---

### 4. QA Verification Matrix (P11-QA-01 to P11-QA-10)
- [ ] **P11-QA-01 (M501 Continuous Slither):** Snake segments continuously span across the vine bridge without seam separation or clipping.
- [ ] **P11-QA-02 (M501 Board 2 Clearance):** If the entry tile on Board 2 is occupied, the snake halts on Board 1 with 0 hearts lost.
- [ ] **P11-QA-03 (M502 Messenger Trigger):** Board 2 lock opens if and only if the Messenger Snake on Board 1 completely exits.
- [ ] **P11-QA-04 (M503 Synchronous Mirroring):** Obstructing either mirror partner halts both snakes simultaneously at origin with 0 hearts lost.
- [ ] **P11-QA-05 (M504 Cross-Board Portal):** Entering the burrow on Board 1 transports the snake to Board 2 preserving orientation.
- [ ] **P11-QA-06 (Deadlock Prevention):** Continuous transit from Board 1 to Board 2 never results in an unresolvable grid jam.
- [ ] **P11-QA-07 (Undo Multi-Board State):** Tapping Undo restores previous states on both boards and rewinds bridge transit smoothly.
- [ ] **P11-QA-08 (Level 5500 Finale):** Completing Level 5500 grants 1,000 coins, 6 boosters, Phase 11 profile badge, and unlocks Phase 12.
- [ ] **P11-QA-09 (Memory Leak Profile):** 50 consecutive dual-board level completions maintain stable heap below 120MB.
- [ ] **P11-QA-10 (CI Binary Verification):** `phase_11_meta.bin` integrity confirmed via checksum before release packaging.

## Affected Files
- `packages/puzzle_core/lib/src/tech/phase_11_meta_loader.dart` (to be created)
- `assets/levels/phase_11_meta.bin` (to be generated)
- `test/tech/phase_11_qa_test.dart` (to be created)
- `tool/ci/validate_phase_11_seeds.dart` (to be created)

## Risks and Open Questions
- **Cross-Board Deadlocks:** If a long snake partially occupies Board 2 and blocks the only exit of another snake needed to clear Board 2, a circular wait condition could arise. The generator's A* reachability checker must reject any level layout with potential inter-board cyclic dependencies.

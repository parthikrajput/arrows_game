Source docs: phases/phase_13/06_UI_AND_QA_PHASE_13.md, phases/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §13, §14, ../../SCALING_TO_10000_LEVELS.md §10. Depends on: specs/tech/on-device-level-generation.md, specs/tech/phase-12-qa-and-rollout.md.

# Spec: Tech — Phase 13 QA, Release Prerequisites and Rollout

## Status
Draft

## Type
New Feature

## Goal
Establish the CI seed pre-validation pipeline, binary metadata compilation (`phase_13_meta.bin`), runtime performance budgets, Remote Config staged rollout flags, and QA verification checklist for Phase 13 (Levels 6001–6500).

## Current State
Design documented in `phases/phase_13/06_UI_AND_QA_PHASE_13.md`, `phases/phase_13/01_PHASE_13_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §10, not yet implemented.
- CI pipeline verified levels up to 6000 with `maxPhase = 12`.
- Phase 13 introduces fog-of-war visibility masks, requiring verification of zero-guessing solvability, visibility state persistence, and bundling `phase_13_meta.bin`.

## Proposed Change
Extend test harnesses, CI runners, and deployment configurations:

### 1. CI Pre-Validation Pipeline (Standard §12)
- **Deterministic Batch Generation:**
  - CI generates all 500 levels (L6001–6500) using the PRNG seed formula:
    $$\text{seed} = \text{xoshiro128**}(\text{levelNumber}, \text{phase} = 13)$$
- **Zero-Booster Headless Solver:**
  - Every seed must be solved by headless A* search with **0 hearts lost** and **0 boosters consumed**.
  - The solver is granted full omniscient visibility to verify topological solvability, while ensuring that scout snakes and long-press raycast probes yield adequate clues for human players.
  - Any seed exceeding search budgets ($> 50{,}000$ states evaluated or $> 500\text{ ms}$ solve latency) is regenerated with seed salt increments; persistent outliers are registered in `assets/levels/seed_overrides.json`.
- **Binary Metadata Compilation:**
  - Validated par moves, fog bitmasks, and SHA-256 level hashes are serialized into `assets/levels/phase_13_meta.bin` ($\approx 2.5\text{ KB}$ gzipped).

---

### 2. Runtime Performance Budgets (Standard §13)
- **On-Device Level Generation:**
  - High/Mid-Tier devices: $\le 150\text{ ms}$
  - Low-Tier devices (Android Go, 2GB RAM): $\le 250\text{ ms}$
- **Fog Alpha Rendering & Frame Rate:**
  - Full-screen fog masking must execute within $\le 2\text{ ms}$ GPU canvas time.
  - Low-Tier devices utilize fallback pre-baked alpha masks without multi-pass Gaussian blur.
  - Total puzzle core memory usage during continuous play: $\le 90\text{ MB}$ (Low-Tier), $\le 110\text{ MB}$ (Mid-Tier).
- **Frame Rate Target:** Stable 60 FPS across all tiers, min 50 FPS during full fog clearance animations on Low-Tier devices.

---

### 3. Remote Config & Staged Rollout Strategy
Rollout is governed by Firebase Remote Config parameters:
- `max_phase_unlocked`: Incremented from `12` to `13` according to the rollout schedule:
  - Day 1: Internal QA & Canary (1%)
  - Day 3: 5% staged rollout
  - Day 7: 25% staged rollout
  - Day 14: 100% full production rollout
- `phase_13_fog_default_opacity`: Double parameter (default `0.85`, range `0.5..1.0`) controlling base fog opacity for live tuning.

---

### 4. QA Verification Matrix (P13-QA-01 to P13-QA-10)
- [ ] **P13-QA-01 (M601 Scout Sweep):** Scout Gecko departure permanently clears fog along its path and a 1-cell radius.
- [ ] **P13-QA-02 (M602 Mist Immunity):** Trick mist never respawns on cells marked permanently revealed by a scout.
- [ ] **P13-QA-03 (M603 False Wall Pass):** Snakes pass through Painted Walls without obstruction or collision errors.
- [ ] **P13-QA-04 (M603 Preview Fairness):** Long-press raycast clearly penetrates False Walls, indicating passability before moving.
- [ ] **P13-QA-05 (M604 Glow Stone Area):** Resting on a Glow Stone illuminates a $3 \times 3$ area; leaving the stone re-shrouds un-scouted cells.
- [ ] **P13-QA-06 (Zero Damage in Fog):** Colliding with an un-scouted wall causes a harmless head-bonk with 0 hearts lost.
- [ ] **P13-QA-07 (Undo Fog State):** Tapping Undo restores previous move, snake positions, and exact fog visibility states.
- [ ] **P13-QA-08 (Level 6500 Finale):** Completing Level 6500 awards 1,000 coins, 6 boosters, Phase 13 profile badge, and unlocks Phase 14.
- [ ] **P13-QA-09 (Memory Leak Profile):** 50 consecutive fog level clears maintain stable heap below 120MB.
- [ ] **P13-QA-10 (CI Binary Verification):** `phase_13_meta.bin` integrity confirmed via checksum before release packaging.

## Affected Files
- `packages/puzzle_core/lib/src/tech/phase_13_meta_loader.dart` (to be created)
- `assets/levels/phase_13_meta.bin` (to be generated)
- `test/tech/phase_13_qa_test.dart` (to be created)
- `tool/ci/validate_phase_13_seeds.dart` (to be created)

## Risks and Open Questions
- **Undo Stack Fog Mask Synchronization:** When an undo command is received, the fog grid must restore prior visibility states without orphaned scout flags, ensuring that revoked moves do not grant permanent visibility advantages.

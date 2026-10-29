Source docs: phases/phase_9/06_UI_AND_QA_PHASE_9.md, phases/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §13, §14, ../../SCALING_TO_10000_LEVELS.md §10. Depends on: specs/tech/on-device-level-generation.md, specs/tech/phase-8-qa-and-rollout.md.

# Spec: Tech — Phase 9 QA, Release Prerequisites and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed pre-validation pipeline, binary metadata artifact generation (`phase_9_meta.bin`), runtime performance budgets, Remote Config staged rollout configuration, and comprehensive QA checklist for Phase 9 (Levels 4001–4500).

## Current State
Design documented in `phases/phase_9/06_UI_AND_QA_PHASE_9.md`, `phases/phase_9/01_PHASE_9_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §10, not yet implemented.
- CI and build tooling previously covered up to Phase 8 with `maxPhase = 8`.
- Phase 9 introduces dynamic entity decomposition and synthesis, requiring verification of state reversible simulation, entity pool lifecycle, and seed metadata generation for Levels 4001–4500.

## Proposed Change
Extend test harnesses, CI runners, and deployment configurations:

### 1. CI Pre-Validation Pipeline (Standard §12)
- **Deterministic Batch Generation:**
  - CI generates all 500 levels (L4001–4500) using the PRNG seed formula:
    $$\text{seed} = \text{xoshiro128**}(\text{levelNumber}, \text{phase} = 9)$$
- **Zero-Booster Headless Solver:**
  - Every seed must be solved by headless A* search with **0 hearts lost** and **0 boosters consumed**.
  - Any seed exceeding search budgets ($> 50{,}000$ states evaluated or $> 500\text{ ms}$ solve latency) is regenerated with seed salt increments; persistent outliers are registered in `assets/levels/seed_overrides.json`.
- **Binary Metadata Compilation:**
  - Validated par moves, entity counts, and SHA-256 level hashes are serialized into `assets/levels/phase_9_meta.bin` ($\approx 2.5\text{ KB}$ gzipped).

---

### 2. Runtime Performance Budgets (Standard §13)
- **On-Device Level Generation:**
  - High/Mid-Tier devices: $\le 150\text{ ms}$
  - Low-Tier devices (Android Go, 2GB RAM): $\le 250\text{ ms}$
- **Entity Pool & Heap Headroom:**
  - Dynamic snake allocation for bifurcated entities must utilize pooled object instances to ensure zero garbage collection spikes during move execution.
  - Total puzzle core memory usage during continuous play: $\le 90\text{ MB}$ (Low-Tier), $\le 110\text{ MB}$ (Mid-Tier).
- **Frame Rate Target:** Stable 60 FPS across all tiers, min 50 FPS under simultaneous split particle bursts on Low-Tier devices.

---

### 3. Remote Config & Staged Rollout Strategy
Rollout is governed by Firebase Remote Config parameters:
- `max_phase_unlocked`: Incremented from `8` to `9` according to the rollout schedule:
  - Day 1: Internal QA & Canary (1%)
  - Day 3: 5% staged rollout
  - Day 7: 25% staged rollout
  - Day 14: 100% full production rollout
- `phase_9_split_preview_enabled`: Boolean flag (default `true`) allowing kill-switch disablement of ghost trajectory dots if shader performance issues arise.

---

### 4. QA Verification Matrix (P9-QA-01 to P9-QA-10)
- [ ] **P9-QA-01 (M401 Head Alignment):** Both snake heads must firmly occupy adjacent Hug Pad cells before merger fires.
- [ ] **P9-QA-02 (M401 Segment Stitching):** Resulting merged snake length must strictly equal $A_{\text{len}} + B_{\text{len}}$.
- [ ] **P9-QA-03 (M402 Dual-Path Clearance):** Obstructed left or right exit path halts snake at stump with 0 hearts deducted.
- [ ] **P9-QA-04 (M402 Odd Split Parity):** Length-5 snake splits precisely into 3-segment and 2-segment entities.
- [ ] **P9-QA-05 (M403 Bead Counting):** Every exiting body segment increments the Bead Lock meter by 1 until target reached.
- [ ] **P9-QA-06 (M404 Reunion Trigger):** Reunion Gate opens if and only if both split child halves have exited the board.
- [ ] **P9-QA-07 (Undo/Redo Integrity):** Reversing a split move merges children seamlessly back into the parent entity without orphaned IDs.
- [ ] **P9-QA-08 (Level 4500 Finale):** Completing Level 4500 grants 1,000 coins, 6 boosters, Phase 9 profile badge, and unlocks Phase 10.
- [ ] **P9-QA-09 (Memory Leak Profile):** 50 continuous split/merge level completions maintain stable heap below 120MB.
- [ ] **P9-QA-10 (CI Binary Verification):** `phase_9_meta.bin` integrity confirmed via checksum before release packaging.

## Affected Files
- `packages/puzzle_core/lib/src/tech/phase_9_meta_loader.dart` (to be created)
- `assets/levels/phase_9_meta.bin` (to be generated)
- `test/tech/phase_9_qa_test.dart` (to be created)
- `tool/ci/validate_phase_9_seeds.dart` (to be created)

## Risks and Open Questions
- **Undo Stack Complexity:** Dynamic entity allocation (splitting 1 snake into 2) requires undo snapshots to capture dynamic ID life cycles and reinstantiate the original single entity without breaking references in move history.

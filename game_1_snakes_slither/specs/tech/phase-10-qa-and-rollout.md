Source docs: phases/phase_10/06_UI_AND_QA_PHASE_10.md, phases/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §13, §14, ../../SCALING_TO_10000_LEVELS.md §10. Depends on: specs/tech/on-device-level-generation.md, specs/tech/phase-9-qa-and-rollout.md.

# Spec: Tech — Phase 10 QA, Release Prerequisites and Rollout

## Status
Draft

## Type
New Feature

## Goal
Establish the CI seed pre-validation pipeline, binary metadata compilation (`phase_10_meta.bin`), runtime performance budgets, Remote Config staged rollout flags, and QA test checklist for Phase 10 (Levels 4501–5000), celebrating the halfway milestone of the game.

## Current State
Design documented in `phases/phase_10/06_UI_AND_QA_PHASE_10.md`, `phases/phase_10/01_PHASE_10_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §10, not yet implemented.
- CI pipeline previously verified seeds up to Level 4500 with `maxPhase = 9`.
- Phase 10 requires extending the test harness for Levels 4501–5000, validating move-modulo rhythm determinism, verifying exit history buffer integrity, and bundling `phase_10_meta.bin`.

## Proposed Change
Extend test harnesses, CI runners, and deployment configurations:

### 1. CI Pre-Validation Pipeline (Standard §12)
- **Deterministic Batch Generation:**
  - CI generates all 500 levels (L4501–5000) using the PRNG seed formula:
    $$\text{seed} = \text{xoshiro128**}(\text{levelNumber}, \text{phase} = 10)$$
- **Zero-Booster Headless Solver:**
  - Every seed must be solved by headless A* search with **0 hearts lost** and **0 boosters consumed**.
  - Any seed exceeding search budgets ($> 50{,}000$ states evaluated or $> 500\text{ ms}$ solve latency) is regenerated with seed salt increments; persistent outliers are registered in `assets/levels/seed_overrides.json`.
- **Binary Metadata Compilation:**
  - Validated par moves, parade indices, and SHA-256 level hashes are serialized into `assets/levels/phase_10_meta.bin` ($\approx 2.5\text{ KB}$ gzipped).

---

### 2. Runtime Performance Budgets (Standard §13)
- **On-Device Level Generation:**
  - High/Mid-Tier devices: $\le 150\text{ ms}$
  - Low-Tier devices (Android Go, 2GB RAM): $\le 250\text{ ms}$
- **Buffer Memory & Audio Pool:**
  - Exit history buffer memory footprint: $< 4\text{ KB}$ heap allocation.
  - Total puzzle core memory usage during continuous play: $\le 90\text{ MB}$ (Low-Tier), $\le 110\text{ MB}$ (Mid-Tier).
- **Frame Rate Target:** Stable 60 FPS across all tiers, min 50 FPS under Level 5000 halfway celebration VFX on Low-Tier devices.

---

### 3. Remote Config & Staged Rollout Strategy
Rollout is governed by Firebase Remote Config parameters:
- `max_phase_unlocked`: Incremented from `9` to `10` according to the rollout schedule:
  - Day 1: Internal QA & Canary (1%)
  - Day 3: 5% staged rollout
  - Day 7: 25% staged rollout
  - Day 14: 100% full production rollout
- `phase_10_rhythm_lookahead_beats`: Integer parameter (default `2`, range `1..4`) controlling how many forward beats are shown in the rhythm HUD.

---

### 4. QA Verification Matrix (P10-QA-01 to P10-QA-10)
- [ ] **P10-QA-01 (M451 Move Modulo):** Drum Gate toggles states strictly upon player move increment based on $\text{Move} \pmod L$.
- [ ] **P10-QA-02 (M451 Zero Damage):** Attempting to cross a closed Drum Gate results in a harmless bonk with 0 hearts lost.
- [ ] **P10-QA-03 (M452 Totem History Match):** Totem Gate unlocks if and only if the last $k$ exited snakes match target color sequence.
- [ ] **P10-QA-04 (M452 Buffer Reset):** Intervening exit of an incorrect color resets matching progress without deducting hearts.
- [ ] **P10-QA-05 (M453 Parade Sequence):** Only the lowest un-cleared badge number can exit through the Parade Gate; out-of-order attempts are safely rejected.
- [ ] **P10-QA-06 (M454 Echo Invariance):** Group B gate unlocks only after Group A clears, and rejects any departure that deviates from Group A's departure order.
- [ ] **P10-QA-07 (Undo Integrity):** Reversing a move correctly decrements the move counter, restores previous Drum Gate state, and rolls back the exit buffer.
- [ ] **P10-QA-08 (Level 5000 Halfway Milestone):** Completing Level 5000 triggers the halfway milestone cinematic, awards 2,000 coins, 9 boosters, and unlocks Phase 11.
- [ ] **P10-QA-09 (Memory Leak Profile):** 50 consecutive level clears maintain stable heap below 120MB.
- [ ] **P10-QA-10 (CI Binary Verification):** `phase_10_meta.bin` integrity confirmed via checksum before release packaging.

## Affected Files
- `packages/puzzle_core/lib/src/tech/phase_10_meta_loader.dart` (to be created)
- `assets/levels/phase_10_meta.bin` (to be generated)
- `test/tech/phase_10_qa_test.dart` (to be created)
- `tool/ci/validate_phase_10_seeds.dart` (to be created)

## Risks and Open Questions
- **Undo Operation on FIFO Buffers:** Undoing an exit move must pop the last record from the `ExitHistoryBuffer` and reinsert the snake entity onto the board with its original position and orientation, ensuring deterministic state rollback.

Source docs: phases/phase_8/06_UI_AND_QA_PHASE_8.md, phases/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §13, §14, ../../SCALING_TO_10000_LEVELS.md §10. Depends on: specs/tech/on-device-level-generation.md, specs/tech/phase-7-qa-and-rollout.md.

# Spec: Tech — Phase 8 QA, Release Prerequisites and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed validation suite, metadata artifact compilation (`phase_8_meta.bin`), runtime performance budgets, Remote Config staged rollout flags, and QA test checklist for Phase 8 (Levels 3501–4000).

## Current State
Design documented in `phases/phase_8/06_UI_AND_QA_PHASE_8.md`, `phases/phase_8/01_PHASE_8_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §10, not yet implemented.
- Phase 7 pipeline bundled levels up to 3500 with `maxPhase = 7`.
- Phase 8 requires extending the CI pre-validation suite for Levels 3501–4000, checking growth sprawl determinism, and bundling Phase 8 metadata.

## Proposed Change
Extend build tools and test suites for Phase 8 verification and staged rollout:

### 1. CI Pre-Validation Pipeline (Standard §12)
- **Batch Generation:** CI generates all 500 levels (L3501–4000) using the PRNG seed formula:
  $$\text{seed} = \text{xoshiro128**}(\text{levelNumber}, \text{phase} = 8)$$
- **Automated Solver Verification:**
  - Every level must be solvable by the IDA* engine with **0 Hearts lost** and **0 Boosters required**.
  - Par moves and optimal solution paths are compiled into binary format.
  - Generation failures or timeouts ($> 2,000,000$ IDA* nodes) trigger $k$-retry increments; persistent outliers are hardcoded into `seed_overrides.json`.
- **Binary Metadata Compilation:**
  - Validated par moves and checksums are serialized into `assets/levels/phase_8_meta.bin` ($\approx 2.5\text{ KB}$ gzipped).

---

### 2. Cross-Platform Determinism Verification
- Run generation and solver suites on:
  1. Linux CI x64 runner
  2. Android ARM64 emulator / device farm
  3. iOS Simulator / TestFlight build
- **Acceptance Criteria:** Bit-exact SHA-256 hash match for all generated level JSON representations across all platforms.

---

### 3. Performance Budgets & Device Profiling (Standard §13)
- **Growth Tick Calculation:** U->R->D->L neighbor searches and vine allocations must resolve in $\le 1\text{ ms}$ on 2 GB RAM Android devices.
- **On-Device Level Generation:** Level generation must complete in $\le 300\text{ ms}$ (mid-tier) and $\le 800\text{ ms}$ (low-tier).
- **Peak Memory:** Resident memory heap increase during growth simulation must remain $< 3\text{ MB}$.

---

### 4. Remote Config & Staged Rollout
- **Rollout Key:** `maxPhase`
- **Configuration Values:**
  - `maxPhase = 7`: Phase 8 content locked behind "Coming Soon" garden gates.
  - `maxPhase = 8`: Phase 8 unlocked globally; Level 3501 becomes accessible immediately upon clearing Level 3500.
- **Rollout Schedule:**
  - 10% pilot rollout on Day 1.
  - 50% rollout on Day 3 (monitoring crash rate $< 0.1\%$ and ANR $< 0.05\%$).
  - 100% full production rollout on Day 5.

---

### 5. Master QA Test Matrix (Phase 8)

| Test ID | Area | Verification Description | Expected Result | Status |
|---|---|---|---|---|
| **P8-QA-01** | Vine Neighbor Search | Wild vine spreads on move $N$ | Expands strictly in U->R->D->L priority order into first 2 free floor cells | Not run |
| **P8-QA-02** | Snake Collision Guard | Vine attempts to spread onto snake body | Spread onto snake cell is rejected; evaluates next valid direction | Not run |
| **P8-QA-03** | Growth Cap | Vine reaches `maxCells = 8` | Growth halts permanently for remainder of level attempt | Not run |
| **P8-QA-04** | Pruning Pulse | Exiting snake traverses M352 Pruner Tile | All adjacent orthogonal vines ($r \le 1$) are severed and cleared | Not run |
| **P8-QA-05** | Seed Pod Trample | Snake traverses active Seed Pod | Pod is crushed and destroyed; does not sprout | Not run |
| **P8-QA-06** | Seed Pod Sprout | Seed Pod timer reaches 0 untrampled | Pod bursts and spawns new Wild Vine blocker | Not run |
| **P8-QA-07** | Bloom Gate Unlock | All linked vines eliminated | M354 Bloom Gate immediately unlocks and clears path | Not run |
| **P8-QA-08** | Determinism | Seed re-generation across devices | Exact identical board layout and solver parity across Android/iOS/CI | Not run |
| **P8-QA-09** | Phase Finale | Complete Level 4000 | 1,000 coins + 6 boosters + Phase 8 Badge correctly awarded | Not run |

## Affected Files
- `test/phases/phase_8_determinism_test.dart` — to be created
- `test/phases/phase_8_solver_test.dart` — to be created
- `tool/ci/generate_phase_8_metadata.dart` — to be created

## Risks and Open Questions
- None. Fully compliant with all specifications.


Source docs: phases/phase_7/06_UI_AND_QA_PHASE_7.md, phases/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §13, §14, ../../SCALING_TO_10000_LEVELS.md §10. Depends on: specs/tech/on-device-level-generation.md, specs/tech/phase-6-qa-and-rollout.md.

# Spec: Tech — Phase 7 QA, Release Prerequisites and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed validation suite, metadata artifact compilation (`phase_7_meta.bin`), runtime performance budgets, Remote Config staged rollout flags, and QA test checklist for Phase 7 (Levels 3001–3500).

## Current State
Design documented in `phases/phase_7/06_UI_AND_QA_PHASE_7.md`, `phases/phase_7/01_PHASE_7_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §10, not yet implemented.
- Phase 6 pipeline bundled levels up to 3000 with `maxPhase = 6`.
- Phase 7 requires extending the CI pre-validation suite for Levels 3001–3500, checking rotation matrix determinism, and bundling Phase 7 metadata.

## Proposed Change
Extend build tools and test suites for Phase 7 verification and staged rollout:

### 1. CI Pre-Validation Pipeline (Standard §12)
- **Batch Generation:** CI generates all 500 levels (L3001–3500) using the PRNG seed formula:
  $$\text{seed} = \text{xoshiro128**}(\text{levelNumber}, \text{phase} = 7)$$
- **Automated Solver Verification:**
  - Every level must be solvable by the IDA* engine with **0 Hearts lost** and **0 Boosters required**.
  - Par moves and optimal solution paths are compiled into binary format.
  - Generation failures or timeouts ($> 2,000,000$ IDA* nodes) trigger $k$-retry increments; persistent outliers are hardcoded into `seed_overrides.json`.
- **Binary Metadata Compilation:**
  - Validated par moves and checksums are serialized into `assets/levels/phase_7_meta.bin` ($\approx 2.5\text{ KB}$ gzipped).

---

### 2. Cross-Platform Determinism Verification
- Run generation and solver suites on:
  1. Linux CI x64 runner
  2. Android ARM64 emulator / device farm
  3. iOS Simulator / TestFlight build
- **Acceptance Criteria:** Bit-exact SHA-256 hash match for all generated level JSON representations across all platforms.

---

### 3. Performance Budgets & Device Profiling (Standard §13)
- **Rotation Transform:** 4×4 sub-board rotation must execute smoothly at **60 FPS** without garbage collection hiccups or texture allocation stutters.
- **On-Device Level Generation:** Level generation must complete in $\le 300\text{ ms}$ (mid-tier) and $\le 800\text{ ms}$ (low-tier).
- **Peak Memory:** Resident memory heap increase during rotation must remain $< 5\text{ MB}$.

---

### 4. Remote Config & Staged Rollout
- **Rollout Key:** `maxPhase`
- **Configuration Values:**
  - `maxPhase = 6`: Phase 7 content locked behind "Coming Soon" valley gates.
  - `maxPhase = 7`: Phase 7 unlocked globally; Level 3001 becomes accessible immediately upon clearing Level 3000.
- **Rollout Schedule:**
  - 10% pilot rollout on Day 1.
  - 50% rollout on Day 3 (monitoring crash rate $< 0.1\%$ and ANR $< 0.05\%$).
  - 100% full production rollout on Day 5.

---

### 5. Master QA Test Matrix (Phase 7)

| Test ID | Area | Verification Description | Expected Result | Status |
|---|---|---|---|---|
| **P7-QA-01** | Partial Snake Lock | Snake straddles 4×4 rotor boundary | Rotor handle produces Locked Tap; 0 hearts lost; 0 moves spent | Not run |
| **P7-QA-02** | Sub-board Rotation | Valid rotor handle tapped | All completely enclosed snakes rotate coordinates and `dir` 90° CW | Not run |
| **P7-QA-03** | Tangled Invariant | Rotated snake heading points into own body | Snake enters Tangled state; tapping yields locked tap (no damage) | Not run |
| **P7-QA-04** | Border Shift | Player executes any valid move | M302 Turning Hedges advance 1 cell clockwise along border track | Not run |
| **P7-QA-05** | Spinning Snake | Player executes any valid move | M303 Spinning Snake heading direction automatically pivots 90° CW | Not run |
| **P7-QA-06** | Gear Alignment | Rotor set to target angle vs other angles | M304 Gear Lock opens only at exact `unlockAngle`; blocks at other angles | Not run |
| **P7-QA-07** | Determinism | Seed re-generation across devices | Exact identical board layout and solver parity across Android/iOS/CI | Not run |
| **P7-QA-08** | 0-Heart Guarantee | IDA* solver replay across all 500 levels | 100% win rate with 0 hearts lost and 0 boosters used | Not run |
| **P7-QA-09** | Phase Finale | Complete Level 3500 | 1,000 coins + 6 boosters + Phase 7 Badge correctly awarded | Not run |

## Affected Files
- `test/phases/phase_7_determinism_test.dart` — to be created
- `test/phases/phase_7_solver_test.dart` — to be created
- `tool/ci/generate_phase_7_metadata.dart` — to be created

## Risks and Open Questions
- None. Meets all performance and quality standards.


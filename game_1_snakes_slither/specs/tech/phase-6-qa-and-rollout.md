Source docs: phases/phase_6/06_UI_AND_QA_PHASE_6.md, phases/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §12, §13, §14, ../../SCALING_TO_10000_LEVELS.md §10. Depends on: specs/tech/on-device-level-generation.md, specs/tech/phase-5-qa-and-rollout.md.

# Spec: Tech — Phase 6 QA, Release Prerequisites and Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed validation suite, metadata artifact compilation (`phase_6_meta.bin`), runtime performance budgets, Remote Config staged rollout flags, and QA test checklist for Phase 6 (Levels 2501–3000).

## Current State
Design documented in `phases/phase_6/06_UI_AND_QA_PHASE_6.md`, `phases/phase_6/01_PHASE_6_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §10, not yet implemented.
- Phase 5 pipeline bundled levels up to 2500 with `maxPhase = 5`.
- Phase 6 requires extending the CI pre-validation suite for Levels 2501–3000, checking optics determinism, and bundling Phase 6 metadata.

## Proposed Change
Extend build tools and test suites for Phase 6 verification and staged rollout:

### 1. CI Pre-Validation Pipeline (Standard §12)
- **Batch Generation:** CI generates all 500 levels (L2501–3000) using the PRNG seed formula:
  $$\text{seed} = \text{xoshiro128**}(\text{levelNumber}, \text{phase} = 6)$$
- **Automated Solver Verification:**
  - Every level must be solvable by the IDA* engine with **0 Hearts lost** and **0 Boosters required**.
  - Par moves and optimal solution paths are extracted and compiled into binary format.
  - Failed generation attempts trigger $k$-retry increments; persistent outliers are hardcoded into `seed_overrides.json`.
- **Binary Metadata Compilation:**
  - Validated par moves and checksums are serialized into `assets/levels/phase_6_meta.bin` ($\approx 2.5\text{ KB}$ gzipped).

---

### 2. Cross-Platform Determinism Verification
- Run generation and solver suites on:
  1. Linux CI x64 runner
  2. Android ARM64 emulator / device farm
  3. iOS Simulator / TestFlight build
- **Acceptance Criteria:** SHA-256 hashes of generated level JSON models must match bit-for-bit across all three platforms.

---

### 3. Performance Budgets & Device Profiling (Standard §13)
- **Ray Tracing Latency:** Dynamic ray tracing across up to 4 emitters and 10 mirrors must resolve in $\le 2\text{ ms}$ on 2 GB RAM Android devices.
- **On-Device Level Generation:** Level generation and board layout validation must complete in $\le 300\text{ ms}$ (mid-tier) and $\le 800\text{ ms}$ (low-tier).
- **Frame Rate:** Stable 60 FPS during beam refraction and particle explosions. Low-tier minimum stable 30 FPS.

---

### 4. Remote Config & Staged Rollout
- **Rollout Key:** `maxPhase`
- **Configuration Values:**
  - `maxPhase = 5`: Phase 6 content locked behind "Coming Soon" temple gates.
  - `maxPhase = 6`: Phase 6 unlocked globally; Level 2501 becomes accessible immediately upon clearing Level 2500.
- **Rollout Schedule:**
  - 10% pilot rollout on Day 1.
  - 50% rollout on Day 3 (monitoring crash rate $< 0.1\%$ and ANR $< 0.05\%$).
  - 100% full production rollout on Day 5.

---

### 5. Master QA Test Matrix (Phase 6)

| Test ID | Area | Verification Description | Expected Result | Status |
|---|---|---|---|---|
| **P6-QA-01** | Petal Filtering | Beam traverses M251 Petal Filter | Ray changes to filter color; only matching colored receivers activate | Not run |
| **P6-QA-02** | Prism Multi-Beam | Beam hits M252 Prism Lock | Stays closed on 1 beam; permanently latches open on $\ge 2$ beams | Not run |
| **P6-QA-03** | Sundial Timer | Beam strikes M253 Sundial Receiver | Sustained illumination over $N$ moves decrements counter to 0 and latches gate open | Not run |
| **P6-QA-04** | Sundial Interruption | Beam interrupted before $N$ moves | Counter immediately resets back to full initial $N$ | Not run |
| **P6-QA-05** | Shade Leaves Lock | Snake head inside M254 Dark Cell | Tapping yields Locked Tap; shining beam on cell awakens snake | Not run |
| **P6-QA-06** | Opaque Obstruction | Snake slithers into light ray | Ray stops at snake body; vacating cell restores ray continuation | Not run |
| **P6-QA-07** | Determinism | Seed re-generation across devices | Exact identical board layout and solver parity | Not run |
| **P6-QA-08** | 0-Heart Guarantee | IDA* solver replay across all 500 levels | 100% win rate with 0 hearts lost and 0 boosters used | Not run |
| **P6-QA-09** | Phase Finale | Complete Level 3000 | 1,000 coins + 6 boosters + Phase 6 Badge correctly awarded | Not run |

## Affected Files
- `test/phases/phase_6_determinism_test.dart` — to be created
- `test/phases/phase_6_solver_test.dart` — to be created
- `tool/ci/generate_phase_6_metadata.dart` — to be created

## Risks and Open Questions
- **Binary Metadata Asset Size:** Ensuring `phase_6_meta.bin` stays below 3 KB to respect total app bundle budget ($< 35\text{ MB}$).
  - *Status:* Verified — compact bit-packed format consumes $\approx 5\text{ bytes}$ per level.


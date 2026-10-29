Source docs: phase/phase_10/06_UI_AND_QA_PHASE_10.md, phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3–§5. Depends on: specs/tech/frontend-and-qa-phase-2.md, specs/tech/on-device-level-generation.md, specs/gameplay/phase-10-signature-system.md.

# Spec: Tech — Phase 10 QA Matrix & Release Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed pre-validation pipeline, binary metadata shipping (`phase_10_meta.bin`), rhythmic sequence engine performance benchmarks, Remote Config staged rollout strategy, and QA verification checklist for Yarn Unravel Phase 10 (Levels 4501–5000).

## Current State
Design documented in `phase/phase_10/06_UI_AND_QA_PHASE_10.md` and `phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 9 handled multi-ply entity mutations.
- Phase 10 introduces chronological exit ordering and periodic rhythm gates, requiring validation of acyclic sequence prerequisite chains and 60 fps performance under multi-gate configurations.

## Proposed Change
Build the Phase 10 CI verification suite and release gatekeeper:

### 1. CI Seed Pre-Validation Pipeline
- `tools/levelgen` runs a headless batch job evaluating all 500 levels in Phase 10 ($L \in [4501, 5000]$):
  1. Computes initial seed: `seed = hash64("yarn_unravel", level, 10)`.
  2. Evaluates attempt $k \in [0, 63]$.
  3. Solves constrained sequential exit permutations via IDA* solver, verifying zero-heart solvability.
  4. If attempt $k > 0$ is required, records entry in `assets/levels/seed_overrides.json`.
  5. Computes and serializes metadata into `assets/levels/phase_10_meta.bin`.

### 2. Shipped Metadata Binary (`phase_10_meta.bin`)
Compact 16-byte binary record per level (500 levels $\times$ 16 bytes = 8 KB total):
```
[2B level][1B k_override][1B par_moves][2B difficulty_x10][1B rhythm_gate_count][1B clasp_count][4B crc32][4B reserved]
```
- Shipped directly inside the app bundle.
- Eliminates on-device solver calculation for par moves and hint assistance.

### 3. Generator & Sequence Engine Performance Budgets
Tested on low-tier reference hardware (DM-1: 2 GB RAM, Quad-Core A53):
- **Generation Latency:** $\le 15\text{ ms}$ per level.
- **Isolate Thread Execution:** Generator runs in background isolate `compute()`, zero UI frame hitching.
- **Sequence Evaluation:** Order validation and rhythm state derivation $\le 1\text{ ms}$ per player move.
- **Frame Rate:** Maintains steady 60 fps on a 14×14 grid with 4 metronome gates, 3 pattern clasps, and 40 threads.

### 4. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer, default `9`).
- **Gating Logic:**
  - `maxPhase < 10`: Levels 4501+ display "Pattern Book Coming Soon!" teaser modal.
  - `maxPhase >= 10`: Automatically unlocks Level 4501 provided Level 4500 is cleared.
- **Staged Rollout Schedule:**
  - Internal QA: 100% staging.
  - Day 1: 5% production roll.
  - Day 3: 20% production roll.
  - Day 7: 100% full release.

### 5. Phase 10 QA Checklist
Checklist executed across all devices in the test matrix:

| QA ID | Category | Test Condition & Expected Outcome | Status |
|---|---|---|---|
| **QA-P10-01** | Metronome Gate | Metronome gate oscillates according to assigned periodic move pattern; acts as solid blocker in closed phase. | Not run |
| **QA-P10-02** | Pattern Clasp | Clasp unlocks permanently only when unraveled threads match its required chronological color sequence. | Not run |
| **QA-P10-03** | Ordered Hem | Threads attempting to exit through ordered hem out of numerical sequence trigger snag collision (-1 Heart). | Not run |
| **QA-P10-04** | Echo Card | Echo card records first $k$ colors; subsequent $k$ threads must repeat identical color sequence to proceed. | Not run |
| **QA-P10-05** | Solvability | All 500 levels (4501–5000) verified 100% solvable with 0 hearts lost and 0 boosters used. | Not run |
| **QA-P10-06** | Performance | Low-tier reference device (DM-1) maintains steady 60 fps with 4 rhythm gates and 40 threads on 14×14 grid. | Not run |
| **QA-P10-07** | Rollout | Remote Config `maxPhase = 9` gates Level 4501; incrementing to `10` unlocks cleanly. | Not run |
| **QA-P10-08** | Finale | L4991 Review level and L5000 Finale "The Master Pattern" generate and play properly, granting Grand Sewing Chest. | Not run |

## Affected Files
- `tools/levelgen/bin/prevalidate_phase10.dart` (to be created: CI seed batch validator)
- `assets/levels/phase_10_meta.bin` (to be created: 8 KB binary metadata)
- `lib/features/level_map/bloc/map_cubit.dart` (changed: integrate `maxPhase = 10` gate)

## Risks
- Cyclic deadlocks where sequence requirements require threads locked behind un-unlocked clasps. Mitigated by strict topological sort validation during reverse construction.

## Open Questions
None. Sequence engine performance benchmarks and QA matrix match Phase 10 design specifications.

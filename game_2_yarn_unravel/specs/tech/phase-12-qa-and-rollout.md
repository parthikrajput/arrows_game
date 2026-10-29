Source docs: phase/phase_12/06_UI_AND_QA_PHASE_12.md, phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3–§5. Depends on: specs/tech/frontend-and-qa-phase-2.md, specs/tech/on-device-level-generation.md, specs/gameplay/phase-12-signature-system.md.

# Spec: Tech — Phase 12 QA Matrix & Release Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed pre-validation pipeline, binary metadata shipping (`phase_12_meta.bin`), gravity physics performance benchmarks, Remote Config staged rollout strategy, and QA verification checklist for Yarn Unravel Phase 12 (Levels 5501–6000).

## Current State
Design documented in `phase/phase_12/06_UI_AND_QA_PHASE_12.md` and `phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 11 handled dual-canvas cross-hoop transitions.
- Phase 12 introduces dynamic 4-way gravity physics, requiring validation of sliding obstacle resting points, weighted thread translations, and 60 fps performance under multi-body physics sweeps.

## Proposed Change
Build the Phase 12 CI verification suite and release gatekeeper:

### 1. CI Seed Pre-Validation Pipeline
- `tools/levelgen` runs a headless batch job evaluating all 500 levels in Phase 12 ($L \in [5501, 6000]$):
  1. Computes initial seed: `seed = hash64("yarn_unravel", level, 12)`.
  2. Evaluates attempt $k \in [0, 63]$.
  3. Solves dynamic multi-directional gravity trees via IDA* solver, verifying zero-heart solvability.
  4. If attempt $k > 0$ is required, records entry in `assets/levels/seed_overrides.json`.
  5. Computes and serializes metadata into `assets/levels/phase_12_meta.bin`.

### 2. Shipped Metadata Binary (`phase_12_meta.bin`)
Compact 16-byte binary record per level (500 levels $\times$ 16 bytes = 8 KB total):
```
[2B level][1B k_override][1B par_moves][2B difficulty_x10][1B lever_count][1B button_count][4B crc32][4B reserved]
```
- Shipped directly inside the app bundle.
- Eliminates on-device solver calculation for par moves and hint assistance.

### 3. Generator & Gravity Physics Performance Budgets
Tested on low-tier reference hardware (DM-1: 2 GB RAM, Quad-Core A53):
- **Generation Latency:** $\le 15\text{ ms}$ per level.
- **Isolate Thread Execution:** Generator runs in background isolate `compute()`, zero UI frame hitching.
- **Gravity Step Calculation:** Multi-button ray-cast sliding $\le 1\text{ ms}$ per player move.
- **Frame Rate:** Maintains steady 60 fps on a 14×14 grid with 2 plumb levers, 6 sliding buttons, 4 weighted threads, and 40 threads total.

### 4. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer, default `11`).
- **Gating Logic:**
  - `maxPhase < 12`: Levels 5501+ display "Hanging Loom Coming Soon!" teaser modal.
  - `maxPhase >= 12`: Automatically unlocks Level 5501 provided Level 5500 is cleared.
- **Staged Rollout Schedule:**
  - Internal QA: 100% staging.
  - Day 1: 5% production roll.
  - Day 3: 20% production roll.
  - Day 7: 100% full release.

### 5. Phase 12 QA Checklist
Checklist executed across all devices in the test matrix:

| QA ID | Category | Test Condition & Expected Outcome | Status |
|---|---|---|---|
| **QA-P12-01** | Plumb Lever | Tapping plumb lever shifts gravity to the next clockwise direction in 1 move; plumb needle animates smoothly. | Not run |
| **QA-P12-02** | Dropping Buttons | Loose buttons slide along active gravity until colliding with obstacle or border; act as solid blockers when stopped. | Not run |
| **QA-P12-03** | Float Patch | Objects situated on Float Patch remain completely stationary and immune to gravity direction shifts. | Not run |
| **QA-P12-04** | Weighted Thread | Heavy wire thread translates 1 cell in gravity direction at end of each valid move if destination cells are empty. | Not run |
| **QA-P12-05** | Solvability | All 500 levels (5501–6000) verified 100% solvable with 0 hearts lost and 0 boosters used. | Not run |
| **QA-P12-06** | Performance | Low-tier reference device (DM-1) maintains steady 60 fps during multi-button gravity cascades on 14×14 grid. | Not run |
| **QA-P12-07** | Rollout | Remote Config `maxPhase = 11` gates Level 5501; incrementing to `12` unlocks cleanly. | Not run |
| **QA-P12-08** | Finale | L5991 Review level and L6000 Finale "The Plumb Line Tapestry" generate and play properly, granting Grand Sewing Chest. | Not run |

## Affected Files
- `tools/levelgen/bin/prevalidate_phase12.dart` (to be created: CI seed batch validator)
- `assets/levels/phase_12_meta.bin` (to be created: 8 KB binary metadata)
- `lib/features/level_map/bloc/map_cubit.dart` (changed: integrate `maxPhase = 12` gate)

## Risks
- Unexpected cyclic button loops during multi-directional shifts. Mitigated by synchronous resting state enforcement within Step 4.

## Open Questions
None. Gravity performance benchmarks and QA matrix match Phase 12 design specifications.

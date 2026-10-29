Source docs: phase/phase_11/06_UI_AND_QA_PHASE_11.md, phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3–§5. Depends on: specs/tech/frontend-and-qa-phase-2.md, specs/tech/on-device-level-generation.md, specs/gameplay/phase-11-signature-system.md.

# Spec: Tech — Phase 11 QA Matrix & Release Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed pre-validation pipeline, binary metadata shipping (`phase_11_meta.bin`), dual-canvas runtime performance benchmarks, Remote Config staged rollout strategy, and QA verification checklist for Yarn Unravel Phase 11 (Levels 5001–5500).

## Current State
Design documented in `phase/phase_11/06_UI_AND_QA_PHASE_11.md` and `phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 10 handled chronological sequence execution on a single grid.
- Phase 11 introduces concurrent dual mini-board canvases (Twin Hoops), requiring validation of cross-board dependency DAGs, seam transition parity, and 60 fps rendering on low-tier mobile hardware.

## Proposed Change
Build the Phase 11 CI verification suite and release gatekeeper:

### 1. CI Seed Pre-Validation Pipeline
- `tools/levelgen` runs a headless batch job evaluating all 500 levels in Phase 11 ($L \in [5001, 5500]$):
  1. Computes initial seed: `seed = hash64("yarn_unravel", level, 11)`.
  2. Synthesizes dual mini hoops (Hoop A and Hoop B) with cross-board seam and portal links.
  3. Evaluates attempt $k \in [0, 63]$.
  4. Solves cross-board dependency graphs via IDA* multi-board solver, verifying zero-heart solvability.
  5. If attempt $k > 0$ is required, records entry in `assets/levels/seed_overrides.json`.
  6. Computes and serializes metadata into `assets/levels/phase_11_meta.bin`.

### 2. Shipped Metadata Binary (`phase_11_meta.bin`)
Compact 16-byte binary record per level (500 levels $\times$ 16 bytes = 8 KB total):
```
[2B level][1B k_override][1B par_moves][2B difficulty_x10][1B seam_count][1B portal_count][4B crc32][4B reserved]
```
- Shipped directly inside the app bundle.
- Eliminates on-device solver calculation for par moves and hint assistance.

### 3. Generator & Dual-Board Performance Budgets
Tested on low-tier reference hardware (DM-1: 2 GB RAM, Quad-Core A53):
- **Generation Latency:** $\le 15\text{ ms}$ per level.
- **Isolate Thread Execution:** Generator runs in background isolate `compute()`, zero UI frame hitching.
- **Dual-Board Rasterization:** Dual-canvas layout maintains $60\text{ fps}$ and raster frame times $\le 8\text{ ms}$.
- **Memory Footprint:** Total Resident Set Size (RSS) $\le 220\text{ MB}$ during active dual-board gameplay.

### 4. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer, default `10`).
- **Gating Logic:**
  - `maxPhase < 11`: Levels 5001+ display "Twin Hoops Coming Soon!" teaser modal.
  - `maxPhase >= 11`: Automatically unlocks Level 5001 provided Level 5000 is cleared.
- **Staged Rollout Schedule:**
  - Internal QA: 100% staging.
  - Day 1: 5% production roll.
  - Day 3: 20% production roll.
  - Day 7: 100% full release.

### 5. Phase 11 QA Checklist
Checklist executed across all devices in the test matrix:

| QA ID | Category | Test Condition & Expected Outcome | Status |
|---|---|---|---|
| **QA-P11-01** | Seam Traversal | Thread exiting through Seam Edge on Hoop A enters correct destination coordinate on Hoop B with preserved heading. | Not run |
| **QA-P11-02** | Seam Collision | If destination cell on sister hoop is obstructed, thread snags on the seam boundary (-1 Heart) and snaps back. | Not run |
| **QA-P11-03** | Cross Charm | Unravelling key thread on Hoop A successfully unlocks the linked target clasp on Hoop B. | Not run |
| **QA-P11-04** | Mirror Hoop | Mirror threads unravel simultaneously across both hoops; collision on either deducts only 1 Heart total. | Not run |
| **QA-P11-05** | Solvability | All 500 levels (5001–5500) verified 100% solvable with 0 hearts lost and 0 boosters used. | Not run |
| **QA-P11-06** | Performance | Low-tier reference device (DM-1) maintains steady 60 fps during dual-hoop gameplay on $10 \times 10$ boards. | Not run |
| **QA-P11-07** | Rollout | Remote Config `maxPhase = 10` gates Level 5001; incrementing to `11` unlocks cleanly. | Not run |
| **QA-P11-08** | Finale | L5491 Review level and L5500 Finale "The Twin Hoops Symphony" generate and play properly, granting Grand Sewing Chest. | Not run |

## Affected Files
- `tools/levelgen/bin/prevalidate_phase11.dart` (to be created: CI seed batch validator)
- `assets/levels/phase_11_meta.bin` (to be created: 8 KB binary metadata)
- `lib/features/level_map/bloc/map_cubit.dart` (changed: integrate `maxPhase = 11` gate)

## Risks
- Cyclic cross-board path dependencies creating unsolvable deadlock loops. Mitigated by strict DAG cycle detection during seed generation.

## Open Questions
None. Dual-board performance benchmarks and QA matrix match Phase 11 design specifications.

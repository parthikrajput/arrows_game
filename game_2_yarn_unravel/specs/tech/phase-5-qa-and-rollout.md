Source docs: phase/phase_5/06_UI_AND_QA_PHASE_5.md, phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3–§5. Depends on: specs/tech/frontend-and-qa-phase-2.md, specs/tech/on-device-level-generation.md, specs/gameplay/phase-5-signature-system.md.

# Spec: Tech — Phase 5 QA Matrix & Release Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed pre-validation pipeline, binary metadata shipping (`phase_5_meta.bin`), push physics runtime performance benchmarks, Remote Config staged rollout strategy, and QA verification checklist for Yarn Unravel Phase 5 (Levels 2001–2500).

## Current State
Design documented in `phase/phase_5/06_UI_AND_QA_PHASE_5.md` and `phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 4 introduced multi-floor stack generation and memory budgets.
- Phase 5 introduces push physics kinetics with movable crate entities, requiring validation of dynamic board states, dead-end avoidance, and frame stability during multi-crate displacement.

## Proposed Change
Build the Phase 5 CI verification suite and release gatekeeper:

### 1. CI Seed Pre-Validation Pipeline
- `tools/levelgen` runs a headless batch job evaluating all 500 levels in Phase 5 ($L \in [2001, 2500]$):
  1. Computes initial seed: `seed = hash64("yarn_unravel", level, 5)`.
  2. Evaluates attempt $k \in [0, 63]$.
  3. Solves dynamic crate displacement graphs via IDA* solver, verifying zero-heart solvability.
  4. If attempt $k > 0$ is required, records entry in `assets/levels/seed_overrides.json`.
  5. Computes and serializes metadata into `assets/levels/phase_5_meta.bin`.

### 2. Shipped Metadata Binary (`phase_5_meta.bin`)
Compact 16-byte binary record per level (500 levels $\times$ 16 bytes = 8 KB total):
```
[2B level][1B k_override][1B par_moves][2B difficulty_x10][1B crate_count][1B pit_count][4B crc32][4B reserved]
```
- Shipped directly inside the app bundle.
- Eliminates on-device solver calculation for par moves and hint assistance.

### 3. Generator & Push Physics Performance Budgets
Tested on low-tier reference hardware (DM-1: 2 GB RAM, Quad-Core A53):
- **Generation Latency:** $\le 15\text{ ms}$ per level.
- **Isolate Thread Execution:** Generator runs in background isolate `compute()`, zero UI frame hitching.
- **Physics Calculation:** Crate displacement resolution $\le 1\text{ ms}$ per push event.
- **Frame Rate:** Maintains steady 60 fps on a 14×14 grid with 6 active crates and 40 threads.

### 4. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer, default `4`).
- **Gating Logic:**
  - `maxPhase < 5`: Levels 2001+ display "Notions Workshop Coming Soon!" teaser modal.
  - `maxPhase >= 5`: Automatically unlocks Level 2001 provided Level 2000 is cleared.
- **Staged Rollout Schedule:**
  - Internal QA: 100% staging.
  - Day 1: 5% production roll.
  - Day 3: 20% production roll.
  - Day 7: 100% full release.

### 5. Phase 5 QA Checklist
Checklist executed across all devices in the test matrix:

| QA ID | Category | Test Condition & Expected Outcome | Status |
|---|---|---|---|
| **QA-P5-01** | Push Kinetics | Unraveling thread head pushes standard crate exactly 1 cell ahead if destination cell is empty. | Not run |
| **QA-P5-02** | Collision | If destination cell behind crate is blocked by wall, obstacle, or thread, crate does not move; thread snags (-1 Heart). | Not run |
| **QA-P5-03** | Mechanics | M201 Crate Pit: Pushing crate into pit consumes crate and pit, transforming cell into flat traversable floor. | Not run |
| **QA-P5-04** | Mechanics | M202 Satin Crate: Pushed satin crate slides continuously until stopped by obstacle, wall, or unfilled pit. | Not run |
| **QA-P5-05** | Mechanics | M203 Charm Crate: Pushing charm crate onto matching clasp unlocks clasp permanently and consumes crate. | Not run |
| **QA-P5-06** | Mechanics | M204 Iron Crate: Normal threads snag on collision; only Chunky Chenille (M024) or Ribbon Pairs (M011) displace it. | Not run |
| **QA-P5-07** | Solvability | All 500 levels (2001–2500) verified 100% solvable with 0 hearts lost and 0 boosters used. | Not run |
| **QA-P5-08** | Performance | Low-tier reference device (DM-1) maintains steady 60 fps with 6 pushable crates and 40 threads on 14×14 grid. | Not run |
| **QA-P5-09** | Rollout | Remote Config `maxPhase = 4` gates Level 2001; incrementing to `5` unlocks cleanly. | Not run |
| **QA-P5-10** | Finale | L2491 Review level and L2500 Finale "Master Workshop Tapestry" generate and play properly, granting Grand Sewing Chest. | Not run |

## Affected Files
- `tools/levelgen/bin/prevalidate_phase5.dart` (to be created: CI seed batch validator)
- `assets/levels/phase_5_meta.bin` (to be created: 8 KB binary metadata)
- `lib/features/level_map/bloc/map_cubit.dart` (changed: integrate `maxPhase = 5` gate)

## Risks
- Unexpected cyclic push dependencies causing solver timeouts. Mitigated by strict maximum recursion depth in IDA* crate branch evaluation.

## Open Questions
None. Push kinetics performance and QA matrix match Phase 5 design specifications.

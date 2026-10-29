Source docs: phase/phase_9/06_UI_AND_QA_PHASE_9.md, phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3–§5. Depends on: specs/tech/frontend-and-qa-phase-2.md, specs/tech/on-device-level-generation.md, specs/gameplay/phase-9-signature-system.md.

# Spec: Tech — Phase 9 QA Matrix & Release Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed pre-validation pipeline, binary metadata shipping (`phase_9_meta.bin`), dynamic ply/twist performance benchmarks, Remote Config staged rollout strategy, and QA verification checklist for Yarn Unravel Phase 9 (Levels 4001–4500).

## Current State
Design documented in `phase/phase_9/06_UI_AND_QA_PHASE_9.md` and `phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 8 handled organic grid expansion with vine growth rules.
- Phase 9 introduces dynamic entity decomposition and synthesis (Split & Merge), requiring validation of multi-ply thread lifecycles, parallel tracking channels, and strict 60 fps rendering.

## Proposed Change
Build the Phase 9 CI verification suite and release gatekeeper:

### 1. CI Seed Pre-Validation Pipeline
- `tools/levelgen` runs a headless batch job evaluating all 500 levels in Phase 9 ($L \in [4001, 4500]$):
  1. Computes initial seed: `seed = hash64("yarn_unravel", level, 9)`.
  2. Evaluates attempt $k \in [0, 63]$.
  3. Solves dynamic thread split and merge trees via IDA* solver, verifying zero-heart solvability.
  4. If attempt $k > 0$ is required, records entry in `assets/levels/seed_overrides.json`.
  5. Computes and serializes metadata into `assets/levels/phase_9_meta.bin`.

### 2. Shipped Metadata Binary (`phase_9_meta.bin`)
Compact 16-byte binary record per level (500 levels $\times$ 16 bytes = 8 KB total):
```
[2B level][1B k_override][1B par_moves][2B difficulty_x10][1B pad_count][1B splitter_count][4B crc32][4B reserved]
```
- Shipped directly inside the app bundle.
- Eliminates on-device solver calculation for par moves and hint assistance.

### 3. Generator & Split/Merge Performance Budgets
Tested on low-tier reference hardware (DM-1: 2 GB RAM, Quad-Core A53):
- **Generation Latency:** $\le 15\text{ ms}$ per level.
- **Isolate Thread Execution:** Generator runs in background isolate `compute()`, zero UI frame hitching.
- **Split/Merge Resolution:** Ply topology mutation $\le 1\text{ ms}$ per move resolution.
- **Frame Rate:** Maintains steady 60 fps on a 14×14 grid with 4 active pads, twin splitters, and 40 threads.

### 4. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer, default `8`).
- **Gating Logic:**
  - `maxPhase < 9`: Levels 4001+ display "Ply & Twist Atelier Coming Soon!" teaser modal.
  - `maxPhase >= 9`: Automatically unlocks Level 4001 provided Level 4000 is cleared.
- **Staged Rollout Schedule:**
  - Internal QA: 100% staging.
  - Day 1: 5% production roll.
  - Day 3: 20% production roll.
  - Day 7: 100% full release.

### 5. Phase 9 QA Checklist
Checklist executed across all devices in the test matrix:

| QA ID | Category | Test Condition & Expected Outcome | Status |
|---|---|---|---|
| **QA-P9-01** | Twisting Pad | Two needles landing on pad activate it; tapping merges them into a single consolidated thread in 1 move. | Not run |
| **QA-P9-02** | Double Split | Needle entering splitter divides into two parallel half-ply child threads maintaining original heading. | Not run |
| **QA-P9-03** | Mechanics | M403 Stitch Lock: Locked body segment prevents thread movement until key-thread unravelling pops clasp. | Not run |
| **QA-P9-04** | Mechanics | M404 Rejoin Gate: Buckle gate opens permanently only after both child plies of target thread traverse it. | Not run |
| **QA-P9-05** | Solvability | All 500 levels (4001–4500) verified 100% solvable with 0 hearts lost and 0 boosters used. | Not run |
| **QA-P9-06** | Performance | Low-tier reference device (DM-1) maintains steady 60 fps during complex split and merge actions on 14×14 grid. | Not run |
| **QA-P9-07** | Rollout | Remote Config `maxPhase = 8` gates Level 4001; incrementing to `9` unlocks cleanly. | Not run |
| **QA-P9-08** | Finale | L4491 Review level and L4500 Finale "The Grand Tapestry Knot" generate and play properly, granting Grand Sewing Chest. | Not run |

## Affected Files
- `tools/levelgen/bin/prevalidate_phase9.dart` (to be created: CI seed batch validator)
- `assets/levels/phase_9_meta.bin` (to be created: 8 KB binary metadata)
- `lib/features/level_map/bloc/map_cubit.dart` (changed: integrate `maxPhase = 9` gate)

## Risks
- Entity reference leaks when threads merge or split. Mitigated by strict immutable state generation in `packages/puzzle_core`.

## Open Questions
None. Split/merge performance benchmarks and QA matrix match Phase 9 design specifications.

Source docs: phase/phase_8/06_UI_AND_QA_PHASE_8.md, phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3–§5. Depends on: specs/tech/frontend-and-qa-phase-2.md, specs/tech/on-device-level-generation.md, specs/gameplay/phase-8-signature-system.md.

# Spec: Tech — Phase 8 QA Matrix & Release Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed pre-validation pipeline, binary metadata shipping (`phase_8_meta.bin`), vine growth performance benchmarks, Remote Config staged rollout strategy, and QA verification checklist for Yarn Unravel Phase 8 (Levels 3501–4000).

## Current State
Design documented in `phase/phase_8/06_UI_AND_QA_PHASE_8.md` and `phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 7 handled coordinate transformations on sub-boards.
- Phase 8 introduces dynamic board state growth (Ivy Yarn), requiring CI validation of move-gated branch expansion, pruning timing windows, and frame rate stability under dense vine populations.

## Proposed Change
Build the Phase 8 CI verification suite and release gatekeeper:

### 1. CI Seed Pre-Validation Pipeline
- `tools/levelgen` runs a headless batch job evaluating all 500 levels in Phase 8 ($L \in [3501, 4000]$):
  1. Computes initial seed: `seed = hash64("yarn_unravel", level, 8)`.
  2. Evaluates attempt $k \in [0, 63]$.
  3. Solves dynamic vine expansion and pruning trees via IDA* solver, verifying zero-heart solvability.
  4. If attempt $k > 0$ is required, records entry in `assets/levels/seed_overrides.json`.
  5. Computes and serializes metadata into `assets/levels/phase_8_meta.bin`.

### 2. Shipped Metadata Binary (`phase_8_meta.bin`)
Compact 16-byte binary record per level (500 levels $\times$ 16 bytes = 8 KB total):
```
[2B level][1B k_override][1B par_moves][2B difficulty_x10][1B root_count][1B gate_count][4B crc32][4B reserved]
```
- Shipped directly inside the app bundle.
- Eliminates on-device solver calculation for par moves and hint assistance.

### 3. Generator & Growth Performance Budgets
Tested on low-tier reference hardware (DM-1: 2 GB RAM, Quad-Core A53):
- **Generation Latency:** $\le 15\text{ ms}$ per level.
- **Isolate Thread Execution:** Generator runs in background isolate `compute()`, zero UI frame hitching.
- **Spread Calculation:** Vine growth calculation $\le 1\text{ ms}$ per step tick.
- **Frame Rate:** Maintains steady 60 fps on a 14×14 grid with 3 active roots, active vines, and 40 threads.

### 4. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer, default `7`).
- **Gating Logic:**
  - `maxPhase < 8`: Levels 3501+ display "Garden Knitting Coming Soon!" teaser modal.
  - `maxPhase >= 8`: Automatically unlocks Level 3501 provided Level 3500 is cleared.
- **Staged Rollout Schedule:**
  - Internal QA: 100% staging.
  - Day 1: 5% production roll.
  - Day 3: 20% production roll.
  - Day 7: 100% full release.

### 5. Phase 8 QA Checklist
Checklist executed across all devices in the test matrix:

| QA ID | Category | Test Condition & Expected Outcome | Status |
|---|---|---|---|
| **QA-P8-01** | Growth Kinetics | Ivy Yarn spreads into exactly 2 empty cells every $N$ moves following clockwise direction priority ($U \to R \to D \to L$). | Not run |
| **QA-P8-02** | Thread Collision | Cells occupied by thread bodies block vine expansion; ivy does not intrude into active threads. | Not run |
| **QA-P8-03** | Mechanics | M352 Snip Tile: Thread unravel path crossing shears tile instantly prunes all ivy in surrounding 8 cells. | Not run |
| **QA-P8-04** | Mechanics | M353 Seed Bead Thread: Leaves bead on tail cell; germinates into Wooden Button after 3 moves unless crushed by thread. | Not run |
| **QA-P8-05** | Mechanics | M354 Blossom Gate: Pruning $K$ designated adjacent vine cells blooms gate open permanently. | Not run |
| **QA-P8-06** | Solvability | All 500 levels (3501–4000) verified 100% solvable with 0 hearts lost and 0 boosters used. | Not run |
| **QA-P8-07** | Performance | Low-tier reference device (DM-1) maintains steady 60 fps with 3 active roots on a 14×14 grid. | Not run |
| **QA-P8-08** | Rollout | Remote Config `maxPhase = 7` gates Level 3501; incrementing to `8` unlocks cleanly. | Not run |
| **QA-P8-09** | Finale | L3991 Review level and L4000 Finale "The Blooming Quilt" generate and play properly, granting Grand Sewing Chest. | Not run |

## Affected Files
- `tools/levelgen/bin/prevalidate_phase8.dart` (to be created: CI seed batch validator)
- `assets/levels/phase_8_meta.bin` (to be created: 8 KB binary metadata)
- `lib/features/level_map/bloc/map_cubit.dart` (changed: integrate `maxPhase = 8` gate)

## Risks
- Vine growth visual lag during compound multi-root spreads. Mitigated by caching static board layers and batching vine path geometry.

## Open Questions
None. Growth performance benchmarks and QA matrix match Phase 8 design specifications.

Source docs: phase/phase_4/06_UI_AND_QA_PHASE_4.md, phase/phase_4/01_PHASE_4_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3–§5. Depends on: specs/tech/frontend-and-qa-phase-2.md, specs/tech/on-device-level-generation.md, specs/gameplay/phase-4-signature-system.md.

# Spec: Tech — Phase 4 QA Matrix & Release Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI level seed pre-validation pipeline, multi-floor binary metadata shipping (`phase_4_meta.bin`), on-device generator performance benchmarks, Remote Config staged rollout strategy, and QA verification checklist for Yarn Unravel Phase 4 (Levels 1501–2000).

## Current State
Design documented in `phase/phase_4/06_UI_AND_QA_PHASE_4.md` and `phase/phase_4/01_PHASE_4_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 3 established procedural generation of single-plane cycle boards.
- Phase 4 expands procedural generation to multi-plane 3D stacks (2 to 3 floors: F1, F2, F3) interconnected by Stairs (M151), Organza peek holes (M152), Drop Holes (M153), and Bobbin Lifts (M154), requiring multi-floor solvability graph validation and strict memory caps.

## Proposed Change
Build the Phase 4 CI verification suite, multi-floor binary metadata, and rollout gatekeeper:

### 1. CI Seed Pre-Validation Pipeline
- `tools/levelgen` runs a headless batch job evaluating all 500 levels in Phase 4 ($L \in [1501, 2000]$):
  1. Computes initial seed: `seed = hash64("yarn_unravel", level, 4)`.
  2. Synthesizes floor planes:
     - Levels 1501–1750 (P4-A): 2 floors (F1, F2).
     - Levels 1751–2000 (P4-B): 3 floors (F1, F2, F3).
  3. Evaluates attempt $k \in [0, 63]$.
  4. Solves cross-floor dependency graph via IDA* multi-layer solver, verifying zero-heart solvability.
  5. If attempt $k > 0$ is required, records entry in `assets/levels/seed_overrides.json`.
  6. Computes and serializes metadata into `assets/levels/phase_4_meta.bin`.

### 2. Shipped Metadata Binary (`phase_4_meta.bin`)
Compact 16-byte binary record per level (500 levels $\times$ 16 bytes = 8 KB total):
```
[2B level][1B k_override][1B par_moves][2B difficulty_x10][1B floor_count][1B connector_count][4B crc32][4B reserved]
```
- Shipped directly inside the app bundle.
- Runtime retrieves validated floor counts, connectors, and par moves immediately without running the solver.

### 3. Generator & Multi-Floor Memory Performance Budgets
Tested on low-tier reference hardware (DM-1: 2 GB RAM, Quad-Core A53):
- **Generation Latency:** $\le 20\text{ ms}$ for multi-floor board generation.
- **Isolate Thread Execution:** Generator executes within background isolate `compute()`, zero main thread stutter.
- **Memory Overhead:** Total Resident Set Size (RSS) $\le 250\text{ MB}$ during active multi-floor gameplay.
  - Low tier culls inactive floor canvases from memory entirely.
  - Mid tier keeps lower floors in low-res cached pictures.
  - High tier retains full composite shader layers.

### 4. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer, default `3`).
- **Gating Logic:**
  - `maxPhase < 4`: Levels 1501+ display "Multi-Floor Sewing Room Coming Soon!" teaser modal.
  - `maxPhase >= 4`: Automatically unlocks Level 1501 provided Level 1500 is cleared.
- **Staged Rollout Schedule:**
  - Internal QA: 100% staging.
  - Day 1: 5% production roll.
  - Day 3: 20% production roll.
  - Day 7: 100% full release.

### 5. Phase 4 QA Checklist
Checklist executed across all devices in the test matrix:

| QA ID | Category | Test Condition & Expected Outcome | Status |
|---|---|---|---|
| **QA-P4-01** | Navigation | Tapping F1, F2, F3 tabs smoothly switches camera view to the target floor in 250 ms without expending moves (0 moves cost). | Not run |
| **QA-P4-02** | Mechanics | M151 Spiral Spool Stair routes thread from source floor to target floor at matching (x, y) coordinates with seamless unravel animation. | Not run |
| **QA-P4-03** | Mechanics | M152 Organza Floor semi-transparent cell (`alpha = 0.55`) permits seeing and tapping lower floor threads directly when unobstructed. | Not run |
| **QA-P4-04** | Mechanics | M153 Drop Hole transfers thread head to floor immediately below upon arrival, spending 1 move and emitting wool puff VFX. | Not run |
| **QA-P4-05** | Mechanics | M154 Bobbin Lift carries needle/thread between designated floor pairs upon tapping lift control mechanism. | Not run |
| **QA-P4-06** | Win Condition | Level clear modal triggers only when all active floors (F1, F2, and F3 if applicable) are 100% cleared of threads. | Not run |
| **QA-P4-07** | Solvability | All 500 levels (1501–2000) verified 100% solvable with 0 hearts lost and 0 boosters used. | Not run |
| **QA-P4-08** | Performance | Low-tier reference device (DM-1) maintains RSS $\le 250\text{ MB}$ and stable frame rate across all multi-floor transitions. | Not run |
| **QA-P4-09** | Rollout | Remote Config `maxPhase = 3` properly gates Level 1501; bumping to `4` unlocks seamlessly. | Not run |
| **QA-P4-10** | Finale | L1991 Review Level and L2000 Finale "The Three-Tier Quilt" generate properly with all 3 floors and grant Grand Sewing Chest upon victory. | Not run |

## Affected Files
- `tools/levelgen/bin/prevalidate_phase4.dart` (to be created: CI multi-floor seed batch validator)
- `assets/levels/phase_4_meta.bin` (to be created: 8 KB binary metadata)
- `lib/features/level_map/bloc/map_cubit.dart` (changed: integrate `maxPhase = 4` gate)

## Risks
- Excessive texture allocation if multiple floor canvases are kept active simultaneously on low-end devices. Mitigated by strict canvas disposal policy on low tier.

## Open Questions
None. Multi-floor validation pipeline and QA checklist match Phase 4 design specifications.

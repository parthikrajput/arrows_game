Source docs: phase/phase_6/06_UI_AND_QA_PHASE_6.md, phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3–§5. Depends on: specs/tech/frontend-and-qa-phase-2.md, specs/tech/on-device-level-generation.md, specs/gameplay/phase-6-signature-system.md.

# Spec: Tech — Phase 6 QA Matrix & Release Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed pre-validation pipeline, binary metadata shipping (`phase_6_meta.bin`), ray-casting performance benchmarks, Remote Config staged rollout strategy, and QA verification checklist for Yarn Unravel Phase 6 (Levels 2501–3000).

## Current State
Design documented in `phase/phase_6/06_UI_AND_QA_PHASE_6.md` and `phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 5 verified push kinetics and dynamic box-shifting graphs.
- Phase 6 introduces dynamic optical ray-casting, beam occlusion, chromatic color filtering, and shadow cell unlocking, requiring rapid bitboard derived state evaluation and strict frame rate preservation.

## Proposed Change
Build the Phase 6 CI verification suite and release gatekeeper:

### 1. CI Seed Pre-Validation Pipeline
- `tools/levelgen` runs a headless batch job evaluating all 500 levels in Phase 6 ($L \in [2501, 3000]$):
  1. Computes initial seed: `seed = hash64("yarn_unravel", level, 6)`.
  2. Evaluates attempt $k \in [0, 63]$.
  3. Solves dynamic optical prerequisite chains via IDA* solver, verifying zero-heart solvability.
  4. If attempt $k > 0$ is required, records entry in `assets/levels/seed_overrides.json`.
  5. Computes and serializes metadata into `assets/levels/phase_6_meta.bin`.

### 2. Shipped Metadata Binary (`phase_6_meta.bin`)
Compact 16-byte binary record per level (500 levels $\times$ 16 bytes = 8 KB total):
```
[2B level][1B k_override][1B par_moves][2B difficulty_x10][1B lamp_count][1B filter_count][4B crc32][4B reserved]
```
- Shipped directly inside the app bundle.
- Eliminates on-device solver calculation for par moves and hint assistance.

### 3. Generator & Ray-Casting Performance Budgets
Tested on low-tier reference hardware (DM-1: 2 GB RAM, Quad-Core A53):
- **Generation Latency:** $\le 15\text{ ms}$ per level.
- **Isolate Thread Execution:** Generator runs in background isolate `compute()`, zero UI frame hitching.
- **Ray-Cast Evaluation:** Bitboard derived state calculation $\le 1\text{ ms}$ per move resolution.
- **Frame Rate:** Maintains steady 60 fps on a 14×14 grid with 5 active lamp emitters and 40 threads.

### 4. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer, default `5`).
- **Gating Logic:**
  - `maxPhase < 6`: Levels 2501+ display "Lamplight Atelier Coming Soon!" teaser modal.
  - `maxPhase >= 6`: Automatically unlocks Level 2501 provided Level 2500 is cleared.
- **Staged Rollout Schedule:**
  - Internal QA: 100% staging.
  - Day 1: 5% production roll.
  - Day 3: 20% production roll.
  - Day 7: 100% full release.

### 5. Phase 6 QA Checklist
Checklist executed across all devices in the test matrix:

| QA ID | Category | Test Condition & Expected Outcome | Status |
|---|---|---|---|
| **QA-P6-01** | Ray-Casting | Light rays project straight from brass lamps and are accurately stopped by blockers, walls, crates, and thread bodies. | Not run |
| **QA-P6-02** | Occlusion | Unraveling an obstructing thread instantly lets the light ray advance through the vacated cells on Step 4. | Not run |
| **QA-P6-03** | Mechanics | M251 Tinted Glass: Light passing through filter adopts filter color and activates only matching chromatic Sun-Catchers. | Not run |
| **QA-P6-04** | Mechanics | M252 Prism Clasp: Unlocks permanently and shatters only when $\ge 2$ independent light rays strike it simultaneously. | Not run |
| **QA-P6-05** | Mechanics | M253 Hourglass Lamp: Toggles ON/OFF every $N$ valid player moves; zero wall-clock timer drift; invalid taps do not advance counter. | Not run |
| **QA-P6-06** | Mechanics | M254 Shadow Pocket: Threads residing in unlit cells remain locked; shine of light ray clears darkness and enables thread selection. | Not run |
| **QA-P6-07** | Solvability | All 500 levels (2501–3000) verified 100% solvable with 0 hearts lost and 0 boosters used. | Not run |
| **QA-P6-08** | Performance | Low-tier reference device (DM-1) maintains steady 60 fps with 5 lamps and 40 threads on 14×14 grid. | Not run |
| **QA-P6-09** | Rollout | Remote Config `maxPhase = 5` gates Level 2501; incrementing to `6` unlocks cleanly. | Not run |
| **QA-P6-10** | Finale | L2991 Review level and L3000 Finale "Atelier Chandelier Tapestry" generate and play properly, granting Grand Sewing Chest. | Not run |

## Affected Files
- `tools/levelgen/bin/prevalidate_phase6.dart` (to be created: CI seed batch validator)
- `assets/levels/phase_6_meta.bin` (to be created: 8 KB binary metadata)
- `lib/features/level_map/bloc/map_cubit.dart` (changed: integrate `maxPhase = 6` gate)

## Risks
- Ray infinite reflection loops when combining mirrors and prisms. Mitigated by strict 16-bounce ceiling in ray-casting engine.

## Open Questions
None. Ray-casting benchmarks and QA matrix match Phase 6 design specifications.

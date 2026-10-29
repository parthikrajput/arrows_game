Source docs: phase/phase_3/06_UI_AND_QA_PHASE_3.md, phase/phase_3/01_PHASE_3_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3–§5. Depends on: specs/tech/frontend-and-qa-phase-2.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 3 QA Matrix & Release Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI level seed pre-validation pipeline, binary metadata shipping (`phase_3_meta.bin`), on-device generator performance benchmarks, Remote Config staged rollout strategy, and QA verification checklist for Yarn Unravel Phase 3 (Levels 1001–1500).

## Current State
Design documented in `phase/phase_3/06_UI_AND_QA_PHASE_3.md` and `phase/phase_3/01_PHASE_3_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 2 loaded pre-packaged levels from gzip bundles.
- Phase 3 is the first update where levels are synthesized on-device from seeds, necessitating pre-computed CI metadata to guarantee instantaneous loading and verified solvability.

## Proposed Change
Build the Phase 3 CI verification suite and rollout gatekeeper:

### 1. CI Seed Pre-Validation Pipeline
- `tools/levelgen` runs a headless batch job evaluating all 500 levels in Phase 3 ($L \in [1001, 1500]$):
  1. Computes initial seed: `seed = hash64("yarn_unravel", level, 3)`.
  2. Evaluates attempt $k \in [0, 63]$.
  3. Verifies zero-heart solvability via IDA* solver.
  4. If attempt $k > 0$ is required, records entry in `assets/levels/seed_overrides.json` (`{"1124": 3, ...}`).
  5. Computes and serializes metadata into `assets/levels/phase_3_meta.bin`.

### 2. Shipped Metadata Binary (`phase_3_meta.bin`)
Compact 16-byte binary record per level (500 levels $\times$ 16 bytes = 8 KB total):
```
[2B level][1B k_override][1B par_moves][2B difficulty_x10][4B crc32][6B reserved]
```
- Shipped directly inside the app bundle.
- Eliminates any need for on-device solver calculation for Hints or par moves; runtime retrieves verified values directly from the metadata binary.

### 3. Generator Performance Budgets
Tested on low-tier reference hardware (DM-1: 2 GB RAM, Quad-Core A53):
- **Generation Latency:** $\le 15\text{ ms}$ per level.
- **Isolate Thread Execution:** Generator executes within a dedicated Dart background isolate (`compute()`), ensuring 0 ms main UI thread frame drops.
- **Memory Overhead:** Level generator state footprint $\le 500\text{ KB}$.

### 4. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer, default `2`).
- **Gating Logic:**
  - `maxPhase < 3`: Levels 1001+ display "New Loom Patterns Coming Soon!" teaser modal.
  - `maxPhase >= 3`: Automatically unlocks Level 1001 provided Level 1000 is cleared.
- **Staged Rollout Schedule:**
  - Internal QA: 100% staging.
  - Day 1: 5% production roll.
  - Day 3: 20% production roll.
  - Day 7: 100% full release.

### 5. Phase 3 QA Checklist
Checklist executed across all devices in the test matrix:

| QA ID | Category | Test Condition & Expected Outcome | Status |
|---|---|---|---|
| **QA-P3-01** | Cycles | Board state oscillates between Day (A) and Night (B) exactly every 5 valid Moves. Locked/bumped taps do not advance counter. | Not run |
| **QA-P3-02** | Mechanics | M101 Loom Latch is open during assigned cycle state; acts as a solid blocker in opposing state (-1 Heart snag). | Not run |
| **QA-P3-03** | Mechanics | M102 Day Bridge allows multi-layer orthogonal crossings in Day; acts as solid blocker in Night. | Not run |
| **QA-P3-04** | Mechanics | M103 Night Pompom teleports threads only during Night; acts as solid blocker during Day. | Not run |
| **QA-P3-05** | Mechanics | M104 Twilight Eyelet permits colorA in Day and colorB in Night; non-matching colors snag. | Not run |
| **QA-P3-06** | Generation | All 500 levels (1001–1500) generate deterministically on device matching CI `phase_3_meta.bin` byte hashes. | Not run |
| **QA-P3-07** | Solvability | Every level (1001–1500) verified 100% solvable with 0 hearts lost and 0 boosters used. | Not run |
| **QA-P3-08** | Performance | Low-tier reference device (DM-1) maintains steady 60 fps on 14×14 boards with 40 threads. | Not run |
| **QA-P3-09** | Rollout | Remote Config `maxPhase = 2` properly gates Level 1001; toggling to `3` unlocks seamlessly. | Not run |
| **QA-P3-10** | Finale | L1491 Review level and L1500 "Day & Night Tapestry" Finale generate and award Grand Sewing Chest upon victory. | Not run |

## Affected Files
- `tools/levelgen/bin/prevalidate_phase3.dart` (to be created: CI seed batch validator)
- `assets/levels/phase_3_meta.bin` (to be created: 8 KB binary metadata)
- `lib/features/level_map/bloc/map_cubit.dart` (changed: integrate `maxPhase` gate)

## Risks
- Corrupted metadata binary causing level loading failures. Mitigated by CRC32 checksum verification prior to parsing.

## Open Questions
None. Validation pipeline and QA IDs match Phase 3 documentation.

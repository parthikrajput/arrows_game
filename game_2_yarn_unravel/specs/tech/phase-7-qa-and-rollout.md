Source docs: phase/phase_7/06_UI_AND_QA_PHASE_7.md, phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §3–§5. Depends on: specs/tech/frontend-and-qa-phase-2.md, specs/tech/on-device-level-generation.md, specs/gameplay/phase-7-signature-system.md.

# Spec: Tech — Phase 7 QA Matrix & Release Rollout

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed pre-validation pipeline, binary metadata shipping (`phase_7_meta.bin`), canvas matrix raster benchmarks, Remote Config staged rollout strategy, and QA verification checklist for Yarn Unravel Phase 7 (Levels 3001–3500).

## Current State
Design documented in `phase/phase_7/06_UI_AND_QA_PHASE_7.md` and `phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 6 validated dynamic optical ray casting and shadow state derivations.
- Phase 7 introduces dynamic coordinate transformations (sub-board rotation), requiring verification of boundary locks, cyclic state detection, and raster frame stability during matrix rotation.

## Proposed Change
Build the Phase 7 CI verification suite and release gatekeeper:

### 1. CI Seed Pre-Validation Pipeline
- `tools/levelgen` runs a headless batch job evaluating all 500 levels in Phase 7 ($L \in [3001, 3500]$):
  1. Computes initial seed: `seed = hash64("yarn_unravel", level, 7)`.
  2. Evaluates attempt $k \in [0, 63]$.
  3. Solves dynamic rotational permutations via IDA* solver, verifying zero-heart solvability.
  4. If attempt $k > 0$ is required, records entry in `assets/levels/seed_overrides.json`.
  5. Computes and serializes metadata into `assets/levels/phase_7_meta.bin`.

### 2. Shipped Metadata Binary (`phase_7_meta.bin`)
Compact 16-byte binary record per level (500 levels $\times$ 16 bytes = 8 KB total):
```
[2B level][1B k_override][1B par_moves][2B difficulty_x10][1B rotor_count][1B hem_gap_count][4B crc32][4B reserved]
```
- Shipped directly inside the app bundle.
- Eliminates on-device solver calculation for par moves and hint assistance.

### 3. Generator & Raster Performance Budgets
Tested on low-tier reference hardware (DM-1: 2 GB RAM, Quad-Core A53):
- **Generation Latency:** $\le 15\text{ ms}$ per level.
- **Isolate Thread Execution:** Generator runs in background isolate `compute()`, zero UI frame hitching.
- **Raster Performance:** 2D Canvas matrix transform maintains raster times $p95 < 8\text{ ms}$ during continuous 250 ms rotation animations.
- **Frame Rate:** Maintains steady 60 fps on a 14×14 grid with 3 active hoop rotors and 40 threads.

### 4. Remote Config Rollout Gate
- **Key:** `maxPhase` (integer, default `6`).
- **Gating Logic:**
  - `maxPhase < 7`: Levels 3001+ display "Turning Table Atelier Coming Soon!" teaser modal.
  - `maxPhase >= 7`: Automatically unlocks Level 3001 provided Level 3000 is cleared.
- **Staged Rollout Schedule:**
  - Internal QA: 100% staging.
  - Day 1: 5% production roll.
  - Day 3: 20% production roll.
  - Day 7: 100% full release.

### 5. Phase 7 QA Checklist
Checklist executed across all devices in the test matrix:

| QA ID | Category | Test Condition & Expected Outcome | Status |
|---|---|---|---|
| **QA-P7-01** | Sub-Board Rotor | Tapping $4 \times 4$ hoop rotor center rotates enclosed coordinates 90° CW, expending exactly 1 move. | Not run |
| **QA-P7-02** | Boundary Invariant | Threads straddling the hoop boundary mechanically lock the rotor; tap results in denial nudge and 0 moves expended. | Not run |
| **QA-P7-03** | Mechanics | M302 Turning Hem: Perimeter exit gaps advance 1 segment CW after every valid move; blocked borders cause snags. | Not run |
| **QA-P7-04** | Mechanics | M303 Twirl Thread: Needle spins 90° CW after every valid move; unravelling only succeeds when pointing to open exit. | Not run |
| **QA-P7-05** | Mechanics | M304 Ratchet Pin: Rotor remains locked until associated key-thread unravelling pops safety pin. | Not run |
| **QA-P7-06** | Tangled State | Needles pointing into their own thread body enter Tangled state; tapping triggers lock nudge with 0 hearts lost. | Not run |
| **QA-P7-07** | Solvability | All 500 levels (3001–3500) verified 100% solvable with 0 hearts lost and 0 boosters used. | Not run |
| **QA-P7-08** | Performance | Low-tier reference device (DM-1) maintains steady 60 fps and raster $p95 < 8\text{ ms}$ during sub-grid rotation. | Not run |
| **QA-P7-09** | Rollout | Remote Config `maxPhase = 6` gates Level 3001; incrementing to `7` unlocks cleanly. | Not run |
| **QA-P7-10** | Finale | L3491 Review level and L3500 Finale "The Kaleidoscope Quilt" generate and play properly, granting Grand Sewing Chest. | Not run |

## Affected Files
- `tools/levelgen/bin/prevalidate_phase7.dart` (to be created: CI seed batch validator)
- `assets/levels/phase_7_meta.bin` (to be created: 8 KB binary metadata)
- `lib/features/level_map/bloc/map_cubit.dart` (changed: integrate `maxPhase = 7` gate)

## Risks
- Orientation confusion if sub-grids rotate multiple times in succession. Mitigated by explicit visual needle heading indicators.

## Open Questions
None. Rotation performance benchmarks and QA matrix match Phase 7 design specifications.

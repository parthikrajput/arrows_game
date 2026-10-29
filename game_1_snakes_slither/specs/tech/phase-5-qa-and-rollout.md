Source docs: phase_5/06_UI_AND_QA_PHASE_5.md, phase_5/01_PHASE_5_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §8–§10. Depends on: specs/tech/phase-4-qa-and-rollout.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 5 QA, Rollout & Metadata Pipeline

## Status
Draft

## Type
Improvement (extends deployment gates, CI validation, and QA verification for Phase 5 on-device content)

## Goal
Specify the CI pre-validation suite for Levels 2001–2500, generation of binary metadata `phase_5_meta.bin`, Remote Config staged rollout flags, performance budgets for push physics and sliding calculations, and QA test procedures for Phase 5.

## Current State
Design documented in `phase_5/06_UI_AND_QA_PHASE_5.md`, `phase_5/01_PHASE_5_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §8–§10, not yet implemented.
- Earlier phases established pre-validation generation pipelines and binary metadata asset bundling.
- Phase 5 expands generator reverse-construction and stateful solving to support pushable dynamic obstacles, inertia paths, and terrain mutations.

## Proposed Change
Implement the offline validation pipeline, metadata bundler, and QA verification suite for Phase 5:

### 1. CI Offline Pre-Validation Pipeline
Prior to publishing an app update containing Phase 5:
1. **Full Seed Sweep:** CI executes `tools/levelgen` across all 500 levels (L2001–2500) with attempts $k = 0 \dots 63$.
2. **Deterministic Parity:** Compares generated JSON across ARM64 Android, iOS simulator, and x64 Linux runners to guarantee byte-identical outputs across all target architectures.
3. **Validator Gates:**
   - **100% Solvability:** Every level must be solvable with 0 hearts lost and 0 boosters used.
   - **Difficulty Plateaus:** Difficulty $D$ must fall within **60 to 76** (±3 tolerance margin; $x9$ Hard $\approx 84$; Finale $\approx 91$).
   - **Intro Constraints:** `x1` intro levels contain only the intro mechanic/variant + $\le 1$ earlier mechanic.
   - **No Permanent Deadlocks:** No pushable block or snake may be permanently trapped at move 0 without an escape sequence.
4. **Metadata Bundling:** Outputs `assets/levels/phase_5_meta.bin` containing per-level:
   `{level: uint16, k: uint8, par_moves: uint8, difficulty: float32, crc32: uint32, solution: List<uint8>}`.
5. **Overrides Manifest:** Any levels requiring $k > 0$ are written to `assets/levels/seed_overrides.json`.

### 2. Performance Budgets & Device Gates
- **On-Device Level Generation:**
  - Background isolate thread: **$\le 300\text{ ms}$** on mid-tier hardware (Snapdragon 700 / Helio G90 class).
  - Low-tier hardware (Redmi 9A class): **$\le 800\text{ ms}$**.
  - Background speculative pre-generation: Level $N+1$ is generated in an isolate while the player is solving level $N$.
- **Rendering Performance:**
  - Stable 60 fps during multi-tile continuous sliding (M202) and terrain modification events.
  - Dynamic physics calculations occur synchronously in Dart without GC pauses or memory leaks.

### 3. Remote Config Rollout Architecture
```json
{
  "maxPhase": 5,
  "levelOverrides_p5": {},
  "push_physics_inertia": 1.0,
  "p5_economy": {
    "gift_basket_coins": 300,
    "finale_chest_coins": 1000
  },
  "featureFlags": {
    "phase_5_live": true
  }
}
```
- App update ships with Phase 5 engine code and `phase_5_meta.bin`, but initial Remote Config sets `maxPhase = 4`.
- Staged rollout: 10% → 25% → 50% → 100%. Once crash rates, ANR rates, and completion funnels remain within normal thresholds, `maxPhase` is raised to `5`.

### 4. Phase 5 QA Matrix (P5-QA-01 to P5-QA-10)
| ID | Area | Test Case | Acceptance Criteria |
|---|---|---|---|
| **P5-QA-01** | Basic Push | Push with empty cell behind | Coconut advances 1 cell and snake completes move |
| **P5-QA-02** | Pit Filling | Coconut enters M201 Pit | Coconut is consumed; pit permanently becomes Plain Floor |
| **P5-QA-03** | Continuous Slide | M202 Dew-Slick Coconut | Slides continuously until obstacle, pit, or boundary |
| **P5-QA-04** | Crate Key | M203 Key Coconut | Lands on lock cell; linked gate permanently latches open |
| **P5-QA-05** | Heavy Resistance | Standard snake vs M204 | Snake bonks (−1 Heart Berry); displays "Too Heavy!" cue |
| **P5-QA-06** | Anaconda Push | Giant Anaconda vs M204 | Anaconda successfully pushes boulder 1 cell forward |
| **P5-QA-07** | Open Edge Fall | Push toward unwalled edge | Coconut falls off board and is removed (lane cleared) |
| **P5-QA-08** | Determinism | Seed regeneration | Identical board JSON produced on Android, iOS, and CI |
| **P5-QA-09** | 0-Hearts Check | Solvability sweep | All 500 levels solvable with 0 hearts lost and 0 boosters |
| **P5-QA-10** | Finale L2500 | Phase 5 completion | L2500 awards 1,000 coins + 6 boosters + Phase 5 Master Badge |

## Affected Files
- `tools/levelgen/bin/validate_phase.dart` (extended for Phase 5 validation sweep)
- `assets/levels/phase_5_meta.bin` (to be added)
- `lib/features/gameplay/domain/services/level_cache_service.dart` (updated for Phase 5 metadata)

## Risks
- Solver timing out on high-friction push puzzles during CI sweeps. Mitigated by bounding solver search depth and enforcing reverse-construction reachability invariants.

## Open Questions
- None. Validation gates, metadata schema, and rollout flags align with `phase_5/01` and `06`.

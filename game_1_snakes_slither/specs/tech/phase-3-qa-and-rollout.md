Source docs: phase_3/06_UI_AND_QA_PHASE_3.md, phase_3/01_PHASE_3_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §8–§10. Depends on: specs/tech/frontend-and-qa-phase-2.md.

# Spec: Tech — Phase 3 QA, Rollout & Metadata Pipeline

## Status
Draft

## Type
Improvement (extends deployment gates, CI validation, and QA verification for Phase 3 on-device content)

## Goal
Specify the CI pre-validation suite for Levels 1001–1500, generation of `phase_3_meta.bin`, Remote Config staged rollout flags, performance budgets, and QA test procedures for Phase 3.

## Current State
Design documented in `phase_3/06_UI_AND_QA_PHASE_3.md` and `SCALING_TO_10000_LEVELS.md` §8–§10, not yet implemented.
- Phase 1 & 2 levels were bundled in static gzipped JSON files.
- Phase 3 introduces on-device level generation validated by CI offline tests and shipped binary metadata.

## Proposed Change
Implement the offline validation pipeline, metadata bundler, and QA verification suite:

### 1. CI Offline Pre-Validation Pipeline
Prior to publishing an app update containing Phase 3:
1. **Full Seed Sweep:** CI generates all 500 levels (L1001–1500) across seed attempts $k = 0 \dots 63$.
2. **Deterministic Parity:** Generates levels across ARM64 Android, iOS simulator, and x64 Linux CI runners to confirm byte-identical JSON outputs.
3. **Validator Gates:**
   - 100% solvable with 0 hearts lost and 0 boosters used.
   - Difficulty $D$ strictly within plateau band **60 to 76** (±3 margin; $x9$ Hard $\approx 84$; Finale $\approx 91$).
   - Intro rule satisfied: `x1` levels feature only the intro mechanic/variant + $\le 1$ earlier mechanic.
   - No snake permanently locked from move 0.
4. **Metadata Bundling:** Outputs `assets/levels/phase_3_meta.bin` containing per-level:
   `{level: uint16, k: uint8, par_moves: uint8, difficulty: float32, crc32: uint32, solution: List<uint8>}`.
5. **Overrides Manifest:** Any levels requiring $k \ne 0$ are written to `assets/levels/seed_overrides.json`.

### 2. Performance Budgets & Device Gates
- **On-Device Level Generation:**
  - Background isolate thread: **$\le 300\text{ ms}$** on mid-tier hardware (Snapdragon 700 / Helio G90 class).
  - Low-tier hardware (Redmi 9A class): **$\le 800\text{ ms}$**.
  - Background pre-generation: Next level is generated while player is actively solving the current level.
- **Rendering Budget:** 60 fps stable during Day ↔ Night transitions and multi-snake slithers.

### 3. Remote Config Rollout Architecture
```json
{
  "maxPhase": 3,
  "levelOverrides_p3": {},
  "cycle_vfx_intensity": 1.0,
  "featureFlags": {
    "phase_3_live": true
  }
}
```
- App update ships with Phase 3 code and metadata assets, but initial Remote Config sets `maxPhase = 2`.
- Rollout stages: 10% -> 25% -> 50% -> 100%. Once error rates and crash rates remain normal, `maxPhase` is raised to `3`.

### 4. Phase 3 QA Matrix (P0 / P1 Checks)
- **P3-QA-01:** Cycle timing: Day ↔ Night toggles exactly every 5 valid Moves.
- **P3-QA-02:** Inverted M101 gates open/close in reverse sync with standard gates.
- **P3-QA-03:** M102 Bridge voids block snakes with $-1$ Heart when inactive.
- **P3-QA-04:** No-clipping: Snakes crossing M101/M102 during cycle swap exit safely without getting chopped.
- **P3-QA-05:** M104 Flower Gates filter snakes based strictly on active cycle color.
- **P3-QA-06:** All 45 variants behave according to their modifier decorator rules.
- **P3-QA-07:** Cross-platform determinism matches `phase_3_meta.bin` solutions.
- **P3-QA-08:** Level 1500 Finale awards Jungle Treasure Chest and triggers complete screen.

## Affected Files
- `tools/levelgen/bin/validate_phase.dart` (CI script for Phase 3 sweep)
- `tools/levelgen/lib/src/meta_bundler.dart` (binary metadata builder)
- `assets/levels/phase_3_meta.bin` (to be added)
- `lib/features/gameplay/domain/services/level_cache_service.dart` (to be created)

## Risks
- Low-end devices timing out during on-device generation isolate call. Mitigated by background speculative pre-generation of the upcoming level during active gameplay.

## Open Questions
- None. Validation gates, metadata schema, and rollout flags align with `phase_3/01` and `06`.

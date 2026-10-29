Source docs: phase_4/06_UI_AND_QA_PHASE_4.md, phase_4/01_PHASE_4_SCOPE_AND_RULES.md, ../../SCALING_TO_10000_LEVELS.md §8–§10. Depends on: specs/tech/phase-3-qa-and-rollout.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 4 QA, Rollout & Metadata Pipeline

## Status
Draft

## Type
Improvement (extends deployment gates, CI validation, and QA verification for Phase 4 on-device content)

## Goal
Specify the CI pre-validation suite for Levels 1501–2000, generation of binary metadata `phase_4_meta.bin`, Remote Config staged rollout flags, performance budgets for multi-floor levels, and QA test procedures for Phase 4.

## Current State
Design documented in `phase_4/06_UI_AND_QA_PHASE_4.md`, `phase_4/01_PHASE_4_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §8–§10, not yet implemented.
- Phase 3 established CI pre-validation sweeps and `phase_3_meta.bin` bundling.
- Phase 4 scales on-device generation to handle multi-floor stacked levels up to 3 floors and 40 paths.

## Proposed Change
Implement the offline validation pipeline, metadata bundler, and QA verification suite for Phase 4:

### 1. CI Offline Pre-Validation Pipeline
Prior to publishing an app update containing Phase 4:
1. **Full Seed Sweep:** CI executes `tools/levelgen` across all 500 levels (L1501–2000) with attempts $k = 0 \dots 63$.
2. **Deterministic Parity:** Compares generated JSON across ARM64 Android, iOS simulator, and x64 Linux runners to guarantee byte-identical outputs across all target architectures.
3. **Validator Gates:**
   - **100% Solvability:** Every level must be solvable with 0 hearts lost and 0 boosters used.
   - **Difficulty Plateaus:** Difficulty $D$ must fall within **60 to 76** (±3 tolerance margin; $x9$ Hard $\approx 84$; Finale $\approx 91$).
   - **Intro Constraints:** `x1` intro levels contain only the intro mechanic/variant + $\le 1$ earlier mechanic.
   - **No Permanent Deadlocks:** No snake may be trapped indefinitely at move 0.
4. **Metadata Bundling:** Outputs `assets/levels/phase_4_meta.bin` containing per-level:
   `{level: uint16, k: uint8, par_moves: uint8, difficulty: float32, crc32: uint32, solution: List<uint8>}`.
5. **Overrides Manifest:** Any levels requiring $k > 0$ are written to `assets/levels/seed_overrides.json`.

### 2. Performance Budgets & Device Gates
- **On-Device Level Generation:**
  - Background isolate thread: **$\le 300\text{ ms}$** on mid-tier hardware (Snapdragon 700 / Helio G90 class), even for 3-floor boards.
  - Low-tier hardware (Redmi 9A class): **$\le 800\text{ ms}$**.
  - Background speculative pre-generation: Level $N+1$ is generated in an isolate while the player is solving level $N$.
- **Rendering Performance:**
  - 60 fps stable during floor camera transitions and multi-floor path exits.
  - Inactive floors are retained in memory via pre-recorded `Picture` objects, eliminating re-layout overhead during tab switches.

### 3. Remote Config Rollout Architecture
```json
{
  "maxPhase": 4,
  "levelOverrides_p4": {},
  "multi_floor_transition_ms": 200,
  "p4_economy": {
    "gift_basket_coins": 300,
    "finale_chest_coins": 1000
  },
  "featureFlags": {
    "phase_4_live": true
  }
}
```
- App update ships with Phase 4 engine code and `phase_4_meta.bin`, but initial Remote Config sets `maxPhase = 3`.
- Staged rollout: 10% → 25% → 50% → 100%. Once crash rates, ANR rates, and completion funnels remain within normal thresholds, `maxPhase` is raised to `4`.

### 4. Phase 4 QA Matrix (P4-QA-01 to P4-QA-09)
| ID | Area | Test Case | Acceptance Criteria |
|---|---|---|---|
| **P4-QA-01** | Floor Viewing | Floor tabs tap and viewing | Viewing other floors does NOT increment `moveCount` or consume hearts |
| **P4-QA-02** | Stairs Continuity | M151 Root Stairs traversal | Snake entering stairs emerges on destination floor in same direction |
| **P4-QA-03** | Dewglass Non-Blocking | M152 Dewglass Floor | Snakes above do not lock or collide with snakes below |
| **P4-QA-04** | Knot Hole One-Way | M153 Knot Hole | Snake drops downward only; cannot ascend; bumps if landing is blocked |
| **P4-QA-05** | Lift Locked Tap | M154 Vine Lift | Snake partially on platform triggers Locked Tap (0 moves, 0 hearts lost) |
| **P4-QA-06** | Camera Auto-Pan | Inter-floor snake travel | Camera smoothly tracks snake across floors to target floor |
| **P4-QA-07** | Determinism | Seed regeneration | Identical board JSON produced on Android, iOS, and CI |
| **P4-QA-08** | 0-Hearts Check | Solvability sweep | All 500 levels solvable with 0 hearts lost and 0 boosters |
| **P4-QA-09** | Finale L2000 | Phase 4 completion | L2000 awards 1,000 coins + 6 boosters + Phase 4 Master Badge |

## Affected Files
- `tools/levelgen/bin/validate_phase.dart` (extended for Phase 4 validation sweep)
- `assets/levels/phase_4_meta.bin` (to be added)
- `lib/features/gameplay/domain/services/level_cache_service.dart` (updated for Phase 4 metadata)

## Risks
- Low-end devices running out of memory with 3 stacked floors cached simultaneously. Mitigated by releasing PictureRecorder caches of non-adjacent floors if memory pressure events are received.

## Open Questions
- None. Validation gates, metadata schema, and rollout flags align with `phase_4/01` and `06`.

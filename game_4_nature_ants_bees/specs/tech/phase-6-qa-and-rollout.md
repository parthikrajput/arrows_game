Source docs: phase/phase_6/06_UI_AND_QA_PHASE_6.md, phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, SCALING_TO_10000_LEVELS.md §8, §10. Depends on: specs/tech/phase-5-qa-and-rollout.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 6 QA, Performance & Rollout

## Status
Draft

## Type
New Feature

## Goal
Establish the automated CI pre-validation harness, `phase_6_meta.bin` metadata serialization, Remote Config rollout controls, and manual testing matrix for Phase 6 (Levels 2501–3000).

## Current State
Design documented in `phase/phase_6/06_UI_AND_QA_PHASE_6.md` and `SCALING_TO_10000_LEVELS.md`, not yet implemented.
- Phase 5 established CI validation for push physics levels.
- Phase 6 requires validating optical raycasts, chromatic gate triggers, sundial periods, and shade patch line waking.

## Proposed Change
Implement QA tooling, metadata bundling, and release safeguards:

### 1. CI Pre-Validation Suite (`tools/levelgen`)
- **Validation Pipeline:** Runs headless solver across all 500 seeds for Phase 6 (`level = 2501` to `3000`):
  - Solvability: 100% of levels must be solvable with **0 hearts lost** and **0 boosters used**.
  - Optical Recalculation: Raycast simulator validates that beam reflections and filters do not produce unsolvable optical deadlocks.
  - Move Budget: Target difficulty verified against $D \in [60, 76]$ (Finale $D \approx 93$).
  - Overrides: Any seed failing solver constraints within $k = 0..63$ attempts is recorded in `seed_overrides.json`.
- **Performance Budget:** Headless CI validator must solve all 500 levels in $\le 75\text{ seconds}$ total ($\le 150\text{ ms/level}$).

### 2. Shipped Metadata File (`phase_6_meta.bin`)
- Compressed binary asset shipped in the client bundle (Standard §17.34):
  - 500 records $\times$ 16 bytes = 8 KB total footprint.
  - Fields per level: `attempt_k` (1 byte), `par_moves` (1 byte), `difficulty_d` (1 byte), `json_crc32` (4 bytes), `hint_solution_head` (9 bytes packed).
  - Guarantees Nectar Glow Hint solves optical puzzles instantly on device.

### 3. Remote Config Rollout
- Key: `maxPhase = 6` (default `5` until QA gate passed).
- Gate Criteria:
  - Crash-free user sessions $\ge 99.5\%$.
  - L2501–3000 telemetry confirms zero raycasting crashes or frame drops during beam recalculations.

### 4. Phase 6 QA Matrix
| ID | Test Case | Expected Outcome | Status |
|---|---|---|---|
| **P6-QA-01** | Optical raycast layer check | Ground beams affect ground lines; air beams affect worker bees and tall obstacles. | Draft |
| **P6-QA-02** | Petal filter color shifting | White beam passing through red petal turns red; activates red sunflower receptor. | Draft |
| **P6-QA-03** | Conflicting filter absorption | Red beam entering blue petal filter is absorbed and terminates. | Draft |
| **P6-QA-04** | Twin-Sun Lock AND logic | Gate opens only when both receivers illuminated; shuts if either beam blocked. | Draft |
| **P6-QA-05** | Sundial lens periodic emission | Beam toggles strictly every N valid player moves; no wall-clock drift. | Draft |
| **P6-QA-06** | Shade patch sleep lock | Shaded lines locked to taps; awaken immediately when illuminated by matching beam. | Draft |
| **P6-QA-07** | Max reflection boundary | Beam terminates after 8 reflections; no infinite loop or freeze. | Draft |
| **P6-QA-08** | L3000 Solstice Festival Finale | Solvable with 0 hearts and 0 boosters; awards Royal Honey Chest & Solar badge. | Draft |
| **P6-QA-09** | CI 500/500 solver pass | 100% of levels 2501–3000 verified solvable with zero boosters required. | Draft |
| **P6-QA-10** | Offline generation & caching | Levels 2501–3000 generate and cache properly without network connection. | Draft |

## Affected Files
- `tools/levelgen/bin/validate_phase_6.dart` (to be created)
- `packages/puzzle_core/lib/src/meta/meta_reader.dart` (changed to read `phase_6_meta.bin`)
- `lib/features/config/remote_config_service.dart` (changed to support `maxPhase = 6`)

## Risks
- Raycast latency spike on low-end devices with dense mirrors. Mitigated by bounding total emitters per board to $\le 4$ and reflections to $\le 8$.

## Open Questions
- None. QA matrix and rollout keys align with `phase/phase_6/06_UI_AND_QA_PHASE_6.md`.

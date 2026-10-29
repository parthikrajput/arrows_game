Source docs: phase/phase_5/06_UI_AND_QA_PHASE_5.md, phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md, SCALING_TO_10000_LEVELS.md §8, §10. Depends on: specs/tech/phase-4-qa-and-rollout.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 5 QA, Performance & Rollout

## Status
Draft

## Type
New Feature

## Goal
Establish the automated CI pre-validation harness, `phase_5_meta.bin` metadata serialization, Remote Config rollout controls, and manual testing matrix for Phase 5 (Levels 2001–2500).

## Current State
Design documented in `phase/phase_5/06_UI_AND_QA_PHASE_5.md` and `SCALING_TO_10000_LEVELS.md`, not yet implemented.
- Phase 4 established CI validation for multi-floor levels.
- Phase 5 requires validating push physics chains, momentum limits, and irreversible pit-filling terrain transformations.

## Proposed Change
Implement QA tooling, metadata bundling, and release safeguards:

### 1. CI Pre-Validation Suite (`tools/levelgen`)
- **Validation Pipeline:** Runs headless solver across all 500 seeds for Phase 5 (`level = 2001` to `2500`):
  - Solvability: 100% of levels must be solvable with **0 hearts lost** and **0 boosters used**.
  - Push Chain Validation: Verifies that push block movements do not leave required keys permanently inaccessible.
  - Move Budget: Target difficulty verified against $D \in [60, 76]$ (Finale $D \approx 92$).
  - Overrides: Any seed failing solver constraints within $k = 0..63$ attempts is recorded in `seed_overrides.json`.
- **Performance Budget:** Headless CI validator must solve all 500 levels in $\le 75\text{ seconds}$ total ($\le 150\text{ ms/level}$).

### 2. Shipped Metadata File (`phase_5_meta.bin`)
- Compressed binary asset shipped in the client bundle (Standard §17.34):
  - 500 records $\times$ 16 bytes = 8 KB total footprint.
  - Fields per level: `attempt_k` (1 byte), `par_moves` (1 byte), `difficulty_d` (1 byte), `json_crc32` (4 bytes), `hint_solution_head` (9 bytes packed).
  - Guarantees Nectar Glow Hint calculates optimal push steps instantly without lag on device.

### 3. Remote Config Rollout
- Key: `maxPhase = 5` (default `4` until QA gate passed).
- Gate Criteria:
  - Crash-free user sessions $\ge 99.5\%$.
  - L2001–2500 telemetry confirms zero unbeatable level deadlocks or push block collision glitches.

### 4. Phase 5 QA Matrix
| ID | Test Case | Expected Outcome | Status |
|---|---|---|---|
| **P5-QA-01** | Push chain depth 2 resolution | Pushing block A against block B shifts both 1 cell forward if landing cell is free. | Draft |
| **P5-QA-02** | Mole hole pit filling | Block pushed into mole hole consumes both; converts cell into walkable ground. | Draft |
| **P5-QA-03** | Dewdrop marble low friction slide | Marble slides continuously along vector until hitting an obstacle or edge. | Draft |
| **P5-QA-04** | Seed key pod socketing | Pushing colored key pod into socket permanently unlocks matching thorn gates. | Draft |
| **P5-QA-05** | Stone pumpkin single line bonk | Single-file insect line striking stone pumpkin bonks without moving the block. | Draft |
| **P5-QA-06** | Stone pumpkin double-file push | Double-file or linked swarm lines push stone pumpkin 1 cell forward. | Draft |
| **P5-QA-07** | Layer collision rules | Ground ants interact with push blocks; air worker bees fly over standard blocks. | Draft |
| **P5-QA-08** | L2500 Harvest Festival Finale | Solvable with 0 hearts and 0 boosters; awards Royal Honey Chest & Harvest badge. | Draft |
| **P5-QA-09** | CI 500/500 solver pass | 100% of levels 2001–2500 verified solvable with zero boosters required. | Draft |
| **P5-QA-10** | Offline generation & caching | Levels 2001–2500 generate and cache properly without network connection. | Draft |

## Affected Files
- `tools/levelgen/bin/validate_phase_5.dart` (to be created)
- `packages/puzzle_core/lib/src/meta/meta_reader.dart` (changed to read `phase_5_meta.bin`)
- `lib/features/config/remote_config_service.dart` (changed to support `maxPhase = 5`)

## Risks
- Physics desync between visual slide animation and internal grid state. Mitigated by updating logical grid cell occupancy immediately at move start, while running visual interpolation independently.

## Open Questions
- None. QA matrix and rollout keys align with `phase/phase_5/06_UI_AND_QA_PHASE_5.md`.


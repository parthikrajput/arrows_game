Source docs: phase/phase_7/06_UI_AND_QA_PHASE_7.md, phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, SCALING_TO_10000_LEVELS.md §8, §10. Depends on: specs/tech/phase-6-qa-and-rollout.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 7 QA, Performance & Rollout

## Status
Draft

## Type
New Feature

## Goal
Establish the automated CI pre-validation harness, `phase_7_meta.bin` metadata serialization, Remote Config rollout controls, and manual testing matrix for Phase 7 (Levels 3001–3500).

## Current State
Design documented in `phase/phase_7/06_UI_AND_QA_PHASE_7.md` and `SCALING_TO_10000_LEVELS.md`, not yet implemented.
- Phase 6 established CI validation for optical levels.
- Phase 7 requires validating rotational state graphs, perimeter edge movement, and rotation-locking daisy constraints.

## Proposed Change
Implement QA tooling, metadata bundling, and release safeguards:

### 1. CI Pre-Validation Suite (`tools/levelgen`)
- **Validation Pipeline:** Runs headless solver across all 500 seeds for Phase 7 (`level = 3001` to `3500`):
  - Solvability: 100% of levels must be solvable with **0 hearts lost** and **0 boosters used**.
  - Rotation State Tracking: State space solver models orientation permutation groups ($D_4$) to ensure no deadlock loops.
  - Move Budget: Target difficulty verified against $D \in [60, 76]$ (Finale $D \approx 93$).
  - Overrides: Any seed failing solver constraints within $k = 0..63$ attempts is recorded in `seed_overrides.json`.
- **Performance Budget:** Headless CI validator must solve all 500 levels in $\le 75\text{ seconds}$ total ($\le 150\text{ ms/level}$).

### 2. Shipped Metadata File (`phase_7_meta.bin`)
- Compressed binary asset shipped in the client bundle (Standard §17.34):
  - 500 records $\times$ 16 bytes = 8 KB total footprint.
  - Fields per level: `attempt_k` (1 byte), `par_moves` (1 byte), `difficulty_d` (1 byte), `json_crc32` (4 bytes), `hint_solution_head` (9 bytes packed).
  - Guarantees Nectar Glow Hint solves rotation puzzles instantly on device.

### 3. Remote Config Rollout
- Key: `maxPhase = 7` (default `6` until QA gate passed).
- Gate Criteria:
  - Crash-free user sessions $\ge 99.5\%$.
  - L3001–3500 telemetry confirms zero rotation desynchronization crashes or perimeter wall clipping glitches.

### 4. Phase 7 QA Matrix
| ID | Test Case | Expected Outcome | Status |
|---|---|---|---|
| **P7-QA-01** | Sub-grid coordinate transform | 90° CW rotation correctly transforms all inner cells; outer cells unaffected. | Draft |
| **P7-QA-02** | Line orientation rotation | All lines inside turntable rotate forward direction 90° CW. | Draft |
| **P7-QA-03** | Boundary straddling lock | Line overlapping turntable edge disables center button until line leaves. | Draft |
| **P7-QA-04** | Turning hedge perimeter shift | Outer hedges shift 1 cell CW every N moves; exit gaps move predictably. | Draft |
| **P7-QA-05** | Spinning top line auto-turn | Line turns 90° CW whenever player moves another piece on the board. | Draft |
| **P7-QA-06** | Pinned daisy immunity | Pinned lines do not rotate; anchor turntable button until cleared. | Draft |
| **P7-QA-07** | Layer rotation parity | Ground ants, worker bees, and canopy scouts rotate together cleanly. | Draft |
| **P7-QA-08** | L3500 Whirling Gala Finale | Solvable with 0 hearts and 0 boosters; awards Royal Honey Chest & Virtuoso badge. | Draft |
| **P7-QA-09** | CI 500/500 solver pass | 100% of levels 3001–3500 verified solvable with zero boosters required. | Draft |
| **P7-QA-10** | Offline generation & caching | Levels 3001–3500 generate and cache properly without network connection. | Draft |

## Affected Files
- `tools/levelgen/bin/validate_phase_7.dart` (to be created)
- `packages/puzzle_core/lib/src/meta/meta_reader.dart` (changed to read `phase_7_meta.bin`)
- `lib/features/config/remote_config_service.dart` (changed to support `maxPhase = 7`)

## Risks
- State explosion in IDA* solver due to 4 rotational orientations per line in turntable sectors. Mitigated by canonical symmetry reduction in state hashing.

## Open Questions
- None. QA matrix and rollout keys align with `phase/phase_7/06_UI_AND_QA_PHASE_7.md`.

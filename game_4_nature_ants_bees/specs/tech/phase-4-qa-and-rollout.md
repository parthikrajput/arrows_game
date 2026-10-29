Source docs: phase/phase_4/06_UI_AND_QA_PHASE_4.md, phase/phase_4/01_PHASE_4_SCOPE_AND_RULES.md, SCALING_TO_10000_LEVELS.md §8, §10. Depends on: specs/tech/phase-3-qa-and-rollout.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 4 QA, Performance & Rollout

## Status
Draft

## Type
New Feature

## Goal
Establish the automated CI pre-validation harness, `phase_4_meta.bin` metadata serialization, Remote Config rollout controls, and manual testing matrix for Phase 4 (Levels 1501–2000).

## Current State
Design documented in `phase/phase_4/06_UI_AND_QA_PHASE_4.md` and `SCALING_TO_10000_LEVELS.md`, not yet implemented.
- Phase 3 established CI seed validation for single-floor on-device levels.
- Phase 4 requires validating multi-floor reverse construction and cross-floor reachability.

## Proposed Change
Implement QA tooling, metadata bundling, and release safeguards:

### 1. CI Pre-Validation Suite (`tools/levelgen`)
- **Validation Pipeline:** Runs headless solver across all 500 seeds for Phase 4 (`level = 1501` to `2000`):
  - Solvability: 100% of levels must be solvable with **0 hearts lost** and **0 boosters used**.
  - Multi-Floor Check: Verifies that every insect line starting on upper floors has an unobstructed route to board exit.
  - Move Budget: Target difficulty verified against $D \in [60, 76]$ (Finale $D \approx 92$).
  - Overrides: Any seed failing solver constraints within $k = 0..63$ attempts is recorded in `seed_overrides.json`.
- **Performance Budget:** Headless CI validator must solve all 500 levels in $\le 75\text{ seconds}$ total ($\le 150\text{ ms/level}$).

### 2. Shipped Metadata File (`phase_4_meta.bin`)
- Compressed binary asset shipped in the client bundle (Standard §17.34):
  - 500 records $\times$ 16 bytes = 8 KB total footprint.
  - Fields per level: `attempt_k` (1 byte), `par_moves` (1 byte), `difficulty_d` (1 byte), `json_crc32` (4 bytes), `hint_solution_head` (9 bytes packed).
  - Guarantees Nectar Glow Hint works instantly across multiple floors on device.

### 3. Remote Config Rollout
- Key: `maxPhase = 4` (default `3` until QA gate passed).
- Gate Criteria:
  - Crash-free user sessions $\ge 99.5\%$.
  - L1501–2000 telemetry confirms zero deadlocks or camera glitch reports during floor transitions.

### 4. Phase 4 QA Matrix
| ID | Test Case | Expected Outcome | Status |
|---|---|---|---|
| **P4-QA-01** | Multi-floor data model integrity | Floors array deserializes properly with correct floor IDs and dimensions. | Draft |
| **P4-QA-02** | Root stairs bidirectional transit | Ants traverse up/down stairs; tall stairs carry worker bees. | Draft |
| **P4-QA-03** | Dew-Glass shadow projection | Occupied glass tile blocks corresponding lower tile; clears on exit. | Draft |
| **P4-QA-04** | Rabbit hole one-way drop | Lines fall downward cleanly; cannot enter from lower floor. | Draft |
| **P4-QA-05** | Acorn lift vertical transfer | Tapping lift platform transfers resting line between floors. | Draft |
| **P4-QA-06** | Camera follow on transition | Camera glides smoothly to destination floor when line transits. | Draft |
| **P4-QA-07** | Floor tab manual navigation | Tapping floor tabs scrolls immediately to target terrace view. | Draft |
| **P4-QA-08** | L2000 Summit Gala Finale | Solvable with 0 hearts and 0 boosters across all 3 floors; awards chest. | Draft |
| **P4-QA-09** | CI 500/500 solver pass | 100% of levels 1501–2000 verified solvable with zero boosters required. | Draft |
| **P4-QA-10** | Offline generation & caching | Levels 1501–2000 generate and cache properly without network connection. | Draft |

## Affected Files
- `tools/levelgen/bin/validate_phase_4.dart` (to be created)
- `packages/puzzle_core/lib/src/meta/meta_reader.dart` (changed to read `phase_4_meta.bin`)
- `lib/features/config/remote_config_service.dart` (changed to support `maxPhase = 4`)

## Risks
- Memory retention if off-screen floors are not garbage-collected during extended play sessions. Mitigated by caching floor state in lightweight data structures and rendering only active floor views.

## Open Questions
- None. QA matrix and rollout keys align with `phase/phase_4/06_UI_AND_QA_PHASE_4.md`.


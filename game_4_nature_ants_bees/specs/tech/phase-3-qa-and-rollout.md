Source docs: phase/phase_3/06_UI_AND_QA_PHASE_3.md, phase/phase_3/01_PHASE_3_SCOPE_AND_RULES.md, SCALING_TO_10000_LEVELS.md §8, §10. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/tech/on-device-level-generation.md.

# Spec: Tech — Phase 3 QA, Performance & Rollout

## Status
Draft

## Type
New Feature

## Goal
Establish the automated CI pre-validation harness, `phase_3_meta.bin` metadata serialization, Remote Config rollout controls, and manual testing matrix for Phase 3 (Levels 1001–1500).

## Current State
Design documented in `phase/phase_3/06_UI_AND_QA_PHASE_3.md` and `SCALING_TO_10000_LEVELS.md`, not yet implemented.
- Phases 1 & 2 used static JSON files verified by basic smoke tests.
- Phase 3 requires CI seed validation and pre-computed hint metadata.

## Proposed Change
Implement QA tooling, metadata bundling, and release safeguards:

### 1. CI Pre-Validation Suite (`tools/levelgen`)
- **Validation Pipeline:** Runs headless solver across all 500 seeds for Phase 3 (`level = 1001` to `1500`):
  - Solvability: 100% of levels must be solvable with **0 hearts lost** and **0 boosters used**.
  - Move Budget: Target difficulty verified against $D \in [60, 76]$ (Finale $D \approx 91$).
  - Overrides: Any seed failing solver constraints within $k = 0..63$ attempts is recorded in `seed_overrides.json`.
- **Performance Budget:** Headless CI validator must solve all 500 levels in $\le 60\text{ seconds}$ total ($\le 120\text{ ms/level}$).

### 2. Shipped Metadata File (`phase_3_meta.bin`)
- Compressed binary asset shipped in the client bundle (Standard §17.34):
  - 500 records $\times$ 16 bytes = 8 KB total footprint.
  - Fields per level: `attempt_k` (1 byte), `par_moves` (1 byte), `difficulty_d` (1 byte), `json_crc32` (4 bytes), `hint_solution_head` (9 bytes packed).
  - Guarantees Nectar Glow Hint works instantly on device without running an expensive runtime solver.

### 3. Remote Config Rollout
- Key: `maxPhase = 3` (default `2` until QA gate passed).
- Gate Criteria:
  - Crash-free user sessions $\ge 99.5\%$.
  - L1001–1500 completion telemetry confirms zero unbeatable level deadlocks.

### 4. Phase 3 QA Matrix
| ID | Test Case | Expected Outcome | Status |
|---|---|---|---|
| **P3-QA-01** | Move counting parity | Dial increments strictly on valid moves; boosters and preview do not advance dial. | Draft |
| **P3-QA-02** | Cycle state flip at Move 5 | Day flips to Night exactly after 5th move finishes animation. | Draft |
| **P3-QA-03** | Sunrise Gate blocking | M101 blocks ants at night; tall M101 blocks bees and canopy scouts. | Draft |
| **P3-QA-04** | Moonlit Bridge crossing | M102 acts as bridge at night; plain ground in day (collides if occupied). | Draft |
| **P3-QA-05** | Dawn Burrow portal | M103 teleports lines in day; inert cells at night. | Draft |
| **P3-QA-06** | Day-Bloom color matching | M104 matches color A gates in day, color B gates at night. | Draft |
| **P3-QA-07** | Deterministic seed generation | ARM64 mobile and x64 CI produce identical level JSON for all seeds. | Draft |
| **P3-QA-08** | L1500 Solstice Gala Finale | Solvable with 0 hearts and 0 boosters; awards Royal Honey Chest. | Draft |
| **P3-QA-09** | Battery Saver profile | Enforces Low VFX profile immediately, cycles continue smoothly. | Draft |
| **P3-QA-10** | Offline generation | Generates and loads levels 1001–1500 seamlessly without network connection. | Draft |

## Affected Files
- `tools/levelgen/bin/validate_phase_3.dart` (to be created)
- `packages/puzzle_core/lib/src/meta/meta_reader.dart` (changed to read `phase_3_meta.bin`)
- `lib/features/config/remote_config_service.dart` (changed to support `maxPhase = 3`)

## Risks
- Floating-point PRNG discrepancies between ARM64 and x64 architectures. Mitigated by using pure-integer 64-bit arithmetic (`xoshiro128**`).

## Open Questions
- None. QA matrix and rollout keys align with `phase/phase_3/06_UI_AND_QA_PHASE_3.md`.

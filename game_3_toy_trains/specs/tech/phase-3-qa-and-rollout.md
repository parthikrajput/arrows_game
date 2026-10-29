Source docs: phase/phase_3/06_UI_AND_QA_PHASE_3.md, phase/phase_3/01_PHASE_3_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/frontend-and-qa-phase-2.md, specs/gameplay/phase-3-level-plan-01001-01500.md.

# Spec: Tech — Phase 3 QA Matrix & Rollout Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the CI seed pre-validation pipeline, metadata serialization (`phase_3_meta.bin`), runtime generation performance budgets, Remote Config staged rollout gating, and QA acceptance test checklist for Phase 3 (Levels 1001–1500) of Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_3/06_UI_AND_QA_PHASE_3.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Phases 1 and 2 validated pre-compiled JSON files bundled directly in the application archive.
- Phase 3 shifts content delivery to client-side procedural generation, requiring automated offline seed validation and compact parity metadata.

## Proposed Change
Implement the Phase 3 build pipeline and QA verification harness:

### 1. CI Seed Validation Pipeline (`tools/levelgen`)
- **Coverage:** Automated solver executes against every level seed from $L = 1001$ to $1500$.
- **Acceptance Criteria:**
  - 100% (500/500) levels must prove solvable with 0 hearts lost and 0 boosters used.
  - No level may require wall-clock timers.
  - Each intro level ($x1$) must contain strictly the intro mechanic plus $\le 1$ earlier mechanic.
- **Seed Overrides:** Any level where initial seed $k = 0$ exceeds difficulty tolerance or solver depth is re-seeded ($k \in [1, 63]$) and committed to `assets/levels/seed_overrides.json`.

### 2. Parity & Metadata Serialization (`phase_3_meta.bin`)
- Compressed binary metadata file bundled with the client app (~4 KB for 500 levels).
- Per-level fields:
  - `par_moves`: uint8 (optimal solution length).
  - `min_moves`: uint8 (fastest theoretical exit sequence).
  - `difficulty`: uint8 (scaled $D \times 2$).
  - `mechanic_flags`: uint16 (bitmask of present mechanics).

### 3. Generation Performance Budget
- **Budget Limits:**
  - Low-Tier Devices: $\le \mathbf{250\ ms}$ total generation time per level.
  - Mid/High-Tier Devices: $\le \mathbf{120\ ms}$ total generation time per level.
- **Async Worker:** Generation runs in a separate Dart `Isolate` during the victory screen transition of the preceding level, ensuring zero perceived loading screen latency.

### 4. Remote Config Staged Rollout
- Controlled via Remote Config key `maxPhase`:
  - When `maxPhase < 3`, level map displays a lock at Level 1001: "Phase 3 arriving soon!".
  - Staged percentage rollout: 5% -> 25% -> 50% -> 100% monitoring Crashlytics and level completion rates.

### 5. QA Acceptance Checklist (Phase 3)
All items start with status `Not run`:

| QA ID | Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **QA-P3-01** | Cycle Tick | State flips Day <-> Night exactly when valid `moveCount % 5 == 0`; bumps and boosters do not advance counter. | Not run |
| **QA-P3-02** | Dial HUD | Sun/Moon dial reflects active state; 5 pips advance clockwise; tooltip shows remaining moves. | Not run |
| **QA-P3-03** | M101 Gate | Gate open in active cycle, closed in alternate; hitting closed gate causes buffer clack (-1 heart). | Not run |
| **QA-P3-04** | M102 Bridge | Overpass allows crossing in Day; drops to solid blocking obstacle in Night. | Not run |
| **QA-P3-05** | M103 Tunnel | Tunnel pair open in Day; shutter blocks tunnel entrance in Night. | Not run |
| **QA-P3-06** | M104 Livery | Train switches enamel livery on cycle flip; enters matching color gates only. | Not run |
| **QA-P3-07** | Generation Speed | Levels generate in < 250 ms on low-tier hardware without UI frame drops. | Not run |
| **QA-P3-08** | Seed Override | Level loading uses `seed_overrides.json` seamlessly when $k \ne 0$. | Not run |
| **QA-P3-09** | L1500 Finale | L1500 board features cyclic boss synthesis; awards Grand Central Chest and Badge. | Not run |
| **QA-P3-10** | Rollout Flag | Setting `maxPhase = 2` locks Level 1001 cleanly with "Coming Soon" modal. | Not run |

## Affected Files
- `tools/levelgen/bin/validate_phase_3.dart` (to be created)
- `packages/puzzle_core/lib/src/generator/generator_isolate.dart` (to be created)
- `assets/levels/phase_3_meta.bin` (to be generated)

## Risks
- Crashlytics spikes if a seed produces unsolvable configuration on specific platform architectures. Mitigation: PRNG uses custom `xoshiro128**` with cross-platform integer guarantees.

## Open Questions
- None. Rollout strategy and test cases match `phase/phase_3/06_UI_AND_QA_PHASE_3.md` and `SHARED_CORE_STANDARD.md`.


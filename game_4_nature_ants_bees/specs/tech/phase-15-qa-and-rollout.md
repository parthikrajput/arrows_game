# Spec: Phase 15 QA & Rollout — Brook & Rails (Levels 7001–7500)

Source docs: phase/phase_15/06_UI_AND_QA_PHASE_15.md, phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-15-level-plan-07001-07500.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 15 QA & Rollout — Brook & Rails |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 15 (Levels 7001–7500) |

---

## Goal

Define CI seed validation, QA test matrix, conveyor drift performance limits, Remote Config rollout gates, telemetry logging, and operational risk mitigation for Phase 15 (Brook & Rails).

---

## Current State

Design documented in `phase/phase_15/06_UI_AND_QA_PHASE_15.md` and `phase/phase_15/01_PHASE_15_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation Suite
- All 500 level seeds (L7001–7500) pre-validated via automated CI solver.
- Mandatory checks:
  - [ ] 100% solvable with 0 hearts lost and 0 boosters used.
  - [ ] Graph-based conveyor drift step completes in ≤ 0.2 ms on 14×14 grid.
  - [ ] Grid dimensions conform strictly to 12×12 to 14×14 boundaries.
  - [ ] Line counts remain within 28–40.
  - [ ] Obstacle counts stay within 8–14.
  - [ ] Difficulty curve strictly adheres to plateau D 60–76; L7500 scales to D ≈ 91.
  - [ ] Ant drifting into occupied cells halts cleanly without collisions or heart deductions.
  - [ ] Flying bees cross brook tiles without receiving any drift displacement.
  - [ ] Sluice Levers change flow states without leaving ants trapped in inescapable dead-ends.
  - [ ] Lazy River loops allow ants to be successfully launched toward open exit corridors.
- Seeds failing automated verification are routed to `seed_overrides.json`.

### 2. Phase Binary Metadata
- `phase_15_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Standard 16-byte record: `level_id` (4B), `seed` (4B), `target_d` (2B), `grid_size` (1B), `line_count` (1B), `flags` (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| Conveyor Drift Resolution Budget | ≤ 0.2 ms |
| Conveyor Drift Animation Duration | ≤ 180 ms |
| Frame Rendering Budget (Low Tier) | ≤ 16.7 ms (60 fps) |
| On-Device Level Generation & Load | ≤ 1.5 s |
| Conveyor State Memory Allocation | ≤ 2.0 MB |

### 4. Remote Config Rollout Gate

| Key | Pre-Launch Default | Post-QA Value | Purpose |
|---|---|---|---|
| `maxPhase` | `14` | `15` | Unlock Phase 15 content |
| `p15_brook_drift_anim_ms` | `180` | `180` | Drift animation duration |

- Rollout schedule: 5% → 20% → 100% over 72 hours following full QA sign-off.

### 5. QA Test Matrix

| ID | Test Scenario | Expected Outcome | Status |
|---|---|---|---|
| P15-QA-01 | Ant brook drift | Ant resting on brook tile drifts exactly 1 tile per turn in flow direction | Not run |
| P15-QA-02 | Bee brook immunity | Worker and canopy bees cross brook tiles without any drift displacement | Not run |
| P15-QA-03 | Obstacle drift blockage | Ant drifting into occupied tile halts immediately without bonk or injury | Not run |
| P15-QA-04 | Tidal flow reversal | River reverses direction strictly according to moveCount % reverseEvery | Not run |
| P15-QA-05 | Lazy river loop traversal | Ant line orbits loop continuously until valid exit tap is executed | Not run |
| P15-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI | Not run |
| P15-QA-07 | L7500 Rushing Waters Gala | Finale solvable, awards Royal Honey Chest and River Master badge | Not run |
| P15-QA-08 | Offline conveyor generation | Seed-based generation works seamlessly offline across all devices | Not run |
| P15-QA-09 | Stream junction switching | Sluice Lever reliably flips Brook Fork guide paddle between left and right | Not run |
| P15-QA-10 | Downstream settlement priority | Ants on adjacent stream tiles settle without collision race conditions | Not run |

### 6. Analytics Telemetry

| Event Name | Payload Attributes |
|---|---|
| `phase_15_started` | `{ level_id, player_id }` |
| `ant_drifted` | `{ level_id, stream_id, distance }` |
| `sluice_lever_flipped` | `{ level_id, valve_id, new_branch }` |
| `tidal_reversal_occurred` | `{ level_id, move_count, new_direction }` |
| `lazy_river_ejection` | `{ level_id, loop_id, turns_in_orbit }` |
| `phase_15_finale_cleared` | `{ level_id: 7500, time_ms, moves_taken }` |
| `royal_honey_chest_awarded` | `{ level_id: 7500, badge_id: "river_master" }` |

### 7. Upstream Spec Cross-References
- `specs/tech/on-device-level-generation.md` — Extend generator to lay out continuous stream vectors and junction graphs.
- `specs/gameplay/phase-14-signature-system.md` — Ensure stream drift coordinates correctly with bilateral mirror movement.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/validator/phase_15_validator.dart` | To be created |
| `packages/puzzle_core/lib/generator/brook_and_rails_generator.dart` | To be created |
| `assets/phase_15/phase_15_meta.bin` | To be created |
| `assets/phase_15/seeds/seed_overrides.json` | To be created |
| `packages/analytics/lib/phase_15_events.dart` | To be created |

---

## Risks and Open Questions

1. **Drift into Closed Gate:** When an ant drifts into a closed gate, it must halt smoothly. Ensure that when the gate opens on a subsequent turn, the ant resumes drifting with the current.
2. **Rollback strategy:** If conveyor settlement logic causes state desync, immediately set `maxPhase = 14` via Remote Config.

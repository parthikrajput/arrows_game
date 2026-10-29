# Spec: Phase 14 QA & Rollout — Reflecting Pond (Levels 6501–7000)

Source docs: phase/phase_14/06_UI_AND_QA_PHASE_14.md, phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-14-level-plan-06501-07000.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 14 QA & Rollout — Reflecting Pond |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 14 (Levels 6501–7000) |

---

## Goal

Define CI seed validation, QA test matrix, bilateral symmetry performance budgets, Remote Config rollout gates, telemetry tracking, and operational risk mitigation for Phase 14 (Reflecting Pond).

---

## Current State

Design documented in `phase/phase_14/06_UI_AND_QA_PHASE_14.md` and `phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation Suite
- All 500 level seeds (L6501–7000) pre-validated via automated CI solver.
- Mandatory checks:
  - [ ] 100% solvable with 0 hearts lost and 0 boosters used.
  - [ ] Coordinate reflection and dual-branch collision checks complete in ≤ 0.1 ms.
  - [ ] Grid dimensions strictly conform to 12×12 to 14×14 boundaries.
  - [ ] Line counts remain within 28–40.
  - [ ] Obstacle counts stay within 8–14.
  - [ ] Difficulty follows plateau D 60–76; L7000 scales to D ≈ 91.
  - [ ] All mirrored twin lines are paired with valid, reachable exit paths.
  - [ ] Reflection Locks have accessible key insects across the axis.
  - [ ] Single bonk deduction (−1 Heart) verified when either twin collides.
- Seeds failing automated verification are routed to `seed_overrides.json`.

### 2. Phase Binary Metadata
- `phase_14_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Standard 16-byte record: `level_id` (4B), `seed` (4B), `target_d` (2B), `grid_size` (1B), `line_count` (1B), `flags` (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| Bilateral Symmetry Matrix Calculation | ≤ 0.1 ms |
| Frame Rendering Budget (Low Tier) | ≤ 16.7 ms (60 fps) |
| On-Device Level Generation & Load | ≤ 1.5 s |
| Water Ripple Shader Overhead | ≤ 1.5 ms GPU |
| Mirror State Memory Allocation | ≤ 2.0 MB |

### 4. Remote Config Rollout Gate

| Key | Pre-Launch Default | Post-QA Value | Purpose |
|---|---|---|---|
| `maxPhase` | `13` | `14` | Unlock Phase 14 content |
| `p14_water_ripple_hz` | `1.5` | `1.5` | Water ripple animation rate |

- Rollout schedule: 5% → 20% → 100% over 72 hours following full QA sign-off.

### 5. QA Test Matrix

| ID | Test Scenario | Expected Outcome | Status |
|---|---|---|---|
| P14-QA-01 | Pond axis bilateral movement | Tapping line initiates simultaneous movement of both origin and mirrored twin | Not run |
| P14-QA-02 | Single bonk penalty | If either mirrored twin bonks into an obstacle, single -1 Heart is deducted | Not run |
| P14-QA-03 | Reflection lock remote unlock | Key insect exiting on side B immediately dissolves reflection lock on side A | Not run |
| P14-QA-04 | Twin pond synchronized tap | Tap on Pond 1 triggers exact matching coordinate line on Pond 2 | Not run |
| P14-QA-05 | Upside-down line reverse direction | Line moves strictly opposite to shown head direction along axis | Not run |
| P14-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI | Not run |
| P14-QA-07 | L7000 Mirrored Solstice Gala | Finale solvable, awards Royal Honey Chest and Mirror Mirage Master badge | Not run |
| P14-QA-08 | Offline mirror generation | Seed-based generation works seamlessly offline across all devices | Not run |
| P14-QA-09 | Non-integer axis reflection | Reflections on even grids calculate exact integer target coordinates | Not run |
| P14-QA-10 | Asymmetric exit timing | First twin exiting clears smoothly while second twin finishes journey | Not run |

### 6. Analytics Telemetry

| Event Name | Payload Attributes |
|---|---|
| `phase_14_started` | `{ level_id, player_id }` |
| `mirrored_move_executed` | `{ level_id, twin_pair_id, steps }` |
| `reflection_lock_unlocked` | `{ level_id, lock_id, key_shore }` |
| `twin_pond_tap_dispatched` | `{ level_id, coord, dual_success: bool }` |
| `upside_down_line_moved` | `{ level_id, apparent_dir, actual_dir }` |
| `phase_14_finale_cleared` | `{ level_id: 7000, time_ms, moves_taken }` |
| `royal_honey_chest_awarded` | `{ level_id: 7000, badge_id: "mirror_mirage_master" }` |

### 7. Upstream Spec Cross-References
- `specs/tech/on-device-level-generation.md` — Extend generator to produce symmetric insect pairings with asymmetric obstacle layouts.
- `specs/gameplay/phase-13-signature-system.md` — Verify mirrored lines interact properly with fog shrouds across the pond axis.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/validator/phase_14_validator.dart` | To be created |
| `packages/puzzle_core/lib/generator/reflecting_pond_generator.dart` | To be created |
| `assets/phase_14/phase_14_meta.bin` | To be created |
| `assets/phase_14/seeds/seed_overrides.json` | To be created |
| `packages/analytics/lib/phase_14_events.dart` | To be created |

---

## Risks and Open Questions

1. **Simultaneous Exit Scent Trail Lag:** When both mirrored twins exit within milliseconds, double completion chimes and score popups must not clash or drop audio channels.
2. **Rollback strategy:** If reflection matrix math causes softlocks, revert `maxPhase = 13` immediately via Remote Config.

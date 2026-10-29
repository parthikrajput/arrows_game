# Spec: Phase 19 QA & Rollout — Garden Festival II (Levels 9001–9500)

Source docs: phase/phase_19/06_UI_AND_QA_PHASE_19.md, phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-19-level-plan-09001-09500.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 19 QA & Rollout — Garden Festival II |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 19 (Levels 9001–9500) |

---

## Goal

Define CI seed validation, QA test matrix, kinetic multi-system settlement performance limits, Remote Config rollout gates, telemetry logging, and operational risk mitigation for Phase 19 (Garden Festival II).

---

## Current State

Design documented in `phase/phase_19/06_UI_AND_QA_PHASE_19.md` and `phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation Suite
- All 500 level seeds (L9001–9500) pre-validated via automated CI solver.
- Mandatory checks:
  - [ ] 100% solvable with 0 hearts lost and 0 boosters used.
  - [ ] Multi-system kinetic settlement (rotor + gravity + growth) completes in $\le 0.3\text{ ms}$.
  - [ ] Grid dimensions conform strictly to 12×12 to 14×14 boundaries.
  - [ ] Line counts remain within 28–40 across active layers.
  - [ ] Obstacle counts stay within 8–14.
  - [ ] Difficulty curve strictly adheres to plateau D 60–76; L9500 scales to D ≈ 91.
  - [ ] Falling vines expand orthogonally and slide downward strictly per settlement tick order.
  - [ ] Rhythm rotor turns 90° CW automatically strictly on modulo moves without player tap.
  - [ ] Twin-garden fork creates simultaneous lines across Board A and Board B without deadlock.
  - [ ] Gravity turntable updates local gravity vector and settles loose debris independently.
- Seeds failing automated verification are routed to `seed_overrides.json`.

### 2. Phase Binary Metadata
- `phase_19_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Standard 16-byte record: `level_id` (4B), `seed` (4B), `target_d` (2B), `grid_size` (1B), `line_count` (1B), `flags` (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| Kinetic Settlement Solver Step | ≤ 0.3 ms |
| Sub-Board Rotor Turn Animation Duration | ≤ 200 ms |
| Frame Rendering Budget (Low Tier) | ≤ 16.7 ms (60 fps) |
| On-Device Level Generation & Load | ≤ 1.5 s |
| Kinetic State Memory Allocation | ≤ 2.5 MB |

### 4. Remote Config Rollout Gate
- **Flag:** `maxPhase = 19` (enables Levels 9001–9500 in production).
- **Rollout Schedule:**
  - Internal Dogfood: Day 1 (100%).
  - Canary: Day 3 (5% active users).
  - Staged Rollout: Day 5 (25%), Day 7 (50%), Day 10 (100%).
- **Kill-Switch / Fallback:**
  - If crash rate exceeds 0.5% or unsolvability reports emerge, set `maxPhase = 18`.
  - Tweakable parameter: `p19_combo_selection_version` (default 1, selects active combo candidate snapshot).

### 5. Telemetry & Analytics Events

| Event Name | Key Parameters | Purpose |
|---|---|---|
| `p19_vine_expanded` | `level_id`, `cells_grown`, `gravity_direction` | Tracks falling vine expansion rate. |
| `p19_rotor_auto_turned` | `level_id`, `move_count`, `lines_rotated` | Monitors automatic rhythm rotor turns. |
| `p19_cross_board_split` | `level_id`, `board_a_id`, `board_b_id` | Evaluates dual-board fork traversal. |
| `p19_gravity_turntable_rotated`| `level_id`, `new_gravity_angle` | Tracks sector gravity manipulations. |
| `p19_level_complete` | `level_id`, `duration_s`, `stars`, `boosters_used` | General completion health and difficulty telemetry. |

### 6. QA Test Matrix

| ID | Test Description | Expected Result | Priority |
|---|---|---|---|
| P19-QA-01 | Falling vines multi-step | Vines expand orthogonally and slide with gravity according to tick order. | P0 |
| P19-QA-02 | Rhythm rotor auto rotation | Sub-grid sector turns 90° CW strictly on modulo beats without player tap. | P0 |
| P19-QA-03 | Twin-garden fork division | One half moves within Board A; second half exits into matching Board B tile. | P0 |
| P19-QA-04 | Gravity turntable sector shift | Local items slide according to sector's rotated gravity vector independently. | P0 |
| P19-QA-05 | Order of settlement verification| Player move $\to$ rotor turn $\to$ gravity drift $\to$ vine growth settles cleanly. | P0 |
| P19-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | P0 |
| P19-QA-07 | L9500 Winds & Blooms Gala | Finale solvable, awards Royal Honey Chest and Master Composer badge. | P0 |
| P19-QA-08 | Offline kinetic generation | Seed-based generation works seamlessly offline across all devices. | P1 |

---

## Verification Plan

### Automated Tests
1. Run CI test suite covering all 500 Phase 19 seeds (`test_phase_19_generation.dart`).
2. Run memory leak check during continuous 50-level kinetic playthroughs.

### Manual Verification
1. Verify auto-rotor turn does not intercept or discard user tap input in flight.
2. Verify remote config flag toggle locks/unlocks access cleanly.

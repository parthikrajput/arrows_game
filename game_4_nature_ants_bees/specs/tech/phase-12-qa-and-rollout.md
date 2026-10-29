# Spec: Phase 12 QA & Rollout — Falling Leaves (Levels 5501–6000)

Source docs: phase/phase_12/06_UI_AND_QA_PHASE_12.md, phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-12-level-plan-05501-06000.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 12 QA & Rollout — Falling Leaves |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 12 (Levels 5501–6000) |

---

## Goal

Define CI seed validation, QA test matrix, gravity settlement performance budgets, Remote Config rollout gates, telemetry tracking, and operational risk mitigation for Phase 12 (Falling Leaves).

---

## Current State

Design documented in `phase/phase_12/06_UI_AND_QA_PHASE_12.md` and `phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation Suite
- All 500 level seeds (L5501–6000) pre-validated via automated CI solver.
- Mandatory checks:
  - [ ] 100% solvable with 0 hearts lost and 0 boosters used.
  - [ ] Gravity settlement scanning across 14×14 grid completes in ≤ 0.3 ms.
  - [ ] Grid dimensions conform to 12×12 to 14×14 bounds.
  - [ ] Line counts remain within 28–40.
  - [ ] Obstacle counts stay within 8–14.
  - [ ] Difficulty band strictly follows plateau D 60–76; L6000 scales to D ≈ 91.
  - [ ] Wind-Vane Lever shifts $\vec{g}$ without causing irrecoverable blocker traps.
  - [ ] Falling Acorns never trap lines without an alternative route or gravity shift.
  - [ ] Dandelion Puff Tiles guarantee zero-gravity immunity for rested items.
  - [ ] Flying bees remain unaffected by gravity across all test vectors.
- Any seed failing automated verification moves to `seed_overrides.json`.

### 2. Phase Binary Metadata
- `phase_12_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Standard 16-byte record: `level_id` (4B), `seed` (4B), `target_d` (2B), `grid_size` (1B), `line_count` (1B), `flags` (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| Gravity Settlement Calculation (14×14 grid) | ≤ 0.3 ms |
| Item Slide Animation Duration | ≤ 150 ms |
| Frame Rendering Budget (Low Tier) | ≤ 16.7 ms (60 fps) |
| On-Device Level Generation & Load | ≤ 1.5 s |
| Gravity State Memory Allocation | ≤ 2.0 MB |

### 4. Remote Config Rollout Gate

| Key | Pre-Launch Default | Post-QA Value | Purpose |
|---|---|---|---|
| `maxPhase` | `11` | `12` | Unlock Phase 12 content |
| `p12_gravity_slide_anim_ms` | `150` | `150` | Slide animation duration |

- Rollout schedule: 5% → 20% → 100% over 72 hours following full QA sign-off.

### 5. QA Test Matrix

| ID | Test Scenario | Expected Outcome | Status |
|---|---|---|---|
| P12-QA-01 | Wind-vane gravity vector change | Tapping lever changes global gravity vector reliably through U, L, D, R | Not run |
| P12-QA-02 | Falling acorn single step | Loose acorn drops exactly 1 tile per player move until hitting obstacle | Not run |
| P12-QA-03 | Dandelion puff immunity | Acorn or beetle resting on dandelion tile remains completely motionless | Not run |
| P12-QA-04 | Heavy beetle directional drift | Heavy beetle shifts with gravity; worker and scout bees fly unaffected | Not run |
| P12-QA-05 | Insect protection check | Falling items never land on or crush another insect; stop immediately adjacent | Not run |
| P12-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI | Not run |
| P12-QA-07 | L6000 Autumn Gale Gala | Finale solvable, awards Royal Honey Chest and Wind Whisperer badge | Not run |
| P12-QA-08 | Offline gravity generation | Seed-based generation works seamlessly offline across all devices | Not run |
| P12-QA-09 | Non-crush boundary test | Falling item meeting board boundary halts cleanly without clip or glitch | Not run |
| P12-QA-10 | Booster interaction | Leaf Blower clears falling acorns and restores clear corridor | Not run |

### 6. Analytics Telemetry

| Event Name | Payload Attributes |
|---|---|
| `phase_12_started` | `{ level_id, player_id }` |
| `gravity_lever_toggled` | `{ level_id, old_vector, new_vector }` |
| `acorn_settled` | `{ level_id, distance_fallen, resting_tile }` |
| `dandelion_tile_used` | `{ level_id, entity_type }` |
| `heavy_beetle_drifted` | `{ level_id, drift_direction, step_count }` |
| `phase_12_finale_cleared` | `{ level_id: 6000, time_ms, moves_taken }` |
| `royal_honey_chest_awarded` | `{ level_id: 6000, badge_id: "wind_whisperer" }` |

### 7. Upstream Spec Cross-References
- `specs/tech/on-device-level-generation.md` — Incorporate directional gravity rules and settlement steps into procedural level generation.
- `specs/gameplay/phase-11-signature-system.md` — Verify gravity vectors function independently across linked dual boards.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/validator/phase_12_validator.dart` | To be created |
| `packages/puzzle_core/lib/generator/falling_leaves_generator.dart` | To be created |
| `assets/phase_12/phase_12_meta.bin` | To be created |
| `assets/phase_12/seeds/seed_overrides.json` | To be created |
| `packages/analytics/lib/phase_12_events.dart` | To be created |

---

## Risks and Open Questions

1. **Simultaneous Multi-Acorn Settlement:** Ensure collision resolution between two adjacent falling items maintains predictable determinism without race conditions.
2. **Rollback strategy:** If gravity simulation crashes older devices, immediately set `maxPhase = 11` via Remote Config.

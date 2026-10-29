# Spec: Phase 13 QA & Rollout — Mystery Meadow (Levels 6001–6500)

Source docs: phase/phase_13/06_UI_AND_QA_PHASE_13.md, phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-13-level-plan-06001-06500.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 13 QA & Rollout — Mystery Meadow |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 13 (Levels 6001–6500) |

---

## Goal

Define CI seed validation, QA test matrix, fog rendering performance limits, Remote Config rollout gates, telemetry tracking, and operational risk mitigation for Phase 13 (Mystery Meadow).

---

## Current State

Design documented in `phase/phase_13/06_UI_AND_QA_PHASE_13.md` and `phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation Suite
- All 500 level seeds (L6001–6500) pre-validated via automated CI solver.
- Mandatory verification points:
  - [ ] 100% solvable with 0 hearts lost and 0 boosters used.
  - [ ] Fog mask compositing and Chebyshev distance checks execute in ≤ 0.3 ms.
  - [ ] Grid dimensions conform strictly to 12×12 to 14×14 boundaries.
  - [ ] Line counts remain within 28–40.
  - [ ] Obstacle counts stay within 8–14.
  - [ ] Difficulty curve strictly adheres to plateau D 60–76; L6500 scales to D ≈ 91.
  - [ ] Every level with concealed lines has at least one accessible, interactive Scout Ant or Sunlit Plate visible at level start.
  - [ ] Mirage Mist triggers never create inescapable deadlocks.
  - [ ] Painted Pebbles permit unimpeded insect passage without collision bonks.
- Seeds failing automated verification are written to `seed_overrides.json`.

### 2. Phase Binary Metadata
- `phase_13_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Standard 16-byte record: `level_id` (4B), `seed` (4B), `target_d` (2B), `grid_size` (1B), `line_count` (1B), `flags` (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| Fog Mask Compositing Budget | ≤ 0.3 ms |
| Fog Dissolve Animation Duration | ≤ 200 ms |
| Frame Rendering Budget (Low Tier) | ≤ 16.7 ms (60 fps) |
| On-Device Level Generation & Load | ≤ 1.5 s |
| Fog State Memory Footprint | ≤ 2.0 MB |

### 4. Remote Config Rollout Gate

| Key | Pre-Launch Default | Post-QA Value | Purpose |
|---|---|---|---|
| `maxPhase` | `12` | `13` | Unlock Phase 13 content |
| `p13_fog_dissolve_ms` | `200` | `200` | Fog clearing animation duration |

- Rollout schedule: 5% → 20% → 100% over 72 hours following full QA sign-off.

### 5. QA Test Matrix

| ID | Test Scenario | Expected Outcome | Status |
|---|---|---|---|
| P13-QA-01 | Scout ant fog clearance | Exiting scout clears all fog within Chebyshev radius 2 of entire exit path | Not run |
| P13-QA-02 | Fogged insect tap guard | Attempting to tap concealed insect under fog is rejected ("Scout needed!") | Not run |
| P13-QA-03 | Mirage mist proximity trigger | Line passing orthogonally adjacent instantly generates 3x3 fog bank | Not run |
| P13-QA-04 | Painted pebble passage | Insect moves directly through painted pebble without bonk (-0 hearts) | Not run |
| P13-QA-05 | Sunlit plate row/column reveal | Ant standing on plate reveals all hidden lines in its row and column | Not run |
| P13-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI | Not run |
| P13-QA-07 | L6500 Solstice Dawn Gala | Finale solvable, awards Royal Honey Chest and Meadow Clairvoyant badge | Not run |
| P13-QA-08 | Offline fog generation | Seed-based generation works seamlessly offline across all devices | Not run |
| P13-QA-09 | Scent trail preview false wall | Preview over Painted Pebble shows yellow "?" and allows simulated drag | Not run |
| P13-QA-10 | Sunlit plate departure re-shroud | Vacating Sunlit Plate re-cloaks non-permanently cleared cells smoothly | Not run |

### 6. Analytics Telemetry

| Event Name | Payload Attributes |
|---|---|
| `phase_13_started` | `{ level_id, player_id }` |
| `scout_ant_exited` | `{ level_id, cleared_tiles_count }` |
| `mirage_mist_triggered` | `{ level_id, re_shrouded_lines_count }` |
| `painted_pebble_traversed` | `{ level_id, pebble_id }` |
| `sunlit_plate_occupied` | `{ level_id, revealed_lines_count }` |
| `phase_13_finale_cleared` | `{ level_id: 6500, time_ms, moves_taken }` |
| `royal_honey_chest_awarded` | `{ level_id: 6500, badge_id: "meadow_clairvoyant" }` |

### 7. Upstream Spec Cross-References
- `specs/tech/on-device-level-generation.md` — Extend generator to place initial fog masks and guarantee early scout accessibility.
- `specs/gameplay/phase-12-signature-system.md` — Verify falling acorns and heavy beetles correctly interact with fogged tiles.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/validator/phase_13_validator.dart` | To be created |
| `packages/puzzle_core/lib/generator/mystery_meadow_generator.dart` | To be created |
| `assets/phase_13/phase_13_meta.bin` | To be created |
| `assets/phase_13/seeds/seed_overrides.json` | To be created |
| `packages/analytics/lib/phase_13_events.dart` | To be created |

---

## Risks and Open Questions

1. **Re-fogging player frustration:** If an M602 mist triggers late in a puzzle, re-shrouding paths may frustrate players. Levels must ensure mirage mist triggers are early-stage or bypassable.
2. **Rollback strategy:** If fog shader causes GPU crashes on older devices, revert `maxPhase = 12` immediately via Remote Config.

# Spec: Phase 8 QA & Rollout — Bloom Season (Levels 3501–4000)

Source docs: phase/phase_8/06_UI_AND_QA_PHASE_8.md, phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-8-level-plan-03501-04000.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 8 QA & Rollout — Bloom Season |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 8 (Levels 3501–4000) |

---

## Goal

Define CI seed validation, QA checklist, performance budgets, Remote Config rollout gate, analytics events, and known risks for Phase 8 (Bloom Season) release.

---

## Current State

Design documented in phase/phase_8/06_UI_AND_QA_PHASE_8.md and phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation
- All 500 level seeds (L3501–4000) must be pre-validated in CI.
- Validator checks:
  - [ ] Solvable in 0 hearts lost, 0 boosters required.
  - [ ] Vine expansion BFS completes in ≤ 0.4 ms on 14×14 grid.
  - [ ] Grid size within 12×12 to 14×14.
  - [ ] Line count within 28–40.
  - [ ] Obstacle count within 8–14.
  - [ ] D value within tier band (D 60–76 plateau; D ≈ 91 for L4000 finale tag).
  - [ ] Seed-Dropping Line seeds always have a reachable trample path before countdown.
  - [ ] Pollination Gate K value achievable given the level layout.
  - [ ] Vine max cap (48 cells) never makes level unsolvable.
- CI failure: failing seeds go to `seed_overrides.json`; override must pass same checks.

### 2. Phase Meta Data
- `phase_8_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Fields per record: level_id (4B), seed (4B), D_value (2B), grid_size (1B), line_count (1B), flags (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| Vine expansion BFS (14×14 grid) | ≤ 0.4 ms |
| Frame time (Low tier device) | ≤ 16.7 ms (60 fps) |
| Level load time | ≤ 1.5 s |
| Memory overhead (vine state) | ≤ 2 MB |

### 4. Remote Config Rollout

| Key | Pre-Launch Default | Post-QA Value | Purpose |
|---|---|---|---|
| `maxPhase` | `7` | `8` | Unlock Phase 8 content |
| `p8_vine_max_spread_cells` | `48` | `48` | Per-level vine cap |

- Phase 8 content remains hidden until `maxPhase = 8` is set in Remote Config.
- Staged rollout: 5% → 20% → 100% over 72 hours post-QA gate.

### 5. QA Checklist

| ID | Test | Expected Result | Status |
|---|---|---|---|
| P8-QA-01 | Morning glory cross-expansion | Vines grow exactly 1 cell into free orthogonal cells every N moves | Not run |
| P8-QA-02 | Shears vine pruning | Passing lane over shears removes all 4 orthogonally adjacent vine cells | Not run |
| P8-QA-03 | Seed line drop & countdown | Exiting line drops seed at head cell; counts down N moves to blocker | Not run |
| P8-QA-04 | Seed lane trample | Passing same-layer line over unsprouted seed removes the seed safely | Not run |
| P8-QA-05 | Pollination gate requirement | Exactly K adjacent exits required to permanently open pollination gate | Not run |
| P8-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI | Not run |
| P8-QA-07 | L4000 Eternal Bloom Gala | Finale solvable, awards Royal Honey Chest and Master Florist badge | Not run |
| P8-QA-08 | Offline growth generation | Seed-based generation works seamlessly offline on all supported devices | Not run |
| P8-QA-09 | Vine cap enforcement | Vine stops expanding at 48 cells; level remains solvable at cap | Not run |
| P8-QA-10 | Frozen vine + shears | Verify behaviour when Frozen(K) vine is adjacent to shears (see Open Questions) | Not run |

### 6. Analytics Events

| Event | Payload |
|---|---|
| `phase_8_started` | `{ level_id, player_id }` |
| `vine_expanded` | `{ level_id, move_count, cells_added }` |
| `shears_triggered` | `{ level_id, vines_pruned }` |
| `seed_sprouted` | `{ level_id, blocker_created: true }` |
| `seed_trampled` | `{ level_id }` |
| `pollination_gate_opened` | `{ level_id, gate_id, moves_taken }` |
| `phase_8_finale_cleared` | `{ level_id: 4000, player_id, time_ms }` |
| `royal_honey_chest_awarded` | `{ level_id: 4000 }` |

### 7. Earlier Specs Requiring Updates
The following earlier specs may need updates due to Phase 8 additions (do not edit here — list only):
- `specs/gameplay/phase-7-signature-system.md` — confirm Rotation mechanics correctly interact with vine expansion in mixed levels.
- `specs/tech/on-device-level-generation.md` — add vine BFS simulation to generator steps.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/validator/phase_8_validator.dart` | To be created |
| `packages/puzzle_core/lib/generator/bloom_season_generator.dart` | To be created |
| `assets/phase_8/phase_8_meta.bin` | To be created |
| `assets/phase_8/seeds/seed_overrides.json` | To be created |
| `packages/analytics/lib/phase_8_events.dart` | To be created |

---

## Risks and Open Questions

1. **Frozen vine + shears interaction:** Behaviour when a `Frozen(K)` vine is adjacent to Garden Shears at snip time is undefined. Must be resolved before P8-QA-10 can be run.
2. **Vine BFS performance on low-tier devices:** 0.4 ms budget is tight on low-tier Android devices at 14×14 with 48 vine cells. Profiling needed early in implementation.
3. **Seed head cell fallback:** If the Seed-Dropping Line's head cell is occupied at exit time, seed drop behaviour is undefined. Must be resolved before M353 implementation.
4. **Staged rollout risk:** If a critical vine expansion bug is found after 5% rollout, `maxPhase` must be reverted to 7 immediately. Confirm rollback procedure is documented.

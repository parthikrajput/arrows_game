# Spec: Phase 11 QA & Rollout — Twin Gardens (Levels 5001–5500)

Source docs: phase/phase_11/06_UI_AND_QA_PHASE_11.md, phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-11-level-plan-05001-05500.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 11 QA & Rollout — Twin Gardens |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 11 (Levels 5001–5500) |

---

## Goal

Define CI seed validation, QA test matrix, dual-viewport performance constraints, Remote Config rollout gates, telemetry tracking, and operational risk mitigation for Phase 11 (Twin Gardens).

---

## Current State

Design documented in `phase/phase_11/06_UI_AND_QA_PHASE_11.md` and `phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation Suite
- All 500 level seeds (L5001–5500) pre-validated via headless CI solver.
- Mandatory checks:
  - [ ] 100% solvable with 0 hearts lost and 0 boosters used.
  - [ ] Cross-board link pathfinding evaluates within ≤ 0.3 ms across both boards.
  - [ ] Both boards stay within 12×12 to 14×14 per-board dimension limits.
  - [ ] Total line counts remain within 28–40 across both boards combined.
  - [ ] Obstacle instances stay within 8–14 across both boards.
  - [ ] Difficulty conforms to plateau D 60–76; L5500 finale scales to D ≈ 91.
  - [ ] All cross-board links (M501, M504) map to valid, unblocked arrival cells.
  - [ ] Pen-Pal Key dependencies on Board A are verified acyclic and fully reachable.
  - [ ] Synchronized mirror lines (M503) have valid collision-free paths on both boards.
- Seeds failing CI validation are written to `seed_overrides.json`.

### 2. Phase Binary Metadata
- `phase_11_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Standard 16-byte record: `level_id` (4B), `seed` (4B), `target_d` (2B), `grid_size` (1B), `line_count` (1B), `flags` (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| Dual Viewport Memory Footprint (Texture Memory) | ≤ 45 MB |
| Viewport Pan Duration | ≤ 250 ms |
| Frame Rendering Budget (Low Tier) | ≤ 16.7 ms (60 fps) |
| On-Device Level Generation & Load | ≤ 1.5 s |

### 4. Remote Config Rollout Gate

| Key | Pre-Launch Default | Post-QA Value | Purpose |
|---|---|---|---|
| `maxPhase` | `10` | `11` | Unlock Phase 11 content |
| `p11_board_pan_ms` | `250` | `250` | Camera pan animation speed |

- Rollout schedule: 5% → 20% → 100% over 72 hours following full QA sign-off.

### 5. QA Test Matrix

| ID | Test Scenario | Expected Outcome | Status |
|---|---|---|---|
| P11-QA-01 | Gate link cross-board entrance | Line exiting Board A appears seamlessly at matching Board B edge cell | Not run |
| P11-QA-02 | Destination board obstruction | If Board B entrance is blocked, line bonks on Board A with zero teleport | Not run |
| P11-QA-03 | Pen-Pal key remote unlock | Key exit on Board A immediately clears linked lock on Board B | Not run |
| P11-QA-04 | Mirror twin synchronous movement | Tapping twin on Board A moves Board B twin; obstacle collision causes bonk | Not run |
| P11-QA-05 | Relay burrow ant-only check | Ant enters burrow and exits Board B; bee cannot enter burrow | Not run |
| P11-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI | Not run |
| P11-QA-07 | L5500 Twin Garden Jubilee | Finale solvable, awards Royal Honey Chest and Twin Realm Navigator badge | Not run |
| P11-QA-08 | Offline dual-board generation | Seed-based generation works seamlessly offline across all devices | Not run |
| P11-QA-09 | Viewport camera pan | Panning between Board A and Board B executes smoothly in ≤ 250 ms without jitter | Not run |
| P11-QA-10 | Dual board memory footprint | Texture memory remains ≤ 45 MB during active gameplay on low-end devices | Not run |

### 6. Analytics Telemetry

| Event Name | Payload Attributes |
|---|---|
| `phase_11_started` | `{ level_id, player_id }` |
| `cross_board_link_traversed` | `{ level_id, from_board, to_board, coord }` |
| `pen_pal_key_unlocked` | `{ level_id, key_id, target_lock_id }` |
| `mirror_twin_synchronized` | `{ level_id, twin_id, simultaneous_exit: bool }` |
| `relay_burrow_used` | `{ level_id, burrow_id, ant_length }` |
| `phase_11_finale_cleared` | `{ level_id: 5500, time_ms, moves_taken }` |
| `royal_honey_chest_awarded` | `{ level_id: 5500, badge_id: "twin_realm_navigator" }` |

### 7. Upstream Spec Cross-References
- `specs/tech/on-device-level-generation.md` — Extend generator data structures to output dual-board grid schemas.
- `specs/gameplay/phase-10-signature-system.md` — Ensure rhythm modulo checks evaluate synchronously across both linked boards.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/validator/phase_11_validator.dart` | To be created |
| `packages/puzzle_core/lib/generator/twin_gardens_generator.dart` | To be created |
| `assets/phase_11/phase_11_meta.bin` | To be created |
| `assets/phase_11/seeds/seed_overrides.json` | To be created |
| `packages/analytics/lib/phase_11_events.dart` | To be created |

---

## Risks and Open Questions

1. **Low-Memory Device Crash Risk:** Concurrently hosting two boards in memory may cause out-of-memory terminations on older 2GB RAM Android devices. Viewport cull optimizations must be implemented.
2. **Rollback strategy:** If fatal cross-board synchronization issues occur in production, revert `maxPhase = 10` immediately via Remote Config.

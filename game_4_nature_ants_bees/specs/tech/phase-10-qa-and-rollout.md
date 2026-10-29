# Spec: Phase 10 QA & Rollout — Garden Rhythm (Levels 4501–5000)

Source docs: phase/phase_10/06_UI_AND_QA_PHASE_10.md, phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-10-level-plan-04501-05000.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 10 QA & Rollout — Garden Rhythm |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 10 (Levels 4501–5000) |

---

## Goal

Define CI seed validation, QA test matrix, performance limits, Remote Config rollout gates, telemetry logging, and risk mitigation for Phase 10 (Garden Rhythm).

---

## Current State

Design documented in `phase/phase_10/06_UI_AND_QA_PHASE_10.md` and `phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation Suite
- All 500 level seeds (L4501–5000) pre-validated via headless CI solver.
- Mandatory verification points:
  - [ ] 100% solvable with 0 hearts lost and 0 boosters used.
  - [ ] Rhythm modulo evaluation and FIFO pattern comparison execute in ≤ 0.1 ms.
  - [ ] Grid bounds maintain 12×12 to 14×14 limit.
  - [ ] Line counts remain within 28–40.
  - [ ] Obstacle instances stay within 8–14.
  - [ ] Difficulty follows plateau D 60–76; L5000 scales to D ≈ 91.
  - [ ] Cricket Gate modulo configuration ($P \in [2, 4]$) guarantees at least one valid escape path window.
  - [ ] Bead-String Locks are supplied with sufficient coloured lines in level layout.
  - [ ] Queue Hedges have unambiguous, monotonic exit paths for 1, 2, 3...
  - [ ] Echo Bloom seeds guarantee identical colour distributions between Phase 1 and Phase 2.
- Seeds failing CI checks move to `seed_overrides.json`.

### 2. Phase Binary Metadata
- `phase_10_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Standard 16-byte record: `level_id` (4B), `seed` (4B), `target_d` (2B), `grid_size` (1B), `line_count` (1B), `flags` (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| Rhythm Engine Evaluation (modulo + FIFO matching) | ≤ 0.1 ms |
| Frame Rendering Budget (Low Tier) | ≤ 16.7 ms (60 fps) |
| Level Load Time | ≤ 1.5 s |
| Rhythm State Memory Allocation | ≤ 2.0 MB |

### 4. Remote Config Rollout Gate

| Key | Pre-Launch Default | Post-QA Value | Purpose |
|---|---|---|---|
| `maxPhase` | `9` | `10` | Unlock Phase 10 content |
| `p10_rhythm_pulse_intensity` | `1.0` | `1.0` | Rhythm UI glow intensity |

- Rollout schedule: 5% → 20% → 100% over 72 hours following full regression pass.

### 5. QA Test Matrix

| ID | Test Scenario | Expected Outcome | Status |
|---|---|---|---|
| P10-QA-01 | Cricket gate modulo opening | Gate opens strictly when moveCount % P in S; closes on non-matching moves | Not run |
| P10-QA-02 | Bead-string color match | Gate opens only when consecutive exits match target color string exactly | Not run |
| P10-QA-03 | Bead-string wrong color reset | Wrong color exit resets progress without crash or invalid state | Not run |
| P10-QA-04 | Queue hedge order enforcement | Line entering out of numerical order bonks (-1 Heart); correct order passes | Not run |
| P10-QA-05 | Echo bloom playback tap guard | Tapping out-of-order color in playback phase shakes gently with zero heart loss | Not run |
| P10-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI | Not run |
| P10-QA-07 | L5000 Mid-Season Symphony | Finale solvable, awards Royal Honey Chest and Rhythm Maestro badge | Not run |
| P10-QA-08 | Offline rhythm generation | Seed-based generation works seamlessly offline across all devices | Not run |
| P10-QA-09 | Non-colour accessibility | Color-blind users can identify beads and gates using embossed shapes | Not run |
| P10-QA-10 | Modulo deadlock prevention | Solver confirms no level seed requires a move count that locks all gates | Not run |

### 6. Analytics Telemetry

| Event Name | Payload Attributes |
|---|---|
| `phase_10_started` | `{ level_id, player_id }` |
| `cricket_gate_traversed` | `{ level_id, gate_id, move_count }` |
| `bead_pattern_matched` | `{ level_id, pattern_length, attempts }` |
| `queue_order_completed` | `{ level_id, max_queue_index }` |
| `echo_bloom_harmonized` | `{ level_id, recording_moves, playback_moves }` |
| `phase_10_finale_cleared` | `{ level_id: 5000, time_ms, moves_taken }` |
| `royal_honey_chest_awarded` | `{ level_id: 5000, badge_id: "rhythm_maestro" }` |

### 7. Upstream Spec Cross-References
- `specs/tech/on-device-level-generation.md` — Incorporate rhythm modulo and FIFO sequences into procedural generator parameters.
- `specs/gameplay/phase-9-signature-system.md` — Ensure split caravan branches interact properly with queue ordering constraints.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/validator/phase_10_validator.dart` | To be created |
| `packages/puzzle_core/lib/generator/garden_rhythm_generator.dart` | To be created |
| `assets/phase_10/phase_10_meta.bin` | To be created |
| `assets/phase_10/seeds/seed_overrides.json` | To be created |
| `packages/analytics/lib/phase_10_events.dart` | To be created |

---

## Risks and Open Questions

1. **Tap Guard edge case:** M454 gentle shake without heart penalty must integrate into `TapGestureRecognizer` cleanly without triggering bonk vibration feedback.
2. **Rollback strategy:** If fatal modulo sync crashes emerge, immediately set `maxPhase = 9` via Remote Config.

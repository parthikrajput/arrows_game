# Spec: Phase 18 QA & Rollout — Garden Festival I (Levels 8501–9000)

Source docs: phase/phase_18/06_UI_AND_QA_PHASE_18.md, phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-18-level-plan-08501-09000.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 18 QA & Rollout — Garden Festival I |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 18 (Levels 8501–9000) |

---

## Goal

Define CI seed validation, QA test matrix, hybrid multi-floor and beam solver performance limits, Remote Config rollout gates, telemetry logging, and operational risk mitigation for Phase 18 (Garden Festival I).

---

## Current State

Design documented in `phase/phase_18/06_UI_AND_QA_PHASE_18.md` and `phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation Suite
- All 500 level seeds (L8501–9000) pre-validated via automated CI solver.
- Mandatory checks:
  - [ ] 100% solvable with 0 hearts lost and 0 boosters used.
  - [ ] Multi-floor and beam raycasting combined state step completes in $\le 0.3\text{ ms}$.
  - [ ] Grid dimensions conform strictly to 12×12 to 14×14 boundaries per floor.
  - [ ] Line counts remain within 28–40 across active layers.
  - [ ] Obstacle counts stay within 8–14.
  - [ ] Difficulty curve strictly adheres to plateau D 60–76; L9000 scales to D ≈ 91.
  - [ ] Day-night terrace permits upward floor travel strictly during Day state.
  - [ ] Pushing sunlit acorn into a beam redirects rays and updates downstream targets in the same turn.
  - [ ] Shaded stairs open only when touched by an active light beam.
  - [ ] Dawn marble slides freely in Day state and acts as an immovable obstacle in Night state.
- Seeds failing automated verification are routed to `seed_overrides.json`.

### 2. Phase Binary Metadata
- `phase_18_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Standard 16-byte record: `level_id` (4B), `seed` (4B), `target_d` (2B), `grid_size` (1B), `line_count` (1B), `flags` (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| Multi-Floor & Raycast Solver Step | ≤ 0.3 ms |
| Floor Pan Camera Duration | ≤ 250 ms |
| Frame Rendering Budget (Low Tier) | ≤ 16.7 ms (60 fps) |
| On-Device Level Generation & Load | ≤ 1.5 s |
| Hybrid State Memory Allocation | ≤ 2.5 MB |

### 4. Remote Config Rollout Gate
- **Flag:** `maxPhase = 18` (enables Levels 8501–9000 in production).
- **Rollout Schedule:**
  - Internal Dogfood: Day 1 (100%).
  - Canary: Day 3 (5% active users).
  - Staged Rollout: Day 5 (25%), Day 7 (50%), Day 10 (100%).
- **Kill-Switch / Fallback:**
  - If crash rate exceeds 0.5% or unsolvability reports emerge, set `maxPhase = 17`.
  - Tweakable parameter: `p18_combo_selection_version` (default 1, selects active combo candidate snapshot).

### 5. Telemetry & Analytics Events

| Event Name | Key Parameters | Purpose |
|---|---|---|
| `p18_terrace_climbed` | `level_id`, `floor_from`, `floor_to`, `cycle_state` | Tracks vertical floor transitions. |
| `p18_acorn_deflected` | `level_id`, `receptor_id`, `moves_taken` | Monitors prism alignment utility. |
| `p18_shaded_stairs_unlocked` | `level_id`, `beam_id` | Tracks solar illumination of vertical routes. |
| `p18_marble_slid` | `level_id`, `cells_traveled`, `cycle_state` | Evaluates sliding physics engagement. |
| `p18_level_complete` | `level_id`, `duration_s`, `stars`, `boosters_used` | General completion health and difficulty telemetry. |

### 6. QA Test Matrix

| ID | Test Description | Expected Result | Priority |
|---|---|---|---|
| P18-QA-01 | Day-night terrace temporal climb | Insects climb to floor 2 in Day state; blocked in Night state (lawn cell). | P0 |
| P18-QA-02 | Sunlit acorn push and reflect | Pushing acorn updates beam deflection angle accurately in same turn. | P0 |
| P18-QA-03 | Shaded stairs beam requirement | Stairs remain untraversable until illuminated by matching layer beam. | P0 |
| P18-QA-04 | Dawn marble state-dependent physics | Slides freely on grass in Day; completely stationary and immovable at Night. | P0 |
| P18-QA-05 | Floor and beam layer alignment | Beams on floor 1 do not illuminate stairs on floor 2 without optical portals. | P0 |
| P18-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | P0 |
| P18-QA-07 | L9000 Festival Gala | Finale solvable, awards Royal Honey Chest and Festival Grandee badge. | P0 |
| P18-QA-08 | Offline hybrid generation | Seed-based generation works seamlessly offline across all devices. | P1 |

---

## Verification Plan

### Automated Tests
1. Run CI test suite covering all 500 Phase 18 seeds (`test_phase_18_generation.dart`).
2. Run memory leak check during continuous 50-level multi-floor playthroughs.

### Manual Verification
1. Verify raycasting updates cleanly without stuttering when pushing Sunlit Acorns rapidly.
2. Verify remote config flag toggle locks/unlocks access cleanly.

# Spec: Phase 20 QA & Rollout — Grand Master Garden & Finale (Levels 9501–10,000)

Source docs: phase/phase_20/06_UI_AND_QA_PHASE_20.md, phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-20-level-plan-09501-10000.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 20 QA & Rollout — Grand Master Garden & Finale |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 20 (Levels 9501–10,000) |

---

## Goal

Define CI seed validation, QA test matrix, all-systems engine execution performance limits, Remote Config rollout gates, telemetry logging, and operational risk mitigation for Phase 20 (Grand Master Garden & L10,000 Grand Finale).

---

## Current State

Design documented in `phase/phase_20/06_UI_AND_QA_PHASE_20.md` and `phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation Suite
- All 500 level seeds (L9501–10,000) pre-validated via automated CI solver.
- Mandatory checks:
  - [ ] 100% solvable with 0 hearts lost and 0 boosters used.
  - [ ] 9-step deterministic multi-system tick order (§16.17) completes in $\le 0.4\text{ ms}$ on 14×14 grid with 40 lines.
  - [ ] Grid dimensions conform strictly to 13×13 to 14×14 boundaries.
  - [ ] Line counts remain within 32–40 across active layers.
  - [ ] Obstacle counts stay within 10–14.
  - [ ] Difficulty curve strictly adheres to plateau D 60–76; L10,000 scales to D ≈ 95.
  - [ ] Eternal bloom canopy expands during bloom and allows travel during withered phase.
  - [ ] Twin cascade nexus resolves independent gravity flows on Board A and Board B without desync.
  - [ ] Shrouded guardian aegis requires 3 hidden keys before armor cracks.
  - [ ] Prismatic rhythm turntable rotates $90^\circ$ every 4 moves and updates all beam raycast reflections.
  - [ ] L10,000 Grand Finale board successfully integrates Twin Hornets across 3 spatial layers.
- Seeds failing automated verification are routed to `seed_overrides.json`.

### 2. Phase Binary Metadata
- `phase_20_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Standard 16-byte record: `level_id` (4B), `seed` (4B), `target_d` (2B), `grid_size` (1B), `line_count` (1B), `flags` (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| All-Systems Full Tick Resolution Budget | ≤ 0.4 ms |
| L10,000 Coronation Victory Sequence | ≤ 400 ms |
| Frame Rendering Budget (Low Tier) | ≤ 16.7 ms (60 fps) |
| On-Device Level Generation & Load | ≤ 1.5 s |
| Full 20-Phase Memory Allocation | ≤ 3.0 MB |

### 4. Remote Config Rollout Gate
- **Flag:** `maxPhase = 20` (enables Levels 9501–10,000 and the complete 10,000 level experience).
- **Rollout Schedule:**
  - Internal Dogfood: Day 1 (100%).
  - Canary: Day 3 (5% active users).
  - Staged Rollout: Day 5 (25%), Day 7 (50%), Day 10 (100%).
- **Kill-Switch / Fallback:**
  - If crash rate exceeds 0.5% or unsolvability reports emerge, set `maxPhase = 19`.
  - Tweakable parameter: `p20_grand_mastery_active` (default true, controls Endless Mode access).

### 5. Telemetry & Analytics Events

| Event Name | Key Parameters | Purpose |
|---|---|---|
| `p20_bloom_cycle_shifted` | `level_id`, `new_state` | Tracks bloom timing and player passability. |
| `p20_cascade_split` | `level_id`, `board_a_lines`, `board_b_lines` | Evaluates multi-board gravity balance. |
| `p20_aegis_keys_gathered` | `level_id`, `keys_count`, `moves_used` | Tracks shrouded guardian key collection. |
| `p20_prismatic_rotor_turned` | `level_id`, `beams_redirected` | Monitors optical rhythm synchronization. |
| `p20_finale_l10000_cleared` | `duration_s`, `stars`, `boosters_used` | Ultimate campaign completion milestone event. |
| `p20_endless_mastery_started`| `prestige_rank`, `seed` | Tracks post-10K player engagement. |

### 6. QA Test Matrix

| ID | Test Description | Expected Result | Priority |
|---|---|---|---|
| P20-QA-01 | Multi-system tick order resolution | All 9 steps in Standard §16.17 resolve deterministically without desync. | P0 |
| P20-QA-02 | Eternal bloom canopy timing | Vines block during full bloom, allow passage during withered state. | P0 |
| P20-QA-03 | Twin cascade gravity fork | Gravity pull on local branch and portal teleport on linked branch execute cleanly. | P0 |
| P20-QA-04 | Shrouded guardian key progress | Exactly 3 keys required from fog to shatter guardian armor. | P0 |
| P20-QA-05 | Prismatic rotor raycast deflection | 90° rotation recalculates all board light rays and receptor states in 1 frame. | P0 |
| P20-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | P0 |
| P20-QA-07 | L10,000 Queen's Eternal Garden | Grand Finale solvable, awards 1,000 coins, Eternal badge, and unlocks Endless mode. | P0 |
| P20-QA-08 | Endless prestige generation | Post-10K levels generate procedurally with stable performance and infinite loop. | P1 |

---

## Verification Plan

### Automated Tests
1. Run CI test suite covering all 500 Phase 20 seeds (`test_phase_20_generation.dart`).
2. Run stress test simulating continuous 100-level playthrough in Endless Grand Mastery mode.

### Manual Verification
1. Verify L10,000 completion flow properly transitions to Coronation sequence and awards profile badge.
2. Verify remote config flag toggle locks/unlocks access cleanly.

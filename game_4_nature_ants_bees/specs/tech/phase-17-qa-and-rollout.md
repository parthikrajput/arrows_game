# Spec: Phase 17 QA & Rollout — Garden Guardians (Levels 8001–8500)

Source docs: phase/phase_17/06_UI_AND_QA_PHASE_17.md, phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-17-level-plan-08001-08500.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 17 QA & Rollout — Garden Guardians |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 17 (Levels 8001–8500) |

---

## Goal

Define CI seed validation, QA test matrix, boss collision and spawner execution performance limits, Remote Config rollout gates, telemetry logging, and operational risk mitigation for Phase 17 (Garden Guardians).

---

## Current State

Design documented in `phase/phase_17/06_UI_AND_QA_PHASE_17.md` and `phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation Suite
- All 500 level seeds (L8001–8500) pre-validated via automated CI solver.
- Mandatory checks:
  - [ ] 100% solvable with 0 hearts lost and 0 boosters used.
  - [ ] Multi-cell footprint collision checks and spawner ticks complete in $\le 0.2\text{ ms}$.
  - [ ] Grid dimensions conform strictly to 12×12 to 14×14 boundaries.
  - [ ] Line counts remain within 28–40.
  - [ ] Obstacle counts stay within 8–14.
  - [ ] Difficulty curve strictly adheres to plateau D 60–76; L8500 scales to D ≈ 91.
  - [ ] Twin hornets decrement shared HP and vanish simultaneously at 0.
  - [ ] Armored rhino beetle ignores damage until Ivy Lever is activated.
  - [ ] Wasp nest spawns exactly 1 mud blocker every $N$ moves into the first free neighbor in U-R-D-L order.
  - [ ] Heart-seed guardian decrements HP strictly upon direct line intersection through the core tile.
- Seeds failing automated verification are routed to `seed_overrides.json`.

### 2. Phase Binary Metadata
- `phase_17_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Standard 16-byte record: `level_id` (4B), `seed` (4B), `target_d` (2B), `grid_size` (1B), `line_count` (1B), `flags` (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| Boss Logic & Footprint Check Budget | ≤ 0.2 ms |
| Boss Defeat Animation Duration | ≤ 300 ms |
| Frame Rendering Budget (Low Tier) | ≤ 16.7 ms (60 fps) |
| On-Device Level Generation & Load | ≤ 1.5 s |
| Guardian State Memory Allocation | ≤ 2.0 MB |

### 4. Remote Config Rollout Gate
- **Flag:** `maxPhase = 17` (enables Levels 8001–8500 in production).
- **Rollout Schedule:**
  - Internal Dogfood: Day 1 (100%).
  - Canary: Day 3 (5% active users).
  - Staged Rollout: Day 5 (25%), Day 7 (50%), Day 10 (100%).
- **Kill-Switch / Fallback:**
  - If crash rate exceeds 0.5% or unsolvability reports emerge, set `maxPhase = 16`.
  - Tweakable parameter: `p17_guardian_defeat_ms` (default 300, range 150–500).

### 5. Telemetry & Analytics Events

| Event Name | Key Parameters | Purpose |
|---|---|---|
| `p17_guardian_damaged` | `level_id`, `guardian_type`, `remaining_hp` | Tracks damage events against bosses. |
| `p17_armor_shattered` | `level_id`, `lever_move_index` | Monitors timing of rhino beetle armor removal. |
| `p17_blocker_spawned` | `level_id`, `total_spawns_count` | Monitors nest pressure and pacing. |
| `p17_guardian_defeated` | `level_id`, `guardian_type`, `moves_taken` | Evaluates combat efficiency and balance. |
| `p17_level_complete` | `level_id`, `duration_s`, `stars`, `boosters_used` | General completion health and difficulty telemetry. |

### 6. QA Test Matrix

| ID | Test Description | Expected Result | Priority |
|---|---|---|---|
| P17-QA-01 | Twin hornets shared HP | Line exit drops shared HP by 1; both hornets vanish simultaneously at 0 HP. | P0 |
| P17-QA-02 | Rhino beetle armor invulnerability | Lines exiting while armor is active deal 0 damage; lever removes armor. | P0 |
| P17-QA-03 | Wasp nest spawner pacing | Nest spawns exactly 1 mud blocker every N moves into first free neighbor. | P0 |
| P17-QA-04 | Heart-seed core piercing lane | Only lines whose straight trajectory intersects core tile decrement HP. | P0 |
| P17-QA-05 | Tall boss obstruction check | Both ground ants and airborne bees bonk into guardian 2x2 footprint. | P0 |
| P17-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | P0 |
| P17-QA-07 | L8500 Royal Hive Defense | Finale solvable, awards Royal Honey Chest and Hive Protector badge. | P0 |
| P17-QA-08 | Offline boss generation | Seed-based generation works seamlessly offline across all devices. | P1 |

---

## Verification Plan

### Automated Tests
1. Run CI test suite covering all 500 Phase 17 seeds (`test_phase_17_generation.dart`).
2. Run memory leak check during continuous 50-level boss battle playthroughs.

### Manual Verification
1. Verify Wasp Nest spawns do not cause hit-box anomalies or phantom collisions.
2. Verify remote config flag toggle locks/unlocks access cleanly.

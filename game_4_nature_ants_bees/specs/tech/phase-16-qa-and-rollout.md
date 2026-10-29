# Spec: Phase 16 QA & Rollout — Royal Keyring (Levels 7501–8000)

Source docs: phase/phase_16/06_UI_AND_QA_PHASE_16.md, phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-16-level-plan-07501-08000.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 16 QA & Rollout — Royal Keyring |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 16 (Levels 7501–8000) |

---

## Goal

Define CI seed validation, QA test matrix, key dependency graph verification budgets, Remote Config rollout gates, telemetry logging, and operational risk mitigation for Phase 16 (Royal Keyring).

---

## Current State

Design documented in `phase/phase_16/06_UI_AND_QA_PHASE_16.md` and `phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation Suite
- All 500 level seeds (L7501–8000) pre-validated via automated CI solver.
- Mandatory checks:
  - [ ] 100% solvable with 0 hearts lost and 0 boosters used.
  - [ ] Chained dependency graph resolution completes in $\le 0.1\text{ ms}$.
  - [ ] Grid dimensions conform strictly to 12×12 to 14×14 boundaries.
  - [ ] Line counts remain within 28–40.
  - [ ] Obstacle counts stay within 8–14.
  - [ ] Difficulty curve strictly adheres to plateau D 60–76; L8000 scales to D ≈ 91.
  - [ ] Dew key chain passes key immediately upon lock clearance.
  - [ ] Crafting gate opens strictly after BOTH required half-key insects exit the board.
  - [ ] Skeleton Dew Key cross-axis sweep shatters locks in starting row and column accurately.
  - [ ] Key swap pad correctly exchanges key possession between linked lines.
- Seeds failing automated verification are routed to `seed_overrides.json`.

### 2. Phase Binary Metadata
- `phase_16_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Standard 16-byte record: `level_id` (4B), `seed` (4B), `target_d` (2B), `grid_size` (1B), `line_count` (1B), `flags` (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| Key Graph Verification Budget | ≤ 0.1 ms |
| Skeleton Sweep Animation Duration | ≤ 120 ms |
| Frame Rendering Budget (Low Tier) | ≤ 16.7 ms (60 fps) |
| On-Device Level Generation & Load | ≤ 1.5 s |
| Key State Memory Allocation | ≤ 2.0 MB |

### 4. Remote Config Rollout Gate
- **Flag:** `maxPhase = 16` (enables Levels 7501–8000 in production).
- **Rollout Schedule:**
  - Internal Dogfood: Day 1 (100%).
  - Canary: Day 3 (5% active users).
  - Staged Rollout: Day 5 (25%), Day 7 (50%), Day 10 (100%).
- **Kill-Switch / Fallback:**
  - If crash rate exceeds 0.5% or unsolvability reports emerge, set `maxPhase = 15`.
  - Tweakable parameter: `p16_skeleton_sweep_speed_ms` (default 120, range 80–200).

### 5. Telemetry & Analytics Events

| Event Name | Key Parameters | Purpose |
|---|---|---|
| `p16_key_chain_triggered` | `level_id`, `step_index`, `key_color` | Tracks successful chain key transfers. |
| `p16_key_crafted` | `level_id`, `flower_id`, `crafted_type` | Tracks synthesis of dual half-keys. |
| `p16_skeleton_sweep` | `level_id`, `locks_destroyed_count` | Monitors skeleton master key efficiency. |
| `p16_key_swapped` | `level_id`, `swap_pad_id`, `moves_used` | Evaluates swap mechanic utilization. |
| `p16_level_complete` | `level_id`, `duration_s`, `stars`, `boosters_used` | General completion health and difficulty telemetry. |

### 6. QA Test Matrix

| ID | Test Description | Expected Result | Priority |
|---|---|---|---|
| P16-QA-01 | Dew key chain progression | Opening lock 1 immediately bestows key 2 to linked insect. | P0 |
| P16-QA-02 | Half-key synthesis completion | Gate opens strictly after BOTH required half-key insects exit the board. | P0 |
| P16-QA-03 | Skeleton key cross-axis sweep | Exiting skeleton key clears all locks in starting row and column accurately. | P0 |
| P16-QA-04 | Key swap allocation | Tapping swap pad exchanges key types between the two target lines. | P0 |
| P16-QA-05 | Cross-layer key carry | Worker bees and ground ants carry and utilize keys with identical logic. | P0 |
| P16-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | P0 |
| P16-QA-07 | L8000 Queen's Royal Lock Gala | Finale solvable, awards Royal Honey Chest and Master Keywright badge. | P0 |
| P16-QA-08 | Offline key generation | Seed-based generation works seamlessly offline across all devices. | P1 |

---

## Verification Plan

### Automated Tests
1. Run CI test suite covering all 500 Phase 16 seeds (`test_phase_16_generation.dart`).
2. Run memory leak check during continuous 50-level key chain playthroughs.

### Manual Verification
1. Verify Skeleton cross-axis sweep destroys simultaneously row and column locks without desync.
2. Verify remote config flag toggle locks/unlocks access cleanly.

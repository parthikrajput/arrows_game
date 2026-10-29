# Spec: Phase 9 QA & Rollout — Swarm Splits (Levels 4001–4500)

Source docs: phase/phase_9/06_UI_AND_QA_PHASE_9.md, phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §12, §16, SCALING_TO_10000_LEVELS.md §8, §9, §10. Depends on: specs/tech/on-device-level-generation.md, specs/gameplay/phase-9-level-plan-04001-04500.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 9 QA & Rollout — Swarm Splits |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | tech |
| **Phase** | 9 (Levels 4001–4500) |

---

## Goal

Define CI seed validation, QA test matrix, performance limits, Remote Config rollout gates, analytics telemetry, and operational risk mitigation for Phase 9 (Swarm Splits).

---

## Current State

Design documented in `phase/phase_9/06_UI_AND_QA_PHASE_9.md` and `phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md`, not yet implemented.

---

## Proposed Change

### 1. CI Seed Validation Suite
- All 500 level seeds (L4001–4500) must be pre-validated by the automated CI solver.
- Mandatory checks:
  - [ ] Solvable with 0 hearts lost and 0 boosters used.
  - [ ] Branch routing clearance check completes in ≤ 0.3 ms across a 14×14 grid.
  - [ ] Grid dimensions stay within 12×12 to 14×14 bounds.
  - [ ] Total line counts remain within 28–40.
  - [ ] Obstacle instances stay within 8–14.
  - [ ] Target difficulty conforms to plateau D 60–76; L4500 finale scales to D ≈ 91.
  - [ ] Fork Twig splits never branch directly into impassable boundaries or deadlocks.
  - [ ] All Honey Merge Pads have reachable paired lines that can successfully fuse.
  - [ ] Segment Clasp key dependencies are verified strictly acyclic.
  - [ ] Reunion Arches have both associated split branches present and verifiable.
- Any seed failing validation must be routed to `seed_overrides.json`.

### 2. Phase Binary Metadata
- `phase_9_meta.bin`: 500 records × 16 bytes = **8,000 bytes (8 KB)**.
- Record layout: `level_id` (4B), `seed` (4B), `target_d` (2B), `grid_size` (1B), `line_count` (1B), `flags` (4B).

### 3. Performance Budget

| Metric | Budget |
|---|---|
| Dual Branch Clearance Verification (14×14 grid) | ≤ 0.3 ms |
| Frame Rendering Budget (Low Tier) | ≤ 16.7 ms (60 fps) |
| On-Device Level Generation & Load | ≤ 1.5 s |
| Swarm State Memory Allocation | ≤ 2.5 MB |

### 4. Remote Config Rollout Gate

| Key | Pre-Launch Default | Post-QA Value | Purpose |
|---|---|---|---|
| `maxPhase` | `8` | `9` | Unlock Phase 9 content |
| `p9_split_stagger_ms` | `0` | `0` | Synchronous split animation toggle |

- Staged rollout plan: 5% → 20% → 100% over 72 hours following full QA sign-off.

### 5. QA Test Matrix

| ID | Test Scenario | Expected Outcome | Status |
|---|---|---|---|
| P9-QA-01 | Merge pad coupling | First line halts on pad; second line attaches behind and exits together | Not run |
| P9-QA-02 | Fork twig atomic clearance | If either branch is blocked, move aborts with bonk (-1 Heart); no line splits | Not run |
| P9-QA-03 | Fork twig line division | Even length splits into exact halves; odd length splits into ceil/floor lengths | Not run |
| P9-QA-04 | Segment clasp hold | Front segment moves while clasped back segments remain stationary | Not run |
| P9-QA-05 | Reunion arch dual check | Arch stays shut after 1 branch exits; opens immediately upon 2nd branch exit | Not run |
| P9-QA-06 | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI | Not run |
| P9-QA-07 | L4500 Great Swarm Reunion | Finale solvable, awards Royal Honey Chest and Swarm Conductor badge | Not run |
| P9-QA-08 | Offline split generation | Seed-based generation works seamlessly offline across all devices | Not run |
| P9-QA-09 | Clasp dependency graph | Solver detects and rejects cyclic key dependencies during generation | Not run |
| P9-QA-10 | Cross-layer merge rejection | Ant lines and bee lines cannot fuse on the same Merge Pad | Not run |

### 6. Analytics Telemetry

| Event Name | Payload Attributes |
|---|---|
| `phase_9_started` | `{ level_id, player_id }` |
| `line_split_triggered` | `{ level_id, fork_id, branch_lengths: [left, right] }` |
| `lines_coupled` | `{ level_id, pad_id, caravan_length }` |
| `clasp_unlocked` | `{ level_id, clasp_id, key_line_id }` |
| `reunion_arch_opened` | `{ level_id, arch_id, moves_elapsed }` |
| `phase_9_finale_cleared` | `{ level_id: 4500, time_ms, moves_taken }` |
| `royal_honey_chest_awarded` | `{ level_id: 4500, badge_id: "swarm_conductor" }` |

### 7. Upstream Spec Cross-References
- `specs/tech/on-device-level-generation.md` — Expand generator schema for split/merge graph nodes.
- `specs/gameplay/phase-8-signature-system.md` — Verify vine expansion interaction with split caravan paths.

---

## Affected Files

| File / Module | Status |
|---|---|
| `packages/puzzle_core/lib/validator/phase_9_validator.dart` | To be created |
| `packages/puzzle_core/lib/generator/swarm_splits_generator.dart` | To be created |
| `assets/phase_9/phase_9_meta.bin` | To be created |
| `assets/phase_9/seeds/seed_overrides.json` | To be created |
| `packages/analytics/lib/phase_9_events.dart` | To be created |

---

## Risks and Open Questions

1. **Dual Branch Collision Latency:** If both branches encounter obstacles concurrently, evaluating cascading bonks on multi-layer grids must strictly respect the 0.3 ms budget.
2. **Rollback strategy:** If game crashes occur on older devices during fork animations, `maxPhase` must be immediately rolled back to 8 via Remote Config.

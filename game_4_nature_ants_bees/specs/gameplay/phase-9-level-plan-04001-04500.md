# Spec: Phase 9 Level Plan — Levels 4001–4500 (Swarm Splits)

Source docs: phase/phase_9/02_LEVEL_PLAN_4001_4500.md, phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-9-signature-system.md, specs/gameplay/phase-9-base-mechanics.md, specs/gameplay/phase-9-variants-and-modifiers.md, specs/tech/on-device-level-generation.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 9 Level Plan — Levels 4001–4500 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 9 (Levels 4001–4500) |

---

## Goal

Define the complete 50-block slot map for 500 levels (4001–4500) of Swarm Splits, specifying grid sizes, difficulty bands, tiers, milestone rewards, and the Great Swarm Reunion finale at L4500.

---

## Current State

Design documented in phase/phase_9/02_LEVEL_PLAN_4001_4500.md, not yet implemented.

---

## Proposed Change

### Slot Map Architecture

| Slot | Role | Target D | Tag | Clear Coins | Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | 60–63 | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice | 64–68 | `normal` | 20 | — |
| x5 | Breather (simple 2-line merge route) | 60–62 | `easy` | 15 | — |
| x6–x8 | Ramp (multi-fork and clasp dependencies) | 69–73 | `normal` | 20 | — |
| x9 | Hard (red badge, +10% target D) | 74–76 | `hard` | 30 | — |
| x0 | Milestone Level | 65–68 | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L4500 | Phase Finale — Great Swarm Reunion | ≈ 91 | `finale` | 50 | **Royal Honey Chest** |

### Difficulty Tiers

| Tier | Level Range | Grid Size | Lines | D Band |
|---|---|---|---|---|
| P9-A | 4001–4250 | 12×12 to 13×13 | 28–34 | 60–68 |
| P9-B | 4251–4500 | 13×13 to 14×14 | 32–40 | 68–76 |

### 50-Block Master Table

| Block | Range | x1 Feature / New Item | Grid | Lines | Target D | Hard (x9) | Gift Box (x0) |
|---|---|---|---|---|---|---|---|
| **1** | 4001–4010 | Signature Intro: Swarm Splits | 12×12 | 28 | 60–62 | L4009 (D 74) | 300 coins + Hint |
| **2** | 4011–4020 | M401 Honey Merge Pad | 12×12 | 28–30 | 61–63 | L4019 (D 74) | 300 coins + Leaf Blower |
| **3–13** | 4021–4130 | Variants 1–11 (M401 line convergence puzzles) | 12×12–13×13 | 30–34 | 62–67 | x9 Hard | 300 coins + rotating |
| **14** | 4131–4140 | M402 Fork Twig | 13×13 | 32–34 | 66–68 | L4139 (D 75) | 300 coins + Shield |
| **15–25** | 4141–4250 | Variants 12–22 (M402 dual branch routing tactics) | 13×13 | 32–36 | 67–70 | x9 Hard | 300 coins + rotating |
| **26** | 4251–4260 | M403 Segment Clasp | 13×13 | 34–36 | 69–71 | L4259 (D 75) | 300 coins + Hint |
| **27–37** | 4261–4370 | Variants 23–33 (M403 caravan segment locks) | 13×13–14×14 | 34–38 | 70–73 | x9 Hard | 300 coins + rotating |
| **38** | 4371–4380 | M404 Reunion Arch | 14×14 | 36–38 | 72–74 | L4379 (D 76) | 300 coins + Leaf Blower |
| **39–49** | 4381–4490 | Variants 34–44 (M404 dual exit synchrony challenges) | 14×14 | 36–40 | 73–75 | x9 Hard | 300 coins + rotating |
| **50** | 4491–4500 | L4491 Mastery Mix / L4500 Great Swarm Reunion | 14×14 | 40 | 76 / 91 | L4499 (D 76) | L4500 Royal Chest |

### Gift Box Rotation
- 49 Gift Boxes at: L4010, L4020 … L4490.
- `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### L4500 Finale — Great Swarm Reunion
- Grid: 14×14, 40 lines, target D ≈ 91.
- Reward: **Royal Honey Chest** — 1,000 coins + 2 Nectar Glow Hints + 2 Queen's Royal Shields + 2 Leaf Blowers + **"Swarm Conductor"** cosmetic badge.
- Finale tag: `finale`.

---

## Acceptance Criteria
- [ ] All 500 level seeds (L4001–4500) pass CI solver: 0 hearts, 0 boosters.
- [ ] Grid sizes: 12×12 to 14×14 throughout.
- [ ] Line counts: 28–40 across all levels.
- [ ] 49 Gift Boxes at x0 milestones (L4010–L4490).
- [ ] L4500 awards Royal Honey Chest + Swarm Conductor badge exactly once.
- [ ] `phase_9_meta.bin`: 500 records × 16 bytes = 8,000 bytes.

---

## Affected Files

| File / Module | Status |
|---|---|
| `assets/phase_9/seeds/phase_9_seeds.json` | To be created |
| `assets/phase_9/phase_9_meta.bin` | To be created |
| `packages/puzzle_core/lib/generator/swarm_splits_generator.dart` | To be created |

---

## Risks and Open Questions

1. **Branch routing budget:** 0.3 ms for dual branch verification on 14×14 may be tight; profiling required on low-tier devices.
2. **Mastery Mix (L4491) composition:** Exact mechanics used not enumerated in source docs.
3. **Finale D ≈ 91:** Verify against D formula in SHARED_CORE_STANDARD.md §9 for `finale` tag.

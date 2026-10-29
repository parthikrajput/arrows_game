# Spec: Phase 8 Level Plan — Levels 3501–4000 (Bloom Season)

Source docs: phase/phase_8/02_LEVEL_PLAN_3501_4000.md, phase/phase_8/01_PHASE_8_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-8-signature-system.md, specs/gameplay/phase-8-base-mechanics.md, specs/gameplay/phase-8-variants-and-modifiers.md, specs/tech/on-device-level-generation.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 8 Level Plan — Levels 3501–4000 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 8 (Levels 3501–4000) |

---

## Goal

Define the complete 50-block slot map for 500 levels (3501–4000) of Bloom Season, specifying grid sizes, difficulty bands, tiers, milestone rewards, and the Eternal Bloom Gala finale at L4000.

---

## Current State

Design documented in phase/phase_8/02_LEVEL_PLAN_3501_4000.md, not yet implemented. Levels are generated on-device from seeds; CI pre-validates all 500 seeds.

---

## Proposed Change

### Slot Map Architecture (50 Blocks × 10 Levels)

| Slot | Role | Target D | Tag | Clear Coins | Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | 60–63 | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice (mix with previous mechanics) | 64–68 | `normal` | 20 | — |
| x5 | Breather (simple vine pruning route) | 60–62 | `easy` | 15 | — |
| x6–x8 | Ramp (fast spreading vines & seed timing) | 69–73 | `normal` | 20 | — |
| x9 | Hard (red badge, +10% target D) | 74–76 | `hard` | 30 | — |
| x0 | Milestone Level | 65–68 | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L4000 | Phase Finale — Eternal Bloom Gala | ≈ 91 | `finale` | 50 | **Royal Honey Chest** |

### Difficulty Tiers

| Tier | Level Range | Grid Size | Lines | D Band |
|---|---|---|---|---|
| P8-A | 3501–3750 | 12×12 to 13×13 | 28–34 | 60–68 |
| P8-B | 3751–4000 | 13×13 to 14×14 | 32–40 | 68–76 |

### 50-Block Master Table

| Block | Range | x1 Feature / New Item | Grid | Lines | Target D | Hard (x9) | Gift Box (x0) |
|---|---|---|---|---|---|---|---|
| **1** | 3501–3510 | Signature Intro: Bloom Season | 12×12 | 28 | 60–62 | L3509 (D 74) | 300 coins + Hint |
| **2** | 3511–3520 | M351 Morning Glory Vine | 12×12 | 28–30 | 61–63 | L3519 (D 74) | 300 coins + Leaf Blower |
| **3–13** | 3521–3630 | Variants 1–11 (M351 spreading vine containment) | 12×12–13×13 | 30–34 | 62–67 | x9 Hard | 300 coins + rotating |
| **14** | 3631–3640 | M352 Garden Shears | 13×13 | 32–34 | 66–68 | L3639 (D 75) | 300 coins + Shield |
| **15–25** | 3641–3750 | Variants 12–22 (M352 pruner timing & lane clears) | 13×13 | 32–36 | 67–70 | x9 Hard | 300 coins + rotating |
| **26** | 3751–3760 | M353 Seed-Dropping Line | 13×13 | 34–36 | 69–71 | L3759 (D 75) | 300 coins + Hint |
| **27–37** | 3761–3870 | Variants 23–33 (M353 latent seed blocker avoidance) | 13×13–14×14 | 34–38 | 70–73 | x9 Hard | 300 coins + rotating |
| **38** | 3871–3880 | M354 Pollination Gate | 14×14 | 36–38 | 72–74 | L3879 (D 76) | 300 coins + Leaf Blower |
| **39–49** | 3881–3990 | Variants 34–44 (M354 multi-line pollination sequences) | 14×14 | 36–40 | 73–75 | x9 Hard | 300 coins + rotating |
| **50** | 3991–4000 | L3991 Mastery Mix / L4000 Eternal Bloom Gala | 14×14 | 40 | 76 / 91 | L3999 (D 76) | L4000 Royal Chest |

### Booster Rotation at x0 Milestones
- Booster at level x0: `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.
- 49 Gift Boxes at: L3510, L3520, L3530 … L3990.

### L4000 Finale — Eternal Bloom Gala
- Grid: 14×14, 40 lines, target D ≈ 91.
- Reward: **Royal Honey Chest** — 1,000 coins + 2 Nectar Glow Hints + 2 Queen's Royal Shields + 2 Leaf Blowers + **"Master Florist"** cosmetic badge.
- Finale tag: `finale`; tutorial overlay fires: "Eternal Bloom Gala — Show your mastery of all living vines and blossoming gates!"

### Intro-Level Constraints
- Each x1 intro level: single instance of the new mechanic, minimal other obstacles, D at band low.
- Tutorial card fires exactly once per mechanic per player account.
- L3501 (Block 1 x1): Bloom Season signature intro — no previous Growth mechanics present.

---

## Acceptance Criteria
- [ ] All 500 level seeds (L3501–4000) pass CI solver: 0 hearts lost, 0 boosters.
- [ ] Grid sizes stay within 12×12 to 14×14 throughout.
- [ ] Line counts: 28–40 across all levels.
- [ ] Hard (x9) levels in each block target D 74–76 (10% above band high of 68–73).
- [ ] 49 Gift Boxes awarded at x0 milestones (L3510–L3990).
- [ ] L4000 Finale awards Royal Honey Chest + Master Florist badge exactly once.
- [ ] Phase 8 `phase_8_meta.bin`: 500 records × 16 bytes = 8,000 bytes.

---

## Affected Files

| File / Module | Status |
|---|---|
| `assets/phase_8/seeds/phase_8_seeds.json` | To be created |
| `assets/phase_8/phase_8_meta.bin` | To be created (8 KB) |
| `packages/puzzle_core/lib/level_loader.dart` | Changed |
| `packages/puzzle_core/lib/generator/bloom_season_generator.dart` | To be created |

---

## Risks and Open Questions

1. **L3991 Mastery Mix content:** Exact mechanics used in the Mastery Mix review level are not enumerated in source docs. Must be specified in level seed definition.
2. **Finale D ≈ 91 computation:** The exact formula for how D = 91 is achieved at L4000 should be verified against SHARED_CORE_STANDARD.md §9 D formula for `finale` tag levels.
3. **Obstacle count bounds:** Source doc §01 states 8–14 obstacles; this should be cross-checked against SHARED_CORE_STANDARD.md §11 for Phase 8 caps.

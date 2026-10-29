# Spec: Phase 14 Level Plan — Levels 6501–7000 (Reflecting Pond)

Source docs: phase/phase_14/02_LEVEL_PLAN_6501_7000.md, phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-14-signature-system.md, specs/gameplay/phase-14-base-mechanics.md, specs/gameplay/phase-14-variants-and-modifiers.md, specs/tech/on-device-level-generation.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 14 Level Plan — Levels 6501–7000 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 14 (Levels 6501–7000) |

---

## Goal

Define the complete 50-block slot map for 500 levels (6501–7000) of Reflecting Pond, outlining difficulty envelopes, bilateral tier progressions, milestone rewards, and the Mirrored Solstice Gala finale at L7000.

---

## Current State

Design documented in `phase/phase_14/02_LEVEL_PLAN_6501_7000.md`, not yet implemented.

---

## Proposed Change

### Slot Map Architecture

| Slot | Role | Target D | Tag | Clear Coins | Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | 60–63 | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice (Mix with previous mechanics) | 64–68 | `normal` | 20 | — |
| x5 | Breather (Simple bilateral mirror exit) | 60–62 | `easy` | 15 | — |
| x6–x8 | Ramp (Asymmetric obstacles with symmetric lines) | 69–73 | `normal` | 20 | — |
| x9 | Hard (Red badge, +10% target D) | 74–76 | `hard` | 30 | — |
| x0 | Milestone Level | 65–68 | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L7000 | Phase Finale — Mirrored Solstice Gala | ≈ 91 | `finale` | 50 | **Royal Honey Chest** |

### Difficulty Tiers

| Tier | Level Range | Grid Size | Lines | D Band |
|---|---|---|---|---|
| P14-A | 6501–6750 | 12×12 to 13×13 | 28–34 | 60–68 |
| P14-B | 6751–7000 | 13×13 to 14×14 | 32–40 | 68–76 |

### 50-Block Master Table

| Block | Range | x1 Feature / New Item | Grid | Lines | Target D | Hard (x9) | Gift Box (x0) |
|---|---|---|---|---|---|---|---|
| **1** | 6501–6510 | **Signature Intro: Reflecting Pond** | 12×12 | 28 | 60–62 | L6509 (D 74) | 300 coins + Hint |
| **2** | 6511–6520 | **M651 Pond Axis** | 12×12 | 28–30 | 61–63 | L6519 (D 74) | 300 coins + Leaf Blower |
| **3–13** | 6521–6630 | Variants 1–11 (M651 bilateral symmetric movement) | 12×12–13×13 | 30–34 | 62–67 | x9 Hard | 300 coins + rot. |
| **14** | 6631–6640 | **M652 Reflection Lock** | 13×13 | 32–34 | 66–68 | L6639 (D 75) | 300 coins + Shield |
| **15–25** | 6641–6750 | Variants 12–22 (M652 cross-axis key-lock routing) | 13×13 | 32–36 | 67–70 | x9 Hard | 300 coins + rot. |
| **26** | 6751–6760 | **M653 Twin Pond** | 13×13 | 34–36 | 69–71 | L6759 (D 75) | 300 coins + Hint |
| **27–37** | 6761–6870 | Variants 23–33 (M653 simultaneous board input challenges) | 13×13–14×14 | 34–38 | 70–73 | x9 Hard | 300 coins + rot. |
| **38** | 6871–6880 | **M654 Upside-Down Line** | 14×14 | 36–38 | 72–74 | L6879 (D 76) | 300 coins + Leaf Blower |
| **39–49** | 6881–6990 | Variants 34–44 (M654 inverted direction logic mazes) | 14×14 | 36–40 | 73–75 | x9 Hard | 300 coins + rot. |
| **50** | 6991–7000 | **L6991 Mastery Mix / L7000 Mirrored Solstice Gala** | 14×14 | 40 | 76 / 91 | L6999 (D 76) | L7000 **Royal Chest** |

### Gift Box Rotation
- 49 Gift Boxes at: L6510, L6520 … L6990.
- `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### L7000 Finale — Mirrored Solstice Gala
- Grid: 14×14, 40 lines, target D ≈ 91.
- Reward: **Royal Honey Chest** — 1,000 coins + 2 Nectar Glow Hints + 2 Queen's Royal Shields + 2 Leaf Blowers + **"Mirror Mirage Master"** cosmetic badge.
- Finale tag: `finale`.

---

## Acceptance Criteria
- [ ] All 500 level seeds (L6501–7000) pass CI solver without boosters or heart loss.
- [ ] Grid dimensions conform strictly to 12×12–14×14 limits.
- [ ] Line counts remain within 28–40 across all blocks.
- [ ] 49 Gift Boxes awarded at exact x0 milestones.
- [ ] L7000 awards Royal Honey Chest + Mirror Mirage Master badge.
- [ ] `phase_14_meta.bin`: 500 records × 16 bytes = 8,000 bytes.

---

## Affected Files

| File / Module | Status |
|---|---|
| `assets/phase_14/seeds/phase_14_seeds.json` | To be created |
| `assets/phase_14/phase_14_meta.bin` | To be created |
| `packages/puzzle_core/lib/generator/reflecting_pond_generator.dart` | To be created |

---

## Risks and Open Questions

1. **Bilateral Symmetry Generation Constraint:** Procedural generation must guarantee that while lines are placed symmetrically, obstacle placement is non-trivially asymmetric to provide genuine puzzle tension.

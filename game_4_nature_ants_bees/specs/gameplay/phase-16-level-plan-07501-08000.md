# Spec: Phase 16 Level Plan — Levels 7501–8000 (Royal Keyring)

Source docs: phase/phase_16/02_LEVEL_PLAN_7501_8000.md, phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-16-signature-system.md, specs/gameplay/phase-16-base-mechanics.md, specs/gameplay/phase-16-variants-and-modifiers.md, specs/tech/on-device-level-generation.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 16 Level Plan — Levels 7501–8000 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 16 (Levels 7501–8000) |

---

## Goal

Define the complete 50-block slot map for 500 levels (7501–8000) of Royal Keyring, detailing multi-key complexity progressions, tier distributions, milestone rewards, and the Queen's Royal Lock Gala finale at L8000.

---

## Current State

Design documented in `phase/phase_16/02_LEVEL_PLAN_7501_8000.md`, not yet implemented.

---

## Proposed Change

### Slot Map Architecture

| Slot | Role | Target D | Tag | Clear Coins | Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | 60–63 | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice (Mix with previous mechanics) | 64–68 | `normal` | 20 | — |
| x5 | Breather (Simple 2-link key chain) | 60–62 | `easy` | 15 | — |
| x6–x8 | Ramp (Multi-tier key crafting & swap puzzles) | 69–73 | `normal` | 20 | — |
| x9 | Hard (Red badge, +10% target D) | 74–76 | `hard` | 30 | — |
| x0 | Milestone Level | 65–68 | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L8000 | Phase Finale — Queen's Royal Lock Gala | ≈ 91 | `finale` | 50 | **Royal Honey Chest** |

### Difficulty Tiers

| Tier | Level Range | Grid Size | Lines | D Band |
|---|---|---|---|---|
| P16-A | 7501–7750 | 12×12 to 13×13 | 28–34 | 60–68 |
| P16-B | 7751–8000 | 13×13 to 14×14 | 32–40 | 68–76 |

### 50-Block Master Table

| Block | Range | x1 Feature / New Item | Grid | Lines | Target D | Hard (x9) | Gift Box (x0) |
|---|---|---|---|---|---|---|---|
| **1** | 7501–7510 | **Signature Intro: Royal Keyring** | 12×12 | 28 | 60–62 | L7509 (D 74) | 300 coins + Hint |
| **2** | 7511–7520 | **M751 Dew Key Chain** | 12×12 | 28–30 | 61–63 | L7519 (D 74) | 300 coins + Leaf Blower |
| **3–13** | 7521–7630 | Variants 1–11 (M751 progressive key chain stages) | 12×12–13×13 | 30–34 | 62–67 | x9 Hard | 300 coins + rot. |
| **14** | 7631–7640 | **M752 Key-Crafting Flower** | 13×13 | 32–34 | 66–68 | L7639 (D 75) | 300 coins + Shield |
| **15–25** | 7641–7750 | Variants 12–22 (M752 dual half-key synthesis routes) | 13×13 | 32–36 | 67–70 | x9 Hard | 300 coins + rot. |
| **26** | 7751–7760 | **M753 Skeleton Dew Key** | 13×13 | 34–36 | 69–71 | L7759 (D 75) | 300 coins + Hint |
| **27–37** | 7761–7870 | Variants 23–33 (M753 master row/column lock clearing) | 13×13–14×14 | 34–38 | 70–73 | x9 Hard | 300 coins + rot. |
| **38** | 7871–7880 | **M754 Key Swap Pad** | 14×14 | 36–38 | 72–74 | L7879 (D 76) | 300 coins + Leaf Blower |
| **39–49** | 7881–7990 | Variants 34–44 (M754 key icon reallocation tactics) | 14×14 | 36–40 | 73–75 | x9 Hard | 300 coins + rot. |
| **50** | 7991–8000 | **L7991 Mastery Mix / L8000 Queen's Royal Lock Gala** | 14×14 | 40 | 76 / 91 | L7999 (D 76) | L8000 **Royal Chest** |

### Gift Box Rotation
- 49 Gift Boxes at: L7510, L7520 … L7990.
- `(L / 10) mod 3` → 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield.

### L8000 Finale — Queen's Royal Lock Gala
- Grid: 14×14, 40 lines, target D ≈ 91.
- Reward: **Royal Honey Chest** — 1,000 coins + 2 Nectar Glow Hints + 2 Queen's Royal Shields + 2 Leaf Blowers + **"Master Keywright"** cosmetic badge.
- Major 80% milestone achievement toward level 10,000.

---

## Acceptance Criteria
- [ ] All 500 level seeds (L7501–8000) pass CI solver without boosters or heart loss.
- [ ] Grid dimensions conform strictly to 12×12–14×14 limits.
- [ ] Line counts remain within 28–40 across all blocks.
- [ ] 49 Gift Boxes awarded at exact x0 milestones.
- [ ] L8000 awards Royal Honey Chest + Master Keywright profile badge.
- [ ] `phase_16_meta.bin`: 500 records × 16 bytes = 8,000 bytes.

---

## Affected Files

| File / Module | Status |
|---|---|
| `assets/phase_16/seeds/phase_16_seeds.json` | To be created |
| `assets/phase_16/phase_16_meta.bin` | To be created |
| `packages/puzzle_core/lib/generator/royal_keyring_generator.dart` | To be created |

---

## Risks and Open Questions

1. **DAG Complexity Bounds:** The procedural generator must constrain key dependency chains to a maximum depth of 4 stages to avoid overly convoluted lock trees.

# Spec: Phase 20 Level Plan — Levels 9501–10,000 (Grand Master Garden)

Source docs: phase/phase_20/02_LEVEL_PLAN_9501_10000.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-20-base-mechanics.md, specs/gameplay/phase-20-variants-and-modifiers.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 20 Level Plan — Levels 9501–10,000 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 20 (Levels 9501–10,000) |

---

## Goal

Define the 500-level generation parameters, slot roles, difficulty scaling curve, grid dimensions, and the Ultimate Grand Finale (L10,000 Queen's Eternal Garden) for Levels 9501–10,000.

---

## Current State

Design documented in `phase/phase_20/02_LEVEL_PLAN_9501_10000.md`, not yet implemented.

---

## Proposed Change

### 1. 50-Block Architecture
Phase 20 comprises 500 levels organized into 50 blocks of 10 levels each:
- **Block 1 x1 (L9501):** Signature Intro — **Grand Master Garden (All Systems)**.
- **Block 2 x1 (L9511):** Grand Combo 1 Intro — **M951 Eternal Bloom Canopy**.
- **Block 14 x1 (L9631):** Grand Combo 2 Intro — **M952 Twin Cascade Nexus**.
- **Block 26 x1 (L9751):** Grand Combo 3 Intro — **M953 Shrouded Guardian Aegis**.
- **Block 38 x1 (L9871):** Grand Combo 4 Intro — **M954 Prismatic Rhythm Turntable**.
- **Blocks 3–13, 15–25, 27–37, 39–49 x1:** 44 Variant Intro Slots.
- **Block 50 x1 (L9991):** Review Level ("Mastery Mix").
- **L10,000 (Block 50 x0):** Ultimate Grand Finale — **Queen's Eternal Garden**.

### 2. Slot Roles & Target Difficulty Within Every Block

| Slot | Role | Target D | Tag | First Clear Coins | Milestone Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | Band Low (60–63) | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice / Integration | Band Mid (64–68) | `normal` | 20 | — |
| x5 | Breather (Accessible multi-system synergy) | Band Low (60–62) | `easy` | 15 | — |
| x6–x8 | Ramp (Complex multi-layer boss & puzzle layouts) | Band High (69–73) | `normal` | 20 | — |
| x9 | Hard Challenge | Band High × 1.1 (74–76) | `hard` | 30 | — |
| x0 | Milestone Level | Band Mid (65–68) | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L10,000 | Grand Finale | Band High × 1.25 (≈ 95) | `finale` | 100 | **Grand Royal Honey Chest** |

### 3. Tiers & Physical Parameters

#### Tier P20-A (Levels 9501–9750)
- **Grid Dimensions:** 13×13 to 14×14.
- **Line Count:** 32–36 active lines across ground and air layers.
- **Obstacle Count:** 10–12 static, boss, and combo obstacles.
- **Target D Band:** 60–68.

#### Tier P20-B (Levels 9751–10,000)
- **Grid Dimensions:** 14×14 maximum full board.
- **Line Count:** 36–40 active lines across ground, air, and canopy layers.
- **Obstacle Count:** 12–14 static, boss, kinetic, and optical obstacles.
- **Target D Band:** 68–76 (L10,000 peaks at D ≈ 95).

### 4. Ultimate Grand Finale: L10,000 Queen's Eternal Garden
- **Board Grid:** 14×14 maximum master grid.
- **Features:**
  - 3 simultaneous layers (Ground Ants, Worker Bees, Canopy Scout Bees).
  - 40 lines coordinating across at least 12 distinct mechanical systems.
  - Dual $2\times 2$ Twin Hornet Bosses with 3 Chitin Armor Shells each.
  - Multi-tier light beam routing, gravity slopes, and cyclic blooming vines.
- **Target Difficulty:** $D \approx 95$.
- **Completion Reward:**
  - 100 first-clear coins.
  - Grand Royal Honey Chest (1,000 coins + 2 of each booster + "Eternal Hive Champion" cosmetic badge & Crown Flower profile frame).
  - Permanent unlock of **Endless Grand Mastery Mode**.

---

## Verification Plan

### Automated Tests
1. Verify 500-level sequence covers all 50 blocks without missing or misaligned slot assignments.
2. Verify all intro levels (x1) enforce target D $\le 63$.
3. Verify all x9 hard levels apply the 1.1 difficulty multiplier and 'hard' tag.
4. Verify L10,000 features 40 lines, 3 layers, Twin Hornets, and target D ≈ 95.

### Manual Verification
1. Play through L9501, L9511, L9631, L9751, L9871, L10000 to confirm tutorial cards display on first encounter.
2. Confirm pinch-zoom and panning remain smooth and responsive on 14×14 grid scale.

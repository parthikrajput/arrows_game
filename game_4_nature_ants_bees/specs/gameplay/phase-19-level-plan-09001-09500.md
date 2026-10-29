# Spec: Phase 19 Level Plan — Levels 9001–9500 (Garden Festival II)

Source docs: phase/phase_19/02_LEVEL_PLAN_9001_9500.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-19-base-mechanics.md, specs/gameplay/phase-19-variants-and-modifiers.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 19 Level Plan — Levels 9001–9500 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 19 (Levels 9001–9500) |

---

## Goal

Define the 500-level generation parameters, slot roles, difficulty scaling curve, grid dimensions, and Phase Finale structure for Levels 9001–9500 (Garden Festival II — Remix B).

---

## Current State

Design documented in `phase/phase_19/02_LEVEL_PLAN_9001_9500.md`, not yet implemented.

---

## Proposed Change

### 1. 50-Block Architecture
Phase 19 comprises 500 levels organized into 50 blocks of 10 levels each:
- **Block 1 x1 (L9001):** Signature Intro — **Garden Festival II (Remix B)**.
- **Block 2 x1 (L9011):** Combo Mechanic 1 Intro — **M901 Falling Vines**.
- **Block 14 x1 (L9131):** Combo Mechanic 2 Intro — **M902 Rhythm Rotor**.
- **Block 26 x1 (L9251):** Combo Mechanic 3 Intro — **M903 Twin-Garden Fork**.
- **Block 38 x1 (L9371):** Combo Mechanic 4 Intro — **M904 Gravity Turntable**.
- **Blocks 3–13, 15–25, 27–37, 39–49 x1:** 45 Variant Intro Slots.
- **Block 50 x1 (L9491):** Review Level ("Mastery Mix").
- **L9500 (Block 50 x0):** Phase Finale — **Festival of Winds & Blooms**.

### 2. Slot Roles & Target Difficulty Within Every Block

| Slot | Role | Target D | Tag | First Clear Coins | Milestone Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | Band Low (60–63) | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice / Integration | Band Mid (64–68) | `normal` | 20 | — |
| x5 | Breather (Accessible kinetic alignment) | Band Low (60–62) | `easy` | 15 | — |
| x6–x8 | Ramp (Falling vine traps & cross-board split timing) | Band High (69–73) | `normal` | 20 | — |
| x9 | Hard Challenge | Band High × 1.1 (74–76) | `hard` | 30 | — |
| x0 | Milestone Level | Band Mid (65–68) | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L9500 | Phase Finale | Band High × 1.2 (≈ 91) | `finale` | 50 | **Royal Honey Chest** |

### 3. Tiers & Physical Parameters

#### Tier P19-A (Levels 9001–9250)
- **Grid Dimensions:** 12×12 to 13×13.
- **Line Count:** 28–34 active lines across ground and air layers.
- **Obstacle Count:** 8–12 static and kinetic combo obstacles.
- **Target D Band:** 60–68.

#### Tier P19-B (Levels 9251–9500)
- **Grid Dimensions:** 13×13 to 14×14.
- **Line Count:** 32–40 active lines across ground, air, and canopy layers.
- **Obstacle Count:** 10–14 static, kinetic combo, and cross-board obstacles.
- **Target D Band:** 68–76 (L9500 peaks at D ≈ 91).

### 4. Phase Finale: L9500 Festival of Winds & Blooms
- **Board Architecture:** Multi-board dual 14×14 grid setup.
- **Features:** Integrates Falling Vines (M901) sliding down gravitational slopes, Rhythm Rotors (M902) pulsing to musical beats, Twin-Garden Forks (M903) routing insect lines across linked boards, and Gravity Turntables (M904) redirecting debris streams.
- **Line Count:** Exactly 40 insects coordinating across all 3 spatial layers and dual boards.
- **Completion Reward:** Unlocks Royal Honey Chest containing 1,000 coins, 2 Nectar Glow Hints, 2 Queen's Royal Shields, 2 Leaf Blowers, and the **"Master Composer"** profile badge.

---

## Verification Plan

### Automated Tests
1. Verify 500-level sequence covers all 50 blocks without missing or misaligned slot assignments.
2. Verify all intro levels (x1) enforce target D $\le 63$.
3. Verify all x9 hard levels apply the 1.1 difficulty multiplier and 'hard' tag.
4. Verify L9500 integrates all 4 Phase 19 combo mechanics and target D ≈ 91.

### Manual Verification
1. Play through L9001, L9011, L9131, L9251, L9371 to confirm tutorial cards display on first encounter.
2. Confirm dual-board UI transitions are seamless and lag-free on low-end devices.

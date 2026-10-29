# Spec: Phase 18 Level Plan — Levels 8501–9000 (Garden Festival I)

Source docs: phase/phase_18/02_LEVEL_PLAN_8501_9000.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-18-base-mechanics.md, specs/gameplay/phase-18-variants-and-modifiers.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 18 Level Plan — Levels 8501–9000 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 18 (Levels 8501–9000) |

---

## Goal

Define the 500-level generation parameters, slot roles, difficulty scaling curve, grid dimensions per floor, and Phase Finale structure for Levels 8501–9000 (Garden Festival I — Remix A).

---

## Current State

Design documented in `phase/phase_18/02_LEVEL_PLAN_8501_9000.md`, not yet implemented.

---

## Proposed Change

### 1. 50-Block Architecture
Phase 18 comprises 500 levels organized into 50 blocks of 10 levels each:
- **Block 1 x1 (L8501):** Signature Intro — **Garden Festival I (Remix A)**.
- **Block 2 x1 (L8511):** Combo Mechanic 1 Intro — **M851 Day-Night Terrace**.
- **Block 14 x1 (L8631):** Combo Mechanic 2 Intro — **M852 Sunlit Acorn**.
- **Block 26 x1 (L8751):** Combo Mechanic 3 Intro — **M853 Shaded Stairs**.
- **Block 38 x1 (L8871):** Combo Mechanic 4 Intro — **M854 Dawn Marble**.
- **Blocks 3–13, 15–25, 27–37, 39–49 x1:** 45 Variant Intro Slots.
- **Block 50 x1 (L8991):** Review Level ("Mastery Mix").
- **L9000 (Block 50 x0):** Phase Finale — **Festival of Sunlight & Shadows**.

### 2. Slot Roles & Target Difficulty Within Every Block

| Slot | Role | Target D | Tag | First Clear Coins | Milestone Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | Band Low (60–63) | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice / Integration | Band Mid (64–68) | `normal` | 20 | — |
| x5 | Breather (Accessible hybrid transition) | Band Low (60–62) | `easy` | 15 | — |
| x6–x8 | Ramp (Multi-floor beam reflections & timing) | Band High (69–73) | `normal` | 20 | — |
| x9 | Hard Challenge | Band High × 1.1 (74–76) | `hard` | 30 | — |
| x0 | Milestone Level | Band Mid (65–68) | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L9000 | Phase Finale | Band High × 1.2 (≈ 91) | `finale` | 50 | **Royal Honey Chest** |

### 3. Tiers & Physical Parameters

#### Tier P18-A (Levels 8501–8750)
- **Grid Dimensions:** 12×12 per active floor.
- **Line Count:** 28–34 active lines across ground and air layers.
- **Obstacle Count:** 8–12 static and combo obstacles.
- **Target D Band:** 60–68.

#### Tier P18-B (Levels 8751–9000)
- **Grid Dimensions:** 13×13 to 14×14 per floor.
- **Line Count:** 32–40 active lines across ground, air, and canopy layers.
- **Obstacle Count:** 10–14 static, combo, and multi-floor obstacles.
- **Target D Band:** 68–76 (L9000 peaks at D ≈ 91).

### 4. Phase Finale: L9000 Festival of Sunlight & Shadows
- **Board Architecture:** Multi-floor 14×14 board setup (Floor 1 & Floor 2).
- **Features:** Integrates Day-Night Terraces (M851), Sunlit Acorns (M852) redirecting solar rays across levels, Shaded Stairs (M853) unlocked by optical networks, and Dawn Marbles (M854) sliding into pressure receptors.
- **Line Count:** Exactly 40 insects coordinating across all 3 spatial layers and 2 floors.
- **Completion Reward:** Unlocks Royal Honey Chest containing 1,000 coins, 2 Nectar Glow Hints, 2 Queen's Royal Shields, 2 Leaf Blowers, and the **"Festival Grandee"** profile badge.

---

## Verification Plan

### Automated Tests
1. Verify 500-level sequence covers all 50 blocks without missing or misaligned slot assignments.
2. Verify all intro levels (x1) enforce target D $\le 63$.
3. Verify all x9 hard levels apply the 1.1 difficulty multiplier and 'hard' tag.
4. Verify L9000 integrates all 4 Phase 18 combo mechanics and target D ≈ 91.

### Manual Verification
1. Play through L8501, L8511, L8631, L8751, L8871 to confirm tutorial cards display on first encounter.
2. Confirm multi-floor level navigation and zoom feel responsive on low-end devices.

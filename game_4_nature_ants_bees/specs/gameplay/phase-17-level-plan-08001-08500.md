# Spec: Phase 17 Level Plan — Levels 8001–8500 (Garden Guardians)

Source docs: phase/phase_17/02_LEVEL_PLAN_8001_8500.md, SHARED_CORE_STANDARD.md §9, §11, §17.38, SCALING_TO_10000_LEVELS.md §6, §7. Depends on: specs/gameplay/phase-17-base-mechanics.md, specs/gameplay/phase-17-variants-and-modifiers.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 17 Level Plan — Levels 8001–8500 |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 17 (Levels 8001–8500) |

---

## Goal

Define the 500-level generation parameters, slot roles, difficulty scaling curve, grid dimensions, and Phase Finale structure for Levels 8001–8500 (Garden Guardians).

---

## Current State

Design documented in `phase/phase_17/02_LEVEL_PLAN_8001_8500.md`, not yet implemented.

---

## Proposed Change

### 1. 50-Block Architecture
Phase 17 comprises 500 levels organized into 50 blocks of 10 levels each:
- **Block 1 x1 (L8001):** Signature System Intro — **Garden Guardians**.
- **Block 2 x1 (L8011):** Base Mechanic 1 Intro — **M801 Twin Hornets**.
- **Block 14 x1 (L8131):** Base Mechanic 2 Intro — **M802 Armored Rhino Beetle**.
- **Block 26 x1 (L8251):** Base Mechanic 3 Intro — **M803 Wasp Nest Guardian**.
- **Block 38 x1 (L8371):** Base Mechanic 4 Intro — **M804 Heart-Seed Guardian**.
- **Blocks 3–13, 15–25, 27–37, 39–49 x1:** 45 Variant Intro Slots.
- **Block 50 x1 (L8491):** Review Level ("Mastery Mix").
- **L8500 (Block 50 x0):** Phase Finale — **Royal Hive Defense Gala**.

### 2. Slot Roles & Target Difficulty Within Every Block

| Slot | Role | Target D | Tag | First Clear Coins | Milestone Reward |
|---|---|---|---|---|---|
| x1 | Intro (Signature / Base / Variant) | Band Low (60–63) | `normal` | 20 | Tutorial Card |
| x2–x4 | Practice / Integration | Band Mid (64–68) | `normal` | 20 | — |
| x5 | Breather (Accessible 2-hit boss) | Band Low (60–62) | `easy` | 15 | — |
| x6–x8 | Ramp (Shields & Spawners combined) | Band High (69–73) | `normal` | 20 | — |
| x9 | Hard Challenge | Band High × 1.1 (74–76) | `hard` | 30 | — |
| x0 | Milestone Level | Band Mid (65–68) | `normal` | 20 | **Queen's Gift Box** (300 coins + 1 booster) |
| L8500 | Phase Finale | Band High × 1.2 (≈ 91) | `finale` | 50 | **Royal Honey Chest** |

### 3. Tiers & Physical Parameters

#### Tier P17-A (Levels 8001–8250)
- **Grid Dimensions:** 12×12 to 13×13.
- **Line Count:** 28–34 active lines across ground and air layers.
- **Obstacle Count:** 8–12 static and guardian obstacles.
- **Target D Band:** 60–68.

#### Tier P17-B (Levels 8251–8500)
- **Grid Dimensions:** 13×13 to 14×14.
- **Line Count:** 32–40 active lines across ground, air, and canopy layers.
- **Obstacle Count:** 10–14 static, guardian, and spawner obstacles.
- **Target D Band:** 68–76 (L8500 peaks at D ≈ 91).

### 4. Phase Finale: L8500 Royal Hive Defense Gala
- **Board Grid:** 14×14 full master battleground.
- **Features:** Simultaneous encounter against Twin Hornets (M801), an Armored Rhino Beetle (M802), a Wasp Nest Spawner (M803), and a central Heart-Seed Guardian (M804).
- **Line Count:** Exactly 40 insects coordinating across all 3 spatial layers.
- **Completion Reward:** Unlocks Royal Honey Chest containing 1,000 coins, 2 Nectar Glow Hints, 2 Queen's Royal Shields, 2 Leaf Blowers, and the **"Hive Protector"** profile badge.

---

## Verification Plan

### Automated Tests
1. Verify 500-level sequence covers all 50 blocks without missing or misaligned slot assignments.
2. Verify all intro levels (x1) enforce target D $\le 63$.
3. Verify all x9 hard levels apply the 1.1 difficulty multiplier and 'hard' tag.
4. Verify L8500 features all 4 Phase 17 base mechanics and target D ≈ 91.

### Manual Verification
1. Play through L8001, L8011, L8131, L8251, L8371 to confirm tutorial cards display on first encounter.
2. Validate pinch-zoom and panning smoothness on 14×14 board sizes.

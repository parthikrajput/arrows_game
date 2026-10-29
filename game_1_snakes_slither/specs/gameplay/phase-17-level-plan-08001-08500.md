# Technical Specification: Phase 17 Level Plan (Levels 8001–8500)

**Status:** Draft  
**Phase:** 17 (Levels 8001–8500)  
**Theme:** Mongoose Clan (Guardians)  
**Document Type:** Technical Level Progression Specification  
**Source Cross-Reference:** [phases/phase_17/02_LEVEL_PLAN_8001_8500.md](../../phases/phase_17/02_LEVEL_PLAN_8001_8500.md), [SCALING_TO_10000_LEVELS.md §2–§4](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Phase Structure & Sub-Tiers

Phase 17 spans 500 levels structured across 50 discrete blocks (Blocks 801 to 850) divided into two sub-tiers:
- **Sub-Tier P17-A (Levels 8001–8250, Blocks 801–825):** Biome: *Mongoose Outpost* (`#EFEBE9`). Focus on M801 Mongoose Twins and M802 Armadillo Guardian. Difficulty plateau $D \in [60, 72]$.
- **Sub-Tier P17-B (Levels 8251–8500, Blocks 826–850):** Biome: *Den of the Clan* (`#D7CCC8`). Focus on M803 Mama Mongoose, M804 Den Core, and high-density multi-guardian encounters. Difficulty plateau $D \in [68, 76]$; Hard slots $D \approx 84$; Grand Finale Level 8500 $D \approx 91$.

---

## 2. 10-Level Block Template

Every 10-level block adheres strictly to the canonical distribution:
- **Slot 1 (x1):** Mechanic/Variant Introduction (Easy, $D = 60$).
- **Slot 2 (x2):** Reinforcement & Basic Routing (Easy, $D = 62$).
- **Slot 3 (x3):** Extended Path & Squeeze Navigation (Normal, $D = 65$).
- **Slot 4 (x4):** Recovery & Rhythm Check (Easy, $D = 61$).
- **Slot 5 (x5):** Multi-Snake Synchronization (Normal, $D = 68$).
- **Slot 6 (x6):** Density Spike & Narrow Channels (Normal, $D = 71$).
- **Slot 7 (x7):** Boss HP Threshold & Dynamic Shift Testing (Normal, $D = 73$).
- **Slot 8 (x8):** Pre-Climax Pressure (Normal, $D = 75$).
- **Slot 9 (x9):** Block Climax (Hard, $D \approx 82-85$).
- **Slot 10 (x0):** Milestone Gate & Gift Basket Unlock (Milestone, $D = 74$).

---

## 3. 50-Block Distribution Schedule

| Block # | Level Range | Sub-Tier | Primary Mechanic / Focus | Highlight Milestone |
| :---: | :---: | :---: | :--- | :--- |
| **801** | 8001–8010 | P17-A | Phase 17 Signature Intro: Guardians | Gift Basket 1 @ 8010 |
| **802** | 8011–8020 | P17-A | M801 Mongoose Twins / Twin Guardian Intro | Gift Basket 2 @ 8020 |
| **803** | 8021–8030 | P17-A | V01: Chroma Twins | Rush 1 @ 8025; Basket 3 @ 8030 |
| **804** | 8031–8040 | P17-A | V02: Tri-Mongoose Clan | Gift Basket 4 @ 8040 |
| **805** | 8041–8050 | P17-A | V03: Restless Twins | Rush 2 @ 8050; Basket 5 @ 8050 |
| **806–813**| 8051–8130 | P17-A | V04–V11: Twin Guardians & Choke Point Modifiers | Baskets 6–13; Rushes 3–5 |
| **814** | 8131–8140 | P17-A | M802 Armadillo Guardian / Shield Intro | Gift Basket 14 @ 8140 |
| **815–824**| 8141–8240 | P17-A | V12–V21: Shield Levers, Armor & Vulnerability Windows | Baskets 15–24; Rushes 6–9 |
| **825** | 8241–8250 | P17-A | V22: Mongoose Outpost Citadel (P17-A Climax) | Rush 10 @ 8250; Basket 25 @ 8250 |
| **826** | 8251–8260 | P17-B | M803 Mama Mongoose / Spawner Intro | Gift Basket 26 @ 8260 |
| **827–836**| 8261–8360 | P17-B | V23–V32: Rock Spawners & Board Obstacle Control | Baskets 27–36; Rushes 11–14 |
| **837** | 8361–8370 | P17-B | V33: Broodmother Matriarch | Basket 37 @ 8370; Rush 15 @ 8375 |
| **838** | 8371–8380 | P17-B | M804 Guardian Core / Den Core Intro | Gift Basket 38 @ 8380 |
| **839–849**| 8381–8490 | P17-B | V34–V44: Directional Core Gates & Multi-Boss Bastions | Baskets 39–49; Rushes 16–19 |
| **850** | 8491–8500 | P17-B | V45: Grand Mongoose Clan Finale ($14 \times 14$ grid) | Level 8500 Finale Chest + Badge |

---

## 4. Finale Level 8500 Technical Parameters
- **Grid Dimension:** $14 \times 14$ with pan and pinch zoom enabled.
- **Snake Count:** 42 snakes (8 length-8, 14 length-6, 12 length-4, 8 length-3).
- **Obstacles:** 15 obstacles (canyon boulders, heavy palisades, bone markers).
- **Active Mechanics:** M801 + M802 + M803 + M804 integrated in ultimate fortress layout.
- **Estimated Solver Move Budget:** 74 moves ($D \approx 91$).

---

## 5. References & Cross-Links
- [Phase 17 Base Mechanics](phase-17-base-mechanics.md)
- [Phase 17 Variants and Modifiers](phase-17-variants-and-modifiers.md)
- [Phase 17 Rewards](../economy/phase-17-rewards.md)

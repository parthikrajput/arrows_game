# Technical Specification: Phase 15 Level Plan (Levels 7001–7500)

**Status:** Draft  
**Phase:** 15 (Levels 7001–7500)  
**Theme:** River Delta (Conveyors & Tracks)  
**Document Type:** Technical Level Progression Specification  
**Source Cross-Reference:** [phases/phase_15/02_LEVEL_PLAN_7001_7500.md](../../phases/phase_15/02_LEVEL_PLAN_7001_7500.md), [SCALING_TO_10000_LEVELS.md §2–§4](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Phase Structure & Sub-Tiers

Phase 15 spans 500 levels structured across 50 discrete blocks (Blocks 701 to 750) divided into two sub-tiers:
- **Sub-Tier P15-A (Levels 7001–7250, Blocks 701–725):** Biome: *Estuary Marsh* (`#E0F7FA`). Focus on M701 Belt Junction and M702 Tide River. Difficulty plateau $D \in [60, 72]$.
- **Sub-Tier P15-B (Levels 7251–7500, Blocks 726–750):** Biome: *Delta Rapids* (`#80DEEA`). Focus on M703 Sluice Lever, M704 Whirlpool Loop, and complex hybrid circuits. Difficulty plateau $D \in [68, 76]$; Hard slots $D \approx 84$; Grand Finale Level 7500 $D \approx 91$.

---

## 2. 10-Level Block Template

Every 10-level block adheres strictly to the canonical distribution:
- **Slot 1 (x1):** Mechanic/Variant Introduction (Easy, $D = 60$).
- **Slot 2 (x2):** Reinforcement & Basic Routing (Easy, $D = 62$).
- **Slot 3 (x3):** Extended Path & Squeeze Navigation (Normal, $D = 65$).
- **Slot 4 (x4):** Recovery & Rhythm Check (Easy, $D = 61$).
- **Slot 5 (x5):** Multi-Snake Synchronization (Normal, $D = 68$).
- **Slot 6 (x6):** Density Spike & Narrow Channels (Normal, $D = 71$).
- **Slot 7 (x7):** Reversal / Dynamic Shift Testing (Normal, $D = 73$).
- **Slot 8 (x8):** Pre-Climax Pressure (Normal, $D = 75$).
- **Slot 9 (x9):** Block Climax (Hard, $D \approx 82-85$).
- **Slot 10 (x0):** Milestone Gate & Gift Basket Unlock (Milestone, $D = 74$).

---

## 3. 50-Block Distribution Schedule

| Block # | Level Range | Sub-Tier | Primary Mechanic / Focus | Highlight Milestone |
| :---: | :---: | :---: | :--- | :--- |
| **701** | 7001–7010 | P15-A | Phase 15 Signature Intro: Conveyor Belts | Gift Basket 1 @ 7010 |
| **702** | 7011–7020 | P15-A | M701 River Fork / Belt Junction Intro | Gift Basket 2 @ 7020 |
| **703** | 7021–7030 | P15-A | V01: Tri-Fork Junction | Rush 1 @ 7025; Basket 3 @ 7030 |
| **704** | 7031–7040 | P15-A | V02: Chroma Junction | Gift Basket 4 @ 7040 |
| **705** | 7041–7050 | P15-A | V03: Timed Switch | Rush 2 @ 7050; Basket 5 @ 7050 |
| **706–713**| 7051–7130 | P15-A | V04–V11: Junction Modifiers & Cascade Networks | Baskets 6–13; Rushes 3–5 |
| **714** | 7131–7140 | P15-A | M702 Tide River / Reversible Belt Intro | Gift Basket 14 @ 7140 |
| **715–724**| 7141–7240 | P15-A | V12–V21: Tidal Surge, Phase, & Directional Modifiers | Baskets 15–24; Rushes 6–9 |
| **725** | 7241–7250 | P15-A | V22: Grand Delta Surge (Estuary Marsh Climax) | Rush 10 @ 7250; Basket 25 @ 7250 |
| **726** | 7251–7260 | P15-B | M703 Sluice Lever / Belt Lever Intro | Gift Basket 26 @ 7260 |
| **727–736**| 7261–7360 | P15-B | V23–V32: Sluice Lever Arrays & Hydraulic Networks | Baskets 27–36; Rushes 11–14 |
| **737** | 7361–7370 | P15-B | V33: Delta Canal Network | Basket 37 @ 7370; Rush 15 @ 7375 |
| **738** | 7371–7380 | P15-B | M704 Whirlpool / Track Loop Intro | Gift Basket 38 @ 7380 |
| **739–749**| 7381–7490 | P15-B | V34–V44: Whirlpool Chains, Maelstroms & Hybrids | Baskets 39–49; Rushes 16–19 |
| **750** | 7491–7500 | P15-B | V45: Grand Delta Finale Gauntlet ($14 \times 14$ grid) | Level 7500 Finale Chest + Badge |

---

## 4. Finale Level 7500 Technical Parameters
- **Grid Dimension:** $14 \times 14$ with mandatory pan and pinch zoom.
- **Snake Count:** 42 snakes (6 length-8, 12 length-6, 16 length-4, 8 length-3).
- **Obstacles:** 15 obstacles (sunken river pilings, reed beds, sluice gates).
- **Active Mechanics:** M701 + M702 + M703 + M704 simultaneous integration.
- **Estimated Solver Move Budget:** 68 moves ($D \approx 91$).

---

## 5. References & Cross-Links
- [Phase 15 Base Mechanics](phase-15-base-mechanics.md)
- [Phase 15 Variants and Modifiers](phase-15-variants-and-modifiers.md)
- [Phase 15 Rewards](../economy/phase-15-rewards.md)

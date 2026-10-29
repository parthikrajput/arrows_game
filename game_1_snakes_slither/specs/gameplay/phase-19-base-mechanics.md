# Technical Specification: Phase 19 Base Mechanics (Remix B)

**Status:** Draft  
**Phase:** 19 (Levels 9001–9500)  
**Theme:** Remix B (Phase 7 to Phase 12 Mechanics Synergy)  
**Document Type:** Technical Mechanics Specification  
**Source Cross-Reference:** [phases/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md](../../phases/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md), [SCALING_TO_10000_LEVELS.md §6, §9](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Mechanics Overview

Phase 19 introduces four data-driven combo mechanics combining dynamic late-game systems from Phases 7 through 12:

| Mechanic ID | Mechanic Name | Themed In-Game Name | Eras Combined | Introduction Level | Block Slot | Core Purpose |
| :---: | :--- | :--- | :---: | :---: | :---: | :--- |
| **M901** | Wind-Driven Vine | Gale Vine | Phase 7 (Wind) + Phase 8 (Vines) | Level 9011 | Block 902 (x1) | Overgrown vines whose growth vector is guided and deflected by wind currents |
| **M902** | Split River Bridge | Siphon Rapids | Phase 9 (Twin Rivers) + Phase 11 (Reflection) | Level 9131 | Block 914 (x1) | Coupled river canals whose flow vectors flip via reflection lily pad triggers |
| **M903** | Rhythm Gravity Cascade | Monsoon Downbeat | Phase 10 (Drum Gates) + Phase 12 (Monsoon) | Level 9251 | Block 926 (x1) | Polyrhythmic 3-beat cycle: Beat 3 triggers directional monsoon wind + gate toggle |
| **M904** | Echo Weight Shift | Seismic Resonator | Phase 10 (Echo Gates) + Phase 12 (Heavy Python) | Level 9371 | Block 938 (x1) | Heavy snake impacts emit radial seismic waves ($r=4$) opening distant echo locks |

---

## 2. Detailed Mechanic Specifications

### 2.1 M901: Wind-Driven Vine (Gale Vine)
- **Level Intro:** Level 9011 (Block 902, x1 slot).
- **Behavior & Rules:**
  - Active vine shoots expand 1 tile every 2 moves.
  - Direction of expansion is strictly determined by ambient `currentWindVector`.
  - Opposing wind suppresses growth entirely.
  - Players can toggle wind switch levers to bend vine growth around obstacles or seal off hazardous passages.

### 2.2 M902: Split River Bridge (Siphon Rapids)
- **Level Intro:** Level 9131 (Block 914, x1 slot).
- **Behavior & Rules:**
  - Two parallel rivers flowing in opposite directions.
  - Stepping on a submerged reflection lily pad activates a hydraulic siphon bridge.
  - The bridge links the waterways and reverses the current vectors of both rivers.
  - Resting snakes are propelled 1 extra tile along the reversed current vector.

### 2.3 M903: Rhythm Gravity Cascade (Monsoon Downbeat)
- **Level Intro:** Level 9251 (Block 926, x1 slot).
- **Behavior & Rules:**
  - Governed by a repeating 3-beat cadence ($B_1, B_2, B_3$).
  - Beats 1 & 2: Neutral conditions, snakes move under standard rules.
  - Beat 3 (Downbeat): Torrential monsoon gust applies a 1-tile force vector to all snakes and simultaneously inverts Drum Gate states (Open $\leftrightarrow$ Closed).
  - Ticker displays pulsing drum beats to allow precise planning.

### 2.4 M904: Echo Weight Shift (Seismic Resonator)
- **Level Intro:** Level 9371 (Block 938, x1 slot).
- **Behavior & Rules:**
  - Heavy python segments ($2\times$ mass) stepping onto bedrock ground tiles generate acoustic shockwaves.
  - Shockwave radiates outward up to $r = 4$ tiles Manhattan distance.
  - Resonant Echo Bells within range ring and open corresponding locked gates for 3 moves.
  - Standard snakes are too light to generate seismic resonance.

---

## 3. Integration & Interaction Matrix

| Interaction Pair | Interaction Behavior |
| :--- | :--- |
| **M901 (Vine) + M903 (Monsoon)** | Downbeat wind force bends growing vine around corner into key slot. |
| **M902 (River) + M904 (Seismic)** | Heavy python landing on riverbank triggers shockwave across water to island bell. |
| **Conveyor (Phase 15) + M902** | Siphon current extends conveyor slide distance across river bridges. |
| **Guardians (Phase 17) + M903** | Monsoon downbeat forces resting guardian minions back 1 tile. |

---

## 4. References & Cross-Links
- [Phase 19 Signature System](phase-19-signature-system.md)
- [Phase 19 Variants and Modifiers](phase-19-variants-and-modifiers.md)
- [Phase 19 Level Plan](phase-19-level-plan-09001-09500.md)


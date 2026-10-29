# Technical Specification: Phase 18 Base Mechanics (Remix A)

**Status:** Draft  
**Phase:** 18 (Levels 8501–9000)  
**Theme:** Remix A (Early Eras Synergy / Data-Driven)  
**Document Type:** Technical Mechanics Specification  
**Source Cross-Reference:** [phases/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md](../../phases/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md), [SCALING_TO_10000_LEVELS.md §6, §9](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Mechanics Overview

Phase 18 introduces four data-driven combo mechanics combining high-engagement systems from Phases 1 through 6:

| Mechanic ID | Mechanic Name | Themed In-Game Name | Eras Combined | Introduction Level | Block Slot | Core Purpose |
| :---: | :--- | :--- | :---: | :---: | :---: | :--- |
| **M851** | Cycle Floor Elevator | Seasonal Elevator | Phase 3 (Day/Night) + Phase 4 (Elevator) | Level 8511 | Block 852 (x1) | Seasonal dial flips raising or lowering sub-floor tiles every $N$ turns |
| **M852** | Prism Coconut Roll | Refraction Boulder | Phase 5 (Coconuts) + Phase 6 (Prisms) | Level 8631 | Block 864 (x1) | Heavy rolling boulder that deflects or is disintegrated by focused prism beams |
| **M853** | Solar Burrow Portal | Sun Portal | Phase 1 (Burrows) + Phase 6 (Solar Switches) | Level 8751 | Block 876 (x1) | Burrow portal gates that activate only when illuminated by focused solar light |
| **M854** | Shadow Weight Drop | Trapdoor Balance | Phase 5 (Weight Plates) + Phase 6 (Shadow Gates) | Level 8871 | Block 888 (x1) | Heavy counter-weighted trapdoors toggled by coconut placement and light casting |

---

## 2. Detailed Mechanic Specifications

### 2.1 M851: Cycle Floor Elevator (Seasonal Elevator)
- **Level Intro:** Level 8511 (Block 852, x1 slot).
- **Behavior & Rules:**
  - Day/Night (or Seasonal) dial increments every move. Every 5 moves, the cycle shifts.
  - Designated elevator tiles switch height between Level 1 (sub-floor) and Level 2 (ground floor).
  - When elevated, snakes can slither across bridges over lower trenches; when lowered, snakes can access sunken burrows.

### 2.2 M852: Prism Coconut Roll (Refraction Boulder)
- **Level Intro:** Level 8631 (Block 864, x1 slot).
- **Behavior & Rules:**
  - Heavy coconut boulder pushed by snake impact.
  - When a rolling coconut intersects a refracted prism beam:
    - Normal light: Boulder deflects at $90^\circ$ angle along beam path.
    - Laser/Solar beam: Boulder shatters into dust, clearing an obstructed gateway.

### 2.3 M853: Solar Burrow Portal (Sun Portal)
- **Level Intro:** Level 8751 (Block 876, x1 slot).
- **Behavior & Rules:**
  - Underground burrow wormholes paired across the board.
  - A burrow is dormant (closed) until a light beam is steered onto its solar receptor gem.
  - Once energized, entering Snake Head immediately warps to paired exit with particle swirl.

### 2.4 M854: Shadow Weight Drop (Trapdoor Balance)
- **Level Intro:** Level 8871 (Block 888, x1 slot).
- **Behavior & Rules:**
  - Pressure plates requiring specific cumulative weight ($1W$, $2W$).
  - Dropping a heavy coconut onto plate raises an iron portcullis or lowers a trapdoor.
  - Casting a shadow over the receptor inverts the weight requirement.

---

## 3. Integration & Interaction Matrix

| Interaction Pair | Interaction Behavior |
| :--- | :--- |
| **M851 (Elevator) + M852 (Coconut)** | Pushing a coconut off an elevated floor causes it to fall into lower trench, activating sunken plate. |
| **M853 (Sun Portal) + M851 (Elevator)** | Elevating floor reveals a previously hidden portal receptor gem to incoming light beams. |
| **M854 (Weight) + Conveyor (Phase 15)** | Conveyor belt transports coconut onto moving pressure plate. |
| **Multi-Snake Coordination** | Snake A pushes coconut to weigh down plate, opening gate for Snake B to exit. |

---

## 4. Open Questions & Analytics Data Gap
- **Open Question P18-OQ-01:** Live telemetry weights between Coconut Fun Rating vs Booster Reliance: If live metrics show player drop-off on multi-step boulder puzzles, generator seed difficulty clamp will enforce $\le 2$ coconut pushes per level.

---

## 5. References & Cross-Links
- [Phase 18 Signature System](phase-18-signature-system.md)
- [Phase 18 Variants and Modifiers](phase-18-variants-and-modifiers.md)
- [Phase 18 Level Plan](phase-18-level-plan-08501-09000.md)

# Technical Specification: Phase 17 Base Mechanics (Mongoose Clan)

**Status:** Draft  
**Phase:** 17 (Levels 8001–8500)  
**Theme:** Mongoose Clan (Guardians)  
**Document Type:** Technical Mechanics Specification  
**Source Cross-Reference:** [phases/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md](../../phases/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md), [SCALING_TO_10000_LEVELS.md §6](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Mechanics Overview

Phase 17 introduces four base guardian mechanics that transform level completion from simple pathfinding to strategic boss damage sequencing:

| Mechanic ID | Mechanic Name | Themed In-Game Name | Introduction Level | Block Slot | Core Purpose |
| :---: | :--- | :--- | :---: | :---: | :--- |
| **M801** | Twin Guardian | Mongoose Twins | Level 8011 | Block 802 (x1) | Dual guardians sharing one unified HP pool; defeating one clears both |
| **M802** | Shield Guardian | Armadillo Guardian | Level 8131 | Block 814 (x1) | Invulnerable barrier guardian deactivated via interactive shield lever |
| **M803** | Spawner Guardian | Mama Mongoose | Level 8251 | Block 826 (x1) | Periodically drops garden rocks into board cells up to a strict cap of 3 |
| **M804** | Guardian Core | Den Core | Level 8371 | Block 838 (x1) | Direction-sensitive guardian core vulnerable only to specific snake attack vectors |

---

## 2. Detailed Mechanic Specifications

### 2.1 M801: Mongoose Twins / Twin Guardian
- **Level Intro:** Level 8011 (Block 802, x1 slot).
- **Behavior & Rules:**
  - Two distinct mongoose guardians placed on opposite quadrants of the board.
  - Linked to a single shared health pool (e.g. 6 total HP).
  - Each snake cleared from the board deducts 1 HP regardless of which side is used.
  - When the shared pool reaches 0, both twins burrow away simultaneously, clearing 2 strategic board choke points.

### 2.2 M802: Armadillo Guardian / Shield Guardian
- **Level Intro:** Level 8131 (Block 814, x1 slot).
- **Behavior & Rules:**
  - Stationary guardian curled in impenetrable crystalline armor.
  - While shield lever is ON, armadillo deflects all damage (snakes exiting grant 0 HP loss).
  - Tapping the shield lever lowers armor for 3 moves (`Move += 1`).
  - Players must coordinate snake clearing during the vulnerable lever window.

### 2.3 M803: Mama Mongoose / Spawner Guardian
- **Level Intro:** Level 8251 (Block 826, x1 slot).
- **Behavior & Rules:**
  - Stationary matriarch defending nest entrance.
  - Every 4 moves, tosses a garden rock into the closest unoccupied board tile.
  - **Hard Cap:** Exactly 3 active spawned rocks permitted at any time. If 3 rocks exist, spawning pauses until a rock is broken or snake clears.
  - Prevents board flooding and solver deadlock.

### 2.4 M804: Mongoose Den Core / Guardian Core
- **Level Intro:** Level 8371 (Block 838, x1 slot).
- **Behavior & Rules:**
  - Heavy central fortress core with colored directional armor plates (e.g., North, East, South, West).
  - Only takes damage when a snake exits through an unshielded cardinal gateway matching the illuminated plate.
  - Clearing snakes through wrong angles deflects harmlessly.

---

## 3. Integration & Interaction Matrix

| Interaction Pair | Interaction Behavior |
| :--- | :--- |
| **M801 (Twins) + M802 (Shield)** | Twin A may be unshielded while Twin B is shielded, allowing players to focus damage on Twin A. |
| **M803 (Spawner) + M804 (Core)** | Spawned rocks can block vulnerable core access vectors, requiring immediate hammer or route bypass. |
| **Conveyors (Phase 15) + Guardians** | Conveyors push resting snakes past guardian attack zones or toward exit triggers. |
| **Keys (Phase 16) + Shield Lever** | Lever may be locked behind a key barrier, enforcing DAG solve before shield can drop. |

---

## 4. References & Cross-Links
- [Phase 17 Signature System](phase-17-signature-system.md)
- [Phase 17 Variants and Modifiers](phase-17-variants-and-modifiers.md)
- [Phase 17 Level Plan](phase-17-level-plan-08001-08500.md)

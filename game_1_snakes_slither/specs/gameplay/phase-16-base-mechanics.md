# Technical Specification: Phase 16 Base Mechanics (Treasure Keys)

**Status:** Draft  
**Phase:** 16 (Levels 7501–8000)  
**Theme:** Treasure Keys (Keys Deluxe)  
**Document Type:** Technical Mechanics Specification  
**Source Cross-Reference:** [phases/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md](../../phases/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md), [SCALING_TO_10000_LEVELS.md §6](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Mechanics Overview

Phase 16 introduces four advanced key manipulation mechanics that govern locking topologies, crafting pipelines, and dynamic key distribution:

| Mechanic ID | Mechanic Name | Themed In-Game Name | Introduction Level | Block Slot | Core Purpose |
| :---: | :--- | :--- | :---: | :---: | :--- |
| **M751** | Key Chain / Key Vine | Golden Vine Lock | Level 7511 | Block 752 (x1) | Unlocking a gate unspools a vine, releasing a secondary key onto the board |
| **M752** | Key Bundle / Key Crafting | Key Forge | Level 7631 | Block 764 (x1) | Collecting two half-keys automatically synthesizes a master key |
| **M753** | Golden Master Leaf | Skeleton Key | Level 7751 | Block 776 (x1) | Universal master key capable of opening any locked barrier or gate |
| **M754** | Key Swap Stone | Key Swap Pedestal | Level 7871 | Block 788 (x1) | Stepping onto pedestal exchanges held key with pedestal's seated key |

---

## 2. Detailed Mechanic Specifications

### 2.1 M751: Key Vine / Golden Vine Lock
- **Level Intro:** Level 7511 (Block 752, x1 slot).
- **Behavior & Rules:**
  - A locked barrier physically tethered by a golden leafy vine to a secondary locked tile or enclosed key.
  - When Snake unlocks Gate 1 using Key 1:
    - Gate 1 dissolves.
    - Golden vine unspools with particle trail across the board.
    - Key 2 drops onto designated grid cell, becoming collectable.
  - Enforces strict sequential dependency (Lock 1 $\to$ Vine Release $\to$ Key 2 $\to$ Lock 2).

### 2.2 M752: Key Crafting / Key Forge
- **Level Intro:** Level 7631 (Block 764, x1 slot).
- **Behavior & Rules:**
  - Board contains split key fragments: Half-Key A (Head) and Half-Key B (Shaft/Teeth).
  - Snakes must independently navigate to collect each piece.
  - Upon collecting both fragments, the HUD forge ribbon plays a metallic clink VFX/SFX, merging them into a usable Master Key.
  - Gates require a forged Master Key and reject individual unmerged halves.

### 2.3 M753: Golden Master Leaf / Skeleton Key
- **Level Intro:** Level 7751 (Block 776, x1 slot).
- **Behavior & Rules:**
  - Rare universal golden key entity.
  - Can open any colored lock, vine gate, or vault door regardless of color-coding or shape.
  - Single use: consumed immediately upon unlocking one gate.
  - Introduces strategic player choice: which branch or gate to bypass first.

### 2.4 M754: Key Swap Stone / Key Swap Pedestal
- **Level Intro:** Level 7871 (Block 788, x1 slot).
- **Behavior & Rules:**
  - Carved stone pedestal occupying a grid node, holding an idle key.
  - When a snake carrying an active key slithers onto the pedestal:
    - Held key is deposited onto the pedestal.
    - Pedestal's key is picked up by the snake.
    - Swapping consumes 0 extra moves (part of snake traversal).
  - Used to juggle color-coded keys to open matching locks on opposite sides of barriers.

---

## 3. Integration & Interaction Matrix

| Interaction Pair | Interaction Behavior |
| :--- | :--- |
| **M751 (Vine) + M752 (Crafting)** | Vine release can drop a half-key required for forge completion. |
| **M753 (Skeleton) + M751 (Vine)** | Using Skeleton Key on vine gate unspools chain without needing specific color key. |
| **M754 (Swap) + Multi-Snake** | Snake 1 drops Key A on pedestal; Snake 2 later picks up Key A to open remote gate. |
| **Conveyor (Phase 15) + Key Drop** | Key released by vine onto conveyor is carried along stream to downstream pool. |

---

## 4. References & Cross-Links
- [Phase 16 Signature System](phase-16-signature-system.md)
- [Phase 16 Variants and Modifiers](phase-16-variants-and-modifiers.md)
- [Phase 16 Level Plan](phase-16-level-plan-07501-08000.md)


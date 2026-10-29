# Technical Specification: Phase 15 Base Mechanics (River Delta)

**Status:** Draft  
**Phase:** 15 (Levels 7001–7500)  
**Theme:** River Delta (Conveyors & Tracks)  
**Document Type:** Technical Mechanics Specification  
**Source Cross-Reference:** [phases/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md](../../phases/phase_15/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md), [SCALING_TO_10000_LEVELS.md §6](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Mechanics Overview

Phase 15 introduces four foundational conveyor mechanics that manipulate snake transport, directionality, and grid topology across the River Delta:

| Mechanic ID | Mechanic Name | Themed In-Game Name | Introduction Level | Block Slot | Core Purpose |
| :---: | :--- | :--- | :---: | :---: | :--- |
| **M701** | Belt Junction | River Fork | Level 7011 | Block 702 (x1) | Diverts snake path at branch points via toggle switch |
| **M702** | Reversible Belt | Tide River | Level 7131 | Block 714 (x1) | Periodically flips river flow direction every $N$ moves |
| **M703** | Belt Lever | Sluice Lever | Level 7251 | Block 726 (x1) | Interactive switch activating/deactivating conveyor flow |
| **M704** | Track Loop | Whirlpool | Level 7371 | Block 738 (x1) | Closed loop circulating snakes until tap on tangent exit |

---

## 2. Detailed Mechanic Specifications

### 2.1 M701: River Fork / Belt Junction
- **Level Intro:** Level 7011 (Block 702, x1 slot).
- **Behavior & Rules:**
  - A 1-input, 2-output conveyor tile (e.g., Input West $\to$ Output North or Output East).
  - Contains an interactive mechanical toggle switch/diverter paddle.
  - Tapping the switch flips active output branch and consumes 1 move (`Move += 1`).
  - Snakes reaching the junction follow the currently active illuminated branch.
- **State Representation:**
  ```dart
  class JunctionState {
    final Point<int> position;
    final Vector2 inputDir;
    final List<Vector2> outputOptions; // Exactly 2 options
    int activeIndex; // 0 or 1

    Vector2 get currentOutput => outputOptions[activeIndex];
    void toggle() => activeIndex = (activeIndex + 1) % outputOptions.length;
  }
  ```

### 2.2 M702: Tide River / Reversible Belt
- **Level Intro:** Level 7131 (Block 714, x1 slot).
- **Behavior & Rules:**
  - River sections marked with tidal foam and dual-directional chevron arrows.
  - Direction flips $180^\circ$ every $N$ moves ($N=4$ standard, $N=2$ rapid, $N=6$ calm).
  - Calculated as: `isFlipped = (moveCount ~/ N) % 2 == 1`.
  - Snakes pushed backward or forward depending on tidal surge phase.
- **HUD Indicator:** Floating tidal icon showing countdown moves until reversal (`[TIDE: -> EAST (FLIP IN 2 MOVES)]`).

### 2.3 M703: Sluice Lever / Belt Lever
- **Level Intro:** Level 7251 (Block 726, x1 slot).
- **Behavior & Rules:**
  - Sluice gate lever situated on board edge or adjacent bank.
  - Tapping lever toggles sluice gate open/shut (`Move += 1`).
  - Open gate: Conveyor water rushes, carrying snakes 1 tile/move.
  - Closed gate: Conveyor dries to static riverbed floor; snakes move under normal manual rules.

### 2.4 M704: Whirlpool / Track Loop
- **Level Intro:** Level 7371 (Block 738, x1 slot).
- **Behavior & Rules:**
  - Closed circular track of 4 to 8 tiles arranged in a loop (e.g., $2 \times 2$ or $3 \times 3$ perimeter).
  - Any snake entering whirlpool is captured and revolves continuously (1 tile/move clockwise or counter-clockwise).
  - Tapping snake when its head aligns with a tangent exit dislodges it, launching it outward onto connecting delta waterway.

---

## 3. Integration & Interaction Matrix

| Interaction Pair | Interaction Behavior |
| :--- | :--- |
| **M701 (Fork) + M702 (Tide)** | Fork output can point upstream against a rising tide, halting progress until tide flips. |
| **M703 (Sluice) + M704 (Whirlpool)** | Closing sluice lever drains whirlpool, allowing snakes to slither across loop bed freely. |
| **Conveyor + Obstacle (Rock/Lilypad)** | Snake carried by conveyor into obstacle halts without life loss; resumes when obstruction clears. |
| **Conveyor + Ice Slide (Phase 4)** | Snakes exiting ice onto conveyor maintain momentum + conveyor displacement (+1 extra tile). |

---

## 4. References & Cross-Links
- [Phase 15 Signature System](phase-15-signature-system.md)
- [Phase 15 Variants and Modifiers](phase-15-variants-and-modifiers.md)
- [Phase 15 Level Plan](phase-15-level-plan-07001-07500.md)


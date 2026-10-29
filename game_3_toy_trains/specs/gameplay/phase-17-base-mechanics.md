Source docs: phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md, phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §16.17. Depends on: specs/gameplay/phase-17-signature-system.md.

# Spec: Gameplay — Phase 17 Base Mechanics (M801–M804)

## Status
Draft

## Type
New Feature

## Goal
Specify the formal rules, parameters, data models, edge cases, and solver representations for the 4 base mechanics of Phase 17 (Clock Towers): M801 Twin Clock Towers, M802 Armoured Clock Tower, M803 Depot Tower, and M804 Clock Core.

## Current State
Design documented in `phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md` and `../../SHARED_CORE_STANDARD.md` §16.17, not yet implemented.

## Proposed Change
Implement the 4 base mechanic types in `packages/puzzle_core`:

### 1. M801 · Twin Clock Towers (Twin Guardian)
- **Intro Level:** L8011 (Block 2, x1).
- **Category:** B / C (Shared HP Boss Blocker).
- **Rule:** A pair of 2x2 wooden clock towers sharing a single unified HP pool (e.g. 6 HP). Clearing adjacent trains inflicts 1 point of damage to the shared pool. When HP reaches 0, both towers collapse simultaneously.
- **Hammerable:** No (Immune to Track Crane).
- **Data Model:**
  ```json
  {"id": "o1_twin", "type": "M801", "cells": [[3, 3], [3, 4], [4, 3], [4, 4], [8, 8], [8, 9], [9, 8], [9, 9]], "params": {"sharedHp": 6}, "hammerable": false}
  ```

### 2. M802 · Armoured Clock Tower (Shield Guardian)
- **Intro Level:** L8131 (Block 14, x1).
- **Category:** B / L (Order-Dependent Shield Boss).
- **Rule:** A reinforced 2x2 clock tower shielded by a chromatic barrier. Damage is only accepted when adjacent trains depart in the exact color sequence shown on the tower's dial banner (e.g. Red -> Blue -> Yellow). Dispatches out of order inflict 0 damage.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o2", "type": "M802", "cells": [[5, 5], [5, 6], [6, 5], [6, 6]], "params": {"hp": 4, "damageSequence": ["red", "blue", "yellow"]}, "hammerable": false}
  ```

### 3. M803 · Depot Tower (Spawner Guardian)
- **Intro Level:** L8251 (Block 26, x1).
- **Category:** B / S (Blocker Spawner Boss).
- **Rule:** A 2x2 railway maintenance depot tower with an HP pool. Every $N$ moves (Step 3 tick), it deploys a new Buffer Stop (M001 blocker) onto an empty orthogonal track tile. When its HP reaches 0, spawning ceases and the depot collapses.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o3", "type": "M803", "cells": [[6, 8]], "params": {"hp": 3, "spawnPeriod": 3}, "hammerable": false}
  ```

### 4. M804 · Clock Core (Guardian Core)
- **Intro Level:** L8371 (Block 38, x1).
- **Category:** B / K (Multi-Condition Core).
- **Rule:** The mechanical clockwork heart tile of the citadel. Upon reaching 0 HP, it remains impassable until hit directly by an optical Signal Light Beam (M251). Direct beam contact dissolves the core completely.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o4", "type": "M804", "cells": [[5, 5]], "params": {"hp": 0, "needsBeam": true}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m801_twin_clock_towers.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m802_armoured_clock_tower.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m803_depot_tower.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m804_clock_core.dart` (to be created)

## Risks
- Board deadlock if spawner blocks all adjacent lines before trains can move. Mitigation: Generator enforces maximum 1 spawn every 3 moves, and leaves at least 2 alternate exit paths open.

## Open Questions
- None. Rules match `phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md`.

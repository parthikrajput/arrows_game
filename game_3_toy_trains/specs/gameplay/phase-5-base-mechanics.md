Source docs: phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md, phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-5-signature-system.md, specs/gameplay/phase-4-base-mechanics.md.

# Spec: Gameplay — Phase 5 Base Mechanics (M201–M204)

## Status
Draft

## Type
New Feature

## Goal
Specify the four new base railway mechanics (M201–M204) introduced in Phase 5 (Levels 2001–2500) of Toy Trains: Wooden Railway Puzzle, establishing their rules, collision mechanics, weight thresholds, hammerability, solver implications, and JSON schemas.

## Current State
Design documented in `phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases handled basic 1-cell push blocks (M053).
- Phase 5 establishes specialized shunting wagons and track hazards.

## Proposed Change
Implement the 4 base shunting mechanics in `packages/puzzle_core/lib/src/mechanics/phase_5/`:

### 1. M201 · Cart Pit (Crate Holes)
- **Intro Level:** L2011 (Block 2, x1).
- **Category:** B (Blocker / Terrain Mod).
- **Exact Rule:** Deep track excavation pit. Acts as a solid blocker causing buffer clack bumps (-1 heart) if a train attempts to traverse it. When any cart is pushed into this pit, the cart falls into the depression, permanently leveling the cell into standard passable wooden track.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M201", "cells": [[5, 4]], "params": {}, "hammerable": false}
  ```

### 2. M202 · Ice Block Cart (Sliding Ice Crates)
- **Intro Level:** L2131 (Block 14, x1).
- **Category:** C (Continuous Inertia Blocker).
- **Exact Rule:** Wooden cart encrusted with frozen ice. When pushed by an exiting train, it does not stop after 1 cell; it continues sliding indefinitely along the departure vector until it impacts another train, solid obstacle, or falls into an M201 Cart Pit. Falling off board edges removes the cart.
- **Hammerable:** Yes (Track Crane can remove it as a standard hammer action).
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M202", "cells": [[4, 7]], "params": {}, "hammerable": true}
  ```

### 3. M203 · Ticket Cart (Crate Keys)
- **Intro Level:** L2251 (Block 26, x1).
- **Category:** K (Object-Carried Key).
- **Exact Rule:** Enamel freight wagon bearing a stamped Ticket symbol. Pushing this cart onto a matching color receptor pad (`targetPad`) permanently unlocks and opens the linked railway signal barrier gate.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M203", "cells": [[6, 3]], "params": {"targetPad": [6, 8], "color": "red"}, "hammerable": false}
  ```

### 4. M204 · Ballast Cart (Heavy Crate)
- **Intro Level:** L2371 (Block 38, x1).
- **Category:** B (Heavy Resistance Blocker).
- **Exact Rule:** Overweight freight wagon loaded with crushed granite ballast. Standard single locomotives cannot displace this wagon (hitting it causes a buffer clack bump, -1 heart). It can be displaced strictly by **Wide Load Freight (M024)** or **Coupled Engines (M011, M066)** possessing double pushing power.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M204", "cells": [[7, 2]], "params": {"requiredPushPower": 2}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_5/m201_cart_pit.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_5/m202_ice_cart.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_5/m203_ticket_cart.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_5/m204_ballast_cart.dart` (to be created)

## Risks
- Ice Block Cart sliding infinitely in an enclosed loop. Mitigated by grid boundary checks and solver infinite loop cycle detection.

## Open Questions
- None. All mechanics match `phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md` and `SHARED_CORE_STANDARD.md` §11.


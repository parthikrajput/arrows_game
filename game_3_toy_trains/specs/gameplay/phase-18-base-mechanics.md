Source docs: phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md, phase/phase_18/01_PHASE_18_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §16.17. Depends on: specs/gameplay/phase-18-signature-system.md.

# Spec: Gameplay — Phase 18 Base Mechanics (M851–M854)

## Status
Draft

## Type
New Feature

## Goal
Specify the formal rules, parameters, data models, edge cases, and solver representations for the 4 base combo mechanics of Phase 18 (Remix A): M851 Day/Night Ticket Cart, M852 Station Floor Shunting Lift, M853 Prism Signal Sensor, and M854 Ice Cart Blackout Chute.

## Current State
Design documented in `phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md` and `../../SHARED_CORE_STANDARD.md` §16.17, not yet implemented.

## Proposed Change
Implement the 4 base mechanic types in `packages/puzzle_core`:

### 1. M851 · Day/Night Ticket Cart (Cycle Key)
- **Intro Level:** L8511 (Block 2, x1).
- **Category:** K / C (Shuntable Cyclic Key Cart).
- **Rule:** A pushable ticket cart (P5) that can be pushed through a Day/Night tunnel (P3). Traversing the tunnel stamps the cart with the active solar/lunar state, enabling it to open day- or night-specific barrier gates.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o1", "type": "M851", "cells": [[4, 6]], "params": {"stampedCycle": "day", "linkedGateId": "gate_solar"}, "hammerable": false}
  ```

### 2. M852 · Station Floor Shunting Lift (Multi-Floor Cart Elevator)
- **Intro Level:** L8631 (Block 14, x1).
- **Category:** E / P (Vertical Shunting Elevator).
- **Rule:** A heavy goods elevator (P4) connecting Floor 1 and Floor 2. Can transport mobile cargo carts (ice or ballast carts, P5) vertically when a cart is pushed into the cabin.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o2", "type": "M852", "cells": [[7, 3]], "params": {"sourceFloor": 1, "targetFloor": 2, "holdingCart": null}, "hammerable": false}
  ```

### 3. M853 · Prism Signal Sensor (Color Lens Sensor Gate)
- **Intro Level:** L8751 (Block 26, x1).
- **Category:** L / T (Refracted Optical Sensor).
- **Rule:** An optical sensor gate (P6) paired with a chromatic glass prism (P6). When a signal lamp beam is steered through the prism onto the sensor, a heavy wooden drawbridge (P2) drops permanently.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o3", "type": "M853", "cells": [[8, 9]], "params": {"requiredColor": "emerald", "targetBridgeId": "drawbridge_f1"}, "hammerable": false}
  ```

### 4. M854 · Ice Cart Blackout Chute (Drop Hole Shunting)
- **Intro Level:** L8871 (Block 38, x1).
- **Category:** B / D (Frictionless Void Fill).
- **Rule:** An ice block cart (P5) sliding across frictionless tracks. Pushing it into a goods chute (P4) drops it down to the lower floor directly into a dark blackout patch pit (P6), locking in place to complete a missing rail section.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o4", "type": "M854", "cells": [[3, 3]], "params": {"lowerPitCell": [3, 3, 1], "isFilled": false}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m851_day_night_ticket_cart.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m852_shunting_lift.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m853_prism_sensor.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m854_ice_blackout_chute.dart` (to be created)

## Risks
- Cart falling through chute onto an occupied track below. Mitigation: Chute arrival cell strictly restricted to dedicated non-occupied pit tiles.

## Open Questions
- None. Rules match `phase/phase_18/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md`.

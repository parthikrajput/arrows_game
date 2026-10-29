Source docs: phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md, phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §10. Depends on: specs/gameplay/obstacle-catalog-phase-1.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-7-signature-system.md.

# Spec: Gameplay — Phase 7 Base Mechanics (M301–M304)

## Status
Draft

## Type
New Feature

## Goal
Specify the rules, attributes, JSON schemas, solver constraints, and edge case behaviors for the 4 Phase 7 craft base mechanics: M301 Hoop Rotor, M302 Turning Hem, M303 Twirl Thread, and M304 Ratchet Pin.

## Current State
Design documented in `phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md`, not yet implemented.

## Proposed Change
Implement M301 through M304 in `packages/puzzle_core`:

### 1. Catalog Cards

#### M301 — Hoop Rotor (Sub-board Rotor)
- **ID:** `M301`
- **Themed Name:** Hoop Rotor
- **Generic Equivalent:** Sub-board Rotor
- **Intro Level:** L3011
- **Category:** Turntable / Control (T)
- **Hammerable:** No.
- **Rule:** A circular wooden embroidery hoop enclosing a $4 \times 4$ sub-grid on the craft board. Tapping the central rotor pivot rotates all fully enclosed grid cells and threads 90° clockwise (cost: 1 move). If any thread straddles the boundary (partly inside, partly outside), the rotor is locked and cannot be tapped.
- **Edge Cases:** Tapping a locked rotor plays denial haptics and costs 0 moves. Boosters cannot be used to force a rotation.
- **JSON Schema:**
  ```json
  {
    "id": "m301_1",
    "type": "M301",
    "cells": [[4, 4], [4, 7], [7, 4], [7, 7]],
    "params": {
      "size": 4
    },
    "hammerable": false
  }
  ```

#### M302 — Turning Hem (Rotating Edges)
- **ID:** `M302`
- **Themed Name:** Turning Hem
- **Generic Equivalent:** Rotating Edges
- **Intro Level:** L3131
- **Category:** Blocker / Controller (B/C)
- **Hammerable:** No.
- **Rule:** A folded fabric hem running along the board perimeter with open exit gaps. At the conclusion of every valid player move (Step 3), the open exit gaps advance 1 perimeter cell clockwise around the board. Threads attempting to exit through a closed hem section collide and snag (-1 Heart); they must exit through an aligned gap.
- **Edge Cases:** If a thread unravels during a move, it checks the gap position at the time of unraveling before the hem advances.
- **JSON Schema:**
  ```json
  {
    "id": "m302_1",
    "type": "M302",
    "cells": [[0, 5], [0, 6]],
    "params": {
      "gapSize": 2,
      "step": 1
    },
    "hammerable": false
  }
  ```

#### M303 — Twirl Thread (Spin Path)
- **ID:** `M303`
- **Themed Name:** Twirl Thread
- **Generic Equivalent:** Spin Path
- **Intro Level:** L3251
- **Category:** Path (P)
- **Hammerable:** Yes (Golden Scissors snips thread).
- **Rule:** A dynamic woolen thread whose needle head continuously rotates 90° clockwise ($U \to R \to D \to L$) after every valid player move. The player must time their tap when the needle points toward a clear exit trajectory; tapping while pointed at an obstacle or border results in a snag (-1 Heart).
- **Edge Cases:** If an adjacent thread's unraveling frees a corridor, the twirl thread must still face that corridor to exit safely.
- **JSON Schema:**
  ```json
  {
    "id": "m303_1",
    "type": "M303",
    "cells": [[5, 5], [5, 6], [5, 7]],
    "params": {
      "spinInterval": 1
    },
    "hammerable": true
  }
  ```

#### M304 — Ratchet Pin (Rotation Lock)
- **ID:** `M304`
- **Themed Name:** Ratchet Pin
- **Generic Equivalent:** Rotation Lock
- **Intro Level:** L3371
- **Category:** Key (K)
- **Hammerable:** No.
- **Rule:** A vintage brass safety pin pinning a Hoop Rotor (M301) in place. The linked rotor cannot be rotated while the Ratchet Pin is fastened. The pin is bound to a specific key-thread (`keyThreadId`); as soon as that thread completely unravels from the board, the pin springs open, permanently unlocking the rotor for rotation.
- **Edge Cases:** Pinned rotors display a distinct lock icon and spring tension badge.
- **JSON Schema:**
  ```json
  {
    "id": "m304_1",
    "type": "M304",
    "cells": [[4, 4]],
    "params": {
      "targetRotorId": "m301_1",
      "keyThreadId": "p12"
    },
    "hammerable": false
  }
  ```

### 2. Solver Integration
- Reverse generation in `tools/levelgen`:
  - M301: Synthesizes cleared board and executes reverse 90° counter-clockwise rotor turns to lay paths.
  - M302: Calculates modulo perimeter offsets to guarantee exit gaps align with threads during solver unwinding.
  - M303: Enforces turn parity so needle orientation reaches exit direction on valid moves.
  - M304: Establishes prerequisite dependency: Key Thread $\rightarrow$ Unlock Ratchet $\rightarrow$ Rotor Rotation $\rightarrow$ Dependent Threads Unravel.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m301_hoop_rotor.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m302_turning_hem.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m303_twirl_thread.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m304_ratchet_pin.dart` (to be created)
- `tools/levelgen/lib/src/generators/mechanics_factory.dart` (changed: register M301–M304)

## Risks
- Rapid rotational shifts disorienting players. Mitigated by gentle 250 ms eased animation curves and clear directional arrows on needle heads.

## Open Questions
None. Catalog cards, parameters, and intro levels match Phase 7 documentation.

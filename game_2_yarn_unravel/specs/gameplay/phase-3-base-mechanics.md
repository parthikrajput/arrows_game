Source docs: phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md, ../../SHARED_CORE_STANDARD.md §10, §11. Depends on: specs/gameplay/phase-3-signature-system.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 3 Base Mechanics (M101–M104)

## Status
Draft

## Type
New Feature

## Goal
Specify the 4 new base mechanics introduced in Yarn Unravel Phase 3 (M101 Loom Latch, M102 Day Bridge, M103 Night Pompom, and M104 Twilight Eyelet), their gameplay rules, state changes, bump/snag behaviors, solver hooks, and JSON schema v3 representations.

## Current State
Design documented in `phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md` and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 2 concluded with mechanic M099 (Master Jewel Clasp).
- Phase 3 introduces 4 base mechanics that directly interact with the Day & Night Loom cycle states (A/B).

## Proposed Change
Implement mechanic controllers in `packages/puzzle_core/lib/src/mechanics/phase_3/`:

### 1. M101 — Loom Latch (Cycle Gate)
- **ID:** `M101` | **Themed Name:** Loom Latch | **Generic:** Cycle Gate | **Category:** Blocker (B) | **Hammerable:** No | **Intro Level:** L1011.
- **Rule:** A wooden hinged latch on a grid cell. Open during its designated active cycle state (`activeState: "A"` or `"B"`), allowing thread pull lanes to freely pass through. Closed during the opposite state, acting as a solid Single Blocker.
- **Bump/Snag:** Attempting to pull a thread through a closed latch causes a snag bump (-1 Heart, damped twang, thread springs back).
- **Solver Hook:** Deterministic state `isOpen = (currentCycleState == activeState)`.
- **JSON Schema v3:**
  ```json
  {
    "id": "m101_1",
    "type": "M101",
    "cells": [[4, 6]],
    "params": { "activeState": "A" },
    "hammerable": false
  }
  ```

### 2. M102 — Day Bridge (Cycle Bridge)
- **ID:** `M102` | **Themed Name:** Day Bridge | **Generic:** Cycle Bridge | **Category:** Layer (L) | **Hammerable:** No | **Intro Level:** L1131.
- **Rule:** An elevated fabric crossing cell. In State A (Day), it functions as an active Stitch Bridge (M015), allowing orthogonal thread crossings on different layers without collision. In State B (Night), the bridge collapses flat, acting as an impassable blocker for all layers.
- **Bump/Snag:** In State B, any thread lane crossing the cell snags (-1 Heart).
- **JSON Schema v3:**
  ```json
  {
    "id": "m102_1",
    "type": "M102",
    "cells": [[6, 6]],
    "params": { "bridgeState": "A" },
    "hammerable": false
  }
  ```

### 3. M103 — Night Pompom (Cycle Portal)
- **ID:** `M103` | **Themed Name:** Night Pompom | **Generic:** Cycle Portal | **Category:** Deflector (D) | **Hammerable:** No | **Intro Level:** L1251.
- **Rule:** A linked pair of wool pompom portals. In State B (Night), the portals are illuminated: a thread entering Pompom 1 teleports and exits from Pompom 2 along the same direction vector. In State A (Day), portals are dormant and act as solid single blockers.
- **Bump/Snag:** Hitting a dormant pompom in State A triggers a snag (-1 Heart).
- **JSON Schema v3:**
  ```json
  {
    "id": "m103_1",
    "type": "M103",
    "cells": [[2, 3], [8, 9]],
    "params": { "portalState": "B" },
    "hammerable": false
  }
  ```

### 4. M104 — Twilight Eyelet (Cycle Color)
- **ID:** `M104` | **Themed Name:** Twilight Eyelet | **Generic:** Cycle Color | **Category:** Blocker (B) | **Hammerable:** No | **Intro Level:** L1371.
- **Rule:** A color-filtering eyelet ring. In State A (Day), it permits only threads of color `colorA` to pass through. In State B (Night), it shifts to permit only threads of color `colorB`. Threads of non-matching color are blocked.
- **Bump/Snag:** Non-matching threads snag upon contacting the eyelet (-1 Heart).
- **JSON Schema v3:**
  ```json
  {
    "id": "m104_1",
    "type": "M104",
    "cells": [[5, 8]],
    "params": { "colorA": "red", "colorB": "blue" },
    "hammerable": false
  }
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_3/m101_loom_latch.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_3/m102_day_bridge.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_3/m103_night_pompom.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_3/m104_twilight_eyelet.dart` (to be created)
- `packages/puzzle_core/test/mechanics/m101_test.dart` through `m104_test.dart` (to be created)

## Risks
- Cyclic portal loops between M103 Night Pompoms and earlier Phase 1/2 portals. Mitigated by `lane_evaluator` visited cell set terminating on repeat.

## Open Questions
None. Mechanics rules and IDs match `SHARED_CORE_STANDARD.md` §11.

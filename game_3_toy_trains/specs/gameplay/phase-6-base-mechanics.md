Source docs: phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md, phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-6-signature-system.md, specs/gameplay/phase-5-base-mechanics.md.

# Spec: Gameplay — Phase 6 Base Mechanics (M251–M254)

## Status
Draft

## Type
New Feature

## Goal
Specify the four new base optical mechanics (M251–M254) introduced in Phase 6 (Levels 2501–3000) of Toy Trains: Wooden Railway Puzzle, establishing their rules, optical interactions, collision properties, hammerability, solver implications, and JSON schemas.

## Current State
Design documented in `phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases featured monochromatic beams and single-sensor gates (M084, M085).
- Phase 6 introduces chromatic spectrum filtering, dual-beam Boolean AND gates, cyclical beam emitters, and dark track cells.

## Proposed Change
Implement the 4 base optical mechanics in `packages/puzzle_core/lib/src/mechanics/phase_6/`:

### 1. M251 · Coloured Lens (Color Filter)
- **Intro Level:** L2511 (Block 2, x1).
- **Category:** D (Directional / Optical Filter).
- **Exact Rule:** Tinted optical glass lens positioned along track corridors. When a light beam passes through this cell, the beam's color property transforms to match `params.filterColor` (Red, Green, Blue, or Amber). Chromatic sensor boxes only activate when struck by a beam of matching color wavelength. Exiting trains can pass through without obstruction.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M251", "cells": [[4, 5]], "params": {"filterColor": "green"}, "hammerable": false}
  ```

### 2. M252 · Twin Sensor Gate (Beam Splitter Lock)
- **Intro Level:** L2631 (Block 14, x1).
- **Category:** K (Multi-Sensor Lock).
- **Exact Rule:** Railway barrier gate governed by two distinct photocell receptors (`sensors`). The gate unlocks and retracts if and only if **both** sensor receptors are simultaneously illuminated by active light beams on the current turn. If either receptor is unlit, the gate remains closed (attempting to pass causes a buffer clack bump, -1 heart).
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M252", "cells": [[6, 8]], "params": {"sensors": [[5, 2], [7, 2]]}, "hammerable": false}
  ```

### 3. M253 · Lamp Timer (Beam Timer)
- **Intro Level:** L2751 (Block 26, x1).
- **Category:** C (Move Countdown Emitter).
- **Exact Rule:** Signal lamp equipped with clockwork shutter timer. Toggles between active (emitting beam) and dormant (beam extinguished) states every `params.period` valid player Moves (ticks during Step 3 of the turn lifecycle).
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M253", "cells": [[3, 3]], "params": {"period": 3, "initialState": true}, "hammerable": false}
  ```

### 4. M254 · Blackout Patch (Dark Cells)
- **Intro Level:** L2871 (Block 38, x1).
- **Category:** C (Illumination Cell / Hidden).
- **Exact Rule:** Shrouded unlit track cells. Trains stationed on Blackout cells are locked in darkness (tapping them triggers a locked tap: soft wobble, 0 moves, 0 hearts lost) and cannot depart. When an optical light beam passes through the blackout cells, the area becomes illuminated, activating the trains for normal departure.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M254", "cells": [[8, 4], [8, 5]], "params": {}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_6/m251_coloured_lens.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_6/m252_twin_sensor.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_6/m253_lamp_timer.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_6/m254_blackout_patch.dart` (to be created)

## Risks
- Cyclic dependencies where illuminating a blackout cell requires an engine that is itself locked in darkness. Mitigated by validator check: every dark cell must have an unblocked light path achievable from initial board state.

## Open Questions
- None. All mechanics match `phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md` and `SHARED_CORE_STANDARD.md` §11.

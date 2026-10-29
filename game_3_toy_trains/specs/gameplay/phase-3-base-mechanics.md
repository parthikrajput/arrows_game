Source docs: phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md, phase/phase_3/01_PHASE_3_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-3-signature-system.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 3 Base Mechanics (M101–M104)

## Status
Draft

## Type
New Feature

## Goal
Specify the four new base railway mechanics (M101–M104) introduced in Phase 3 (Levels 1001–1500) of Toy Trains: Wooden Railway Puzzle, establishing their exact rules, collision and tap behaviors, hammerability, solver implications, and JSON schemas.

## Current State
Design documented in `phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases had static gates and move-based alternating barriers (M057).
- Phase 3 couples mechanics directly to the global Day & Night Timetable cycle (`S03`).

## Proposed Change
Implement the 4 base cyclic mechanics in `packages/puzzle_core/lib/src/mechanics/phase_3/`:

### 1. M101 · Day/Night Gate (Cycle Gate)
- **Intro Level:** L1011 (Block 2, x1).
- **Category:** B (Blocker / Gate).
- **Exact Rule:** Railway gate cell that is open in State A (Day Service) and closed in State B (Night Service), or vice-versa based on `params.openIn: "A" | "B"`. A train attempting to pass through a closed gate collides with buffers clacking and loses 1 heart.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M101", "cells": [[6, 4]], "params": {"openIn": "A"}, "hammerable": false}
  ```

### 2. M102 · Day/Night Overpass (Cycle Bridge)
- **Intro Level:** L1131 (Block 14, x1).
- **Category:** L (Layer / Bridge).
- **Exact Rule:** In State A (Day Service), functions as a Wooden Overpass (M015) allowing crossing tracks on Ground and Mid layer without collision. In State B (Night Service), the bridge mechanism drops, acting as a solid blocking obstacle that obstructs both intersecting track lanes.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M102", "cells": [[7, 5]], "params": {"openIn": "A"}, "hammerable": false}
  ```

### 3. M103 · Day/Night Tunnel (Cycle Portal)
- **Intro Level:** L1251 (Block 26, x1).
- **Category:** D (Directional / Portal).
- **Exact Rule:** Dual tunnel portals. In State A (Day Service), the tunnel pair is open: a train entering one portal emerges immediately from the paired portal in its heading direction. In State B (Night Service), the tunnel portal iron shutters drop shut; both tunnel mouths become solid blockers (-1 heart bump upon impact).
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M103", "cells": [[2, 8], [9, 8]], "params": {"openIn": "A"}, "hammerable": false}
  ```

### 4. M104 · Day/Night Livery (Cycle Color)
- **Intro Level:** L1371 (Block 38, x1).
- **Category:** P (Train Variant).
- **Exact Rule:** Train with dual enamel liveries (e.g. Day: Red / Night: Blue). Whenever the board toggles between State A and State B, the train's active color swaps automatically. Interacts dynamically with color-coded mechanics (M005 Platform Gate, M030 Station Exit, M033 Locked Siding, M094 Paint Mixer Shed).
- **Hammerable:** Yes (Track Crane can remove the train as a normal departure).
- **JSON Definition:**
  ```json
  {
    "paths": [
      {"id": "p5", "color": "red", "dir": "R", "body": [[2,3],[1,3]], "mods": {"cycleColor": {"stateA": "red", "stateB": "blue"}}}
    ],
    "mechanics": [
      {"id": "o4", "type": "M104", "cells": [], "params": {"path": "p5"}, "hammerable": false}
    ]
  }
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_3/m101_cycle_gate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_3/m102_cycle_bridge.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_3/m103_cycle_portal.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_3/m104_cycle_color.dart` (to be created)

## Risks
- Trains stranded inside M103 Day/Night Tunnel if the cycle flips mid-move. Mitigated by atomic move resolution: train exit completes within the active move before the cycle transition ticks.

## Open Questions
- None. All mechanics rules and parameters match `phase/phase_3/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md` and `SHARED_CORE_STANDARD.md` §11.


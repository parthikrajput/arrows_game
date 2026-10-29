Source docs: phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md, phase/phase_10/01_PHASE_10_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-10-signature-system.md, specs/gameplay/phase-9-base-mechanics.md.

# Spec: Gameplay — Phase 10 Base Mechanics (M451–M454)

## Status
Draft

## Type
New Feature

## Goal
Specify the four new base sequencing mechanics (M451–M454) introduced in Phase 10 (Levels 4501–5000) of Toy Trains: Wooden Railway Puzzle, establishing their rules, chronological verifications, collision properties, hammerability, solver implications, and JSON schemas.

## Current State
Design documented in `phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases featured spatial clearances and coupling configurations.
- Phase 10 establishes rhythmic and chronological dispatch gates.

## Proposed Change
Implement the 4 base sequencing mechanics in `packages/puzzle_core/lib/src/mechanics/phase_10/`:

### 1. M451 · Metronome Gate (Rhythm Gate)
- **Intro Level:** L4511 (Block 2, x1).
- **Category:** G (Rhythm-based Barrier).
- **Exact Rule:** Railway barrier that operates on a cyclic rhythm pattern (e.g. `["open", "open", "closed"]`). Advances 1 step across the pattern array on every valid player Move anywhere on the board (Step 3 tick). When the active pattern state is `"open"`, trains pass freely; when `"closed"`, it acts as a solid blocker causing buffer clack bumps (-1 heart).
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M451", "cells": [[5, 6]], "params": {"pattern": ["open", "open", "closed"], "initialIndex": 0}, "hammerable": false}
  ```

### 2. M452 · Departure Code Lock (Pattern Lock)
- **Intro Level:** L4631 (Block 14, x1).
- **Category:** K / L (Exit Pattern Barrier).
- **Exact Rule:** Station departure barrier displaying an ordered list of livery colors (e.g. `["red", "blue", "green"]`). As trains exit the board, their colors are compared against the expected code. If the departing train matches the current expected color, progress increments; if it mismatches, progress resets to 0. When the full sequence is fulfilled, the barrier opens permanently.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o2", "type": "M462", "cells": [[8, 4]], "params": {"expectedColors": ["red", "blue", "green"]}, "hammerable": false}
  ```

### 3. M453 · Platform Order Exit (Order Edge)
- **Intro Level:** L4751 (Block 26, x1).
- **Category:** E / G (Numbered Edge Exit).
- **Exact Rule:** Perimeter departure edge marked with sequential platform numbers (1, 2, 3...). Trains must exit through this edge in strictly ascending numeric order based on their stamped locomotive numbers. Out-of-order departure attempts collide with locked barriers (-1 heart bump).
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M453", "cells": [[0, 5], [0, 6]], "params": {"currentRequiredOrder": 1, "maxOrder": 3}, "hammerable": false}
  ```

### 4. M454 · Echo Signal (Echo Sequence)
- **Intro Level:** L4871 (Block 38, x1).
- **Category:** S / G (Echo Memory Signal).
- **Exact Rule:** Railway memory signal recording the color history of the preceding $N$ cleared trains. The next $N$ departures must replicate the exact same color sequence. If the sequence is mirrored accurately, the signal displays green; if violated, the signal turns red, blocking track lines.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M454", "cells": [[6, 3]], "params": {"echoLength": 2}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_10/m451_metronome_gate.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_10/m452_departure_code.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_10/m453_platform_order.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_10/m454_echo_signal.dart` (to be created)

## Risks
- Deadlocks if the required sequence color trains are physically occluded by trains of different colors. Mitigated by reverse construction guaranteeing that required departure candidates are physically reachable.

## Open Questions
- None. All mechanics match `phase/phase_10/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md` and `SHARED_CORE_STANDARD.md` §11.

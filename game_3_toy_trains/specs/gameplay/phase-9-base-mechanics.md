Source docs: phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md, phase/phase_9/01_PHASE_9_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §17.38. Depends on: specs/gameplay/phase-9-signature-system.md, specs/gameplay/phase-8-base-mechanics.md.

# Spec: Gameplay — Phase 9 Base Mechanics (M401–M404)

## Status
Draft

## Type
New Feature

## Goal
Specify the four new base train composition mechanics (M401–M404) introduced in Phase 9 (Levels 4001–4500) of Toy Trains: Wooden Railway Puzzle, establishing their rules, collision dynamics, interactive states, hammerability, solver implications, and JSON schemas.

## Current State
Design documented in `phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md` and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases featured static train coupling chains (M011, M066).
- Phase 9 introduces interactive, runtime coupling, uncoupling, and splitting mechanics.

## Proposed Change
Implement the 4 base composition mechanics in `packages/puzzle_core/lib/src/mechanics/phase_9/`:

### 1. M401 · Coupling Pad (Merger Pad)
- **Intro Level:** L4011 (Block 2, x1).
- **Category:** T (Interactive Track Tile).
- **Exact Rule:** Dual coupling track pad. When the engine heads of two designated trains (`targetTrains`) rest upon both coupling pads simultaneously, tapping the central pad lever (1 Move) merges the two trains into a single extended locomotive. If both heads are not present on the pads, tapping triggers a locked tap (soft wobble, 0 moves, 0 hearts).
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o1", "type": "M401", "cells": [[4, 5], [4, 6]], "params": {"targetTrains": ["p1", "p2"]}, "hammerable": false}
  ```

### 2. M402 · Twin Split Train (Twin Splitter)
- **Intro Level:** L4131 (Block 14, x1).
- **Category:** P (Locomotive Splitting Path).
- **Exact Rule:** Double-width or tandem-linked locomotive. When tapped (1 Move), splits along its central axis into two independent parallel trains facing the original heading direction. Requires adjacent destination cells to be completely vacant; if obstructed, splitting is blocked and a buffer clack bump triggers (-1 heart).
- **Hammerable:** Yes (Track Crane can remove the entire un-split train).
- **JSON Definition:**
  ```json
  {"id": "p1", "type": "path", "cells": [[2, 2], [2, 3], [3, 2], [3, 3]], "dir": "R", "params": {"splitAxis": "parallel"}, "mods": {}}
  ```

### 3. M403 · Coupling Lock (Segment Lock)
- **Intro Level:** L4251 (Block 26, x1).
- **Category:** K / L (Train Segment Barrier).
- **Exact Rule:** Heavy mechanical coupling clamp. While the designated key train (`keyTrain`) remains on the board, this segment clamp remains locked, preventing coupled trains from separating or traversing the clamped junction. Once the key train departs, the clamp unlocks permanently.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o3", "type": "M403", "cells": [[7, 8]], "params": {"keyTrain": "p3"}, "hammerable": false}
  ```

### 4. M404 · Rejoin Arch (Rejoin Gate)
- **Intro Level:** L4371 (Block 38, x1).
- **Category:** G (Conditional Gate).
- **Exact Rule:** Archway gate designed specifically for split train pairs (M402). The archway begins closed. When both split halves of the train pass through the archway, the gate unlocks and opens permanently for any remaining railway traffic.
- **Hammerable:** No (`hammerable: false`).
- **JSON Definition:**
  ```json
  {"id": "o4", "type": "M404", "cells": [[5, 9]], "params": {"requiredPairs": ["p1_a", "p1_b"]}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_9/m401_coupling_pad.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_9/m402_twin_split_train.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_9/m403_coupling_lock.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/phase_9/m404_rejoin_arch.dart` (to be created)

## Risks
- Body segment disconnection desync if a split train attempts to move while one half is obstructed. Mitigated by atomic splitting validation.

## Open Questions
- None. All mechanics match `phase/phase_9/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md` and `SHARED_CORE_STANDARD.md` §11.

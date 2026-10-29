Source docs: phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md, phase/phase_20/01_PHASE_20_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §16.17. Depends on: specs/gameplay/phase-20-signature-system.md.

# Spec: Gameplay — Phase 20 Base Mechanics (M951–M954)

## Status
Draft

## Type
New Feature

## Goal
Specify the formal rules, parameters, data models, edge cases, and solver representations for the 4 supreme combo mechanics of Phase 20 (Grand Master): M951 Clockwork Conveyor Guardian, M952 Gravity Mirror Relay, M953 Day/Night Ticket Master Pass, and M954 Prism Bloom Arch.

## Current State
Design documented in `phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md` and `../../SHARED_CORE_STANDARD.md` §16.17, not yet implemented.

## Proposed Change
Implement the 4 base mechanic types in `packages/puzzle_core`:

### 1. M951 · Clockwork Conveyor Guardian
- **Intro Level:** L9511 (Block 2, x1).
- **Category:** B / T (Conveyor + Clock Tower Fusion).
- **Rule:** A 2x2 Clock Tower Guardian (6 HP) encircled by an automated conveyor ring (P15). Trains on the ring circulate continuously; timing a train's exit to depart from an adjacent spur strikes the tower for 1 point of structural damage.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o1_conveyor_boss", "type": "M951", "cells": [[5, 5], [5, 6], [6, 5], [6, 6]], "params": {"hp": 6, "ringCells": [[4, 4], [4, 5], [4, 6], [4, 7], [7, 4], [7, 5], [7, 6], [7, 7]]}, "hammerable": false}
  ```

### 2. M952 · Gravity Mirror Relay
- **Intro Level:** L9631 (Block 14, x1).
- **Category:** T / E (Hill Line + Mirror Rails + Twin Tables Fusion).
- **Rule:** Dual-board gravity relay lever. Activating the tilt lever sets Table A's gravity downward ($D$), which inverts across the central mirror axis to set Table B's gravity upward ($U$). Loose crates on both tables slide in opposite directions.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o2_grav_mirror", "type": "M952", "cells": [[7, 7]], "params": {"tableADir": "D", "tableBDir": "U"}, "hammerable": false}
  ```

### 3. M953 · Day/Night Ticket Master Pass
- **Intro Level:** L9751 (Block 26, x1).
- **Category:** P / K (Day/Night + Ticket Office Fusion).
- **Rule:** A solar/lunar locomotive. In Day Phase A, it acts as a normal single-use pass opening standard barriers. In Night Phase B, it illuminates as an ultimate skeleton key that unlocks all colored barriers along its path without being consumed.
- **Hammerable:** Yes (Track Crane removes the train).
- **Data Model:**
  ```json
  {"id": "p_master_cycle", "type": "path", "cells": [[2, 2], [2, 3]], "dir": "R", "params": {"nightSkeleton": true}}
  ```

### 4. M954 · Prism Bloom Arch
- **Intro Level:** L9871 (Block 38, x1).
- **Category:** G / S (Ivy Growth + Signal Lights Fusion).
- **Rule:** A botanical stone arch embedded with an optical crystal prism. Unlocks permanently only when two concurrent conditions are satisfied: (1) at least $K = 4$ living wild ivy cells connect to its foundation, and (2) a colored signal light beam strikes the prism apex.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o4_prism_bloom", "type": "M954", "cells": [[11, 6]], "params": {"requiredIvy": 4, "requiredBeamColor": "cyan"}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m951_conveyor_guardian.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m952_gravity_mirror_relay.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m953_day_night_master_pass.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m954_prism_bloom_arch.dart` (to be created)

## Risks
- Double condition deadlock on M954 if players prune all ivy before beam connects. Mitigation: Level generator provides backup ivy seeds on nearby sidings.

## Open Questions
- None. Rules match `phase/phase_20/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md`.

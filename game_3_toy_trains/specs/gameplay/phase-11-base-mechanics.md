Source docs: phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md, phase/phase_11/01_PHASE_11_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §16.17. Depends on: specs/gameplay/phase-11-signature-system.md.

# Spec: Gameplay — Phase 11 Base Mechanics (M501–M504)

## Status
Draft

## Type
New Feature

## Goal
Specify the formal rules, parameters, data models, edge cases, and solver representations for the 4 base mechanics of Phase 11 (Twin Tables): M501 Table Bridge, M502 Inter-table Ticket, M503 Mirror Table, and M504 Relay Tunnel.

## Current State
Design documented in `phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md` and `../../SHARED_CORE_STANDARD.md` §16.17, not yet implemented.

## Proposed Change
Implement the 4 base mechanic types in `packages/puzzle_core`:

### 1. M501 · Table Bridge (Board Link Edge)
- **Intro Level:** L5011 (Block 2, x1).
- **Category:** E / P (Cross-Table Connector).
- **Rule:** A wooden connecting trestle bridge between Table A and Table B. When a train exits Table A along the bridge edge, it seamlessly enters Table B at the designated connected cell along the same trajectory. If the entry cell on Table B is occupied, the train bumps at the bridge entrance (-1 heart).
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o1", "type": "M501", "cells": [[7, 4]], "params": {"sourceBoard": "A", "targetBoard": "B", "targetCell": [0, 4]}, "hammerable": false}
  ```

### 2. M502 · Inter-table Ticket (Cross-board Key)
- **Intro Level:** L5131 (Block 14, x1).
- **Category:** K / T (Cross-board Trigger Key).
- **Rule:** A collectible ticket item located on Table A. When a Table A train traverses the ticket cell, it permanently unlocks the linked railway barrier gate situated on Table B.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o2", "type": "M502", "cells": [[3, 3]], "params": {"sourceBoard": "A", "targetBarrierId": "b_gate_1", "targetBoard": "B"}, "hammerable": false}
  ```

### 3. M503 · Mirror Table (Mirror Board)
- **Intro Level:** L5251 (Block 26, x1).
- **Category:** P / B (Synchronized Twin Train).
- **Rule:** A pair of synchronized twin locomotives—one on Table A, the other on Table B. Tapping either train commands both to advance concurrently in mirrored directions. If either train encounters an obstruction or misaligned switch, both halt and register a collision bump (-1 heart).
- **Hammerable:** Yes (Track Crane removes one twin engine; the remaining engine reverts to a standard independent train).
- **Data Model:**
  ```json
  {"id": "p_twin_a", "type": "path", "board": "A", "cells": [[2, 2], [2, 3]], "dir": "R", "params": {"partnerId": "p_twin_b", "partnerBoard": "B"}}
  ```

### 4. M504 · Relay Tunnel (Relay Portal)
- **Intro Level:** L5371 (Block 38, x1).
- **Category:** P / G (Inter-table Portal).
- **Rule:** An inter-table portal tunnel with entrance mouth on Table A and exit mouth on Table B. Entering the tunnel portal transports the train directly through to the other table in a single atomic move step.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o4", "type": "M504", "cells": [[5, 2]], "params": {"mouthA": {"board": "A", "cell": [5, 2]}, "mouthB": {"board": "B", "cell": [2, 5]}}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m501_table_bridge.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m502_inter_table_ticket.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m503_mirror_train.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m504_relay_tunnel.dart` (to be created)

## Risks
- Collision race conditions during simultaneous mirror moves. Mitigation: Atomic move evaluation pre-checks both paths before executing animations.

## Open Questions
- None. Rules match `phase/phase_11/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md`.

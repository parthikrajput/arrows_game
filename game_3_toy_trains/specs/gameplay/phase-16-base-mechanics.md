Source docs: phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md, phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §16.17. Depends on: specs/gameplay/phase-16-signature-system.md.

# Spec: Gameplay — Phase 16 Base Mechanics (M751–M754)

## Status
Draft

## Type
New Feature

## Goal
Specify the formal rules, parameters, data models, edge cases, and solver representations for the 4 base mechanics of Phase 16 (Ticket Office): M751 Ticket Chain, M752 Ticket Punch, M753 Master Pass, and M754 Ticket Swap Pad.

## Current State
Design documented in `phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md` and `../../SHARED_CORE_STANDARD.md` §16.17, not yet implemented.

## Proposed Change
Implement the 4 base mechanic types in `packages/puzzle_core`:

### 1. M751 · Ticket Chain (Key Chain)
- **Intro Level:** L7511 (Block 2, x1).
- **Category:** K / L (Chained Sequential Barrier).
- **Rule:** A chained sequence of railway barriers. Barrier A unlocks when Ticket A arrives; the gate opening immediately activates Ticket Car B nested within, granting access to unlock Barrier B.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o1", "type": "M751", "cells": [[4, 4]], "params": {"keyId": "ticket_a", "releasesKey": "ticket_b"}, "hammerable": false}
  ```

### 2. M752 · Ticket Punch (Key Crafting)
- **Intro Level:** L7631 (Block 14, x1).
- **Category:** T / K (Half-Ticket Assembler).
- **Rule:** A wooden conductor punch station. Two distinct half-ticket stubs (Left Stub 🎟️L and Right Stub 🎟️R) exist on the grid. Routing both stubs through the punch booth welds them into 1 complete Golden Ticket, permanently unlocking the golden gate.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o2", "type": "M752", "cells": [[7, 8]], "params": {"requiredStubs": ["stub_left", "stub_right"], "craftedKey": "golden_ticket"}, "hammerable": false}
  ```

### 3. M753 · Master Pass (Skeleton Key)
- **Intro Level:** L7751 (Block 26, x1).
- **Category:** P / K (Universal Skeleton Locomotive).
- **Rule:** A golden locomotive carrying an omni-key skeleton pass. Automatically unlocks the first encountered colored railway barrier along its route. The pass is consumed upon unlock (single-use).
- **Hammerable:** Yes (Track Crane removes the master pass locomotive).
- **Data Model:**
  ```json
  {"id": "p_master", "type": "path", "cells": [[2, 2], [2, 3]], "dir": "R", "params": {"isMasterPass": true}}
  ```

### 4. M754 · Ticket Swap Pad (Key Swap)
- **Intro Level:** L7871 (Block 38, x1).
- **Category:** T (Key Reallocation Pad).
- **Rule:** Paired siding pads on parallel tracks. When two key-holding trains stop on the pads, tapping the pad consumes 1 move and exchanges their held ticket emblems.
- **Hammerable:** No.
- **Data Model:**
  ```json
  {"id": "o4", "type": "M754", "cells": [[9, 3], [9, 5]], "params": {"swapSlots": ["p1", "p2"]}, "hammerable": false}
  ```

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/m751_ticket_chain.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m752_ticket_punch.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m753_master_pass.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m754_ticket_swap_pad.dart` (to be created)

## Risks
- Incorrect stub alignment in punch booth. Mitigation: Stubs buffer into the station and weld immediately once both arrive.

## Open Questions
- None. Rules match `phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md`.

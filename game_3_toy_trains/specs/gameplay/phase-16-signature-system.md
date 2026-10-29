Source docs: phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md, phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-15-signature-system.md, specs/tech/on-device-level-generation.md.

# Spec: Gameplay — Phase 16 Signature System (Ticket Office Keys Deluxe)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 16 signature system "Ticket Office" (Keys Deluxe `S16`): chained sequential ticket barriers, ticket stub punch crafting booths, universal master pass locomotives, and inter-train ticket swap pads for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md`, `phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Earlier phases operated independent single-key barriers.
- Phase 16 introduces chained key dependencies (DAG), key fusion, and dynamic key transfer mechanics.

## Proposed Change
Extend `packages/puzzle_core` with a key dependency solver and ticket crafting system:

### 1. Key Lifecycle & Dependency Graph
- **Ticket Chain (M751):**
  - Unlocking Barrier A with Ticket Car A immediately releases Ticket Car B from behind the gate, which is required to unlock Barrier B.
- **Ticket Punch Booth (M752):**
  - Board contains two complementary half-ticket stubs (Left Stub 🎟️L and Right Stub 🎟️R).
  - Delivering both stubs into the punch booth automatically crafts one full Golden Ticket, which unlocks the golden terminal barrier.
- **Master Pass Locomotive (M753):**
  - Golden locomotive carrying a universal skeleton pass. It automatically consumes its master pass to unlock the first colored railway barrier (red, blue, green) it encounters along its route.
- **Ticket Swap Pad (M754):**
  - Paired siding pads. When two ticket-carrying trains park on the pads, tapping the pad (1 Move) swaps their held ticket keys.

### 2. Topological Dependency Verification
- Solver builds a Directed Acyclic Graph (DAG) of key acquisitions and barrier unlocks.
- Topological sort verifies that no cyclic key deadlocks exist under optimal play.

## Affected Files
- `packages/puzzle_core/lib/src/engine/ticket_office_manager.dart` (to be created)
- `packages/puzzle_core/lib/src/models/ticket_inventory.dart` (to be created)

## Risks
- Players using Master Pass on the wrong barrier creating unsolvable states. Mitigation: Solver ensures all valid branching uses of the Master Pass maintain at least one solvable win path.

## Open Questions
- None. Rules match `phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md` and `SHARED_CORE_STANDARD.md` §11.

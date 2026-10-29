Source docs: phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md, phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 16 Signature System: Keys Deluxe (Jewel Box)

## Status
Draft

## Type
New Feature

## Goal
Specify the advanced key logistics, ordered charm chains, dual-half key crafting, universal skeleton keys, and step tick integration for Yarn Unravel Phase 16 (Levels 7501–8000).

## Current State
Design documented in `phase/phase_16/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md` and `phase/phase_16/01_PHASE_16_SCOPE_AND_RULES.md`, not yet implemented.
- Prior phases utilized 1:1 color-matched keys and locks.
- Phase 16 introduces Keys Deluxe (Jewel Box), expanding key interactions into ordered collection chains ($1 \to 2 \to 3$), multi-thread key synthesis, universal skeleton charms, and interactive color swap hoops.

## Proposed Change
Implement the Keys Deluxe system within `packages/puzzle_core`:

### 1. Advanced Key Logistics & System Rules
- **Charm Chain (M751):**
  - Thread heads decorated with numbered golden badges ($1, 2, 3$).
  - Threads must be unraveled strictly in ascending numerical order.
  - Tapping an out-of-order chain thread results in a locked feedback vibration (no heart penalty, thread does not unravel).
- **Charm Crafting (M752):**
  - Two distinct threads carry half-key charms (Half-Charm Left and Half-Charm Right).
  - When both designated threads successfully exit the board, the two halves assemble into a Grand Master Key that unlocks the primary level clasp.
- **Skeleton Charm (M753):**
  - A thread carrying an ornate golden skeleton key emblem.
  - Passing through or unraveling across any colored clasp immediately and permanently unlocks it, bypassing color-matching requirements.
- **Charm Swap Hoop (M754):**
  - Interactive brass hoop on the board canvas.
  - Tapping costs 1 move and swaps the active key colors between two linked threads.

### 2. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Player unravels a thread OR taps Charm Swap Hoop (1 move).
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):** M007, M017, M031, M253, M353 decrement.
- **Step 4 (Keys & Crafting Step Execution):**
  1. Charm Chain (M751) evaluates index: unlocks next numbered link if previous link exited cleanly.
  2. Charm Crafting (M752) checks inventory: if both half-charms are collected, trigger Grand Key assembly.
  3. Skeleton Charm (M753) evaluates path intersections and unlocks encountered clasps.
  4. Charm Swap Hoop (M754) updates color properties between linked threads.
- **Step 5 (Clasps & Gates State Updates):** Unlock verified clasps.
- **Step 6 (Heart Loss & Shield Resolution):** Resolve snags from player unravel actions.
- **Step 7 (Win / Loss Evaluation):** Check remaining threads and board clearance.

### 3. Solver Integration (IDA*)
- In the IDA* puzzle solver:
  - Chain dependencies are encoded as strict state preconditions.
  - Key crafting states track collected half-key bitmasks.
  - Solvability verification guarantees that required key paths are never deadlocked behind clasps they are intended to open.

## Affected Files
- `packages/puzzle_core/lib/src/models/keys_deluxe_state.dart` (to be created: charm chains and synthesis models)
- `packages/puzzle_core/lib/src/logic/keys_deluxe_controller.dart` (to be created: ordering, crafting, and swap logic)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: ordered prerequisite move pruning)
- `packages/puzzle_core/lib/src/generator/level_generator.dart` (changed: placement of chain threads and crafting altars)

## Risks and Open Questions
- None. System rules strictly adhere to `SHARED_CORE_STANDARD.md` §11 and §16.17.

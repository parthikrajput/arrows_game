Source docs: phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md, phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-4-signature-system.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 5 Signature System (Yard Shunting+ Push Physics)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 5 signature system "Yard Shunting+" (Push Physics+ `S05`): advanced railway yard shunting dynamics where engines displace push carts, fill track pits, slide frictionless ice wagons, navigate ticket key carts onto sensor pads, and overcome heavy ballast wagons for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md`, `phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 2 introduced basic Push Carts (M053) that slid 1 cell forward.
- Phase 5 expands push mechanics into a comprehensive shunting puzzle system with continuous sliding, pit filling, receptor pads, and weight thresholds.

## Proposed Change
Extend `packages/puzzle_core` with advanced shunting simulation rules:

### 1. Advanced Shunting Dynamics
- **Push Interaction:** When an exiting train strikes a shunting cart:
  - If the space directly behind the cart is clear, the cart is displaced forward along the train's departure vector.
  - Displacement counts as 1 Move turn. The train halts in its pre-impact position and does NOT exit on that turn.
  - If the space behind is blocked by a wall, obstacle, or stationary train, the impact results in a buffer clack bump (-1 heart).
- **Multi-Cart Stacks:** Pushing a row of contiguous carts is prohibited; pushing multiple carts simultaneously causes a bump (-1 heart).

### 2. Interaction with Track Features
- Pushing carts into holes (Cart Pit M201) permanently converts the hole into regular traversable track.
- Pushing carts onto sensor pads (Ticket Cart M203 onto matching color pad) permanently unlocks linked signal gates.
- Pushing onto icy sections triggers continuous sliding until an obstacle or board boundary is contacted.

### 3. Solver Heuristics & Determinism
- Stateful solver models carts as dynamic entities within the board state key: `(remainingTrains, cartCoordinates, filledPitMask)`.
- Solver tracks irreversibility: pushing a cart into an unrecoverable corner (without exit lines) is pruned as a loss state.

## Affected Files
- `packages/puzzle_core/lib/src/engine/shunting_physics.dart` (to be created)
- `packages/puzzle_core/lib/src/models/shunting_cart.dart` (to be created)

## Risks
- Unintended corner traps where a player pushes a cart against a wall with no remaining legal moves. Mitigated by CI solver solvability guarantee.

## Open Questions
- None. Shunting physics rules match `phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md` and `SHARED_CORE_STANDARD.md` §11.


Source docs: phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md, phase_5/01_PHASE_5_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §12, §16.17, §17.3, §17.24, §17.29, §17.38. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/obstacle-catalog-phase-2.md, specs/gameplay/phase-4-signature-system.md.

# Spec: Gameplay — Phase 5 Signature System (Coconut Grove Physics)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 5 signature system "Coconut Grove Physics" (Push Physics+): an advanced momentum and push interaction model extending single-cell pushes with inertia, terrain modification via pit filling, object-carried key socketing, and multi-unit weight resistance.

## Current State
Design documented in `phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md`, `phase_5/01_PHASE_5_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 2 introduced basic 1-cell push blocks (M053 Rolling Coconut) and localized ice sliding crates (M054).
- There was no support for permanent dynamic terrain alteration (filling holes to create walkable floor), inertia sliding on normal ground, push-activated gate locks, or heavy blockers requiring specialized push strength.

## Proposed Change
Extend `packages/puzzle_core` with advanced push physics resolution pipelines, dynamic grid cell state alterations, and push strength validations:

### 1. Advanced Push Physics & Momentum Architecture
- **Push Action Resolution:**
  - When an advancing snake head contacts a pushable coconut, the engine validates the cell directly behind the block along the snake's travel vector $\vec{v}$.
  - If the target cell is free floor, the block is displaced into that cell and the snake proceeds forward.
  - If the target cell is occupied by a wall, obstacle, or stationary snake, the snake bonks against the block (−1 Heart Berry) and slides back.
- **Continuous Sliding (Inertia):**
  - Dew-Slick Coconuts (M202) preserve momentum, sliding continuously across successive free floor cells until encountering an obstacle, board boundary, or pit.
- **Dynamic Terrain Modification:**
  - Pushing any coconut block into a Coconut Pit (M201) permanently transforms the pit cell into standard navigable floor (`cell.type = Floor`), removing the obstruction and expanding player path options.
- **Open Edge Board Clearance (Standard §17.29):**
  - Pushing any coconut block across an open (unwalled) board boundary causes the block to fall off the board and be permanently removed from the simulation, clearing the lane.
  - Pushing against a walled boundary triggers a bump (−1 Heart Berry).

### 2. Push Strength & Weight Mechanics
- **Standard Push Force:** Any standard snake can push standard coconuts (M053, M202, M203) by 1 or more cells.
- **Heavy Resistance (Jackfruit Boulder M204):**
  - Requires elevated push force. Standard snakes attempting to push M204 bonk and lose 1 Heart Berry.
  - Authorized push sources:
    1. **Giant Anaconda (M049):** 2-wide snake head provides sufficient mass to displace M204 by 1 cell.
    2. **Chained Group Push:** Two snakes linked via the `Chained` modifier executing a simultaneous push.

### 3. Turn Pipeline & Tick Order Integration (Standard §16.17)
Push resolution executes during Step 1 of the turn resolution cycle:
```
1. Action resolve:
   - Snake initiates slither along lane.
   - If path collides with pushable block:
     a. Validate push force (Standard vs Heavy).
     b. Compute trajectory (1 cell vs continuous slide).
     c. Execute block displacement or open-edge fall-off.
     d. If block lands on M201 Pit: alter grid cell to Plain Floor.
     e. If block lands on M203 Lock Cell: latch matching gate open.
     f. Snake completes slither into cleared cell.
2. moveCount += 1.
3. Move counters tick (periodic obstacles, timers).
4. Derived states evaluated (pressure plates, beams, cages).
5. Heart loss & shields resolved.
6. Win condition check: Evaluated once all block motions and path exits settle.
```

### 4. Interaction with Earlier Systems
- **Phase 4 Multi-Floor:** Push blocks exist on their designated floor. If a push block is pushed into a Drop Hole (M153), it falls to the floor below, filling any pit or blocking a lower cell.
- **Phase 3 Cycles:** Cycle transitions do not alter push block coordinates; cycle gates continue to act as solid push blockers while in their closed state.
- **Boosters:**
  - Magic Stone Hammer: Can shatter standard coconuts (M053, M202) to clear a lane; cannot shatter Jackfruit Boulders (M204, standard §16.18).
  - Tongue-Flick Preview: Accurately previews block displacement and pit filling trajectories before executing a move.

## Affected Files
- `packages/puzzle_core/lib/src/engine/push_physics_controller.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` (updated for continuous sliding and terrain transformation)
- `packages/puzzle_core/lib/src/models/grid_cell.dart` (updated to support mutable cell state changes)

## Risks
- Infinite sliding loops on Dew-Slick Coconuts (M202) if boundary bounds check fails. Mitigated by strict board edge collision clamps.
- Solver state explosion when tracking floating push block coordinates. Addressed by discrete coordinate hashing in IDA* state keys.

## Open Questions
- **OD-P5-01:** Pit filling animation timing: 250 ms wobble animation before snapping to flat floor vs instant transition. (Decision: 250 ms visual settling; solver evaluates state change instantly).
- **OD-P5-02:** Hammerability of Jackfruit Boulder (M204). (Confirmed: Non-hammerable per standard §16.18).

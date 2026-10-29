Source docs: phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md, phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-4-signature-system.md, specs/gameplay/core-concept-and-rules.md.

# Spec: Gameplay — Phase 5 Signature System (Acorn Physics Push Physics+)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 5 signature system "Acorn Physics" (Push Physics+): momentum-based push sliding, push chain resolution (chain depth 2), friction surface interactions, and hole filling terrain transformation in Ants & Bees: Garden Trails.

## Current State
Design documented in `phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md`, `phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 2 introduced basic 1-step push blocks (M051 Rolling Acorn).
- Advanced multi-block push chains, frictionless continuous slides, crate sockets, and heavy weight constraints do not exist in the engine.

## Proposed Change
Extend `packages/puzzle_core` with an advanced push physics engine:

### 1. Push Chain Rules (Depth = 2)
- When an insect line strikes push block $A$ along vector $\vec{v}$:
  - If cell $A + \vec{v}$ is empty $\implies$ block $A$ slides into $A + \vec{v}$.
  - If cell $A + \vec{v}$ contains push block $B$, and cell $B + \vec{v}$ is empty $\implies$ both $A$ and $B$ shift 1 cell forward along $\vec{v}$ simultaneously (Chain Depth = 2).
  - If cell $B + \vec{v}$ is blocked by an obstacle, board edge, or third block $C \implies$ the push fails; the insect line bonks at starting cell (-1 Heart).

### 2. Surface Friction & Momentum
- **Standard Lawn:** Block moves exactly 1 cell along $\vec{v}$ and settles.
- **Low-Friction Dewdrop Marble (M202) / Dew Leaves:** Slides continuously along $\vec{v}$ until it encounters a blocking tile, pit, or board boundary.
- **Hole Filling (M201 Mole Hole):** When any rolling acorn or dewdrop marble enters a mole hole, both the block and the hole are consumed, transforming the tile into passable ground terrain.

### 3. Multi-Layer Interaction
- Ground ants (`layer: 0`) push standard blocks (`tall: false`).
- Worker bees (`layer: 1`) and canopy bees (`layer: 2`) fly freely over standard push blocks without colliding.
- Blocks with `tall: true` can be pushed by air lines and block air lines when immovable.

### 4. Turn Pipeline & Tick Order Integration (Standard §16.17)
```
1. Action resolve: Line pushes block(s).
2. Push settlement: Block slides to destination (or drops into pit).
3. moveCount += 1.
4. Periodic counters and 5-move day/night cycles tick.
5. Board state updated (socket plates checked, locks opened).
6. Win condition check.
```

## Affected Files
- `packages/puzzle_core/lib/src/engine/push_physics_engine.dart` (to be created)
- `packages/puzzle_core/lib/src/models/push_block.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` (changed to include push chain resolution)

## Design
- Visual trajectory guide: free Scent Trail Preview displays ghost trajectory of pushed blocks and resulting pit fillings.

## Risks
- Infinite sliding loops on enclosed low-friction loops. Mitigated by grid boundary termination and cycle detection in physics solver.

## Open Questions
- None. Push chain limits and surface rules strictly match `SHARED_CORE_STANDARD.md` §11.


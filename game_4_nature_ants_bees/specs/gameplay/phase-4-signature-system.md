Source docs: phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md, phase/phase_4/01_PHASE_4_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-3-signature-system.md, specs/gameplay/core-concept-and-rules.md.

# Spec: Gameplay — Phase 4 Signature System (Garden Terraces Multi-Floor)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 4 signature system "Garden Terraces" (Multi-Floor): multi-level board architecture supporting up to 3 vertical garden floors (Lower Terrace, Main Garden, Upper Canopy), vertical raycasting exit lane checks, inter-floor camera tracking, and floor switcher navigation.

## Current State
Design documented in `phase/phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md`, `phase/phase_4/01_PHASE_4_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phases 1 to 3 operated on single-floor 2D boards with multiple insect layers (ground ants, worker bees, canopy scout bees).
- Vertical multi-floor boards with inter-floor transit transitions do not exist.

## Proposed Change
Extend `packages/puzzle_core` with multi-floor board modeling and vertical raycasting:

### 1. Multi-Floor Data Model
- **Floors Array:** Optional level JSON property:
  ```json
  "floors": [
    {"id": 0, "name": "Lower Terrace", "grid": [12, 12]},
    {"id": 1, "name": "Main Garden", "grid": [12, 12]},
    {"id": 2, "name": "Upper Canopy", "grid": [12, 12]}
  ]
  ```
- **Floor Property:** Every line (`Path`) and obstacle instance declares its home floor: `"floor": int` (default `0`).
- **Active Floor View:** At runtime, the client viewport displays one floor at a time with smooth vertical camera slides when switching.

### 2. Vertical Raycasting & Exit Lane Validation
- When an insect line's head reaches an inter-floor transition tile (M151 Root Stairs, M153 Rabbit Hole, or M154 Acorn Lift):
  - The exit ray continues onto the target floor at the matching coordinate $(x, y)$ in the line's current direction.
  - If the landing cell or continuation ray on the target floor is obstructed by a blocking obstacle or line, the line bonks immediately on its source floor before moving (-1 Heart).
  - Both source and target floor constraints must be satisfied for a legal move.

### 3. Layer Separation on Multiple Floors
- Each floor independently hosts ground ants (`layer: 0`), worker bees (`layer: 1`), and canopy scout bees (`layer: 2`).
- Standard layer rules apply on every floor: ants and bees never collide; tall obstacles block all layers on their floor.

### 4. Turn Pipeline & Tick Order Integration (Standard §16.17)
- Multi-floor transitions evaluate in Step 1 (Lane checking) and execute in Step 2 (Movement animation).
- When a line transitions floors, the camera smoothly tracks the insect to the new floor (250 ms vertical pan).
- Global move counter increments once per player action; day/night cycles continue ticking every 5 valid moves.

## Affected Files
- `packages/puzzle_core/lib/src/engine/floor_manager.dart` (to be created)
- `packages/puzzle_core/lib/src/models/floor_state.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` (changed to support inter-floor raycasting)

## Design
- Vertical Floor Switcher tabs on right edge of screen (`[T3] Upper`, `[T2] Main`, `[T1] Lower`) with color accents and unread line counters.
- Smooth 250 ms parallax vertical scroll between floors.

## Risks
- Vertical cyclic deadlocks where floor A transitions into floor B, but floor B requires a line to cross floor A first. Mitigated by IDA* reverse construction validator verifying acyclic dependency graphs.

## Open Questions
- None. Multi-floor rules and vertical constraints are strictly defined in `SHARED_CORE_STANDARD.md` §11.


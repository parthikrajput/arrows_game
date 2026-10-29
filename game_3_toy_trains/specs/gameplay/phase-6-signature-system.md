Source docs: phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md, phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/phase-5-signature-system.md, specs/gameplay/obstacle-catalog-phase-2.md.

# Spec: Gameplay — Phase 6 Signature System (Signal Lights+ Optical Beams)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 6 signature system "Signal Lights+" (Light & Shadows+ `S06`): advanced railway optical mechanics where signal lamps project continuous linear light beams across track corridors, triggering photocell receivers, interacting with color filters, and revealing darkened track cells for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md`, `phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md`, and `../../SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 2 introduced basic Signal Lamps (M084), Light Sensors (M085), and Mirrors (M086).
- Phase 6 expands optical mechanics into a signature system featuring chromatic beam filtering, dual-sensor gates, countdown beam timers, and dark blackout tracks.

## Proposed Change
Extend `packages/puzzle_core` with an enhanced optical ray-tracing pipeline:

### 1. Ray-Tracing Engine & Beam Propagation
- **Line-of-Sight Raycasting:**
  - Active Signal Lamps project an unbroken light ray orthogonally/diagonally along their heading vector across the board.
  - The ray continues infinitely until colliding with an occluding entity: train carriage, solid obstacle, or board boundary.
  - Trains or carts entering a beam immediately block propagation downstream.
- **Derived State Evaluation (Step 4 of Turn Tick):**
  - Following any Move action and move counter increment, the engine re-evaluates all active light rays across the board.
  - Sensor boxes evaluate their active illumination status (true/false) and color spectrum matching.
  - Linked signal gates toggle open or closed based on sensor illumination.
  - Blackout cells (M254) illuminated by active beams switch from dormant/dark to active/illuminated.

### 2. Solver Heuristics & Determinism
- Stateful solver (IDA* / BFS) encodes optical beam states within the state key: `(remainingTrains, sensorActivationBitmask, timerPhases)`.
- Reverse construction guarantees that all dark cells can be systematically illuminated and all twin-sensor gates can be unlocked without requiring booster usage.

## Affected Files
- `packages/puzzle_core/lib/src/engine/optical_ray_tracer.dart` (to be created)
- `packages/puzzle_core/lib/src/models/optical_beam.dart` (to be created)

## Risks
- Ray-tracing performance bottlenecks if multiple mirrors and prisms create deep recursive reflection loops. Mitigated by maximum ray reflection limit capped at 16 bounces.

## Open Questions
- None. Optical ray-tracing rules and tick orders match `phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md` and `SHARED_CORE_STANDARD.md` §11.

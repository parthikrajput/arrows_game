Source docs: phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md, phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 7 Signature System: Rotation (Turning Table)

## Status
Draft

## Type
New Feature

## Goal
Specify the 90° clockwise sub-board coordinate transformation mathematics, boundary thread constraints, Tangled thread state invariants, and step tick integration for Yarn Unravel Phase 7 (Levels 3001–3500).

## Current State
Design documented in `phase/phase_7/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md` and `phase/phase_7/01_PHASE_7_SCOPE_AND_RULES.md`, not yet implemented.
- Previous phases maintained fixed coordinate orientations for cells and thread trajectories.
- Phase 7 introduces dynamic rotational elements (Turning Table), including player-triggered sub-grid turntable hoops and automatic rotational perimeter shifts.

## Proposed Change
Implement the Rotation system within `packages/puzzle_core`:

### 1. Rotational Mathematics & Grid Transformation
- **Sub-Grid Pivot:** A rotation center `(cx, cy)` defines a local square sub-board (e.g., $4 \times 4$).
- **90° Clockwise Coordinate Mapping:**
  For any internal cell `(x, y)` relative to center `(cx, cy)`:
  $$x' = cx - (y - cy), \quad y' = cy + (x - cx)$$
- **Direction Vector Transformation:**
  Vector directions transform cyclically:
  $$\text{Up } (0, -1) \to \text{Right } (1, 0) \to \text{Down } (0, 1) \to \text{Left } (-1, 0) \to \text{Up } (0, -1)$$
  Diagonal vectors similarly advance 90° clockwise.

### 2. Boundary Invariant & Rotor Locking
- **Full Enclosure Requirement:**
  - A thread or multi-cell entity rotates with the sub-board if and only if **100% of its coordinate cells** reside strictly inside the sub-grid bounding box.
- **Straddling Boundary Constraint:**
  - If any thread has at least one segment inside the rotor and at least one segment outside the rotor, the sub-board rotor is mechanically locked.
  - Tapping a locked rotor plays a tactile denial wobble (`tangled_denied_tap`) and expends **0 moves**.
  - The rotor can only rotate once straddling threads have completely unraveled from the sub-grid.

### 3. Tangled Thread State Invariant
- Following any rotation, if a thread's needle head (`body[0]`) points directly into an adjacent segment of its own body (`body[1]` or further along its path):
  - The thread enters the **Tangled** state.
  - While Tangled, tapping the thread does NOT cause a heart-losing snag collision; instead, it triggers a soft denial wobble (`denied_nudge`, 0 hearts lost, 0 moves expended).
  - The thread cannot unravel until subsequent rotations re-align its needle head toward open fabric.

### 4. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Player-Triggered Rotor Tap:**
  - Costs 1 move.
  - Step 1: Transforms coordinates of all fully contained entities.
  - Step 2: Increments `moveCount += 1`.
  - Step 3: Evaluates periodic mechanics (Turning Hems M302 and Twirl Threads M303).
  - Step 4: Re-evaluates derived states (Tangled thread states, beam ray casts).
  - Step 5: Checks win/loss conditions.
- **Standard Thread Unravel Tap:**
  - Thread unravels; at Step 3, automatic rotating elements advance 1 tick.

## Affected Files
- `packages/puzzle_core/lib/src/engine/rotation_transformer.dart` (to be created: rotation math engine)
- `packages/puzzle_core/lib/src/models/rotor_entity.dart` (to be created: rotor state model)
- `packages/puzzle_core/lib/src/engine/puzzle_engine.dart` (changed: integrate rotor tap and Step 3 tick)
- `tools/levelgen/lib/src/solver/ida_star_solver.dart` (changed: integrate rotation state permutations)

## Risks
- Combinatorial state explosion in IDA* solver due to 4 rotational orientations per sub-grid. Mitigated by canonical state representation and transposition hashing.

## Open Questions
None. Rotation math, boundary rules, and tick integration match Phase 7 design documentation.

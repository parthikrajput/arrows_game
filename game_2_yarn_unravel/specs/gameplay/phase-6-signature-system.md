Source docs: phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md, phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 6 Signature System: Light & Beams+ (Lamplight Atelier)

## Status
Draft

## Type
New Feature

## Goal
Specify the chromatic ray-casting propagation engine, dynamic occlusion, Sun-Catcher beam triggers, step tick integration (Step 4 Derived States), and solver ray reflection bounds for Yarn Unravel Phase 6 (Levels 2501–3000).

## Current State
Design documented in `phase/phase_6/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md` and `phase/phase_6/01_PHASE_6_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 2 introduced static directional laser beams.
- Phase 6 expands this into a full dynamic chromatic optical simulation (Lamplight Atelier): lamps emit light rays that dynamically project across the board, are occluded by threads and crates, change color when passing through tinted filters, activate light-sensitive Sun-Catcher clasps, and illuminate dark shadow cells.

## Proposed Change
Implement the Light & Beams+ system in `packages/puzzle_core`:

### 1. Optical Entity Model
- **Atelier Lamp Emitter:**
  - Placed at board boundaries or designated grid cells `(x, y)`.
  - Parameters: `direction: Direction` (N, S, E, W, or diagonal), `color: BeamColor` (default: white/warm gold), `state: LampState.active`.
  - Max emitters per board: 2 to 5 lamps.
- **Sun-Catcher Gate:**
  - Stationary receiver cell on board fabric.
  - Linked to one or more barrier gates.
  - State: Opens when illuminated by a beam matching its required color (or any beam if chromatic filter is neutral).

### 2. Ray-Casting & Propagation Rules
1. **Linear Marching:**
   - From each active emitter, a light ray marches forward cell-by-cell in its assigned direction.
   - Rays pass through empty fabric cells without impedance.
2. **Dynamic Occlusion:**
   - Thread bodies, wooden crates, and solid wall blockers stop ray propagation immediately at the contacted cell boundary.
   - When a thread unravels and vacates cells, the ray instantly marches through the liberated cells during the subsequent tick pass.
3. **Infinite Loop Prevention:**
   - When intersecting deflecting mirrors (M014 Hook Deflectors) or reflecting modifiers, ray reflections are capped at a maximum of 16 bounces; rays exceeding 16 bounces safely terminate to avoid recursive lockups.

### 3. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Thread unravels; vacates grid cells.
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Tick Counters):** Move-based timers (e.g., M253 Hourglass Lamps) evaluate and toggle state if interval threshold reached.
- **Step 4 (Derived States / Ray-Cast Pass):**
  1. All active emitters cast rays.
  2. Rays evaluate Tinted Glass (M251) color transformations.
  3. Rays evaluate Prism Clasps (M252) simultaneous incidence.
  4. Illuminated cells clear Shadow Pockets (M254), unlocking covered threads.
  5. Sun-Catchers update gate barriers.
- **Step 5 (Win / Loss Evaluation):** Check remaining threads and board clearance.

### 4. Solver Integration (IDA*)
- Ray trajectories are computed as pure deterministic derived state:
  - Solver does not maintain separate history branches for ray paths; instead, the ray-cast pass executes as a fast bitmask evaluation across the $14 \times 14$ grid whenever thread or crate positions shift.
  - Bitmask representation: `Int64` bitboard for beam presence per color channel.

## Affected Files
- `packages/puzzle_core/lib/src/models/beam_emitter.dart` (to be created: lamp model)
- `packages/puzzle_core/lib/src/engine/raycast_engine.dart` (to be created: bitboard ray-caster)
- `packages/puzzle_core/lib/src/engine/puzzle_engine.dart` (changed: integrate ray-cast pass into Step 4)
- `tools/levelgen/lib/src/solver/ida_star_solver.dart` (changed: integrate optical state transitions)

## Risks
- Ray-casting latency during continuous undo/redo operations. Mitigated by bitmask ray-casting operations completing in $< 0.1\text{ ms}$.

## Open Questions
None. Ray-cast rules, step tick integration, and maximum bounce limit match Phase 6 documentation.

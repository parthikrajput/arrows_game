Source docs: phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md, phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 5 Signature System: Push Physics+ (Crate Workshop)

## Status
Draft

## Type
New Feature

## Goal
Specify the Push Physics+ (Crate Workshop) dynamic entity kinetics, displacement rules, collision handling, solver state transitions, and step tick integration for Yarn Unravel Phase 5 (Levels 2001–2500).

## Current State
Design documented in `phase/phase_5/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md` and `phase/phase_5/01_PHASE_5_SCOPE_AND_RULES.md`, not yet implemented.
- Phase 1 and 2 supported static obstacles, directional pins, and beam blockers.
- Phase 5 introduces movable Notions Crates (wooden sewing boxes) positioned on the craft board that dynamically displace when pushed by unraveling threads.

## Proposed Change
Implement the Push Physics+ system within `packages/puzzle_core`:

### 1. Entity Model: Notions Crate
- **Board Grid Cell:** Occupies a single cell `(x, y)` on the primary fabric plane.
- **Attributes:**
  - `id`: Unique identifier (e.g., `crate_01`).
  - `type`: `CrateType.standard` (or mechanic variants M202–M204).
  - `hammerable`: `true` for standard wooden crates; consumes 1 Golden Scissors strike to destroy the crate and free the cell.

### 2. Push Displacement Kinetics
When an unraveling thread head advances along its unravel trajectory and encounters a crate at `(x, y)`:
1. **Empty Target Cell Check:**
   - The cell directly ahead in the thread's unravel direction `(x + dx, y + dy)` is evaluated.
   - If `(x + dx, y + dy)` is inside board bounds and contains NO solid blocker, active thread body, or immovable obstacle:
     - The crate is displaced to `(x + dx, y + dy)` (emitting `crate_push_step` VFX and wooden slide SFX).
     - The thread continues moving along its unravel path unhindered through `(x, y)`.
2. **Blocked Cell / Snag Collision:**
   - If `(x + dx, y + dy)` is outside board bounds, or contains a wall, obstacle, another unmovable crate, or thread segment:
     - The crate CANNOT displace.
     - The pushing thread collides with the crate, resulting in a **Snag** (-1 Heart, twang sound, vibration).
     - The crate remains stationary at `(x, y)`.

### 3. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17, Push Physics integrates into the 5-step tick pipeline:
- **Step 1 (Action Resolve):** Thread unravel trajectory evaluates push collisions. If pushable, the crate position is updated synchronously before path clear confirmation.
- **Step 2 (Board Effect):** Crate arrival at target cell triggers surface triggers (e.g., Crate Pit M201 filling or Charm Crate M203 clasp unlocking).
- **Step 3 (Chain Reactions):** Secondary effects (e.g., sliding satin crates M202 or knit-growth) resolve.
- **Step 4 (Periodic Cycles / Latch Check):** Earlier phase cycle ticks evaluate if active.
- **Step 5 (Win / Loss Evaluation):** Thread exit count and board clearance checked.

### 4. Solver Integration (IDA*)
- In the IDA* puzzle solver, crates form dynamic spatial dependencies:
  - Moving a crate can simultaneously open an exit path for Thread A while sealing an exit path for Thread B.
  - Solver state representation encodes `(crate_id, x, y)` coordinates.
  - Transposition table hashes crate positions alongside thread configurations.
  - Zero-heart solvability check verifies no unresolvable deadlocks are created.

## Affected Files
- `packages/puzzle_core/lib/src/models/crate_entity.dart` (to be created: crate state model)
- `packages/puzzle_core/lib/src/engine/push_resolver.dart` (to be created: push kinetics calculator)
- `packages/puzzle_core/lib/src/engine/puzzle_engine.dart` (changed: integrate push resolver into Step 1)
- `tools/levelgen/lib/src/solver/ida_star_solver.dart` (changed: include crate positions in board state hash)

## Risks
- Deadlocks where crates are pushed into corners making remaining threads un-unravelable. Mitigated by CI generator dead-end pruning during level generation.

## Open Questions
None. Push kinetics and tick step rules match Phase 5 design documentation and SHARED_CORE_STANDARD §11 and §16.17.

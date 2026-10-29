Source docs: phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md, phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17, ../../SCALING_TO_10000_LEVELS.md §10.3. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 19 Signature System: Remix B (Phases 7–12 Synergy)

## Status
Draft

## Type
New Feature

## Goal
Specify the advanced kinematic synergies, rotation-gravity dynamics, rotor-growth redirection, rhythmic transport, and step tick integration for Yarn Unravel Phase 19 (Levels 9001–9500).

## Current State
Design documented in `phase/phase_19/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md` and `phase/phase_19/01_PHASE_19_SCOPE_AND_RULES.md`, not yet implemented.
- Prior phases explored rotational grids, organic vine growth, linked boards, and gravity kinetics in separate chapters.
- Phase 19 introduces Remix B, harmonizing kinematic and spatial systems from Phases 7 to 12 into high-level mechanical orchestrations while enforcing strict solver complexity caps.

## Proposed Change
Implement the Remix B system within `packages/puzzle_core`:

### 1. Kinematic Synergy Dynamics & Candidate Pool (§10.3)
Selected mechanics feature deep physical interactions:
- **M901 — Twirl Weighted Thread:** Integrates Phase 7 Rotation with Phase 12 Gravity. After every player move, this heavy metal-core thread rotates 90° clockwise, then translates 1 cell along the current active gravity vector (if destination cell is vacant).
- **M902 — Ivy Hoop Rotor:** Integrates Phase 8 Organic Growth with Phase 7 Hoop Rotors. A $4\times 4$ rotating disc bearing embedded ivy roots; tapping the rotor turns the roots 90° clockwise, altering the direction of subsequent organic vine growth.
- **M903 — Rhythm Belt:** Integrates Phase 15 Conveyors with Phase 10 Sequencing Metronome. Conveyor belts translate resting threads only on active metronome beats (e.g. advance 1 cell on beat; pause on off-beat).
- **M904 — Seam Edge Split:** Integrates Phase 11 Linked Boards with Phase 9 Split & Merge. Pulling a thread across the boundary seam between Hoop A and Hoop B causes it to split cleanly into dual half-ply strands upon entering Hoop B.

### 2. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Player unravels an active thread OR taps a rotor disc (1 move).
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):** Periodic counters decrement.
- **Step 4 (Remix B Multi-System Resolution):**
  1. Rotations & Twirls resolve (M901 rotates 90° CW).
  2. Gravity translations execute (M901 slides 1 cell in gravity direction).
  3. Organic Ivy expansion propagates in cardinal order ($U \to R \to D \to L$) from oriented roots (M902).
  4. Rhythm Belts (M903) evaluate beat counter and advance resting threads if active.
  5. Seam Edge cross-board splits (M904) instantiate paired thread entities.
- **Step 5 (Gates & Clasps Update):** Update locks and clasps.
- **Step 6 (Heart Loss & Shield Resolution):** Evaluate snags from player unravel actions.
- **Step 7 (Win / Loss Evaluation):** Check remaining threads and board clearance.

### 3. Solver Integration (IDA*)
- In the IDA* puzzle solver:
  - Multi-kinematic state hashing incorporates rotation angles, gravity vectors, and growth bitboards.
  - CI verification guarantees that multi-system interactions solve within $\le 1.5\text{M}$ nodes and do not generate infinite cyclic orbits.

## Affected Files
- `packages/puzzle_core/lib/src/models/remix_b_state.dart` (to be created: kinematic combo models)
- `packages/puzzle_core/lib/src/logic/remix_b_controller.dart` (to be created: kinematic dispatch logic)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: multi-system kinematic heuristics)
- `packages/puzzle_core/lib/src/generator/level_generator.dart` (changed: kinematic synergy board layouts)

## Risks and Open Questions
- None. System interactions comply with `SHARED_CORE_STANDARD.md` §11 and §16.17.


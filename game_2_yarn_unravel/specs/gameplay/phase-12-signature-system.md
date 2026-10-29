Source docs: phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md, phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 12 Signature System: Gravity (Hanging Loom)

## Status
Draft

## Type
New Feature

## Goal
Specify the 4-directional directional gravity field, sliding kinetics for unstitched objects, weighted thread translation rules, and step tick integration for Yarn Unravel Phase 12 (Levels 5501–6000).

## Current State
Design documented in `phase/phase_12/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md` and `phase/phase_12/01_PHASE_12_SCOPE_AND_RULES.md`, not yet implemented.
- Previous phases maintained static spatial positions for obstacles unless explicitly pushed by unraveling threads.
- Phase 12 introduces Gravity (Hanging Loom), simulating a hanging frame where loose objects (Dropping Buttons) and heavy threads slide along an orientable gravity vector ($\text{Down} \downarrow$, $\text{Left} \leftarrow$, $\text{Up} \uparrow$, $\text{Right} \rightarrow$).

## Proposed Change
Implement the Gravity system within `packages/puzzle_core`:

### 1. Gravity Vector Model & Field Rules
- **Gravity Field State:**
  - Orientations: $\text{Down} (0, 1)$, $\text{Left} (-1, 0)$, $\text{Up} (0, -1)$, $\text{Right} (1, 0)$. Default orientation is $\text{Down}$.
  - Toggled manually via Plumb Lever (M551), which cycles through the 4 orientations in clockwise order (costs 1 move).
- **Object Susceptibility Invariants:**
  - Standard threads: Woven tightly into the linen base; immune to gravity forces.
  - Dropping Buttons (M552): Loose round buttons; slide continuously along the gravity vector until halted by an obstacle, thread body, or board border.
  - Float Patches (M553): Anti-gravity fabric zones; any object situated on a float patch is completely anchored and immune to gravity shifts.
  - Weighted Threads (M554): Metal-core threads; translate exactly 1 cell along the gravity vector after every valid player move, provided all target destination cells are unoccupied.

### 2. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Player unravels a thread OR taps Plumb Lever (1 move).
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):** Periodic counters decrement.
- **Step 4 (Derived States / Gravity Execution Step):**
  1. Weighted Threads (M554) translate 1 cell along the current gravity vector.
  2. Dropping Buttons (M552) execute continuous ray-cast slides along the gravity vector until resting against blockers.
  3. Stationary buttons take up positions as single blockers (M001).
- **Step 5 (Win / Loss Evaluation):** Check remaining threads and board clearance.

### 3. Solver Integration (IDA*)
- In the IDA* puzzle solver:
  - Board states include `(gravity_dir, button_positions, weighted_thread_positions)`.
  - Transposition tables hash gravity vectors and loose object coordinates alongside thread bitboards.
  - Solvability verification guarantees that gravity shifts never slide buttons into unresolvable dead-end configurations.

## Affected Files
- `packages/puzzle_core/lib/src/models/gravity_field.dart` (to be created: gravity state model)
- `packages/puzzle_core/lib/src/engine/gravity_resolver.dart` (to be created: slide & fall kinetics)
- `packages/puzzle_core/lib/src/engine/puzzle_engine.dart` (changed: integrate gravity step into Step 4)
- `tools/levelgen/lib/src/solver/ida_star_solver.dart` (changed: integrate gravity state hashing)

## Risks
- Rapid successive gravity shifts creating cyclic button loops. Mitigated by button slide resolution reaching a resting state synchronously within Step 4.

## Open Questions
None. Gravity mechanics and tick order integration match Phase 12 documentation.

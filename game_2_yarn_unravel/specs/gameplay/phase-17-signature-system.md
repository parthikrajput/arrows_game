Source docs: phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md, phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 17 Signature System: Guardians (Pincushion Court)

## Status
Draft

## Type
New Feature

## Goal
Specify the multi-cell velvet Pincushion Guardian boss entities, adjacent pin extraction damage rules, shared HP pools, button spawner cycles, and move tick integration for Yarn Unravel Phase 17 (Levels 8001–8500).

## Current State
Design documented in `phase/phase_17/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md` and `phase/phase_17/01_PHASE_17_SCOPE_AND_RULES.md`, not yet implemented.
- Previous obstacles were static single-cell or fixed polyomino blockers.
- Phase 17 introduces Guardians (Pincushion Court), multi-cell ($2\times 2$ or $3\times 3$) royal velvet pincushions with health point (HP) pools that demand unravelling threads from adjacent cells to extract pins and collapse the guardians.

## Proposed Change
Implement the Guardians system within `packages/puzzle_core`:

### 1. Pincushion Mechanics & Damage Models
- **Pincushion Entity Scale & Health:**
  - Multi-cell obstacles ($2\times 2$ or $3\times 3$) occupying linen grid cells.
  - Initial HP typically ranges from 4 to 8 (12 HP in Finale Level 8500).
  - While active, all constituent cells act as solid immovable blockers.
- **Pin Extraction (Damage Rule):**
  - Whenever an unravelling thread pulls through any cell immediately adjacent (orthogonal or diagonal, Chebyshev distance = 1) to the pincushion perimeter, exactly 1 pin is extracted (-1 HP).
  - When HP reaches 0, the pincushion collapses, dissolves into silk ribbons, and clears its footprint into traversable floor cells.
- **Twin Pincushions (M801):**
  - Two $2\times 2$ pincushions sharing a synchronized HP pool; pulling a pin from either guardian reduces the shared pool until both collapse simultaneously.
- **Armoured Pincushion (M802):**
  - Equipped with a brass shield cap; immune to pin extraction while its linked clutch lever is in the "Shielded" state.
- **Seeding Pincushion (M803):**
  - Every 4 player moves, spawns a new wooden button blocker (M001) in the first available adjacent empty cell ($U \to R \to D \to L$).
- **Heart Pincushion (M804):**
  - Features an internal core cell; takes damage only when an active light beam (Phase 6 Lamplight) illuminates its core during adjacent thread extraction.

### 2. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Player unravels a thread OR toggles a shield lever (1 move).
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):** Periodic counters decrement.
- **Step 4 (Guardian & Spawner Resolution):**
  1. Evaluate adjacent thread extractions: apply -1 HP to valid, unshielded pincushions.
  2. For Heart Pincushions (M804), verify active beam intersection before registering damage.
  3. If HP reaches 0, trigger collapse and free occupied grid cells.
  4. Seeding Pincushions (M803) check move counter: if $m \pmod 4 == 0$ and active, spawn 1 button blocker.
- **Step 5 (Gates & Clasps Update):** Update color gates and locks.
- **Step 6 (Heart Loss & Shield Resolution):** Evaluate snags from player unravel actions.
- **Step 7 (Win / Loss Evaluation):** Check remaining threads and board clearance.

### 3. Solver Integration (IDA*)
- In the IDA* puzzle solver:
  - Board states include `(guardian_hps, shield_states, spawner_counters)`.
  - Solvability verification guarantees that spawner buttons never create unavoidable deadlocks and that sufficient thread extractions exist to clear all guardians.

## Affected Files
- `packages/puzzle_core/lib/src/models/guardian_state.dart` (to be created: pincushion entity and HP models)
- `packages/puzzle_core/lib/src/logic/guardian_controller.dart` (to be created: pin extraction and spawner logic)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: dynamic guardian HP state transitions)
- `packages/puzzle_core/lib/src/generator/level_generator.dart` (changed: guardian footprint and spawner placement)

## Risks and Open Questions
- None. System rules strictly adhere to `SHARED_CORE_STANDARD.md` §11 and §16.17.

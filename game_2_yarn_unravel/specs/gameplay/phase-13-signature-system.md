Source docs: phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md, phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 13 Signature System: Hidden Info (Mystery Basket)

## Status
Draft

## Type
New Feature

## Goal
Specify the Wool Fluff Fog of War hidden information mechanics, scouting reveals, lantern illumination states, and tick order integration for Yarn Unravel Phase 13 (Levels 6001–6500).

## Current State
Design documented in `phase/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md` and `phase/phase_13/01_PHASE_13_SCOPE_AND_RULES.md`, not yet implemented.
- Prior levels operated with complete information; all threads, obstacles, and pins were visible on the linen canvas.
- Phase 13 introduces Hidden Info (Mystery Basket), where thick wool fluff patches conceal board sectors, requiring tactical reveals via Scout Threads (M601) and Lantern Plates (M604).

## Proposed Change
Implement the Hidden Info system within `packages/puzzle_core`:

### 1. Wool Fluff Fog of War Rules
- **Concealment Model:**
  - Board grid cells covered by Wool Fluff fog hide underlying threads, pins, and obstacles.
  - Concealed thread heads are tap-locked; players cannot unravel an obscured thread until its head cell is revealed.
  - Thread Peek: Threads entering or exiting a fog patch display a subtle question mark (`?`) indicator on the perimeter to assist path deduction without exposing full geometry.
- **Reveal Methods:**
  - **Scout Thread (M601):** Unraveling a silver-headed Scout Thread permanently dissolves fog within a 1-cell radius (Chebyshev distance $\le 1$) along its entire pull path.
  - **Lantern Plate (M604):** While any thread body cell rests on a brass Lantern Plate, all board fog transitions to 40% semi-transparency, revealing underlying geometries (threads remain tap-locked until fog is cleared).
  - **Decoy Fluff (M602) & Painted Wall (M603):** Transient illusions that dissolve upon direct thread interaction.

### 2. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Player unravels an active thread.
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):** M007, M017, M031, M253, M353 decrement.
- **Step 4 (Reveal & Scouting Resolution):**
  1. Scout Thread (M601) exit triggers 1-cell radius permanent fog clearance.
  2. Decoy Fluff (M602) touched by an unraveling thread body instantly poofs and vanishes.
  3. Painted Wall (M603) crossed by a thread converts into a transparent chalk outline.
  4. Lantern Plate (M604) evaluates occupied/unoccupied state, updating board-wide fog opacity (40% vs 100%).
- **Step 5 (Gates & Clasps Update):** Update color gates, clasps, and locks.
- **Step 6 (Heart Loss & Shield Resolution):** Evaluate collisions or snag hazards.
- **Step 7 (Win / Loss Evaluation):** Check remaining threads and board clearance.

### 3. Solver Integration (IDA*)
- In the IDA* puzzle solver:
  - Hidden cells are tracked with visibility bitboards.
  - Solver enforces the 0-hearts solvable invariant: valid visible moves must always exist without requiring random guessing or blind taps under fog.
  - Deductive branching ensures a strictly deterministic unravel order from initial visible Scout Threads to full board clearance.

## Affected Files
- `packages/puzzle_core/lib/src/models/hidden_info_state.dart` (to be created: fog and reveal state model)
- `packages/puzzle_core/lib/src/logic/hidden_info_controller.dart` (to be created: reveal resolution and fog grid logic)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: fog visibility heuristics and search pruning)
- `packages/puzzle_core/lib/src/generator/level_generator.dart` (changed: placement of fog clusters, scout paths, and lantern plates)

## Risks and Open Questions
- **Risk:** Players feeling frustrated by blind snags if fog conceals blocking ruler obstacles.
  - *Mitigation:* Generator guarantees that no invisible obstacle can cause a snag unless an unrevealed thread was illegally forced, and visible clues/peeks indicate trajectory clearance.


Source docs: phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md, phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.17. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Gameplay — Phase 14 Signature System: Mirror Worlds (Looking-Glass Quilt)

## Status
Draft

## Type
New Feature

## Goal
Specify the Looking-Glass Quilt mirror symmetry dynamics, twin thread synchronized unraveling, inverse movement rules, and step tick integration for Yarn Unravel Phase 14 (Levels 6501–7000).

## Current State
Design documented in `phase/phase_14/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md` and `phase/phase_14/01_PHASE_14_SCOPE_AND_RULES.md`, not yet implemented.
- Prior phases allowed threads to unravel independently as single entities.
- Phase 14 introduces Mirror Worlds (Looking-Glass Quilt), where reflection axes (Mirror Seam M651) bisect the crafting board, pairing symmetrical threads that pull simultaneously or inverse threads that translate oppositely.

## Proposed Change
Implement the Mirror Worlds system within `packages/puzzle_core`:

### 1. Mirror Reflection Dynamics & Rules
- **Reflection Axes (Mirror Seam M651):**
  - A silver stitched seam situated at the vertical ($x = W/2$) or horizontal ($y = H/2$) centerline.
  - Symmetrical threads across the seam are paired as "Twin Pairs".
  - Tapping either twin initiates a synchronized pull: both threads advance simultaneously toward their respective board exits.
  - **Collision & Snag Rule:** If either thread encounters a blocker or obstacle, both threads snag immediately, spring back, and deduct exactly **-1 Heart** total (not double penalty).
- **Reflect Clasp (M652):**
  - A pair of linked clasps reflected across the seam.
  - When the player unlocks one clasp with a key, its mirrored twin unlocks immediately without requiring a second key.
- **Twin Quilt (M653):**
  - Symmetrical toggle switches; toggling one side mirrors state changes across the seam.
- **Inverse Thread (M654):**
  - Contra-directional thread linked to a primary thread; when the primary moves in direction $D$, the inverse thread travels in $\text{opposite}(D)$.

### 2. Move Resolution Tick Order Integration
Per `SHARED_CORE_STANDARD.md` §16.17:
- **Step 1 (Action Resolve):** Player unravels an active thread.
- **Step 2 (Move Count):** `moveCount += 1`.
- **Step 3 (Counters Tick):** Periodic counters decrement.
- **Step 4 (Mirror & Inverse Resolution):**
  1. Synchronized twin threads advance in parallel across the mirror seam.
  2. Inverse threads advance 1:1 in the exact opposite direction ($\text{opposite}(D)$).
- **Step 5 (Clasps & Gates Update):**
  1. Reflect Clasps (M652) unlock pairwise upon key application.
  2. Twin Quilt toggles synchronize mirror states.
- **Step 6 (Heart Loss & Shield Resolution):** Evaluate collisions; twin collisions incur a single -1 Heart penalty.
- **Step 7 (Win / Loss Evaluation):** Check remaining threads and board clearance.

### 3. Solver Integration (IDA*)
- In the IDA* puzzle solver:
  - State representation binds twin thread IDs into single dual-action moves.
  - Symmetrical pruning exploits geometric reflection to reduce search branching.
  - Solvability verification guarantees that twin pulls never create mutual deadlocks where each blocks the other's exit.

## Affected Files
- `packages/puzzle_core/lib/src/models/mirror_pair.dart` (to be created: twin thread binding model)
- `packages/puzzle_core/lib/src/logic/mirror_controller.dart` (to be created: synchronized pull and collision resolver)
- `packages/puzzle_core/lib/src/solver/ida_star_solver.dart` (changed: twin move branching and symmetry reduction)
- `packages/puzzle_core/lib/src/generator/level_generator.dart` (changed: symmetrical board layout generation)

## Risks and Open Questions
- **Risk:** Confusion over whether touching an inverse thread moves it directly.
  - *Mitigation:* Clear visual cues (glass arrow directional marker on inverse threads) and explicit tutorial card at Level 6871.


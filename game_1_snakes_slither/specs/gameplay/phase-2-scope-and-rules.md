Source docs: phase_2/01_PHASE_2_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/level-progression-0001-0500.md.

# Spec: Phase 2 Scope & Rule Additions

## Status
Draft

## Type
Improvement (expands board geometry, input handling, and layer count from `specs/gameplay/core-concept-and-rules.md`)

## Goal
Define the scope and foundational rule additions for Phase 2 (Levels 501–1000), including pinch-zoom and pan navigation, 8-directional diagonal snake movement, three-layer boards, push physics fundamentals, sunbeams, and Remote Config rollout gating.

## Current State
Design documented in `phase_2/01_PHASE_2_SCOPE_AND_RULES.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 core rules from `specs/gameplay/core-concept-and-rules.md` remain intact (turn-based, 3 hearts, 1 ad revive per level, Heart Berry Refill 120 coins, 0-hearts solvable guarantee).
- Phase 1 boards were limited to 11x11 with auto-fit and strictly orthogonal directions (U, D, L, R) across at most 2 layers.
- Phase 2 introduces larger boards (up to 14x14) requiring gestures for zoom and pan, diagonal paths, and additional layers.

## Proposed Change
Extend `packages/puzzle_core` engine and Flutter game view to support Phase 2 rule additions:

### 1. Pinch-Zoom & Pan (Boards >= 12x12)
- **Activation:** Automatically enabled whenever `max(gridWidth, gridHeight) >= 12`. Smaller boards (10x10, 11x11) remain auto-fit with zoom disabled.
- **Initial State:** Starts at `fitScale` (entire board visible in viewport).
- **Gestures:**
  - 1-finger tap (slop <= 18 dp, < 350 ms): Triggers snake or interactive obstacle tap.
  - 1-finger long-press (>= 350 ms, slop <= 18 dp): Triggers Tongue-Flick Preview.
  - 1-finger drag (> 18 dp when zoomed in): Pans the camera (does not trigger moves).
  - 2-finger pinch: Scales the board around fingers' midpoint between `minScale` (`fitScale`) and `maxScale` (cell size = 48 dp).
  - 2-finger drag: Pans camera smoothly.
  - Double-tap: Explicitly ignored for zooming to prevent accidental game taps.
  - "Fit" button (HUD top-right): Animates camera back to `fitScale` over 250 ms.
- **Cell Size Rule:** Minimum cell size at `fitScale` is `fitCell >= 22 dp`. When `fitCell < 29 dp`, ambiguous tap guard prevents misclicks if two snakes are within 0.15 cell distance.

### 2. Diagonal Snake Movement (8 Directions)
- Introduces directions `UL`, `UR`, `DL`, `DR` (unlocked via M051 Sidewinder Snake).
- Snake bodies remain 8-connected.
- Diagonal lane step is blocked only if both orthogonal side cells belong to another snake's crossing diagonal link (validator rejects intersecting diagonal links).
- Orthogonal-only mechanics (Bamboo Ramps M014, Directional Vines M006) bounce diagonal snakes.

### 3. Three Layers (Ground, Canopy, Treetop)
- Expands layers from 2 to 3: Layer 0 (Ground), Layer 1 (Canopy M032), Layer 2 (Treetop M069).
- Taps prioritize the highest visible layer at the tapped coordinate.
- Boosters and hammers target the uppermost layer; hammer cannot target a path covered by higher layers.

### 4. Push Physics & Sunbeams Fundamentals
- Push blocks (Rolling Coconut M053) slide 1 cell forward if clear; falling off an open board edge removes the block.
- Sunbeams (M084–M089) cast persistent line-of-sight light rays across the board. Lanes entering unaligned beams or dark cells adhere to light rules.

### 5. Phase 2 Tick Order Integration (standard §16.17)
Resolution order per Move:
1. Action resolve (snake exit or interactive tap).
2. `moveCount += 1`.
3. Counters tick: Phase 1 counters -> Phase 2 counters (M057, M058, M063, M067, M068, M075, M079, M082, M090, M096).
4. Derived states (plates, beams, cages, locks).
5. Heart loss & shield absorb.
6. Win condition check.

### 6. Rollout & Remote Config Keys
- Gated behind Remote Config key `maxPhase`. When `maxPhase < 2`, Level 500 displays "More levels coming soon".
- Feature flags: `featureFlags.album`, `featureFlags.race`, `featureFlags.piggy`, `featureFlags.cosmetics`, `featureFlags.cloudSync`.

## Affected Files
- `packages/puzzle_core/lib/src/models/direction.dart` (changed to include 8 directions)
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` (changed to include Phase 2 tick sequence)
- `packages/puzzle_core/lib/src/engine/collision.dart` (changed for diagonal lane checks and 3 layers)
- `lib/features/gameplay/presentation/widgets/board_pan_zoom_container.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/hud_fit_button.dart` (to be created)

## Design
- Screen: Gameplay screen layout for boards >= 12x12.
- HUD components: Floating 🔍 "Fit" button in top-right corner; off-screen bump red chevron indicator (400 ms) when an off-screen obstacle is struck.
- Design tokens: Consistent with Phase 1 design tokens, touch slop 18 dp, max zoom cell target 48 dp.

## Risks
- Gesture conflicts between pan and 1-finger snake taps. Must strictly enforce the 18 dp slop threshold before canceling tap gestures.
- Performance on low-end devices during 2-finger pinch-zoom with 35+ active snakes.

## Open Questions
- None. All parameters, gestures, and limits are strictly bound by `SHARED_CORE_STANDARD.md` §17.1–§17.24.

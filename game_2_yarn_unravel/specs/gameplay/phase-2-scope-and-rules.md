Source docs: phase/phase_2/01_PHASE_2_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/level-progression-0001-0500.md.

# Spec: Phase 2 Scope & Rule Additions

## Status
Draft

## Type
Improvement (expands board geometry, camera gestures, thread directions, layers, push physics, and resolution tick order from `specs/gameplay/core-concept-and-rules.md`)

## Goal
Specify the core gameplay additions for Yarn Unravel Phase 2 (Levels 501–1000), including pinch-zoom and pan gestures for boards up to 14x14, 8-directional diagonal thread movement, three-layer boards, Bobbin Crate push mechanics, optical lamp beams vs lanes, and the extended 7-step Move resolution order.

## Current State
Design documented in `phase/phase_2/01_PHASE_2_SCOPE_AND_RULES.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 core rules from `specs/gameplay/core-concept-and-rules.md` remain intact (turn-based, 3 hearts, 1 ad revive per level, Heart Refill 120 coins max 2/attempt, 0-hearts solvable guarantee).
- Phase 1 boards were capped at 11x11 with fit-only view, strictly orthogonal directions (U, D, L, R), and at most 2 layers.
- Phase 2 introduces larger boards (up to 14x14) requiring gestures for zoom and pan, diagonal thread exit lanes, pushable crates, and optical light beams.

## Proposed Change
Extend `packages/puzzle_core` engine and Flutter game view to support Phase 2 rule additions:

### 1. Pinch-Zoom & Pan (Boards >= 12x12)
- **Activation:** Automatically enabled whenever `max(gridWidth, gridHeight) >= 12`. Smaller boards (10x10, 11x11) remain auto-fit with zoom disabled.
- **Initial State:** Starts at `fitScale` (entire board visible in viewport, 16 dp gutters). `fitCell = floor(min((screenW - 32) / W, availH / H))`.
- **Gestures:**
  - 1-finger tap (slop <= 18 dp, < 350 ms): Triggers thread or interactive obstacle tap.
  - 1-finger long-press (>= 350 ms, slop <= 18 dp): Triggers Thread Peek preview.
  - 1-finger drag (> 18 dp when zoomed in): Pans the camera (does not trigger moves; clamped to board edge + 24 dp).
  - 2-finger pinch: Scales the board around fingers' focal point between `scale = 1.0` and `maxScale = max(1.0, 48 / fitCell)` (zoomed cell max 48 dp).
  - 2-finger drag: Pans camera smoothly.
  - Double-tap: Explicitly ignored for zooming to prevent accidental thread taps.
  - "Fit" button (HUD top-right, spool icon): Animates camera back to scale 1.0 over 250 ms.
- **Cell Size Rule:** Minimum cell size at `fitScale` is `fitCell >= 22 dp` on 360 dp phones. When `fitCell < 29 dp`, enlarged hit slop (0.1 cell outside board edge) prevents misclicks.
- **Camera Follow:** Camera does NOT auto-pan during thread unraveling to prevent motion sickness; off-screen exit displays a directional arrow cue at the viewport edge.

### 2. Diagonal Thread Movement (8 Directions)
- Introduces directions `UL`, `UR`, `DL`, `DR` (unlocked via M051 Bias-Cut Thread at Level 511).
- Thread bodies in Phase 2 may be 8-connected (consecutive cells king-move adjacent).
- **No-Crossing Rule:** Validator rejects intersecting diagonal links within the same 2x2 cell quadrant.
- **Squeeze Rule:** A diagonal lane step `(x, y) -> (x+1, y+1)` is blocked only if both side cells `(x+1, y)` and `(x, y+1)` contain consecutive segments of the SAME thread. If side cells belong to different threads or obstacles, the needle squeezes through.
- **Orthogonal Obstacles vs Diagonal Lanes:**
  - Directional Stitch Arrow (M006) and Spinning Arrow (M058) bounce diagonal lanes (snag).
  - Hook Deflector (M014), Vanity Mirror (M086), and Thread Guide Switch (M018) act as solid blockers to diagonal lanes (snag).
  - Pompom Tunnels (M008/M076) continue diagonal lanes along the same `dir`.
  - Chunky Chenille (M024) is strictly forbidden from being diagonal.

### 3. Three Layers (Lining, Fabric, Tulle)
- Expands layers from 2 to 3: Layer 0 Lining (bottom), Layer 1 Fabric (middle), Layer 2 Tulle (top, M069).
- Threads are locked whenever covered by any segment of a thread on a higher layer index.
- Taps prioritize the uppermost layer at the tapped cell.
- Golden Scissors cannot target a thread that is covered by a higher layer.
- Layer transitions occur exclusively via Pleat Ramp (M056).

### 4. Push Physics (Bobbin Crate Family)
- When a thread's pull lane encounters a Bobbin Crate (M053) as the first non-passable entity:
  - If the space directly behind the crate along the lane vector is free: crate shifts 1 cell forward. Thread stays stationary; Move count increments by 1; no Heart loss.
  - If the space behind is blocked: thread snags (-1 Heart).
  - Free space definition: within board bounds, no thread on the crate's layer, and no obstacle (except floor types: Foot Pedal Plate M019, Satin Glide Patch M054, Crate Dock Plate M055, Worn Fabric Patch M067, Feed Dog Belt M082, Heavy Treadle Plate M083).
  - Push off open board edge: crate falls off and is removed (§17.29). Pushing into a walled edge (Hem Wall M029, closed Zipper Edge M031, Center-Only Exit M078) results in a snag (-1 Heart).
  - Satin Glide Patch (M054): crate continues sliding across consecutive ice glide patches until hitting a non-glide cell.

### 5. Beams vs Pull Lanes
- Sewing Lamp Emitter (M084) casts persistent orthogonal light beams on its layer.
- Beams pass through empty cells, floor plates, open gates, and baskets, but stop at thread bodies, blockers, closed gates, Bobbin Crates, emitters, and tunnels.
- Vanity Mirror (M086) redirects beams 90°; Crystal Bead Prism (M089) splits beams into two orthogonal rays.
- Beams are evaluated during Move tick step 4 and level load. Beam cells act as lane blockers (crossing a beam results in a snag). Beams themselves deal no damage.

### 6. Phase 2 Extended Move Resolution Order (standard §16.17)
Per Move resolution steps:
1. **Action resolve:** Evaluate lane on pre-move state (diagonals, squeeze, portals, push, dye pots) -> Exit / Snag / Push / Interactive toggle. Exit triggers activate on exit/relocate only. Snag moves trigger no lane effects.
2. `moveCount += 1`.
3. **Counters tick in exact order:** M007 -> M017 -> M031 -> M025 + M098 (Guardian step) -> M027 -> M047 -> M041 -> M057 -> M058 -> M063 -> M067 -> M068 -> M075 -> M079 -> M082 -> M090 -> M096.
4. **Derived states recomputed:** Plates (M019, M055, M083), light beams (M084, M086, M089), receivers (M085), cages, Master Jewel Clasp (M099).
5. **Heart loss:** (Thimble Shield absorbs first).
6. **Win check:** All threads exited + goals met (Sequins M026, Sorting Hem M062 quotas).
7. **Zero-heart check:** Triggers Second Chance popup.

### 7. Rollout & Remote Config Keys
- `maxPhase` (integer, default 1, set to 2 for Phase 2).
- `zoom_min_board_dim` (default 12).
- `zoom_max_cell_dp` (default 48).

## Affected Files
- `packages/puzzle_core/lib/src/models/board.dart` (changed: add 3 layers, diagonal directions)
- `packages/puzzle_core/lib/src/models/thread.dart` (changed: 8-connected body support)
- `packages/puzzle_core/lib/src/logic/move_resolver.dart` (changed: 7-step tick pipeline, push, beams)
- `packages/puzzle_core/lib/src/logic/beam_evaluator.dart` (to be created: optical light ray tracing)
- `lib/features/gameplay/view/board_gesture_detector.dart` (to be created: pinch-zoom, pan, slop clamp)
- `lib/features/gameplay/view/fit_button.dart` (to be created: animated return to auto-fit)

## Risks
- Gesture ambiguity between 1-finger drag (pan) and long-press (Thread Peek). Mitigated by strict 18 dp slop check before peek timer expires.
- Performance drops during 2-finger pinch on low-tier devices with 40 threads. Mitigated by keeping static layer cached in a `Picture` and scaling the viewport matrix.

## Open Questions
None. All rules match `SHARED_CORE_STANDARD.md` and Phase 2 design docs.

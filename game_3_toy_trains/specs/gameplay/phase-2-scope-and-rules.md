Source docs: phase/phase_2/01_PHASE_2_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/level-progression-0001-0500.md.

# Spec: Phase 2 Scope & Rule Additions (Toy Trains)

## Status
Draft

## Type
Improvement (expands board geometry, camera gestures, train directions, and layer count from `specs/gameplay/core-concept-and-rules.md`)

## Goal
Define the scope and foundational rule additions for Phase 2 (Levels 501–1000) of Toy Trains: Wooden Railway Puzzle, including pinch-zoom and pan on 12x12–14x14 boards, 8-directional diagonal train movement, three-layer boards (Triple-Deck Viaduct), push physics (Push Carts, Frosty Rails), signal light beams vs lanes, and the extended Phase 2 turn tick sequence.

## Current State
Design documented in `phase/phase_2/01_PHASE_2_SCOPE_AND_RULES.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 core rules from `specs/gameplay/core-concept-and-rules.md` remain intact: turn-based logic, 3 hearts, 1 ad revive per level, Heart Refill 120 coins (max 2/attempt), 0-hearts solvable guarantee, deterministic turn pipeline, free Route Peek long-press (>= 350 ms).
- Phase 1 boards were capped at 11x11 (cell >= 29 dp on 360 dp screens) with zoom disabled and strictly orthogonal directions (`U, D, L, R`) across 2 layers.
- Phase 2 introduces larger boards (12x12 up to 14x14) requiring pinch-zoom and pan, diagonal train movement, three elevation layers, push cart dynamics, and signal light optics.

## Proposed Change
Extend `packages/puzzle_core` engine and Flutter game presentation layer to support Phase 2 rules:

### 1. Pinch-Zoom & Pan (Boards >= 12x12)
- **Activation:** Enabled automatically when `max(gridWidth, gridHeight) >= 12`. Smaller boards (10x10, 11x11) remain auto-fit with zoom disabled (`fitCell >= 29 dp`).
- **Scale Range:** Starts at `fitScale` (1.0, entire board visible with 16 dp screen gutters). Min scale = 1.0 (no zooming out beyond fit). Max scale = `48 dp / fitCell` (e.g. ~2.05x on 14x14).
- **Gestures:**
  - 1-finger tap (slop <= 8 dp, < 350 ms): Triggers train tap or interactive railway cell.
  - 1-finger long-press (>= 350 ms, slop <= 8 dp): Triggers Route Peek path preview.
  - 1-finger drag (slop > 8 dp when scale > 1.0) or 2-finger drag: Pans camera. Cancels pending tap or long-press if slop is exceeded.
  - 2-finger pinch: Scales board centered on focal point between fingers.
  - Double-tap: Explicitly ignored to prevent accidental train departure taps.
  - Zoom and pan do not increment Move count or trigger counter ticks.
- **HUD Controls & Edge Indicators:**
  - "⤢ Fit" button on HUD (top-right, visible only when scale > 1.0) animates camera back to 1.0 over 250 ms.
  - Camera never auto-pans during normal train moves or buffer clack bumps.
  - Exception: Green Signal Hint (Hint) target outside viewport smoothly centers target over 300 ms before playing hint highlight.
  - Route Peek extending past the viewport renders an edge arrow chip: `"Track continues →"`.
  - Off-screen urgent counters (e.g. Alternating Signal with 1 move remaining) display a subtle pulsing indicator dot on the screen edge.

### 2. Diagonal Train Movement (8 Directions)
- From M051 Diagonal Express (L511), engine directions expand to 8 vectors:
  - Orthogonal: `U` (0,-1), `D` (0,1), `L` (-1,0), `R` (1,0).
  - Diagonal: `UL` (-1,-1), `UR` (1,-1), `DL` (-1,1), `DR` (1,1).
- Carriages follow the engine along 45° and 90° polyline joints.
- **Coupling-cross rule:** A diagonal train step is blocked if and only if both orthogonal corner cells are occupied by consecutive cars of the same crossing train (prevents cutting through connected wooden carriage couplings). Intersecting independent tracks are handled by standard clearance rules.
- Orthogonal-only mechanics (M006 Directional Track, M014 Track Ramp, M018 Track Switch) bounce diagonal trains. M024 Wide Load is never diagonal.
- 90° CW rotation transforms: `U->R->D->L->U` and `UR->DR->DL->UL->UR`.

### 3. Three Layers (Triple-Deck Viaduct)
- Expands layers from 2 to 3:
  - Layer 0: Ground level tabletop track.
  - Layer 1: Mid-level Viaduct Deck (M032).
  - Layer 2: Top-level Triple-Deck Viaduct (M069, L691).
- Taps prioritize the highest layer on the tapped coordinate.
- Boosters and Track Crane (Hammer) affect only the uppermost visible train or obstacle at coordinate.
- M056 Viaduct Ramp dynamically transfers an exiting train between layers along its exit lane.

### 4. Push Physics (Push Carts & Frosty Rails)
- **Push Cart (M053):** A 1-cell cart block. When an exit lane strikes a Push Cart, the cart is pushed 1 cell forward if the space behind is vacant. This counts as 1 Move, does not cost a heart, and the pushing train stays in place. If blocked behind, it triggers a normal buffer clack bump (-1 heart).
- **Frosty Rails (M054):** Frictionless rails. Pushing a cart onto Frosty Rails causes it to slide continuously until hitting another obstacle or board boundary.
- **Cart Weighbridge (M055):** Push Cart resting on weighbridge holds open linked railway gates.
- Track Crane (Hammer) can target Push Carts (hammerable: true).

### 5. Signal Lamp Light Beams vs Exit Lanes
- Signal Lamp (M084) casts persistent, continuous light rays across the board until occluded by a train or solid obstacle.
- Light beams are separate from train exit lanes:
  - Beams trigger Light Sensor Boxes (M085) to open gates.
  - Signal Mirrors (M086) reflect both beams and train lanes by 90° CW.
  - Crystal Prisms (M089) split a beam into dual perpendicular rays.

### 6. Phase 2 Turn Tick Sequence (standard §16.17)
Resolution pipeline on each Move:
1. Action resolution (train departure, push cart displacement, or interactive cell tap).
2. `moveCount += 1`.
3. Move counters tick in strict order:
   - Phase 1 counters: M007 Level Crossing, M017 Steam Whistle, M031 Clockwork Platform, M025 Patrol Train, M027 Shunting Signal, M047 Last Call Exit, M041 Inspection Draisine.
   - Phase 2 counters: M057 Alternating Signal, M058 Spinning Arrow Rail, M063 Magnet Post, M067 Worn Sleepers, M068 Smoke Trail Train, M075 Creeping Steam, M079 Spinning Playmat, M082 Conveyor Track, M090 Tick-Tock Gate, M096 Shadow Train.
4. Derived state update (plates, sensor boxes, light beams, gates).
5. Heart loss evaluation & Cowcatcher Shield absorption.
6. Win condition evaluation (all trains cleared).
7. If hearts == 0, trigger "Back on Track?" Second Chance popup.

### 7. Rollout & Remote Config Keys
- Gated behind Remote Config key `maxPhase`. When `maxPhase < 2`, Level 500 displays "More levels coming soon".
- Feature flags: `featureFlags.album`, `featureFlags.race`, `featureFlags.piggy`, `featureFlags.cosmetics`, `featureFlags.cloudSync`.

## Affected Files
- `packages/puzzle_core/lib/src/models/direction.dart` (changed: add 8-direction support and rotation vectors)
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` (changed: integrate Phase 2 counter list and push actions)
- `packages/puzzle_core/lib/src/engine/collision.dart` (changed: diagonal coupling-cross and 3-layer occlusion)
- `packages/puzzle_core/lib/src/models/layer.dart` (changed: layer 0, 1, 2 definitions)
- `lib/features/gameplay/presentation/widgets/board_viewport.dart` (changed: pinch-zoom and pan gesture handler)
- `lib/features/gameplay/presentation/widgets/hud_fit_button.dart` (to be created)

## Design
- Screen: Gameplay screen layout for boards >= 12x12.
- HUD components: Floating "⤢ Fit" icon button top-right (250 ms ease-out animation); Route Peek edge arrow chip ("Track continues →"); pulsing off-screen counter warning dot.
- Design tokens: Consistent with Phase 1 wooden toy theme, 8 dp touch slop, max zoom cell target 48 dp.

## Risks
- Gesture conflicts between pan drag and train taps on small screens. Mitigation: Strict 8 dp threshold; any finger movement beyond 8 dp cancels tap/long-press and transitions to pan.
- Frame drop during pinch-zoom on low-tier devices with 35+ trains. Mitigation: Render static table grid to cached picture during active gesture transforms.

## Open Questions
- None. All rules, gesture thresholds, and tick orders match `phase/phase_2/01_PHASE_2_SCOPE_AND_RULES.md` and `SHARED_CORE_STANDARD.md`.

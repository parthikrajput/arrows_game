Source docs: phase_2/01_PHASE_2_SCOPE_AND_RULES.md, SHARED_CORE_STANDARD.md. Depends on: specs/gameplay/core-concept-and-rules.md

# Spec: Phase 2 Scope and Gameplay Rule Extensions

## Status
Draft

## Type
Improvement

## Goal
Extend the Phase 1 core puzzle rules for Levels 501–1000, introducing pinch-zoom/pan navigation on grids up to 14x14, diagonal lines and lanes, the third Canopy layer, push physics, sunbeams, and updated tap priority for Ants & Bees: Garden Trails.

## Current State
Design documented in phase_2/01_PHASE_2_SCOPE_AND_RULES.md and SHARED_CORE_STANDARD.md.
- Extends `specs/gameplay/core-concept-and-rules.md`.
- Phase 1 limits: <= 11x11 grid, orthogonal directions only (`U, D, L, R`), 2 layers (Ground and Air).
- Phase 2 expands grid to 14x14, requiring zoom/pan navigation; introduces diagonal directions (`UL, UR, DL, DR`), a 3rd layer (Canopy at L691), push blocks, and sunbeams.

## Proposed Change
Implement the Phase 2 gameplay rules in `packages/puzzle_core`:

### 1. Invariants Carried from Phase 1
- Tap → Exit / Blocked → Bonk (-1 Heart).
- Turn-based deterministic forward simulation; zero wall-clock timer in puzzles (only 30s Golden Nectar Rush).
- Solvability guarantee: Every level solvable with 0 hearts lost and 0 boosters used.
- 3 Hearts per attempt; 1 rewarded ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, and free Scent Trail Preview retain identical pricing, caps, and mechanics.

### 2. Pinch-Zoom & Pan Engine (Grids >= 12x12)
- **Activation:** Enabled automatically when board width or height >= 12 cells.
- **Initial State:** Auto-fits the full board inside the viewport (`scaleFit`).
- **Zoom Range:** From `scaleFit` up to a maximum where cell size = 48 dp.
- **Gestures:**
  - 2-finger pinch: Scales board centered on pinch focal point.
  - 1-finger drag (when zoomed in): Pans board across viewport.
  - **Double-tap zoom is strictly disabled** (double-tap is interpreted as two standard single taps).
- **Touch Slop:** 18 dp movement threshold. Finger displacement > 18 dp initiates pan and cancels tap/preview.
- **Pan Clamping:** Board edges cannot pan more than 24 dp inside the viewport bounds.
- **HUD "Fit" Button:** Magnifying glass icon 🔍 in HUD triggers smooth 250 ms animation resetting zoom to `scaleFit`.
- **Accessibility:** Optional "+/−" zoom buttons toggleable in Settings for players unable to pinch.

### 3. Diagonal Directions & No-Cutting Rule (M051, L511+)
- **Directions:** Expands direction enum to 8 values: `U, D, L, R, UL, UR, DL, DR`.
- **Applicability:** Ant lines, bee lines, and canopy scout lines can all have diagonal directions.
- **No-Cutting Rule:** A diagonal step between cell $A$ and diagonal neighbor $B$ is blocked if both orthogonal shared corners contain consecutive body cells of the same line in the same layer. Traversing diagonally between two separate obstacles is permitted.
- **Device Interactions:** Orthogonal-only mechanics (Bamboo One-Way Tube M006, Curled Leaf Deflector M014) cause bonks if hit diagonally. Pinecone Bumper (M052) specifically reflects diagonal lanes.

### 4. Third Layer: Canopy Layer (M069, L691+)
- **Layer 2 (Canopy):** Introduces Canopy Scout Bees (`layer: 2`). Rendered with +12 dp vertical offset, distinctive emerald wing sheen, and high-altitude shadow.
- **Non-Collision:** Canopy bees do not collide with ground ants or mid-air worker bees.
- **Tall Obstacles:** `tall: true` obstacles block all flyers (both Air and Canopy layers).
- **Hierarchical Cover Lock:**
  - Canopy bee directly over mid-air bee locks the mid-air bee.
  - Mid-air bee directly over ground ant locks the ground ant.
- **Extended Tap Priority:** Interactive control > Canopy (Layer 2) > Air (Layer 1) > Ground (Layer 0).

### 5. Push Physics & Push Blocks
- **Rolling Acorns / Garden Pumpkins (M053):** Pushed 1 cell forward when hit by a marching ant or flying bee. Pushing into an empty cell advances the block; pushing into a wall or blocker causes a bonk.
- **Slick Leaves (M054):** Push block slides continuously across slick leaves until hitting dry ground or obstacle.
- **Socket Plates (M055):** Pushing a block into a matching socket locks it and deactivates linked bramble gates.

### 6. Sunbeams & Dew Prisms (L841+)
- Solar lenses project directional light beams across designated layers.
- Dew Prisms (M089) split white sunbeams into primary color rays.
- Sunlight Receivers (M085) deactivate blocking Royal Hive Doors when continuously illuminated.

## Affected Files
- `packages/puzzle_core/lib/src/engine/camera_transform.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/diagonal_path_rules.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/layer_rules.dart` (to be modified)
- `packages/puzzle_core/lib/src/mechanics/push_block_mechanics.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/sunbeam_mechanics.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/render/board_gesture_detector.dart` (to be created)

## Risks
- Pinch gestures might interfere with quick taps if touch slop threshold (18 dp) is tuned poorly.
- Diagonal raycasting must rigorously enforce the no-cutting rule to prevent lines visually phasing through corners.

## Open Questions
- None. Scope and rules are completely aligned with phase_2/01_PHASE_2_SCOPE_AND_RULES.md.

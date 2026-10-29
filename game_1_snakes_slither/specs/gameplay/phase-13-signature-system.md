Source docs: phases/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md, phases/phase_13/01_PHASE_13_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §16.5, §16.17, ../../SCALING_TO_10000_LEVELS.md §6. Depends on: specs/gameplay/phase-12-signature-system.md.

# Spec: Gameplay — Phase 13 Signature System (Mystery Mists: Hidden Info)

## Status
Draft

## Type
New Feature

## Goal
Implement the Mystery Mists (Hidden Info & Fog-of-War) signature system for Phase 13 (Levels 6001–6500), incorporating deterministic visibility grids, permanent scout clearing, trick mist respawning, optical false walls, and pressure plate illumination while strictly enforcing the Zero-Guessing Fairness standard.

## Current State
Design documented in `phases/phase_13/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md`, `phases/phase_13/01_PHASE_13_SCOPE_AND_RULES.md`, and `SCALING_TO_10000_LEVELS.md` §6, not yet implemented.
- Previous phases operated with complete board visibility from level start.
- Phase 13 introduces partial fog-of-war where cell properties and passage obstacles are occluded until revealed by scouting entities, tactile plates, or long-press tongue-flick previews.

## Proposed Change
Implement the fog and visibility architecture within `packages/puzzle_core/lib/src/systems/phase_13/`:

### 1. Fog-of-War & Visibility Grid Architecture
```
[FOG COVERED REGION] 
~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
[M601 SCOUT GECKO] ---> (Slithers out -> Permanently clears 1-cell radius fog)
~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
[M603 FALSE WALL]  ---> (Appears as wall, but Tongue-Flick Preview shows path through)
[M604 GLOW STONE]  ---> (Snake on plate -> Temporarily reveals 3x3 surrounding cells)
```
1. **Cell Visibility State Matrix:**
   ```dart
   enum CellVisibility { hidden, scouted, permanentlyRevealed }
   ```
   - `hidden`: Tile type and surface modifiers are veiled under shifting fog sprites.
   - `scouted`: Temporarily unveiled while an M604 Glow Stone is held down by a resting snake.
   - `permanentlyRevealed`: Irrevocably cleared by M601 Scout Gecko transit; immune to subsequent mist respawning.
2. **Zero-Guessing Fairness Principle (Standard §16.5):**
   - Pure guessing is strictly prohibited in algorithmic puzzle design.
   - **Tongue-Flick Preview ($\ge 350\text{ ms}$):** Long-pressing any snake casts a raycast trajectory probe forward.
   - If an impassable obstacle lurks in the fog, the preview renders a red bounce dot at the collision point.
   - If an apparent obstacle is an M603 Painted Wall (False Wall), the preview line cleanly penetrates the wall with a golden shimmer, revealing the passable truth prior to committing a move.
3. **Zero Damage & Head-Bonk Safety:**
   - Slithering into an un-scouted obstacle never costs hearts or results in game over. The snake bumps harmlessly, reveals the obstacle cell, and snaps back to its starting coordinate (0 hearts lost).

---

### 2. Engine Tick Integration (§16.17)
```
Step 1: Player Input Preview -> Long-press calculates raycast through fog and M603 Painted Walls
Step 2: Player Tap Input -> Active Snake Selection & Slither Execution
Step 3: In-Transit Evaluation:
        - Snake body crosses floor tiles
        - Update M604 Glow Stones: If covered -> set 3x3 surrounding cells to 'scouted'
Step 4: Board Exit Detection:
        - If Scout Gecko (M601) exits -> Mark entire traversed lane + 1-cell radius as permanentlyRevealed
        - If Regular Snake exits -> Vacated cells not permanentlyRevealed re-cloak under M602 Trick Mist
Step 5: Refresh Visibility Grid & Update GPU fog alpha texture buffer
Step 6: Board Settled -> Ready for Next Turn.
```

---

### 3. Interaction Matrix with Earlier Systems
- **M551 (Wind Levers):** When gravity shifts, falling fruits plunge through fog. If a fruit lands in a hidden cell, it creates an impact thud and temporarily reveals its resting tile.
- **M501 (Vine Bridges):** Fog can cover bridge entrances; bridgeheads become scouted when reached by a snake's tongue probe.
- **M452 (Totem Pattern Lock):** The totem pillar itself is always placed outside the fog boundary so required sequences are clearly visible at all times.
- **M351 (Wild Vines):** Vines growing into fog cells dissolve the fog on that cell upon sprouting.

---

### 4. Solver Guarantees & Generation Rules
1. **Deterministic Reachability:** Procedural levels guarantee that an M601 Scout Gecko is accessible within $\le 3$ moves without blind trials.
2. **Full Heuristic Awareness:** Headless A* solver has omniscient visibility of all hidden obstacles during CI offline validation, confirming that zero-booster, zero-damage solutions exist deterministically.

## Affected Files
- `packages/puzzle_core/lib/src/systems/phase_13/visibility_grid.dart` (to be created)
- `packages/puzzle_core/lib/src/systems/phase_13/fog_controller.dart` (to be created)
- `packages/puzzle_core/lib/src/systems/phase_13/tongue_flick_probe.dart` (to be created)
- `test/systems/phase_13_visibility_test.dart` (to be created)

## Risks and Open Questions
- **Player Perception of Fairness:** If players do not know about the $\ge 350\text{ ms}$ tongue-flick probe, fog puzzles could feel like trial-and-error. Tutorial Card P13-01 must explicitly mandate the long-press mechanic on Level 6001.

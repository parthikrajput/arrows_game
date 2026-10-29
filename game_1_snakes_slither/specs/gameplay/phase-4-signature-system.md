Source docs: phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md, phase_4/01_PHASE_4_SCOPE_AND_RULES.md, ../../SHARED_CORE_STANDARD.md §11, §12, §16.17, §17.24, §17.38. Depends on: specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md, specs/gameplay/phase-3-signature-system.md.

# Spec: Gameplay — Phase 4 Signature System (Great Tree Floors)

## Status
Draft

## Type
New Feature

## Goal
Implement the Phase 4 signature system "Great Tree Floors" (Multi-Floor): a multi-level stacked grid architecture supporting up to 3 floors (F1 Ground/Roots, F2 Trunk, F3 Canopy), floor viewing navigation tabs without move consumption, vertical lane traversal between floors, and camera auto-tracking.

## Current State
Design documented in `phase_4/03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md`, `phase_4/01_PHASE_4_SCOPE_AND_RULES.md`, and `SHARED_CORE_STANDARD.md` §11, not yet implemented.
- Phase 1 and Phase 2 supported 2D boards with up to 3 visual layers (Ground, Canopy, Treetop) on a single grid.
- Phase 3 introduced global Day & Night Cycles on a single board.
- There was no support for multiple stacked independent floor grids or inter-floor vertical connectivity.

## Proposed Change
Extend `packages/puzzle_core` with multi-floor board models, vertical lane graph routing, and floor state management:

### 1. Multi-Floor Architecture & Grid Stacking
- **Floor Hierarchy:** Up to 3 stacked grid planes per level:
  - `Floor 1 (F1)`: Giant Root Cavern (Ground / Roots)
  - `Floor 2 (F2)`: Tree Trunk
  - `Floor 3 (F3)`: Cloud Canopy Terrace (Canopy)
- **Grid Dimensions:** 12×12 to 14×14 per floor. Floors within the same level share identical coordinate bounds `[width, height]`.
- **Snake Distribution:** 28–40 total snakes ($P$) per level distributed across the 2 or 3 active floors.
- **Level JSON Schema v3 Extension:**
  ```json
  {
    "schema": 3,
    "level": 1501,
    "phase": 4,
    "floors": 2,
    "activeFloor": 1,
    "paths": [
      {"id": "p1", "color": "green", "dir": "R", "floor": 1, "body": [[3, 2], [2, 2], [1, 2]]}
    ],
    "mechanics": []
  }
  ```

### 2. Floor Viewing Navigation Rules (Standard §1)
- **Free Viewing Action:** Tapping the Floor Tabs (`[F1]`, `[F2]`, `[F3]`), zooming, or panning across floors is strictly an inspection action:
  - Does NOT increment `moveCount`.
  - Does NOT consume hearts or booster charges.
  - Does NOT trigger board ticks or cycle transitions.
- **Independent Board Rendering:** Each floor maintains its own cached static layer (`PictureRecorder`). Switching floors activates the target floor's dynamic layer without rebuilding unaffected static geometry.

### 3. Vertical Lane Continuity & Camera Auto-Tracking
- **Vertical Path Traversal:**
  - When a snake enters an inter-floor connector (M151 Root Stairs, M153 Knot Hole, M154 Vine Lift), its movement continues seamlessly onto the linked floor.
  - If the target cell or exit lane on the destination floor is obstructed, the move is invalid: the snake bumps on the origin floor and retreats to its initial position (−1 Heart Berry).
- **Smooth Auto-Pan:** When an active snake traverses across floors during an exit move, the camera smoothly pans to follow the snake to the destination floor (200 ms ease-out vertical slide).
- **Multi-Floor Silhouette Cue:** If a snake or interactive platform spans or reveals layers across floors (e.g., Dewglass M152 or Vine Lift M154), a subtle silhouette is visible on adjacent floors to maintain spatial awareness.

### 4. Turn Pipeline & Tick Order Integration (Standard §16.17)
Multi-floor transitions integrate into the standard move resolution cycle:
```
1. Action resolve:
   - Snake slithers along lane; if passing inter-floor connector, transitions to target floor.
   - Or interactive obstacle toggled (e.g., Vine Lift M154 changes floor).
2. moveCount += 1.
3. Move counters tick (periodic obstacles, countdowns, cycle counters).
4. Floor Transition Step:
   - If active snake moved between floors, camera executes auto-tracking slide to destination floor.
5. Derived states evaluated across all active floors (beams, plates, fog, cages, locks).
6. Heart loss & shields resolved.
7. Win condition check: Evaluated across ALL floors (all snakes on all floors must have exited).
```

### 5. Interaction with Earlier Systems
- **Phase 3 Cycles:** If Day & Night Cycles are active in a Phase 4 level, the cycle counter advances uniformly on each valid Move across all floors simultaneously.
- **Phase 2 Zoom/Pan:** Zoom level and camera slop settings persist seamlessly when switching between floors.
- **Boosters:**
  - Glow Firefly Hint: Points to the next valid snake regardless of which floor it resides on; auto-switches camera to that floor.
  - Magic Stone Hammer: Player can navigate to any floor to hammer an eligible obstacle.

## Affected Files
- `packages/puzzle_core/lib/src/models/multi_floor_board_state.dart` (to be created)
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` (updated to handle multi-floor transitions)
- `packages/puzzle_core/lib/src/models/board_state.dart` (updated to support `floor` attribute in paths and mechanics)
- `lib/features/gameplay/presentation/widgets/multi_floor_controller.dart` (to be created)

## Design
- Floating vertical tabs (`[F3]`, `[F2]`, `[F1]`) docked along the right viewport edge.
- Visual floor tinting to reinforce depth:
  - F1 (Roots): Deep earthen tones (`#EFEBE9`)
  - F2 (Trunk): Rich mossy bark (`#E8F5E9`)
  - F3 (Canopy): Ethereal sky terrace (`#E0F7FA`)

## Risks
- Disorientation when camera auto-switches floors during a fast snake slither. Mitigated by smooth 200 ms ease-out vertical transition and distinct floor tint cues.
- Player overlooking snakes on inactive floors. Mitigated by floor tab activity badges and win condition check requiring total clearance.

## Open Questions
- **OD-P4-01:** Floor switch transition: 200 ms vertical slide animation vs instant cut. (Decision: 200 ms ease-out vertical slide as default; instant cut under Reduce Motion).
- **OD-P4-02:** Cross-floor tail visibility: subtle semi-transparent silhouette on adjacent floors during Dewglass/Lift traversal.

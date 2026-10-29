Source docs: phase_2/06_FRONTEND_AND_QA_PHASE_2.md, ../../SHARED_CORE_STANDARD.md §13, §17.28. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Tech — Frontend Architecture & QA (Phase 2)

## Status
Draft

## Type
Improvement (extends client architecture from `specs/tech/frontend-implementation-and-qa.md` to support Phase 2 systems)

## Goal
Specify frontend rendering extensions for diagonal snakes, 3-layer depth ordering, sunbeam light optics, pinch-zoom viewport caching, 60 fps performance budgets for 40 snakes on low-tier hardware, staged rollout orchestration, and the Phase 2 QA test matrix.

## Current State
Design documented in `phase_2/06_FRONTEND_AND_QA_PHASE_2.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 frontend in `specs/tech/frontend-implementation-and-qa.md` supported up to 11x11 boards, orthogonal CustomPainter rendering, and at most 2 layers.
- Phase 2 requires rendering 14x14 boards with 40 snakes, 8 directions, sunbeams, zoom/pan transforms, and live sync services.

## Proposed Change
Extend the Flutter rendering pipeline and quality profiles in `lib/features/gameplay/`:

### 1. Viewport & Rendering Pipeline
- **`BoardViewport` (Zoom/Pan Controller):** Wraps board CustomPainter inside an optimized gesture detector. Enforces 18 dp touch slop before recognizing pan. Scales between `fitScale` and 48 dp per cell.
- **Layered Rendering Order:**
  1. *Background & Static Layer:* Board tiles, static obstacles, borders cached via `PictureRecorder` (re-recorded only on terrain mutation e.g. push blocks).
  2. *Ground Layer (Layer 0):* Stationary Ground snakes and Ground interactive mechanics.
  3. *Canopy Layer (Layer 1):* Canopy platforms (M032), translucent leaves, Canopy snakes.
  4. *Treetop Layer (Layer 2):* Treetop platforms (M069), high-altitude vines, Treetop snakes.
  5. *Optics / Sunbeams Layer:* Beams rendered using `BlendMode.plus` with dynamic ray casting.
  6. *Dynamic VFX Layer:* Single board `Ticker` drawing particles via `drawAtlas` and active slither animations.
  7. *HUD Overlay:* Moves, Hearts, Dial, Fit button, off-screen bump chevrons.

### 2. Diagonal & 8-Direction Path Drawing
- Extends snake body segment interpolation to support diagonal transitions (`UL`, `UR`, `DL`, `DR`).
- Prevents diagonal corner clipping by smoothing corner spline arcs through 8-connected body points.
- Pre-bakes soft drop shadows into snake sprite atlases; disables per-frame runtime `saveLayer` or `MaskFilter.blur`.

### 3. Performance Budget & Device Tiers
- **Frame Rate Target:** Stable 60 fps on low-tier Android devices (e.g. Redmi 9A, 2 GB RAM) with 40 active paths.
- **Raster Budget:** p95 frame raster time < 8 ms on mid-tier hardware.
- **On-Device Hint Solver (Phase 2):**
  - Uses node limit = 500k (expanded from Phase 1 50k to handle Phase 2 complex boards).
  - Time budget = 50 ms on background isolate.
  - If search exceeds budget, falls back gracefully to "Try Restart" toast without consuming the player's Hint booster.

### 4. Staged Rollout Strategy
1. App update ships with bundled `phase_2.json.gz` and code assets, but Remote Config default is `maxPhase = 1`.
2. Staged rollout schedule: 5% of users (Day 1) -> 20% (Day 3) -> 100% (Day 5).
3. Once crash-free user rate >= 99.5% and backend error rate < 0.5%, Remote Config updates to `maxPhase = 2`, unlocking Levels 501–1000 and LiveOps features globally.

### 5. Phase 2 QA Matrix (P0 Core Checks)
- **P0-1:** Pinch-zoom gesture does not consume moves or lose hearts.
- **P0-2:** Ambiguous tap guard prevents accidental selection when two snakes are close at fit-scale.
- **P0-3:** Diagonal snakes travel along designated 8-dir lanes without clipping adjacent obstacles.
- **P0-4:** Push blocks pushed into open board edges fall off cleanly and free the lane.
- **P0-5:** Sunbeam optics dynamically recalculate reflections upon mirror tap within 1 frame.
- **P0-6:** Star Race joins assign valid cohorts in matching timezone buckets without deadlocks.
- **P0-7:** Piggy Bank break credits wallet accurately via verified server transaction.
- **P0-8:** Offline play queues level clears and syncs idempotently when connectivity resumes.
- **P0-9:** In-app account deletion wipes local and remote data cleanly.

## Affected Files
- `lib/features/gameplay/presentation/painters/board_painter.dart` (changed to support 8 directions and 3 layers)
- `lib/features/gameplay/presentation/painters/sunbeam_painter.dart` (to be created)
- `lib/features/gameplay/presentation/widgets/board_viewport.dart` (to be created)
- `packages/puzzle_core/lib/src/solver/hint_solver.dart` (updated node limit to 500k)

## Risks
- Heavy memory consumption from three simultaneous cached layers on 2 GB devices. Addressed by invalidating off-screen layer pictures during extreme zoom.

## Open Questions
- None. Rendering, memory limits, and QA checklist match `phase_2/06_FRONTEND_AND_QA_PHASE_2.md`.

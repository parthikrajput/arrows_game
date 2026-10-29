Source docs: phase_2/06_FRONTEND_AND_QA_PHASE_2.md, SHARED_CORE_STANDARD.md. Depends on: specs/tech/frontend-implementation-and-qa.md

# Spec: Frontend Implementation, Viewport Engine, and QA Matrix (Phase 2)

## Status
Draft

## Type
Improvement

## Goal
Specify the Phase 2 frontend architecture enhancements, including multi-layer viewport scaling, extended BLoC modules, sunbeam rendering pipelines, and the comprehensive QA validation checklist for Ants & Bees: Garden Trails.

## Current State
Design documented in phase_2/06_FRONTEND_AND_QA_PHASE_2.md and SHARED_CORE_STANDARD.md.
- Extends `specs/tech/frontend-implementation-and-qa.md`.
- Phase 1 supported fixed-scale 11x11 boards with 2 layers and local-only state management.
- Phase 2 expands boards to 14x14, requiring zoomable viewport transforms, 3-layer rendering with beam overlays, and 7 new state management cubits/blocs.

## Proposed Change
Implement the Phase 2 client architecture additions in `apps/ants_bees/lib/`:

### 1. New State Management Modules (BLoCs / Cubits)
- **`ViewportCubit`:** Manages matrix transformation, pinch focal scaling, pan offset clamping, and fit-to-screen animations.
- **`AlbumCubit`:** Evaluates milestone sticker unlocks, handles retroactive veteran grants, and volume reward distributions.
- **`RaceBloc`:** Manages weekly star race lifecycle, cohort matchmaking state, level completion telemetry, and reward claims.
- **`BankCubit`:** Tracks Golden Honeycomb Bank deposit accumulation, full-state alerts, and IAP unlock execution.
- **`WardrobeCubit`:** Manages cosmetic skin ownership, trial preview states, and equipment persistence across insect layers and boards.
- **`SyncCubit`:** Coordinates offline op queuing, connectivity state transitions, and background flush cycles.
- **`AccountCubit`:** Manages Firebase Auth states, provider linking flows, and credential conflict resolution dialogs.

### 2. Viewport Transform & Gesture Pipeline
- Implemented in `BoardViewport` widget utilizing interactive transformation matrices:
  - `scaleFit`: Base scale mapping full board within available viewport dimensions with 16 dp padding.
  - `maxScale`: Clamped to `scaleFit * (48 dp / cellFit)`.
- **Gesture Priority:**
  - Displacement $\le 18\text{ dp}$: Evaluated as tap or long-press preview.
  - Displacement $> 18\text{ dp}$: Engages viewport pan; cancels line tap and preview.
- **Inverse Matrix Hit Testing:** Touch coordinates are projected through the inverted transform matrix to resolve exact grid cells regardless of current zoom and pan offsets.

### 3. Rendering Pipeline Enhancements (3 Layers + Sunbeams)
- Multi-layer `CustomPainter` extended to 5 distinct drawing passes:
  1. **Pass 0:** Cached static background (lawn tiles, boundary edging).
  2. **Pass 1:** Ground layer (Ant lines, ground obstacles, push blocks, socket plates).
  3. **Pass 2:** Air layer (Worker Bee lines, mid-air obstacles, flying items).
  4. **Pass 3:** Canopy layer (Canopy Scout Bees at +12 dp offset, tall bramble tops).
  5. **Pass 4:** Sunbeam vectors (`BlendMode.plus`), laser prisms, and dynamic particles.

### 4. Phase 2 Performance Budgets (14×14 Boards, 40 Lines)
- **Frame Rate:** 60 fps stable on low-tier hardware; 120 fps on ProMotion displays.
- **Raster Thread Budget:** 95th percentile raster time $\le 8.5\text{ ms}$.
- **Memory Footprint:** Dart heap resident memory $\le 170\text{ MB}$ (with lazy-loaded cosmetic atlases).
- **Engine Resolution:** `MoveResolver.apply()` completes in $\le 1.2\text{ ms}$ on 14x14 boards.

### 5. Phase 2 QA Verification Matrix
| QA ID | Verification Test | Expected Criteria |
|---|---|---|
| **P2-QA-01** | Zoom gesture on $\ge 12\times 12$ boards | Smooth 60 fps pinch-zoom up to 48 dp cell limit. |
| **P2-QA-02** | Double-tap zoom lockout | Double-tap executes as two sequential taps, never zooming. |
| **P2-QA-03** | Diagonal no-cutting rule | Diagonal paths bonk when attempting to slice between consecutive body cells. |
| **P2-QA-04** | Canopy layer cover lock | Canopy bee locks mid-air bee; mid-air bee locks ground ant. |
| **P2-QA-05** | Push block sliding | Rolling Acorn slides continuously across Dew-Slick Lily Leaves. |
| **P2-QA-06** | Sunbeam reflection & splitting | Prisms split white beam into colored rays; mirrors reflect at 90°. |
| **P2-QA-07** | Offline op-log queuing | Level clears offline queue in Hive; sync automatically flushes on reconnection. |
| **P2-QA-08** | Race plausibility rejection | Clears faster than 250 ms/move are flagged and excluded from race counts. |
| **P2-QA-09** | Honeycomb Bank cap | Bank halts deposits at 1,000 coins; cracks open accurately upon ₹49 IAP. |
| **P2-QA-10** | L1000 Phase Finale solvability | Queen's Midsummer Jubilee passes CI solver with 0 hearts lost and 0 boosters. |

## Affected Files
- `apps/ants_bees/lib/features/gameplay/render/board_viewport.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/render/beam_painter.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/cubit/viewport_cubit.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/render/tap_resolver.dart` (to be created)

## Risks
- Concurrent rendering of 40 active lines and animated sunbeams on low-tier GPUs could drop frames if paths are not pre-compiled.

## Open Questions
- None. Frontend components and QA matrix correspond directly to phase_2/06_FRONTEND_AND_QA_PHASE_2.md.

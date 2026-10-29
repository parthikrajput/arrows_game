Source docs: phase/phase_2/06_FRONTEND_AND_QA_PHASE_2.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Tech — Phase 2 Frontend Implementation & QA Matrix

## Status
Draft

## Type
Improvement (extends Flutter presentation layer, CustomPainter rendering pipelines, CI level validator, and QA checklists from `specs/tech/frontend-implementation-and-qa.md`)

## Goal
Specify the frontend rendering and input additions for Yarn Unravel Phase 2 (viewport Matrix4 transformation, 8-directional thread path generation, beam rendering shaders, CI validator additions) and establish the comprehensive Phase 2 QA verification matrix.

## Current State
Design documented in `phase/phase_2/06_FRONTEND_AND_QA_PHASE_2.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 frontend in `specs/tech/frontend-implementation-and-qa.md` handled fixed-scale boards up to 11x11, orthogonal paths, and 2 fabric layers.
- Phase 2 requires smooth zooming and panning over 14x14 boards, 8-connected thread segment drawing, optical light beam shaders, and new LiveOps UI modules.

## Proposed Change
Extend the Flutter presentation layer and CI tools:

### 1. Viewport Matrix & Gesture Pipeline
- Implemented in `BoardGestureDetector` wrapping the puzzle canvas:
  - Uses `TransformationController` with a custom gesture recognizer separating 1-finger pans from 2-finger pinches.
  - Enforces minimum cell size `fitCell >= 22 dp` at scale 1.0 and maximum cell size 48 dp at `maxScale`.
  - Animates zoom-out to scale 1.0 upon tapping the HUD "Fit" button (duration 250 ms, curve `Curves.easeInOutCubic`).
  - Clamps pan offsets so the board edge never pans more than 24 dp inside the viewport boundaries.

### 2. CustomPainter Rendering Extensions
- **Static Layer (`StaticBoardPainter`):**
  - Cached into an offscreen `ui.Picture` via `PictureRecorder` on initial layout or board mutation.
  - Paints wooden frame, fabric background grid, floor plates (M019, M054, M055, M067, M082, M083), and stationary obstacles.
- **Dynamic Layer (`ActiveBoardPainter`):**
  - Driven by a single active `Ticker` when animations are in flight (thread unravel, crate slide, beam pulse).
  - **Diagonal Threads (M051):** Uses bezier curves (`quadraticBezierTo`) with fillet radius `cell * 0.35` across 45° angle transitions.
  - **Beams (M084–M089):** Rendered using `BlendMode.plus` with a central glowing core (`Colors.amberAccent`) and soft outer falloff drawn in a single batched pass.
  - **Three Fabric Layers:** Drawn in strictly ascending order: Layer 0 (Lining, full opacity), Layer 1 (Fabric, 0.95 opacity), Layer 2 (Tulle, 0.85 opacity with subtle fabric weave shader).

### 3. CI Level Validator Extensions (`tools/levelgen`)
The offline CI validator is extended with 6 mandatory Phase 2 validation rules:
1. **Diagonal No-Crossing:** Rejects any level where diagonal links of different threads intersect in the same 2x2 cell quadrant.
2. **Squeeze Rule Verification:** Ensures diagonal paths passing between obstacles adhere to single-thread side cell constraints.
3. **Beam Termination Guard:** Traces all light rays from emitters (M084, M087); aborts with error if a ray fails to terminate within 100 iterations (preventing infinite mirror loops).
4. **Crate Push Solvability:** State-space BFS/A* solver tracks crate coordinates and confirms all crates required for plates or exits can be pushed without deadlock.
5. **Three-Layer Lock Integrity:** Verifies that no cyclic lock dependencies exist across the 3 layers (Layer 0 cannot require an entity on Layer 2 that itself depends on Layer 0).
6. **Sub-Board Rotator Alignment:** Confirms that all Turning Quilt Frames (M079) operate on perfectly square grids (e.g. 4x4) and rotate without clipping board borders.

### 4. Phase 2 QA Verification Matrix
Checklist spanning all Phase 2 features across the Device Matrix (DM-1 low-tier, DM-2 mid-tier, DM-3 high-tier, DM-4 tablet):

| QA ID | Category | Description | Status |
|---|---|---|---|
| **QA-P2-01** | Gestures | Pinch-zoom scales board smoothly between 1.0 and 48 dp max cell size | Not run |
| **QA-P2-02** | Gestures | 1-finger pan drags board without triggering thread unravel or peek | Not run |
| **QA-P2-03** | Gestures | "Fit" HUD button animates viewport back to scale 1.0 within 250 ms | Not run |
| **QA-P2-04** | Gestures | Double-tap is ignored for zooming (does not trigger accidental tap) | Not run |
| **QA-P2-05** | Mechanics | M051 Bias-Cut Thread unrolls smoothly along diagonal lanes (UL, UR, DL, DR) | Not run |
| **QA-P2-06** | Mechanics | Squeeze rule allows diagonal thread to pass between two distinct obstacles | Not run |
| **QA-P2-07** | Mechanics | M053 Bobbin Crate pushes 1 cell forward if space is free; snags if blocked | Not run |
| **QA-P2-08** | Mechanics | Bobbin Crate falls off open board edge and is removed without error | Not run |
| **QA-P2-09** | Mechanics | M054 Satin Glide Patch accelerates pushed crate until hitting solid cell | Not run |
| **QA-P2-10** | Mechanics | M055 Crate Dock Plate lowers connected gate while occupied by crate | Not run |
| **QA-P2-11** | Mechanics | M069 3-layer stack correctly locks Layer 0 threads beneath Layer 2 tulle | Not run |
| **QA-P2-12** | Mechanics | M084 Sewing Lamp beam blocks intersecting thread lanes (triggers snag) | Not run |
| **QA-P2-13** | Mechanics | M086 Vanity Mirror redirects light beam and thread lane 90° | Not run |
| **QA-P2-14** | Mechanics | M089 Crystal Bead Prism splits incoming beam into two orthogonal rays | Not run |
| **QA-P2-15** | LiveOps | Scrapbook milestone stickers award upon first clear of every 10th level | Not run |
| **QA-P2-16** | LiveOps | Retroactive Scrapbook grant unlocks appropriate volumes on Phase 1 update | Not run |
| **QA-P2-17** | LiveOps | Volume completion modal awards exact Coins + cosmetic reward | Not run |
| **QA-P2-18** | LiveOps | Weekly Star Race joins 5-player cohort; ghost players populate after 10m | Not run |
| **QA-P2-19** | LiveOps | Star Race server rejects reports claiming > 1 star per 25 seconds | Not run |
| **QA-P2-20** | LiveOps | Knitted Piggy Bank stores 15% clear coins; breaks via ₹49 IAP at >= 300 coins| Not run |
| **QA-P2-21** | LiveOps | Wardrobe shop purchases thread skins and board themes with coins | Not run |
| **QA-P2-22** | Sync | Anonymous auth initiates silently on first online boot without blocking | Not run |
| **QA-P2-23** | Sync | Account link conflict modal shows side-by-side saves for explicit choice | Not run |
| **QA-P2-24** | Sync | Op-log flushes queued offline actions upon network reconnection | Not run |
| **QA-P2-25** | Perf | Low-tier reference device (DM-1) maintains 60 fps during active zoom on 14x14| Not run |

## Affected Files
- `lib/features/gameplay/view/board_canvas.dart` (changed: integrate Matrix4 transform)
- `lib/features/gameplay/view/painters/static_board_painter.dart` (changed: 3 layers)
- `lib/features/gameplay/view/painters/active_board_painter.dart` (changed: diagonal paths, beams)
- `tools/levelgen/bin/validate_phase2.dart` (to be created: Phase 2 CI validator)

## Risks
- Matrix4 canvas transformations introducing floating-point rendering artifacts or fuzzy lines on low-density displays. Mitigated by rounding transformed coordinates to nearest physical device pixel.

## Open Questions
None. QA IDs and test requirements match Phase 2 documentation.

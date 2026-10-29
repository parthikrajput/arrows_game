Source docs: ../../PERFORMANCE_OPTIMIZATION.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Performance Optimization and Device Budgets

## Status
Draft

## Type
New Feature

## Goal
Implement the performance architecture, on-demand Ticker loop, static layer caching, device tiering, adaptive visual scaling, and frame monitoring to guarantee smooth 60 fps gameplay on low-tier 2 GB RAM Android devices for Yarn Unravel.

## Current State
Design documented in ../../PERFORMANCE_OPTIMIZATION.md and phase_1/07, not yet implemented.
- Turn-based logic: when threads are stationary, the game loop produces 0 frames (~0% CPU load).
- Target device matrix: Low tier (Redmi 9A, 2 GB RAM), Mid tier (Galaxy A14 / Redmi Note 12), High tier (Pixel 8, Galaxy S23, iPhone 15 Pro).
- Target budgets: 60 fps on low-tier, raster p95 < 8 ms on mid-tier, peak memory <= 250 MB on low-tier, level load <= 150 ms.
- Quality scaling adapts particles, background animations, and screen shake by device tier.

## Proposed Change
Implement the rendering optimization, isolate threading, memory management, and monitoring services:

### 1. Performance Budgets
| Metric | Budget | Measurement Mechanism |
|---|---|---|
| Gameplay Frame Rate | **60 fps** on low-tier (Redmi 9A, 2 GB RAM) with 30 threads. **120 fps** on ProMotion / 120 Hz displays | `FrameTiming` monitor |
| Raster Time p95 | **< 8 ms** on mid-tier | `FrameTiming.rasterDuration` |
| Janky Frames | **< 1%** target during gameplay. **> 5% triggers `W-PERF-001`** | `FrameMonitor` callback |
| Static Layer Rebuild | <= 2 ms on mid-tier (executed once per Move commit) | Timeline event `static_rebuild` |
| Tap to Visual Response | <= 50 ms (3 frames at 60 Hz). > 200 ms triggers `I-SLOW-INPUT` | `InputTrace` timestamping |
| Hint Solver Latency | Isolate execution, capped at 50 ms or 50k nodes | Perf trace `hint_solve` |
| Level Load Latency | <= 150 ms target. > 1.5 s triggers `W-PERF-002` | Perf trace `level_load` |
| Peak Memory (RSS) | <= 250 MB on low-tier hardware | Android `dumpsys meminfo` / DevTools |
| App Download Size | <= 60 MB per-device download (AAB / thinned IPA) | Play Console / App Store Connect |
| Idle Board CPU | ~0% app CPU when board is static | System profiler |

### 2. Device Tiers & Adaptive Quality
- **Tier Detection:** Evaluated once at first boot via native channel (`isLowRamDevice()` or RAM <= 3 GB -> Low; 3–6 GB -> Mid; > 6 GB -> High) and saved to Hive `settings`.
- **Runtime Demotion:** If janky frames exceed 5% across the player's first 3 completed levels, the tier is automatically demoted (High -> Mid -> Low), logging `W-PERF-001` and `tier_demoted`.
- **Adaptive Quality Profiles:**
  - *Max Particles (win confetti, sparkles):* Low: 30, Mid: 80, High: 150.
  - *Background Ambient Animations (hearth glow, fluff tufts):* Low: Off (static), Mid: 30 fps tick, High: Full 60 fps.
  - *Path Idle Animations (thread wobble):* Low: Off, Mid: Only on tapped thread, High: All threads staggered.
  - *Screen Shake (snag bump):* Low: Off (haptic + red flash only), Mid: 4 dp shake, High: 6 dp shake.
  - *Sprite Atlas Scaling:* Low: 2.0x atlas on all displays; Mid/High: Native display DPR.
  - *Image Cache Cap:* Low: 48 MB, Mid: 96 MB, High: 160 MB.
- **Battery Saver Toggle:** Settings toggle forcing the Low quality profile regardless of hardware capabilities.

### 3. Rendering Pipeline Rules (`CustomPainter` + `Ticker`)
- **Static Board Layer (`PictureRecorder`):**
  - Renders wood frame, linen cloth, cross-stitch dots, static obstacles, and non-moving threads into a `ui.Picture`.
  - Rebuilt only when a Move is committed or board state mutates.
  - Static layer paints in < 0.5 ms per frame during idle display.
- **Dynamic Thread Rendering Optimization:**
  - Pre-bakes corner curves (`radius = cell * 0.35`) into cached `ui.Path` objects.
  - Unravel animation uses `PathMetric.extractPath(0.0, currentLength)` instead of regenerating curved paths every frame.
  - Twisted-ply texture uses pre-compiled `ImageShader` reused across all threads.
  - Round caps and joins drawn in a single continuous stroke pass.
- **Particle System Pool:**
  - Fixed pre-allocated particle array; 0 runtime heap allocations during gameplay.
  - Renders all particles in a single `canvas.drawAtlas` invocation.

### 4. Memory Management & Asset Unloading
- Asset atlases for Gameplay are loaded only during level entry and discarded upon return to Home.
- Sound effects pool loads uncompressed PCM samples into memory on level launch (total audio footprint <= 8 MB).
- Level repository loads compressed chunks on demand; unused tiers are garbage collected.

## Affected Files
- `apps/yarn_unravel/lib/services/performance_monitor.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/render/static_layer.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/render/vfx/particle_pool.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/render/yarn_stroke.dart` (to be created)

## Risks
- Curved bezier threads with twisted-ply shaders can exceed 8 ms raster time on old Mali-G52 GPUs if shader uniforms are rebuilt every frame.
- Static layer picture caching must be invalidated on viewport resize or system font scaling changes.

## Open Questions
- None. Performance budgets and tier criteria match PERFORMANCE_OPTIMIZATION.md.


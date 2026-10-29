Source docs: ../../PERFORMANCE_OPTIMIZATION.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Performance Optimization and Device Budgets

## Status
Draft

## Type
New Feature

## Goal
Implement the performance architecture, on-demand Ticker loop, static layer caching, device tiering, adaptive visual scaling, and frame monitoring to guarantee smooth 60 fps gameplay on low-tier 2 GB RAM Android devices.

## Current State
Design documented in ../../PERFORMANCE_OPTIMIZATION.md and phase_1/07, not yet implemented.
- Turn-based logic: when snakes are stationary, the game loop produces 0 frames (~0% CPU load).
- Target device matrix: Low tier (Redmi 9A, 2 GB RAM), Mid tier (Galaxy A14 / Redmi Note 12), High tier (Pixel 8, Galaxy S23, iPhone 15 Pro).
- Target budgets: 60 fps on low-tier, raster p95 < 8 ms on mid-tier, peak memory <= 250 MB on low-tier, level load <= 150 ms.
- Quality scaling adapts particles, background animations, and screen shake by device tier.

## Proposed Change
Implement the rendering optimization, isolate threading, memory management, and monitoring services:

### 1. Performance Budgets
| Metric | Budget | Measurement Mechanism |
|---|---|---|
| Gameplay Frame Rate | **60 fps** on low-tier (Redmi 9A, 2 GB RAM) with 30 snakes. **120 fps** on ProMotion / 120 Hz displays | `FrameTiming` monitor |
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
  - *Background Ambient Animations (swaying leaves, clouds):* Low: Off (static), Mid: 30 fps tick, High: Full 60 fps.
  - *Path Idle Animations (breathing, eye blink):* Low: Off, Mid: Only on tapped snake, High: All snakes staggered.
  - *Screen Shake (bump bonk):* Low: Off (haptic + red flash only), Mid: 4 dp shake, High: 6 dp shake.
  - *Sprite Atlas Scaling:* Low: 2.0x atlas on all displays; Mid/High: Native display DPR.
  - *Image Cache Cap:* Low: 48 MB, Mid: 96 MB, High: 160 MB.
- **Battery Saver Toggle:** Settings toggle forcing the Low quality profile regardless of hardware capabilities.

### 3. Rendering Pipeline Rules (`CustomPainter` + `Ticker`)
- **On-Demand Ticker (`BoardAnimator`):** Single `Ticker` per board. Automatically starts when a snake motion or particle is added; immediately stops when the animation queue is empty.
- **Static Layer Caching (`StaticLayerCache`):**
  - Grid cells, boundary hedges, obstacles, and stationary snakes are drawn once to a `ui.PictureRecorder`.
  - Rebuilt only when `board.staticVersion` increments (upon move execution, obstacle state change, or Hammer use).
  - Pre-baked soft drop shadows are rasterized into the static picture; per-frame `MaskFilter.blur` is strictly forbidden.
- **Dynamic Layer Rendering:**
  - Active frames paint only moving snakes, trail particles, and tongue-flick previews.
  - Snake segments are batched using `canvas.drawRawAtlas` reusing pre-allocated `Float32List` transform arrays.
  - Alpha transparency is applied using `Paint()..color = c.withValues(alpha: a)` (avoiding deprecated `withOpacity`).

### 4. Widget Tree Optimization (`flutter_bloc`)
- Board widget tree never rebuilds during move animations. `BlocBuilder` uses `buildWhen: (a, b) => a.board.staticVersion != b.board.staticVersion`.
- HUD elements (hearts, coins, moves, booster counts) are isolated using distinct `BlocSelector` widgets to prevent sibling rebuilds.
- Interactive board is wrapped in a `RepaintBoundary` to decouple board rasterization from HUD coin counter animations.
- Level Map virtualizes 500 nodes via `ListView.builder` with fixed item extents. Map opens directly via `jumpTo` without animating across hundreds of nodes.

### 5. CPU Work & Threading
- Rule execution: `puzzle_core.Engine.apply` runs synchronously on the main isolate (O(paths), <= 1 ms).
- Heavy tasks run strictly on background isolates via `Isolate.run`:
  - On-device Hint solver (50 ms / 50k nodes cap).
  - Level pack decompression and parsing (`phase_1.json.gz`).
  - Next-level prefetching initiated during Level Complete screen presentation.
- Synchronous file I/O on the main thread is strictly prohibited. Hive operations execute asynchronously; flush occurs on level win and app pause.

### 6. Asset & Memory Management
- UI assets compressed as WebP. Atlases constrained to <= 2048x2048.
- Large images decoded at target dimensions via `ResizeImage` / `cacheWidth`.
- Level-specific `ui.Image` and `ui.Picture` instances are explicitly disposed upon level exit.
- `onTrimMemory` / memory pressure events trigger `imageCache.clear()` and log `W-PERF-003`.
- Gujarati and Devanagari fonts subset with complete OpenType layout features preserved (`--layout-features='*'`).

### 7. In-App Frame Monitor (`FrameMonitor`)
- Listens to `SchedulerBinding.instance.addTimingsCallback` during active gameplay.
- Evaluates build and raster durations against the display refresh budget (16.6 ms at 60 Hz, 8.3 ms at 120 Hz).
- Level completion reports summary metrics (total frames, janky count, p95 raster microseconds).
- If jank exceeds 5%, logs warning `W-PERF-001` with tier attributes to Firebase Performance.

### 8. Performance QA Checklist
All items initialized with status **"Not run"**:
- PERF-01: Low-tier device (Redmi 9A), 30-snake level, 2 minutes continuous play: >= 60 fps, jank < 1%.
- PERF-02: Mid-tier device raster duration p95 < 8 ms.
- PERF-03: 120 Hz devices (iPhone 15 Pro, Pixel 8) achieve steady 120 fps during slither animations.
- PERF-04: Non-Vulkan Android device (OpenGL ES fallback) runs at steady 60 fps.
- PERF-05: Idle board for 60 seconds produces 0 frames in DevTools and ~0% CPU.
- PERF-06: Tap to visual response <= 50 ms.
- PERF-07: Static layer rebuild time per Move <= 2 ms.
- PERF-08: HUD coin update does not cause board repaint (RepaintBoundary verified).
- PERF-09: Rebuild counts verify 0 widget rebuilds outside HUD during gameplay taps.
- PERF-10: Level load from Map or Win <= 150 ms; never > 1.5s.
- PERF-11: Hint solver on hardest level completes in <= 50 ms or displays fallback toast without UI frame drops.
- PERF-12: Phase 3 level generation completes in <= 150 ms in background isolate.
- PERF-13: Cold start TTID <= 600 ms mid-tier / <= 1,200 ms low-tier.
- PERF-14: Level Map fling from node 1 to 500 maintains 60 fps with memory spike <= 30 MB.
- PERF-15: Memory leak test: 10 level plays and returns to Home returns RSS memory to baseline ± 10 MB.
- PERF-16: Peak memory on low-tier device <= 250 MB.
- PERF-17: Simulated memory pressure (`am send-trim-memory`) clears image cache, logs `W-PERF-003`, and does not crash.
- PERF-18: Download size of release AAB <= 60 MB.
- PERF-19: Win confetti on Low tier clamped to <= 30 particles with 0 frame jank.
- PERF-20: 30 minutes continuous play on mid-tier hardware results in <= 8% battery drain without thermal throttling.
- PERF-21: 20 rapid background/foreground toggles properly pause and resume tickers and audio.
- PERF-22: First frame following full-screen ad dismissal renders in <= 100 ms.
- PERF-23: Battery Saver toggle immediately enforces Low profile without altering rules.
- PERF-24: Forced jank triggers automatic runtime tier demotion after 3 levels.
- PERF-25: Gujarati and Hindi text at 2.0x scale renders without layout jank or broken conjuncts.
- PERF-26: Automated CI performance benchmark blocks PR if raster p90 regresses by > 10%.

## Affected Files
- `apps/snakes_slither/lib/features/gameplay/render/board_animator.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/render/static_layer_cache.dart` (to be created)
- `apps/snakes_slither/lib/services/perf/frame_monitor.dart` (to be created)
- `apps/snakes_slither/lib/services/perf/device_tier.dart` (to be created)

## Risks
- Thermal throttling during extended sessions: device demotion logic must handle hardware down-clocking gracefully.
- Shader compilation vs image decoding: all gameplay atlases must be pre-warmed before transitioning out of Home.

## Open Questions
- None. Performance budgets and device thresholds are governed directly by SHARED_CORE_STANDARD §13 and PERFORMANCE_OPTIMIZATION.md.

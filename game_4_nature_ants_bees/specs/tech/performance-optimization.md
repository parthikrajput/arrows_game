Source docs: PERFORMANCE_OPTIMIZATION.md, SHARED_CORE_STANDARD.md

# Spec: Performance Optimization, Device Tiers, and Rendering Budgets

## Status
Draft

## Type
New Feature

## Goal
Establish the rendering performance budgets, device tier profiles, on-demand ticking loop, particle pooling, and static background caching for Ants & Bees: Garden Trails Phase 1.

## Current State
Design documented in PERFORMANCE_OPTIMIZATION.md and SHARED_CORE_STANDARD.md, not yet implemented.
- 60 fps target on low-tier reference devices; 120 fps support on ProMotion displays.
- Idle board consumes 0 frames/sec (on-demand Ticker).
- Particle limits scaled across Low (30), Mid (80), and High (150) tiers.
- Heap budget capped at < 150 MB.

## Proposed Change
Implement the performance monitor, device tier manager, and rendering optimizations in `apps/ants_bees/lib/core/performance/`:

### 1. Device Tiers & Quality Profiles
| Tier | Criteria | Target FPS | Max Live Particles | Screen Shake | Ambient Motion |
|---|---|---|---|---|---|
| **Low** | <= 2 GB RAM, Android Go, or low-end SoC | 60 fps | 30 | Off (haptic + red flash only) | Static image |
| **Mid** | 3–4 GB RAM, mid-tier SoC | 60 fps | 80 | 4 dp shake | 30 fps subtle grass sway |
| **High**| >= 6 GB RAM, flagship SoC, 120 Hz displays | 120 fps | 150 | 6 dp shake | Full 60/120 fps grass & sunlight |

- **Battery Saver Mode:** User setting in Settings immediately forces the Low profile on any device hardware.
- **Dynamic Tier Demotion:** If 3 consecutive levels record > 5% dropped frames (via `FrameMonitor`), device tier drops by 1 tier (persisted in Hive).

### 2. On-Demand Ticker Loop
- The Flutter `Ticker` controlling puzzle animations is managed by `BoardAnimationController`.
- **Active State:** Ticker runs when:
  - An ant line is marching or bee line is flying.
  - A bonk squash and shake animation is playing.
  - Scent trail preview is being held.
  - Particles or floating coin texts are active.
- **Idle State:** When the animation queue empties, the ticker stops completely. The board remains rendered as a static raster. CPU and GPU usage drop to zero.

### 3. Rendering Pipeline Optimizations
- **Static Background Caching:** The 11x11 garden grass grid, cell corner dew drops, and soil rim are drawn into an offline `ui.Picture` via `PictureRecorder` upon board initialization. During gameplay frames, this cached picture is drawn in a single call.
- **Single `drawAtlas` Particle Batching:** All particles (pollen sparkles, win confetti, dust bursts) share one sprite sheet atlas and are drawn using a single `Canvas.drawAtlas()` call per frame.
- **Zero Expensive Shaders:** No runtime `BackdropFilter`, no per-frame `MaskFilter.blur`, and no `Canvas.saveLayer()` calls in the rendering path.
- **Alpha Blending:** Uses `Color.withValues(alpha:)` and `BlendMode.plus` for additive glow effects.

### 4. Memory & Resource Budgets
- **Dart Heap:** <= 150 MB resident heap memory.
- **Image Atlases:** Total loaded texture memory <= 30 MB (1 main game sprite atlas + 1 VFX atlas).
- **Raster Thread Budget:** 95th percentile frame raster time <= 8 ms on low-tier reference devices (ensures 16.6 ms frame budget is consistently met).

### 5. Automated Performance QA Checks
- **PERF-01:** Low-tier reference device maintains >= 59.5 fps average during full board multi-line clearance.
- **PERF-02:** Static board produces 0 frames over a 10-second idle measurement.
- **PERF-03:** Battery Saver mode immediately caps particle pools to 30 and disables camera shake.
- **PERF-04:** Startup time to interactive board <= target budgets specified in splash spec.

## Affected Files
- `apps/ants_bees/lib/core/performance/device_tier_manager.dart` (to be created)
- `apps/ants_bees/lib/core/performance/frame_monitor.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/render/board_animation_controller.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/render/cached_background_painter.dart` (to be created)

## Risks
- Memory leaks from uncollected particle pools or image handles if not properly disposed in `GameBloc.close()`.

## Open Questions
- None. Performance specifications and tier limits follow PERFORMANCE_OPTIMIZATION.md.

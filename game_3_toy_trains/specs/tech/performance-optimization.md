Source docs: ../../PERFORMANCE_OPTIMIZATION.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Performance Optimization and Device Tier Budgets (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Enforce 60 fps rendering budgets on low-tier Android hardware (Redmi 9A class), optimize memory footprint, implement dynamic quality tier scaling, and eliminate GPU jank for Toy Trains Phase 1.

## Current State
Design documented in ../../PERFORMANCE_OPTIMIZATION.md and phase_1/07, not yet implemented.
- Budget hardware (2 GB RAM, low-end GPU) suffers frame drops when unbounded particle effects or runtime filters are used.
- Need strict quality tiering where gameplay logic is 100% identical, but visual overhead scales adaptively.
- Static boards must consume 0 frames per second to preserve battery.

## Proposed Change
Implement the performance monitor, device tier detector, and optimized rendering practices across `apps/toy_trains/`:

### 1. Device Tiers & Quality Matrix
Hardware is classified at startup into Low, Mid, or High based on CPU core count, available memory, and OpenGL/Vulkan capabilities:
| Feature / Limit | Low Tier (Redmi 9A, 2 GB) | Mid Tier (Galaxy A14) | High Tier (Pixel 8 / S23) |
|---|---|---|---|
| **Frame Rate Target** | 60 fps (jank < 1%) | 60 fps (90 Hz display) | 120 fps |
| **Active Particles (Confetti/Sparkle)** | Max **30** | Max **80** | Max **150** |
| **Ambient Track Animations** | Off (static image) | 30 fps throttled | Full 60/120 fps |
| **Idle Train Wobble** | Off | Tapped train only | Staggered on all trains |
| **Exit Steam Trail** | Simple alpha fade | Particle puff trail | Volumetric steam puffs |
| **Buffer Clack Screen Shake** | Off (red flash + haptic only)| On (4 dp offset) | On (6 dp offset) |
| **Level Map Parallax** | Off | 2 layers | 3 layers |
| **Drop Shadows** | Pre-baked sprite shadows | Pre-baked | Pre-baked |

- **Battery Saver Mode:** When enabled in Settings, forces the Low quality profile regardless of hardware capabilities.
- **Reduce Motion Support:** Respects system accessibility setting and in-game toggle: disables all screen shake, camera pans, and explosive particle bursts.

### 2. Rendering Rules & GPU Guardrails
- **Zero Runtime Blurs:** No `BackdropFilter`, no `MaskFilter.blur`, and no per-particle `saveLayer` calls anywhere in the rendering tree.
- **Batch Particle Painting:** All particles (smoke puffs, sparks, confetti) are packed into a single texture atlas (`assets/vfx/atlas.webp`) and rendered via one `canvas.drawAtlas` invocation per frame.
- **Cached Tabletop Picture:** The oak playmat, peg dots, and track rails are recorded into an immutable `ui.Picture` and blitted directly, avoiding redundant canvas draws.
- **Modern Color API:** Strict enforcement of `Color.withValues(alpha:)` to prevent deprecated `withOpacity` allocation overhead.
- **On-Demand Ticker:** Ticker starts when an action is triggered and halts as soon as the last particle fades. Zero redraws occur during idle puzzle contemplation.

### 3. Dynamic Tier Demotion
- `PerformanceMonitor` records frame timings via `WidgetsBinding.instance.addTimingsCallback`.
- If 3 consecutive levels exhibit jank exceeding 5% (frames taking > 16.6 ms on 60 Hz), the game quietly drops one quality tier (e.g. Mid to Low) to maintain fluidity, logging warning `W-PERF-001`.

### 4. Memory Allocations & Budgets
| Tier | Heap RAM Ceiling | Textures in VRAM | Level Pack Decompress |
|---|---|---|---|
| **Low** | <= 150 MB | <= 40 MB | Streaming parse in isolate |
| **Mid** | <= 250 MB | <= 70 MB | Cached in memory |
| **High**| <= 400 MB | <= 120 MB| Full pre-warming |

### 5. Performance QA Matrix (PERF-01 to PERF-10)
- **PERF-01:** Low tier maintains 60 fps during L500 Grand Central Finale with multiple simultaneous animations.
- **PERF-02:** Static board yields 0 fps and 0% CPU consumption when idle.
- **PERF-03:** Confetti particle pool strictly clamps at 30 (Low), 80 (Mid), and 150 (High).
- **PERF-04:** Battery Saver toggle instantly transitions visual settings without interrupting gameplay.
- **PERF-05:** Rapidly tapping trains causes no memory spikes or uncollected animation objects.

## Affected Files
- `apps/toy_trains/lib/services/perf/performance_monitor.dart` (to be created)
- `apps/toy_trains/lib/services/perf/device_tier_service.dart` (to be created)
- `apps/toy_trains/lib/game/render/vfx/particle_pool.dart` (to be created)

## Risks
- Extreme thermal throttling on budget devices during extended play sessions; handled by proactive tier demotion.

## Open Questions
- None. Budgets and thresholds align with PERFORMANCE_OPTIMIZATION.md.

Source docs: phase/phase_3/06_UI_AND_QA_PHASE_3.md, ../../VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/ui/vfx-phase-2.md.

# Spec: UI — Phase 3 Visual Effects (VFX) & Juice

## Status
Draft

## Type
Improvement (extends VFX engine and particle pool mappings from `specs/ui/vfx-phase-2.md` for Phase 3 cycle shifts and base mechanics)

## Goal
Specify the particle effects, ambient lighting bursts, shader ripples, and haptic feedback for Phase 3 Day & Night Loom transitions and mechanics M101–M104 while adhering to strict device tier budgets.

## Current State
Design documented in `phase/phase_3/06_UI_AND_QA_PHASE_3.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Phase 2 in `specs/ui/vfx-phase-2.md` handled diagonal wakes, beam glow, and crate slide trails.
- Phase 3 introduces global atmospheric cycle shift effects and dynamic toggling for cycle gates, bridges, and portals.

## Proposed Change
Extend `VfxService` and `BoardAnimator` to support Phase 3 effect bindings:

### 1. Phase 3 Event VFX Mappings
Reuses standardized effect classes from `VFX_IMPLEMENTATION.md` §4:

| Event ID | Effect Class | Visual Look & Dynamics | Haptic Feedback |
|---|---|---|---|
| `cycle_shift_day_to_night` | `state_toggle` + `morph_flash` | Cool silver-blue glow ripple expanding across board canvas; loom dial clicks | `HapticFeedback.lightImpact()` |
| `cycle_shift_night_to_day` | `state_toggle` + `morph_flash` | Warm golden sunshine burst radiating outward from board center | `HapticFeedback.lightImpact()` |
| `m101_latch_toggle` | `state_toggle` | Wooden latch rotates 90° open/closed with 4 subtle sawdust particles | `HapticFeedback.selectionClick()` |
| `m102_bridge_toggle` | `lane_warp` | Golden thread loops arch upward or collapse into flat dark blocker | `HapticFeedback.selectionClick()` |
| `m103_pompom_active` | `portal_whoosh` | Luminescent wool fluff sparkles pulse around active night pompom rims | `HapticFeedback.lightImpact()` |
| `m104_eyelet_shift` | `morph_flash` | Eyelet bezel displays smooth 200 ms gradient color shift flash | `HapticFeedback.selectionClick()` |

### 2. Device Tier Budgets & Particle Limits
Adheres strictly to `PERFORMANCE_OPTIMIZATION.md` §3 constraints:

| Metric / Setting | Low Tier (DM-1) | Mid Tier (DM-2) | High Tier (DM-3) |
|---|---|---|---|
| **Max Live Particles** | **30** | **80** | **150** |
| **Cycle Radial Glow** | Disabled (flat tint) | 30 fps opacity fade | 60 fps smooth shader ripple |
| **Screen Shake** | 0 dp (disabled) | 4 dp on cycle shift | 6 dp on cycle shift |
| **Particle Mesh Quality** | Low-poly flat quads | Filtered sprites | High-res soft textured particles |

### 3. Accessibility & Reduced Motion Mode
- When `accessibility.reduceMotion` is active:
  - Radial sunshine and moonlight ripples are disabled.
  - Ambient board color shifts smoothly via a simple opacity fade (150 ms).
  - Latch and bridge transitions omit rotation tweens, snapping directly to target states.

## Affected Files
- `lib/features/gameplay/vfx/vfx_service.dart` (changed: register Phase 3 cycle event IDs)
- `lib/features/gameplay/vfx/effects/cycle_ripple_effect.dart` (to be created: radial glow ripple)
- `lib/features/gameplay/vfx/effects/pompom_glow_effect.dart` (to be created: night portal luminescence)

## Risks
- Radial cycle ripple overdrawing the entire 14×14 board causing frame drops on low-tier devices. Mitigated by disabling the ripple shader entirely on Low Tier (DM-1).

## Open Questions
None. Particle caps and effect classes conform to `VFX_IMPLEMENTATION.md`.

Source docs: phase/phase_4/06_UI_AND_QA_PHASE_4.md, ../../VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-3-vfx.md.

# Spec: UI — Phase 4 Visual Effects (VFX) & Multi-Floor Juice

## Status
Draft

## Type
Improvement (extends particle engine, camera tweening, and shader effects from `specs/ui/phase-3-vfx.md` for multi-floor vertical transitions)

## Goal
Specify the particle animations, vertical camera glide curves, floor transition shaders, and haptic feedback profiles for Yarn Unravel Phase 4 (M151–M154) across device performance tiers.

## Current State
Design documented in `phase/phase_4/06_UI_AND_QA_PHASE_4.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Phase 3 in `specs/ui/phase-3-vfx.md` handled single-canvas day/night color shifts and cycle ripples.
- Phase 4 introduces vertical camera glides and particle emissions traversing separate architectural floor planes.

## Proposed Change
Extend `VfxService` and `BoardAnimator` for Phase 4 events:

### 1. Phase 4 Event VFX Mappings
Reuses standardized effect classes from `VFX_IMPLEMENTATION.md` §4:

| Event ID | Effect Class | Visual Presentation & Dynamics | Haptic Feedback |
|---|---|---|---|
| `floor_switch` | `lane_warp` | 250 ms vertical camera glide with slight motion blur; background floor linen fades smoothly | `HapticFeedback.selectionClick()` |
| `m151_stair_traverse` | `lane_warp` | Steel spool stair spins with gleaming metallic highlight; needle emerges on target floor emitting 8 golden yarn sparkles | `HapticFeedback.lightImpact()` |
| `m152_organza_tap` | `morph_flash` | Radial silk ripple pulse (200 ms) across organza fabric when tapped; lower-floor thread glows upon unhooking | `HapticFeedback.selectionClick()` |
| `m153_drop_hole` | `dust_puff` + `lane_warp` | Thread slides into hole; 4 small wool tufts pop upward as thread lands on lower floor | `HapticFeedback.lightImpact()` |
| `m154_lift_operate` | `state_toggle` | Wooden bobbin platform slides vertically with mechanical cable tension shake and ratchet click | `HapticFeedback.mediumImpact()` |

### 2. Device Tier Budgets & Multi-Floor Rendering Optimization
Adheres strictly to `PERFORMANCE_OPTIMIZATION.md` §3 constraints:

| Tier | Active Memory Strategy | Max Particles | Screen Shake | Camera Glide Quality |
|---|---|---|---|---|
| **Low Tier (DM-1)** | Only active floor rendered; inactive floors culled completely from memory | **30** | 0 dp (disabled) | Simple vertical translation without motion blur |
| **Mid Tier (DM-2)** | Inactive floors cached as low-res static pictures | **80** | 4 dp on lift operate | Filtered 30 fps camera tween |
| **High Tier (DM-3)** | All 3 floors maintained active with real-time drop shadows | **150** | 6 dp on lift operate | Full 60 fps smooth glide with motion blur shader |

### 3. Accessibility & Reduced Motion Mode
- When `accessibility.reduceMotion` is true:
  - Vertical camera glides are eliminated; tapping an `F` tab switches floors instantaneously (0 ms tween).
  - Stair and drop-hole particle bursts are replaced with subtle 100 ms opacity cross-fades.

## Affected Files
- `lib/features/gameplay/vfx/vfx_service.dart` (changed: register Phase 4 event triggers)
- `lib/features/gameplay/vfx/effects/spool_stair_effect.dart` (to be created: stair traverse particle sparkle)
- `lib/features/gameplay/vfx/effects/drop_hole_effect.dart` (to be created: wool puff ejection)

## Risks
- Rapidly switching floor tabs repeatedly causing particle pool exhaustion or memory spikes. Mitigated by clearing active particle systems belonging to an inactive floor upon switch.

## Open Questions
None. Tier budgets and effect mappings conform to `VFX_IMPLEMENTATION.md`.

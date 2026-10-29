Source docs: phase/phase_12/06_UI_AND_QA_PHASE_12.md, ../../VFX_IMPLEMENTATION.md §4.4. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-12-ui-additions.md.

# Spec: UI — Phase 12 Visual Effects (VFX) & Haptics

## Status
Draft

## Type
New Feature

## Goal
Specify the gravity field ripple waves, wood-slide dust trails, button impact thumps, and haptic feedback mappings for Yarn Unravel Phase 12 (Levels 5501–6000) within strict device tier budgets.

## Current State
Design documented in `phase/phase_12/06_UI_AND_QA_PHASE_12.md`, not yet implemented.

## Proposed Change
Implement Phase 12 VFX and haptic mappings in `lib/core/vfx`:

### 1. Event Effect Mapping Catalog
Reuses established core effect classes from `VFX_IMPLEMENTATION.md`:

| Event | Effect Class | Visual Presentation | Haptic Feedback |
|---|---|---|---|
| `m551_gravity_shift` | `lane_warp` + `morph_flash` | Plumb bob pendulum swings; soft distortion wave sweeps across the entire canvas along the new gravity vector. | `HapticFeedback.mediumImpact()` |
| `m552_button_slide` | `spool_roll` | Wooden button accelerates along gravity path; trailing cloud of wood-dust motes and fabric friction sparks. | `HapticFeedback.selectionClick()` |
| `m552_button_impact` | `hammer_impact` | Button strikes wall or blocker; small radial wood chip burst with tactile wooden impact thump. | `HapticFeedback.lightImpact()` |
| `m554_weighted_shift` | `counter_pop` | Heavy wire thread translates 1 cell; subtle metallic glint along wire spine with sharp tactile tick. | `HapticFeedback.lightImpact()` |

### 2. Device Tier Particle & Shake Budgets

| Device Tier | Max Live Particles | Shake Intensity | Animation Curve & Motion |
|---|---|---|---|
| **Low Tier** | $\le 30$ particles | 0 dp (disabled) | Instantaneous 0 ms slide; simple dust puffs; 0 dp shake. |
| **Mid Tier** | $\le 80$ particles | $\le 4\text{ dp}$ | 200 ms linear slide animation; localized impact puffs; light screen shudder. |
| **High Tier** | $\le 150$ particles | $\le 6\text{ dp}$ | Full physics-driven pendulum inertia, trailing friction dust, layered haptics. |

### 3. Motion Accessibility
- When user enables **Reduce Motion**:
  - Screen shake is completely zeroed ($0\text{ dp}$).
  - Gravity shifts and sliding motions snap instantly (0 ms).
  - Ambient friction particles are suppressed.

## Affected Files
- `lib/core/vfx/effects/gravity_effects.dart` (to be created: gravity wave & slide particle systems)
- `lib/core/audio/haptics_service.dart` (changed: register Phase 12 gravity haptic triggers)

## Risks
- Cascading button collisions generating overlapping impact audio/haptics. Mitigated by debounce throttles (max 1 impact haptic per 100 ms).

## Open Questions
None. VFX and haptic mappings match Phase 12 documentation.

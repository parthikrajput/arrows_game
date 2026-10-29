Source docs: phase/phase_6/06_UI_AND_QA_PHASE_6.md, ../../VFX_IMPLEMENTATION.md §4.4. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-6-ui-additions.md.

# Spec: UI — Phase 6 Visual Effects (VFX) & Haptics

## Status
Draft

## Type
New Feature

## Goal
Specify the chromatic beam particle systems, prism flash bursts, shadow dissolve shaders, and haptic feedback mappings for Yarn Unravel Phase 6 (Levels 2501–3000) within strict device tier budgets.

## Current State
Design documented in `phase/phase_6/06_UI_AND_QA_PHASE_6.md`, not yet implemented.

## Proposed Change
Implement Phase 6 VFX and haptic mappings in `lib/core/vfx`:

### 1. Event Effect Mapping Catalog
Reuses established core effect classes from `VFX_IMPLEMENTATION.md`:

| Event | Effect Class | Visual Presentation | Haptic Feedback |
|---|---|---|---|
| `beam_ignite` | `beam_glow` | Brass lamp filament glows warmly; golden light ray shoots in straight path across board. | `HapticFeedback.lightImpact()` |
| `m251_filter_pass` | `morph_flash` | White beam strikes tinted pane; vivid chromatic light burst as beam emerges tinted. | `HapticFeedback.selectionClick()` |
| `m252_prism_unlock` | `state_toggle` + `morph_flash` | 2 concurrent beams strike prism; radiant golden starburst flash as crystal lock dissolves. | `HapticFeedback.heavyImpact()` |
| `m253_lamp_tick` | `state_toggle` | Hourglass lamp toggles state on move interval with subtle filament pulse and mechanical click. | `HapticFeedback.selectionClick()` |
| `m254_shadow_lift` | `fog_dissolve` | Light beam cuts into dark cell; twilight shadow vignette vaporizes in soft circular dissolve. | `HapticFeedback.lightImpact()` |

### 2. Device Tier Particle & Shake Budgets

| Device Tier | Max Live Particles | Shake Intensity | Texture Resolution & Shaders |
|---|---|---|---|
| **Low Tier** | $\le 30$ particles | 0 dp (disabled) | Simple solid colored lines; bloom particles disabled; direct shadow alpha toggle. |
| **Mid Tier** | $\le 80$ particles | $\le 4\text{ dp}$ | Soft alpha gradient beam strokes; subtle prism starburst particles; 150 ms dissolve. |
| **High Tier** | $\le 150$ particles | $\le 6\text{ dp}$ | Full chromatic dispersion, ambient floating dust motes illuminated by beams, layered haptics. |

### 3. Motion Accessibility
- When user enables **Reduce Motion**:
  - Screen shake is completely disabled ($0\text{ dp}$).
  - Particle emission is clamped to minimal static sparkles.
  - Light beams manifest instantly without pulse or sweep animations.

## Affected Files
- `lib/core/vfx/effects/optical_effects.dart` (to be created: ray particle and flash renderers)
- `lib/core/audio/haptics_service.dart` (changed: register Phase 6 optical haptic triggers)

## Risks
- Excessive GPU fill rate on high-resolution screens with multiple intersecting beams. Mitigated by `BlendMode.plus` rasterization without off-screen blur passes.

## Open Questions
None. VFX and haptic mappings match Phase 6 documentation.

Source docs: phase/phase_7/06_UI_AND_QA_PHASE_7.md, ../../VFX_IMPLEMENTATION.md §4.4. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-7-ui-additions.md.

# Spec: UI — Phase 7 Visual Effects (VFX) & Haptics

## Status
Draft

## Type
New Feature

## Goal
Specify the angular particle arcs, rotational swoosh effects, safety pin spring bursts, and haptic feedback mappings for Yarn Unravel Phase 7 (Levels 3001–3500) within strict device tier budgets.

## Current State
Design documented in `phase/phase_7/06_UI_AND_QA_PHASE_7.md`, not yet implemented.

## Proposed Change
Implement Phase 7 VFX and haptic mappings in `lib/core/vfx`:

### 1. Event Effect Mapping Catalog
Reuses established core effect classes from `VFX_IMPLEMENTATION.md`:

| Event | Effect Class | Visual Presentation | Haptic Feedback |
|---|---|---|---|
| `rotor_rotate_tap` | `rotate_swoosh` | $4 \times 4$ hoop spins 90° CW; sweeps an ethereal arc of spinning wool filaments and linen dust. | `HapticFeedback.mediumImpact()` |
| `m302_hem_shift` | `state_toggle` | Exit gap slides 1 perimeter segment CW with brief embroidered stitch glow. | `HapticFeedback.selectionClick()` |
| `m303_twirl_tick` | `morph_flash` | Twirl needle head snaps 90° CW; emits tiny silver sparkle glint from needle eye. | `HapticFeedback.selectionClick()` |
| `m304_pin_pop` | `state_toggle` | Brass safety pin unclips with spring recoil; releases small burst of golden brass particles. | `HapticFeedback.lightImpact()` |
| `tangled_denied_tap` | `denied_nudge` | Tangled thread head oscillates in 3-cycle horizontal micro-wobble; lock badge scales $1.2\times$. | `HapticFeedback.selectionClick()` |

### 2. Device Tier Particle & Shake Budgets

| Device Tier | Max Live Particles | Shake Intensity | Animation Curve & Motion |
|---|---|---|---|
| **Low Tier** | $\le 30$ particles | 0 dp (disabled) | Instantaneous 0 ms rotational snap; no swoosh arcs; 0 dp shake. |
| **Mid Tier** | $\le 80$ particles | $\le 4\text{ dp}$ | 200 ms cubic ease rotation; basic circular swoosh stroke; light screen shudder. |
| **High Tier** | $\le 150$ particles | $\le 6\text{ dp}$ | 250 ms eased rotation with angular inertia, trailing wool filaments, layered haptics. |

### 3. Motion Accessibility
- When user enables **Reduce Motion**:
  - Screen shake is completely zeroed ($0\text{ dp}$).
  - Rotor rotations snap instantly (0 ms).
  - Rotational swoosh particles are suppressed.

## Affected Files
- `lib/core/vfx/effects/rotation_effects.dart` (to be created: swoosh particle arcs)
- `lib/core/audio/haptics_service.dart` (changed: register Phase 7 rotational haptic triggers)

## Risks
- Matrix rotation redraw overhead causing frame stutter on older Android devices. Mitigated by caching static background cells outside the active rotor.

## Open Questions
None. VFX and haptic mappings match Phase 7 documentation.

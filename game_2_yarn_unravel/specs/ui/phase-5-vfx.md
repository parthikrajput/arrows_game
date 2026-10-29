Source docs: phase/phase_5/06_UI_AND_QA_PHASE_5.md, ../../VFX_IMPLEMENTATION.md §4.4. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-5-ui-additions.md.

# Spec: UI — Phase 5 Visual Effects (VFX) & Haptics

## Status
Draft

## Type
New Feature

## Goal
Specify the particle systems, crate animation curves, screen shake, and haptic feedback mappings for Yarn Unravel Phase 5 (Levels 2001–2500) within strict device tier budgets.

## Current State
Design documented in `phase/phase_5/06_UI_AND_QA_PHASE_5.md`, not yet implemented.

## Proposed Change
Implement Phase 5 VFX and haptic mappings in `lib/core/vfx`:

### 1. Event Effect Mapping Catalog
Reuses established core effect classes from `VFX_IMPLEMENTATION.md`:

| Event | Effect Class | Visual Presentation | Haptic Feedback |
|---|---|---|---|
| `crate_push_step` | `dust_puff` | Wooden crate slides 1 cell; emits 4 tiny wood shavings and linen dust particles in slide wake. | `HapticFeedback.lightImpact()` |
| `m201_pit_fill` | `lane_warp` + `dust_puff` | Crate drops into pit; fabric levels out with expanding golden stitch ripple ring. | `HapticFeedback.mediumImpact()` |
| `m202_satin_slide` | `lane_warp` | Satin crate glides smoothly across multiple cells with trailing silk shimmer sparkles. | `HapticFeedback.lightImpact()` |
| `m203_charm_unlock` | `state_toggle` | Metallic charm snaps into clasp; bursting ring of golden stars as crate dissolves. | `HapticFeedback.mediumImpact()` |
| `m204_iron_push` | `blocker_hit_hard` + `dust_puff` | Heavy iron chest shifts 1 cell with industrial friction sparks and dense wool puff. | `HapticFeedback.heavyImpact()` |
| `iron_snag_failed` | `bump_flash` | Normal thread strikes iron crate; crate shudders with red flash; thread recoils. | `HapticFeedback.mediumImpact()` |

### 2. Device Tier Particle & Shake Budgets

| Device Tier | Max Live Particles | Shake Intensity | Texture Resolution & Shaders |
|---|---|---|---|
| **Low Tier** | $\le 30$ particles | 0 dp (disabled) | Simple single-pixel dust particles; slide motion blur disabled. |
| **Mid Tier** | $\le 80$ particles | $\le 4\text{ dp}$ | Wood shaving sprites, soft satin trails, subtle screen shudder on iron push. |
| **High Tier** | $\le 150$ particles | $\le 6\text{ dp}$ | Full physics-simulated dust puffs, satin specular trail glows, layered haptics. |

### 3. Motion Accessibility
- When user enables **Reduce Motion**:
  - Screen shake is zeroed across all tiers ($0\text{ dp}$).
  - Particle emission is clamped to minimal static indicators.
  - Crate slide durations snap instantly to destination cells.

## Affected Files
- `lib/core/vfx/effects/crate_effects.dart` (to be created: crate particle and trail renderers)
- `lib/core/audio/haptics_service.dart` (changed: register Phase 5 haptic triggers)

## Risks
- Frame rate drops during satin crate continuous slides (M202) over long distances. Mitigated by particle pooling and limiting trailing emission frequency.

## Open Questions
None. VFX and haptic mappings match Phase 5 documentation.

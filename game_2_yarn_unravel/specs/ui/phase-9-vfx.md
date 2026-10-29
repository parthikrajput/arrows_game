Source docs: phase/phase_9/06_UI_AND_QA_PHASE_9.md, ../../VFX_IMPLEMENTATION.md §4.4. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-9-ui-additions.md.

# Spec: UI — Phase 9 Visual Effects (VFX) & Haptics

## Status
Draft

## Type
New Feature

## Goal
Specify the thread twisting spirals, parallel fiber split sparks, buckle snap bursts, and haptic feedback mappings for Yarn Unravel Phase 9 (Levels 4001–4500) within strict device tier budgets.

## Current State
Design documented in `phase/phase_9/06_UI_AND_QA_PHASE_9.md`, not yet implemented.

## Proposed Change
Implement Phase 9 VFX and haptic mappings in `lib/core/vfx`:

### 1. Event Effect Mapping Catalog
Reuses established core effect classes from `VFX_IMPLEMENTATION.md`:

| Event | Effect Class | Visual Presentation | Haptic Feedback |
|---|---|---|---|
| `m401_twisting_merge` | `morph_flash` + `lane_warp` | Two needle heads spiral inward in 180 ms; erupts in golden wool twist sparks as single thread forms. | `HapticFeedback.mediumImpact()` |
| `m402_double_split` | `burst_sparks` | Needle traverses splitter eyelet; bursts into two parallel tracks with fine wool fluff particles. | `HapticFeedback.lightImpact()` |
| `m403_stitch_lock_open` | `key_unlock` | Key thread unravels; silver safety clasp springs open with silver glint and chime. | `HapticFeedback.selectionClick()` |
| `m404_rejoin_gate_open` | `gate_open` | Second child ply clears buckle; buckle snaps outward with heavy brass flash ring. | `HapticFeedback.heavyImpact()` |

### 2. Device Tier Particle & Shake Budgets

| Device Tier | Max Live Particles | Shake Intensity | Animation Curve & Motion |
|---|---|---|---|
| **Low Tier** | $\le 30$ particles | 0 dp (disabled) | Instantaneous 0 ms split and merge; simple sparkles; 0 dp shake. |
| **Mid Tier** | $\le 80$ particles | $\le 4\text{ dp}$ | 180 ms spiral twist tween; wool fluff bursts; light screen shudder on buckle open. |
| **High Tier** | $\le 150$ particles | $\le 6\text{ dp}$ | Full helical fiber particle physics, trailing golden embers, layered haptics. |

### 3. Motion Accessibility
- When user enables **Reduce Motion**:
  - Screen shake is completely zeroed ($0\text{ dp}$).
  - Twisting and splitting motions snap instantly (0 ms).
  - Ambient spiral particles are suppressed.

## Affected Files
- `lib/core/vfx/effects/ply_twist_effects.dart` (to be created: spiral twist particle systems)
- `lib/core/audio/haptics_service.dart` (changed: register Phase 9 ply/twist haptic triggers)

## Risks
- Dual-thread animations causing micro-stutters during simultaneous merges. Mitigated by particle pooling and pre-compiled tween controllers.

## Open Questions
None. VFX and haptic mappings match Phase 9 documentation.

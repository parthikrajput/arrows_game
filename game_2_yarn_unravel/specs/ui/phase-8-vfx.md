Source docs: phase/phase_8/06_UI_AND_QA_PHASE_8.md, ../../VFX_IMPLEMENTATION.md §4.4. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-8-ui-additions.md.

# Spec: UI — Phase 8 Visual Effects (VFX) & Haptics

## Status
Draft

## Type
New Feature

## Goal
Specify the sprouting particle bursts, shears snipping animations, floral pollen bursts, and haptic feedback mappings for Yarn Unravel Phase 8 (Levels 3501–4000) within strict device tier budgets.

## Current State
Design documented in `phase/phase_8/06_UI_AND_QA_PHASE_8.md`, not yet implemented.

## Proposed Change
Implement Phase 8 VFX and haptic mappings in `lib/core/vfx`:

### 1. Event Effect Mapping Catalog
Reuses established core effect classes from `VFX_IMPLEMENTATION.md`:

| Event | Effect Class | Visual Presentation | Haptic Feedback |
|---|---|---|---|
| `m351_ivy_spread` | `grow_burst` | Green wool vine sprouts outward; emits 4 tiny wool fiber filaments and leaf sparks. | `HapticFeedback.lightImpact()` |
| `m352_snip_prune` | `hammer_impact` + `lane_warp` | Rapid metallic scissor snip; cloud of snipped wool clippings and green leaf confetti from 8 cells. | `HapticFeedback.mediumImpact()` |
| `m353_seed_drop` | `counter_pop` | Seed bead drops onto fabric with elastic bounce; floating countdown badge pops in. | `HapticFeedback.selectionClick()` |
| `seed_mature_button` | `morph_flash` | Wooden seed swells and snaps into polished Wooden Button with radial flash ring. | `HapticFeedback.lightImpact()` |
| `m354_blossom_bloom` | `gate_open` | Embroidered flower blooms open in full glory; showers golden pollen sparkles across cell. | `HapticFeedback.heavyImpact()` |

### 2. Device Tier Particle & Shake Budgets

| Device Tier | Max Live Particles | Shake Intensity | Animation Curve & Motion |
|---|---|---|---|
| **Low Tier** | $\le 30$ particles | 0 dp (disabled) | Instantaneous 0 ms vine manifestation; simple confetti; 0 dp shake. |
| **Mid Tier** | $\le 80$ particles | $\le 4\text{ dp}$ | 200 ms spring-out sprout animation; leaf clipping particles; light screen shudder. |
| **High Tier** | $\le 150$ particles | $\le 6\text{ dp}$ | Full physics leaf flutter, trailing golden pollen showers on bloom, layered haptics. |

### 3. Motion Accessibility
- When user enables **Reduce Motion**:
  - Screen shake is completely zeroed ($0\text{ dp}$).
  - Sprouting and petal opening snap instantly (0 ms).
  - Floating pollen and particle debris are suppressed.

## Affected Files
- `lib/core/vfx/effects/garden_effects.dart` (to be created: leaf and bloom particle systems)
- `lib/core/audio/haptics_service.dart` (changed: register Phase 8 garden haptic triggers)

## Risks
- Rapid successive Snip Tile prunes generating hundreds of particles simultaneously. Mitigated by strict particle pool limits clamped to tier caps.

## Open Questions
None. VFX and haptic mappings match Phase 8 documentation.

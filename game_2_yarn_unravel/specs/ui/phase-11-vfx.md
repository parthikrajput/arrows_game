Source docs: phase/phase_11/06_UI_AND_QA_PHASE_11.md, ../../VFX_IMPLEMENTATION.md §4.4. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-11-ui-additions.md.

# Spec: UI — Phase 11 Visual Effects (VFX) & Haptics

## Status
Draft

## Type
New Feature

## Goal
Specify the seam stitch shimmer waves, cross-hoop portal bursts, twin-mirror synchronization trails, and haptic feedback mappings for Yarn Unravel Phase 11 (Levels 5001–5500) within strict device tier budgets.

## Current State
Design documented in `phase/phase_11/06_UI_AND_QA_PHASE_11.md`, not yet implemented.

## Proposed Change
Implement Phase 11 VFX and haptic mappings in `lib/core/vfx`:

### 1. Event Effect Mapping Catalog
Reuses established core effect classes from `VFX_IMPLEMENTATION.md`:

| Event | Effect Class | Visual Presentation | Haptic Feedback |
|---|---|---|---|
| `m501_seam_warp` | `lane_warp` | Needle crosses border seam; golden zig-zag stitches light up in sequence as thread transitions into sister hoop. | `HapticFeedback.lightImpact()` |
| `m502_cross_key_unlock` | `key_unlock` + `sparkle_stream` | Key thread unravels from Hoop A; brilliant golden spark trajectory leaps across canvases to pop clasp on Hoop B. | `HapticFeedback.mediumImpact()` |
| `m503_mirror_sync` | `morph_flash` | Synchronous dual unravel; twin threads emit matching chromatic wake trails on both hoops simultaneously. | `HapticFeedback.mediumImpact()` |
| `m504_relay_jump` | `pompom_poof` | Thread head dives into pompom with wool tuft puff; instantly bursts out of sister pompom with cloud of soft wool dust. | `HapticFeedback.lightImpact()` |

### 2. Device Tier Particle & Shake Budgets

| Device Tier | Max Live Particles | Shake Intensity | Animation Curve & Motion |
|---|---|---|---|
| **Low Tier** | $\le 30$ particles | 0 dp (disabled) | Instantaneous 0 ms seam transition; simple sparkle pops; 0 dp shake. |
| **Mid Tier** | $\le 80$ particles | $\le 4\text{ dp}$ | 200 ms seam glide animation; localized pompom puff; light screen shudder. |
| **High Tier** | $\le 150$ particles | $\le 6\text{ dp}$ | Full physics-simulated yarn tuft bursts, cross-canvas traveling spark arcs, layered haptics. |

### 3. Motion Accessibility
- When user enables **Reduce Motion**:
  - Screen shake is completely zeroed ($0\text{ dp}$).
  - Seam transitions and portal jumps snap instantly (0 ms).
  - Cross-board traveling sparks are suppressed.

## Affected Files
- `lib/core/vfx/effects/twin_hoop_effects.dart` (to be created: seam and pompom particle systems)
- `lib/core/audio/haptics_service.dart` (changed: register Phase 11 dual hoop haptic triggers)

## Risks
- Double particle load from having two active boards simultaneously. Mitigated by enforcing a single shared particle pool capped at the tier limit.

## Open Questions
None. VFX and haptic mappings match Phase 11 documentation.

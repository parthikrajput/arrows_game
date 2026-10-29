Source docs: phase/phase_10/06_UI_AND_QA_PHASE_10.md, ../../VFX_IMPLEMENTATION.md §4.4. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-10-ui-additions.md.

# Spec: UI — Phase 10 Visual Effects (VFX) & Haptics

## Status
Draft

## Type
New Feature

## Goal
Specify the pendulum sweep animations, chromatic sparkle streams, rhythmic pulse waves, and haptic feedback mappings for Yarn Unravel Phase 10 (Levels 4501–5000) within strict device tier budgets.

## Current State
Design documented in `phase/phase_10/06_UI_AND_QA_PHASE_10.md`, not yet implemented.

## Proposed Change
Implement Phase 10 VFX and haptic mappings in `lib/core/vfx`:

### 1. Event Effect Mapping Catalog
Reuses established core effect classes from `VFX_IMPLEMENTATION.md`:

| Event | Effect Class | Visual Presentation | Haptic Feedback |
|---|---|---|---|
| `m451_metronome_tick` | `counter_pop` | Pendulum needle snaps to new beat position with subtle wooden tick animation. | `HapticFeedback.selectionClick()` |
| `m452_pattern_match` | `sparkle_stream` | Correct color unraveled; stream of prismatic sparkles glints around target brooch pip. | `HapticFeedback.lightImpact()` |
| `m452_clasp_open` | `gate_open` | Entire color sequence satisfied; brooch bursts with radial golden light flash as barrier frees. | `HapticFeedback.heavyImpact()` |
| `m453_ordered_snag` | `blocked_bump` | Out-of-order exit attempt; red warning ripple across border hem accompanied by twang vibration. | `HapticFeedback.heavyImpact()` |
| `m454_echo_pulse` | `lane_warp` | Echo card receives matching color; soft rhythmic light wave pulses across the canvas board. | `HapticFeedback.lightImpact()` |

### 2. Device Tier Particle & Shake Budgets

| Device Tier | Max Live Particles | Shake Intensity | Animation Curve & Motion |
|---|---|---|---|
| **Low Tier** | $\le 30$ particles | 0 dp (disabled) | Instantaneous 0 ms metronome state toggle; simple sparkle pips; 0 dp shake. |
| **Mid Tier** | $\le 80$ particles | $\le 4\text{ dp}$ | 150 ms eased pendulum sweep; localized sparkle streams; light screen shudder. |
| **High Tier** | $\le 150$ particles | $\le 6\text{ dp}$ | Full harmonic pendulum physics, cascading golden dust showers on clasp open, layered haptics. |

### 3. Motion Accessibility
- When user enables **Reduce Motion**:
  - Screen shake is completely zeroed ($0\text{ dp}$).
  - Pendulum needle snaps instantaneously (0 ms).
  - Ambient sparkle streams and pulse waves are suppressed.

## Affected Files
- `lib/core/vfx/effects/sequence_effects.dart` (to be created: metronome and brooch particle systems)
- `lib/core/audio/haptics_service.dart` (changed: register Phase 10 sequence haptic triggers)

## Risks
- Rapid successive moves overwhelming metronome animation queue. Mitigated by dropping intermediate in-flight tweens and snapping to latest move state.

## Open Questions
None. VFX and haptic mappings match Phase 10 documentation.

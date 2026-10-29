Source docs: phase/phase_7/06_UI_AND_QA_PHASE_7.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-7-signature-system.md.

# Spec: UI — Phase 7 VFX & Juice (Whirling Garden Visual Effects)

## Status
Draft

## Type
New Feature

## Goal
Implement the visual effects for the Whirling Garden sub-board rotation, perimeter edge wall shifts, spinning top lines, and the L3500 Whirling Blossom Gala Finale, reusing existing effect classes within established particle and device tier budgets.

## Current State
Design documented in `phase/phase_7/06_UI_AND_QA_PHASE_7.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Current VFX suite covers standard line movement, bonks, ambient day/night sweeps, push trails, and optical beams.
- Rotational canvas transforms, angular motion blur, and circular flower-petal whirlwinds are not implemented.

## Proposed Change
Extend `packages/puzzle_core/lib/src/vfx/` with Phase 7 effect mappings:

### 1. Rotational Motion & Sector Blur
- **Turntable 90° CW Spin (`state_toggle` class):**
  - Smooth 250 ms `Curves.easeInOutCubic` angular rotation.
  - Generates circular arc trail of floral petals and golden pollen sweeping along the turntable circumference.
- **Perimeter Edge Wall Slide (`lane_warp` class):**
  - Thorny hedge segments shift along board border with leafy rustle sound and tiny green leaf puffs at corner turns.

### 2. Base Mechanics VFX Mapping
| Event / Mechanic | Effect Class | Visual Effect Definition | Tier Budget (Low / Mid / High) |
|---|---|---|---|
| Flower-Bed Turntable (M301) | `state_toggle` | 250 ms clockwise rotation with circular petal trail and resonant wooden clicking sound. | 0 / 16 / 32 particles |
| Turning Hedge Shift (M302) | `lane_warp` + `dust_puff` | Hedges slide along perimeter; green leaf puffs kick up at corner intersections. | 0 / 12 / 24 particles |
| Spinning Top Turn (M303) | `state_toggle` | Quick 150 ms snap rotation with propeller blur and cheerful insect chirp. | 4 / 8 / 16 particles |
| Pinned Daisy Anchor Lock (M304)| `hazard_sparks` | Tapping locked turntable produces white daisy shockwave and rooted creaking sound. | 0 / 10 / 20 particles |
| L3500 Finale Win | `win_confetti` + `lane_warp` | **Whirling Blossom Gala:** Giant floral cyclone of cherry blossoms, golden pollen, and fireworks across the board. | 30 / 80 / 150 particles |

### 3. Performance & Tier Constraints
- **Low Tier (Budget $\le 30$ particles):** Instantaneous angular rotation without particle arcs; leaf puffs omitted; screen shake disabled.
- **Mid Tier (Budget $\le 80$ particles):** Standard 250 ms angular interpolation, standard particle counts, max 4 dp camera shake on finale.
- **High Tier (Budget $\le 150$ particles):** Radial motion blur on turntable perimeter, dual-layer blossom cyclone, max 6 dp shake on finale.
- **Reduce Motion:** When `reduce_motion = true`, turntable rotation executes as an instantaneous snap transition with zero angular blur or camera shake.

## Affected Files
- `packages/puzzle_core/lib/src/vfx/rotation_vfx_controller.dart` (to be created)
- `packages/puzzle_core/lib/src/vfx/vfx_registry.dart` (changed to register Phase 7 mappings)

## Risks
- Canvas rasterization artifacts during 90° rotation on anti-aliased insect vector paths. Mitigated by applying smooth matrix canvas transforms with high-quality rendering hints.

## Open Questions
- None. VFX mappings reuse canonical classes from `VFX_IMPLEMENTATION.md` §4.

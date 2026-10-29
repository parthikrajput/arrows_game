Source docs: phase/phase_4/06_UI_AND_QA_PHASE_4.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-4-signature-system.md.

# Spec: UI — Phase 4 VFX & Juice (Terrace Visual Effects)

## Status
Draft

## Type
New Feature

## Goal
Implement the visual effects for the Garden Terraces multi-floor transitions, M151–M154 mechanics, and the L2000 Finale, reusing existing effect classes within established particle and device tier budgets.

## Current State
Design documented in `phase/phase_4/06_UI_AND_QA_PHASE_4.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Current VFX suite covers single-board effects and day/night ambient sweeps.
- Vertical depth blur, floor transition warps, and glass ray shadow shaders are not implemented.

## Proposed Change
Extend `packages/puzzle_core/lib/src/vfx/` with Phase 4 effect mappings:

### 1. Inter-Floor Camera & Transition VFX
- **Vertical Parallax Glide (`lane_warp` class):**
  - Background foliage moves at 0.5x speed while grid content moves at 1.0x speed during vertical scroll.
  - Soft speed-lines and leafy dust particles sweep past camera during inter-floor transit.
- **Glass Terrace Shadow Projection (`laser_beam` / `state_toggle` class):**
  - Dew-Glass tiles (M152) render a soft, tinted translucent shadow onto the lower floor with 2 dp blur.

### 2. Base Mechanics VFX Mapping
| Event / Mechanic | Effect Class | Visual Effect Definition | Tier Budget (Low / Mid / High) |
|---|---|---|---|
| Root Stairs (M151) | `lane_warp` | Line spirals smoothly into wooden knot stairs with organic wood-dust puff. | 0 / 12 / 24 particles |
| Glass Terrace Shadow (M152) | `state_toggle` | Crystalline light refraction on upper glass; soft translucent shadow on lower terrace. | Shader / 12 / 24 particles |
| Rabbit Hole Drop (M153) | `lane_warp` + `dust_puff` | Insect plunges into hole; emerges below with a crisp earth-dust poof. | 0 / 14 / 28 particles |
| Acorn Lift (M154) | `state_toggle` | Wooden platform rattles and rises/lowers with ascending leaf flutter. | 8 / 16 / 32 particles |
| L2000 Finale Win | `win_confetti` + `laser_beam` | **Terrace Summit Coronation:** Rainbow floral confetti cascade across all 3 floors simultaneously. | 30 / 80 / 150 particles |

### 3. Performance & Tier Constraints
- **Low Tier (Budget $\le 30$ particles):** Parallax blur disabled; vertical camera scroll is a simple linear slide; dust puffs omitted.
- **Mid Tier (Budget $\le 80$ particles):** Full parallax scroll, standard particle counts, max 4 dp camera shake on finale.
- **High Tier (Budget $\le 150$ particles):** Shaded crystalline glass refraction, dual-plane particles, max 6 dp shake on finale.
- **Reduce Motion:** When `reduce_motion = true`, floor switching becomes an instantaneous 100 ms crossfade without vertical sliding.

## Affected Files
- `packages/puzzle_core/lib/src/vfx/multi_floor_vfx.dart` (to be created)
- `packages/puzzle_core/lib/src/vfx/vfx_registry.dart` (changed to register Phase 4 mappings)

## Risks
- Frame drops during vertical camera transitions on low-end devices due to rendering two floors simultaneously during scroll. Mitigated by culling inactive floor widgets as soon as transition completes.

## Open Questions
- None. VFX mappings reuse canonical classes from `VFX_IMPLEMENTATION.md` §4.


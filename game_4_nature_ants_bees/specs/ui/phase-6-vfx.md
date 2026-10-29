Source docs: phase/phase_6/06_UI_AND_QA_PHASE_6.md, VFX_IMPLEMENTATION.md §4, §5. Depends on: specs/ui/vfx-and-juice.md, specs/gameplay/phase-6-signature-system.md.

# Spec: UI — Phase 6 VFX & Juice (Sunlit Garden Visual Effects)

## Status
Draft

## Type
New Feature

## Goal
Implement the visual effects for the Sunlit Garden optical networks, beam reflections, chromatic filtering, shade patch awakening bursts, and the L3000 Solstice Festival Finale, reusing existing effect classes within established particle and device tier budgets.

## Current State
Design documented in `phase/phase_6/06_UI_AND_QA_PHASE_6.md` and `VFX_IMPLEMENTATION.md`, not yet implemented.
- Current VFX suite covers standard movement, bonks, ambient day/night sweeps, and push block trails.
- Dynamic laser beam raycasting shaders, chromatic prism splits, and solar awakening sparkles are not implemented.

## Proposed Change
Extend `packages/puzzle_core/lib/src/vfx/` with Phase 6 effect mappings:

### 1. Optical Beam & Chromatic Shader Effects
- **Laser Sunbeam Glow (`laser_beam` class):**
  - Continuous ray rendered with `BlendMode.plus` and high-intensity golden core.
  - Micro-particles of drifting golden pollen flow along the beam direction at 60 fps.
- **Chromatic Petal Filter (`morph_flash` class):**
  - Passing through a Petal Filter (M251) triggers an instantaneous radial color bloom, shifting beam hue with soft dispersion.

### 2. Base Mechanics VFX Mapping
| Event / Mechanic | Effect Class | Visual Effect Definition | Tier Budget (Low / Mid / High) |
|---|---|---|---|
| Petal Filter Color Shift (M251) | `morph_flash` | Radial color bloom on filter tile; beam transitions hue with shimmering pollen burst. | 8 / 16 / 32 particles |
| Twin-Sun Lock Open (M252) | `unlock_shatter` | Dual golden light flares converge into gate lock, shattering thorns with resonant chime. | 8 / 20 / 40 particles |
| Sundial Lens Toggle (M253) | `beam_glow` | Beam snaps on/off with bright focal flash and expanding lens flare ring. | 0 / 12 / 24 particles |
| Shade Patch Awakening (M254) | `state_toggle` + `morph_flash` | Golden sunbeam strikes shaded line; burst of warm sparkles dispels gloom and restores insect color. | 8 / 16 / 32 particles |
| L3000 Finale Win | `win_confetti` + `laser_beam` | **Midsummer Solstice Zenith:** Blinding solar zenith flare, golden sunflower petal fireworks, and confetti across all layers. | 30 / 80 / 150 particles |

### 3. Performance & Tier Constraints
- **Low Tier (Budget $\le 30$ particles):** Plain 2D colored line drawing without additive blending or drifting pollen; screen shake disabled.
- **Mid Tier (Budget $\le 80$ particles):** Additive blending, standard particle counts, max 4 dp camera shake on finale.
- **High Tier (Budget $\le 150$ particles):** Bloom shaders, chromatic aberration on prism splits, max 6 dp shake on finale.
- **Reduce Motion:** When `reduce_motion = true`, all lens flares and camera shakes are disabled; beam toggles are instantaneous crossfades.

## Affected Files
- `packages/puzzle_core/lib/src/vfx/optical_beam_painter.dart` (to be created)
- `packages/puzzle_core/lib/src/vfx/vfx_registry.dart` (changed to register Phase 6 mappings)

## Risks
- High GPU fill-rate consumption from multiple additive-blended intersecting sunbeams. Mitigated by rendering static beam segments into a cached picture layer when the board is stationary.

## Open Questions
- None. VFX mappings reuse canonical classes from `VFX_IMPLEMENTATION.md` §4.

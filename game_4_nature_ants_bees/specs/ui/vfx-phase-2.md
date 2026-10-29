Source docs: VFX_IMPLEMENTATION.md, phase_2/01_PHASE_2_SCOPE_AND_RULES.md, phase_2/03_OBSTACLE_CATALOG_PHASE_2.md, phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, phase_2/06_FRONTEND_AND_QA_PHASE_2.md. Depends on: specs/ui/vfx-and-juice.md

# Spec: Visual Effects and Game Feel (Phase 2 Additions)

## Status
Draft

## Type
Improvement

## Goal
Specify the Phase 2 visual effects, including Canopy 3rd-layer rendering, diagonal movement trails, push block particle bursts, sunbeam optics, LiveOps animations, and Level 1000 Jubilee finale effects for Ants & Bees: Garden Trails.

## Current State
Design documented in VFX_IMPLEMENTATION.md, phase_2/01, 03, 04, and 06.
- Extends `specs/ui/vfx-and-juice.md`.
- Phase 1 covered ground and air layers with basic particle caps and effect classes.
- Phase 2 adds 3rd-layer canopy rendering, 8-directional trails, push-block dust, continuous sunbeam passes, and LiveOps visual rewards.

## Proposed Change
Extend `VfxService` and the effects atlas in `apps/ants_bees/lib/features/gameplay/render/vfx/`:

### 1. Canopy Layer (Layer 2) Visual Treatment
- **Altitude Offset:** Canopy Scout Bees (M069) render at +12 dp vertical offset relative to grid cells.
- **Visual Glint:** Emerald wing highlights and high-altitude soft shadow offset 12 dp down-right.
- **Exit Trail:** High-altitude pale-green pollen sparkle trail with gentle floating drift.

### 2. Diagonal Movement & Trails (M051)
- 8-directional trail vectors matching line orientation (`UL, UR, DL, DR`).
- Particle emission aligns with the line's exact trajectory vector.
- Diagonal bonk: Head insect performs 45° angular squash and rebound against diagonal blockers.

### 3. Push Block & Optical Mechanics VFX
| Mechanic / Event | Effect Class | Phase 2 Themed Visual Implementation |
|---|---|---|
| Rolling Acorn (M053) | `dust_puff` | Tiny dry wood and soil dust puffs when pushed. |
| Dew-Slick Leaf (M054) | `lane_warp` (slide) | Watery droplet wake trailing behind sliding acorns. |
| Socket Plate (M055) | `state_toggle` | Radiant leaf burst and green lock glow upon socket connection. |
| Sunbeam Lens (M084) | `beam_glow` | Additive white sunbeam vector (`BlendMode.plus`) with ambient light ray dust motes. |
| Beetle Mirror (M086) | `beam_glow` | Brilliant pinpoint light flare at mirror reflection point. |
| Dew Prism (M089) | `beam_glow` | Separates white incident sunbeam into distinct red, yellow, and blue refracted rays. |
| Great Stag Beetle (M098)| `guardian_hit` | Golden metallic chitin glint on carapace; heavy ground impact shockwave. |

### 4. LiveOps Visuals
- **Flora & Fauna Compendium:**
  - Stamp placement: 1.2-second fluid drop animation with soft scale pop and golden pollen dusting.
  - Volume Completion: Shimmering botanical ribbon animation across the completed album page.
- **Weekly Star Race:**
  - Podium reveal: Ascending pedestal animation with radiant light beams.
  - 1st place celebration: Golden honey crown drop and dancing worker bee swarm.
- **Golden Honeycomb Bank:**
  - Deposit: Tiny coin arcs into honeycomb with golden honey splash.
  - Capacity Meter: Honey level progressively fills the transparent honeycomb cells.
  - Bank Break: Explosive golden honey rupture with tumbling coins and sparkling nectar droplets.

### 5. Level 1000 Finale: "Queen's Midsummer Jubilee"
- Culminating victory celebration across all 3 layers:
  - Grand multi-tiered confetti burst featuring sunflower petals, emerald leaves, and golden honey sparkles.
  - Dancing fireflies drift across the entire screen.
  - Respects strict tier particle limits (Low 30, Mid 80, High 150 particles).

## Affected Files
- `apps/ants_bees/lib/features/gameplay/render/vfx/beam_renderer.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/render/vfx/vfx_catalog_p2.dart` (to be created)
- `apps/ants_bees/assets/vfx/atlas.webp` (to be extended with Phase 2 sprites)

## Risks
- Sunbeam blending (`BlendMode.plus`) could cause overdraw slowdowns if not rendered via cached path vectors.

## Open Questions
- None. VFX classes, particle limits, and triggers conform to VFX_IMPLEMENTATION.md and phase_2/06.

Source docs: VFX_IMPLEMENTATION.md, phase/phase_2/06_FRONTEND_AND_QA_PHASE_2.md. Depends on: specs/ui/vfx-and-juice.md.

# Spec: Visual Effects & Juice Phase 2 (Toy Trains)

## Status
Draft

## Type
Improvement (extends VFX catalog, particle emitters, and screen juice from `specs/ui/vfx-and-juice.md` for Phase 2 content)

## Goal
Specify the visual effects (VFX), particle emitters, optical shaders, and UI juice animations for Phase 2 of Toy Trains: Wooden Railway Puzzle, covering M051–M099 mechanics, three-layer depth rendering, LiveOps celebration sequences, and device tier performance budgets.

## Current State
Design documented in `VFX_IMPLEMENTATION.md` and `phase/phase_2/06_FRONTEND_AND_QA_PHASE_2.md`, not yet implemented.
- Phase 1 VFX (`specs/ui/vfx-and-juice.md`) defined core particle emitters (steam puffs, buffer clack sparks, star sparkles), camera micro-shakes, and device particle tier caps.
- Phase 2 introduces diagonal puff trails, optical light beam shaders, multi-tier viaduct shadows, and LiveOps celebratory bursts.

## Proposed Change
Extend the Flutter rendering pipeline and particle engine:

### 1. Performance Budgets & Device Tier Limits
Adheres strictly to `VFX_IMPLEMENTATION.md` §3 particle caps:

| Tier | Max Particles / Emitter | Screen Shake Max | Feature Overrides |
|---|---|---|---|
| **Low** | **30** | **0 dp** (Disabled) | Simple alpha blends, no dynamic drop shadows, single-layer blur |
| **Mid** | **80** | **2 dp** | Standard particle emitters, static viaduct shadows, additive glow |
| **High** | **150** | **4 dp** | Full physics particles, dynamic viaduct drop shadows, chromatic prism flare |

- **Reduce Motion Accessibility:** When enabled in system settings: screen shakes are entirely disabled (0 dp), particle bursts are replaced with smooth opacity cross-fades (250 ms), and zoom animations jump instantly to target scale.

### 2. Phase 2 Mechanics VFX Catalog

| Event / Mechanic | Visual Effect Description | Particle Type / Shader | Emitter Count (Low / Mid / High) |
|---|---|---|---|
| **M051 Diagonal Express** | 45° puff trail trailing diagonal train cabin during exit departure. | Soft wooden steam circles drifting at 45° | 10 / 25 / 40 |
| **M053 Push Cart Shove** | Impact dust ring at point of impact; cart slides forward 1 cell. | Fine sawdust particle puff | 8 / 20 / 35 |
| **M054 Frosty Rails Slide** | Gliding frosty mist particles and crystalline ice sparkles trailing moving cart. | Cyan ice diamond flecks (`#E0F7FA`) | 12 / 30 / 60 |
| **M069 Triple-Deck Viaduct** | Layer 2 casts dynamic soft drop shadow onto Layer 1 and Layer 0 tracks. | Multi-pass gaussian shadow shader | n/a (Shader) |
| **M084 Signal Lamp Beam** | Continuous linear light ray with soft edge blur; casts crisp shadow behind occluding trains. | Additive blend light corridor (`#FFF59D`) | n/a (Shader) |
| **M086 Signal Mirror** | 90° beam reflection point displays warm brass flare glint. | 4-point star lens ping (`#FFE082`) | 5 / 12 / 20 |
| **M087 Jam Spill Unstick** | Sticky amber filaments stretch between locomotive wheels and rails, then snap. | Elastic procedural bezier strands | 4 / 8 / 16 |
| **M089 Crystal Prism Split** | Incoming white beam refracts into dual perpendicular colored beams (cyan & amber). | Spectral refraction shader | n/a (Shader) |
| **M097 Domino Cascade** | Successive wooden crate tumble with flying splinter flakes. | Miniature rectangular wood chips | 15 / 40 / 75 |
| **M098 Marching Clock Tower**| Heavy brass footstep stomps creating circular dust shockwave ring. | Expanding oval shockwave circle | 10 / 25 / 50 |
| **L1000 Grand Finale** | Dual brass steam whistles blast fireworks, golden confetti fountains, and rainbow banners. | Golden star confetti & smoke plumes | 30 / 80 / 150 |

### 3. LiveOps Event Celebrations
- **Depot Sticker Album Volume Complete:**
  - Wax seal stamp animates with realistic 3D compression.
  - Border of volume page ignites with golden filigree sparkle trail (Low: 15 / Mid 40 / High 80 golden stars).
- **Weekly Star Race Podium Dialog:**
  - Golden, silver, and bronze spotlight beams illuminate locomotive trophies.
  - Confetti cannon triggers cascading streamer ribbons across dialog viewport.
- **Ticket Piggy Bank Shatter:**
  - Ceramic piggy bank splits along jagged fracture lines.
  - Ceramic shards burst outward with gravity physics (Low: 12 / Mid 30 / High 60 shards).
  - Volumetric shower of 50 brass coins arcs from break point directly into the top HUD coin counter.

## Affected Files
- `lib/core/vfx/renderers/beam_shader_painter.dart` (to be created)
- `lib/core/vfx/emitters/sawdust_emitter.dart` (to be created)
- `lib/core/vfx/emitters/ice_sparkle_emitter.dart` (to be created)
- `lib/core/vfx/emitters/piggy_shatter_emitter.dart` (to be created)
- `lib/core/vfx/vfx_service.dart` (changed: register Phase 2 effect classes)

## Risks
- Additive blending shader performance degradation on older Mali GPUs. Mitigation: Fallback to simple unblended translucent polygon ribbons on Low tier.

## Open Questions
- None. All effect classes, particle budgets, and tier rules match `VFX_IMPLEMENTATION.md` and Phase 2 docs.

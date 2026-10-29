Source docs: VFX_IMPLEMENTATION.md, phase/phase_2/01_PHASE_2_SCOPE_AND_RULES.md, phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, phase/phase_2/06_FRONTEND_AND_QA_PHASE_2.md. Depends on: specs/ui/vfx-and-juice.md.

# Spec: UI — Phase 2 Visual Effects (VFX) & Juice

## Status
Draft

## Type
Improvement (extends particle systems, shader pipelines, and event bindings from `specs/ui/vfx-and-juice.md` for Phase 2 mechanics and LiveOps)

## Goal
Specify visual effects (VFX), optical light beam rendering, three-layer vertical depth cues, 8-directional diagonal thread wakes, and LiveOps visual celebrations for Yarn Unravel Phase 2 while respecting strict low-tier performance budgets and accessibility options.

## Current State
Design documented in `VFX_IMPLEMENTATION.md` and `phase/phase_2/` docs, not yet implemented.
- Phase 1 VFX in `specs/ui/vfx-and-juice.md` established particle pool architectures, single `Ticker` dynamic layer painting via `drawAtlas`, and Phase 1 mechanic event bindings.
- Phase 2 introduces 8-directional diagonal unravelling, 3-layer vertical depth cues, continuous sliding crates, optical light beams, and LiveOps visual celebrations.

## Proposed Change
Extend `VfxService` and `BoardAnimator` to map Phase 2 events to existing generic effect classes (standard §4):

### 1. Phase 2 Mechanics VFX Mapping
Reuses generic effect classes from `VFX_IMPLEMENTATION.md` §4 without creating unbudgeted classes:

| Event / Mechanic | Effect Class | Visual Details | Particle Cap (Low / Mid / High) |
|---|---|---|---|
| **M051 Diagonal Exit** | `exit_trail` | Diagonal wool fiber wake aligned to 45° angle with soft thread fuzz | Low: 0, Mid: 12, High: 25 |
| **M053 Bobbin Crate Push** | `dust_puff` | Soft lint puff at crate base as wooden block shifts 1 cell forward | Low: 0, Mid: 8, High: 15 |
| **M054 Satin Glide Patch** | `dust_puff` + `lane_warp` | Silky continuous shimmer trail following sliding crate until impact | Low: 0, Mid: 10, High: 20 |
| **M055 Crate Dock Plate** | `state_toggle` | Expanding wooden ring pulse (200 ms) when latch engages | Low: 0, Mid: 6, High: 12 |
| **M069 3-Layer Depth** | Ambient depth shading | Soft atmospheric shadow cast between Lining, Fabric, and Tulle layers | Shader pass (0 particles) |
| **M079 Turning Quilt Frame** | `rotate_swoosh` | 90° clockwise rotation arc with swirling thread fragments | Low: 0, Mid: 15, High: 30 |
| **M084–M089 Lamp Beams & Mirrors** | `beam_glow` | Continuous optical light beams rendered using `BlendMode.plus` | Low: beam only, Mid: 10, High: 20 |
| **M092 Segmented Thread** | `morph_flash` | Subtle wooden bead snap as rear segments detach | Low: 0, Mid: 8, High: 16 |
| **M097 Bobbin Dominoes** | `domino_chain` | Sequential pulse waves traversing falling bobbins spaced 60 ms apart | Low: 0, Mid: 12, High: 24 |
| **M098 Wandering Guardian** | `guardian_hit` | Pincushion dust puff on each patrol step; pulse flash when struck | Low: 0, Mid: 6, High: 12 |

### 2. LiveOps Visual Celebrations
- **Scrapbook Sticker Stamp:**
  - Class: `chest_burst` (scaled down).
  - Visual: Knitted patch outline renders -> stitches fill -> brass stamp hammers down with 12 dp squash, emitting radial paper dust and gold star sparkles.
  - Particles: Low 0, Mid 15, High 30.
- **Weekly Star Race ("Cozy Cup"):**
  - Track Advance: Small golden thread trail following the player's needle avatar along the race track.
  - 1st Place Podium Celebration: `win_confetti` with shimmering golden spool trophy glow.
- **Knitted Piggy Bank Smash:**
  - Class: `hammer_impact` + `chest_burst`.
  - Visual: Golden Scissors / hammer strikes ceramic piggy bank; wool shards burst outwards accompanied by cascading 3D coin trails (`coin_trail`).
  - Particles: Low 20, Mid 60, High 100.
- **Wardrobe Cosmetics Preview:**
  - Thread Skins: Dynamic highlight glint traversing thread body segments.
  - Board Themes: Instant smooth cross-fade (200 ms) between wood textures.

### 3. Level 1000 Grand Finale Celebration: "The Heirloom Tapestry"
- Massive dual-phase celebration combining `win_confetti`, `chest_burst`, and continuous golden thread cascades across the entire 14x14 board.
- Particles: Low 40, Mid 120, High 200.

### 4. Accessibility & Performance Controls
- **Reduced Motion:** When system `accessibility.reduceMotion` is true:
  - Board rotation (M079) and zoom-to-fit animations snap instantly without tweening.
  - Crate pushes and particle explosions are replaced by simple 150 ms opacity cross-fades.
- **Device Tiers:**
  - Low-tier devices (DM-1): Particle emission capped at 30 active particles total across all simultaneous effects.
  - Mid-tier (DM-2): Capped at 100 particles.
  - High-tier (DM-3): Capped at 250 particles.

## Affected Files
- `lib/features/gameplay/vfx/vfx_service.dart` (changed: register Phase 2 event triggers)
- `lib/features/gameplay/vfx/effects/beam_glow_effect.dart` (to be created: optical light beam renderer)
- `lib/features/gameplay/vfx/effects/crate_slide_effect.dart` (to be created: satin glide smoke trail)
- `lib/features/album/view/widgets/stamp_fx_widget.dart` (to be created: sticker stamp particle burst)

## Risks
- Optical beam glow (`BlendMode.plus`) causing excessive overdraw on low-end Mali GPUs. Mitigated by rendering beam bodies into a single cached `Picture` path rather than per-pixel blur shaders.

## Open Questions
None. All effect classes and tier limits conform to `VFX_IMPLEMENTATION.md`.

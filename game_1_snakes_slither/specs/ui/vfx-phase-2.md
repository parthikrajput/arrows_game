Source docs: VFX_IMPLEMENTATION.md, phase_2/01_PHASE_2_SCOPE_AND_RULES.md, phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, phase_2/06_FRONTEND_AND_QA_PHASE_2.md. Depends on: specs/ui/vfx-and-juice.md.

# Spec: UI — Phase 2 Visual Effects (VFX) & Juice

## Status
Draft

## Type
Improvement (extends visual effects engine and event mappings from `specs/ui/vfx-and-juice.md` for Phase 2 systems)

## Goal
Specify visual effects (VFX), particle emitters, depth shaders, optical sunbeams, and reward animations for Phase 2 gameplay mechanics (M051–M099), three-layer depth cues, and LiveOps features while respecting strict low-tier particle limits and accessibility modes.

## Current State
Design documented in `VFX_IMPLEMENTATION.md` and `phase_2/` docs, not yet implemented.
- Phase 1 VFX in `specs/ui/vfx-and-juice.md` established particle pool architectures, single `Ticker` dynamic layer painting via `drawAtlas`, and Phase 1 mechanic event bindings.
- Phase 2 introduces 8-directional diagonal slithers, 3-layer vertical depth cues, sunbeams, continuous sliding, and LiveOps visual celebrations.

## Proposed Change
Extend `VfxService` and `BoardAnimator` to map Phase 2 events to existing generic effect classes (standard §4):

### 1. Phase 2 Mechanics VFX Mapping
Reuses generic effect classes from `VFX_IMPLEMENTATION.md` §4 without creating unbudgeted classes:

| Event / Mechanic | Effect Class | Visual Details | Particle Cap (Low / Mid / High) |
|---|---|---|---|
| M051 Diagonal Exit | `exit_trail` | Diagonal particle wake aligned to 45° angle with leaf sparkles | Low: fade only, Mid: 12, High: 25 |
| M053 Rolling Coconut Push | `dust_puff` | Soft dirt puff at block base as coconut rolls 1 cell forward | Low: 0, Mid: 8, High: 15 |
| M054 Ice Slide Crate | `dust_puff` + `lane_warp` | Continuous ice frost trail following sliding crate until impact | Low: 0, Mid: 10, High: 20 |
| M055 Pressure Plate Click | `state_toggle` | Small stone ring pulse (200 ms) when depressed | Low: 0, Mid: 6, High: 12 |
| M069 Treetop Platform Depth | Ambient depth shading | Soft atmospheric haze applied between Canopy and Treetop layers | Shader pass (0 particles) |
| M079 Sub-board Rotor | `rotate_swoosh` | 90° clockwise rotation arc with swirling autumn leaves | Low: 0, Mid: 15, High: 30 |
| M084–M089 Sunbeams & Mirrors | `beam_glow` | Luminous golden light rays rendered using `BlendMode.plus` | Low: beam only, Mid: 10, High: 20 |
| M092 Centipede Split | `morph_flash` | Subtle wooden splinter pop as segments disconnect | Low: 0, Mid: 8, High: 16 |
| M097 Bamboo Dominoes | `domino_chain` | Sequential pulse waves traversing dominoes spaced 60 ms apart | Low: 0, Mid: 12, High: 24 |
| M098 Prowling Mongoose | `guardian_hit` | Prowling paw dust puff on each step | Low: 0, Mid: 6, High: 12 |

### 2. LiveOps Visual Celebrations
- **Sticker Album Stamp:**
  - Class: `chest_burst` (scaled down).
  - Visual: Stamp hammers down with 12 dp squash, emitting radial paper dust and gold star sparkles.
  - Particles: Low 0, Mid 15, High 30.
- **Weekly Star Race:**
  - Level Complete notch advance: Small celebratory green leaf trail behind snake avatar.
  - Podium Celebration (1st Place): `win_confetti` with golden laurel crown glow.
- **Piggy Bank Smash:**
  - Class: `hammer_impact` + `chest_burst`.
  - Visual: Wooden hammer strikes ceramic piggy bank; shards shatter outwards accompanied by cascading 3D coin trails (`coin_trail`).
  - Particles: Low 20, Mid 60, High 100.
- **Cosmetics Equipped Trails:**
  - `skin_emerald_vine`: Soft trailing ivy leaves (Mid: 8, High: 16).
  - `skin_moonlight_glow`: Soft blue luminescent stardust (Mid: 10, High: 20).
  - `skin_golden_cobra`: Golden sparkle embers (Mid: 12, High: 24).

### 3. Level 1000 Finale: Grand Celebration
- **Event:** L1000 completion trigger.
- **Effects:** Combined `win_confetti` + `chest_burst` + `beam_glow` solar flare radiating from the Sun Temple disc.
- **Tier Particles:** Low: 30, Mid: 80, High: 150 particles (capped at standard §5 tier limits).

### 4. Accessibility & Quality Rules
- **Reduce Motion:**
  - Disables board shakes and rotational swooshes.
  - Replaces beam pulses and sliding trails with clean static alpha transitions.
- **Color-Blind Safety:**
  - Sunbeams and receivers always combine color with unique geometric runic symbols (e.g., Red = Triangle, Yellow = Diamond).
  - Red blocker bump flashes are always paired with directional chevron indicators and haptic pulses.

## Affected Files
- `lib/features/gameplay/presentation/vfx/vfx_service.dart` (extended with Phase 2 event bindings)
- `lib/features/gameplay/presentation/vfx/effects/sunbeam_effect.dart` (to be created)
- `lib/features/gameplay/presentation/vfx/effects/sliding_trail_effect.dart` (to be created)
- `lib/features/album/presentation/vfx/stamp_animation.dart` (to be created)
- `assets/vfx/atlas.webp` (updated sprite atlas including Phase 2 particle textures)

## Risks
- Rapid simultaneous particle bursts during large domino chains (M097) or multi-beam reflections causing frame drops on low-end devices. Mitigated by strict particle pooling and tier clamping.

## Open Questions
- None. VFX classes, particle limits, and accessibility rules match `VFX_IMPLEMENTATION.md` and `phase_2/` docs.

Source docs: phases/phase_14/06_UI_AND_QA_PHASE_14.md, ../../VFX_IMPLEMENTATION.md §4, §5, §6, ../../SOUND_EFFECTS_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-13-vfx.md.

# Spec: UI — Phase 14 Visual Effects (VFX) and Juice

## Status
Draft

## Type
New Feature

## Goal
Implement hardware-accelerated crystal reflection glints, cross-axis water ripple waves, twin board golden splash bursts, inverse vector reverse plumes, and the Level 7,000 Grand Finale obsidian shimmer explosion, conforming strictly to device particle budgets.

## Current State
Design documented in `phases/phase_14/06_UI_AND_QA_PHASE_14.md`, `VFX_IMPLEMENTATION.md`, and `SOUND_EFFECTS_IMPLEMENTATION.md`, not yet implemented.
- Previous VFX specs covered mist dissipation and false wall liquid ripples.
- Phase 14 introduces crystalline refractive sparkles, synchronized bilateral particle trails, reverse vapor plumes, and obsidian shimmer bursts.

## Proposed Change
Extend `lib/features/vfx/` with Phase 14 reflection and mirror world effect classes:

### 1. Phase 14 VFX Catalog & Effect Classes

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particle Limits |
|---|---|---|---|
| **M651 Mirror Slither** | `mirror_crystal_sparkle` | Dual trails of crystalline light flecks and refraction sparks follow both slithering partners | Low: 0 particles (glow trail)<br>Mid: 12 particles<br>High: 24 particles |
| **M652 Reflection Unlock** | `water_ripple_wave` | Luminous concentric water wave glides across the central axis and bursts into sparkling foam on gate impact | Low: 0 particles (line flash)<br>Mid: 10 particles<br>High: 20 particles |
| **M653 Twin Board Clear** | `twin_board_splash` | Symmetrical golden fountain splashes erupting concurrently across both mirrored grids | Low: 0 particles (screen pulse)<br>Mid: 14 particles<br>High: 28 particles |
| **M654 Inverse Slither** | `inverse_motion_smoke` | Soft violet counter-flow smoke trails behind inverse snake as it slithers backward | Low: 0 particles (reversed alpha fade)<br>Mid: 8 particles<br>High: 16 particles |
| **Axis Collision Bonk** | `axis_ripple_bonk` | Symmetrical double impact ripples with starburst flecks at both blocked heads | Low: 0 particles<br>Mid: 6 particles<br>High: 12 particles |
| **Level 7000 Grand Finale** | `obsidian_shimmer_burst` | Grand obsidian crystal explosion, kaleidoscopic light refractions, and golden confetti showers | Low: 30 particles<br>Mid: 80 particles<br>High: 150 particles |

---

### 2. Audio Mapping (SFX) Integration
- `sfx_mirror_slither.ogg`: Harmonized dual-channel stereo crystal chime sliding with movement.
- `sfx_reflect_unlock.wav`: Melodic glass bell chime followed by rushing water.
- `sfx_twin_clear.ogg`: Synchronized double splash and victorious aquatic chord.
- `sfx_inverse_swoosh.wav`: Deep reverse Doppler-shift whoosh sound.
- `sfx_pond_bonk.wav`: Soft double aquatic slap signifying synchronized blockage.
- `sfx_mirror_finale.ogg`: Grand orchestral mirror fanfare celebrating Level 7,000 completion.

---

### 3. Device Tier Budgets & Invariants
- **Particle Caps:**
  - Low-Tier ($\le 2\text{GB RAM}$): Maximum concurrent **30 particles**.
  - Mid-Tier ($4\text{GB RAM}$): Maximum concurrent **80 particles**.
  - High-Tier (Flagship): Maximum concurrent **150 particles**.
- **Frame Rate Target:** Stable 60 FPS across all tiers, min 50 FPS during simultaneous dual-partner slither on Low-Tier devices.
- **Canvas Mirroring Fallback:** On Low-Tier hardware, complex refraction shaders fall back to hardware 2D matrix scale transforms (`canvas.scale(-1, 1)`).

---

### 4. Accessibility & Reduce Motion (Standard §5.3)
- When **Reduce Motion** is enabled:
  - Kaleidoscopic refractions and crystal sparkle bursts are disabled.
  - Symmetrical impact ripples are replaced by static warning icons.
  - Screen shake and camera zoom punches on Level 7000 are suppressed.

## Affected Files
- `lib/features/vfx/phase_14_vfx_pack.dart` (to be created)
- `assets/vfx/phase_14/` (to be created)
- `assets/audio/sfx/phase_14/` (to be created)
- `test/vfx/phase_14_vfx_budget_test.dart` (to be created)

## Risks and Open Questions
- **Dual-Channel Stereo Audio Pan:** Spatial panning `sfx_mirror_slither.ogg` across left and right audio channels enhances immersion on stereo headphones, but on mono phone speakers must mix down cleanly to prevent phase cancellation.

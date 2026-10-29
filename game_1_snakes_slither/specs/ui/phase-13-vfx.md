Source docs: phases/phase_13/06_UI_AND_QA_PHASE_13.md, ../../VFX_IMPLEMENTATION.md §4, §5, §6, ../../SOUND_EFFECTS_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-12-vfx.md.

# Spec: UI — Phase 13 Visual Effects (VFX) and Juice

## Status
Draft

## Type
New Feature

## Goal
Implement hardware-accelerated mist dispersal bursts, trick fog condensation plumes, false wall ripple dissolves, glow stone ignition flashes, and the Grand Level 6,500 Finale sunlight dissolution burst within device particle budgets.

## Current State
Design documented in `phases/phase_13/06_UI_AND_QA_PHASE_13.md`, `VFX_IMPLEMENTATION.md`, and `SOUND_EFFECTS_IMPLEMENTATION.md`, not yet implemented.
- Previous VFX specs covered atmospheric wind gusts and falling fruit impacts.
- Phase 13 introduces volumetric mist vapor simulation, optical illusion phasing, and ethereal sunlight beams.

## Proposed Change
Extend `lib/features/vfx/` with Phase 13 fog and illumination effect classes:

### 1. Phase 13 VFX Catalog & Effect Classes

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particle Limits |
|---|---|---|---|
| **M601 Scout Clearance** | `mist_dispel_burst` | Fog rolls rapidly outward and vaporizes into sparkling chartreuse motes as scout exits | Low: 0 particles (alpha fade)<br>Mid: 12 particles<br>High: 24 particles |
| **M602 Trick Mist Condense** | `trick_fog_condense` | Swirling lavender mist wisps coalesce and condense downward over vacated tile | Low: 0 particles (alpha fade-in)<br>Mid: 8 particles<br>High: 16 particles |
| **M603 False Wall Pass** | `false_wall_ripple` | Stone texture warps with water-like liquid ripple and turns translucent canvas as snake phases through | Low: 0 particles (crossfade)<br>Mid: 10 particles<br>High: 20 particles |
| **M604 Glow Stone Press** | `glow_stone_ignite` | Radial wave of warm sunlight expands across $3 \times 3$ area with sparkling dust flecks | Low: 0 particles (light circle)<br>Mid: 12 particles<br>High: 24 particles |
| **Hidden Wall Bonk** | `fog_shadow_bonk` | Dull shadow displacement wave with head-shake starburst on blocked veiled tile | Low: 0 particles<br>Mid: 6 particles<br>High: 12 particles |
| **Level 6500 Grand Finale** | `sunlight_mist_dissolve` | Radiant golden sunbeams pierce through all remaining mist, evaporating fog in sparkling rainbow clouds | Low: 30 particles<br>Mid: 80 particles<br>High: 150 particles |

---

### 2. Audio Mapping (SFX) Integration
- `sfx_mist_clear.ogg`: Gentle rushing wind chime with uplifting melodic glissando.
- `sfx_mist_whisper.wav`: Subtle eerie atmospheric whisper as fog re-condenses.
- `sfx_wall_phase.wav`: Shimmering harmonic frequency shift as snake phases through canvas wall.
- `sfx_glow_light.wav`: Resonant crystal chime upon pressure plate depression.
- `sfx_wood_bonk.wav`: Hollow wooden thud signifying harmless mist collision.
- `sfx_mist_finale.ogg`: Grand tranquil orchestral dawn fanfare dissolving the mist.

---

### 3. Device Tier Budgets & Invariants
- **Particle Caps:**
  - Low-Tier ($\le 2\text{GB RAM}$): Maximum concurrent **30 particles**.
  - Mid-Tier ($4\text{GB RAM}$): Maximum concurrent **80 particles**.
  - High-Tier (Flagship): Maximum concurrent **150 particles**.
- **Frame Rate Target:** Stable 60 FPS across all tiers, min 50 FPS during scout dissipation waves on Low-Tier devices.
- **Shader Optimization:** Fog alpha blending relies on pre-multiplied alpha textures to prevent draw-call bottlenecks on low-tier mobile chipsets.

---

### 4. Accessibility & Reduce Motion (Standard §5.3)
- When **Reduce Motion** is enabled:
  - Mist dispersal executes as an instant 50 ms alpha fade without expanding cloud drift.
  - False wall liquid ripple distortion is replaced with an immediate transparency snap.
  - Sunlight beam screen flashes on Level 6500 are disabled.

## Affected Files
- `lib/features/vfx/phase_13_vfx_pack.dart` (to be created)
- `assets/vfx/phase_13/` (to be created)
- `assets/audio/sfx/phase_13/` (to be created)
- `test/vfx/phase_13_vfx_budget_test.dart` (to be created)

## Risks and Open Questions
- **GPU Fill Rate on Fog Dissolves:** Clearing large fog regions ($14 \times 14$) with particle emitters can saturate GPU fill rates. Particle spawning must be restricted strictly to perimeter border cells of the cleared area rather than filling every interior cell.

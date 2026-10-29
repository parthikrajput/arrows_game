Source docs: phases/phase_12/06_UI_AND_QA_PHASE_12.md, ../../VFX_IMPLEMENTATION.md §4, §5, §6, ../../SOUND_EFFECTS_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-11-vfx.md.

# Spec: UI — Phase 12 Visual Effects (VFX) and Juice

## Status
Draft

## Type
New Feature

## Goal
Implement hardware-accelerated monsoon wind gusts, falling fruit impact dust puffs, anti-gravity suspension shimmers, ground-shake sliding rumbles, and the Level 6,000 Grand Finale monsoon tempest burst, strictly conforming to device particle limits.

## Current State
Design documented in `phases/phase_12/06_UI_AND_QA_PHASE_12.md`, `VFX_IMPLEMENTATION.md`, and `SOUND_EFFECTS_IMPLEMENTATION.md`, not yet implemented.
- Previous VFX specs covered aquatic lily ripples and cross-board beams.
- Phase 12 introduces atmospheric wind screen sweeps, heavy obstacle impact feedback, anti-gravity levitation motes, and storm tempest celebrations.

## Proposed Change
Extend `lib/features/vfx/` with Phase 12 atmospheric physics and impact effect classes:

### 1. Phase 12 VFX Catalog & Effect Classes

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particle Limits |
|---|---|---|---|
| **M551 Lever Rotation** | `gravity_shift_wind` | Translucent monsoon gust lines sweep across board matching new gravity orientation | Low: 0 particles (screen wipe)<br>Mid: 12 particles<br>High: 25 particles |
| **M552 Fruit Drop** | `fruit_impact_dust` | Fruit plunges downward, releasing a puff of dirt motes and autumn leaf fragments upon impact | Low: 0 particles (impact scale bounce)<br>Mid: 10 particles<br>High: 20 particles |
| **M553 Floaty Lily Hold** | `anti_grav_float_shimmer` | Soft violet anti-gravity aura and levitating pollen motes pulse gently beneath suspended fruit | Low: 0 particles (glow shader)<br>Mid: 8 particles<br>High: 16 particles |
| **M554 Heavy Python Slide** | `ground_shake_slide` | Heavy snake slides downward with ground dust trails and a localized micro-rumble pulse | Low: 0 particles (sliding motion)<br>Mid: 8 particles<br>High: 16 particles |
| **Fruit Stops on Snake** | `snake_cushion_ripple` | Snake body squishes slightly with soft green compression wave, acting as a flexible mattress | Low: 0 particles (squash/stretch)<br>Mid: 4 particles<br>High: 8 particles |
| **Level 6000 Grand Finale** | `monsoon_hurricane_burst` | Majestic storm tempest burst, flashing golden lightning bolts, swirling wind vortexes, and tropical flower rain | Low: 30 particles<br>Mid: 80 particles<br>High: 150 particles |

---

### 2. Audio Mapping (SFX) Integration
- `sfx_lever_ratchet.wav`: Heavy mechanical bronze cog click and ratchet turn.
- `sfx_fruit_thud.wav`: Resonant heavy coconut thud impacting stone floor.
- `sfx_lily_hum.ogg`: Ethereal low-frequency anti-gravity hum.
- `sfx_heavy_python_scrape.wav`: Gritty scraping stone friction sound as heavy python slides.
- `sfx_soft_thud.wav`: Soft muffled thud indicating fruit safely landing on snake scales.
- `sfx_monsoon_finale.ogg`: Triumphant orchestral storm symphony commemorating Level 6,000 completion.

---

### 3. Device Tier Budgets & Invariants
- **Particle Caps:**
  - Low-Tier ($\le 2\text{GB RAM}$): Maximum concurrent **30 particles**.
  - Mid-Tier ($4\text{GB RAM}$): Maximum concurrent **80 particles**.
  - High-Tier (Flagship): Maximum concurrent **150 particles**.
- **Frame Rate Target:** Stable 60 FPS across all tiers, min 50 FPS during multi-fruit cascade drops on Low-Tier devices.
- **Squash & Stretch Budget:** Snake impact cushion utilizes 2D sprite procedural deformation matrices without creating new texture allocations.

---

### 4. Accessibility & Reduce Motion (Standard §5.3)
- When **Reduce Motion** is enabled:
  - Screen shake and camera rumble on fruit impacts and python slides are disabled.
  - Wind sweep gust lines are replaced by an immediate compass needle snap.
  - Falling obstacles teleport instantly to resting cells over 50 ms alpha transitions.

## Affected Files
- `lib/features/vfx/phase_12_vfx_pack.dart` (to be created)
- `assets/vfx/phase_12/` (to be created)
- `assets/audio/sfx/phase_12/` (to be created)
- `test/vfx/phase_12_vfx_budget_test.dart` (to be created)

## Risks and Open Questions
- **Cascade Audio Overlap:** In multi-fruit drops (e.g. 5 fruits dropping at once), triggering 5 simultaneous thud audio instances could clip the sound channel. The audio engine must enforce a voice limit of max 2 concurrent thuds with subtle pitch variation.

Source docs: phases/phase_10/06_UI_AND_QA_PHASE_10.md, ../../VFX_IMPLEMENTATION.md §4, §5, §6, ../../SOUND_EFFECTS_IMPLEMENTATION.md. Depends on: specs/ui/vfx-and-juice.md, specs/ui/phase-9-vfx.md.

# Spec: UI — Phase 10 Visual Effects (VFX) and Juice

## Status
Draft

## Type
New Feature

## Goal
Implement hardware-accelerated drum acoustic pulse rings, totem gemstone glows, parade celebratory confetti, echo resonance waves, and the Grand Level 5,000 Halfway Milestone celebration fireworks, conforming strictly to device particle budgets.

## Current State
Design documented in `phases/phase_10/06_UI_AND_QA_PHASE_10.md`, `VFX_IMPLEMENTATION.md`, and `SOUND_EFFECTS_IMPLEMENTATION.md`, not yet implemented.
- Previous VFX specs covered aquatic bifurcation splashes and fluid streams.
- Phase 10 introduces rhythmic acoustic pulse rings, tribal carving illumination, carnival parade confetti, and the monumental Level 5,000 celebration sequence.

## Proposed Change
Extend `lib/features/vfx/` with Phase 10 rhythm, totem, and halfway celebration effect classes:

### 1. Phase 10 VFX Catalog & Effect Classes

| Event / Mechanic | Effect Class | Visual Behavior | Tier Max Particle Limits |
|---|---|---|---|
| **M451 Drum Beat Cycle** | `drum_pulse_ring` | Concentric circular acoustic shockwave ripples outward from drum gate base on state transition | Low: 0 particles (expanding 2D ring)<br>Mid: 8 particles<br>High: 16 particles |
| **M452 Totem Match** | `totem_carve_glow` | Inscribed tribal relief carvings blaze with radiant golden-amber luminescence | Low: 0 particles (alpha blend)<br>Mid: 12 particles<br>High: 24 particles |
| **M453 Parade Step** | `parade_confetti` | Burst of multi-colored festival paper confetti and golden starbursts upon valid ordinal exit | Low: 0 particles<br>Mid: 15 particles<br>High: 30 particles |
| **M454 Echo Resonance** | `echo_resonance_wave` | Luminous harmonic aura sweeps across the board, linking Master and Echo lagoons | Low: 0 particles (screen flash)<br>Mid: 10 particles<br>High: 20 particles |
| **Wrong Order Bonk** | `order_bonk_shake` | Head blushes red with blunt impact sparks and quick comic head-shake wobble | Low: 0 particles<br>Mid: 6 particles<br>High: 12 particles |
| **Level 5000 Halfway Finale** | `halfway_5000_grand_burst` | Grand sky fireworks, streaming golden ribbons, dancing snake silhouettes, and 5,000-banner confetti | Low: 30 particles<br>Mid: 80 particles<br>High: 150 particles |

---

### 2. Audio Mapping (SFX) Integration
- `sfx_drum_beat.ogg`: Resonant acoustic tribal drum beat (open vs closed pitch variation).
- `sfx_totem_chime.wav`: Melodic ancient wind chime / wooden marimba chime.
- `sfx_parade_step.wav`: Upbeat ceremonial horn / festival parade fanfare.
- `sfx_echo_harp.ogg`: Ethereal acoustic harp resonance with harmonic echo.
- `sfx_drum_error.wav`: Muffled dull wooden thud signifying invalid move sequence.
- `sfx_festival_halfway.ogg`: Orchestral celebration symphony commemorating the 5,000-level halfway milestone.

---

### 3. Device Tier Budgets & Invariants
- **Particle Caps:**
  - Low-Tier ($\le 2\text{GB RAM}$): Maximum concurrent **30 particles**.
  - Mid-Tier ($4\text{GB RAM}$): Maximum concurrent **80 particles**.
  - High-Tier (Flagship): Maximum concurrent **150 particles**.
- **Frame Rate Target:** 60 FPS guaranteed across all tiers, min 50 FPS during Level 5000 finale confetti.
- **Instanced Audio Cache:** Drum beat sound effects are held in a low-latency sound pool to eliminate audio playback delay upon rapid moves.

---

### 4. Accessibility & Reduce Motion (Standard §5.3)
- When **Reduce Motion** is enabled:
  - Acoustic pulse rings render as a static outline highlight without expanding shockwaves.
  - Confetti explosions and firework bursts are replaced with smooth static banner overlays.
  - Screen shake and camera zoom punches on Level 5000 are disabled.

## Affected Files
- `lib/features/vfx/phase_10_vfx_pack.dart` (to be created)
- `assets/vfx/phase_10/` (to be created)
- `assets/audio/sfx/phase_10/` (to be created)
- `test/vfx/phase_10_vfx_budget_test.dart` (to be created)

## Risks and Open Questions
- **Level 5000 Climax VFX Load:** The Level 5000 halfway celebration features the most elaborate effects in the first half of the game. On Low-Tier devices, particle spawning must strictly conform to the 30-particle cap, relying on pre-rendered 2D sprite animations for fireworks rather than dynamic physics particles.

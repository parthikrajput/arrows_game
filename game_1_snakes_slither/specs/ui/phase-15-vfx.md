# Technical Specification: Phase 15 Visual Effects and Audio (River Delta)

**Status:** Draft  
**Phase:** 15 (Levels 7001–7500)  
**Theme:** River Delta (Conveyors & Tracks)  
**Document Type:** Technical VFX/Audio Specification  
**Source Cross-Reference:** [phases/phase_15/06_UI_AND_QA_PHASE_15.md](../../phases/phase_15/06_UI_AND_QA_PHASE_15.md), [VFX_IMPLEMENTATION.md](../../VFX_IMPLEMENTATION.md)

---

## 1. Particle Effects & Visual Assets

| Effect Identifier | Trigger Condition | Visual Presentation | Particle Count / Budget |
| :--- | :--- | :--- | :---: |
| `vfx_conveyor_flow` | Continuous (Active Belts) | Water chevrons flowing along vector with trailing foam | Max 24 particles/tile |
| `vfx_tide_reverse_surge` | M702 Tide Reversal | Wave crest wash sweeping across grid with spray | 80 particles, 400ms duration |
| `vfx_sluice_water_rush` | M703 Sluice Gate Open | Water eruption rushing down canal channel | 60 particles, 300ms duration |
| `vfx_whirlpool_spin` | M704 Whirlpool Active | Concentric vortex swirl with rotating bubble spray | 30 particles/loop |
| `vfx_switch_flip` | M701 Lever Toggled | Brass lever swing with mechanical copper spark burst | 12 particles, 150ms duration |
| `vfx_conveyor_bonk` | Snake blocked on belt | Water splash ripple expanding outward | 20 particles, 250ms duration |
| `vfx_delta_finale_burst`| Level 7500 Complete | Massive tidal fountain erupting across screen with gold sparkles | 350 particles, 2.5s duration |

---

## 2. Audio Effects & Sound Design

| Sound ID | File Asset | Pitch / Volume Variation | Mix Channel |
| :--- | :--- | :--- | :--- |
| `sfx_switch_click` | `sfx_switch_click.wav` | $\pm 5\%$ pitch randomize, volume 0.8 | SFX / Interactive |
| `sfx_tide_surge` | `sfx_tide_surge.ogg` | Deep resonant ocean wave swell, volume 0.85 | SFX / Environment |
| `sfx_sluice_gate` | `sfx_sluice_gate.wav` | Heavy stone gate grinding into position, volume 0.9 | SFX / Interactive |
| `sfx_whirlpool_loop`| `sfx_whirlpool_loop.ogg`| Ambient swirling water loop, volume 0.6 | Ambient / Loop |
| `sfx_water_stall` | `sfx_water_stall.wav` | Dull hydraulic thud and splash, volume 0.7 | SFX / Feedback |
| `sfx_delta_finale` | `sfx_delta_finale.ogg` | Orchestral river delta fanfare with water chimes | Music / Victory |

---

## 3. Haptic Feedback Mapping
- **M701 Fork Toggle:** `HapticFeedback.lightImpact()` (crisp 15ms tap).
- **M702 Tide Flip:** `HapticFeedback.mediumImpact()` (30ms wave pulse).
- **M703 Sluice Open/Close:** `HapticFeedback.heavyImpact()` (45ms stone shudder).
- **M704 Whirlpool Tangent Launch:** `HapticFeedback.selectionClick()` (rapid double-tap).
- **Conveyor Collision Bonk:** `HapticFeedback.vibrate()` (short 60ms failure buzz).

---

## 4. Performance Budgets & Device Scaling
- **Low-End Tier (Snapdragon 665 / 3GB):** Maximum 120 concurrent particles; disables secondary water foam shaders; maintains 60 FPS.
- **Mid & High Tier:** Full screen space refraction shader for whirlpool vortex; dynamic particle emitters; 60/120 FPS target.

---

## 5. References & Cross-Links
- [Phase 15 UI Additions](phase-15-ui-additions.md)
- [Phase 15 Signature System](../gameplay/phase-15-signature-system.md)
- [VFX Implementation Standard](../../VFX_IMPLEMENTATION.md)


# Technical Specification: Phase 19 Visual Effects and Audio (Remix B)

**Status:** Draft  
**Phase:** 19 (Levels 9001–9500)  
**Theme:** Remix B (Phase 7 to Phase 12 Mechanics Synergy)  
**Document Type:** Technical VFX/Audio Specification  
**Source Cross-Reference:** [phases/phase_19/06_UI_AND_QA_PHASE_19.md](../../phases/phase_19/06_UI_AND_QA_PHASE_19.md), [VFX_IMPLEMENTATION.md](../../VFX_IMPLEMENTATION.md)

---

## 1. Particle Effects & Visual Assets

| Effect Identifier | Trigger Condition | Visual Presentation | Particle Count / Budget |
| :--- | :--- | :--- | :---: |
| `vfx_wind_vine_growth` | M901 Vine advances | Sprouting green leaves and leafy trail whipped by wind gust | 20 particles, 300ms duration |
| `vfx_siphon_reversal` | M902 River vectors flip | Twin river water surge with foaming spray along bridge | 45 particles, 350ms duration |
| `vfx_monsoon_downbeat` | M903 Beat 3 triggers | Dramatic rain squall sweep with directional dust displacement | 60 particles, 400ms duration |
| `vfx_seismic_shockwave`| M904 Heavy python lands | Concentric ground fracture ring radiating $r=4$ tiles | 35 particles, 300ms duration |
| `vfx_echo_bell_ring` | Bell hit by shockwave | Golden acoustic resonance rings expanding upward | 15 particles, 250ms duration |
| `vfx_wild_currents_burst`| Level 9500 Grand Finale | Majestic waterfall spray explosion with rainbow prisms | 350 particles, 2.5s duration |

---

## 2. Audio Effects & Sound Design

| Sound ID | File Asset | Pitch / Volume Variation | Mix Channel |
| :--- | :--- | :--- | :--- |
| `sfx_gale_vine_rustle` | `sfx_gale_vine_rustle.ogg`| Whipping leaves with wind whoosh, volume 0.8 | SFX / Environment |
| `sfx_siphon_rush` | `sfx_siphon_rush.wav` | Rushing hydraulic torrent and lock release, volume 0.85 | SFX / Interactive |
| `sfx_monsoon_drum_down`| `sfx_monsoon_drum_down.ogg`| Resonant tribal bass drum downbeat with thunder crack | Music / Sync |
| `sfx_seismic_boom` | `sfx_seismic_boom.wav` | Deep bass sub-woofer bedrock shudder, volume 0.9 | SFX / Combat |
| `sfx_echo_bell_chime` | `sfx_echo_bell_chime.wav` | Crystal chime fading over 2.0s, volume 0.75 | SFX / Interactive |
| `sfx_wild_finale` | `sfx_wild_finale.ogg` | Epic late-era symphony with thunder percussion | Music / Victory |

---

## 3. Haptic Feedback Mapping
- **Wind Vine Growth:** `HapticFeedback.lightImpact()` (15ms leafy pulse).
- **River Siphon Flip:** `HapticFeedback.mediumImpact()` (25ms water surge).
- **Monsoon Downbeat:** `HapticFeedback.heavyImpact()` (40ms thunderous thud).
- **Seismic Shockwave:** `HapticFeedback.heavyImpact()` followed by decaying secondary buzz.
- **Echo Bell Chime:** `HapticFeedback.selectionClick()` (crisp metallic click).

---

## 4. Performance Budgets & Device Scaling
- **Low-End Tier (Snapdragon 665 / 3GB):** Maximum 100 concurrent particles; disables secondary water foam shaders; maintains rock-solid 60 FPS.
- **Mid & High Tier:** GPU particle simulations for monsoon squalls; screen-space refraction on water siphons; 60/120 FPS target.

---

## 5. References & Cross-Links
- [Phase 19 UI Additions](phase-19-ui-additions.md)
- [Phase 19 Signature System](../gameplay/phase-19-signature-system.md)
- [VFX Implementation Standard](../../VFX_IMPLEMENTATION.md)


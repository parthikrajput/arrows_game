# Technical Specification: Phase 20 Visual Effects and Audio (Grand Jungle Master)

**Status:** Draft  
**Phase:** 20 (Levels 9501–10,000)  
**Theme:** Grand Jungle Master (All Systems Culmination & Level 10,000 Grand Finale)  
**Document Type:** Technical VFX/Audio Specification  
**Source Cross-Reference:** [phases/phase_20/06_UI_AND_QA_PHASE_20.md](../../phases/phase_20/06_UI_AND_QA_PHASE_20.md), [VFX_IMPLEMENTATION.md](../../VFX_IMPLEMENTATION.md)

---

## 1. Particle Effects & Visual Assets

| Effect Identifier | Trigger Condition | Visual Presentation | Particle Count / Budget |
| :--- | :--- | :--- | :---: |
| `vfx_boss_telegraph_roar`| Boss spots snake | Crimson acoustic shockwave ring + red runic ground stripes | 35 particles, 300ms duration |
| `vfx_boss_rush_strike` | Boss charges forward | Dust storm charge trail with tearing claw mark decals | 50 particles, 250ms duration |
| `vfx_boss_stun_impact` | Boss hits obstacle | Golden dizzy stars and rock rubble fragments | 45 particles, 400ms duration |
| `vfx_omni_key_unlock` | Master key collected | Prismatic board-wide light pulse dissolving all locks | 100 particles, 600ms duration |
| `vfx_vortex_glide` | Snake enters vortex | Cosmic spiral suction and dimensional warp starfield | 40 particles, 300ms duration |
| `vfx_sovereign_coronation`| Snake mounts Crown | Golden column of light, diamond fireworks, and flower petal shower | 500 celebratory particles, 3.5s duration |

---

## 2. Audio Effects & Sound Design

| Sound ID | File Asset | Pitch / Volume Variation | Mix Channel |
| :--- | :--- | :--- | :--- |
| `sfx_boss_roar` | `sfx_boss_roar.ogg` | Deep resonant predator roar with bass shake, volume 0.95 | SFX / Boss |
| `sfx_boss_charge` | `sfx_boss_charge.wav` | Heavy galloping footsteps and tearing claws, volume 0.9 | SFX / Combat |
| `sfx_boss_crash_stun` | `sfx_boss_crash_stun.wav` | Massive stone collision followed by comic dizzy birds, vol 0.85 | SFX / Combat |
| `sfx_omni_unlock` | `sfx_omni_unlock.ogg` | Crystal bell cathedral chord echoing across board, vol 0.9 | SFX / Triumph |
| `sfx_vortex_warp` | `sfx_vortex_warp.ogg` | Cosmic spatial whoosh with bass hum, volume 0.8 | SFX / Interactive |
| `sfx_crown_coronation` | `sfx_crown_coronation.ogg`| Triumphant 10,000-level sovereign master symphony | Music / Climax |

---

## 3. Haptic Feedback Mapping
- **Boss Telegraph Roar:** `HapticFeedback.mediumImpact()` (25ms warning pulse).
- **Boss Charge Impact:** `HapticFeedback.heavyImpact()` (crisp 40ms collision thud).
- **Omni Key Pickup:** `HapticFeedback.selectionClick()` followed by rising vibration crescendo.
- **Vortex Warp:** `HapticFeedback.lightImpact()` (rapid double tap).
- **Crown Pedestal Coronation:** Series of 5 rhythmic heavy impact pulses celebrating the 10,000-level summit.

---

## 4. Performance Budgets & Device Scaling
- **Low-End Tier (Snapdragon 665 / 3GB):** Maximum 120 concurrent particles; disables post-process bloom; rock-solid 60 FPS target.
- **Mid & High Tier:** GPU particle simulations, screen-space refraction on cosmic vortexes, full dynamic illumination on crown light shafts, 60/120 FPS target.

---

## 5. References & Cross-Links
- [Phase 20 UI Additions](phase-20-ui-additions.md)
- [Phase 20 Signature System](../gameplay/phase-20-signature-system.md)
- [VFX Implementation Standard](../../VFX_IMPLEMENTATION.md)


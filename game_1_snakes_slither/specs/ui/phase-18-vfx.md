# Technical Specification: Phase 18 Visual Effects and Audio (Remix A)

**Status:** Draft  
**Phase:** 18 (Levels 8501–9000)  
**Theme:** Remix A (Early Eras Synergy / Data-Driven)  
**Document Type:** Technical VFX/Audio Specification  
**Source Cross-Reference:** [phases/phase_18/06_UI_AND_QA_PHASE_18.md](../../phases/phase_18/06_UI_AND_QA_PHASE_18.md), [VFX_IMPLEMENTATION.md](../../VFX_IMPLEMENTATION.md)

---

## 1. Particle Effects & Visual Assets

| Effect Identifier | Trigger Condition | Visual Presentation | Particle Count / Budget |
| :--- | :--- | :--- | :---: |
| `vfx_floor_elevation` | M851 Floor height change | Earthy stone dust puffs and golden gear spark burst | 16 particles, 350ms duration |
| `vfx_coconut_prism_roll`| M852 Coconut hits prism beam | Prismatic glass fracture sparks with radiant refraction rays | 24 radiant particles, 400ms duration |
| `vfx_portal_teleport` | M853 Snake enters portal | Purple/gold solar vortex swirl and starburst exit trail | 30 swirl particles, 250ms duration |
| `vfx_weight_trigger` | M854 Coconut depresses plate | Expanding ground dust ripple wave and latch lock flash | 12 particles, 200ms duration |
| `vfx_sunbeam_burst` | Level 9000 Grand Finale | Golden solar nova explosion with rainbow light curtains | 80 celebratory particles, 1.8s duration |

---

## 2. Audio Effects & Sound Design

| Sound ID | File Asset | Pitch / Volume Variation | Mix Channel |
| :--- | :--- | :--- | :--- |
| `sfx_cycle_shift` | `sfx_cycle_shift.ogg` | Soft mechanical bronze bell chime, 80dB LUFS | SFX / Environment |
| `sfx_coconut_impact`| `sfx_coconut_impact.ogg`| Resonant wooden impact with stone scraping thud, 82dB LUFS | SFX / Interactive |
| `sfx_burrow_warp` | `sfx_burrow_warp.ogg` | High-frequency shimmer followed by low swoosh, 85dB LUFS | SFX / Interactive |
| `sfx_trapdoor_clunk`| `sfx_trapdoor_clunk.ogg`| Solid iron latch engaging, 78dB LUFS | SFX / Interactive |
| `bgm_sanctuary` | `bgm_phase18_sanctuary.ogg`| Ancient jungle stone temple ambience with wind chimes | Music / Ambient |
| `sfx_remix_finale` | `sfx_remix_finale.ogg` | Majestic dawn fanfare with shimmering harp glissando | Music / Victory |

---

## 3. Haptic Feedback Mapping
- **Floor Elevation Transition:** `HapticFeedback.mediumImpact()` (25ms mechanical rumble).
- **Coconut Boulder Impact:** `HapticFeedback.heavyImpact()` (35ms solid thud).
- **Portal Warp Transit:** `HapticFeedback.lightImpact()` (15ms double click).
- **Pressure Plate Latch:** `HapticFeedback.selectionClick()` (click tap).
- **Finale Clear:** `HapticFeedback.heavyImpact()` followed by rhythmic victory pulses.

---

## 4. Performance Budgets & Device Scaling
- **Low-End Tier (Snapdragon 665 / 3GB):** Maximum 80 concurrent particles; billboard quad instancing; 60 FPS target.
- **Mid & High Tier:** Additive blending dynamic shaders for refraction rays; GPU vortex emitters; 60/120 FPS target.

---

## 5. References & Cross-Links
- [Phase 18 UI Additions](phase-18-ui-additions.md)
- [Phase 18 Signature System](../gameplay/phase-18-signature-system.md)
- [VFX Implementation Standard](../../VFX_IMPLEMENTATION.md)

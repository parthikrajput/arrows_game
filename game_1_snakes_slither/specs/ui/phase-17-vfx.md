# Technical Specification: Phase 17 Visual Effects and Audio (Mongoose Clan)

**Status:** Draft  
**Phase:** 17 (Levels 8001–8500)  
**Theme:** Mongoose Clan (Guardians)  
**Document Type:** Technical VFX/Audio Specification  
**Source Cross-Reference:** [phases/phase_17/06_UI_AND_QA_PHASE_17.md](../../phases/phase_17/06_UI_AND_QA_PHASE_17.md), [VFX_IMPLEMENTATION.md](../../VFX_IMPLEMENTATION.md)

---

## 1. Particle Effects & Visual Assets

| Effect Identifier | Trigger Condition | Visual Presentation | Particle Count / Budget |
| :--- | :--- | :--- | :---: |
| `vfx_guardian_hit` | Snake exits damaging guardian | Fiery impact spark burst and shockwave ring | 40 particles, 250ms duration |
| `vfx_guardian_shield_deflect`| Slither exiting shielded boss | Crystalline hexagonal barrier flash with blue deflection spark | 25 particles, 200ms duration |
| `vfx_guardian_retreat` | Guardian reaches 0 HP | Smoke poof + burrow dirt fountain as mongoose scurries off | 60 particles, 400ms duration |
| `vfx_spawner_throw` | Mama Mongoose tosses rock | Arc trajectory dust trail followed by heavy dirt impact puff | 35 particles, 300ms duration |
| `vfx_core_meltdown` | Den Core destroyed | Golden beam eruption shatters fortress walls | 90 particles, 600ms duration |
| `vfx_mongoose_finale_burst`| Level 8500 Complete | Royal clan victory firework burst with golden paw prints | 380 particles, 2.5s duration |

---

## 2. Audio Effects & Sound Design

| Sound ID | File Asset | Pitch / Volume Variation | Mix Channel |
| :--- | :--- | :--- | :--- |
| `sfx_guardian_grunt` | `sfx_guardian_grunt.wav` | Low boss grunt with pitch randomize $\pm 5\%$, vol 0.85 | SFX / Combat |
| `sfx_shield_clash` | `sfx_shield_clash.wav` | High-pitched metallic ricochet, volume 0.8 | SFX / Combat |
| `sfx_burrow_retreat`| `sfx_burrow_retreat.ogg`| Quick dirt scurrying and pop, volume 0.75 | SFX / Environment |
| `sfx_rock_thud` | `sfx_rock_thud.wav` | Heavy stone landing on packed earth, volume 0.85 | SFX / Environment |
| `sfx_lever_drop` | `sfx_lever_drop.wav` | Heavy mechanical iron latch release, volume 0.8 | SFX / Interactive |
| `sfx_clan_finale` | `sfx_clan_finale.ogg` | Tribal percussion crescendo with triumphal horn section | Music / Victory |

---

## 3. Haptic Feedback Mapping
- **Guardian Damage Hit:** `HapticFeedback.heavyImpact()` (crisp 35ms combat shudder).
- **Shield Deflection:** `HapticFeedback.vibrate()` (rapid 40ms buzz).
- **Guardian Defeat Retreat:** `HapticFeedback.mediumImpact()` (25ms double thud).
- **Rock Spawn Drop:** `HapticFeedback.lightImpact()` (15ms ground tap).
- **Shield Lever Switch:** `HapticFeedback.selectionClick()` (click tap).

---

## 4. Performance Budgets & Device Scaling
- **Low-End Tier (Snapdragon 665 / 3GB):** Maximum 100 concurrent particles; disables secondary ground smoke ripples; 60 FPS target.
- **Mid & High Tier:** Full dynamic lighting on shield deflection, high-res dirt particle emitters, 60/120 FPS target.

---

## 5. References & Cross-Links
- [Phase 17 UI Additions](phase-17-ui-additions.md)
- [Phase 17 Signature System](../gameplay/phase-17-signature-system.md)
- [VFX Implementation Standard](../../VFX_IMPLEMENTATION.md)

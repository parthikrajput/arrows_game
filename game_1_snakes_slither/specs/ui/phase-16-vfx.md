# Technical Specification: Phase 16 Visual Effects and Audio (Treasure Keys)

**Status:** Draft  
**Phase:** 16 (Levels 7501–8000)  
**Theme:** Treasure Keys (Keys Deluxe)  
**Document Type:** Technical VFX/Audio Specification  
**Source Cross-Reference:** [phases/phase_16/06_UI_AND_QA_PHASE_16.md](../../phases/phase_16/06_UI_AND_QA_PHASE_16.md), [VFX_IMPLEMENTATION.md](../../VFX_IMPLEMENTATION.md)

---

## 1. Particle Effects & Visual Assets

| Effect Identifier | Trigger Condition | Visual Presentation | Particle Count / Budget |
| :--- | :--- | :--- | :---: |
| `vfx_key_vine_dissolve` | M751 Vine Lock Release | Golden vine shatters into shimmering golden leaves & petals | 60 particles, 400ms duration |
| `vfx_key_crafting_forge` | M752 Both Halves Collected | Bright golden anvil flash and spark burst in HUD ribbon | 45 particles, 300ms duration |
| `vfx_skeleton_shatter` | M753 Skeleton Key Used | Universal key vaporizes into radiant golden prismatic shockwave | 75 particles, 500ms duration |
| `vfx_key_swap_beam` | M754 Pedestal Swap | Vertical beam of light connecting snake and pedestal | 30 particles, 250ms duration |
| `vfx_lock_recoil_spark` | Snake hitting locked gate | Red and gold deflection sparks with lock shudder | 15 particles, 200ms duration |
| `vfx_vault_grand_burst` | Level 8000 Grand Finale | Massive treasure burst: golden coins, keys, and gemstones | 400 particles, 3.0s duration |

---

## 2. Audio Effects & Sound Design

| Sound ID | File Asset | Pitch / Volume Variation | Mix Channel |
| :--- | :--- | :--- | :--- |
| `sfx_vine_key_snap` | `sfx_vine_key_snap.ogg` | Sharp snapping branch followed by musical chime, vol 0.85 | SFX / Environment |
| `sfx_key_anvil_clink`| `sfx_key_anvil_clink.wav`| Crisp metallic bell clink on forging key halves, vol 0.9 | SFX / Interactive |
| `sfx_skeleton_unlock`| `sfx_skeleton_unlock.wav`| Resonant ancient master tumbler unlock mechanism, vol 0.95 | SFX / Interactive |
| `sfx_key_swap_woosh` | `sfx_key_swap_woosh.wav` | Mystical energy whoosh, volume 0.75 | SFX / Interactive |
| `sfx_lock_rattle` | `sfx_lock_rattle.wav` | Heavy wrought-iron gate rattle upon blocked path, vol 0.7 | SFX / Feedback |
| `sfx_vault_finale` | `sfx_vault_finale.ogg` | Orchestral brass fanfare with triumphal church bells | Music / Victory |

---

## 3. Haptic Feedback Mapping
- **M751 Vine Lock Release:** `HapticFeedback.mediumImpact()` (25ms snap pulse).
- **M752 Key Forge:** `HapticFeedback.selectionClick()` followed by `HapticFeedback.lightImpact()` (double clink).
- **M753 Skeleton Key Unlock:** `HapticFeedback.heavyImpact()` (crisp 40ms unlocking click).
- **M754 Pedestal Key Swap:** `HapticFeedback.lightImpact()` (15ms whoosh tap).
- **Locked Gate Recoil:** `HapticFeedback.vibrate()` (60ms error shudder).

---

## 4. Performance Budgets & Device Scaling
- **Low-End Tier (Snapdragon 665 / 3GB):** Maximum 100 concurrent particles; disables secondary bloom passes on golden vines; rock solid 60 FPS.
- **Mid & High Tier:** Full high-dynamic-range golden glow shaders, GPU particle simulations, 60/120 FPS target.

---

## 5. References & Cross-Links
- [Phase 16 UI Additions](phase-16-ui-additions.md)
- [Phase 16 Signature System](../gameplay/phase-16-signature-system.md)
- [VFX Implementation Standard](../../VFX_IMPLEMENTATION.md)


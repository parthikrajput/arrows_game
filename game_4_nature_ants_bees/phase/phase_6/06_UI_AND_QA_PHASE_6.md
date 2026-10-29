# 06 — UI, VFX & QA, Phase 6 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Optical UI indicators, Petal filter and sundial VFX, CI validation, performance budgets અને Phase 6 QA checklist.

**Related docs:** [Phase 6 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md)

---

## 1. UI Components for Sunlit Garden
- **Colored Beam Rendering:**
  - અર્ધપારદર્શક એડિટિવ ગ્લો લાઈનો (`BlendMode.plus`) જે ફિલ્ટરમાંથી પસાર થતાં લાલ, પીળો કે વાદળી રંગ પકડે છે.
- **Sundial Move Counter HUD:**
  - સનડાયલ લેન્સની ઉપર નાનો સૂર્ય-ડાયલ આઇકન જે આગામી સ્ટેટ ચેન્જ (ON/OFF) માટે બાકી રહેલા Moves દર્શાવે છે (ઉદા. "3 moves left").
- **Shade Patch Overlay:**
  - અંધારાવાળા સેલ્સ પર હળવો પારદર્શક છાંયડો ($15\%$ opacity soft black overlay) જે સૂર્યકિરણ પડતાં સોનેરી પ્રકાશમાં ફેરવાય છે.
- **Tutorial Overlay Cards:**
  - L2501: "Sunlit Garden — Direct light beams to illuminate the garden paths!"
  - L2511: "Petal Filter — Pass light through colored petals to change the beam's color."
  - L2631: "Twin-Sun Lock — Illuminate both sunflower receivers at once to unlock the thorn gate."
  - L2751: "Sundial Lens — Moves tick the sundial! Beams turn ON and OFF periodically."
  - L2871: "Shade Patch — Insects resting in the dark are locked. Shine a light beam to wake them!"

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Petal Filter (M251) | `state_toggle` | Beam color instantly refracts into vibrant red/yellow/blue with tiny chromatic particles. |
| Twin-Sun Lock (M252) | `state_toggle` | Dual golden light streams hit receivers; thorn gate dissolves with golden floral burst. |
| Sundial Lens (M253) | `state_toggle` | Sundial arm clicks; lens unleashes a brilliant focused sunbeam with radial light flares. |
| Shade Patch Light (M254)| `glow_burst` | Warm solar glow sweeps across dark cells; sleeping ants wake with cheerful sparkle aura. |
| L3000 Finale Win | `win_confetti` | Grand Midsummer Sunlit celebration: brilliant golden sunbursts, rainbow prismatic confetti. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Raycasting Engine Budget:** Pure integer raycasting across 14×14 grid with up to 8 reflections completes in $\le 1.0\text{ ms}$.
- **CI Pre-Validation:** L2501–3000 ના તમામ 500 levels optical solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 6 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P6-QA-01** | Petal filter color transmission | Beam passing through red filter only activates red sunflower receiver. | Not run |
| **P6-QA-02** | Twin-Sun Lock simultaneous check | One beam hitting receiver does not open gate; both beams hitting opens gate. | Not run |
| **P6-QA-03** | Sundial Lens Move tick | Move-based ON/OFF cycles strictly count player Moves (no clock timer). | Not run |
| **P6-QA-04** | Shade patch tap prevention | Tapping insect in shade is rejected; illuminating insect allows tap. | Not run |
| **P6-QA-05** | Raycasting reflection cap | Mirrors capping at 8 reflections prevents any infinite loop freezes. | Not run |
| **P6-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P6-QA-07** | L3000 Sunlit Jubilee Gala | Finale solvable, awards Royal Honey Chest and Solar Sage badge. | Not run |
| **P6-QA-08** | Offline optical generation | Seed-based generation works seamlessly offline on low-end devices. | Not run |

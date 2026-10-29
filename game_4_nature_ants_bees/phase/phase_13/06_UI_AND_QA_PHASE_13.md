# 06 — UI, VFX & QA, Phase 13 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Fog rendering UI indicators, Sunbeam reveal VFX, CI validation, performance budgets અને Phase 13 QA checklist.

**Related docs:** [Phase 13 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md)

---

## 1. UI Components for Mystery Meadow
- **Volumetric Fog Shader Overlay:**
  - બોર્ડના અજ્ઞાત ભાગો પર હળવું સફેદ-વાદળી ધુમ્મસ જે ધીમેથી વહેતું દેખાય છે ($40\%$ opacity).
- **Scout Ant Radar Rings:**
  - Scout Ant (M601) ના એન્ટેનામાંથી બહાર નીકળતી નાની ગોળાકાર સોનાર પલ્સ ("Scouts terrain on exit").
- **Painted Pebble "?" Cue:**
  - Scent Trail Preview (long-press 350 ms) Painted Pebble (M603) પર નાનો પીળો પ્રશ્નાર્થ ચિહ્ન દર્શાવે છે ("Hollow wall — safe to pass!").
- **Sunlit Plate Crosshairs HUD:**
  - કીડી Sunlit Plate (M604) પર ઊભી રહે ત્યારે તેની આખી હરોળ અને સ્તંભ સોનેરી પ્રકાશની લાઈન વડે હાઇલાઇટ થાય છે.
- **Tutorial Overlay Cards:**
  - L6001: "Mystery Meadow — Morning fog hides garden paths. Send scouts to clear the way!"
  - L6011: "Scout Ant — When this insect exits, it clears all fog within 2 tiles of its path."
  - L6131: "Mirage Mist — Looks like plain grass, but passing nearby blankets the area in fog."
  - L6251: "Painted Pebble — An optical illusion! Insects pass right through without bumping."
  - L6371: "Sunlit Plate — Stand an ant on this plate to illuminate its whole row and column."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Fog Dissolve (M601) | `glow_burst` | Warm sunbeams pierce the fog, smoothly evaporating mist with sparkling water dew (200 ms). |
| Mirage Trigger (M602)| `dust_puff` | Sudden swirling burst of cool vapor blanket expands across 3x3 tiles. |
| False Wall Crumble (M603)| `state_toggle` | Hollow pebble cracks into colorful paint flakes and leaves a clear lawn tile. |
| Sunlit Plate Beam (M604)| `state_toggle` | High-intensity golden light wash sweeps horizontally and vertically across the grid. |
| L6500 Finale Win | `win_confetti` | Grand Solstice Dawn Gala: prismatic sun halos, sparkling morning dewdrops, golden confetti. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Fog Mask Rendering Budget:** Per-frame bitmap mask compositing completes in $\le 0.3\text{ ms}$ on mobile GPU.
- **CI Pre-Validation:** L6001–6500 ના તમામ 500 levels fog simulation solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 13 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P13-QA-01** | Scout ant fog clearance | Exiting scout clears all fog within Chebyshev radius 2 of entire exit path. | Not run |
| **P13-QA-02** | Fogged insect tap guard | Attempting to tap concealed insect under fog is rejected ("Scout needed!"). | Not run |
| **P13-QA-03** | Mirage mist proximity trigger | Line passing orthogonally adjacent instantly generates 3x3 fog bank. | Not run |
| **P13-QA-04** | Painted pebble passage | Insect moves directly through painted pebble without bonk (-0 hearts). | Not run |
| **P13-QA-05** | Sunlit plate row/column reveal | Ant standing on plate reveals all hidden lines in its row and column. | Not run |
| **P13-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P13-QA-07** | L6500 Solstice Dawn Gala | Finale solvable, awards Royal Honey Chest and Meadow Clairvoyant badge. | Not run |
| **P13-QA-08** | Offline fog generation | Seed-based generation works seamlessly offline across all devices. | Not run |


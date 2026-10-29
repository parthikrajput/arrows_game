# 06 — UI, VFX & QA, Phase 14 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Water mirror UI indicators, Mirrored reflection VFX, CI validation, performance budgets અને Phase 14 QA checklist.

**Related docs:** [Phase 14 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md)

---

## 1. UI Components for Reflecting Pond
- **Pond Axis Water Shader:**
  - બોર્ડની મધ્યમાં આવેલી પાણીની અક્ષ પર $1.5\text{ Hz}$ ની આવૃત્તિ સાથે વહેતા પારદર્શક જળ-તરંગો (water ripple reflections).
- **Mirrored Twin Target Highlight:**
  - પ્લેયર જ્યારે એક લાઈન પર આંગળી મૂકે છે, ત્યારે અક્ષની બીજી બાજુ રહેલી તેની મિરર ટ્વિન લાઈન પણ તરત વાદળી પાણી જેવા આભા (blue halo) થી પ્રકાશિત થાય છે.
- **Upside-Down Line Inversion Marker:**
  - Upside-Down Line (M654) ના શરીર પર પાણીના નાના વમળો અને પાછળની તરફ નિર્દેશ કરતું નાનું તીર ("Runs in reverse").
- **Tutorial Overlay Cards:**
  - L6501: "Reflecting Pond — The calm water reflects your moves. Tapping one insect moves its twin!"
  - L6511: "Pond Axis — Move insects across the mirror axis. Both twins must reach exit safely."
  - L6631: "Reflection Lock — Unlocked only when the key insect on the opposite side of the pond escapes."
  - L6751: "Twin Pond — Dual ponds receive taps simultaneously. Balance both garden shores!"
  - L6871: "Upside-Down Line — Optical illusion! This insect moves opposite to where its head is facing."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Axis Ripple (M651) | `lane_warp` | Shimmering cerulean water wave pulses across the axis as mirrored insects move in unison. |
| Reflection Unlock (M652)| `state_toggle` | Water droplet splash erupts from the pond surface, shattering the lock into crystalline spray. |
| Twin Pond Tap (M653)| `state_toggle` | Dual water ripples expand from tap origin in both ponds simultaneously. |
| Inverted Dash (M654) | `lane_warp` | Insect dashes with rippling aquatic trail, splashing reverse droplets behind its departure. |
| L7000 Finale Win | `win_confetti` | Grand Mirrored Solstice Gala: dual rainbow light arcs, glowing water lilies, golden confetti. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Symmetry Transformation Budget:** Matrix coordinate reflection and dual branch check complete in $\le 0.1\text{ ms}$.
- **CI Pre-Validation:** L6501–7000 ના તમામ 500 levels mirror simulation solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 14 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P14-QA-01** | Pond axis bilateral movement | Tapping line initiates simultaneous movement of both origin and mirrored twin. | Not run |
| **P14-QA-02** | Single bonk penalty | If either mirrored twin bonks into an obstacle, single -1 Heart is deducted. | Not run |
| **P14-QA-03** | Reflection lock remote unlock | Key insect exiting on side B immediately dissolves reflection lock on side A. | Not run |
| **P14-QA-04** | Twin pond synchronized tap | Tap on Pond 1 triggers exact matching coordinate line on Pond 2. | Not run |
| **P14-QA-05** | Upside-down line reverse direction | Line moves strictly opposite to shown head direction along axis. | Not run |
| **P14-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P14-QA-07** | L7000 Mirrored Solstice Gala | Finale solvable, awards Royal Honey Chest and Mirror Mirage Master badge. | Not run |
| **P14-QA-08** | Offline mirror generation | Seed-based generation works seamlessly offline across all devices. | Not run |


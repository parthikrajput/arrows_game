# 06 — UI, VFX & QA, Phase 11 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Linked Boards UI indicators, Dual-board viewport VFX, CI validation, performance budgets અને Phase 11 QA checklist.

**Related docs:** [Phase 11 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md)

---

## 1. UI Components for Twin Gardens
- **Dual-Board Viewport Toggle Bar:**
  - ટોચ પર "Garden A" અને "Garden B" ટેબ્સ; ટેપ કરવાથી કેમેરા ૨૫૦ ms સ્મૂથ પેન સાથે બીજા બોર્ડ પર સ્વિચ થાય છે.
- **Link Mini-Map Preview:**
  - સ્ક્રીનના ખૂણે નાનો ડ્યુઅલ-બોર્ડ પૂર્વાવલોકન આઇકન જે દર્શાવે છે કે કયા એક્ઝિટ્સ ક્રોસ-બોર્ડ લિંક્સ છે.
- **Cross-Board Key Connection Beam:**
  - Pen-Pal Key (M502) પર ટેપ કરતાં હળવી ગોલ્ડન લિંક લાઈન બીજા બોર્ડ પરના તેના લૉક તરફ નિર્દેશ કરે છે.
- **Relay Burrow Portal Glow:**
  - Relay Burrow (M504) ના મુખ પર અંડરગ્રાઉન્ડ સોનેરી ગ્લો.
- **Tutorial Overlay Cards:**
  - L5001: "Twin Gardens — Two interconnected gardens! Switch between boards to solve the dual puzzle."
  - L5011: "Garden Gate Link — Insects exiting this gate enter the matching cell in the other garden."
  - L5131: "Pen-Pal Key — This insect carries a key that unlocks a distant lock in Garden B!"
  - L5251: "Reflecting Pond Board — Moving this insect simultaneously controls its reflection in the twin garden."
  - L5371: "Relay Burrow — Ants dive into this subterranean tunnel to emerge directly into the other garden."

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Gate Link Crossing (M501)| `lane_warp` | Shimmering boundary veil parts as line smoothly transitions across gardens. |
| Cross-Board Unlock (M502)| `state_toggle` | Golden pollen streak shoots across screen, bursting thorn lock on destination board. |
| Mirror Synchronization (M503)| `state_toggle` | Blue water droplet ripples and reflection sparkles track synchronized insects. |
| Burrow Teleport (M504)| `dust_puff` + `lane_warp`| Soil puff as ant dives underground; matching soil fountain upon emerging in Garden B. |
| L5500 Finale Win | `win_confetti` | Grand Twin Garden Jubilee: dual rainbow light bridges, mirrored golden confetti showers. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

## 3. Performance & CI Validation
- **Dual Viewport Memory Budget:** Both boards render within 60 fps budget; texture memory $\le 45\text{ MB}$.
- **CI Pre-Validation:** L5001–5500 ના તમામ 500 levels linked boards solver માં 0 hearts lost અને 0 boosters થી ક્લિયર થવા જોઈએ.

## 4. Phase 11 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P11-QA-01** | Gate link cross-board entrance | Line exiting Board A appears seamlessly at matching Board B edge cell. | Not run |
| **P11-QA-02** | Destination board obstruction | If Board B entrance is blocked, line bonks on Board A with zero teleport. | Not run |
| **P11-QA-03** | Pen-Pal key remote unlock | Key exit on Board A immediately clears linked lock on Board B. | Not run |
| **P11-QA-04** | Mirror twin synchronous movement | Tapping twin on Board A moves Board B twin; obstacle collision causes bonk. | Not run |
| **P11-QA-05** | Relay burrow ant-only check | Ant enters burrow and exits Board B; bee cannot enter burrow. | Not run |
| **P11-QA-06** | CI solver pass | 500/500 levels verified solvable with 0 hearts and 0 boosters in CI. | Not run |
| **P11-QA-07** | L5500 Twin Garden Jubilee | Finale solvable, awards Royal Honey Chest and Twin Realm Navigator badge. | Not run |
| **P11-QA-08** | Offline dual-board generation | Seed-based generation works seamlessly offline across all devices. | Not run |


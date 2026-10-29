# 06 — UI, VFX & QA, Phase 20 (યુઝર ઇન્ટરફેસ અને ચકાસણી)
> Grand Master UI indicators, Queen's Eternal Garden VFX, L10,000 Grand Finale victory sequence, CI validation budgets, Post-10K prestige loop અને Phase 20 QA checklist.

**Related docs:** [Phase 20 README](./README.md) · [VFX Implementation Standard §4, §5](../../VFX_IMPLEMENTATION.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md)

---

## 1. UI Components for Grand Master Garden & Finale
- **Grand Master Systems HUD:**
  - $14\times 14$ મેક્સિમમ ગ્રીડ માટે એડપ્ટિવ ઝૂમ/પેન (Pinch-zoom) કંટ્રોલ અને મિનિમેપ.
- **Eternal Bloom Canopy Stage Ring:**
  - M951 ના ફૂલ ફરતે કલર-કોડેડ રિંગ (લીલો = કરમાયેલું/ખુલ્લું, લાલ = ખીલેલું/બ્લોક).
- **Twin Cascade Gravity Arrows:**
  - M952 પર બેવડા તીર જે દર્શાવે છે કે કયો અર્ધભાગ લોકલ ગ્રેવિટીમાં જશે અને કયો પાર્ટ પોર્ટલ લિંકમાં જશે.
- **Shrouded Guardian Key Progress:**
  - M953 ગાર્ડિયનના માથા પર $0/3$ રોયલ કીઝ ફ્લોટિંગ કાઉન્ટર.
- **Prismatic Rotor Light Path Preview:**
  - M954 ની આસપાસ હળવી ડોટેડ લાઈટ લાઈનો જે આગામી રોટેશન પછી બીમ ક્યાં પ્રતિબિંબિત થશે તે દર્શાવે છે.
- **L10,000 Twin Hornet Boss Bars:**
  - સ્ક્રીનના ઉપરના ભાગમાં બેવડી રોયલ હોર્નેટ હેલ્થ/આર્મર બાર (3 Armor Shells each).
- **Post-L10,000 Prestige UI:**
  - L10,000 જીત્યા પછી મેઇન મેનૂ પર "Endless Grand Mastery" નો નવો ગોલ્ડન એક્સેસ ગેટ.
  - પ્રોફાઇલ પર કાયમી "Eternal Hive Champion" ગોલ્ડન બેજ અને સ્પાર્કલિંગ ક્રાઉન ફ્રેમ.
- **Tutorial Overlay Cards:**
  - L9501: "The Grand Master Garden — Every creature, flower, and mechanism from your journey unites here!"
  - L9511: "Eternal Bloom Canopy — Time your march when these cyclical flowers wither away!"
  - L9631: "Twin Cascade Nexus — A line split across twin boards under active gravitational pull."
  - L9751: "Shrouded Guardian Aegis — Dispel the deep fog, gather the Royal Keys, and satisfy the guardian!"
  - L9871: "Prismatic Rhythm Turntable — Light beams and turn-tracks synchronized to the rhythm of the garden."
  - L10000: "Queen's Eternal Garden — The ultimate test! 40 lines, 3 layers, twin hornets, and 12 systems. Lead the swarm to eternity!"

---

## 2. Visual Effects (VFX) Mapping
Effects reuse established classes from `VFX_IMPLEMENTATION.md`:
| Event / Mechanic | Effect Class | Visual Effect Definition |
|---|---|---|
| Bloom Canopy Cycle (M951)| `state_toggle` + `dust_puff`| Giant golden petals bloom or wither with gentle floral pollen particles. |
| Cascade Nexus Split (M952)| `lane_warp` | Line divides into shimmering dual streams; one cascades with gravity, one warps via linked portal. |
| Shrouded Guardian Unlock (M953)| `unlock_shatter` | Golden keys merge into guardian's shield, shattering fog and emitting warm royal light burst. |
| Prismatic Rotor Turn (M954)| `state_toggle` + `laser_beam`| 4x4 crystal platform rotates smoothly; light beams refract in rainbow colors across the board. |
| Hornet Armor Crack (L10,000)| `hazard_sparks` | Heavy metallic clinking sound with nectar sparks as armor layer shatters. |
| L10,000 Grand Finale Victory | `win_confetti` + `laser_beam`| **The Queen's Coronation:** સમગ્ર 14x14 બોર્ડ પર ગોલ્ડન મધમાખીઓનો ભવ્ય સ્વોર્મ ડાન્સ, શાશ્વત ક્રાઉન ફ્લાવરનું ખીલવું, આકાશમાં રોયલ ફાયરવર્ક્સ અને સુવર્ણ કન્ફેટી. |

- **Tier Limits:** Low: $\le 30$ particles, shake off; Mid: $\le 80$ particles, 4 dp shake; High: $\le 150$ particles, 6 dp shake.

---

## 3. Performance & CI Validation
- **Engine Execution Budget:** L10,000 જેવા $14\times 14$, 40 લાઈન્સ અને 12 એકસાથે ચાલતી સિસ્ટમ્સ વાળા જટિલ બોર્ડ પર પણ ફુલ ટિક રેઝોલ્યુશન $\le 0.4\text{ ms}$ માં પૂર્ણ થાય છે.
- **CI Pre-Validation:** L9501–10000 ના તમામ 500 levels CI solver માં 0 hearts lost અને 0 boosters સાથે સૉલ્વેબલ હોવા ફરજિયાત છે.

---

## 4. Phase 20 QA Checklist
| ID | Test | Expected Result | Status |
|---|---|---|---|
| **P20-QA-01** | Multi-system tick order resolution | All 9 steps in Standard §16.17 resolve deterministically without desync. | Not run |
| **P20-QA-02** | Eternal bloom canopy timing | Vines block during full bloom, allow passage during withered state. | Not run |
| **P20-QA-03** | Twin cascade gravity fork | Gravity pull on local branch and portal teleport on linked branch execute cleanly. | Not run |
| **P20-QA-04** | Shrouded guardian key collection | 3 keys collected from fog unlock the guardian gate correctly. | Not run |
| **P20-QA-05** | Prismatic rotor raycast update | Light beam bounces update instantly and correctly after automatic rotor turn. | Not run |
| **P20-QA-06** | L10,000 Boss finale victory | Twin hornets satisfied, 40 lines cleared, awards Grand Royal Honey Chest & Eternal badge. | Not run |
| **P20-QA-07** | Post-10K Endless Prestige loop | Endless Grand Mastery mode activates smoothly without crashes or dead ends. | Not run |
| **P20-QA-08** | CI 500/500 solver pass | 100% of levels 9501–10,000 verified solvable with zero hearts lost and zero boosters. | Not run |

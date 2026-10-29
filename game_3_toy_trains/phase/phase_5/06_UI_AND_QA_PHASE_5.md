# 06 · UI & QA Phase 5 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 5 ના UI ઘટકો (Shunting Arrow Directional Indicators, Heavy Push Cues), VFX, પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 5 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Shunting Direction Indicators
- **વિઝ્યુઅલ:** જ્યારે કોઈ ટ્રેનની exit lane કાર્ટ તરફ લક્ષ્ય સાધે છે, ત્યારે કાર્ટની પાછળ નાના ગોલ્ડન એરો ઇન્ડિકેટર્સ પ્રગટ થાય છે જે દર્શાવે છે કે ધકેલાયા પછી કાર્ટ ક્યાં જશે.
- **Heavy Push Cue:** જો એકલી ટ્રેન Ballast Cart (M204) તરફ આગળ વધતી હોય, તો એરો લાલ રંગમાં ✕ માર્કર સાથે "Too Heavy!" દર્શાવે છે.

### 1.2 Tutorial Cards
- **L2001:** Shunting Push પરિચય ("Trains can push carts on the tracks! Clear their path!").
- **L2011 (M201):** Cart Pit પરિચય ("Push a cart into a pit to repair the track and make it passable!").
- **L2131 (M202):** Ice Block Cart પરિચય ("Ice carts slide frictionless along the track until they hit an obstacle!").
- **L2251 (M203):** Ticket Cart પરિચય ("Push the ticket cart onto the barrier pad to unlock the gate!").
- **L2371 (M204):** Ballast Cart પરિચય ("Heavy ballast carts require Wide Load Freight or Coupled Engines to push!").

---

## 2. Phase 5 Visual Effects (VFX)
- **Cart Shunt Impact:** ટ્રેનના બફર્સ કાર્ટ સાથે સંપર્કમાં આવતાં લાકડાનો સંપર્ક અવાજ + વ્હીલ સ્પાર્ક્સ.
- **Ice Cart Slide Trail:** આઇસ કાર્ટ લપસતાં પાટા પર ચમકતી સ્નો-મિસ્ટ અને ફ્રોસ્ટ સ્પીડ-લાઈન્સ (`BlendMode.plus`).
- **Pit Fill VFX:** કાર્ટ ખાડામાં પડતાં લાકડાના પાટિયાં બેસી જવાનો એનિમેશન + ડસ્ટ પફ.
- **Ticket Pad Activation:** બેરિયર પેડ પર કાર્ટ બેસતાં ગોલ્ડન લાઇટ રિંગ + બેરિયર ગેટ અનલૉક ફ્લેર.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 5)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P5-QA-01 | L2001–2500 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P5-QA-02 | Shunting Single-Cell Push | કાર્ટ આગળ ખાલી સેલ હોય તો 1 સેલ આગળ વધે; ટ્રેન લેન ક્લિયર રહે. | Not run |
| P5-QA-03 | Pit Fill Terrain Conversion | કાર્ટ ખાડામાં પડતાં સેલ પાટા બની જાય અને ટ્રેન સુરક્ષિત રીતે પસાર થાય. | Not run |
| P5-QA-04 | Continuous Ice Slide | M202 કાર્ટ જ્યાં સુધી અવરોધ ન આવે ત્યાં સુધી લપસતું રહે. | Not run |
| P5-QA-05 | Ticket Cart Gate Trigger | કાર્ટ પેડ પર પહોંચતાં જ બંધ દરવાજો કાયમી ધોરણે ખુલી જાય. | Not run |
| P5-QA-06 | Ballast Heavy Resistance | સામાન્ય ટ્રેન અથડાતાં બમ્પ (−1 Heart); વાઇડ લોડ ટ્રેન તેને સફળતાપૂર્વક ધકેલે. | Not run |
| P5-QA-07 | 60 fps Push Physics Budget | મલ્ટી-કાર્ટ શન્ટિંગ અને સ્લાઇડિંગ એનિમેશન દરમિયાન 0 frame drop. | Not run |
| P5-QA-08 | Remote Config Rollout | `maxPhase < 5` હોય ત્યારે L2001 લોક રહે; `5` થતાં જ અનલૉક થાય. | Not run |


# 03 — Signature System & Base Mechanics: Phase 12
> Gravity (Hanging Loom) signature system અને Phase 12 ના 4 નવા base mechanics (M551–M554) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 12 index](./README.md) · [01 Scope & Rules](./01_PHASE_12_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Gravity (Hanging Loom)
- **Concept:** લૂમ ફ્રેમ જ્યારે ઊભી લટકાવેલી (Hanging) હોય ત્યારે ગુરુત્વાકર્ષણ બળ છૂટક ઑબ્જેક્ટ્સ અને ભારે દોરાઓને નીચે તરફ ખેંચે છે. પ્લેયર પ્લમ્બ લીવર વડે બોર્ડના ગુરુત્વાકર્ષણને 4 દિશાઓમાં નિયંત્રિત કરી શકે છે.
- **Rules & Mechanics:**
  - સામાન્ય દોરાઓ લિનન ફેબ્રિકમાં ગૂંથેલા હોવાથી ગ્રેવિટીથી ખસતા નથી.
  - માત્ર અનગૂંથેલા છૂટા બટન્સ (Dropping Buttons) અને વિશિષ્ટ મેટલ-કોર વેઇટેડ દોરાઓ (Weighted Threads) જ ગ્રેવિટી દિશામાં સ્લાઇડ થાય છે.
  - સ્લાઇડિંગ પછી તેઓ મજબૂત બ્લોકર તરીકે કામ કરે છે.

---

## 2. Base Mechanics Catalog Cards

### M551 — Plumb Lever (Gravity Lever)
- **ID:** `M551` | **Themed Name:** Plumb Lever | **Generic:** Gravity Lever | **Intro:** L5511 | **Cat:** D/G | **Hammerable:** No
- **Rule:** લાકડાની ફ્રેમ પર લટકતો પિત્તળનો ઓળંબો (Plumb Bob Lever). ટેપ કરવાથી (1 Move વપરાય છે) ગુરુત્વાકર્ષણની દિશા આગળના એંગલ પર ફરે છે ($\text{Down} \to \text{Left} \to \text{Up} \to \text{Right} \to \text{Down}$). હેમરેબલ નથી.
- **JSON Format:** `{"id":"m551_1","type":"M551","cells":[[0,6]],"params":{"initialDir":"down","cycle":["down","left","up","right"]},"hammerable":false}`

---

### M552 — Dropping Buttons (Falling Blockers)
- **ID:** `M552` | **Themed Name:** Dropping Buttons | **Generic:** Falling Blockers | **Intro:** L5631 | **Cat:** B/P | **Hammerable:** Yes (1 button/snip)
- **Rule:** બોર્ડ પર છૂટા પડેલા લાકડાના ગોળ બટનો. દરેક મૂવ પછી, સક્રિય ગુરુત્વાકર્ષણની દિશામાં જ્યાં સુધી અવરોધ ન આવે ત્યાં સુધી સીધા સ્લાઇડ થાય છે. જો તેઓ Float Patch (M553) પર હોય તો સ્લાઇડ થતાં નથી. સ્થિર થયા પછી સિંગલ બ્લોકર (M001) ની જેમ વર્તે છે. હેમરેબલ છે.
- **JSON Format:** `{"id":"m552_1","type":"M552","cells":[[4,7]],"params":{},"hammerable":true}`

---

### M553 — Float Patch (Anti-grav Tile)
- **ID:** `M553` | **Themed Name:** Float Patch | **Generic:** Anti-grav Tile | **Intro:** L5751 | **Cat:** D | **Hammerable:** No
- **Rule:** લિનન પર રેશમના તારથી ગૂંથેલો એન્ટિ-ગ્રેવિટી ચોરસ પેચ. આ પેચ પર સ્થિત કોઈપણ બટન કે દોરો ગુરુત્વાકર્ષણના નિયમથી મુક્ત રહે છે અને દિશા બદલાવા છતાં નીચે પડતો નથી. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m553_1","type":"M553","cells":[[8,8]],"params":{},"hammerable":false}`

---

### M554 — Weighted Thread (Weight Path)
- **ID:** `M554` | **Themed Name:** Weighted Thread | **Generic:** Weight Path | **Intro:** L5871 | **Cat:** P | **Hammerable:** Yes
- **Rule:** મેટાલિક થ્રેડ કોર ધરાવતો ભારે દોરો. જ્યારે પ્લેયર અન્ય કોઈ એક્શન કરે છે, ત્યારે દરેક મૂવના અંતે આ દોરો આખો ને આખો ગુરુત્વાકર્ષણ દિશામાં 1 સેલ ટ્રાન્સલેટ થાય છે, શરત કે તેના આગામી તમામ સેલ્સ ખાલી હોવા જોઈએ. પ્લેયર તેને સામાન્ય દોરાની જેમ ટેપ કરીને અનરૅવલ પણ કરી શકે છે. હેમરેબલ છે.
- **JSON Format:** `{"id":"m554_1","type":"M554","cells":[[2,3],[2,4],[2,5]],"params":{"weightClass":"heavy"},"hammerable":true}`


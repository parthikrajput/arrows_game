# 03 — Signature System & Base Mechanics: Phase 3
> Day & Night Loom (Cycles) signature system અને Phase 3 ના 4 નવા base mechanics (M101–M104) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 3 index](./README.md) · [01 Scope & Rules](./01_PHASE_3_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Day & Night Loom (Cycles)
- **Concept:** લાકડાની લૂમ પર દિવસ અને રાતનું ચક્ર ચાલે છે. દર 5 Moves એ લૂમનું શટલ ફરીને બોર્ડનું વાતાવરણ અને cycle mechanics ની સ્થિતિ State A (Day) માંથી State B (Night) માં ફેરવે છે.
- **Cycle Period:** બરાબર **5 Moves** (`floor(moveCount / 5) % 2 == 0` ⇒ State A; `== 1` ⇒ State B).
- **Move Resolution Hook (Step 4):**
  1. Action resolve થાય છે.
  2. `moveCount += 1`.
  3. Counters tick (M007 -> M017 -> M031 -> M025 -> M027 -> M047 -> M041).
  4. **Cycle Toggle:** જો `moveCount % 5 == 0`, Cycle state toggle થાય છે (`A ↔ B`).
  5. Derived states update (M101 open/close, M102 bridge/blocker, M103 active/inactive, M104 color shift).
  6. Heart loss & Shields.
  7. Win check.
- **HUD & Visuals:** ટોપ બારમાં લૂમ શટલ ડાયલ 5 stitch dots દર્શાવે છે જે દર મૂવે ઘટે છે (5, 4, 3, 2, 1). State A માં સોનેરી સૂર્ય કિરણો અને State B માં ચાંદી જેવો શીતળ ચંદ્ર પ્રકાશ બોર્ડના લિનન પર પ્રસરે છે.

---

## 2. Base Mechanics Catalog Cards

### M101 — Loom Latch (Cycle Gate)
- **ID:** `M101` | **Themed Name:** Loom Latch | **Generic:** Cycle Gate | **Intro:** L1011 | **Cat:** B | **Hammerable:** No
- **Rule:** બોર્ડ સેલ પર લાકડાની લૂમ લેચ (કમાણ) છે. લેચ તેની નિયુક્ત Cycle State (A અથવા B) માં **ખુલ્લી** (ઓપન) રહે છે જેથી દોરો પસાર થઈ શકે છે. વિરુદ્ધ State માં તે **બંધ** થાય છે અને Single Blocker તરીકે વર્તે છે.
- **Tap/Bump:** બંધ લેચમાં દોરો ખેંચવાનો પ્રયાસ snag bump પરિણમે છે (-1 Heart, twang).
- **Solver Hook:** Solver જાણે છે કે લેચ વર્તમાન `moveCount` મુજબ `(5 - (moveCount % 5))` મૂવ્સ પછી ખુલશે/બંધ થશે.
- **JSON Format:** `{"id":"m101_1","type":"M101","cells":[[4,6]],"params":{"activeState":"A"},"hammerable":false}`

---

### M102 — Day Bridge (Cycle Bridge)
- **ID:** `M102` | **Themed Name:** Day Bridge | **Generic:** Cycle Bridge | **Intro:** L1131 | **Cat:** L | **Hammerable:** No
- **Rule:** લૂમ પરનો વિશિષ્ટ સેલ જે State A (Day) માં **Stitch Bridge (M015)** તરીકે વર્તે છે (ઉપર અને નીચે બંને લેયરના દોરાઓ અથડામણ વગર ઓર્થોગોનલ પસાર થઈ શકે છે). State B (Night) માં આ બ્રિજ ઢળી પડીને **Single Blocker** બની જાય છે અને બંને લેયરને બ્લોક કરે છે.
- **Tap/Bump:** State B દરમિયાન સેલમાંથી પસાર થતો દોરો snag થાય છે (-1 Heart).
- **JSON Format:** `{"id":"m102_1","type":"M102","cells":[[6,6]],"params":{"bridgeState":"A"},"hammerable":false}`

---

### M103 — Night Pompom (Cycle Portal)
- **ID:** `M103` | **Themed Name:** Night Pompom | **Generic:** Cycle Portal | **Intro:** L1251 | **Cat:** D | **Hammerable:** No
- **Rule:** જોડીમાં રહેલા પોમપોમ પોર્ટલ્સ (M008) જે માત્ર State B (Night) માં સક્રિય થાય છે. State B માં દોરો Pompom 1 માં પ્રવેશી Pompom 2 માંથી સમાન દિશામાં બહાર નીકળે છે. State A (Day) માં આ પોમપોમ્સ નિષ્ક્રિય થઈને સામાન્ય Single Blockers બની જાય છે.
- **Tap/Bump:** State A માં પોમપોમ પર જતો દોરો અથડાઈને snag થાય છે.
- **JSON Format:** `{"id":"m103_1","type":"M103","cells":[[2,3],[8,9]],"params":{"portalState":"B"},"hammerable":false}`

---

### M104 — Twilight Eyelet (Cycle Color)
- **ID:** `M104` | **Themed Name:** Twilight Eyelet | **Generic:** Cycle Color | **Intro:** L1371 | **Cat:** B | **Hammerable:** No
- **Rule:** કલર આઇલેટ (M005) જેનું ફિલ્ટર કલર સાયકલ સ્ટેટ સાથે બદલાય છે. State A (Day) માં તે `colorA` (દા.ત. લાલ) દોરાઓને જ પસાર થવા દે છે; State B (Night) માં તે શિફ્ટ થઈને `colorB` (દા.ત. વાદળી) દોરાઓને જ પસાર થવા દે છે. બિન-મેચિંગ કલર snag bump કરે છે.
- **Tap/Bump:** અયોગ્ય કલરનો દોરો snag twang સાથે પાછો વળે છે (-1 Heart).
- **JSON Format:** `{"id":"m104_1","type":"M104","cells":[[5,8]],"params":{"colorA":"red","colorB":"blue"},"hammerable":false}`


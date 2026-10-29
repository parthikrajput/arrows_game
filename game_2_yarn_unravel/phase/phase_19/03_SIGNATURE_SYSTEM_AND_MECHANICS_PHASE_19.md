# 03 — Signature System & Base Mechanics: Phase 19
> Remix B (Phases 7 to 12 Synergy) signature system અને Phase 19 ના 4 ડેટા-ડ્રિવન combo mechanics (M901–M904) ના સંપૂર્ણ catalog cards — standard §10 ના તમામ fields સાથે.

**Related docs:** [Phase 19 index](./README.md) · [01 Scope & Rules](./01_PHASE_19_SCOPE_AND_RULES.md) · [Shared Core Standard §10, §11, §16](../../SHARED_CORE_STANDARD.md) · [Scaling §7, §10.3](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Signature System: Remix B
- **Concept:** તબક્કા 7 થી 12 ની કાઇનેમેટિક અને સ્પેશિયલ પ્રણાલીઓ (Rotation, Growth, Split & Merge, Sequencing, Linked Boards, Gravity) વચ્ચે ગતિશીલ સંવાદ.
- **Data Selection Rule:** ટેલિમેટ્રી ડેટા (વિન રેટ 45–65%, સોલ્વર નોડ્સ < 1.5M) દ્વારા શ્રેષ્ઠ 4 મિકેનિક્સ પસંદગી.
- **Invariants:** તમામ સ્તરે 0-hearts solvability સુનિશ્ચિત.

---

## 2. Combo Mechanics Catalog Cards (Candidate Pool)

### M901 — Twirl Weighted Thread
- **ID:** `M901` | **Themed Name:** Twirl Weighted Thread | **Generic:** Twirl Weighted Thread | **Intro:** L9011 | **Cat:** P | **Hammerable:** Yes (1 thread/snip)
- **Rule:** રોટેશન (M303) અને ગ્રેવિટી (M554) નું સંયોજન. આ ભારે દોરો દરેક માન્ય મૂવ પછી પોતાની દિશા (`dir`) 90° CW ફેરવે છે, અને ત્યારબાદ વર્તમાન સક્રિય ગુરુત્વાકર્ષણની દિશામાં 1 સેલ સરકે છે જો તે સેલ ખાલી હોય. હેમરેબલ છે.
- **JSON Format:** `{"id":"m901_1","type":"M901","cells":[[5,5],[5,6]],"params":{"dir":"up","rotatesCW":true,"fallsWithGravity":true},"hammerable":true}`

---

### M902 — Ivy Hoop Rotor
- **ID:** `M902` | **Themed Name:** Ivy Hoop Rotor | **Generic:** Ivy Hoop Rotor | **Intro:** L9131 | **Cat:** D/C | **Hammerable:** No
- **Rule:** ગ્રોથ (M351) અને રોટર (M301) નું મિશ્રણ. 4×4 રોટર સેલ જેના પર આઇવી ગ્રોથ રૂટ્સ આવેલા છે. જ્યારે પ્લેયર રોટર ફેરવે છે (90° CW), ત્યારે રૂટ્સની દિશા પણ બદલાઈ જાય છે, જેનાથી આગામી ગ્રોથ બોર્ડના નવા ક્વાડ્રન્ટ સેલ્સમાં વિસ્તરે છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m902_1","type":"M902","cells":[[2,2],[2,5],[5,2],[5,5]],"params":{"size":4,"rootOffsets":[[1,1]]},"hammerable":false}`

---

### M903 — Rhythm Belt
- **ID:** `M903` | **Themed Name:** Rhythm Belt | **Generic:** Rhythm Belt | **Intro:** L9251 | **Cat:** T/B | **Hammerable:** No
- **Rule:** કન્વેયર્સ (Phase 15) અને સિક્વન્સિંગ મેટ્રોનોમ (Phase 10) નું જોડાણ. કન્વેયર બેલ્ટ સતત ચાલવાને બદલે માત્ર મેટ્રોનોમ રિધમ બીટ પર જ સક્રિય થાય છે (દા.ત. દર 2જા મૂવ પર 1 સેલ ગતિ; ઑફ-બીટ પર અટકે છે). હેમરેબલ નથી.
- **JSON Format:** `{"id":"m903_1","type":"M903","cells":[[8,4],[8,5],[8,6],[8,7]],"params":{"beatPattern":[1,0],"dir":"left"},"hammerable":false}`

---

### M904 — Seam Edge Split
- **ID:** `M904` | **Themed Name:** Seam Edge Split | **Generic:** Seam Edge Split | **Intro:** L9371 | **Cat:** T/E | **Hammerable:** No
- **Rule:** લિંક્ડ બોર્ડ્સ (Phase 11) અને સ્પ્લિટ-પ્લાય (Phase 9) નું મિશ્રણ. જ્યારે દોરો Hoop A ની સીમ એજમાંથી બહાર નીકળીને Hoop B માં પ્રવેશે છે, ત્યારે તે સીમમાંથી પસાર થતાં જ બે સમાંતર હાફ-પ્લાય દોરાઓમાં વિભાજીત થઈને Hoop B માં આગળ વધે છે. હેમરેબલ નથી.
- **JSON Format:** `{"id":"m904_1","type":"M904","cells":[[7,0]],"params":{"targetBoard":"hoop_b","splitOnCross":true},"hammerable":false}`

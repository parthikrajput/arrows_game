# 03 — Signature System & Mechanics, Phase 20 (M951–M954)
> Grand Master Garden architecture, multi-system conflict resolution order (Standard §16.17), M951–M954 Grand Combo cards, અને L10,000 Grand Finale rules.

**Related docs:** [Phase 20 README](./README.md) · [Shared Core Standard §11, §12, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_20_SCOPE_AND_RULES.md)

---

## 1. Signature System: Grand Master Garden
- **Core Concept:** રમતના તમામ 19 પાછલા ફેઝિસની મિકેનિક્સ અને સિસ્ટમ્સ (સાયકલ્સ, મલ્ટિ-ફ્લોર, પુશિંગ, પ્રિઝમ લાઈટ બીમ્સ, ટર્નટેબલ રોટેશન, વેલોનો ગ્રોથ, સ્પ્લિટ/મર્જ સ્વોર્મ્સ, રિધમિક સીક્વન્સિંગ, ટ્વિન લિંક્ડ બોર્ડ્સ, ગ્રેવિટી સ્લાઈડ્સ, હિડન ફોગ, મિરર ગેટ્સ, કન્વેયર્સ/સ્ટ્રીમ્સ, રોયલ કીઝ અને ગાર્ડિયન હોર્નેટ્સ) નું પૂર્ણ-સંકલિત ગ્રાન્ડ માસ્ટર રૂપ.
- **Multi-System Conflict Resolution Order (Standard §16.17):**
  જ્યારે એક જ Move માં બહુવિધ ગતિશીલ સિસ્ટમ્સ સક્રિય થાય છે, ત્યારે એન્જિન નીચે દર્શાવેલા નિર્ધારિત ટિક ઓર્ડર (Deterministic Tick Order) માં પ્રક્રિયા કરે છે:
  1. **Player Move Execution:** ખેલાડી દ્વારા પસંદ કરેલી કીડી/મધમાખી લાઈન પોતાની દિશામાં આગળ વધે છે.
  2. **Conveyors & Brook Streams (Phase 15):** કન્વેયર ટ્રેક અને પાણીના પ્રવાહ પર રહેલા ઓબ્જેક્ટ્સ 1 સેલ આગળ ખસે છે.
  3. **Gravity Shift & Acorn Falls (Phase 12):** ગુરુત્વાકર્ષણ પ્રભાવ હેઠળના લૂઝ એકોર્ન્સ અને અનસપોર્ટેડ બ્લોક્સ નીચે પડે છે.
  4. **Growth Flora Spreading (Phase 8):** મોર્નિંગ ગ્લોરી વેલો અને થોર્ન બુશ વિસ્તરે છે.
  5. **Rhythm Pulse & Timed Rotors (Phase 10 & 19):** મોડ્યુલો કાઉન્ટર અપડેટ થાય છે અને ઓટો-ટર્નટેબલ્સ $90^\circ$ ફરે છે.
  6. **Light Beam & Prism Recalculation (Phase 6):** અરીસાઓ અને પ્રિઝમ્સ દ્વારા સનલાઈટ બીમ્સનું પુનર્ગણન થાય છે.
  7. **Hidden Fog Cleared (Phase 13):** નજીકના સેલ સાફ થતાં રહસ્યમય ધુમ્મસ દૂર થાય છે.
  8. **Guardians Reaction & Armor State (Phase 17):** ગાર્ડિયન હોર્નેટ્સ કી-ચિહ્નો અને આર્મર સ્ટેટ તપાસે છે.
  9. **Line Clear & Goal Verification:** નિર્ધારિત નેસ્ટ/હાઇવમાં પહોંચેલી લાઈનો ગ્રીડમાંથી અદ્રશ્ય થાય છે અને વિજય શરત ચકાસાય છે.

---

## 2. Grand Combo Mechanics Cards (M951–M954)

### M951 — Eternal Bloom Canopy (Pool P3–P8 Combo)
| Field | Value |
|---|---|
| ID | `M951` |
| Themed Name | **Eternal Bloom Canopy** (શાશ્વત ખીલેલી છત્રછાયા) — Generic: Cyclical Growth Flora |
| Category | B / T — Cyclic Spreading Barrier |
| Intro Level | **L9511** (Block 2 x1) |
| Rule | Cycles (Phase 3) અને Growth (Phase 8) નું ગ્રાન્ડ કોમ્બિનેશન. આ ફૂલોની વેલ ચોક્કસ સીઝનલ સાયકલ (ખીલવું $\rightarrow$ ફળ આપવું $\rightarrow$ કરમાવું) માંથી પસાર થાય છે. જ્યારે કરમાયેલી હોય ત્યારે જ કીડીઓ તેના પરથી પસાર થઈ શકે છે. જો પ્લેયર ખોટી ચાલ કરે અને તે 'પૂર્ણ ખીલેલી' સ્થિતિમાં હોય, તો તે આસપાસના રસ્તા બ્લોક કરી દે છે. શેઅર્સ (M352) થી 1 સાયકલ માટે કાપી શકાય છે. |
| Ants / Bees | ગ્રાઉન્ડ કીડીઓ અને નીચી મધમાખીઓ બંનેને અસર કરે છે (`tall: true`). |
| Tall | Yes. |
| Hammerable | Yes (Leaf Blower). |
| Non-Monotone (N)| Yes. |

### M952 — Twin Cascade Nexus (Pool P9–P12 Combo)
| Field | Value |
|---|---|
| ID | `M952` |
| Themed Name | **Twin Cascade Nexus** (જોડિયા પ્રપાત કેન્દ્ર) — Generic: Linked Gravitational Swarm Fork |
| Category | T / G — Multi-Board Gravity Splitter |
| Intro Level | **L9631** (Block 14 x1) |
| Rule | Linked Boards (Phase 11), Split/Merge (Phase 9) અને Gravity (Phase 12) નું ગ્રાન્ડ સંયોજન. બોર્ડ A ની ધાર પર રહેલું આ નેક્સસ લાઈનને 2 ભાગમાં વહેંચે છે: એક ભાગ બોર્ડ A ના ગુરુત્વાકર્ષણ પ્રવાહ સાથે નીચે ગગડે છે, જ્યારે બીજો ભાગ પોર્ટલ લિંક દ્વારા બોર્ડ B માં પ્રવેશે છે અને ત્યાંના ઊર્ધ્વ પ્રવાહમાં આગળ વધે છે. |
| Ants / Bees | બંને બોર્ડના અનુરૂપ લેયર્સમાં એકસાથે સિમ્યુલેટ થાય છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M953 — Shrouded Guardian Aegis (Pool P13–P17 Combo)
| Field | Value |
|---|---|
| ID | `M953` |
| Themed Name | **Shrouded Guardian Aegis** (ધુમ્મસિયું રક્ષક કવચ) — Generic: Shrouded Guardian Lockgate |
| Category | O / B — Hidden Key-Locked Heavy Boss Barrier |
| Intro Level | **L9751** (Block 26 x1) |
| Rule | Hidden Fog (Phase 13), Royal Keys (Phase 16) અને Guardians (Phase 17) નું ત્રિવેણી સંયોજન. ગાર્ડિયન હોર્નેટ એક રહસ્યમય ધુમ્મસિયા ચેમ્બરમાં બેઠો હોય છે. તેનું કવચ તોડવા માટે જરૂરી 3 રોયલ કીઝ ફોગની અંદર છુપાયેલી હોય છે. કીડીઓ ફોગને સાફ કરીને કીઝ લાવે તે પછી જ ગાર્ડિયન ખુશ થઈને રાણીના રક્ષણ માટેનો માર્ગ મોકળો કરે છે. |
| Ants / Bees | કીડીઓ ગ્રાઉન્ડ કીઝ લાવે છે; સ્કાઉટ બીઝ હવાઈ ફોગ હટાવે છે. |
| Tall | Yes. |
| Hammerable | No (કીઝ કલેક્શન અનિવાર્ય છે). |
| Non-Monotone (N)| No. |

### M954 — Prismatic Rhythm Turntable (Pool P18–P19 Combo)
| Field | Value |
|---|---|
| ID | `M954` |
| Themed Name | **Prismatic Rhythm Turntable** (પ્રિઝમેટિક રિધમ ટર્નટેબલ) — Generic: Multi-Kinetic Prismatic Rotor |
| Category | T / C — Synchronized Light-Bending Turntable |
| Intro Level | **L9871** (Block 38 x1) |
| Rule | Sunlit Beams (Phase 6), Rotation (Phase 7) અને Rhythm Sequencing (Phase 10) નું સર્વોચ્ચ સંયોજન. એક વિશાળ $4\times 4$ ટર્નટેબલ જેના પર ઓપ્ટિકલ પ્રિઝમ્સ જડેલા છે. તે દર 4 Moves એ આપમેળે $90^\circ$ ફરે છે, જેનાથી સમગ્ર બોર્ડ પર ફરતા પ્રકાશના કિરણોની દિશા ક્ષણે-ક્ષણે બદલાય છે અને ફોટોસેન્સિટિવ ગાર્ડન ગેટ્સ ખૂલે/બંધ થાય છે. |
| Ants / Bees | લાઈનો અને લાઈટ બીમ્સ બંનેનું એક સાથે નેવિગેશન જરૂરી બને છે. |
| Tall | Grid region. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

---

## 3. L10,000 Grand Finale Boss Rules — "Queen's Eternal Garden"
1. **Grid & Environment:**
   - રમતની સૌથી મોટી માન્ય ગ્રીડ: **14×14 Full Grid**.
   - સંપૂર્ણ 3 લેયર્સ એકસાથે સક્રિય: Ground Ants (16 lines), Worker Bees (14 lines), Canopy Scout Bees (10 lines) = **કુલ 40 લાઈન્સ**.
2. **Multi-Boss Encounter:**
   - **Twin Giant Hornets:** 2 સશસ્ત્ર રોયલ હોર્નેટ્સ (એક ઉત્તર-પૂર્વ બગીચામાં, એક દક્ષિણ-પશ્ચિમ ચેમ્બરમાં).
   - દરેક હોર્નેટ 3 સ્તરનું રોયલ નેક્ટર કવચ (Armor Shell) ધરાવે છે.
3. **Active Systems Synergy (12 Simultaneous Systems):**
   - 1. ગાર્ડન સાયકલ્સ (Day/Night bloom states).
   - 2. મલ્ટિ-ફ્લોર એલિવેટર્સ (Ant hill tunnels).
   - 3. રોક અને એકોર્ન પુશિંગ.
   - 4. સનલાઈટ પ્રિઝમ બીમ્સ (M251/M252).
   - 5. મેન્યુઅલ ટર્નટેબલ્સ (M301).
   - 6. મોર્નિંગ ગ્લોરી વેલો (M351).
   - 7. સ્પ્લિટ-પાથ નેક્સસ (M401).
   - 8. રિધમિક ગાર્ડન ડ્રમ્સ (M451).
   - 9. ટ્વિન કનેક્ટેડ બોર્ડ પોર્ટલ્સ (M501).
   - 10. ગ્રેવિટી સ્લાઈડ્સ અને બ્રૂક સ્ટ્રીમ્સ (M551/M701).
   - 11. રોયલ કી-લોક્સ (M751).
   - 12. ગાર્ડિયન હોર્નેટ બોસ (M801).
4. **Target Difficulty:**
   - **$D \approx 95$** (Standard §16.13 Finale Target — અત્યંત પડકારજનક છતાં 0 હાર્ટ્સ અને 0 બૂસ્ટર સાથે સૉલ્વેબલ).
5. **Victory Condition:**
   - બંને હોર્નેટ્સને સંતુષ્ટ કરવા, તમામ 40 લાઈન્સને તેમના ક્વીન નેસ્ટ/હાઇવમાં સુરક્ષિત પહોંચાડવી અને રોયલ ક્રાઉન ફ્લાવરને ખીલવવું.

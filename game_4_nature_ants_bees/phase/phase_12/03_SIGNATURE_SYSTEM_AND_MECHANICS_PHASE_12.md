# 03 — Signature System & Mechanics, Phase 12 (M551–M554)
> Falling Leaves (Gravity architecture), directional gravity settlement, anti-gravity zones અને M551–M554 base mechanics cards.

**Related docs:** [Phase 12 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_12_SCOPE_AND_RULES.md)

---

## 1. Signature System: Falling Leaves (Gravity)
- **Core Concept:** બગીચામાં પવનની દિશા અનુસાર ગુરુત્વાકર્ષણ પ્રવાહ કામ કરે છે. પ્લેયરના દરેક Move પછી મુક્ત એકોર્ન્સ અને વજનદાર કીડીઓ ગુરુત્વાકર્ષણની દિશામાં એક-એક સેલ નીચે અથવા આગળ સરકે છે, જેનાથી બોર્ડનું લેઆઉટ સતત બદલાય છે.
- **Gravity Settlement Algorithm:**
  - વર્તમાન ગુરુત્વાકર્ષણ વેક્ટર: $\vec{g} \in \{(0, 1), (0, -1), (-1, 0), (1, 0)\}$ (Down, Up, Left, Right).
  - દરેક Move પૂર્ણ થયા પછી:
    - $\vec{g}$ ની વિરુદ્ધ દિશાથી સ્કેનિંગ થાય છે જેથી આગળ રહેલા ઘટકો પહેલા આગળ વધી શકે.
    - જો કોઈ મુક્ત બ્લોકર (M552) કે હેવી બીટલ (M554) આગળનો સેલ ખાલી હોય અને તે Dandelion Puff Tile (M553) પર ન હોય, તો તે $1$ સેલ આગળ સરકે છે.
    - જો આગળ અવરોધ, દીવાલ કે અન્ય સ્થિર લાઈન હોય, તો તે ત્યાં જ અટકી જાય છે (શાંતિપૂર્વક રેસ્ટિંગ સ્ટેટ).
  - **Bees Immunity:** મધમાખીઓ હવામાં ઉડે છે તેથી તે ગુરુત્વાકર્ષણથી સંપૂર્ણપણે મુક્ત છે (Bees never fall).

---

## 2. Base Mechanics Cards (M551–M554)

### M551 — Wind-Vane Lever (Gravity Lever)
| Field | Value |
|---|---|
| ID | `M551` |
| Themed Name | **Wind-Vane Lever** (પવન-કૂકડો લીવર) — Generic: Gravity Lever |
| Category | C / T — Directional Gravity Controller |
| Intro Level | **L5511** (Block 2 x1) |
| Rule | બોર્ડ પરનું પવન-કૂકડો લીવર. તેને ટેપ કરવાથી ($1$ Move વપરાય છે) ગુરુત્વાકર્ષણની દિશા આગામી દિશામાં ફરે છે (દા.ત. Down $\to$ Left $\to$ Up $\to$ Right). |
| Ants / Bees | સમગ્ર બોર્ડના ગુરુત્વાકર્ષણને નિયંત્રિત કરે છે. |
| Tall | Global controller. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M552 — Falling Acorns (Falling Blockers)
| Field | Value |
|---|---|
| ID | `M552` |
| Themed Name | **Falling Acorns** (પડતાં એકોર્ન) — Generic: Falling Blockers |
| Category | B / T — Gravity-Sensitive Blocker |
| Intro Level | **L5631** (Block 14 x1) |
| Rule | ઝાડ પરથી પડેલા ગોળાકાર એકોર્ન. દરેક Move પછી જો ગુરુત્વાકર્ષણની દિશામાં આગળનો સેલ ખાલી હોય, તો તે 1 સેલ સરકે છે. જો કોઈ કીડી તેના સરકવાના માર્ગમાં ઊભી હોય તો તે તેની આગળ જ અટકી જાય છે (કીડીને ક્યારેય કચડતું નથી). |
| Ants / Bees | ગ્રાઉન્ડ કીડીઓની લેન બ્લોક કરે છે; `tall: true` એકોર્ન બી લાઈનોને પણ બ્લોક કરે છે. |
| Tall | Per instance. |
| Hammerable | Yes (Leaf Blower થી ઉડી શકે છે). |
| Non-Monotone (N)| Yes. |

### M553 — Dandelion Puff Tile (Anti-grav Tile)
| Field | Value |
|---|---|
| ID | `M553` |
| Themed Name | **Dandelion Puff Tile** (ડેંડિલિઅન પફ ટાઇલ) — Generic: Anti-grav Tile |
| Category | D — Anti-Gravity Floating Sanctuary |
| Intro Level | **L5751** (Block 26 x1) |
| Rule | સફેદ રૂંવાંવાળા ડેંડિલિઅન ફૂલની ટાઇલ. આ ટાઇલ પર રહેલી કોઈપણ વસ્તુ (એકોર્ન કે ભારે કીડી) ગુરુત્વાકર્ષણની ખેંચાણથી મુક્ત થઈને હવામાં તરતી રહે છે અને નીચે પડતી નથી જ્યાં સુધી તેને બહાર કાઢવામાં ન આવે. |
| Ants / Bees | તમામ કીડીઓ અને ઘટકો માટે એન્ટિ-ગ્રેવિટી પ્રોટેક્શન આપે છે. |
| Tall | `false` (ground level tile). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M554 — Heavy Beetle Line (Weight Path)
| Field | Value |
|---|---|
| ID | `M554` |
| Themed Name | **Heavy Beetle Line** (ભારે બીટલ લાઈન) — Generic: Weight Path |
| Category | P / T — Gravity-Drifting Insect Line |
| Intro Level | **L5871** (Block 38 x1) |
| Rule | જાડા કવચવાળી ભારે બીટલ કીડીઓની લાઈન. જો તેમની આગળનો રસ્તો ગુરુત્વાકર્ષણ દિશામાં ખાલી હોય, તો દરેક Move પછી આખી લાઈન $1$ સેલ ગુરુત્વાકર્ષણ દિશામાં આપમેળે સરકે છે. પ્લેયરે ગ્રેવિટીનો યોગ્ય ઉપયોગ કરીને તેને એક્ઝિટ લેન સુધી પહોંચાડવી પડે છે. |
| Ants / Bees | માત્ર જમીન પરની ભારે કીડીઓ (Ants only) ગુરુત્વાકર્ષણથી સરકે છે; મધમાખીઓ ઉડે છે. |
| Tall | `false` (ground only). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |


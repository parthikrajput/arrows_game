# 03 — Signature System & Mechanics, Phase 6 (M251–M254)
> Sunlit Garden (Light & Beams+ architecture), raycasting rules, layer-bound optics અને M251–M254 base mechanics cards.

**Related docs:** [Phase 6 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_6_SCOPE_AND_RULES.md)

---

## 1. Signature System: Sunlit Garden (Light & Beams+)
- **Core Concept:** Phase 2 માં ઉમેરાયેલ સનબીમ્સ (M084 Sunbeam Emitter, M085 Sunflower Receiver, M089 Dew Prism) Phase 6 માં કલર ફિલ્ટરિંગ, ડ્યુઅલ સ્પ્લિટ-રિસીવર લૉકિંગ, મૂવ-આધારિત સનડાયલ ટાઇમિંગ અને ડાર્ક શેડિંગ સાથે અદ્યતન ઓપ્ટિકલ પઝલ નેટવર્ક બનાવે છે.
- **Raycasting Engine & Layer Rules:**
  - દરેક emitter ચોક્કસ લેયર સાથે જોડાયેલ છે (`params.layer: 0 (ground), 1 (air), 2 (canopy)`).
  - કિરણ તેના જ લેયરની લાઈનો (જેમ કે શરીરના સેલ્સ) અને `tall: true` ધરાવતા બ્લોકર્સ દ્વારા અવરોધાય છે અથવા રીફ્લેક્ટ થાય છે.
  - મહત્તમ 8 પરાવર્તન (reflections) પછી કિરણ ઓગળી જાય છે (infinite loop prevention).
  - કિરણનું ટ્રેસિંગ સંપૂર્ણપણે ટર્ન-આધારિત સ્ટેટિક રી-ઈવેલ્યુએશન છે: દરેક Move પછી સમગ્ર બોર્ડના બીમ્સ તરત રી-કેલ્ક્યુલેટ થાય છે ($O(W+H)$ per emitter).

---

## 2. Base Mechanics Cards (M251–M254)

### M251 — Petal Filter (Color Filter)
| Field | Value |
|---|---|
| ID | `M251` |
| Themed Name | **Petal Filter** (પાંખડી ફિલ્ટર) — Generic: Color Filter |
| Category | O — Optical / Beam Filter |
| Intro Level | **L2511** (Block 2 x1) |
| Rule | પારદર્શક રંગીન ફૂલની પાંખડી (Red, Yellow, Blue). જ્યારે કોઈ સૂર્યકિરણ આ ફિલ્ટરમાંથી સીધું પસાર થાય છે, ત્યારે કિરણ ફિલ્ટરનો રંગ ધારણ કરે છે. રંગીન સનફ્લાવર રિસીવર્સ માત્ર તેમના મેચિંગ રંગના કિરણથી જ સક્રિય થાય છે. સફેદ કિરણ તમામ ફિલ્ટરમાંથી પસાર થઈ શકે છે, પરંતુ એકવાર રંગીન થયા પછી વિરોધી રંગના ફિલ્ટર તેને બ્લોક કરે છે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ ફિલ્ટર સેલ પરથી સામાન્ય રીતે પસાર થઈ શકે છે (લેન બ્લોક થતી નથી). |
| Tall | `params.tall` મુજબ (ડિફૉલ્ટ `false` = ગ્રાઉન્ડ લેવલ). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M252 — Twin-Sun Lock (Beam Splitter Lock)
| Field | Value |
|---|---|
| ID | `M252` |
| Themed Name | **Twin-Sun Lock** (ટ્વિન-સૂર્ય લૉક) — Generic: Beam Splitter Lock |
| Category | K / O — Optical Lock |
| Intro Level | **L2631** (Block 14 x1) |
| Rule | બે અલગ-અલગ સનફ્લાવર રિસીવર્સ સાથે જોડાયેલો કાંટાળો ગેટ. આ ગેટ ત્યારે જ ખુલે છે જ્યારે બંને રિસીવર્સ એક જ મૂવમાં એકસાથે સૂર્યકિરણો વડે પ્રકાશિત થાય. જો કોઈ એક રિસીવરનો બીમ કટ થઈ જાય, તો ગેટ તરત બંધ થઈ જાય છે. |
| Ants / Bees | બંધ હોય ત્યારે ગ્રાઉન્ડ કીડીઓને બ્લોક કરે છે; `tall: true` હોય તો બી લાઈનોને પણ બ્લોક કરે છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M253 — Sundial Lens (Beam Timer)
| Field | Value |
|---|---|
| ID | `M253` |
| Themed Name | **Sundial Lens** (સનડાયલ લેન્સ) — Generic: Beam Timer |
| Category | O / T — Timed Emitter |
| Intro Level | **L2751** (Block 26 x1) |
| Rule | મૂવ-આધારિત પિરિયોડિક એમિટર. તે દર $N$ Moves સુધી પ્રકાશનું કિરણ ચાલુ રાખે છે અને પછી $N$ Moves સુધી બંધ રહે છે (`params.period: N`, ઉદા. $N = 3$ Moves ON, $3$ Moves OFF). આમાં કોઈ wall-clock timer નથી; માત્ર પ્લેયરના વેલિડ મૂવ્સ જ કાઉન્ટર આગળ વધારે છે. |
| Ants / Bees | બીમ ચાલુ હોય ત્યારે મેચિંગ લેયરના રિસીવર્સ અને શેડ પેચને સક્રિય કરે છે. |
| Tall | Emitter layer મુજબ. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M254 — Shade Patch (Dark Cells)
| Field | Value |
|---|---|
| ID | `M254` |
| Themed Name | **Shade Patch** (છાંયડાનો પેચ) — Generic: Dark Cells |
| Category | D / O — Environmental Constraint |
| Intro Level | **L2871** (Block 38 x1) |
| Rule | બોર્ડ પરનો ઘેરો છાંયડો ધરાવતો $2\times 2$ અથવા $3\times 3$ વિસ્તાર. આ વિસ્તારમાં રહેલી કોઈપણ કીડી કે મધમાખીનું શરીર જ્યાં સુધી અંધારામાં હોય ત્યાં સુધી તે **Locked** રહે છે (ટેપ કરતાં "In the dark!" ફીડબેક મળે છે). જ્યારે તેના જ લેયરનું સૂર્યકિરણ તે લાઈનના કોઈપણ એક શરીર સેલ પર પડે છે, ત્યારે લાઈન તરત જ અનલૉક થાય છે અને ટેપ કરી શકાય છે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ બંનેને તેમના સંબંધિત લેયરના બીમની જરૂર પડે છે. |
| Tall | N/A (ક્ષેત્ર આધારિત). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

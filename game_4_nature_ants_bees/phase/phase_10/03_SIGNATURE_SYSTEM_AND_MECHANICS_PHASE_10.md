# 03 — Signature System & Mechanics, Phase 10 (M451–M454)
> Garden Rhythm (Sequencing architecture), modulo rhythm states, FIFO color matching અને M451–M454 base mechanics cards.

**Related docs:** [Phase 10 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_10_SCOPE_AND_RULES.md)

---

## 1. Signature System: Garden Rhythm (Sequencing)
- **Core Concept:** ગાર્ડન પઝલ માત્ર અવકાશી માર્ગો પૂરતી સીમિત ન રહેતાં તેમાં સંગીતમય તાલબદ્ધતા અને ક્રમબદ્ધતા જોડાય છે. લાઈનોના એક્ઝિટ ક્રમ, કલર પેટર્ન અને મૂવ મોડ્યુલો સાયકલ્સ નક્કી કરે છે કે ગેટ્સ ક્યારે ખુલશે.
- **Rhythm Cycle Evaluation (M451):**
  - ગેટ પિરિયડ $P$ અને વેલિડ સ્ટેટ્સ $S$ ધરાવે છે.
  - વર્તમાન મૂવ કાઉન્ટ માટે જો $(\text{moveCount} \bmod P) \in S$ હોય, તો ગેટ ઓપન સ્ટેટમાં હોય છે.
  - પ્લેયર આગામી કેટલા મૂવ્સ પછી ગેટ ખુલશે તે ગેટ પરના રિધમિક બેજ દ્વારા જોઈ શકે છે.
- **Color Sequence FIFO (M452):**
  - લૉક પર $k$ લંબાઈની કલર સ્ટ્રિંગ (દા.ત. [Red, Yellow, Sky]) દર્શાવાય છે.
  - પ્લેયર દ્વારા બોર્ડમાંથી બહાર કાઢવામાં આવતી લાઈનોના રંગો FIFO બફરમાં નોંધાય છે. જ્યારે છેલ્લા $k$ એક્ઝિટ્સ બરાબર મેચ થાય છે ત્યારે લૉક કાયમી અનલૉક થાય છે.
- **Queue Order Enforcement (M453):**
  - Queue Hedge પર 1, 2, 3 ક્રમ અંકિત હોય છે. જ્યાં સુધી 1 નંબરની લાઈન એક્ઝિટ ન થાય ત્યાં સુધી 2 નંબરની લાઈન ત્યાંથી નીકળી શકતી નથી (bonk થાય છે).

---

## 2. Base Mechanics Cards (M451–M454)

### M451 — Cricket Gate (Rhythm Gate)
| Field | Value |
|---|---|
| ID | `M451` |
| Themed Name | **Cricket Gate** (તમરાં ગેટ) — Generic: Rhythm Gate |
| Category | G / T — Modulo-Timed Gate |
| Intro Level | **L4511** (Block 2 x1) |
| Rule | તમરાંની નાની મ્યુઝિકલ વાંસળી ધરાવતો ગેટ. જ્યારે $\text{moveCount} \bmod P \in S$ હોય ત્યારે જ તે ખુલ્લો રહે છે (ઉદા. $P = 3, S = \{0\}$). બાકીના મૂવ્સ પર તે બંધ રહે છે. કોઈ wall-clock timer નથી; પ્લેયરના દરેક માન્ય મૂવ સાથે રિધમ સ્ટેટ આગળ વધે છે. |
| Ants / Bees | બંધ હોય ત્યારે ગ્રાઉન્ડ કીડીઓને બ્લોક કરે છે; `tall: true` હોય તો બી લાઈનોને પણ બ્લોક કરે છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M452 — Bead-String Lock (Pattern Lock)
| Field | Value |
|---|---|
| ID | `M452` |
| Themed Name | **Bead-String Lock** (મોતી-માળા લૉક) — Generic: Pattern Lock |
| Category | K / S — Color Sequence Lock |
| Intro Level | **L4631** (Block 14 x1) |
| Rule | રંગબેરંગી મોતીઓની માળા ધરાવતો ફ્લોરલ લૉક. તેના પર $k$ રંગોનો ચોક્કસ ક્રમ કોતરેલો હોય છે (દા.ત. લાલ $\to$ વાદળી $\to$ પીળો). જ્યારે સતત $k$ લાઈનો બોર્ડમાંથી એક્ઝિટ થાય અને તેમનો રંગ આ ક્રમ સાથે બરાબર મેચ થાય, ત્યારે કાંટાળો ગેટ કાયમી ખુલી જાય છે. ખોટો રંગ આવતાં સીક્વન્સ રીસેટ થાય છે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ બંનેના એક્ઝિટ રંગો આ પેટર્નમાં ગણાય છે. |
| Tall | Lock per tall. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M453 — Queue Hedge (Order Edge)
| Field | Value |
|---|---|
| ID | `M453` |
| Themed Name | **Queue Hedge** (કતાર હેજ) — Generic: Order Edge |
| Category | B / S — Strict Numerical Order Edge |
| Intro Level | **L4751** (Block 26 x1) |
| Rule | સરહદ પરનો હેજ દીવાલ સેગમેન્ટ જેના પર 1, 2, 3... ક્રમાંક લખેલા હોય છે. તે માત્ર તેના પોતાના નંબરના ક્રમ મુજબ જ લાઈનોને એક્ઝિટ થવા દે છે. જો 1 નંબરની લાઈન નીકળ્યા પહેલા 2 નંબરની લાઈન ત્યાંથી નીકળવાનો પ્રયત્ન કરે, તો તે અથડાઈને પાછી આવે છે (bonk, $-1$ Heart). |
| Ants / Bees | ગ્રાઉન્ડ લેવલ કીડીઓ માટે હેજ; `tall: true` હોય તો બી લાઈનોને પણ કતારબદ્ધ રાખે છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M454 — Echo Bloom (Echo Sequence)
| Field | Value |
|---|---|
| ID | `M454` |
| Themed Name | **Echo Bloom** (પડઘો ફૂલ) — Generic: Echo Sequence |
| Category | S / G — Memory Playback Gate |
| Intro Level | **L4871** (Block 38 x1) |
| Rule | એક વિશિષ્ટ જાંબલી પડઘો-ફૂલ. લેવલની પ્રથમ $k$ લાઈનો (Phase 1) જે રંગ ક્રમમાં બહાર નીકળે છે, તે રંગો આ ફૂલની પાંડીઓ પર નોંધાઈ જાય છે. ત્યાર પછીની $k$ લાઈનો (Phase 2) એ તે જ રંગ ક્રમમાં બહાર નીકળવું પડે છે. જો પ્લેયર ખોટા રંગની લાઈનને ટેપ કરે, તો લાઈન હળવી ધ્રૂજીને અટકી જાય છે ("Out of tune!"). |
| Ants / Bees | તમામ લેયર્સના એક્ઝિટ રંગો રેકોર્ડ અને પ્લેબેક થાય છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |


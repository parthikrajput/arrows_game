# 03 — Signature System & Mechanics, Phase 9 (M401–M404)
> Swarm Splits (Split & Merge architecture), branch collision verification, caravan coupling અને M401–M404 base mechanics cards.

**Related docs:** [Phase 9 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_9_SCOPE_AND_RULES.md)

---

## 1. Signature System: Swarm Splits (Split & Merge)
- **Core Concept:** કીડીઓ અને મધમાખીઓ હવે માત્ર અખંડ લાઈનો તરીકે જ નથી ચાલતી; પઝલ જરૂરિયાત મુજબ લાઈનો ફોર્ક ટ્વિગ્સ દ્વારા બે અલગ-અલગ શાખાઓમાં વહેંચાય છે અને હની મર્જ પેડ્સ પર ફરી જોડાઈને લાંબા કારવાં બનાવે છે.
- **Line Splitting Rules (M402):**
  - લંબાઈ $L$ ધરાવતી લાઈન ફોર્ક સેલ પર પહોંચતાં:
    - જો $L$ બેકી હોય (even) $\implies$ બંને શાખામાં $L/2$ લંબાઈની લાઈનો બને છે.
    - જો $L$ એકી હોય (odd) $\implies$ ડાબી શાખા $\lceil L/2 \rceil$ અને જમણી શાખા $\lfloor L/2 \rfloor$ લંબાઈ ધારણ કરે છે.
  - ડાબી શાખા $90^\circ$ CCW અને જમણી શાખા $90^\circ$ CW વળાંક લઈને આગળ વધે છે.
  - **Atomic Collision Check:** જો બંનેમાંથી કોઈપણ એક શાખાનો રસ્તો બ્લોક હોય, તો સમગ્ર મૂવ ફેલ થાય છે (bonk, $-1$ Heart) અને કોઈ લાઈન આગળ વધતી નથી.
- **Caravan Coupling Rules (M401):**
  - પ્રથમ લાઈન હની મર્જ પેડ પર પહોંચીને અટકે છે.
  - બીજી લિંક્ડ લાઈન જ્યારે તે જ પેડ પર પ્રવેશે છે, ત્યારે તે પ્રથમ લાઈનની પાછળ જોડાઈ જાય છે અને બંને એક સંયુક્ત લાઈન તરીકે બીજી લાઈનની દિશામાં આગળ કૂચ કરે છે (same layer only).

---

## 2. Base Mechanics Cards (M401–M404)

### M401 — Honey Merge Pad (Merger Pad)
| Field | Value |
|---|---|
| ID | `M401` |
| Themed Name | **Honey Merge Pad** (મધ મર્જ પેડ) — Generic: Merger Pad |
| Category | T — Stationary Line Fusion Tile |
| Intro Level | **L4011** (Block 2 x1) |
| Rule | સ્ટીકી મધનું સોનેરી પેડ. જ્યારે પ્રથમ લિંક્ડ લાઈન આ પેડ પર પહોંચે છે, ત્યારે તેનું માથું પેડ પર રોકાઈ જાય છે (તે નિષ્ક્રિય બને છે). જ્યારે બીજી લિંક્ડ લાઈન આ પેડ પર પહોંચે છે, ત્યારે તે પ્રથમ લાઈન સાથે સંયોજિત થઈ જાય છે અને બંને એક સાથે બીજી લાઈનની મૂળ દિશામાં આગળ વધીને બોર્ડ બહાર નીકળે છે. |
| Ants / Bees | માત્ર સમાન લેયરની લાઈનો જ મર્જ થઈ શકે છે (કીડી ↔ કીડી, બી ↔ બી). |
| Tall | Layer મુજબ. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M402 — Fork Twig (Twin Splitter)
| Field | Value |
|---|---|
| ID | `M402` |
| Themed Name | **Fork Twig** (કાંટાવાળી ડાળી) — Generic: Twin Splitter |
| Category | T — Dynamic Line Splitting Node |
| Intro Level | **L4131** (Block 14 x1) |
| Rule | Y-આકારની નાની ડાળી. જ્યારે કોઈ લાઈન તેના મુખ તરફથી પ્રવેશે છે, ત્યારે તે બે સમાન અર્ધભાગમાં વિભાજિત થઈને $90^\circ$ ડાબી અને જમણી દિશામાં બહાર નીકળે છે. બંને એક્ઝિટ પાથ સંપૂર્ણપણે ખાલી હોવા અનિવાર્ય છે. |
| Ants / Bees | કીડીઓની લેન માટે ગ્રાઉન્ડ ડાળી; `tall: true` હોય તો બી લાઈનોને પણ વિભાજિત કરે છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M403 — Segment Clasp (Segment Lock)
| Field | Value |
|---|---|
| ID | `M403` |
| Themed Name | **Segment Clasp** (સેગમેન્ટ ક્લેસ્પ) — Generic: Segment Lock |
| Category | K / P — Selective Body Segment Lock |
| Intro Level | **L4251** (Block 26 x1) |
| Rule | લાઈનના પાછળના સેગમેન્ટ્સને પકડી રાખતો નાનો ગોલ્ડન બકલ/ક્લેસ્પ. ક્લેસ્પ લાગેલી લાઈનને ટેપ કરવાથી માત્ર તેનું આગળનું મુક્ત સેગમેન્ટ ચાલે છે, જ્યારે પાછળના સેગમેન્ટ્સ લૉક રહે છે જ્યાં સુધી તેની સાથે જોડાયેલી કી-લાઈન બોર્ડમાંથી બહાર ન નીકળી જાય. કી-લાઈન નીકળતાં ક્લેસ્પ ખુલે છે અને બાકીના સેગમેન્ટ્સ સ્વતંત્ર લાઈન બની જાય છે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ બંનેની લાઈનો પર લાગુ પડે છે. |
| Tall | Line layer મુજબ. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M404 — Reunion Arch (Rejoin Gate)
| Field | Value |
|---|---|
| ID | `M404` |
| Themed Name | **Reunion Arch** (પુનઃમિલન કમાન) — Generic: Rejoin Gate |
| Category | G — Split Completion Gate |
| Intro Level | **L4371** (Block 38 x1) |
| Rule | લીલા પાંદડાઓથી ગૂંથેલી સુંદર કમાન. આ ગેટ ત્યારે જ ખુલે છે જ્યારે Fork Twig (M402) દ્વારા વિભાજિત થયેલી લાઈનના બંને અર્ધભાગ (Left & Right halves) બોર્ડમાંથી સફળતાપૂર્વક બહાર નીકળી જાય. એક અડધો ભાગ નીકળે તો ગેટ બંધ જ રહે છે. |
| Ants / Bees | બંધ હોય ત્યારે ગ્રાઉન્ડ કીડીઓને બ્લોક કરે છે; `tall: true` હોય તો બી લાઈનોને પણ બ્લોક કરે છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |


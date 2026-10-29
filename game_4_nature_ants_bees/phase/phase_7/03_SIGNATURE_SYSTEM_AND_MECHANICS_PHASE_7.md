# 03 — Signature System & Mechanics, Phase 7 (M301–M304)
> Whirling Garden (Rotation architecture), rotation matrix transforms, perimeter tracking અને M301–M304 base mechanics cards.

**Related docs:** [Phase 7 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_7_SCOPE_AND_RULES.md)

---

## 1. Signature System: Whirling Garden (Rotation)
- **Core Concept:** બોર્ડના ચોક્કસ ભાગો અથવા લાઈનોની દિશાઓ $90^\circ$ ક્લોકવાઇઝ ફરે છે, જેનાથી અગાઉ બ્લોક થયેલા રસ્તાઓ અચાનક ખુલી જાય છે અને નવી બહાર નીકળવાની લેન્સ બને છે.
- **Sub-Grid Coordinate Transforms (90° CW):**
  - સ્થાનિક સેન્ટર $(x_c, y_c)$ ની સાપેક્ષે કોઈપણ સેલ $(x, y)$ નું નવું સ્થાન:
    $$x' = x_c + (y - y_c)$$
    $$y' = y_c - (x - x_c)$$
- **Line Direction CW Mapping:**
  - Orthogonal: $\text{Right} \to \text{Down} \to \text{Left} \to \text{Up} \to \text{Right}$.
  - Diagonal: $\text{Down-Right} \to \text{Down-Left} \to \text{Up-Left} \to \text{Up-Right} \to \text{Down-Right}$.
- **Containment Rule:**
  - ટર્નટેબલ ફેરવવા માટે તે વિસ્તારમાં રહેલી લાઈનોના તમામ બોડી સેલ્સ તે ટર્નટેબલ વિસ્તારની અંદર હોવા જરૂરી છે. સરહદ ઓળંગતી કોઈપણ લાઈન ટર્નટેબલ રોટેશનને બ્લોક કરે છે.

---

## 2. Base Mechanics Cards (M301–M304)

### M301 — Flower-Bed Turntable (Sub-board Rotor)
| Field | Value |
|---|---|
| ID | `M301` |
| Themed Name | **Flower-Bed Turntable** (ફૂલક્યારી ટર્નટેબલ) — Generic: Sub-board Rotor |
| Category | T / C — Interactive Rotating Grid |
| Intro Level | **L3011** (Block 2 x1) |
| Rule | $4\times 4$ અથવા $5\times 5$ કદનો ગોળાકાર ફૂલક્યારી વિસ્તાર. તેના કેન્દ્રમાં એક પાવર કંટ્રોલ બટન હોય છે. પ્લેયર આ બટન ટેપ કરે છે ($1$ Move વપરાય છે), જેનાથી આ વિસ્તારની અંદર રહેલા તમામ બ્લોક્સ, લાઈનો અને મિકેનિક્સ $90^\circ$ ક્લોકવાઇઝ ફરી જાય છે. લાઈનોના મુખની દિશા પણ $90^\circ$ CW ફરી જાય છે. |
| Ants / Bees | કીડીઓ, મધમાખીઓ અને કેનોપી બીઝ તમામ લેયર્સ એકસાથે રોટેટ થાય છે. |
| Tall | N/A (ક્ષેત્ર આધારિત). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M302 — Turning Hedge (Rotating Edges)
| Field | Value |
|---|---|
| ID | `M302` |
| Themed Name | **Turning Hedge** (ફરતી હેજ દીવાલ) — Generic: Rotating Edges |
| Category | B / T — Perimeter Moving Blocker |
| Intro Level | **L3131** (Block 14 x1) |
| Rule | બોર્ડની બાહ્ય સરહદ (perimeter edge) પર લાગેલી કાંટાળી હેજ દીવાલો. તે દર $N$ Moves એ ($N = 2$ કે $3$) બોર્ડની કિનારીઓ પર $1$ સેલ ક્લોકવાઇઝ આગળ સરકે છે. તેનાથી બહાર નીકળવાના એક્ઝિટ ગેપ્સ (Exit Gaps) પણ સતત ફરતા રહે છે. |
| Ants / Bees | ગ્રાઉન્ડ લેવલ કીડીઓ સામાન્ય હેજથી બ્લોક થાય છે; `tall: true` હેજ મધમાખીઓને પણ બ્લોક કરે છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M303 — Spinning Top Line (Spin Path)
| Field | Value |
|---|---|
| ID | `M303` |
| Themed Name | **Spinning Top Line** (ભમરડા લાઈન) — Generic: Spin Path |
| Category | P — Dynamic Direction Insect Line |
| Intro Level | **L3251** (Block 26 x1) |
| Rule | આ લાઈનના માથા પર ભમરડા જેવી પાંખો હોય છે. દરેક ટર્નમાં જો પ્લેયર અન્ય કોઈ લાઈનને ચલાવે (આ લાઈન સ્થિર રહે), તો આ લાઈનની દિશા આપમેળે $90^\circ$ CW ફરી જાય છે. પ્લેયરે યોગ્ય દિશા આવે ત્યારે જ તેને ટેપ કરીને બહાર કાઢવી પડે છે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ બંનેમાં સ્પિનિંગ ટોપ વેરિઅન્ટ હોઈ શકે છે. |
| Tall | Line layer મુજબ. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M304 — Pinned Daisy (Rotation Lock)
| Field | Value |
|---|---|
| ID | `M304` |
| Themed Name | **Pinned Daisy** (જડાયેલ ડેઇઝી) — Generic: Rotation Lock |
| Category | K / D — Rotation Immune Anchor |
| Intro Level | **L3371** (Block 38 x1) |
| Rule | જમીનમાં ઊંડા મૂળ ધરાવતું સફેદ ડેઇઝી ફૂલ. જે લાઈન પર આ ફૂલ જડાયેલું હોય, તે લાઈન કોઈપણ રોટેશનથી સંપૂર્ણપણે મુક્ત (immune) રહે છે. જો આવી કોઈ લાઈન Flower-Bed Turntable (M301) ની અંદર હોય, તો તે ટર્નટેબલ ફેરવી શકાતું નથી (કંટ્રોલ બટન લૉક થઈ જાય છે). પ્રથમ તે લાઈનને બહાર કાઢવી પડે છે, ત્યારબાદ જ ટર્નટેબલ ફરી શકે છે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ બંને પર પિન થઈ શકે છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

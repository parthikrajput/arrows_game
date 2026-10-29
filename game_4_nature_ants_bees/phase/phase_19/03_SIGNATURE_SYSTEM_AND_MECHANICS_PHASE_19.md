# 03 — Signature System & Mechanics, Phase 19 (M901–M904)
> Garden Festival II (Remix B architecture), kinetic multi-system composition, analytics selection rule અને M901–M904 combo cards.

**Related docs:** [Phase 19 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_19_SCOPE_AND_RULES.md)

---

## 1. Signature System: Garden Festival II (Remix B)
- **Core Concept:** Phases 7 થી 12 ની અદ્યતન સિસ્ટમ્સ (રોટેશન, ગ્રોથ, સ્પ્લિટ/મર્જ, રિધમિક સીક્વન્સિંગ, લિંક્ડ બોર્ડ્સ અને ગ્રેવિટી) નું ગતિશીલ સંયોજન.
- **Selection Rule (Standard §7):**
  - લાઈવ ટેલિમેટ્રી ડેટા (D7–D12 પૂર્ણતા દર, બૂસ્ટર વપરાશ દર અને પ્લેયર રિટેન્શન) દ્વારા સૌથી સંતોષકારક સાબિત થયેલી પેરેન્ટ સિસ્ટમ્સના કોમ્બોઝ પસંદ થાય છે.
- **Rule Composition ($Rule_A \circ Rule_B$):**
  - બંને પેરેન્ટ મિકેનિક્સના નિયમો યથાવત્ રહે છે અને એકબીજા સાથે નિર્ધારિત ટિક ઓર્ડર (Standard §16.17) મુજબ ઇન્ટરેક્ટ કરે છે.

---

## 2. Combo Mechanics Cards (M901–M904)

### M901 — Falling Vines (Growth × Gravity)
| Field | Value |
|---|---|
| ID | `M901` |
| Themed Name | **Falling Vines** (પડતી વેલો) — Generic: Spreading Gravity Vines |
| Category | B / T — Gravity-Sensitive Expanding Vines |
| Intro Level | **L9011** (Block 2 x1) |
| Rule | Growth (Phase 8) અને Gravity (Phase 12) નું સંયોજન. મોર્નિંગ ગ્લોરી વેલો દર $N$ Moves એ ઓર્થોગોનલ દિશામાં વધે છે અને સાથે-સાથે ગુરુત્વાકર્ષણની દિશામાં $1$ સેલ નીચે સરકે છે, જેનાથી રસ્તાઓ સતત બદલાતા રહે છે. ગાર્ડન શેઅર્સ (M352) થી કાપી શકાય છે. |
| Ants / Bees | ગ્રાઉન્ડ કીડીઓ માટે બ્લોકર; `tall: true` હોય તો બી લાઈનોને પણ બ્લોક કરે છે. |
| Tall | Per instance. |
| Hammerable | Yes (Leaf Blower). |
| Non-Monotone (N)| Yes. |

### M902 — Rhythm Rotor (Sequencing × Rotation)
| Field | Value |
|---|---|
| ID | `M902` |
| Themed Name | **Rhythm Rotor** (રિધમ રોટર) — Generic: Auto-Timed Sub-board Turntable |
| Category | T / C — Modulo-Triggered Sub-Grid Rotor |
| Intro Level | **L9131** (Block 14 x1) |
| Rule | Sequencing (Phase 10) અને Rotation (Phase 7) નું સંયોજન. $4\times 4$ સબ-ગ્રીડ ટર્નટેબલ જે પ્લેયરના કોઈપણ ટેપ વગર, જ્યારે $\text{moveCount} \bmod P == 0$ થાય ત્યારે આપમેળે $90^\circ$ ક્લોકવાઇઝ ફરી જાય છે. પ્લેયરે તેના સ્વચાલિત પરિભ્રમણની ગણતરી કરીને ચાલવું પડે છે. |
| Ants / Bees | વિસ્તારની અંદર રહેલી તમામ કીડીઓ અને મધમાખીઓ આપમેળે રોટેટ થાય છે. |
| Tall | Grid region. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M903 — Twin-Garden Fork (Linked Boards × Split/Merge)
| Field | Value |
|---|---|
| ID | `M903` |
| Themed Name | **Twin-Garden Fork** (ટ્વિન-ગાર્ડન ફોર્ક) — Generic: Cross-Board Twin Splitter |
| Category | T / G — Inter-Board Line Splitting Node |
| Intro Level | **L9251** (Block 26 x1) |
| Rule | Linked Boards (Phase 11) અને Split/Merge (Phase 9) નું સંયોજન. બોર્ડ A ની સરહદ પર લાગેલી વિભાજક ડાળી. જ્યારે લાઈન તેના પર પ્રવેશે છે, ત્યારે એક અર્ધભાગ બોર્ડ A માં $90^\circ$ વળીને રહે છે, જ્યારે બીજો અર્ધભાગ બોર્ડ લિંક પાર કરીને સીધો જ બોર્ડ B માં પ્રવેશે છે! બંને બોર્ડમાં રસ્તો ક્લિયર હોવો અનિવાર્ય છે. |
| Ants / Bees | બંને બોર્ડના લેયર નિયમોનું પાલન કરે છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M904 — Gravity Turntable (Rotation × Gravity)
| Field | Value |
|---|---|
| ID | `M904` |
| Themed Name | **Gravity Turntable** (ગ્રેવિટી ટર્નટેબલ) — Generic: Rotating Gravity Zone |
| Category | T / C — Sector-Specific Gravity Matrix |
| Intro Level | **L9371** (Block 38 x1) |
| Rule | Rotation (Phase 7) અને Gravity (Phase 12) નું સંયોજન. આ વિશિષ્ટ ટર્નટેબલ ફેરવવાથી ($1$ Move) માત્ર લાઈનોની દિશા જ નથી ફરતી, પરંતુ તે વિસ્તાર પૂરતો સ્થાનિક ગુરુત્વાકર્ષણ પ્રવાહ પણ $90^\circ$ CW ફરી જાય છે, જેનાથી અંદર રહેલા એકોર્ન્સ નવી દિશામાં ગગડવા લાગે છે. |
| Ants / Bees | સ્થાનિક ગ્રેવિટી માત્ર ગ્રાઉન્ડ કીડીઓ અને લૂઝ એકોર્ન્સ પર અસર કરે છે. |
| Tall | Grid region. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

# 03 — Signature System & Mechanics, Phase 18 (M851–M854)
> Garden Festival I (Remix A architecture), cross-system rule composition, analytics selection rule અને M851–M854 combo cards.

**Related docs:** [Phase 18 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_18_SCOPE_AND_RULES.md)

---

## 1. Signature System: Garden Festival I (Remix A)
- **Core Concept:** Phases 1 થી 6 ની સફળ સિસ્ટમ્સ (ડે-નાઇટ સાયકલ્સ, મલ્ટિ-ફ્લોર ટેરેસ, એકોર્ન ફિઝિક્સ અને સનલાઇટ બીમ્સ) નું ગાણિતિક સંયોજન.
- **Selection Rule (Standard §7):**
  - કોઈ મનસ્વી નવી મિકેનિક્સ ઉમેરવામાં આવતી નથી.
  - લાઈવ ટેલિમેટ્રી ડેટા (D1–D30 પૂર્ણતા દર, બૂસ્ટર વપરાશ દર અને રિપ્લે રેટ) દ્વારા સૌથી વધુ એન્ગેજિંગ સાબિત થયેલી પેરેન્ટ સિસ્ટમ્સના કોમ્બોઝ પસંદ થાય છે.
- **Rule Composition ($Rule_A \circ Rule_B$):**
  - બંને પેરેન્ટ મિકેનિક્સના નિયમો યથાવત્ રહે છે અને એકબીજા સાથે નિર્ધારિત રીતે ઇન્ટરેક્ટ કરે છે.
  - લેયર નિયમો વારસામાં મળે છે (Ants vs Bees vs Canopy).

---

## 2. Combo Mechanics Cards (M851–M854)

### M851 — Day-Night Terrace (Cycles × Floors)
| Field | Value |
|---|---|
| ID | `M851` |
| Themed Name | **Day-Night Terrace** (દિન-રાત ટેરેસ) — Generic: Day-Night Stairs |
| Category | T / C — Temporal Vertical Portal |
| Intro Level | **L8511** (Block 2 x1) |
| Rule | Cycles (Phase 3) અને Multi-floor (Phase 4) નું સંયોજન. આ મૂળિયાંની સીડીઓ માત્ર દિવસના સ્ટેટમાં ($A$, દર 5 Moves એ બદલાતું) સક્રિય હોય છે અને કીડીઓને બીજા માળે લઈ જાય છે. રાત્રિના સ્ટેટમાં ($B$) સીડીઓ જમીનમાં સંકોચાઈ જાય છે અને સામાન્ય લૉન બની જાય છે. |
| Ants / Bees | કીડીઓ માટે ગ્રાઉન્ડ સીડી; `tall: true` હોય તો બી લાઈનો પણ ઉપયોગ કરે છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M852 — Sunlit Acorn (Push × Beams)
| Field | Value |
|---|---|
| ID | `M852` |
| Themed Name | **Sunlit Acorn** (સૂર્યમુખી એકોર્ન) — Generic: Movable Prism Block |
| Category | T / O — Mobile Optical Push Blocker |
| Intro Level | **L8631** (Block 14 x1) |
| Rule | Push Physics (Phase 5) અને Light & Beams (Phase 6) નું સંયોજન. એકોર્ન પુશ બ્લોક જેના ઉપર કાચનો પ્રિઝમ જડેલો છે. કીડી કે મધમાખી તેને ધકેલે ત્યારે તે નવા સેલ પર પહોંચે છે અને તેના પર પડતા સૂર્યકિરણને $90^\circ$ કોણ પર વાળીને દૂરના સનફ્લાવર રિસીવર તરફ ફેંકે છે. |
| Ants / Bees | કીડીઓ ધકેલી શકે છે; `tall: true` હોય તો બી લાઈનો પણ ધકેલે છે. |
| Tall | Per instance. |
| Hammerable | Yes (Leaf Blower). |
| Non-Monotone (N)| Yes. |

### M853 — Shaded Stairs (Beams × Floors)
| Field | Value |
|---|---|
| ID | `M853` |
| Themed Name | **Shaded Stairs** (છાંયડાની સીડી) — Generic: Illuminated Elevator |
| Category | T / O — Beam-Unlocked Vertical Link |
| Intro Level | **L8751** (Block 26 x1) |
| Rule | Beams (Phase 6) અને Multi-floor (Phase 4) નું સંયોજન. આ સીડીઓ ગાઢ અંધકારમાં છુપાયેલી હોય છે અને તેના પર લૉક લાગેલો હોય છે. જ્યારે સૂર્યકિરણ તેના પર પડે છે, ત્યારે સીડીઓ સોનેરી પ્રકાશિત થઈને બીજા માળે જવા માટે અનલૉક થાય છે. |
| Ants / Bees | બંને લેયર્સ પોતાના લેયરના બીમથી સીડી અનલૉક કરી શકે છે. |
| Tall | Layer મુજબ. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M854 — Dawn Marble (Cycles × Push)
| Field | Value |
|---|---|
| ID | `M854` |
| Themed Name | **Dawn Marble** (પ્રભાત લખોટી) — Generic: Cycle Phase Marble |
| Category | T / C — State-Dependent Sliding Block |
| Intro Level | **L8871** (Block 38 x1) |
| Rule | Cycles (Phase 3) અને Push Physics (Phase 5) નું સંયોજન. આ અતિ લપસણી લખોટી દિવસના સ્ટેટમાં ($A$) લૉન પર જ્યાં સુધી અવરોધ ન મળે ત્યાં સુધી સરકે છે; પરંતુ રાત્રિના સ્ટેટમાં ($B$) ઝાકળ જામી જતાં તે ભારે સ્થિર પથ્થર બની જાય છે જેને ધકેલી શકાતી નથી. |
| Ants / Bees | કીડીઓ દ્વારા ધકેલાય છે; `tall: true` હોય તો મધમાખીઓ પણ ધકેલે છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

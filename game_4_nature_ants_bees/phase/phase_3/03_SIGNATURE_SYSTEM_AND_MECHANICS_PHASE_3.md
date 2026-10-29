# 03 — Signature System & Mechanics, Phase 3 (M101–M104)
> Day & Night Garden (Cycles system) ના નિયમો, Sun/Moon dial HUD, tick order integration અને M101–M104 ના 4 નવા base mechanics cards.

**Related docs:** [Phase 3 README](./README.md) · [Shared Core Standard §11, §16.17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_3_SCOPE_AND_RULES.md)

---

## 1. Signature System: Day & Night Garden (Cycles)
- **Concept:** બગીચામાં સૂર્યોદય (Day) અને ચંદ્રપ્રકાશ (Night) ના 2 તબક્કા છે. દરેક તબક્કો બોર્ડનું વાતાવરણ અને cycle mechanics બદલે છે.
- **Cycle Period:** બરાબર **5 Moves** (Standard §11).
  - Move 0–4: State A (Day) — સન્ની ગાર્ડન, સોનેરી પ્રકાશ.
  - Move 5–9: State B (Night) — નીલી ચાંદની, ચમકતા આગિયા.
  - Move 10–14: State A (Day), અને આ જ રીતે ચાલુ રહે છે.
  - Formula: `cycleState = (moveCount / 5) % 2` (0 = Day/A, 1 = Night/B).
- **HUD Representation:** ટોપ બારમાં 5 સેગમેન્ટ્સવાળું **Sun/Moon Dial**:
  - દિવસ દરમિયાન: સૂર્યનું આઇકોન + આગામી 5 પગલાંની રિંગ.
  - 5મો મુવ પૂર્ણ થતાં: ડાયલ 180° ફરે છે, ચંદ્ર દેખાય છે અને બોર્ડ પર હળવો નાઇટ ટિંટ પથરાય છે.
- **Tick Order Integration (Standard §16.17):**
  - Step 1: Input validation & lane check.
  - Step 2: Line exit or bonk animation.
  - Step 3: Increment Move Counter (`moveCount++`).
  - Step 4: Evaluate Cycle flip: જો `moveCount % 5 == 0`, તો Cycle State ફ્લિપ થાય.
  - Step 5: Update cycle mechanics (Sunrise Gates, Bridges, Portals, Colors).
  - Step 6: Evaluate board consistency and check Win condition.

---

## 2. Base Mechanics Cards (M101–M104)

### M101 — Sunrise Gate (Cycle Gate)
| Field | Value |
|---|---|
| ID | `M101` |
| Themed Name | **Sunrise Gate** (સૂર્યોદય દ્વાર) — Generic: Cycle Gate |
| Category | B — Static Blocker / Gate |
| Intro Level | **L1011** (Block 2 x1) |
| Rule | State A (Day) માં ખુલ્લું રહે છે; State B (Night) માં પાંદડીઓ બિડાઈ જતાં બંધ થાય છે. `params.openIn: "B"` સેટ હોય તો ઊલટું કાર્ય કરે છે (Moonrise Gate). |
| Ants (Ground)| બંધ હોય ત્યારે કીડીઓની lane block કરે છે (bonk). |
| Bees (Air/Canopy)| `tall: true` હોય ત્યારે જ મધમાખીઓને block કરે છે. |
| Tall | Per instance (default `false`). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M102 — Moonlit Twig Bridge (Cycle Bridge)
| Field | Value |
|---|---|
| ID | `M102` |
| Themed Name | **Moonlit Twig Bridge** (ચંદ્રપ્રકાશ પુલ) — Generic: Cycle Bridge |
| Category | L — Layer / Bridge |
| Intro Level | **L1131** (Block 14 x1) |
| Rule | State B (Night) માં ચાંદનીથી ઝળહળીને bridge બને છે (Over/Under crossway); State A (Day) માં તે સામાન્ય સપાટ જમીન બની જાય છે (overlapping paths collide). |
| Ants (Ground)| Ant-only mechanic. |
| Bees (Air/Canopy)| Bees ઉપરથી ઉડી જાય છે (અપ્રભાવિત). |
| Tall | false (fixed). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M103 — Dawn Burrow (Cycle Portal)
| Field | Value |
|---|---|
| ID | `M103` |
| Themed Name | **Dawn Burrow** (પ્રભાત દર) — Generic: Cycle Portal |
| Category | D — Directional / Portal |
| Intro Level | **L1251** (Block 26 x1) |
| Rule | Portal pair માત્ર State A (Day) માં જ સક્રિય રહે છે. રાત્રે દર બંધ થઈ જાય છે અને બંને cells સામાન્ય જમીન બની જાય છે (કોઈ teleportation નહીં). |
| Ants (Ground)| કીડીઓને દિવસ દરમિયાન teleport કરે છે. |
| Bees (Air/Canopy)| Bees અપ્રભાવિત (દર ગ્રાઉન્ડ લેયર માટે છે). |
| Tall | false (fixed). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M104 — Day-Bloom Line (Cycle Color)
| Field | Value |
|---|---|
| ID | `M104` |
| Themed Name | **Day-Bloom Line** (દિન-પુષ્પ લાઈન) — Generic: Cycle Color |
| Category | P — Path-Variant |
| Intro Level | **L1371** (Block 38 x1) |
| Rule | Line નો રંગ દિવસ અને રાત્રે અલગ હોય છે: State A માં `colorA` (દા.ત. Red) અને State B માં `colorB` (દા.ત. Blue). Color Gates અને Petal Baskets વર્તમાન રંગ ચકાસે છે. |
| Ants / Bees | બંને લેયર્સ પર લાગુ (path-modifier). Head glyph પણ બદલાય છે. |
| Tall | N/A. |
| Hammerable | Line તરીકે Leaf Blower થી દૂર થઈ શકે છે. |
| Non-Monotone (N)| Yes. |


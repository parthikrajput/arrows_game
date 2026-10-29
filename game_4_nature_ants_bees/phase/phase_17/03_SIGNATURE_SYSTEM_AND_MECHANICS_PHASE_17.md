# 03 — Signature System & Mechanics, Phase 17 (M801–M804)
> Garden Guardians (Guardians architecture), multi-tile boss entities, shared HP pools અને M801–M804 base mechanics cards.

**Related docs:** [Phase 17 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_17_SCOPE_AND_RULES.md)

---

## 1. Signature System: Garden Guardians (Guardians)
- **Core Concept:** સામાન્ય 1-સેલ બ્લોકર્સની સરખામણીએ બોર્ડ પર વિશાળ $2\times 2$ કદના બોસ ગાર્ડિયન્સ આવે છે. આ ગાર્ડિયન્સ `tall: true` ધરાવતા હોવાથી કીડીઓ અને મધમાખીઓ બંનેને બ્લોક કરે છે અને તેમને હટાવવા માટે બહુસ્તરીય હુમલા (HP ડેમેજ) જરૂરી છે.
- **Shared HP Pool Rules (M801):**
  - ટ્વિન હોર્નેટ્સ $A$ અને $B$ બે અલગ-અલગ સ્થાને બેસે છે પરંતુ એક જ HP પૂલ શેર કરે છે (દા.ત. 4 HP).
  - કોઈપણ લિંક્ડ લાઈન બહાર નીકળતાં HP માંથી 1 પોઇન્ટ ઘટે છે.
  - $\text{HP} = 0$ થતાં બંને બોસ એકસાથે પરાગના ધુમાડામાં અદ્રશ્ય થાય છે.
- **Armor Stripping Logic (M802):**
  - રાઇનો બીટલનું કવચ જ્યાં સુધી ઓન હોય, ત્યાં સુધી લાઈનો નીકળવા છતાં તેને કોઈ ડેમેજ થતું નથી.
  - બોર્ડ પરનું લિંક્ડ લીવર ઓપરેટ થતાં કવચ તૂટે છે અને ત્યારબાદ જ HP ઘટાડી શકાય છે.
- **Spawner Dynamics (M803):**
  - દર $N$ Moves એ (Up $\to$ Right $\to$ Down $\to$ Left) ક્રમમાં પ્રથમ ખાલી સેલ પર માટીનો બ્લોકર સ્પોન કરે છે જ્યાં સુધી બોસ હારે નહીં.
- **Core Precision Requirement (M804):**
  - માત્ર એવી જ લાઈનો ડેમેજ આપી શકે છે જેનો એક્ઝિટ પાથ હાર્ટ-સીડ સેલમાંથી ચોક્કસ રીતે પસાર થાય.

---

## 2. Base Mechanics Cards (M801–M804)

### M801 — Twin Hornets (Twin Guardian)
| Field | Value |
|---|---|
| ID | `M801` |
| Themed Name | **Twin Hornets** (જોડિયા ભમરા) — Generic: Twin Guardian |
| Category | B / G — Shared HP Dual Boss |
| Intro Level | **L8011** (Block 2 x1) |
| Rule | બે વિશાળ $2\times 2$ કદના પીળા-કાળા હોર્નેટ્સ. બંને એક જ HP પૂલ (દા.ત. 4 કે 6 HP) શેર કરે છે. નિર્ધારિત લાઈનો બોર્ડમાંથી બહાર નીકળે ત્યારે 1 HP ઘટે છે. જ્યારે HP શૂન્ય થાય ત્યારે બંને હોર્નેટ્સ એકસાથે ગાયબ થાય છે અને સમગ્ર રસ્તો ખુલે છે. |
| Ants / Bees | `tall: true` હોવાથી ગ્રાઉન્ડ કીડીઓ અને તમામ મધમાખીઓને બ્લોક કરે છે. |
| Tall | `true` (fixed). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M802 — Armored Rhino Beetle (Shield Guardian)
| Field | Value |
|---|---|
| ID | `M802` |
| Themed Name | **Armored Rhino Beetle** (કવચધારી રાઇનો બીટલ) — Generic: Shield Guardian |
| Category | B / G — Shielded Boss Blocker |
| Intro Level | **L8131** (Block 14 x1) |
| Rule | જાડા પથ્થર જેવું શીંગડાવાળું કવચ ધરાવતો $2\times 2$ ગાર્ડિયન. શરૂઆતમાં તેના પર કોઈપણ લાઈનનો એક્ઝિટ ડેમેજ થતો નથી. જ્યારે તેની સાથે જોડાયેલું Ivy Lever ઓપરેટ કરવામાં આવે છે, ત્યારે તેનું કવચ ખરી પડે છે અને સામાન્ય ડેમેજ લઈ શકે છે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ બંનેને બ્લોક કરે છે. |
| Tall | `true` (fixed). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M803 — Wasp Nest Guardian (Spawner Guardian)
| Field | Value |
|---|---|
| ID | `M803` |
| Themed Name | **Wasp Nest Guardian** (ભમરી માળો ગાર્ડિયન) — Generic: Spawner Guardian |
| Category | B / T — Periodic Obstacle Spawner |
| Intro Level | **L8251** (Block 26 x1) |
| Rule | ડાળી પર લટકતો વિશાળ ભમરીનો માળો ($2\times 2$). દર $N$ Moves એ (ડિફૉલ્ટ $N = 4$) તે પોતાની આસપાસના પ્રથમ મુક્ત સેલ પર માટીનો $1$-સેલ બ્લોકર સ્પોન કરે છે. જ્યાં સુધી પ્લેયર લિંક્ડ લાઈનો બહાર કાઢીને તેનો HP 0 ન કરે ત્યાં સુધી સ્પોનિંગ ચાલુ રહે છે. |
| Ants / Bees | માળો અને સ્પોન થયેલા બ્લોકર્સ બંને લેયર્સને પ્રભાવિત કરે છે. |
| Tall | `true` (fixed). |
| Hammerable | No (Nest); Spawns hammerable via Leaf Blower. |
| Non-Monotone (N)| Yes. |

### M804 — Heart-Seed Guardian (Guardian Core)
| Field | Value |
|---|---|
| ID | `M804` |
| Themed Name | **Heart-Seed Guardian** (હૃદય-બીજ ગાર્ડિયન) — Generic: Guardian Core |
| Category | B / G — Precision Core Target Guardian |
| Intro Level | **L8371** (Block 38 x1) |
| Rule | કેન્દ્રમાં લાલ હાર્ટ-સીડ રત્ન ધરાવતો પ્રાચીન વૃક્ષ-ગાર્ડિયન. સામાન્ય એક્ઝિટ્સ તેને ડેમેજ કરતા નથી; માત્ર એવી લાઈનો જેમના બહાર નીકળવાનો સીધો માર્ગ ગાર્ડિયનના કેન્દ્રીય સેલ (Core Tile) માંથી આરપાર પસાર થાય, તે જ તેના HP માં 1 નો ઘટાડો કરી શકે છે. |
| Ants / Bees | બંને લેયર્સના ચોક્કસ માર્ગો કોરને હિટ કરી શકે છે. |
| Tall | `true` (fixed). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |


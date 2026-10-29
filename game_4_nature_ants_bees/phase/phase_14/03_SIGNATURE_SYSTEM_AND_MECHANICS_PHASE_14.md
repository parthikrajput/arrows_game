# 03 — Signature System & Mechanics, Phase 14 (M651–M654)
> Reflecting Pond (Mirror Worlds architecture), bilateral symmetry transforms, inverted kinetic vectors અને M651–M654 base mechanics cards.

**Related docs:** [Phase 14 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_14_SCOPE_AND_RULES.md)

---

## 1. Signature System: Reflecting Pond (Mirror Worlds)
- **Core Concept:** બગીચાના મધ્યમાં એક શાંત જળ-સપાટી (Pond Axis) પ્રતિબિંબ પાડે છે. ખેલાડી જ્યારે એક કીડી કે મધમાખીને ચલાવે છે, ત્યારે પાણીમાં તેનું પ્રતિબિંબ આપમેળે વિરુદ્ધ દિશામાં સમાંતર દોડે છે. પઝલનો ઉકેલ બંને બાજુના અવરોધોને સંતુલિત કરવામાં છે.
- **Bilateral Axis Transformation (M651):**
  - વર્ટિકલ મિરર અક્ષ $x = x_{\text{axis}}$ માટે:
    - મૂળ કોઓર્ડિનેટ્સ $(x, y)$ નો મિરર સેલ $(2x_{\text{axis}} - x, y)$ બને છે.
    - દિશા રૂપાંતરણ: $\text{Right} \leftrightarrow \text{Left}$, $\text{Up-Right} \leftrightarrow \text{Up-Left}$, $\text{Down-Right} \leftrightarrow \text{Down-Left}$.
  - બંને લાઈનો એકસાથે દોડે છે. જો બેમાંથી કોઈપણ એક લાઈન કોઈ પથ્થર કે અવરોધ સાથે અથડાય, તો બંને પાછી ફરે છે અને કુલ $-1$ Heart ગુમાવાય છે (single bonk penalty).
- **Reflection Key-Lock Dependency (M652):**
  - અક્ષની સામી બાજુ રહેલી કીડી જ્યારે એક્ઝિટ થાય ત્યારે જ આ બાજુનું કાંટાળું પ્રતિબિંબ તાળું ખુલે છે.
- **Inverted Kinetic Vectors (M654):**
  - Upside-Down Line નો દેખાવ સામાન્ય લાગે છે પરંતુ તેની આંતરિક વેગ દિશા અક્ષની સાપેક્ષે ઉલટી હોય છે.

---

## 2. Base Mechanics Cards (M651–M654)

### M651 — Pond Axis (Mirror Axis)
| Field | Value |
|---|---|
| ID | `M651` |
| Themed Name | **Pond Axis** (તળાવ અક્ષ) — Generic: Mirror Axis |
| Category | T / P — Bilateral Mirror Symmetry Axis |
| Intro Level | **L6511** (Block 2 x1) |
| Rule | બોર્ડની મધ્યમાં આવેલી પાણીની પાતળી વાદળી લાઈન જે સમગ્ર બોર્ડનું પ્રતિબિંબ પાડે છે. અક્ષની એક બાજુ રહેલી લાઈનને ટેપ કરતાં અક્ષની સામી બાજુ રહેલી તેની મિરર ટ્વિન લાઈન પણ એકસાથે ગતિ કરે છે. બંને લાઈનો સહીસલામત બહાર નીકળવી અનિવાર્ય છે. |
| Ants / Bees | કીડીઓ કીડી સાથે અને મધમાખીઓ મધમાખી સાથે મિરર થાય છે (સમાન લેયર). |
| Tall | N/A (બોર્ડ અક્ષ). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M652 — Reflection Lock (Reflect Lock)
| Field | Value |
|---|---|
| ID | `M652` |
| Themed Name | **Reflection Lock** (પ્રતિબિંબ લૉક) — Generic: Reflect Lock |
| Category | K / T — Mirrored Counterpart Lock |
| Intro Level | **L6631** (Block 14 x1) |
| Rule | જળ સપાટી સાથે જોડાયેલું સુંદર કાંટાળું તાળું. આ તાળું પોતાની બાજુની કોઈ ચાવીથી ખુલતું નથી; અક્ષની સામેની બાજુએ તેના પ્રતિબિંબ સ્થાન પર રહેલી કીડી જ્યારે બોર્ડ બહાર નીકળે છે, ત્યારે જ આ લૉક ઓગળી જાય છે. |
| Ants / Bees | બંધ હોય ત્યારે ગ્રાઉન્ડ કીડીઓને બ્લોક કરે છે; `tall: true` હોય તો બી લાઈનોને પણ બ્લોક કરે છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M653 — Twin Pond (Twin Board)
| Field | Value |
|---|---|
| ID | `M653` |
| Themed Name | **Twin Pond** (જોડિયા તળાવ) — Generic: Twin Board |
| Category | T / C — Synchronized Dual Pond Controller |
| Intro Level | **L6751** (Block 26 x1) |
| Rule | સ્ક્રીન પર બે સ્વતંત્ર તળાવ વિસ્તારો. પ્લેયર કોઈપણ એક તળાવમાં લાઈન ટેપ કરે ત્યારે બીજા તળાવમાં તે જ સ્થાન પર રહેલી લાઈન પણ ટેપ થાય છે. બંને તળાવોમાં એકપણ અથડામણ વગર લાઈનો બહાર નીકળવી જોઈએ. |
| Ants / Bees | તમામ લેયર્સ પર એકસાથે લાગુ પડે છે. |
| Tall | Global dual setup. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M654 — Upside-Down Line (Inverse Path)
| Field | Value |
|---|---|
| ID | `M654` |
| Themed Name | **Upside-Down Line** (ઉલટી લાઈન) — Generic: Inverse Path |
| Category | P — Inverted Direction Vector Line |
| Intro Level | **L6871** (Block 38 x1) |
| Rule | પાણીના પ્રતિબિંબથી ભ્રમિત થયેલી વિશિષ્ટ લાઈન. તેનું માથું જે દિશા દર્શાવતું હોય (દા.ત. Up), ટેપ કરતાં તે બરાબર તેની વિરુદ્ધ/મિરર દિશામાં (દા.ત. Down) દોડે છે. તેના શરીર પર હળવા પાણીના વમળો હોય છે જેથી પ્લેયર તેને ઓળખી શકે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ બંનેમાં આ ઇન્વર્સ વેરિઅન્ટ હોઈ શકે છે. |
| Tall | Line layer મુજબ. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |


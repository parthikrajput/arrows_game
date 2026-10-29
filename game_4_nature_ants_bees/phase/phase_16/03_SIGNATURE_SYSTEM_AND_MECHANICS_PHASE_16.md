# 03 — Signature System & Mechanics, Phase 16 (M751–M754)
> Royal Keyring (Keys Deluxe architecture), chained key states, half-key synthesis અને M751–M754 base mechanics cards.

**Related docs:** [Phase 16 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_16_SCOPE_AND_RULES.md)

---

## 1. Signature System: Royal Keyring (Keys Deluxe)
- **Core Concept:** કીડીઓ અને મધમાખીઓના સામ્રાજ્યમાં શાહી તાળાં-ચાવીઓનું સંકુલ નેટવર્ક. એક તાળું ખોલવાથી અન્ય લાઈનને નવી ચાવી મળે છે, બે અર્ધ-ચાવીઓ ભેગી થઈને સંયુક્ત રંગ બનાવે છે અને સ્કેલેટન ચાવીઓ આખી હરોળના તાળાઓ સાફ કરે છે.
- **Key-Chain State Machine (M751):**
  - લૉક $L_1$ તેની સાથે જોડાયેલી લાઈન $p_2$ નો સંદર્ભ ધરાવે છે.
  - જ્યારે કીડી $p_1$ બહાર નીકળીને $L_1$ ખોલે છે, ત્યારે લાઈન $p_2$ પર આપમેળે $L_2$ માટેની ચાવી પ્રગટ થાય છે.
- **Key Crafting Synthesis (M752):**
  - બોર્ડ પર બે અર્ધ-ચાવીઓ હોય છે (દા.ત. Red Half-Key અને Yellow Half-Key).
  - બંને કીડીઓ જ્યારે બોર્ડમાંથી બહાર નીકળી જાય છે, ત્યારે સેન્ટ્રલ ક્રાફ્ટિંગ ફ્લાવર પર બંને ચાવીઓ જોડાઈને Orange Key બને છે અને મેચિંગ નારંગી તાળું કાયમી ખુલી જાય છે.
- **Skeleton Cross-Ray Clearance (M753):**
  - સ્કેલેટન કીડી બોર્ડ બહાર નીકળતાં જ તેના પ્રારંભિક હેડ સેલ $(x_0, y_0)$ પરથી ચારેય દિશામાં સોનેરી તરંગો ફેલાય છે અને હરોળ $y_0$ તથા સ્તંભ $x_0$ ના તમામ તાળાઓ નાશ પામે છે.

---

## 2. Base Mechanics Cards (M751–M754)

### M751 — Dew Key Chain (Key Chain)
| Field | Value |
|---|---|
| ID | `M751` |
| Themed Name | **Dew Key Chain** (ઝાકળ-ચાવી શ્રૃંખલા) — Generic: Key Chain |
| Category | K — Progressive Chained Key Delivery |
| Intro Level | **L7511** (Block 2 x1) |
| Rule | બહુ-તબક્કાવાર ચાવી પ્રણાલી. જ્યારે પ્રથમ કી-લાઈન એક્ઝિટ થઈને લૉક 1 ખોલે છે, ત્યારે તે લૉકમાંથી મુક્ત થયેલું ચાવીનું આઇકન તેની સાથે લિંક્ડ બીજી લાઈન પર ટ્રાન્સફર થાય છે. તે બીજી લાઈન બહાર નીકળતાં જ લૉક 2 ખુલે છે. |
| Ants / Bees | કોઈપણ લેયરની કીડી કે મધમાખી આ ચેઇનનો ભાગ બની શકે છે. |
| Tall | Key layer મુજબ. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M752 — Key-Crafting Flower (Key Crafting)
| Field | Value |
|---|---|
| ID | `M752` |
| Themed Name | **Key-Crafting Flower** (ચાવી-ઘડતર ફૂલ) — Generic: Key Crafting |
| Category | K / T — Multi-Key Synthesis Node |
| Intro Level | **L7631** (Block 14 x1) |
| Rule | સુવર્ણ પાંખડીઓવાળું ચાવી-ઘડતર ફૂલ. બોર્ડ પર રહેલી બે અલગ-અલગ અર્ધ-ચાવીઓ (દા.ત. લાલ અને પીળી) ધરાવતી લાઈનો જ્યારે બંને સફળતાપૂર્વક બહાર નીકળી જાય છે, ત્યારે આ ફૂલ પર સંયુક્ત રંગની (નારંગી) સંપૂર્ણ ચાવી તૈયાર થાય છે અને જોડાયેલું મોટું તાળું ખુલે છે. |
| Ants / Bees | બંને અર્ધ-ચાવીઓ અલગ-અલગ લેયર્સ (કીડી અને મધમાખી) પાસે પણ હોઈ શકે છે. |
| Tall | Lock per tall. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M753 — Skeleton Dew Key (Skeleton Key)
| Field | Value |
|---|---|
| ID | `M753` |
| Themed Name | **Skeleton Dew Key** (માસ્ટર ઝાકળ ચાવી) — Generic: Skeleton Key |
| Category | K — Cross-Axis Multi-Lock Breaker |
| Intro Level | **L7751** (Block 26 x1) |
| Rule | સોનેરી ક્રાઉન પહેરેલી વિશિષ્ટ માસ્ટર કીડી. આ કીડી જ્યારે બોર્ડમાંથી બહાર નીકળી જાય છે, ત્યારે તેના પ્રારંભિક હેડ સેલની સમગ્ર હરોળ (row) અને સ્તંભ (column) માં રહેલા તમામ કાંટાળા તાળાઓ (Thorn Locks) એકસાથે ઓગળી જાય છે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ બંને સ્કેલેટન કી હોઈ શકે છે. |
| Tall | Key layer મુજબ. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M754 — Key Swap Pad (Key Swap)
| Field | Value |
|---|---|
| ID | `M754` |
| Themed Name | **Key Swap Pad** (ચાવી અદલાબદલી પેડ) — Generic: Key Swap |
| Category | C / K — Key Reallocation Controller |
| Intro Level | **L7871** (Block 38 x1) |
| Rule | જમીન પર આવેલું બે સોનેરી તીરવાળું કંટ્રોલ પેડ. પ્લેયર જ્યારે આ પેડ ટેપ કરે છે ($1$ Move વપરાય છે), ત્યારે તેની સાથે લિંક્ડ રહેલી બે લાઈનો વચ્ચે ચાવીઓની પરસ્પર અદલાબદલી (Key Swap) થઈ જાય છે, જેથી ફસાયેલી લાઈન મુક્ત થઈ શકે. |
| Ants / Bees | સમાન કે અલગ-અલગ લેયર્સની લાઈનો વચ્ચે પણ ચાવી બદલી શકાય છે. |
| Tall | Interactive controller. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |


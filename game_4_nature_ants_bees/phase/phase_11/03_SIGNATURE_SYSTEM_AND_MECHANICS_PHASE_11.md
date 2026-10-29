# 03 — Signature System & Mechanics, Phase 11 (M501–M504)
> Twin Gardens (Linked Boards architecture), cross-board boundary traversal, dual-viewport coordination અને M501–M504 base mechanics cards.

**Related docs:** [Phase 11 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_11_SCOPE_AND_RULES.md)

---

## 1. Signature System: Twin Gardens (Linked Boards)
- **Core Concept:** પઝલ હવે એક બોર્ડ પૂરતી સીમિત નથી. બોર્ડ A અને બોર્ડ B બાજુબાજુમાં સ્થિત છે અને વિવિધ લિંક્સ દ્વારા જોડાયેલા છે. લાઈનો એક બોર્ડમાંથી નીકળીને બીજા બોર્ડમાં પ્રવેશી શકે છે અથવા એક બોર્ડની ક્રિયા બીજા બોર્ડમાં ગેટ્સ ખોલે છે.
- **Cross-Board Link Rules (M501):**
  - બોર્ડ A ના લિંક્ડ એજ સેલ $(x_A, y_A)$ માંથી જ્યારે કોઈ લાઈન બહાર નીકળે છે:
    - તે તાત્કાલિક બોર્ડ B ના અનુરૂપ સેલ $(x_B, y_B)$ પર તે જ દિશામાં આગળ વધે છે.
    - જો બોર્ડ B નો તે સેલ અથવા તેની આગળની લેન બ્લોક હોય, તો લાઈન આગળ વધી શકતી નથી અને બોર્ડ A પર જ bonk થાય છે ($-1$ Heart).
- **Cross-Board Key Logic (M502):**
  - બોર્ડ A ની કી-લાઈન બોર્ડ B પરના ચોક્કસ તાળા સાથે લિંક્ડ હોય છે (`params.targetLock: "B_lock_1"`).
  - કી-લાઈન બોર્ડ A માંથી સફળતાપૂર્વક બહાર નીકળતાં જ બોર્ડ B પરનું તાળું કાયમી ઓગળી જાય છે.
- **Mirror Twin Across Boards (M503):**
  - બોર્ડ A ની લાઈન ટેપ કરવાથી બોર્ડ B ની ટ્વિન લાઈન પણ સમાન દિશા/રીફ્લેક્ટેડ દિશામાં આગળ વધે છે. જો બંનેમાંથી એક પણ લાઈન અથડાય તો $-1$ Heart થાય છે.

---

## 2. Base Mechanics Cards (M501–M504)

### M501 — Garden Gate Link (Board Link Edge)
| Field | Value |
|---|---|
| ID | `M501` |
| Themed Name | **Garden Gate Link** (બગીચા ગેટ લિંક) — Generic: Board Link Edge |
| Category | T / G — Inter-Board Boundary Portal |
| Intro Level | **L5011** (Block 2 x1) |
| Rule | બોર્ડ A અને બોર્ડ B ની સરહદ પરનો ખુલ્લો ગેટવે. બોર્ડ A માંથી આ ગેટ તરફ જતી લાઈન બોર્ડ B ના અનુરૂપ સેલ પર પ્રવેશીને ત્યાં આગળ વધે છે જ્યાં સુધી તે બોર્ડ B ના બાહ્ય એક્ઝિટ સુધી ન પહોંચે. |
| Ants / Bees | ગ્રાઉન્ડ કીડીઓ સરળતાથી પસાર થાય છે; `tall: true` હોય તો બી લાઈનો પણ બોર્ડ ક્રોસ કરે છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M502 — Pen-Pal Key (Cross-board Key)
| Field | Value |
|---|---|
| ID | `M502` |
| Themed Name | **Pen-Pal Key** (પેન-પાલ ચાવી) — Generic: Cross-board Key |
| Category | K — Remote Inter-Board Key |
| Intro Level | **L5131** (Block 14 x1) |
| Rule | બોર્ડ A પર રહેલી વિશિષ્ટ કીડી જેના માથા પર ગોલ્ડન ચાવીનું ચિહ્ન હોય છે. આ કીડી બોર્ડ A માંથી બહાર નીકળતાં જ બોર્ડ B પર રહેલું કાંટાળું તાળું (Pen-Pal Lock) ખુલી જાય છે, જેનાથી બોર્ડ B ના રસ્તાઓ સાફ થાય છે. |
| Ants / Bees | કોઈપણ લેયરની કીડી કે મધમાખી પેન-પાલ કી હોઈ શકે છે. |
| Tall | Key layer મુજબ. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M503 — Reflecting Pond Board (Mirror Board)
| Field | Value |
|---|---|
| ID | `M503` |
| Themed Name | **Reflecting Pond Board** (પ્રતિબિંબિત તળાવ બોર્ડ) — Generic: Mirror Board |
| Category | P / T — Inter-Board Synchronized Pair |
| Intro Level | **L5251** (Block 26 x1) |
| Rule | બોર્ડ A પરની લાઈન અને બોર્ડ B પરની સમાન રંગની લાઈન એકબીજા સાથે જાદુઈ રીતે જોડાયેલી હોય છે. પ્લેયર બોર્ડ A ની લાઈન ટેપ કરે ત્યારે બોર્ડ B ની લાઈન પણ આપમેળે દોડે છે. બંને લાઈનો એકસાથે સહીસલામત બહાર નીકળવી જોઈએ; જો કોઈ એક પણ લાઈન કોઈ અવરોધ સાથે અથડાય તો bonk ($-1$ Heart) થાય છે. |
| Ants / Bees | માત્ર સમાન લેયરની લાઈનો વચ્ચે જ મિરરિંગ થાય છે. |
| Tall | Line layer મુજબ. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M504 — Relay Burrow (Relay Portal)
| Field | Value |
|---|---|
| ID | `M504` |
| Themed Name | **Relay Burrow** (રિલે દર) — Generic: Relay Portal |
| Category | T — Cross-Board Subterranean Tunnel |
| Intro Level | **L5371** (Block 38 x1) |
| Rule | બોર્ડ A પરનો એક દર (burrow) અને બોર્ડ B પરનો બીજો દર એક અંડરગ્રાઉન્ડ ટનલ દ્વારા જોડાયેલા હોય છે. કીડી બોર્ડ A ના દરમાં પ્રવેશે છે અને તાત્કાલિક બોર્ડ B ના દરમાંથી બહાર આવીને આગળ વધે છે. |
| Ants / Bees | માત્ર જમીન પરની કીડીઓ (Ants only) આ ટનલનો ઉપયોગ કરી શકે છે (મધમાખીઓ દરમાં જઈ શકતી નથી). |
| Tall | `false` (fixed ground). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |


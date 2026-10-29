# 03 — Signature System & Mechanics, Phase 15 (M701–M704)
> Brook & Rails (Conveyors & Tracks architecture), water current drift vectors, ant-only transport અને M701–M704 base mechanics cards.

**Related docs:** [Phase 15 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_15_SCOPE_AND_RULES.md)

---

## 1. Signature System: Brook & Rails (Conveyors & Tracks)
- **Core Concept:** બગીચાના ઘાસની વચ્ચેથી વહેતા છીછરા પાણીના ઝરણાં (Brooks). કીડીઓ જ્યારે આ ઝરણાંની ટાઇલ્સ પર ઊભી હોય છે, ત્યારે પાણીનો પ્રવાહ તેમને દરેક Move પછી આપમેળે $1$ સેલ આગળ વહાવી જાય છે.
- **Drift Physics & Settlement Rules:**
  - દરેક Move પછી ઝરણાં પર રહેલી કીડી લાઈનો પ્રવાહની દિશામાં $1$ સેલ આગળ ખસે છે (Drift Step).
  - જો આગળનો સેલ બ્લોક હોય કે અન્ય લાઈન ઊભી હોય, તો કીડી ત્યાં જ અટકી જાય છે (પાણીમાં ડૂબતી કે bonk થતી નથી).
  - **Bees Exemption:** મધમાખીઓ જમીનથી ઉપર ઉડતી હોવાથી ઝરણાંના પ્રવાહથી સંપૂર્ણપણે મુક્ત રહે છે (No drift for Bees).
- **Branching & Sluice Gates (M701, M703):**
  - ફોર્ક પોઇન્ટ પર સ્લુઈસ ગેટનું સ્થાન નક્કી કરે છે કે કીડી કઈ શાખામાં જશે.
- **Tidal Current Reversals (M702):**
  - નિયમિત મૂવ અંતરાલ પર પાણીનો પ્રવાહ વિરુદ્ધ દિશામાં વહેવા લાગે છે.

---

## 2. Base Mechanics Cards (M701–M704)

### M701 — Brook Fork (Belt Junction)
| Field | Value |
|---|---|
| ID | `M701` |
| Themed Name | **Brook Fork** (ઝરણાં ફોર્ક) — Generic: Belt Junction |
| Category | T — Water Conveyor Branch Junction |
| Intro Level | **L7011** (Block 2 x1) |
| Rule | જ્યાં પાણીનો પ્રવાહ બે અલગ-અલગ શાખાઓમાં (ડાબે કે જમણે) વહેંચાય છે. જંક્શન પર રહેલી લાકડાની નાની પટ્ટી જે તરફ નમેલી હોય, તે તરફ વહેતી કીડી આગળ વધે છે. સ્લુઈસ લીવર (M703) થી આ દિશા બદલી શકાય છે. |
| Ants / Bees | માત્ર ગ્રાઉન્ડ કીડીઓ જ ફોર્કમાં વહે છે; મધમાખીઓ સીધી ઉડી જાય છે. |
| Tall | Ground conveyor. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M702 — Tide Brook (Reversible Belt)
| Field | Value |
|---|---|
| ID | `M702` |
| Themed Name | **Tide Brook** (ભરતી-ઓટ ઝરણું) — Generic: Reversible Belt |
| Category | T — Move-Periodic Reversing Current |
| Intro Level | **L7131** (Block 14 x1) |
| Rule | ગાર્ડન ટાઈડલ ઝરણું. દર $N$ Moves એ ($N = 3$ કે $4$) તેના પાણીના પ્રવાહની દિશા આપમેળે $180^\circ$ ઉલટી થઈ જાય છે (Forward $\leftrightarrow$ Backward). પ્લેયરે પ્રવાહ સાનુકૂળ હોય તે જ ટર્નમાં કીડીઓને આગળ વધારવી પડે છે. |
| Ants / Bees | માત્ર ગ્રાઉન્ડ કીડીઓ પર અસર કરે છે. |
| Tall | Ground conveyor. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M703 — Sluice Lever (Belt Lever)
| Field | Value |
|---|---|
| ID | `M703` |
| Themed Name | **Sluice Lever** (પાણીનું લીવર) — Generic: Belt Lever |
| Category | C / T — Flow Gate Controller |
| Intro Level | **L7251** (Block 26 x1) |
| Rule | લાકડાનો કંટ્રોલ વાલ્વ. પ્લેયર આ લીવર ટેપ કરે ત્યારે ($1$ Move વપરાય છે) ચોક્કસ ઝરણાંનો પ્રવાહ રોકાઈ જાય છે (સ્થિર પાણી) અથવા Brook Fork (M701) ની સ્વિચ ડાબી બાજુથી જમણી બાજુ પલટાય છે. |
| Ants / Bees | જળપ્રવાહનું નિયંત્રણ કરે છે. |
| Tall | Interactive controller. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M704 — Lazy River (Track Loop)
| Field | Value |
|---|---|
| ID | `M704` |
| Themed Name | **Lazy River** (આળસુ નદી) — Generic: Track Loop |
| Category | T — Closed Loop Water Carousel |
| Intro Level | **L7371** (Block 38 x1) |
| Rule | $3\times 3$ કે $4\times 4$ માપનો બંધ ગોળાકાર જળપ્રવાહ લૂપ. જે કીડી આ લૂપમાં પ્રવેશે છે, તે જ્યાં સુધી પ્લેયર તેને ટેપ કરીને બહાર ન કાઢે ત્યાં સુધી દર ટર્ને $1$ સેલ ક્લોકવાઇઝ ચક્કર લગાવ્યા કરે છે. કીડી જ્યારે એક્ઝિટ લેનની બરાબર સામે આવે ત્યારે જ તેને ટેપ કરીને બહાર કાઢી શકાય છે. |
| Ants / Bees | માત્ર ગ્રાઉન્ડ કીડીઓ લૂપમાં ફરે છે; મધમાખીઓ કોઈપણ વિક્ષેપ વગર ઉપરથી ઉડી જાય છે. |
| Tall | Ground loop. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |


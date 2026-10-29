# 03 — Signature System & Mechanics, Phase 4 (M151–M154)
> Garden Terraces (Multi-floor architecture), vertical raycasting, Floor Switcher UI અને M151–M154 base mechanics cards.

**Related docs:** [Phase 4 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_4_SCOPE_AND_RULES.md)

---

## 1. Signature System: Garden Terraces (Multi-Floor)
- **Concept:** બગીચો 2 થી 3 સમાંતર સ્તરો (Floors) માં વિસ્તરે છે. કીડીઓ અને મધમાખીઓ સીડીઓ (Stairs), છિદ્રો (Holes) અને લિફ્ટ (Lifts) દ્વારા સ્તરો વચ્ચે મુસાફરી કરે છે.
- **Floor Data Model:**
  - Level JSON માં optional `"floors": [{"id": 0, "name": "Lower Terrace"}, {"id": 1, "name": "Main Garden"}, {"id": 2, "name": "Upper Canopy"}]`.
  - દરેક path અને mechanic instance પાસે `"floor": int` પ્રોપર્ટી હોય છે.
- **Vertical Raycasting & Exit Lanes:**
  - જ્યારે કોઈ લાઈન stairs કે hole પર પહોંચે છે, ત્યારે તેનો exit ray આપોઆપ લક્ષ્ય ફ્લોર પર સમાન $(x, y)$ થી આગળ વધે છે.
  - જો લક્ષ્ય ફ્લોર પર તે સેલ બ્લોક થયેલો હોય, તો પ્રારંભિક લાઈન મૂળ સ્થાન પર જ "bonk" કરે છે (-1 Heart).
- **Floor Switcher & Camera:**
  - સ્ક્રીન એક સમયે એક ફ્લોર દર્શાવે છે.
  - ટેબ સ્વિચર દ્વારા પ્લેયર કોઈપણ ફ્લોર જોઈ શકે છે.
  - લાઈન exit થતાં જો તે અન્ય ફ્લોર પર જાય તો કૅમેરા સ્મૂથ વર્ટિકલ ટ્રાન્ઝિશન (250 ms) સાથે તેને ફોલો કરે છે.

---

## 2. Base Mechanics Cards (M151–M154)

### M151 — Root Stairs (Stairs)
| Field | Value |
|---|---|
| ID | `M151` |
| Themed Name | **Root Stairs** (વૃક્ષમૂળ સીડી) — Generic: Stairs |
| Category | D — Directional / Floor Transition |
| Intro Level | **L1511** (Block 2 x1) |
| Rule | સીડીમાં પ્રવેશતી લાઈન જોડાયેલા ફ્લોર પર સમાન $(x, y)$ કોઓર્ડિનેટ પરથી સમાન દિશામાં આગળ વધે છે. |
| Ants (Ground) | કીડીઓ સીડી ચઢી/ઊતરી શકે છે. |
| Bees (Air/Canopy)| માત્ર `tall: true` સીડી ("Updraft Stairs") મધમાખીઓને ઉપર લઈ જાય છે; સામાન્ય સીડી ઉપરથી ઉડી જાય છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| No. |

### M152 — Dew-Glass Terrace (Glass Floor)
| Field | Value |
|---|---|
| ID | `M152` |
| Themed Name | **Dew-Glass Terrace** (ઝાકળ-કાચ અગાસી) — Generic: Glass Floor |
| Category | B — Structural Blocker / Transparent Tile |
| Intro Level | **L1631** (Block 14 x1) |
| Rule | પારદર્શક ફ્લોર ટાઇલ. આ ટાઇલ પર પડેલી લાઈન નીચેના ફ્લોરના તે જ $(x, y)$ સેલની lane ને પણ block કરે છે (વર્ટિકલ શેડો બ્લોક). |
| Ants / Bees | પોતાના લેયરમાં નીચેના ફ્લોરને બ્લોક કરે છે. |
| Tall | N/A (Floor property). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M153 — Rabbit Hole (Drop Hole)
| Field | Value |
|---|---|
| ID | `M153` |
| Themed Name | **Rabbit Hole** (સસલાંનું દર / છિદ્ર) — Generic: Drop Hole |
| Category | D — Directional / Drop |
| Intro Level | **L1751** (Block 26 x1) |
| Rule | ગ્રાઉન્ડ લેવલનું છિદ્ર. તેમાં પ્રવેશતી લાઈન સીધી નીચેના ફ્લોર પર ડ્રોપ થાય છે અને ત્યાંથી આગળ વધે છે (1-way downward drop). |
| Ants (Ground) | કીડીઓ નીચેના ફ્લોર પર પડે છે. |
| Bees (Air/Canopy)| Bees છિદ્ર ઉપરથી કોઈપણ અસર વગર ઉડી જાય છે. |
| Tall | false (fixed). |
| Hammerable | No. |
| Non-Monotone (N)| No. |

### M154 — Acorn Lift (Elevator)
| Field | Value |
|---|---|
| ID | `M154` |
| Themed Name | **Acorn Lift** (કાંચકી લિફ્ટ) — Generic: Elevator |
| Category | T — Interactive Control / Vertical Lift |
| Intro Level | **L1871** (Block 38 x1) |
| Rule | ઇન્ટરેક્ટિવ લિફ્ટ સેલ. ટેપ કરવાથી (1 Move) લિફ્ટ પર રહેલી લાઈન ઉપલા કે નીચલા ફ્લોર પર ટ્રાન્સફર થાય છે (`params.targetFloor`). |
| Ants / Bees | બંને લેયર્સ લિફ્ટ વાપરી શકે છે. |
| Tall | false. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |


# 01 — Phase 4 Scope & Rule Additions
> Phase 4 (L1501–2000) માં લાગુ પડતા નિયમો: Great Tree Floors (Multi-floor up to 3 floors), Floor Switching vs Move rules, Vertical Connectivity (Stairs, Drop Holes, Lifts), Glass Floors, D band 60–76 અને Remote Config keys.

**Related docs:** [Phase 4 index](./README.md) · [Shared Core Standard §11, §12, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_1501_2000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_4.md)

---

## 1. Overview (શું બદલાતું નથી, શું ઉમેરાય છે)

### બદલાતું નથી:
- Core puzzle loop (Tap → slither, blocked → bonk, −1 Heart Berry).
- Turn-based nature (કોઈપણ પ્રકારનો સમય પ્રતિબંધ નહીં).
- 0-hearts solvable guarantee.
- Boosters (Hint, Shield, Hammer) અને free Tongue-Flick Preview.
- D-band: Fixed plateau **D 60–76** (standard §17.24).

### ઉમેરાય છે:
| # | Addition | વિગત | First Level |
|---|---|---|---|
| 1 | **Multi-Floor Architecture** | 3 stacked grids સુધી (F1 Ground, F2 Trunk, F3 Canopy) | L1501 |
| 2 | **Floor Viewing Gesture** | Floor Tabs ટેપ કરીને અન્ય માળ જોવો એ **Move નથી** (standard §1) | L1501 |
| 3 | **Base Mechanics M151–M154** | Root Stairs, Dewglass Floor, Knot Hole, Vine Lift | L1511, L1631, L1751, L1871 |
| 4 | **Inter-Floor Path Transitions** | સાપ એક માળેથી સીડી/હોલ/લિફ્ટ દ્વારા બીજા માળે પ્રવેશીને બહાર નીકળે છે | L1511 |
| 5 | **45 Multi-Floor Variants** | M151–M154 અને અગાઉના mechanics સાથેના variants | L1521 … L1981 |

---

## 2. Multi-Floor Navigation & Rules
### 2.1 Floor Viewing Rule (No Move)
- HUD પર Floor Tabs (`[F1]`, `[F2]`, `[F3]`) ઉપલબ્ધ હોય છે.
- કોઈપણ Floor Tab પર ટેપ કરવાથી કેમેરા તે ફ્લોર પર સ્વિચ થાય છે.
- **નિયમ:** ફ્લોર જોવું, ઝૂમ કરવું કે પાન કરવું એ ગેમપ્લે Move નથી. તેનાથી `moveCount` વધતો નથી, હાર્ટ જતું નથી કે કોઈ સ્ટેટ બદલાતી નથી.

### 2.2 Vertical Lane Continuity
- જ્યારે કોઈ સાપ એક ફ્લોર પરથી Root Stairs (M151) કે Knot Hole (M153) માં પ્રવેશે છે:
  - તેની લેન આપોઆપ લક્ષ્ય ફ્લોર (Target Floor) પર ચાલુ રહે છે.
  - કેમેરા આપોઆપ સાપની પાછળ ટાર્ગેટ ફ્લોર પર સરળતાથી સ્લાઇડ થાય છે (Smooth auto-pan).
  - જો ટાર્ગેટ ફ્લોર પર લેન બ્લોક હોય, તો સાપ અગાઉના ફ્લોર પર જ બોંક થઈને પાછો આવી જાય છે (−1 Heart).

---

## 3. Limits & Parameters
| Parameter | Value Range | નોંધ |
|---|---|---|
| Floors per Level | 2 – 3 floors | Level JSON schema v3 `floors: 2` |
| Grid Size per Floor | 12×12 – 14×14 | Pinch-zoom & pan સક્ષમ |
| Snake Paths ($P$) | 28 – 40 snakes | બધા માળ વચ્ચે વહેંચાયેલા |
| Max Obstacles ($O$) | 8 – 14 instances | માળ દીઠ 3–5 instances |
| Difficulty ($D$) Band | **60 – 76** | Plateau target |
| x9 Hard Target | ≈ 84 | High band × 1.1 |
| L2000 Finale Target | ≈ 91 | High band × 1.2 |

---

## 4. Remote Config Keys
```json
{
  "maxPhase": 4,
  "levelOverrides_p4": {},
  "multi_floor_transition_ms": 200,
  "p4_economy": {
    "gift_basket_coins": 300,
    "finale_chest_coins": 1000
  }
}
```

---

## 5. Open Decisions
- **OD-P4-02:** જો ઉપલા માળ પર લાંબો સાપ હોય અને તેની પૂંછડી નીચલા માળ પર અડધી હોય (Dewglass / Lift વખતે), તો તે ટાઈમે બંને માળ પર હાફ-શેડો દેખાડવો કે માત્ર સક્રિય માળ પર? (હાલ બંને માળ પર સબટલ સિલુએટ નક્કી છે).


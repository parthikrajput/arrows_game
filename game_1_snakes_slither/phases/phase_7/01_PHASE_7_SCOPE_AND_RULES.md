# 01 — Phase 7 Scope & Rule Additions
> Phase 7 (L3001–3500) માં લાગુ પડતા નિયમો: Whirlwind Valley (Rotation signature system), Sub-board Rotor 4×4, Partial Snake Lock Invariants, Tangled Rotation Guard, Shifting Borders, D band 60–76 અને Remote Config keys.

**Related docs:** [Phase 7 index](./README.md) · [Shared Core Standard §11, §12, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_3001_3500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_7.md)

---

## 1. Overview (શું બદલાતું નથી, શું ઉમેરાય છે)

### બદલાતું નથી:
- Core puzzle loop (Tap → slither, blocked → bonk, −1 Heart Berry).
- 0-hearts solvable guarantee (સોલ્વર તમામ રોટેશન સ્ટેટ્સ ચકાસે છે).
- Turn-based rules (કોઈ વાસ્તવિક સમય મર્યાદા નહીં).
- Boosters (Hint, Shield, Hammer) અને Free Tongue-Flick Preview.
- D-band: Fixed plateau **D 60–76** (standard §17.24).

### ઉમેરાય છે:
| # | Addition | વિગત | First Level |
|---|---|---|---|
| 1 | **Rotation Signature System** | 4×4 સબ-બોર્ડ રોટેશન, ફરતી કિનારીઓ અને દિશા પરિવર્તન | L3001 |
| 2 | **Base Mechanics M301–M304** | Island Spinner, Turning Hedges, Spinning Snake, Gear Lock | L3011, L3131, L3251, L3371 |
| 3 | **Partial Snake Lock Invariant** | 4×4 રોટર ક્ષેત્રમાં અડધો સાપ હોય તો રોટેશન લૉક રહે છે (સાપ કપાતો નથી) | L3011 |
| 4 | **Tangled Rotation Guard** | જો નવી દિશા સાપના પોતાના શરીર તરફ વળે, તો તે Tangled બને છે (Locked Tap) | L3251 |
| 5 | **Border Wall Shifting** | કિનારીની દિવાલો દરેક Move પછી ઘડિયાળ દિશામાં 1 સેલ આગળ ખસે છે | L3131 |

---

## 2. Rotation Invariants (standard §16.19, §17.39)
### 2.1 Sub-board Rotor (M301) Safety Rules
- રોટર એક $4 \times 4$ ચોરસ ક્ષેત્ર છે જેને સેન્ટ્રલ હેન્ડલ પર ટેપ કરીને 90° Clockwise ફેરવી શકાય છે (1 Move ખર્ચાય છે).
- **Partial Snake Rule:** જો કોઈ સાપનું શરીર $4 \times 4$ ક્ષેત્રની અંદર અને બહાર બંને તરફ વિસ્તરેલું હોય, તો રોટર ટેપ **Locked Tap** ગણાય છે. સાપ કપાતો કે તૂટતો નથી.
- જે સાપ સંપૂર્ણપણે $4 \times 4$ ની અંદર હોય તે રોટેશન સાથે 90° ફરી જાય છે (તેની દિશા `dir` પણ 90° CW ફરે છે).

### 2.2 Tangled Rotation Invariant (standard §17.39)
- જો કોઈ સાપની નવી `dir` તેના પોતાના જ શરીરના સેલ તરફ નિર્દેશિત થતી હોય, તો સાપ "Tangled" (ગૂંચવાયેલો) બને છે.
- Tangled સાપ પર ટેપ કરવાથી તે Locked Tap ગણાય છે (હાર્ટ જતું નથી, Move ગણાતો નથી). રોટર ફરી ફેરવતાં જ્યારે દિશા ખુલ્લી થાય ત્યારે જ તે મુક્ત થાય છે.

---

## 3. Limits & Parameters
| Parameter | Value Range | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સક્ષમ |
| Snake Paths ($P$) | 28 – 40 snakes | Reverse construction થી place થાય છે |
| Max Obstacles ($O$) | 8 – 14 instances | Rotors, spinning paths સહિત |
| Difficulty ($D$) Band | **60 – 76** | Plateau target |
| x9 Hard Target | ≈ 84 | High band × 1.1 |
| L3500 Finale Target | ≈ 91 | High band × 1.2 |

---

## 4. Remote Config Keys
```json
{
  "maxPhase": 7,
  "levelOverrides_p7": {},
  "rotor_anim_speed_ms": 250,
  "p7_economy": {
    "gift_basket_coins": 300,
    "finale_chest_coins": 1000
  }
}
```

---

## 5. Open Decisions
- **OD-P7-02:** Turning Hedges (M302) ના ફરતી વખતે બોર્ડની ચારેય ખૂણા પર દિવાલ સ્મૂધલી રાઉન્ડ કોર્નર વળાંક લે કે ઇન્સ્ટન્ટ સ્નેપ થાય? (હાલ 200 ms સ્મૂધ આર્ક સ્લાઇડ નક્કી છે).

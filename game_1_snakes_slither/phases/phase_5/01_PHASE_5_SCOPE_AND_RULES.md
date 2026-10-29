# 01 — Phase 5 Scope & Rule Additions
> Phase 5 (L2001–2500) માં લાગુ પડતા નિયમો: Coconut Grove Physics (Push Physics+ signature system), Coconut Pits & Terrain modification, Continuous Sliding, Crate Keys, Heavy Boulders, D band 60–76 અને Remote Config keys.

**Related docs:** [Phase 5 index](./README.md) · [Shared Core Standard §11, §12, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_2001_2500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_5.md)

---

## 1. Overview (શું બદલાતું નથી, શું ઉમેરાય છે)

### બદલાતું નથી:
- Turn-based puzzle rules (Tap → slither, blocked → bonk, −1 Heart Berry).
- 0-hearts solvable guarantee.
- Boosters (Hint, Shield, Hammer) અને Tongue-Flick Preview.
- D-band: Fixed plateau **D 60–76** (standard §17.24).

### ઉમેરાય છે:
| # | Addition | વિગત | First Level |
|---|---|---|---|
| 1 | **Push Physics+ Signature System** | નારિયેળ ધકેલવાના વિસ્તૃત ભૌતિક નિયમો (Inertia, Pit filling, Locks) | L2001 |
| 2 | **Base Mechanics M201–M204** | Coconut Pit, Dew-Slick Coconut, Key Coconut, Jackfruit Boulder | L2011, L2131, L2251, L2371 |
| 3 | **Dynamic Floor Modification** | ખાલી ખાડામાં નારિયેળ પડતાં તે સામાન્ય ફ્લોર બની જાય છે | L2011 |
| 4 | **Inertial Momentum (Sliding)** | Dew-Slick Coconut જ્યાં સુધી અવરોધ ન આવે ત્યાં સુધી લપસે છે | L2131 |
| 5 | **Push Resistance Logic** | ભારે બોલ્ડર્સ માટે ચોક્કસ શક્તિ (Giant Anaconda / Chained push) જરૂરી | L2371 |

---

## 2. Advanced Push Physics Rules (standard §17.3, §17.29)
### 2.1 Basic Push vs Bump
- સામાન્ય નારિયેળ (M053 Rolling Coconut) ને સાપનું માથું અડતાં જો નારિયેળની પાછળનો સેલ ખાલી હોય, તો નારિયેળ 1 સેલ આગળ ખસે છે અને સાપ આગળ વધે છે.
- જો નારિયેળની પાછળ દિવાલ, અન્ય સાપ કે અવરોધ હોય: સાપ નારિયેળ સાથે બોંક થાય છે (−1 Heart).

### 2.2 Board Edge Rule (standard §17.29)
- જો નારિયેળને **ખુલ્લી બોર્ડ એજ** (Open Edge) તરફ ધકેલવામાં આવે: નારિયેળ બોર્ડની બહાર પડીને અદૃશ્ય થઈ જાય છે અને સાપનો રસ્તો મુક્ત થાય છે.
- જો બોર્ડની કિનારે દિવાલ હોય (Walled Edge): તો તે બ્લોકર તરીકે વર્તે છે અને બોંક થાય છે.

---

## 3. Limits & Parameters
| Parameter | Value Range | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સક્ષમ |
| Snake Paths ($P$) | 28 – 40 snakes | Reverse construction થી place થાય છે |
| Max Obstacles ($O$) | 8 – 14 instances | Push blocks & pits સહિત |
| Difficulty ($D$) Band | **60 – 76** | Plateau target |
| x9 Hard Target | ≈ 84 | High band × 1.1 |
| L2500 Finale Target | ≈ 91 | High band × 1.2 |

---

## 4. Remote Config Keys
```json
{
  "maxPhase": 5,
  "levelOverrides_p5": {},
  "push_physics_inertia": 1.0,
  "p5_economy": {
    "gift_basket_coins": 300,
    "finale_chest_coins": 1000
  }
}
```

---

## 5. Open Decisions
- **OD-P5-02:** શું Jackfruit Boulder (M204) પર હેમર વાપરવાની મંજૂરી આપવી? (હાલ standard §16.18 મુજબ heavy obstacles NOT hammerable નક્કી છે).


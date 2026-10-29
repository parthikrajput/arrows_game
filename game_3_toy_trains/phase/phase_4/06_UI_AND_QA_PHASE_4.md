# 06 · UI & QA Phase 4 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 4 ના UI ઘટકો (Floor Tabs UI, 3D સ્તર સંક્રમણ), VFX, કેમેરા એનિમેશન, પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 4 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Floor Tabs Navigation
- **સ્થાન:** સ્ક્રીનની જમણી કિનારે ઊભી પટ્ટી પર લાકડાના બટનો: `F1` (Ground), `F2` (Mezzanine), `F3` (High Line).
- **વર્તણૂક:**
  - Tab બદલતાં કેમેરા 250 ms માં સ્મૂધ ઊર્ધ્વગામી/અધોગામી સ્લાઇડ થાય છે (`Curves.easeInOutCubic`).
  - સક્રિય ફ્લોર પિત્તળની બોર્ડર સાથે હાઇલાઇટ થાય છે.
  - ટેબ સ્વિચિંગ સંપૂર્ણપણે મફત છે (0 Moves, no heart lost).

### 1.2 Tutorial Cards
- **L1501:** Multi-Floor પરિચય ("Welcome to Multi-Floor Station! Tap floor tabs to inspect each level!").
- **L1511 (M151):** Station Stairs પરિચય ("Trains climb stairs to continue on the connected floor!").
- **L1631 (M152):** Glass Platform પરિચય ("Glass lets you see and tap trains on the floor below!").
- **L1751 (M153):** Goods Chute પરિચય ("Lanes into chutes drop trains to the yard below!").
- **L1871 (M154):** Goods Lift પરિચય ("Board the lift and tap to transport the train to another floor!").

---

## 2. Phase 4 Visual Effects (VFX)
- **Stair Transit VFX:** ટ્રેન સીડી પર ચડતાં તેનો સ્કેલ 1.0 -> 0.85 -> 1.0 થાય છે + નાનો વ્હીલ સ્પાર્કલ.
- **Glass Platform Reflection:** સપાટી પર પારદર્શક ગ્લાસ શાઇન (`BlendMode.plus` લાઈટ બેન્ડ).
- **Chute Drop VFX:** ટ્રેન નીચે પડતાં નાનો ડ્રોપ શેડો + નીચેના ફ્લોર પર ડસ્ટ પફ.
- **Lift Operation VFX:** લિફ્ટ પ્લેટફોર્મની આસપાસ હાઈડ્રોલિક સ્ટીમ પફ + ગિયર સ્પાર્કલ્સ.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 4)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P4-QA-01 | L1501–2000 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P4-QA-02 | Floor Tab Navigation | ફ્લોર બદલવાથી move count ન વધવો જોઈએ; બોર્ડ સ્ટેટ અકબંધ રહે. | Not run |
| P4-QA-03 | Stairs Vertical Collision | જો લક્ષ્ય ફ્લોરનો સેલ બ્લોક હોય તો બફર ક્લેક બમ્પ (−1 Heart) થાય. | Not run |
| P4-QA-04 | Glass Platform Transparency | નીચેના ફ્લોરની ટ્રેન સ્પષ્ટ દેખાય અને સીધી ટેપ કરીને રવાના કરી શકાય. | Not run |
| P4-QA-05 | Chute Relocation | ટ્રેન નીચેના ફ્લોર પર સફળતાપૂર્વક શિફ્ટ થાય અને આગલા ટેપ પર આગળ વધે. | Not run |
| P4-QA-06 | Lift Single-Move Shift | ટ્રેન સંપૂર્ણ લિફ્ટ પર હોય ત્યારે જ લિફ્ટ ઓપરેટ થાય (1 Move). | Not run |
| P4-QA-07 | 60 fps Multi-Floor Budget | 3 ફ્લોર વચ્ચે ઝડપી ટેબ સ્વિચિંગ દરમિયાન 0 jank અને 60 fps જળવાય. | Not run |
| P4-QA-08 | Remote Config Rollout | `maxPhase < 4` હોય ત્યારે L1501 લોક રહે; `4` થતાં જ અનલૉક થાય. | Not run |


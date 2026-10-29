# 06 · UI & QA Phase 18 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 18 ના UI ઘટકો (Cross-System Interlock Visualizers, Multi-Floor Day/Night Shading, Prism Beam Reticle), VFX (`cycle_prism_flare`, `hydraulic_lift`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 18 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Cross-System Synergy Visualizers
- **Multi-Floor Day/Night Shading:** દિવસ (Day Phase A) માં ઉપરના માળ પર સોનેરી સૂર્યપ્રકાશ અને નીચેના માળ પર હળવો પડછાયો પડે છે; રાત્રિ (Night Phase B) માં બંને માળ પર સિલ્વર બ્લુ મૂનલાઇટ ગ્લો ફેલાય છે.
- **Prism Chromatic Trajectory:** સિગ્નલ લેમ્પમાંથી નીકળતો બીમ પ્રિઝમ લેન્સમાંથી પસાર થતાં રંગીન સ્પેક્ટ્રમ લાઇન (RGB Split) સાથે સેન્સર ગેટ સુધી દોરાય છે.
- **Shunting Lift Height Indicator:** લિફ્ટ પ્લેટફોર્મની બાજુમાં વર્તમાન ફ્લોર બેજ (`Floor 1` / `Floor 2`) ચમકે છે.
- **Ice Chute Target Target Reticle:** નીચલા માળના કાર્ટ પીટ પર નાના એરોઝ સાથે ડ્રોપ ટાર્ગેટ હાઇલાઇટ થાય છે.

### 1.2 Tutorial Cards
- **L8511 (M851):** Day/Night Ticket Cart પરિચય ("Push this ticket cart through the cycle tunnel to adapt its key to the current timetable phase!").
- **L8631 (M852):** Station Floor Shunting Lift પરિચય ("Use the goods elevator to haul heavy shunting carts between station floor levels!").
- **L8751 (M853):** Prism Signal Sensor પરિચય ("Filter signal beams through coloured lenses to trigger matching drawbridge sensors!").
- **L8871 (M854):** Ice Cart Blackout Chute પરિચય ("Slide ice crates into goods chutes to plug cart pits on lower platform floors!").

---

## 2. Phase 18 Visual Effects (VFX)
- **Cycle Prism Flare:** ડે/નાઇટ ફ્લિપ સાથે પ્રિઝમમાંથી નીકળતો રંગીન સ્પેક્ટ્રમ ફ્લેશ (`BlendMode.plus`).
- **Hydraulic Lift Motion:** માલવાહક લિફ્ટ ચડતી/ઉતરતી વખતે વુડન સ્ટીમ હિસ અને હાઇડ્રોલિક પાર્ટિકલ્સ.
- **Chute Slide & Splash:** આઇસ કાર્ટ ચ્યુટમાંથી નીચે પડતાં લાકડાના ફ્લોર પર સ્નો/આઇસ ક્રંચ ઇફેક્ટ.
- **Drawbridge Magnet Clack:** સેન્સર બીમ મળતાં ડ્રોબ્રિજ નીચો થવાની સ્મૂધ મિકેનિકલ ઇફેક્ટ.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 18)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P18-QA-01 | L8501–9000 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P18-QA-02 | Day/Night Ticket Cart Sync | ટનલમાંથી નીકળતી કાર્ટ માત્ર સક્રિય સાયકલ ફેઝમાં જ બેરિયર ખોલે. | Not run |
| P18-QA-03 | Goods Lift Vertical Shunting | લિફ્ટ પર રહેલી કાર્ટ ફ્લોર બદલે ત્યારે તેના કોઓર્ડિનેટ્સ $(x, y, z)$ ચોક્કસ અપડેટ થાય. | Not run |
| P18-QA-04 | Prism Beam Bridge Activation | યોગ્ય રંગનો બીમ સેન્સર પર પડતાં જ ડ્રોબ્રિજ ઓપન થાય; બીમ તૂટતાં બ્રિજ બ્લોક થાય. | Not run |
| P18-QA-05 | Ice Chute Pit Filling | ચ્યુટમાંથી પડતો આઇસ બ્લોક નીચેના ફ્લોરના પીટને ભરીને પાટો સમતલ બનાવે. | Not run |
| P18-QA-06 | Max-2 Modifier Stacking | રિમિક્સ લેવલ્સમાં 2 મોડિફાયર્સ એકસાથે લાગુ થતાં કોઈ કન્ફ્લિક્ટ ન થાય. | Not run |
| P18-QA-07 | 60 fps Multi-Layer Lighting Budget | મલ્ટી-ફ્લોર અને બીમ રિસોલ્યુશન વખતે લો-ટાયર ડિવાઇસ પર 60 fps જળવાય. | Not run |
| P18-QA-08 | Remote Config Rollout | `maxPhase < 18` હોય ત્યારે L8501 લોક રહે; `18` થતાં જ અનલૉક થાય. | Not run |


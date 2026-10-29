# 06 · UI & QA Phase 12 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 12 ના UI ઘટકો (Gravity Compass HUD, Incline Arrows, Balloon Bobbing Indicator), VFX (`incline_tilt`, `crate_slide`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 12 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Gravity HUD & Incline Visualizers
- **Gravity Compass Widget:** સ્ક્રીનના ઉપરના ખૂણામાં વુડન હોકાયંત્ર પ્રદર્શિત થાય છે. જેવો ટિલ્ટ લીવર ફરે છે તેમ તેનો સોનેરી એરો ઢાળની નવી દિશા તરફ સ્મૂધ રોટેટ થાય છે.
- **Slope Arrow Overlays:** પાટા વચ્ચે આછી પર્વતીય ઢાળ રેખાઓ અને એરોઝ તરવરે છે, જે દર્શાવે છે કે કઈ દિશામાં લૂઝ વસ્તુઓ સરકશે.
- **Balloon Bobbing Animation:** Balloon Pad પર સ્થિર થયેલા ક્રેટ્સ હવામાં હળવેકથી ઉંચા-નીચા (bobbing) થાય છે, જે દર્શાવે છે કે તેઓ ગુરુત્વાકર્ષણ મુક્ત છે.
- **Ballast Momentum Spark:** ભારે બેલાસ્ટ ટ્રેનના આગળના વ્હીલ્સ પર નાના સ્પાર્ક્સ દેખાય છે જો તે આગળ વધવા માટે તૈયાર હોય.

### 1.2 Tutorial Cards
- **L5511 (M551):** Tilt Lever પરિચય ("Tap the tilt lever to rotate the board's gravity and incline! Watch which way things roll!").
- **L5631 (M552):** Loose Crates પરિચય ("Loose cargo crates slide down the slope on every move! Keep your tracks clear!").
- **L5751 (M553):** Balloon Pad પરિચય ("Crates that slide onto balloon pads float safely against gravity!").
- **L5871 (M554):** Ballast Train પરિચય ("This heavy ballast train rolls down the slope automatically if its track is open!").

---

## 2. Phase 12 Visual Effects (VFX)
- **Board Tilt VFX:** લીવર ટેપ કરતાં બોર્ડ સહેજ 3D એન્ગલ પર ટિલ્ટ થવાનો ભાસ + વુડન ક્રિક સાઉન્ડ.
- **Crate Slide Dust:** ક્રેટ્સ પાટા પર સરકતી વખતે તેમની પાછળ લાકડાની રજકણો અને ડસ્ટ પફ ઉડે છે.
- **Balloon Float Burst:** પેડ પર ક્રેટ આવતાં નાના રંગબેરંગી એન્ટિ-ગ્રેવ સ્પાર્કલ્સ અને ફુગ્ગા ગ્લો (`BlendMode.plus`).
- **Heavy Ballast Rumble:** બેલાસ્ટ ટ્રેન ઢાળ પર દોડતી વખતે સ્મોક પફ્સ અને સ્ક્રીન પર હળવું માઇક્રો-શેક.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 12)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P12-QA-01 | L5501–6000 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P12-QA-02 | Tilt Lever Direction Cycle | ટેપ કરતાં ઢાળ ચોક્કસપણે `D -> L -> U -> R` ક્રમમાં 90° ક્લોકવાઇઝ ફરે. | Not run |
| P12-QA-03 | Loose Crates Bottom-Up Sliding | સ્ટેકીંગ વખતે નીચેના ક્રેટ્સ પહેલાં સરકે; કોઈ ઓવરલેપિંગ કે ગ્લીચ ન થાય. | Not run |
| P12-QA-04 | Balloon Pad Zero Gravity | પેડ પર રહેલો ક્રેટ ગમે તે ઢાળમાં પણ સરકતો નથી જ્યાં સુધી પુશ ન થાય. | Not run |
| P12-QA-05 | Ballast Train Autonomous Roll | પાટો ખાલી અને સંરેખિત હોય ત્યારે જ બેલાસ્ટ ટ્રેન 1 સેલ આપોઆપ આગળ વધે. | Not run |
| P12-QA-06 | Multi-Modifier Stacking | સ્લાઇડિંગ ક્રેટ સાથે ફ્રોઝન કે આર્મ્ડ મોડિફાયરનું સુસંગત વર્તન. | Not run |
| P12-QA-07 | 60 fps Sliding Physics Budget | 10+ ક્રેટ્સ એકસાથે સરકતા હોય ત્યારે પણ લો-ટાયર ડિવાઇસ પર 60 fps જળવાય. | Not run |
| P12-QA-08 | Remote Config Rollout | `maxPhase < 12` હોય ત્યારે L5501 લોક રહે; `12` થતાં જ અનલૉક થાય. | Not run |

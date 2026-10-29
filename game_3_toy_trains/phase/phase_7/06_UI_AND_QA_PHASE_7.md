# 06 · UI & QA Phase 7 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 7 ના UI ઘટકો (Sub-board Rotor Matrix Canvas, Shifting Border Indicators), VFX (`rotate_swoosh`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 7 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Sub-board Rotation & Edge Visualizers
- **Rotor Matrix Canvas:** 4×4 રોટર સેલની આસપાસ ગોળાકાર પિત્તળની રીંગ અને કંપાસ માર્કર્સ. રોટેશન વખતે `canvas.rotate()` એનિમેશન 200 ms માં પૂર્ણ થાય છે (`Curves.easeInOutCubic`).
- **Shifting Exit Markers:** બોર્ડર પર ફરતા એક્ઝિટ ગેપ્સ આગળ નાના ગ્લોઇંગ એરોઝ હોય છે જે આગામી શિફ્ટની દિશા દર્શાવે છે.

### 1.2 Tutorial Cards
- **L3011 (M301):** Rotating Yard Block પરિચય ("Tap the central lever to rotate the entire 4×4 yard block!").
- **L3131 (M302):** Spinning Station Exits પરિચય ("Station exits shift clockwise every few moves! Time your departures!").
- **L3251 (M303):** Spinner Engine પરિચય ("This clockwork locomotive rotates 90° clockwise on every move!").
- **L3371 (M304):** Turntable Lock પરિચય ("Release the key train to unlock the roundhouse turntable!").

---

## 2. Phase 7 Visual Effects (VFX)
- **Sub-board Rotate Swoosh:** 4×4 બ્લોક ફરતાં ગોળાકાર વ્હીલ સ્પીડ-લાઇન્સ અને હળવો સ્ટીમ પફ.
- **Edge Shift Trail:** એક્ઝિટ ગેપ આગળ ખસતાં લાકડાની બોર્ડર પર ગોલ્ડન સ્પાર્ક શિફ્ટ.
- **Spinner Engine Rotation:** એન્જિન પોતાની જગ્યા પર ગોળ ફરતાં નાનો સ્ટીમ પફ + વ્હીલ ક્લિક.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 7)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P7-QA-01 | L3001–3500 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P7-QA-02 | Sub-board Boundary Invariant | આંશિક રીતે બહાર રહેલી ટ્રેન વખતે રોટર ટેપ locked tap થાય (બોર્ડ ન ફરે). | Not run |
| P7-QA-03 | Tangled Train Resolution | એન્જિન ડબ્બા તરફ ફરી જતાં ટ્રેન Tangled બને (0 heart loss, locked tap). | Not run |
| P7-QA-04 | Spinning Exit Collision | જો ટ્રેન બોર્ડર પર આવે અને ગેપ ન હોય તો બફર ક્લેક (−1 Heart) થાય. | Not run |
| P7-QA-05 | Spinner Engine Direction Shift| દરેક માન્ય મૂવ પછી સ્પિનર એન્જિન ચોક્કસ 90° CW દિશા બદલે. | Not run |
| P7-QA-06 | Turntable Lock Enforcement | કી ટ્રેન બહાર નીકળે તે પહેલાં રોટર ટેપ locked tap રહે. | Not run |
| P7-QA-07 | 60 fps Sub-board Rotation | 4×4 રોટર ફેરવતી વખતે લો-ટાયર ડિવાઇસ પર 0 jank અને 60 fps જળવાય. | Not run |
| P7-QA-08 | Remote Config Rollout | `maxPhase < 7` હોય ત્યારે L3001 લોક રહે; `7` થતાં જ અનલૉક થાય. | Not run |

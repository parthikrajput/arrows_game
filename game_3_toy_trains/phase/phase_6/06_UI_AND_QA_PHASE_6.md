# 06 · UI & QA Phase 6 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 6 ના UI ઘટકો (Beam Visualizer, Optical Sensor Indicators), VFX (`BlendMode.plus`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 6 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Optical Beam & Sensor Indicators
- **બીમ વિઝ્યુઅલ:** તેજસ્વી રંગીન કિરણો (Green, Red, Blue, Amber) જે ટ્રેક ઉપર `BlendMode.plus` મોડમાં ઝળહળે છે (કોઈ પ્રતિ-ફ્રેમ બ્લર નહીં).
- **સેન્સર સ્ટેટસ:** સેન્સર પર બીમ પડતાં નાનો ગ્લો પલ્સ અને ગોલ્ડન ઓપન આઇકન દેખાય છે. બીમ તૂટતાં લાલ ✕ આઇકન સાથે ગેટ બંધ થાય છે.

### 1.2 Tutorial Cards
- **L2501:** Signal Lights પરિચય ("Signal lamps emit beams of light! Connect them to sensors to open gates!").
- **L2511 (M251):** Coloured Lens પરિચય ("Lenses change the beam color! Match the color to activate matching sensors!").
- **L2631 (M252):** Twin Sensor Gate પરિચય ("Both sensors must be lit simultaneously for this gate to open!").
- **L2751 (M253):** Lamp Timer પરિચય ("This signal lamp toggles on and off every few moves!").
- **L2871 (M254):** Blackout Patch પરિચય ("Shine a light beam into dark tracks to reveal and unlock the trains!").

---

## 2. Phase 6 Visual Effects (VFX)
- **Continuous Beam Trail:** `CustomPainter` લાઇન `BlendMode.plus` સાથે, zero allocation per frame.
- **Sensor Flare:** બીમ સેન્સરને અડકતાં નાની ગોળ સ્પાર્ક રિંગ (`star_land` ક્લાસ).
- **Dark Cell Illumination:** અંધારા સેલ પર પ્રકાશ પડતાં સ્મૂધ આલ્ફા ફેડ (0.0 -> 1.0) અને ગોલ્ડન એમ્બિયન્ટ લાઇટ.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 6)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P6-QA-01 | L2501–3000 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P6-QA-02 | Train Beam Occlusion | ટ્રેન બીમમાંથી પસાર થતાં બીમ તૂટવો જોઈએ અને સેન્સર તરત ડી-એક્ટિવેટ થાય. | Not run |
| P6-QA-03 | Lens Color Filtering | લેન્સમાંથી નીકળતો બીમ માત્ર મેળ ખાતા રંગીન સેન્સરને જ એક્ટિવેટ કરે. | Not run |
| P6-QA-04 | Twin Sensor Concurrency | એક સેન્સર અનલિટ હોય તો ગેટ બંધ રહે (બમ્પ થાય, −1 Heart). | Not run |
| P6-QA-05 | Lamp Timer Tick Order | Step 3 માં ચોક્કસપણે ટાઈમર કાઉન્ટ થાય અને લેમ્પ સ્ટેટ સ્વેપ થાય. | Not run |
| P6-QA-06 | Dark Cell Unlock | બીમ પડતાં જ ડાર્ક સેલની ટ્રેન સક્રિય બને અને ટેપ સ્વીકારે. | Not run |
| P6-QA-07 | 60 fps Multi-Beam Budget | બોર્ડ પર 6 સક્રિય બીમ્સ હોવા છતાં લો-ટાયર ડિવાઇસ પર 60 fps જળવાય. | Not run |
| P6-QA-08 | Remote Config Rollout | `maxPhase < 6` હોય ત્યારે L2501 લોક રહે; `6` થતાં જ અનલૉક થાય. | Not run |

# 06 · UI & QA Phase 19 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 19 ના UI ઘટકો (Turntable Coupler Reticle, Gravity Spore Trails, Cross-Table Beat UI), VFX (`rotor_coupler_snap`, `spore_slide`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 19 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Mid-Era Cross-System Visualizers
- **Turntable Coupler Alignment Reticle:** રોટેટિંગ યાર્ડ પર જ્યારે મેગ્નેટિક પેડ્સ મુખ્ય ટ્રેક સાથે સંરેખિત (aligned) થાય છે, ત્યારે સોનેરી લોક રીંગ ચમકે છે જે દર્શાવે છે કે ટ્રેન હવે મર્જ થઈ શકે છે.
- **Gravity Spore Particle Trail:** ઢાળ પર સરકતી સીડ વેગનની પાછળ લીલી રેતી અને બીજની ટ્રેલ લાઇન અંકિત થાય છે.
- **Cross-Table Bridge Metronome Display:** Table A અને Table B વચ્ચેના બ્રિજ પર પેન્ડુલમ એનિમેશન ચાલે છે જે બંને ટેબલ પર એકસાથે ધબકે છે.
- **Dual Pruner Blade Indicators:** સ્પ્લિટ પ્રૂનર ટ્રેનની બંને બાજુ ફરતી ચમકતી બ્લેડ્સ દર્શાવવામાં આવે છે.

### 1.2 Tutorial Cards
- **L9011 (M901):** Turntable Coupling Pad પરિચય ("Rotate the turntable yard to align the magnetic pads before merging your trains!").
- **L9131 (M902):** Incline Seed Wagon પરિચય ("This heavy seed wagon rolls down gravity slopes, dropping delayed ivy seeds behind it!").
- **L9251 (M903):** Cross-Table Metronome Gate પરિચય ("The bridge between Table A and Table B opens and closes to a steady metronome rhythm!").
- **L9371 (M904):** Hedge-Trimming Split Train પરિચય ("Split this double train into parallel pruners that slice through wild ivy along both tracks!").

---

## 2. Phase 19 Visual Effects (VFX)
- **Rotor Coupler Snap:** યાર્ડ 90° રોટેટ થઈને સંરેખિત થતાં મેટાલિક લેચ સાઉન્ડ અને બ્લુ મેગ્નેટિક સ્પાર્ક (`BlendMode.plus`).
- **Incline Spore Slide:** સીડ વેગન ઢાળ પર સરકતી વખતે વ્હીલ ડસ્ટ અને નાના ગ્રીન સ્પોર વિસ્ફોટો.
- **Cross-Bridge Rhythm Pulse:** મેટ્રોનોમ "open" થતાં પુલ પર સોનેરી એરોઝ દોડે છે.
- **Dual Pruning Slash:** બંને સમાંતર ટ્રેનો પાટા પરથી પસાર થતાં બંને બાજુ પાંદડાં ખરવાની તેજસ્વી ઇફેક્ટ.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 19)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P19-QA-01 | L9001–9500 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P19-QA-02 | Turntable Coupler Alignment | યાર્ડ 90° સંરેખિત હોય ત્યારે જ કપલિંગ ટેપ માન્ય બને; અસંરેખિત વખતે બમ્પ થાય. | Not run |
| P19-QA-03 | Incline Seed Wagon Slide & Sprout | વેગન ગ્રેવિટી દિશામાં સરકે અને તેના છોડેલા બીજ N moves પછી જ વેલ બને. | Not run |
| P19-QA-04 | Cross-Table Metronome Enforce | મેટ્રોનોમ "closed" હોય ત્યારે Table A થી B માં પ્રવેશતી ટ્રેન બમ્પ થાય. | Not run |
| P19-QA-05 | Split Pruner Dual Cleaning | બંને વિભાજિત ટ્રેનો પોતાની સંલગ્ન વેલને સફળતાપૂર્વક કાપીને દૂર કરે. | Not run |
| P19-QA-06 | Max-2 Modifier Stacking | મિડ-એરા રિમિક્સમાં 2 મોડિફાયર્સનું સ્ટેકીંગ સ્ટેબલ રહે. | Not run |
| P19-QA-07 | 60 fps Dual Table Physics Budget | બંને ટેબલ્સ પર રોટેશન અને સ્લાઇડિંગ છતાં 60 fps જળવાય. | Not run |
| P19-QA-08 | Remote Config Rollout | `maxPhase < 19` હોય ત્યારે L9001 લોક રહે; `19` થતાં જ અનલૉક થાય. | Not run |


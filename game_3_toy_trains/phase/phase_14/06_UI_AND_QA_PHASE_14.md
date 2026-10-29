# 06 · UI & QA Phase 14 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 14 ના UI ઘટકો (Alpine Glacier Axis Line, Mirrored Twin Link, Reverse Arrow Indicator), VFX (`glacier_shimmer`, `mirror_spark`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 14 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Mirror Worlds & Alpine Axis Visualizers
- **Glacier Axis Divider:** બોર્ડની મધ્યમાં સ્ફટિક જેવી પારદર્શક આલ્પાઇન ગ્લેશિયર રેખા (Ice/Mirror Axis) પ્રદર્શિત થાય છે જે ડાબી અને જમણી બાજુના ક્ષેત્રને વિભાજિત કરે છે.
- **Twin Link Connection:** જ્યારે ખેલાડી કોઈ મિરર ટ્રેન પર હોવર કે ટેપ કરે છે, ત્યારે અક્ષની બંને બાજુની જોડિયા ટ્રેનો વચ્ચે સ્યાન (Cyan) રંગની સ્પાર્કિંગ ગ્લો લાઇન પ્રગટે છે.
- **Reverse Arrow HUD:** Reverse Engine (M654) પર પરંપરાગત એરોથી વિપરીત ઉલટો બ્લિંકિંગ એરો (<<<) છાપવામાં આવે છે જેથી ખેલાડીને તેની રિવર્સ પ્રકૃતિ સ્પષ્ટ થાય.
- **Reflection Lock Harmony Indicator:** જોડિયા ગ્લેશિયર લોક્સ પર બે અર્ધ-ચંદ્રાકાર પ્રતીકો હોય છે જે બંને બાજુ સંતુલિત થતાં સંપૂર્ણ વર્તુળ રચીને ખુલે છે.

### 1.2 Tutorial Cards
- **L6511 (M651):** Mirror Rail Axis પરિચય ("Tapping a train on one side moves its mirrored twin across the icy alpine pass! Both tracks must be clear!").
- **L6631 (M652):** Reflection Lock પરિચય ("These glacier gates only unlock when both sides of the mirror pass are opened together!").
- **L6751 (M653):** Alpine Twin Yard પરિચય ("Shunting in this mountain yard mirrors your moves across the pass! Plan symmetrically!").
- **L6871 (M654):** Reverse Engine પરિચય ("This alpine locomotive drives in the reverse direction of its painted arrow!").

---

## 2. Phase 14 Visual Effects (VFX)
- **Glacier Shimmer VFX:** કેન્દ્રીય અક્ષ પર બર્ફીલો સ્ફટિકિય ચમકારો અને હિમકણો (Frost Shards) તરવરે છે.
- **Mirror Sync Beam:** બંને જોડિયા ટ્રેનો જ્યારે એકસાથે મુવ થાય છે ત્યારે તેમની વચ્ચે આકાશી વાદળી લેસર સ્પાર્ક કનેક્શન રચાય છે (`BlendMode.plus`).
- **Reverse Thruster Puffs:** રિવર્સ એન્જિન વિરુદ્ધ દિશામાં ઉપડતાં આગળના ભાગમાંથી વધારાનો સફેદ સ્ટીમ પફ છૂટે છે.
- **Glacier Gate Shatter:** બંને બાજુઓ સંતુલિત થતાં બરફનો દરવાજો તૂટીને ખુલી જવાની સ્ફટિકિય ઇફેક્ટ.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 14)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P14-QA-01 | L6501–7000 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P14-QA-02 | Mirror Rail Axis Simultanous Move | એક બાજુની ટ્રેન ટેપ કરતાં બીજી ટ્વિન ટ્રેન સપ્રમાણ મિરર દિશામાં સાથે ચાલે. | Not run |
| P14-QA-03 | Dual Path Block Collision Check | જો બેમાંથી કોઈ પણ એક ટ્રેનનો પાથ બ્લોક હોય તો બંને અટકે અને બમ્પ થાય. | Not run |
| P14-QA-04 | Reflection Lock Synchronized Unlock | બંને બાજુના ટ્રિગર્સ સક્રિય થાય ત્યારે જ બેરિયર્સ ડાઉન થાય. | Not run |
| P14-QA-05 | Reverse Engine Direction Inversion | M654 ટ્રેન પોતાના એરોની બરાબર વિરુદ્ધ દિશામાં સફળતાપૂર્વક મુવ કરે. | Not run |
| P14-QA-06 | Multi-Modifier Stacking | મિરર ટ્રેન સાથે ફ્રોઝન કે આર્મ્ડ મોડિફાયરનું સુસંગત વર્તન. | Not run |
| P14-QA-07 | 60 fps Symmetrical Render Budget | મિરર અક્ષ અને બંને બાજુના 45+ ટ્રેક સેલ્સ વખતે લો-ટાયર ડિવાઇસ પર 60 fps જળવાય. | Not run |
| P14-QA-08 | Remote Config Rollout | `maxPhase < 14` હોય ત્યારે L6501 લોક રહે; `14` થતાં જ અનલૉક થાય. | Not run |

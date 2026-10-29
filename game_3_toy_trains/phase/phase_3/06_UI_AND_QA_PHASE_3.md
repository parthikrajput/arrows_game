# 06 · UI & QA Phase 3 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 3 ના નવા UI ઘટકો (Day & Night Sun/Moon Dial HUD, ટ્યુટોરિયલ કાર્ડ્સ), VFX એકીકરણ, પર્ફોર્મન્સ બજેટ, CI સીડ વેરિફિકેશન અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 3 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Sun/Moon Timetable Dial HUD
- **સ્થાન:** ગેમપ્લે સ્ક્રીન પર ટોપ HUD સેન્ટરમાં મૂવ કાઉન્ટરની બાજુમાં.
- **વિઝ્યુઅલ:** પિત્તળની ગોળાકાર ડાયલ જે અડધી સૂર્ય (Day Service) અને અડધી ચંદ્ર (Night Service) દર્શાવે છે.
- **એનિમેશન:** દરેક Move પર ડાયલ 72 ડિગ્રી રોટેટ થાય છે (5 Moves = 360 ડિગ્રી પૂર્ણ ચક્ર). 5મા મૂવ પર સોફ્ટ ચાઇમ સાથે ડાયલ પલટાય છે અને બોર્ડ પર એમ્બર લાઈટ સ્પ્રેડ થાય છે.

### 1.2 Tutorial Cards
- **L1001:** Day & Night Timetable પરિચય ("The railway timetable flips between Day & Night every 5 moves!").
- **L1011 (M101):** Day/Night Gate પરિચય ("This gate opens only during Day Service!").
- **L1131 (M102):** Day/Night Overpass પરિચય ("The overpass lowers at night, blocking lower tracks!").
- **L1251 (M103):** Day/Night Tunnel પરિચય ("Tunnels close their doors during Night Service!").
- **L1371 (M104):** Day/Night Livery પરિચય ("This locomotive swaps livery colors on every timetable change!").

---

## 2. Phase 3 Visual Effects (VFX)
- **Day/Night Flip Transition:** બોર્ડના honey-oak કલર પર 450 ms નો સ્મૂધ `Color.lerp` લાઈટિંગ સ્વીપ (Day: soft bright daylight; Night: warm lantern amber).
- **M101 Gate Flip:** દરવાજાનો પિત્તળનો આર્મ 0° થી 90° વચ્ચે ખુલે/બંધ થાય છે + ગોલ્ડન સ્પાર્ક રિંગ.
- **M102 Overpass Drop:** ઓવરપાસનો ડેક નીચે બેસીને ટ્રેક સાથે સ્ક્વોશ થાય છે + લાકડાની રજકણો (wood splinter particles).
- **M103 Tunnel Portal:** સુરંગના મુખ પર લોખંડનું શટર નીચે પડે છે + ડસ્ટ પફ.
- **M104 Livery Swap:** એન્જિન અને ડબ્બાઓના રંગો 250 ms માં સ્વેપ થાય છે + ટ્વિંકલ સ્પાર્કલ બર્સ્ટ (`BlendMode.plus`).
- **Tier Limits:** Low: મહત્તમ 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. CI Validation & QA Checklist

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P3-QA-01 | L1001–1500 CI Solver Run | તમામ 500 લેવલ્સ 0 hearts અને 0 boosters સાથે 100% સોલ્વેબલ હોવા જોઈએ. | Not run |
| P3-QA-02 | Seed Metadata Verification | `phase_3_meta.bin` ફાઇલનું CRC32 ચેકસમ બિલ્ડ આર્ટીફેક્ટ સાથે મેચ થવું જોઈએ. | Not run |
| P3-QA-03 | Determinism Across Platforms | x64 Linux CI અને ARM64 Android પર એક જ સીડ સમાન લેવલ JSON આપે. | Not run |
| P3-QA-04 | Cycle State Machine Tick | દર 5મા Move ના Step 3 માં ચોક્કસપણે Day/Night સ્ટેટ ફ્લિપ થાય. | Not run |
| P3-QA-05 | M101–M103 Collision Invariants| બંધ અવસ્થામાં ટ્રેન અથડાતાં બફર ક્લેક (−1 Heart) થાય; ખુલ્લી અવસ્થામાં સરળતાથી બહાર નીકળે. | Not run |
| P3-QA-06 | M104 Color Swap Correctness | સ્ટેટ ફ્લિપ પછી M104 ટ્રેન ફક્ત તેના નવા સક્રિય રંગના ગેટ્સ સાથે જ ક્રિયાપ્રતિક્રિયા કરે. | Not run |
| P3-QA-07 | 60 fps Performance Budget | 14×14 ના મોટા બોર્ડ પર 40 ટ્રેનો અને સાયકલ ફ્લિપ દરમિયાન લો-ટાયર ડિવાઇસ પર 60 fps જળવાય. | Not run |
| P3-QA-08 | Remote Config Rollout Gate | `maxPhase < 3` હોય ત્યારે L1001 લોક રહે; `maxPhase = 3` થતાં જ અનલૉક થાય. | Not run |

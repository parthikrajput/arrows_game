# 06 · UI & QA Phase 8 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 8 ના UI ઘટકો (Ivy Spread Visualizer, Pruning Lane Cleanser, Bloom Indicator), VFX (`grow_burst`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 8 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Ivy Growth & Bloom Visualizers
- **Ivy Sprout Indicator:** વેલ જે સેલમાં ફેલાવાની હોય ત્યાં 1 Move પહેલાં નાની લીલી કળીનો સંકેત દેખાય છે જેથી ખેલાડી પ્લાન કરી શકે.
- **Bloom Gate Progress:** Flower Arch કમાન પર K પાંખડીઓવાળું ફૂલ હોય છે. જેમ જેમ વેલ અડે છે તેમ પાંખડીઓ ગોલ્ડન ગ્લો સાથે ખીલે છે.

### 1.2 Tutorial Cards
- **L3511 (M351):** Wild Ivy+ પરિચય ("Wild ivy spreads into two adjacent tracks every few moves! Clear it before it blocks your trains!").
- **L3631 (M352):** Hedge Trimmer Car પરિચય ("Send a train across the hedge trimmer to cut all ivy along its track!").
- **L3751 (M353):** Seed Wagon પરિચય ("This wagon drops a seed on departure that sprouts into ivy! Plan your route!").
- **L3871 (M354):** Flower Arch પરિચય ("Let ivy touch this arch to make its flowers bloom and open the gate!").

---

## 2. Phase 8 Visual Effects (VFX)
- **Ivy Spread VFX:** વેલ પાટા પર આગળ વધતાં નાના લીલાં પાંદડાં ખરવાનો એનિમેશન + ફોલિએજ સ્પ્રાઉટ.
- **Hedge Trimmer Slash:** ટ્રેન પસાર થતાં બંને બાજુ લીલાં પાંદડાંની રજકણો અને કટિંગ સ્પીડ-લાઇન્સ (`crack_shards`).
- **Seed Sprout Burst:** બીજ વાવતાં નાનો માટીનો પફ; ફૂટતી વખતે નાનો ગ્રીન સ્પ્રાઉટ બર્સ્ટ.
- **Flower Bloom Flare:** K વેલ અડકતાં કમાન પર ફૂલો ખીલીને તેજસ્વી સોનેરી પ્રકાશ ફેંકે છે (`BlendMode.plus`).
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 8)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P8-QA-01 | L3501–4000 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P8-QA-02 | Wild Ivy Double Spread | Step 3 માં ચોક્કસપણે `U -> R -> D -> L` ક્રમમાં મહત્તમ 2 સેલ્સમાં વેલ ફેલાય. | Not run |
| P8-QA-03 | Hedge Trimmer Pruning | ટ્રેન પસાર થતાં બંને બાજુની ઓર્થોગોનલ વેલ કટ થઈને સેલ ફ્લોર બની જાય. | Not run |
| P8-QA-04 | Seed Wagon Drop | ટ્રેન નીકળતાં છેલ્લા સેલ પર બીજ રહે અને N moves પછી જ અંકુરિત થાય. | Not run |
| P8-QA-05 | Flower Arch Bloom Trigger | K વેલ અડકતાં જ કમાન કાયમી ખુલે; K કરતાં ઓછી હોય તો બંધ રહે (બમ્પ). | Not run |
| P8-QA-06 | Track Crane Ivy Prune | ક્રેન દ્વારા વેલનો સિંગલ સેલ સફળતાપૂર્વક હટાવી શકાય. | Not run |
| P8-QA-07 | 60 fps Dense Foliage Budget| બોર્ડ પર 30+ વેલ સેલ્સ હોવા છતાં લો-ટાયર ડિવાઇસ પર 60 fps જળવાય. | Not run |
| P8-QA-08 | Remote Config Rollout | `maxPhase < 8` હોય ત્યારે L3501 લોક રહે; `8` થતાં જ અનલૉક થાય. | Not run |

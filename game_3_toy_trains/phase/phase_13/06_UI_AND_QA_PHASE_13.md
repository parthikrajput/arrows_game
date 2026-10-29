# 06 · UI & QA Phase 13 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 13 ના UI ઘટકો (Fog Particle Shroud, Route Peek True View, Lantern Halo), VFX (`fog_dissipate`, `mirage_shimmer`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 13 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Fog of War & Reveal Visualizers
- **Dynamic Fog Shroud:** ધુમ્મસિયા સેલ્સ પર સફેદ-ગ્રે સ્ટીમ પાર્ટીકલ્સનું સ્મૂધ લેયર તરવરે છે, જેના કારણે નીચેના પાટા અને ટ્રેનો અર્ધ-પારદર્શક બને છે.
- **Route Peek True View:** ટ્રેન પર લોન્ગ પ્રેસ કરતાં, રૂટ પીક ધુમ્મસની આરપાર સાચો માર્ગ (ગ્રીન લાઇન) દર્શાવે છે અને મિરાજ ટ્રેનોને 'X' માર્ક સાથે ઓળખી બતાવે છે.
- **Lantern Light Radius:** Lantern Plate પર ટ્રેન ઉભી રહેતાં જમીન પર ગોળ પીળો પ્રકાશ (Radial Halo) પ્રસરે છે જે ધુમ્મસને કિનારે ધકેલી દે છે.
- **Scout Trail Glow:** સ્કાઉટ ટ્રેનની પાછળ સ્પાર્કલિંગ લીલી ટ્રેલ લાઇન અંકિત થાય છે.

### 1.2 Tutorial Cards
- **L6011 (M601):** Scout Draisine પરિચય ("Clear this scout handcart to permanently disperse the fog along its entire track!").
- **L6131 (M602):** Mirage Steam પરિચય ("Don't be fooled by ghostly train silhouettes in the fog! Use Route Peek to spot illusions!").
- **L6251 (M603):** Painted Backdrop પરિચય ("This wooden fence is just a painted illusion! Your trains can pass right through it!").
- **L6371 (M604):** Lantern Plate પરિચય ("Park a train on the lantern switch to illuminate and clear the fog in a wide circle!").

---

## 2. Phase 13 Visual Effects (VFX)
- **Fog Dissipate VFX:** સ્કાઉટ ટ્રેન પસાર થતાં ધુમ્મસ સફેદ વાદળિયા પફ્સ સાથે વિખેરાઈ જવાની ઇફેક્ટ.
- **Mirage Shimmer:** મિરાજ ટ્રેન પર હળવું મોજા જેવું ગરમીનું વિકૃતિ (Heat Haze Distortion) એનિમેશન.
- **Backdrop Dissolve:** ટ્રેન વાડમાંથી પસાર થતાં લાકડાની પેઇન્ટ પ્લેટ્સ પારદર્શક થઈ ફેડ-ઇન/આઉટ થાય છે.
- **Lantern Glow Halo:** લેન્ટર્ન પ્લેટ પર પગ મુકતાં સોનેરી પ્રકાશનો વર્તુળાકાર ફ્લેર (`BlendMode.plus`).
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 13)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P13-QA-01 | L6001–6500 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P13-QA-02 | Scout Draisine Reveal | સ્કાઉટ એક્ઝિટ થતાં જ લેનના 1-સેલ વિસ્તારનું ધુમ્મસ કાયમી દૂર થાય. | Not run |
| P13-QA-03 | Mirage Steam Illusions | મિરાજ ટ્રેન પર ટેપ કરવાથી બમ્પ ન થાય; વાસ્તવિક ટ્રેન તેના સેલમાંથી આરપાર નીકળે. | Not run |
| P13-QA-04 | Painted Backdrop Permeability | ફોલ્સ વોલમાંથી ટ્રેન વગર અવરોધે પસાર થાય; Route Peek ગ્રીન પાથ દર્શાવે. | Not run |
| P13-QA-05 | Lantern Plate Radius | ટ્રેન પ્લેટ પર હોય ત્યારે રેડિયસ 2 નું ધુમ્મસ હટે; ટ્રેન ખસતાં ધુમ્મસ પાછું ફરે. | Not run |
| P13-QA-06 | Route Peek Decoy Clarity | લોન્ગ પ્રેસ રૂટ પીક મિરાજ અને વાસ્તવિક ટ્રેન વચ્ચે સ્પષ્ટ તફાવત દર્શાવે. | Not run |
| P13-QA-07 | 60 fps Fog Particle Budget | બોર્ડ પર 40+ ધુમ્મસિયા સેલ્સ હોવા છતાં લો-ટાયર ડિવાઇસ પર 60 fps જળવાય. | Not run |
| P13-QA-08 | Remote Config Rollout | `maxPhase < 13` હોય ત્યારે L6001 લોક રહે; `13` થતાં જ અનલૉક થાય. | Not run |

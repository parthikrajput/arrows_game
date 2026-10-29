# 06 · UI & QA Phase 9 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 9 ના UI ઘટકો (Coupling Pad Highlights, Split Train Visualizers, Rejoin Counter), VFX (`magnetic_snap`, `steam_split`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 9 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Coupling & Split Visualizers
- **Coupling Ready Indicator:** જ્યારે બંને ટ્રેનોના મુખ Coupling Pads પર આવે છે, ત્યારે પેડ્સ વચ્ચે મેગ્નેટિક બ્લુ ગ્લો અને સ્પાર્ક લાઇન દેખાય છે, જે સૂચવે છે કે ટેપ કરવાથી જોડાણ થશે.
- **Split Ghost Trail:** Twin Split Train પર ટેપ કરતાં પહેલાં, બંને ટ્રેનો કયા પાટા પર સ્પ્લિટ થશે તેનો પારદર્શક (ghost) પ્રિવ્યૂ પાટા પર પ્રદર્શિત થાય છે.
- **Rejoin Arch Badge:** Rejoin Arch પર `1/2` અથવા `2/2` નું કાઉન્ટર બેજ દેખાય છે, જેથી પ્લેયરને ખ્યાલ આવે કે કેટલી ટ્વિન ટ્રેન પસાર થઈ છે.

### 1.2 Tutorial Cards
- **L4011 (M401):** Coupling Pad પરિચય ("Park both locomotive heads on the magnetic pads and tap to merge them into one long train!").
- **L4131 (M402):** Twin Split Train પરિચય ("Tap this double locomotive to split it into two parallel trains heading down separate tracks!").
- **L4251 (M403):** Coupling Lock પરિચય ("This uncoupled car segment is locked until its key train exits the board!").
- **L4371 (M404):** Rejoin Arch પરિચય ("Both halves of the split train must pass through this arch to unlock it permanently!").

---

## 2. Phase 9 Visual Effects (VFX)
- **Magnetic Snap VFX:** ટ્રેનો જોડાતી વખતે મેટાલિક 'ક્લેન્ક' સાઉન્ડ સાથે બ્લુ/સિલ્વર મેગ્નેટિક પાર્ટિકલ સ્નેપ (`BlendMode.plus`).
- **Steam Split Burst:** ટ્વિન ટ્રેન છૂટી પડતી વખતે મધ્યમાંથી સફેદ સ્ટીમ પફ અને સ્પ્લિટ પાર્ટીકલ્સ છૂટા પડે છે.
- **Segment Lock Key Burst:** કી-ટ્રેન નીકળતાં લોક પર સોનેરી ચાવીનો ફ્લેશ અને સાંકળ તૂટવાનો એનિમેશન.
- **Rejoin Gate Flare:** બંને ભાગો પસાર થયા પછી કમાન સોનેરી રોશની સાથે ખુલે છે.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 9)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P9-QA-01 | L4001–4500 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P9-QA-02 | Coupling Pad Merge Check | બંને ટ્રેનો પેડ પર હોય ત્યારે જ 1 Move માં જોડાઈને સિંગલ બોડી બને. | Not run |
| P9-QA-03 | Twin Split Parallel Check | સ્પ્લિટ પછી બંને ટ્રેનો સમાન દિશામાં મુખ રાખી અલગથી ટેપ કરી શકાય. | Not run |
| P9-QA-04 | Coupling Lock Security | કી-ટ્રેન એક્ઝિટ ન થાય ત્યાં સુધી સેગમેન્ટ લોક રહે (અમાન્ય ટેપ બમ્પ). | Not run |
| P9-QA-05 | Rejoin Arch Twin Pass | બંને વિભાજિત ટ્રેનો પસાર થતાં જ કમાન કાયમી અનલોક થાય; અન્ય ટ્રેન માટે બ્લોક રહે. | Not run |
| P9-QA-06 | Long Merged Train Collision | મર્જ થયા પછી લંબાઈ વધતાં ટેલ-કોલિઝન ચેક્સ ચોક્કસ રીતે કામ કરે. | Not run |
| P9-QA-07 | 60 fps Coupling Animation | સ્પ્લિટ અને મર્જના એનિમેશન દરમિયાન 60 fps જળવાય. | Not run |
| P9-QA-08 | Remote Config Rollout | `maxPhase < 9` હોય ત્યારે L4001 લોક રહે; `9` થતાં જ અનલૉક થાય. | Not run |

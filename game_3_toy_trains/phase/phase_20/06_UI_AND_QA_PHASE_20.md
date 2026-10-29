# 06 · UI & QA Phase 20 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 20 ના UI ઘટકો (Marching Clock Tower Boss UI, Omni-System HUD, Grand Master Celebration Screen), VFX (`boss_shockwave`, `grand_confetti`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 20 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 L10000 Marching Boss & Omni-System Visualizers
- **Marching Boss Threat Path:** $3\times 3$ Marching Clock Tower આગામી 5 મૂવ્સમાં કયા પાટા પર આગળ વધશે તે દર્શાવતો લાલ ડેન્જર ઝોન ઓવરલે (Red Ground Hazard Grid) પ્રદર્શિત થાય છે.
- **Boss HP Gauge & Clock Gear:** બોસની ઉપર સોનેરી ફ્રેમમાં 12-HP ગોળાકાર ક્લોક ડાયલ હોય છે. દરેક ડેમેજ પર ઘડિયાળનો કાંટો ફરતાં ટાવરમાં તિરાડો પ્રગટે છે.
- **Omni-System Dynamic HUD:** સ્ક્રીનની ઉપર એકીસાથે ડે/નાઇટ સાયકલ મીટર, ગ્રેવિટી હોકાયંત્ર અને ટિકિટ ઇન્વેન્ટરી આઇકોન્સ અત્યંત સુંદર રીતે ગોઠવાયેલા રહે છે.
- **Grand Master Crown Screen:** લેવલ 10,000 પૂર્ણ થતાં સંપૂર્ણ સ્ક્રીન પર સોનેરી કન્ફેટી, લાઇવ ટ્રેન હોર્ન સેલિબ્રેશન અને "Grand Master of 10,000 Tracks" નો વિજયી તાજ ચમકે છે.

### 1.2 Tutorial Cards
- **L9511 (M951):** Clockwork Conveyor Guardian પરિચય ("Clear trains through the revolving conveyor ring to weaken the guardian tower at its center!").
- **L9631 (M952):** Gravity Mirror Relay પરિચય ("The tilt lever inverts gravity in opposite directions across the mirrored twin tables!").
- **L9751 (M953):** Day/Night Ticket Master Pass પરિચય ("This master train holds standard keys by day, but transforms into an all-unlocking skeleton key at night!").
- **L9871 (M954):** Prism Bloom Arch પરિચય ("Touch this arch with wild ivy and align a filtered light beam to bloom its flowers and open the way!").

---

## 2. Phase 20 Visual Effects (VFX)
- **Marching Boss Shockwave:** દર 5 મૂવે બોસ ટાવર આગળ ડગલું ભરતાં જમીન ધ્રૂજી ઉઠે છે (Screen Shake) અને લાકડાના પાટા કચડાવાનો ક્રંચ સાઉન્ડ આવે છે.
- **Prism Bloom Flare:** પ્રિઝમમાંથી નીકળતો બીમ વેલને અડતાં કમાન પર હજારો સોનેરી અને ગુલાબી પાંખડીઓનો ફ્લેર બર્સ્ટ (`BlendMode.plus`).
- **Supreme Skeleton Unlock:** નાઇટ ફેઝમાં માસ્ટર પાસ બેરિયર ખોલતાં સોનેરી લેસર બર્સ્ટ.
- **Grand Finale 10,000 Fireworks:** L10000 પૂર્ણ થતાં આકાશમાં રંગબેરંગી ફટાકડા, ટ્રેન વ્હિસલ્સ અને ગોલ્ડન પાર્ટીકલ્સનો ભવ્ય વરસાદ.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 20)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P20-QA-01 | L9501–10000 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P20-QA-02 | L10000 Boss Marching Logic | દર 5 મૂવે બોસ ૧ સેલ આગળ વધે; નીચે આવતી ટ્રેન ક્રશ ન થાય તેની સોલ્વેબિલિટી ચકાસવી. | Not run |
| P20-QA-03 | Clockwork Conveyor Damage | કન્વેયર રીંગમાંથી ટ્રેન એક્ઝિટ થતાં જ ટાવરનું HP ચોક્કસ ૧ પોઇન્ટ ઘટે. | Not run |
| P20-QA-04 | Gravity Mirror Dual Incline | ટિલ્ટ લીવર Table A અને Table B પર વિરુદ્ધ દિશાઓમાં ગ્રેવિટી લાગુ કરે. | Not run |
| P20-QA-05 | Night Skeleton Pass Power | નાઇટ ફેઝમાં માસ્ટર પાસ કોઈપણ બેરિયરને ખોલે; ડે ફેઝમાં માત્ર સામાન્ય ગેટ ખુલે. | Not run |
| P20-QA-06 | Prism Bloom Dual Requirement | K વેલ + લાઇટ બીમ બંને એકસાથે હાજર હોય ત્યારે જ આર્ચ કાયમી અનલોક થાય. | Not run |
| P20-QA-07 | 60 fps 14×14 Ultimate Board | 56 ટ્રેનો, બોસ ટાવર અને કન્વેયર્સ છતાં લો-ટાયર ડિવાઇસ પર 60 fps જળવાય. | Not run |
| P20-QA-08 | Remote Config Rollout | `maxPhase = 20` સેટ થતાં સમગ્ર 10,000 લેવલ્સ અનલૉક થાય; ફિનાલે ટ્રોફી સાચી એવોર્ડ થાય. | Not run |


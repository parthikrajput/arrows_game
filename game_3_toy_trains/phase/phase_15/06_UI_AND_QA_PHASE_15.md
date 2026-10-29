# 06 · UI & QA Phase 15 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 15 ના UI ઘટકો (Conveyor Tread Flow, Belt Switch Chevrons, Loop Rotation Display), VFX (`belt_roll`, `motor_reverse`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 15 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Motorized Conveyor Visualizers
- **Conveyor Tread Shader:** કન્વેયર બેલ્ટ સેલ્સ પર સતત ગતિશીલ રોલર્સ અને વુડન સ્લેટ્સનું લૂપિંગ એનિમેશન ચાલે છે જે પ્રવાહની ઝડપ અને દિશા દર્શાવે છે.
- **Direction Flow Chevrons:** બેલ્ટની ઉપર નાના પ્રકાશિત એરોઝ (>>>>>) દોડે છે. જ્યારે દિશા ઉલટાય છે ત્યારે એરોઝ સ્મૂધલી ૧૮૦ ડિગ્રી ફરી જાય છે.
- **Belt Switch Branch Indicator:** Belt Switch (M701) પર સક્રિય શાખા ગ્રીન સિગ્નલ સાથે ગ્લો થાય છે, જ્યારે નિષ્ક્રિય શાખા પર લાલ બેરિયર દેખાય છે.
- **Loop Exit Pilot Light:** Loop Belt (M704) માંથી બહાર નીકળતી એક્ઝિટ લેન પર ટ્રેનનું મુખ આવે ત્યારે નાનો પાયલોટ લાઇટ બ્લિંક થાય છે.

### 1.2 Tutorial Cards
- **L7011 (M701):** Belt Switch પરિચય ("Tap this junction to switch the conveyor belt flow between the left and right branch tracks!").
- **L7131 (M702):** Reversing Belt પરિચય ("Pull the reversing lever to instantly invert the conveyor belt's travel direction!").
- **L7251 (M703):** Belt Stop Lever પરિચય ("Use the brake lever to pause and resume linked motorized conveyor belts!").
- **L7371 (M704):** Loop Belt પરિચય ("Trains circle this closed loop track automatically until you tap them toward an exit!").

---

## 2. Phase 15 Visual Effects (VFX)
- **Tread Rolling Motion:** બેલ્ટ ચાલુ હોય ત્યારે નાના રોલિંગ વ્હીલ્સ અને વુડન ફ્રિક્શન પાર્ટિકલ્સ.
- **Motor Reverse Sparks:** રિવર્સિંગ લીવર ખેંચતાં કન્વેયર મોટરમાંથી ઇલેક્ટ્રિક બ્લુ સ્પાર્ક્સ અને ગિયર ક્લેક સાઉન્ડ (`BlendMode.plus`).
- **Clutch Brake Smoke:** બેલ્ટ અટકાવતાં સ્મોક પફ અને બ્રેક સ્ક્રીચ સાઉન્ડ.
- **Loop Carousel Trail:** લૂપમાં ટ્રેન ગોળ ફરતી વખતે તેની પાછળ સર્ક્યુલર સ્પીડ-લાઇન્સ.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 15)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P15-QA-01 | L7001–7500 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P15-QA-02 | Step 3 Conveyor Advance | દરેક મૂવના અંતે બેલ્ટ પર રહેલી ટ્રેન 1 સેલ આગળ વધે (જો આગળ ખાલી હોય). | Not run |
| P15-QA-03 | Belt Switch L/R Routing | સ્વિચ ટેપ કરતાં પ્રવાહ ચોક્કસપણે ડાબે/જમણે ટોગલ થાય (1 Move). | Not run |
| P15-QA-04 | Reversing Belt 180° Flip | લીવર ખેંચતાં સંલગ્ન તમામ બેલ્ટ્સ વિરુદ્ધ દિશામાં મુવ થવા લાગે. | Not run |
| P15-QA-05 | Belt Stop Lever Pause | સ્ટોપ લીવર ટેપ કરતાં બેલ્ટ સ્થિર બને અને ટ્રેનો સરકતી અટકે. | Not run |
| P15-QA-06 | Loop Belt Continuous Cycle | લૂપમાં રહેલી ટ્રેન ક્લોકવાઇઝ ફરે; ટેપ કરતાં બહારની ખુલ્લી શાખામાં એક્ઝિટ લે. | Not run |
| P15-QA-07 | 60 fps Multi-Conveyor Budget| સ્ક્રીન પર 30+ એનિમેટેડ બેલ્ટ સેલ્સ છતાં લો-ટાયર ડિવાઇસ પર 60 fps જળવાય. | Not run |
| P15-QA-08 | Remote Config Rollout | `maxPhase < 15` હોય ત્યારે L7001 લોક રહે; `15` થતાં જ અનલૉક થાય. | Not run |

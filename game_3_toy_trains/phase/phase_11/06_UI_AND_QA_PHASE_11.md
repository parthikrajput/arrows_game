# 06 · UI & QA Phase 11 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 11 ના UI ઘટકો (Twin Table Viewport, Bridge Flow Chevrons, Cross-Board Ticket Links), VFX (`bridge_transfer`, `portal_warp`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 11 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Twin Tables Viewport & Cross-Board Visualizers
- **Dual Table Layout:** સ્ક્રીન પર Table A અને Table B બાજુ-બાજુમાં (Landscape) અથવા ઉપર-નીચે (Portrait) પ્રદર્શિત થાય છે. Pinch-to-zoom અને smooth camera pan સક્ષમ રહે છે.
- **Bridge Flow Chevrons:** જ્યારે ટ્રેન Table Bridge પરથી પસાર થતી હોય ત્યારે પુલ પર તેજસ્વી સોનેરી એરોઝ (>>>) ચમકે છે, જે દર્શાવે છે કે ટ્રેન બીજા ટેબલ પર જઈ રહી છે.
- **Cross-Board Ticket Link Beam:** Table A પરની ટિકિટ અને Table B પરના બેરિયર વચ્ચે આછી વાદળી ગ્લોઇંગ કનેક્શન લાઇન પ્રદર્શિત થાય છે, જેથી પ્લેયરને બંને વચ્ચેનો સંબંધ તુરંત સમજાય.
- **Mirror Train Emblem:** જોડિયા ટ્રેનોની છત પર વિશિષ્ટ મિરર આઈકોન (⚏) ચમકે છે.

### 1.2 Tutorial Cards
- **L5011 (M501):** Table Bridge પરિચય ("Tracks can cross between Table A and Table B via wooden bridges! Watch for incoming trains!").
- **L5131 (M502):** Inter-table Ticket પરિચય ("Collect this ticket on Table A to unlock the barrier gate on Table B!").
- **L5251 (M503):** Mirror Table પરિચય ("Twin trains move together across both tables in mirrored directions! Clear both paths!").
- **L5371 (M504):** Relay Tunnel પરિચય ("Enter this tunnel on Table A to instantly emerge on Table B!").

---

## 2. Phase 9–11 Visual Effects (VFX)
- **Bridge Transfer Glow:** ટ્રેન પુલ ઓળંગતી વખતે લાકડાના પાટિયાં નીચેથી ગોલ્ડન લાઇટ રિમ અને વ્હીલ ક્લેક સાઉન્ડ.
- **Cross-Board Unlock Laser:** ટિકિટ કલેક્ટ થતાં જ એક તેજસ્વી બીમ Table A પરથી ઉડીને Table B ના બેરિયર પર ત્રાટકે છે અને તેને અનલોક કરે છે (`BlendMode.plus`).
- **Mirror Sync Flash:** એક ટ્રેન ટેપ કરતાં બીજી ટ્રેન પર એકસાથે બ્લુ સ્પાર્કલ ફ્લેશ.
- **Relay Portal Warp:** સુરંગમાં પ્રવેશતાં વોર્પિંગ રિંગ્સ અને એક્ઝિટ મુખ પર રિવર્સ વોર્પ ફ્લેશ.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 11)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P11-QA-01 | L5011–5500 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P11-QA-02 | Table Bridge Entry & Exit | Table A ની એજમાંથી નીકળતી ટ્રેન Table B ના સંલગ્ન સેલમાં પ્રવેશે; બ્લોક હોય તો બમ્પ થાય. | Not run |
| P11-QA-03 | Inter-table Ticket Unlock | Table A પર ટિકિટ પાસ થતાં જ Table B પરનો બેરિયર કાયમી ખુલે. | Not run |
| P11-QA-04 | Mirror Train Simultanous Move | એક ટ્રેન ચલાવતાં બીજી મિરર ટ્રેન એકસાથે ચાલે; કોઈ એક બ્લોક થાય તો બંને બમ્પ થાય. | Not run |
| P11-QA-05 | Relay Tunnel Transfer | એક ટેબલના ટનલ મુખમાંથી પ્રવેશી બીજા ટેબલના મુખમાંથી સીધી બહાર આવે. | Not run |
| P11-QA-06 | Dual Viewport Rendering | બંને ટેબલ્સ એકસાથે સરળતાથી રેન્ડર થાય (કોઈ ફ્રેમ ડ્રોપ કે ક્લિપિંગ વગર). | Not run |
| P11-QA-07 | 60 fps Dual Table Budget | બંને ટેબલ્સ પર 35+ ટ્રેનો સક્રિય હોવા છતાં લો-ટાયર ડિવાઇસ પર 60 fps જળવાય. | Not run |
| P11-QA-08 | Remote Config Rollout | `maxPhase < 11` હોય ત્યારે L5011 લોક રહે; `11` થતાં જ અનલૉક થાય. | Not run |

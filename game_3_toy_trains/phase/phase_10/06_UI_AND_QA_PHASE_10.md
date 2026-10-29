# 06 · UI & QA Phase 10 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 10 ના UI ઘટકો (Metronome Beat Visualizer, Departure Ribbon, Echo History Display), VFX (`rhythm_pulse`, `code_unlock`), પર્ફોર્મન્સ બજેટ અને QA ચેકલિસ્ટ.

**Related docs:** [Phase 10 README](./README.md) · [Shared Core Standard §11, §13](../../SHARED_CORE_STANDARD.md) · [VFX Implementation](../../VFX_IMPLEMENTATION.md) · [Performance Optimization](../PERFORMANCE_OPTIMIZATION.md)

---

## 1. UI Additions

### 1.1 Timetable & Sequencing Visualizers
- **Metronome Beat Indicator:** ગેટની ઉપર નાનો પેન્ડુલમ/મીટર જે આગામી મૂવ પર ગેટ "Open" કે "Closed" રહેશે તેનો અગાઉથી સંકેત આપે છે.
- **Departure Code Ribbon:** Departure Code Lock ની ઉપર ટ્રેન રંગોની પટ્ટી દર્શાવેલી હોય છે (દા.ત. 🔴 -> 🔵 -> 🟢). જેવો યોગ્ય રંગ નીકળે છે તેમ તે રંગ ચેકમાર્ક (✓) સાથે ગ્લો થાય છે.
- **Platform Order Badges:** પ્લેટફોર્મ ટ્રેક સેલ્સ પર ક્રમાંકિત ડિસ્ક (①, ②, ③) દેખાય છે, જે દર્શાવે છે કે કઈ ટ્રેન પહેલાં જવી જરૂરી છે.
- **Echo Sequence Buffer:** Echo Signal ની બાજુમાં 2 ગોળ સ્લોટ્સ હોય છે જે તાજેતરમાં નીકળેલી ટ્રેનોના રંગો દર્શાવે છે જેથી પ્લેયરને યાદ ન રાખવું પડે.

### 1.2 Tutorial Cards
- **L4511 (M451):** Metronome Gate પરિચય ("This gate opens and closes to a steady rhythm! Watch the beat before sending your train!").
- **L4631 (M452):** Departure Code Lock પરિચય ("Trains must exit in the exact color sequence shown on the billboard to open this gate!").
- **L4751 (M453):** Platform Order Exit પરિચય ("Numbered platforms only accept trains in ascending order: 1, then 2, then 3!").
- **L4871 (M454):** Echo Signal પરિચય ("Echo Signal remembers departing train colors! Your next departures must mirror the pattern!").

---

## 2. Phase 10 Visual Effects (VFX)
- **Rhythm Pulse VFX:** દરેક મૂવ પર મેટ્રોનોમ ગેટમાંથી નાનો સોનિક પલ્સ છૂટે છે (ગ્રીન જો ખુલ્લો હોય, રેડ જો બંધ હોય).
- **Code Unlock Burst:** સાચો કલર કોડ પૂર્ણ થતાં જ બેરિયર પર સોનેરી કન્ફેટી અને ફ્લેર બર્સ્ટ થાય છે (`BlendMode.plus`).
- **Order Violation Buzz:** ખોટા ક્રમમાં ટ્રેન જવાનો પ્રયત્ન કરે ત્યારે લાલ વાઇબ્રેશન અને બમ્પ સ્મોક.
- **Echo Memory Glow:** અગાઉના રંગનું પુનરાવર્તન થતાં ઇકો સિગ્નલ પર સ્પાર્કલિંગ રીંગ એનિમેશન.
- **Tier Limits:** Low: 30 particles; Mid: 80 particles; High: 150 particles.

---

## 3. QA Checklist (Phase 10)

| ID | ટેસ્ટ વર્ણન | અપેક્ષિત પરિણામ | સ્થિતિ |
|---|---|---|---|
| P10-QA-01 | L4501–5000 CI Validation | તમામ 500 levels 0 hearts / 0 boosters સાથે સોલ્વેબલ હોવા જોઈએ. | Not run |
| P10-QA-02 | Metronome Gate Cycle | મૂવ્સ સાથે ગેટ ચોક્કસ પેટર્ન મુજબ ઓપન/ક્લોઝ થાય (ક્લોઝ્ડ હોય ત્યારે બમ્પ). | Not run |
| P10-QA-03 | Departure Code Sequence | સાચા રંગ ક્રમમાં એક્ઝિટ થતાં જ ગેટ કાયમી ખુલે; ખોટા રંગ પર રીસેટ થાય. | Not run |
| P10-QA-04 | Platform Order Enforce | ટ્રેન #1 નીકળ્યા વગર ટ્રેન #2 એજ પાર ન કરી શકે (અમાન્ય ટેપ બમ્પ). | Not run |
| P10-QA-05 | Echo Signal Matching | N રંગોનું પુનરાવર્તન થાય તો જ ગ્રીન રહે; વિસંગતતા પર રેડ થઈ પાટો રોકે. | Not run |
| P10-QA-06 | Multi-Modifier Stacking | મેટ્રોનોમ સાથે ఫ્રોઝન કે કલર્ડ મોડિફાયરનું સુસંગત વર્તન. | Not run |
| P10-QA-07 | 60 fps Clockwork Display | પેન્ડુલમ અને રીબન એનિમેશન વખતે લો-ટાયર ડિવાઇસ પર 60 fps જળવાય. | Not run |
| P10-QA-08 | Remote Config Rollout | `maxPhase < 10` હોય ત્યારે L4501 લોક રહે; `10` થતાં જ અનલૉક થાય. | Not run |

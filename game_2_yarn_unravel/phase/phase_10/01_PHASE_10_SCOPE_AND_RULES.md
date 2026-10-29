# 01 — Phase 10 Scope & Rule Additions
> Phase 10 (L4501–5000) માટે વિગતવાર સ્કોપ અને નિયમો: Sequencing (Pattern Book) સિગ્નેચર સિસ્ટમ, દોરાઓના એક્ઝિટ ક્રમ, રિધમિક મેટ્રોનોમ ગેટ્સ, ઑન-ડિવાઇસ જનરેશન, D band 82–98, ગ્રીડ અને પાથ મર્યાદાઓ.

**Related docs:** [Phase 10 index](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling §2–§7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_4501_5000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_10.md)

---

## 1. Baseline Invariants (અપરિવર્તિત નિયમો)
Phase 10 માં કોર ગેમપ્લે ઇન્વેરિયન્ટ્સ યથાવત રહે છે:
- **Core Loop:** Tap $\to$ Needle Head unravels, blocked $\to$ needle snags (-1 Heart, damped twang $\le 3\text{ kHz}$ spring-back).
- **Turn-based:** કોઈ વૉલ-ક્લોક ટાઈમર નથી; રિધમિક પેટર્ન (Rhythm/Metronome) પણ પ્લેયરના દરેક માન્ય મૂવ પર જ એડવાન્સ થાય છે.
- **0-Hearts Solvable:** દરેક સીડમાંથી જનરેટ થયેલ લેવલ 0 hearts lost અને 0 boosters વડે 100% સોલ્વેબલ હોવું ફરજિયાત છે.
- **Touch Targets:** 360 dp બેઝલાઇન વિન્ડો પર લઘુત્તમ 29 dp સેલ કદ (પિંચ-ઝૂમ અને પાન સાથે).

---

## 2. New Signature System: Sequencing (Pattern Book)

### 2.1 Sequencing Constraints
1. **Metronome Gate (M451):**
   - ક્રાફ્ટ ગેટ જે પ્લેયરના મૂવ કાઉન્ટના રિધમ મુજબ ઓપન/ક્લોઝ થાય છે.
   - ઉદાહરણ: પેટર્ન $[O, C, C]$ (1 મૂવ ઓપન, 2 મૂવ ક્લોઝ). મૂવ 0 (ઓપન), મૂવ 1 (ક્લોઝ), મૂવ 2 (ક્લોઝ), મૂવ 3 (ઓપન).
   - ગેટ જ્યારે ક્લોઝ હોય ત્યારે તે સિંગલ બ્લોકર તરીકે વર્તે છે.
2. **Pattern Clasp (M452):**
   - એમ્બ્રોઇડરી ક્લેસ્પ જે ચોક્કસ રંગીન સ્ટીચ પેટર્ન દર્શાવે છે (દા.ત. Red $\to$ Blue $\to$ Yellow).
   - ખેલાડીએ આ રંગ ક્રમમાં જ દોરાઓ અનરૅવલ કરવા પડે છે; ખોટા રંગનો દોરો ખેંચતાં ક્લેસ્પ અનલૉક થતો નથી.
3. **Ordered Hem (M453):**
   - બોર્ડની કિનારીનો એક ભાગ (Hem) જ્યાં માત્ર ચડતા ક્રમના ટેગ ($1, 2, 3 \dots$) વાળા દોરાઓ જ બહાર નીકળી શકે છે.
   - અન્ય દોરો આ હેમમાંથી નીકળવાનો પ્રયત્ન કરે તો સ્નેગ થાય છે (-1 Heart).
4. **Echo Card (M454):**
   - સ્કોરબોર્ડ પર પ્રદર્શિત કાર્ડ જે પ્રથમ $k$ (2–3) દોરાઓના કલર ક્રમને રેકોર્ડ કરે છે. આગામી $k$ દોરાઓ આ જ કલર ક્રમમાં બહાર નીકળવા ફરજિયાત છે; ખોટા કલર પર ટેપ લૉક થાય છે.

### 2.2 Tick Order Integration (standard §16.17)
1. Player action resolve થાય છે (દોરો અનરૅવલ એક્ઝિટ).
2. `moveCount += 1`.
3. Counters tick: M007, M017, M031, M253, M353.
4. Rhythm & Metronome state update:
   - Metronome Gate (M451) આગામી સ્ટેટમાં શિફ્ટ થાય છે ($m \pmod K$).
5. Sequence verification & Clasps:
   - Pattern Clasp (M452) કલર મેચિંગ તપાસે છે અને જો ક્રમ પૂર્ણ થાય તો કાયમી ઓપન થાય છે.
   - Echo Card (M454) હિસ્ટ્રી સ્ટેક અપડેટ કરે છે.
6. Heart loss & Shields resolution.
7. Win condition check.

---

## 3. Limits & Parameters
| Parameter | Phase 10 Budget | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સપોર્ટેડ |
| Thread Paths ($P$) | 28 – 40 threads | Reverse construction & solver verified |
| Max Obstacles ($O$) | 8 – 14 instances | Metronome Gates, Pattern Clasps, Ordered Hems |
| Difficulty ($D$) Band | **82 – 98** | Formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ~ 108 | High band × 1.10 |
| L5000 Finale Target | ~ 118 | High band × 1.20 |
| Generation Timeout | $\le 100\text{ ms}$ | Isolate-based background generation |

---

## 4. Rollout Guard
- **Remote Config Key:** `maxPhase`. જો `maxPhase < 10` હોય તો Phase 10 ના તમામ નોડ્સ લૉક રહે છે.
- **Seed Overrides:** જો કોઈ સીડ CI વેરિફિકેશનમાં ફેલ થાય, તો `assets/levels/seed_overrides.json` માં ઓવરરાઈડ નોંધાય છે.


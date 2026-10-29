# 01 — Phase 18 Scope & Rule Additions
> Phase 18 (L8501–9000) માટે વિગતવાર સ્કોપ અને નિયમો: Remix A (Phases 1–6 Synergies) સિગ્નેચર સિસ્ટમ, ડેટા-ડ્રિવન મિકેનિક સિલેક્શન, ઑન-ડિવાઇસ જનરેશન, D band 106–122, ગ્રીડ અને પાથ મર્યાદાઓ.

**Related docs:** [Phase 18 index](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling §2–§7, §10.3](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_8501_9000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_18.md)

---

## 1. Baseline Invariants (અપરિવર્તિત નિયમો)
Phase 18 માં કોર ગેમપ્લે ઇન્વેરિયન્ટ્સ યથાવત રહે છે:
- **Core Loop:** Tap $\to$ Needle Head unravels, blocked $\to$ needle snags (-1 Heart, damped twang $\le 3\text{ kHz}$ spring-back).
- **Turn-based:** કોઈ વૉલ-ક્લોક ટાઈમર નથી; મલ્ટિ-સિસ્ટમ સ્ટેટ્સ પ્લેયરના દરેક વેલિડ મૂવ સાથે જ ટિક થાય છે.
- **0-Hearts Solvable:** દરેક સીડમાંથી જનરેટ થયેલ લેવલ 0 hearts lost અને 0 boosters વડે 100% સોલ્વેબલ હોવું ફરજિયાત છે.
- **Touch Targets:** 360 dp બેઝલાઇન વિન્ડો પર લઘુત્તમ 29 dp સેલ કદ (પિંચ-ઝૂમ અને પાન સાથે).

---

## 2. Signature System: Remix A (Phases 1 to 6 Synergy)

### 2.1 Data-Driven Combo Selection (§10.3)
Remix A એ પ્રથમ 6 તબક્કાઓના લોકપ્રિય મિકેનિક્સનું સિનર્જિસ્ટિક મિશ્રણ છે:
1. **Selection Rule:** ઉમેદવાર પૂલમાંથી એવા 4 મિકેનિક્સ પસંદ થાય છે જે:
   - પ્લેયર એંગેજમેન્ટમાં ઉચ્ચ સ્કોર ધરાવતા હોય (વિન રેટ 45%–65%, ક્વિટ રેટ < 12%).
   - CI સોલ્વર નોડ્સ બજેટ ($\le 1.5\text{M}$ nodes) માં પૂર્ણ થતાં હોય.
   - ડિઝાઇન ટીમ દ્વારા ક્રાફ્ટ થીમ સાથે સુસંગત માન્યતા પ્રાપ્ત હોય.
2. **Candidate Pool:**
   - **M851 — Cycle Crate:** ડે/નાઈટ સાયકલ (P3) મુજબ પોઝિશન સ્વિચ કરતો અથવા માત્ર ચોક્કસ સાયકલમાં જ પુશ થઈ શકે તેવો વૂડન ક્રેટ (P5).
   - **M852 — Floor Beam:** લાઈટ બીમ (P6) જે કાપડના લેયર/ફ્લોર (P4) પરથી પસાર થઈને અન્ય માળે રહેલા સન-કેચર્સને પ્રકાશિત કરે છે.
   - **M853 — Fogged Stair:** મલ્ટિ-ફ્લોર સીડી (P4) જે વૂલ ફ્લફ ફોગ નીચે છુપાયેલી હોય છે અને દોરો પ્રવેશતાં રિવિલ થાય છે.
   - **M854 — Satin Charm Crate:** સ્લાઇડિંગ સાટિન ક્રેટ (P5) જેને કલર્ડ ક્લેસ્પ પર ધકેલવાથી કાયમી લૉક ખુલે છે.

### 2.2 Tick Order Integration (standard §16.17)
1. Player action resolve થાય છે (દોરો ખેંચવો / ક્રેટ પુશ / ટૉગલ ટેપ).
2. `moveCount += 1`.
3. Counters tick: M007, M017, M031, M253, M353.
4. **Remix A Multi-System Resolution:**
   - Cycles state transition ($m \pmod 5 == 0$).
   - Light beam ray tracing & color reflection calculation.
   - Push physics & Floor transition resolution.
5. Gates, clasps & locks update.
6. Heart loss & Shields resolution.
7. Win condition check.

---

## 3. Limits & Parameters
| Parameter | Phase 18 Budget | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સપોર્ટેડ |
| Thread Paths ($P$) | 28 – 40 threads | Reverse construction & solver verified |
| Max Obstacles ($O$) | 8 – 14 instances | Combo mechanics from candidate pool |
| Difficulty ($D$) Band | **106 – 122** | Formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ~ 134 | High band × 1.10 |
| L9000 Finale Target | ~ 146 | High band × 1.20 |
| Generation Timeout | $\le 100\text{ ms}$ | Isolate-based background generation |

---

## 4. Rollout Guard
- **Remote Config Key:** `maxPhase`. જો `maxPhase < 18` હોય તો Phase 18 ના તમામ નોડ્સ લૉક રહે છે.
- **Seed Overrides:** જો કોઈ સીડ CI વેરિફિકેશનમાં ફેલ થાય, તો `assets/levels/seed_overrides.json` માં ઓવરરાઈડ નોંધાય છે.

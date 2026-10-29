# 01 — Phase 16 Scope & Rule Additions
> Phase 16 (L7501–8000) માટે વિગતવાર સ્કોપ અને નિયમો: Keys Deluxe (Jewel Box) સિગ્નેચર સિસ્ટમ, ચાર્મ ચેઇન્સ, કી ક્રાફ્ટિંગ, સ્કેલેટન ચાર્મ્સ, ઑન-ડિવાઇસ જનરેશન, D band 100–116, ગ્રીડ અને પાથ મર્યાદાઓ.

**Related docs:** [Phase 16 index](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling §2–§7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_7501_8000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_16.md)

---

## 1. Baseline Invariants (અપરિવર્તિત નિયમો)
Phase 16 માં કોર ગેમપ્લે ઇન્વેરિયન્ટ્સ યથાવત રહે છે:
- **Core Loop:** Tap $\to$ Needle Head unravels, blocked $\to$ needle snags (-1 Heart, damped twang $\le 3\text{ kHz}$ spring-back).
- **Turn-based:** કોઈ વૉલ-ક્લોક ટાઈમર નથી; ચાર્મ કલેક્શન અને કી ક્રાફ્ટિંગ પ્લેયરના દરેક વેલિડ મૂવ સાથે આગળ વધે છે.
- **0-Hearts Solvable:** દરેક સીડમાંથી જનરેટ થયેલ લેવલ 0 hearts lost અને 0 boosters વડે 100% સોલ્વેબલ હોવું ફરજિયાત છે.
- **Touch Targets:** 360 dp બેઝલાઇન વિન્ડો પર લઘુત્તમ 29 dp સેલ કદ (પિંચ-ઝૂમ અને પાન સાથે).

---

## 2. New Signature System: Keys Deluxe (Jewel Box)

### 2.1 Advanced Key Logistics
1. **Charm Chain (M751):**
   - ક્રમાંકિત ચાર્મ્સની શૃંખલા ($1 \to 2 \to 3$).
   - ખેલાડીએ પહેલાં ચાર્મ 1 વાળા દોરાને બહાર કાઢવો પડે છે, પછી જ ચાર્મ 2 વાળો દોરો ટેપ-સક્ષમ બને છે; જો ક્રમ તોડીને દોરો ટેપ કરાય તો ટેપ લૉક રહે છે (કોઈ સ્નેગ પેનલ્ટી નહીં).
2. **Charm Crafting (M752):**
   - બે જુદા જુદા દોરાઓ અડધી-અડધી કી (Half-Charm A અને Half-Charm B) ધરાવે છે.
   - જ્યારે બંને દોરા સફળતાપૂર્વક અનરૅવલ થઈ જાય છે, ત્યારે બંને અર્ધભાગો જોડાઈને સોનેરી ગ્રાન્ડ કી (Complete Key) બને છે અને મુખ્ય ગ્રાન્ડ ક્લેસ્પને અનલૉક કરે છે.
3. **Skeleton Charm (M753):**
   - માસ્ટર ક્રાફ્ટ કી જે કોઈપણ રંગના ક્લેસ્પને અનલૉક કરી શકે છે. જ્યારે આ દોરો કોઈપણ કલર્ડ ક્લેસ્પ પરથી પસાર થાય છે, ત્યારે તે ક્લેસ્પ આપોઆપ ખુલી જાય છે.
4. **Charm Swap Hoop (M754):**
   - બોર્ડ પર ઇન્ટરેક્ટિવ સ્વેપ હોપ. ટેપ કરવાથી (1 Move) તેની સાથે લિંક થયેલા બે દોરાઓ વચ્ચે કી રંગોનું પરસ્પર આદાન-પ્રદાન (Color Swap) થાય છે.

### 2.2 Tick Order Integration (standard §16.17)
1. Player action resolve થાય છે (દોરો ખેંચવો અથવા Swap Hoop ટેપ કરવું).
2. `moveCount += 1`.
3. Counters tick: M007, M017, M031, M253, M353.
4. **Keys & Crafting Step Execution:**
   - Charm Chain (M751) પ્રગતિ ચકાસાય છે અને આગામી ચાર્મ ટેપ-સક્ષમ બને છે.
   - Half-Charms (M752) બંને પ્રાપ્ત થયા હોય તો Complete Key ફોર્જ થાય છે.
   - Skeleton Charm (M753) પાસ થતાં કલર્ડ ક્લેસ્પ અનલૉક થાય છે.
   - Charm Swap (M754) રંગોનું સ્વેપિંગ પૂર્ણ કરે છે.
5. Clasps & Gates state updates.
6. Heart loss & Shields resolution.
7. Win condition check.

---

## 3. Limits & Parameters
| Parameter | Phase 16 Budget | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સપોર્ટેડ |
| Thread Paths ($P$) | 28 – 40 threads | Reverse construction & solver verified |
| Max Obstacles ($O$) | 8 – 14 instances | Charm Chains, Crafting Altars, Swap Hoops |
| Difficulty ($D$) Band | **100 – 116** | Formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ~ 127 | High band × 1.10 |
| L8000 Finale Target | ~ 139 | High band × 1.20 |
| Generation Timeout | $\le 100\text{ ms}$ | Isolate-based background generation |

---

## 4. Rollout Guard
- **Remote Config Key:** `maxPhase`. જો `maxPhase < 16` હોય તો Phase 16 ના તમામ નોડ્સ લૉક રહે છે.
- **Seed Overrides:** જો કોઈ સીડ CI વેરિફિકેશનમાં ફેલ થાય, તો `assets/levels/seed_overrides.json` માં ઓવરરાઈડ નોંધાય છે.


# 01 — Phase 14 Scope & Rule Additions
> Phase 14 (L6501–7000) માટે વિગતવાર સ્કોપ અને નિયમો: Mirror Worlds (Looking-Glass Quilt) સિગ્નેચર સિસ્ટમ, મિરર સીમ્સ, રિફ્લેક્ટ ક્લેસ્પ્સ, ઇન્વર્સ થ્રેડ્સ, ઑન-ડિવાઇસ જનરેશન, D band 94–110, ગ્રીડ અને પાથ મર્યાદાઓ.

**Related docs:** [Phase 14 index](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling §2–§7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_6501_7000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_14.md)

---

## 1. Baseline Invariants (અપરિવર્તિત નિયમો)
Phase 14 માં કોર ગેમપ્લે ઇન્વેરિયન્ટ્સ યથાવત રહે છે:
- **Core Loop:** Tap $\to$ Needle Head unravels, blocked $\to$ needle snags (-1 Heart, damped twang $\le 3\text{ kHz}$ spring-back).
- **Turn-based:** કોઈ વૉલ-ક્લોક ટાઈમર નથી; મિરર ટ્વીન એક્શન્સ અને ઇન્વર્સ મૂવમેન્ટ્સ પ્લેયરના ટેપ સાથે તાત્કાલિક સિંક થાય છે.
- **0-Hearts Solvable:** દરેક સીડમાંથી જનરેટ થયેલ લેવલ 0 hearts lost અને 0 boosters વડે 100% સોલ્વેબલ હોવું ફરજિયાત છે.
- **Touch Targets:** 360 dp બેઝલાઇન વિન્ડો પર લઘુત્તમ 29 dp સેલ કદ (પિંચ-ઝૂમ અને પાન સાથે).

---

## 2. New Signature System: Mirror Worlds (Looking-Glass Quilt)

### 2.1 Reflection Axes & Dynamics
1. **Mirror Seam (M651):**
   - ક્રાફ્ટ બોર્ડની મધ્યમાં આવેલી ચાંદીના તારવાળી મિરર સીમ (વર્ટિકલ $x = W/2$ અથવા હોરિઝોન્ટલ $y = H/2$).
   - આ સીમની બંને બાજુએ આવેલા દોરાઓ "ટ્વીન પેર" (Twin Pair) તરીકે જોડાયેલા હોય છે.
   - કોઈપણ એક ટ્વીનને ટેપ કરતાં, બંને દોરા એકસાથે પોતાના સંબંધિત એક્ઝિટ તરફ ખેંચાય છે. જો બંનેના રસ્તા ક્લિયર હોય તો બંને સફળતાપૂર્વક અનરૅવલ થાય છે; જો કોઈ એક પણ બ્લોક હોય તો બંને સ્નેગ થાય છે અને કુલ **-1 Heart** જ ગુમાવાય છે.
2. **Reflect Clasp (M652):**
   - મિરર સીમની બંને બાજુએ સ્થિત ક્લેસ્પ જોડી. જ્યારે એક બાજુનો ક્લેસ્પ કી દ્વારા ખુલે છે, ત્યારે બીજી બાજુનો ક્લેસ્પ આપોઆપ પ્રતિબિંબિત થઈને ખુલી જાય છે.
3. **Twin Quilt (M653):**
   - બોર્ડના અડધા ભાગ પરનો ઇન્ટરેક્ટિવ સ્વિચ કે ટૉગલ; તેના પર ટેપ કરતાં મિરર અડધા ભાગ પરનો સ્વિચ આપોઆપ સમાન અવસ્થામાં પલટાઈ જાય છે.
4. **Inverse Thread (M654):**
   - પ્રાઇમરી દોરા સાથે વિરુદ્ધ જોડાયેલો દોરો. જ્યારે પ્રાઇમરી દોરો દિશા $D$ માં આગળ વધે છે, ત્યારે ઇન્વર્સ દોરો બરાબર તેની વિરુદ્ધ દિશા $\text{opp}(D)$ માં ગતિ કરે છે.

### 2.2 Tick Order Integration (standard §16.17)
1. Player action resolve થાય છે (દોરો ખેંચવો).
2. `moveCount += 1`.
3. Counters tick: M007, M017, M031, M253, M353.
4. **Mirror & Inverse Resolution:**
   - Mirror Twin threads એકસાથે અનરૅવલ થાય છે.
   - Inverse Threads વિરુદ્ધ દિશામાં 1:1 ગતિ કરે છે.
5. Clasps & Gates update:
   - Reflect Clasps (M652) જોડીમાં એકીસાથે અનલૉક થાય છે.
6. Heart loss & Shields resolution (ટ્વીન ફેલ્યોર પર મહત્તમ 1 Heart).
7. Win condition check.

---

## 3. Limits & Parameters
| Parameter | Phase 14 Budget | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સપોર્ટેડ |
| Thread Paths ($P$) | 28 – 40 threads | Reverse construction & solver verified |
| Max Obstacles ($O$) | 8 – 14 instances | Mirror Seams, Reflect Clasps, Inverse Threads |
| Difficulty ($D$) Band | **94 – 110** | Formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ~ 121 | High band × 1.10 |
| L7000 Finale Target | ~ 132 | High band × 1.20 |
| Generation Timeout | $\le 100\text{ ms}$ | Isolate-based background generation |

---

## 4. Rollout Guard
- **Remote Config Key:** `maxPhase`. જો `maxPhase < 14` હોય તો Phase 14 ના તમામ નોડ્સ લૉક રહે છે.
- **Seed Overrides:** જો કોઈ સીડ CI વેરિફિકેશનમાં ફેલ થાય, તો `assets/levels/seed_overrides.json` માં ઓવરરાઈડ નોંધાય છે.


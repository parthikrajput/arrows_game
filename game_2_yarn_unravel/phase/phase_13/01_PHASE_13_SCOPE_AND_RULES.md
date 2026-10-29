# 01 — Phase 13 Scope & Rule Additions
> Phase 13 (L6001–6500) માટે વિગતવાર સ્કોપ અને નિયમો: Hidden Info (Mystery Basket) સિગ્નેચર સિસ્ટમ, વૂલ ફ્લફ ફોગ ઑફ વૉર, સ્કાઉટિંગ પાથ્સ, લેન્ટર્ન પ્લેટ્સ, ઑન-ડિવાઇસ જનરેશન, D band 91–107, ગ્રીડ અને પાથ મર્યાદાઓ.

**Related docs:** [Phase 13 index](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling §2–§7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_6001_6500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_13.md)

---

## 1. Baseline Invariants (અપરિવર્તિત નિયમો)
Phase 13 માં કોર ગેમપ્લે ઇન્વેરિયન્ટ્સ યથાવત રહે છે:
- **Core Loop:** Tap $\to$ Needle Head unravels, blocked $\to$ needle snags (-1 Heart, damped twang $\le 3\text{ kHz}$ spring-back).
- **Turn-based:** કોઈ વૉલ-ક્લોક ટાઈમર નથી; ફોગ રિવિલ અને સ્કાઉટિંગ પ્લેયરના દરેક માન્ય મૂવ પર આધાર રાખે છે.
- **0-Hearts Solvable:** દરેક સીડમાંથી જનરેટ થયેલ લેવલ 0 hearts lost અને 0 boosters વડે 100% સોલ્વેબલ હોવું ફરજિયાત છે (રિવિલ પહેલાં પણ સાચો પાથ સોલ્વેબલ છે).
- **Touch Targets:** 360 dp બેઝલાઇન વિન્ડો પર લઘુત્તમ 29 dp સેલ કદ (પિંચ-ઝૂમ અને પાન સાથે).

---

## 2. New Signature System: Hidden Info (Mystery Basket)

### 2.1 Fog of War & Reveal Mechanics
1. **Wool Fluff Fog (M010 Extension):**
   - બોર્ડના કેટલાક ચોરસ વિસ્તારો જાડા વૂલ ફ્લફ (ઊનની ધુમ્મસ) થી ઢંકાયેલા હોય છે. અંદર રહેલા દોરાઓ અને અવરોધો સંપૂર્ણપણે અદૃશ્ય હોય છે.
2. **Scout Thread (M601):**
   - ખાસ દોરો જે બહાર નીકળતી વખતે તેના સમગ્ર પુલ પાથની 1-સેલ આસપાસ રહેલું તમામ વૂલ ફ્લફ કાયમી ધોરણે સાફ (Clear) કરી નાખે છે.
3. **Decoy Fluff (M602):**
   - દેખાવમાં જાડા વૂલ ફ્લફ જેવું લાગે છે પણ અંદર કશું છુપાયેલું હોતું નથી; કોઈપણ દોરાની પુલ લાઇન તેને સ્પર્શતાં જ તે ધુમાડાની જેમ વિખેરાઈ જાય છે.
4. **Painted Wall (M603):**
   - કાપડ પર દોરેલી નકલી દિવાલ જે લાકડાના રૂલર બ્લોકર (M002) જેવી જ દેખાય છે, પરંતુ દોરાઓ તેના આરપાર સીધા પસાર થઈ શકે છે! પ્રથમ પાસ પછી તે પારદર્શક ચોક લાઇન બની જાય છે.
5. **Lantern Plate (M604):**
   - પિત્તળની લેન્ટર્ન પ્રેશર પ્લેટ. જ્યાં સુધી કોઈ દોરાનું શરીર આ પ્લેટ પર દબાયેલું રહે, ત્યાં સુધી બોર્ડનું તમામ વૂલ ફ્લફ અર્ધ-પારદર્શક (Semi-transparent) બની જાય છે.

### 2.2 Tick Order Integration (standard §16.17)
1. Player action resolve થાય છે (દોરો ખેંચવો).
2. `moveCount += 1`.
3. Counters tick: M007, M017, M031, M253, M353.
4. **Reveal & Scouting Resolution:**
   - Scout Thread (M601) એક્ઝિટ થતાં 1-સેલ રેડિયસમાં ફોગ અદૃશ્ય થાય છે.
   - Decoy Fluff (M602) પાથ સ્પર્શતાં તાત્કાલિક સાફ થાય છે.
   - Painted Wall (M603) પાસ થતાં નકલી દિવાલ ડિસ્પ્લે અપડેટ થાય છે.
   - Lantern Plate (M604) કવર/અનકવર સ્ટેટ પ્રમાણે પારદર્શકતા સ્વિચ કરે છે.
5. Gates & Clasps update.
6. Heart loss & Shields resolution.
7. Win condition check.

---

## 3. Limits & Parameters
| Parameter | Phase 13 Budget | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સપોર્ટેડ |
| Thread Paths ($P$) | 28 – 40 threads | Reverse construction & solver verified |
| Max Obstacles ($O$) | 8 – 14 instances | Scout Threads, Decoy Fluffs, Lantern Plates |
| Difficulty ($D$) Band | **91 – 107** | Formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ~ 118 | High band × 1.10 |
| L6500 Finale Target | ~ 128 | High band × 1.20 |
| Generation Timeout | $\le 100\text{ ms}$ | Isolate-based background generation |

---

## 4. Rollout Guard
- **Remote Config Key:** `maxPhase`. જો `maxPhase < 13` હોય તો Phase 13 ના તમામ નોડ્સ લૉક રહે છે.
- **Seed Overrides:** જો કોઈ સીડ CI વેરિફિકેશનમાં ફેલ થાય, તો `assets/levels/seed_overrides.json` માં ઓવરરાઈડ નોંધાય છે.


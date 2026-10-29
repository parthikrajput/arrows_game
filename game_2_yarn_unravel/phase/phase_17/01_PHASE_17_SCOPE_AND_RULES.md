# 01 — Phase 17 Scope & Rule Additions
> Phase 17 (L8001–8500) માટે વિગતવાર સ્કોપ અને નિયમો: Guardians (Pincushion Court) સિગ્નેચર સિસ્ટમ, પિનકુશન HP પૂલ્સ, આર્મર્ડ શિલ્ડ્સ, બટન સ્પૉનર્સ, ઑન-ડિવાઇસ જનરેશન, D band 103–119, ગ્રીડ અને પાથ મર્યાદાઓ.

**Related docs:** [Phase 17 index](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling §2–§7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_8001_8500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_17.md)

---

## 1. Baseline Invariants (અપરિવર્તિત નિયમો)
Phase 17 માં કોર ગેમપ્લે ઇન્વેરિયન્ટ્સ યથાવત રહે છે:
- **Core Loop:** Tap $\to$ Needle Head unravels, blocked $\to$ needle snags (-1 Heart, damped twang $\le 3\text{ kHz}$ spring-back).
- **Turn-based:** કોઈ વૉલ-ક્લોક ટાઈમર નથી; ગાર્ડિયન સ્પૉન્સ અને HP ડીપ્લીશન પ્લેયરના વેલિડ મૂવ્સ પર જ આધાર રાખે છે.
- **0-Hearts Solvable:** દરેક સીડમાંથી જનરેટ થયેલ લેવલ 0 hearts lost અને 0 boosters વડે 100% સોલ્વેબલ હોવું ફરજિયાત છે.
- **Touch Targets:** 360 dp બેઝલાઇન વિન્ડો પર લઘુત્તમ 29 dp સેલ કદ (પિંચ-ઝૂમ અને પાન સાથે).

---

## 2. New Signature System: Guardians (Pincushion Court)

### 2.1 Pincushion Mechanics & Damage Models
1. **Pincushion Scale:**
   - પિનકુશન્સ એ 2×2 અથવા 3×3 કદના મોટા મખમલી ઓબ્જેક્ટ્સ છે જેમાં સોય-પિન જડેલી હોય છે. તેઓ પ્રારંભિક HP (દા.ત. 4 થી 8) ધરાવે છે.
   - જ્યારે કોઈ દોરો પિનકુશનના અડીને આવેલા સેલમાંથી અનરૅવલ થઈને બહાર નીકળે છે, ત્યારે તે પિનકુશનમાંથી 1 પિન ખેંચી લે છે (-1 HP).
   - જ્યારે HP 0 થાય છે, ત્યારે પિનકુશન ગૂંચળું બનીને સંકોચાઈ જાય છે અને તેના તમામ સેલ્સ ખુલ્લા ક્લિયર ફ્લોર બની જાય છે.
2. **Twin Pincushions (M801):**
   - બોર્ડ પર બે પિનકુશન્સ જે સંયુક્ત HP પૂલ (Shared Pool) ધરાવે છે. બંનેમાંથી ગમે તે એક પાસે દોરો નીકળે તો સંયુક્ત HP ઘટે છે; 0 થતાં બંને એકસાથે ગાયબ થાય છે.
3. **Armoured Pincushion (M802):**
   - પિત્તળની કેપ ધરાવતું પિનકુશન. જ્યાં સુધી તેની સાથે જોડાયેલું લીવર "Shielded" સ્થિતિમાં હોય, ત્યાં સુધી દોરા નીકળવા છતાં તેને કોઈ ડેમેજ થતું નથી (શિલ્ડ ઇમ્યુન).
4. **Seeding Pincushion (M803):**
   - દર $N$ (4) મૂવ્સના અંતે પોતાની આસપાસના પ્રથમ ખાલી પડોશી સેલમાં ($U \to R \to D \to L$) એક લાકડાનું બટન (M001) સ્પૉન કરે છે.
5. **Heart Pincushion (M804):**
   - ગાર્ડિયનનું હાર્ટ કોર સેલ. તેનું HP માત્ર ત્યારે જ ઘટે છે જ્યારે બોર્ડ પરનું એક્ટિવ બીમ (Phase 6 Lamplight) તેના કોર સેલને પ્રકાશિત કરતું હોય અને તે જ મૂવમાં દોરો બહાર નીકળે.

### 2.2 Tick Order Integration (standard §16.17)
1. Player action resolve થાય છે (દોરો અનરૅવલ).
2. `moveCount += 1`.
3. Counters tick: M007, M017, M031, M253, M353.
4. **Guardian & Spawner Resolution:**
   - દોરાના પાથ અડીને નીકળતાં Pincushions ડેમેજ મેળવે છે (જો શીલ્ડ ન હોય).
   - Heart Pincushion (M804) માટે બીમ ઇન્ટરસેક્શન ચેક થાય છે.
   - HP 0 પહોંચતાં ગાર્ડિયન્સ ડિસપિયર થઈને સેલ્સ અનલૉક કરે છે.
   - Seeding Pincushion (M803) જો $m \pmod N == 0$ હોય તો બટન સ્પૉન કરે છે.
5. Gates & Clasps updates.
6. Heart loss & Shields resolution.
7. Win condition check.

---

## 3. Limits & Parameters
| Parameter | Phase 17 Budget | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સપોર્ટેડ |
| Thread Paths ($P$) | 28 – 40 threads | Reverse construction & solver verified |
| Max Obstacles ($O$) | 8 – 14 instances | Pincushions, Shield Levers, Beams |
| Difficulty ($D$) Band | **103 – 119** | Formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ~ 130 | High band × 1.10 |
| L8500 Finale Target | ~ 142 | High band × 1.20 |
| Generation Timeout | $\le 100\text{ ms}$ | Isolate-based background generation |

---

## 4. Rollout Guard
- **Remote Config Key:** `maxPhase`. જો `maxPhase < 17` હોય તો Phase 17 ના તમામ નોડ્સ લૉક રહે છે.
- **Seed Overrides:** જો કોઈ સીડ CI વેરિફિકેશનમાં ફેલ થાય, તો `assets/levels/seed_overrides.json` માં ઓવરરાઈડ નોંધાય છે.


# 01 — Phase 15 Scope & Rule Additions
> Phase 15 (L7001–7500) માટે વિગતવાર સ્કોપ અને નિયમો: Conveyors & Tracks (Feed Dog Factory) સિગ્નેચર સિસ્ટમ, કન્વેયર બેલ્ટ્સ, રિવર્સિંગ મિકેનિઝમ, ટ્રેક લૂપ્સ, ઑન-ડિવાઇસ જનરેશન, D band 97–113, ગ્રીડ અને પાથ મર્યાદાઓ.

**Related docs:** [Phase 15 index](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling §2–§7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_7001_7500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_15.md)

---

## 1. Baseline Invariants (અપરિવર્તિત નિયમો)
Phase 15 માં કોર ગેમપ્લે ઇન્વેરિયન્ટ્સ યથાવત રહે છે:
- **Core Loop:** Tap $\to$ Needle Head unravels, blocked $\to$ needle snags (-1 Heart, damped twang $\le 3\text{ kHz}$ spring-back).
- **Turn-based:** કોઈ વૉલ-ક્લોક ટાઈમર નથી; કન્વેયર બેલ્ટ અને ટ્રેક લૂપનું 1-સેલ મૂવમેન્ટ પ્લેયરના દરેક વેલિડ મૂવ પછી જ એક્ઝિક્યુટ થાય છે.
- **0-Hearts Solvable:** દરેક સીડમાંથી જનરેટ થયેલ લેવલ 0 hearts lost અને 0 boosters વડે 100% સોલ્વેબલ હોવું ફરજિયાત છે.
- **Touch Targets:** 360 dp બેઝલાઇન વિન્ડો પર લઘુત્તમ 29 dp સેલ કદ (પિંચ-ઝૂમ અને પાન સાથે).

---

## 2. New Signature System: Conveyors & Tracks (Feed Dog Factory)

### 2.1 Mechanical Belts & Track Loops
1. **Feed Dog Conveyor Belts:**
   - લિનન ક્રાફ્ટ બોર્ડમાં જડેલા દાંતેદાર કન્વેયર બેલ્ટ્સ (Feed Dogs).
   - જ્યારે કોઈ દોરાનું શરીર કે સોય બેલ્ટ સેલ્સ પર હોય, ત્યારે પ્લેયરના દરેક માન્ય મૂવના અંતે તે દોરો બેલ્ટની દિશામાં 1 સેલ આગળ ખસે છે (જો આગળનો સેલ ખાલી હોય).
2. **Belt Switch (M701):**
   - બેલ્ટ જંકશન સ્વિચ. ટેપ કરવાથી (1 Move) કન્વેયર કઈ શાખામાં (દા.ત. Straight vs Right Turn) દોરાઓને મોકલશે તે ટૉગલ થાય છે.
3. **Reversing Belt (M702):**
   - વિશેષ કન્વેયર બેલ્ટ જેની દિશા દર $N$ (3–5) મૂવ્સ પછી આપોઆપ 180° ઊંધી (Forward $\leftrightarrow$ Backward) થઈ જાય છે.
4. **Belt Lever (M703):**
   - ક્રાફ્ટ ક્લચ લીવર. ટેપ કરવાથી જોડાયેલા કન્વેયર બેલ્ટ્સ ચાલુ (Active) અથવા બંધ (Halted) થાય છે.
5. **Track Loop (M704):**
   - બંધ લૂપ ટ્રેક (Closed Circuit). દોરો ટ્રેક પર દર મૂવ દીઠ 1 સેલ ગોળ-ગોળ ફરે છે; માત્ર ત્યારે જ અનરૅવલ થઈને બહાર નીકળી શકે છે જ્યારે તેની સોય નિયુક્ત એક્ઝિટ સેલ પર પહોંચે.

### 2.2 Tick Order Integration (standard §16.17)
1. Player action resolve થાય છે (દોરો ખેંચવો અથવા Switch/Lever ટેપ કરવું).
2. `moveCount += 1`.
3. Counters tick: M007, M017, M031, M253, M353.
4. **Conveyor & Track Step Execution:**
   - Belt Switch (M701) અને Belt Lever (M703) સ્ટેટ મુજબ કન્વેયર્સ ગતિ કરે છે.
   - Reversing Belts (M702) જો $m \pmod N == 0$ હોય તો દિશા ફ્લિપ કરે છે.
   - બેલ્ટ પર સ્થિત દોરાઓ 1 સેલ આગળ ધકેલાય છે (Push logic).
   - Track Loops (M704) પર દોરાઓ 1 સેલ ઘડિયાળના કાંટા મુજબ ફરે છે.
5. Collision & Blocker updates.
6. Heart loss & Shields resolution.
7. Win condition check.

---

## 3. Limits & Parameters
| Parameter | Phase 15 Budget | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સપોર્ટેડ |
| Thread Paths ($P$) | 28 – 40 threads | Reverse construction & solver verified |
| Max Obstacles ($O$) | 8 – 14 instances | Belt Switches, Reversing Belts, Track Loops |
| Difficulty ($D$) Band | **97 – 113** | Formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ~ 124 | High band × 1.10 |
| L7500 Finale Target | ~ 135 | High band × 1.20 |
| Generation Timeout | $\le 100\text{ ms}$ | Isolate-based background generation |

---

## 4. Rollout Guard
- **Remote Config Key:** `maxPhase`. જો `maxPhase < 15` હોય તો Phase 15 ના તમામ નોડ્સ લૉક રહે છે.
- **Seed Overrides:** જો કોઈ સીડ CI વેરિફિકેશનમાં ફેલ થાય, તો `assets/levels/seed_overrides.json` માં ઓવરરાઈડ નોંધાય છે.


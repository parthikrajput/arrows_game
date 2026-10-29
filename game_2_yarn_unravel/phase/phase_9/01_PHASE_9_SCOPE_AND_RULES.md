# 01 — Phase 9 Scope & Rule Additions
> Phase 9 (L4001–4500) માટે વિગતવાર સ્કોપ અને નિયમો: Split & Merge (Ply & Twist) સિગ્નેચર સિસ્ટમ, દોરાઓનું ડાયનેમિક મર્જિંગ અને સ્પ્લિટિંગ, ઑન-ડિવાઇસ જનરેશન, D band 79–95, ગ્રીડ અને પાથ મર્યાદાઓ.

**Related docs:** [Phase 9 index](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling §2–§7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_4001_4500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_9.md)

---

## 1. Baseline Invariants (અપરિવર્તિત નિયમો)
Phase 9 માં કોર ગેમપ્લે ઇન્વેરિયન્ટ્સ યથાવત રહે છે:
- **Core Loop:** Tap $\to$ Needle Head unravels, blocked $\to$ needle snags (-1 Heart, damped twang $\le 3\text{ kHz}$ spring-back).
- **Turn-based:** કોઈ વૉલ-ક્લોક ટાઈમર નથી; તમામ સ્ટેટ્સ (Twisting Pad, Rejoin Gate, Counters) પ્લેયર મૂવ્સ પર આધાર રાખે છે.
- **0-Hearts Solvable:** દરેક સીડમાંથી જનરેટ થયેલ લેવલ 0 hearts lost અને 0 boosters વડે 100% સોલ્વેબલ હોવું ફરજિયાત છે.
- **Touch Targets:** 360 dp બેઝલાઇન વિન્ડો પર લઘુત્તમ 29 dp સેલ કદ (પિંચ-ઝૂમ અને પાન સાથે).

---

## 2. New Signature System: Split & Merge (Ply & Twist)

### 2.1 Topology of Split Threads
1. **Double Split (M402):**
   - જ્યારે કોઈ થ્રેડનું Needle Head સ્પ્લિટ ટાઇલ પરથી પસાર થાય છે, ત્યારે તે દોરો બે સ્વતંત્ર પાતળા સિંગલ-પ્લાય (Single-Ply) દોરાઓમાં વિભાજીત થાય છે.
   - અગાઉના M029 Split-Ply (કાટખૂણે ડાબે-જમણે વિભાજન) થી વિપરીત, M402 Double Split માં બંને નવા દોરા મૂળ દોરાની દિશા (`dir`) જ જાળવી રાખે છે પરંતુ સમાંતર બે ટ્રેક પર આગળ વધે છે.
2. **Twisting Pad (M401):**
   - ટ્વિસ્ટિંગ પેડ એ 2 સંલગ્ન સેલ્સનું સ્પેશિયલ પેડ છે.
   - જ્યારે બે સુસંગત દોરાઓ (દા.ત. સમાન કલર અથવા સ્પ્લિટ થયેલી જોડી) ની સોય આ બે સેલ્સ પર આવીને અટકે છે, ત્યારે પ્લેયર પેડ પર ટેપ કરીને (1 Move) બંને દોરાઓને એક ડબલ-પ્લાય થ્રેડમાં એકીકૃત (Merge) કરી શકે છે.
   - નવો મર્જ થયેલો દોરો સંયુક્ત લંબાઈ અને અગ્રણી સોયની દિશા ધારણ કરે છે.
3. **Rejoin Gate (M404):**
   - એક વિશિષ્ટ ક્રાફ્ટ ગેટ જે સ્પ્લિટ થયેલા દોરાના બંને અર્ધભાગ સફળતાપૂર્વક તેના પરથી પસાર ન થાય ત્યાં સુધી ખુલે નહીં.

### 2.2 Tick Order Integration (standard §16.17)
1. Player action resolve થાય છે (દોરો ખેંચવો અથવા Twisting Pad ટેપ કરવું).
2. `moveCount += 1`.
3. Counters tick: M007, M017, M031, M253, M353.
4. Split & Merge resolution:
   - સ્પ્લિટર્સ પરથી પસાર થતા દોરાઓ નવા પ્લીસ (plys) બનાવે છે.
   - મર્જ પેડ ટેપ થતાં બંને દોરા જોડી એક સંયુક્ત પાથ ધારણ કરે છે.
5. Gates & Locks update:
   - Stitch Locks (M403) કી દોરાના એક્ઝિટ પછી અનલૉક થાય છે.
   - Rejoin Gates (M404) બંને પ્લીસ પાસ થયાની ચકાસણી કરીને સ્ટેટ ઓપન કરે છે.
6. Heart loss & Shields resolution.
7. Win condition check (બધા દોરા બોર્ડ બહાર અનરૅવલ).

---

## 3. Limits & Parameters
| Parameter | Phase 9 Budget | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સપોર્ટેડ |
| Thread Paths ($P$) | 28 – 40 threads | Reverse construction & solver verified |
| Max Obstacles ($O$) | 8 – 14 instances | Twisting Pads, Rejoin Gates, Stitch Locks |
| Difficulty ($D$) Band | **79 – 95** | Formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ~ 104 | High band × 1.10 |
| L4500 Finale Target | ~ 114 | High band × 1.20 |
| Generation Timeout | $\le 100\text{ ms}$ | Isolate-based background generation |

---

## 4. Rollout Guard
- **Remote Config Key:** `maxPhase`. જો `maxPhase < 9` હોય તો Phase 9 ના તમામ નોડ્સ લૉક રહે છે.
- **Seed Overrides:** જો કોઈ સીડ CI વેરિફિકેશનમાં ફેલ થાય, તો `assets/levels/seed_overrides.json` માં ઓવરરાઈડ નોંધાય છે.


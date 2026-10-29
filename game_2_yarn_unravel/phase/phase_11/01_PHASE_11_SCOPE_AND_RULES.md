# 01 — Phase 11 Scope & Rule Additions
> Phase 11 (L5001–5500) માટે વિગતવાર સ્કોપ અને નિયમો: Linked Boards (Twin Hoops) સિગ્નેચર સિસ્ટમ, બે જોડાયેલા મિની બોર્ડ્સ વચ્ચે દોરાઓનું ટ્રાન્ઝિશન, સીમ એજ અને ક્રોસ-હૂપ મિકેનિક્સ, ઑન-ડિવાઇસ જનરેશન, D band 85–101, ગ્રીડ અને પાથ મર્યાદાઓ.

**Related docs:** [Phase 11 index](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling §2–§7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_5001_5500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_11.md)

---

## 1. Baseline Invariants (અપરિવર્તિત નિયમો)
Phase 11 માં કોર ગેમપ્લે ઇન્વેરિયન્ટ્સ યથાવત રહે છે:
- **Core Loop:** Tap $\to$ Needle Head unravels, blocked $\to$ needle snags (-1 Heart, damped twang $\le 3\text{ kHz}$ spring-back).
- **Turn-based:** કોઈ વૉલ-ક્લોક ટાઈમર નથી; બંને હૂપ્સ પર પ્લેયર પોતાની ગતિએ વિચારીને ટેપ કરે છે.
- **0-Hearts Solvable:** દરેક સીડમાંથી જનરેટ થયેલ લેવલ 0 hearts lost અને 0 boosters વડે 100% સોલ્વેબલ હોવું ફરજિયાત છે.
- **Touch Targets:** 360 dp બેઝલાઇન વિન્ડો પર લઘુત્તમ 29 dp સેલ કદ (ટ્વીન હૂપ વ્યૂ માટે સ્માર્ટ ઓટો-ફ્રેમિંગ અને પિંચ-ઝૂમ).

---

## 2. New Signature System: Linked Boards (Twin Hoops)

### 2.1 Twin Hoops Architecture
1. **Dual Boards (Hoop A & Hoop B):**
   - સ્ક્રીન પર બે સ્વતંત્ર મિની એમ્બ્રોઇડરી હૂપ્સ (Hoop A ડાબે/ઉપર, Hoop B જમણે/નીચે) દેખાય છે. દરેક બોર્ડ સામાન્ય રીતે 8×8 થી 10×10 સેલ્સનું કદ ધરાવે છે.
2. **Seam Edge (M501):**
   - બે હૂપ્સ વચ્ચેની સમાન સરહદ પર સીવેલો ટાંકો (Seam Edge).
   - જ્યારે કોઈ દોરાની પુલ લાઇન Hoop A ની સીમ એજમાંથી બહાર નીકળે છે, ત્યારે તે સીધો બોર્ડ બહાર જવાને બદલે Hoop B ની સંલગ્ન રો/કૉલમ સેલમાંથી તે જ દિશામાં આગળ વધે છે!
3. **Cross Charm (M502):**
   - Hoop A પર રહેલી કી (Charm) Hoop B પર રહેલા ક્રાફ્ટ ક્લેસ્પને કાયમી ધોરણે ખોલે છે.
4. **Mirror Hoop (M503):**
   - Hoop A ના ચોક્કસ દોરા સાથે Hoop B નો ટ્વીન દોરો સંકળાયેલો છે. એક દોરા પર ટેપ કરતાં બંને હૂપ્સ પર એકસાથે એક્શન થાય છે (જો કોઈ એક પણ બ્લોક હોય તો બંને સ્નેગ થાય છે, પરંતુ કુલ -1 Heart જ ગુમાવાય છે).
5. **Relay Pompom (M504):**
   - પોમપોમ પોર્ટલ જોડી જે એક હૂપથી બીજા હૂપ સુધી વિસ્તરેલી છે (Hoop A માં એન્ટર, Hoop B માંથી એક્ઝિટ).

### 2.2 Tick Order Integration (standard §16.17)
1. Player action resolve થાય છે (Hoop A અથવા Hoop B પર ટેપ).
2. `moveCount += 1`.
3. Counters tick: M007, M017, M031, M253, M353.
4. Cross-board Transitions:
   - Seam Edge (M501) પરથી પસાર થતો દોરો લક્ષ્ય હૂપ પર નિર્ધારિત સેલમાં પ્રોજેક્ટ થાય છે.
   - Mirror Hoop (M503) ટ્વીન દોરાઓ એકસાથે મૂવ થાય છે.
5. Gates & Clasps update:
   - Cross Charm (M502) અનલૉક થાય છે અને વિરોધી હૂપ પરનો ગેટ ખુલે છે.
6. Heart loss & Shields resolution.
7. Win condition check (બંને હૂપ્સ સંપૂર્ણપણે અનરૅવલ થાય ત્યારે જ લેવલ ક્લિયર થાય છે).

---

## 3. Limits & Parameters
| Parameter | Phase 11 Budget | નોંધ |
|---|---|---|
| Grid Size | Dual 8×8 to 10×10 (કુલ 128–200 cells) | Combined area ~ 12×12 to 14×14 |
| Thread Paths ($P$) | 28 – 40 threads (કુલ બંને હૂપ્સમાં) | Reverse construction & solver verified |
| Max Obstacles ($O$) | 8 – 14 instances | Seam Edges, Cross Charms, Relay Pompoms |
| Difficulty ($D$) Band | **85 – 101** | Formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ~ 111 | High band × 1.10 |
| L5500 Finale Target | ~ 121 | High band × 1.20 |
| Generation Timeout | $\le 100\text{ ms}$ | Isolate-based background generation |

---

## 4. Rollout Guard
- **Remote Config Key:** `maxPhase`. જો `maxPhase < 11` હોય તો Phase 11 ના તમામ નોડ્સ લૉક રહે છે.
- **Seed Overrides:** જો કોઈ સીડ CI વેરિફિકેશનમાં ફેલ થાય, તો `assets/levels/seed_overrides.json` માં ઓવરરાઈડ નોંધાય છે.


# 01 — Phase 19 Scope & Rule Additions
> Phase 19 (L9001–9500) માટે વિગતવાર સ્કોપ અને નિયમો: Remix B (Phases 7–12 Synergies) સિગ્નેચર સિસ્ટમ, ડેટા-ડ્રિવન મિકેનિક્સ, ઑન-ડિવાઇસ જનરેશન, D band 109–125, ગ્રીડ અને પાથ મર્યાદાઓ.

**Related docs:** [Phase 19 index](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling §2–§7, §10.3](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_9001_9500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_19.md)

---

## 1. Baseline Invariants (અપરિવર્તિત નિયમો)
Phase 19 માં કોર ગેમપ્લે ઇન્વેરિયન્ટ્સ યથાવત રહે છે:
- **Core Loop:** Tap $\to$ Needle Head unravels, blocked $\to$ needle snags (-1 Heart, damped twang $\le 3\text{ kHz}$ spring-back).
- **Turn-based:** કોઈ વૉલ-ક્લોક ટાઈમર નથી; રોટેશન, ગ્રોથ અને ગ્રેવિટી પ્લેયરના દરેક વેલિડ મૂવ સાથે જ અપડેટ થાય છે.
- **0-Hearts Solvable:** દરેક સીડમાંથી જનરેટ થયેલ લેવલ 0 hearts lost અને 0 boosters વડે 100% સોલ્વેબલ હોવું ફરજિયાત છે.
- **Touch Targets:** 360 dp બેઝલાઇન વિન્ડો પર લઘુત્તમ 29 dp સેલ કદ (પિંચ-ઝૂમ અને પાન સાથે).

---

## 2. Signature System: Remix B (Phases 7 to 12 Synergy)

### 2.1 Candidate Pool & Synergies (§10.3)
Remix B એ તબક્કા 7 થી 12 ની અદ્યતન યાંત્રિક પ્રણાલીઓનું સંકલન છે:
1. **Selection Rule:** ઉમેદવાર પૂલમાંથી એવા 4 મિકેનિક્સ પસંદ થાય છે જે પ્લેયર સંતોષ અને સોલ્વર પરફોર્મન્સનું સંતુલન જાળવે.
2. **Candidate Pool:**
   - **M901 — Twirl Weighted Thread:** Rotation (P7) + Gravity (P12). ભારે દોરો જે દરેક મૂવ પછી 90° CW દિશા ફેરવે છે અને પછી ગ્રેવિટી દિશામાં 1 સેલ સ્લાઇડ થાય છે.
   - **M902 — Ivy Hoop Rotor:** Growth (P8) + Rotation (P7). 4×4 રોટર જેના પર આઇવી ગ્રોથ રૂટ્સ છે; રોટેશનથી ગ્રોથ નવી દિશામાં સ્પ્રાઉટ થાય છે.
   - **M903 — Rhythm Belt:** Conveyors (P15) + Sequencing (P10). કન્વેયર જે માત્ર મેટ્રોનોમ રિધમ બીટ પર જ ચાલે છે (ઓન-બીટ પર 1 સેલ ગતિ, ઓફ-બીટ પર પોઝ).
   - **M904 — Seam Edge Split:** Linked Boards (P11) + Split & Merge (P9). બે હૂપ્સ વચ્ચેની સીમ એજમાંથી પસાર થતાં જ દોરો આપોઆપ બે અર્ધભાગોમાં વહેંચાઈને બોર્ડ B માં પ્રવેશે છે.

### 2.2 Tick Order Integration (standard §16.17)
1. Player action resolve થાય છે (દોરો ખેંચવો / રોટર ટેપ).
2. `moveCount += 1`.
3. Counters tick: M007, M017, M031, M253, M353.
4. **Remix B Multi-System Resolution:**
   - Rotations & Twirls resolve થાય છે.
   - Gravity shifts & Weighted thread translations.
   - Organic Ivy growth expands ($U \to R \to D \to L$).
   - Seam Edge cross-board splits.
5. Gates, clasps & locks update.
6. Heart loss & Shields resolution.
7. Win condition check.

---

## 3. Limits & Parameters
| Parameter | Phase 19 Budget | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સપોર્ટેડ |
| Thread Paths ($P$) | 28 – 40 threads | Reverse construction & solver verified |
| Max Obstacles ($O$) | 8 – 14 instances | Combo mechanics from candidate pool |
| Difficulty ($D$) Band | **109 – 125** | Formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ~ 137 | High band × 1.10 |
| L9500 Finale Target | ~ 150 | High band × 1.20 |
| Generation Timeout | $\le 100\text{ ms}$ | Isolate-based background generation |

---

## 4. Rollout Guard
- **Remote Config Key:** `maxPhase`. જો `maxPhase < 19` હોય તો Phase 19 ના તમામ નોડ્સ લૉક રહે છે.
- **Seed Overrides:** જો કોઈ સીડ CI વેરિફિકેશનમાં ફેલ થાય, તો `assets/levels/seed_overrides.json` માં ઓવરરાઈડ નોંધાય છે.

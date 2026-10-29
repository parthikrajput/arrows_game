# 01 — Phase 20 Scope & Rule Additions
> Phase 20 (L9501–10,000) માટે વિગતવાર સ્કોપ અને નિયમો: Grand Master (The Endless Tapestry) સિગ્નેચર સિસ્ટમ, L10,000 Grand Finale, પોસ્ટ-10,000 એન્ડગેમ, ઑન-ડિવાઇસ જનરેશન, D band 112–128, ગ્રીડ અને પાથ મર્યાદાઓ.

**Related docs:** [Phase 20 index](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling §2–§7, §9](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_9501_10000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_20.md)

---

## 1. Baseline Invariants (અપરિવર્તિત નિયમો)
Phase 20 માં કોર ગેમપ્લે ઇન્વેરિયન્ટ્સ યથાવત રહે છે:
- **Core Loop:** Tap $\to$ Needle Head unravels, blocked $\to$ needle snags (-1 Heart, damped twang $\le 3\text{ kHz}$ spring-back).
- **Turn-based:** કોઈ વૉલ-ક્લોક ટાઈમર નથી; સમગ્ર ગ્રાન્ડ માસ્ટર પઝલમાં તમામ સ્ટેટ્સ અને મૂવિંગ ગાર્ડિયન્સ પ્લેયરના દરેક માન્ય મૂવ પર જ એડવાન્સ થાય છે.
- **0-Hearts Solvable:** દરેક સીડમાંથી જનરેટ થયેલ લેવલ (સહિત L10,000) 0 hearts lost અને 0 boosters વડે 100% સોલ્વેબલ હોવું ફરજિયાત છે.
- **Touch Targets:** 360 dp બેઝલાઇન વિન્ડો પર લઘુત્તમ 29 dp સેલ કદ (પિંચ-ઝૂમ અને પાન સાથે).

---

## 2. Signature System: The Endless Tapestry (All Systems Synthesis)

### 2.1 The Grand Master Mechanics
Phase 20 એ Yarn Unravel ના 10,000 લેવલ્સનું શિખર છે:
1. **M951 — Moving Guardian (Living Tapestry):**
   - 2×2 બોસ પિનકુશન જે સ્થિર રહેવાને બદલે દર $N$ મૂવ્સ પછી ક્રાફ્ટ બોર્ડ પર 1 સેલ આગળ ખસે છે (નિર્ધારિત લૂપ અથવા પાથ પર). જ્યારે તેનું HP 0 થાય ત્યારે તે કાયમી સ્થિર થઈને અદૃશ્ય થાય છે.
2. **M952 — Omni Gate (Chromatic Prism Gate):**
   - સર્વવ્યાપી ક્રાફ્ટ ગેટ જે તમામ કલર્સ અને સ્ટેટ્સ (Day/Night, Prism, Sequence) નું સંગમ છે; નિર્ધારિત મલ્ટિ-કન્ડીશન પૂરી થતાં જ ખુલે છે.
3. **M953 — Grand Loom Spool (Infinity Bobbin):**
   - અનંત બોબિન સ્લીવ જેમાંથી એક સાથે મલ્ટિપલ દોરાઓ બહાર આવે છે અને પ્લેયર કાળજીપૂર્વક તેમનો ક્રમ નક્કી કરે છે.
4. **M954 — Master Weaver Key (Grand Skeleton Charm):**
   - અંતિમ સુવર્ણ કી જે બોર્ડ પર રહેલા કોઈપણ જટિલ લૉકને અનલૉક કરવાની શક્તિ ધરાવે છે.

### 2.2 Level 10,000 Grand Finale Architecture
- **Board Composition:**
  - 14×14 સર્વોચ્ચ ક્રાફ્ટ બોર્ડ.
  - અગાઉની તમામ સિગ્નેચર સિસ્ટમ્સનું એક-એક પ્રતિનિધિત્વ (Day & Night લૂમ સાયકલ, મલ્ટિ-ફ્લોર ઓર્ગેન્ઝા વિન્ડો, સ્લાઇડિંગ સાટિન ક્રેટ્સ, પ્રિઝમ લાઈટ બીમ, 4×4 રોટર, આઇવી વેલાઓ, સ્પ્લિટ-પ્લાય થ્રેડ, રિધમિક મેટ્રોનોમ, લિંક્ડ ટ્વીન હૂપ્સ, પ્લમ્બ ઓળંબો, વૂલ ફ્લફ ફોગ, મિરર સીમ, ફીડ ડોગ બેલ્ટ, ચાર્મ ક્રાફ્ટિંગ અને Moving Guardian).
- **Target Difficulty:** $D \approx 154$ ($128 \times 1.20$).
- **Solvability:** CI માં વિશિષ્ટ ડીપ સર્ચ દ્વારા પૂર્વ-પ્રમાણિત (0 hearts, 0 boosters).

---

## 3. Limits & Parameters
| Parameter | Phase 20 Budget | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સપોર્ટેડ |
| Thread Paths ($P$) | 28 – 40 threads | Reverse construction & solver verified |
| Max Obstacles ($O$) | 8 – 14 instances | Grand Master mix elements |
| Difficulty ($D$) Band | **112 – 128** | Formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ~ 140 | High band × 1.10 |
| L10,000 Finale Target | ~ 154 | High band × 1.20 |
| Generation Timeout | $\le 100\text{ ms}$ | Isolate-based background generation |

---

## 4. Rollout Guard & Post-L10000 State
- **Remote Config Key:** `maxPhase`. જો `maxPhase < 20` હોય તો Phase 20 ના નોડ્સ લૉક રહે છે.
- **Endgame State:** L10,000 જીત્યા પછી મેપ પર "Grand Master Weaver" કાયમી સન્માન દર્શાવાય છે, અને પ્લેયર માટે અનંત પ્રક્રિયાગત ડેઇલી અને વિક્લી ચેલેન્જીસ ચાલુ રહે છે.

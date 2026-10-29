# 01 — Phase 12 Scope & Rule Additions
> Phase 12 (L5501–6000) માટે વિગતવાર સ્કોપ અને નિયમો: Gravity (Hanging Loom) સિગ્નેચર સિસ્ટમ, પ્લમ્બ લીવર્સ, ડ્રોપિંગ બટન્સ ફિઝિક્સ, વેઇટેડ થ્રેડ્સ, ઑન-ડિવાઇસ જનરેશન, D band 88–104, ગ્રીડ અને પાથ મર્યાદાઓ.

**Related docs:** [Phase 12 index](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling §2–§7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_5501_6000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_12.md)

---

## 1. Baseline Invariants (અપરિવર્તિત નિયમો)
Phase 12 માં કોર ગેમપ્લે ઇન્વેરિયન્ટ્સ યથાવત રહે છે:
- **Core Loop:** Tap $\to$ Needle Head unravels, blocked $\to$ needle snags (-1 Heart, damped twang $\le 3\text{ kHz}$ spring-back).
- **Turn-based:** કોઈ વૉલ-ક્લોક ટાઈમર નથી; ગુરુત્વાકર્ષણ આધારિત સ્લાઇડ્સ અને ફૉલ માત્ર પ્લેયરના વેલિડ મૂવ પછી જ એક્ઝિક્યુટ થાય છે.
- **0-Hearts Solvable:** દરેક સીડમાંથી જનરેટ થયેલ લેવલ 0 hearts lost અને 0 boosters વડે 100% સોલ્વેબલ હોવું ફરજિયાત છે.
- **Touch Targets:** 360 dp બેઝલાઇન વિન્ડો પર લઘુત્તમ 29 dp સેલ કદ (પિંચ-ઝૂમ અને પાન સાથે).

---

## 2. New Signature System: Gravity (Hanging Loom)

### 2.1 Gravity Directions & Physics
1. **Gravity States:**
   - બોર્ડ પર 4 દિશાઓમાં ગુરુત્વાકર્ષણ લાગુ થઈ શકે છે: $\text{Down} \downarrow$, $\text{Up} \uparrow$, $\text{Left} \leftarrow$, $\text{Right} \rightarrow$. ડિફોલ્ટ સ્ટેટ $\text{Down} \downarrow$ છે.
2. **Plumb Lever (M551):**
   - બોર્ડ પર આવેલો વૂડન પ્લમ્બ લીવર (ઓળંબો). પ્લેયર આ લીવર પર ટેપ કરીને (1 Move) ગુરુત્વાકર્ષણની દિશા બદલી શકે છે.
3. **Dropping Buttons (M552):**
   - લૂઝ વૂડન બટન્સ. દરેક મૂવ પછી સક્રિય ગુરુત્વાકર્ષણની દિશામાં આગળ સ્લાઇડ થાય છે જ્યાં સુધી કોઈ અવરોધ, દિવાલ કે દોરાના શરીર સાથે અથડાઈને અટકે નહીં.
4. **Float Patch (M553):**
   - બોર્ડ પર ગૂંથેલો એન્ટિ-ગ્રેવિટી પેચ. આ પેચ પર રહેલું કોઈપણ બટન કે દોરો ગુરુત્વાકર્ષણથી અપ્રભાવિત રહે છે અને પડતું નથી.
5. **Weighted Thread (M554):**
   - ભારે ધાતુના તાર સાથે વણાયેલો દોરો. દરેક મૂવ પછી તે ગુરુત્વાકર્ષણની દિશામાં 1 સેલ સરકે છે જો તેની તમામ લક્ષિત સેલ્સ ખાલી હોય.

### 2.2 Tick Order Integration (standard §16.17)
1. Player action resolve થાય છે (દોરો ખેંચવો અથવા Plumb Lever ટેપ કરવું).
2. `moveCount += 1`.
3. Counters tick: M007, M017, M031, M253, M353.
4. **Gravity Step Execution:**
   - Weighted Threads (M554) ગુરુત્વાકર્ષણ દિશામાં 1 સેલ ટ્રાન્સલેટ થાય છે (જો ગંતવ્ય ખાલી હોય).
   - Dropping Buttons (M552) ગુરુત્વાકર્ષણ દિશામાં સતત સ્લાઇડ થઈને બ્લોક ન થાય ત્યાં સુધી ગબડે છે (સિવાય કે Float Patch M553 પર હોય).
5. Obstacles & Collision resolution:
   - સ્લાઇડ થયેલા બટન્સ સ્થિર થઈને સિંગલ બ્લોકર તરીકે સ્થાન ગ્રહણ કરે છે.
6. Heart loss & Shields resolution.
7. Win condition check.

---

## 3. Limits & Parameters
| Parameter | Phase 12 Budget | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સપોર્ટેડ |
| Thread Paths ($P$) | 28 – 40 threads | Reverse construction & solver verified |
| Max Obstacles ($O$) | 8 – 14 instances | Plumb Levers, Dropping Buttons, Float Patches |
| Difficulty ($D$) Band | **88 – 104** | Formula: $0.6P + 1.5C + 2.0O + 3.0N + 1.0S$ |
| x9 Hard Target | ~ 114 | High band × 1.10 |
| L6000 Finale Target | ~ 125 | High band × 1.20 |
| Generation Timeout | $\le 100\text{ ms}$ | Isolate-based background generation |

---

## 4. Rollout Guard
- **Remote Config Key:** `maxPhase`. જો `maxPhase < 12` હોય તો Phase 12 ના તમામ નોડ્સ લૉક રહે છે.
- **Seed Overrides:** જો કોઈ સીડ CI વેરિફિકેશનમાં ફેલ થાય, તો `assets/levels/seed_overrides.json` માં ઓવરરાઈડ નોંધાય છે.


# 01 — Phase 18 Scope & Rule Changes (ફેઝ 18 નિયમો)
> Levels 8501–9000 માટે Remix A (Garden Festival I) ના નિયમો, હાઇબ્રિડ મિકેનિક્સ, પેરેન્ટ રૂલ કમ્પોઝિશન અને Phase 18 limits.

**Related docs:** [Phase 18 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 18 (નવું શું છે)
1. **Remix A: Garden Festival I (Systems of Phases 1 to 6):**
   - અગાઉના સફળ 6 ફેઝિસની સિસ્ટમ્સ (Cycles, Multi-floor, Push Physics+, Light & Beams+) નું ગાણિતિક સંયોજન:
     - **Day-Night Terrace (M851):** Cycles (Phase 3) × Multi-floor (Phase 4). આ સીડીઓ માત્ર દિવસ (State A) દરમિયાન જ ઉપલા માળે લઈ જાય છે; રાત્રે (State B) સામાન્ય જમીન બની જાય છે.
     - **Sunlit Acorn (M852):** Push Physics+ (Phase 5) × Light & Beams+ (Phase 6). એકોર્ન પુશ બ્લોક જેના પર સોનેરી લેન્સ લાગેલો છે; ધકેલાય તે સ્થાન પરથી તે સૂર્યકિરણને નવી દિશામાં પરાવર્તિત કરે છે.
     - **Shaded Stairs (M853):** Beams (Phase 6) × Multi-floor (Phase 4). સીડીઓ છાંયડામાં ઢંકાયેલી હોય છે; સૂર્યકિરણ પડે ત્યારે જ તે બીજા માળે જવા માટે અનલૉક થાય છે.
     - **Dawn Marble (M854):** Cycles (Phase 3) × Push (Phase 5). ઝાકળની લખોટી જે દિવસના સ્ટેટમાં લૉન પર સરકે છે અને રાતના સ્ટેટમાં સ્થિર પથ્થર બની જાય છે.
2. **Composition Rule Principle:**
   - કોઈ નવું પ્રિમિટિવ એલિમેન્ટ ઉમેરાતું નથી; નિયમ બંને પેરેન્ટ મિકેનિક્સના નિયમોનું સીધું ગાણિતિક જોડાણ છે ($Rule_{\text{combo}} = Rule_A \circ Rule_B$).
3. **4 Data-Driven Combo Mechanics (M851–M854):**
   - Day-Night Terrace (M851), Sunlit Acorn (M852), Shaded Stairs (M853), Dawn Marble (M854).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per floor (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 18`: Phase 18 content unlock કરવા માટે.
- `p18_combo_selection_version = 1`: Analytics data selection snapshot ID.

# 01 — Phase 19 Scope & Rule Changes (ફેઝ 19 નિયમો)
> Levels 9001–9500 માટે Remix B (Garden Festival II) ના નિયમો, કાઇનેટિક હાઇબ્રિડ્સ, ગ્રેવિટી-રોટેશન અને Phase 19 limits.

**Related docs:** [Phase 19 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 19 (નવું શું છે)
1. **Remix B: Garden Festival II (Systems of Phases 7 to 12):**
   - મધ્ય-ગાળાના અદ્યતન 6 ફેઝિસ (Rotation, Growth, Split/Merge, Sequencing, Linked Boards, Gravity) નું સંયોજન:
     - **Falling Vines (M901):** Growth (Phase 8) × Gravity (Phase 12). જીવંત વેલો દર થોડા Moves એ ઉગે છે અને સાથે-સાથે ગુરુત્વાકર્ષણની દિશામાં સરકીને નીચેની લેન્સ બ્લોક કરે છે.
     - **Rhythm Rotor (M902):** Sequencing (Phase 10) × Rotation (Phase 7). ટર્નટેબલ જે પ્લેયર ટેપ કર્યા વગર પણ દર $P$ Moves ના રિધમિક મોડ્યુલો પર આપમેળે $90^\circ$ CW ફરે છે.
     - **Twin-Garden Fork (M903):** Linked Boards (Phase 11) × Split/Merge (Phase 9). ફોર્ક ટ્વિગ બોર્ડ A પર સ્થિત છે; લાઈન વિભાજિત થતાં એક અર્ધભાગ બોર્ડ A માં રહે છે અને બીજો અર્ધભાગ બોર્ડ લિંક દ્વારા બોર્ડ B માં પ્રવેશે છે.
     - **Gravity Turntable (M904):** Rotation (Phase 7) × Gravity (Phase 12). ટર્નટેબલની અંદર રહેલા ઘટકો તેના $90^\circ$ રોટેશન સાથે ગ્રેવિટી વેક્ટરની નવી દિશામાં સ્લાઇડ થાય છે.
2. **Deterministic Multi-System Resolution:**
   - પહેલા પ્લેયરનો મૂવ $\implies$ પછી ટર્નટેબલ/રોટર શિફ્ટ $\implies$ પછી ગ્રેવિટી સ્લાઇડ $\implies$ પછી ગ્રોથ સ્પ્રેડ (Standard §16.17 ટિક ક્રમ).
3. **4 Data-Driven Combo Mechanics (M901–M904):**
   - Falling Vines (M901), Rhythm Rotor (M902), Twin-Garden Fork (M903), Gravity Turntable (M904).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 19`: Phase 19 content unlock કરવા માટે.
- `p19_combo_selection_version = 1`: Analytics data selection snapshot ID.

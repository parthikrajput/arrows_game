# 01 — Phase 7 Scope & Rule Changes (ફેઝ 7 નિયમો)
> Levels 3001–3500 માટે Rotation (Whirling Garden) ના નિયમો, સબ-ગ્રીડ ટર્નટેબલ્સ, સ્પિનિંગ લાઈનો, પેરિમીટર શિફ્ટિંગ અને Phase 7 limits.

**Related docs:** [Phase 7 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 7 (નવું શું છે)
1. **Rotation (Whirling Garden):**
   - બોર્ડ પરના ઘટકો અને લાઈનોની દિશાઓ ભૌમિતિક રીતે 90° ક્લોકવાઇઝ ફરે છે:
     - **Flower-Bed Turntable (M301):** કંટ્રોલ બટન ટેપ કરવાથી ($1$ Move) નિર્ધારિત $4\times 4$ કે $5\times 5$ સબ-રીજનની તમામ લાઈનો અને મિકેનિક્સ 90° CW ફરે છે.
     - **Turning Hedge (M302):** બોર્ડની સરહદ (perimeter) પરની હેજ દીવાલ દર $N$ Moves એ 1 સેગમેન્ટ ક્લોકવાઇઝ આગળ ખસે છે.
     - **Spinning Top Line (M303):** એવી વિશિષ્ટ લાઈન જે દરેક ટર્નમાં (જો તે પોતે ન ખસી હોય તો) તેની દિશા 90° CW બદલે છે.
     - **Pinned Daisy (M304):** જમીનમાં ઊંડે જડાયેલ ડેઇઝી ધરાવતી લાઈન જે કોઈપણ રોટેશનથી મુક્ત છે; જો તે કોઈ ટર્નટેબલની અંદર હોય તો તે ટર્નટેબલ લૉક રહે છે.
2. **Sub-Grid Coordinate Transforms:**
   - રીજન રોટેશન સ્થાનિક કોઓર્ડિનેટ સેન્ટર $(x_c, y_c)$ ની આસપાસ $90^\circ$ CW મેટ્રિક્સ પર ગણવામાં આવે છે: $(x', y') = (y - y_c + x_c, -(x - x_c) + y_c)$.
3. **4 New Base Mechanics (M301–M304):**
   - Flower-Bed Turntable (M301), Turning Hedge (M302), Spinning Top Line (M303), Pinned Daisy (M304).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 7`: Phase 7 content unlock કરવા માટે.
- `p7_turntable_anim_ms = 250`: Rotation visual animation duration.

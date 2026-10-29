# 01 — Phase 12 Scope & Rule Changes (ફેઝ 12 નિયમો)
> Levels 5501–6000 માટે Gravity (Falling Leaves) ના નિયમો, પવન દિશા-સૂચક લીવર, પડતાં એકોર્ન, એન્ટિ-ગ્રેવિટી ટાઇલ્સ અને Phase 12 limits.

**Related docs:** [Phase 12 README](./README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)
- Turn-based, deterministic forward simulation (30s Golden Nectar Rush સિવાય કોઈ timer નથી).
- 3 Hearts per attempt; bonk = −1 Heart; 1 ad revive per level; Honey Heart Refill 120 coins (max 2/attempt).
- Boosters: Nectar Glow Hint, Queen's Royal Shield, Leaf Blower, અને free Scent Trail Preview યથાવત્.
- Layer rules: Ants (ground), Worker Bees (air), Canopy Scout Bees (canopy).
- 0 hearts lost અને 0 boosters required (CI solver verified).

## 2. What's New in Phase 12 (નવું શું છે)
1. **Gravity (Falling Leaves):**
   - સમગ્ર બગીચામાં એક વૈશ્વિક ગુરુત્વાકર્ષણ વેક્ટર (Up, Down, Left, Right) સક્રિય હોય છે:
     - **Wind-Vane Lever (M551):** કંટ્રોલ લીવર ટેપ કરવાથી ($1$ Move) સમગ્ર બોર્ડનું ગુરુત્વાકર્ષણ U, D, L, R માં ફરે છે.
     - **Falling Acorns (M552):** લૂઝ બ્લોકર; દરેક Move પછી ગુરુત્વાકર્ષણની દિશામાં 1 સેલ નીચે/આગળ પડે છે જ્યાં સુધી કોઈ અવરોધ ન મળે.
     - **Dandelion Puff Tile (M553):** એન્ટિ-ગ્રેવિટી ટાઇલ; તેના પર રહેલી કોઈપણ વસ્તુ કે લાઈન ક્યારેય નીચે પડતી નથી (તરતી રહે છે).
     - **Heavy Beetle Line (M554):** વજનદાર કીડી લાઈન; જો તેની આગળ રસ્તો ખાલી હોય તો દરેક Move પછી આખી લાઈન ગુરુત્વાકર્ષણ દિશામાં 1 સેલ સરકે છે (મધમાખીઓ ઉડે છે એટલે ગુરુત્વાકર્ષણથી મુક્ત છે).
2. **Deterministic Settlement Order:**
   - પ્લેયરના Move પછી ટિક ઓર્ડર (Standard §16.17) મુજબ તમામ મુક્ત બ્લોકર્સ અને ભારે કીડીઓ એકસાથે 1 સેલ ગ્રેવિટી દિશામાં શિફ્ટ થાય છે.
3. **4 New Base Mechanics (M551–M554):**
   - Wind-Vane Lever (M551), Falling Acorns (M552), Dandelion Puff Tile (M553), Heavy Beetle Line (M554).

## 3. Limits & Difficulty Plateau
- **Grid Limits:** 12×12 થી 14×14 per board (Pinch-zoom / Pan ઉપલબ્ધ).
- **Line Count:** 28 થી 40 lines across all active layers.
- **Obstacle Count:** 8 થી 14 instances.
- **Difficulty Band:** Fixed plateau **D 60–76**.

## 4. Remote Config Keys
- `maxPhase = 12`: Phase 12 content unlock કરવા માટે.
- `p12_gravity_slide_anim_ms = 150`: Gravity fall animation duration.


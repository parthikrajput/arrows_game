# 01 · Phase 12 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 12 (Levels 5501–6000) ના નિયમો, Gravity (Hill Line) signature system, ટિલ્ટ લીવર, લૂઝ ક્રેટ્સની ગતિ, એન્ટિ-ગ્રેવ પેડ્સ અને Remote Config keys.

**Related docs:** [Phase 12 README](./README.md) · [Shared Core Standard §11, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [03 Signature System](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md)

---

## 1. Scope (પ્રમાણ)
Phase 12 એ Toy Trains નું બારમું content update છે જે Levels 5501 થી 6000 સુધી વિસ્તરે છે.

| પરિમાણ | Phase 11 (5001–5500) | Phase 12 (5501–6000) |
|---|---|---|
| Levels | 5001–5500 | **5501–6000 (On-device generated via seed)** |
| Signature System | Twin Tables (Linked Boards) | **Hill Line (Gravity Physics)** |
| Directional Tilt | None | **Tilt Lever (M551) switches gravity dir (U, R, D, L)** |
| Sliding Blockers | Static crates / pits | **Loose Crates (M552) slide along gravity until blocked** |
| Floating Mechanics| None | **Balloon Pad (M553) suspends items against gravity** |
| Autonomous Rolling| Normal trains | **Ballast Train (M554) rolls along gravity if clear** |
| Difficulty Range | Fixed Plateau D 60–76 | **Fixed Plateau D 60–76** (Standard §17.24) |
| Board Grids | Dual 8×8 to 9×9 Sub-boards | **12×12 થી 14×14 Single Sloped Board** |
| Trains Count | 34–46 trains | **34–46 trains** |

---

## 2. Signature System: Hill Line (`S12` Rules)
1. **Tilt Lever (M551 Gravity Lever):**
   - ટ્રેક પર આવેલો લાકડાનો ટિલ્ટ લીવર. ખેલાડી આ લીવર પર ટેપ કરે છે (1 Move).
   - ટેપ કરવાથી બોર્ડની ગુરુત્વાકર્ષણ (ઢાળ) ની દિશા $90^\circ$ ક્લોકવાઇઝ ફરે છે (`Down -> Left -> Up -> Right`).
   - HUD પર ઢાળની દિશા દર્શાવતો ગોલ્ડન સ્લોપ એરો (Compass) તુરંત અપડેટ થાય છે.
2. **Loose Crates (M552 Falling Blockers):**
   - મુક્ત લાકડાના કાર્ગો ક્રેટ્સ. પ્રત્યેક મૂવ પછી (Step 3 tick માં), આ ક્રેટ્સ ગુરુત્વાકર્ષણની દિશામાં 1 સેલ સરકે છે જો તેમની આગળનો સેલ ખાલી હોય.
   - જો આગળ કોઈ દીવાલ, અન્ય ક્રેટ કે ટ્રેન હોય, તો ક્રેટ ત્યાં જ અટકી જાય છે. ટ્રેન ક્રેટ સાથે અથડાતાં −1 Heart ગુમાવે છે.
3. **Balloon Pad (M553 Anti-grav Tile):**
   - ગરમ હવાના ફુગ્ગાનું પ્રતીક ધરાવતી સ્પેશિયલ ગાદી ટાઇલ.
   - જ્યારે કોઈ ક્રેટ સરકીને આ પેડ પર આવે છે, ત્યારે તે હવામાં સ્થિર (સસ્પેન્ડ) થઈ જાય છે અને ગુરુત્વાકર્ષણ હોવા છતાં આગળ સરકતો નથી જ્યાં સુધી કોઈ ટ્રેન તેને પુશ ન કરે.
4. **Ballast Train (M554 Weight Path):**
   - ભારે પથ્થર (Ballast) ભરેલી ભારે ટ્રેન.
   - જો આ ટ્રેનના મુખ આગળનો પાટો ખાલી હોય અને તે ઢાળની દિશા સાથે સંરેખિત (aligned) હોય, તો તે ખેલાડીના ટેપ વગર પણ દરેક મૂવ વખતે 1 સેલ આપોઆપ આગળ સરકે છે.

---

## 3. Remote Config Keys
| Key | Type | Default | વર્ણન |
|---|---|---|---|
| `maxPhase` | int | `12` | Player માટે ઉપલબ્ધ મહત્તમ phase. `12` હોય ત્યારે જ L5501 unlock થાય. |
| `phase_12_d_min` | double | `60.0` | Generator difficulty ceiling minimum. |
| `phase_12_d_max` | double | `76.0` | Generator difficulty ceiling maximum. |
| `seed_overrides_p12` | string | `"{}"` | Emergency overrides for failed seeds in Phase 12. |

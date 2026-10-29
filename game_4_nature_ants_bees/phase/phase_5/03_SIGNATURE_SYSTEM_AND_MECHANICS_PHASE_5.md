# 03 — Signature System & Mechanics, Phase 5 (M201–M204)
> Acorn Physics (Push Physics+ architecture), inertia, chain reactions અને M201–M204 base mechanics cards.

**Related docs:** [Phase 5 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_5_SCOPE_AND_RULES.md)

---

## 1. Signature System: Acorn Physics (Push Physics+)
- **Concept:** સામાન્ય સ્થિર બ્લોક્સની જગ્યાએ વિવિધ ગુણધર્મો (વજન, ઘર્ષણ, કદ) ધરાવતા પઝલ બ્લોક્સ જેને કીડીઓ અને મધમાખીઓ ગતિ આપે છે.
- **Push Chain Rule:**
  - જ્યારે કોઈ લાઈન બ્લોક $A$ ને હિટ કરે છે:
    - જો $A$ ની આગળનો સેલ ખાલી હોય ⇒ $A$ આગળ વધે છે.
    - જો $A$ ની આગળ બ્લોક $B$ હોય અને $B$ નો આગળનો સેલ ખાલી હોય ⇒ બંને બ્લોક્સ 1 ડગલું આગળ ખસે છે (ચેઇન ડેપ્થ = 2).
    - જો $B$ ની આગળ દીવાલ કે અન્ય બ્લોક હોય ⇒ અથડામણ (bonk, −1 Heart).
- **Surface Friction Interactions:**
  - સામાન્ય લૉન ટાઇલ પર બ્લોક 1 સેલ આગળ વધીને અટકી જાય છે.
  - Dew-Slick Lily Leaves (M054) પર બ્લોક જ્યાં સુધી સૂકી જમીન કે અવરોધ ન આવે ત્યાં સુધી સરકતો રહે છે.

---

## 2. Base Mechanics Cards (M201–M204)

### M201 — Mole Hole (Crate Holes)
| Field | Value |
|---|---|
| ID | `M201` |
| Themed Name | **Mole Hole** (છછુંદરનો ખાડો) — Generic: Crate Holes |
| Category | D — Terrain / Hole |
| Intro Level | **L2011** (Block 2 x1) |
| Rule | જમીન પરનો ઊંડો ખાડો જે લેનને બ્લોક કરે છે. જ્યારે કોઈ push block (Rolling Acorn, Dewdrop Marble) આ ખાડામાં ધકેલાય છે ત્યારે બ્લોક અને ખાડો બંને અદ્રશ્ય થાય છે અને તે સેલ સામાન્ય જમીન બની જાય છે (લેન ક્લિયર થઈ જાય છે). |
| Ants (Ground) | ખાડો કીડીઓની લેન બ્લોક કરે છે જ્યાં સુધી પૂરાય નહીં. |
| Bees (Air/Canopy)| Bees ખાડા ઉપરથી કોઈપણ અસર વગર ઉડી જાય છે. |
| Tall | false (fixed). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M202 — Dewdrop Marble (Sliding Ice Crates)
| Field | Value |
|---|---|
| ID | `M202` |
| Themed Name | **Dewdrop Marble** (ઝાકળ-લખોટી) — Generic: Sliding Ice Crates |
| Category | T — Interactive Push Block / Low Friction |
| Intro Level | **L2131** (Block 14 x1) |
| Rule | અતિ લપસણી ગોળાકાર કાચ/ઝાકળની લખોટી. ધકેલતાં તે સામાન્ય લૉન પર પણ જ્યાં સુધી કોઈ અવરોધ, દીવાલ કે ખાડો ન મળે ત્યાં સુધી સતત સરકતી રહે છે. |
| Ants (Ground) | કીડીઓ દ્વારા ધકેલાય છે. |
| Bees (Air/Canopy)| `tall: true` હોય તો મધમાખીઓ પણ ધકેલી શકે છે. |
| Tall | Per instance (default `false`). |
| Hammerable | Yes (Leaf Blower થી ઉડી શકે છે). |
| Non-Monotone (N)| Yes. |

### M203 — Seed Key Pod (Crate Keys)
| Field | Value |
|---|---|
| ID | `M203` |
| Themed Name | **Seed Key Pod** (બીજ-ચાવી પોડ) — Generic: Crate Keys |
| Category | K — Key & Lock / Movable Key |
| Intro Level | **L2251** (Block 26 x1) |
| Rule | ચાવી ધરાવતો વિશિષ્ટ રંગીન પુશ બ્લોક. જ્યારે તેને ધકેલીને તેના મેચિંગ રંગના Seed Socket Plate (M055) પર બેસાડવામાં આવે છે, ત્યારે જોડાયેલા કાંટાળા લોક (Thorn Locks) કાયમી ખુલી જાય છે. |
| Ants / Bees | બ્લોકના લેયર અને `tall` ગુણધર્મ અનુસાર ધકેલી શકાય છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M204 — Stone Pumpkin (Heavy Crate)
| Field | Value |
|---|---|
| ID | `M204` |
| Themed Name | **Stone Pumpkin** (પથ્થરનું કોળું) — Generic: Heavy Crate |
| Category | B / T — Heavy Push Blocker |
| Intro Level | **L2371** (Block 38 x1) |
| Rule | ભારે પથ્થરનું બ્લોકર. સામાન્ય 1-વાઇડ સિંગલ લાઈન તેને ધકેલી શકતી નથી (bonk થાય છે). તેને માત્ર **Double-File (M024)** લાઈન અથવા **Petal-Linked (M011/M066)** જૂથની લાઈનો એકસાથે હિટ કરીને જ 1 ડગલું આગળ ખસેડી શકે છે. |
| Ants / Bees | `tall: true` હોય તો વાઇડ બી લાઈનો પણ ધકેલી શકે છે. |
| Tall | Per instance (default `false`). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |


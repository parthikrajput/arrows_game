# 01 — Phase 8 Scope & Rule Additions
> Phase 8 (L3501–4000) માં લાગુ પડતા નિયમો: Overgrown Garden (Growth signature system), Multi-neighbour Vine Spread, Pruning Mechanics, Seed Drops, Bloom Gates, D band 60–76 અને Remote Config keys.

**Related docs:** [Phase 8 index](./README.md) · [Shared Core Standard §11, §12, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_3501_4000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_8.md)

---

## 1. Overview (શું બદલાતું નથી, શું ઉમેરાય છે)

### બદલાતું નથી:
- Core puzzle loop (Tap → slither, blocked → bonk, −1 Heart Berry).
- 0-hearts solvable guarantee.
- Turn-based rules (કોઈ સમય મર્યાદા નહીં; ગ્રોથ મૂવ કાઉન્ટથી થાય છે).
- Boosters (Hint, Shield, Hammer) અને Free Tongue-Flick Preview.
- D-band: Fixed plateau **D 60–76** (standard §17.24).

### ઉમેરાય છે:
| # | Addition | વિગત | First Level |
|---|---|---|---|
| 1 | **Growth Signature System** | ગતિશીલ રીતે ફેલાતી વેલો, કાપણી ટાઇલ્સ અને બીજ અંકુરણ | L3501 |
| 2 | **Base Mechanics M351–M354** | Wild Vine, Pruning Shears Tile, Seed-Carrier Snake, Bloom Gate | L3511, L3631, L3751, L3871 |
| 3 | **Multi-Neighbour Spread Order** | દર $N$ મૂવ્સે વેલો પોતાના પ્રથમ **બે** ખાલી પાડોશી સેલમાં (U, R, D, L ક્રમ) ફેલાય છે | L3511 |
| 4 | **Lane-Crossing Pruning** | પ્રૂનિંગ સેલ પરથી લેન પસાર થતાં તેની ચારેય બાજુની વેલો નાશ પામે છે | L3631 |
| 5 | **Conditional Bloom Unlocking** | તમામ લિંક થયેલી વેલો પ્રૂન થાય તે પછી જ બ્લૂમ ગેટ ખુલે છે | L3871 |

---

## 2. Growth Dynamics & Safety Invariants
### 2.1 Wild Vine Growth (M351)
- દર $N$ Moves એ (Step 3: Counters tick) વેલો અંકુરિત થાય છે.
- તે પોતાના ખાલી ઓર્થોગોનલ પાડોશી સેલ્સ તપાસે છે (`U, R, D, L` ક્રમમાં).
- પ્રથમ 2 ખાલી સેલ્સ પર નવા વેલો બ્લોકર્સ ઉગી નીકળે છે.
- **સોલ્વર બાઉન્ડ:** વેલોની મહત્તમ સંખ્યા સ્તર દીઠ કેપ કરવામાં આવે છે (Max 8 vine cells) જેથી બોર્ડ અનિવાર્યપણે બ્લોક ન થઈ જાય.

### 2.2 Seed-Carrier Snake (M353)
- જ્યારે Seed-Carrier Snake બહાર નીકળે છે, ત્યારે તે બોર્ડ પર પોતાના નિર્ધારિત સેલ પર એક બીજ (Seed) છોડી જાય છે.
- આ બીજ $N$ મૂવ્સ સુધી સુષુપ્ત રહે છે.
- જો $N$ મૂવ્સમાં અન્ય કોઈ સાપ તેની ઉપરથી પસાર થઈ જાય, તો બીજ કચડાઈને નાશ પામે છે.
- જો $N$ મૂવ્સમાં કોઈ સાપ ન નીકળે, તો બીજ અંકુરિત થઈને સોલિડ બ્લોકર વેલો બની જાય છે!

---

## 3. Limits & Parameters
| Parameter | Value Range | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સક્ષમ |
| Snake Paths ($P$) | 28 – 40 snakes | Reverse construction થી place થાય છે |
| Max Obstacles ($O$) | 8 – 14 instances | Vines, pruners, seeds સહિત |
| Difficulty ($D$) Band | **60 – 76** | Plateau target |
| x9 Hard Target | ≈ 84 | High band × 1.1 |
| L4000 Finale Target | ≈ 91 | High band × 1.2 |

---

## 4. Remote Config Keys
```json
{
  "maxPhase": 8,
  "levelOverrides_p8": {},
  "vine_growth_anim_ms": 200,
  "p8_economy": {
    "gift_basket_coins": 300,
    "finale_chest_coins": 1000
  }
}
```

---

## 5. Open Decisions
- **OD-P8-02:** Wild Vine ફેલાતી વખતે પાડોશી સેલમાં કોઈ ફળ કે સિક્કો હોય તો તે ઢંકાઈ જાય કે ગાયબ થાય? (હાલ ઢંકાઈ જાય છે, વેલો કપાતાં ફરી દેખાય છે).

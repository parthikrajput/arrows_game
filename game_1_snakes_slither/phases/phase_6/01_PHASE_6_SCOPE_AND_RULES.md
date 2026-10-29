# 01 — Phase 6 Scope & Rule Additions
> Phase 6 (L2501–3000) માં લાગુ પડતા નિયમો: Sun Temple Light (Light & Beams+ signature system), Chromatic Filtering, Multi-beam Concurrency Locks, Consecutive Beam Timers, Dark Cell Locks, D band 60–76 અને Remote Config keys.

**Related docs:** [Phase 6 index](./README.md) · [Shared Core Standard §11, §12, §16, §17](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_2501_3000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md) · [06 UI & QA](./06_UI_AND_QA_PHASE_6.md)

---

## 1. Overview (શું બદલાતું નથી, શું ઉમેરાય છે)

### બદલાતું નથી:
- Core puzzle loop (Tap → slither, blocked → bonk, −1 Heart Berry).
- 0-hearts solvable guarantee.
- Turn-based rules (કોઈ સમય મર્યાદા નહીં; બીમ ટાઈમર્સ માત્ર Moves થી ગણાય છે).
- Boosters (Hint, Shield, Hammer) અને Free Tongue-Flick Preview.
- D-band: Fixed plateau **D 60–76** (standard §17.24).

### ઉમેરાય છે:
| # | Addition | વિગત | First Level |
|---|---|---|---|
| 1 | **Light & Beams+ Signature System** | કિરણોનું રંગ ફિલ્ટરિંગ, બહુ-કિરણ તાળાઓ અને પ્રકાશ આધારિત લોક્સ | L2501 |
| 2 | **Base Mechanics M251–M254** | Petal Filter, Prism Lock, Sundial Receiver, Shade Leaves | L2511, L2631, L2751, L2871 |
| 3 | **Chromatic Filtering** | બીમ ફિલ્ટરમાંથી પસાર થતાં તેનો રંગ બદલાય છે; માત્ર મેચિંગ રીસીવર જ સક્રિય થાય છે | L2511 |
| 4 | **Multi-Beam Concurrency** | એક જ Move માં $\ge 2$ કિરણો લોક પર પડવા અનિવાર્ય છે | L2631 |
| 5 | **Dark Cells & Head Lock** | અંધારા સેલમાં માથું ધરાવતો સાપ ત્યાં સુધી લૉક રહે છે જ્યાં સુધી કિરણ તે સેલમાંથી ન નીકળે | L2871 |

---

## 2. Advanced Optics Rules (standard §17.19)
### 2.1 Beam Propagation & Tick Integration
- કિરણો (Sunbeams) સીધી રેખામાં પ્રવાસ કરે છે.
- **Pre-Move Evaluation:** ખેલાડીના Move પહેલાં કિરણોની સ્થિતિ ચકાસાય છે.
- **Step 4 Resolution (Tick Step):** સાપ નીકળ્યા કે અરીસો ફર્યા પછી બીમ તરત ફરી ગણાય છે (Ray casting update).
- બીમ સાપના શરીર દ્વારા અવરોધાય છે (ઓપેક બોડી).

### 2.2 Consecutive Move Beam Timers (M253)
- જો કોઈ રીસીવરને દરવાજો ખોલવા માટે $N$ સળંગ મૂવ્સ સુધી પ્રકાશિત રહેવાની જરૂર હોય:
  - સળંગ $N$ મૂવ્સ સુધી બીમ ચાલુ રહેતાં દરવાજો કાયમ માટે Latch Open થઈ જાય છે.
  - જો વચ્ચે 1 પણ મૂવ માટે બીમ કપાઈ જાય, તો કાઉન્ટર રીસેટ થઈને 0 થાય છે.

---

## 3. Limits & Parameters
| Parameter | Value Range | નોંધ |
|---|---|---|
| Grid Size | 12×12 – 14×14 | Pinch-zoom & pan સક્ષમ |
| Snake Paths ($P$) | 28 – 40 snakes | Reverse construction થી place થાય છે |
| Max Obstacles ($O$) | 8 – 14 instances | Emitters, mirrors, filters સહિત |
| Difficulty ($D$) Band | **60 – 76** | Plateau target |
| x9 Hard Target | ≈ 84 | High band × 1.1 |
| L3000 Finale Target | ≈ 91 | High band × 1.2 |

---

## 4. Remote Config Keys
```json
{
  "maxPhase": 6,
  "levelOverrides_p6": {},
  "beam_glow_intensity": 1.0,
  "p6_economy": {
    "gift_basket_coins": 300,
    "finale_chest_coins": 1000
  }
}
```

---

## 5. Open Decisions
- **OD-P6-02:** જ્યારે બે અલગ રંગના કિરણો એકબીજાને છેદે (Cross-beam), ત્યારે ક્રોસ સેલ પર મિશ્રિત રંગનો ગ્લો આપવો કે સ્વતંત્ર ઓવરલે? (હાલ `BlendMode.plus` એડિટિવ ગ્લો નક્કી છે).

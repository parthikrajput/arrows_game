# 03 — Signature System & Mechanics, Phase 8 (M351–M354)
> Bloom Season (Growth architecture), cross-expansion algorithms, pruning logic અને M351–M354 base mechanics cards.

**Related docs:** [Phase 8 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6](../../SCALING_TO_10000_LEVELS.md) · [01 Rules](./01_PHASE_8_SCOPE_AND_RULES.md)

---

## 1. Signature System: Bloom Season (Growth)
- **Core Concept:** બોર્ડ પરના વનસ્પતિ અવરોધો સ્થિર રહેવાને બદલે પ્લેયરના Moves સાથે સજીવ રીતે વિસ્તરે છે. જો યોગ્ય સમયે રસ્તો સાફ ન કરવામાં આવે કે કાતર વડે કાપણી ન કરવામાં આવે, તો વેલ મુખ્ય એક્ઝિટ લેન્સ બંધ કરી શકે છે.
- **Cross-Expansion Algorithm (M351):**
  - દર $N$ Moves પૂર્ણ થયા પછી (`moveCount % params.growEvery == 0`):
    - હાલના તમામ વેલ સેલ્સ તેમની આસપાસના 4 ઓર્થોગોનલ પડોશી સેલ્સ તપાસે છે (Order: Up $\to$ Right $\to$ Down $\to$ Left).
    - જો પડોશી સેલ સંપૂર્ણપણે ખાલી હોય (કોઈ લાઈન, બ્લોકર કે દીવાલ ન હોય), તો ત્યાં નવો વેલ સેલ ઉગી નીકળે છે.
    - એક ટર્નમાં ઉમેરાયેલા નવા સેલ્સ તે જ ટર્નમાં આગળ વધતા નથી (સ્ટેપ-વાઇઝ સિન્ક્રોનસ એક્સપાન્શન).
- **Pruning Logic (M352):**
  - જ્યારે કોઈપણ લાઈનનો પાથ Garden Shears સેલ પરથી પસાર થાય છે, ત્યારે તે કાતર સક્રિય થાય છે અને તેની ચારેય ઓર્થોગોનલ દિશામાં રહેલા તમામ વેલ સેલ્સ તાત્કાલિક કપાઈને દૂર થઈ જાય છે.

---

## 2. Base Mechanics Cards (M351–M354)

### M351 — Morning Glory Vine (Vine Spread+)
| Field | Value |
|---|---|
| ID | `M351` |
| Themed Name | **Morning Glory Vine** (મોર્નિંગ ગ્લોરી વેલ) — Generic: Vine Spread+ |
| Category | B / T — Expanding Blocker |
| Intro Level | **L3511** (Block 2 x1) |
| Rule | જાંબલી રંગના સુંદર ફૂલોવાળી જીવંત વેલ. દર $N$ Moves એ (ડિફૉલ્ટ $N = 3$) તે ચારેય મુક્ત ઓર્થોગોનલ દિશાઓમાં (U, R, D, L) $1$ સેલ આગળ વધે છે. જ્યાં સુધી રસ્તો ખુલ્લો હોય ત્યાં સુધી તે ફેલાતી રહે છે. જો તેના ફેલાવા વચ્ચે કીડી આવે તો તે અટકી જાય છે (લાઈનને ક્યારેય દબાવતી નથી). |
| Ants / Bees | ગ્રાઉન્ડ લેવલ કીડીઓ માટે પૂર્ણ બ્લોકર છે; `tall: true` વેલ મધમાખીઓની ફ્લાઇટ લેન પણ બ્લોક કરે છે. |
| Tall | Per instance (default `false`). |
| Hammerable | Yes (Leaf Blower થી સમગ્ર ક્લસ્ટર સાફ થાય છે). |
| Non-Monotone (N)| Yes. |

### M352 — Garden Shears (Pruner Tile)
| Field | Value |
|---|---|
| ID | `M352` |
| Themed Name | **Garden Shears** (બગીચાની કાતર) — Generic: Pruner Tile |
| Category | T — Reactive Clearing Tile |
| Intro Level | **L3631** (Block 14 x1) |
| Rule | જમીન પર પડેલી નાની કાતરની ટાઇલ. જ્યારે કોઈપણ કીડી કે મધમાખીની લેન આ સેલ પરથી પસાર થાય છે, ત્યારે કાતર તાત્કાલિક સ્નિપ (snip) થાય છે અને તેની ચારેય ઓર્થોગોનલ બાજુએ અડીને રહેલી તમામ વેલો (M351) કાયમી કપાઈને દૂર થઈ જાય છે. |
| Ants / Bees | કીડીઓ અને મધમાખીઓ બંનેની લેન તેને ટ્રિગર કરી શકે છે. |
| Tall | `true` (બંને લેયર્સ તેને સક્રિય કરે છે). |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M353 — Seed-Dropping Line (Seed Path)
| Field | Value |
|---|---|
| ID | `M353` |
| Themed Name | **Seed-Dropping Line** (બીજ-છોડતી લાઈન) — Generic: Seed Path |
| Category | P / T — Delayed Hazard Line |
| Intro Level | **L3751** (Block 26 x1) |
| Rule | આ લાઈન જ્યારે બોર્ડમાંથી સફળતાપૂર્વક બહાર નીકળી જાય છે, ત્યારે તેના પ્રારંભિક હેડ સેલ (Start Head Cell) પર એક સોનેરી બીજ (Seed) છોડી જાય છે. આ બીજ પર $N$ Moves નું કાઉન્ટડાઉન શરૂ થાય છે. જો $N$ Moves માં અન્ય કોઈ સમાન લેયરની લાઈન તેના પરથી પસાર ન થાય, તો બીજ અંકુરિત થઈને કાયમી સિંગલ બ્લોકર (Pebble) બની જાય છે. |
| Ants / Bees | કીડીઓ ગ્રાઉન્ડ સીડ છોડે છે; મધમાખીઓ કેનોપી/એર સીડ પોડ છોડે છે. |
| Tall | Line layer મુજબ. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

### M354 — Pollination Gate (Bloom Gate)
| Field | Value |
|---|---|
| ID | `M354` |
| Themed Name | **Pollination Gate** (પરાગનયન ગેટ) — Generic: Bloom Gate |
| Category | G — Cumulative Exit Gate |
| Intro Level | **L3871** (Block 38 x1) |
| Rule | બંધ કળી સ્વરૂપે રહેલો ફ્લોરલ ગેટ. આ ગેટની આસપાસના ચાર અડીને આવેલા સેલ્સમાંથી જ્યારે કુલ $K$ લાઈનો (ડિફૉલ્ટ $K = 2$ અથવા $3$) સફળતાપૂર્વક બહાર નીકળી જાય છે, ત્યારે તેમના પરાગરજથી આ ગેટ સંપૂર્ણ ખીલી ઊઠે છે અને કાયમી ખુલ્લો થઈ જાય છે. |
| Ants / Bees | ગ્રાઉન્ડ કીડીઓ અને ફ્લાઇંગ બીઝ બંનેના એક્ઝિટ પરાગરજ કાઉન્ટરમાં ગણાય છે. |
| Tall | Per instance. |
| Hammerable | No. |
| Non-Monotone (N)| Yes. |

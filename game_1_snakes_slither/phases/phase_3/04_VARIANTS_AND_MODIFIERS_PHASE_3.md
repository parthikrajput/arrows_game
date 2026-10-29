# 04 — Variants & Modifiers (Phase 3)
> Phase 3 માં વપરાતા 45 variant slots, 10 generic modifiers ના નિયમો, base mechanics સાથેનું mapping, JSON representation અને tutorial card conventions.

**Related docs:** [Phase 3 index](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_1001_1500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md)

---

## 1. Variant Concept (સિદ્ધાંત)
- **Variant = Existing Base Mechanic × Modifier.**
- Phase 3 માં 45 variant slots છે જે 50-block slot map માં blocks 3–13, 15–25, 27–37, 39–49 ના x1 intro સ્લોટ પર રજૂ થાય છે.
- દરેક variant ને એક સ્વાયત્ત tutorial card મળે છે (base mechanic એનિમેશન + modifier આઇકોન બેજ + નિયમ વાક્ય).

---

## 2. 10 Generic Modifiers (Standard §11, SCALING §7)

| Modifier | Exact Rule | લાગુ પડતી કેટેગરી | Tutorial Card Copy |
|---|---|---|---|
| `Frozen(K)` | $K$ નજીકના સાપ નીકળે ત્યાં સુધી થીજી ગયેલું રહે છે; ત્યાં સુધી સોલિડ બ્લોકર | B, D, T, G | "Frozen! Free K neighbours to wake it." |
| `Colored(c)` | માત્ર $c$ રંગના સાપને અસર કરે છે; અન્ય રંગ માટે બ્લોકર | Lane-type D, G, L | "Only c snakes can use this." |
| `Fogged` | જંગલની ધુમ્મસ નીચે છુપાયેલું છે; બાજુનો સાપ નીકળ્યા પછી જ દેખાય છે | All except X | "Something hides in the mist…" |
| `Chained` | બે ઇન્સ્ટન્સ જોડાયેલા છે; એક પર ક્રિયા બંને પર એકસાથે થાય છે | T, D, C | "Linked by a vine — both act together." |
| `Countdown(N)` | પ્રથમ $N$ Moves સુધી જ કામ કરે છે, પછી સાદું ફ્લોર બની જાય છે | B, D, T, G | "Lasts N moves!" |
| `Phasing` | Even Move પર દેખાય છે, Odd પર અદૃશ્ય થાય છે (Parity rule) | B, D, G | "Blinks every other move." |
| `Armored` | હેમર વાપરી શકાતો નથી; વિસ્ફોટોથી અસુરક્ષિત | B, C, X | "Armored — the hammer won't work." |
| `Layered(l)` | માત્ર $l$ સ્તર (Ground, Canopy, Treetop) ને જ અસર કરે છે | B, D, T, G | "Only affects the canopy/ground." |
| `Mirrored` | રોટેશન કે દિશા ઉલટી (CW ↔ CCW, લાઈટ એંગલ રિફ્લેક્ટેડ) | D, T | "Everything turns the other way." |
| `Growing(N)` | દર $N$ Moves એ પાડોશી ખાલી સેલમાં 1 સેલ ફેલાય છે (max 4) | B | "Grows every N moves!" |

---

## 3. 45 Variant Slots Mapping Table (Phase 3)

| Slot | Block | Level | Base Mechanic | Modifier | JSON Example `params.mod` |
|---|---|---|---|---|---|
| V01 | 3 | L1021 | M101 Sun-Moon Gate | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V02 | 4 | L1031 | M101 Sun-Moon Gate | `Colored(teal)` | `{"kind": "Colored", "color": "teal"}` |
| V03 | 5 | L1041 | M101 Sun-Moon Gate | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| V04 | 6 | L1051 | M101 Sun-Moon Gate | `Phasing` | `{"kind": "Phasing"}` |
| V05 | 7 | L1061 | M101 Sun-Moon Gate | `Armored` | `{"kind": "Armored"}` |
| V06 | 8 | L1071 | M004 Lily Pad | `Chained` | `{"kind": "Chained", "linkedId": "o04_b"}` |
| V07 | 9 | L1081 | M009 Vine Gate | `Growing(4)` | `{"kind": "Growing", "n": 4}` |
| V08 | 10 | L1091 | M014 Bamboo Ramp | `Mirrored` | `{"kind": "Mirrored"}` |
| V09 | 11 | L1101 | M019 Moss Blocker | `Fogged` | `{"kind": "Fogged"}` |
| V10 | 12 | L1111 | M020 Burrow | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| V11 | 13 | L1121 | M053 Rolling Coconut | `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| V12 | 15 | L1141 | M102 Moonlight Bridge | `Colored(violet)` | `{"kind": "Colored", "color": "violet"}` |
| V13 | 16 | L1151 | M102 Moonlight Bridge | `Countdown(10)` | `{"kind": "Countdown", "n": 10}` |
| V14 | 17 | L1161 | M102 Moonlight Bridge | `Chained` | `{"kind": "Chained", "linkedId": "o102_b"}` |
| V15 | 18 | L1171 | M058 Periodic Gate | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V16 | 19 | L1181 | M063 Swamp Mud | `Armored` | `{"kind": "Armored"}` |
| V17 | 20 | L1191 | M069 Treetop Platform | `Colored(amber)` | `{"kind": "Colored", "color": "amber"}` |
| V18 | 21 | L1201 | M070 Canopy Fan | `Phasing` | `{"kind": "Phasing"}` |
| V19 | 22 | L1211 | M076 Spider Silk Portal| `Fogged` | `{"kind": "Fogged"}` |
| V20 | 23 | L1221 | M084 Sunbeam Reflector | `Mirrored` | `{"kind": "Mirrored"}` |
| V21 | 24 | L1231 | M086 Crystal Prism | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V22 | 25 | L1241 | M090 Sun Dial Gate | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| V23 | 27 | L1261 | M103 Day-Night Burrows| `Colored(coral)` | `{"kind": "Colored", "color": "coral"}` |
| V24 | 28 | L1271 | M103 Day-Night Burrows| `Countdown(6)` | `{"kind": "Countdown", "n": 6}` |
| V25 | 29 | L1281 | M103 Day-Night Burrows| `Chained` | `{"kind": "Chained", "linkedId": "o103_b"}` |
| V26 | 30 | L1291 | M103 Day-Night Burrows| `Frozen(4)` | `{"kind": "Frozen", "k": 4}` |
| V27 | 31 | L1301 | M001 Stone Blocker | `Growing(2)` | `{"kind": "Growing", "n": 2}` |
| V28 | 32 | L1311 | M007 Ant Nest | `Layered(0)` | `{"kind": "Layered", "layer": 0}` |
| V29 | 33 | L1321 | M025 Gecko Sentry | `Armored` | `{"kind": "Armored"}` |
| V30 | 34 | L1331 | M032 Canopy Leaf | `Colored(emerald)`| `{"kind": "Colored", "color": "emerald"}` |
| V31 | 35 | L1341 | M042 Fragile Vine Bridge| `Phasing` | `{"kind": "Phasing"}` |
| V32 | 36 | L1351 | M051 Sidewinder Snake | `Fogged` | `{"kind": "Fogged"}` |
| V33 | 37 | L1361 | M054 Ice Slide Crate | `Mirrored` | `{"kind": "Mirrored"}` |
| V34 | 39 | L1381 | M104 Twilight Flower | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| V35 | 40 | L1391 | M104 Twilight Flower | `Chained` | `{"kind": "Chained", "linkedId": "o104_b"}` |
| V36 | 41 | L1401 | M104 Twilight Flower | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V37 | 42 | L1411 | M060 Chameleon Log | `Colored(gold)` | `{"kind": "Colored", "color": "gold"}` |
| V38 | 43 | L1421 | M067 Quicksand | `Armored` | `{"kind": "Armored"}` |
| V39 | 44 | L1431 | M075 Creeping Moss | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| V40 | 45 | L1441 | M082 River Rapids Belt | `Phasing` | `{"kind": "Phasing"}` |
| V41 | 46 | L1451 | M087 Sticky Amber | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V42 | 47 | L1461 | M092 Segment Worm | `Mirrored` | `{"kind": "Mirrored"}` |
| V43 | 48 | L1471 | M094 Paint Bloom | `Fogged` | `{"kind": "Fogged"}` |
| V44 | 49 | L1481 | M098 Prowling Mongoose| `Chained` | `{"kind": "Chained", "linkedId": "o98_b"}` |
| V45 | 49 | L1485 | M002 Hollow Log | `Armored` | `{"kind": "Armored"}` |


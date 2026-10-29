# 04 — Variants & Modifiers (Phase 5)
> Phase 5 (Coconut Grove Physics) માં વપરાતા 45 variant slots, 10 generic modifiers નું Push Physics mechanics સાથે mapping અને વર્તણૂક નિયમો.

**Related docs:** [Phase 5 index](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_2001_2500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md)

---

## 1. Push Physics Variant Architecture
- પુશ બ્લોક્સ અને ખાડાઓ પર મોડિફાયર્સ (દા.ત. `Frozen`, `Colored`, `Growing`, `Chained`) લાગુ થવાથી કોયડાઓમાં વિવિધતા આવે છે:
  - `Frozen(K)` Coconut: આસપાસના સાપ નીકળે પછી જ નારિયેળ ધકેલી શકાય છે.
  - `Colored(c)` Pit: માત્ર ચોક્કસ રંગના નારિયેળ કે સાપને જ સ્વીકારે છે.
  - `Countdown(N)` Pit: $N$ મૂવ્સ પછી આપોઆપ માટી ભરાઈને ફ્લોર બની જાય છે.

---

## 2. 45 Variant Slots Mapping Table (Phase 5)

| Slot | Block | Level | Base Mechanic | Modifier | JSON `params.mod` |
|---|---|---|---|---|---|
| V01 | 3 | L2021 | M201 Coconut Pit | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V02 | 4 | L2031 | M201 Coconut Pit | `Colored(amber)` | `{"kind": "Colored", "color": "amber"}` |
| V03 | 5 | L2041 | M201 Coconut Pit | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| V04 | 6 | L2051 | M201 Coconut Pit | `Phasing` | `{"kind": "Phasing"}` |
| V05 | 7 | L2061 | M201 Coconut Pit | `Armored` | `{"kind": "Armored"}` |
| V06 | 8 | L2071 | M004 Lily Pad | `Chained` | `{"kind": "Chained", "linkedId": "o04_b"}` |
| V07 | 9 | L2081 | M009 Vine Gate | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V08 | 10 | L2091 | M014 Bamboo Ramp | `Mirrored` | `{"kind": "Mirrored"}` |
| V09 | 11 | L2101 | M020 Burrow | `Fogged` | `{"kind": "Fogged"}` |
| V10 | 12 | L2111 | M053 Rolling Coconut | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| V11 | 13 | L2121 | M151 Root Stairs | `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| V12 | 15 | L2141 | M202 Dew-Slick Coconut | `Colored(cyan)` | `{"kind": "Colored", "color": "cyan"}` |
| V13 | 16 | L2151 | M202 Dew-Slick Coconut | `Countdown(10)` | `{"kind": "Countdown", "n": 10}` |
| V14 | 17 | L2161 | M202 Dew-Slick Coconut | `Chained` | `{"kind": "Chained", "linkedId": "o202_b"}` |
| V15 | 18 | L2171 | M058 Periodic Gate | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V16 | 19 | L2181 | M063 Swamp Mud | `Armored` | `{"kind": "Armored"}` |
| V17 | 20 | L2191 | M069 Treetop Platform| `Colored(gold)` | `{"kind": "Colored", "color": "gold"}` |
| V18 | 21 | L2201 | M070 Canopy Fan | `Phasing` | `{"kind": "Phasing"}` |
| V19 | 22 | L2211 | M084 Sunbeam Reflector| `Mirrored` | `{"kind": "Mirrored"}` |
| V20 | 23 | L2221 | M086 Crystal Prism | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V21 | 24 | L2231 | M090 Sun Dial Gate | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| V22 | 25 | L2241 | M152 Dewglass Floor | `Fogged` | `{"kind": "Fogged"}` |
| V23 | 27 | L2261 | M203 Key Coconut | `Colored(ruby)` | `{"kind": "Colored", "color": "ruby"}` |
| V24 | 28 | L2271 | M203 Key Coconut | `Countdown(6)` | `{"kind": "Countdown", "n": 6}` |
| V25 | 29 | L2281 | M203 Key Coconut | `Chained` | `{"kind": "Chained", "linkedId": "o203_b"}` |
| V26 | 30 | L2291 | M203 Key Coconut | `Frozen(4)` | `{"kind": "Frozen", "k": 4}` |
| V27 | 31 | L2301 | M001 Stone Blocker | `Growing(2)` | `{"kind": "Growing", "n": 2}` |
| V28 | 32 | L2311 | M007 Ant Nest | `Layered(0)` | `{"kind": "Layered", "layer": 0}` |
| V29 | 33 | L2321 | M025 Gecko Sentry | `Armored` | `{"kind": "Armored"}` |
| V30 | 34 | L2331 | M032 Canopy Leaf | `Colored(mint)` | `{"kind": "Colored", "color": "mint"}` |
| V31 | 35 | L2341 | M042 Fragile Vine Bridge| `Phasing` | `{"kind": "Phasing"}` |
| V32 | 36 | L2351 | M051 Sidewinder Snake | `Fogged` | `{"kind": "Fogged"}` |
| V33 | 37 | L2361 | M054 Ice Slide Crate | `Mirrored` | `{"kind": "Mirrored"}` |
| V34 | 39 | L2381 | M204 Jackfruit Boulder | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| V35 | 40 | L2391 | M204 Jackfruit Boulder | `Chained` | `{"kind": "Chained", "linkedId": "o204_b"}` |
| V36 | 41 | L2401 | M204 Jackfruit Boulder | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V37 | 42 | L2411 | M060 Chameleon Log | `Colored(bronze)`| `{"kind": "Colored", "color": "bronze"}` |
| V38 | 43 | L2421 | M067 Quicksand | `Armored` | `{"kind": "Armored"}` |
| V39 | 44 | L2431 | M075 Creeping Moss | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| V40 | 45 | L2441 | M082 River Rapids Belt| `Phasing` | `{"kind": "Phasing"}` |
| V41 | 46 | L2451 | M087 Sticky Amber | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V42 | 47 | L2461 | M092 Segment Worm | `Mirrored` | `{"kind": "Mirrored"}` |
| V43 | 48 | L2471 | M094 Paint Bloom | `Fogged` | `{"kind": "Fogged"}` |
| V44 | 49 | L2481 | M153 Knot Hole | `Chained` | `{"kind": "Chained", "linkedId": "o153_c"}` |
| V45 | 49 | L2485 | M002 Hollow Log | `Armored` | `{"kind": "Armored"}` |


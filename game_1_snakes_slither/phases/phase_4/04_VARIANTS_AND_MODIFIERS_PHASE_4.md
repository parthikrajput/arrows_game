# 04 — Variants & Modifiers (Phase 4)
> Phase 4 (Great Tree Floors) માં વપરાતા 45 variant slots, 10 generic modifiers નું Multi-Floor mechanics સાથે mapping અને વર્તણૂક નિયમો.

**Related docs:** [Phase 4 index](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_1501_2000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md)

---

## 1. Multi-Floor Variant Architecture
- Multi-floor પરિમાણમાં modifiers વધુ રોમાંચક પરિણામો આપે છે: દા.ત. એક માળ પર રહેલી સીડી કે હોલ પર `Countdown`, `Colored` કે `Layered` લગાવવાથી વર્ટિકલ પઝલ્સ વધુ ઊંડાણપૂર્વકના બને છે.
- 50 blocks ના slot map માં 45 variant slots બ્લોક્સ 3–13, 15–25, 27–37, 39–49 માં ગોઠવાયેલા છે.

---

## 2. 45 Variant Slots Mapping Table (Phase 4)

| Slot | Block | Level | Base Mechanic | Modifier | JSON `params.mod` |
|---|---|---|---|---|---|
| V01 | 3 | L1521 | M151 Root Stairs | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V02 | 4 | L1531 | M151 Root Stairs | `Colored(blue)` | `{"kind": "Colored", "color": "blue"}` |
| V03 | 5 | L1541 | M151 Root Stairs | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| V04 | 6 | L1551 | M151 Root Stairs | `Phasing` | `{"kind": "Phasing"}` |
| V05 | 7 | L1561 | M151 Root Stairs | `Armored` | `{"kind": "Armored"}` |
| V06 | 8 | L1571 | M004 Lily Pad | `Chained` | `{"kind": "Chained", "linkedId": "o04_b"}` |
| V07 | 9 | L1581 | M010 Jungle Mist | `Fogged` | `{"kind": "Fogged"}` |
| V08 | 10 | L1591 | M014 Bamboo Ramp | `Mirrored` | `{"kind": "Mirrored"}` |
| V09 | 11 | L1601 | M020 Burrow | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V10 | 12 | L1611 | M053 Rolling Coconut | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| V11 | 13 | L1621 | M101 Sun-Moon Gate | `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| V12 | 15 | L1641 | M152 Dewglass Floor | `Colored(green)` | `{"kind": "Colored", "color": "green"}` |
| V13 | 16 | L1651 | M152 Dewglass Floor | `Countdown(10)` | `{"kind": "Countdown", "n": 10}` |
| V14 | 17 | L1661 | M152 Dewglass Floor | `Chained` | `{"kind": "Chained", "linkedId": "o152_b"}` |
| V15 | 18 | L1671 | M058 Periodic Gate | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V16 | 19 | L1681 | M063 Swamp Mud | `Armored` | `{"kind": "Armored"}` |
| V17 | 20 | L1691 | M069 Treetop Platform| `Colored(orange)`| `{"kind": "Colored", "color": "orange"}` |
| V18 | 21 | L1701 | M070 Canopy Fan | `Phasing` | `{"kind": "Phasing"}` |
| V19 | 22 | L1711 | M084 Sunbeam Reflector| `Mirrored` | `{"kind": "Mirrored"}` |
| V20 | 23 | L1721 | M086 Crystal Prism | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V21 | 24 | L1731 | M090 Sun Dial Gate | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| V22 | 25 | L1741 | M102 Moonlight Bridge | `Fogged` | `{"kind": "Fogged"}` |
| V23 | 27 | L1761 | M153 Knot Hole | `Colored(purple)` | `{"kind": "Colored", "color": "purple"}` |
| V24 | 28 | L1771 | M153 Knot Hole | `Countdown(6)` | `{"kind": "Countdown", "n": 6}` |
| V25 | 29 | L1781 | M153 Knot Hole | `Chained` | `{"kind": "Chained", "linkedId": "o153_b"}` |
| V26 | 30 | L1791 | M153 Knot Hole | `Frozen(4)` | `{"kind": "Frozen", "k": 4}` |
| V27 | 31 | L1801 | M001 Stone Blocker | `Growing(2)` | `{"kind": "Growing", "n": 2}` |
| V28 | 32 | L1811 | M007 Ant Nest | `Layered(0)` | `{"kind": "Layered", "layer": 0}` |
| V29 | 33 | L1821 | M025 Gecko Sentry | `Armored` | `{"kind": "Armored"}` |
| V30 | 34 | L1831 | M032 Canopy Leaf | `Colored(yellow)` | `{"kind": "Colored", "color": "yellow"}` |
| V31 | 35 | L1841 | M042 Fragile Vine Bridge| `Phasing` | `{"kind": "Phasing"}` |
| V32 | 36 | L1851 | M051 Sidewinder Snake | `Fogged` | `{"kind": "Fogged"}` |
| V33 | 37 | L1861 | M054 Ice Slide Crate | `Mirrored` | `{"kind": "Mirrored"}` |
| V34 | 39 | L1881 | M154 Vine Lift | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| V35 | 40 | L1891 | M154 Vine Lift | `Chained` | `{"kind": "Chained", "linkedId": "o154_b"}` |
| V36 | 41 | L1901 | M154 Vine Lift | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V37 | 42 | L1911 | M060 Chameleon Log | `Colored(ruby)` | `{"kind": "Colored", "color": "ruby"}` |
| V38 | 43 | L1921 | M067 Quicksand | `Armored` | `{"kind": "Armored"}` |
| V39 | 44 | L1931 | M075 Creeping Moss | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| V40 | 45 | L1941 | M082 River Rapids Belt| `Phasing` | `{"kind": "Phasing"}` |
| V41 | 46 | L1951 | M087 Sticky Amber | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V42 | 47 | L1961 | M092 Segment Worm | `Mirrored` | `{"kind": "Mirrored"}` |
| V43 | 48 | L1971 | M094 Paint Bloom | `Fogged` | `{"kind": "Fogged"}` |
| V44 | 49 | L1981 | M103 Day-Night Burrows| `Chained` | `{"kind": "Chained", "linkedId": "o103_c"}` |
| V45 | 49 | L1985 | M002 Hollow Log | `Armored` | `{"kind": "Armored"}` |


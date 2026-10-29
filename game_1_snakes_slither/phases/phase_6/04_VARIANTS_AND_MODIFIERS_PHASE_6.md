# 04 — Variants & Modifiers (Phase 6)
> Phase 6 (Sun Temple Light) માં વપરાતા 45 variant slots, 10 generic modifiers નું Optics mechanics સાથે mapping અને વર્તણૂક નિયમો.

**Related docs:** [Phase 6 index](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_2501_3000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md)

---

## 1. Optics Variant Architecture
- પ્રકાશ અને અરીસાઓ પર મોડિફાયર્સ (દા.ત. `Phasing`, `Countdown`, `Frozen`, `Mirrored`) લાગુ થવાથી કોયડાઓમાં વિવિધ પરિમાણો ઉમેરાય છે:
  - `Phasing` Filter: માત્ર Even moves પર જ બીમનો રંગ બદલે છે; Odd moves પર બીમ સીધું પાસ થાય છે.
  - `Countdown(N)` Prism Lock: પ્રથમ $N$ મૂવ્સમાં જ $\ge 2$ કિરણો મેળવવા પડે છે.
  - `Frozen(K)` Mirror: નજીકના સાપ મુક્ત થાય તે પછી જ અરીસો રોટેટ થઈ શકે છે.

---

## 2. 45 Variant Slots Mapping Table (Phase 6)

| Slot | Block | Level | Base Mechanic | Modifier | JSON `params.mod` |
|---|---|---|---|---|---|
| V01 | 3 | L2521 | M251 Petal Filter | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V02 | 4 | L2531 | M251 Petal Filter | `Colored(ruby)` | `{"kind": "Colored", "color": "ruby"}` |
| V03 | 5 | L2541 | M251 Petal Filter | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| V04 | 6 | L2551 | M251 Petal Filter | `Phasing` | `{"kind": "Phasing"}` |
| V05 | 7 | L2561 | M251 Petal Filter | `Armored` | `{"kind": "Armored"}` |
| V06 | 8 | L2571 | M004 Lily Pad | `Chained` | `{"kind": "Chained", "linkedId": "o04_b"}` |
| V07 | 9 | L2581 | M009 Vine Gate | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V08 | 10 | L2591 | M014 Bamboo Ramp | `Mirrored` | `{"kind": "Mirrored"}` |
| V09 | 11 | L2601 | M020 Burrow | `Fogged` | `{"kind": "Fogged"}` |
| V10 | 12 | L2611 | M053 Rolling Coconut | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| V11 | 13 | L2621 | M201 Coconut Pit | `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| V12 | 15 | L2641 | M252 Prism Lock | `Colored(cyan)` | `{"kind": "Colored", "color": "cyan"}` |
| V13 | 16 | L2651 | M252 Prism Lock | `Countdown(10)` | `{"kind": "Countdown", "n": 10}` |
| V14 | 17 | L2661 | M252 Prism Lock | `Chained` | `{"kind": "Chained", "linkedId": "o252_b"}` |
| V15 | 18 | L2671 | M058 Periodic Gate | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V16 | 19 | L2681 | M063 Swamp Mud | `Armored` | `{"kind": "Armored"}` |
| V17 | 20 | L2691 | M069 Treetop Platform| `Colored(emerald)`| `{"kind": "Colored", "color": "emerald"}` |
| V18 | 21 | L2701 | M070 Canopy Fan | `Phasing` | `{"kind": "Phasing"}` |
| V19 | 22 | L2711 | M084 Sunbeam Reflector| `Mirrored` | `{"kind": "Mirrored"}` |
| V20 | 23 | L2721 | M086 Crystal Prism | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V21 | 24 | L2731 | M090 Sun Dial Gate | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| V22 | 25 | L2741 | M202 Dew-Slick Coconut| `Fogged` | `{"kind": "Fogged"}` |
| V23 | 27 | L2761 | M253 Sundial Receiver | `Colored(gold)` | `{"kind": "Colored", "color": "gold"}` |
| V24 | 28 | L2771 | M253 Sundial Receiver | `Countdown(6)` | `{"kind": "Countdown", "n": 6}` |
| V25 | 29 | L2781 | M253 Sundial Receiver | `Chained` | `{"kind": "Chained", "linkedId": "o253_b"}` |
| V26 | 30 | L2791 | M253 Sundial Receiver | `Frozen(4)` | `{"kind": "Frozen", "k": 4}` |
| V27 | 31 | L2801 | M001 Stone Blocker | `Growing(2)` | `{"kind": "Growing", "n": 2}` |
| V28 | 32 | L2811 | M007 Ant Nest | `Layered(0)` | `{"kind": "Layered", "layer": 0}` |
| V29 | 33 | L2821 | M025 Gecko Sentry | `Armored` | `{"kind": "Armored"}` |
| V30 | 34 | L2831 | M032 Canopy Leaf | `Colored(violet)` | `{"kind": "Colored", "color": "violet"}` |
| V31 | 35 | L2841 | M042 Fragile Vine Bridge| `Phasing` | `{"kind": "Phasing"}` |
| V32 | 36 | L2851 | M051 Sidewinder Snake | `Fogged` | `{"kind": "Fogged"}` |
| V33 | 37 | L2861 | M054 Ice Slide Crate | `Mirrored` | `{"kind": "Mirrored"}` |
| V34 | 39 | L2881 | M254 Shade Leaves | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| V35 | 40 | L2891 | M254 Shade Leaves | `Chained` | `{"kind": "Chained", "linkedId": "o254_b"}` |
| V36 | 41 | L2901 | M254 Shade Leaves | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V37 | 42 | L2911 | M060 Chameleon Log | `Colored(amber)` | `{"kind": "Colored", "color": "amber"}` |
| V38 | 43 | L2921 | M067 Quicksand | `Armored` | `{"kind": "Armored"}` |
| V39 | 44 | L2931 | M075 Creeping Moss | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| V40 | 45 | L2941 | M082 River Rapids Belt| `Phasing` | `{"kind": "Phasing"}` |
| V41 | 46 | L2951 | M087 Sticky Amber | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V42 | 47 | L2961 | M092 Segment Worm | `Mirrored` | `{"kind": "Mirrored"}` |
| V43 | 48 | L2971 | M094 Paint Bloom | `Fogged` | `{"kind": "Fogged"}` |
| V44 | 49 | L2981 | M203 Key Coconut | `Chained` | `{"kind": "Chained", "linkedId": "o203_c"}` |
| V45 | 49 | L2985 | M002 Hollow Log | `Armored` | `{"kind": "Armored"}` |

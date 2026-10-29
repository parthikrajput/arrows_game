# 04 — Variants & Modifiers (Phase 8)
> Phase 8 (Overgrown Garden) માં વપરાતા 45 variant slots, 10 generic modifiers નું Growth mechanics સાથે mapping અને વર્તણૂક નિયમો.

**Related docs:** [Phase 8 index](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_3501_4000.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md)

---

## 1. Growth Variant Architecture
- વેલો અને અંકુરણ મિકેનિક્સ પર મોડિફાયર્સ (દા.ત. `Frozen`, `Colored`, `Phasing`, `Growing`, `Armored`) રોમાંચક પરિણામો આપે છે:
  - `Armored` Wild Vine: હેમરથી કાપી શકાતી નથી; માત્ર પ્રૂનિંગ ટાઈલ (M352) થી જ સાફ થાય છે!
  - `Colored(c)` Pruning Tile: માત્ર $c$ રંગનો સાપ પસાર થાય ત્યારે જ કાપણી સક્રિય કરે છે.
  - `Phasing` Seed Pod: માત્ર Even મૂવ્સ પર જ જમીન પર સક્રિય રહે છે.

---

## 2. 45 Variant Slots Mapping Table (Phase 8)

| Slot | Block | Level | Base Mechanic | Modifier | JSON `params.mod` |
|---|---|---|---|---|---|
| V01 | 3 | L3521 | M351 Wild Vine | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V02 | 4 | L3531 | M351 Wild Vine | `Colored(emerald)`| `{"kind": "Colored", "color": "emerald"}` |
| V03 | 5 | L3541 | M351 Wild Vine | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| V04 | 6 | L3551 | M351 Wild Vine | `Phasing` | `{"kind": "Phasing"}` |
| V05 | 7 | L3561 | M351 Wild Vine | `Armored` | `{"kind": "Armored"}` |
| V06 | 8 | L3571 | M004 Lily Pad | `Chained` | `{"kind": "Chained", "linkedId": "o04_b"}` |
| V07 | 9 | L3581 | M009 Vine Gate | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V08 | 10 | L3591 | M014 Bamboo Ramp | `Mirrored` | `{"kind": "Mirrored"}` |
| V09 | 11 | L3601 | M020 Burrow | `Fogged` | `{"kind": "Fogged"}` |
| V10 | 12 | L3611 | M053 Rolling Coconut | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| V11 | 13 | L3621 | M301 Island Spinner | `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| V12 | 15 | L3641 | M352 Pruner Tile | `Colored(cyan)` | `{"kind": "Colored", "color": "cyan"}` |
| V13 | 16 | L3651 | M352 Pruner Tile | `Countdown(10)` | `{"kind": "Countdown", "n": 10}` |
| V14 | 17 | L3661 | M352 Pruner Tile | `Chained` | `{"kind": "Chained", "linkedId": "o352_b"}` |
| V15 | 18 | L3671 | M058 Periodic Gate | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V16 | 19 | L3681 | M063 Swamp Mud | `Armored` | `{"kind": "Armored"}` |
| V17 | 20 | L3691 | M069 Treetop Platform| `Colored(ruby)` | `{"kind": "Colored", "color": "ruby"}` |
| V18 | 21 | L3701 | M070 Canopy Fan | `Phasing` | `{"kind": "Phasing"}` |
| V19 | 22 | L3711 | M084 Sunbeam Reflector| `Mirrored` | `{"kind": "Mirrored"}` |
| V20 | 23 | L3721 | M086 Crystal Prism | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V21 | 24 | L3731 | M090 Sun Dial Gate | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| V22 | 25 | L3741 | M302 Turning Hedges | `Fogged` | `{"kind": "Fogged"}` |
| V23 | 27 | L3761 | M353 Seed-Carrier Snake| `Colored(gold)`| `{"kind": "Colored", "color": "gold"}` |
| V24 | 28 | L3771 | M353 Seed-Carrier Snake| `Countdown(6)` | `{"kind": "Countdown", "n": 6}` |
| V25 | 29 | L3781 | M353 Seed-Carrier Snake| `Chained` | `{"kind": "Chained", "linkedId": "p_seed_b"}`|
| V26 | 30 | L3791 | M353 Seed-Carrier Snake| `Frozen(4)` | `{"kind": "Frozen", "k": 4}` |
| V27 | 31 | L3801 | M001 Stone Blocker | `Growing(2)` | `{"kind": "Growing", "n": 2}` |
| V28 | 32 | L3811 | M007 Ant Nest | `Layered(0)` | `{"kind": "Layered", "layer": 0}` |
| V29 | 33 | L3821 | M025 Gecko Sentry | `Armored` | `{"kind": "Armored"}` |
| V30 | 34 | L3831 | M032 Canopy Leaf | `Colored(violet)` | `{"kind": "Colored", "color": "violet"}` |
| V31 | 35 | L3841 | M042 Fragile Vine Bridge| `Phasing` | `{"kind": "Phasing"}` |
| V32 | 36 | L3851 | M051 Sidewinder Snake | `Fogged` | `{"kind": "Fogged"}` |
| V33 | 37 | L3861 | M054 Ice Slide Crate | `Mirrored` | `{"kind": "Mirrored"}` |
| V34 | 39 | L3881 | M354 Bloom Gate | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| V35 | 40 | L3891 | M354 Bloom Gate | `Chained` | `{"kind": "Chained", "linkedId": "o354_b"}` |
| V36 | 41 | L3901 | M354 Bloom Gate | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V37 | 42 | L3911 | M060 Chameleon Log | `Colored(amber)` | `{"kind": "Colored", "color": "amber"}` |
| V38 | 43 | L3921 | M067 Quicksand | `Armored` | `{"kind": "Armored"}` |
| V39 | 44 | L3931 | M075 Creeping Moss | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| V40 | 45 | L3941 | M082 River Rapids Belt| `Phasing` | `{"kind": "Phasing"}` |
| V41 | 46 | L3951 | M087 Sticky Amber | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V42 | 47 | L3961 | M092 Segment Worm | `Mirrored` | `{"kind": "Mirrored"}` |
| V43 | 48 | L3971 | M094 Paint Bloom | `Fogged` | `{"kind": "Fogged"}` |
| V44 | 49 | L3981 | M303 Spinning Snake | `Chained` | `{"kind": "Chained", "linkedId": "p_spin_c"}`|
| V45 | 49 | L3985 | M002 Hollow Log | `Armored` | `{"kind": "Armored"}` |

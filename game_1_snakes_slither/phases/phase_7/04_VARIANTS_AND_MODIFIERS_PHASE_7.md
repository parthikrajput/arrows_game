# 04 — Variants & Modifiers (Phase 7)
> Phase 7 (Whirlwind Valley) માં વપરાતા 45 variant slots, 10 generic modifiers નું Rotation mechanics સાથે mapping અને વર્તણૂક નિયમો.

**Related docs:** [Phase 7 index](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_3001_3500.md) · [03 Signature & Mechanics](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md)

---

## 1. Rotation Variant Architecture
- રોટેશન મિકેનિક્સ સાથે મોડિફાયર્સ (દા.ત. `Mirrored`, `Frozen`, `Countdown`, `Layered`) અનન્ય પરિણામો આપે છે:
  - `Mirrored` Spinner: Clockwise ને બદલે Counter-Clockwise (CCW) દિશામાં ફરે છે!
  - `Frozen(K)` Spinning Snake: પાડોશી સાપ નીકળે ત્યાં સુધી સ્થિર રહે છે; મુક્ત થતાં ફરવાનું શરૂ કરે છે.
  - `Countdown(N)` Turning Hedges: પ્રથમ $N$ મૂવ્સ સુધી જ ફરે છે, પછી સ્થિર દિવાલ બની જાય છે.

---

## 2. 45 Variant Slots Mapping Table (Phase 7)

| Slot | Block | Level | Base Mechanic | Modifier | JSON `params.mod` |
|---|---|---|---|---|---|
| V01 | 3 | L3021 | M301 Island Spinner | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V02 | 4 | L3031 | M301 Island Spinner | `Colored(amber)` | `{"kind": "Colored", "color": "amber"}` |
| V03 | 5 | L3041 | M301 Island Spinner | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| V04 | 6 | L3051 | M301 Island Spinner | `Phasing` | `{"kind": "Phasing"}` |
| V05 | 7 | L3061 | M301 Island Spinner | `Armored` | `{"kind": "Armored"}` |
| V06 | 8 | L3071 | M004 Lily Pad | `Chained` | `{"kind": "Chained", "linkedId": "o04_b"}` |
| V07 | 9 | L3081 | M009 Vine Gate | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V08 | 10 | L3091 | M014 Bamboo Ramp | `Mirrored` | `{"kind": "Mirrored"}` |
| V09 | 11 | L3101 | M020 Burrow | `Fogged` | `{"kind": "Fogged"}` |
| V10 | 12 | L3111 | M053 Rolling Coconut | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| V11 | 13 | L3121 | M251 Petal Filter | `Frozen(2)` | `{"kind": "Frozen", "k": 2}` |
| V12 | 15 | L3141 | M302 Turning Hedges | `Colored(cyan)` | `{"kind": "Colored", "color": "cyan"}` |
| V13 | 16 | L3151 | M302 Turning Hedges | `Countdown(10)` | `{"kind": "Countdown", "n": 10}` |
| V14 | 17 | L3161 | M302 Turning Hedges | `Chained` | `{"kind": "Chained", "linkedId": "o302_b"}` |
| V15 | 18 | L3171 | M058 Periodic Gate | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V16 | 19 | L3181 | M063 Swamp Mud | `Armored` | `{"kind": "Armored"}` |
| V17 | 20 | L3191 | M069 Treetop Platform| `Colored(gold)` | `{"kind": "Colored", "color": "gold"}` |
| V18 | 21 | L3201 | M070 Canopy Fan | `Phasing` | `{"kind": "Phasing"}` |
| V19 | 22 | L3211 | M084 Sunbeam Reflector| `Mirrored` | `{"kind": "Mirrored"}` |
| V20 | 23 | L3221 | M086 Crystal Prism | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V21 | 24 | L3231 | M090 Sun Dial Gate | `Layered(1)` | `{"kind": "Layered", "layer": 1}` |
| V22 | 25 | L3241 | M252 Prism Lock | `Fogged` | `{"kind": "Fogged"}` |
| V23 | 27 | L3261 | M303 Spinning Snake | `Colored(ruby)` | `{"kind": "Colored", "color": "ruby"}` |
| V24 | 28 | L3271 | M303 Spinning Snake | `Countdown(6)` | `{"kind": "Countdown", "n": 6}` |
| V25 | 29 | L3281 | M303 Spinning Snake | `Chained` | `{"kind": "Chained", "linkedId": "p_spin_b"}`|
| V26 | 30 | L3291 | M303 Spinning Snake | `Frozen(4)` | `{"kind": "Frozen", "k": 4}` |
| V27 | 31 | L3301 | M001 Stone Blocker | `Growing(2)` | `{"kind": "Growing", "n": 2}` |
| V28 | 32 | L3311 | M007 Ant Nest | `Layered(0)` | `{"kind": "Layered", "layer": 0}` |
| V29 | 33 | L3321 | M025 Gecko Sentry | `Armored` | `{"kind": "Armored"}` |
| V30 | 34 | L3331 | M032 Canopy Leaf | `Colored(mint)` | `{"kind": "Colored", "color": "mint"}` |
| V31 | 35 | L3341 | M042 Fragile Vine Bridge| `Phasing` | `{"kind": "Phasing"}` |
| V32 | 36 | L3351 | M051 Sidewinder Snake | `Fogged` | `{"kind": "Fogged"}` |
| V33 | 37 | L3361 | M054 Ice Slide Crate | `Mirrored` | `{"kind": "Mirrored"}` |
| V34 | 39 | L3381 | M304 Gear Lock | `Countdown(8)` | `{"kind": "Countdown", "n": 8}` |
| V35 | 40 | L3391 | M304 Gear Lock | `Chained` | `{"kind": "Chained", "linkedId": "o304_b"}` |
| V36 | 41 | L3401 | M304 Gear Lock | `Frozen(3)` | `{"kind": "Frozen", "k": 3}` |
| V37 | 42 | L3411 | M060 Chameleon Log | `Colored(bronze)`| `{"kind": "Colored", "color": "bronze"}` |
| V38 | 43 | L3421 | M067 Quicksand | `Armored` | `{"kind": "Armored"}` |
| V39 | 44 | L3431 | M075 Creeping Moss | `Layered(2)` | `{"kind": "Layered", "layer": 2}` |
| V40 | 45 | L3441 | M082 River Rapids Belt| `Phasing` | `{"kind": "Phasing"}` |
| V41 | 46 | L3451 | M087 Sticky Amber | `Growing(3)` | `{"kind": "Growing", "n": 3}` |
| V42 | 47 | L3461 | M092 Segment Worm | `Mirrored` | `{"kind": "Mirrored"}` |
| V43 | 48 | L3471 | M094 Paint Bloom | `Fogged` | `{"kind": "Fogged"}` |
| V44 | 49 | L3481 | M253 Sundial Receiver | `Chained` | `{"kind": "Chained", "linkedId": "o253_c"}` |
| V45 | 49 | L3485 | M002 Hollow Log | `Armored` | `{"kind": "Armored"}` |

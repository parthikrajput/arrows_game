# 04 — Variants & Modifiers, Phase 7 (વેરિઅન્ટ્સ)
> Phase 7 ના 45 વેરિઅન્ટ સ્લોટ્સ: Whirling Garden Mechanics × 10 Modifiers ના સંયોજનો અને નિયમો.

**Related docs:** [Phase 7 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_3001_3500.md)

---

## 1. Variant Architecture in Phase 7
Phase 7 ના 45 variant slots (Blocks 3–49 માં x1 સ્લોટ્સ, 14, 26, 38 સિવાય) રોટેશનલ મિકેનિક્સ અને 10 પ્રમાણિત મોડિફાયર્સનું સંયોજન છે:
- **Modifiers:** `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered(mask)`, `Mirrored`, `Growing(N)`.

## 2. Phase 7 Variant Slot Definitions (45 Slots)
| Block | Level | Variant Themed Name | Base × Modifier |
|---|---|---|---|
| **3** | L3021 | Frozen Turntable | M301 × `Frozen(2)` |
| **4** | L3031 | Colored Turntable | M301 × `Colored(Yellow)` |
| **5** | L3041 | Fogged Turntable | M301 × `Fogged` |
| **6** | L3051 | Chained Turntables | M301 × `Chained` |
| **7** | L3061 | Countdown Turntable | M301 × `Countdown(6)` |
| **8** | L3071 | Phasing Turntable | M301 × `Phasing` |
| **9** | L3081 | Mirrored Turntables | M301 × `Mirrored` |
| **10** | L3091 | Armored Turntable Core | M301 × `Armored` |
| **11** | L3101 | Growing Turning Hedge | M302 × `Growing(4)` |
| **12** | L3111 | Layered Turntable | M301 × `Layered(ground)` |
| **13** | L3121 | Frozen Turning Hedge | M302 × `Frozen(3)` |
| **15** | L3141 | Colored Turning Hedge | M302 × `Colored(Red)` |
| **16** | L3151 | Fogged Turning Hedge | M302 × `Fogged` |
| **17** | L3161 | Chained Turning Hedges | M302 × `Chained` |
| **18** | L3171 | Phasing Petal Filter | M251 × `Phasing` |
| **19** | L3181 | Countdown Turning Hedge | M302 × `Countdown(10)` |
| **20** | L3191 | Mirrored Turning Hedge | M302 × `Mirrored` |
| **21** | L3201 | Armored Turning Hedge | M302 × `Armored` |
| **22** | L3211 | Layered Turning Hedge | M302 × `Layered(air)` |
| **23** | L3221 | Growing Thorn Cluster | M002 × `Growing(3)` |
| **24** | L3231 | Frozen Spinning Top Line | M303 × `Frozen(1)` |
| **25** | L3241 | Colored Spinning Top Line | M303 × `Colored(Blue)` |
| **27** | L3261 | Fogged Spinning Top Line | M303 × `Fogged` |
| **28** | L3271 | Chained Spinning Top Lines | M303 × `Chained` |
| **29** | L3281 | Countdown Spinning Top Line | M303 × `Countdown(8)` |
| **30** | L3291 | Phasing Dewdrop Marble | M202 × `Phasing` |
| **31** | L3301 | Mirrored Spinning Top Line | M303 × `Mirrored` |
| **32** | L3311 | Armored Twin-Sun Lock | M252 × `Armored` |
| **33** | L3321 | Layered Spinning Top Line | M303 × `Layered(canopy)` |
| **34** | L3331 | Frozen Pinned Daisy | M304 × `Frozen(2)` |
| **35** | L3341 | Growing Ivy Tangle | M074 × `Growing(4)` |
| **36** | L3351 | Colored Pinned Daisy | M304 × `Colored(Pink)` |
| **37** | L3361 | Countdown Pinned Daisy | M304 × `Countdown(10)` |
| **39** | L3381 | Fogged Pinned Daisy | M304 × `Fogged` |
| **40** | L3391 | Chained Pinned Daisies | M304 × `Chained` |
| **41** | L3401 | Phasing Pinned Daisy | M304 × `Phasing` |
| **42** | L3411 | Mirrored Pinned Daisy | M304 × `Mirrored` |
| **43** | L3421 | Armored Stone Pumpkin | M204 × `Armored` |
| **44** | L3431 | Layered Pinned Daisy | M304 × `Layered(ground)` |
| **45** | L3441 | Growing Hedge Border | M071 × `Growing(5)` |
| **46** | L3451 | Colored Compass Rose | M070 × `Colored(Orange)` |
| **47** | L3461 | Countdown Sundial Lens | M253 × `Countdown(12)` |
| **48** | L3471 | Phasing Acorn Lift | M154 × `Phasing` |
| **49** | L3481 | Chained Honeycomb Arch | M005 × `Chained` |

*(45 slots standard compatibility constraints સાથે સંતુલિત).*

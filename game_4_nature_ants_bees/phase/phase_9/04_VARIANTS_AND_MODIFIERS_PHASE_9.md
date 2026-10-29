# 04 — Variants & Modifiers, Phase 9 (વેરિઅન્ટ્સ)
> Phase 9 ના 45 વેરિઅન્ટ સ્લોટ્સ: Swarm Splits Mechanics × 10 Modifiers ના સંયોજનો અને નિયમો.

**Related docs:** [Phase 9 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_4001_4500.md)

---

## 1. Variant Architecture in Phase 9
Phase 9 ના 45 variant slots (Blocks 3–49 માં x1 સ્લોટ્સ, 14, 26, 38 સિવાય) સ્પ્લિટ/મર્જ મિકેનિક્સ અને 10 પ્રમાણિત મોડિફાયર્સનું સંયોજન છે:
- **Modifiers:** `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered(mask)`, `Mirrored`, `Growing(N)`.

## 2. Phase 9 Variant Slot Definitions (45 Slots)
| Block | Level | Variant Themed Name | Base × Modifier |
|---|---|---|---|
| **3** | L4021 | Frozen Honey Merge Pad | M401 × `Frozen(2)` |
| **4** | L4031 | Colored Honey Merge Pad | M401 × `Colored(Gold)` |
| **5** | L4041 | Fogged Honey Merge Pad | M401 × `Fogged` |
| **6** | L4051 | Chained Honey Merge Pads | M401 × `Chained` |
| **7** | L4061 | Countdown Honey Merge Pad | M401 × `Countdown(8)` |
| **8** | L4071 | Phasing Honey Merge Pad | M401 × `Phasing` |
| **9** | L4081 | Mirrored Honey Merge Pad | M401 × `Mirrored` |
| **10** | L4091 | Armored Honey Merge Pad | M401 × `Armored` |
| **11** | L4101 | Growing Bramble Patch | M002 × `Growing(4)` |
| **12** | L4111 | Layered Honey Merge Pad | M401 × `Layered(ground)` |
| **13** | L4121 | Frozen Fork Twig | M402 × `Frozen(2)` |
| **15** | L4141 | Colored Fork Twig | M402 × `Colored(Red)` |
| **16** | L4151 | Fogged Fork Twig | M402 × `Fogged` |
| **17** | L4161 | Chained Fork Twigs | M402 × `Chained` |
| **18** | L4171 | Phasing Turntable | M301 × `Phasing` |
| **19** | L4181 | Countdown Fork Twig | M402 × `Countdown(10)` |
| **20** | L4191 | Mirrored Fork Twig | M402 × `Mirrored` |
| **21** | L4201 | Armored Fork Twig | M402 × `Armored` |
| **22** | L4211 | Layered Fork Twig | M402 × `Layered(air)` |
| **23** | L4221 | Growing Ivy Tangle | M074 × `Growing(3)` |
| **24** | L4231 | Frozen Segment Clasp | M403 × `Frozen(1)` |
| **25** | L4241 | Colored Segment Clasp | M403 × `Colored(Blue)` |
| **27** | L4261 | Fogged Segment Clasp | M403 × `Fogged` |
| **28** | L4271 | Chained Segment Clasps | M403 × `Chained` |
| **29** | L4281 | Countdown Segment Clasp | M403 × `Countdown(7)` |
| **30** | L4291 | Phasing Garden Shears | M352 × `Phasing` |
| **31** | L4301 | Mirrored Segment Clasp | M403 × `Mirrored` |
| **32** | L4311 | Armored Morning Glory | M351 × `Armored` |
| **33** | L4321 | Layered Segment Clasp | M403 × `Layered(canopy)` |
| **34** | L4331 | Frozen Reunion Arch | M404 × `Frozen(3)` |
| **35** | L4341 | Growing Moss Spores | M027 × `Growing(5)` |
| **36** | L4351 | Colored Reunion Arch | M404 × `Colored(Yellow)` |
| **37** | L4361 | Countdown Reunion Arch | M404 × `Countdown(12)` |
| **39** | L4381 | Fogged Reunion Arch | M404 × `Fogged` |
| **40** | L4391 | Chained Reunion Arches | M404 × `Chained` |
| **41** | L4401 | Phasing Reunion Arch | M404 × `Phasing` |
| **42** | L4411 | Mirrored Reunion Arch | M404 × `Mirrored` |
| **43** | L4421 | Armored Pollination Gate | M354 × `Armored` |
| **44** | L4431 | Layered Reunion Arch | M404 × `Layered(ground)` |
| **45** | L4441 | Growing Hedge Wall | M071 × `Growing(4)` |
| **46** | L4451 | Colored Spinning Top Line | M303 × `Colored(Purple)` |
| **47** | L4461 | Countdown Petal Filter | M251 × `Countdown(9)` |
| **48** | L4471 | Phasing Dewdrop Marble | M202 × `Phasing` |
| **49** | L4481 | Chained Honeycomb Arch | M005 × `Chained` |

*(45 slots standard compatibility constraints સાથે સંતુલિત).*


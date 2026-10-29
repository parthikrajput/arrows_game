# 04 — Variants & Modifiers, Phase 13 (વેરિઅન્ટ્સ)
> Phase 13 ના 45 વેરિઅન્ટ સ્લોટ્સ: Mystery Meadow Mechanics × 10 Modifiers ના સંયોજનો અને નિયમો.

**Related docs:** [Phase 13 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_6001_6500.md)

---

## 1. Variant Architecture in Phase 13
Phase 13 ના 45 variant slots (Blocks 3–49 માં x1 સ્લોટ્સ, 14, 26, 38 સિવાય) હિડન ઇન્ફો મિકેનિક્સ અને 10 પ્રમાણિત મોડિફાયર્સનું સંયોજન છે:
- **Modifiers:** `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered(mask)`, `Mirrored`, `Growing(N)`.

## 2. Phase 13 Variant Slot Definitions (45 Slots)
| Block | Level | Variant Themed Name | Base × Modifier |
|---|---|---|---|
| **3** | L6021 | Frozen Scout Ant | M601 × `Frozen(2)` |
| **4** | L6031 | Colored Scout Ant | M601 × `Colored(Yellow)` |
| **5** | L6041 | Fogged Scout Ant | M601 × `Fogged` |
| **6** | L6051 | Chained Scout Ants | M601 × `Chained` |
| **7** | L6061 | Countdown Scout Ant | M601 × `Countdown(8)` |
| **8** | L6071 | Phasing Scout Ant | M601 × `Phasing` |
| **9** | L6081 | Mirrored Scout Ant | M601 × `Mirrored` |
| **10** | L6091 | Armored Scout Ant | M601 × `Armored` |
| **11** | L6101 | Growing Bramble Patch | M002 × `Growing(4)` |
| **12** | L6111 | Layered Scout Ant | M601 × `Layered(ground)` |
| **13** | L6121 | Frozen Mirage Mist | M602 × `Frozen(2)` |
| **15** | L6141 | Colored Mirage Mist | M602 × `Colored(White)` |
| **16** | L6151 | Fogged Mirage Mist | M602 × `Fogged` |
| **17** | L6161 | Chained Mirage Mists | M602 × `Chained` |
| **18** | L6171 | Phasing Wind-Vane Lever | M551 × `Phasing` |
| **19** | L6181 | Countdown Mirage Mist | M602 × `Countdown(10)` |
| **20** | L6191 | Mirrored Mirage Mist | M602 × `Mirrored` |
| **21** | L6201 | Armored Mirage Mist | M602 × `Armored` |
| **22** | L6211 | Layered Mirage Mist | M602 × `Layered(air)` |
| **23** | L6221 | Growing Ivy Tangle | M074 × `Growing(3)` |
| **24** | L6231 | Frozen Painted Pebble | M603 × `Frozen(1)` |
| **25** | L6241 | Colored Painted Pebble | M603 × `Colored(Blue)` |
| **27** | L6261 | Fogged Painted Pebble | M603 × `Fogged` |
| **28** | L6271 | Chained Painted Pebbles | M603 × `Chained` |
| **29** | L6281 | Countdown Painted Pebble | M603 × `Countdown(7)` |
| **30** | L6291 | Phasing Falling Acorns | M552 × `Phasing` |
| **31** | L6301 | Mirrored Painted Pebble | M603 × `Mirrored` |
| **32** | L6311 | Armored Cricket Gate | M451 × `Armored` |
| **33** | L6321 | Layered Painted Pebble | M603 × `Layered(canopy)` |
| **34** | L6331 | Frozen Sunlit Plate | M604 × `Frozen(3)` |
| **35** | L6341 | Growing Moss Spores | M027 × `Growing(5)` |
| **36** | L6351 | Colored Sunlit Plate | M604 × `Colored(Gold)` |
| **37** | L6361 | Countdown Sunlit Plate | M604 × `Countdown(12)` |
| **39** | L6381 | Fogged Sunlit Plate | M604 × `Fogged` |
| **40** | L6391 | Chained Sunlit Plates | M604 × `Chained` |
| **41** | L6401 | Phasing Sunlit Plate | M604 × `Phasing` |
| **42** | L6411 | Mirrored Sunlit Plate | M604 × `Mirrored` |
| **43** | L6421 | Armored Garden Gate Link | M501 × `Armored` |
| **44** | L6431 | Layered Sunlit Plate | M604 × `Layered(ground)` |
| **45** | L6441 | Growing Hedge Wall | M071 × `Growing(4)` |
| **46** | L6451 | Colored Pen-Pal Key | M502 × `Colored(Amber)` |
| **47** | L6461 | Countdown Bead-String Lock | M452 × `Countdown(9)` |
| **48** | L6471 | Phasing Fork Twig | M402 × `Phasing` |
| **49** | L6481 | Chained Honeycomb Arch | M005 × `Chained` |

*(45 slots standard compatibility constraints સાથે સંતુલિત).*


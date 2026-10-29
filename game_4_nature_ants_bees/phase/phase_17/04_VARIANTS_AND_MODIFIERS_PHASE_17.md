# 04 — Variants & Modifiers, Phase 17 (વેરિઅન્ટ્સ)
> Phase 17 ના 45 વેરિઅન્ટ સ્લોટ્સ: Garden Guardians Mechanics × 10 Modifiers ના સંયોજનો અને નિયમો.

**Related docs:** [Phase 17 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7, §8](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_8001_8500.md)

---

## 1. Variant Architecture in Phase 17
Phase 17 ના 45 variant slots (Blocks 3–49 માં x1 સ્લોટ્સ, 14, 26, 38 સિવાય) ગાર્ડિયન્સ મિકેનિક્સ અને 10 પ્રમાણિત મોડિફાયર્સનું સંયોજન છે:
- **Modifiers:** `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered(mask)`, `Mirrored`, `Growing(N)`.
- **Compatibility Note (Standard §8):** બોસ ગાર્ડિયન્સ (M801–M804) પર `Phasing` કે `Countdown` લાગુ પડતાં નથી; તે મોડિફાયર્સ અન્ય સહાયક મિકેનિક્સ પર ઉપયોગમાં લેવાય છે.

## 2. Phase 17 Variant Slot Definitions (45 Slots)
| Block | Level | Variant Themed Name | Base × Modifier |
|---|---|---|---|
| **3** | L8021 | Frozen Twin Hornets | M801 × `Frozen(2)` |
| **4** | L8031 | Colored Twin Hornets | M801 × `Colored(Yellow)` |
| **5** | L8041 | Fogged Twin Hornets | M801 × `Fogged` |
| **6** | L8051 | Chained Twin Hornets | M801 × `Chained` |
| **7** | L8061 | Countdown Ivy Lever | M074 × `Countdown(8)` |
| **8** | L8071 | Phasing Dew Key Chain | M751 × `Phasing` |
| **9** | L8081 | Mirrored Twin Hornets | M801 × `Mirrored` |
| **10** | L8091 | Armored Twin Hornets | M801 × `Armored` |
| **11** | L8101 | Growing Bramble Thicket | M002 × `Growing(4)` |
| **12** | L8111 | Layered Twin Hornets | M801 × `Layered(ground)` |
| **13** | L8121 | Frozen Rhino Beetle | M802 × `Frozen(2)` |
| **15** | L8141 | Colored Rhino Beetle | M802 × `Colored(Black)` |
| **16** | L8151 | Fogged Rhino Beetle | M802 × `Fogged` |
| **17** | L8161 | Chained Rhino Beetles | M802 × `Chained` |
| **18** | L8171 | Phasing Crafting Flower | M752 × `Phasing` |
| **19** | L8181 | Countdown Brook Fork | M701 × `Countdown(10)` |
| **20** | L8191 | Mirrored Rhino Beetle | M802 × `Mirrored` |
| **21** | L8201 | Armored Rhino Spikes | M802 × `Armored` |
| **22** | L8211 | Layered Rhino Beetle | M802 × `Layered(air)` |
| **23** | L8221 | Growing Ivy Root | M074 × `Growing(3)` |
| **24** | L8231 | Frozen Wasp Nest | M803 × `Frozen(2)` |
| **25** | L8241 | Colored Wasp Nest | M803 × `Colored(Amber)` |
| **27** | L8261 | Fogged Wasp Nest | M803 × `Fogged` |
| **28** | L8271 | Chained Wasp Nests | M803 × `Chained` |
| **29** | L8281 | Countdown Sluice Lever | M703 × `Countdown(7)` |
| **30** | L8291 | Phasing Skeleton Key | M753 × `Phasing` |
| **31** | L8301 | Mirrored Wasp Nest | M803 × `Mirrored` |
| **32** | L8311 | Armored Spawner Shell | M803 × `Armored` |
| **33** | L8321 | Layered Wasp Nest | M803 × `Layered(canopy)` |
| **34** | L8331 | Frozen Heart-Seed Guardian | M804 × `Frozen(3)` |
| **35** | L8341 | Growing Moss Spores | M027 × `Growing(5)` |
| **36** | L8351 | Colored Heart-Seed Guardian | M804 × `Colored(Ruby)` |
| **37** | L8361 | Countdown Key Swap Pad | M754 × `Countdown(12)` |
| **39** | L8381 | Fogged Heart-Seed Guardian | M804 × `Fogged` |
| **40** | L8391 | Chained Heart-Seed Guardians | M804 × `Chained` |
| **41** | L8401 | Phasing Tide Brook | M702 × `Phasing` |
| **42** | L8411 | Mirrored Heart-Seed Guardian | M804 × `Mirrored` |
| **43** | L8421 | Armored Heart Core | M804 × `Armored` |
| **44** | L8431 | Layered Heart-Seed Guardian | M804 × `Layered(ground)` |
| **45** | L8441 | Growing Hedge Wall | M071 × `Growing(4)` |
| **46** | L8451 | Colored Pond Axis | M651 × `Colored(Blue)` |
| **47** | L8461 | Countdown Sunlit Plate | M604 × `Countdown(9)` |
| **48** | L8471 | Phasing Lazy River | M704 × `Phasing` |
| **49** | L8481 | Chained Honeycomb Arch | M005 × `Chained` |

*(45 slots standard compatibility constraints સાથે સંતુલિત).*


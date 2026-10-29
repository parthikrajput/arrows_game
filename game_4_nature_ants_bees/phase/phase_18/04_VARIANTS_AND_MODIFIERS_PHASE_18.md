# 04 — Variants & Modifiers, Phase 18 (વેરિઅન્ટ્સ)
> Phase 18 ના 45 વેરિઅન્ટ સ્લોટ્સ: Remix A Mechanics × 10 Modifiers ના સંયોજનો અને નિયમો.

**Related docs:** [Phase 18 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_8501_9000.md)

---

## 1. Variant Architecture in Phase 18
Phase 18 ના 45 variant slots (Blocks 3–49 માં x1 સ્લોટ્સ, 14, 26, 38 સિવાય) રીમિક્સ A મિકેનિક્સ અને 10 પ્રમાણિત મોડિફાયર્સનું સંયોજન છે:
- **Modifiers:** `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered(mask)`, `Mirrored`, `Growing(N)`.

## 2. Phase 18 Variant Slot Definitions (45 Slots)
| Block | Level | Variant Themed Name | Base × Modifier |
|---|---|---|---|
| **3** | L8521 | Frozen Day-Night Terrace | M851 × `Frozen(2)` |
| **4** | L8531 | Colored Day-Night Terrace | M851 × `Colored(Gold)` |
| **5** | L8541 | Fogged Day-Night Terrace | M851 × `Fogged` |
| **6** | L8551 | Chained Day-Night Terraces | M851 × `Chained` |
| **7** | L8561 | Countdown Day-Night Terrace | M851 × `Countdown(8)` |
| **8** | L8571 | Phasing Day-Night Terrace | M851 × `Phasing` |
| **9** | L8581 | Mirrored Day-Night Terrace | M851 × `Mirrored` |
| **10** | L8591 | Armored Day-Night Terrace | M851 × `Armored` |
| **11** | L8601 | Growing Bramble Patch | M002 × `Growing(4)` |
| **12** | L8611 | Layered Day-Night Terrace | M851 × `Layered(ground)` |
| **13** | L8621 | Frozen Sunlit Acorn | M852 × `Frozen(2)` |
| **15** | L8641 | Colored Sunlit Acorn | M852 × `Colored(Red)` |
| **16** | L8651 | Fogged Sunlit Acorn | M852 × `Fogged` |
| **17** | L8661 | Chained Sunlit Acorns | M852 × `Chained` |
| **18** | L8671 | Phasing Dew Key Chain | M751 × `Phasing` |
| **19** | L8681 | Countdown Sunlit Acorn | M852 × `Countdown(10)` |
| **20** | L8691 | Mirrored Sunlit Acorn | M852 × `Mirrored` |
| **21** | L8701 | Armored Sunlit Acorn | M852 × `Armored` |
| **22** | L8711 | Layered Sunlit Acorn | M852 × `Layered(air)` |
| **23** | L8721 | Growing Ivy Tangle | M074 × `Growing(3)` |
| **24** | L8731 | Frozen Shaded Stairs | M853 × `Frozen(1)` |
| **25** | L8741 | Colored Shaded Stairs | M853 × `Colored(Blue)` |
| **27** | L8761 | Fogged Shaded Stairs | M853 × `Fogged` |
| **28** | L8771 | Chained Shaded Stairs | M853 × `Chained` |
| **29** | L8781 | Countdown Shaded Stairs | M853 × `Countdown(7)` |
| **30** | L8791 | Phasing Brook Fork | M701 × `Phasing` |
| **31** | L8801 | Mirrored Shaded Stairs | M853 × `Mirrored` |
| **32** | L8811 | Armored Rhino Beetle | M802 × `Armored` |
| **33** | L8821 | Layered Shaded Stairs | M853 × `Layered(canopy)` |
| **34** | L8831 | Frozen Dawn Marble | M854 × `Frozen(3)` |
| **35** | L8841 | Growing Moss Spores | M027 × `Growing(5)` |
| **36** | L8851 | Colored Dawn Marble | M854 × `Colored(White)` |
| **37** | L8861 | Countdown Dawn Marble | M854 × `Countdown(12)` |
| **39** | L8881 | Fogged Dawn Marble | M854 × `Fogged` |
| **40** | L8891 | Chained Dawn Marbles | M854 × `Chained` |
| **41** | L8901 | Phasing Dawn Marble | M854 × `Phasing` |
| **42** | L8911 | Mirrored Dawn Marble | M854 × `Mirrored` |
| **43** | L8921 | Armored Crafting Flower | M752 × `Armored` |
| **44** | L8931 | Layered Dawn Marble | M854 × `Layered(ground)` |
| **45** | L8941 | Growing Hedge Border | M071 × `Growing(4)` |
| **46** | L8951 | Colored Pond Axis | M651 × `Colored(Amber)` |
| **47** | L8961 | Countdown Sluice Lever | M703 × `Countdown(9)` |
| **48** | L8971 | Phasing Skeleton Key | M753 × `Phasing` |
| **49** | L8981 | Chained Honeycomb Arch | M005 × `Chained` |

*(45 slots standard compatibility constraints સાથે સંતુલિત).*

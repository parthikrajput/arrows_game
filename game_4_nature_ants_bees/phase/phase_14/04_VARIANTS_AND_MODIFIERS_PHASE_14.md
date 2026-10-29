# 04 — Variants & Modifiers, Phase 14 (વેરિઅન્ટ્સ)
> Phase 14 ના 45 વેરિઅન્ટ સ્લોટ્સ: Reflecting Pond Mechanics × 10 Modifiers ના સંયોજનો અને નિયમો.

**Related docs:** [Phase 14 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_6501_7000.md)

---

## 1. Variant Architecture in Phase 14
Phase 14 ના 45 variant slots (Blocks 3–49 માં x1 સ્લોટ્સ, 14, 26, 38 સિવાય) મિરર વર્લ્ડ્સ મિકેનિક્સ અને 10 પ્રમાણિત મોડિફાયર્સનું સંયોજન છે:
- **Modifiers:** `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered(mask)`, `Mirrored`, `Growing(N)`.

## 2. Phase 14 Variant Slot Definitions (45 Slots)
| Block | Level | Variant Themed Name | Base × Modifier |
|---|---|---|---|
| **3** | L6521 | Frozen Pond Axis | M651 × `Frozen(2)` |
| **4** | L6531 | Colored Pond Axis | M651 × `Colored(Sky)` |
| **5** | L6541 | Fogged Pond Axis | M651 × `Fogged` |
| **6** | L6551 | Chained Pond Axes | M651 × `Chained` |
| **7** | L6561 | Countdown Pond Axis | M651 × `Countdown(8)` |
| **8** | L6571 | Phasing Pond Axis | M651 × `Phasing` |
| **9** | L6581 | Mirrored Pond Axis | M651 × `Mirrored` |
| **10** | L6591 | Armored Pond Axis | M651 × `Armored` |
| **11** | L6601 | Growing Bramble Edge | M002 × `Growing(4)` |
| **12** | L6611 | Layered Pond Axis | M651 × `Layered(ground)` |
| **13** | L6621 | Frozen Reflection Lock | M652 × `Frozen(2)` |
| **15** | L6641 | Colored Reflection Lock | M652 × `Colored(Blue)` |
| **16** | L6651 | Fogged Reflection Lock | M652 × `Fogged` |
| **17** | L6661 | Chained Reflection Locks | M652 × `Chained` |
| **18** | L6671 | Phasing Scout Ant | M601 × `Phasing` |
| **19** | L6681 | Countdown Reflection Lock | M652 × `Countdown(10)` |
| **20** | L6691 | Mirrored Reflection Lock | M652 × `Mirrored` |
| **21** | L6701 | Armored Reflection Lock | M652 × `Armored` |
| **22** | L6711 | Layered Reflection Lock | M652 × `Layered(air)` |
| **23** | L6721 | Growing Ivy Sprout | M074 × `Growing(3)` |
| **24** | L6731 | Frozen Twin Pond | M653 × `Frozen(1)` |
| **25** | L6741 | Colored Twin Pond | M653 × `Colored(Amber)` |
| **27** | L6761 | Fogged Twin Pond | M653 × `Fogged` |
| **28** | L6771 | Chained Twin Ponds | M653 × `Chained` |
| **29** | L6781 | Countdown Twin Pond | M653 × `Countdown(7)` |
| **30** | L6791 | Phasing Wind-Vane Lever | M551 × `Phasing` |
| **31** | L6801 | Mirrored Twin Pond | M653 × `Mirrored` |
| **32** | L6811 | Armored Cricket Gate | M451 × `Armored` |
| **33** | L6821 | Layered Twin Pond | M653 × `Layered(canopy)` |
| **34** | L6831 | Frozen Upside-Down Line | M654 × `Frozen(3)` |
| **35** | L6841 | Growing Moss Spores | M027 × `Growing(5)` |
| **36** | L6851 | Colored Upside-Down Line | M654 × `Colored(Red)` |
| **37** | L6861 | Countdown Upside-Down Line | M654 × `Countdown(12)` |
| **39** | L6881 | Fogged Upside-Down Line | M654 × `Fogged` |
| **40** | L6891 | Chained Upside-Down Lines | M654 × `Chained` |
| **41** | L6901 | Phasing Upside-Down Line | M654 × `Phasing` |
| **42** | L6911 | Mirrored Upside-Down Line | M654 × `Mirrored` |
| **43** | L6921 | Armored Garden Gate Link | M501 × `Armored` |
| **44** | L6931 | Layered Upside-Down Line | M654 × `Layered(ground)` |
| **45** | L6941 | Growing Hedge Border | M071 × `Growing(4)` |
| **46** | L6951 | Colored Sunlit Plate | M604 × `Colored(Gold)` |
| **47** | L6961 | Countdown Falling Acorns | M552 × `Countdown(9)` |
| **48** | L6971 | Phasing Bead-String Lock | M452 × `Phasing` |
| **49** | L6981 | Chained Honeycomb Arch | M005 × `Chained` |

*(45 slots standard compatibility constraints સાથે સંતુલિત).*


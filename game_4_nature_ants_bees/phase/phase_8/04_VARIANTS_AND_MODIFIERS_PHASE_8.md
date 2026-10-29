# 04 — Variants & Modifiers, Phase 8 (વેરિઅન્ટ્સ)
> Phase 8 ના 45 વેરિઅન્ટ સ્લોટ્સ: Bloom Season Mechanics × 10 Modifiers ના સંયોજનો અને નિયમો.

**Related docs:** [Phase 8 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_3501_4000.md)

---

## 1. Variant Architecture in Phase 8
Phase 8 ના 45 variant slots (Blocks 3–49 માં x1 સ્લોટ્સ, 14, 26, 38 સિવાય) ગ્રોથ મિકેનિક્સ અને 10 પ્રમાણિત મોડિફાયર્સનું સંયોજન છે:
- **Modifiers:** `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered(mask)`, `Mirrored`, `Growing(N)`.

## 2. Phase 8 Variant Slot Definitions (45 Slots)
| Block | Level | Variant Themed Name | Base × Modifier |
|---|---|---|---|
| **3** | L3521 | Frozen Morning Glory | M351 × `Frozen(2)` |
| **4** | L3531 | Colored Morning Glory | M351 × `Colored(Purple)` |
| **5** | L3541 | Fogged Morning Glory | M351 × `Fogged` |
| **6** | L3551 | Chained Morning Glories | M351 × `Chained` |
| **7** | L3561 | Countdown Morning Glory | M351 × `Countdown(8)` |
| **8** | L3571 | Phasing Morning Glory | M351 × `Phasing` |
| **9** | L3581 | Mirrored Morning Glory | M351 × `Mirrored` |
| **10** | L3591 | Armored Morning Glory Root | M351 × `Armored` |
| **11** | L3601 | Growing Bramble Thicket | M002 × `Growing(3)` |
| **12** | L3611 | Layered Morning Glory | M351 × `Layered(ground)` |
| **13** | L3621 | Frozen Garden Shears | M352 × `Frozen(2)` |
| **15** | L3641 | Colored Garden Shears | M352 × `Colored(Silver)` |
| **16** | L3651 | Fogged Garden Shears | M352 × `Fogged` |
| **17** | L3661 | Chained Garden Shears | M352 × `Chained` |
| **18** | L3671 | Phasing Turntable | M301 × `Phasing` |
| **19** | L3681 | Countdown Garden Shears | M352 × `Countdown(10)` |
| **20** | L3691 | Mirrored Garden Shears | M352 × `Mirrored` |
| **21** | L3701 | Armored Shears Base | M352 × `Armored` |
| **22** | L3711 | Layered Garden Shears | M352 × `Layered(air)` |
| **23** | L3721 | Growing Ivy Vine | M074 × `Growing(4)` |
| **24** | L3731 | Frozen Seed-Dropping Line | M353 × `Frozen(1)` |
| **25** | L3741 | Colored Seed-Dropping Line | M353 × `Colored(Amber)` |
| **27** | L3761 | Fogged Seed-Dropping Line | M353 × `Fogged` |
| **28** | L3771 | Chained Seed-Dropping Lines | M353 × `Chained` |
| **29** | L3781 | Countdown Seed-Dropping Line | M353 × `Countdown(7)` |
| **30** | L3791 | Phasing Spinning Top Line | M303 × `Phasing` |
| **31** | L3801 | Mirrored Seed-Dropping Line | M353 × `Mirrored` |
| **32** | L3811 | Armored Turning Hedge | M302 × `Armored` |
| **33** | L3821 | Layered Seed-Dropping Line | M353 × `Layered(canopy)` |
| **34** | L3831 | Frozen Pollination Gate | M354 × `Frozen(3)` |
| **35** | L3841 | Growing Moss Spores | M027 × `Growing(5)` |
| **36** | L3851 | Colored Pollination Gate | M354 × `Colored(Pink)` |
| **37** | L3861 | Countdown Pollination Gate | M354 × `Countdown(12)` |
| **39** | L3881 | Fogged Pollination Gate | M354 × `Fogged` |
| **40** | L3891 | Chained Pollination Gates | M354 × `Chained` |
| **41** | L3901 | Phasing Pollination Gate | M354 × `Phasing` |
| **42** | L3911 | Mirrored Pollination Gate | M354 × `Mirrored` |
| **43** | L3921 | Armored Pinned Daisy | M304 × `Armored` |
| **44** | L3931 | Layered Pollination Gate | M354 × `Layered(canopy)` |
| **45** | L3941 | Growing Hedge Wall | M071 × `Growing(4)` |
| **46** | L3951 | Colored Dewdrop Marble | M202 × `Colored(Green)` |
| **47** | L3961 | Countdown Petal Filter | M251 × `Countdown(9)` |
| **48** | L3971 | Phasing Acorn Lift | M154 × `Phasing` |
| **49** | L3981 | Chained Honeycomb Gate | M005 × `Chained` |

*(45 slots standard compatibility constraints સાથે સંતુલિત).*

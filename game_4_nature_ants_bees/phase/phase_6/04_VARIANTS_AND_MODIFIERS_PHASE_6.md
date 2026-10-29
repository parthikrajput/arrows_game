# 04 — Variants & Modifiers, Phase 6 (વેરિઅન્ટ્સ)
> Phase 6 ના 45 વેરિઅન્ટ સ્લોટ્સ: Sunlit Garden Mechanics × 10 Modifiers ના સંયોજનો અને નિયમો.

**Related docs:** [Phase 6 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_2501_3000.md)

---

## 1. Variant Architecture in Phase 6
Phase 6 ના 45 variant slots (Blocks 3–49 માં x1 સ્લોટ્સ, 14, 26, 38 સિવાય) ઓપ્ટિકલ મિકેનિક્સ અને 10 પ્રમાણિત મોડિફાયર્સનું સંયોજન છે:
- **Modifiers:** `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered(mask)`, `Mirrored`, `Growing(N)`.

## 2. Phase 6 Variant Slot Definitions (45 Slots)
| Block | Level | Variant Themed Name | Base × Modifier |
|---|---|---|---|
| **3** | L2521 | Frozen Petal Filter | M251 × `Frozen(2)` |
| **4** | L2531 | Colored Sunbeam Emitter | M084 × `Colored(Red)` |
| **5** | L2541 | Fogged Petal Filter | M251 × `Fogged` |
| **6** | L2551 | Chained Petal Filters | M251 × `Chained` |
| **7** | L2561 | Countdown Petal Filter | M251 × `Countdown(8)` |
| **8** | L2571 | Phasing Sunbeam Emitter | M084 × `Phasing` |
| **9** | L2581 | Mirrored Dew Prism | M089 × `Mirrored` |
| **10** | L2591 | Armored Sunflower Receiver | M085 × `Armored` |
| **11** | L2601 | Growing Bramble Patch | M002 × `Growing(4)` |
| **12** | L2611 | Layered Petal Filter | M251 × `Layered(canopy)` |
| **13** | L2621 | Frozen Sunflower Receiver | M085 × `Frozen(1)` |
| **15** | L2641 | Colored Twin-Sun Lock | M252 × `Colored(Yellow)` |
| **16** | L2651 | Fogged Twin-Sun Lock | M252 × `Fogged` |
| **17** | L2661 | Chained Twin-Sun Locks | M252 × `Chained` |
| **18** | L2671 | Phasing Dewdrop Marble | M202 × `Phasing` |
| **19** | L2681 | Countdown Sunflower Receiver | M085 × `Countdown(10)` |
| **20** | L2691 | Mirrored Twin-Sun Lock | M252 × `Mirrored` |
| **21** | L2701 | Armored Pinecone Bumper | M052 × `Armored` |
| **22** | L2711 | Layered Twin-Sun Lock | M252 × `Layered(air)` |
| **23** | L2721 | Growing Ivy Vine | M074 × `Growing(3)` |
| **24** | L2731 | Frozen Twin-Sun Lock | M252 × `Frozen(2)` |
| **25** | L2741 | Colored Dew Prism | M089 × `Colored(Blue)` |
| **27** | L2761 | Fogged Sundial Lens | M253 × `Fogged` |
| **28** | L2771 | Chained Sundial Lenses | M253 × `Chained` |
| **29** | L2781 | Countdown Sundial Lens | M253 × `Countdown(12)` |
| **30** | L2791 | Phasing Sunrise Gate | M101 × `Phasing` |
| **31** | L2801 | Mirrored Sundial Lens | M253 × `Mirrored` |
| **32** | L2811 | Armored Thorn Lock | M004 × `Armored` |
| **33** | L2821 | Layered Sundial Lens | M253 × `Layered(ground)` |
| **34** | L2831 | Frozen Sundial Lens | M253 × `Frozen(3)` |
| **35** | L2841 | Growing Moss Barrier | M027 × `Growing(5)` |
| **36** | L2851 | Colored Sleepy Tulip | M057 × `Colored(Purple)` |
| **37** | L2861 | Countdown Rolling Acorn | M053 × `Countdown(7)` |
| **39** | L2881 | Frozen Shade Patch | M254 × `Frozen(2)` |
| **40** | L2891 | Colored Shade Patch | M254 × `Colored(Green)` |
| **41** | L2901 | Fogged Shade Patch | M254 × `Fogged` |
| **42** | L2911 | Chained Shade Patches | M254 × `Chained` |
| **43** | L2921 | Phasing Shade Patch | M254 × `Phasing` |
| **44** | L2931 | Mirrored Shade Patch | M254 × `Mirrored` |
| **45** | L2941 | Armored Mole Hole | M201 × `Armored` |
| **46** | L2951 | Layered Shade Patch | M254 × `Layered(canopy)` |
| **47** | L2961 | Growing Hedge Thicket | M071 × `Growing(4)` |
| **48** | L2971 | Countdown Root Stairs | M151 × `Countdown(9)` |
| **49** | L2981 | Chained Honeycomb Walls | M005 × `Chained` |

*(45 slots standard compatibility constraints સાથે સંતુલિત).*

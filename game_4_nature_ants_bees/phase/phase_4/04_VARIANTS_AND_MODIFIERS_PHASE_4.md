# 04 — Variants & Modifiers, Phase 4 (વેરિઅન્ટ્સ)
> Phase 4 ના 45 વેરિઅન્ટ સ્લોટ્સ: Multi-Floor Mechanics × 10 Modifiers ના સંયોજનો અને નિયમો.

**Related docs:** [Phase 4 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_1501_2000.md)

---

## 1. Variant Architecture in Phase 4
Phase 4 ના 45 variant slots (Blocks 3–49 માં x1 સ્લોટ્સ, 14, 26, 38 સિવાય) Multi-Floor બેઝ મિકેનિક્સ અને 10 પ્રમાણિત મોડિફાયર્સનું સંયોજન છે:
- **Modifiers:** `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered(mask)`, `Mirrored`, `Growing(N)`.

## 2. Phase 4 Variant Slot Definitions (45 Slots)
| Block | Level | Variant Themed Name | Base × Modifier |
|---|---|---|---|
| **3** | L1521 | Frozen Root Stairs | M151 × `Frozen(2)` |
| **4** | L1531 | Colored Root Stairs | M151 × `Colored(Green)` |
| **5** | L1541 | Fogged Root Stairs | M151 × `Fogged` |
| **6** | L1551 | Chained Root Stairs | M151 × `Chained` |
| **7** | L1561 | Countdown Root Stairs | M151 × `Countdown(8)` |
| **8** | L1571 | Phasing Sunrise Gate | M101 × `Phasing` |
| **9** | L1581 | Mirrored Pinecone Bumper | M052 × `Mirrored` |
| **10** | L1591 | Armored Rolling Acorn | M053 × `Armored` |
| **11** | L1601 | Growing Twig Fence | M002 × `Growing(4)` |
| **12** | L1611 | Layered Bamboo Tube | M006 × `Layered(ground)` |
| **13** | L1621 | Frozen Dew-Glass Terrace | M152 × `Frozen(1)` |
| **15** | L1641 | Colored Dew-Glass Terrace | M152 × `Colored(Sky)` |
| **16** | L1651 | Fogged Dew-Glass Terrace | M152 × `Fogged` |
| **17** | L1661 | Chained Dew-Glass Terraces | M152 × `Chained` |
| **18** | L1671 | Phasing Moonlit Bridge | M102 × `Phasing` |
| **19** | L1681 | Countdown Acorn Plate | M019 × `Countdown(10)` |
| **20** | L1691 | Mirrored Dandelion Lift | M056 × `Mirrored` |
| **21** | L1701 | Armored Old Stone Wall | M074 × `Armored` |
| **22** | L1711 | Layered Sleepy Tulip | M057 × `Layered(air)` |
| **23** | L1721 | Growing Creeping Moss | M027 × `Growing(3)` |
| **24** | L1731 | Frozen Rabbit Hole | M153 × `Frozen(2)` |
| **25** | L1741 | Colored Rabbit Hole | M153 × `Colored(Pink)` |
| **27** | L1761 | Fogged Rabbit Hole | M153 × `Fogged` |
| **28** | L1771 | Chained Rabbit Holes | M153 × `Chained` |
| **29** | L1781 | Countdown Rabbit Hole | M153 × `Countdown(7)` |
| **30** | L1791 | Phasing Dawn Burrow | M103 × `Phasing` |
| **31** | L1801 | Mirrored Sunflower Receiver | M085 × `Mirrored` |
| **32** | L1811 | Armored Thorn Lock | M004 × `Armored` |
| **33** | L1821 | Layered Sunbeam Lens | M084 × `Layered(canopy)` |
| **34** | L1831 | Frozen Dew Prism | M089 × `Frozen(2)` |
| **35** | L1841 | Growing Bramble Row | M002 × `Growing(4)` |
| **36** | L1851 | Colored Twin Mushrooms | M060 × `Colored(Red)` |
| **37** | L1861 | Countdown Acorn Lift | M154 × `Countdown(12)` |
| **39** | L1881 | Frozen Acorn Lift | M154 × `Frozen(3)` |
| **40** | L1891 | Colored Acorn Lift | M154 × `Colored(Gold)` |
| **41** | L1901 | Fogged Acorn Lift | M154 × `Fogged` |
| **42** | L1911 | Chained Acorn Lifts | M154 × `Chained` |
| **43** | L1921 | Phasing Day-Bloom Line | M104 × `Phasing` |
| **44** | L1931 | Mirrored Great Stag Beetle | M098 × `Mirrored` |
| **45** | L1941 | Armored Royal Hive Door | M099 × `Armored` |
| **46** | L1951 | Layered Compass Flower | M070 × `Layered(air)` |
| **47** | L1961 | Growing Hedge Gap | M071 × `Growing(5)` |
| **48** | L1971 | Countdown Petal Mixing Bowl | M094 × `Countdown(10)` |
| **49** | L1981 | Chained Honeycomb Gates | M005 × `Chained` |

*(45 slots standard cross-phase constraints પ્રમાણે સંતુલિત).*


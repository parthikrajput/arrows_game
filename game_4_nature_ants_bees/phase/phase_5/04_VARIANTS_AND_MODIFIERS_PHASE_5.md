# 04 — Variants & Modifiers, Phase 5 (વેરિઅન્ટ્સ)
> Phase 5 ના 45 વેરિઅન્ટ સ્લોટ્સ: Acorn Physics Mechanics × 10 Modifiers ના સંયોજનો અને નિયમો.

**Related docs:** [Phase 5 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_2001_2500.md)

---

## 1. Variant Architecture in Phase 5
Phase 5 ના 45 variant slots (Blocks 3–49 માં x1 સ્લોટ્સ, 14, 26, 38 સિવાય) Acorn Physics મિકેનિક્સ અને 10 પ્રમાણિત મોડિફાયર્સનું સંયોજન છે:
- **Modifiers:** `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered(mask)`, `Mirrored`, `Growing(N)`.

## 2. Phase 5 Variant Slot Definitions (45 Slots)
| Block | Level | Variant Themed Name | Base × Modifier |
|---|---|---|---|
| **3** | L2021 | Frozen Mole Hole | M201 × `Frozen(2)` |
| **4** | L2031 | Colored Mole Hole | M201 × `Colored(Brown)` |
| **5** | L2041 | Fogged Mole Hole | M201 × `Fogged` |
| **6** | L2051 | Chained Mole Holes | M201 × `Chained` |
| **7** | L2061 | Countdown Mole Hole | M201 × `Countdown(8)` |
| **8** | L2071 | Phasing Rolling Acorn | M053 × `Phasing` |
| **9** | L2081 | Mirrored Pinecone Bumper | M052 × `Mirrored` |
| **10** | L2091 | Armored Dewdrop Marble | M202 × `Armored` |
| **11** | L2101 | Growing Bramble Row | M002 × `Growing(4)` |
| **12** | L2111 | Layered Seed Socket | M055 × `Layered(ground)` |
| **13** | L2121 | Frozen Dewdrop Marble | M202 × `Frozen(1)` |
| **15** | L2141 | Colored Dewdrop Marble | M202 × `Colored(Cyan)` |
| **16** | L2151 | Fogged Dewdrop Marble | M202 × `Fogged` |
| **17** | L2161 | Chained Dewdrop Marbles | M202 × `Chained` |
| **18** | L2171 | Phasing Sunrise Gate | M101 × `Phasing` |
| **19** | L2181 | Countdown Root Stairs | M151 × `Countdown(10)` |
| **20** | L2191 | Mirrored Dandelion Lift | M056 × `Mirrored` |
| **21** | L2201 | Armored Old Stone Wall | M074 × `Armored` |
| **22** | L2211 | Layered Sleepy Tulip | M057 × `Layered(air)` |
| **23** | L2221 | Growing Creeping Moss | M027 × `Growing(3)` |
| **24** | L2231 | Frozen Seed Key Pod | M203 × `Frozen(2)` |
| **25** | L2241 | Colored Seed Key Pod | M203 × `Colored(Yellow)` |
| **27** | L2261 | Fogged Seed Key Pod | M203 × `Fogged` |
| **28** | L2271 | Chained Seed Key Pods | M203 × `Chained` |
| **29** | L2281 | Countdown Seed Key Pod | M203 × `Countdown(7)` |
| **30** | L2291 | Phasing Acorn Lift | M154 × `Phasing` |
| **31** | L2301 | Mirrored Sunflower Receiver | M085 × `Mirrored` |
| **32** | L2311 | Armored Thorn Lock | M004 × `Armored` |
| **33** | L2321 | Layered Sunbeam Lens | M084 × `Layered(canopy)` |
| **34** | L2331 | Frozen Dew Prism | M089 × `Frozen(2)` |
| **35** | L2341 | Growing Hedge Gap | M071 × `Growing(5)` |
| **36** | L2351 | Colored Twin Mushrooms | M060 × `Colored(Blue)` |
| **37** | L2361 | Countdown Stone Pumpkin | M204 × `Countdown(12)` |
| **39** | L2381 | Frozen Stone Pumpkin | M204 × `Frozen(3)` |
| **40** | L2391 | Colored Stone Pumpkin | M204 × `Colored(Orange)` |
| **41** | L2401 | Fogged Stone Pumpkin | M204 × `Fogged` |
| **42** | L2411 | Chained Stone Pumpkins | M204 × `Chained` |
| **43** | L2421 | Phasing Day-Bloom Line | M104 × `Phasing` |
| **44** | L2431 | Mirrored Great Stag Beetle | M098 × `Mirrored` |
| **45** | L2441 | Armored Royal Hive Door | M099 × `Armored` |
| **46** | L2451 | Layered Compass Flower | M070 × `Layered(air)` |
| **47** | L2461 | Growing Mud Puddle | M037 × `Growing(4)` |
| **48** | L2471 | Countdown Petal Mixing Bowl | M094 × `Countdown(10)` |
| **49** | L2481 | Chained Honeycomb Gates | M005 × `Chained` |

*(45 slots standard compatibility constraints સાથે સંતુલિત).*


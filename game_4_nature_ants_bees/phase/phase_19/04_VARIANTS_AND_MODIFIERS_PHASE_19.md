# 04 — Variants & Modifiers, Phase 19 (વેરિઅન્ટ્સ)
> Phase 19 ના 45 વેરિઅન્ટ સ્લોટ્સ: Remix B Mechanics × 10 Modifiers ના સંયોજનો અને નિયમો.

**Related docs:** [Phase 19 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_9001_9500.md)

---

## 1. Variant Architecture in Phase 19
Phase 19 ના 45 variant slots (Blocks 3–49 માં x1 સ્લોટ્સ, 14, 26, 38 સિવાય) રીમિક્સ B મિકેનિક્સ અને 10 પ્રમાણિત મોડિફાયર્સનું સંયોજન છે:
- **Modifiers:** `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered(mask)`, `Mirrored`, `Growing(N)`.

## 2. Phase 19 Variant Slot Definitions (45 Slots)
| Block | Level | Variant Themed Name | Base × Modifier |
|---|---|---|---|
| **3** | L9021 | Frozen Falling Vines | M901 × `Frozen(2)` |
| **4** | L9031 | Colored Falling Vines | M901 × `Colored(Purple)` |
| **5** | L9041 | Fogged Falling Vines | M901 × `Fogged` |
| **6** | L9051 | Chained Falling Vines | M901 × `Chained` |
| **7** | L9061 | Countdown Falling Vines | M901 × `Countdown(8)` |
| **8** | L9071 | Phasing Falling Vines | M901 × `Phasing` |
| **9** | L9081 | Mirrored Falling Vines | M901 × `Mirrored` |
| **10** | L9091 | Armored Falling Vines | M901 × `Armored` |
| **11** | L9101 | Growing Bramble Fence | M002 × `Growing(4)` |
| **12** | L9111 | Layered Falling Vines | M901 × `Layered(ground)` |
| **13** | L9121 | Frozen Rhythm Rotor | M902 × `Frozen(2)` |
| **15** | L9141 | Colored Rhythm Rotor | M902 × `Colored(Gold)` |
| **16** | L9151 | Fogged Rhythm Rotor | M902 × `Fogged` |
| **17** | L9161 | Chained Rhythm Rotors | M902 × `Chained` |
| **18** | L9171 | Phasing Day-Night Terrace | M851 × `Phasing` |
| **19** | L9181 | Countdown Rhythm Rotor | M902 × `Countdown(10)` |
| **20** | L9191 | Mirrored Rhythm Rotor | M902 × `Mirrored` |
| **21** | L9201 | Armored Rhythm Rotor | M902 × `Armored` |
| **22** | L9211 | Layered Rhythm Rotor | M902 × `Layered(air)` |
| **23** | L9221 | Growing Ivy Tangle | M074 × `Growing(3)` |
| **24** | L9231 | Frozen Twin-Garden Fork | M903 × `Frozen(1)` |
| **25** | L9241 | Colored Twin-Garden Fork | M903 × `Colored(Red)` |
| **27** | L9261 | Fogged Twin-Garden Fork | M903 × `Fogged` |
| **28** | L9271 | Chained Twin-Garden Forks | M903 × `Chained` |
| **29** | L9281 | Countdown Twin-Garden Fork | M903 × `Countdown(7)` |
| **30** | L9291 | Phasing Sunlit Acorn | M852 × `Phasing` |
| **31** | L9301 | Mirrored Twin-Garden Fork | M903 × `Mirrored` |
| **32** | L9311 | Armored Rhino Beetle | M802 × `Armored` |
| **33** | L9321 | Layered Twin-Garden Fork | M903 × `Layered(canopy)` |
| **34** | L9331 | Frozen Gravity Turntable | M904 × `Frozen(3)` |
| **35** | L9341 | Growing Moss Spores | M027 × `Growing(5)` |
| **36** | L9351 | Colored Gravity Turntable | M904 × `Colored(Sky)` |
| **37** | L9361 | Countdown Gravity Turntable | M904 × `Countdown(12)` |
| **39** | L9381 | Fogged Gravity Turntable | M904 × `Fogged` |
| **40** | L9391 | Chained Gravity Turntables | M904 × `Chained` |
| **41** | L9401 | Phasing Gravity Turntable | M904 × `Phasing` |
| **42** | L9411 | Mirrored Gravity Turntable | M904 × `Mirrored` |
| **43** | L9421 | Armored Twin Hornets | M801 × `Armored` |
| **44** | L9431 | Layered Gravity Turntable | M904 × `Layered(ground)` |
| **45** | L9441 | Growing Hedge Border | M071 × `Growing(4)` |
| **46** | L9451 | Colored Skeleton Key | M753 × `Colored(Amber)` |
| **47** | L9461 | Countdown Shaded Stairs | M853 × `Countdown(9)` |
| **48** | L9471 | Phasing Dawn Marble | M854 × `Phasing` |
| **49** | L9481 | Chained Honeycomb Arch | M005 × `Chained` |

*(45 slots standard compatibility constraints સાથે સંતુલિત).*

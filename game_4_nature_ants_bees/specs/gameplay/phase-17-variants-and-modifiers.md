# Spec: Phase 17 Variants & Modifiers — Garden Guardians (Levels 8001–8500)

Source docs: phase/phase_17/04_VARIANTS_AND_MODIFIERS_PHASE_17.md, SCALING_TO_10000_LEVELS.md §7, §8, SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-17-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 17 Variants & Modifiers — Garden Guardians |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 17 (Levels 8001–8500) |

---

## Goal

Define all 45 variant slots across Phase 17 (Levels 8001–8500), mapping base mechanics (M801–M804, along with earlier supporting mechanics) to 10 standardized modifiers, ensuring compliance with modifier compatibility matrices.

---

## Current State

Design documented in `phase/phase_17/04_VARIANTS_AND_MODIFIERS_PHASE_17.md`, not yet implemented.

---

## Proposed Change

### 1. Modifier Compatibility Rules for Boss Guardians
Per SHARED_CORE_STANDARD.md §8:
- Boss Guardians (M801–M804) **CANNOT** directly receive `Phasing` or `Countdown` modifiers due to their multi-tile persistent footprint and HP state architecture.
- When `Phasing` or `Countdown` appears in a variant block, it is applied to auxiliary mechanics (e.g. Dew Key Chain, Ivy Lever, Brook Fork, Sluice Lever) rather than the Boss Guardian directly.
- Modifiers like `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Armored`, `Layered(mask)`, and `Mirrored` can directly augment Guardian encounters or their surrounding puzzle geometry.

### 2. 45 Variant Slot Table (Blocks 3–49 x1, excluding 14, 26, 38)

| Block | Level | Variant Themed Name | Base × Modifier | Design Intent |
|---|---|---|---|---|
| **3** | L8021 | Frozen Twin Hornets | M801 × `Frozen(2)` | Hornets frozen in frost; unthaw required before attacks register. |
| **4** | L8031 | Colored Twin Hornets | M801 × `Colored(Yellow)` | Only yellow-marked pollen lines deal damage to hornets. |
| **5** | L8041 | Fogged Twin Hornets | M801 × `Fogged` | Dense mist obscures hornets until adjacent clearing occurs. |
| **6** | L8051 | Chained Twin Hornets | M801 × `Chained` | Both hornets tethered by thorn chain; breaks upon first damage. |
| **7** | L8061 | Countdown Ivy Lever | M074 × `Countdown(8)` | Must activate lever before countdown expires to strip armor. |
| **8** | L8071 | Phasing Dew Key Chain | M751 × `Phasing` | Key chain phases through board layers periodically. |
| **9** | L8081 | Mirrored Twin Hornets | M801 × `Mirrored` | Hornets duplicate across reflecting pond axis. |
| **10** | L8091 | Armored Twin Hornets | M801 × `Armored` | Dual hornets augmented with secondary chitin shield. |
| **11** | L8101 | Growing Bramble Thicket | M002 × `Growing(4)` | Brambles expand every 4 moves while battling hornets. |
| **12** | L8111 | Layered Twin Hornets | M801 × `Layered(ground)` | Ground layer attacks prioritize first hornet body. |
| **13** | L8121 | Frozen Rhino Beetle | M802 × `Frozen(2)` | Ice encrustation over beetle armor requires dual strikes. |
| **15** | L8141 | Colored Rhino Beetle | M802 × `Colored(Black)` | Only black carpenter ants can shatter the cracked shell. |
| **16** | L8151 | Fogged Rhino Beetle | M802 × `Fogged` | Fog hides beetle armor status until proximity line clears. |
| **17** | L8161 | Chained Rhino Beetles | M802 × `Chained` | Beetle bound to iron chain anchors holding nearby gates closed. |
| **18** | L8171 | Phasing Crafting Flower | M752 × `Phasing` | Crafting flower alternates active phase every 3 moves. |
| **19** | L8181 | Countdown Brook Fork | M701 × `Countdown(10)` | Brook fork water routing expires after 10 moves. |
| **20** | L8191 | Mirrored Rhino Beetle | M802 × `Mirrored` | Twin mirrored beetle shadows reflect across the central pond. |
| **21** | L8201 | Armored Rhino Spikes | M802 × `Armored` | Dual-layered carapace requires two consecutive lever pulls. |
| **22** | L8211 | Layered Rhino Beetle | M802 × `Layered(air)` | Flying bees must dive first to trigger shell fracture. |
| **23** | L8221 | Growing Ivy Root | M074 × `Growing(3)` | Roots creep toward lever, threatening to jam mechanism. |
| **24** | L8231 | Frozen Wasp Nest | M803 × `Frozen(2)` | Nest temporarily dormant under frost layer for first 2 turns. |
| **25** | L8241 | Colored Wasp Nest | M803 × `Colored(Amber)` | Spawns amber resin blockers vulnerable only to amber lines. |
| **27** | L8261 | Fogged Wasp Nest | M803 × `Fogged` | Hidden nest location identified only by emerging mud spawns. |
| **28** | L8271 | Chained Wasp Nests | M803 × `Chained` | Dual nests linked; defeating one doubles spawn rate of other. |
| **29** | L8281 | Countdown Sluice Lever | M703 × `Countdown(7)` | Sluice gates lock into place if lever not flipped in 7 moves. |
| **30** | L8291 | Phasing Skeleton Key | M753 × `Phasing` | Skeleton key phases across dimensions, shifting target rows. |
| **31** | L8301 | Mirrored Wasp Nest | M803 × `Mirrored` | Mirrored nests spawn coordinated mud blocks simultaneously. |
| **32** | L8311 | Armored Spawner Shell | M803 × `Armored` | Nest protected by hardened clay shell; requires initial hit. |
| **33** | L8321 | Layered Wasp Nest | M803 × `Layered(canopy)` | Canopy-level nest spawns aerial obstacles down to ground. |
| **34** | L8331 | Frozen Heart-Seed Guardian | M804 × `Frozen(3)` | Glacial frost protects core until 3 perimeter lines clear. |
| **35** | L8341 | Growing Moss Spores | M027 × `Growing(5)` | Spores creep outward across board while solving core alignments. |
| **36** | L8351 | Colored Heart-Seed Guardian | M804 × `Colored(Ruby)` | Only ruby line trajectories deal piercing core damage. |
| **37** | L8361 | Countdown Key Swap Pad | M754 × `Countdown(12)` | Swap pad mechanism times out after 12 player moves. |
| **38** | L8371 | *(Base Intro: M804 Heart-Seed Guardian)* | M804 Base | (Base intro slot). |
| **39** | L8381 | Fogged Heart-Seed Guardian | M804 × `Fogged` | Core tile shrouded in fog until clear lane emerges. |
| **40** | L8391 | Chained Heart-Seed Guardians | M804 × `Chained` | Ancient roots anchor core; must be cleaved before damage registers. |
| **41** | L8401 | Phasing Tide Brook | M702 × `Phasing` | Tide brook water current periodically phases between dry and wet. |
| **42** | L8411 | Mirrored Heart-Seed Guardian | M804 × `Mirrored` | Dual core targets require synchronized mirrored line strikes. |
| **43** | L8421 | Armored Heart Core | M804 × `Armored` | Heart core shielded behind interlocking bark plates. |
| **44** | L8431 | Layered Heart-Seed Guardian | M804 × `Layered(ground)` | Ground ant tunneling lines needed for core under-strike. |
| **45** | L8441 | Growing Hedge Wall | M071 × `Growing(4)` | Perimeter hedge thickens every 4 moves, narrowing exit corridors. |
| **46** | L8451 | Colored Pond Axis | M651 × `Colored(Blue)` | Blue reflection axis alters symmetry mechanics. |
| **47** | L8461 | Countdown Sunlit Plate | M604 × `Countdown(9)` | Sunlit pressure plate must be depressed before timer elapses. |
| **48** | L8471 | Phasing Lazy River | M704 × `Phasing` | Lazy river water loop phases in and out of active circulation. |
| **49** | L8481 | Chained Honeycomb Arch | M005 × `Chained` | Honeycomb gate chained shut until final guardian hit lands. |

---

## Verification Plan

### Automated Tests
1. Verify that all 45 variant slot definitions compile without illegal modifier assignments (no `Phasing` or `Countdown` directly on M801–M804 entities).
2. Validate variant intro levels match their respective block x1 indices (L8021, L8031, etc.).

### Manual Verification
1. Test L8061 Countdown Ivy Lever: verify countdown badge renders clearly beside lever sprite.
2. Test L8351 Colored Heart-Seed: verify non-matching color lines safely pass through core without dealing damage or bonking.

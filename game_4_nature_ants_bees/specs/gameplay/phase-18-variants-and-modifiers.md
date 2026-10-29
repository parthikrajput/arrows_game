# Spec: Phase 18 Variants & Modifiers — Garden Festival I (Levels 8501–9000)

Source docs: phase/phase_18/04_VARIANTS_AND_MODIFIERS_PHASE_18.md, SCALING_TO_10000_LEVELS.md §7, §8, SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-18-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 18 Variants & Modifiers — Garden Festival I |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 18 (Levels 8501–9000) |

---

## Goal

Define all 45 variant slots across Phase 18 (Levels 8501–9000), combining Remix A combo mechanics (M851–M854 and supporting mechanics) with 10 standardized modifiers while adhering to compatibility and balance constraints.

---

## Current State

Design documented in `phase/phase_18/04_VARIANTS_AND_MODIFIERS_PHASE_18.md`, not yet implemented.

---

## Proposed Change

### 1. Modifier Compatibility Rules for Combo Mechanics
- Modifiers apply to the hybrid entity according to its active spatial presence.
- For multi-floor mechanics (M851, M853), modifiers like `Layered` or `Mirrored` replicate or map per floor level.
- Push and slide entities (M852, M854) maintain sliding dynamics under `Frozen` (requires unthaw strike before push occurs) and `Colored` (only matching color lines can initiate push).

### 2. 45 Variant Slot Table (Blocks 3–49 x1, excluding 14, 26, 38)

| Block | Level | Variant Themed Name | Base × Modifier | Design Intent |
|---|---|---|---|---|
| **3** | L8521 | Frozen Day-Night Terrace | M851 × `Frozen(2)` | Frost encrusts terrace; requires 2 adjacent hits to activate. |
| **4** | L8531 | Colored Day-Night Terrace | M851 × `Colored(Gold)` | Only golden-marked worker lines can utilize the staircase. |
| **5** | L8541 | Fogged Day-Night Terrace | M851 × `Fogged` | Shrouded in fog; terrace status revealed on approach. |
| **6** | L8551 | Chained Day-Night Terraces | M851 × `Chained` | Linked terraces on Floor 1 and 2 operate in synchrony. |
| **7** | L8561 | Countdown Day-Night Terrace | M851 × `Countdown(8)` | Terrace permanently collapses after 8 player moves. |
| **8** | L8571 | Phasing Day-Night Terrace | M851 × `Phasing` | Terrace phases between floors every 3 moves. |
| **9** | L8581 | Mirrored Day-Night Terrace | M851 × `Mirrored` | Twin terraces mirror across pond axis on both floors. |
| **10** | L8591 | Armored Day-Night Terrace | M851 × `Armored` | Heavy stone gate blocks staircase until lever pulled. |
| **11** | L8601 | Growing Bramble Patch | M002 × `Growing(4)` | Brambles expand while navigating vertical terrace climbs. |
| **12** | L8611 | Layered Day-Night Terrace | M851 × `Layered(ground)` | Ground ants take priority access on terrace. |
| **13** | L8621 | Frozen Sunlit Acorn | M852 × `Frozen(2)` | Ice block locks acorn in place until shattered. |
| **15** | L8641 | Colored Sunlit Acorn | M852 × `Colored(Red)` | Only red lines can push the prism acorn. |
| **16** | L8651 | Fogged Sunlit Acorn | M852 × `Fogged` | Fog hides prism orientation until insect nears. |
| **17** | L8661 | Chained Sunlit Acorns | M852 × `Chained` | Pushing Acorn A simultaneously displaces linked Acorn B. |
| **18** | L8671 | Phasing Dew Key Chain | M751 × `Phasing` | Dew key chain phases across layers periodically. |
| **19** | L8681 | Countdown Sunlit Acorn | M852 × `Countdown(10)` | Prism degrades after 10 moves if beam not routed. |
| **20** | L8691 | Mirrored Sunlit Acorn | M852 × `Mirrored` | Pushing acorn moves mirrored twin in opposite direction. |
| **21** | L8701 | Armored Sunlit Acorn | M852 × `Armored` | Acorn shielded by chitin husk; cracked by first bump. |
| **22** | L8711 | Layered Sunlit Acorn | M852 × `Layered(air)` | Flying bees push acorn across upper air layer. |
| **23** | L8721 | Growing Ivy Tangle | M074 × `Growing(3)` | Creeping ivy threatens to block solar beam lines. |
| **24** | L8731 | Frozen Shaded Stairs | M853 × `Frozen(1)` | Ice film over photosensitive buds cleared by warm beam. |
| **25** | L8741 | Colored Shaded Stairs | M853 × `Colored(Blue)` | Requires blue-tinted beam to unlock vertical transit. |
| **27** | L8761 | Fogged Shaded Stairs | M853 × `Fogged` | Hidden in dark fog until beam illuminates path. |
| **28** | L8771 | Chained Shaded Stairs | M853 × `Chained` | Illuminating Stair A also powers illuminated link on Stair B. |
| **29** | L8781 | Countdown Shaded Stairs | M853 × `Countdown(7)` | Beam window closes after 7 moves; rapid climb required. |
| **30** | L8791 | Phasing Brook Fork | M701 × `Phasing` | Stream current switches channels every 2 moves. |
| **31** | L8801 | Mirrored Shaded Stairs | M853 × `Mirrored` | Dual shaded stairs placed symmetrically across water axis. |
| **32** | L8811 | Armored Rhino Beetle | M802 × `Armored` | Rhino beetle guards stairs until armor stripped. |
| **33** | L8821 | Layered Shaded Stairs | M853 × `Layered(canopy)` | Canopy-level sunbeams unlock stairs leading up to treetops. |
| **34** | L8831 | Frozen Dawn Marble | M854 × `Frozen(3)` | Frozen solid; triple bump required to restore rolling state. |
| **35** | L8841 | Growing Moss Spores | M027 × `Growing(5)` | Spores create new friction obstacles along sliding paths. |
| **36** | L8851 | Colored Dawn Marble | M854 × `Colored(White)` | Only translucent worker ants can propel white marble. |
| **37** | L8861 | Countdown Dawn Marble | M854 × `Countdown(12)` | Marble dissolves into water after 12 moves. |
| **38** | L8871 | *(Base Intro: M854 Dawn Marble)* | M854 Base | (Base intro slot). |
| **39** | L8881 | Fogged Dawn Marble | M854 × `Fogged` | Fog obscures destination bumper cells along slide vector. |
| **40** | L8891 | Chained Dawn Marbles | M854 × `Chained` | Two marbles slide together along parallel vectors. |
| **41** | L8901 | Phasing Dawn Marble | M854 × `Phasing` | Marble phases through obstacles during odd turns. |
| **42** | L8911 | Mirrored Dawn Marble | M854 × `Mirrored` | Symmetric marble slides counter-balance opposite quadrant. |
| **43** | L8921 | Armored Crafting Flower | M752 × `Armored` | Crafting petals protected by bud casing. |
| **44** | L8931 | Layered Dawn Marble | M854 × `Layered(ground)` | Ground-only sliding physics across subterranean tunnels. |
| **45** | L8941 | Growing Hedge Border | M071 × `Growing(4)` | Boundary hedges expand, altering rebound wall coordinates. |
| **46** | L8951 | Colored Pond Axis | M651 × `Colored(Amber)` | Amber reflection axis inverts optical beam vectors. |
| **47** | L8961 | Countdown Sluice Lever | M703 × `Countdown(9)` | Sluice lever times out after 9 turns. |
| **48** | L8971 | Phasing Skeleton Key | M753 × `Phasing` | Skeleton key shifts through phase dimensions. |
| **49** | L8981 | Chained Honeycomb Arch | M005 × `Chained` | Gate arch unlocks upon final marble alignment. |

---

## Verification Plan

### Automated Tests
1. Verify all 45 variant slot combinations compile cleanly with valid base and modifier parameters.
2. Verify all x1 slot levels strictly correspond to designated block indices.

### Manual Verification
1. Test L8641 Colored Sunlit Acorn: verify non-matching color lines bonk when attempting push.
2. Test L8781 Countdown Shaded Stairs: confirm countdown warning pulses before stairs re-lock.

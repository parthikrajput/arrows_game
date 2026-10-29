# Spec: Phase 20 Variants & Modifiers — Grand Master Garden (Levels 9501–10,000)

Source docs: phase/phase_20/04_VARIANTS_AND_MODIFIERS_PHASE_20.md, SCALING_TO_10000_LEVELS.md §7, §8, SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-20-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 20 Variants & Modifiers — Grand Master Garden |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 20 (Levels 9501–10,000) |

---

## Goal

Define all 44 variant slots across Phase 20 (Levels 9501–10,000), pairing Grand Master combo mechanics (M951–M954 and high-tier supporting mechanics) with 10 standardized modifiers to form the ultimate pre-finale puzzle gauntlet.

---

## Current State

Design documented in `phase/phase_20/04_VARIANTS_AND_MODIFIERS_PHASE_20.md`, not yet implemented.

---

## Proposed Change

### 1. Architectural Design
- Phase 20's 44 variant slots represent the culmination of modifier synergy across all evolutionary eras.
- Modifiers include all 10 standard types: `Frozen(K)`, `Colored(c)`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered(mask)`, `Mirrored`, `Growing(N)`.
- Boss-type combinations adhere to standard §8 constraints (no direct `Phasing` or `Countdown` on multi-tile bosses; applied to surrounding mechanisms).

### 2. 44 Variant Slot Table (Blocks 3–49 x1, excluding 14, 26, 38)

| Block | Level | Variant Themed Name | Base × Modifier | Design Intent |
|---|---|---|---|---|
| **3** | L9521 | Frozen Bloom Canopy | M951 × `Frozen(2)` | Ice encrustation delays floral cycle until 2 strikes thaw it. |
| **4** | L9531 | Colored Bloom Canopy | M951 × `Colored(Violet)` | Only violet pollen-coated insects can trim the blooming canopy. |
| **5** | L9541 | Fogged Bloom Canopy | M951 × `Fogged` | Thick mist conceals which vines are blooming vs withered. |
| **6** | L9551 | Chained Bloom Canopy | M951 × `Chained` | Multiple canopy vines tethered; clearing one frees both. |
| **7** | L9561 | Countdown Bloom Canopy | M951 × `Countdown(8)` | Canopy permanently collapses after 8 player moves. |
| **8** | L9571 | Phasing Bloom Canopy | M951 × `Phasing` | Canopy phases through spatial planes every 2 turns. |
| **9** | L9581 | Mirrored Bloom Canopy | M951 × `Mirrored` | Vines bloom symmetrically across bilateral water reflection. |
| **10** | L9591 | Armored Bloom Canopy | M951 × `Armored` | Heavy chitin plates protect vine stems until lever unlocked. |
| **11** | L9601 | Growing Royal Brambles | M002 × `Growing(4)` | Brambles expand every 4 moves alongside floral canopy. |
| **12** | L9611 | Layered Bloom Canopy | M951 × `Layered(ground)` | Ground ants take exclusive pathing through canopy roots. |
| **13** | L9621 | Frozen Cascade Nexus | M952 × `Frozen(2)` | Cross-board split node frozen solid; requires 2 bumps. |
| **15** | L9641 | Colored Cascade Nexus | M952 × `Colored(Gold)` | Only golden royal ants can trigger the gravitational cascade. |
| **16** | L9651 | Fogged Cascade Nexus | M952 × `Fogged` | Destination portal on Board B shrouded in mystery fog. |
| **17** | L9661 | Chained Cascade Nexus | M952 × `Chained` | Dual cascade nodes linked across parallel boards. |
| **18** | L9671 | Phasing Cascade Nexus | M952 × `Phasing` | Split node phases across alternate dimensions. |
| **19** | L9681 | Countdown Cascade Nexus | M952 × `Countdown(10)` | Gravity portal closes permanently after 10 moves. |
| **20** | L9691 | Mirrored Cascade Nexus | M952 × `Mirrored` | Symmetrical nexus splits lines into 4 mirrored pathways. |
| **21** | L9701 | Armored Cascade Nexus | M952 × `Armored` | Nexus node protected by heavy shell until lever pulled. |
| **22** | L9711 | Layered Cascade Nexus | M952 × `Layered(air)` | Airborne worker bees utilize upper gravitational slipstream. |
| **23** | L9721 | Growing Ivy Trellis | M074 × `Growing(3)` | Creeping ivy crawls into gravity cascade chutes. |
| **24** | L9731 | Frozen Guardian Aegis | M953 × `Frozen(3)` | Glacial frost encrusts guardian; triple bump required. |
| **25** | L9741 | Colored Guardian Aegis | M953 × `Colored(Crimson)` | Crimson dew keys required to unlock crimson aegis. |
| **27** | L9761 | Fogged Guardian Aegis | M953 × `Fogged` | Deep impenetrable fog blankets entire guardian arena. |
| **28** | L9771 | Chained Guardian Aegis | M953 × `Chained` | Dual guardians chained together; both require keys. |
| **29** | L9781 | Countdown Guardian Aegis | M953 × `Countdown(12)` | Must collect all 3 keys within 12 moves before aegis seals. |
| **30** | L9791 | Phasing Guardian Aegis | M953 × `Phasing` | Key lock sockets phase between open and closed states. |
| **31** | L9801 | Mirrored Guardian Aegis | M953 × `Mirrored` | Twin mirrored guardians reflect across central axis. |
| **32** | L9811 | Armored Twin Hornets Boss | M801 × `Armored` | Dual hornet bosses shielded behind secondary chitin shell. |
| **33** | L9821 | Layered Guardian Aegis | M953 × `Layered(canopy)` | Canopy scout bees carry keys across treetop highways. |
| **34** | L9831 | Frozen Prismatic Rotor | M954 × `Frozen(2)` | Rotor gears iced over; requires dual hits to free rotation. |
| **35** | L9841 | Growing Spore Thick | M027 × `Growing(5)` | Spores creep outward while prism rotor turns. |
| **36** | L9851 | Colored Prismatic Rotor | M954 × `Colored(Emerald)` | Emerald optical prism bends green-wavelength beams only. |
| **37** | L9861 | Countdown Prismatic Rotor | M954 × `Countdown(9)` | Rhythm rotation ceases permanently after 9 moves. |
| **39** | L9881 | Fogged Prismatic Rotor | M954 × `Fogged` | Light beams cut through fog, revealing hidden crystal facets. |
| **40** | L9891 | Chained Prismatic Rotor | M954 × `Chained` | Dual prism rotors synchronize rotation across board quadrants. |
| **41** | L9901 | Phasing Prismatic Rotor | M954 × `Phasing` | Rotor phases out of tangibility during odd-numbered turns. |
| **42** | L9911 | Mirrored Prismatic Rotor | M954 × `Mirrored` | Counter-rotating prism mirrors light symmetrically. |
| **43** | L9921 | Armored Guardian Core | M802 × `Armored` | Beetle armor protects core receptor from stray insects. |
| **44** | L9931 | Layered Prismatic Rotor | M954 × `Layered(ground+air)`| Simultaneous ground and aerial light paths refract. |
| **45** | L9941 | Growing Solar Vines | M901 × `Growing(3)` | Solar vines expand along active light trajectories. |
| **46** | L9951 | Colored Master Key | M753 × `Colored(Rainbow)` | Prismatic master key sweeps locks across all 4 colors. |
| **47** | L9961 | Countdown Rhythm Rotor | M902 × `Countdown(8)` | Rhythm countdown creates tight puzzle execution window. |
| **48** | L9971 | Phasing Twin Fork | M903 × `Phasing` | Cross-board portal alternates destination coordinates. |
| **49** | L9981 | Chained Royal Gate | M005 × `Chained` | Massive gilded gate bars access to Queen's inner sanctuary. |

---

## Verification Plan

### Automated Tests
1. Verify all 44 variant slots compile cleanly and map to valid base and modifier parameters.
2. Verify all intro levels strictly align with block x1 indices.

### Manual Verification
1. Test L9741 Colored Guardian Aegis: confirm crimson keys clearly contrast against standard keys.
2. Test L9851 Emerald Prismatic Rotor: verify emerald beam correctly triggers emerald photosensitive receptors.

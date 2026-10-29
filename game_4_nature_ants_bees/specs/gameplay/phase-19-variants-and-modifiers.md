# Spec: Phase 19 Variants & Modifiers — Garden Festival II (Levels 9001–9500)

Source docs: phase/phase_19/04_VARIANTS_AND_MODIFIERS_PHASE_19.md, SCALING_TO_10000_LEVELS.md §7, §8, SHARED_CORE_STANDARD.md §11. Depends on: specs/gameplay/phase-19-base-mechanics.md.

---

| Field | Value |
|---|---|
| **Title** | Phase 19 Variants & Modifiers — Garden Festival II |
| **Type** | New Feature |
| **Status** | Draft |
| **Group** | gameplay |
| **Phase** | 19 (Levels 9001–9500) |

---

## Goal

Define all 45 variant slots across Phase 19 (Levels 9001–9500), combining Remix B combo mechanics (M901–M904 and supporting mechanics) with 10 standardized modifiers while maintaining solver feasibility and compatibility rules.

---

## Current State

Design documented in `phase/phase_19/04_VARIANTS_AND_MODIFIERS_PHASE_19.md`, not yet implemented.

---

## Proposed Change

### 1. Modifier Compatibility Rules for Kinetic Combos
- Rotational sectors (M902, M904) carry internal modifiers through rotations.
- Modifiers applied to M903 (Twin-Garden Fork) govern the behavior of both branch trajectories unless masked by layer filters.
- `Growing(N)` on Falling Vines accelerates the growth frequency while maintaining gravity drift steps.

### 2. 45 Variant Slot Table (Blocks 3–49 x1, excluding 14, 26, 38)

| Block | Level | Variant Themed Name | Base × Modifier | Design Intent |
|---|---|---|---|---|
| **3** | L9021 | Frozen Falling Vines | M901 × `Frozen(2)` | Vines encased in ice; gravity drift suppressed until thawed. |
| **4** | L9031 | Colored Falling Vines | M901 × `Colored(Purple)` | Only purple insects can clear purple falling vine clusters. |
| **5** | L9041 | Fogged Falling Vines | M901 × `Fogged` | Vines advance silently beneath thick garden mist. |
| **6** | L9051 | Chained Falling Vines | M901 × `Chained` | Multiple vine clusters tethered; clearing one frees both. |
| **7** | L9061 | Countdown Falling Vines | M901 × `Countdown(8)` | Vines wither and dissolve permanently after 8 moves. |
| **8** | L9071 | Phasing Falling Vines | M901 × `Phasing` | Vines phase in and out of tangibility every 2 turns. |
| **9** | L9081 | Mirrored Falling Vines | M901 × `Mirrored` | Vines fall symmetrically across bilateral reflection axis. |
| **10** | L9091 | Armored Falling Vines | M901 × `Armored` | Bark armor prevents trimming until lever cracked. |
| **11** | L9101 | Growing Bramble Fence | M002 × `Growing(4)` | Brambles expand every 4 moves alongside falling vines. |
| **12** | L9111 | Layered Falling Vines | M901 × `Layered(ground)` | Falling vines only obstruct ground-crawling ants. |
| **13** | L9121 | Frozen Rhythm Rotor | M902 × `Frozen(2)` | Rotor gears frozen; requires 2 adjacent strikes to unjam. |
| **15** | L9141 | Colored Rhythm Rotor | M902 × `Colored(Gold)` | Only golden lines within the rotor are eligible to exit. |
| **16** | L9151 | Fogged Rhythm Rotor | M902 × `Fogged` | Sub-board sector shrouded in fog until first rotation. |
| **17** | L9161 | Chained Rhythm Rotors | M902 × `Chained` | Two adjacent rotors turn simultaneously in unison. |
| **18** | L9171 | Phasing Day-Night Terrace | M851 × `Phasing` | Terrace transitions phase periodically across turns. |
| **19** | L9181 | Countdown Rhythm Rotor | M902 × `Countdown(10)` | Auto-rotor turns off permanently after 10 moves. |
| **20** | L9191 | Mirrored Rhythm Rotor | M902 × `Mirrored` | Counter-rotating twin rotor turns CCW across mirror axis. |
| **21** | L9201 | Armored Rhythm Rotor | M902 × `Armored` | Turntable border protected by armor plates. |
| **22** | L9211 | Layered Rhythm Rotor | M902 × `Layered(air)` | Rotor carries flying bees while ground ants remain fixed. |
| **23** | L9221 | Growing Ivy Tangle | M074 × `Growing(3)` | Creeping ivy crawls into rotor perimeter. |
| **24** | L9231 | Frozen Twin-Garden Fork | M903 × `Frozen(1)` | Frost blocks fork portal until single hit melts it. |
| **25** | L9241 | Colored Twin-Garden Fork | M903 × `Colored(Red)` | Only red lines trigger cross-board division. |
| **27** | L9261 | Fogged Twin-Garden Fork | M903 × `Fogged` | Destination portal on Board B hidden by fog. |
| **28** | L9271 | Chained Twin-Garden Forks | M903 × `Chained` | Linked forks across boards operate in tandem. |
| **29** | L9281 | Countdown Twin-Garden Fork | M903 × `Countdown(7)` | Inter-board portal closes after 7 moves. |
| **30** | L9291 | Phasing Sunlit Acorn | M852 × `Phasing` | Prism acorn phases through solid walls. |
| **31** | L9301 | Mirrored Twin-Garden Fork | M903 × `Mirrored` | Symmetric forks divide insects into 4 mirrored lines. |
| **32** | L9311 | Armored Rhino Beetle | M802 × `Armored` | Beetle guards portal entrance until shell removed. |
| **33** | L9321 | Layered Twin-Garden Fork | M903 × `Layered(canopy)` | Canopy scout bees enter high-altitude tree portal. |
| **34** | L9331 | Frozen Gravity Turntable | M904 × `Frozen(3)` | Turntable frozen in place; requires 3 hits to unlock. |
| **35** | L9341 | Growing Moss Spores | M027 × `Growing(5)` | Spores creep along floor while gravity shifts. |
| **36** | L9351 | Colored Gravity Turntable | M904 × `Colored(Sky)` | Only sky-blue lines respond to rotated gravity vector. |
| **37** | L9361 | Countdown Gravity Turntable | M904 × `Countdown(12)` | Turntable locks permanently after 12 player moves. |
| **38** | L9371 | *(Base Intro: M904 Gravity Turntable)* | M904 Base | (Base intro slot). |
| **39** | L9381 | Fogged Gravity Turntable | M904 × `Fogged` | Local gravity direction hidden by thick mist. |
| **40** | L9391 | Chained Gravity Turntables | M904 × `Chained` | Rotating Turntable A also rotates Turntable B. |
| **41** | L9401 | Phasing Gravity Turntable | M904 × `Phasing` | Gravity sector shifts between zero-g and standard-g. |
| **42** | L9411 | Mirrored Gravity Turntable | M904 × `Mirrored` | Mirrored gravity sectors invert lateral pull directions. |
| **43** | L9421 | Armored Twin Hornets | M801 × `Armored` | Dual hornets patrol gravity turntable perimeter. |
| **44** | L9431 | Layered Gravity Turntable | M904 × `Layered(ground)` | Local gravity influences subterranean ant tunnels. |
| **45** | L9441 | Growing Hedge Border | M071 × `Growing(4)` | Perimeter hedge thickens every 4 moves. |
| **46** | L9451 | Colored Skeleton Key | M753 × `Colored(Amber)` | Amber skeleton key sweeps amber-tinted locks. |
| **47** | L9461 | Countdown Shaded Stairs | M853 × `Countdown(9)` | Shaded stairs beam illumination expires in 9 moves. |
| **48** | L9471 | Phasing Dawn Marble | M854 × `Phasing` | Marble phases through obstacles while sliding. |
| **49** | L9481 | Chained Honeycomb Arch | M005 × `Chained` | Arch gate unlocks upon completing final gravity puzzle. |

---

## Verification Plan

### Automated Tests
1. Verify all 45 variant slot definitions compile without syntax or modifier incompatibilities.
2. Verify all x1 slot levels strictly correspond to designated block indices.

### Manual Verification
1. Test L9061 Countdown Falling Vines: verify vines dissolve cleanly upon counter expiry.
2. Test L9241 Colored Twin-Garden Fork: verify non-matching color lines safely pass without splitting.

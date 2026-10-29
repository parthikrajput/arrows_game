Source docs: phase_1/03_OBSTACLE_CATALOG_PHASE_1.md, SHARED_CORE_STANDARD.md

# Spec: Obstacle and Mechanics Catalog (Phase 1)

## Status
Draft

## Type
New Feature

## Goal
Define the technical and gameplay specifications for all 49 Phase 1 mechanics (M001–M049) and the Level 500 Phase Finale, including layer collision rules, hammerable properties, and solver interactions for Ants & Bees: Garden Trails.

## Current State
Design documented in phase_1/03_OBSTACLE_CATALOG_PHASE_1.md and SHARED_CORE_STANDARD.md, not yet implemented.
- 49 mechanics scheduled one every 10 levels on the x1 slot from Level 11 to 491.
- M004 and M032 swapped per Standard §10 exception: M032 Bee Lines (Air Layer) introduced at L41, M004 Dew Key & Thorn Lock introduced at L321.
- Clear layer differentiation: Ants on ground (`layer: 0`), Bees in air (`layer: 1`).
- Tall obstacles (`tall: true`) interact with both layers; ground obstacles interact with ground only.
- Leaf Blower (Hammer) targets any single unhidden, uncovered line OR specific hammerable obstacles.

## Proposed Change
Implement the complete mechanics runtime in `packages/puzzle_core/lib/src/mechanics/`:

### 1. Layer and Hammer Rules
- **Ground Only (`tall: false (fixed)`):** Completely ignored by bee lines (bees fly over with no collision, no trigger). Affects only ants.
- **Tall Blocker (`tall: true`):** Blocks both ant and bee lanes. Visually rendered with a tall vertical stem, prominent ground shadow, and a top wing-glyph indicator.
- **Per Instance `tall`:** Configured in level JSON per instance (default `false`). Available starting from Level 42.
- **Leaf Blower (Hammer):** Can remove any 1 line (counts as a successful exit) OR one of the designated hammerable obstacles:
  - `M001 Garden Pebble / Sunflower Stalk` (single cell)
  - `M002 Twig Fence / Bramble Row` (entire contiguous wall)
  - `M016 Crumbly Dirt Clod`
  - `M025 Patrolling Ladybug`
  - `M027 Creeping Moss` (targeted cell only)
  - `M042 Dry Leaf Bridge` (after broken state)
  - *Non-hammerable:* Gates, portals, turntables, rotors, levers, pressure plates, locks, cages, and Great Orb Spider.

### 2. Complete Phase 1 Mechanics Catalog (M001–M049 + Finale)
| # | Intro | ID | Themed Name | Generic Name | Cat | Ants | Bees | Tall | Hammerable |
|---|---|---|---|---|---|---|---|---|---|
| 1 | L11 | **M001** | Garden Pebble / Sunflower Stalk | Single Blocker | B | Blocks | If tall | Per inst. | Yes |
| 2 | L21 | **M002** | Twig Fence / Bramble Row | Long Wall | B | Blocks | If tall | Per inst. | Yes (whole) |
| 3 | L31 | **M003** | Dew-Stuck Line | Frozen Path | C | Locked until hit | Locked until hit | N/A | No |
| 4 | L41 | **M032** ⇄ | Bee Lines (Air Layer) | Two Layers | L | Cover-locked | Air layer | N/A | No |
| 5 | L51 | **M005** | Petal Gate | Color Gate | B | Non-matching bonk | If tall | Per inst. | No |
| 6 | L61 | **M006** | Bamboo One-Way Tube | One-Way Tile | D | One-way traversal | Ignored | false | No |
| 7 | L71 | **M007** | Morning Glory Gate | Countdown Gate | C | Blocks while closed | If tall | Per inst. | No |
| 8 | L81 | **M008** | Burrow Tunnel Pair | Portal Pair | D | Teleports ants | Ignored | false | No |
| 9 | L91 | **M009** | Twig Lever & Vine Gates | Lever + Toggle Gates | T | Lever+gates | Gates if tall | Gates per inst. | No |
| 10 | L101 | **M010** | Morning Mist | Fog Patch | C | Hides & locks | Hides & locks | N/A | No |
| 11 | L111 | **M011** | Petal-Linked Pair | Chained Pair | P | Simultaneous exit | Simultaneous exit | N/A | No |
| 12 | L121 | **M012** | Napping Line | Sleeping Path | P | Wake via adjacent | Wake via adjacent | N/A | No |
| 13 | L131 | **M013** | Spinning Daisy | Turntable | T | Rotates 90° | Rotates 90° | false | No |
| 14 | L141 | **M014** | Curled Leaf Deflector | Mirror / Deflector | D | 90° turn | If tall | Per inst. | No |
| 15 | L151 | **M015** | Twig Bridge | Bridge (Over/Under) | L | Bridge traversal | Ignored | false | No |
| 16 | L161 | **M016** | Crumbly Dirt Clod | Cracked Rock | C | Breaks in 2 hits | Ignored | false | Yes |
| 17 | L171 | **M017** | Rain-Alert Line | Countdown Path | C | Ticks down moves | Ticks down moves | N/A | No |
| 18 | L181 | **M018** | Clover Switch | Switch Junction | T | Toggles path dir | Ignored | false | No |
| 19 | L191 | **M019** | Acorn Pressure Plate | Pressure Plate | T | Ant steps trigger | Gates if tall | Gate per inst. | No |
| 20 | L201 | **M020** | Anthill & Hive Entrance | Inner Exit | G | Ant exit hole | Bee hive hole | Layer param | No |
| 21 | L211 | **M021** | Hide-and-Seek Line | Phasing Path | P | Solid/ghost cycle | Solid/ghost cycle | N/A | No |
| 22 | L221 | **M022** | Backward-Walking Line | Reverse Path | P | Exits from tail | Exits from tail | N/A | No |
| 23 | L231 | **M023** | Two-Way Scout Line | Two-Head Path | P | Tap head chooses | Tap head chooses | N/A | No |
| 24 | L241 | **M024** | Double-File Line | Wide Path (2-wide) | P | 2-cell wide exit | 2-cell wide exit | N/A | No |
| 25 | L251 | **M025** | Patrolling Ladybug | Patrol Blocker | C | Moves per turn | Ignored | false | Yes |
| 26 | L261 | **M026** | Sugar Crumbs & Nectar Drops | Collect Gems | G | Ant collects crumb| Bee collects nectar| Layer param | No |
| 27 | L271 | **M027** | Creeping Moss | Spreader | C | Expands per turn | Ignored | false | Yes (1 cell) |
| 28 | L281 | **M028** | Marching Order | Numbered Paths | P | Strict order 1..N | Strict order 1..N | N/A | No |
| 29 | L291 | **M029** | Brick Edging | Edge Wall | B | Blocks edge exit | If tall | Per inst. | No |
| 30 | L301 | **M030** | Painted Garden Gate | Color Edge | B | Matches color | If tall | Per inst. | No |
| 31 | L311 | **M031** | Latching Gate | Closing Edge | C | Closes after N exits| If tall | Per inst. | No |
| 32 | L321 | **M004** ⇄ | Dew Key & Thorn Lock | Key & Lock | K | Key unlocks lock | If tall | Per inst. | No |
| 33 | L331 | **M033** | Flower-Bud Cage | Color Cage | K | Key color frees | Key color frees | N/A | No |
| 34 | L341 | **M034** | Lily-Pad Rotor | Rotor 2×2 | T | Rotates 2×2 grid | Rotates 2×2 grid | false | No |
| 35 | L351 | **M035** | Brood Line | Spawner Path | P | Splits on exit | Splits on exit | N/A | No |
| 36 | L361 | **M036** | Hungry Line | Hungry Path | P | Must eat crumb | Must eat blossom | Layer param | No |
| 37 | L371 | **M037** | Mud Puddle | Mud Trap | D | Stops and traps | Ignored | false | No |
| 38 | L381 | **M038** | Mushroom Spring | Jump Pad | G | Jumps over 2 cells | Ignored | false | No |
| 39 | L391 | **M039** | Mirror-Twin Lines | Mirror Twins | P | Inverted movement | Inverted movement| N/A | No |
| 40 | L401 | **M040** | Twilight Garden | Night Board | G | Lantern radius | Lantern radius | N/A | No |
| 41 | L411 | **M041** | Rainbow Pollen Line | Chameleon Path | P | Adopts gate color | Adopts gate color| N/A | No |
| 42 | L421 | **M042** | Dry Leaf Bridge | Fragile Bridge | L | Crumbles after 1 | Ignored | false | After break |
| 43 | L431 | **M043** | Bramble Multi-Lock | Multi-Lock | K | Needs 2–3 keys | If tall | Per inst. | No |
| 44 | L441 | **M044** | Twisting Burrow | Turning Portal | D | Changes direction | Ignored | false | No |
| 45 | L451 | **M045** | Root Gear Lever | Gear Lever | T | Rotates connected | Rotates connected| false | No |
| 46 | L461 | **M046** | Ring-Around Line | Loop Path | K | Head meets tail | Head meets tail | N/A | No |
| 47 | L471 | **M047** | Recruiting Line | Growing Path | C | Adds tail insects | Adds tail insects | N/A | No |
| 48 | L481 | **M048** | Colony Call | Color Group Tap | P | Taps all of color | Taps all of color | N/A | No |
| 49 | L491 | **M049** | Great Orb Spider | Guardian | X | Web blocks area | Web blocks air | true (fixed) | No |
| — | L500 | — | **Queen's Garden Gala** | Phase 1 Finale | X | Grand puzzle mix | Grand puzzle mix | Mixed | No |

### 3. Key Mechanic Specifics
- **M032 Bee Lines (L41, M004 slot):** Tapping an ant line directly beneath a bee line triggers a locked tap with the tooltip: "A bee is resting on this line".
- **M004 Dew Key & Thorn Lock (L321, M032 slot):** A key line collects the dewdrop key upon exit, flying to and unlocking the target Thorn Lock.
- **M049 Great Orb Spider (L491):** The spider occupies a 2x2 web in the garden centre. Every 3 moves, it shifts web strands. Spider is defeated once all garden lines are evacuated.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/mechanic_base.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/blocker_mechanics.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/trigger_mechanics.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/path_modifier_mechanics.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/guardian_spider.dart` (to be created)
- `packages/puzzle_core/lib/src/models/mechanic_instance.dart` (to be created)

## Risks
- Incorrect `tall` state propagation could cause bees to collide with ground pebbles or ignore tall sunflower stalks.
- Multi-lock (M043) and chained pairs (M011) must cleanly update solver graph dependencies.

## Open Questions
- None. All mechanics match the 49 canonical rules and the swap defined in SHARED_CORE_STANDARD.md §10.

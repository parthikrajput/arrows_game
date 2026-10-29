Source docs: phase_2/03_OBSTACLE_CATALOG_PHASE_2.md, SHARED_CORE_STANDARD.md. Depends on: specs/gameplay/obstacle-catalog-phase-1.md

# Spec: Obstacle and Mechanics Catalog (Phase 2, M051–M099)

## Status
Draft

## Type
New Feature

## Goal
Specify all 49 Phase 2 mechanics (M051–M099) and the Level 1000 Phase Finale, including 3-layer interactions, diagonal movement, push block physics, light/sunbeam networks, and boss mechanics for Ants & Bees: Garden Trails.

## Current State
Design documented in phase_2/03_OBSTACLE_CATALOG_PHASE_2.md and SHARED_CORE_STANDARD.md.
- Extends `specs/gameplay/obstacle-catalog-phase-1.md`.
- Phase 1 defined M001–M049 and 2 layers.
- Phase 2 introduces M051–M099 scheduled every 10 levels from L511 to L991, plus the L1000 Finale "Queen's Midsummer Jubilee".

## Proposed Change
Implement the Phase 2 mechanics library in `packages/puzzle_core/lib/src/mechanics/`:

### 1. Layer and Interaction Matrix in Phase 2
- **Ground (`layer: 0`):** Ants. Interacts with all obstacles and ground mechanics.
- **Air (`layer: 1`):** Worker Bees. Interacts only with bee lines, `tall: true` obstacles, and air-specific mechanics.
- **Canopy (`layer: 2`, introduced at L691 via M069):** Canopy Scout Bees. Interacts only with canopy lines, `tall: true` obstacles, and high-altitude elements.
- **Cover Lock Hierarchy:** Canopy (L2) locks Air (L1); Air (L1) locks Ground (L0).
- **Leaf Blower (Hammer) in Phase 2:**
  - Can remove any visible line (counts as exit).
  - Can remove **M053 Rolling Acorn** (even when resting on slick leaves).
  - Can remove **M097 Toppling Toadstool** (the first toadstool `d1` only).
  - All other Phase 2 mechanics are non-hammerable.

### 2. Complete Phase 2 Mechanics Catalog (M051–M099 + Finale)
| # | Intro | ID | Themed Name | Generic Name | Cat | Ants | Bees (Air/Canopy) | Tall | Hammerable | Non-Monotone (N) |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | L511 | **M051** | Diagonal Dash Lines | Diagonal Paths | P | Diagonal | Diagonal | N/A | No | — |
| 2 | L521 | **M052** | Pinecone Bumper | Corner Bumper | D | Deflects diag | If tall | Per inst. | No | — |
| 3 | L531 | **M053** | Rolling Acorn | Push Block | T | Pushable | Push if tall | Per inst. | Yes | Yes |
| 4 | L541 | **M054** | Dew-Slick Lily Leaf | Ice Floor | D | Slides block | Ignored | false | Block on it: Yes | — |
| 5 | L551 | **M055** | Seed Socket Plate | Block Plate | T | Socket trigger | Gate if tall | Gate per inst. | No | Yes |
| 6 | L561 | **M056** | Dandelion Lift | Ramp (Layer Shift)| L | Elevates to air| Shifts layer | `pair` param | No | — |
| 7 | L571 | **M057** | Sleepy Tulip Gate | Traffic Light | C | Cycles open/shut| If tall | Per inst. | No | Yes |
| 8 | L581 | **M058** | Spinning Seed Arrow | Rotating Arrow | D | Rotates one-way | If tall | Per inst. | No | Yes |
| 9 | L591 | **M059** | Pollen Paint Patch | Paint Cell | P | Recolors ant | If tall | Per inst. | No | — |
| 10 | L601 | **M060** | Twin Mushroom Swap | Swap Pad | T | Swaps lines | Swaps lines | false | No | Yes |
| 11 | L611 | **M061** | Little Anthill & Mini Hive | Capacity Hole | G | Exits N ants | Exits N bees | `layer` param | No | — |
| 12 | L621 | **M062** | Flower Bed Delivery | Edge Quota | G | Edge quota | Edge quota | N/A | No | — |
| 13 | L631 | **M063** | Sugar Cube Lure | Magnet Blocker | C | Pulls lines | If tall | Per inst. | No | Yes |
| 14 | L641 | **M064** | Seesaw Twig Gates | Seesaw Gates | T | Alternates open| If tall | Per inst. | No | Yes |
| 15 | L651 | **M065** | Buried Dew Key | Hidden Key | K | Discovered key | Discovered key | Lock per inst. | No | — |
| 16 | L661 | **M066** | Petal-Linked Trio | Chained Triplet | P | 3-way linked | 3-way linked | N/A | No | — |
| 17 | L671 | **M067** | Crumbling Soil Patch | Collapsing Floor | C | Breaks on step | Ignored | false | No | Yes |
| 18 | L681 | **M068** | Honey-Drip Line | Trail Blocker | C | Leaves trail | Leaves trail | N/A | No | Yes |
| 19 | L691 | **M069** | Canopy Scout Bees | Three Layers | L | Covered by L1/L2| Air + Canopy | N/A | No | — |
| 20 | L701 | **M070** | Compass Flower Lever | Global Rotator | T | Rotates all dir | Rotates all dir | false | No | Yes |
| 21 | L711 | **M071** | Counting Hedge Gap | Quota Edge | B | Exits after Q | If tall | Per inst. | No | — |
| 22 | L721 | **M072** | Garland Order | Color Sequence | P | Color order | Color order | N/A | No | — |
| 23 | L731 | **M073** | Dew Bubble Line | Bubble Path | P | Absorbs 1 bonk | Absorbs 1 bonk | N/A | No | — |
| 24 | L741 | **M074** | Old Stone Wall | Armored Wall | B | 3-hit wall | If tall | Per inst. | No | Yes |
| 25 | L751 | **M075** | Creeping Mist | Creeping Fog | C | Expands fog | Expands fog | N/A | No | Yes |
| 26 | L761 | **M076** | Burrow Network | Portal Network | D | Multi-burrow | Ignored | false | No | — |
| 27 | L771 | **M077** | Puffball Mushroom | Bomb Blocker | X | 3x3 clearance | If tall | Per inst. | No | — |
| 28 | L781 | **M078** | Greenhouse Garden | Center-Only Exit | B | Edges walled | Edges walled | true (fixed) | No | — |
| 29 | L791 | **M079** | Turning Flower Bed | Board Rotator | T | Rotates board | Rotates board | N/A | No | Yes |
| 30 | L801 | **M080** | Twin Thorn Locks | Twin Locks | K | Dual key lock | If tall | Per inst. | No | — |
| 31 | L811 | **M081** | Copycat Line | Mimic Path | P | Mimics moves | Mimics moves | N/A | No | Yes |
| 32 | L821 | **M082** | Trickling Brook | Conveyor | D | Drifts 1 cell | Ignored | false | No | Yes |
| 33 | L831 | **M083** | Stone Slab Plate | Heavy Plate | T | Double-wide only| Gate if tall | Gate per inst. | No | Yes |
| 34 | L841 | **M084** | Sunbeam Lens | Laser Emitter | B | Ground beam | Air beam | Per inst. + `layer` | No | — |
| 35 | L851 | **M085** | Sun-Seeker Sunflower | Laser Receiver | T | Receiver gate | If tall | Per inst. | No | Yes |
| 36 | L861 | **M086** | Beetle-Shell Mirror | Beam Mirror | D | Reflects beam | If tall | Per inst. | No | — |
| 37 | L871 | **M087** | Tree Sap Drop | Glue Pad | P | Traps insect | Traps insect | `layer` param | No | Yes |
| 38 | L881 | **M088** | Bramble Snare | Lane Mine | K | Mine disarm | If tall | Per inst. | No | — |
| 39 | L891 | **M089** | Dew Prism | Prism | D | Splits beam | If tall | Per inst. | No | — |
| 40 | L901 | **M090** | Firefly Lantern Gate | Parity Gate | C | Parity toggle | If tall | Per inst. | No | Yes |
| 41 | L911 | **M091** | Giant Lily-Pad Rotor | Rotor 3×3 | T | Rotates 3x3 | Rotates 3x3 | false | No | Yes |
| 42 | L921 | **M092** | Caravan Line | Segmented Path | P | Exits in halves | Exits in halves | N/A | No | Yes |
| 43 | L931 | **M093** | Scatter Line | Splitter Path | P | Splits in 4 | Splits in 4 | N/A | No | Yes |
| 44 | L941 | **M094** | Petal Mixing Bowl | Color Mixer | P | Blends colors | If tall | Per inst. | No | — |
| 45 | L951 | **M095** | Colored Hedge Gap | Color Quota Edge | B | Quota by color | If tall | Per inst. | No | — |
| 46 | L961 | **M096** | Dusk Shadow Line | Shadow Path | P | Visible on odd | Visible on odd | N/A | No | Yes |
| 47 | L971 | **M097** | Toppling Toadstools | Domino Chain | B | Chain collapse | If tall | Per inst. | d1 only | — |
| 48 | L981 | **M098** | Great Stag Beetle | Moving Guardian | X | Patrols & blocks| Patrols & blocks| true (fixed) | No | Yes |
| 49 | L991 | **M099** | Royal Hive Door | Master Lock | K | Master beam lock| Master beam lock| true (fixed) | No | — |
| — | L1000 | — | **Queen's Midsummer Jubilee**| Phase 2 Finale | X | Grand 3-layer mix| Grand 3-layer mix| Mixed | No | Yes |

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase2_mechanics.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/beam_system.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/patrolling_guardian.dart` (to be created)

## Risks
- Cyclic dependencies in 3-layer puzzle layouts could cause exponential states in the solver if not pruned via visited state hashing.

## Open Questions
- None. All 49 mechanics and parameters correspond to phase_2/03_OBSTACLE_CATALOG_PHASE_2.md.

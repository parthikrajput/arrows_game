Source docs: phase/phase_2/03_OBSTACLE_CATALOG_PHASE_2.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/gameplay/obstacle-catalog-phase-1.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Obstacle Catalog — Phase 2 (Mechanics M051–M099 + Finale)

## Status
Draft

## Type
New Feature

## Goal
Catalog and specify the complete suite of 49 sewing-themed Phase 2 puzzle mechanics (M051 through M099) and the Level 1000 Grand Finale for Yarn Unravel, detailing their gameplay rules, category classifications, hammer and booster interactions, resolution order, and JSON schema v3 representations.

## Current State
Design documented in `phase/phase_2/03_OBSTACLE_CATALOG_PHASE_2.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 catalog in `specs/gameplay/obstacle-catalog-phase-1.md` defined M001–M049.
- Phase 2 expands the library with 49 mechanics unlocking at every x1 level slot (L511 to L991).
- Mechanics span 10 categories: Paths (P), Deflectors (D), Timers/Counters (C), Triggers/Switches (T), Blockers (B), Layers (L), Gates (G), Keys/Locks (K), Explosives/Hazards (X), and Moving Guardians (G).

## Proposed Change
Implement individual mechanic controllers in `packages/puzzle_core/lib/src/mechanics/phase_2/` adhering to the standard schema:

### 1. Mechanic Catalog (M051–M099)

| ID | Themed Name | Generic Concept | Intro Lvl | Cat | Hammerable | Rule Summary |
|---|---|---|---|---|---|---|
| **M051** | Bias-Cut Thread | Diagonal Paths | 511 | P | Thread: yes | Moves in diagonal directions (UL, UR, DL, DR); 8-connected body cells; squeeze rule applies. |
| **M052** | Felt Corner Bumper | Corner Bumper | 521 | D | No | Diagonal deflector reflecting incoming diagonal pull lanes 90° across corners. |
| **M053** | Bobbin Crate | Push Block | 531 | T | Yes | Pushed 1 cell along pull lane if rear space is free; falls off open edges; walled edge causes snag. |
| **M054** | Satin Glide Patch | Ice Floor | 541 | D | No | Frictionless surface causing pushed crates to slide until hitting a solid block or board edge. |
| **M055** | Crate Dock Plate | Block Plate | 551 | T | No | Pressure plate that lowers associated Loom Gates only while occupied by a Bobbin Crate. |
| **M056** | Pleat Ramp | Ramp | 561 | L | No | Bi-directional ramp shifting a traversing thread's layer (+1 or -1) during exit. |
| **M057** | Loom Shuttle Gate | Traffic Light | 571 | C | No | Alternates between open and closed state every N Moves (default 2 Moves). |
| **M058** | Spinning Stitch Arrow | Rotating Arrow | 581 | D | No | Rotates 90° clockwise on every Move; forces passing orthogonal lanes along its arrow direction. |
| **M059** | Dye Pot | Paint Cell | 591 | P | No | Changes passing thread color to the pot's dye color; does not block movement. |
| **M060** | Swap Hoop | Swap Pad | 601 | T | Threads: yes | Swaps positions and orientations of two threads when both occupy linked swap hoops. |
| **M061** | Drawstring Pouch | Capacity Hole | 611 | G | No | Swallows up to N threads into its pouch before closing and acting as a solid wall. |
| **M062** | Sorting Hem | Edge Quota | 621 | G | No | Board edge requiring a specific count of matching-colored threads to exit before opening. |
| **M063** | Magnet Pin Dish | Magnet Blocker | 631 | C | No | Draws adjacent needle heads toward it every N Moves, redirecting their exit lanes. |
| **M064** | Seesaw Latches | Seesaw Gates | 641 | T | No | Paired gates: opening one latch instantly closes the linked twin latch. |
| **M065** | Hidden Charm | Hidden Key | 651 | K | No | Key hidden beneath a thread; revealed and collected only when the covering thread unravels. |
| **M066** | Ribbon-Tied Trio | Chained Triplet | 661 | P | Thread: 1 | Three interconnected threads; all three must unravel in consecutive Moves or reset. |
| **M067** | Worn Fabric Patch | Collapsing Floor | 671 | C | No | Weakened fabric tile that collapses into an impassable hole after being crossed N times. |
| **M068** | Lint Trail | Trail Blocker | 681 | C | No | Deposition of sticky lint left behind along a thread's exit path, blocking subsequent lanes for 3 Moves. |
| **M069** | Triple Fabric Layers | Three Layers | 691 | L | Threads: yes | Extends depth to 3 layers (Lining, Fabric, Tulle); upper layers lock threads underneath. |
| **M070** | Great Spool Lever | Global Rotator | 701 | T | No | Interactive lever that rotates all needle heads on the board 90° clockwise. |
| **M071** | Drawstring Hem | Quota Edge | 711 | B | No | Constricted border that opens only after a specified total number of threads have cleared. |
| **M072** | Pattern Card Sequence | Color Sequence | 721 | P | Next in pattern | Enforces strict color order for unraveling based on an illustrated weaving pattern card. |
| **M073** | Cushioned Thread | Bubble Path | 731 | P | Thread: yes | Protected thread enclosed in wool batting; survives 1 bump without losing a Heart. |
| **M074** | Brass Bar Wall | Armored Wall | 741 | B | **No** | Heavy brass reinforcing bar impervious to Golden Scissors (hammerable = false). |
| **M075** | Creeping Fluff | Creeping Fog | 751 | C | No | Wool fluff that expands 1 cell toward the board center every 4 Moves unless cleared. |
| **M076** | Pompom Tunnel Network| Portal Network | 761 | D | No | Network of 3+ colored tunnels; threads exit through the matching-colored portal. |
| **M077** | Confetti Popper | Bomb Blocker | 771 | X | Yes (no blast) | Explodes on impact or when triggered, clearing adjacent obstacles within a 3x3 radius. |
| **M078** | Closed Hoop Frame | Center-Only Exit | 781 | B | No | Impassable perimeter frame forcing threads to exit through a central embroidery opening. |
| **M079** | Turning Quilt Frame | Board Rotator | 791 | T | No | Interactive frame mechanism that rotates a 4x4 sub-grid of cells 90° clockwise. |
| **M080** | Color Hem Gap | Color Exit | 801 | B | No | Edge gap that allows only threads of matching yarn color to unravel through it. |
| **M081** | Basting Thread | Elastic Path | 811 | P | Thread: yes | Stretches forward 2 cells when pulled; retracts back to origin if blocked. |
| **M082** | Feed Dog Belt | Conveyor Belt | 821 | D | No | Sewing machine feed dog strip that shifts occupying crates/threads 1 cell in direction every Move. |
| **M083** | Heavy Treadle Plate | Heavy Plate | 831 | T | No | Floor plate requiring a heavy entity (Bobbin Crate M053 or Chunky Chenille M024) to depress. |
| **M084** | Sewing Lamp Emitter | Laser Emitter | 841 | L | No | Casts continuous optical light beams across the board on its layer; beam cells block lanes. |
| **M085** | Sun-Catcher | Laser Detector Gate | 851 | L | No | Sensor gate that stays open only while struck by an active lamp light beam. |
| **M086** | Vanity Mirror | Laser Mirror | 861 | L | No | Reflector that deflects both light beams and thread pull lanes 90° across the board. |
| **M087** | Moving Light Spool | Laser Mover | 871 | L | No | Mobile lamp emitter that slides back and forth along a rail every Move. |
| **M088** | Lamp Sensor Wall | Laser Toggle Wall | 881 | L | No | Wall barrier that toggles open/closed each time a light beam path is interrupted. |
| **M089** | Crystal Bead Prism | Laser Splitter | 891 | L | No | Prism bead that splits an incoming light beam into two orthogonal output beams. |
| **M090** | Stitch Clock | Tick-Tock Wall | 901 | C | No | Wall that alternates open on even Move counts and closed on odd Move counts. |
| **M091** | Spool Swivel Turntable | Rotary Turntable | 911 | T | No | Turntable cell that rotates the occupying thread or crate 90° upon entry. |
| **M092** | Segmented Thread | Segment Snake | 921 | P | Thread: yes | Thread that sheds its rear segment upon unraveling, leaving the rest on the board. |
| **M093** | Memory Thread | Mimic Path | 931 | P | Thread: yes | Copies the movement vector of the player's previously unraveled thread. |
| **M094** | Purl's Claw Scratcher | Multi-Hit Gate | 941 | B | No | Reinforced wooden gate requiring 3 distinct thread bumps or hammer strike to break. |
| **M095** | Thread Snip Scissors | Trap Hazard | 951 | X | No | Hazard tile that severs any thread passing over it, causing instant heart loss. |
| **M096** | Alternating Loom Gate | Parity Gate | 961 | C | No | Dual gates tied to Move parity: Gate A opens on even moves; Gate B opens on odd moves. |
| **M097** | Wooden Bobbin Dominoes| Domino Chain | 971 | X | Yes | Chain-reaction bobbins that topple sequentially, knocking down connected blockers. |
| **M098** | Wandering Guardian | Patrol Monster | 981 | G | No | Animated pincushion patrol traversing a fixed path every Move; blocks intersecting lanes. |
| **M099** | Master Jewel Clasp | Master Key Gate | 991 | K | No | Master padlock requiring three distinct jeweled pins to be collected before opening. |

### 2. Level 1000 Finale: "The Heirloom Tapestry"
- Integrates Wandering Pincushion Guardian (M098) patrol loop with Sewing Lamps (M084), Sun-Catchers (M085), Bobbin Crates (M053), and Master Jewel Clasp (M099).
- Requires exact coordination of crate pushes and beam redirections across 3 fabric layers.

### 3. Unit Test Coverage
Each mechanic ID requires a dedicated test file `packages/puzzle_core/test/mechanics/m0xx_test.dart` testing:
1. Rule happy path (unravel, toggle, trigger).
2. Snag and locked behavior.
3. Golden Scissors interaction (`hammerable` flag verification).
4. Solver zero-heart solvability on intro level.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_2/*.dart` (to be created: 49 mechanic controllers)
- `packages/puzzle_core/test/mechanics/m051_test.dart` through `m099_test.dart` (to be created)

## Risks
- High complexity of beam splitter loops (M089) and crate sliding loops (M054). Mitigated by cycle detection guard terminating after board width steps.

## Open Questions
None. All definitions align with `SHARED_CORE_STANDARD.md` §10.

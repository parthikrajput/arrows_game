Source docs: phase/phase_2/03_OBSTACLE_CATALOG_PHASE_2.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/gameplay/obstacle-catalog-phase-1.md, specs/gameplay/core-concept-and-rules.md, specs/gameplay/phase-2-scope-and-rules.md.

# Spec: Obstacle & Mechanics Catalog Phase 2 (M051–M099 & L1000 Finale)

## Status
Draft

## Type
New Feature

## Goal
Specify the developer-ready mechanics catalog for Phase 2 (Levels 501–1000) of Toy Trains: Wooden Railway Puzzle, defining all 49 new railway mechanics (M051–M099), their standard definitions, wooden toy theme implementations, collision and tap behaviors, hammerability, solver implications, and the L1000 Grand Terminus Finale boss board.

## Current State
Design documented in `phase/phase_2/03_OBSTACLE_CATALOG_PHASE_2.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 catalog (`specs/gameplay/obstacle-catalog-phase-1.md`) defined M001–M049 (Buffer Stops, Level Crossings, Turntables, Drawbridges, Clock Tower Guardian, etc.).
- Phase 2 introduces 49 new mechanics on a strict 10-level block rhythm (introduced at x1 of each block from L511 to L991).

## Proposed Change
Implement the Phase 2 mechanics engine classes within `packages/puzzle_core/lib/src/mechanics/phase_2/`:

### 1. Categories & General Rules
- **Categories:** **B** Static Blocker, **K** Key/Lock, **C** Move Counter, **T** Toggle/Interactive, **P** Path-variant, **D** Direction changer, **L** Layer, **G** Goal/Helper, **X** Boss.
- **Track Crane (Hammer) Eligibility:** In Phase 2, strictly only Push Carts (M053, M054) and the first Domino Crate (M097) are hammerable (`hammerable: true`). Gates, mirrors, sensor boxes, light lamps, and guardians are not hammerable.
- **Intro Constraint:** Each x1 intro level contains only the intro mechanic plus at most 1 earlier mechanic. Composite partner mechanics (e.g. M054/M055 with M053; M085/M086/M089 with M084) occupy that 1 earlier mechanic slot.

### 2. Comprehensive Mechanics Catalog (M051–M099)

| ID | Themed Name | Intro Level | Cat | Core Standard Rule & Railway Interaction | Hammerable | Non-Monotone (N?) |
|---|---|---|---|---|---|---|
| **M051** | Diagonal Express | L511 | P | Trains oriented diagonally (`UL, UR, DL, DR`); exit lane projects diagonally across grid corners. Coupling-cross blocks intersection. | No (Train) | No |
| **M052** | Corner Buffer | L521 | D | Curved wooden buffer placed at cell vertices that deflects diagonal train lanes by 90°. | No | No |
| **M053** | Push Cart | L531 | T | 1-cell wooden cart. Train lane hitting it shoves it 1 cell forward if space behind is clear (1 Move, path stays, 0 hearts lost). Blocked = bump. | **Yes** | Yes |
| **M054** | Frosty Rails | L541 | D | Frictionless icy track section. Pushed cart slides continuously across Frosty Rails until hitting an obstacle or board boundary. | Cart Yes, Rail No | No |
| **M055** | Cart Weighbridge | L551 | T | Pressure plate for carts. While a Push Cart rests on the weighbridge, linked railway signal gates remain held open. | No | Yes |
| **M056** | Viaduct Ramp | L561 | L | Incline track ramp that shifts a traveling train from Layer 0 to Layer 1, or Layer 1 to Layer 2, mid-departure. | No | No |
| **M057** | Alternating Signal | L571 | C | Dual semaphore signal that alternates between open and closed state every N Moves (periodic cycle). | No | Yes |
| **M058** | Spinning Arrow Rail | L581 | D | Directional arrow track tile that rotates 90° CW on each Move turn. Trains passing it must travel in current arrow direction. | No | Yes |
| **M059** | Paint Shed | L591 | P | Track shed containing paint bath. Exiting train lane passing through the shed is recolored to shed's livery color. | No | No |
| **M060** | Swap Platform | L601 | T | Interactive hydraulic platform. Tapping the switch swaps positions of 2 linked trains (strictly identical shape and length). | No | Yes |
| **M061** | Small Engine Shed | L611 | G | Internal terminal siding that absorbs exactly N trains, then permanently shuts its doors. | No | Yes |
| **M062** | Delivery Platform Quota | L621 | G | Station platform requiring >= Q trains of a specific livery to exit through its designated board edge. | No | No |
| **M063** | Magnet Post | L631 | C | Crane with magnetic post. On every Move, pulls nearest train in its cardinal row/column 1 cell toward it if space is free. | No | Yes |
| **M064** | Seesaw Barriers | L641 | T | Pair of mechanically linked gates: exactly one is open. Whenever a train exits through the open gate, the seesaw flips. | No | Yes |
| **M065** | Hidden Ticket | L651 | K | Golden Ticket key tile hidden beneath steam fog or another train; revealed and collectible only when covering element departs. | No | No |
| **M066** | Triple-Coupled Engines | L661 | P | Three engines coupled in tandem (extends M011); tapping one initiates departure for all three in rigid sequence. | No (Train) | No |
| **M067** | Worn Sleepers | L671 | C | Weakened wooden track bed. After N train passages, the sleepers collapse into a hole blocker. | No | Yes |
| **M068** | Smoke Trail Train | L681 | C | Exiting vintage steam engine leaves lingering puff blockers along its vacated track cells for 2 Moves. | No (Train) | Yes |
| **M069** | Triple-Deck Viaduct | L691 | L | Three-tier railway bridge supporting simultaneous independent tracks on Ground (L0), Mid (L1), and Top (L2). | No | No |
| **M070** | Roundhouse Lever | L701 | T | Central yard master lever. Tapping it rotates every train's heading by 90° CW simultaneously. | No | Yes |
| **M071** | Departure Quota Gate | L711 | B | Heavy iron boundary barrier that unlocks only after Q total trains of any type have departed. | No | No |
| **M072** | Colour Timetable | L721 | P | Station departure board displaying strict color sequence (e.g. Red -> Blue -> Yellow); departures out of order are locked. | No (Train) | No |
| **M073** | Cushion Train | L731 | P | Train fitted with pneumatic spring buffers; absorbs 1st incoming collision without heart loss, popping the cushion. | No (Train) | No |
| **M074** | Iron Girder Wall | L741 | B | Indestructible steel girder barrier; immune to Track Crane, removable solely via its remote lever. | No | No |
| **M075** | Creeping Steam | L751 | C | Boiler steam leak that expands outward by 1 cell every N Moves in deterministic cardinal order. | No | Yes |
| **M076** | Tunnel Network | L761 | D | Multi-portal tunnel system with 3+ portals cycling traffic sequentially: Portal A -> B -> C -> A. | No | No |
| **M077** | Popper Crate | L771 | X | Explosive ballast crate. When linked trigger train exits, crate detonates, clearing all hammerable blockers in 3x3 radius. | No | No |
| **M078** | Island Station | L781 | B | Enclosed tabletop layout with walled perimeter edges; trains must escape solely via internal Depot Siding pits. | No | No |
| **M079** | Spinning Playmat | L791 | T | Mechanized revolving table section. Every N Moves, the entire designated zone rotates 90° CW, rotating train headings. | No | Yes |
| **M080** | Twin Ticket Barriers | L801 | K | Dual ticket barriers requiring two keys to exit on the exact same Move turn (utilizing M011 or M066 coupled trains). | No | No |
| **M081** | Copycat Engine | L811 | P | Puppet shunter engine that dynamically reorients its heading to match the departure direction of the previous moved train. | No (Train) | Yes |
| **M082** | Conveyor Track | L821 | D | Motorized shunting belt. Any train resting fully on the conveyor is shifted 1 cell forward along the belt on each Move turn. | No | Yes |
| **M083** | Heavy Weighbridge | L831 | T | Heavy-duty pressure plate calibrated specifically for M024 Wide Load trains; standard-width trains cannot trigger it. | No | Yes |
| **M084** | Signal Lamp | L841 | B | Powerful optical lamp projecting continuous linear light beam that acts as a physical barrier across track lanes. | No | Yes |
| **M085** | Light Sensor Box | L851 | T | Photocell receiver. When struck by an unbroken Signal Lamp beam, triggers linked signal gate to hold open. | No | Yes |
| **M086** | Signal Mirror | L861 | D | Polished railway mirror reflecting both optical light beams and approaching train lanes by 90° CW. | No | No |
| **M087** | Jam Spill | L871 | P | Track spoiled with sticky locomotive grease/jam. 1st tap un-sticks the train (1 Move); 2nd tap initiates normal departure. | No | No |
| **M088** | Track Clamp | L881 | K | Emergency track clamp (mine). Blocks train lane until defused by the successful departure of its designated key engine. | No | No |
| **M089** | Crystal Prism | L891 | D | Optical crystal prism that refracts an incoming Signal Lamp beam into two perpendicular outgoing beams. | No | No |
| **M090** | Tick-Tock Gate | L901 | C | Clockwork barrier that opens on odd Move counts and closes on even Move counts. | No | Yes |
| **M091** | Rotating Yard 3x3 | L911 | T | 3x3 turntable turntable hub (extends M034); tapping center rotates the entire 3x3 cluster and all internal tracks 90° CW. | No | Yes |
| **M092** | Uncoupling Train | L921 | P | Articulated train where each individual tap uncouples and dispatches exactly 1 car (multi-move departure). | No (Train) | No |
| **M093** | Splitting Train | L931 | P | Symmetric twin-ended train. Tapping splits train at midpoint into two independent engines facing opposite directions. | No (Train) | No |
| **M094** | Paint Mixer Shed | L941 | P | Advanced paint shed combining livery colors (Red + Blue = Purple, Red + Yellow = Orange, Blue + Yellow = Green). | No | No |
| **M095** | Colour Quota Gate | L951 | B | Railway gate that opens only after Q trains of a designated specific color have been cleared. | No | No |
| **M096** | Shadow Train | L961 | P | Phasing ghostly train. Tangible and tappable on even Moves; intangible and transparent on odd Moves (cannot block or bump). | No (Train) | Yes |
| **M097** | Domino Crates | L971 | B | Linear row of wooden crates. Clearing the 1st crate (via Track Crane or linked train lane) cascades to clear entire line. | 1st Yes, rest No | No |
| **M098** | Marching Clock Tower | L981 | X | Patrolling robotic clock tower boss. Advances 1 cell along fixed track patrol each Move; blocks lane and crushes path if collided. | No | Yes |
| **M099** | Master Station Gate | L991 | K | Sovereign vault gate requiring 3 distinct keys plus an active optical beam focused into its receptor to unlock. | No | No |

### 3. Level 1000 Grand Terminus Finale Boss Board
- **Configuration:** 14x14 grid, 40 trains, 14 obstacle instances. Target D = **84 ±3**.
- **Boss Element:** M098 Marching Clock Tower patrolling outer perimeter corridor.
- **Mechanics Fusion:** Features >= 10 Phase 1 & 2 mechanics simultaneously: Signal Lamp (M084), Light Sensor (M085), Mirror (M086), Push Cart (M053), Frosty Rails (M054), Triple-Deck Viaduct (M069), Seesaw Barriers (M064), Domino Crates (M097), Master Station Gate (M099), and Diagonal Express trains (M051).
- **Rewards:** 50 clear coins + Grand Central Chest (1,000 coins + 2x Hint + 2x Shield + 2x Hammer + "Phase 2 Conductor" badge) + Depot Album Vol 5 #25 sticker.

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/phase_2/*.dart` (to be created: 49 mechanic behavior implementations)
- `packages/puzzle_core/lib/src/engine/collision.dart` (changed: integrate M051–M099 collision rules)
- `packages/puzzle_core/lib/src/engine/turn_pipeline.dart` (changed: integrate Phase 2 counters and interactive taps)

## Risks
- Interaction deadlocks between complex mechanics (e.g. Seesaw Barriers M064 + Signal Mirrors M086 + Light Sensors M085). Mitigation: Strict CI validator solver checking for reachable 0-heart solutions.

## Open Questions
- None. All mechanics match `phase/phase_2/03_OBSTACLE_CATALOG_PHASE_2.md` and `SHARED_CORE_STANDARD.md`.

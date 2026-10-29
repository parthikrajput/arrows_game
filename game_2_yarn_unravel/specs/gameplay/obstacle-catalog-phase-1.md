Source docs: phase_1/03_OBSTACLE_CATALOG_PHASE_1.md, ../../SHARED_CORE_STANDARD.md

# Spec: Phase 1 Obstacle Catalog (Mechanics M001–M049 and Finale)

## Status
Draft

## Type
New Feature

## Goal
Implement the 49 craft- and sewing-themed mechanics (M001 to M049) and the Level 500 Phase Finale for Yarn Unravel Phase 1, defining collision boundaries, hammer interactions, state machines, and solver integrations.

## Current State
Design documented in phase_1/03_OBSTACLE_CATALOG_PHASE_1.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- 49 mechanics divided across 9 categories: B (Static Blocker), K (Key/Lock), C (Move-based Counter), T (Toggle/Interactive), P (Path-variant), D (Direction changer), L (Layer), G (Goal/Helper), X (Boss).
- Turn-based tick sequence: moveCount increments *after* action resolve, followed by counters ticking in fixed order:
  `M007 -> M017 -> M031 -> M025 -> M027 -> M047 -> M041`.
- Golden Scissors rules: targets any visible thread OR any `hammerable: true` obstacle instance. Non-lane exit effects fire; lane traversal effects do not.

## Proposed Change
Implement the pure-Dart mechanic interface, registrations, and behavior classes in `packages/puzzle_core`:

### 1. Mechanic Interface & Lifecycle Hooks
Every mechanic implements the `Mechanic` interface with hooks:
- `blocksLane(Cell cell, LaneContext ctx)`: Evaluates if a pull lane ray hitting `cell` is blocked.
- `redirect(Cell cell, Dir dir)`: Returns redirected direction if cell alters path direction (e.g. deflector, tunnel).
- `isLocked(ThreadPath thread)`: Returns true if thread is locked (e.g. knotted, under fluff, wrong tag order).
- `onTap(BoardState state, Cell cell)`: Handles direct interactive taps (levers, spinners, switches, rotors).
- `onPathExit(ThreadPath thread, List<Cell> lane)`: Immediate exit trigger (key consumption, fluff clearing, boss damage).
- `onMoveTick(BoardState state)`: Ticks move-based countdowns and cyclic states.
- `encode()`: Emits state tuple for solver state deduplication.

### 2. Global Golden Scissors (Hammer) Rules
- **Targeting:** Any visible thread OR any obstacle with `hammerable: true`.
- **Exclusions:** Cannot target locks/clasps (M004 Clasp), Hem Walls (M029), color gates, or Grand Pincushion Guardian (M049). Cannot target threads hidden beneath Wool Fluff (M010) or threads covered by upper fabric layers (M032).
- **Exit Effect Differentiation:**
  - Snipping a thread counts as an exit: fires key/clasp unlocks, decrements Knotted Thread (M003) adjacent counts, damages Grand Pincushion Guardian HP, triggers Skein Spawners (M035), and counts toward cage color tallies.
  - Snipping does NOT trigger lane traversal effects: does not collect Sequins (M026), does not feed Loose Beads (M036), does not damage Tailor's Chalk (M016), and does not cross bridges.
- **Last Thread Guard:** Golden Scissors is disabled on the last remaining thread if Sequins (M026) remain uncollected.
- **Irreversibility:** Golden Scissors actions cannot be undone.

### 3. Move Tick Sequence (Fixed Order)
At the conclusion of each Move action:
1. Action resolves (unravel exit, snag bump, or interactive toggle).
2. Exit triggers fire immediately.
3. `moveCount += 1` (Parity mechanic M021 Sheer Silk evaluates parity prior to increment).
4. Counters tick in exact sequence: `M007 -> M017 -> M031 -> M025 -> M027 -> M047 -> M041`.
5. Derived states update (Foot Pedal Plate M019, Wool Fluff M010, Safety-Pin Cage M033, clasps).
6. Queued heart loss applies (Thimble Shield absorbs first).
7. Win check executes; if won, level completes before checking 0 hearts.
8. If hearts == 0, Second Chance triggers.

### 4. Mechanics Catalog (M001–M049)
1. **M001 Wooden Button (Single Blocker, Cat B, L11):** 1 cell. Blocks pull lane. Hammerable: true.
2. **M002 Ruler Strip (Long Wall, Cat B, L21):** 2–4 straight cells (H/V). Blocks pull lane. Hammerable: true (removes entire strip).
3. **M003 Knotted Thread (Frozen Path, Cat C, L31):** Thread with knot icon; locked until K (1–3) orthogonally adjacent threads unravel. Thread is hammerable; adjacent threads are hammerable (decrements K).
4. **M004 Charm & Clasp (Key & Lock, Cat K, L41):** Charm badge on thread; matching color clasp lock blocks lane until charm-thread unravels. Clasp is NOT hammerable.
5. **M005 Color Eyelet (Color Gate, Cat B, L51):** Passable only by thread of matching color; others snag. NOT hammerable.
6. **M006 Stitch Arrow (One-Way Tile, Cat D, L61):** Passable only in marked arrow direction; opposite or cross entry causes snag. NOT hammerable.
7. **M007 Basting Seam (Countdown Gate, Cat C, L71):** Temporary seam gate unstitches and opens permanently after N player moves. Badge shows remaining moves. NOT hammerable.
8. **M008 Pompom Tunnel (Portal Pair, Cat D, L81):** Pull lane entering Pompom A exits Pompom B in same direction. Blocked if Pompom B is occupied. NOT hammerable.
9. **M009 Presser Lever (Lever + Toggle Gates, Cat T, L91):** Tapping lever (costs 1 Move) toggles linked stitch gates open/closed. Non-monotone. NOT hammerable.
10. **M010 Wool Fluff (Fog Patch, Cat C, L101):** Soft wool patch hides needle direction and details. Tapping hidden thread is locked. Clears when an adjacent thread unravels. NOT hammerable.
11. **M011 Ribbon-Tied Pair (Chained Pair, Cat P, L111):** Two threads linked by ribbon; both must have clear pull lanes to unravel simultaneously. If either is blocked, both snag. Threads are hammerable individually.
12. **M012 Coiled Thread (Sleeping Path, Cat P, L121):** Coiled thread; first tap wakes it (straightens coil, costs 1 Move); second tap unravels it if lane is clear. Thread is hammerable.
13. **M013 Spool Spinner (Turntable, Cat T, L131):** 1-cell rotating spool. Tapping spool rotates it 90 degrees clockwise (costs 1 Move). If a needle rests on spool, its direction rotates. If rotation points needle into its own body, it becomes tangled (locked tap). NOT hammerable.
14. **M014 Hook Deflector (Mirror, Cat D, L141):** Angled crochet hook deflects incoming pull lane 90 degrees. Both entry angles valid. NOT hammerable.
15. **M015 Stitch Bridge (Bridge, Cat L, L151):** 1-cell overpass allowing orthogonal thread crossing without collision. Lower thread cannot exit while upper thread occupies bridge cell. NOT hammerable.
16. **M016 Tailor's Chalk (Cracked Rock, Cat C, L161):** Chalk mark with HP (2–3). Each pull lane traversing it reduces HP by 1. At 0 HP, chalk erases and cell becomes clear. Hammerable: true (instant clear).
17. **M017 Fraying Thread (Countdown Path, Cat C, L171):** Thread with fray counter N (5–12). Ticks down on each Move. If counter hits 0 before thread unravels, thread breaks and player loses 1 Heart (absorbed by Shield if active). Thread is hammerable.
18. **M018 Thread Guide Switch (Switch Junction, Cat T, L181):** Y-junction guide. Tapping toggles track direction between left and right branch (costs 1 Move). NOT hammerable.
19. **M019 Foot Pedal Plate (Pressure Plate, Cat T, L191):** Pressure plate cell. While occupied by a thread body, linked seam gate remains open; vacating plate closes gate. NOT hammerable.
20. **M020 Yarn Basket (Inner Exit, Cat G, L201):** Central basket hole on craft board. Threads facing basket unravel inward into basket instead of board boundary. NOT hammerable.
21. **M021 Sheer Silk Thread (Phasing Path, Cat P, L211):** Alternates between solid and translucent ghost phases on odd/even moves. In ghost phase, other threads pass through it and tapping it is locked. Solid phase interacts normally. Hammerable only during solid phase.
22. **M022 Backstitch Thread (Reverse Path, Cat P, L221):** Tapping unravels thread backwards (tail-first in opposite direction). Needle follows tail out. Thread is hammerable.
23. **M023 Double-Needle Thread (Two-Head Path, Cat P, L231):** Needles at both ends pointing outward. Tapping needle A unravels in direction A; tapping needle B unravels in direction B; middle tap defaults to `body[0]`. Both lanes must be clear for respective pull. Thread is hammerable.
24. **M024 Chunky Chenille (Wide Path, Cat P, L241):** Thick 2-cell wide thread occupying a 2xL footprint. Requires a 2-cell wide clear lane to unravel. Thread is hammerable.
25. **M025 Rolling Yarn Ball (Patrol Blocker, Cat C, L251):** Yarn ball patrolling back and forth along a fixed track every Move. Blocks intersecting lanes. Hammerable: true.
26. **M026 Sequins (Collect Gems, Cat G, L261):** Sparkling sequins placed on board cells. Must be collected by pull lanes passing through them. All sequins must be collected to win. NOT hammerable. Golden Scissors disabled on last thread if sequins remain.
27. **M027 Spreading Tangle (Spreader, Cat C, L271):** Loose tangle expanding to 1 adjacent cell every N (3–5) moves. Blocks lanes. Hammerable: true (removes 1 targeted cell per snip).
28. **M028 Tagged Threads (Numbered Paths, Cat P, L281):** Threads bearing numbered tags (1, 2, 3...). Must be unraveled in strict ascending order. Tapping out of order produces a locked tap. Thread is hammerable.
29. **M029 Hem Wall (Edge Wall, Cat B, L291):** Thick folded hem along board edges blocking threads from unraveling off that specific edge. NOT hammerable.
30. **M030 Color Hem Gap (Color Edge, Cat B, L301):** Border opening that permits only threads of matching color to exit; non-matching threads snag. NOT hammerable.
31. **M031 Zipper Edge (Closing Edge, Cat C, L311):** Zipper teeth closing 1 edge cell every N moves, permanently blocking exits through closed slots. NOT hammerable.
32. **M032 Double Fabric Layers (Two Layers, Cat L, L321):** Top and bottom linen fabric layers. Top layer threads must be unraveled before bottom layer threads become interactive. Threads on different layers do not collide. Threads are hammerable.
33. **M033 Safety-Pin Cage (Color Cage, Cat K, L331):** Safety pin locking a thread inside a cage. Unlocks when all threads of the matching color exit the board. Caged thread is hammerable.
34. **M034 Quilt Block Rotor (Rotor 2x2, Cat T, L341):** 2x2 block rotating 90 degrees when tapped (costs 1 Move). Completely enclosed threads rotate with it; partially overlapping threads lock rotor rotation. NOT hammerable.
35. **M036 Bead-Stringer Thread (Hungry Path, Cat P, L361):** Thread with needle that must string/consume loose beads placed in its pull lane. Attempting to unravel without collecting required beads results in a snag. Thread is hammerable; beads are not.
36. **M035 Skein Spawner (Spawner Path, Cat P, L351):** When unraveled, immediately spawns 1–2 smaller mini-threads on predefined empty cells. Thread is hammerable.
37. **M037 Glue Dot (Mud Trap, Cat D, L371):** Sticky craft glue dot. Thread passing over it loses forward momentum, halts on the glue cell, and relocates its rest position (costs 1 Move). Next tap pulls from new location. NOT hammerable.
38. **M038 Elastic Hop Pad (Jump Pad, Cat G, L381):** Elastic band cell that launches thread forward, leaping over 1 intermediate blocker cell without colliding. NOT hammerable.
39. **M039 Twin Skeins (Linked Pair, Cat P, L391):** Two threads that move simultaneously in parallel directions on single tap. Both lanes must be clear. Threads are hammerable.
40. **M040 Lamplight Evening (Cat G/B, L401):** Visual board state where background dims and threads glow. Highlights lane clearance visually. Excluded from Daily Challenge. NOT hammerable.
41. **M041 Ombre Thread (Cat P, L411):** Gradient thread whose active color changes every N moves (cycling red -> blue -> yellow). Interacts dynamically with color eyelets and gates. Thread is hammerable.
42. **M042 Fragile Lace Bridge (Cat L, L421):** Delicate lace bridge supporting 1 crossing. Collapses into blocker rubble after first thread passes over. Rubble is hammerable.
43. **M043 Multi-Clasp (Cat K, L431):** Reinforced clasp lock requiring 2 or 3 distinct charm keys to unlock. Clasp is NOT hammerable.
44. **M044 Twisting Pompom Tunnel (Cat D, L441):** Complex pompom tunnel whose exit angle shifts 90 degrees after each pass. NOT hammerable.
45. **M045 Treadle Gear Lever (Cat T, L451):** Multi-state treadle gear rotating 3 distinct gate sets in sequence (A -> B -> C -> A). NOT hammerable.
46. **M046 Knitted Loop (Cat P, L461):** Thread connected in a closed circle. Tapping is locked until player taps its golden closure stitch (costs 1 Move), severing loop into a standard thread. Thread is hammerable.
47. **M047 Growing Knit Thread (Cat P, L471):** Thread that extends its tail by 1 segment every N (3–5) moves, lengthening into empty cells. Thread is hammerable.
48. **M048 Color Bundle (Cat K/P, L481):** Bundle of tied threads that can only be unraveled once all threads of an external key color have exited. Threads are hammerable.
49. **M049 Grand Pincushion Guardian (Boss, Cat X, L491):** Centerpiece boss with HP (3–5). Every unraveled thread of matching color fires a pin that strikes the pincushion, reducing HP by 1. At 0 HP, boss pops in a puff of stuffing. Grand Pincushion is NOT hammerable.
50. **Level 500 Phase Finale ("The Grand Quilt"):** 11x11 craft board combining Grand Pincushion Guardian with >= 8 distinct Phase 1 mechanics.

## Affected Files
- `packages/puzzle_core/lib/src/model/mechanic.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m001_wooden_button.dart` to `m049_grand_pincushion.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/registry.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/render/needle_painter.dart` (to be created)

## Risks
- Interactions between deflecting hooks (M014) and pompom tunnels (M008) must be guarded against infinite redirect loops.
- Layer overlaps (M015, M032) must maintain strict hit slop priority so top layer receives taps reliably.

## Open Questions
- None. Mechanics match SHARED_CORE_STANDARD.md §10.


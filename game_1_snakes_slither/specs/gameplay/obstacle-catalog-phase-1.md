Source docs: phase_1/03_OBSTACLE_CATALOG_PHASE_1.md, ../../SHARED_CORE_STANDARD.md

# Spec: Phase 1 Obstacle Catalog (Mechanics M001–M049 and Finale)

## Status
Draft

## Type
New Feature

## Goal
Implement the 49 jungle-themed mechanics (M001 to M049) and the Level 500 Phase Finale for Phase 1, defining category rules, collision behaviors, hammerable interactions, state machines, and solver hooks.

## Current State
Design documented in phase_1/03_OBSTACLE_CATALOG_PHASE_1.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- 49 mechanics categorized as: B (Static Blocker), K (Key/Lock), C (Move-based Counter), T (Toggle/Interactive), P (Path-variant), D (Direction changer), L (Layer), G (Goal/Helper), X (Boss).
- Strict Hammerable rules: defaults are true for M001, M002, M016, M025, M027 (single cell), and broken M042; false for gates, tiles, interactive devices, locks, edges, and Guardians.
- Turn-based tick sequence: moveCount increment occurs *after* action resolve and non-lane exit triggers, followed by counter ticks in fixed order.

## Proposed Change
Implement the pure-Dart mechanic interface, registrations, and behavior classes in `packages/puzzle_core`:

### 1. Mechanic Interface & Lifecycle Hooks
Every mechanic implements the `Mechanic` interface with hooks:
- `blocksLane(Cell cell, LaneContext ctx)`: Evaluates if a ray hitting `cell` is blocked.
- `redirect(Cell cell, Dir dir)`: Returns new direction if cell bends the lane (e.g. mirrors, burrows).
- `isLocked(Snake snake)`: Evaluates if snake cannot currently be tapped (e.g. frozen, mist, order).
- `onTap(BoardState state)`: Handles direct taps on interactive cells (levers, lilypads, rotors).
- `onPathExit(Snake snake, List<Cell> lane)`: Immediate exit trigger (keys, counts, gems, food).
- `onMoveTick(BoardState state)`: Ticks move-based countdowns and cyclic states.
- `encode()`: Emits state tuple for solver state deduplication and hash computation.

### 2. Global Hammer Rules
- Hammer targets: Any visible snake OR any `hammerable: true` obstacle instance.
- Hidden snakes under Jungle Mist (M010) cannot be targeted by Hammer.
- Hammered snake counts as an exit for stateful mechanics (unlocks keys, decrements Frost Coil K, lowers Mongoose HP, advances hatch order), but does NOT trigger lane traversal effects (does not collect gems, does not feed hungry caterpillar, does not damage termite mounds, does not cross bridges).
- Hammer is disabled on the last remaining snake if gems (M026) remain uncollected.
- Hammer action is irreversible; it cannot be undone or re-applied.

### 3. Move Tick Sequence (Fixed Order)
At the conclusion of each Move action:
1. Action resolves (exit, bump, or interactive tap).
2. Exit triggers fire immediately.
3. `moveCount += 1` (Parity mechanics M021 read parity prior to increment).
4. Counters tick in exact sequence: M007 -> M017 -> M031 -> M025 -> M027 -> M047 -> M041.
5. Derived states update (pressure gates M019, fog boundaries M010, cages M033, locks).
6. Queued heart-loss events apply (Safety Shell Shield absorbs first).
7. Win check executes; if won, execution completes before checking 0 hearts.
8. If hearts == 0, Second Chance triggers.

### 4. Mechanics Catalog (M001–M049)
1. **M001 Garden Rock (Single Blocker, Cat B, L11):** 1 cell. Blocks exit lane. Hammerable: true.
2. **M002 Fallen Log (Long Wall, Cat B, L21):** 2–4 straight cells (H/V). Blocks exit lane. Hammerable: true (removes entire log).
3. **M003 Frost Coil (Frozen Path, Cat C, L31):** Snake encased in ice; locked until K (1–3) orthogonally adjacent snakes exit. Hammerable: snake is hammerable; neighbors are hammerable (decrements K).
4. **M004 Bamboo Cage & Key (Key & Lock, Cat K, L41):** Key badge on snake; matching color lock cell blocks lane until key-snake exits. Lock is NOT hammerable.
5. **M005 Flower Gate (Color Gate, Cat B, L51):** Gate passable only by matching snake color; others bonk. NOT hammerable.
6. **M006 Bamboo One-Way (One-Way Tile, Cat D, L61):** Passable only in marked arrow direction; entering from opposite or perpendicular direction causes bonk. NOT hammerable.
7. **M007 Lotus Bud Gate (Countdown Gate, Cat C, L71):** Closed gate opens permanently after N player moves. Badge shows remaining moves. NOT hammerable.
8. **M008 Rabbit Burrows (Portal Pair, Cat D, L81):** Lane entering Burrow A emerges from Burrow B in identical direction. Blocked if Burrow B is occupied by a snake. NOT hammerable.
9. **M009 Branch Lever & Twig Gates (Lever + Toggle Gates, Cat T, L91):** Tapping lever (costs 1 Move) toggles all linked twig gates open/closed. Non-monotone. NOT hammerable.
10. **M010 Jungle Mist (Fog Patch, Cat C, L101):** Snaking bodies under mist are hidden and locked. Clears when any snake whose body touches the mist patch exits. NOT hammerable.
11. **M011 Vine-Tied Twins (Chained Pair, Cat P, L111):** 2 snakes linked. Tapping either commands both to slither. If either lane is blocked, both bonk (-1 Heart total). Both snakes hammerable individually.
12. **M012 Sleepy Python (Sleeping Path, Cat P, L121):** First tap wakes snake (1 Move); second tap executes slither out. Snake is hammerable.
13. **M013 Spinning Lilypad (Turntable, Cat T, L131):** Snake head rests on lilypad. Tapping lilypad rotates that snake 90° CW (1 Move). If rotated into its own body, snake becomes tangled (locked tap). Tapping head rotates lilypad; tapping body taps snake. NOT hammerable.
14. **M014 Mushroom Bumper (Mirror, Cat D, L141):** Diagonal bumper (`/` or `\`) reflects exit lane by 90°. NOT hammerable.
15. **M015 Root Bridge (Bridge, Cat L, L151):** Upper bridge cell allows snakes to cross perpendicular lanes passing beneath without collision. NOT hammerable.
16. **M016 Termite Mound (Cracked Rock, Cat C, L161):** HP 1–3. Loses 1 HP whenever an exiting snake lane passes an orthogonally adjacent cell. At HP 0, disappears. Hammerable: true.
17. **M017 Restless Caterpillar (Countdown Path, Cat C, L171):** Must exit within N moves. If countdown reaches 0, player loses 1 heart and counter resets to N. Non-monotone. Snake is hammerable.
18. **M018 Fern Fork Switch (Switch Junction, Cat T, L181):** Cell deflects lane left or right based on switch state. Tapping switch toggles deflection (1 Move). NOT hammerable.
19. **M019 Mossy Pressure Stone (Pressure Plate, Cat T, L191):** Linked gate stays open *while* any snake body covers the stone. When snake departs, gate closes. NOT hammerable.
20. **M020 Home Burrow (Inner Exit, Cat G, L201):** Internal hole cell acting as board exit. Any lane reaching it allows snake to exit into the hole. NOT hammerable.
21. **M021 Phantom Snake (Phasing Path, Cat P, L211):** Solid on even move counts, ghost (transparent, non-blocking, non-tappable) on odd move counts. Evaluates move count prior to increment. Hammerable when solid.
22. **M022 Reverse Slither (Reverse Path, Cat P, L221):** Snake exits tail-first (travels backward from tail). Tail shows direction arrow. Snake is hammerable.
23. **M023 Two-Headed Hydra (Two-Head Path, Cat P, L231):** Heads at both ends. Tapping near an end exits that way (nearest-end rule). Tapping exact center exits via `body[0]`. Snake is hammerable.
24. **M024 Giant Anaconda (Wide Path, Cat P, L241):** 2-cell wide body. Requires a 2-cell wide unobstructed exit lane. Snake is hammerable.
25. **M025 Patrolling Beetle (Patrol Blocker, Cat C, L251):** 1-cell blocker patrolling a fixed waypoint loop, advancing 1 cell per Move. Waits if next cell is occupied. Hammerable: true.
26. **M026 Jungle Gems (Collect Gems, Cat G, L261):** Collectibles on board. All gems must be collected by crossing lanes to satisfy Win condition. Last snake cannot be hammered while gems remain. NOT hammerable.
27. **M027 Creeping Vine (Spreader, Cat C, L271):** Expands 1 cell every N moves into free neighbor (priority: U, R, D, L). Each vine cell is individually hammerable.
28. **M028 Hatch Order Snakes (Numbered Paths, Cat P, L281):** Numbered badges (1, 2, 3...). Must exit in strictly ascending order. Tapping out of order produces locked tap. Snakes are hammerable.
29. **M029 Hedge Border (Edge Wall, Cat B, L291):** Walled board edge segments. Lanes hitting hedge border bonk. NOT hammerable.
30. **M030 Flower Arch Exit (Color Edge, Cat B, L301):** Edge opening passable only by matching snake color. NOT hammerable.
31. **M031 Closing Hedge Gap (Closing Edge, Cat C, L311):** Open edge segment permanently closes after N player moves. NOT hammerable.
32. **M032 Canopy & Ground (Two Layers, Cat L, L321):** Upper canopy snakes drawn above ground snakes. Ground snakes locked while covered by canopy snake body. Lanes interact only within same layer. Obstacles block both layers by default. Snakes are hammerable.
33. **M033 Petal Cage (Color Cage, Cat K, L331):** Caged snake locked until all other snakes of cage color exit. Cage is NOT hammerable; caged snake is hammerable.
34. **M034 Whirl Stump (Rotor 2x2, Cat T, L341):** Tapping stump rotates 2x2 grid contents 90° CW (affects only snakes fully enclosed inside). Partial snake inside = locked tap. Tangled rotation = locked tap. NOT hammerable.
35. **M035 Mama Snake (Spawner Path, Cat P, L351):** On exit, spawns a short child snake at marked nest cells if clear (waits if blocked). Snake is hammerable.
36. **M036 Hungry Caterpillar (Hungry Path, Cat P, L361):** Can only exit if lane passes a food berry cell (food consumed on pass). Tapping with clear lane but no food causes bonk (-1 Heart). Snake is hammerable.
37. **M037 Sticky Swamp Mud (Mud Trap, Cat D, L371):** Lane entering mud stops snake there (relocates head to mud, costs 1 Move). Subsequent tap exits from mud cell. NOT hammerable.
38. **M038 Bouncy Fern Pad (Jump Pad, Cat G, L381):** Lane crossing pad leaps over the next 1 cell (can jump over a 1-cell blocker, cannot jump over a snake). NOT hammerable.
39. **M039 Pond Twins (Mirror Twins, Cat P, L391):** Tapping one snake moves both mirrored across axis. Both lanes must be clear, otherwise both bonk (-1 Heart total). Snakes are hammerable.
40. **M040 Jungle Night (Night Board, Cat G, L401):** Visual mechanic. Only area around last moved snake and long-press preview is illuminated. Core rules unchanged.
41. **M041 Chameleon Snake (Chameleon Path, Cat P, L411):** Snake color cycles (R -> G -> B) on each Move. Interacts with color gates, arches, and cages. Snake is hammerable.
42. **M042 Dry Twig Bridge (Fragile Bridge, Cat L, L421):** Bridge allows exactly 1 lane crossing, then snaps and turns into a Single Blocker (M001). Broken state is hammerable.
43. **M043 Big Knot Cage (Multi-Lock, Cat K, L431):** Cage requiring 2–3 distinct key snakes to exit before opening. Cage is NOT hammerable.
44. **M044 Twisty Burrow (Turning Portal, Cat D, L441):** Portal pair that rotates lane exit direction 90°. NOT hammerable.
45. **M045 Root Gear Lever (Gear Lever, Cat T, L451):** Single lever tap simultaneously rotates multiple linked Spinning Lilypads (M013) by 90° CW. NOT hammerable.
46. **M046 Tail-Biter Loop (Loop Path, Cat K, L461):** Snake connected head-to-tail in closed loop. Locked until linked key-snake exits; then opens at marked head. Hammerable after opening.
47. **M047 Growing Caterpillar (Growing Path, Cat C, L471):** Tail grows 1 cell every N moves into free cell behind tail. No growth if rear cell blocked. Snake is hammerable.
48. **M048 Snake Parade (Color Group Tap, Cat P, L481):** Tapping a parade snake moves all same-color parade snakes simultaneously. If any bonks, all bonk (-1 Heart total). Snakes are hammerable.
49. **M049 Grumpy Mongoose (Guardian, Cat X, L491):** Multi-cell boss blocker. HP equals linked snakes count. Each linked snake exit deals -1 HP. At HP 0, vanishes in a leaf puff. NOT hammerable.
50. **Phase 1 Finale — Mongoose King's Garden (L500):** Mongoose King (HP 6) surrounded by 9 Phase 1 mechanics (Bamboo Cage, Twig Gates, Jungle Mist, Lilypad, Termite Mound, Home Burrow, 3 Gems, Hatch Order, Chameleon).

### 5. Validator Ban Rules
The CI validator enforces strict mechanic combination bans:
- M024 (Wide Path) cannot be placed on diagonal lanes or boards with M013/M034 rotors.
- M010 (Jungle Mist) cannot conceal M049 (Guardian).
- M046 (Tail-Biter Loop) cannot be enclosed within M034 (Whirl Stump).

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/mechanic.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/registry.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m001_garden_rock.dart` through `m049_grumpy_mongoose.dart` (to be created)
- `packages/puzzle_core/test/mechanics/m001_test.dart` through `m049_test.dart` (to be created)
- `tools/validator/lib/combo_validator.dart` (to be created)

## Risks
- Complex state combinations (e.g. Chameleon cycling into Flower Gate while Chained Pair triggers) must maintain deterministic resolution order.
- Ensuring BFS/IDA* solver correctly caches and hashes states for all 49 mechanics within the 50k on-device node limit.

## Open Questions
- None. All 49 mechanic definitions, category designations, and hammerable statuses directly match SHARED_CORE_STANDARD §10.

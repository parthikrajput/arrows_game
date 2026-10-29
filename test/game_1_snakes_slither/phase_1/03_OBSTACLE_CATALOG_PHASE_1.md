# 03 — Obstacle Catalog, Phase 1 (M001–M049 + Finale)
> Phase 1 ના 49 mechanics ના exact rules (standard §10), jungle themed names, JSON schema v3, implementation notes અને level-design usage — એક card per mechanic.

**Related docs:** [Phase 1 index](./README.md) · [Shared Core Standard §10, §12](../../SHARED_CORE_STANDARD.md) · [01 Rules (Move resolution order)](./01_GAME_CONCEPT_AND_RULES.md) · [02 Level Progression](./02_LEVEL_PROGRESSION_0001_0500.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Summary Table (M001–M049)
Categories: **B** Static Blocker · **K** Key/Lock · **C** Counter (Move-based) · **T** Toggle/Interactive · **P** Path-variant (snake variant) · **D** Direction changer · **L** Layer · **G** Goal/Helper · **X** Boss. "Hammer" = Magic Stone Hammer થી remove થઈ શકે (default).

| ID | Intro | Cat | Themed name | Generic | Hammer | Non-monotone (N) |
|---|---|---|---|---|---|---|
| M001 | L11 | B | Garden Rock | Single Blocker | ✅ | — |
| M002 | L21 | B | Fallen Log | Long Wall | ✅ (whole log) | — |
| M003 | L31 | C | Frost Coil | Frozen Path | snake ✅ | — |
| M004 | L41 | K | Bamboo Cage & Key | Key & Lock | ❌ (lock) | — |
| M005 | L51 | B | Flower Gate | Color Gate | ❌ | — |
| M006 | L61 | D | Bamboo One-Way | One-Way Tile | ❌ | — |
| M007 | L71 | C | Lotus Bud Gate | Countdown Gate | ❌ | ✅ |
| M008 | L81 | D | Rabbit Burrows | Portal Pair | ❌ | — |
| M009 | L91 | T | Branch Lever & Twig Gates | Lever + Toggle Gates | ❌ | ✅ |
| M010 | L101 | C | Jungle Mist | Fog Patch | ❌ | — |
| M011 | L111 | P | Vine-Tied Twins | Chained Pair | snake ✅ | — |
| M012 | L121 | P | Sleepy Python | Sleeping Path | snake ✅ | — |
| M013 | L131 | T | Spinning Lilypad | Turntable | ❌ | ✅ |
| M014 | L141 | D | Mushroom Bumper | Mirror | ❌ | — |
| M015 | L151 | L | Root Bridge | Bridge | ❌ | — |
| M016 | L161 | C | Termite Mound | Cracked Rock | ✅ | — |
| M017 | L171 | C | Restless Caterpillar | Countdown Path | snake ✅ | ✅ |
| M018 | L181 | T | Fern Fork Switch | Switch Junction | ❌ | ✅ |
| M019 | L191 | T | Mossy Pressure Stone | Pressure Plate | ❌ | ✅ |
| M020 | L201 | G | Home Burrow | Inner Exit (Hole) | ❌ | — |
| M021 | L211 | P | Phantom Snake | Phasing Path | snake ✅ (solid only) | ✅ |
| M022 | L221 | P | Reverse Slither | Reverse Path | snake ✅ | — |
| M023 | L231 | P | Two-Headed Hydra | Two-Head Path | snake ✅ | — |
| M024 | L241 | P | Giant Anaconda | Wide Path | snake ✅ | — |
| M025 | L251 | C | Patrolling Beetle | Patrol Blocker | ✅ | ✅ |
| M026 | L261 | G | Jungle Gems | Collect Gems | ❌ | — |
| M027 | L271 | C | Creeping Vine | Spreader | ✅ (one vine cell) | ✅ |
| M028 | L281 | P | Hatch Order Snakes | Numbered Paths | snake ✅ | — |
| M029 | L291 | B | Hedge Border | Edge Wall | ❌ (standard) | — |
| M030 | L301 | B | Flower Arch Exit | Color Edge | ❌ | — |
| M031 | L311 | C | Closing Hedge Gap | Closing Edge | ❌ | ✅ |
| M032 | L321 | L | Canopy & Ground | Two Layers | snake ✅ | — |
| M033 | L331 | K | Petal Cage | Color Cage | ❌ (cage) | — |
| M034 | L341 | T | Whirl Stump | Rotor 2×2 | ❌ | ✅ |
| M035 | L351 | P | Mama Snake | Spawner Path | snake ✅ | — |
| M036 | L361 | P | Hungry Caterpillar | Hungry Path | snake ✅ | — |
| M037 | L371 | D | Sticky Swamp Mud | Mud Trap | ❌ | — |
| M038 | L381 | G | Bouncy Fern Pad | Jump Pad | ❌ | — |
| M039 | L391 | P | Pond Twins | Mirror Twins | snake ✅ | — |
| M040 | L401 | G | Jungle Night | Night Board | — (visual) | — |
| M041 | L411 | P | Chameleon Snake | Chameleon Path | snake ✅ | ✅ |
| M042 | L421 | L | Dry Twig Bridge | Fragile Bridge | ✅ (after break) | — |
| M043 | L431 | K | Big Knot Cage | Multi-Lock | ❌ (lock) | — |
| M044 | L441 | D | Twisty Burrow | Turning Portal | ❌ | — |
| M045 | L451 | T | Root Gear Lever | Gear Lever | ❌ | ✅ |
| M046 | L461 | K | Tail-Biter Loop | Loop Path | snake ✅ (after open) | — |
| M047 | L471 | C | Growing Caterpillar | Growing Path | snake ✅ | ✅ |
| M048 | L481 | P | Snake Parade | Color Group Tap | snake ✅ | — |
| M049 | L491 | X | Grumpy Mongoose | Guardian | ❌ (standard) | — |
| — | L500 | X | Mongoose King's Garden | Phase 1 Finale | — | — |

## 2. Conventions (બધા cards માટે)
### 2.1 JSON (schema v3)
- દરેક mechanic level JSON ના `mechanics[]` માં: `{"id", "type": "M0xx", "cells": [[x,y],…], "params": {…}, "hammerable": bool}`.
- **Snake variants (P) અને snake-linked mechanics** પણ `mechanics[]` માં જ, `params.path` / `params.paths` થી snake id refer કરે. `paths[].mods` માત્ર cosmetic (`{"skin": "caterpillar"}`) માટે.
- `hammerable` field દરેક instance પર લખવો; standard ના fixed defaults (§16.18): **true** = M001, M002, M016, M025, M027 (એક cell), broken M042; **false** = બાકીના gates, tiles, interactive cells, locks, edges, Guardian (M049) — validator override થવા ન દે. Snakes (P variants સહિત) હંમેશા Hammer target (visible હોય તો); mechanic object પોતે `hammerable: false`.
- Directions `U, D, L, R`. Coordinates `[x, y]`, origin top-left.

### 2.2 Engine Hooks (puzzle_core)
દરેક mechanic `Mechanic` class implement કરે; card ના "Implementation" માં વપરાયેલા hooks:

| Hook | ક્યારે | Use |
|---|---|---|
| `blocksLane(cell, ctx)` | Lane trace દરમિયાન | Blocker / gate / edge |
| `redirect(cell, dir)` | Lane trace | Mirror, burrow, fork, jump |
| `isLocked(path)` | Tap validate | Frost, mist, order, cage, ghost |
| `onTap(state)` | Obstacle tap | Lever, lilypad, fork, stump, gear |
| `onPathExit(path, lane)` | Step 3 (exit triggers) | Keys, HP, gems, food, spawn |
| `onMoveTick(state)` | Step 5 (fixed order) | Counters, patrol, growth, parity |
| `encode()` | Solver hashing | Mechanic state ⇒ solver state key |

State immutable (`copyWith`), દરેક Move એક નવો `BoardState` આપે ⇒ Undo = snapshot stack, solver = BFS/IDA*.

### 2.3 Hammer Rules (all mechanics)
- Hammer target = 1 snake (visible; Jungle Mist નીચેનો hidden snake નહીં) **અથવા** 1 `hammerable: true` obstacle instance.
- Hammered snake = **exit ગણાય**: step 3 ના બધા exit triggers ચાલે (key, frost count, mongoose HP, spawn…), પણ lane-based triggers (Termite Mound HP, gems, food, bridge crossing) **નહીં** (lane નથી). Hammer Move નથી ⇒ tick નહીં.
- Jungle Gems બાકી હોય ત્યારે **છેલ્લા snake** પર Hammer disabled (toast "Gems still need collecting!") — નહીં તો level unwinnable થાય (standard §16.31).
- Hammer use ⇒ **Undo history clear** (standard §16.23); Hammer ક્યારેય undo / re-apply થતો નથી.

## 3. Mechanic Cards
Card format: Rule → Tap/bump → Heart → Hammer → Hint/solver → Visual & audio → JSON → Implementation → Design do/don't → Combos.

---

### M001 — Garden Rock (Single Blocker)
| Field | Value |
|---|---|
| Intro / Category | L11 · B |
| Rule | 1 cell rock. કોઈ પણ snake નો lane આ cell પર blocked |
| Tap / bump | Rock tap ⇒ ignore (Move નથી). Lane rock સુધી ⇒ head bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ✅ (standard) |
| Hint / solver | Static; reverse construction થી solvable. State વગર |
| Visual & audio | Grey mossy rock, 3 variants; bump પર rock 1-frame wobble + `sfx_bonk_rock` |

```json
{"id": "o1", "type": "M001", "cells": [[3,2]], "params": {"variant": 1}, "hammerable": true}
```
- **Implementation:** Model `SingleBlocker(cell)`; state none; `blocksLane` = true. Render: static layer (cached `Picture`), hammer ⇒ static layer rebuild.
- **Do:** Rock વડે "આ snake પહેલાં" chain બનાવો; x1 માં 1–2 rocks.
- **Don't:** Rock થી કોઈ snake હંમેશ માટે blocked ન કરો (validator પકડે); rock ને corner માં નકામો ન મૂકો.
- **Combos:** M038 Bouncy Fern Pad (rock ઉપરથી કૂદકો), M014 Mushroom Bumper.

---

### M002 — Fallen Log (Long Wall)
| Field | Value |
|---|---|
| Intro / Category | L21 · B |
| Rule | 2–4 cells સીધી line (H અથવા V). કોઈ પણ cell પર lane blocked |
| Tap / bump | Log tap ignore. Lane log સુધી ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ✅ આખો log એક instance તરીકે (standard) |
| Hint / solver | Static |
| Visual & audio | Brown log with rings & mushrooms; `sfx_bonk_wood` |

```json
{"id": "o2", "type": "M002", "cells": [[2,4],[3,4],[4,4]], "params": {"orient": "H"}, "hammerable": true}
```
- **Implementation:** `LongWall(cells, orient)`; validator: cells contiguous straight, length 2–4. Render as one sprite stretched (end caps + middle tiles).
- **Do:** Board ને બે zones માં વહેંચવા; 1 log + rocks.
- **Don't:** 4-length log edge પર સમાંતર મૂકી આખી edge બંધ ન કરો (Hedge Border નું કામ છે).
- **Combos:** M001, M008 Rabbit Burrows (log પાછળ જવા), M016.

---

### M003 — Frost Coil (Frozen Path)
| Field | Value |
|---|---|
| Intro / Category | L31 · C |
| Rule | Snake બરફમાં જકડાયેલો; **K (1–3) adjacent snakes exit** થાય ત્યાં સુધી locked. Adjacent = level start પર જેનું body frozen snake ના કોઈ cell ને orthogonally અડે. Badge = બાકી K |
| Tap / bump | Locked tap ❄️ (wobble, no heart, no Move). K = 0 ⇒ બરફ તૂટે, normal snake |
| Heart effect | Locked tap ⇒ 0. Frozen snake બીજાના lane ને block કરે (bump −1) |
| Hammerable | Frozen snake ખુદ ✅ (any visible snake); hammered neighbour exit ગણાય ⇒ K −1 |
| Hint / solver | State: `remainingK`. Solver neighbours પહેલાં exit કરાવે |
| Visual & audio | Light-blue ice shell, crack stages per K; thaw ⇒ `sfx_ice_crack` + snake shiver |

```json
{"id": "o3", "type": "M003", "cells": [], "params": {"path": "p4", "k": 2}, "hammerable": false}
```
- **Implementation:** `FrozenPath(pathId, k)`; load પર `neighbours` set compute (static); `onPathExit` ⇒ જો exited ∈ neighbours ⇒ k−1. `isLocked` = k > 0. Render: ice overlay on snake (dynamic layer only when k changes).
- **Do:** K ≤ neighbours count − 0 (validator: neighbours ≥ K). Frozen snake ને blocker તરીકે વાપરો.
- **Don't:** K = 3 x1 intro માં નહીં (1–2 રાખો).
- **Combos:** M004 (key snake frozen), M028 Hatch Order.

---

### M004 — Bamboo Cage & Key (Key & Lock)
| Field | Value |
|---|---|
| Intro / Category | L41 · K |
| Rule | એક snake પર key icon (colour). Same-colour **Bamboo Cage** cell lanes block કરે; key-snake exit થાય ⇒ cage **કાયમ** ખુલે |
| Tap / bump | Cage tap ignore. Closed cage સુધી lane ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | Cage ❌ (standard). Key-snake ને hammer ⇒ exit ગણાય ⇒ cage ખુલે |
| Hint / solver | State: `open` bool. Monotone |
| Visual & audio | Bamboo cage with coloured knot; key = golden leaf-key on snake's back; open ⇒ cage slats lift `sfx_cage_open` |

```json
{"id": "o4", "type": "M004", "cells": [[5,1]], "params": {"keyPath": "p2", "color": "blue"}, "hammerable": false}
```
- **Implementation:** `KeyLock(cell, keyPathId, color)`; `onPathExit(p)` p == keyPath ⇒ open. Key icon render snake ના mid segment પર.
- **Do:** Key snake ને સરળ પણ "ભૂલાઈ જાય" એવી જગ્યાએ.
- **Don't:** Key snake નો lane પોતાના જ cage થી block ન કરો (deadlock — validator).
- **Combos:** M003, M010 (key snake mist નીચે), M043 (multi-key upgrade).

---

### M005 — Flower Gate (Color Gate)
| Field | Value |
|---|---|
| Intro / Category | L51 · B |
| Rule | Cell માત્ર **same-colour** snake માટે passable; બીજા colour ⇒ blocked |
| Tap / bump | Gate tap ignore. Different colour lane ⇒ bonk at gate |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ (default) |
| Hint / solver | Static per colour; M041 Chameleon સાથે state-dependent |
| Visual & audio | Flower arch in snake colour + pattern icon; same colour pass ⇒ petals flutter `sfx_petal` |

```json
{"id": "o5", "type": "M005", "cells": [[4,3]], "params": {"color": "red"}, "hammerable": false}
```
- **Implementation:** `ColorGate(cell, color)`; `blocksLane` = path.color != color. Snake body gate cell પર ન હોય (validator).
- **Do:** 2 colours વચ્ચે sorting puzzle.
- **Don't:** એક જ board પર 3+ gate colours T1 માં નહીં (readability).
- **Combos:** M041, M030, M033.

---

### M006 — Bamboo One-Way (One-Way Tile)
| Field | Value |
|---|---|
| Intro / Category | L61 · D |
| Rule | Cell માત્ર arrow દિશામાં passable; બીજી કોઈ દિશા (opposite કે perpendicular) ⇒ blocked |
| Tap / bump | Tile tap ignore. ખોટી દિશા ⇒ bonk at tile |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Static |
| Visual & audio | Bamboo slat floor with carved arrow; pass ⇒ `sfx_bamboo_click` |

```json
{"id": "o6", "type": "M006", "cells": [[2,5]], "params": {"arrow": "R"}, "hammerable": false}
```
- **Implementation:** `OneWay(cell, arrow)`; `blocksLane(cell, ctx)` = ctx.dir != arrow. Snake body tile પર ન હોય.
- **Do:** "આ corridor માત્ર એક બાજુથી" puzzles; mirror પછી direction બદલાય તે બતાવો.
- **Don't:** Arrow edge તરફ મોં રાખી ખાલી corridor માં નકામું ન મૂકો.
- **Combos:** M014, M008.

---

### M007 — Lotus Bud Gate (Countdown Gate)
| Field | Value |
|---|---|
| Intro / Category | L71 · C |
| Rule | Closed gate; **N Moves** પછી કાયમ ખુલે (badge N). દરેક Move (exit, bump, interactive tap, wake, mud) badge −1 |
| Tap / bump | Gate tap ignore. Closed gate સુધી lane ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | State: `remaining`. Solver પાસે N પહેલાં બીજા useful Moves હોવા જ જોઈએ (no forced bump — validator) |
| Visual & audio | Closed lotus bud with number; 0 ⇒ blooms `sfx_lotus_bloom` |

```json
{"id": "o7", "type": "M007", "cells": [[6,2]], "params": {"n": 4}, "hammerable": false}
```
- **Implementation:** `CountdownGate(cell, n)`; `onMoveTick` (order #1) remaining−1, 0 ⇒ open. Undo snapshot remaining restore કરે.
- **Do:** N = બીજા snakes ની સંખ્યા કરતાં ઓછું/બરાબર — player ને "પહેલાં બીજા" નો વિચાર.
- **Don't:** N > solution length − 1 (gate ક્યારેય useful ન થાય).
- **Combos:** M001, M017.

---

### M008 — Rabbit Burrows (Portal Pair)
| Field | Value |
|---|---|
| Intro / Category | L81 · D |
| Rule | Lane burrow A માં પ્રવેશે ⇒ burrow B માંથી **એ જ દિશામાં** આગળ ચાલે (two-way: B ⇒ A પણ). B પર કોઈ snake body હોય ⇒ blocked |
| Tap / bump | Burrow tap ignore. B occupied અથવા B પછી blocked ⇒ bonk (head A સુધી જઈ પાછો) |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Static redirect; lane trace ⇒ cycle detection (same cell+dir ફરી ⇒ validator reject) |
| Visual & audio | Two burrow holes, same colour rim + pair symbol (🥕/🌼…); bunny ears peek; `sfx_burrow_pop` |

```json
{"id": "o8", "type": "M008", "cells": [[1,1],[6,5]], "params": {"pair": "carrot"}, "hammerable": false}
```
- **Implementation:** `PortalPair(a, b)`; `redirect(cell==a)` ⇒ continue from b + dir. Render: snake segments burrow A માં clip થાય, B માંથી emerge (two clip paths).
- **Do:** Log પાછળથી snake બહાર કાઢવા; 1 pair per board T1 માં.
- **Don't:** Same pair symbol/colour બે pairs માટે.
- **Combos:** M002, M014, M044 (upgrade).

---

### M009 — Branch Lever & Twig Gates (Lever + Toggle Gates)
| Field | Value |
|---|---|
| Intro / Category | L91 · T |
| Rule | Lever tap (1 Move) ⇒ બધા linked twig gates flip (open ↔ closed). Closed gate lane block કરે. Non-monotone |
| Tap / bump | Lever tap = Move (bump નહીં). Closed gate સુધી lane ⇒ bonk |
| Heart effect | Lever 0; bump −1 |
| Hammerable | ❌ (lever અને gates) |
| Hint / solver | State: gates bitmask. Hint lever ને glow કરી શકે (`solution` માં obstacle id `"o9"`) |
| Visual & audio | Branch lever (left/right tilt), twig gates; `sfx_lever_creak` + gates swing |

```json
{"id": "o9", "type": "M009", "cells": [[0,6]], "params": {"gates": [[3,3],[5,3]], "initial": ["open","closed"]}, "hammerable": false}
```
- **Implementation:** `LeverGates(lever, gates, states)`; `onTap` flip all. Gate cells પર snake body નહીં (validator). Lever cell interactive ⇒ tap priority over empty.
- **Do:** 2 gates opposite states ⇒ "પહેલાં આ snake, પછી flip".
- **Don't:** 3+ levers T1 માં; lever ને board બહાર edge-tap જગ્યાએ (tap target ≥ 1 cell).
- **Combos:** M019, M045 (gear), M049.

---

### M010 — Jungle Mist (Fog Patch)
| Field | Value |
|---|---|
| Intro / Category | L101 · C |
| Rule | Mist area નીચેના snakes **hidden & locked**. કોઈ snake જેનું body area ને **touch** કરે (area ની અંદર અથવા orthogonally adjacent cell) તે exit થાય ⇒ આખો area clear |
| Tap / bump | Mist પર tap ⇒ locked ☁️. Hidden snakes બીજાના lanes block કરે (physical) |
| Heart effect | Locked tap 0; lane hidden snake સાથે અથડાય ⇒ −1 |
| Hammerable | Mist ❌; hidden snake target ન બને |
| Hint / solver | State: area cleared bool. Hint/Preview hidden info ન બતાવે (preview mist edge પર "?") |
| Visual & audio | Soft green-white animated mist (pre-baked noise texture scroll), clear ⇒ swirl away `sfx_mist_whoosh` |

```json
{"id": "o10", "type": "M010", "cells": [[5,5],[6,5],[5,6],[6,6]], "params": {}, "hammerable": false}
```
- **Implementation:** `FogPatch(cells)`; load પર touching paths set (static). `isLocked(p)` = p body ∩ area && !cleared. Render: mist overlay layer above snakes; hidden snakes paint નહીં.
- **Do:** Solution માં mist clear થાય તે પહેલાં કોઈ lane mist માંથી પસાર ન થાય (fairness — validator rule "no blind lanes").
- **Don't:** Mist area > 6 cells T2 માં; touching snake mist ની અંદરનો જ હોય તેવી setup (locked forever).
- **Combos:** M004, M003; Daily Thursday "Fog Day".

---

### M011 — Vine-Tied Twins (Chained Pair)
| Field | Value |
|---|---|
| Intro / Category | L111 · P |
| Rule | 2 snakes vine થી જોડાયેલા. કોઈ પણ tap ⇒ **બંને** exit try કરે; બંનેના lanes clear હોવા જોઈએ (એકબીજાનું body પણ blocker ગણાય), નહીં તો બંને bonk |
| Tap / bump | 1 Move. Blocked ⇒ બંને bonk animation |
| Heart effect | **−1 total** (એક heart-loss event) |
| Hammerable | Snake ✅: hammered twin exit ગણાય, vine તૂટે, partner normal snake |
| Hint / solver | Pair = એક atomic action |
| Visual & audio | Leafy vine between tails; exit ⇒ both wiggle in sync `sfx_twin_slither` |

```json
{"id": "o11", "type": "M011", "cells": [], "params": {"paths": ["p3", "p5"]}, "hammerable": false}
```
- **Implementation:** `ChainedPair(a, b)`; tap router: target ∈ pair ⇒ `tryExitGroup([a,b])`. Lanes evaluate current state પર (simultaneous).
- **Do:** એક twin સરળ, બીજો blocked ⇒ "પહેલાં બીજાને clear કરો".
- **Don't:** Twins ના lanes એકબીજાને cross કરે (હંમેશા blocked).
- **Combos:** M001, M028, M048.

---

### M012 — Sleepy Python (Sleeping Path)
| Field | Value |
|---|---|
| Intro / Category | L121 · P |
| Rule | પહેલો tap ⇒ જાગે (1 Move, lane check નહીં). બીજો tap ⇒ normal exit/bump |
| Tap / bump | Wake tap કદી bump નથી |
| Heart effect | Wake 0; બીજા tap પર blocked ⇒ −1 |
| Hammerable | ✅ (sleeping પણ) |
| Hint / solver | State: awake bool. Wake = 1 extra Move (S +1 in D) |
| Visual & audio | Closed eyes + "Zzz" bubbles; wake ⇒ yawn + stretch `sfx_yawn` |

```json
{"id": "o12", "type": "M012", "cells": [], "params": {"path": "p6"}, "hammerable": false}
```
- **Implementation:** `SleepingPath(pathId)`; tap router ⇒ !awake ⇒ awake = true (Move). Render: eyes closed sprite + Zzz particle (static loop, 2 fps).
- **Do:** M007/M017 સાથે "wake Move" ને tick તરીકે વાપરો.
- **Don't:** 4+ sleepy pythons એક board પર (tedious).
- **Combos:** M007, M017, M021.

---

### M013 — Spinning Lilypad (Turntable)
| Field | Value |
|---|---|
| Intro / Category | L131 · T |
| Rule | Snake નું head lilypad પર. Lilypad tap ⇒ તે snake નો `dir` **90° CW** ફરે (1 Move). Body ખસતું નથી |
| Tap / bump | Head cell (lilypad cell) tap = rotate (interactive cell > snake cell, standard §16.5/§16.19); snake ના બાકીના body cells tap = normal exit/bump. નવો dir પોતાના body (neck `body[1]`) તરફ હોય ⇒ snake **"tangled"** ⇒ snake tap = **locked tap** 🌀 (no Move, no heart) જ્યાં સુધી lilypad ફરી rotate ન થાય (standard §17.39) |
| Heart effect | Rotate 0; bump −1 |
| Hammerable | ❌ (lilypad). Snake ✅ |
| Hint / solver | State: dir (4). Lilypad id solution માં |
| Visual & audio | Green lilypad with water ripple ring; rotate ⇒ `sfx_lily_spin` + head turns |

```json
{"id": "o13", "type": "M013", "cells": [[4,4]], "params": {"path": "p7"}, "hammerable": false}
```
- **Implementation:** `Turntable(cell, pathId)`; `onTap` ⇒ path.dir = cw(dir). Hit-test: આખો lilypad cell ⇒ lilypad; validator: linked snake length ≥ 2. `isLocked(path)` = `dir` points into own body (tangled). Snake exit પછી lilypad tap ⇒ locked tap.
- **Do:** 1–2 rotations જરૂરી; self-facing orientation solution માં ન આવે.
- **Don't:** Lilypad snake ના body ના વચ્ચે (head સિવાય) — invalid.
- **Combos:** M045 (gear), M014, M009.

---

### M014 — Mushroom Bumper (Mirror)
| Field | Value |
|---|---|
| Intro / Category | L141 · D |
| Rule | `/` અથવા `\` mushroom cell; lane **90° વળે**. `/`: R→U, L→D, U→R, D→L. `\`: R→D, L→U, U→L, D→R. Mushroom block નથી |
| Tap / bump | Mushroom tap ignore. વળ્યા પછી blocked ⇒ bonk at blocker |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Static redirect; validator lane loop check |
| Visual & audio | Red-cap mushroom tilted; snake bounce off ⇒ `sfx_boing` + cap squash |

```json
{"id": "o14", "type": "M014", "cells": [[6,2]], "params": {"orient": "/"}, "hammerable": false}
```
- **Implementation:** `Mirror(cell, orient)`; `redirect`. Exit animation: snake track polyline mushroom cell center પર વળે (PathMetrics smooth corner radius 0.3 cell).
- **Do:** "Board ના ખૂણેથી બહાર" routes.
- **Don't:** Mushroom પર snake body (validator); lane પોતાના body માં પાછો વળે તેવી geometry.
- **Combos:** M008, M006, M020.

---

### M015 — Root Bridge (Bridge)
| Field | Value |
|---|---|
| Intro / Category | L151 · L |
| Rule | Bridge cell (axis H/V). Bridge પર પડેલું snake body **perpendicular lanes** ને block નથી કરતું (lane નીચેથી પસાર). Axis સાથે parallel lane normal રીતે block |
| Tap / bump | Bridge tap ignore |
| Heart effect | Bump ⇒ −1 (parallel block) |
| Hammerable | ❌ |
| Hint / solver | Static |
| Visual & audio | Living tree-root bridge; snake under ⇒ dimmed tunnel shadow `sfx_root_creak` |

```json
{"id": "o15", "type": "M015", "cells": [[3,4]], "params": {"axis": "H"}, "hammerable": false}
```
- **Implementation:** `Bridge(cell, axis)`; `blocksLane(cell, ctx)` = body present && ctx.dir parallel to axis. Validator: bridge પરનું body axis સાથે aligned. Render: under-passing snake segment bridge sprite નીચે (z-order).
- **Do:** "Crossing" puzzles; intro માં 1 bridge.
- **Don't:** Bridge પર snake turn (corner) ન મૂકો.
- **Combos:** M042 (upgrade), M032.

---

### M016 — Termite Mound (Cracked Rock)
| Field | Value |
|---|---|
| Intro / Category | L161 · C |
| Rule | HP 1–3 blocker. **Exit** થતા snake નો lane mound ના orthogonally adjacent cell પરથી પસાર થાય ⇒ HP −1 (એક exit દીઠ max −1 per mound). HP 0 ⇒ ભાંગી remove |
| Tap / bump | Mound tap ignore. Lane mound પર ⇒ bonk (bump HP ઘટાડતો નથી) |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ✅ (standard) |
| Hint / solver | State: hp |
| Visual & audio | Clay mound with termite eyes; crack per HP; break ⇒ `sfx_mound_crumble` + dust puff |

```json
{"id": "o16", "type": "M016", "cells": [[4,2]], "params": {"hp": 2}, "hammerable": true}
```
- **Implementation:** `CrackedRock(cell, hp)`; `onPathExit(p, lane)` ⇒ lane cells માંથી કોઈ adjacent ⇒ hp−1. Hammered snake (lane નથી) HP ન ઘટાડે.
- **Do:** HP = નજીકના free snakes ની સંખ્યા.
- **Don't:** HP 3 + માત્ર 2 adjacent routes (unsolvable — validator).
- **Combos:** M001, M049.

---

### M017 — Restless Caterpillar (Countdown Path)
| Field | Value |
|---|---|
| Intro / Category | L171 · C |
| Rule | Badge N: **N Moves ની અંદર exit** થવું જ જોઈએ. દરેક Move પછી −1; 0 થાય અને હજી board પર ⇒ heart-loss event, counter **N પર reset** |
| Tap / bump | Normal snake tap |
| Heart effect | Timeout ⇒ −1 (Shield absorb કરે). Validator: solution માં timeout નહીં |
| Hammerable | ✅ |
| Hint / solver | State: remaining. Solver priority |
| Visual & audio | Caterpillar tapping feet, number bubble; ≤ 2 ⇒ bubble pulses orange; timeout ⇒ `sfx_grumble` + heart pop |

```json
{"id": "o17", "type": "M017", "cells": [], "params": {"path": "p8", "n": 5}, "hammerable": false}
```
- **Implementation:** `CountdownPath(pathId, n)`; `onMoveTick` (order #2, standard §16.17). Exit step 3 માં થાય ⇒ exit Move પર tick નહીં.
- **Do:** N = (optimal exit index + 2) — થોડી slack.
- **Don't:** બે restless caterpillars જેમાં બંને ને પહેલું exit જોઈએ (impossible).
- **Combos:** M007, M012.

---

### M018 — Fern Fork Switch (Switch Junction)
| Field | Value |
|---|---|
| Intro / Category | L181 · T |
| Rule | Cell પર આવતો lane state મુજબ **L અથવા R** (travel direction ની relative) વળે. Switch tap ⇒ toggle (1 Move) |
| Tap / bump | Switch tap = Move. વળ્યા પછી blocked ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | State: L/R bit |
| Visual & audio | Fern leaf pointing direction; toggle ⇒ leaf flips `sfx_fern_swish` |

```json
{"id": "o18", "type": "M018", "cells": [[5,5]], "params": {"state": "L"}, "hammerable": false}
```
- **Implementation:** `SwitchJunction(cell, state)`; `redirect` = rotate dir ±90 relative. Snake body cell પર નહીં.
- **Do:** એક switch, બે snakes ને અલગ state જોઈએ.
- **Don't:** Switch ને lane ના પહેલા cell (head સામે જ) પર — confusing.
- **Combos:** M014, M009.

---

### M019 — Mossy Pressure Stone (Pressure Plate)
| Field | Value |
|---|---|
| Intro / Category | L191 · T |
| Rule | Linked gate **ત્યાં સુધી open** જ્યાં સુધી કોઈ snake body plate cell ને cover કરે. Plate-snake exit ⇒ gate closes. Lane plate પરથી પસાર થાય તે cover ગણાતું નથી |
| Tap / bump | Plate tap ignore. Closed gate ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | State: covered (derived) |
| Visual & audio | Mossy stone sinks when covered; gate = vine curtain; `sfx_stone_press` |

```json
{"id": "o19", "type": "M019", "cells": [[2,2]], "params": {"gates": [[6,4]]}, "hammerable": false}
```
- **Implementation:** `PressurePlate(plate, gates)`; gate open = any body ∋ plate (each state eval). Mud (M037) અથવા growth (M047) થી plate પર આવી શકે.
- **Do:** "Plate snake ને **છેલ્લે** કાઢો" puzzles.
- **Don't:** Plate snake નો lane પોતાના gate માંથી (exit ⇒ gate closed છતાં snake already ગયો — confusing visuals).
- **Combos:** M037, M009.

---

### M020 — Home Burrow (Inner Exit)
| Field | Value |
|---|---|
| Intro / Category | L201 · G |
| Rule | Board ની અંદરનો cell જે exit તરીકે કામ કરે: lane ત્યાં પહોંચે ⇒ snake અંદર dive કરી exit |
| Tap / bump | Burrow tap ignore |
| Heart effect | — |
| Hammerable | ❌ |
| Hint / solver | Lane terminal |
| Visual & audio | Cozy burrow with welcome mat; dive ⇒ `sfx_burrow_dive` + "home!" sparkle |

```json
{"id": "o20", "type": "M020", "cells": [[5,5]], "params": {}, "hammerable": false}
```
- **Implementation:** `InnerExit(cell)`; lane trace ⇒ terminal success. Render: snake track burrow center પર ends, clip circle.
- **Do:** Edge બંધ (M029) સાથે.
- **Don't:** Snake body burrow cell પર.
- **Combos:** M029, M014, M049.

---

### M021 — Phantom Snake (Phasing Path)
| Field | Value |
|---|---|
| Intro / Category | L211 · P |
| Rule | `moveCount` **even** ⇒ solid (normal, blocks, tappable). **Odd** ⇒ ghost (lanes નીચેથી પસાર, tap ⇒ locked 👻). Start 0 = solid |
| Tap / bump | Ghost tap locked (no Move) |
| Heart effect | Solid tap blocked ⇒ −1 |
| Hammerable | ✅ માત્ર solid હોય ત્યારે |
| Hint / solver | State: parity (global) |
| Visual & audio | Translucent shimmer at odd (alpha 0.35 + wavy outline); phase change ⇒ soft `sfx_phase` |

```json
{"id": "o21", "type": "M021", "cells": [], "params": {"path": "p9"}, "hammerable": false}
```
- **Implementation:** `PhasingPath(pathId)`; `blocksLane` & `isLocked` use `state.moveCount.isOdd`. Undo moveCount restore.
- **Do:** "Ghost હોય ત્યારે બીજો snake પસાર કરો".
- **Don't:** 3+ phantoms એક board પર T3 માં.
- **Combos:** M007, M012 (wake Move parity બદલે).

---

### M022 — Reverse Slither (Reverse Path)
| Field | Value |
|---|---|
| Intro / Category | L221 · P |
| Rule | Snake **tail-first** (પાછળની દિશામાં) exit થાય: lane tail cell થી `tail − body[n−2]` દિશામાં |
| Tap / bump | Normal tap; lane reverse direction માં |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ✅ |
| Hint / solver | Static (dir derived) |
| Visual & audio | Tail પર glowing arrow cue; head looks back over shoulder; `sfx_reverse_slither` (reversed whoosh) |

```json
{"id": "o22", "type": "M022", "cells": [], "params": {"path": "p10"}, "hammerable": false}
```
- **Implementation:** `ReversePath(pathId)`; `exitLane(p)` override. Animation track tail→… reversed.
- **Do:** Reverse snake ને "ખોટી દિશામાં મોં" decoy તરીકે.
- **Don't:** Length 2 reverse snakes (cue દેખાય નહીં).
- **Combos:** M023, M014.

---

### M023 — Two-Headed Hydra (Two-Head Path)
| Field | Value |
|---|---|
| Intro / Category | L231 · P |
| Rule | બંને છેડે માથું. Tap cell index i: `i < n−1−i` ⇒ body[0] ના head તરફ exit; ઊલટું ⇒ body[n−1] તરફ; tie ⇒ body[0] (nearest-end rule) |
| Tap / bump | પસંદ થયેલા end નો lane blocked ⇒ bonk (બીજો end try નહીં) |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ✅ |
| Hint / solver | 2 actions (`p11:A`, `p11:B`); Hint glow ચોક્કસ half |
| Visual & audio | Two cute heads, different hats; tap ⇒ chosen head smiles `sfx_hydra_giggle` |

```json
{"id": "o23", "type": "M023", "cells": [], "params": {"path": "p11"}, "hammerable": false}
```
- **Implementation:** `TwoHeadPath(pathId)`; tap router needs tapped cell index. Solution token `"p11:B"`.
- **Do:** Length ≥ 4 (halves સ્પષ્ટ).
- **Don't:** Odd length 3 (middle tie confusing).
- **Combos:** M022, M011.

---

### M024 — Giant Anaconda (Wide Path)
| Field | Value |
|---|---|
| Intro / Category | L241 · P |
| Rule | 2-cell-wide body (spine + side column). Exit માટે **2-wide clear lane** જોઈએ. Phase 1: body સીધું (straight) |
| Tap / bump | બંને columns માંથી કોઈ blocked ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ✅ |
| Hint / solver | Static |
| Visual & audio | Chubby anaconda, wide head; exit ⇒ heavy `sfx_anaconda_slide` |

```json
{"id": "o24", "type": "M024", "cells": [], "params": {"path": "p12", "side": "R"}, "hammerable": false}
```
- **Implementation:** `WidePath(pathId, side)`; occupied cells = spine ∪ offset(side). Lane = spine lane ∪ side lane. `side` = facing direction ની relative right/left.
- **Do:** Corridors 2-wide બનાવો.
- **Don't:** Wide + mirror (Phase 1 માં wide lane redirect નહીં — validator).
- **Combos:** M002, M001.

---

### M025 — Patrolling Beetle (Patrol Blocker)
| Field | Value |
|---|---|
| Intro / Category | L251 · C |
| Rule | Fixed loop પર દર Move 1 cell આગળ; જ્યાં ઊભો ત્યાં lane block. આગલા cell પર snake body ⇒ beetle રાહ જુએ (ખસે નહીં) |
| Tap / bump | Beetle tap ignore |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ✅ (default) |
| Hint / solver | State: loop index. Periodic ⇒ non-monotone |
| Visual & audio | Shiny ladybug-beetle with path dots; step ⇒ `sfx_beetle_tick` |

```json
{"id": "o25", "type": "M025", "cells": [[1,1],[2,1],[2,2],[1,2]], "params": {"start": 0}, "hammerable": true}
```
- **Implementation:** `PatrolBlocker(loop, idx)`; `onMoveTick` (order #4). Loop cells પર બીજા obstacles નહીં. Render: beetle sprite tween 150 ms tick પછી.
- **Do:** Loop length 4–8; next position preview dot.
- **Don't:** Beetle ને lane ની એકમાત્ર જગ્યા પર "હંમેશા" (period trap).
- **Combos:** M007, M021.

---

### M026 — Jungle Gems (Collect Gems)
| Field | Value |
|---|---|
| Intro / Category | L261 · G |
| Rule | Win માટે બધા gems collect જરૂરી. **Exit** થતા snake નો lane gem cell પરથી પસાર ⇒ collect. Gems block નથી |
| Tap / bump | Gem tap ignore. Bump gem collect નથી કરતો |
| Heart effect | — |
| Hammerable | ❌ (gems). Hammered snake gems collect ન કરે; gems બાકી હોય ત્યારે છેલ્લો snake hammer નહીં |
| Hint / solver | State: gem bitmask; goal condition |
| Visual & audio | Sparkly emerald/ruby gems; collect ⇒ fly to HUD counter `sfx_gem_ding` |

```json
{"id": "o26", "type": "M026", "cells": [[2,6],[7,1]], "params": {}, "hammerable": false}
```
- **Implementation:** `CollectGems(cells)`; `onPathExit(p, lane)`. Level `goals.gems` = cells count. HUD gem counter.
- **Do:** Gems lane routes (mirror/burrow) માં.
- **Don't:** Gem cell પર snake body; gem જ્યાં કોઈ lane પહોંચી શકે નહીં.
- **Combos:** M014, M008, M049.

---

### M027 — Creeping Vine (Spreader)
| Field | Value |
|---|---|
| Intro / Category | L271 · C |
| Rule | દર **N Moves** vine 1 cell વધે: vine cells creation order માં, દરેક માટે U, R, D, L ક્રમે પહેલું **free** neighbour (board ની અંદર, snake/obstacle/gem વગર) ⇒ નવું vine. Free ન મળે ⇒ growth નહીં |
| Tap / bump | Vine tap ignore. Vine cell પર lane ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ✅ **એક vine cell** per Hammer (standard §16.18); બાકીના cells રહે અને growth ચાલુ |
| Hint / solver | State: vine cell list + counter |
| Visual & audio | Curly vine with leaves; grow ⇒ unfurl animation `sfx_vine_creak` |

```json
{"id": "o27", "type": "M027", "cells": [[8,8]], "params": {"n": 3}, "hammerable": true}
```
- **Implementation:** `Spreader(cells, n, counter)`; `onMoveTick` (order #5). Free check exited-snake cells ને free ગણે.
- **Do:** Vine growth ને "ઝડપથી કાઢો" pressure તરીકે (Moves).
- **Don't:** N = 1 (દર Move growth — frustrating).
- **Combos:** M001, M025.

---

### M028 — Hatch Order Snakes (Numbered Paths)
| Field | Value |
|---|---|
| Intro / Category | L281 · P |
| Rule | Numbered snakes (1…k) **ascending order** માં જ exit. ખોટો number tap ⇒ locked |
| Tap / bump | Out-of-order ⇒ locked 🔢 (no Move). Current number blocked ⇒ bonk |
| Heart effect | Locked 0; bump −1 |
| Hammerable | ✅ (hammered = તેનો number પૂરો; current ન હોય તો order list માંથી remove) |
| Hint / solver | State: next index |
| Visual & audio | Egg-shell hat with number; current number glows softly; `sfx_hatch_chirp` |

```json
{"id": "o28", "type": "M028", "cells": [], "params": {"order": ["p3", "p7", "p9"]}, "hammerable": false}
```
- **Implementation:** `NumberedPaths(order, idx)`; `isLocked(p)` = p ∈ order && p != order[idx].
- **Do:** Number order અને natural order અલગ.
- **Don't:** k > 5 Phase 1 માં.
- **Combos:** M011, M003.

---

### M029 — Hedge Border (Edge Wall)
| Field | Value |
|---|---|
| Intro / Category | L291 · B |
| Rule | Board edge ના segments (દરેક cell ની એક side) hedge થી બંધ; lane તે edge પર પહોંચે ⇒ bonk |
| Tap / bump | Hedge tap ignore |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ (standard) |
| Hint / solver | Static |
| Visual & audio | Trimmed green hedge along border; bonk ⇒ leaves rustle `sfx_hedge_rustle` |

```json
{"id": "o29", "type": "M029", "cells": [[0,3],[0,4],[0,5]], "params": {"side": "L"}, "hammerable": false}
```
- **Implementation:** `EdgeWall(cells, side)`; lane trace edge crossing check. Validator: cells side ની edge row/col પર.
- **Do:** M020 Home Burrow સાથે "અંદરથી exit".
- **Don't:** બધી edges બંધ (M078 Phase 2 નું કામ).
- **Combos:** M020, M030, M031.

---

### M030 — Flower Arch Exit (Color Edge)
| Field | Value |
|---|---|
| Intro / Category | L301 · B |
| Rule | Edge opening (segment) **માત્ર એક colour** માટે ખુલ્લું; બીજા colours ⇒ bonk at edge |
| Tap / bump | Arch tap ignore |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Static per colour |
| Visual & audio | Flower arch in colour + pattern; pass ⇒ petals shower `sfx_petal` |

```json
{"id": "o30", "type": "M030", "cells": [[9,2],[9,3]], "params": {"side": "R", "color": "yellow"}, "hammerable": false}
```
- **Implementation:** `ColorEdge(cells, side, color)`.
- **Do:** Hedge Border સાથે sorting.
- **Don't:** Arch colour એવો જે board પર નથી (validator).
- **Combos:** M029, M041.

---

### M031 — Closing Hedge Gap (Closing Edge)
| Field | Value |
|---|---|
| Intro / Category | L311 · C |
| Rule | Open edge segment **N Moves** પછી કાયમ બંધ (પછી Hedge Border જેવું). Badge N |
| Tap / bump | — |
| Heart effect | બંધ પછી bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | State: remaining |
| Visual & audio | Hedge gap with growing twigs; close ⇒ `sfx_hedge_close` |

```json
{"id": "o31", "type": "M031", "cells": [[4,0],[5,0]], "params": {"side": "U", "n": 5}, "hammerable": false}
```
- **Implementation:** `ClosingEdge(cells, side, n)`; `onMoveTick` (order #3, standard §16.17).
- **Do:** "આ snake પહેલાં 5 Moves માં" priority.
- **Don't:** Gap ને એકમાત્ર exit બનાવી N ઓછું રાખવું (no slack).
- **Combos:** M029, M017.

---

### M032 — Canopy & Ground (Two Layers)
| Field | Value |
|---|---|
| Intro / Category | L321 · L |
| Rule | Level `layers: 2`. Canopy (layer 1) snakes ઉપર દોરાય. Ground (layer 0) snake **locked** જ્યાં સુધી કોઈ canopy snake તેના body ને cover કરે. Lanes **માત્ર પોતાના layer** માં interact (ground lane માત્ર ground snakes થી blocked, canopy lane માત્ર canopy snakes થી) |
| Tap / bump | Overlap cell ⇒ canopy snake ને tap (priority). Covered ground ⇒ locked 🍃 |
| Heart effect | Bump ⇒ −1 |
| Hammerable | Snake ✅ (visible part; covered ground snake target નથી) |
| Hint / solver | State: derived from remaining snakes |
| Visual & audio | Canopy snakes on branch shadow (pre-baked offset shadow), ground snakes slightly desaturated when covered; `sfx_leaf_rustle` |

```json
{"id": "o32", "type": "M032", "cells": [], "params": {"obstacleLayer": "both"}, "hammerable": false}
```
- **Implementation:** `TwoLayers()`; paths `layer` 0/1. Lane trace filter by layer. Obstacles default બંને layers block કરે (`params.layer` 0/1 થી override).
- **Do:** 2–4 canopy snakes; overlap clear દેખાય.
- **Don't:** Canopy snake ground snake ને પૂરેપૂરો ઢાંકે (ground snake દેખાય નહીં).
- **Combos:** M015, M004.

---

### M033 — Petal Cage (Color Cage)
| Field | Value |
|---|---|
| Intro / Category | L331 · K |
| Rule | Caged snake **locked** જ્યાં સુધી cage colour ના **બધા** snakes exit ન થાય. દરેક Move પછી check; એક વાર condition સાચી ⇒ cage કાયમ ખુલે |
| Tap / bump | Caged ⇒ locked 🌸. Caged snake બીજાના lanes block કરે |
| Heart effect | Locked 0 |
| Hammerable | Cage ❌; caged snake ✅ (visible snake) |
| Hint / solver | State: open bool |
| Visual & audio | Flower-petal cage in colour + pattern; open ⇒ petals fall `sfx_cage_bloom` |

```json
{"id": "o33", "type": "M033", "cells": [], "params": {"path": "p5", "color": "pink"}, "hammerable": false}
```
- **Implementation:** `ColorCage(pathId, color)`; condition = no remaining snake (excluding caged) whose current colour == color. Validator: caged snake colour ≠ cage colour.
- **Do:** Cage colour ના 2–3 snakes.
- **Don't:** Cage colour ના snake નો lane caged snake થી blocked અને બીજો રસ્તો નહીં (deadlock).
- **Combos:** M041, M005.

---

### M034 — Whirl Stump (Rotor 2×2)
| Field | Value |
|---|---|
| Intro / Category | L341 · T |
| Rule | 2×2 tree stump. Tap ⇒ 2×2 નું content **90° CW** ફરે: પૂરેપૂરા અંદર રહેલા snakes (cells + dir) અને static obstacles/gems. કોઈ snake **અડધો અંદર** હોય ⇒ rotate થઈ શકે નહીં |
| Tap / bump | Valid tap = 1 Move. Partial snake હોય ⇒ locked tap ⛔ (no Move) |
| Heart effect | 0 |
| Hammerable | ❌ |
| Hint / solver | State: rotation (content positions) |
| Visual & audio | Tree-stump rings with arrow; rotate ⇒ `sfx_stump_turn` 300 ms |

```json
{"id": "o34", "type": "M034", "cells": [[3,3],[4,3],[3,4],[4,4]], "params": {}, "hammerable": false}
```
- **Implementation:** `Rotor2x2(origin)`; `onTap` ⇒ cell map (x,y)→rotated, dir cw. Tap on stump center seam (cells overlap snake ⇒ tap priority: stump ring icon in center).
- **Do:** Length-2 snake inside stump.
- **Don't:** Stump ના cells પર interactive obstacles.
- **Combos:** M013, M026.

---

### M035 — Mama Snake (Spawner Path)
| Field | Value |
|---|---|
| Intro / Category | L351 · P |
| Rule | Mama exit થાય ⇒ marked cells પર ટૂંકો **baby snake** spawn (cells free હોય તો); નહીં તો pending, દરેક Move ના tick પર ફરી check |
| Tap / bump | Mama normal; baby normal snake (win માટે baby પણ exit જરૂરી) |
| Heart effect | Normal |
| Hammerable | ✅ mama (exit ગણાય ⇒ baby spawn), baby ✅ |
| Hint / solver | State: spawned/pending |
| Visual & audio | Mama with bow, egg icon on marked cells (dotted outline); spawn ⇒ egg hatch `sfx_hatch_pop` |

```json
{"id": "o35", "type": "M035", "cells": [[2,7],[3,7]], "params": {"path": "p2", "child": {"id": "p2c", "color": "green", "dir": "R", "body": [[3,7],[2,7]]}}, "hammerable": false}
```
- **Implementation:** `SpawnerPath(pathId, child)`; `onPathExit` ⇒ queue; derived-state step ([01 §5.9](./01_GAME_CONCEPT_AND_RULES.md#59-move-resolution-order-deterministic) step 6) spawn if free. Win check: pending queue empty.
- **Do:** Baby નો lane mama ના exit પછી ખુલ્લો.
- **Don't:** Marked cells પર બીજો snake જે ક્યારેય નીકળી ન શકે.
- **Combos:** M028, M020.

---

### M036 — Hungry Caterpillar (Hungry Path)
| Field | Value |
|---|---|
| Intro / Category | L361 · P |
| Rule | Exit **ત્યારે જ** જ્યારે તેનો lane કોઈ food (apple) cell પરથી પસાર થાય; પહેલું food consume. Food block નથી; બીજા snakes food ignore |
| Tap / bump | Lane blocked ⇒ bonk. Lane clear પણ food નહીં ⇒ **bonk (bump)** too — standard §16.6 (Move +1) |
| Heart effect | Bump −1 (blocked અથવા no-food બંને); Shield absorb કરે |
| Hammerable | ✅ |
| Hint / solver | State: food bitmask |
| Visual & audio | Caterpillar with bib; apple cells; eat ⇒ chomp `sfx_chomp` |

```json
{"id": "o36", "type": "M036", "cells": [[6,3]], "params": {"path": "p6"}, "hammerable": false}
```
- **Implementation:** `HungryPath(pathId, foodCells)`; tap resolve: trace lane ⇒ blocked? bump : (food on lane? exit+consume : bump). Hint/solver no-food tap ને bump ગણે (ક્યારેય suggest નહીં).
- **Do:** Food mirror/burrow route પર.
- **Don't:** બે hungry snakes + 1 food (એક અટકે — validator).
- **Combos:** M014, M008.

---

### M037 — Sticky Swamp Mud (Mud Trap)
| Field | Value |
|---|---|
| Intro / Category | L371 · D |
| Rule | Lane mud cell સુધી પહોંચે ⇒ snake **ત્યાં અટકે**: head mud પર, body lane પર પાછળ (relocate, 1 Move). પછીનો tap mud થી એ જ dir માં આગળ |
| Tap / bump | Mud પહેલાં blocked ⇒ bonk. Relocate = Move (bump નહીં) |
| Heart effect | Relocate 0 |
| Hammerable | ❌ |
| Hint / solver | State: snake positions (relocation) |
| Visual & audio | Brown bubbling mud; stuck ⇒ `sfx_mud_squelch` + mud splash |

```json
{"id": "o37", "type": "M037", "cells": [[5,2]], "params": {}, "hammerable": false}
```
- **Implementation:** `MudTrap(cell)`; lane trace ⇒ stop at mud ⇒ new body = last n cells of (old body + lane up to mud). Snake initially on mud ⇒ next tap normal.
- **Do:** Mud ⇒ snake ને plate (M019) પર લાવવો.
- **Don't:** Mud પછી head સામે તરત blocker (useless stop).
- **Combos:** M019, M016.

---

### M038 — Bouncy Fern Pad (Jump Pad)
| Field | Value |
|---|---|
| Intro / Category | L381 · G |
| Rule | Lane pad પરથી પસાર થાય ⇒ **આગલો 1 cell કૂદી જાય** (1-cell blocker — rock, closed gate, lock — ઉપરથી). આગલા cell માં snake body ⇒ કૂદી ન શકે ⇒ bonk |
| Tap / bump | Landing cell blocked ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Static redirect |
| Visual & audio | Curled fern spring; jump ⇒ snake arcs (scale 1.15) `sfx_spring` |

```json
{"id": "o38", "type": "M038", "cells": [[3,5]], "params": {}, "hammerable": false}
```
- **Implementation:** `JumpPad(cell)`; trace: next cell skip unless path body; landing off-board ⇒ exit. Animation arc via vertical offset on segment.
- **Do:** Rock ઉપરથી જવાનું "aha".
- **Don't:** 2 pads સળંગ.
- **Combos:** M001, M005.

---

### M039 — Pond Twins (Mirror Twins)
| Field | Value |
|---|---|
| Intro / Category | L391 · P |
| Rule | Pond axis ની બંને બાજુ mirrored twins. એક tap ⇒ twin **mirrored** રીતે સાથે ચાલે; **બંને** lanes clear જોઈએ, નહીં તો બંને bonk |
| Tap / bump | 1 Move |
| Heart effect | Blocked ⇒ −1 total |
| Hammerable | ✅ (hammered twin exit; બીજો normal) |
| Hint / solver | Atomic pair action |
| Visual & audio | Pond ripple line between; twins have reflection shimmer; `sfx_twin_splash` |

```json
{"id": "o39", "type": "M039", "cells": [], "params": {"paths": ["p3", "p4"], "axis": "V"}, "hammerable": false}
```
- **Implementation:** `MirrorTwins(a, b, axis)`; validator: b == mirror(a) (cells & dir). Resolve like group of 2.
- **Do:** Board symmetric, એક બાજુ obstacle.
- **Don't:** Axis ને board center સિવાય (Phase 1 માં center only).
- **Combos:** M001, M005.

---

### M040 — Jungle Night (Night Board)
| Field | Value |
|---|---|
| Intro / Category | L401 · G |
| Rule | **Visual only:** board અંધારું; માત્ર છેલ્લા moved snake ના route/position ની આસપાસ (radius 2 cells) અને long-press preview lane પ્રકાશિત. **Rules unchanged** |
| Tap / bump | Normal |
| Heart effect | Normal |
| Hammerable | — |
| Hint / solver | Solver unaffected |
| Visual & audio | Moonlight vignette, fireflies around lit area; snakes' eyes glow (min silhouette visibility 20%); night ambience |

```json
{"id": "o40", "type": "M040", "cells": [], "params": {"radius": 2}, "hammerable": false}
```
- **Implementation:** `NightBoard(radius)`; render-only: dark overlay with radial cut-outs (pre-baked gradient image). Accessibility "Brighter nights" ⇒ min visibility 40%.
- **Do:** Simple rules + memory challenge.
- **Don't:** Night + Jungle Mist એક જ board (double hidden).
- **Combos:** M001, M028.

---

### M041 — Chameleon Snake (Chameleon Path)
| Field | Value |
|---|---|
| Intro / Category | L411 · P |
| Rule | Colour દર Move cycle: **red → green → blue → red …**. Current colour M005 Flower Gate, M030 Flower Arch, M033 Petal Cage સાથે interact |
| Tap / bump | Normal; current colour થી gate check |
| Heart effect | Normal |
| Hammerable | ✅ |
| Hint / solver | State: moveCount mod 3 (+ start) |
| Visual & audio | Chameleon-skin snake with curled tail; colour morph 200 ms + pattern swap; `sfx_chameleon_shift` |

```json
{"id": "o41", "type": "M041", "cells": [], "params": {"path": "p5", "cycle": ["red", "green", "blue"], "start": 0}, "hammerable": false}
```
- **Implementation:** `ChameleonPath(pathId, cycle, start)`; colour = cycle[(start + moveCount) % 3]; tick order #7 (last counter, standard §16.17).
- **Do:** Flower Gate + "સાચા colour ની રાહ" via other Moves.
- **Don't:** Pattern-only cue વગર (colour-blind — pattern પણ બદલાય).
- **Combos:** M005, M030, M033.

---

### M042 — Dry Twig Bridge (Fragile Bridge)
| Field | Value |
|---|---|
| Intro / Category | L421 · L |
| Rule | Root Bridge જેવું, પણ **1 crossing** પછી તૂટી **Garden Rock (Single Blocker)** બને. Crossing = કોઈ પણ lane bridge cell પરથી/નીચેથી પસાર, અથવા bridge પરનું body exit |
| Tap / bump | Broken ⇒ blocker |
| Heart effect | Bump ⇒ −1 |
| Hammerable | Intact ❌ · broken ✅ |
| Hint / solver | State: intact bool |
| Visual & audio | Dry twigs; crossing ⇒ snap `sfx_twig_snap` + becomes twig pile |

```json
{"id": "o42", "type": "M042", "cells": [[4,6]], "params": {"axis": "V"}, "hammerable": false}
```
- **Implementation:** `FragileBridge(cell, axis, intact)`; `onPathExit` ⇒ crossing ⇒ intact = false, `hammerable = true` runtime.
- **Do:** "કોને bridge વાપરવા દેવો?" choice.
- **Don't:** બે snakes ને bridge જ જોઈએ (unsolvable).
- **Combos:** M015, M001.

---

### M043 — Big Knot Cage (Multi-Lock)
| Field | Value |
|---|---|
| Intro / Category | L431 · K |
| Rule | Lock ને **2–3 keys** જોઈએ: બધા key-snakes exit ⇒ કાયમ ખુલે. Badge = બાકી keys |
| Tap / bump | Closed ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ (lock) |
| Hint / solver | State: remaining keys set |
| Visual & audio | Big bamboo cage with 2–3 knots; each key ⇒ knot unties `sfx_knot_untie` |

```json
{"id": "o43", "type": "M043", "cells": [[7,4]], "params": {"keyPaths": ["p1", "p4", "p7"]}, "hammerable": false}
```
- **Implementation:** `MultiLock(cell, keys)`.
- **Do:** Keys board ના અલગ ખૂણામાં.
- **Don't:** Key snake નો lane પોતાના lock થી blocked.
- **Combos:** M004, M010.

---

### M044 — Twisty Burrow (Turning Portal)
| Field | Value |
|---|---|
| Intro / Category | L441 · D |
| Rule | Rabbit Burrows જેવું, પણ exit side પર lane direction **90° ફરે** (દરેક burrow નો `rot` CW/CCW) |
| Tap / bump | B occupied/blocked ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Static redirect |
| Visual & audio | Spiral burrow; snake emerges twisting `sfx_burrow_twist` |

```json
{"id": "o44", "type": "M044", "cells": [[1,6],[8,2]], "params": {"pair": "spiral", "rot": ["CW", "CCW"]}, "hammerable": false}
```
- **Implementation:** `TurningPortal(a, b, rotA, rotB)`; lane entering A ⇒ from B with dir rotated by rotB (and vice versa).
- **Do:** Board ના ખૂણાથી બીજી edge.
- **Don't:** Twisty + plain burrows same symbol.
- **Combos:** M008, M014.

---

### M045 — Root Gear Lever (Gear Lever)
| Field | Value |
|---|---|
| Intro / Category | L451 · T |
| Rule | એક lever tap (1 Move) ⇒ linked **બધા Spinning Lilypads (M013)** સાથે 90° CW ફરે. Gear-linked lilypads ને પોતાનો tap નથી |
| Tap / bump | Lever = Move; linked lilypad tap ⇒ locked ⚙️ |
| Heart effect | 0 |
| Hammerable | ❌ |
| Hint / solver | State: each linked dir |
| Visual & audio | Wooden root gears connecting lilypads; turn ⇒ `sfx_gear_turn` |

```json
{"id": "o45", "type": "M045", "cells": [[0,0]], "params": {"turntables": ["o13a", "o13b", "o13c"]}, "hammerable": false}
```
- **Implementation:** `GearLever(cell, turntableIds)`; exited snake ના lilypad skip.
- **Do:** 2–3 lilypads, "4 વાર tap = પાછું" cycle.
- **Don't:** Lilypads ના snakes એકબીજાના lanes ને rotation પછી હંમેશા block.
- **Combos:** M013, M009.

---

### M046 — Tail-Biter Loop (Loop Path)
| Field | Value |
|---|---|
| Intro / Category | L461 · K |
| Rule | Snake પોતાની પૂંછડી મોં માં (closed loop) — **locked** જ્યાં સુધી linked key-snake exit ન થાય; પછી marked head cell થી ખુલે (dir given) અને normal snake |
| Tap / bump | Locked 🔗 |
| Heart effect | 0 |
| Hammerable | Locked ❌ · open ✅ |
| Hint / solver | State: open bool |
| Visual & audio | Ouroboros ring; key ⇒ snake lets go of tail `sfx_loop_open` |

```json
{"id": "o46", "type": "M046", "cells": [], "params": {"path": "p9", "keyPath": "p3", "head": [5,5], "dir": "U"}, "hammerable": false}
```
- **Implementation:** `LoopPath(pathId, keyPath, head, dir)`; open ⇒ body reorder from head around loop. Validator: loop closed, length ≥ 4.
- **Do:** Loop board ના વચ્ચે, lanes ને block કરે.
- **Don't:** Opened dir loop ના પોતાના body માં.
- **Combos:** M004, M043.

---

### M047 — Growing Caterpillar (Growing Path)
| Field | Value |
|---|---|
| Intro / Category | L471 · C |
| Rule | દર **N Moves** tail પાછળ 1 cell વધે (direction `tail − body[n−2]`), cell free હોય તો; blocked/off-board ⇒ growth નહીં |
| Tap / bump | Normal |
| Heart effect | Normal |
| Hammerable | ✅ |
| Hint / solver | State: body length + counter |
| Visual & audio | Segment pops in `sfx_grow_pop` |

```json
{"id": "o47", "type": "M047", "cells": [], "params": {"path": "p10", "n": 4}, "hammerable": false}
```
- **Implementation:** `GrowingPath(pathId, n)`; `onMoveTick` (order #6).
- **Do:** Growth બીજા lanes ને બંધ કરે ⇒ "પહેલાં કાઢો".
- **Don't:** N ≤ 2.
- **Combos:** M019, M027.

---

### M048 — Snake Parade (Color Group Tap)
| Field | Value |
|---|---|
| Intro / Category | L481 · P |
| Rule | Group-marked same-colour snakes: એક tap ⇒ **બધા** group snakes સાથે exit try; કોઈ એક blocked (બીજા group members પણ blocker ગણાય) ⇒ બધા bonk |
| Tap / bump | 1 Move |
| Heart effect | Blocked ⇒ −1 total |
| Hammerable | ✅ (hammered member group માંથી remove) |
| Hint / solver | Atomic group action |
| Visual & audio | Tiny flag on each member; exit ⇒ marching parade `sfx_parade` |

```json
{"id": "o48", "type": "M048", "cells": [], "params": {"color": "orange", "paths": ["p2", "p6", "p8"]}, "hammerable": false}
```
- **Implementation:** `ColorGroup(color, paths)`; shared `tryExitGroup` with M011.
- **Do:** 2–3 members.
- **Don't:** Group members lanes cross.
- **Combos:** M011, M005.

---

### M049 — Grumpy Mongoose (Guardian)
| Field | Value |
|---|---|
| Intro / Category | L491 · X |
| Rule | Multi-cell blocker (2×2; Finale 3×3). **HP = linked snakes count**; દરેક linked snake exit ⇒ HP −1; HP 0 ⇒ vanish |
| Tap / bump | Mongoose tap ⇒ grumpy huff (ignore, no Move). Lane ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ (standard). Hammered linked snake ⇒ exit ગણાય ⇒ HP −1 |
| Hint / solver | State: HP |
| Visual & audio | Cute mongoose with crossed arms; linked snakes have paw-print tag; HP pips; vanish ⇒ "poof" `sfx_mongoose_poof` |

```json
{"id": "o49", "type": "M049", "cells": [[4,4],[5,4],[4,5],[5,5]], "params": {"linked": ["p1", "p5", "p9"]}, "hammerable": false}
```
- **Implementation:** `Guardian(cells, linked)`; Sunday Daily "Mini Boss".
- **Do:** Linked snakes board ભરમાં; mongoose central.
- **Don't:** Linked snake નો એકમાત્ર lane mongoose માંથી.
- **Combos:** M020, M026, Finale mix.

---

### Finale — Mongoose King's Garden (L500)
| Field | Value |
|---|---|
| Category | X |
| Rule | Grumpy Mongoose (King, 3×3, HP 6) + 9 other Phase-1 mechanic instances (= T5 max 10, standard §16.35); વિગત [02 §8](./02_LEVEL_PROGRESSION_0001_0500.md#8-phase-finale--l500-mongoose-kings-garden) |
| Hammer | Mongoose ❌ |
| Visual & audio | Crown, cape, finale music |

## 4. Combo Rules (validator)
| Combo | Status | Reason |
|---|---|---|
| M010 Mist + M040 Night | ❌ banned | Double hidden info |
| M024 Giant Anaconda + M014/M008/M044/M018 redirect | ❌ banned (Phase 1) | Wide lane redirect undefined |
| M013 Lilypad orientation facing neck in `solution` | ❌ | Self-block |
| M033 cage colour == caged snake colour | ❌ | Circular |
| M011/M039/M048 group lanes crossing each other | ❌ | Always blocked |
| M041 Chameleon + M005/M030/M033 | ✅ recommended | Designed interaction |
| M019 Plate + M037 Mud | ✅ | Plate cover by relocation |
| M049 + M026 + M020 | ✅ | Boss goals |
| Lane loops (same cell+dir twice) | ❌ | Infinite trace |

## 5. Per-Mechanic Unit Tests (puzzle_core)
દરેક M-ID માટે `test/mechanics/m0xx_test.dart` ફરજિયાત, minimum cases:
1. Rule happy path (exit/open/redirect).
2. Blocked ⇒ bump ⇒ hearts −1, board unchanged, moveCount +1.
3. Locked tap (લાગુ પડે ત્યાં) ⇒ hearts same, moveCount same.
4. Hammer behaviour (allowed/denied + exit triggers).
5. Undo ⇒ state exact restore (`==` on `BoardState`).
6. Solver encode determinism (same state ⇒ same hash).
QA IDs: [07 §14](./07_FRONTEND_IMPLEMENTATION_AND_QA.md#14-qa-checklist) (`QA-MECH-M001` … `QA-MECH-M049`).

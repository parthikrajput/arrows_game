# 03 — Obstacle Catalog, Phase 1 (M001–M049)
Phase 1 ના બધા 49 mechanics + L500 Finale — દરેક card standard §10 ના ફરજિયાત fields + Game 4 ના **Ants / Bees / Tall** fields સાથે.

**Related docs:** [Shared Core Standard §10](../../SHARED_CORE_STANDARD.md) · [01 Rules (Layer Rule §5)](./01_GAME_CONCEPT_AND_RULES.md) · [02 Level Progression](./02_LEVEL_PROGRESSION_0001_0500.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md) · [Phase 2 docs](../phase_2/README.md)

---

## 1. How to Read This Catalog (આ catalog કેવી રીતે વાંચવો)

### 1.1 Layer rule recap ([01 §5](./01_GAME_CONCEPT_AND_RULES.md))
- **Ants = Ground (`layer: 0`). Bees = Air (`layer: 1`).** Ants અને bees એકબીજા સાથે **ક્યારેય collide નથી** થતાં.
- **Ant lane** block: ant lines + **બધા** blocking obstacles (`tall` ગમે તે હોય) + ant-blocking edges.
- **Bee lane** block: **માત્ર** bee lines + `tall: true` obstacles.
- Non-blocking cell mechanics bee lane ને ત્યારે જ અસર કરે જ્યારે `tall: true`. Card માં **Tall** field:
  - `false (fixed)` ⇒ ant-only mechanic; bees ને કોઈ અસર નહીં.
  - `true (fixed)` ⇒ હંમેશા બંને layers.
  - `Per instance` ⇒ level designer `"tall"` set કરે (default `false`); tall instances ઊંચા sprite + wing marker સાથે દોરાય. Tall instances **L42 થી** વાપરી શકાય (bees L41 પછી).
  - `N/A` ⇒ path modifier અથવા area effect; card ના Ants/Bees fields અસર સમજાવે.

### 1.2 The M004 ↔ M032 swap (Standard §10 exception)
| Slot | Standard default | **Game 4** |
|---|---|---|
| L41 (M004 slot) | Key & Lock | **M032 Bee Lines (Air Layer)** — engine rule M032 "Two Layers" |
| L321 (M032 slot) | Two Layers | **M004 Dew Key & Thorn Lock** — engine rule M004 "Key & Lock" |

- JSON `type` હંમેશા **engine rule ID** વાપરે: Key & Lock instance = `"type": "M004"` (L321 થી), layer system = path `"layer"` + level `"layers": 2` (L41 થી). એટલે `puzzle_core` નો code બદલાતો નથી; માત્ર Game 4 ની intro schedule બદલાય છે.
- **L1–40 = ants only.** L41–320 માં keys/locks **નથી**. Friday "Key Hunt" daily modifier L321 unlock પહેલાં Classic પર fallback ([05](./05_DAILY_CHALLENGE_AND_STREAK.md)).
- બીજી કોઈ ordering change નથી.

### 1.3 JSON conventions (schema v3)
- Path: `{"id","color","dir","body":[[x,y]...],"layer":0|1,"mods":{}}` — `body[0]` = head insect.
- Mechanic: `{"id","type":"M0xx","cells","params","hammerable","tall"}` — `tall` Game 4 extension (optional, default `false`, `layers: 1` levels માં ignore).
- Examples ટૂંકા fragments છે; full level JSON [Standard §12](../../SHARED_CORE_STANDARD.md).

### 1.4 Hammerable rule
Leaf Blower (Hammer) કોઈપણ **1 visible line** remove કરી શકે (exit ગણાય) — mechanic hammerable હોય કે નહીં. Obstacle remove માત્ર `hammerable: true` instances ([Standard §16.18](../../SHARED_CORE_STANDARD.md)): **M001 Garden Pebble/Sunflower Stalk, M002 Twig Fence/Bramble Row (આખી wall), M016 Crumbly Dirt Clod, M025 Patrolling Ladybug, M027 Creeping Moss (એક target cell જ), M042 Fallen Leaf (break પછી)**. બાકીના બધા (gates, tiles, interactive cells, Lock family, Edge Walls, Great Orb Spider) not hammerable. Fog-hidden અને cover-locked (bee નીચેની) lines Leaf Blower target નથી (Standard §16.8).

## 2. Summary Table (સારાંશ)

| # | Intro | ID | Themed name | Generic | Cat | Ants | Bees | Tall | Hammer |
|---|---|---|---|---|---|---|---|---|---|
| 1 | L11 | **M001** | Garden Pebble | Single Blocker | B | Block | If tall | Per inst. | Yes |
| 2 | L21 | **M002** | Twig Fence | Long Wall | B | Block | If tall | Per inst. | Yes (whole) |
| 3 | L31 | **M003** | Dew-Stuck Line | Frozen Path | C | Yes | Yes | N/A | No |
| 4 | L41 | **M032** | Bee Lines (Air Layer) — **M004 slot** | Two Layers | L | Cover-lock | Air layer | N/A | No |
| 5 | L51 | **M005** | Petal Gate | Color Gate | B | Non-match bump | If tall | Per inst. | No |
| 6 | L61 | **M006** | Bamboo One-Way Tube | One-Way Tile | D | Yes | No | false | No |
| 7 | L71 | **M007** | Morning Glory Gate | Countdown Gate | C | Block while closed | If tall | Per inst. | No |
| 8 | L81 | **M008** | Burrow Tunnel Pair | Portal Pair | D | Yes | No | false | No |
| 9 | L91 | **M009** | Twig Lever & Vine Gates | Lever + Toggle Gates | T | Lever+gates | Gates if tall | Gates per inst. | No |
| 10 | L101 | **M010** | Morning Mist | Fog Patch | C | Hide+lock | Hide+lock | N/A | No |
| 11 | L111 | **M011** | Petal-Linked Pair | Chained Pair | P | Yes | Yes | N/A | No |
| 12 | L121 | **M012** | Napping Line | Sleeping Path | P | Yes | Yes | N/A | No |
| 13 | L131 | **M013** | Spinning Daisy | Turntable | T | Rotate head | Rotate head | false | No |
| 14 | L141 | **M014** | Curled Leaf Deflector | Mirror | D | Deflect | If tall | Per inst. | No |
| 15 | L151 | **M015** | Twig Bridge | Bridge | L | Yes | No | false | No |
| 16 | L161 | **M016** | Crumbly Dirt Clod | Cracked Rock | C | Block | No | false | Yes |
| 17 | L171 | **M017** | Rain-Alert Line | Countdown Path | C | Yes | Yes | N/A | No |
| 18 | L181 | **M018** | Clover Switch | Switch Junction | T | Yes | No | false | No |
| 19 | L191 | **M019** | Acorn Pressure Plate | Pressure Plate | T | Press plate | Gate if tall | Gate per inst. | No |
| 20 | L201 | **M020** | Anthill & Hive Entrance | Inner Exit (Hole) | G | Anthill | Hive | `layer` param | No |
| 21 | L211 | **M021** | Hide-and-Seek Line | Phasing Path | P | Yes | Yes | N/A | No |
| 22 | L221 | **M022** | Backward-Walking Line | Reverse Path | P | Yes | Yes | N/A | No |
| 23 | L231 | **M023** | Two-Way Scout Line | Two-Head Path | P | Yes | Yes | N/A | No |
| 24 | L241 | **M024** | Double-File Line | Wide Path | P | Yes | Yes | N/A | No |
| 25 | L251 | **M025** | Patrolling Ladybug | Patrol Blocker | C | Block | No | false | Yes |
| 26 | L261 | **M026** | Sugar Crumbs & Nectar Drops | Collect Gems | G | Crumb | Nectar | `layer` param | No |
| 27 | L271 | **M027** | Creeping Moss | Spreader | C | Block | No | false | Yes (1 cell) |
| 28 | L281 | **M028** | Marching Order | Numbered Paths | P | Yes | Yes (shared order) | N/A | No |
| 29 | L291 | **M029** | Brick Edging | Edge Wall | B | Bump | If tall | Per inst. | No |
| 30 | L301 | **M030** | Painted Garden Gate | Color Edge | B | Non-match bump | If tall | Per inst. | No |
| 31 | L311 | **M031** | Latching Gate | Closing Edge | C | Bump after N | If tall | Per inst. | No |
| 32 | L321 | **M004** | Dew Key & Thorn Lock — **M032 slot** | Key & Lock | K | Lock blocks | If tall; keys any layer | Per inst. | No |
| 33 | L331 | **M033** | Flower-Bud Cage | Color Cage | K | Yes | Yes | N/A | No |
| 34 | L341 | **M034** | Lily-Pad Rotor | Rotor 2×2 | T | Rotate | Rotate | false | No |
| 35 | L351 | **M035** | Brood Line | Spawner Path | P | Yes | Yes | N/A | No |
| 36 | L361 | **M036** | Hungry Line | Hungry Path | P | Crumb food | Blossom food | `layer` param | No |
| 37 | L371 | **M037** | Mud Puddle | Mud Trap | D | Stop | No | false | No |
| 38 | L381 | **M038** | Mushroom Spring | Jump Pad | G | Jump | No | false | No |
| 39 | L391 | **M039** | Mirror-Twin Lines | Mirror Twins | P | Yes | Yes | N/A | No |
| 40 | L401 | **M040** | Twilight Garden | Night Board | G | Visual | Visual | N/A | No |
| 41 | L411 | **M041** | Rainbow Pollen Line | Chameleon Path | P | Yes | Yes | N/A | No |
| 42 | L421 | **M042** | Dry Leaf Bridge | Fragile Bridge | L | Yes | No | false | After break |
| 43 | L431 | **M043** | Bramble Multi-Lock | Multi-Lock | K | Lock blocks | If tall | Per inst. | No |
| 44 | L441 | **M044** | Twisting Burrow | Turning Portal | D | Yes | No | false | No |
| 45 | L451 | **M045** | Root Gear Lever | Gear Lever | T | Rotate | Rotate | false | No |
| 46 | L461 | **M046** | Ring-Around Line | Loop Path | K | Yes | Yes | N/A | No |
| 47 | L471 | **M047** | Recruiting Line | Growing Path | C | Yes | Yes | N/A | No |
| 48 | L481 | **M048** | Colony Call | Color Group Tap | P | Yes | Yes | N/A | No |
| 49 | L491 | **M049** | Great Orb Spider | Guardian | X | Block | Block | true | No |
| — | L500 | — | **Queen's Garden Gala** (Phase 1 Finale) | Phase 1 Finale | X | Mixed | Mixed | — | — |

## 3. Mechanic Cards (દરેક mechanic નું card)

### 3.1 M001 — Garden Pebble (બગીચાની કાંકરી)

| Field | Value |
|---|---|
| ID | `M001` (engine rule) |
| Themed name | **Garden Pebble** (બગીચાની કાંકરી) — generic: Single Blocker |
| Intro level | **L11** (block 11–20) |
| Category | B — Static Blocker |
| Rule | 1 cell blocker; lane ને block કરે. |
| Ants (Ground) | Ant lane block કરે (હંમેશા). |
| Bees (Air) | `tall: false` (Pebble) ⇒ bees ઉપરથી ઉડી જાય. `tall: true` (**Sunflower Stalk** variant, L41+) ⇒ bee lane પણ block. |
| Tall | Per instance; default `false`. `true` = Sunflower Stalk (L42 થી વાપરી શકાય). |
| Tap / bump | Pebble પર tap ⇒ ignore (tap target નથી). Lane pebble ને મળે ⇒ bump. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | **Yes** (Leaf Blower થી 1 instance remove). |
| Hint / solver | Static: reverse construction થી solvable; solver state માં static cell. |
| Visual | ગોળ ભૂખરો પથ્થર, ઉપર highlight; Sunflower Stalk = ઊંચી દાંડી + પીળું ફૂલ + wing marker. |
| Audio | Bump: "tok" stone bonk; Leaf Blower remove: leaf-whoosh. |
| Implementation | `StaticBlocker` class; `blocksLayer(layer) => layer == 0 || tall`. Board cache picture માં દોરાય. |
| Level-design usage | L11 intro: 1–2 pebbles, lines ને ઓર્ડર શીખવે. L42+ માં Sunflower Stalk bees ને ઓર્ડર આપવા. |

```json
{"id": "o1", "type": "M001", "cells": [[3, 2]], "params": {}, "hammerable": true, "tall": false}
```

### 3.2 M002 — Twig Fence (ડાળખીની વાડ)

| Field | Value |
|---|---|
| ID | `M002` (engine rule) |
| Themed name | **Twig Fence** (ડાળખીની વાડ) — generic: Long Wall |
| Intro level | **L21** (block 21–30) |
| Category | B — Static Blocker |
| Rule | 2–4 cells ની સીધી wall; lane block કરે. |
| Ants (Ground) | Ant lane block (હંમેશા). |
| Bees (Air) | `tall: false` (Twig Fence) ⇒ bees અસર નહીં. `tall: true` (**Bramble Row** variant, L41+) ⇒ bee lane block. |
| Tall | Per instance; default `false`. `true` = Bramble Row. |
| Tap / bump | Tap ignore. Lane ⇒ bump. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | **Yes** — આખી wall (બધા cells) એક Leaf Blower થી. |
| Hint / solver | Static. Cells સીધી line માં (validator). |
| Visual | ભૂરી ડાળખીઓ દોરીથી બાંધેલી; Bramble Row = કાંટાળી લીલી વેલ, ઊંચી. |
| Audio | Bump: wooden "knock". |
| Implementation | `LongWall` = `StaticBlocker` with multi cells; Leaf Blower બધા cells remove કરે. |
| Level-design usage | Board ને zones માં વહેંચવા; long chain dependencies. |

```json
{"id": "o2", "type": "M002", "cells": [[2, 4], [3, 4], [4, 4]], "params": {}, "hammerable": true, "tall": false}
```

### 3.3 M003 — Dew-Stuck Line (ઝાકળમાં ચોંટેલી લાઈન)

| Field | Value |
|---|---|
| ID | `M003` (engine rule) |
| Themed name | **Dew-Stuck Line** (ઝાકળમાં ચોંટેલી લાઈન) — generic: Frozen Path |
| Intro level | **L31** (block 31–40) |
| Category | C — Counter (Move-based) |
| Rule | Line locked જ્યાં સુધી K (1–3) **adjacent** (orthogonal) lines exit ન થાય; badge K બતાવે. |
| Ants (Ground) | Ant line dew-stuck હોઈ શકે. |
| Bees (Air) | Bee line dew-stuck હોઈ શકે (L41+). Adjacency 2D grid માં ગણાય — **બંને layers** ની lines count થાય. |
| Tall | N/A (path modifier, obstacle નથી). |
| Tap / bump | K > 0 હોય ત્યારે tap ⇒ locked tap. K = 0 ⇒ normal line. |
| Heart effect | Locked tap માં heart નહીં. |
| Hammerable | Line itself Leaf Blower થી remove થઈ શકે (line target). Dew modifier અલગથી નહીં. |
| Hint / solver | State: `k` per line. Adjacent set level start પર compute થાય; adjacent line exit ⇒ k−1. |
| Visual | Line પર ઝાકળના ટીપાં + badge (ટીપામાં K); k=0 ⇒ ટીપાં સરકી પડે. |
| Audio | Unlock: water "drip-pop". |
| Implementation | `mods.frozen.k`; adjacency set `frozenNeighbours` precompute. Undo k restore કરે. |
| Level-design usage | Ordering puzzles: પહેલાં પડોશીઓ ખાલી કરો. |

```json
{"id": "p3", "color": "blue", "dir": "U", "body": [[4, 4], [4, 5]], "layer": 0, "mods": {"frozen": {"k": 2}}}
```

### 3.4 M032 — Bee Lines (Air Layer) (મધમાખીની લાઈનો (હવાઈ layer))

| Field | Value |
|---|---|
| ID | `M032` (engine rule) · Standard §10 exception: Game 4 માં **M004 slot (L41)** પર |
| Themed name | **Bee Lines (Air Layer)** (મધમાખીની લાઈનો (હવાઈ layer)) — generic: Two Layers |
| Intro level | **L41** (block 41–50) |
| Category | L — Layer |
| Rule | Upper-layer (air) lines ઉપર દોરાય; lower (ground) line locked જ્યારે કોઈ upper line તેના body ને ઢાંકે; lanes માત્ર પોતાના layer માં interact કરે. Game 4 માં upper = bees, lower = ants. |
| Ants (Ground) | Ant lanes bees થી ક્યારેય block નહીં. Bee જે ant cells ઢાંકે તે ant line cover-locked (LR-6). |
| Bees (Air) | Bee lanes ants થી ક્યારેય block નહીં; માત્ર bee lines + `tall: true` obstacles થી. |
| Tall | N/A (layer system). Existing obstacles નું `tall` value bees માટે નિર્ણય કરે. |
| Tap / bump | Overlapping cell tap ⇒ bee (LR-7). Covered ant line નો uncovered cell tap ⇒ locked tap. |
| Heart effect | Normal bump rules દરેક layer માં. |
| Hammerable | Bee line પણ Leaf Blower target (line). |
| Hint / solver | Solver: blocked-check layer-wise; cover-lock = `any bee cell ∩ ant body`. Reverse construction layer-wise valid. |
| Visual | Bees 6 dp ઉપર offset, હળવો મોટો shadow; ant cover થાય ત્યારે ant line સહેજ ઝાંખી (alpha 0.75) + નાનું bee icon. |
| Audio | Bee fly-off "bzzz-whoosh"; cover-locked tap "tsk" + tiny buzz. |
| Implementation | Engine rule ID M032 (layer system). Game 4 માં L41 slot પર. Renderer: ground layer → air layer order. |
| Level-design usage | L41 intro: 2–3 bees, 1 cover-lock. L42: Sunflower Stalk (tall). પછી દરેક block માં 20–50% lines bees. |

```json
{"layers": 2, "paths": [{"id": "a1", "color": "red", "dir": "R", "body": [[2, 3], [1, 3]], "layer": 0, "mods": {}}, {"id": "b1", "color": "yellow", "dir": "U", "body": [[2, 3], [2, 4]], "layer": 1, "mods": {}}]}
```

### 3.5 M005 — Petal Gate (પાંખડી ગેટ)

| Field | Value |
|---|---|
| ID | `M005` (engine rule) |
| Themed name | **Petal Gate** (પાંખડી ગેટ) — generic: Color Gate |
| Intro level | **L51** (block 51–60) |
| Category | B — Static Blocker |
| Rule | Cell ફક્ત same-color line પસાર કરી શકે; બીજા colors bump. |
| Ants (Ground) | Non-matching ant lane ⇒ bump; matching ant line પસાર. Ant body gate cell પર ન હોય (validator). |
| Bees (Air) | `tall: false` ⇒ bees ignore. `tall: true` (**Tall Tulip Gate**) ⇒ non-matching bee lane bump, matching bee પસાર. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. Non-matching lane ⇒ bump. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Static per color; solver check `color == gate.color`. |
| Visual | ફૂલની કમાન, પાંખડીઓનો રંગ = gate color + glyph. |
| Audio | Pass: soft petal "swish"; bump: "bonk". |
| Implementation | `ColorGate.blocks(path) => blocksLayer(path.layer) && path.color != color`. M041 color current Move પર check. |
| Level-design usage | Colors ના sorting puzzles. |

```json
{"id": "o5", "type": "M005", "cells": [[5, 2]], "params": {"color": "pink"}, "hammerable": false, "tall": false}
```

### 3.6 M006 — Bamboo One-Way Tube (વાંસની એક-માર્ગી નળી)

| Field | Value |
|---|---|
| ID | `M006` (engine rule) |
| Themed name | **Bamboo One-Way Tube** (વાંસની એક-માર્ગી નળી) — generic: One-Way Tile |
| Intro level | **L61** (block 61–70) |
| Category | D — Direction changer |
| Rule | Cell ફક્ત arrow direction માં પસાર થઈ શકે; બીજી દિશા ⇒ bump. |
| Ants (Ground) | Ant lane arrow દિશામાં ⇒ પસાર; બીજી દિશા ⇒ bump. |
| Bees (Air) | Bees અસર નહીં (ground tube). |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Static directional check. |
| Visual | પોલી વાંસની નળી, મોઢા પર arrow કોતરેલો. |
| Audio | Pass: hollow "toonk". |
| Implementation | `OneWay.blocks(path, laneDir) => path.layer == 0 && laneDir != dir`. |
| Level-design usage | Ant ને દિશા-limited ordering; bees ને એ જ cell મુક્ત — layer contrast શીખવે. |

```json
{"id": "o6", "type": "M006", "cells": [[3, 3]], "params": {"dir": "R"}, "hammerable": false, "tall": false}
```

### 3.7 M007 — Morning Glory Gate (સવારનું ફૂલ ગેટ)

| Field | Value |
|---|---|
| ID | `M007` (engine rule) |
| Themed name | **Morning Glory Gate** (સવારનું ફૂલ ગેટ) — generic: Countdown Gate |
| Intro level | **L71** (block 71–80) |
| Category | C — Counter (Move-based) |
| Rule | બંધ gate N Moves પછી કાયમ માટે ખુલે (badge N). |
| Ants (Ground) | બંધ હોય ત્યારે ant lane block. |
| Bees (Air) | `tall: true` instance બંધ હોય ત્યારે bee lane પણ block; `false` ⇒ bees ignore. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. દરેક Move પછી N−1; 0 ⇒ ખુલે. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | State: remaining N. Solver depth માં move count ગણે. |
| Visual | બંધ કળી પર badge N; ખુલે ત્યારે ફૂલ ખીલે. |
| Audio | Open: "bloom chime". |
| Implementation | Move tick system માં `onMove()`. Undo N restore. |
| Level-design usage | Patience puzzles: પહેલાં બીજી lines. |

```json
{"id": "o7", "type": "M007", "cells": [[6, 4]], "params": {"n": 4}, "hammerable": false, "tall": false}
```

### 3.8 M008 — Burrow Tunnel Pair (દર-બોગદાની જોડી)

| Field | Value |
|---|---|
| ID | `M008` (engine rule) |
| Themed name | **Burrow Tunnel Pair** (દર-બોગદાની જોડી) — generic: Portal Pair |
| Intro level | **L81** (block 81–90) |
| Category | D — Direction changer |
| Rule | Lane portal A માં પ્રવેશે તો portal B થી એ જ દિશામાં આગળ. B પર line occupy ⇒ blocked. |
| Ants (Ground) | Ant lanes માટે portal. B ઉપર ant body ⇒ ant lane blocked. |
| Bees (Air) | Bees અસર નહીં (જમીનનાં દર); B પર bee હોય તો પણ ant માટે અસર નહીં. |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Lane graph માં edge A→B. Cycle detect (A→B→A) validator. |
| Visual | બે સરખા રંગના માટીના દર, ring color = pair id. |
| Audio | Enter/exit: soft "plop". |
| Implementation | `laneCells()` portal hop support; animation: line દર A માં ઉતરે, B થી નીકળે. |
| Level-design usage | Lines ને દૂરના edge પર exit કરાવવી. |

```json
{"id": "o8", "type": "M008", "cells": [[1, 1], [6, 5]], "params": {"pair": "a"}, "hammerable": false, "tall": false}
```

### 3.9 M009 — Twig Lever & Vine Gates (ડાળખી લીવર અને વેલ ગેટ)

| Field | Value |
|---|---|
| ID | `M009` (engine rule) |
| Themed name | **Twig Lever & Vine Gates** (ડાળખી લીવર અને વેલ ગેટ) — generic: Lever + Toggle Gates |
| Intro level | **L91** (block 91–100) |
| Category | T — Toggle/Interactive |
| Rule | Lever tap (1 Move) ⇒ બધા linked gates open/closed flip. Non-monotone. |
| Ants (Ground) | Lever cell ant lane block (ground). Closed gate ant lane block. |
| Bees (Air) | Lever cell bees ignore. Closed gate `tall: true` ⇒ bee lane block; `false` ⇒ ignore. |
| Tall | Lever: `false` (fixed). Gates: per instance, default `false`. |
| Tap / bump | Lever cell tap ⇒ flip (1 Move). Gate tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No (lever અને gates બંને). |
| Hint / solver | Non-monotone: state bitmask of gates. Hint lever ને glow કરી શકે. |
| Visual | લાકડાની ડાળખી lever (2 positions); વેલનો પડદો gate (ખુલ્લો = વેલ બાજુએ). |
| Audio | Lever: "creak-click"; gates: leaf rustle. |
| Implementation | Gates = `ToggleGate{open}`. Lever = interactive control (tap order #1, 01 §6.5). Undo flip revert. |
| Level-design usage | Ordering + state planning; x9 Hard levels માં 2 levers. |

```json
[{"id": "o9", "type": "M009", "cells": [[0, 6]], "params": {"role": "lever", "links": ["g1", "g2"]}, "hammerable": false, "tall": false}, {"id": "g1", "type": "M009", "cells": [[3, 5]], "params": {"role": "gate", "open": false}, "hammerable": false, "tall": true}, {"id": "g2", "type": "M009", "cells": [[5, 2]], "params": {"role": "gate", "open": true}, "hammerable": false, "tall": false}]
```

### 3.10 M010 — Morning Mist (સવારનું ધુમ્મસ)

| Field | Value |
|---|---|
| ID | `M010` (engine rule) |
| Themed name | **Morning Mist** (સવારનું ધુમ્મસ) — generic: Fog Patch |
| Intro level | **L101** (block 101–110) |
| Category | C — Counter (Move-based) |
| Rule | Fog નીચે lines છુપાયેલી અને locked; fog area clear થાય જ્યારે કોઈપણ line જેનો body તેને touch કરે તે exit થાય. |
| Ants (Ground) | Fog નીચેની ant lines hidden + locked. |
| Bees (Air) | Fog નીચેની bee lines પણ hidden + locked (ધુમ્મસ બંને layers ઢાંકે). |
| Tall | N/A (cover area, blocker નથી). Hidden lines lane block કરે (own layer). |
| Tap / bump | Fog cell tap ⇒ locked tap. Touching line exit ⇒ fog area fade. |
| Heart effect | Locked tap માં heart નહીં. |
| Hammerable | No (fog). Hidden lines Leaf Blower / Hint target નથી. |
| Hint / solver | Solver hidden information ignore કરે (full info) પણ hidden lines tappable નથી. |
| Visual | સફેદ નરમ ધુમ્મસ layer, clear થાય ત્યારે sun-rays. |
| Audio | Clear: soft wind "whoosh". |
| Implementation | Fog area = cells set; `touches` = any body cell orthogonally adjacent અથવા same cell. Air layer ઉપર દોરાય. |
| Level-design usage | Thursday Fog Day (daily). Reveal ordering puzzles. |

```json
{"id": "o10", "type": "M010", "cells": [[4, 4], [5, 4], [4, 5], [5, 5]], "params": {"area": "f1"}, "hammerable": false}
```

### 3.11 M011 — Petal-Linked Pair (પાંખડીથી જોડાયેલી જોડી)

| Field | Value |
|---|---|
| ID | `M011` (engine rule) |
| Themed name | **Petal-Linked Pair** (પાંખડીથી જોડાયેલી જોડી) — generic: Chained Pair |
| Intro level | **L111** (block 111–120) |
| Category | P — Path-variant |
| Rule | 2 lines linked; કોઈ એક tap ⇒ બંને try; બંનેની lanes clear ન હોય તો બંને bump (કુલ −1 heart). |
| Ants (Ground) | Ant+ant pair. |
| Bees (Air) | Bee+bee pair (L111+). **Pair હંમેશા same layer** (validator). |
| Tall | N/A (path modifier). |
| Tap / bump | Either tap ⇒ joint check; clear ⇒ બંને એકસાથે exit (1 Move). |
| Heart effect | Joint bump = **−1 heart total**. |
| Hammerable | Leaf Blower એક line target કરે ⇒ **બંને** linked lines remove (pair એક unit). |
| Hint / solver | Solver: joint move atom. |
| Visual | બંને heads વચ્ચે ગુલાબી પાંખડી પકડેલી. |
| Audio | Exit: double march/buzz; bump: double bonk single sound. |
| Implementation | `mods.chain` group id; animation બંને paths parallel (≤ 450 ms). Undo બંને restore. |
| Level-design usage | Dependency coupling; bees માં પણ. |

```json
{"id": "p7", "color": "green", "dir": "L", "body": [[3, 1], [4, 1]], "layer": 0, "mods": {"chain": "c1"}}
```

### 3.12 M012 — Napping Line (ઊંઘતી લાઈન)

| Field | Value |
|---|---|
| ID | `M012` (engine rule) |
| Themed name | **Napping Line** (ઊંઘતી લાઈન) — generic: Sleeping Path |
| Intro level | **L121** (block 121–130) |
| Category | P — Path-variant |
| Rule | પહેલો tap જગાડે (1 Move), બીજો tap exit. |
| Ants (Ground) | Ant line nap કરી શકે. |
| Bees (Air) | Bee line nap કરી શકે. |
| Tall | N/A. |
| Tap / bump | 1st tap ⇒ wake (Move +1, lane check નહીં). 2nd tap ⇒ normal exit/bump. |
| Heart effect | Wake tap માં heart નહીં. |
| Hammerable | Line Leaf Blower target. |
| Hint / solver | State: awake flag; S term (extra interactive moves) વધારે. |
| Visual | Zzz bubble; જાગે ત્યારે antennae/પાંખો stretch. |
| Audio | Wake: tiny yawn "mm-hm". |
| Implementation | `mods.sleep`. Wake = Move (counters tick). |
| Level-design usage | Move-count dependent mechanics સાથે parity planning. |

```json
{"id": "p8", "color": "orange", "dir": "D", "body": [[2, 2], [2, 1]], "layer": 1, "mods": {"sleep": true}}
```

### 3.13 M013 — Spinning Daisy (ફરતું ડેઈઝી ફૂલ)

| Field | Value |
|---|---|
| ID | `M013` (engine rule) |
| Themed name | **Spinning Daisy** (ફરતું ડેઈઝી ફૂલ) — generic: Turntable |
| Intro level | **L131** (block 131–140) |
| Category | T — Toggle/Interactive |
| Rule | Line નું head daisy પર; daisy tap ⇒ તે line 90° CW rotate (1 Move). |
| Ants (Ground) | Ant head daisy પર ઊભું હોય ⇒ ant line નું `dir` rotate. |
| Bees (Air) | Bee head daisy પર બેઠું હોય ⇒ bee line rotate. એક daisy પર એક જ head (validator). |
| Tall | `false` (fixed). Daisy cell blocker નથી. |
| Tap / bump | Daisy cell tap ⇒ rotate (tap order #1 — interactive control, [01 §6.5](./01_GAME_CONCEPT_AND_RULES.md)); daisy પરની line ના **બીજા** body cells tap ⇒ exit/bump. Rotation પછી નવો `dir` line ના પોતાના body તરફ હોય ⇒ line **"tangled"**: line tap = locked tap (bump નહીં, heart નહીં) જ્યાં સુધી daisy ફરી rotate ન થાય (Standard §16.19, §17.39). Validator: ant head વાળા daisy ઉપર bee body નહીં. |
| Heart effect | Rotate માં heart નહીં. |
| Hammerable | No. |
| Hint / solver | State: head dir. Rotation: **`dir` 90° CW**, body cells બદલાતા નથી (line head પરથી વળે). Line length ≥ 2 (validator). |
| Visual | સફેદ ડેઈઝી, વચ્ચે પીળું; rotate વખતે પાંખડીઓ ફરે. |
| Audio | Rotate: petal "whirr". |
| Implementation | Daisy = interactive control (tap order #1). Undo dir restore. M045 Root Gear Lever સાથે link. |
| Level-design usage | Direction planning; x9 માં 2–3 daisies. |

```json
{"id": "o13", "type": "M013", "cells": [[4, 3]], "params": {"path": "p2"}, "hammerable": false, "tall": false}
```

### 3.14 M014 — Curled Leaf Deflector (વળેલું પાંદડું)

| Field | Value |
|---|---|
| ID | `M014` (engine rule) |
| Themed name | **Curled Leaf Deflector** (વળેલું પાંદડું) — generic: Mirror |
| Intro level | **L141** (block 141–150) |
| Category | D — Direction changer |
| Rule | `/` અથવા `\` cell; lane 90° વળે. |
| Ants (Ground) | Ant lane વળે. |
| Bees (Air) | `tall: true` (**Tall Reed Leaf**) ⇒ bee lane પણ વળે; `false` ⇒ bees સીધા ઉપરથી. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Lane trace with reflection; loops validator reject. |
| Visual | વળેલું લીલું પાંદડું diagonal; tall = ઊંચું reed. |
| Audio | Turn: leaf "flick". |
| Implementation | `laneCells()` reflection: `/` : R→U, U→R, L→D, D→L; `\` : R→D, D→R, L→U, U→L. Animation line વળાંક follow. |
| Level-design usage | Edge exit choose કરવા. |

```json
{"id": "o14", "type": "M014", "cells": [[6, 2]], "params": {"orient": "/"}, "hammerable": false, "tall": false}
```

### 3.15 M015 — Twig Bridge (ડાળખીનો પુલ)

| Field | Value |
|---|---|
| ID | `M015` (engine rule) |
| Themed name | **Twig Bridge** (ડાળખીનો પુલ) — generic: Bridge |
| Intro level | **L151** (block 151–160) |
| Category | L — Layer |
| Rule | Bridge પર પડેલા line cells perpendicular lanes ને (નીચેથી પસાર થતા) block નથી કરતા. |
| Ants (Ground) | Bridge પર પડેલી ant line, નીચેથી perpendicular ant lane ને block નથી કરતી. |
| Bees (Air) | Bees અસર નહીં (bees ants ને કોઈપણ રીતે નડતાં નથી; bridge ground structure). |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Bridge cell blocked-check: occupant direction ⟂ lane ⇒ pass. |
| Visual | ડાળખીઓનો નાનો પુલ, નીચે માટીનો રસ્તો. |
| Audio | Pass under: hollow wood "tap-tap". |
| Implementation | `axis` H/V: bridge પર line axis પ્રમાણે; ⟂ lanes નીચે. |
| Level-design usage | Ground crossings; layer contrast. |

```json
{"id": "o15", "type": "M015", "cells": [[3, 3]], "params": {"axis": "H"}, "hammerable": false, "tall": false}
```

### 3.16 M016 — Crumbly Dirt Clod (ભરભર માટીનું ઢેફું)

| Field | Value |
|---|---|
| ID | `M016` (engine rule) |
| Themed name | **Crumbly Dirt Clod** (ભરભર માટીનું ઢેફું) — generic: Cracked Rock |
| Intro level | **L161** (block 161–170) |
| Category | C — Counter (Move-based) |
| Rule | HP 1–3; દર વખતે exiting lane orthogonally adjacent cell પરથી પસાર થાય ⇒ −1 HP; HP 0 ⇒ remove. |
| Ants (Ground) | Ant lane block. Adjacent ant exit lanes damage કરે. |
| Bees (Air) | Bees અસર નહીં: bee lane block નહીં, damage પણ નહીં. |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | **Yes**. |
| Hint / solver | State: HP; damage = per exit (એક lane અનેક adjacent cells પસાર કરે તો પણ −1 per exit). |
| Visual | માટીનું ઢેફું, HP મુજબ તિરાડો. |
| Audio | Hit: soil "crunch"; remove: dust puff. |
| Implementation | `onExit(lane)` hook; one decrement per exiting line. |
| Level-design usage | Exit order → unlock sequence. |

```json
{"id": "o16", "type": "M016", "cells": [[5, 5]], "params": {"hp": 2}, "hammerable": true, "tall": false}
```

### 3.17 M017 — Rain-Alert Line (વરસાદ-એલર્ટ લાઈન)

| Field | Value |
|---|---|
| ID | `M017` (engine rule) |
| Themed name | **Rain-Alert Line** (વરસાદ-એલર્ટ લાઈન) — generic: Countdown Path |
| Intro level | **L171** (block 171–180) |
| Category | C — Counter (Move-based) |
| Rule | Line N Moves માં exit થવી જોઈએ; 0 થાય ⇒ −1 heart અને counter N પર reset. |
| Ants (Ground) | Ant line rain-alert હોઈ શકે. |
| Bees (Air) | Bee line rain-alert હોઈ શકે. |
| Tall | N/A. |
| Tap / bump | Normal tap. દરેક Move પછી N−1. |
| Heart effect | Counter 0 ⇒ **−1 Heart** (Shield absorb કરે). Validator: 0-heart solution exists. |
| Hammerable | Line Leaf Blower target. |
| Hint / solver | State: counter; solver ensures exit before 0. |
| Visual | Line ઉપર નાનું વાદળ + badge N; 1 પર વાદળ ઘેરું. |
| Audio | Tick 1: thunder rumble soft; 0: rain splash. |
| Implementation | Move tick. Heart loss event pipeline (Shield → heart). Undo counter restore (heart નહીં). |
| Level-design usage | Priority planning. |

```json
{"id": "p9", "color": "purple", "dir": "R", "body": [[1, 6], [0, 6]], "layer": 0, "mods": {"countdown": {"n": 5}}}
```

### 3.18 M018 — Clover Switch (ક્લોવર સ્વિચ)

| Field | Value |
|---|---|
| ID | `M018` (engine rule) |
| Themed name | **Clover Switch** (ક્લોવર સ્વિચ) — generic: Switch Junction |
| Intro level | **L181** (block 181–190) |
| Category | T — Toggle/Interactive |
| Rule | Cell lane ને state મુજબ L અથવા R વાળે; tap ⇒ toggle (1 Move). |
| Ants (Ground) | Ant lanes વળે. |
| Bees (Air) | Bees અસર નહીં. |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Switch cell tap ⇒ toggle (tap order #1). Line body switch પર ન હોય (validator). |
| Heart effect | Toggle માં heart નહીં. |
| Hammerable | No. |
| Hint / solver | State: L/R; non-monotone. |
| Visual | ચાર પાંદડાંનું clover, arrow state. |
| Audio | Toggle: soft "click-leaf". |
| Implementation | Turn relative to incoming lane dir. |
| Level-design usage | Interactive routing. |

```json
{"id": "o18", "type": "M018", "cells": [[4, 2]], "params": {"state": "L"}, "hammerable": false, "tall": false}
```

### 3.19 M019 — Acorn Pressure Plate (ઓકફળ દબાણ પ્લેટ)

| Field | Value |
|---|---|
| ID | `M019` (engine rule) |
| Themed name | **Acorn Pressure Plate** (ઓકફળ દબાણ પ્લેટ) — generic: Pressure Plate |
| Intro level | **L191** (block 191–200) |
| Category | T — Toggle/Interactive |
| Rule | Linked gate **ખુલ્લો** જ્યાં સુધી કોઈ line body plate ઢાંકે; plate-line exit ⇒ gate બંધ. |
| Ants (Ground) | **માત્ર ant body** plate દબાવી શકે (ground). Closed gate ant lane block. |
| Bees (Air) | Bee body plate ન દબાવે (હવામાં). Gate `tall: true` ⇒ bee lane પણ block. |
| Tall | Plate: `false` (fixed). Gate: per instance default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Gate state derived from plate occupancy (ground) each Move. |
| Visual | Plate પર acorn cap; gate = વેલ. |
| Audio | Gate open: "thunk"; close: rustle. |
| Implementation | Derived state, Undo-safe. |
| Level-design usage | Ant must stay ⇒ bees exit first; layer cooperation. |

```json
[{"id": "o19", "type": "M019", "cells": [[2, 5]], "params": {"role": "plate", "links": ["g3"]}, "hammerable": false, "tall": false}, {"id": "g3", "type": "M019", "cells": [[6, 3]], "params": {"role": "gate"}, "hammerable": false, "tall": true}]
```

### 3.20 M020 — Anthill & Hive Entrance (દર અને મધપૂડાનું પ્રવેશદ્વાર)

| Field | Value |
|---|---|
| ID | `M020` (engine rule) |
| Themed name | **Anthill & Hive Entrance** (દર અને મધપૂડાનું પ્રવેશદ્વાર) — generic: Inner Exit (Hole) |
| Intro level | **L201** (block 201–210) |
| Category | G — Goal/Helper |
| Rule | Internal cell exit તરીકે; lane પહોંચે ⇒ line તેમાં exit. |
| Ants (Ground) | `layer: 0` (**Anthill**) ⇒ ant lanes ત્યાં exit. Hive ant lane ને block કરતું નથી (ઊંચે લટકે). |
| Bees (Air) | `layer: 1` (**Hive**) ⇒ bee lanes ત્યાં exit. Anthill bee lane ને અસર નથી કરતું. |
| Tall | N/A — `params.layer` નક્કી કરે કે કયું layer. |
| Tap / bump | Tap ignore. |
| Heart effect | Exit = no heart. |
| Hammerable | No. |
| Hint / solver | Lane trace stops at matching-layer entrance. |
| Visual | Anthill: માટીનો ઢગલો + દર; Hive: ડાળ પર લટકતો મધપૂડો. |
| Audio | Ants enter: soft "plop"; bees enter hive: happy buzz. |
| Implementation | Interior exits **માત્ર** આ mechanic થી (L201+). |
| Level-design usage | Center-oriented boards. |

```json
{"id": "o20", "type": "M020", "cells": [[5, 5]], "params": {"layer": 1}, "hammerable": false}
```

### 3.21 M021 — Hide-and-Seek Line (સંતાકૂકડી લાઈન)

| Field | Value |
|---|---|
| ID | `M021` (engine rule) |
| Themed name | **Hide-and-Seek Line** (સંતાકૂકડી લાઈન) — generic: Phasing Path |
| Intro level | **L211** (block 211–220) |
| Category | P — Path-variant |
| Rule | Even Move count પર solid; odd પર ghost (non-blocking, not tappable). |
| Ants (Ground) | Ant line: odd ⇒ પાંદડાં નીચે સંતાય. |
| Bees (Air) | Bee line: odd ⇒ ફૂલ પાછળ સંતાય. |
| Tall | N/A. |
| Tap / bump | Ghost tap ⇒ locked tap. |
| Heart effect | Locked tap માં heart નહીં. |
| Hammerable | Solid હોય ત્યારે Leaf Blower target. |
| Hint / solver | State: global move parity. |
| Visual | Ghost = alpha 0.35 + dotted outline. |
| Audio | Phase change: soft "shh". |
| Implementation | Parity = current Move ના increment **પહેલાં** ની `moveCount` (Standard §16.17; start 0 ⇒ solid). Ghost own layer માં block નહીં. |
| Level-design usage | Parity planning. |

```json
{"id": "p10", "color": "teal", "dir": "U", "body": [[3, 6], [3, 7]], "layer": 0, "mods": {"phasing": true}}
```

### 3.22 M022 — Backward-Walking Line (ઊંધી ચાલતી લાઈન)

| Field | Value |
|---|---|
| ID | `M022` (engine rule) |
| Themed name | **Backward-Walking Line** (ઊંધી ચાલતી લાઈન) — generic: Reverse Path |
| Intro level | **L221** (block 221–230) |
| Category | P — Path-variant |
| Rule | Tail-first exit (પાછળ ચાલે); tail પર arrow cue. |
| Ants (Ground) | Ant line backward. |
| Bees (Air) | Bee line backward. |
| Tall | N/A. |
| Tap / bump | Lane = tail થી tail-dir દિશામાં. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | Line target. |
| Hint / solver | Lane computed from tail: tail-dir = `body[len-2] → body[len-1]` direction. |
| Visual | Tail insect પર પાછળ તરફ arrow; head insects પાછળ જોતાં. |
| Audio | Reverse march "tap-tap" ઊલટું. |
| Implementation | Tail-dir = body[-2]→body[-1]. |
| Level-design usage | Misdirection. |

```json
{"id": "p11", "color": "red", "dir": "L", "body": [[4, 1], [5, 1]], "layer": 1, "mods": {"reverse": true}}
```

### 3.23 M023 — Two-Way Scout Line (બંને બાજુ મોં વાળી લાઈન)

| Field | Value |
|---|---|
| ID | `M023` (engine rule) |
| Themed name | **Two-Way Scout Line** (બંને બાજુ મોં વાળી લાઈન) — generic: Two-Head Path |
| Intro level | **L231** (block 231–240) |
| Category | P — Path-variant |
| Rule | બંને છેડે head; tap જે છેડા પાસે ⇒ એ બાજુ exit (nearest-end rule). |
| Ants (Ground) | Ant line. |
| Bees (Air) | Bee line. |
| Tall | N/A. |
| Tap / bump | Tapped cell index < len/2 ⇒ head end; else tail end; exact middle ⇒ `body[0]` end. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | Line target. |
| Hint / solver | Solver: 2 move options per line. |
| Visual | બંને છેડે antennae વાળા head insects; tap કરેલા છેડે હળવો glow. |
| Audio | Normal march/buzz; exit છેડેથી sound pan. |
| Implementation | Tap index map. |
| Level-design usage | Choice puzzles. |

```json
{"id": "p12", "color": "green", "dir": "R", "body": [[3, 3], [2, 3], [1, 3]], "layer": 0, "mods": {"twoHead": true}}
```

### 3.24 M024 — Double-File Line (બે-હરોળ લાઈન)

| Field | Value |
|---|---|
| ID | `M024` (engine rule) |
| Themed name | **Double-File Line** (બે-હરોળ લાઈન) — generic: Wide Path |
| Intro level | **L241** (block 241–250) |
| Category | P — Path-variant |
| Rule | 2-cell-wide body; 2-wide clear lane જોઈએ. |
| Ants (Ground) | Ant double line; બંને lane strips ant blockers થી clear. |
| Bees (Air) | Bee double line; બંને strips bee/tall blockers થી clear. |
| Tall | N/A. |
| Tap / bump | Normal. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | Line target. |
| Hint / solver | Lane = 2 parallel strips; બંને clear જોઈએ (own layer). Validator: body 2×len rectangle. |
| Visual | Insects જોડીમાં કૂચ કરે (ants મોટું પાંદડું ઊંચકે; bees ખભેખભા). |
| Audio | Heavier march / deeper buzz. |
| Implementation | Body ordered pairs. |
| Level-design usage | Space management. |

```json
{"id": "p13", "color": "blue", "dir": "D", "body": [[2, 2], [3, 2], [2, 1], [3, 1]], "layer": 0, "mods": {"wide": true}}
```

### 3.25 M025 — Patrolling Ladybug (પહેરો ભરતી ઢાલકીડી)

| Field | Value |
|---|---|
| ID | `M025` (engine rule) |
| Themed name | **Patrolling Ladybug** (પહેરો ભરતી ઢાલકીડી) — generic: Patrol Blocker |
| Intro level | **L251** (block 251–260) |
| Category | C — Counter (Move-based) |
| Rule | દરેક Move પછી fixed loop પર 1 cell; જ્યાં ઊભી ત્યાં block. |
| Ants (Ground) | Ant lane block. |
| Bees (Air) | Bees અસર નહીં (જમીન પર). |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Tap ignore. Next loop cell પર ant body / ground blocker ⇒ તે Move રાહ જુએ. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | **Yes** — Leaf Blower ladybug ને remove કરે (patrol બંધ; Standard §16.18). |
| Hint / solver | State: index on loop. |
| Visual | લાલ ઢાલકીડી, કાળા ટપકાં; loop ઝાંખા dots. |
| Audio | Step: tiny "tick". |
| Implementation | Move tick after line move resolves. |
| Level-design usage | Timing via move count. |

```json
{"id": "o25", "type": "M025", "cells": [[1, 1], [2, 1], [2, 2], [1, 2]], "params": {"start": 0}, "hammerable": true, "tall": false}
```

### 3.26 M026 — Sugar Crumbs & Nectar Drops (ખાંડના કણ અને મધના ટીપાં)

| Field | Value |
|---|---|
| ID | `M026` (engine rule) |
| Themed name | **Sugar Crumbs & Nectar Drops** (ખાંડના કણ અને મધના ટીપાં) — generic: Collect Gems |
| Intro level | **L261** (block 261–270) |
| Category | G — Goal/Helper |
| Rule | Win માટે બધા gems collect; lane gem પરથી પસાર ⇒ collect. |
| Ants (Ground) | `layer: 0` **Sugar Crumb** ⇒ ant exit lanes collect. |
| Bees (Air) | `layer: 1` **Nectar Drop** ⇒ bee exit lanes collect. |
| Tall | N/A. |
| Tap / bump | Tap ignore. |
| Heart effect | No heart effect. |
| Hammerable | No. |
| Hint / solver | Goal state: remaining gems. |
| Visual | Crumb: સફેદ ચમકતો; Nectar: સોનેરી ટીપું ફૂલ પર. |
| Audio | Collect: "ding". |
| Implementation | Goal counter `goals.gems`. |
| Level-design usage | Route-selection. |

```json
{"id": "o26", "type": "M026", "cells": [[4, 0]], "params": {"layer": 0}, "hammerable": false}
```

### 3.27 M027 — Creeping Moss (ફેલાતી શેવાળ)

| Field | Value |
|---|---|
| ID | `M027` (engine rule) |
| Themed name | **Creeping Moss** (ફેલાતી શેવાળ) — generic: Spreader |
| Intro level | **L271** (block 271–280) |
| Category | C — Counter (Move-based) |
| Rule | દર N Moves પછી first free neighbour (U,R,D,L) માં 1 cell grow. |
| Ants (Ground) | Moss cells ant lane block. Free = ant body નહીં, obstacle નહીં, board ની અંદર. |
| Bees (Air) | Bees અસર નહીં. |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | **Yes, એક cell** — Leaf Blower target કરેલો moss cell જ remove (grown cells સહિત કોઈપણ એક); બાકીના cells અને counter ચાલુ (Standard §16.18). |
| Hint / solver | State: moss set + counter. |
| Visual | લીલી shaggy moss. |
| Audio | Grow: soft squish. |
| Implementation | Order U,R,D,L from each moss cell in insertion order. |
| Level-design usage | Urgency. |

```json
{"id": "o27", "type": "M027", "cells": [[5, 3]], "params": {"n": 3}, "hammerable": true, "tall": false}
```

### 3.28 M028 — Marching Order (કૂચનો ક્રમ)

| Field | Value |
|---|---|
| ID | `M028` (engine rule) |
| Themed name | **Marching Order** (કૂચનો ક્રમ) — generic: Numbered Paths |
| Intro level | **L281** (block 281–290) |
| Category | P — Path-variant |
| Rule | Ascending number order માં exit; wrong ⇒ locked tap. |
| Ants (Ground) | Ant lines numbered. |
| Bees (Air) | Bee lines numbered — numbering **બંને layers માં એક જ sequence**. |
| Tall | N/A. |
| Tap / bump | Wrong number tap ⇒ locked tap. |
| Heart effect | Locked tap માં heart નહીં. |
| Hammerable | Line target (Leaf Blower order rule bypass કરે). |
| Hint / solver | State: next number. |
| Visual | Head પર નંબર badge. |
| Audio | Locked: "tsk". |
| Implementation | Unnumbered lines free. |
| Level-design usage | Strict sequencing. |

```json
{"id": "p14", "color": "yellow", "dir": "U", "body": [[1, 4], [1, 5]], "layer": 1, "mods": {"order": 2}}
```

### 3.29 M029 — Brick Edging (ઈંટની કિનારી)

| Field | Value |
|---|---|
| ID | `M029` (engine rule) |
| Themed name | **Brick Edging** (ઈંટની કિનારી) — generic: Edge Wall |
| Intro level | **L291** (block 291–300) |
| Category | B — Static Blocker |
| Rule | Board edge segments walled; lane edge wall ને મળે ⇒ bump. |
| Ants (Ground) | Ant lane bump. |
| Bees (Air) | `tall: true` (**Hedge Border**) ⇒ bee lane પણ bump; `false` ⇒ bees ઉપરથી ઉડી જાય. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | **No** (standard). |
| Hint / solver | Static edges. |
| Visual | Edge પર ઈંટો / ઊંચી hedge. |
| Audio | Bump: "thud". |
| Implementation | Edge segment = cell+side. |
| Level-design usage | Exit restriction. |

```json
{"id": "o29", "type": "M029", "cells": [[0, 3], [0, 4]], "params": {"side": "L"}, "hammerable": false, "tall": true}
```

### 3.30 M030 — Painted Garden Gate (રંગેલો બગીચા ગેટ)

| Field | Value |
|---|---|
| ID | `M030` (engine rule) |
| Themed name | **Painted Garden Gate** (રંગેલો બગીચા ગેટ) — generic: Color Edge |
| Intro level | **L301** (block 301–310) |
| Category | B — Static Blocker |
| Rule | Edge opening ફક્ત એક color માટે. |
| Ants (Ground) | Non-matching ant lane bump. |
| Bees (Air) | `tall: true` ⇒ non-matching bee lane bump; `false` ⇒ bees ignore. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Static color edge. |
| Visual | રંગીન લાકડાનો ગેટ + glyph. |
| Audio | Pass: gate swing. |
| Implementation | Color check at edge. |
| Level-design usage | Color routing. |

```json
{"id": "o30", "type": "M030", "cells": [[7, 2]], "params": {"side": "R", "color": "red"}, "hammerable": false, "tall": false}
```

### 3.31 M031 — Latching Gate (બંધ થતો ગેટ)

| Field | Value |
|---|---|
| ID | `M031` (engine rule) |
| Themed name | **Latching Gate** (બંધ થતો ગેટ) — generic: Closing Edge |
| Intro level | **L311** (block 311–320) |
| Category | C — Counter (Move-based) |
| Rule | Open edge segment N Moves પછી કાયમ બંધ. |
| Ants (Ground) | બંધ થયા પછી ant lane bump. |
| Bees (Air) | `tall: true` ⇒ બંધ પછી bee lane bump. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | State: N. |
| Visual | ખુલ્લો ગેટ, badge N. |
| Audio | Close: latch "clack". |
| Implementation | Move tick. |
| Level-design usage | Urgency ordering. |

```json
{"id": "o31", "type": "M031", "cells": [[3, 0]], "params": {"side": "U", "n": 6}, "hammerable": false, "tall": false}
```

### 3.32 M004 — Dew Key & Thorn Lock (ઝાકળ ચાવી અને કાંટા તાળું)

| Field | Value |
|---|---|
| ID | `M004` (engine rule) · Standard §10 exception: Game 4 માં **M032 slot (L321)** પર |
| Themed name | **Dew Key & Thorn Lock** (ઝાકળ ચાવી અને કાંટા તાળું) — generic: Key & Lock |
| Intro level | **L321** (block 321–330) |
| Category | K — Key/Lock |
| Rule | Line પર key icon; matching-color Lock cell block કરે જ્યાં સુધી key-line exit ન થાય, પછી કાયમ ખુલે. |
| Ants (Ground) | Lock ant lane block (બંધ હોય ત્યારે). Key ant line પર હોઈ શકે. |
| Bees (Air) | Lock `tall: true` ⇒ bee lane block; key bee line પર પણ હોઈ શકે (cross-layer key valid). |
| Tall | Lock: per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | **No** (Lock not hammerable). Key-line Leaf Blower થી remove ⇒ exit ગણાય ⇒ lock ખુલે. |
| Hint / solver | State: lock open flags. |
| Visual | ઝાકળ ટીપામાં ચાવી; કાંટાની વાડ પર તાળું. |
| Audio | Unlock: chime + thorn retreat. |
| Implementation | Engine rule ID M004. Game 4 માં L321 slot (M032 slot). |
| Level-design usage | Friday Key Hunt (L321+). |

```json
{"id": "o32", "type": "M004", "cells": [[4, 6]], "params": {"color": "blue", "keyPath": "p5"}, "hammerable": false, "tall": false}
```

### 3.33 M033 — Flower-Bud Cage (ફૂલ-કળીનું પાંજરું)

| Field | Value |
|---|---|
| ID | `M033` (engine rule) |
| Themed name | **Flower-Bud Cage** (ફૂલ-કળીનું પાંજરું) — generic: Color Cage |
| Intro level | **L331** (block 331–340) |
| Category | K — Key/Lock |
| Rule | Caged line locked જ્યાં સુધી cage color ની બધી lines exit ન થાય. |
| Ants (Ground) | Ant line caged હોઈ શકે. |
| Bees (Air) | Bee line caged; color count **બંને layers**. |
| Tall | N/A. |
| Tap / bump | Caged tap ⇒ locked tap. |
| Heart effect | Locked tap માં heart નહીં. |
| Hammerable | No (cage). Caged line Leaf Blower target. |
| Hint / solver | State: remaining color count. |
| Visual | Line ફરતે બંધ કળી. |
| Audio | Open: bloom. |
| Implementation | Count includes both layers. |
| Level-design usage | Color dependency. |

```json
{"id": "p15", "color": "green", "dir": "L", "body": [[6, 6], [7, 6]], "layer": 0, "mods": {"cage": "pink"}}
```

### 3.34 M034 — Lily-Pad Rotor (કમળ-પાંદડું રોટર)

| Field | Value |
|---|---|
| ID | `M034` (engine rule) |
| Themed name | **Lily-Pad Rotor** (કમળ-પાંદડું રોટર) — generic: Rotor 2×2 |
| Intro level | **L341** (block 341–350) |
| Category | T — Toggle/Interactive |
| Rule | Rotor tap ⇒ 2×2 contents 90° CW (paths fully inside only). |
| Ants (Ground) | Fully-inside ant lines rotate. |
| Bees (Air) | Fully-inside bee lines rotate. Partial overlap (any layer) ⇒ rotor locked tap. |
| Tall | `false` (fixed). |
| Tap / bump | Hub (4 cells નો shared corner) tap ⇒ rotate (1 Move). Line આંશિક રીતે અંદર ⇒ hub tap = locked tap. Rotation પછી કોઈ line નો head પોતાના body તરફ ⇒ "tangled" locked tap (Standard §16.19). |
| Heart effect | Locked tap માં heart નહીં. |
| Hammerable | No. |
| Hint / solver | State: contents positions. |
| Visual | 4 lily pads ગોળ ગોઠવાયેલા. |
| Audio | Rotate: water swirl. |
| Implementation | Hub hit-test radius 16 dp. |
| Level-design usage | Spatial planning. |

```json
{"id": "o34", "type": "M034", "cells": [[2, 2], [3, 2], [2, 3], [3, 3]], "params": {}, "hammerable": false, "tall": false}
```

### 3.35 M035 — Brood Line (બચ્ચાંની લાઈન)

| Field | Value |
|---|---|
| ID | `M035` (engine rule) |
| Themed name | **Brood Line** (બચ્ચાંની લાઈન) — generic: Spawner Path |
| Intro level | **L351** (block 351–360) |
| Category | P — Path-variant |
| Rule | Exit થાય ત્યારે marked cells માં short child line spawn થાય (cells free હોય તો; નહીં તો free થાય ત્યાં સુધી રાહ — દરેક Move પછી ફરી check). |
| Ants (Ground) | Ant brood line ⇒ child **ant** line. Free = spawn cells માં ant body / ground obstacle નહીં. |
| Bees (Air) | Bee brood line ⇒ child **bee** line. Free = bee body / `tall: true` obstacle નહીં. Child હંમેશા parent ના layer માં. |
| Tall | N/A (path modifier). |
| Tap / bump | Normal tap. Pending child cells પર faint outline; ત્યાં tap ⇒ ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | Line target. Leaf Blower થી removed brood line પણ exit ગણાય ⇒ child spawn થાય. |
| Hint / solver | State: `pendingSpawn` list. Solver: child line એ નવી path; P માં ગણાય. |
| Visual | Line ના છેલ્લા insect પર નાનું સફેદ cocoon; spawn વખતે cocoon ખૂલે. |
| Audio | Spawn: soft "pop" + tiny chirp. |
| Implementation | Spawn Move ના અંતે resolve (counters tick પછી). Undo spawn પણ revert કરે. |
| Level-design usage | Hidden chains: પહેલાં spawn area ખાલી કરો. |

```json
{"id": "p16", "color": "orange", "dir": "R", "body": [[1, 1], [0, 1]], "layer": 0, "mods": {"spawn": {"body": [[4, 4], [4, 5]], "dir": "D", "color": "orange"}}}
```

### 3.36 M036 — Hungry Line (ભૂખી લાઈન)

| Field | Value |
|---|---|
| ID | `M036` (engine rule) |
| Themed name | **Hungry Line** (ભૂખી લાઈન) — generic: Hungry Path |
| Intro level | **L361** (block 361–370) |
| Category | P — Path-variant |
| Rule | Line ત્યારે જ exit થઈ શકે જ્યારે તેની lane food cell પરથી પસાર થાય; food consumed (એક જ વાર). |
| Ants (Ground) | Ant hungry line ⇒ **Snack Crumb** (food `layer: 0`) જોઈએ. |
| Bees (Air) | Bee hungry line ⇒ **Clover Blossom** (food `layer: 1`) જોઈએ. બીજા layer નું food ગણાતું નથી. |
| Tall | Food cell: N/A (blocker નથી; `params.layer` નક્કી કરે). |
| Tap / bump | Lane clear પણ own-layer food વગર ⇒ **bump** (line ભૂખી પાછી ફરે). |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | Line target (food જરૂર નથી). Food cells hammerable નથી. |
| Hint / solver | State: remaining food set. Non-hungry lines food cell પરથી પસાર થાય તો food ખાતી નથી. |
| Visual | Hungry line ના head પર નાનું પેટ icon; crumb સફેદ, clover blossom જાંબલી. |
| Audio | Eat: "munch"; hungry bump: sad bonk. |
| Implementation | Path mod `hungry: true`; food = mechanic M036 instance. Validator: food reachable. |
| Level-design usage | Routing: deflector/portal સાથે food તરફ lane વાળવી. |

```json
{"id": "o36", "type": "M036", "cells": [[2, 0]], "params": {"layer": 1}, "hammerable": false}
```

### 3.37 M037 — Mud Puddle (કાદવનું ખાબોચિયું)

| Field | Value |
|---|---|
| ID | `M037` (engine rule) |
| Themed name | **Mud Puddle** (કાદવનું ખાબોચિયું) — generic: Mud Trap |
| Intro level | **L371** (block 371–380) |
| Category | D — Direction changer |
| Rule | Lane mud cell સુધી પહોંચે ⇒ line ત્યાં અટકે (head mud પર, body follow; relocation = 1 Move); next tap mud થી આગળ continue. |
| Ants (Ground) | Ant lines mud માં અટકે. |
| Bees (Air) | Bees અસર નહીં (ઉપરથી ઉડે). |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Normal tap. Mud પર ઊભેલી line ના next tap પર mud cell ignore (એક વાર). |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | State: line positions change (non-monotone positions). Solver S term વધે. |
| Visual | ભૂરું ચમકતું ખાબોચિયું; અટકેલી ants ના પગ પર કાદવ. |
| Audio | Stop: "squelch". |
| Implementation | Relocated body = lane cells ના છેલ્લા `len` cells. Undo position restore. |
| Level-design usage | Two-step exits; બીજી lines માટે temporary blocker. |

```json
{"id": "o37", "type": "M037", "cells": [[4, 2]], "params": {}, "hammerable": false, "tall": false}
```

### 3.38 M038 — Mushroom Spring (મશરૂમ સ્પ્રિંગ)

| Field | Value |
|---|---|
| ID | `M038` (engine rule) |
| Themed name | **Mushroom Spring** (મશરૂમ સ્પ્રિંગ) — generic: Jump Pad |
| Intro level | **L381** (block 381–390) |
| Category | G — Goal/Helper |
| Rule | Lane pad પરથી પસાર થાય ⇒ આગળનો 1 cell કૂદે (1-cell blocker કૂદી શકે, line નહીં). |
| Ants (Ground) | Ant lanes 1-cell **`tall: false`** blocker કૂદે. Next cell માં line અથવા `tall: true` blocker ⇒ bump. |
| Bees (Air) | Bees અસર નહીં. |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Normal tap. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Lane trace: pad પછીનો cell skip; landing cell blocked ⇒ bump. |
| Visual | લાલ-સફેદ ટપકાંવાળું મશરૂમ. |
| Audio | Jump: "boing". |
| Implementation | Animation: head arc 1 cell ઉપર. |
| Level-design usage | Shortcuts over pebbles. |

```json
{"id": "o38", "type": "M038", "cells": [[3, 4]], "params": {}, "hammerable": false, "tall": false}
```

### 3.39 M039 — Mirror-Twin Lines (આરસી-જોડિયા લાઈનો)

| Field | Value |
|---|---|
| ID | `M039` (engine rule) |
| Themed name | **Mirror-Twin Lines** (આરસી-જોડિયા લાઈનો) — generic: Mirror Twins |
| Intro level | **L391** (block 391–400) |
| Category | P — Path-variant |
| Rule | એક line tap ⇒ twin mirrored દિશામાં move; બંનેની lanes clear જોઈએ, નહીં તો બંને bump. |
| Ants (Ground) | Ant twins (બંને ants). |
| Bees (Air) | Bee twins (બંને bees). Twins **same layer** (validator). |
| Tall | N/A. |
| Tap / bump | Either tap ⇒ joint check (1 Move). |
| Heart effect | Joint bump = **−1 heart total**. |
| Hammerable | Leaf Blower એક target ⇒ બંને twins remove. |
| Hint / solver | Joint move atom; mirror axis V/H. |
| Visual | બંને lines પર ચાંદી જેવી sparkle અને axis dotted line. |
| Audio | Exit: stereo double march/buzz. |
| Implementation | Twin dir = mirror(dir, axis). |
| Level-design usage | Symmetry puzzles. |

```json
{"id": "p17", "color": "pink", "dir": "L", "body": [[2, 3], [3, 3]], "layer": 0, "mods": {"twin": {"id": "t1", "axis": "V"}}}
```

### 3.40 M040 — Twilight Garden (સંધ્યાનો બગીચો)

| Field | Value |
|---|---|
| ID | `M040` (engine rule) |
| Themed name | **Twilight Garden** (સંધ્યાનો બગીચો) — generic: Night Board |
| Intro level | **L401** (block 401–410) |
| Category | G — Goal/Helper |
| Rule | Visual only: છેલ્લી moved line ની આસપાસ (radius 2 cells) અને long-press preview lane જ lit. Rules બદલાતા નથી. |
| Ants (Ground) | Same rules. |
| Bees (Air) | Same rules (bees ની પાંખો હળવી glow). |
| Tall | N/A. |
| Tap / bump | Normal; Scent Trail Preview lit area બતાવે. |
| Heart effect | None. |
| Hammerable | N/A. |
| Hint / solver | Solver unchanged; D માં visibility term નથી. |
| Visual | Dark-blue overlay (pre-rendered radial mask), lit circle. |
| Audio | Night ambience: crickets loop. |
| Implementation | Overlay picture cached; only mask center moves. Accessibility: Settings "Reduce darkness" ⇒ overlay alpha 0.5. |
| Level-design usage | Memory/attention; x5 breather માં નહીં. |

```json
{"schema": 3, "level": 401, "mods": {"night": true}, "mechanics": [{"id": "o40", "type": "M040", "cells": [], "params": {"radius": 2}, "hammerable": false}]}
```

### 3.41 M041 — Rainbow Pollen Line (રંગબદલુ પરાગ લાઈન)

| Field | Value |
|---|---|
| ID | `M041` (engine rule) |
| Themed name | **Rainbow Pollen Line** (રંગબદલુ પરાગ લાઈન) — generic: Chameleon Path |
| Intro level | **L411** (block 411–420) |
| Category | P — Path-variant |
| Rule | Line નો color દરેક Move પછી R→G→B→R cycle થાય; M005 Petal Gate / M030 Painted Garden Gate / M033 Flower-Bud Cage સાથે current color પ્રમાણે interact. |
| Ants (Ground) | Ant line: current color પ્રમાણે ground gates પસાર/bump. |
| Bees (Air) | Bee line: current color પ્રમાણે માત્ર `tall: true` gates ને અસર (LR-4). |
| Tall | N/A (path modifier). |
| Tap / bump | Normal tap; lane check **tap સમયના** color થી (Move count increment પહેલાં). |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | Line target. |
| Hint / solver | Color index = `(startIndex + moveCount) mod 3`; solver state માં move count already છે. |
| Visual | Insects પર પરાગની ધૂળ, color crossfade 200 ms; head પર color glyph પણ બદલાય (●▲■). |
| Audio | Color change: soft wind-chime. |
| Implementation | Color derived (store નહીં) ⇒ Undo આપોઆપ સાચું. M033 cage count માટે chameleon line નો **start color** ગણાય (validator: cage color ≠ chameleon cycle colors, ambiguity ટાળવા). |
| Level-design usage | Gate timing puzzles; Tue Par Moves સાથે સારું. |

```json
{"id": "p18", "color": "red", "dir": "U", "body": [[5, 5], [5, 6]], "layer": 1, "mods": {"chameleon": true}}
```

### 3.42 M042 — Dry Leaf Bridge (સૂકા પાંદડાનો પુલ)

| Field | Value |
|---|---|
| ID | `M042` (engine rule) |
| Themed name | **Dry Leaf Bridge** (સૂકા પાંદડાનો પુલ) — generic: Fragile Bridge |
| Intro level | **L421** (block 421–430) |
| Category | L — Layer |
| Rule | Bridge (M015 rule) 1 crossing allow કરે, પછી **Single Blocker** બની જાય. |
| Ants (Ground) | પહેલી ant lane નીચેથી પસાર ⇒ પાંદડું ખરે ⇒ cell = **Fallen Leaf** blocker (M001 behaviour, `tall: false`). Crossing = perpendicular ant lane પસાર થવી અથવા bridge પરની ant line નું exit. |
| Bees (Air) | Bees અસર નહીં (પહેલાં અને પછી — Fallen Leaf `tall: false`). |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | Bridge state: No. Fallen Leaf blocker: **Yes** (M001 rule). |
| Hint / solver | State: `crossed` flag. Solver: crossing order critical. |
| Visual | સૂકું ભૂરું પાંદડું તિરાડ સાથે; crossing પછી ખરીને જમીન પર પડે. |
| Audio | Crossing: dry-leaf "crunch". |
| Implementation | Crossing પૂર્ણ થાય પછી જ convert; bridge પર line પડેલી હોય ત્યાં સુધી blocker નહીં (Standard §16.12). Hammered line crossing ગણાતી નથી (§16.31). Runtime પર instance ને M001 (`hammerable: true`) માં convert; Undo original restore. |
| Level-design usage | One-shot planning: કઈ line પહેલાં પસાર થાય. |

```json
{"id": "o42", "type": "M042", "cells": [[3, 3]], "params": {"axis": "H"}, "hammerable": false, "tall": false}
```

### 3.43 M043 — Bramble Multi-Lock (કાંટાનું બહુ-તાળું)

| Field | Value |
|---|---|
| ID | `M043` (engine rule) |
| Themed name | **Bramble Multi-Lock** (કાંટાનું બહુ-તાળું) — generic: Multi-Lock |
| Intro level | **L431** (block 431–440) |
| Category | K — Key/Lock |
| Rule | Lock ને 2–3 keys જોઈએ — બધી linked key-lines exit થાય ત્યારે કાયમ ખુલે. |
| Ants (Ground) | બંધ lock ant lane block. |
| Bees (Air) | `tall: true` ⇒ બંધ lock bee lane block; `false` ⇒ bees ignore. Key-lines કોઈપણ layer. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | **No** (lock family not hammerable). Key-line Leaf Blower ⇒ exit ગણાય. |
| Hint / solver | State: remaining keys set. |
| Visual | કાંટાળું તાળું, ઉપર 2–3 key slots; દરેક key આવતાં slot ભરાય. |
| Audio | Key arrive: "click"; open: chime + bramble retreat. |
| Implementation | M004 નું generalization (`keyPaths` list). |
| Level-design usage | Multi-dependency, x9 Hard levels. |

```json
{"id": "o43", "type": "M043", "cells": [[5, 1]], "params": {"keyPaths": ["p2", "p6"], "color": "blue"}, "hammerable": false, "tall": false}
```

### 3.44 M044 — Twisting Burrow (વાંકું દર)

| Field | Value |
|---|---|
| ID | `M044` (engine rule) |
| Themed name | **Twisting Burrow** (વાંકું દર) — generic: Turning Portal |
| Intro level | **L441** (block 441–450) |
| Category | D — Direction changer |
| Rule | Portal pair (M008) જે exit side પર lane direction 90° (`turn`: CW/CCW) rotate કરે. |
| Ants (Ground) | Ant lanes માટે; B પર ant body ⇒ blocked. |
| Bees (Air) | Bees અસર નહીં. |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Lane graph edge with dir rotation; cycles validator reject. |
| Visual | દર ના મોં પર વળાંકવાળો arrow. |
| Audio | Plop + small whirl. |
| Implementation | M008 code reuse + `turn` param. |
| Level-design usage | Long-range routing. |

```json
{"id": "o44", "type": "M044", "cells": [[1, 2], [6, 6]], "params": {"pair": "b", "turn": "CW"}, "hammerable": false, "tall": false}
```

### 3.45 M045 — Root Gear Lever (મૂળિયાંનું ગિયર લીવર)

| Field | Value |
|---|---|
| ID | `M045` (engine rule) |
| Themed name | **Root Gear Lever** (મૂળિયાંનું ગિયર લીવર) — generic: Gear Lever |
| Intro level | **L451** (block 451–460) |
| Category | T — Toggle/Interactive |
| Rule | એક lever tap (1 Move) ⇒ linked બધી Spinning Daisies (M013) એકસાથે 90° CW rotate. |
| Ants (Ground) | Lever cell ant lane block (ground). Daisies પરના ant heads rotate. |
| Bees (Air) | Lever bees ignore. Daisies પરના bee heads પણ rotate. |
| Tall | `false` (fixed). |
| Tap / bump | Lever cell tap (tap order #1) ⇒ rotate all linked. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Combined dir state; non-monotone. |
| Visual | માટીમાંથી નીકળતા મૂળિયાં linked daisies સુધી (thin brown lines). |
| Audio | Gear "grind-click". |
| Implementation | Atomic: બધા rotations એક Move માં; Undo એકસાથે revert. |
| Level-design usage | Coupled directions puzzles. |

```json
{"id": "o45", "type": "M045", "cells": [[0, 0]], "params": {"daisies": ["o13a", "o13b"]}, "hammerable": false, "tall": false}
```

### 3.46 M046 — Ring-Around Line (ગોળ ફરતી લાઈન)

| Field | Value |
|---|---|
| ID | `M046` (engine rule) |
| Themed name | **Ring-Around Line** (ગોળ ફરતી લાઈન) — generic: Loop Path |
| Intro level | **L461** (block 461–470) |
| Category | K — Key/Lock |
| Rule | Closed loop line; linked key-line exit થાય ત્યાં સુધી locked, પછી marked head પર ખૂલીને સામાન્ય line બને. |
| Ants (Ground) | Ant ring (ground). |
| Bees (Air) | Bee ring (air). Key-line કોઈપણ layer. |
| Tall | N/A (path). |
| Tap / bump | Locked હોય ત્યારે tap ⇒ locked tap. ખૂલ્યા પછી normal. |
| Heart effect | Locked tap માં heart નહીં. |
| Hammerable | Line target (locked હોય ત્યારે પણ). |
| Hint / solver | State: open flag; open થાય ત્યારે body order = marked head થી loop direction. |
| Visual | Insects ગોળ ગોળ ધીમે ચાલતાં (idle anim), head સ્થાન પર star marker. |
| Audio | Open: happy chirp (ants) / buzz (bees). |
| Implementation | `body[0]` = marked head; loop closure validator. |
| Level-design usage | Key planning. |

```json
{"id": "p19", "color": "blue", "dir": "R", "body": [[2, 2], [3, 2], [3, 3], [2, 3]], "layer": 0, "mods": {"loop": {"key": "p4"}}}
```

### 3.47 M047 — Recruiting Line (ભરતી કરતી લાઈન)

| Field | Value |
|---|---|
| ID | `M047` (engine rule) |
| Themed name | **Recruiting Line** (ભરતી કરતી લાઈન) — generic: Growing Path |
| Intro level | **L471** (block 471–480) |
| Category | C — Counter (Move-based) |
| Rule | દર N Moves પછી tail પાછળ (tail direction) free cell માં 1 cell grow; blocked ⇒ growth નહીં. |
| Ants (Ground) | Ant line grows; free = no ant body, no ground obstacle, inside board. |
| Bees (Air) | Bee line grows; free = no bee body, no `tall: true` obstacle. |
| Tall | N/A (path modifier). |
| Tap / bump | Normal tap. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | Line target. |
| Hint / solver | State: body length + counter. |
| Visual | નવું insect દોડીને tail સાથે જોડાય; badge N. |
| Audio | Join: "pip". |
| Implementation | Grow after Move resolves; Undo shrinks. |
| Level-design usage | Urgency: lines જે બીજાને block કરવા વધે. |

```json
{"id": "p20", "color": "green", "dir": "U", "body": [[4, 4], [4, 5]], "layer": 1, "mods": {"grow": {"n": 3}}}
```

### 3.48 M048 — Colony Call (વસાહતનો સાદ)

| Field | Value |
|---|---|
| ID | `M048` (engine rule) |
| Themed name | **Colony Call** (વસાહતનો સાદ) — generic: Color Group Tap |
| Intro level | **L481** (block 481–490) |
| Category | P — Path-variant |
| Rule | Group-marked line tap ⇒ same-color group ની બધી lines move; કોઈ એક blocked ⇒ બધી bump. |
| Ants (Ground) | Group ની ant lines ground rules થી check. |
| Bees (Air) | Group માં bee lines હોય તો air rules થી check; group mixed layers હોઈ શકે. |
| Tall | N/A. |
| Tap / bump | Group member tap ⇒ group atom (1 Move). |
| Heart effect | Group bump = **−1 heart total**. |
| Hammerable | Leaf Blower ⇒ **માત્ર target line** remove (group નહીં). |
| Hint / solver | Group atom move; group members ના lanes એકબીજાને block કરે તો (same layer) ⇒ blocked ગણાય (simultaneous move નથી, પહેલાંની state પર check). |
| Visual | Group lines ના head પર નાનું leaf-horn icon + group color ring. |
| Audio | Chorus march (ants) / chorus buzz (bees). |
| Implementation | Parallel animation, total ≤ 450 ms. Undo આખું group restore. |
| Level-design usage | Group sequencing: પહેલાં group ની lanes ખાલી કરો. |

```json
{"id": "p21", "color": "yellow", "dir": "D", "body": [[6, 1], [6, 0]], "layer": 0, "mods": {"group": "yellow"}}
```

### 3.49 M049 — Great Orb Spider (મોટો કરોળિયો)

| Field | Value |
|---|---|
| ID | `M049` (engine rule) |
| Themed name | **Great Orb Spider** (મોટો કરોળિયો) — generic: Guardian |
| Intro level | **L491** (block 491–500) |
| Category | X — Boss |
| Rule | Multi-cell blocker (2×2 web), HP = linked lines count; દરેક linked line exit ⇒ −1 HP; 0 ⇒ spider ચાલ્યો જાય. |
| Ants (Ground) | Ant lane block. |
| Bees (Air) | Bee lane block (web ઊંચે સુધી ફેલાયેલું). |
| Tall | `true` (fixed) — બંને layers. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | **No**. |
| Hint / solver | HP state; linked lines mixed layers હોઈ શકે. Validator: linked lines spider ના cells થી block ન થવી જોઈએ (નહીં તો deadlock). |
| Visual | મિત્રતાભર્યો (ડરામણો નહીં) મોટો કરોળિયો 2×2 web પર, ઉપર HP pips; linked lines પર silk thread marker. |
| Audio | HP hit: web "twang"; vanish: spider દોરી પર ઉપર ચઢી જાય + sparkle. |
| Implementation | Air layer ઉપર અલગ boss sprite layer માં render (web ground cells અને bees બંને ઉપર). HP 0 ⇒ cells free. |
| Level-design usage | L491 intro; Sunday Mini Boss (daily); L500 Queen's Garden Gala. |

```json
{"id": "o49", "type": "M049", "cells": [[4, 4], [5, 4], [4, 5], [5, 5]], "params": {"links": ["p1", "p2", "p7"]}, "hammerable": false, "tall": true}
```

### 3.50 Phase 1 Finale — Queen's Garden Gala (L500)

| Field | Value |
|---|---|
| ID | — (Finale, category X) |
| Intro level | **L500** |
| Rule | **Great Orb Spider (M049)** + Phase 1 ના **≥ 8** બીજા mechanics નો mix. Tag `finale`, D = T5 high +20% (≈ 62). |
| Ants / Bees | બંને layers ફરજિયાત (≥ 30% bee lines); spider linked lines બંને layers માં. |
| Tall | Spider `true`; બાકીના instances designer પ્રમાણે. |
| Heart / hammer | Standard rules; spider not hammerable. 0 hearts / 0 boosters solvable (validator). |
| Reward | **Royal Honey Chest** (Phase Chest): 1,000 coins + 2 of each booster + "Garden Trails I" phase badge; Finale clear coins 50. |
| Design | [02 §6 Phase Finale](./02_LEVEL_PROGRESSION_0001_0500.md). |

## 4. CI Validator Rules per Mechanic (CI ચકાસણી)

| Check | Applies to |
|---|---|
| Level solvable with 0 hearts lost & 0 boosters (solver) | બધા |
| Intro level માં માત્ર intro mechanic + ≤ 1 earlier mechanic | દરેક x1 |
| `tall: true` માત્ર L42+ અને `layers: 2` levels માં | Per-instance tall mechanics |
| Bee body `tall: true` cell પર નહીં; એક layer માં એક cell = max 1 body | M032 + બધા |
| Chain/twin/brood child same layer | M011, M035, M039 |
| Portal / deflector lane loops નહીં | M008, M014, M044 |
| Daisy પર exactly 1 head, line length ≥ 2; switch/lever cells પર line body નહીં | M013, M018, M009, M045 |
| Countdown line 0 પહેલાં exit possible (no forced damage) | M017 |
| Key/lock: key-line ક્યારેય તેના જ lock થી permanently blocked નહીં | M004, M043, M046 |
| Fog: દરેક fog area ને touch કરતી ઓછામાં ઓછી 1 visible line | M010 |
| Guardian linked lines spider cells થી blocked નહીં | M049 |
| L1–40 માં `layers: 1`; L1–320 માં M004 type નહીં | Schedule (swap) |

Unit tests per M-ID: [07 §13](./07_FRONTEND_IMPLEMENTATION_AND_QA.md).

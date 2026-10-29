# 03 — Obstacle Catalog, Phase 2 (M051–M099)
Phase 2 ના બધા 49 mechanics + L1000 Finale — દરેક card Standard §10 ના ફરજિયાત fields + Game 4 ના **Ants / Bees / Tall** fields + **Edge cases** સાથે.

**Related docs:** [Shared Core Standard §10, §16](../../SHARED_CORE_STANDARD.md) · [Phase 2 README](./README.md) · [01 Phase 2 Rules](./01_PHASE_2_SCOPE_AND_RULES.md) · [02 Level Progression 501–1000](./02_LEVEL_PROGRESSION_0501_1000.md) · [06 Frontend & QA](./06_FRONTEND_AND_QA_PHASE_2.md) · [Phase 1 Catalog](../phase_1/03_OBSTACLE_CATALOG_PHASE_1.md)

---

## 1. How to Read This Catalog (આ catalog કેવી રીતે વાંચવો)

### 1.1 Layer rule (3 layers from L691)
Phase 1 Layer Rule ([phase_1/01 §5](../phase_1/01_GAME_CONCEPT_AND_RULES.md)) યથાવત્. Phase 2 extension ([01 §5](./01_PHASE_2_SCOPE_AND_RULES.md)):

| Layer | `layer` | Who | Lane blocked by |
|---|---|---|---|
| Ground | 0 | Ant lines | Ant lines + **બધા** blocking mechanics (`tall` ગમે તે) |
| Air | 1 | Bee lines | Bee lines + `tall: true` mechanics |
| Canopy (L691+, M069) | 2 | Canopy Scout Bee lines | Canopy lines + `tall: true` mechanics |

- Engine formula યથાવત્ (Standard §16.28): `blocks(m, line) = m.layerAffects(line.layer)`, default `layerAffects(l) = l == 0 || m.tall`. Lines માત્ર **પોતાના layer** ની lines સાથે collide.
- **Cover lock:** line locked જ્યાં સુધી કોઈ **ઊંચા layer** ની line તેના body cell ને ઢાંકે. **Tap priority:** canopy > air > ground (controls સૌથી પહેલાં).
- `params.layer` વાળા mechanics (M020, M056, M061, M084, M087) tall ને બદલે layer param વાપરે.

### 1.2 Card fields
- **Tall** field: `false (fixed)` = ant-only · `true (fixed)` = ત્રણેય layers · `Per instance` = designer set કરે (default `false`) · `N/A` = path modifier / area / layer param.
- **Bees** field air (L1) અને canopy (L2) બંને આવરે છે; canopy ફક્ત L691+ levels માં હોય.
- **Edge cases** field: Standard માં જે ખુલ્લું હતું તે અહીં **binding** રીતે define કર્યું (સૂચિ §5).

### 1.3 JSON conventions (schema v3)
- Cell mechanic: `{"id","type":"M0xx","cells","params","hammerable","tall"}` — `type` = engine rule ID. `tall` optional (default `false`).
- Path variant (M051, M065, M066, M068, M073, M081, M092, M093, M096): Phase 1 જેમ path ના `mods` / `dir` માં encode (કોઈ `type` entry નહીં). Level-wide (M069 `layers: 3`, M072 pattern, M078 greenhouse, M079 rotator) mechanic entry `cells: []` સાથે.
- `dir` values: `U, D, L, R, UL, UR, DL, DR` (L511+). `layer`: 0 / 1 / 2.

### 1.4 Hammerable (Leaf Blower) — Standard §16.18
Phase 2 માં obstacle remove માત્ર: **M053 Rolling Acorn / Garden Pumpkin** (M054 leaf પર હોય તો પણ), **M097 પહેલો toadstool (d1)**. બાકીના બધા Phase 2 mechanics (gates, plates, locks, edges, lenses, mirrors, Old Stone Wall M074, Great Stag Beetle M098) **not hammerable**. Lines હંમેશા target (visible, Standard §16.8).

### 1.5 Difficulty weight
D formula ([Standard §9.4](../../SHARED_CORE_STANDARD.md)) માં દરેક instance `O` માં ગણાય; Summary table નો **N** column = `Yes` હોય તો instance `N` (non-monotone) માં પણ ગણાય.

## 2. Summary Table (સારાંશ)

| # | Intro | ID | Themed name | Generic | Cat | Ants | Bees (air/canopy) | Tall | Hammer | N |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | L511 | **M051** | Diagonal Dash Lines | Diagonal Paths | P | Diagonal | Diagonal | N/A | No | — |
| 2 | L521 | **M052** | Pinecone Bumper | Corner Bumper | D | Deflect diag / block orth | If tall | Per inst. | No | — |
| 3 | L531 | **M053** | Rolling Acorn | Push Block | T | Push | Push if tall | Per inst. | Yes | Yes |
| 4 | L541 | **M054** | Dew-Slick Lily Leaf | Ice Floor | D | Blocks slide | No | false | Block on it: Yes | — |
| 5 | L551 | **M055** | Seed Socket Plate | Block Plate | T | Plate+gate | Gate if tall | Gate per inst. | No | Yes |
| 6 | L561 | **M056** | Dandelion Lift | Ramp | L | To air | To ground / canopy | `pair` param | No | — |
| 7 | L571 | **M057** | Sleepy Tulip Gate | Traffic Light | C | Periodic block | If tall | Per inst. | No | Yes |
| 8 | L581 | **M058** | Spinning Seed Arrow | Rotating Arrow | D | Rotating one-way | If tall | Per inst. | No | Yes |
| 9 | L591 | **M059** | Pollen Paint Patch | Paint Cell | P | Recolor | If tall | Per inst. | No | — |
| 10 | L601 | **M060** | Twin Mushroom Swap | Swap Pad | T | Swap | Swap | false | No | Yes |
| 11 | L611 | **M061** | Little Anthill & Mini Hive | Capacity Hole | G | Exit ×N | Exit ×N (hive) | `layer` param | No | — |
| 12 | L621 | **M062** | Flower Bed Delivery | Edge Quota | G | Goal | Goal | N/A | No | — |
| 13 | L631 | **M063** | Sugar Cube Lure | Magnet Blocker | C | Pull+block | If tall | Per inst. | No | Yes |
| 14 | L641 | **M064** | Seesaw Twig Gates | Seesaw Gates | T | Alternate | If tall | Per inst. | No | Yes |
| 15 | L651 | **M065** | Buried Dew Key | Hidden Key | K | Hidden key | Hidden key | Lock per inst. | No | — |
| 16 | L661 | **M066** | Petal-Linked Trio | Chained Triplet | P | Group | Group | N/A | No | — |
| 17 | L671 | **M067** | Crumbling Soil Patch | Collapsing Floor | C | Collapse | No | false | No | Yes |
| 18 | L681 | **M068** | Honey-Drip Line | Trail Blocker | C | Trail | Trail (own layer) | N/A | No | Yes |
| 19 | L691 | **M069** | Canopy Scout Bees | Three Layers | L | Cover-lock | Air + canopy | N/A | No | — |
| 20 | L701 | **M070** | Compass Flower Lever | Global Rotator | T | Rotate dir | Rotate dir | false | No | Yes |
| 21 | L711 | **M071** | Counting Hedge Gap | Quota Edge | B | Bump until Q | If tall | Per inst. | No | — |
| 22 | L721 | **M072** | Garland Order | Color Sequence | P | Order | Order (shared) | N/A | No | — |
| 23 | L731 | **M073** | Dew Bubble Line | Bubble Path | P | Absorb 1 bump | Absorb 1 bump | N/A | No | — |
| 24 | L741 | **M074** | Old Stone Wall | Armored Wall | B | Block | If tall | Per inst. | No | Yes |
| 25 | L751 | **M075** | Creeping Mist | Creeping Fog | C | Spread+hide | Spread+hide | N/A | No | Yes |
| 26 | L761 | **M076** | Burrow Network | Portal Network | D | Teleport cycle | No | false | No | — |
| 27 | L771 | **M077** | Puffball Mushroom | Bomb Blocker | X | Block→clear 3×3 | If tall | Per inst. | No | — |
| 28 | L781 | **M078** | Greenhouse Garden | Center-Only Exit | B | Edges walled | Edges walled | true | No | — |
| 29 | L791 | **M079** | Turning Flower Bed | Board Rotator | T | Rotate board | Rotate board | N/A | No | Yes |
| 30 | L801 | **M080** | Twin Thorn Locks | Twin Locks | K | Lock | If tall | Per inst. | No | — |
| 31 | L811 | **M081** | Copycat Line | Mimic Path | P | Copy dir | Copy dir | N/A | No | Yes |
| 32 | L821 | **M082** | Trickling Brook | Conveyor | D | Drift | No | false | No | Yes |
| 33 | L831 | **M083** | Stone Slab Plate | Heavy Plate | T | Wide-only plate | Gate if tall | Gate per inst. | No | Yes |
| 34 | L841 | **M084** | Sunbeam Lens | Laser Emitter | B | Beam (L0) | Beam (L1/L2) | Per inst. + `layer` | No | — |
| 35 | L851 | **M085** | Sun-Seeker Sunflower | Laser Receiver | T | Receiver | If tall | Per inst. | No | Yes |
| 36 | L861 | **M086** | Beetle-Shell Mirror | Beam Mirror | D | Reflect | If tall | Per inst. | No | — |
| 37 | L871 | **M087** | Tree Sap Drop | Glue Pad | P | Stick | Stick (layer param) | `layer` param | No | Yes |
| 38 | L881 | **M088** | Bramble Snare | Lane Mine | K | Block until key | If tall | Per inst. | No | — |
| 39 | L891 | **M089** | Dew Prism | Prism | D | Split beam / block | If tall | Per inst. | No | — |
| 40 | L901 | **M090** | Firefly Lantern Gate | Parity Gate | C | Parity block | If tall | Per inst. | No | Yes |
| 41 | L911 | **M091** | Giant Lily-Pad Rotor | Rotor 3×3 | T | Rotate | Rotate | false | No | Yes |
| 42 | L921 | **M092** | Caravan Line | Segmented Path | P | Multi-tap | Multi-tap | N/A | No | Yes |
| 43 | L931 | **M093** | Scatter Line | Splitter Path | P | Split | Split | N/A | No | Yes |
| 44 | L941 | **M094** | Petal Mixing Bowl | Color Mixer | P | Mix color | If tall | Per inst. | No | — |
| 45 | L951 | **M095** | Colored Hedge Gap | Color Quota Edge | B | Bump until color Q | If tall | Per inst. | No | — |
| 46 | L961 | **M096** | Dusk Shadow Line | Shadow Path | P | Parity visible | Parity visible | N/A | No | Yes |
| 47 | L971 | **M097** | Toppling Toadstools | Domino Chain | B | Block, chain clear | If tall | Per inst. | d1 only | — |
| 48 | L981 | **M098** | Great Stag Beetle | Moving Guardian | X | Block+patrol | Block+patrol | true | No | Yes |
| 49 | L991 | **M099** | Royal Hive Door | Master Lock | K | Lock | If tall | Per inst. (def. true) | No | — |
| — | L1000 | — | **Queen's Midsummer Jubilee** (Phase 2 Finale) | Phase 2 Finale | X | Mixed | Mixed | — | — | — |

## 3. Mechanic Cards (દરેક mechanic નું card)

### 3.1 M051 — Diagonal Dash Lines (ત્રાંસી દોડતી લાઈનો)

| Field | Value |
|---|---|
| ID | `M051` (engine rule) |
| Themed name | **Diagonal Dash Lines** (ત્રાંસી દોડતી લાઈનો) — generic: Diagonal Paths |
| Intro level | **L511** (block 511–520) |
| Category | P — Path-variant |
| Rule | Head `dir` 8 દિશામાંથી એક: `U, D, L, R, UL, UR, DL, DR`. Diagonal lane = head ના diagonal આગળના cell થી `(dx, dy)` પગલે board બહાર સુધી. Body cells 8-connected (orthogonal અથવા diagonal link). **No cutting:** diagonal પગલું `a → b` blocked જો `(a.x+dx, a.y)` અને `(a.x, a.y+dy)` બંને cells **એક જ same-layer line ના consecutive body cells** હોય (બીજી line ની diagonal link કાપી ન શકાય). Obstacles વચ્ચેથી diagonal squeeze allowed. |
| Ants (Ground) | Ant diagonal lines; lane ને ant lines + બધા obstacles block (LR-3). |
| Bees (Air / Canopy) | Bee diagonal lines (L1); lane ને bee lines + `tall: true` block (LR-4). Canopy (L2, L691+): canopy diagonal lines પણ, same rule own layer માં. |
| Tall | N/A (path variant). |
| Tap / bump | Normal tap. Diagonal lane blocked ⇒ head blocker ની પહેલાંના cell સુધી જાય અને bonk. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | Line target (Leaf Blower). |
| Hint / solver | Lane trace `step(dx,dy)`; no-cutting check solver અને runtime બંનેમાં એક જ function. Reverse construction diagonal lanes માટે પણ valid. |
| Visual | Head insect નું માથું 45° ફરેલું; diagonal links પર body segments 45° rotate; Scent Trail Preview diagonal dotted. |
| Audio | Ants: ઝડપી "tip-tip" zigzag march; bees: ઊંચો "bzz". |
| Implementation | `Dir8 {u, d, l, r, ul, ur, dl, dr}` with `(dx, dy)`; Phase 1 `Dir` values same names ⇒ old JSON unchanged. Corner exit: [01 §5.3](./01_PHASE_2_SCOPE_AND_RULES.md). |
| Level-design usage | L511 intro: 4–6 diagonal ant lines + orthogonal lines, no obstacles; L512+ diagonal bees. Phase 2 બધા blocks માં 10–30% lines diagonal. |
| Edge cases | Corner exit (corner cell થી diagonal બહાર) = બંને edges cross ⇒ કોઈ એક edge segment walled હોય તો bump. M006/M014/M086 cell પર diagonal lane ⇒ bump (orthogonal-only devices). M024 Wide lines diagonal નહીં (validator). |
| D weight | O |

```json
{"id": "p1", "color": "red", "dir": "UR", "body": [[3, 6], [2, 7], [1, 8]], "layer": 0, "mods": {}}
```

### 3.2 M052 — Pinecone Bumper (પાઈનકોનનો બમ્પર)

| Field | Value |
|---|---|
| ID | `M052` (engine rule) |
| Themed name | **Pinecone Bumper** (પાઈનકોનનો બમ્પર) — generic: Corner Bumper |
| Intro level | **L521** (block 521–530) |
| Category | D — Direction changer |
| Rule | Diagonal lane bumper cell માં પ્રવેશે ⇒ ત્યાંથી 90° વળીને આગળ વધે: `params.turn` = `cw` (UR→DR→DL→UL→UR) અથવા `ccw`. Bumper cell પોતે diagonal lane માટે passable. **Orthogonal lane** માટે bumper = blocker (bump). |
| Ants (Ground) | Ant diagonal lane વળે; ant orthogonal lane bump. |
| Bees (Air / Canopy) | `tall: true` (**Tall Pine Bumper**) ⇒ bee/canopy diagonal lanes વળે, orthogonal bump. `tall: false` ⇒ bees ઉપરથી, કોઈ અસર નહીં. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Lane trace turn; loop detection `(cell, dir, layer)` visited set ⇒ validator reject. Beams માટે bumper = beam stop. |
| Visual | ભૂરો pinecone, ઉપર વળાંક-arrow (cw/ccw) glyph. |
| Audio | Deflect: "pok" wooden tick. |
| Implementation | `CornerBumper.redirect(dir) => turn == cw ? dir.rotCw() : dir.rotCcw()` (diagonal only). |
| Level-design usage | Diagonal lines ને ખૂણે ફેરવી બીજી edge પર exit; 2 bumpers ⇒ U-turn routes. |
| Edge cases | Lane બીજા bumper પર ફરી વળે (chain). Bumper board edge પર હોય અને turn પછી તરત board બહાર ⇒ exit valid. Diagonal pass-through લાઈન body bumper cell પર મૂકી શકાય નહીં (validator). |
| D weight | O |

```json
{"id": "o52", "type": "M052", "cells": [[6, 3]], "params": {"turn": "cw"}, "hammerable": false, "tall": false}
```

### 3.3 M053 — Rolling Acorn (ગબડતું ઓકફળ)

| Field | Value |
|---|---|
| ID | `M053` (engine rule) |
| Themed name | **Rolling Acorn** (ગબડતું ઓકફળ) — generic: Push Block |
| Intro level | **L531** (block 531–540) |
| Category | T — Toggle/Interactive |
| Rule | Lane (clear) block સુધી પહોંચે ⇒ block lane દિશામાં **1 cell** ખસે **જો પાછળનો cell free હોય**; line પોતાની જગ્યાએ જ રહે (1 Move, heart નહીં). Free ન હોય ⇒ normal bump. Free cell = board અંદર, block ને અસર કરતા layers માં કોઈ line body નહીં, કોઈ blocker/બીજો block નહીં, અને underlying cell **ખાલી / M054 / M055** જ (holes, portals, gates, plates M019/M083 = not free). Board બહાર ધકેલી શકાય નહીં. |
| Ants (Ground) | Ant lane Rolling Acorn ને ધકેલે; ant lane માટે block = blocker. |
| Bees (Air / Canopy) | `tall: false` (Acorn) ⇒ bees ઉપરથી, ધકેલી ન શકે. `tall: true` (**Garden Pumpkin**) ⇒ ant, bee અને canopy lanes ત્રણેય ધકેલી શકે; destination બધા layers માં free જોઈએ. |
| Tall | Per instance; default `false`. |
| Tap / bump | Block tap ignore. Line tap ⇒ push (જો block પહેલો blocker અને પાછળ free) અથવા bump. |
| Heart effect | Push = heart નહીં. Push શક્ય નહીં ⇒ normal bump (−1 Heart). |
| Hammerable | **Yes** (Standard §16.18). |
| Hint / solver | Non-monotone: block positions state માં. Solver push ને Move તરીકે expand કરે; Sokoban-style dead squares precompute (corner) ⇒ pruning. |
| Visual | ચળકતું ભૂરું acorn cap સાથે; Pumpkin ઊંચું નારંગી + wing marker. Push: 1-cell roll animation 300 ms. |
| Audio | Push: "thud-roll"; blocked: bonk. |
| Implementation | `PushBlock{cell}`; action resolve માં `tryPush(dir)`. Diagonal lane ⇒ diagonal push (diagonal destination free જોઈએ). |
| Level-design usage | Blocker જે line પોતે ખસેડી શકે; બે-પગલાં ordering (push, પછી exit). Plates (M055) સાથે combo. |
| Edge cases | એક જ lane માં બે blocks સળંગ ⇒ પહેલો block પાછળ બીજો block ⇒ not free ⇒ bump (chain push નહીં). Chained pair (M011) માં એક member push કરે અને બીજો exit/bump ⇒ group atom: કોઈ member bump ⇒ આખું group bump (push પણ નહીં). |
| D weight | O + N |

```json
{"id": "o53", "type": "M053", "cells": [[5, 4]], "params": {}, "hammerable": true, "tall": false}
```

### 3.4 M054 — Dew-Slick Lily Leaf (ઝાકળથી લપસણું કમળ-પાન)

| Field | Value |
|---|---|
| ID | `M054` (engine rule) |
| Themed name | **Dew-Slick Lily Leaf** (ઝાકળથી લપસણું કમળ-પાન) — generic: Ice Floor |
| Intro level | **L541** (block 541–550) |
| Category | D — Direction changer |
| Rule | Push થયેલો block slick cell પર આવે ⇒ એ જ દિશામાં સરકતો રહે જ્યાં સુધી (a) આગળનો cell free ન હોય (M053 free definition) અથવા (b) block non-slick cell પર પહોંચે (ત્યાં અટકે). Lines પર કોઈ અસર નહીં. |
| Ants (Ground) | Ant lines slick leaf પર સામાન્ય રીતે ચાલે/ઊભી રહે (ants ને પકડ છે). |
| Bees (Air / Canopy) | Bees/canopy ને અસર નહીં. Tall Pumpkin block પણ slick leaf પર સરકે (leaf જમીન પર છે). |
| Tall | `false` (fixed) — floor mechanic; blocks નો tall ગમે તે હોય slide થાય. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No (leaf). Leaf પરનો block hammerable (§16.18). |
| Hint / solver | Slide deterministic; solver push successor માં slide end compute કરે. |
| Visual | ચમકતું લીલું lily leaf, ઝાકળ ટીપાં; slide motion blur sprite (pre-baked). |
| Audio | Slide: "swish". |
| Implementation | `slideEnd(start, dir)` loop; animation ≤ 450 ms (લાંબી slide speed વધે). |
| Level-design usage | Block ને દૂરના plate સુધી પહોંચાડવો; slide ને રોકવા lines/blockers વાપરવા. |
| Edge cases | Slide board edge પર: છેલ્લા cell પર અટકે (બહાર ન પડે). Slide દરમિયાન block beam (M084) ના cell પરથી પસાર: final position પરથી જ beam recompute (step 4). |
| D weight | O |

```json
{"id": "o54", "type": "M054", "cells": [[2, 2], [3, 2], [4, 2], [5, 2]], "params": {}, "hammerable": false, "tall": false}
```

### 3.5 M055 — Seed Socket Plate (બીજ-ખાંચ પ્લેટ)

| Field | Value |
|---|---|
| ID | `M055` (engine rule) |
| Themed name | **Seed Socket Plate** (બીજ-ખાંચ પ્લેટ) — generic: Block Plate |
| Intro level | **L551** (block 551–560) |
| Category | T — Toggle/Interactive |
| Rule | Push block (M053) plate પર ઊભો હોય **ત્યાં સુધી** linked gates ખુલ્લા; block ખસે ⇒ gates બંધ. Line body plate દબાવતો નથી. |
| Ants (Ground) | Plate cell ant lane block નથી કરતો (ખાલી plate passable). Closed gate ant lane block. |
| Bees (Air / Canopy) | Plate bees ને અસર નહીં. Gate `tall: true` ⇒ bee/canopy lane પણ block. |
| Tall | Plate: `false` (fixed). Gates: per instance, default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No (plate, gate). |
| Hint / solver | Derived state step (4a); state = block positions. |
| Visual | માટીમાં acorn આકારનો ખાંચ; gate = વેલનો દરવાજો; block બેસે ત્યારે "click" glow. |
| Audio | Seat: soft "clunk"; gate open: vine rustle. |
| Implementation | Plate = `BlockPlate{links}`; gate reuse `ToggleGate` (role gate). Undo safe (derived). |
| Level-design usage | Push puzzles નો goal: block ને plate પર રાખો, પછી gate પાછળની lines exit. |
| Edge cases | Slide (M054) plate પરથી પસાર થઈ આગળ જાય ⇒ plate press નહીં (final cell જ ગણાય). Gate cell પર line body હોય અને gate બંધ થાય ⇒ allowed (gate માત્ર lanes block કરે; body અંદર રહે). |
| D weight | O + N |

```json
[{"id": "o55", "type": "M055", "cells": [[7, 7]], "params": {"role": "plate", "links": ["g55"]}, "hammerable": false, "tall": false}, {"id": "g55", "type": "M055", "cells": [[2, 9]], "params": {"role": "gate"}, "hammerable": false, "tall": true}]
```

### 3.6 M056 — Dandelion Lift (ડેંડિલાયનની ઉડાન)

| Field | Value |
|---|---|
| ID | `M056` (engine rule) |
| Themed name | **Dandelion Lift** (ડેંડિલાયનની ઉડાન) — generic: Ramp |
| Intro level | **L561** (block 561–570) |
| Category | L — Layer |
| Rule | Lane ramp cell માં પ્રવેશે ⇒ ramp ના `params.pair: [a, b]` ના બીજા layer માં ચાલુ રહે (a→b, b→a). Ramp cell incoming layer માં check થાય; પછીના cells નવા layer માં. L561–690: pair હંમેશા `[0, 1]`; L691+ `[1, 2]` પણ. |
| Ants (Ground) | Ant lane ramp પર ⇒ ડેંડિલાયનના રૂ પર ચઢી **air layer** માં ઉડે; આગળ bee lines + tall obstacles જ block. |
| Bees (Air / Canopy) | Bee lane `[0,1]` ramp પર ⇒ નીચે ઉતરી **ground** પર ચાલે; આગળ ant lines + બધા obstacles block. Canopy (L2, L691+): `[1,2]` ramp = **Warm Updraft**: air ⇄ canopy. |
| Tall | N/A — `params.pair` layers નક્કી કરે (tall field ignore). |
| Tap / bump | Tap ignore. Lane નવા layer માં blocked ⇒ head blocker પહેલાં bonk, આખી line મૂળ જગ્યાએ (layer પણ મૂળ). |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Lane trace `(cell, layer)` state; validator: lane એક Move માં max 2 ramps; loop reject. |
| Visual | Ground પર સફેદ dandelion puff; updraft = હળવા ગરમ હવાના swirls. Line ramp પાર કરે ત્યારે segments ઊંચાઈ/shadow interpolate. |
| Audio | Lift: soft "fwoosh"; landing: "pat". |
| Implementation | Exit થાય ત્યારે line remove; relocation (M037 mud) નવા layer માં થાય તો line નું `layer` permanently બદલાય — destination cells નવા layer માં free જોઈએ, નહીં તો bump. |
| Level-design usage | Ants ને ground blockers ની ઉપરથી કાઢવા; bees ને tall wall નીચેથી. Layer swap thinking. |
| Edge cases | Ramp cell પર line body હોય તો body નું layer બદલાતું નથી (માત્ર lanes). Ramp પછી ના cell પર ઊંચા layer ની line હોય ⇒ નવો layer blocked. Cover-lock relocation પછી નવી રીતે compute. |
| D weight | O |

```json
{"id": "o56", "type": "M056", "cells": [[4, 6]], "params": {"pair": [0, 1]}, "hammerable": false}
```

### 3.7 M057 — Sleepy Tulip Gate (ઊંઘણશી ટ્યૂલિપ ગેટ)

| Field | Value |
|---|---|
| ID | `M057` (engine rule) |
| Themed name | **Sleepy Tulip Gate** (ઊંઘણશી ટ્યૂલિપ ગેટ) — generic: Traffic Light |
| Intro level | **L571** (block 571–580) |
| Category | C — Counter (Move-based) |
| Rule | Gate દર `N` Moves પર open ⇄ closed બદલાય (periodic). `params.n`, `params.open` (start state). State `open = start XOR (floor(moveCount / N) mod 2 == 1)`, tick step (3) પછી. |
| Ants (Ground) | Closed ⇒ ant lane block; open ⇒ passable. |
| Bees (Air / Canopy) | `tall: true` (**Tall Tulip**) ⇒ closed bee/canopy lane block; `false` ⇒ bees ignore. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. Badge = આગલા flip સુધીના Moves. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | State from `moveCount mod 2N` ⇒ solver state compact. |
| Visual | ટ્યૂલિપ પાંખડીઓ ખુલે/બંધ; badge ઉપર ચંદ્ર/સૂર્ય icon + count. |
| Audio | Flip: petal "flup". |
| Implementation | Pure function of `moveCount` ⇒ Undo automatic. |
| Level-design usage | Timing: યોગ્ય Move count પર lane વાપરવી; waste moves (lever, push) planning. |
| Edge cases | N ≥ 1. Lane check action resolve (step 1) માં **current** state (Move પહેલાંનો) વાપરે; flip step (3) માં. |
| D weight | O + N |

```json
{"id": "o57", "type": "M057", "cells": [[3, 0]], "params": {"n": 2, "open": false}, "hammerable": false, "tall": true}
```

### 3.8 M058 — Spinning Seed Arrow (ફરતું બીજ-તીર)

| Field | Value |
|---|---|
| ID | `M058` (engine rule) |
| Themed name | **Spinning Seed Arrow** (ફરતું બીજ-તીર) — generic: Rotating Arrow |
| Intro level | **L581** (block 581–590) |
| Category | D — Direction changer |
| Rule | One-way tile (M006 rule) જેનું arrow દરેક Move પછી 90° CW ફરે (U→R→D→L→U), tick step (3). Lane arrow ની current દિશામાં જ પસાર; diagonal lane ⇒ bump. |
| Ants (Ground) | Ant lane arrow દિશામાં પસાર; બીજી દિશા bump. |
| Bees (Air / Canopy) | `tall: true` (**Garden Weathervane**) ⇒ bee/canopy lanes પર પણ same rule; `false` ⇒ bees ignore. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Arrow = `start.rotCw(moveCount mod 4)`. |
| Visual | Maple seed (પાંખવાળું બીજ) arrow; weathervane = ધાતુનો મુર્ગો-નહીં, મધમાખી આકારનો vane. |
| Audio | Rotate: tiny "tick-whirr". |
| Implementation | `RotatingArrow.dirAt(moveCount)`; Undo automatic. |
| Level-design usage | Move parity × direction timing; Hard levels માં 2 arrows phase offset. |
| Edge cases | Arrow lane check Move પહેલાંના `moveCount` પ્રમાણે. Bump પણ Move ⇒ arrow ફરે (player bump થી rotate કરાવી શકે — validator: solution bump વગર). |
| D weight | O + N |

```json
{"id": "o58", "type": "M058", "cells": [[5, 5]], "params": {"dir": "U"}, "hammerable": false, "tall": false}
```

### 3.9 M059 — Pollen Paint Patch (પરાગ-રંગ પટ્ટો)

| Field | Value |
|---|---|
| ID | `M059` (engine rule) |
| Themed name | **Pollen Paint Patch** (પરાગ-રંગ પટ્ટો) — generic: Paint Cell |
| Intro level | **L591** (block 591–600) |
| Category | P — Path-variant |
| Rule | Lane paint cell પરથી પસાર ⇒ line નો `color` = paint color (lane trace માં એ cell પછીથી). Lane માં પછી આવતા color mechanics (M005, M030, M062, M095) નવો color જુએ. Line અટકે (M037) તો color permanent. |
| Ants (Ground) | `tall: false` (**Berry Juice Puddle**) ⇒ ant lanes recolor. |
| Bees (Air / Canopy) | `tall: true` (**Pollen Bloom**) ⇒ ant, bee, canopy lanes recolor; `false` ⇒ bees ignore. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. Paint cell પર body allowed. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Lane-trace-time color; solver line state માં color રાખે (relocation). |
| Visual | Juice puddle જાંબલી/લાલ splash; Pollen Bloom = ફૂલ જેમાંથી રંગીન પરાગ ઉડે. |
| Audio | Paint: "puff" + chime (color pitch). |
| Implementation | `PaintCell.apply(LineTrace t)` mutates `t.color`. |
| Level-design usage | Color gate sorting: ખોટા રંગની line ને paint થી સાચી બનાવવી. |
| Edge cases | M072 Garland Order **tap-time color** વાપરે (paint પહેલાંનો); M062/M095 quota **exit-time color** (paint પછીનો). M041 Rainbow Pollen line paint પછી પણ cycle ચાલુ રાખે (paint = current color set). |
| D weight | O |

```json
{"id": "o59", "type": "M059", "cells": [[6, 1]], "params": {"color": "purple"}, "hammerable": false, "tall": true}
```

### 3.10 M060 — Twin Mushroom Swap (જોડિયા મશરૂમ અદલાબદલી)

| Field | Value |
|---|---|
| ID | `M060` (engine rule) |
| Themed name | **Twin Mushroom Swap** (જોડિયા મશરૂમ અદલાબદલી) — generic: Swap Pad |
| Intro level | **L601** (block 601–610) |
| Category | T — Toggle/Interactive |
| Rule | Pad tap (1 Move) ⇒ 2 linked lines ની જગ્યાઓ બદલાય. Linked lines **same shape** (same length + same relative offsets + same `dir`) અને **same layer** (validator). Swap = બંનેના `body` exchange; color, mods, keys, numbers line સાથે જાય. |
| Ants (Ground) | Ant pair swap (mushroom ground પર). |
| Bees (Air / Canopy) | Bee pair swap (layer 1 અથવા canopy) — pad interactive control છે, tall ની અસર નથી. |
| Tall | `false` (fixed) — control cell; linked lines કોઈપણ layer (બંને same). |
| Tap / bump | Pad tap = control (tap priority #1). કોઈ linked line exit થઈ ગઈ હોય / locked (fog, cover) હોય ⇒ locked tap. |
| Heart effect | Locked tap માં heart નહીં, Move નહીં. Swap heart નહીં. |
| Hammerable | No. |
| Hint / solver | Non-monotone; solver control move. Hint pad ને glow કરી શકે. |
| Visual | બે નાના મશરૂમ silk થી જોડાયેલા; swap = બંને lines પર spore swirl. |
| Audio | Swap: "pop-pop". |
| Implementation | `SwapPad.apply(state)` immutable; Undo snapshot. |
| Level-design usage | Keys/numbers/colors ને સાચી line પર લઈ જવા. |
| Edge cases | Swap પછી cover-lock ફરી compute (step 4). Swap પછી body ત્યાં hidden fog હોય તો line hidden બને. |
| D weight | O + N |

```json
{"id": "o60", "type": "M060", "cells": [[0, 0]], "params": {"links": ["p4", "p9"]}, "hammerable": false, "tall": false}
```

### 3.11 M061 — Little Anthill & Mini Hive (નાનો દર અને નાનો મધપૂડો)

| Field | Value |
|---|---|
| ID | `M061` (engine rule) |
| Themed name | **Little Anthill & Mini Hive** (નાનો દર અને નાનો મધપૂડો) — generic: Capacity Hole |
| Intro level | **L611** (block 611–620) |
| Category | G — Goal/Helper |
| Rule | Inner exit (M020 rule) જે `params.cap = N` lines સ્વીકારે, પછી **બંધ** ⇒ તે cell પોતાના layer માટે blocker (not hammerable). Badge બાકી capacity. |
| Ants (Ground) | `layer: 0` (**Little Anthill**) ⇒ ant lanes ત્યાં exit; બંધ ⇒ ant lanes block. |
| Bees (Air / Canopy) | `layer: 1` (**Mini Hive**) ⇒ bee lanes exit; Canopy (L2, L691+): `layer: 2` (**Treetop Mini Hive**). બંધ ⇒ એ layer block. બીજા layers ને કોઈ અસર નહીં. |
| Tall | N/A — `params.layer`. |
| Tap / bump | Tap ignore. |
| Heart effect | Exit = no heart. બંધ પછી normal bump. |
| Hammerable | No. |
| Hint / solver | State: remaining cap. Chained group બંને એક જ hole તરફ અને cap 1 ⇒ group bump (atom). |
| Visual | નાનો દર/મધપૂડો, ઉપર pips; બંધ ⇒ માટી/મીણથી સીલ. |
| Audio | Enter: "plop"; seal: wax "squish". |
| Implementation | `CapacityExit{layer, cap}`; Hammered line hole ને consume નથી કરતો (lane નથી). |
| Level-design usage | Exit allocation puzzles: કઈ lines અંદર, કઈ edge પર. |
| Edge cases | એક Move માં cap કરતાં વધુ lines (group) ⇒ group bump. Cap 0 થાય તે જ Move ના પછીના groups માટે બંધ. |
| D weight | O |

```json
{"id": "o61", "type": "M061", "cells": [[6, 6]], "params": {"layer": 0, "cap": 2}, "hammerable": false}
```

### 3.12 M062 — Flower Bed Delivery (ફૂલક્યારી ડિલિવરી)

| Field | Value |
|---|---|
| ID | `M062` (engine rule) |
| Themed name | **Flower Bed Delivery** (ફૂલક્યારી ડિલિવરી) — generic: Edge Quota |
| Intro level | **L621** (block 621–630) |
| Category | G — Goal/Helper |
| Rule | Goal: marked edge segment (`params.cells` + `side`) થી `params.color` ની ઓછામાં ઓછી `Q` lines exit થવી જોઈએ. Win = બધી lines exit **અને** quota પૂરો. Edge પોતે block નથી કરતી. |
| Ants (Ground) | Ant lines quota માં ગણાય. |
| Bees (Air / Canopy) | Bee અને canopy lines પણ ગણાય (layer-agnostic goal). Edge ઉપરથી ઉડીને બહાર ⇒ ગણાય. |
| Tall | N/A (goal edge, blocker નથી). |
| Tap / bump | Tap ignore. HUD goal chip `🌷 2/3`. |
| Heart effect | Heart effect નહીં. Quota અશક્ય બને (બાકી matching lines < જરૂર) ⇒ "Goal can't be completed" banner + Undo/Restart buttons (heart નહીં, auto-fail નહીં). |
| Hammerable | No. |
| Hint / solver | Goal state counter; solver goal-aware. Hammered line edge થી exit નથી (lane નથી) ⇒ quota માં ગણાતી નથી. |
| Visual | Edge પર રંગીન ફૂલ-ક્યારી strip; delivered line ફૂલ ખીલવે. |
| Audio | Count: bloom chime. |
| Implementation | `EdgeQuota{side, cells, color, q}`; exit color = paint પછીનો. |
| Level-design usage | Exit edge choose કરવી (M014, M052, M056 સાથે). |
| Edge cases | Corner diagonal exit: crossed બંને sides માંથી કોઈ marked હોય ⇒ 1 વાર ગણાય. Quota અશક્ય banner engine `goalReachable()` થી step (6) પછી. |
| D weight | O |

```json
{"id": "o62", "type": "M062", "cells": [[0, 9], [1, 9], [2, 9]], "params": {"side": "D", "color": "red", "q": 2}, "hammerable": false}
```

### 3.13 M063 — Sugar Cube Lure (ખાંડના ટુકડાની લાલચ)

| Field | Value |
|---|---|
| ID | `M063` (engine rule) |
| Themed name | **Sugar Cube Lure** (ખાંડના ટુકડાની લાલચ) — generic: Magnet Blocker |
| Intro level | **L631** (block 631–640) |
| Category | C — Counter (Move-based) |
| Rule | Lure cell blocker. દરેક Move ના step (3) માં: lure ની **row અથવા column** માં body cell ધરાવતી lines માંથી nearest (cells distance) line ને 1 cell lure તરફ **આખી line translate** કરે, જો બધા destination cells free (એ line ના layer માં: બીજી body, blocker, board બહાર નહીં) અને line lure ને અડેલી ન હોય. Tie ⇒ direction order U, R, D, L (lure થી), પછી line id. |
| Ants (Ground) | `tall: false` (**Sugar Cube**) ⇒ માત્ર ant lines ખેંચાય; ant lane block. |
| Bees (Air / Canopy) | `tall: true` (**Nectar Lure Flower**) ⇒ ant, bee, canopy બધી lines candidate; બધા layers lane block. `false` ⇒ bees ignore. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Non-monotone positions; solver tick simulate. Locked lines (cover, fog) પણ ખેંચાય. |
| Visual | સફેદ ખાંડનો ટુકડો + ચમક; ખેંચાતી line ઉપર નાના scent wisps. |
| Audio | Pull: "shff" slide. |
| Implementation | Tick order slot M063 (Standard §16.17). Lures id order માં process. |
| Level-design usage | Lines ને lane માંથી દૂર/નજીક ખેંચવી; cover-lock ઉખેડવા. |
| Edge cases | Pull પછી line lure ને અડે ⇒ આગળ pull નહીં. Pull ના કારણે ant bee ની નીચેથી ખસે ⇒ cover-lock step (4) માં recompute. Lure ની line of sight blocked હોય તો પણ pull (ગંધ પહોંચે). |
| D weight | O + N |

```json
{"id": "o63", "type": "M063", "cells": [[0, 5]], "params": {}, "hammerable": false, "tall": false}
```

### 3.14 M064 — Seesaw Twig Gates (ઝૂલતા ડાળખી ગેટ)

| Field | Value |
|---|---|
| ID | `M064` (engine rule) |
| Themed name | **Seesaw Twig Gates** (ઝૂલતા ડાળખી ગેટ) — generic: Seesaw Gates |
| Intro level | **L641** (block 641–650) |
| Category | T — Toggle/Interactive |
| Rule | 2 linked gates; હંમેશા બરાબર **એક open**. કોઈ line ની **successful** lane (exit અથવા relocation) open gate પરથી પસાર થાય ⇒ action resolve ના અંતે બંને flip. એક Move માં k passes ⇒ k flips. |
| Ants (Ground) | Closed gate ant lane block. |
| Bees (Air / Canopy) | Gates `tall: true` ⇒ bee/canopy lanes block & flip; `false` ⇒ bees ignore (flip પણ નહીં). |
| Tall | Per instance (બંને gates same value). |
| Tap / bump | Tap ignore. Bump lane (પછી blocked) open gate પરથી ગઈ હોય તો **flip નહીં**. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | State 1 bit. Chained group lanes pre-move state થી check. |
| Visual | બે ડાળખીઓ seesaw પર; એક ઊંચે (open) એક નીચે (closed). |
| Audio | Flip: wooden "clack". |
| Implementation | `SeesawPair{openIndex}`. |
| Level-design usage | Alternation ordering: કઈ line ક્યારે. |
| Edge cases | Chained pair ના બંને members open gate પરથી પસાર ⇒ 2 flips ⇒ net no change. |
| D weight | O + N |

```json
[{"id": "s1", "type": "M064", "cells": [[3, 0]], "params": {"pair": "sw1", "open": true}, "hammerable": false, "tall": false}, {"id": "s2", "type": "M064", "cells": [[7, 0]], "params": {"pair": "sw1", "open": false}, "hammerable": false, "tall": false}]
```

### 3.15 M065 — Buried Dew Key (દટાયેલી ઝાકળ ચાવી)

| Field | Value |
|---|---|
| ID | `M065` (engine rule) |
| Themed name | **Buried Dew Key** (દટાયેલી ઝાકળ ચાવી) — generic: Hidden Key |
| Intro level | **L651** (block 651–660) |
| Category | K — Key/Lock |
| Rule | M004 key જે line પર છે તે line **છુપાયેલી**: M010/M075 fog નીચે અથવા ઉપરના layer ની line તેના key cell ને ઢાંકે. Cover clear થાય ત્યાં સુધી key icon દેખાતો નથી અને lock પર `?` badge. Lock નિયમ M004 જેવો (key-line exit ⇒ lock permanently open). |
| Ants (Ground) | Ant line key ધરાવી શકે (bee cover / fog નીચે). |
| Bees (Air / Canopy) | Bee line key ધરાવી શકે (canopy cover / fog નીચે). Lock blocking: lock instance `tall` પ્રમાણે. |
| Tall | Lock: per instance; key: N/A. |
| Tap / bump | Hidden key-line tap ⇒ locked tap (fog / cover-lock). Lock tap ignore. |
| Heart effect | Locked tap માં heart નહીં, Move નહીં. |
| Hammerable | No (lock). Key-line: visible થાય પછી line target. |
| Hint / solver | Solver full info; Hint hidden key-line ને target નથી કરતો — cover clear કરતો Move બતાવે. |
| Visual | માટીમાં અડધી દટાયેલી ઝાકળ ચાવી; reveal ⇒ ચમક + key icon line પર. |
| Audio | Reveal: "ting". |
| Implementation | `mods.key` + `mods.hiddenKey: true`; visibility derived step (4). |
| Level-design usage | Information puzzle: કઈ line ખોલવાથી key દેખાય. |
| Edge cases | Cover clear થયા પછી key icon દેખાય પણ line હજી બીજા કારણે locked હોઈ શકે. Leaf Blower hidden line target નહીં (§16.8). |
| D weight | O |

```json
{"id": "p5", "color": "blue", "dir": "L", "body": [[4, 4], [5, 4]], "layer": 0, "mods": {"key": "blue", "hiddenKey": true}}
```

### 3.16 M066 — Petal-Linked Trio (પાંખડીથી જોડાયેલી ત્રિપુટી)

| Field | Value |
|---|---|
| ID | `M066` (engine rule) |
| Themed name | **Petal-Linked Trio** (પાંખડીથી જોડાયેલી ત્રિપુટી) — generic: Chained Triplet |
| Intro level | **L661** (block 661–670) |
| Category | P — Path-variant |
| Rule | 3 lines linked (M011 ×3). કોઈ એક tap ⇒ ત્રણેય try; ત્રણેય lanes clear ⇒ ત્રણેય એકસાથે exit (1 Move); કોઈ એક blocked ⇒ ત્રણેય bump, **−1 heart total** (§16.7). Group lines એકબીજાની lanes block કરે. |
| Ants (Ground) | Ant trio. |
| Bees (Air / Canopy) | Bee trio (air) અથવા canopy trio. **Trio હંમેશા same layer** (validator). |
| Tall | N/A (path modifier). |
| Tap / bump | Group માં કોઈ member locked ⇒ આખું group locked tap. |
| Heart effect | Joint bump = −1 heart total. |
| Hammerable | Leaf Blower એક member target ⇒ **ત્રણેય** remove (group unit). |
| Hint / solver | Joint move atom; 3-way lane clear check. |
| Visual | ત્રણ lines પર સરખી પાંખડી-dot marker + silk thread. |
| Audio | Group exit: triple chord. |
| Implementation | `mods.chain` group id (size 3). |
| Level-design usage | Coupled ordering, M080 Twin Locks નો base. |
| Edge cases | Member નું exit lane બીજા member ના body માંથી પસાર ⇒ blocked (simultaneous નહીં). |
| D weight | O |

```json
{"id": "p21", "color": "orange", "dir": "D", "body": [[2, 1], [2, 0]], "layer": 1, "mods": {"chain": "c3"}}
```

### 3.17 M067 — Crumbling Soil Patch (ભરભર થતી માટી)

| Field | Value |
|---|---|
| ID | `M067` (engine rule) |
| Themed name | **Crumbling Soil Patch** (ભરભર થતી માટી) — generic: Collapsing Floor |
| Intro level | **L671** (block 671–680) |
| Category | C — Counter (Move-based) |
| Rule | Cell પરથી lanes `N` વાર પસાર (successful exit/relocation lanes) ⇒ **sinkhole** blocker બને (permanent). Pass count step (3) માં apply. |
| Ants (Ground) | Ant lanes ગણાય; sinkhole ant lanes block. |
| Bees (Air / Canopy) | Bee/canopy lanes ઉપરથી ઉડે ⇒ ગણાતી નથી; sinkhole bees ને block નથી કરતું. |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Tap ignore. Badge બાકી passes. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | State per cell count. |
| Visual | તિરાડવાળી માટી, દરેક pass પર તિરાડ વધે; sinkhole = નાનો ખાડો. |
| Audio | Crack: "crk"; collapse: soft rumble. |
| Implementation | Tick slot M067. Hammered line pass નથી (lane નથી). |
| Level-design usage | Shared corridor: કઈ lines પહેલાં વાપરે. |
| Edge cases | Collapse સમયે cell પર ant body હોય (M063/M082 થી આવી) ⇒ collapse deferred, cell ખાલી થાય તે Move ના step (3) માં. |
| D weight | O + N |

```json
{"id": "o67", "type": "M067", "cells": [[4, 3]], "params": {"n": 2}, "hammerable": false, "tall": false}
```

### 3.18 M068 — Honey-Drip Line (મધ ટપકાવતી લાઈન)

| Field | Value |
|---|---|
| ID | `M068` (engine rule) |
| Themed name | **Honey-Drip Line** (મધ ટપકાવતી લાઈન) — generic: Trail Blocker |
| Intro level | **L681** (block 681–690) |
| Category | C — Counter (Move-based) |
| Rule | આ line exit થાય ત્યારે તેના lane cells (head ની આગળથી board edge સુધી, board અંદરના) પર **honey drops** રહે, જે line ના **પોતાના layer** માં lanes block કરે **આગલા 2 Moves** સુધી. Step (3): જૂના drops ttl −1 (0 ⇒ remove), પછી આ Move ના નવા drops ttl 2. |
| Ants (Ground) | Ant honey line ⇒ ground drops (ant lanes block). |
| Bees (Air / Canopy) | Bee honey line ⇒ air drops (bee lanes block); canopy line ⇒ canopy drops. બીજા layers ને અસર નહીં. |
| Tall | N/A (path modifier; drops own layer). |
| Tap / bump | Normal tap. |
| Heart effect | Drops ને અથડાય ⇒ normal bump (−1). |
| Hammerable | Line target. Hammered line drops છોડતી નથી (lane નથી). |
| Hint / solver | State: drop cells + ttl. Solver waiting moves (levers, other lines) વાપરે. |
| Visual | Line પર ચળકતા મધના ટીપાં; trail ambers fade 2 steps. |
| Audio | Drip: "blip". |
| Implementation | Tick slot M068; drops = temporary `StaticBlocker(layer)` not hammerable. |
| Level-design usage | Lines ને એક જ corridor માં સળંગ મોકલવાથી રોકે; ordering + waiting. |
| Edge cases | Drops ની નીચે/ઉપર બીજા layer ની lines સામાન્ય. Drop cell પર પછી body આવી શકતી નથી (blocker). |
| D weight | O + N |

```json
{"id": "p22", "color": "gold", "dir": "R", "body": [[2, 5], [1, 5], [0, 5]], "layer": 0, "mods": {"trail": 2}}
```

### 3.19 M069 — Canopy Scout Bees (ઊંચે ઉડતી સ્કાઉટ મધમાખીઓ)

| Field | Value |
|---|---|
| ID | `M069` (engine rule) |
| Themed name | **Canopy Scout Bees** (ઊંચે ઉડતી સ્કાઉટ મધમાખીઓ) — generic: Three Layers |
| Intro level | **L691** (block 691–700) |
| Category | L — Layer |
| Rule | M032 નું extension: 3 layers — **0 Ground (ants)**, **1 Air (bees)**, **2 Canopy (scout bees, `layer: 2`)**. (a) Lanes માત્ર પોતાના layer ની lines સાથે interact. (b) **Cover lock:** line locked જ્યાં સુધી કોઈ **ઊંચા layer** ની line તેના કોઈ body cell ને ઢાંકે. (c) Tap priority: canopy > air > ground. (d) Blocking: `blocks(m, line) = m.layerAffects(line.layer)` = true જો `layer == 0` અથવા `tall` — **tall obstacles ત્રણેય layers block**, non-tall માત્ર ground. |
| Ants (Ground) | Ant: canopy અથવા air line ઢાંકે ⇒ cover-locked. |
| Bees (Air / Canopy) | Air bee: canopy line ઢાંકે ⇒ cover-locked; ant ને ઢાંકે. Canopy bee: ક્યારેય cover-locked નહીં; ants અને air bees બંનેને ઢાંકે. Canopy lane ને canopy lines + `tall: true` જ block. |
| Tall | N/A (layer system). Existing `tall` values ત્રણેય layer માટે એક જ નિયમ. |
| Tap / bump | Overlapping cell tap ⇒ ઉપરનું layer. Covered line ના uncovered cell tap ⇒ locked tap. |
| Heart effect | Normal bump rules દરેક layer માં. |
| Hammerable | Canopy line Leaf Blower target (priority canopy > air > hammerable obstacle > ant). |
| Hint / solver | Cover-lock = `∃ higher-layer body cell ∩ line.body`. Reverse construction layer-wise; validator no line locked forever. |
| Visual | Canopy bees 12 dp ઉપર offset, scale 0.9, shadow 12 dp દૂર + સૌથી હળવો; covered lines alpha 0.75 + layer badge. |
| Audio | Canopy fly-off: ઊંચો airy "zing". |
| Implementation | `enum Layer { ground, air, canopy }` (index 0/1/2). Level `"layers": 3`. Bee body (layer 1 અથવા 2) `tall: true` blocker cell પર નહીં (LR-8). |
| Level-design usage | L691 intro: 3 canopy lines, cover chain canopy → air → ant. પછી blocks માં 10–20% lines canopy. |
| Edge cases | Ramp `[1,2]` (Warm Updraft) L691+. 3-deep stack (canopy ⊃ air ⊃ ant) ⇒ ઉપરથી નીચે ક્રમે જ. Fog (M010/M075) ત્રણેય layers છુપાવે. |
| D weight | O |

```json
{"layers": 3, "paths": [{"id": "a1", "color": "red", "dir": "R", "body": [[2, 3], [1, 3]], "layer": 0, "mods": {}}, {"id": "b1", "color": "yellow", "dir": "U", "body": [[2, 3], [2, 4]], "layer": 1, "mods": {}}, {"id": "c1", "color": "sky", "dir": "L", "body": [[2, 4], [3, 4]], "layer": 2, "mods": {}}]}
```

### 3.20 M070 — Compass Flower Lever (હોકાયંત્ર ફૂલ લીવર)

| Field | Value |
|---|---|
| ID | `M070` (engine rule) |
| Themed name | **Compass Flower Lever** (હોકાયંત્ર ફૂલ લીવર) — generic: Global Rotator |
| Intro level | **L701** (block 701–710) |
| Category | T — Toggle/Interactive |
| Rule | Lever tap (1 Move) ⇒ board પરની **બધી** lines (બધા layers, hidden સહિત) નો `dir` 90° CW (U→R→D→L, UR→DR→DL→UL). Body cells બદલાતા નથી. M022 Backward line: તેની exit દિશા 90° CW. |
| Ants (Ground) | Ant lines ફરે. |
| Bees (Air / Canopy) | Bee અને canopy lines ફરે. |
| Tall | Lever: `false` (fixed) control cell. |
| Tap / bump | Lever = control (priority #1). Line જેનો નવો `dir` સીધો પોતાના body (neck) તરફ ⇒ **tangled**: tap = locked tap. |
| Heart effect | Locked tap માં heart નહીં, Move નહીં. Rotation heart નહીં. |
| Hammerable | No. |
| Hint / solver | Global state rotation count mod 4; solver control move. |
| Visual | મોટું સૂર્યમુખી-હોકાયંત્ર; rotate ⇒ બધા heads પર arrow sweep. |
| Audio | Rotate: "whoom" + petals. |
| Implementation | Lines `dir = base.rotCw(k)`; validator: M023 Two-Way અને M024 Wide lines M070 levels માં નહીં. |
| Level-design usage | Global planning; Hard levels માં lever + specific order. |
| Edge cases | Tangled line ફરી rotate થી untangle. Validator: કોઈ line દરેક rotation (k=0..3) માં tangled નહીં. |
| D weight | O + N |

```json
{"id": "o70", "type": "M070", "cells": [[9, 0]], "params": {}, "hammerable": false, "tall": false}
```

### 3.21 M071 — Counting Hedge Gap (ગણતરી કરતી વાડ)

| Field | Value |
|---|---|
| ID | `M071` (engine rule) |
| Themed name | **Counting Hedge Gap** (ગણતરી કરતી વાડ) — generic: Quota Edge |
| Intro level | **L711** (block 711–720) |
| Category | B — Static Blocker |
| Rule | Edge segment બંધ (edge wall જેવી) જ્યાં સુધી કુલ `Q` exits (કોઈ પણ layer, edge/inner/hammer સહિત) ન થાય; પછી permanently open. Open check step (4). |
| Ants (Ground) | બંધ ⇒ ant lane bump. |
| Bees (Air / Canopy) | `tall: true` (**Tall Hedge**) ⇒ બંધ હોય ત્યારે bee/canopy lanes bump; `false` ⇒ bees ઉપરથી ઉડી જાય. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. Badge `Q − exits`. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No (edge). |
| Hint / solver | State = global exit count. |
| Visual | Hedge ના પાંદડાં ગણતરી pips સાથે; open ⇒ hedge વચ્ચે રસ્તો. |
| Audio | Open: leafy rustle + chime. |
| Implementation | `QuotaEdge{side, cells, q}`; Leaf Blower removal exit ગણાય (Standard §5). |
| Level-design usage | "પહેલાં બીજે થી Q lines" ordering. |
| Edge cases | Q-th exit ના જ Move માં બીજી line ની lane (group) આ edge વાપરી શકતી નથી (open step 4 માં). Corner diagonal exit: §01 corner rule. |
| D weight | O |

```json
{"id": "o71", "type": "M071", "cells": [[9, 3], [9, 4]], "params": {"side": "R", "q": 3}, "hammerable": false, "tall": false}
```

### 3.22 M072 — Garland Order (ફૂલમાળાનો ક્રમ)

| Field | Value |
|---|---|
| ID | `M072` (engine rule) |
| Themed name | **Garland Order** (ફૂલમાળાનો ક્રમ) — generic: Color Sequence |
| Intro level | **L721** (block 721–730) |
| Category | P — Path-variant |
| Rule | Level HUD માં રંગોની repeating pattern (દા.ત. 🔴🟡🔵). Exit થતી lines નો **tap-time color** pattern ના current slot જેવો જ હોવો જોઈએ; બીજો color ⇒ locked tap. Exit ⇒ pointer +1 (wrap). **Auto-skip:** next color ની કોઈ line બાકી ન હોય ⇒ pointer એ color ને skip કરે. |
| Ants (Ground) | Ant lines pattern માં. |
| Bees (Air / Canopy) | Bee અને canopy lines પણ એ જ pattern (shared). |
| Tall | N/A. |
| Tap / bump | Wrong color ⇒ locked tap + garland slot shake. |
| Heart effect | Locked tap માં heart નહીં, Move નહીં. |
| Hammerable | Line target: Leaf Blower કોઈ પણ line દૂર કરી શકે; color match હોય તો જ pointer આગળ (નહીં તો pointer એ જ). |
| Hint / solver | State: pointer. Validator: M011/M039/M048/M066 groups M072 levels માં નહીં. |
| Visual | HUD ઉપર ફૂલમાળા, current ફૂલ ચમકે. |
| Audio | Correct: soft bell; wrong: "tsk". |
| Implementation | `level.params.garland = ["red","yellow","blue"]`; mechanic entry `M072` HUD માટે. |
| Level-design usage | Color + order planning, paint (M059) સાથે. |
| Edge cases | Pattern ના બધા colors બાકી lines માં ન હોય ⇒ auto-skip ensures no deadlock. Pointer M041 Rainbow line ની tap-time color જુએ. |
| D weight | O |

```json
{"id": "o72", "type": "M072", "cells": [], "params": {"pattern": ["red", "yellow", "blue"]}, "hammerable": false}
```

### 3.23 M073 — Dew Bubble Line (ઝાકળ પરપોટાવાળી લાઈન)

| Field | Value |
|---|---|
| ID | `M073` (engine rule) |
| Themed name | **Dew Bubble Line** (ઝાકળ પરપોટાવાળી લાઈન) — generic: Bubble Path |
| Intro level | **L731** (block 731–740) |
| Category | P — Path-variant |
| Rule | Line ફરતે bubble. **બીજી line** ની lane નો પહેલો blocker આ line નો body cell ⇒ bubble ફૂટે; bump કરનાર line પાછી આવે **heart વગર** (Move ગણાય, Shield charge નહીં). પછી line normal. |
| Ants (Ground) | Ant bubble line (ant lanes ના bumps absorb). |
| Bees (Air / Canopy) | Bee/canopy bubble line (same-layer lanes ના bumps absorb). |
| Tall | N/A. |
| Tap / bump | Bubble line પોતે tap ⇒ normal exit/bump (પોતાનો bump bubble absorb **નથી** કરતો). |
| Heart effect | Bubble absorb ⇒ 0 heart. Group bump: કોઈ member non-bubble blocker થી અટકે ⇒ −1 total (hit થયેલા bubbles પણ ફૂટે). |
| Hammerable | Line target. |
| Hint / solver | State: bubble bit. Solver: bubble-pop bump = free (0 heart) Move ⇒ "0 hearts" validator માં allowed. |
| Visual | પારદર્શક ઝાકળ પરપોટો line ફરતે; pop ⇒ ટીપાં splash. |
| Audio | Pop: "bloop". |
| Implementation | `mods.bubble: true`; bump resolver `firstBlocker` owner check. |
| Level-design usage | Free bump = parity/tick manipulation tool (M057, M090 timing). |
| Edge cases | Bubble pop પણ Move ⇒ counters tick. એક Move માં બે bubbles hit (group) ⇒ બંને ફૂટે. |
| D weight | O |

```json
{"id": "p23", "color": "sky", "dir": "U", "body": [[5, 5], [5, 6]], "layer": 1, "mods": {"bubble": true}}
```

### 3.24 M074 — Old Stone Wall (જૂની પથ્થરની દીવાલ)

| Field | Value |
|---|---|
| ID | `M074` (engine rule) |
| Themed name | **Old Stone Wall** (જૂની પથ્થરની દીવાલ) — generic: Armored Wall |
| Intro level | **L741** (block 741–750) |
| Category | B — Static Blocker |
| Rule | Wall (1–4 cells) lane block; **not hammerable**; linked **Ivy Lever** tap (1 Move) ⇒ wall permanently remove. Lever one-shot (પછી inert). |
| Ants (Ground) | Ant lane block. |
| Bees (Air / Canopy) | `tall: true` (**Ivy-Covered Stone Wall**) ⇒ bee/canopy lane block; `false` ⇒ bees ઉપરથી. |
| Tall | Wall per instance; lever `false` (fixed). |
| Tap / bump | Lever = control (priority #1). Used lever tap ⇒ ignore (no Move). |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | **No** (Standard §16.18). |
| Hint / solver | Monotone after lever; solver control move. |
| Visual | ભૂખરા પથ્થર + શેવાળ; lever = વેલનું દોરડું. |
| Audio | Lever: rope creak + stones tumble. |
| Implementation | `ArmoredWall{links}`; `IvyLever{target, used}`. |
| Level-design usage | Leaf Blower-proof blocker; lever timing. |
| Edge cases | Lever cell પર line body નહીં (validator). Lever pull પછી Undo ⇒ wall પાછી (Move undo). |
| D weight | O + N |

```json
[{"id": "w74", "type": "M074", "cells": [[4, 2], [4, 3], [4, 4]], "params": {"role": "wall"}, "hammerable": false, "tall": true}, {"id": "l74", "type": "M074", "cells": [[0, 9]], "params": {"role": "lever", "links": ["w74"]}, "hammerable": false, "tall": false}]
```

### 3.25 M075 — Creeping Mist (ફેલાતું ધુમ્મસ)

| Field | Value |
|---|---|
| ID | `M075` (engine rule) |
| Themed name | **Creeping Mist** (ફેલાતું ધુમ્મસ) — generic: Creeping Fog |
| Intro level | **L751** (block 751–760) |
| Category | C — Counter (Move-based) |
| Rule | M010 fog area જે દર `N` Moves (step 3) 1 cell ફેલાય: area ના **સૌથી જૂના** cell થી order U, R, D, L માં પહેલા free cell (fog નથી, board અંદર) માં. જૂના cell ની બધી બાજુ ભરેલી ⇒ આગલો જૂનો. Lines ઉપર ફેલાઈ શકે (hidden + locked). Area clear (touching line exit, M010 rule) ⇒ આખું area (ફેલાયેલા cells સહિત) દૂર, ફેલાવો બંધ. |
| Ants (Ground) | Ant lines hidden + locked. |
| Bees (Air / Canopy) | Bee અને canopy lines પણ hidden + locked. |
| Tall | N/A (area). |
| Tap / bump | Fog cell tap ⇒ locked tap. |
| Heart effect | Locked tap માં heart નહીં, Move નહીં. |
| Hammerable | No. |
| Hint / solver | State: fog cell list (age order). Validator: no-forced-damage + fog clearable. |
| Visual | ધીમે ફેલાતું સફેદ ધુમ્મસ, edge પર wisps; next-growth cell પર હળવો dotted outline (telegraph). |
| Audio | Creep: low whoosh. |
| Implementation | Tick slot M075. Growth telegraph ⇒ player ને આગલો cell દેખાય. |
| Level-design usage | Speed puzzle (Move-based): પહેલાં fog clear કરો. |
| Edge cases | Growth key line ને ઢાંકે ⇒ key hidden (M065 interplay). Two areas merge નથી થતા (દરેક area અલગ id; cell પહેલેથી બીજા area નો ⇒ not free). |
| D weight | O + N |

```json
{"id": "o75", "type": "M075", "cells": [[6, 6]], "params": {"area": "f2", "n": 3}, "hammerable": false}
```

### 3.26 M076 — Burrow Network (દર-બોગદાનું જાળું)

| Field | Value |
|---|---|
| ID | `M076` (engine rule) |
| Themed name | **Burrow Network** (દર-બોગદાનું જાળું) — generic: Portal Network |
| Intro level | **L761** (block 761–770) |
| Category | D — Direction changer |
| Rule | 3+ portals ordered list `[A, B, C, …]`; lane portal i માં પ્રવેશે ⇒ portal i+1 (છેલ્લેથી A) થી same `dir` માં ચાલુ. Exit portal પર ant body ⇒ blocked (bump). |
| Ants (Ground) | Ant lanes network વાપરે. |
| Bees (Air / Canopy) | Bees અસર નહીં (ground burrows). |
| Tall | `false` (fixed) — ant-only (M008 જેમ). |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Lane trace hop; loop detection. |
| Visual | માટીના ઢગલામાં દર, ઉપર ક્રમાંક pips (1→2→3). |
| Audio | Enter/exit: "thup". |
| Implementation | `PortalNetwork{cells ordered}`. |
| Level-design usage | Routing: કયો portal ક્યાં લઈ જાય. |
| Edge cases | Diagonal lane portal માંથી diagonal જ નીકળે. Exit portal ની આગળનો cell blocked ⇒ bump at exit portal. |
| D weight | O |

```json
{"id": "o76", "type": "M076", "cells": [[1, 1], [8, 2], [4, 8]], "params": {"net": "n1"}, "hammerable": false, "tall": false}
```

### 3.27 M077 — Puffball Mushroom (પફબોલ મશરૂમ)

| Field | Value |
|---|---|
| ID | `M077` (engine rule) |
| Themed name | **Puffball Mushroom** (પફબોલ મશરૂમ) — generic: Bomb Blocker |
| Intro level | **L771** (block 771–780) |
| Category | X — Boss |
| Rule | Blocker cell; linked line exit થાય (Leaf Blower removal સહિત) ⇒ puffball ફૂટે અને **3×3** (પોતે + 8 પડોશી) ના બધા `hammerable: true` obstacles + પોતાને remove. Lines ને અસર નહીં. |
| Ants (Ground) | Ant lane block (puffball ફૂટે ત્યાં સુધી). |
| Bees (Air / Canopy) | `tall: true` (**Giant Puffball**) ⇒ bee/canopy lane પણ block. Spores બધા layers ના hammerable obstacles ઉડાડે (tall ગમે તે). |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. Linked line પર spore marker. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No (Standard §16.18). |
| Hint / solver | Monotone; on-exit hook. Solver: link exit ⇒ remove set. |
| Visual | ગોળ સફેદ મશરૂમ; ફૂટે ⇒ ભૂરા spores cloud. |
| Audio | Pop: "pfoomf". |
| Implementation | On-exit hook step (1); removed obstacles ના on-remove hooks (M097 domino) ચાલે. |
| Level-design usage | એક exit થી અનેક blockers સાફ. |
| Edge cases | 3×3 board edge પર clip. Push blocks (M053) hammerable ⇒ ઉડી જાય. Chain: 3×3 માં બીજો puffball ⇒ ફૂટતો નથી (not hammerable). |
| D weight | O |

```json
{"id": "o77", "type": "M077", "cells": [[5, 5]], "params": {"links": ["p8"]}, "hammerable": false, "tall": false}
```

### 3.28 M078 — Greenhouse Garden (ગ્રીનહાઉસ બગીચો)

| Field | Value |
|---|---|
| ID | `M078` (engine rule) |
| Themed name | **Greenhouse Garden** (ગ્રીનહાઉસ બગીચો) — generic: Center-Only Exit |
| Intro level | **L781** (block 781–790) |
| Category | B — Static Blocker |
| Rule | Level flag: બધી board edges **બધા layers** માટે walled (કાચની દીવાલ). Lines માત્ર inner exits (M020 Anthill/Hive, M061) થી જ નીકળે. |
| Ants (Ground) | Ant lane edge ⇒ bump; Anthill થી exit. |
| Bees (Air / Canopy) | Bee/canopy lane edge ⇒ bump (કાચ છત સુધી); Hive (layer 1) / Treetop Hive (layer 2) થી exit. |
| Tall | `true` (fixed) — ત્રણેય layers. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Validator: દરેક line ના layer માટે reachable inner exit. |
| Visual | Board ફરતે કાચની greenhouse frame, ચમક reflection (pre-baked). |
| Audio | Edge bump: glass "tink". |
| Implementation | Level `params.greenhouse: true` ⇒ engine edge segments all walled. |
| Level-design usage | Inner routing, M076/M052 સાથે. |
| Edge cases | M062/M071/M095 edge mechanics greenhouse levels માં નહીં (validator). |
| D weight | O |

```json
{"id": "o78", "type": "M078", "cells": [], "params": {"greenhouse": true}, "hammerable": false, "tall": true}
```

### 3.29 M079 — Turning Flower Bed (ફરતી ફૂલક્યારી)

| Field | Value |
|---|---|
| ID | `M079` (engine rule) |
| Themed name | **Turning Flower Bed** (ફરતી ફૂલક્યારી) — generic: Board Rotator |
| Intro level | **L791** (block 791–800) |
| Category | T — Toggle/Interactive |
| Rule | દર `N` Moves (step 3) **inner board** (બધી lines, cell mechanics, તેમના `dir`/`orient`) 90° CW ફરે: `(x, y) → (W−1−y, x)`. **Edge mechanics** (M029, M030, M031, M062, M071, M095) અને M078 ફરતા નથી (garden fence સ્થિર). |
| Ants (Ground) | Ant lines ફરે. |
| Bees (Air / Canopy) | Bee અને canopy lines ફરે. |
| Tall | N/A (board-wide). |
| Tap / bump | Tap ignore. HUD badge આગલા rotation સુધીના Moves. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Square grid only (validator). Solver state rotation index. |
| Visual | Board ફરતે લાકડાનું ફરતું ચક્ર; rotation 450 ms smooth (Reduce Motion ⇒ fade). |
| Audio | Rotate: wooden creak. |
| Implementation | Tick slot M079 (M075 પછી, M082 પહેલાં). Mirror orient `/` ⇄ `\` rotation પર swap. |
| Level-design usage | Edge-relative planning: rotation પછી કઈ edge સામે. |
| Edge cases | Rotation પહેલાં animation પૂરું થાય; rotation દરમિયાન input queue. Beam emitters ફરે ⇒ step (4) recompute. |
| D weight | O + N |

```json
{"id": "o79", "type": "M079", "cells": [], "params": {"n": 4}, "hammerable": false}
```

### 3.30 M080 — Twin Thorn Locks (જોડિયા કાંટા તાળાં)

| Field | Value |
|---|---|
| ID | `M080` (engine rule) |
| Themed name | **Twin Thorn Locks** (જોડિયા કાંટા તાળાં) — generic: Twin Locks |
| Intro level | **L801** (block 801–810) |
| Category | K — Key/Lock |
| Rule | 2 lock cells; બંને **ત્યારે જ** ખૂલે જ્યારે બંને key-lines **એક જ Move** માં exit થાય (M011 chain થી). અલગ Moves માં exit ⇒ locks બંધ જ રહે. |
| Ants (Ground) | Lock ant lane block; ant key-lines. |
| Bees (Air / Canopy) | Locks `tall: true` ⇒ bee/canopy lane block. Key-lines same layer (chain rule). |
| Tall | Locks per instance. |
| Tap / bump | Lock tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No (lock family). |
| Hint / solver | Validator: key-lines હંમેશા chained (M011/M066) ⇒ separate exit શક્ય નથી. Leaf Blower chain member ⇒ આખું chain એક Move માં remove ⇒ locks open. |
| Visual | બે કાંટાળા તાળાં વચ્ચે વેલ; keys જોડિયા ઝાકળ ટીપાં. |
| Audio | Open: double "clink". |
| Implementation | Derived step (4f): `sameMoveExit(k1, k2)`. |
| Level-design usage | Chain + lock combo. |
| Edge cases | Chain bump ⇒ કોઈ exit નહીં ⇒ locks બંધ. Chain નું lane તેના જ lock થી blocked ન હોય (validator). |
| D weight | O |

```json
{"id": "o80", "type": "M080", "cells": [[3, 7], [6, 7]], "params": {"keys": ["p11", "p12"]}, "hammerable": false, "tall": false}
```

### 3.31 M081 — Copycat Line (નકલખોર લાઈન)

| Field | Value |
|---|---|
| ID | `M081` (engine rule) |
| Themed name | **Copycat Line** (નકલખોર લાઈન) — generic: Mimic Path |
| Intro level | **L811** (block 811–820) |
| Category | P — Path-variant |
| Rule | Line નો `dir` = **છેલ્લે tap થઈને move થયેલી line** (exit, bump, push, split) નો `dir` (move સમયનો). Level શરૂઆતમાં પોતાનો JSON `dir`. Controls/boosters `dir` બદલતા નથી. |
| Ants (Ground) | Ant copycat. |
| Bees (Air / Canopy) | Bee/canopy copycat — layer ગમે તે line ની નકલ કરે. |
| Tall | N/A. |
| Tap / bump | Tangled (નવો dir neck તરફ) ⇒ locked tap. પોતે move કરે ⇒ પોતાનો dir જ (no change). |
| Heart effect | Locked tap માં heart નહીં, Move નહીં. Normal bump −1. |
| Hammerable | Line target. |
| Hint / solver | State: last moved dir. Solver deterministic. |
| Visual | Head પર કાચંડા-જેવો ઝબકતો eye marker; dir બદલાય ત્યારે head ફરે. |
| Audio | Copy: "blip-blip". |
| Implementation | `mods.mimic: true`; dir derived after step (1). |
| Level-design usage | "પહેલાં X ને move કરો જેથી copycat સાચી દિશા લે". |
| Edge cases | Multiple copycats: બધા એ જ dir. Bubble-pop bump પણ move ગણાય. Leaf Blower removal "move" નથી. |
| D weight | O + N |

```json
{"id": "p24", "color": "lime", "dir": "L", "body": [[6, 6], [7, 6]], "layer": 0, "mods": {"mimic": true}}
```

### 3.32 M082 — Trickling Brook (ખળખળ વહેતું ઝરણું)

| Field | Value |
|---|---|
| ID | `M082` (engine rule) |
| Themed name | **Trickling Brook** (ખળખળ વહેતું ઝરણું) — generic: Conveyor |
| Intro level | **L821** (block 821–830) |
| Category | D — Direction changer |
| Rule | Brook cells ordered sequence (flow dir). Step (3): line જેનો **આખો body** brook cells પર હોય ⇒ flow દિશામાં 1 cell ખસે (body brook sequence પ્રમાણે) જો આગળનો brook cell free (ant body / blocker નહીં). Brook નો છેલ્લો cell ⇒ ખસે નહીં. Line નો `dir` બદલાતો નથી. |
| Ants (Ground) | Ant lines (leaf rafts) વહે. |
| Bees (Air / Canopy) | Bees અસર નહીં (પાણી ઉપરથી ઉડે). |
| Tall | `false` (fixed) — ant-only. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Positions state; tick slot M082 (છેલ્લે ticks પહેલા M090/M096). |
| Visual | વાદળી ઝરણું, flow arrows; ants પાંદડાના raft પર. |
| Audio | Loop ambient trickle; shift: splash. |
| Implementation | `Conveyor{cells}`; validator: body consecutive brook cells. |
| Level-design usage | Positional timing: line ને સાચા cell સુધી વહેવા દો. |
| Edge cases | બે lines એક જ brook પર: આગળની (flow દિશામાં) પહેલાં ખસે, પછી પાછળની. Partially-on line ખસે નહીં. |
| D weight | O + N |

```json
{"id": "o82", "type": "M082", "cells": [[1, 4], [2, 4], [3, 4], [4, 4], [5, 4]], "params": {}, "hammerable": false, "tall": false}
```

### 3.33 M083 — Stone Slab Plate (પથ્થરની ભારે પ્લેટ)

| Field | Value |
|---|---|
| ID | `M083` (engine rule) |
| Themed name | **Stone Slab Plate** (પથ્થરની ભારે પ્લેટ) — generic: Heavy Plate |
| Intro level | **L831** (block 831–840) |
| Category | T — Toggle/Interactive |
| Rule | M019 જેવી plate, પણ **માત્ર Wide line (M024 Double-File)** નો body plate ઢાંકે ત્યારે જ linked gates ખુલ્લા. સામાન્ય line / push block plate દબાવતા નથી. |
| Ants (Ground) | માત્ર ground Double-File ant line plate દબાવે. Plate cell lane block નથી કરતો. |
| Bees (Air / Canopy) | Bees plate ન દબાવે (હવામાં, Double-File bee પણ નહીં). Gate `tall: true` ⇒ bee/canopy lane block. |
| Tall | Plate `false` (fixed); gates per instance. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Derived step (4a). |
| Visual | મોટો સપાટ પથ્થર; wide line બેસે ⇒ ધૂળ puff + gate open. |
| Audio | Press: heavy "thunk". |
| Implementation | `HeavyPlate.pressed = any wide ground line body ∩ cells`. |
| Level-design usage | Wide ant ને રોકી રાખો, બીજાઓને કાઢો. |
| Edge cases | Plate 2×1 અથવા 2×2 હોઈ શકે; wide line નો કોઈ પણ cell plate પર ⇒ pressed. |
| D weight | O + N |

```json
[{"id": "o83", "type": "M083", "cells": [[3, 3], [4, 3]], "params": {"role": "plate", "links": ["g83"]}, "hammerable": false, "tall": false}, {"id": "g83", "type": "M083", "cells": [[9, 6]], "params": {"role": "gate"}, "hammerable": false, "tall": false}]
```

### 3.34 M084 — Sunbeam Lens (સૂર્યકિરણ લેન્સ)

| Field | Value |
|---|---|
| ID | `M084` (engine rule) |
| Themed name | **Sunbeam Lens** (સૂર્યકિરણ લેન્સ) — generic: Laser Emitter |
| Intro level | **L841** (block 841–850) |
| Category | B — Static Blocker |
| Rule | Lens `params.dir` (U/D/L/R) માં **sunbeam** મોકલે, beam layer = `params.layer`. Beam cells એ layer ના lanes block કરે. Beam અટકે: એ layer નો પહેલો line body cell, એ layer ને block કરતું mechanic (`layerAffects`), board edge. Beam devices (M085, M086, M089) beam layer ને અસર કરતા હોય તો interact. Beams step (4b) માં recompute. |
| Ants (Ground) | Ground beam (`layer: 0`) ant lanes block; ant body beam ને રોકે. |
| Bees (Air / Canopy) | Air beam (`layer: 1`) bee lanes block; Canopy (L2, L691+): `layer: 2` canopy beam. Beam માત્ર પોતાના layer ને block કરે. |
| Tall | Lens per instance; validator: `params.layer ≥ 1 ⇒ tall: true`. Lens પોતે blocker (tall rule). |
| Tap / bump | Lens tap ignore. Lane beam cell cross ⇒ bump at that cell. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No (lens, beam). |
| Hint / solver | Beam trace deterministic, visited `(cell, dir)` ⇒ loop stop. Solver step (4) simulate. |
| Visual | કાચનો ઝાકળ-lens, સોનેરી કિરણ (ground beam ઘાસ પર નીચે, air beam ઊંચે glow). Beam static picture માં (beamVersion). |
| Audio | Beam on: warm hum; block: soft "tzz". |
| Implementation | `BeamTracer.trace(state)` → `Set<(Cell, Layer)>`. |
| Level-design usage | Lines ને beam રોકવા/છોડવા માટે ઉપયોગ; ordering. |
| Edge cases | Beam ને રોકતી line exit થાય ⇒ beam step (4) માં લંબાય — એ જ Move ની lane check pre-move beam વાપરે. Beam cell પર body allowed નથી (body beam ને રોકે જ). |
| D weight | O |

```json
{"id": "o84", "type": "M084", "cells": [[0, 4]], "params": {"dir": "R", "layer": 1}, "hammerable": false, "tall": true}
```

### 3.35 M085 — Sun-Seeker Sunflower (સૂર્યમુખી રિસીવર)

| Field | Value |
|---|---|
| ID | `M085` (engine rule) |
| Themed name | **Sun-Seeker Sunflower** (સૂર્યમુખી રિસીવર) — generic: Laser Receiver |
| Intro level | **L851** (block 851–860) |
| Category | T — Toggle/Interactive |
| Rule | Beam (receiver જે layer ને અસર કરે તેનો) receiver cell સુધી પહોંચે ⇒ linked gates **ખુલ્લા જ્યાં સુધી hit**. Step (4c) beams પછી. |
| Ants (Ground) | Receiver ant lane block. Ground beam hit કરે. |
| Bees (Air / Canopy) | `tall: true` ⇒ air/canopy beams પણ hit; receiver bee lanes block. `false` ⇒ માત્ર ground beam. |
| Tall | Receiver per instance; gates per instance. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Derived; validator: receiver-linked gate કોઈ beam route પર નહીં (no beam↔gate cycle). |
| Visual | સૂર્યમુખી lens તરફ મોં ફેરવે; hit ⇒ ખીલે + gate vine ખસે. |
| Audio | Hit: bright chime. |
| Implementation | `Receiver.lit = beamCells.contains(cell, layer)`. |
| Level-design usage | Beam routing goal: mirrors/prisms થી sunflower સુધી. |
| Edge cases | Receiver beam ને અટકાવે (absorbs). બે beams hit ⇒ lit. |
| D weight | O + N |

```json
[{"id": "r85", "type": "M085", "cells": [[9, 4]], "params": {"links": ["g85"]}, "hammerable": false, "tall": true}, {"id": "g85", "type": "M085", "cells": [[5, 0]], "params": {"role": "gate"}, "hammerable": false, "tall": false}]
```

### 3.36 M086 — Beetle-Shell Mirror (ભમરાના કવચનો અરીસો)

| Field | Value |
|---|---|
| ID | `M086` (engine rule) |
| Themed name | **Beetle-Shell Mirror** (ભમરાના કવચનો અરીસો) — generic: Beam Mirror |
| Intro level | **L861** (block 861–870) |
| Category | D — Direction changer |
| Rule | `/` અથવા `\` mirror: **beams અને orthogonal lanes** બંનેને 90° વાળે (M014 reflection table). Diagonal lanes ⇒ bump. |
| Ants (Ground) | Ant lanes અને ground beams વળે. |
| Bees (Air / Canopy) | `tall: true` ⇒ bee/canopy lanes અને air/canopy beams પણ વળે; `false` ⇒ bees ઉપરથી. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Lane/beam trace reflect; loop detection. |
| Visual | લીલું-ધાતુઈ ભમરાનું કવચ ત્રાંસું ઊભું. |
| Audio | Beam reflect: glassy "ping". |
| Implementation | Shared `reflect(dir, orient)` with M014. |
| Level-design usage | Beam routing + lane routing એકસાથે. |
| Edge cases | Beam બંને બાજુથી reflect (double-sided). M079 rotation પર orient swap. |
| D weight | O |

```json
{"id": "o86", "type": "M086", "cells": [[4, 4]], "params": {"orient": "/"}, "hammerable": false, "tall": true}
```

### 3.37 M087 — Tree Sap Drop (ઝાડના રસનું ટીપું)

| Field | Value |
|---|---|
| ID | `M087` (engine rule) |
| Themed name | **Tree Sap Drop** (ઝાડના રસનું ટીપું) — generic: Glue Pad |
| Intro level | **L871** (block 871–880) |
| Category | P — Path-variant |
| Rule | Line નો **head** sap cell પર (sap `params.layer` = line layer) ⇒ line stuck: 1st tap = unstick (1 Move, lane check નહીં, heart નહીં), 2nd tap = normal exit/bump. Head ફરી sap પર આવે (M037/M082/M063) ⇒ ફરી stuck. |
| Ants (Ground) | `layer: 0` (**Tree Sap**) ⇒ ant heads. |
| Bees (Air / Canopy) | `layer: 1` (**Sundew Bloom**) ⇒ bee heads; Canopy (L2, L691+): `layer: 2` (**Canopy Resin**). બીજા layers ને અસર નહીં. |
| Tall | N/A — `params.layer`. |
| Tap / bump | Stuck line tap ⇒ unstick animation (wiggle). Lane trace sap cells ને ignore કરે (passable). |
| Heart effect | Unstick heart નહીં. |
| Hammerable | No (sap). Line target. |
| Hint / solver | State: stuck bit per line; S term (extra moves) વધે. |
| Visual | સોનેરી ચીકણું ટીપું head નીચે; sundew = ચમકતા વાળ વાળું ફૂલ. |
| Audio | Unstick: "shlurp". |
| Implementation | `mods.stuck` derived at level start from head position. |
| Level-design usage | Extra Move cost ⇒ parity/timing tool. |
| Edge cases | Stuck + M012 Napping: બંને taps ક્રમ: unstick, wake, exit (3 Moves). Hint stuck line પર unstick ને Move તરીકે બતાવે. |
| D weight | O + N |

```json
{"id": "o87", "type": "M087", "cells": [[2, 2]], "params": {"layer": 0}, "hammerable": false}
```

### 3.38 M088 — Bramble Snare (કાંટાળી ફાંસ)

| Field | Value |
|---|---|
| ID | `M088` (engine rule) |
| Themed name | **Bramble Snare** (કાંટાળી ફાંસ) — generic: Lane Mine |
| Intro level | **L881** (block 881–890) |
| Category | K — Key/Lock |
| Rule | Snare cell lane block **જ્યાં સુધી** linked key-line exit ન થાય (defuse) ⇒ પછી permanently remove. |
| Ants (Ground) | Ant lane block. |
| Bees (Air / Canopy) | `tall: true` ⇒ bee/canopy lane block; `false` ⇒ bees ઉપરથી. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No (key family). |
| Hint / solver | Monotone; key-line exit hook. |
| Visual | કાંટાળી વેલની ગાંઠ; defuse ⇒ ગાંઠ ખૂલી જાય. |
| Audio | Defuse: snip "tsnk". |
| Implementation | `LaneMine{key}`; Leaf Blower key-line removal = exit ⇒ defuse. |
| Level-design usage | Key ordering, M004 નો lane version. |
| Edge cases | Key-line નું lane તેના જ snare થી blocked નહીં (validator). |
| D weight | O |

```json
{"id": "o88", "type": "M088", "cells": [[5, 1]], "params": {"key": "p13"}, "hammerable": false, "tall": false}
```

### 3.39 M089 — Dew Prism (ઝાકળ પ્રિઝમ)

| Field | Value |
|---|---|
| ID | `M089` (engine rule) |
| Themed name | **Dew Prism** (ઝાકળ પ્રિઝમ) — generic: Prism |
| Intro level | **L891** (block 891–900) |
| Category | D — Direction changer |
| Rule | Incoming beam prism પર ⇒ **બે beams** incoming dir ના 90° ડાબે અને 90° જમણે; સીધો beam આગળ જતો નથી. Prism cell lanes માટે blocker (object). |
| Ants (Ground) | Ground beams split; prism ant lane block. |
| Bees (Air / Canopy) | `tall: true` ⇒ air/canopy beams split + bee/canopy lane block; `false` ⇒ bees ઉપરથી. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Beam trace branching; visited set stops loops. |
| Visual | પારદર્શક ઝાકળ ટીપું; split ⇒ મેઘધનુષી ઝબકાર. |
| Audio | Split: dual chime. |
| Implementation | `Prism.split(dir) => [dir.rotCcw90(), dir.rotCw90()]`. |
| Level-design usage | એક lens થી બે receivers. |
| Edge cases | બે બાજુથી beams ⇒ દરેક અલગ split. Split beam તરત board edge ⇒ ignore. |
| D weight | O |

```json
{"id": "o89", "type": "M089", "cells": [[6, 4]], "params": {}, "hammerable": false, "tall": true}
```

### 3.40 M090 — Firefly Lantern Gate (આગિયા ફાનસ ગેટ)

| Field | Value |
|---|---|
| ID | `M090` (engine rule) |
| Themed name | **Firefly Lantern Gate** (આગિયા ફાનસ ગેટ) — generic: Parity Gate |
| Intro level | **L901** (block 901–910) |
| Category | C — Counter (Move-based) |
| Rule | Gate **open** જ્યારે Move increment પહેલાંનો `moveCount` **odd**, closed જ્યારે even (§16.17). Start (count 0) ⇒ closed. |
| Ants (Ground) | Closed ⇒ ant lane block. |
| Bees (Air / Canopy) | `tall: true` ⇒ bee/canopy lanes પણ; `false` ⇒ bees ignore. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. Lantern lit = open. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Parity state; Bubble-pop (M073), sap unstick (M087), levers ⇒ parity tools. |
| Visual | ફાનસમાં આગિયા; lit/dim. |
| Audio | Toggle: soft "fwip". |
| Implementation | `ParityGate.open(moveCountBefore) => moveCountBefore.isOdd`. |
| Level-design usage | Parity planning. |
| Edge cases | Undo parity revert (moveCount −1). Locked tap parity બદલતો નથી. |
| D weight | O + N |

```json
{"id": "o90", "type": "M090", "cells": [[2, 0]], "params": {}, "hammerable": false, "tall": false}
```

### 3.41 M091 — Giant Lily-Pad Rotor (મોટું કમળ-પાન રોટર)

| Field | Value |
|---|---|
| ID | `M091` (engine rule) |
| Themed name | **Giant Lily-Pad Rotor** (મોટું કમળ-પાન રોટર) — generic: Rotor 3×3 |
| Intro level | **L911** (block 911–920) |
| Category | T — Toggle/Interactive |
| Rule | 3×3 rotor; tap (1 Move) ⇒ અંદરના contents (lines **સંપૂર્ણ અંદર** હોય તો જ, cell mechanics) 90° CW center ફરતે. Lines ના `dir` પણ ફરે. |
| Ants (Ground) | Ant lines ફરે. |
| Bees (Air / Canopy) | Bee/canopy lines ફરે (rotor control; tall અસર નથી). |
| Tall | `false` (fixed) — control. |
| Tap / bump | Rotor hub (center cell) tap = control. કોઈ line આંશિક અંદર ⇒ locked tap (§16.19). Rotation પછી head body તરફ ⇒ locked tap. |
| Heart effect | Locked tap માં heart નહીં, Move નહીં. |
| Hammerable | No. |
| Hint / solver | Control move; solver 4 states per rotor. |
| Visual | મોટું કમળ-પાન, વચ્ચે ફૂલ hub. |
| Audio | Rotate: water swirl. |
| Implementation | Shared rotor code with M034 (`size: 3`). |
| Level-design usage | Larger reorientation puzzles. |
| Edge cases | Center cell પર line body allowed (hub tap priority control). 2 rotors overlapping નહીં (validator). |
| D weight | O + N |

```json
{"id": "o91", "type": "M091", "cells": [[3, 3], [4, 3], [5, 3], [3, 4], [4, 4], [5, 4], [3, 5], [4, 5], [5, 5]], "params": {"size": 3}, "hammerable": false, "tall": false}
```

### 3.42 M092 — Caravan Line (કાફલા લાઈન)

| Field | Value |
|---|---|
| ID | `M092` (engine rule) |
| Themed name | **Caravan Line** (કાફલા લાઈન) — generic: Segmented Path |
| Intro level | **L921** (block 921–930) |
| Category | P — Path-variant |
| Rule | Body `mods.segments = [n1, n2, …]` (head થી). દરેક tap ⇒ **આગળનો segment** lane પર exit try (1 Move): સફળ ⇒ segment remove; આગલા segment નો પહેલો cell નવો head, `dir` = નવા head થી દૂર થયેલા segment ના છેલ્લા cell તરફની દિશા (8-dir). Blocked ⇒ bump (આખી line મૂળ). છેલ્લો segment exit ⇒ line exit. |
| Ants (Ground) | Ant caravan. |
| Bees (Air / Canopy) | Bee/canopy caravan. |
| Tall | N/A. |
| Tap / bump | Normal tap (દરેક tap 1 segment). |
| Heart effect | Segment bump −1 normal. |
| Hammerable | Leaf Blower ⇒ **આખી** caravan remove (exit, on-exit hooks એક વાર). |
| Hint / solver | State: segments remaining; S term. |
| Visual | Segments વચ્ચે નાના પાંદડાં separators; head segment પર ધ્વજ. |
| Audio | Segment exit: short march + "tick". |
| Implementation | `mods.segments`; on-exit hooks (keys, M003 adjacency, fog) **છેલ્લા** segment ના exit પર જ. |
| Level-design usage | Multi-tap timing (counters, parity). |
| Edge cases | M003 adjacency / fog touch: line ના current body પ્રમાણે. Key icon head segment પર ⇒ પણ hook છેલ્લા segment પર (line exit). |
| D weight | O + N |

```json
{"id": "p25", "color": "brown", "dir": "R", "body": [[5, 2], [4, 2], [3, 2], [2, 2], [1, 2]], "layer": 0, "mods": {"segments": [2, 3]}}
```

### 3.43 M093 — Scatter Line (વિખેરાતી લાઈન)

| Field | Value |
|---|---|
| ID | `M093` (engine rule) |
| Themed name | **Scatter Line** (વિખેરાતી લાઈન) — generic: Splitter Path |
| Intro level | **L931** (block 931–940) |
| Category | P — Path-variant |
| Rule | Tap (1 Move, lane check નહીં) ⇒ midpoint પર 2 lines: **front** = `body[0 … ⌈L/2⌉−1]`, `dir` same; **back** = બાકીના cells reverse (જૂની tail = નવો head), `dir` = original `dir` નો **opposite**. પછી બંને normal lines. L ≥ 4 (validator). |
| Ants (Ground) | Ant scatter. |
| Bees (Air / Canopy) | Bee/canopy scatter. |
| Tall | N/A. |
| Tap / bump | First tap = split; પછી દરેક half અલગ tap. |
| Heart effect | Split heart નહીં; halves normal bump. |
| Hammerable | Unsplit ⇒ Leaf Blower આખી line; split પછી દરેક half અલગ target. |
| Hint / solver | State: split bit; P count +1 પછી (quota/ order માં 2 lines). |
| Visual | Line ની વચ્ચે ઝગમગતું split marker; split ⇒ બે ટોળાં વિરુદ્ધ દિશામાં મોં ફેરવે. |
| Audio | Split: "zip". |
| Implementation | New ids `<id>a`, `<id>b`; color, layer, mods (chain સિવાય) copy. |
| Level-design usage | Opposite-direction exits; edges બંને બાજુ. |
| Edge cases | Back half નો `dir` opposite હોવાથી head body તરફ (bent body) ⇒ tangled ⇒ locked tap (validator avoid). M028/M072 માં halves same number/color ⇒ બંને eligible. |
| D weight | O + N |

```json
{"id": "p26", "color": "pink", "dir": "L", "body": [[2, 7], [3, 7], [4, 7], [5, 7]], "layer": 1, "mods": {"split": true}}
```

### 3.44 M094 — Petal Mixing Bowl (પાંખડી મિશ્રણ વાટકો)

| Field | Value |
|---|---|
| ID | `M094` (engine rule) |
| Themed name | **Petal Mixing Bowl** (પાંખડી મિશ્રણ વાટકો) — generic: Color Mixer |
| Intro level | **L941** (block 941–950) |
| Category | P — Path-variant |
| Rule | Lane mixing bowl cell પરથી પસાર ⇒ line color = `mix(lineColor, bowlColor)`: red+blue = **purple**, red+yellow = **orange**, blue+yellow = **green**; same + same = same; કોઈ પણ secondary/બીજો color સામેલ ⇒ **bowl color** (replace, M059 જેવું). |
| Ants (Ground) | `tall: false` ⇒ ant lanes mix. |
| Bees (Air / Canopy) | `tall: true` ⇒ ant, bee, canopy lanes mix; `false` ⇒ bees ignore. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No. |
| Hint / solver | Lane-trace color; table lookup. |
| Visual | ફૂલના વાટકામાં બે રંગો ઘૂમે; mix ⇒ નવો રંગ splash. |
| Audio | Mix: bubbling chime. |
| Implementation | `ColorMix.table`; colors enum shared with M005/M059. |
| Level-design usage | Two-step coloring: paint + mix to reach gate color. |
| Edge cases | એક lane માં paint (M059) પછી bowl ⇒ ક્રમમાં apply. Color-blind glyphs: mixed colors ના પોતાના glyphs. |
| D weight | O |

```json
{"id": "o94", "type": "M094", "cells": [[4, 1]], "params": {"color": "blue"}, "hammerable": false, "tall": false}
```

### 3.45 M095 — Colored Hedge Gap (રંગીન વાડનું બાકોરું)

| Field | Value |
|---|---|
| ID | `M095` (engine rule) |
| Themed name | **Colored Hedge Gap** (રંગીન વાડનું બાકોરું) — generic: Color Quota Edge |
| Intro level | **L951** (block 951–960) |
| Category | B — Static Blocker |
| Rule | M071 per color: edge segment બંધ જ્યાં સુધી `params.color` ની કુલ `Q` exits (exit-time color, કોઈ પણ layer/exit) ન થાય. |
| Ants (Ground) | બંધ ⇒ ant lane bump. |
| Bees (Air / Canopy) | `tall: true` ⇒ bee/canopy lanes bump; `false` ⇒ bees ઉપરથી. |
| Tall | Per instance; default `false`. |
| Tap / bump | Tap ignore. Badge રંગ + બાકી count. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No (edge). |
| Hint / solver | Per-color exit counters. |
| Visual | Hedge માં રંગીન ફૂલો + pips. |
| Audio | Open: colored chime. |
| Implementation | `ColorQuotaEdge{color, q}`; Leaf Blower removal = exit (current color). |
| Level-design usage | Color sorting + order. |
| Edge cases | Hammered line color = removal સમયનો color. Validator: quota પૂરતી lines. |
| D weight | O |

```json
{"id": "o95", "type": "M095", "cells": [[0, 2], [0, 3]], "params": {"side": "L", "color": "yellow", "q": 2}, "hammerable": false, "tall": true}
```

### 3.46 M096 — Dusk Shadow Line (સંધ્યા પડછાયા લાઈન)

| Field | Value |
|---|---|
| ID | `M096` (engine rule) |
| Themed name | **Dusk Shadow Line** (સંધ્યા પડછાયા લાઈન) — generic: Shadow Path |
| Intro level | **L961** (block 961–970) |
| Category | P — Path-variant |
| Rule | Line **visible + tappable** માત્ર જ્યારે current `moveCount` (Move પહેલાં) **even**; odd ⇒ invisible, not tappable, **ક્યારેય block નહીં**. Start (0) ⇒ visible. |
| Ants (Ground) | Ant shadow line. |
| Bees (Air / Canopy) | Bee/canopy shadow line. |
| Tall | N/A. |
| Tap / bump | Invisible cell tap ⇒ નીચેના layer ને tap (અથવા ignore); visible ⇒ normal. |
| Heart effect | Normal bump when visible. |
| Hammerable | Visible હોય ત્યારે જ Leaf Blower target. |
| Hint / solver | Parity state (§16.17). |
| Visual | Visible: જાંબલી-ભૂખરો પડછાયો; invisible: કંઈ નહીં (Settings → Accessibility "Shadow outlines" ON ⇒ dotted footprint). |
| Audio | Appear: hush. |
| Implementation | `mods.shadow: true`; Scent Trail Preview invisible shadow ને blocker ન ગણે. |
| Level-design usage | Parity planning, M021 નો stronger version. |
| Edge cases | Invisible shadow line બીજી line ને cover-lock નથી કરતી (non-blocking, absent). Invisible વખતે નીચેની line ને tap મળે. |
| D weight | O + N |

```json
{"id": "p27", "color": "violet", "dir": "D", "body": [[7, 2], [7, 1]], "layer": 1, "mods": {"shadow": true}}
```

### 3.47 M097 — Toppling Toadstools (પડતા છત્રી-મશરૂમ)

| Field | Value |
|---|---|
| ID | `M097` (engine rule) |
| Themed name | **Toppling Toadstools** (પડતા છત્રી-મશરૂમ) — generic: Domino Chain |
| Intro level | **L971** (block 971–980) |
| Category | B — Static Blocker |
| Rule | Ordered toadstool chain `[d1, d2, …]`. **d1** clear થાય (Leaf Blower **અથવા** linked line exit) ⇒ એ જ Move માં આખી chain ક્રમમાં remove (60 ms stagger animation). d1 સિવાયના toadstools અલગથી hammerable નથી. |
| Ants (Ground) | દરેક toadstool ant lane block. |
| Bees (Air / Canopy) | `tall: true` ⇒ bee/canopy lanes block; `false` ⇒ bees ઉપરથી. |
| Tall | Per instance (chain same value). |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | d1: **Yes** (`hammerable: true`); બાકી No. |
| Hint / solver | Monotone; on-remove hook. |
| Visual | છત્રી-મશરૂમોની હાર; પહેલાને ધક્કો ⇒ domino fall. |
| Audio | Fall: cascading "tok-tok-tok". |
| Implementation | `DominoChain{order, links}`; M077 puffball d1 ઉડાડે ⇒ chain trigger. |
| Level-design usage | એક action થી લાંબો wall clear. |
| Edge cases | Leaf Blower d2… ને target ન કરી શકે (માત્ર d1). Toadstool cells પર line body નહીં (validator). M077 puffball ના 3×3 માં d1 ⇒ chain trigger; d2+ માત્ર ⇒ અસર નહીં (not hammerable). |
| D weight | O |

```json
{"id": "o97", "type": "M097", "cells": [[2, 5], [3, 5], [4, 5], [5, 5]], "params": {"links": ["p14"]}, "hammerable": true, "tall": false}
```

### 3.48 M098 — Great Stag Beetle (મોટો સ્ટેગ ભમરો)

| Field | Value |
|---|---|
| ID | `M098` (engine rule) |
| Themed name | **Great Stag Beetle** (મોટો સ્ટેગ ભમરો) — generic: Moving Guardian |
| Intro level | **L981** (block 981–990) |
| Category | X — Boss |
| Rule | M049 Guardian (2×2, HP = linked lines; દરેક linked exit −1 HP; 0 ⇒ vanish) + M025 patrol: દરેક Move step (3) માં loop પર 1 position (anchor = top-left) ખસે; આગલી position ના કોઈ cell પર કોઈ line body (કોઈ layer) / blocker ⇒ એ Move રાહ (§16.14). Tick: M025 પછી તરત. |
| Ants (Ground) | Ant lane block. |
| Bees (Air / Canopy) | Bee + canopy lanes block (ઊંચા શિંગડાં). |
| Tall | `true` (fixed) — ત્રણેય layers. |
| Tap / bump | Tap ignore. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | **No**. |
| Hint / solver | State HP + loop index; solver both. Validator: linked lines beetle થી permanently blocked નહીં. |
| Visual | મિત્રતાભર્યો ચળકતો stag beetle, HP pips; ચાલતાં નાનાં પગલાં. |
| Audio | Step: heavy "clomp"; HP hit: shell "tonk". |
| Implementation | Guardian sprite layer (બધા layers ઉપર). Standard tick list માં M098 નથી ⇒ M025 slot સાથે. |
| Level-design usage | L981 intro; L1000 Finale boss; Sunday Mini Boss (Phase 2 players) માં M049 ને બદલે નહીં (Standard: M049). |
| Edge cases | HP 0 એ જ Move માં patrol tick નહીં (vanished). Beetle બીજી line પર ચાલી શકતો નથી ⇒ waits. |
| D weight | O + N |

```json
{"id": "o98", "type": "M098", "cells": [[4, 4], [5, 4], [4, 5], [5, 5]], "params": {"links": ["p1", "p2", "p3"], "loop": [[4, 4], [6, 4], [6, 6], [4, 6]], "start": 0}, "hammerable": false, "tall": true}
```

### 3.49 M099 — Royal Hive Door (રાજવી મધપૂડા દ્વાર)

| Field | Value |
|---|---|
| ID | `M099` (engine rule) |
| Themed name | **Royal Hive Door** (રાજવી મધપૂડા દ્વાર) — generic: Master Lock |
| Intro level | **L991** (block 991–1000) |
| Category | K — Key/Lock |
| Rule | Lock (1–2 cells) **permanently ખૂલે** પહેલા step (4f) માં જ્યારે બંને સાચાં: (a) level ના **બધા key types** (દરેક key color ની બધી key-lines, M004/M043/M065/M080) exit થઈ ગઈ, **અને** (b) linked Sun-Seeker Sunflower (M085) હાલ hit. |
| Ants (Ground) | Door ant lane block. |
| Bees (Air / Canopy) | `tall: true` ⇒ bee/canopy lane block (default true). |
| Tall | Per instance; default `true` (recommended). |
| Tap / bump | Tap ignore. Door પર key slots + sun slot progress. |
| Heart effect | કોઈ સીધો heart effect નથી; blocked lane ⇒ normal bump (−1 Heart). |
| Hammerable | No (lock family). |
| Hint / solver | Derived; validator: બંને conditions એકસાથે reachable, receiver beam route stable. |
| Visual | મીણ અને સોનાનો મોટો દરવાજો, key slots ભરાય, સૂર્ય slot ઝળકે. |
| Audio | Open: royal fanfare short. |
| Implementation | `MasterLock{receiver}`; key set level માંથી auto. |
| Level-design usage | Phase 2 key + beam synthesis; L1000 Finale. |
| Edge cases | Keys પૂરી થાય પછી receiver lit ન હોય ⇒ રાહ; પછી beam route ખુલે એ Move માં open. Open પછી receiver બંધ થાય તો પણ door ખુલ્લો. |
| D weight | O |

```json
{"id": "o99", "type": "M099", "cells": [[6, 0], [7, 0]], "params": {"receiver": "r85"}, "hammerable": false, "tall": true}
```

### 3.50 Phase 2 Finale — Queen's Midsummer Jubilee (L1000)

| Field | Value |
|---|---|
| ID | — (Finale, category X) |
| Intro level | **L1000** |
| Rule | **Great Stag Beetle (M098)** + Phase 2 ના **≥ 10** બીજા mechanics નો mix (Standard §10). Tag `finale`, slot `finale`, D = P2-B high 70 × 1.2 = **84** (validator band 81–87). |
| Ants / Bees | ત્રણેય layers ફરજિયાત (ground ≥ 40%, air ≥ 30%, canopy ≥ 10% lines). Beetle linked lines ત્રણેય layers માં. |
| Tall | Beetle `true` (fixed); Royal Hive Door `true`; બાકી designer. |
| Heart / hammer | Standard rules; Beetle, Door, Lens not hammerable. 0 hearts / 0 boosters solvable (validator). |
| Reward | Finale clear **50** coins + **Royal Honey Chest**: 1,000 coins + 2 of each booster + "Garden Trails II" phase badge; પછી Golden Nectar Rush; પછી Phase Complete (§16.20). |
| Design | [02 §7](./02_LEVEL_PROGRESSION_0501_1000.md). |

```json
{"schema": 3, "level": 1000, "phase": 2, "seed": "0x03E8A0B1C2D3E4F5", "slot": "finale", "tag": "finale", "grid": [14, 14], "layers": 3, "hearts": 3, "paths": [{"id": "p1", "color": "red", "dir": "UR", "body": [[3, 10], [2, 11], [1, 12]], "layer": 0, "mods": {"key": "red"}}], "mechanics": [{"id": "o98", "type": "M098", "cells": [[6, 6], [7, 6], [6, 7], [7, 7]], "params": {"links": ["p1", "p9", "p17", "p30"], "loop": [[6, 6], [8, 6], [8, 8], [6, 8]], "start": 0}, "hammerable": false, "tall": true}, {"id": "o99", "type": "M099", "cells": [[13, 6], [13, 7]], "params": {"receiver": "r85"}, "hammerable": false, "tall": true}], "goals": {"gems": 0}, "par_moves": 52, "difficulty": 84.0, "solution": ["p4", "o70", "p1"]}
```
(Fragment — real L1000 JSON ~40 lines; `solution` truncated.)

## 4. CI Validator Rules — Phase 2 additions (CI ચકાસણી)

| Check | Applies to |
|---|---|
| Solvable with 0 hearts lost & 0 boosters; node limit 2M, depth ≤ 3×P | બધા |
| Intro level = intro mechanic + ≤ 1 earlier mechanic; L501–510 = Phase 1 mechanics only | x1, onboarding |
| `dir` diagonal only L511+; Wide (M024) lines orthogonal only | M051 |
| `layer: 2` / `layers: 3` / ramp pair `[1,2]` only L691+ | M069, M056 |
| Bee/canopy body `tall: true` blocker cell પર નહીં; એક layer માં એક cell = max 1 body | બધા |
| Lane/beam loops નહીં (`(cell, dir, layer)` revisit) ; lane max 2 ramps | M052, M056, M076, M084, M086, M089 |
| `params.layer ≥ 1 ⇒ tall: true` (beam devices) ; receiver-linked gate કોઈ beam route પર નહીં | M084, M085, M089, M099 |
| Push block destination rules; no block permanently trapping a needed lane | M053, M054, M055 |
| Swap pair same shape + same layer | M060 |
| Chain/trio/twin-key same layer; twin keys always chained | M066, M080 |
| M070 levels: no M023/M024; કોઈ line દરેક rotation માં tangled નહીં | M070, M081, M093 |
| M072 levels: no M011/M039/M048/M066 groups; pattern colors present | M072 |
| M079 / M091: square grid / non-overlapping rotors | M079, M091 |
| Greenhouse: દરેક line ના layer માટે reachable inner exit; no edge mechanics | M078 |
| Quotas (M062, M071, M095) reachable; key-lines not blocked by own lock/snare | goals, K |
| Guardian/Beetle linked lines not permanently blocked by it | M098 |
| Grid ≥ 12×12 ⇒ zoom enabled; fit cell ≥ 22 dp at 360 dp width (14×14) | P2-A/P2-B |

## 5. Edge-Case Index (આ catalog માં define કરેલા)

| ID | Edge case | Defined in |
|---|---|---|
| EC-M051 | Corner exit (corner cell થી diagonal બહાર) = બંને edges cross ⇒ કોઈ એક edge segment walled હોય તો bump. M006/M014/M086 cell પર diagonal lane ⇒ bump (orthogonal-only devices). M024 Wide lines diagonal નહીં (validator). | §3.1 |
| EC-M052 | Lane બીજા bumper પર ફરી વળે (chain). Bumper board edge પર હોય અને turn પછી તરત board બહાર ⇒ exit valid. Diagonal pass-through લાઈન body bumper cell પર મૂકી શકાય નહીં (validator). | §3.2 |
| EC-M053 | એક જ lane માં બે blocks સળંગ ⇒ પહેલો block પાછળ બીજો block ⇒ not free ⇒ bump (chain push નહીં). Chained pair (M011) માં એક member push કરે અને બીજો exit/bump ⇒ group atom: કોઈ member bump ⇒ આખું group bump (push પણ નહીં). | §3.3 |
| EC-M054 | Slide board edge પર: છેલ્લા cell પર અટકે (બહાર ન પડે). Slide દરમિયાન block beam (M084) ના cell પરથી પસાર: final position પરથી જ beam recompute (step 4). | §3.4 |
| EC-M055 | Slide (M054) plate પરથી પસાર થઈ આગળ જાય ⇒ plate press નહીં (final cell જ ગણાય). Gate cell પર line body હોય અને gate બંધ થાય ⇒ allowed (gate માત્ર lanes block કરે; body અંદર રહે). | §3.5 |
| EC-M056 | Ramp cell પર line body હોય તો body નું layer બદલાતું નથી (માત્ર lanes). Ramp પછી ના cell પર ઊંચા layer ની line હોય ⇒ નવો layer blocked. Cover-lock relocation પછી નવી રીતે compute. | §3.6 |
| EC-M057 | N ≥ 1. Lane check action resolve (step 1) માં **current** state (Move પહેલાંનો) વાપરે; flip step (3) માં. | §3.7 |
| EC-M058 | Arrow lane check Move પહેલાંના `moveCount` પ્રમાણે. Bump પણ Move ⇒ arrow ફરે (player bump થી rotate કરાવી શકે — validator: solution bump વગર). | §3.8 |
| EC-M059 | M072 Garland Order **tap-time color** વાપરે (paint પહેલાંનો); M062/M095 quota **exit-time color** (paint પછીનો). M041 Rainbow Pollen line paint પછી પણ cycle ચાલુ રાખે (paint = current color set). | §3.9 |
| EC-M060 | Swap પછી cover-lock ફરી compute (step 4). Swap પછી body ત્યાં hidden fog હોય તો line hidden બને. | §3.10 |
| EC-M061 | એક Move માં cap કરતાં વધુ lines (group) ⇒ group bump. Cap 0 થાય તે જ Move ના પછીના groups માટે બંધ. | §3.11 |
| EC-M062 | Corner diagonal exit: crossed બંને sides માંથી કોઈ marked હોય ⇒ 1 વાર ગણાય. Quota અશક્ય banner engine `goalReachable()` થી step (6) પછી. | §3.12 |
| EC-M063 | Pull પછી line lure ને અડે ⇒ આગળ pull નહીં. Pull ના કારણે ant bee ની નીચેથી ખસે ⇒ cover-lock step (4) માં recompute. Lure ની line of sight blocked હોય તો પણ pull (ગંધ પહોંચે). | §3.13 |
| EC-M064 | Chained pair ના બંને members open gate પરથી પસાર ⇒ 2 flips ⇒ net no change. | §3.14 |
| EC-M065 | Cover clear થયા પછી key icon દેખાય પણ line હજી બીજા કારણે locked હોઈ શકે. Leaf Blower hidden line target નહીં (§16.8). | §3.15 |
| EC-M066 | Member નું exit lane બીજા member ના body માંથી પસાર ⇒ blocked (simultaneous નહીં). | §3.16 |
| EC-M067 | Collapse સમયે cell પર ant body હોય (M063/M082 થી આવી) ⇒ collapse deferred, cell ખાલી થાય તે Move ના step (3) માં. | §3.17 |
| EC-M068 | Drops ની નીચે/ઉપર બીજા layer ની lines સામાન્ય. Drop cell પર પછી body આવી શકતી નથી (blocker). | §3.18 |
| EC-M069 | Ramp `[1,2]` (Warm Updraft) L691+. 3-deep stack (canopy ⊃ air ⊃ ant) ⇒ ઉપરથી નીચે ક્રમે જ. Fog (M010/M075) ત્રણેય layers છુપાવે. | §3.19 |
| EC-M070 | Tangled line ફરી rotate થી untangle. Validator: કોઈ line દરેક rotation (k=0..3) માં tangled નહીં. | §3.20 |
| EC-M071 | Q-th exit ના જ Move માં બીજી line ની lane (group) આ edge વાપરી શકતી નથી (open step 4 માં). Corner diagonal exit: §01 corner rule. | §3.21 |
| EC-M072 | Pattern ના બધા colors બાકી lines માં ન હોય ⇒ auto-skip ensures no deadlock. Pointer M041 Rainbow line ની tap-time color જુએ. | §3.22 |
| EC-M073 | Bubble pop પણ Move ⇒ counters tick. એક Move માં બે bubbles hit (group) ⇒ બંને ફૂટે. | §3.23 |
| EC-M074 | Lever cell પર line body નહીં (validator). Lever pull પછી Undo ⇒ wall પાછી (Move undo). | §3.24 |
| EC-M075 | Growth key line ને ઢાંકે ⇒ key hidden (M065 interplay). Two areas merge નથી થતા (દરેક area અલગ id; cell પહેલેથી બીજા area નો ⇒ not free). | §3.25 |
| EC-M076 | Diagonal lane portal માંથી diagonal જ નીકળે. Exit portal ની આગળનો cell blocked ⇒ bump at exit portal. | §3.26 |
| EC-M077 | 3×3 board edge પર clip. Push blocks (M053) hammerable ⇒ ઉડી જાય. Chain: 3×3 માં બીજો puffball ⇒ ફૂટતો નથી (not hammerable). | §3.27 |
| EC-M078 | M062/M071/M095 edge mechanics greenhouse levels માં નહીં (validator). | §3.28 |
| EC-M079 | Rotation પહેલાં animation પૂરું થાય; rotation દરમિયાન input queue. Beam emitters ફરે ⇒ step (4) recompute. | §3.29 |
| EC-M080 | Chain bump ⇒ કોઈ exit નહીં ⇒ locks બંધ. Chain નું lane તેના જ lock થી blocked ન હોય (validator). | §3.30 |
| EC-M081 | Multiple copycats: બધા એ જ dir. Bubble-pop bump પણ move ગણાય. Leaf Blower removal "move" નથી. | §3.31 |
| EC-M082 | બે lines એક જ brook પર: આગળની (flow દિશામાં) પહેલાં ખસે, પછી પાછળની. Partially-on line ખસે નહીં. | §3.32 |
| EC-M083 | Plate 2×1 અથવા 2×2 હોઈ શકે; wide line નો કોઈ પણ cell plate પર ⇒ pressed. | §3.33 |
| EC-M084 | Beam ને રોકતી line exit થાય ⇒ beam step (4) માં લંબાય — એ જ Move ની lane check pre-move beam વાપરે. Beam cell પર body allowed નથી (body beam ને રોકે જ). | §3.34 |
| EC-M085 | Receiver beam ને અટકાવે (absorbs). બે beams hit ⇒ lit. | §3.35 |
| EC-M086 | Beam બંને બાજુથી reflect (double-sided). M079 rotation પર orient swap. | §3.36 |
| EC-M087 | Stuck + M012 Napping: બંને taps ક્રમ: unstick, wake, exit (3 Moves). Hint stuck line પર unstick ને Move તરીકે બતાવે. | §3.37 |
| EC-M088 | Key-line નું lane તેના જ snare થી blocked નહીં (validator). | §3.38 |
| EC-M089 | બે બાજુથી beams ⇒ દરેક અલગ split. Split beam તરત board edge ⇒ ignore. | §3.39 |
| EC-M090 | Undo parity revert (moveCount −1). Locked tap parity બદલતો નથી. | §3.40 |
| EC-M091 | Center cell પર line body allowed (hub tap priority control). 2 rotors overlapping નહીં (validator). | §3.41 |
| EC-M092 | M003 adjacency / fog touch: line ના current body પ્રમાણે. Key icon head segment પર ⇒ પણ hook છેલ્લા segment પર (line exit). | §3.42 |
| EC-M093 | Back half નો `dir` opposite હોવાથી head body તરફ (bent body) ⇒ tangled ⇒ locked tap (validator avoid). M028/M072 માં halves same number/color ⇒ બંને eligible. | §3.43 |
| EC-M094 | એક lane માં paint (M059) પછી bowl ⇒ ક્રમમાં apply. Color-blind glyphs: mixed colors ના પોતાના glyphs. | §3.44 |
| EC-M095 | Hammered line color = removal સમયનો color. Validator: quota પૂરતી lines. | §3.45 |
| EC-M096 | Invisible shadow line બીજી line ને cover-lock નથી કરતી (non-blocking, absent). Invisible વખતે નીચેની line ને tap મળે. | §3.46 |
| EC-M097 | Leaf Blower d2… ને target ન કરી શકે (માત્ર d1). Toadstool cells પર line body નહીં (validator). M077 puffball ના 3×3 માં d1 ⇒ chain trigger; d2+ માત્ર ⇒ અસર નહીં (not hammerable). | §3.47 |
| EC-M098 | HP 0 એ જ Move માં patrol tick નહીં (vanished). Beetle બીજી line પર ચાલી શકતો નથી ⇒ waits. | §3.48 |
| EC-M099 | Keys પૂરી થાય પછી receiver lit ન હોય ⇒ રાહ; પછી beam route ખુલે એ Move માં open. Open પછી receiver બંધ થાય તો પણ door ખુલ્લો. | §3.49 |

QA rows + unit tests per M-ID: [06 §9–§10](./06_FRONTEND_AND_QA_PHASE_2.md).

# 03 — Obstacle Catalog, Phase 2 (M051–M099 + Finale)
> Phase 2 ના 49 mechanics ના exact rules (standard §10 Phase 2 table), jungle themed names, JSON schema v3, implementation notes, level-design usage અને edge cases — એક card per mechanic.

**Related docs:** [Phase 2 index](./README.md) · [Shared Core Standard §10, §12, §16](../../SHARED_CORE_STANDARD.md) · [01 Phase 2 Rules](./01_PHASE_2_SCOPE_AND_RULES.md) · [02 Progression](./02_LEVEL_PROGRESSION_0501_1000.md) · [Phase 1 Catalog](../phase_1/03_OBSTACLE_CATALOG_PHASE_1.md) · [06 Frontend & QA](./06_FRONTEND_AND_QA_PHASE_2.md)

---

## 1. Summary Table (M051–M099)
Categories: **B** Static Blocker · **K** Key/Lock · **C** Counter (Move-based) · **T** Toggle/Interactive · **P** Path-variant · **D** Direction changer · **L** Layer · **G** Goal/Helper · **X** Boss. "Hammer" = Magic Stone Hammer (Hammer) default (standard §16.18). "N" = D formula માં non-monotone instance.

| ID | Intro | Cat | Themed name | Generic | Hammer | N |
|---|---|---|---|---|---|---|
| — | L501–510 | — | Big Garden Onboarding | Onboarding (zoom/pan) | — | — |
| M051 | L511 | P | Sidewinder Snake | Diagonal Paths | snake ✅ | — |
| M052 | L521 | D | Rubber Root Bumper | Corner Bumper | ❌ | — |
| M053 | L531 | T | Rolling Coconut | Push Block | ✅ | ✅ |
| M054 | L541 | D | Slick Moss | Ice Floor | ❌ (moss) | ✅ |
| M055 | L551 | T | Coconut Cradle | Block Plate | ❌ | ✅ |
| M056 | L561 | L | Liana Ramp | Ramp | ❌ | — |
| M057 | L571 | C | Firefly Lantern Gate | Traffic Light | ❌ | ✅ |
| M058 | L581 | D | Spinning Leaf Arrow | Rotating Arrow | ❌ | ✅ |
| M059 | L591 | P | Berry Paint Puddle | Paint Cell | ❌ | — |
| M060 | L601 | T | Toad Swap Stone | Swap Pad | ❌ | ✅ |
| M061 | L611 | G | Sleepy Den | Capacity Hole | ❌ | — |
| M062 | L621 | G | Picnic Exit Quota | Edge Quota | ❌ | — |
| M063 | L631 | C | Honey Pot | Magnet Blocker | ❌ | ✅ |
| M064 | L641 | T | Seesaw Branch Gates | Seesaw Gates | ❌ | ✅ |
| M065 | L651 | K | Buried Leaf-Key | Hidden Key | ❌ | — |
| M066 | L661 | P | Vine-Tied Triplets | Chained Triplet | snake ✅ | — |
| M067 | L671 | C | Crumbly Soil | Collapsing Floor | ❌ | — |
| M068 | L681 | C | Slime Trail Snake | Trail Blocker | snake ✅ (trail ❌) | ✅ |
| M069 | L691 | L | Treetop Tiers | Three Layers | snake ✅ (uncovered) | — |
| M070 | L701 | T | Wind Totem Lever | Global Rotator | ❌ | ✅ |
| M071 | L711 | B | Counting Hedge Gate | Quota Edge | ❌ | — |
| M072 | L721 | P | Rainbow Parade | Color Sequence | snake ✅ (next colour only) | — |
| M073 | L731 | P | Dew Bubble Snake | Bubble Path | snake ✅ | — |
| M074 | L741 | B | Temple Stone Wall | Armored Wall | ❌ (standard) | — |
| M075 | L751 | C | Creeping Mist | Creeping Fog | ❌ | ✅ |
| M076 | L761 | D | Burrow Network | Portal Network | ❌ | — |
| M077 | L771 | X | Boom Puffball | Bomb Blocker | ❌ | — |
| M078 | L781 | B | Walled Garden | Center-Only Exit | ❌ | — |
| M079 | L791 | T | Whirlwind Garden | Board Rotator | — | ✅ |
| M080 | L801 | K | Twin Bamboo Cages | Twin Locks | ❌ (key snakes not targets) | — |
| M081 | L811 | P | Copycat Snake | Mimic Path | snake ✅ | ✅ |
| M082 | L821 | D | River Current | Conveyor | ❌ | ✅ |
| M083 | L831 | T | Heavy Mossy Stone | Heavy Plate | ❌ | ✅ |
| M084 | L841 | B | Sunbeam Crystal | Laser Emitter | ❌ | ✅ |
| M085 | L851 | T | Sunflower Receiver | Laser Receiver | ❌ | ✅ |
| M086 | L861 | D | Dewdrop Mirror Leaf | Beam Mirror | ❌ | — |
| M087 | L871 | P | Tree Sap Puddle | Glue Pad | snake ✅ | — |
| M088 | L881 | K | Thorny Burr Trap | Lane Mine | ❌ | — |
| M089 | L891 | D | Crystal Prism Flower | Prism | ❌ | — |
| M090 | L901 | C | Tick-Tock Toadstool Gate | Parity Gate | ❌ | ✅ |
| M091 | L911 | T | Great Whirl Stump | Rotor 3×3 | ❌ | ✅ |
| M092 | L921 | P | Bead Millipede | Segmented Path | snake ✅ (whole) | — |
| M093 | L931 | P | Fork-Tail Splitter | Splitter Path | snake ✅ | — |
| M094 | L941 | P | Berry Mixer Puddle | Color Mixer | ❌ | — |
| M095 | L951 | B | Rainbow Hedge Gates | Color Quota Edge | ❌ | — |
| M096 | L961 | P | Shadow Snake | Shadow Path | snake ✅ (visible only) | ✅ |
| M097 | L971 | B | Bamboo Domino Poles | Domino Chain | first pole ✅, others ❌ | — |
| M098 | L981 | X | Prowling Mongoose | Moving Guardian | ❌ (standard) | ✅ |
| M099 | L991 | K | Sun Temple Master Lock | Master Lock | ❌ | — |
| — | L1000 | X | Mongoose Emperor's Sun Temple | Phase 2 Finale | — | — |

## 2. Conventions (બધા cards માટે)
### 2.1 JSON (schema v3)
- Phase 1 conventions ([Phase 1 catalog §2](../phase_1/03_OBSTACLE_CATALOG_PHASE_1.md#2-conventions-બધા-cards-માટે)) યથાવત: `{"id", "type": "M0xx", "cells", "params", "hammerable"}`, snake-linked mechanics `params.path` / `params.paths` થી.
- Directions: `U, D, L, R, UL, UR, DL, DR`. Gate/edge sides: `U, D, L, R`.
- **Marker entries** (M051, M069, M078): `cells: []`, D formula ના `O` માં ગણાતી નથી; validator cross-check (દા.ત. M051 list = diagonal-dir paths).
- `hammerable` દરેક instance પર; standard §16.18 values validator lock કરે (M053 = true, M074 = false, M098 = false).

### 2.2 Engine Hooks (Phase 2 additions)
Phase 1 hooks (`blocksLane`, `redirect`, `isLocked`, `onTap`, `onPathExit`, `onMoveTick`, `encode`) + :

| Hook | ક્યારે | Use |
|---|---|---|
| `onLanePass(cell, ctx)` | Successful lane trace ના દરેક cell પર (step 1, exit/relocate માત્ર) | Paint, mixer, seesaw, crumbly soil, buried key collect |
| `onPushInto(cell, block)` | Push resolution | Free-cell check, slick moss slide |
| `beam(cell, dir) → BeamAction` | Step 4 beam trace | `pass`, `stop`, `reflect(dir)`, `split(d1, d2)`, `light` |
| `derive(state)` | Step 4 | Plates, receivers, locks, fog |
| `transform(rotation)` | M070 / M079 | Dirs, orientations, cells rotate |
| `isOccupying(cell)` | Push / pull / patrol / conveyor | Physical occupancy (blocking થી અલગ, M096 માટે) |

### 2.3 Hammer Rules (Phase 2)
- Standard §16.8, §16.31 યથાવત: covered / hidden / invisible (M096 odd) snake target નથી; hammered snake exit ગણાય — non-lane triggers (keys, HP, quotas M071/M095, puffball, dominoes, sequence) ચાલે, lane triggers (paint, gems, crumbly soil, seesaw, buried-key collect, edge quota M062, den capacity M061) **નહીં**.
- **Undo after Hammer:** Hammer use પછી Coil-Back Undo history clear (standard §16.23) — Undo button disabled જ્યાં સુધી નવો Move ન થાય.
- **Phase 2 Hammer guards** (target invalid + toast; booster consume નહીં): M062 quota અશક્ય બને, M072 non-next colour, M080 twin key snakes, gems બાકી હોય ત્યારે છેલ્લો snake (standard §16.31).

## 3. Mechanic Cards
Card format: Rule → Tap/bump → Heart → Hammer → Hint/solver → Visual & audio → JSON → Implementation → Do/Don't → Combos → Edge cases.

---

### Onboarding — Big Garden (L501–510)
| Field | Value |
|---|---|
| Category | — (no new mechanic) |
| Rule | 12×12 boards (L505: 11×11), pinch-zoom + pan ([01 §2](./01_PHASE_2_SCOPE_AND_RULES.md#2-pinch-zoom--pan)); Phase 1 mechanics review |
| Validator | `mechanics[].type` ⊂ M001–M049; grid 11–12; tutorial ids `p2_1_pinch` … `p2_8_remember_zoom` |

---

### M051 — Sidewinder Snake (Diagonal Paths)
| Field | Value |
|---|---|
| Intro / Category | L511 · P |
| Rule | Snake ની `dir ∈ {UL, UR, DL, DR}`; exit lane diagonal (`head + k·(dx,dy)` edge સુધી). Body 8-connected, `body[1] = body[0] − dir`. **No X-crossing:** diagonal step blocked જો target cell blocked **અથવા** બંને orthogonal side cells એક જ snake ના consecutive body cells ([01 §3.3](./01_PHASE_2_SCOPE_AND_RULES.md#33-diagonal-lane)) |
| Tap / bump | Normal tap; blocked ⇒ bonk at blocker (diagonal) |
| Heart effect | Bump ⇒ −1 |
| Hammerable | Snake ✅ |
| Hint / solver | Stateless; lane trace 8-dir. Reverse construction diagonal lanes સાથે ચાલે |
| Visual & audio | Sandy-belly sidewinder, S-curve sideways slither; eyes diagonal જુએ; head પર tiny diagonal arrow chevron (colour-blind); `sfx_sidewind` |

```json
{"id": "o1", "type": "M051", "cells": [], "params": {"paths": ["p1", "p4"]}, "hammerable": false}
```
Path: `{"id": "p1", "color": "green", "dir": "UR", "body": [[4,5],[3,6],[2,7]], "layer": 0, "mods": {}}`
- **Implementation:** `Dir` enum 8 values + `(dx, dy)`; `LaneTracer.step()` generic; squeeze check `linkCrosses(c, d)` uses per-snake link set `{(a,b)}` (static per state). Renderer: track segments diagonal length √2 ([06 §4](./06_FRONTEND_AND_QA_PHASE_2.md#4-diagonal-lanes--slither-rendering)).
- **Do:** Intro માં 2–3 sidewinders orthogonal snakes ની rows ક્રોસ કરે; "આ ત્રાંસો સાપ પહેલાં" chains.
- **Don't:** Diagonal lane M014 / M018 / M086 સુધી (ban); Giant Anaconda diagonal (ban); 3+ diagonal links એક જ cluster માં X-pattern (readability).
- **Combos:** M052 Rubber Root Bumper, M008 Rabbit Burrows, M038 Bouncy Fern Pad, M020 Home Burrow.
- **Edge cases:** corner cell થી diagonal exit = valid exit; બે અલગ snakes ના corner-touch વચ્ચેથી pass; M006 one-way ⇒ always blocked.

---

### M052 — Rubber Root Bumper (Corner Bumper)
| Field | Value |
|---|---|
| Intro / Category | L521 · D |
| Rule | Bumper cell, `face: "H"` અથવા `"V"`. **Diagonal** lane bumper cell માં પ્રવેશે ⇒ 90° deflect અને એ જ cell થી આગળ: `H` ⇒ vertical component flip (UR↔DR, UL↔DL); `V` ⇒ horizontal flip (UR↔UL, DR↔DL). **Orthogonal lane ⇒ bumper solid blocker** (bump) |
| Tap / bump | Bumper tap ignore. Deflect પછી blocked ⇒ bonk at blocker |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Static redirect; lane loop check (same cell + dir twice ⇒ validator reject, runtime bump) |
| Visual & audio | Springy curled root arch (H = horizontal, V = vertical); diagonal hit ⇒ root wobble + `sfx_root_boing` |

```json
{"id": "o2", "type": "M052", "cells": [[6,3]], "params": {"face": "H"}, "hammerable": false}
```
- **Implementation:** `CornerBumper(cell, face)`; `redirect(cell, d)` ⇒ `d.isDiagonal ? flip(d, face) : null`; `blocksLane` = `!d.isDiagonal`. Snake body bumper cell પર નહીં (validator). Exit track bumper center પર corner radius 0.3 cell.
- **Do:** Sidewinder ને board ના બીજા ખૂણા તરફ વાળો; 1–2 bumpers per intro.
- **Don't:** Bumper ને orthogonal snake ના lane માં "trap" તરીકે (confusing) — intro માં નહીં.
- **Combos:** M051, M053 (deflected lane coconut ને diagonal push કરે), M020.
- **Edge cases (defined):** orthogonal lanes માટે solid (standard §17.2); deflect પછી તરત board edge ⇒ exit.

---

### M053 — Rolling Coconut (Push Block)
| Field | Value |
|---|---|
| Intro / Category | L531 · T |
| Rule | Lane coconut સુધી clear હોય અને coconut ની પાછળનો cell (lane direction) **free** ⇒ coconut 1 cell ખસે; snake **પોતાની જગ્યાએ રહે**. = 1 Move, no heart. પાછળ free નથી ⇒ bump. **Open board edge** પાર ધક્કો ⇒ coconut પડીને **remove** (standard §17.29); walled/closed edge ⇒ bump. Free-cell definition, no chain push: [01 §5.1](./01_PHASE_2_SCOPE_AND_RULES.md#51-exact-rule) |
| Tap / bump | Push = head coconut સુધી જઈ nudge + પાછો (220 ms); bump = normal bonk |
| Heart effect | Push 0; bump −1 |
| Hammerable | ✅ (standard §16.18) |
| Hint / solver | State: coconut cells. Push = S +1. Non-monotone (coconut પાછો ધકેલાઈ શકે) |
| Visual & audio | Hairy brown coconut, rolls with rotation; `sfx_coconut_roll`, blocked ⇒ `sfx_coconut_thud` |

```json
{"id": "o3", "type": "M053", "cells": [[5,5]], "params": {}, "hammerable": true}
```
- **Implementation:** `PushBlock(cell)`; `LaneTracer` returns `HitPushable(block, dir)` ⇒ engine `tryPush(block, dir)` ⇒ `onPushInto(next)` chain (moss slide). Coconut blocks all layers. Render: dynamic sprite (moving layer only during push).
- **Do:** "Coconut ને ક્યાં ધકેલવું?" — એક push ખોટી જગ્યાએ ⇒ બીજા snake નો રસ્તો બંધ (Coil-Back Undo).
- **Don't:** Coconut ને corner માં deadlock (no snake can push it out) જ્યારે તે જરૂરી રસ્તો રોકે — solver પકડે.
- **Combos:** M054, M055, M084 (coconut beam રોકે), M077 (puffball coconut ઉડાડે).
- **Edge cases:** blocker head ના તરત આગળ coconut ⇒ head 0.25 cell nudge, coconut ખસે; diagonal lane ⇒ diagonal push; coconut gate cell માં (open હોય તો પણ) ⇒ not free; coconut edge cell પર અને પાછળ **open edge** ⇒ roll-off animation, coconut removed (1 Move, no heart, કશું count નહીં); Hedge Border / closed gap ⇒ bump.

---

### M054 — Slick Moss (Ice Floor)
| Field | Value |
|---|---|
| Intro / Category | L541 · D |
| Rule | Pushed coconut slick moss cell પર આવે ⇒ આગળનો cell free હોય ત્યાં સુધી push direction માં સરકતો રહે; non-moss cell પર પહોંચે ⇒ ત્યાં અટકે; આગળ not free ⇒ છેલ્લા moss cell પર અટકે. **Snakes ક્યારેય slide નથી કરતા;** lanes moss પરથી normal પસાર |
| Tap / bump | Moss tap ignore |
| Heart effect | — |
| Hammerable | ❌ moss tile (coconut on moss ✅ — standard "M053/M054 blocks") |
| Hint / solver | Part of push resolution; slide deterministic |
| Visual & audio | Glossy dark-green moss with water sheen; slide ⇒ `sfx_moss_slide` + water streak |

```json
{"id": "o4", "type": "M054", "cells": [[3,4],[4,4],[5,4],[6,4]], "params": {}, "hammerable": false}
```
- **Implementation:** `IceFloor(cells)`; `onPushInto(cell)` ⇒ if moss ⇒ continue. Slide animation 120 ms/cell, total ≤ 450 ms (max 3 slide cells per push enforced by validator, longer runs ⇒ split moss).
- **Do:** Moss strip ⇒ coconut એક push માં દૂર સુધી.
- **Don't:** 4+ cell moss run (animation limit).
- **Combos:** M053, M055 (slide into cradle), M029 Hedge Border.
- **Edge cases:** moss run cradle માં પૂરું ⇒ coconut cradle પર અટકે (cradle non-moss); moss run open board edge સુધી ⇒ coconut સરકીને પડી જાય અને remove (standard §17.29); walled edge ⇒ છેલ્લા moss cell પર અટકે.

---

### M055 — Coconut Cradle (Block Plate)
| Field | Value |
|---|---|
| Intro / Category | L551 · T |
| Rule | Plate cell, linked twig gates. **Coconut (M053) cradle પર હોય ત્યાં સુધી** linked gates open; coconut ખસે ⇒ closed. Snake body / lane cradle ને activate નથી કરતા |
| Tap / bump | Cradle tap ignore. Closed gate ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ cradle. Cradle પર બેઠેલો coconut ✅ (standard §16.18 "M053/M054 blocks"): hammer ⇒ coconut removed ⇒ step 4 માં cradle release ⇒ linked gates close |
| Hint / solver | Derived (step 4) |
| Visual & audio | Woven leaf nest; coconut settles ⇒ gate vines curl up `sfx_nest_click` |

```json
{"id": "o5", "type": "M055", "cells": [[8,2]], "params": {"gates": [[4,9],[5,9]]}, "hammerable": false}
```
- **Implementation:** `BlockPlate(plate, gates)`; `derive` ⇒ open = blocks ∋ plate. Gate cells: no snake body, no coconut (not free).
- **Do:** "Coconut પહેલાં cradle પર, પછી gate પાછળના snakes."
- **Don't:** Gate ખુલ્યા પછી coconut ફરી ખસેડવો ફરજિયાત (frustration) — intro માં નહીં.
- **Combos:** M053, M054, M064.
- **Edge cases (defined):** cradle-coconut hammer ⇒ gates close; level unwinnable બને તો soft-lock "Stuck" sheet (Undo / Restart, standard §17.31). Hammer Undo history clear કરે (§16.23), એટલે Hint/solver toast "This coconut holds the gate open" Hammer target mode માં બતાવે.

---

### M056 — Liana Ramp (Ramp)
| Field | Value |
|---|---|
| Intro / Category | L561 · L |
| Rule | Ramp cell, `layers: [a, b]`. Layer `a` નો lane ramp cell માં પ્રવેશે ⇒ ramp cell થી આગળ lane **layer `b`** પર ચાલે (layer b ના snakes થી blocked), અને vice versa. બીજા layers (3-layer levels) માટે ramp transparent. Exit successful ⇒ snake layer b પર ચઢીને બહાર |
| Tap / bump | Ramp tap ignore. Ramp પછી blocked ⇒ bonk, snake મૂળ layer + position પર પાછો |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Static per layer; lane state = (cell, dir, layer) |
| Visual & audio | Hanging liana vine sloping up/down; climb ⇒ `sfx_vine_climb`, snake z-order change mid-exit |

```json
{"id": "o6", "type": "M056", "cells": [[5,7]], "params": {"layers": [0, 1]}, "hammerable": false}
```
- **Implementation:** `Ramp(cell, a, b)`; `redirect` returns same dir + `layerSwitch`. Level `layers ≥ 2` (L561–690: 2-layer with M032; L691+: 3-layer). Snake body ramp cell પર નહીં.
- **Do:** Ground snake canopy snakes ની ઉપરથી "ચઢીને" નીકળે.
- **Don't:** Ramp chain ⇒ lane 3 વાર layer બદલે (readability).
- **Combos:** M032 Canopy & Ground, M069, M015.
- **Edge cases (defined):** pair બહારના layer માટે transparent; ramp → ramp ⇒ ફરી switch.

---

### M057 — Firefly Lantern Gate (Traffic Light)
| Field | Value |
|---|---|
| Intro / Category | L571 · C |
| Rule | Gate cell `n` (2–4) અને `initialOpen`. State: `open = initialOpen XOR (floor(moveCount / n) mod 2 == 1)` — દર `n` Moves એ open ↔ closed (step 3 tick). Lane trace Move ની શરૂઆતની state વાપરે |
| Tap / bump | Gate tap ignore. Closed ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | State: `moveCount mod 2n` (periodic) |
| Visual & audio | Lantern of fireflies: glowing = open (fireflies spread), dark = closed (fireflies huddle); badge = Moves until switch; `sfx_firefly_chime` |

```json
{"id": "o7", "type": "M057", "cells": [[6,0]], "params": {"n": 3, "initialOpen": true}, "hammerable": false}
```
- **Implementation:** `TrafficLight(cell, n, initialOpen)`; pure function of `moveCount` (no own state) ⇒ Undo free. Gate cell no snake body.
- **Do:** Player ને lever/Coconut "wait Moves" વાપરવા શીખવો.
- **Don't:** `n = 1` (Toadstool Gate નું કામ).
- **Combos:** M053 push as wait-Move, M073 bubble pop wait, M009.

---

### M058 — Spinning Leaf Arrow (Rotating Arrow)
| Field | Value |
|---|---|
| Intro / Category | L581 · D |
| Rule | One-way tile (M006 rule) જેનો arrow દરેક Move એ **90° CW** ફરે (step 3): `arrow = rotateCW(initial, moveCount)`. Lane ત્યારે જ પસાર થાય જ્યારે lane dir == arrow (Move શરૂઆતની state). Diagonal lane ⇒ always blocked |
| Tap / bump | Tile tap ignore |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | State: `moveCount mod 4` |
| Visual & audio | Big leaf with vein arrow, spins with a soft whoosh `sfx_leaf_spin` |

```json
{"id": "o8", "type": "M058", "cells": [[4,6]], "params": {"initial": "U"}, "hammerable": false}
```
- **Implementation:** `RotatingArrow(cell, initial)`; stateless (moveCount derived). Next-arrow ghost preview (faint).
- **Do:** 2 arrows અલગ phase ⇒ timing puzzle.
- **Don't:** 3+ arrows એક lane માં (practically unsolvable read).
- **Combos:** M057, M090, M053.

---

### M059 — Berry Paint Puddle (Paint Cell)
| Field | Value |
|---|---|
| Intro / Category | L591 · P |
| Rule | Puddle `color`. **Successful** lane (exit અથવા mud relocation) puddle પરથી પસાર ⇒ snake નો colour = puddle colour, **એ જ lane ના આગળના cells** (Flower Gate M005, Flower Arch Exit M030) અને exit-time effects (M033, M062, M072, M095) નવો colour જુએ. Bump ⇒ colour બદલાતો નથી |
| Tap / bump | Puddle tap ignore |
| Heart effect | — |
| Hammerable | ❌ |
| Hint / solver | Lane trace running colour; relocated snake ની colour state માં |
| Visual & audio | Squashed-berry puddle; snake passes ⇒ colour wipe animation head → tail + `sfx_berry_splash`; pattern પણ બદલાય (colour-blind) |

```json
{"id": "o9", "type": "M059", "cells": [[3,3]], "params": {"color": "blue"}, "hammerable": false}
```
- **Implementation:** `PaintCell(cell, color)`; `LaneTracer` carries `runningColor`; `onLanePass` sets. Preview (long-press) running colour થી gate checks બતાવે.
- **Do:** Red snake ⇒ blue paint ⇒ blue Flower Gate pass.
- **Don't:** Puddle ને snake ના પોતાના body cell પર (કોઈ અસર નહીં ⇒ confusing).
- **Combos:** M005, M030, M033, M062, M037 Mud (relocate + paint persist).

---

### M060 — Toad Swap Stone (Swap Pad)
| Field | Value |
|---|---|
| Intro / Category | L601 · T |
| Rule | Pad tap (1 Move) ⇒ 2 linked snakes **positions swap:** A ને B ના body cells + dir, B ને A ના. Identity (colour, keys, numbers, links) snake સાથે જાય. **Same shape only** (validator: body offsets equal by translation, same layer) |
| Tap / bump | Valid ⇒ 1 Move (300 ms toad hop). Linked snake exited ⇒ pad inert ⇒ locked tap |
| Heart effect | 0 |
| Hammerable | ❌ |
| Hint / solver | State: which identity at which slot (bit). Solution માં pad id |
| Visual & audio | Mossy stone with two sleepy toads; tap ⇒ toads croak and snakes "blink-swap" `sfx_toad_croak` |

```json
{"id": "o10", "type": "M060", "cells": [[0,11]], "params": {"paths": ["p3", "p8"]}, "hammerable": false}
```
- **Implementation:** `SwapPad(pad, a, b)`; `onTap` ⇒ exchange `body`, `dir`. Pad cell interactive (tap priority). Frost/keys attached by id ⇒ follow.
- **Do:** Key-snake ને clear lane વાળી જગ્યાએ swap.
- **Don't:** Swap થી કોઈ લાભ ન હોય (decoration).
- **Combos:** M004 key snake, M028 Hatch Order, M005.

---

### M061 — Sleepy Den (Capacity Hole)
| Field | Value |
|---|---|
| Intro / Category | L611 · G |
| Rule | Inner exit (M020 rule) capacity `n` (1–4): lane ત્યાં પહોંચે ⇒ snake અંદર exit, `n −= 1`. `n = 0` ⇒ den **closes** અને blocker બને (bump) |
| Tap / bump | Den tap ignore. Closed den ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | State: remaining `n` |
| Visual & audio | Cozy den with "n beds" sign; full ⇒ leaf door closes `sfx_den_shut` |

```json
{"id": "o11", "type": "M061", "cells": [[6,6]], "params": {"capacity": 2}, "hammerable": false}
```
- **Implementation:** `CapacityHole(cell, n)`; lane terminal while n > 0; `onPathExit` (lane-based) ⇒ n−1. Hammered snakes count નહીં.
- **Do:** M078 Walled Garden સાથે "કોને den માં મોકલવું?"
- **Don't:** Capacity < den સિવાય બહાર ન નીકળી શકે તેવા snakes ની સંખ્યા.
- **Combos:** M020, M078, M062.

---

### M062 — Picnic Exit Quota (Edge Quota)
| Field | Value |
|---|---|
| Intro / Category | L621 · G |
| Rule | **Goal:** colour `C` ના ≥ `Q` snakes marked edge segment (cells + side) **થી** exit થાય. Win = બધા snakes out + quota. Exit colour = paint પછીનો colour |
| Tap / bump | — |
| Heart effect | — |
| Hammerable | ❌. **Guard:** C-colour snake hammer ⇒ quota અશક્ય બને તો target invalid |
| Hint / solver | State: count. Dead-state: remaining C-capable snakes < Q − count ⇒ banner "Picnic goal can't be reached — Undo or Restart" (no heart loss) |
| Visual & audio | Picnic blanket flags on edge segment with colour + "3/4" counter; quota met ⇒ picnic basket opens `sfx_picnic_cheer` |

```json
{"id": "o12", "type": "M062", "cells": [[11,4],[11,5],[11,6]], "params": {"side": "R", "color": "yellow", "quota": 3}, "hammerable": false}
```
- **Implementation:** `EdgeQuota(cells, side, color, q)`; `onPathExit(p, lane)` lane-based, last lane cell ∈ cells && exit side == side && exitColor == color. Goal registry (gems જેવું) win check માં.
- **Do:** Paint puddles થી quota colour બનાવો.
- **Don't:** Quota = બધા C snakes (no choice) intro પછી.
- **Combos:** M059, M094, M052.
- **Edge cases (defined):** "quota impossible" ⇒ banner hint, not auto-fail (standard §17.8); hammered snakes M062 માં count **નથી**.

---

### M063 — Honey Pot (Magnet Blocker)
| Field | Value |
|---|---|
| Intro / Category | L631 · C |
| Rule | Honey cell = blocker. દરેક Move (step 3): same row/column માં **line of sight** વાળો (વચ્ચે કોઈ snake / blocking obstacle નહીં) **nearest** snake (honey થી snake ના નજીકના body cell સુધી cells) શોધો; tie ⇒ direction order U, R, D, L. તે snake ને આખો 1 cell honey તરફ **translate** કરો જો બધા destination cells free (board અંદર, બીજો snake નહીં, blocker નહીં, honey cell નહીં). Adjacent (distance 0) ⇒ pull નહીં. Dir બદલાતી નથી |
| Tap / bump | Honey tap ignore. Lane honey પર ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ (standard §16.18) |
| Hint / solver | State: snake positions; deterministic |
| Visual & audio | Clay honey pot with drip; pulled snake tongue-licks + slides `sfx_honey_slurp` |

```json
{"id": "o13", "type": "M063", "cells": [[6,6]], "params": {}, "hammerable": false}
```
- **Implementation:** `MagnetBlocker(cell)`; `onMoveTick` (Phase 2 slot 3). Single-layer levels only (combo ban).
- **Do:** Pull થી snake ને blocker પાછળથી lane માં લાવો.
- **Don't:** 2 honey pots same row (pull conflict).
- **Combos:** M001, M053, M057.
- **Edge cases (defined):** line-of-sight, tie order U,R,D,L, translate-whole-snake, adjacent ⇒ no pull; M032/M069/M010/M075 સાથે ban.

---

### M064 — Seesaw Branch Gates (Seesaw Gates)
| Field | Value |
|---|---|
| Intro / Category | L641 · T |
| Rule | 2 linked gates; **exactly one open** (`open: 0 | 1`). Successful lane (exit/relocate) open gate માંથી પસાર ⇒ Move ના અંતે (step 1 trigger) બંને flip. Bump lane ⇒ flip નહીં |
| Tap / bump | Gates tap ignore. Closed ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | State: open index (1 bit) |
| Visual & audio | Branch seesaw with a gate on each end; flip ⇒ creak + tilt `sfx_seesaw_creak` |

```json
{"id": "o14", "type": "M064", "cells": [[3,5],[8,5]], "params": {"open": 0}, "hammerable": false}
```
- **Implementation:** `SeesawGates(a, b, open)`; `onLanePass(a or b)` ⇒ mark flip; apply after lane resolve.
- **Do:** "કઈ બાજુનો snake પહેલો?" choice puzzles.
- **Don't:** બંને gates એક જ lane માં (lane ફરી closed gate મળે ⇒ confusing).
- **Combos:** M055, M057, M053.

---

### M065 — Buried Leaf-Key (Hidden Key)
| Field | Value |
|---|---|
| Intro / Category | L651 · K |
| Rule | Floor cell પર colour key token, Jungle Mist (M010/M075) **અથવા** snake body નીચે **hidden**. Cover clear થાય (mist clear / covering snake exit) ⇒ revealed. Revealed key પરથી પહેલો **successful lane** પસાર ⇒ collect ⇒ linked lock (same-colour Bamboo Cage M004 અથવા `params.lock`) કાયમ open |
| Tap / bump | Token tap ignore; lock closed ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ (token, lock). Covering snake hammer ⇒ reveal ✅; hammered snake collect **નહીં** (lane નથી) |
| Hint / solver | State: hidden/revealed/collected |
| Visual & audio | Hidden: small soil mound (no colour); revealed: golden leaf-key pops up `sfx_key_sparkle`; collect ⇒ flies to cage |

```json
{"id": "o15", "type": "M065", "cells": [[3,6]], "params": {"color": "blue", "lock": "o16"}, "hammerable": false}
```
- **Implementation:** `HiddenKey(cell, color, lock)`; `hidden` derived (mist covers || any body ∋ cell); `onLanePass` collect if !hidden. Covering snake નો પોતાનો exit lane key cell પરથી પસાર નથી ⇒ તે collect ન કરે.
- **Do:** Key ઉપર બેઠેલો snake પહેલાં, પછી બીજો snake key પરથી.
- **Don't:** Key ની ઉપર થી પસાર થતો એકમાત્ર lane lock પાછળ.
- **Combos:** M010, M004, M075, M099.
- **Edge cases (defined):** reveal = cover clear; collect = first successful lane after reveal; mound shows "something buried" (no colour leak).

---

### M066 — Vine-Tied Triplets (Chained Triplet)
| Field | Value |
|---|---|
| Intro / Category | L661 · P |
| Rule | 3 snakes vine થી જોડાયેલા (M011 × 3). કોઈ પણ tap ⇒ ત્રણેય exit try; ત્રણેયના lanes clear (એકબીજાનું body પણ blocker) ⇒ ત્રણેય exit; નહીં તો ત્રણેય bonk |
| Tap / bump | 1 Move |
| Heart effect | Group bump = **−1 total** (standard §16.7) |
| Hammerable | Snake ✅: hammered member exit, તેની vine તૂટે, બાકીના 2 **chained pair (M011)** તરીકે રહે |
| Hint / solver | Group = atomic action |
| Visual & audio | Braided vine across 3 tails; exit ⇒ synchronized triple wiggle `sfx_triplet_slither` |

```json
{"id": "o17", "type": "M066", "cells": [], "params": {"paths": ["p2", "p6", "p9"]}, "hammerable": false}
```
- **Implementation:** `ChainedGroup(paths)` (M011 code generalized, size 2–3). Validator: group lanes do not cross each other.
- **Do:** 1 member ને 2 snakes પહેલાં clear કરવા પડે.
- **Don't:** Triplet + Rainbow Parade (ban).
- **Combos:** M001, M053, M073 (bubble).

---

### M067 — Crumbly Soil (Collapsing Floor)
| Field | Value |
|---|---|
| Intro / Category | L671 · C |
| Rule | Cell `n` (1–3). દરેક successful lane pass (exit/relocate) ⇒ `passes += 1` (step 1). `passes == n` ⇒ step 3 (M067 slot) માં **sinkhole blocker** (lanes bump, not free). Collapse વખતે cell પર snake body / coconut હોય ⇒ vacate થાય ત્યાં સુધી defer |
| Tap / bump | Soil tap ignore; sinkhole ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ (soil અને sinkhole) |
| Hint / solver | State: passes |
| Visual & audio | Cracked dry soil with crack stages; collapse ⇒ crumble + dust `sfx_soil_crumble` |

```json
{"id": "o18", "type": "M067", "cells": [[5,3]], "params": {"n": 2}, "hammerable": false}
```
- **Implementation:** `CollapsingFloor(cell, n, passes, collapsed)`; bump lanes / hammered snakes / coconut slides count નહીં.
- **Do:** "આ રસ્તો માત્ર 2 વાર" resource puzzles.
- **Don't:** Collapse એવા cell પર જે કોઈ snake નો એકમાત્ર lane છે અને solution માં n વાર થી વધુ જરૂરી.
- **Combos:** M020, M061, M068.
- **Edge cases (defined):** deferred collapse (standard §16.12 જેવું); lane same cell ને portal થી બે વાર (અલગ dir) ⇒ 2 passes.

---

### M068 — Slime Trail Snake (Trail Blocker)
| Field | Value |
|---|---|
| Intro / Category | L681 · C |
| Rule | Marked snake successful exit થાય ⇒ તેના lane ના **board અંદરના** બધા cells (start body cells સિવાય) **slime** (blocker) બને, `ttl = 2`. Creation Move નો tick skip; પછીના 2 Moves દરમિયાન lanes bump; બીજા Move ના step 3 માં remove |
| Tap / bump | Slime ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | Snake ✅ (hammered ⇒ no lane ⇒ no slime); slime ❌ |
| Hint / solver | State: slime cells + ttl |
| Visual & audio | Shiny snail-like slime glisten, fades in 2 steps (opacity 100% → 50%); `sfx_slime_squish` |

```json
{"id": "o19", "type": "M068", "cells": [], "params": {"path": "p7", "ttl": 2}, "hammerable": false}
```
- **Implementation:** `TrailBlocker(pathId)`; `onPathExit(lane)` ⇒ `trail = lane.cells ∩ board`, `ttl = 2`, `skipTick = true`. Slime not free (coconut, patrol, honey pull).
- **Do:** Slime snake ને પહેલાં કાઢો, પછી 2 "બીજા" Moves.
- **Don't:** Slime snake છેલ્લો જરૂરી + બધા remaining lanes slime પરથી (wait Move ન હોય તો unsolvable — solver પકડે).
- **Combos:** M053 push (wait Move), M009 lever (wait), M067.
- **Edge cases (defined):** ttl semantics "creation Move tick skip"; slime gate/mechanic cells પર પણ (overlay).

---

### M069 — Treetop Tiers (Three Layers)
| Field | Value |
|---|---|
| Intro / Category | L691 · L |
| Rule | `layers: 3`: 0 Ground, 1 Canopy, 2 Treetop. Layer k snake locked જ્યાં સુધી layer > k નો કોઈ snake તેના કોઈ cell ને cover કરે. Lanes માત્ર પોતાના layer માં. Obstacles default બધા layers. Tap priority highest layer ([01 §4](./01_PHASE_2_SCOPE_AND_RULES.md#4-three-layers-m069-થી-m032-નું-extension)) |
| Tap / bump | Overlap ⇒ top snake. Covered ⇒ locked 🍃 |
| Heart effect | Bump ⇒ −1 |
| Hammerable | Uncovered snake ✅ |
| Hint / solver | Derived lock from remaining snakes |
| Visual & audio | Treetop snakes on leafy platform with larger soft shadow; covered ground snakes 35% desaturated; `sfx_leaf_rustle_high` |

```json
{"id": "o20", "type": "M069", "cells": [], "params": {"obstacleLayer": "all"}, "hammerable": false}
```
- **Implementation:** `ThreeLayers()` marker; `LayerIndex` per cell bitmask `[0..2]`. Lane trace filter `layer == p.layer`; obstacle `affects(layer)` default all.
- **Do:** Treetop 1–2 snakes ⇒ canopy ⇒ ground "peel" order.
- **Don't:** Snake પૂરેપૂરો ઢંકાયેલો; 3 layers + Night (M040).
- **Combos:** M056, M032, M004.

---

### M070 — Wind Totem Lever (Global Rotator)
| Field | Value |
|---|---|
| Intro / Category | L701 · T |
| Rule | Totem tap (1 Move) ⇒ **દરેક** snake ની `dir` 90° CW (`U→R→D→L`, `UR→DR→DL→UL`). Body બદલાતું નથી. M022 Reverse Slither: tail exit dir rotate; M023 Hydra: બંને end dirs |
| Tap / bump | 1 Move. Rotation પછી head પોતાના body (neck) તરફ ⇒ તે snake **"tangled"** ⇒ tap = **locked tap** 🌀 (no Move, no heart) જ્યાં સુધી dir ફરી ન બદલાય (standard §17.39). Rotation hidden snakes (mist/covered) ને પણ ફેરવે (§17.12) |
| Heart effect | Totem 0; tangled tap 0 |
| Hammerable | ❌ |
| Hint / solver | State: all dirs (rotation k mod 4 + local turntable changes) |
| Visual & audio | Carved wind totem with spinning feather; all snakes' heads swivel 250 ms `sfx_wind_gust` |

```json
{"id": "o21", "type": "M070", "cells": [[0,0]], "params": {}, "hammerable": false}
```
- **Implementation:** `GlobalRotator(cell)`; `onTap` ⇒ `paths.map((p) => p.copyWith(dir: p.dir.cw))`. Head sprite neck joint પર rotate (body static).
- **Do:** 2 taps = 180° ⇒ "ઉલટી બાજુ" exits.
- **Don't:** Rotation પછી ઘણા tangled snakes (validator warn ≥ 3).
- **Combos:** M013, M051, M079.
- **Edge cases (defined):** self-facing head ⇒ tangled locked tap (standard §17.39); hidden snakes rotate too (§17.12).

---

### M071 — Counting Hedge Gate (Quota Edge)
| Field | Value |
|---|---|
| Intro / Category | L711 · B |
| Rule | Edge segment (cells + side) **walled** જ્યાં સુધી કુલ `Q` exits (કોઈ પણ snake, કોઈ પણ route, hammered સહિત) ન થાય; પછી **કાયમ open** |
| Tap / bump | Closed segment ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | State: exit count (global) |
| Visual & audio | Hedge with wooden counter "5"; each exit ⇒ counter flips; open ⇒ hedge parts `sfx_hedge_open` |

```json
{"id": "o22", "type": "M071", "cells": [[0,4],[0,5],[0,6]], "params": {"side": "L", "quota": 5}, "hammerable": false}
```
- **Implementation:** `QuotaEdge(cells, side, q)`; open = exitedCount ≥ q (derived). Validator: Q ≤ P − (snakes requiring this edge).
- **Do:** "પહેલાં 5 સરળ snakes, પછી ડાબી બાજુ."
- **Don't:** Q ≈ P (છેલ્લે જ ખુલે ⇒ trivial).
- **Combos:** M029, M031, M078 ❌ (ban).

---

### M072 — Rainbow Parade (Color Sequence)
| Field | Value |
|---|---|
| Intro / Category | L721 · P |
| Rule | Pattern (2–4 colours) repeating, દા.ત. `[red, blue, yellow]`. આગલો required colour = `pattern[k mod len]` (k = sequence exits). Tap time નો colour ≠ required ⇒ **locked tap** 🌈. Correct colour exit ⇒ k+1; bump ⇒ k same. Pattern માં ન હોય તેવા colours unrestricted (standard §17.12); pattern colour ના કોઈ snakes બાકી ન હોય ⇒ તે colour skip (no deadlock, §17.40) |
| Tap / bump | Wrong colour ⇒ locked (no Move); correct but blocked ⇒ bonk |
| Heart effect | Locked 0; bump −1 |
| Hammerable | Snake ✅ **માત્ર next-colour** (k+1); બીજા ⇒ invalid target |
| Hint / solver | State: k |
| Visual & audio | Parade banner at board top showing pattern with pointer; current colour snakes softly bob; `sfx_parade_drum` on advance |

```json
{"id": "o23", "type": "M072", "cells": [], "params": {"pattern": ["red", "blue", "yellow"], "k": 0}, "hammerable": false}
```
- **Implementation:** `ColorSequence(pattern, k)`; `isLocked(p)` = colorAtTap(p) != pattern[k % len]. Paint lane દરમિયાન બદલાય ⇒ check & advance **tap-time colour** થી.
- **Do:** Natural order અને colour order અલગ.
- **Don't:** Groups (M011/M039/M048/M066/M080), M028, M093 સાથે (ban).
- **Combos:** M041 Chameleon (tap-time colour), M059.
- **Edge cases (defined):** tap-time colour rule; Hammer next-colour only; exhausted colours skipped (§17.40).

---

### M073 — Dew Bubble Snake (Bubble Path)
| Field | Value |
|---|---|
| Intro / Category | L731 · P |
| Rule | Snake dew bubble માં. **બીજા** snake નો lane તેને અથડાય ⇒ bubble **pops**, bumping snake પાછો આવે, **heart loss નહીં** (Move ગણાય). પછી normal snake (આગળના hits −1). Bubble snake નો પોતાનો exit normal |
| Tap / bump | Pop = bump animation + bubble burst |
| Heart effect | Pop 0 (Safety Shell Shield charge પણ વપરાતો નથી); later bumps −1 |
| Hammerable | Snake ✅ |
| Hint / solver | State: bubble intact bool. Pop = valid "wait" Move (counters tick) |
| Visual & audio | Iridescent dew bubble around snake; pop ⇒ droplets `sfx_bubble_pop` |

```json
{"id": "o24", "type": "M073", "cells": [], "params": {"path": "p5"}, "hammerable": false}
```
- **Implementation:** `BubblePath(pathId, intact)`; bump resolver: blocker == bubble snake && intact ⇒ `heartLoss = false`, intact = false. Stars: heart lost ગણાતું નથી.
- **Do:** Bubble pop ને Lantern Gate wait તરીકે.
- **Don't:** Bubble = solution માં એકમાત્ર wait Move without telling (intro card સમજાવે).
- **Combos:** M057, M090, M066.
- **Edge cases (defined):** group bump (M011/M066) ⇒ heart loss 0 **માત્ર જો** દરેક blocked member નો blocker intact bubble હોય; બધા hit bubbles pop.

---

### M074 — Temple Stone Wall (Armored Wall)
| Field | Value |
|---|---|
| Intro / Category | L741 · B |
| Rule | 1–4 straight cells wall, **not hammerable**. Linked **Temple lever** tap (1 Move) ⇒ wall કાયમ દૂર; lever પછી inert (tap ⇒ locked tap) |
| Tap / bump | Wall ⇒ bonk; lever = 1 Move |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ (standard) — Hammer target mode માં grey + lock icon |
| Hint / solver | State: removed bool (monotone) |
| Visual & audio | Carved ancient stone with vines; lever = stone handle; removal ⇒ sinks into ground `sfx_stone_rumble` |

```json
{"id": "o25", "type": "M074", "cells": [[4,2],[5,2],[6,2]], "params": {"lever": [0,9]}, "hammerable": false}
```
- **Implementation:** `ArmoredWall(cells, lever)`; `onTap(lever)` ⇒ removed = true. Lever interactive cell.
- **Do:** Lever ને દૂર ખૂણે ⇒ "lever ક્યારે?" (Lantern timing).
- **Don't:** Lever tap ફરજિયાત પહેલો Move (trivial).
- **Combos:** M057, M049, M084.
- **Edge cases (defined):** one-shot lever (standard §17.14).

---

### M075 — Creeping Mist (Creeping Fog)
| Field | Value |
|---|---|
| Intro / Category | L751 · C |
| Rule | Jungle Mist area (M010 rules: નીચેના snakes hidden & locked) જે દર `n` Moves (step 3) 1 cell grow: સૌથી **જૂના** mist cell થી fixed order U, R, D, L માં પહેલો neighbour જે board અંદર, mist નથી, અને interactive cell નથી; તે cell ન મળે ⇒ આગલો જૂનો cell. Area ને touch કરતો snake exit ⇒ આખો area clear **અને creeping કાયમ બંધ** |
| Tap / bump | Mist ⇒ locked ☁️ |
| Heart effect | Locked 0; hidden snake સાથે bump −1 |
| Hammerable | ❌; hidden snake target નથી |
| Hint / solver | State: mist cells (ordered by age), cleared |
| Visual & audio | M010 mist with curling tendril at growth front; next-growth cell faint dotted outline (fair preview); `sfx_mist_creep` |

```json
{"id": "o26", "type": "M075", "cells": [[9,9],[10,9]], "params": {"n": 3}, "hammerable": false}
```
- **Implementation:** `CreepingFog(cells, n)`; touch set **dynamic** (exit time area). Validator "no blind lanes" + solver.
- **Do:** "Mist પહોંચે તે પહેલાં આ snake કાઢો."
- **Don't:** Mist + Night / Honey (ban); mist interactive cells ઢાંકે (rule અટકાવે).
- **Combos:** M010, M065, M057.
- **Edge cases (defined):** growth tie-break (oldest cell, U,R,D,L), interactive cells skip, clear ⇒ stop forever.

---

### M076 — Burrow Network (Portal Network)
| Field | Value |
|---|---|
| Intro / Category | L761 · D |
| Rule | 3–4 burrows cycle `[A, B, C(, D)]`: lane burrow i માં પ્રવેશે ⇒ burrow i+1 (mod k) માંથી **એ જ dir** માં આગળ. Destination પર snake body ⇒ blocked |
| Tap / bump | Burrow tap ignore |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Static; loop guard (same cell + dir twice ⇒ validator reject, runtime bump) |
| Visual & audio | Burrows with matching rim + numbered pebbles 1→2→3; `sfx_burrow_pop` chain |

```json
{"id": "o27", "type": "M076", "cells": [[1,1],[10,2],[5,10]], "params": {"cycle": "leaf"}, "hammerable": false}
```
- **Implementation:** `PortalNetwork(cells)`; `redirect(cells[i])` ⇒ cells[(i+1) % k]. Render: clip in/out per burrow.
- **Do:** Ruins ના walled ભાગમાંથી snakes ferry.
- **Don't:** 2 networks એક board પર (readability).
- **Combos:** M078, M061, M098.

---

### M077 — Boom Puffball (Bomb Blocker)
| Field | Value |
|---|---|
| Intro / Category | L771 · X |
| Rule | Puffball cell = blocker, linked snake સાથે. Linked snake exit (કોઈ પણ રીતે, Hammer સહિત) ⇒ puffball burst: પોતે + **3×3 (puffball center)** માં આવતા બધા `hammerable: true` obstacle instances remove (instance નો કોઈ cell 3×3 માં ⇒ આખો instance, Creeping Vine માટે માત્ર અંદરના cells). Snakes, locks, gates, tiles પર અસર નહીં |
| Tap / bump | Puffball ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ (standard §16.18) |
| Hint / solver | State: burst bool |
| Visual & audio | Round puffball mushroom with link tag; burst ⇒ spore cloud + rocks crumble `sfx_puff_boom` (soft, kid-friendly) |

```json
{"id": "o28", "type": "M077", "cells": [[6,6]], "params": {"path": "p4"}, "hammerable": false}
```
- **Implementation:** `BombBlocker(cell, pathId)`; `onPathExit(p)` (non-lane) ⇒ remove set.
- **Do:** Rock cluster + coconut ને એક burst થી સાફ.
- **Don't:** Burst વગર solvable (puffball નકામું).
- **Combos:** M001, M002, M053, M016.
- **Edge cases (defined):** multi-cell instance partially inside ⇒ whole removed; vine partial.

---

### M078 — Walled Garden (Center-Only Exit)
| Field | Value |
|---|---|
| Intro / Category | L781 · B |
| Rule | Level flag: **બધી board edges walled** (Hedge Border all around); snakes માત્ર inner exits (M020 Home Burrow, M061 Sleepy Den) થી exit |
| Tap / bump | Edge ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Static; validator: ≥ 1 inner exit, every snake has route |
| Visual & audio | Tall hedge ring with flowers; burrows glow warmer |

```json
{"id": "o29", "type": "M078", "cells": [], "params": {}, "hammerable": false}
```
- **Implementation:** marker ⇒ `EdgeWall` on all sides at load. Edge mechanics (M030, M031, M062, M071, M095) સાથે ban.
- **Do:** M076 network + M020 burrows.
- **Don't:** 1 burrow + 30 snakes (lane congestion).
- **Combos:** M020, M061, M076, M014.

---

### M079 — Whirlwind Garden (Board Rotator)
| Field | Value |
|---|---|
| Intro / Category | L791 · T |
| Rule | દર `n` Moves (step 3) **આખું board content 90° CW:** cell `(x, y) → (W−1−y, x)` (**W = H ફરજિયાત**); બધી snake dirs CW; orientation params પણ rotate (mirror `/`↔`\`, arrows, bumper face H↔V, emitter dirs, edge sides U→R→D→L) |
| Tap / bump | — (automatic) |
| Heart effect | — |
| Hammerable | — |
| Hint / solver | State: rotation count mod 4 (`moveCount div n`) |
| Visual & audio | Leaf whirlwind swirl; board content rotates 400 ms around center; HUD badge "🌀 in 2"; `sfx_whirlwind` |

```json
{"id": "o30", "type": "M079", "cells": [], "params": {"n": 4}, "hammerable": false}
```
- **Implementation:** `BoardRotator(n)`; `transform(cw)` on every mechanic + path. Camera zoom/pan યથાવત, content board center ફરતે. Undo ⇒ snapshot (rotation સહિત).
- **Do:** "Rotation પહેલાં/પછી" lane planning.
- **Don't:** Non-square boards (validator); n < 3.
- **Combos:** M070, M084, M029.
- **Edge cases (defined):** orientation rotation table above; rotation પછી `dir` પોતાના body તરફ ⇒ tangled locked tap (standard §17.39).

---

### M080 — Twin Bamboo Cages (Twin Locks)
| Field | Value |
|---|---|
| Intro / Category | L801 · K |
| Rule | 2 lock cells, key snakes = **Vine-Tied Twins (M011) pair**. બંને key snakes **એક જ Move** માં exit (pair exit) ⇒ બંને cages કાયમ open |
| Tap / bump | Cages ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ cages. **Key snakes Hammer targets નથી** (પછી same-Move exit અશક્ય) |
| Hint / solver | State: open bool |
| Visual & audio | Twin bamboo cages with mirrored knots; twin keys on the vine-tied snakes; open ⇒ both lift simultaneously `sfx_twin_cage` |

```json
{"id": "o31", "type": "M080", "cells": [[2,8],[9,8]], "params": {"keyPair": "o32"}, "hammerable": false}
```
- **Implementation:** `TwinLocks(cells, chainId)`; `onPathExit` ⇒ open iff both exited in same Move id.
- **Do:** Twins ના lanes cages ની બહાર, cages પાછળ બીજા snakes.
- **Don't:** Twin pair સાથે Rainbow Parade (ban).
- **Combos:** M011, M004.
- **Edge cases (defined):** key-snake Hammer guard.

---

### M081 — Copycat Snake (Mimic Path)
| Field | Value |
|---|---|
| Intro / Category | L811 · P |
| Rule | Copycat ની `dir` = **છેલ્લો moved snake** ની dir — "moved" = **exit, segment exit અથવા relocation** (standard §17.17; bump / push / wake / unstick moved નથી, §17.30). Update step 1 ના અંતે. Copycat પોતે છેલ્લો ⇒ dir same. Initial = JSON dir. Interactive taps (levers, stones) snake move નથી |
| Tap / bump | Normal; copied dir પોતાના body તરફ ⇒ **tangled locked tap** (standard §17.39) |
| Heart effect | Bump ⇒ −1; tangled tap 0 |
| Hammerable | Snake ✅ |
| Hint / solver | State: dir |
| Visual & audio | Cheeky snake with crest arrow that flips to copied dir; eyes follow the last mover `sfx_copy_chirp` |

```json
{"id": "o33", "type": "M081", "cells": [], "params": {"path": "p6"}, "hammerable": false}
```
- **Implementation:** `MimicPath(pathId)`; engine keeps `lastMovedDir`. Exited snake ની dir = તેની exit dir.
- **Do:** "કોને પહેલાં ખસેડું જેથી copycat સાચી દિશા લે?"
- **Don't:** 2 copycats (chain confusing).
- **Combos:** M051 (diagonal copy), M070, M053.
- **Edge cases (defined):** "moved" = exit / segment exit / relocation only (bump, push નહીં).

---

### M082 — River Current (Conveyor)
| Field | Value |
|---|---|
| Intro / Category | L821 · D |
| Rule | Belt = ordered cells (open chain અથવા loop). દરેક Move (step 3): જે snake ના **બધા** body cells belt પર છે તે 1 step downstream shift (દરેક cell → next belt cell) જો leading cell નો next belt cell free; open chain end ⇒ shift નહીં. Most-downstream snake પહેલાં process. Dir absolute (બદલાય નહીં) |
| Tap / bump | Belt cells floor (lanes normal) |
| Heart effect | — |
| Hammerable | ❌ |
| Hint / solver | State: snake positions |
| Visual & audio | Stream with flow ripples + leaf rafts; shift ⇒ `sfx_river_flow` |

```json
{"id": "o34", "type": "M082", "cells": [[1,4],[2,4],[3,4],[4,4],[4,5],[4,6]], "params": {"loop": false}, "hammerable": false}
```
- **Implementation:** `Conveyor(cells, loop)`; `onMoveTick`; loop full ⇒ no shift. Coconuts belt પર ખસતા નથી (snakes only).
- **Do:** Snake ને lane align થાય ત્યાં સુધી "તરવા દો".
- **Don't:** Honey Pot સાથે (ban).
- **Combos:** M057, M053, M020.
- **Edge cases (defined):** processing order, coconuts static, partially-on-belt snake static.

---

### M083 — Heavy Mossy Stone (Heavy Plate)
| Field | Value |
|---|---|
| Intro / Category | L831 · T |
| Rule | M019 Mossy Pressure Stone જેવું, પણ **માત્ર Giant Anaconda (M024)** body cover કરે ત્યારે linked gates open; anaconda exit ⇒ closed. Normal snakes / coconut ⇒ કોઈ અસર નહીં |
| Tap / bump | Closed gate ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Derived |
| Visual & audio | Big cracked stone slab; anaconda weight ⇒ sinks with thud `sfx_heavy_press` |

```json
{"id": "o35", "type": "M083", "cells": [[6,7]], "params": {"gates": [[10,3]]}, "hammerable": false}
```
- **Implementation:** `HeavyPlate(plate, gates)`; open = any wide path occupied cells ∋ plate.
- **Do:** "Anaconda છેલ્લે."
- **Don't:** Anaconda + diagonal / ramp / push (ban).
- **Combos:** M024, M019, M037 Mud.

---

### M084 — Sunbeam Crystal (Laser Emitter)
| Field | Value |
|---|---|
| Intro / Category | L841 · B |
| Rule | Emitter cell (blocker) `dir` (orthogonal). Sunbeam `e + dir` થી પહેલા snake / opaque cell / edge સુધી; **beam cells blockers** (lanes bump). Beam દરેક Move ના step 4 માં ફરી compute; lane trace Move શરૂઆતની beam વાપરે. બધા layers ([01 §6](./01_PHASE_2_SCOPE_AND_RULES.md#6-sunbeams--beams-vs-lanes-m084m089-m099)) |
| Tap / bump | Emitter/beam ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Derived beam cells; non-monotone (snake exit ⇒ beam લાંબો) |
| Visual & audio | Amber crystal on a stump; beam = warm sunlight shaft through leaves with floating dust motes (pre-baked gradient scroll); `sfx_sun_hum` loop (quiet) |

```json
{"id": "o36", "type": "M084", "cells": [[13,2]], "params": {"dir": "L"}, "hammerable": false}
```
- **Implementation:** `LaserEmitter(cell, dir)`; `BeamTracer` step 4; transparent/opaque table [01 §6.2](./01_PHASE_2_SCOPE_AND_RULES.md#62-beam-trace-exact). Render: beam layer above floor, below snakes.
- **Do:** Snake ને beam રોકતો "ઢાલ" તરીકે — તેને છેલ્લે કાઢવો.
- **Don't:** Beam board ને બે ભાગ કરે અને કોઈ way નહીં (solver પકડે).
- **Combos:** M085, M086, M053.

---

### M085 — Sunflower Receiver (Laser Receiver)
| Field | Value |
|---|---|
| Intro / Category | L851 · T |
| Rule | Receiver cell (lanes માટે blocker, beam અટકાવે). કોઈ beam પહોંચે ⇒ **lit** ⇒ linked gates open **while lit** (step 4) |
| Tap / bump | Receiver/closed gate ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Derived |
| Visual & audio | Sunflower that opens & turns to the beam when lit; gates = petal curtains `sfx_sunflower_bloom` |

```json
{"id": "o37", "type": "M085", "cells": [[2,9]], "params": {"gates": [[6,13],[7,13]]}, "hammerable": false}
```
- **Implementation:** `LaserReceiver(cell, gates)`; `beam()` ⇒ `light`.
- **Do:** "Beam ને રોકતો snake કાઢો ⇒ sunflower lit ⇒ gate."
- **Don't:** Gate માંથી પસાર થતા snake ખુદ beam રોકે (deadlock).
- **Combos:** M084, M086, M089, M099.

---

### M086 — Dewdrop Mirror Leaf (Beam Mirror)
| Field | Value |
|---|---|
| Intro / Category | L861 · D |
| Rule | `/` અથવા `\` leaf: **beams અને orthogonal lanes** બંને 90° reflect (M014 mapping). Diagonal lanes ⇒ validator ban (runtime blocker) |
| Tap / bump | Leaf tap ignore |
| Heart effect | Bump ⇒ −1 (reflect પછી blocked) |
| Hammerable | ❌ |
| Hint / solver | Static redirect (lanes + beams) |
| Visual & audio | Glossy leaf with a big dewdrop; beam glints `sfx_dew_glint`; snake bounce `sfx_boing_soft` |

```json
{"id": "o38", "type": "M086", "cells": [[7,2]], "params": {"orient": "\\"}, "hammerable": false}
```
- **Implementation:** `BeamMirror(cell, orient)`; shares `Mirror.reflect()` with M014.
- **Do:** Beam ને ખૂણે વાળી receiver સુધી.
- **Don't:** Beam loop (validator).
- **Combos:** M084, M085, M089.

---

### M087 — Tree Sap Puddle (Glue Pad)
| Field | Value |
|---|---|
| Intro / Category | L871 · P |
| Rule | Tap સમયે snake નો **head** undried sap cell પર ⇒ tap = **unstick** (1 Move, lane check નહીં); sap **રહે છે**. પછીનો tap normal exit/bump. કોઈ Move ના અંતે head ફરી sap પર હોય ⇒ ફરી stick (standard §17.20). Lanes sap પરથી normal પસાર |
| Tap / bump | Unstick કદી bump નથી |
| Heart effect | Unstick 0 |
| Hammerable | Snake ✅ |
| Hint / solver | State: stuck bool per snake. Unstick = S +1 |
| Visual & audio | Amber sticky sap; head stuck ⇒ stretchy pull animation `sfx_sap_pop` |

```json
{"id": "o39", "type": "M087", "cells": [[4,8]], "params": {}, "hammerable": false}
```
- **Implementation:** `GluePad(cell)`; tap router: head ∈ sap ⇒ unstick. Head later sap પર (conveyor, honey, mud) ⇒ પણ stick.
- **Do:** Unstick Move ને counter tick તરીકે (Lantern Gate).
- **Don't:** Sap + Sleepy Python same snake (double wake).
- **Combos:** M057, M012, M082.
- **Edge cases (defined):** dynamic head arrival sticks; sap never dries — re-sticks any head ending a Move on it (standard §17.20).

---

### M088 — Thorny Burr Trap (Lane Mine)
| Field | Value |
|---|---|
| Intro / Category | L881 · K |
| Rule | Burr cell lanes block (bump) જ્યાં સુધી linked key snake exit ન થાય (કોઈ પણ રીતે, Hammer સહિત) ⇒ **defused** કાયમ (passable floor) |
| Tap / bump | Armed ⇒ bonk (normal bump, explosion નહીં) |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ burr; key snake hammer ⇒ defuse ✅ |
| Hint / solver | State: defused bool |
| Visual & audio | Spiky burr ball; key snake wears a little leaf-comb; defuse ⇒ burr curls & rolls aside `sfx_burr_soft` |

```json
{"id": "o40", "type": "M088", "cells": [[5,9]], "params": {"keyPath": "p11"}, "hammerable": false}
```
- **Implementation:** `LaneMine(cell, keyPath)`; non-lane exit trigger.
- **Do:** Burrs narrow corridors માં.
- **Don't:** Key snake નો lane પોતાના burr માંથી.
- **Combos:** M004, M076, M099.

---

### M089 — Crystal Prism Flower (Prism)
| Field | Value |
|---|---|
| Intro / Category | L891 · D |
| Rule | Beam prism માં ⇒ **બે beams:** incoming dir ના 90° CW અને 90° CCW. Lanes માટે prism **blocker** |
| Tap / bump | Prism ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | Derived beams; loop guard per (cell, dir) |
| Visual & audio | Crystal lotus splitting light into two rainbow-edged shafts `sfx_prism_ring` |

```json
{"id": "o41", "type": "M089", "cells": [[7,7]], "params": {}, "hammerable": false}
```
- **Implementation:** `Prism(cell)`; `beam()` ⇒ `split(cw, ccw)`; BFS over beam fronts.
- **Do:** એક crystal થી 2 receivers.
- **Don't:** Prism → mirror → same prism loop.
- **Combos:** M084, M085, M086.

---

### M090 — Tick-Tock Toadstool Gate (Parity Gate)
| Field | Value |
|---|---|
| Intro / Category | L901 · C |
| Rule | Gate **open** જ્યારે `moveCount` (Move increment **પહેલાં**) **odd**, closed જ્યારે even (standard §16.17). Level start (0) ⇒ closed |
| Tap / bump | Closed ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | State: parity |
| Visual & audio | Toadstool cap up (open) / down (closed); HUD parity dot; `sfx_tick` / `sfx_tock` |

```json
{"id": "o42", "type": "M090", "cells": [[3,0],[4,0]], "params": {}, "hammerable": false}
```
- **Implementation:** `ParityGate(cells)`; stateless (moveCount). Locked tap move ન હોવાથી parity બદલાય નહીં.
- **Do:** Wait Moves (push, bubble, lever) થી parity ગોઠવો.
- **Don't:** Phantom Snake (M021) / Shadow Snake (M096) સાથે same level માં 2 parity types (ban: max 1 parity type).
- **Combos:** M053, M073, M009.

---

### M091 — Great Whirl Stump (Rotor 3×3)
| Field | Value |
|---|---|
| Intro / Category | L911 · T |
| Rule | 3×3 stump. Center tap (1 Move) ⇒ 3×3 content 90° CW: પૂરેપૂરા અંદર snakes (cells + dir) અને static obstacles/gems. Partial snake અથવા rotation પછી head પોતાના body તરફ ⇒ **locked tap** (standard §16.19) |
| Tap / bump | Valid = 1 Move (350 ms) |
| Heart effect | 0 |
| Hammerable | ❌ |
| Hint / solver | State: content positions |
| Visual & audio | Large ringed stump with carved arrow; rotate `sfx_stump_turn_big` |

```json
{"id": "o43", "type": "M091", "cells": [[4,4],[5,4],[6,4],[4,5],[5,5],[6,5],[4,6],[5,6],[6,6]], "params": {}, "hammerable": false}
```
- **Implementation:** `Rotor(origin, size: 3)` (M034 code generalized). Tap target = center cell ring icon (tap priority over snake cell, standard §16.19).
- **Do:** L-shaped 3-cell snake અંદર.
- **Don't:** Center cell પર snake head (tap ambiguity) — validator.
- **Combos:** M034, M051, M026.

---

### M092 — Bead Millipede (Segmented Path)
| Field | Value |
|---|---|
| Intro / Category | L921 · P |
| Rule | Body segments (head થી), દા.ત. `seg: [2, 2, 2]`. દરેક tap ⇒ **front segment** lane થી exit (1 Move). બાકી = નવો snake: new head = next segment નો પહેલો cell, **dir = original `dir`** (દરેક segment `dir` રાખે, standard §17.21). છેલ્લો segment exit ⇒ snake exit; exit effects છેલ્લા segment પર fire |
| Tap / bump | Front segment blocked ⇒ bonk (આખો millipede wiggle) |
| Heart effect | Bump ⇒ −1 |
| Hammerable | Snake ✅ (આખો millipede, exit ગણાય) |
| Hint / solver | State: remaining segments. દરેક segment exit = S +1 (છેલ્લા સિવાય) |
| Visual & audio | Bead-chain millipede, segments colour-banded; segment leaves ⇒ "pop-unclip" `sfx_bead_click` |

```json
{"id": "o44", "type": "M092", "cells": [], "params": {"path": "p12", "seg": [2, 2, 2]}, "hammerable": false}
```
- **Implementation:** `SegmentedPath(pathId, seg)`; lane-based triggers (gems, paint, soil, seesaw) **દરેક segment** ના lane માટે; snake-exit triggers (keys, Frost adjacency, Mongoose HP, cage counts, quotas) **માત્ર છેલ્લા segment** પર.
- **Do:** Segments એક જ dir માં પણ અલગ cells થી lane શરૂ ⇒ દરેક segment નો lane અલગ ⇒ multi-step plan.
- **Don't:** > 4 segments.
- **Combos:** M026, M062, M051.
- **Edge cases (defined):** segments keep `dir`; trigger split (lane triggers per segment, exit effects last segment).

---

### M093 — Fork-Tail Splitter (Splitter Path)
| Field | Value |
|---|---|
| Intro / Category | L931 · P |
| Rule | Length **even ≥ 4** (standard §17.21). 1st tap = **split** (1 Move, lane check નહીં): front half = `body[0 … L/2−1]`, dir same; back half = બાકીના cells reversed (original tail = head), dir = **original dir નો opposite** (standard §17.21). New dir પોતાના body તરફ ⇒ tangled locked tap (§17.39). પછી બંને normal snakes (`p5a`, `p5b`) |
| Tap / bump | Split never bumps |
| Heart effect | Split 0 |
| Hammerable | Snake ✅ (split પહેલાં આખો; પછી દરેક half) |
| Hint / solver | State: split bool |
| Visual & audio | Lizard-like snake with forked tail; split ⇒ zip-apart sparkle `sfx_fork_zip` |

```json
{"id": "o45", "type": "M093", "cells": [], "params": {"path": "p5"}, "hammerable": false}
```
- **Implementation:** `SplitterPath(pathId)`; ids `${id}a` / `${id}b`. Links (key, Mongoose link, Frost) **front half (`a`)** inherit; back half no links.
- **Do:** બંને halves અલગ edges તરફ.
- **Don't:** Hatch Order / Rainbow Parade / groups સાથે (ban); bent tail જે back half ને પોતાના front half તરફ મોકલે.
- **Combos:** M001, M020, M062.
- **Edge cases (defined):** half sizes, back dir, link inheritance.

---

### M094 — Berry Mixer Puddle (Color Mixer)
| Field | Value |
|---|---|
| Intro / Category | L941 · P |
| Rule | Mixer puddle primary colour (`red`, `blue`, `yellow`). Successful lane પસાર ⇒ snake colour primary હોય અને અલગ ⇒ mix: red+blue = **purple**, red+yellow = **orange**, blue+yellow = **green**; same ⇒ no change; બીજા combos (snake colour non-primary) ⇒ **brown** (standard §17.6). Lane order માં, downstream gates નવો colour |
| Tap / bump | — |
| Heart effect | — |
| Hammerable | ❌ |
| Hint / solver | Running colour (M059 tracer) |
| Visual & audio | Swirled berry bowl; mix ⇒ two-tone wipe blending `sfx_berry_mix` |

```json
{"id": "o46", "type": "M094", "cells": [[6,3]], "params": {"color": "yellow"}, "hammerable": false}
```
- **Implementation:** `ColorMixer(cell, color)`; `mix(a, b)` table; palette ids (Phase 1 06 §2.2) વાપરે.
- **Do:** Red snake ⇒ yellow mixer ⇒ orange Flower Gate.
- **Don't:** 3 mixers એક lane માં.
- **Combos:** M059, M005, M062, M095.
- **Edge cases (defined):** non-primary ⇒ brown (standard §17.6); bump ⇒ no mix (§17.30).

---

### M095 — Rainbow Hedge Gates (Color Quota Edge)
| Field | Value |
|---|---|
| Intro / Category | L951 · B |
| Rule | M071 per colour: edge segment **walled** જ્યાં સુધી colour `C` ના `Q` exits (exit colour, hammered સહિત) ન થાય; પછી **બધા colours માટે** કાયમ open |
| Tap / bump | Closed ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | State: per-colour count |
| Visual & audio | Hedge with flower of colour C and counter; open ⇒ blossoms burst `sfx_hedge_bloom` |

```json
{"id": "o47", "type": "M095", "cells": [[4,13],[5,13]], "params": {"side": "D", "color": "purple", "quota": 2}, "hammerable": false}
```
- **Implementation:** `ColorQuotaEdge(cells, side, color, q)`; counts per colour.
- **Do:** Mixer થી purple બનાવી quota.
- **Don't:** M078 સાથે (ban).
- **Combos:** M094, M059, M071.
- **Edge cases (defined):** open ⇒ all colours pass.

---

### M096 — Shadow Snake (Shadow Path)
| Field | Value |
|---|---|
| Intro / Category | L961 · P |
| Rule | `moveCount` (Move પહેલાં) **even** ⇒ visible, tappable, normal snake (blocks). **Odd** ⇒ invisible: tap = locked, lanes/beams ને **block નથી કરતો**. પણ odd માં પણ cells **occupied** (coconut push, honey pull, patrol, conveyor માટે not free) |
| Tap / bump | Odd tap ⇒ locked 🌑 (no Move) |
| Heart effect | Locked 0 |
| Hammerable | Snake ✅ visible (even) હોય ત્યારે જ |
| Hint / solver | State: parity |
| Visual & audio | Even: dusky purple snake with soft glow; odd: 15% dashed silhouette (accessibility, fair) `sfx_shadow_whisper` |

```json
{"id": "o48", "type": "M096", "cells": [], "params": {"path": "p9"}, "hammerable": false}
```
- **Implementation:** `ShadowPath(pathId)`; `blocksLane` = parity even; `isOccupying` = true always.
- **Do:** Odd Move પર shadow ની પાછળનો lane વાપરો.
- **Don't:** M021 / M090 સાથે (max 1 parity type).
- **Combos:** M053, M073.
- **Edge cases (defined):** occupancy vs blocking split (standard "never blocks when invisible" ⇒ lanes/beams; physical overlap અટકાવવા occupancy).

---

### M097 — Bamboo Domino Poles (Domino Chain)
| Field | Value |
|---|---|
| Intro / Category | L971 · B |
| Rule | Ordered pole cells (2–6), દરેક blocker. Trigger: **પહેલો pole** Hammer થી **અથવા** linked snake exit ⇒ આખી chain order માં પડે (animation 80 ms/pole) અને એ જ action માં બધા removed |
| Tap / bump | Poles ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | **પહેલો pole ✅** (chain trigger), બાકીના ❌ |
| Hint / solver | State: fallen bool |
| Visual & audio | Leaning bamboo poles; fall ⇒ clack-clack cascade `sfx_domino_clack` |

```json
{"id": "o49", "type": "M097", "cells": [[2,3],[3,3],[4,4],[5,5]], "params": {"path": "p14"}, "hammerable": true}
```
- **Implementation:** `DominoChain(cells, pathId)`; `hammerable` instance-level true પણ Hammer target filter માત્ર `cells[0]`.
- **Do:** Chain મોટા board ને વહેંચે; linked snake દૂર.
- **Don't:** Linked snake chain પાછળ (deadlock).
- **Combos:** M077, M053.

---

### M098 — Prowling Mongoose (Moving Guardian)
| Field | Value |
|---|---|
| Intro / Category | L981 · X |
| Rule | Grumpy Mongoose (M049: multi-cell blocker 2×2, HP = linked snakes, દરેક linked exit −1, 0 ⇒ vanish) + **patrol (M025):** footprint anchors ના fixed loop પર દર Move 1 step (step 3, M025 slot). Next footprint કોઈ snake / blocker / coconut / non-floor cell overlap કરે ⇒ તે Move wait |
| Tap / bump | Mongoose ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ (standard). Hammered linked snake ⇒ HP −1 |
| Hint / solver | State: loop index, HP |
| Visual & audio | Mongoose in explorer hat sniffing around; next position ghost outline; HP pips `sfx_mongoose_sniff` |

```json
{"id": "o50", "type": "M098", "cells": [[4,4],[5,4],[4,5],[5,5]], "params": {"linked": ["p1", "p6", "p9", "p12"], "loop": [[4,4],[5,4],[6,4],[6,5],[5,5],[4,5]], "start": 0}, "hammerable": false}
```
- **Implementation:** `MovingGuardian(size, loop, idx, linked, hp)`; loop = anchor (top-left) list, consecutive anchors 1 cell apart.
- **Do:** Lanes mongoose ના "ખાલી" moment માં.
- **Don't:** Loop M025 beetle loop સાથે overlap (ban).
- **Combos:** M076, M020, M026.

---

### M099 — Sun Temple Master Lock (Master Lock)
| Field | Value |
|---|---|
| Intro / Category | L991 · K |
| Rule | Lock cell(s). `keys` = level ના **બધા key types** ની list (key snakes — exit = collected; Buried Leaf-Key tokens — collect = collected) + **built-in sun slot receiver** (lock નો પોતાનો receiver, standard §17.32: Sunbeam lock ના `sunSide` પર પહોંચે ⇒ lit). Step 4 માં **બધી keys collected અને sun slot lit** ⇒ lock **કાયમ open** (પછી receiver dark થાય તો પણ open) |
| Tap / bump | Closed ⇒ bonk |
| Heart effect | Bump ⇒ −1 |
| Hammerable | ❌ |
| Hint / solver | State: open bool (keys/receiver derived) |
| Visual & audio | Golden sun-disc door with key slots and a sun slot; each key fills slot, sun slot glows when lit; open ⇒ door rolls aside `sfx_temple_open` |

```json
{"id": "o51", "type": "M099", "cells": [[6,0],[7,0]], "params": {"keys": [{"path": "p31"}, {"token": "o15"}], "sunSide": "D"}, "hammerable": false}
```
- **Implementation:** `MasterLock(cells, keys, sunSide)`; beam trace: beam reaching a lock cell from `sunSide` ⇒ `lit` (beam stops); `derive` ⇒ open |= allKeys && lit. Intro L991 માં earlier mechanic તરીકે માત્ર M084 Sunbeam Crystal જરૂરી (standard §17.32).
- **Do:** Keys ભેગી કરતાં beam રોકતો snake હજુ boards પર ⇒ order matters.
- **Don't:** Receiver lit કરવા lock પાછળનો snake જરૂરી (deadlock — solver).
- **Combos:** M065, M084, M004, M088.
- **Edge cases (defined):** "all key types" = `params.keys` list; latch-open once satisfied.

---

### Finale — Mongoose Emperor's Sun Temple (L1000)
| Field | Value |
|---|---|
| Category | X |
| Rule | M098 Prowling Mongoose (Emperor, 3×3, HP 8) + 12 mechanic instances = 13 ≤ 14 (standard: Moving Guardian + ≥ 10 mixed). વિગત [02 §7](./02_LEVEL_PROGRESSION_0501_1000.md#7-phase-finale--l1000-mongoose-emperors-sun-temple) |
| Hammer | Emperor ❌ |
| Visual & audio | Golden temple board frame, Emperor crown + cape, `music_finale_p2.m4a` |

## 4. Combo Rules (validator)
| Combo | Status | Reason |
|---|---|---|
| Diagonal lane × M014 / M018 / M086 | ❌ banned | Orthogonal mirror diagonal reflection undefined |
| M024 Giant Anaconda × diagonal / M056 / M053 / M061 | ❌ | Wide lane undefined |
| M063 Honey Pot × M032 / M069 / M010 / M075 / M082 | ❌ | Layer pull, hidden pull, double mover |
| M072 Rainbow Parade × M011 / M039 / M048 / M066 / M080 / M028 / M093 | ❌ | Order conflicts |
| M093 Splitter × M028 / M011 / M048 / M066 | ❌ | Identity split |
| Parity types (M021, M090, M096) | max **1** per level | Readability |
| M079 × non-square board | ❌ | Rotation undefined |
| M078 × M030 / M031 / M062 / M071 / M095 | ❌ | No edges |
| M075 Creeping Mist × M040 Jungle Night | ❌ | Double hidden info (M010 + M040 ban continues) |
| M098 loop × M025 loop overlap | ❌ | Patrol collision |
| Lane or beam loop (same cell + dir twice) | ❌ | Infinite trace |
| M053 + M055 / M054 | ✅ recommended | Designed push puzzles |
| M084 + M086 + M085 / M089 | ✅ recommended | Beam routing |
| M059 / M094 + M005 / M062 / M095 | ✅ | Paint-routing |
| M069 + M056 | ✅ | Layer routing |
| M065 + M010 / M075 | ✅ | Reveal puzzles |

## 5. Per-Mechanic Unit Tests (puzzle_core)
દરેક M-ID માટે `test/mechanics/m0xx_test.dart` (Phase 1 §5 ના 6 minimum cases) + Phase 2 extras:
1. Rule happy path. 2. Blocked ⇒ bump ⇒ hearts −1, board unchanged, moveCount +1. 3. Locked tap ⇒ hearts/moveCount same. 4. Hammer allowed/denied + guards. 5. Undo exact restore (`==`), Hammer પછી Undo disabled. 6. Solver encode determinism.
7. **Tick-order test** (counter mechanics): standard §16.17 ક્રમ golden sequence.
8. **Rotation test** (M070/M079/M091 involved): orientation params rotate correctly 4× = identity.
9. **Beam test** (M084–M089, M099): golden beam cell sets.
QA IDs: [06 §10](./06_FRONTEND_AND_QA_PHASE_2.md#10-qa-checklist) (`QA-MECH-M051` … `QA-MECH-M099`).

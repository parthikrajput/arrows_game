# 03 — Obstacle Catalog: Phase 1 (M001–M049 + Finale)
> Purpose: Phase 1 ના 49 mechanics ના yarn-themed cards — દરેક card માં standard §10 ના બધા ફરજિયાત fields (rule, tap/bump, heart, hammer, hint/solver, visual/audio, JSON, implementation, level-design usage).

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) (§10 Mechanics Library, §12 Level JSON) · [./README.md](./README.md) · [./01_GAME_CONCEPT_AND_RULES.md](./01_GAME_CONCEPT_AND_RULES.md) · [./02_LEVEL_PROGRESSION_0001_0500.md](./02_LEVEL_PROGRESSION_0001_0500.md) · [./07_FRONTEND_IMPLEMENTATION_AND_QA.md](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Conventions (બધા cards માટે)

- **Rules = standard §10 exact rule.** Themed name, art અને sound જ game-specific છે. Card માં "Clarification" લખેલું હોય તે standard ના rule નું engine-level અર્થઘટન છે (rule બદલાતો નથી).
- **Path = Thread**, head = **Needle**. Move resolution order: [01 §5.5](./01_GAME_CONCEPT_AND_RULES.md).
- **Category:** B Static Blocker · K Key/Lock · C Counter (Move-based) · T Toggle/Interactive · P Path-variant · D Direction changer · L Layer · G Goal/Helper · X Boss.
- **Locked tap** = wobble + "tick", Heart નહીં, Move નહીં. **Bump (snag)** = −1 Heart (Thimble Shield હોય તો charge −1), Move +1.
- **Golden Scissors (Hammer):** કોઈપણ 1 visible thread (exit ગણાય — બધા exit-triggered effects લાગે) અથવા `hammerable: true` obstacle remove. Hammered thread એ "exit" ગણાય પણ તેનો lane traverse થતો નથી (Sequins collect / Tailor's Chalk HP / Stitch Bridge crossing **નહીં**). Wool Fluff નીચેના hidden threads target થઈ શકતા નથી (દેખાતા નથી).
- **JSON (schema v3):** obstacle = `mechanics[]` entry `{"id","type":"M0xx","cells","params","hammerable"}` (optional `"layer"`, default 0). Thread-variant (P category અને thread પર લાગતા C/K) = `mechanics[]` entry with `params.paths: ["p3"]` — `paths[].mods` ખાલી `{}` રહે (single source). Coordinates `[x, y]`, `body[0]` = needle.
- **Wrong-direction / unmet condition** = bump (lane-based) અથવા locked tap (thread state-based) — card માં સ્પષ્ટ.
- **Over/under weaving નથી.** Overlap માત્ર M015 Stitch Bridge અને M032 Double Fabric Layers (અને M042 Fragile Lace Bridge) થી.

## 2. Summary Table

| ID | Themed name | Generic | Intro | Cat | Hammerable |
|---|---|---|---|---|---|
| M001 | Wooden Button | Single Blocker | 11 | B | Yes |
| M002 | Ruler Strip | Long Wall | 21 | B | Yes (whole strip) |
| M003 | Knotted Thread | Frozen Path | 31 | C | Thread: yes (as thread) |
| M004 | Charm & Clasp | Key & Lock | 41 | K | Clasp (Lock): **No** |
| M005 | Color Eyelet | Color Gate | 51 | B | No (gate) |
| M006 | Stitch Arrow | One-Way Tile | 61 | D | No |
| M007 | Basting Seam | Countdown Gate | 71 | C | No (gate) |
| M008 | Pompom Tunnel | Portal Pair | 81 | D | No |
| M009 | Presser Lever | Lever + Toggle Gates | 91 | T | No |
| M010 | Wool Fluff | Fog Patch | 101 | C | No |
| M011 | Ribbon-Tied Pair | Chained Pair | 111 | P | Thread: yes |
| M012 | Coiled Thread | Sleeping Path | 121 | P | Thread: yes |
| M013 | Spool Spinner | Turntable | 131 | T | No |
| M014 | Hook Deflector | Mirror | 141 | D | No |
| M015 | Stitch Bridge | Bridge | 151 | L | No |
| M016 | Tailor's Chalk | Cracked Rock | 161 | C | Yes |
| M017 | Fraying Thread | Countdown Path | 171 | C | Thread: yes |
| M018 | Thread Guide Switch | Switch Junction | 181 | T | No |
| M019 | Foot Pedal Plate | Pressure Plate | 191 | T | No |
| M020 | Yarn Basket | Inner Exit (Hole) | 201 | G | No |
| M021 | Sheer Silk Thread | Phasing Path | 211 | P | Thread: yes (solid phase only) |
| M022 | Backstitch Thread | Reverse Path | 221 | P | Thread: yes |
| M023 | Double-Needle Thread | Two-Head Path | 231 | P | Thread: yes |
| M024 | Chunky Chenille | Wide Path | 241 | P | Thread: yes |
| M025 | Rolling Yarn Ball | Patrol Blocker | 251 | C | Yes |
| M026 | Sequins | Collect Gems | 261 | G | No |
| M027 | Spreading Tangle | Spreader | 271 | C | Yes (one cell per snip) |
| M028 | Tagged Threads | Numbered Paths | 281 | P | Thread: yes |
| M029 | Hem Wall | Edge Wall | 291 | B | **No** |
| M030 | Color Hem Gap | Color Edge | 301 | B | No |
| M031 | Zipper Edge | Closing Edge | 311 | C | No |
| M032 | Double Fabric Layers | Two Layers | 321 | L | n/a (threads: yes) |
| M033 | Safety-Pin Cage | Color Cage | 331 | K | No (caged thread: yes) |
| M034 | Quilt Block Rotor | Rotor 2×2 | 341 | T | No |
| M035 | Skein Spawner | Spawner Path | 351 | P | Thread: yes |
| M036 | Bead-Stringer Thread | Hungry Path | 361 | P | Thread: yes; Loose Bead: no |
| M037 | Glue Dot | Mud Trap | 371 | D | No |
| M038 | Elastic Hop Pad | Jump Pad | 381 | G | No |
| M039 | Twin Skeins | Mirror Twins | 391 | P | Thread: yes |
| M040 | Lamplight Evening | Night Board | 401 | G | n/a |
| M041 | Ombre Thread | Chameleon Path | 411 | P | Thread: yes |
| M042 | Fragile Lace Bridge | Fragile Bridge | 421 | L | Bridge: no · broken (blocker): yes |
| M043 | Multi-Clasp | Multi-Lock | 431 | K | No |
| M044 | Twisting Pompom Tunnel | Turning Portal | 441 | D | No |
| M045 | Treadle Gear Lever | Gear Lever | 451 | T | No |
| M046 | Knitted Loop | Loop Path | 461 | K | Thread: yes |
| M047 | Growing Knit Thread | Growing Path | 471 | C | Thread: yes |
| M048 | Color Bundle | Color Group Tap | 481 | P | Thread: yes (one) |
| M049 | Grand Pincushion Guardian | Guardian | 491 | X | **No** |
| — | The Grand Quilt | Phase 1 Finale | 500 | X | — |

---

## 3. Mechanic Cards

### M001 — Wooden Button (Single Blocker)
| Field | Value |
|---|---|
| Intro / Category | L11 · **B** |
| Rule | 1 cell; lane blocks. hammerable |
| Tap / bump | Button tap કરી શકાતું નથી (no-op, Move નહીં). Lane button cell પર પહોંચે ⇒ needle button સુધી, snag, spring back |
| Heart effect | Bump −1 |
| Hammerable | **Yes** — Golden Scissors button નો દોરો કાપી દે, button પડી જાય |
| Hint / solver | Static occupancy; reverse construction થી solvable guarantee |
| Visual & audio | 2-hole birch-wood button, cell × 0.8, pre-baked shadow. Snag SFX "tok-twang"; snip SFX "snip + clatter" |
| Implementation | `BlockerCell` occupancy in `LaneResolver`; no state |
| Level design | **Do:** intro L11 માં 1–3 buttons, એક thread નો lane button થી બંધ જેથી "બીજી દિશા" શીખે. **Don't:** needle ની સીધી સામે adjacent button જે thread ને કાયમ block કરે (validator: locked forever). **Combos:** M004, M014 (deflect around), M038 (hop over) |
```json
{"id": "o1", "type": "M001", "cells": [[3, 2]], "params": {}, "hammerable": true}
```

### M002 — Ruler Strip (Long Wall)
| Field | Value |
|---|---|
| Intro / Category | L21 · **B** |
| Rule | 2–4 straight cells; lane blocks. hammerable (આખી wall) |
| Tap / bump | Tap no-op. કોઈપણ strip cell lane blocks ⇒ snag |
| Heart effect | Bump −1 |
| Hammerable | **Yes** — એક snip માં આખી strip remove (એક booster use) |
| Hint / solver | Static; strip = multiple occupied cells |
| Visual & audio | Wooden tailor's ruler with inch marks, 2–4 cells straight (H/V). SFX "wood knock" |
| Implementation | cells must be collinear & contiguous (validator); hammer removes all `cells` of the id |
| Level design | **Do:** board ને "rooms" માં વહેંચો, 2 rows ના lanes એક સાથે બંધ. **Don't:** edge ને parallel ruler જે બધી edge exits બંધ કરે. **Combos:** M001, M008 Pompom Tunnel (ruler પાછળથી બહાર) |
```json
{"id": "o2", "type": "M002", "cells": [[2, 4], [3, 4], [4, 4]], "params": {"orient": "H"}, "hammerable": true}
```

### M003 — Knotted Thread (Frozen Path)
| Field | Value |
|---|---|
| Intro / Category | L31 · **C** |
| Rule | Path locked until K (1–3) **adjacent** (orthogonal) paths exit; badge shows K |
| Clarification | "Adjacent" = level start પર જે threads નો કોઈ body cell આ thread ના કોઈ body cell ને orthogonally અડે છે તે set (JSON `params.neighbors` માં precomputed). K = તેમાંથી કેટલા exit થવા જોઈએ |
| Tap / bump | K > 0 ⇒ **locked tap**. K = 0 ⇒ knot ખુલી જાય, normal thread |
| Heart effect | Locked tap: none |
| Hammerable | Knot obstacle નથી; thread પોતે Golden Scissors થી snip થઈ શકે (exit ગણાય) |
| Hint / solver | State: `remainingK`; solver neighbors exit ગણે |
| Visual & audio | Thread પર મોટી ગાંઠ (knot) + K badge (felt circle). Neighbor exit ⇒ badge −1 "loosen" SFX; 0 ⇒ knot untie animation + "pop" |
| Implementation | Exit effect hook (Move step 1, action resolve): `for each knotted where exited ∈ neighbors: k--` |
| Level design | **Do:** K = 1 intro માં, neighbors clear-first ordering શીખવે. **Don't:** neighbors પોતે knotted thread પર આધારિત (deadlock). **Combos:** M004, M010 |
```json
{"id": "o3", "type": "M003", "cells": [], "params": {"paths": ["p4"], "k": 2, "neighbors": ["p2", "p5", "p6"]}, "hammerable": false}
```

### M004 — Charm & Clasp (Key & Lock)
| Field | Value |
|---|---|
| Intro / Category | L41 · **K** |
| Rule | Key icon on a path; matching-color Lock cell blocks until key-path exits, then opens permanently. Lock not hammerable |
| Tap / bump | Clasp cell closed ⇒ lane blocks ⇒ snag. Key-thread exit ⇒ clasp open કાયમ (non-blocking) |
| Heart effect | Bump −1 |
| Hammerable | Clasp: **No**. Key-thread snip ⇒ exit ગણાય ⇒ clasp ખુલે |
| Hint / solver | State bit `open`; monotone |
| Visual & audio | Key-thread ના needle પર small brass **charm** (colour + shape icon); Clasp = brass purse-clasp cell same colour/icon. Open ⇒ "click-clack" |
| Implementation | `lockColor` match `keyColor`; one key may open multiple clasps of same colour |
| Level design | **Do:** key-thread ને visible, free રાખો intro માં. **Don't:** key-thread નો lane પોતાના clasp થી blocked (deadlock — validator). **Combos:** M003, M010, M043 |
```json
{"id": "o4", "type": "M004", "cells": [[5, 1]], "params": {"color": "yellow", "keyPath": "p2"}, "hammerable": false}
```

### M005 — Color Eyelet (Color Gate)
| Field | Value |
|---|---|
| Intro / Category | L51 · **B** |
| Rule | Cell passable only by same-color path; others bump |
| Tap / bump | Same colour thread નો lane eyelet માંથી પસાર; બીજા colour ⇒ snag at eyelet |
| Heart effect | Bump −1 |
| Hammerable | **No** (gate — standard §16.18) |
| Hint / solver | Static per colour; interacts with M041 Ombre colour state |
| Visual & audio | Metal grommet ring with coloured rim + pattern icon. Pass ⇒ soft "zip"; reject ⇒ "twang" |
| Implementation | `LaneResolver.blocks(cell, thread)` checks `thread.color == eyelet.color` |
| Level design | **Do:** 2 colours વચ્ચે sorting. **Don't:** eyelet પર કોઈ thread body મૂકવી (cell occupied). **Combos:** M030, M041 |
```json
{"id": "o5", "type": "M005", "cells": [[4, 0]], "params": {"color": "blue"}, "hammerable": false}
```

### M006 — Stitch Arrow (One-Way Tile)
| Field | Value |
|---|---|
| Intro / Category | L61 · **D** |
| Rule | Passable only in arrow direction; else bump |
| Tap / bump | Lane direction == arrow ⇒ pass; otherwise snag at tile |
| Heart effect | Bump −1 |
| Hammerable | No |
| Hint / solver | Static per direction |
| Visual & audio | Running-stitch arrow (3 chevrons) embroidered on linen. Pass ⇒ light "stitch" tick |
| Implementation | Lane enters cell with `dir`; `dir != arrow` ⇒ block. Thread bodies may lie on it at start |
| Level design | **Do:** one-way corridors. **Don't:** arrow opposite to the only exit of a thread. **Combos:** M008, M014 |
```json
{"id": "o6", "type": "M006", "cells": [[2, 3]], "params": {"arrow": "R"}, "hammerable": false}
```

### M007 — Basting Seam (Countdown Gate)
| Field | Value |
|---|---|
| Intro / Category | L71 · **C** |
| Rule | Closed gate opens permanently after N Moves (badge N) |
| Tap / bump | N > 0 ⇒ blocks (snag). Each Move (exit, bump, interactive) ⇒ N−1 (step 3 tick). N = 0 ⇒ open forever |
| Heart effect | Bump −1 |
| Hammerable | **No** (gate — standard §16.18; wait for N Moves) |
| Hint / solver | State `n`; solver may need "waiting" moves = other exits (never forced bumps — validator ensures solvable with 0 hearts) |
| Visual & audio | Loose white basting stitches across cell + N badge. Tick ⇒ one stitch pops; 0 ⇒ stitches fall away "fwip" |
| Implementation | Global Move counter subscriber |
| Level design | **Do:** N ≤ available other exits. **Don't:** N greater than total threads−1 (no non-bump moves left). **Combos:** M017, M031 |
```json
{"id": "o7", "type": "M007", "cells": [[6, 3]], "params": {"n": 3}, "hammerable": false}
```

### M008 — Pompom Tunnel (Portal Pair)
| Field | Value |
|---|---|
| Intro / Category | L81 · **D** |
| Rule | Lane entering portal A continues from portal B same dir. Path occupying B ⇒ blocked |
| Tap / bump | Lane hits A ⇒ continues from B (B ના next cell થી, same `dir`). B cell પર thread body ⇒ snag at A. Bidirectional (B ⇒ A પણ) |
| Heart effect | Bump −1 |
| Hammerable | No |
| Hint / solver | Lane resolver follows portal; loop guard (max 2 × cells steps) |
| Visual & audio | Two fluffy pompoms same colour; thread dives in one, pops out other "poof" |
| Implementation | Animation: thread segment clipped at A, re-emerges at B (two `extractPath` pieces) |
| Level design | **Do:** escape from enclosed area. **Don't:** portal chains causing infinite loop (validator). **Combos:** M002, M029 |
```json
{"id": "o8", "type": "M008", "cells": [[1, 1], [6, 5]], "params": {"pair": "A"}, "hammerable": false}
```

### M009 — Presser Lever (Lever + Toggle Gates)
| Field | Value |
|---|---|
| Intro / Category | L91 · **T** |
| Rule | Tap lever (1 Move) ⇒ all linked gates flip open/closed. Non-monotone |
| Tap / bump | Lever tap = 1 Move (counters tick). Closed gate blocks lane ⇒ snag |
| Heart effect | Bump −1; lever tap none |
| Hammerable | No (lever and gates) |
| Hint / solver | Hint may glow the lever (`solution` contains lever id). State bitmask |
| Visual & audio | Sewing-machine presser-foot lever; gates = metal presser feet up (open) / down (closed). "clunk" |
| Implementation | Interactive obstacle hit-test before thread hit-test on same cell |
| Level design | **Do:** gate A open / gate B closed start, one flip swaps. **Don't:** > 2 levers before T3. **Combos:** M019, M045 |
```json
{"id": "o9", "type": "M009", "cells": [[0, 7]], "params": {"gates": [{"cell": [3, 3], "open": false}, {"cell": [5, 1], "open": true}]}, "hammerable": false}
```

### M010 — Wool Fluff (Fog Patch)
| Field | Value |
|---|---|
| Intro / Category | L101 · **C** |
| Rule | Paths under fog hidden & locked; a fog area clears when any path whose body touches it exits |
| Clarification | "Under fog" = thread નો કોઈ body cell fluff area માં. "Touches" = visible thread નો body cell area ને orthogonally અડે (અથવા અંદર). Area clear ⇒ અંદરના threads visible + unlocked |
| Tap / bump | Fogged cell tap ⇒ locked tap. Fluff cells lanes block **નથી** કરતા (hidden thread body cells જ block કરે) |
| Heart effect | none (locked) |
| Hammerable | No; hidden threads target ન થાય |
| Hint / solver | Solver full-information (knows hidden threads); Hint never points hidden thread |
| Visual & audio | Cloud of soft carded wool covering cells; clear ⇒ fluff blows away "puff" |
| Implementation | Peek on hidden region shows "?" |
| Level design | **Do:** reveal = reward. **Don't:** hidden thread required as first move. **Combos:** M003, M004, Daily Thu |
```json
{"id": "o10", "type": "M010", "cells": [[4, 4], [5, 4], [4, 5], [5, 5]], "params": {"area": "f1"}, "hammerable": false}
```

### M011 — Ribbon-Tied Pair (Chained Pair)
| Field | Value |
|---|---|
| Intro / Category | L111 · **P** |
| Rule | 2 paths linked; tap either ⇒ both try; both lanes must be clear else both bump (−1 heart total) |
| Tap / bump | Both clear ⇒ both unravel simultaneously (1 Move). Either blocked ⇒ both snag, −1 total |
| Heart effect | −1 total per failed pair tap |
| Hammerable | Snip one thread ⇒ that thread exits, ribbon breaks, partner becomes normal thread |
| Hint / solver | Pair = one action node |
| Visual & audio | Satin ribbon bow between the two needles. Success ⇒ bow flies off |
| Implementation | બંને lanes એક જ pre-move state પર evaluate (partner નો body પણ blocker ગણાય — simultaneous motion collision ટાળવા). Animation: બંને threads parallel unravel/snag |
| Level design | **Do:** pairs whose lanes are mutually independent. **Don't:** pair where one lane blocked by the other forever. **Combos:** M039, M048 |
```json
{"id": "o11", "type": "M011", "cells": [], "params": {"paths": ["p3", "p7"]}, "hammerable": false}
```

### M012 — Coiled Thread (Sleeping Path)
| Field | Value |
|---|---|
| Intro / Category | L121 · **P** |
| Rule | 1st tap wakes (1 Move), 2nd tap exits |
| Tap / bump | 1st tap ⇒ coil uncoils (state awake), Move +1, no lane check. 2nd tap ⇒ normal exit/bump |
| Heart effect | 1st tap none; later bump −1 |
| Hammerable | Thread: yes (any state) |
| Hint / solver | Wake = action node; Hint may glow coiled thread for wake |
| Visual & audio | Thread wound in a small spiral at needle + "zzz" loop icon. Wake ⇒ spring-uncoil "boing" |
| Implementation | `awake` flag; Undo restores coil |
| Level design | **Do:** use as tempo filler for Basting Seam counts. **Don't:** > 4 per level (tap fatigue). **Combos:** M007, M017 |
```json
{"id": "o12", "type": "M012", "cells": [], "params": {"paths": ["p5"]}, "hammerable": false}
```

### M013 — Spool Spinner (Turntable)
| Field | Value |
|---|---|
| Intro / Category | L131 · **T** |
| Rule | Path head on turntable; tap turntable ⇒ rotates that path 90° CW (1 Move) |
| Clarification | Needle direction `dir` 90° CW rotate (U→R→D→L); body cells same. Tap target split: **needle cell (spinner cell) tap ⇒ spinner**; બાકીના body cells tap ⇒ thread pull. તેથી spinner પર needle ધરાવતો thread **length ≥ 2** હોવો જોઈએ (validator). Spinner cell પર tap priority spinner ને (§16.19). Rotation પછી needle નો `dir` પોતાના body તરફ હોય ⇒ thread **tangled** ⇒ locked tap (bump નહીં) જ્યાં સુધી spinner ફરી rotate ન થાય (§17.39) |
| Tap / bump | Spinner tap = 1 Move, no heart. Thread tap normal |
| Heart effect | none (spinner) |
| Hammerable | No |
| Hint / solver | State `dir` 4 values |
| Visual & audio | Wooden spool under needle, rotates with "wooden ratchet" click |
| Implementation | If needle leaves (thread exits), spinner stays as decoration (no block) |
| Level design | **Do:** needle initially facing blocked side. **Don't:** spinner where all 4 dirs blocked; 1-cell thread on spinner (untappable as thread). **Combos:** M045 |
```json
{"id": "o13", "type": "M013", "cells": [[3, 3]], "params": {"path": "p2"}, "hammerable": false}
```

### M014 — Hook Deflector (Mirror)
| Field | Value |
|---|---|
| Intro / Category | L141 · **D** |
| Rule | `/` or `\` cell; lane turns 90° |
| Tap / bump | Lane through deflector turns: `/`: R→U, U→R, L→D, D→L; `\`: R→D, D→R, L→U, U→L. Exiting thread follows bent route |
| Heart effect | none (bump only if new route blocked) |
| Hammerable | No |
| Hint / solver | Lane resolver deterministic |
| Visual & audio | Brass crochet hook lying diagonally. Thread slides around hook "zing" |
| Implementation | Track path for unravel animation includes the turn (Path lineTo corner) |
| Level design | **Do:** exits around blockers. **Don't:** 4-deflector loops (infinite; validator loop guard). **Combos:** M001, M008 |
```json
{"id": "o14", "type": "M014", "cells": [[6, 2]], "params": {"orient": "/"}, "hammerable": false}
```

### M015 — Stitch Bridge (Bridge)
| Field | Value |
|---|---|
| Intro / Category | L151 · **L** |
| Rule | Path cells lying on bridge do not block perpendicular lanes passing under |
| Clarification | Bridge cell ની orientation (H/V). Bridge પર પડેલો thread segment bridge axis પર; perpendicular lane નીચેથી પસાર (block નહીં). Parallel lane ⇒ normal block. **આ weaving નથી** — માત્ર bridge cell પર જ |
| Tap / bump | Tap on bridge cell ⇒ thread on bridge (top) |
| Heart effect | normal |
| Hammerable | No |
| Hint / solver | Occupancy check uses axis |
| Visual & audio | Raised arch of satin stitch; passing thread shown under arch (drawn before bridge layer) |
| Implementation | Paint order: under-lane thread → bridge → on-bridge thread |
| Level design | **Do:** cross pattern. **Don't:** bridge without any thread on it (pointless). **Combos:** M032, M042 |
```json
{"id": "o15", "type": "M015", "cells": [[4, 3]], "params": {"axis": "H"}, "hammerable": false}
```

### M016 — Tailor's Chalk (Cracked Rock)
| Field | Value |
|---|---|
| Intro / Category | L161 · **C** |
| Rule | HP 1–3; −1 HP whenever an exiting lane passes an orthogonally adjacent cell; HP 0 ⇒ removed. hammerable |
| Tap / bump | Blocks lanes while HP > 0. Successful exit whose lane (route cells, not body) passes adjacent ⇒ −1 (once per Move per chalk) |
| Heart effect | Bump −1 |
| Hammerable | **Yes** |
| Hint / solver | State HP |
| Visual & audio | Triangle tailor's chalk block, HP = chips; −1 ⇒ crumble dust "scritch" |
| Implementation | Step 1 (action resolve) effect; snipped threads do not damage chalk |
| Level design | **Do:** HP = number of natural nearby exits. **Don't:** HP > adjacent possible exits. **Combos:** M001, M020 |
```json
{"id": "o16", "type": "M016", "cells": [[2, 5]], "params": {"hp": 2}, "hammerable": true}
```

### M017 — Fraying Thread (Countdown Path)
| Field | Value |
|---|---|
| Intro / Category | L171 · **C** |
| Rule | Must exit within N Moves; at 0 ⇒ −1 heart, counter resets to N |
| Tap / bump | Normal thread. દરેક Move (step 3 tick) ⇒ N−1. N = 0 અને thread હજી board પર ⇒ −1 Heart (Shield absorb કરી શકે), counter = N ફરી |
| Heart effect | −1 at 0 (heart-loss event) |
| Hammerable | Thread: yes (snip ⇒ exit, counter stops) |
| Hint / solver | Solver treats heart loss as forbidden (0-heart solution required) ⇒ solution exits within N |
| Visual & audio | Thread end fraying fibres + N badge; N ≤ 2 ⇒ badge pulses amber; 0 ⇒ "rip" SFX + heart crack |
| Implementation | Fraying thread exit Move ⇒ removed in step 1, tick not applied |
| Level design | **Do:** N ≥ (solution index of thread) + 1 with slack 2 in T2. **Don't:** two fraying threads requiring same window. **Combos:** M007, M012 |
```json
{"id": "o17", "type": "M017", "cells": [], "params": {"paths": ["p6"], "n": 5}, "hammerable": false}
```

### M018 — Thread Guide Switch (Switch Junction)
| Field | Value |
|---|---|
| Intro / Category | L181 · **T** |
| Rule | Cell turns lane L or R per state; tap switch toggles (1 Move) |
| Clarification | L/R lane ના પોતાના direction ની relative (R-state: lane dir 90° CW; L-state: 90° CCW) |
| Tap / bump | Switch tap = 1 Move. Lane entering switch cell turns per state |
| Heart effect | none (tap); bump if new route blocked |
| Hammerable | No |
| Hint / solver | State bit; Hint may glow switch |
| Visual & audio | Sewing-machine thread guide (small metal hook) with arrow L/R; toggle "click" |
| Implementation | Switch cell non-occupiable by bodies at start |
| Level design | **Do:** one switch serving 2 threads with opposite needs (ordering puzzle). **Don't:** switch reachable only by one thread (trivial). **Combos:** M009, M014 |
```json
{"id": "o18", "type": "M018", "cells": [[5, 5]], "params": {"state": "L"}, "hammerable": false}
```

### M019 — Foot Pedal Plate (Pressure Plate)
| Field | Value |
|---|---|
| Intro / Category | L191 · **T** |
| Rule | Linked gate open **while** some path body covers plate; plate-path exits ⇒ gate closes |
| Tap / bump | Plate itself not tappable. Gate state recomputed in step 4 (derived states) each Move |
| Heart effect | Bump on closed gate −1 |
| Hammerable | No (plate & gate) |
| Hint / solver | Non-monotone; solver tracks occupancy |
| Visual & audio | Sewing-machine foot pedal pad on floor; gate = needle-plate cover sliding. Press ⇒ soft "whirr" |
| Implementation | Gate open = `any(body covers plate)`; recompute after M013/M034/M037 movement too |
| Level design | **Do:** "hold the pedal" thread must stay until others pass. **Don't:** plate covered only by the gated thread itself. **Combos:** M009, M037 |
```json
{"id": "o19", "type": "M019", "cells": [[1, 6]], "params": {"gate": [6, 2]}, "hammerable": false}
```

### M020 — Yarn Basket (Inner Exit / Hole)
| Field | Value |
|---|---|
| Intro / Category | L201 · **G** |
| Rule | Internal cell acting as exit; lane reaching it ⇒ path exits into it |
| Tap / bump | Lane reaching basket ⇒ thread dives in (exit), edge સુધી જવાની જરૂર નથી |
| Heart effect | none |
| Hammerable | No |
| Hint / solver | Exit target in lane resolver |
| Visual & audio | Wicker yarn basket; threads coil into it, basket bounces "plop" |
| Implementation | Track path ends at basket centre; thread scale-down last 20% |
| Level design | **Do:** walled boards (with M029). **Don't:** basket adjacent to every needle (trivial). **Combos:** M029, M049 |
```json
{"id": "o20", "type": "M020", "cells": [[5, 5]], "params": {}, "hammerable": false}
```

### M021 — Sheer Silk Thread (Phasing Path)
| Field | Value |
|---|---|
| Intro / Category | L211 · **P** |
| Rule | Solid on even Move count, ghost (non-blocking, not tappable) on odd |
| Tap / bump | Move count even ⇒ normal; odd ⇒ ghost: tap = locked tap, other lanes pass through |
| Heart effect | normal when solid |
| Hammerable | Thread: only when solid (ghost not targetable) |
| Hint / solver | State = global parity; Undo restores parity |
| Visual & audio | Translucent organza silk; ghost = 30% alpha + shimmer; phase change "chime" |
| Implementation | Parity from `moveCount % 2` using the count **before** the current Move's increment (start 0 ⇒ solid; §16.17) |
| Level design | **Do:** "wait one move" puzzles. **Don't:** all threads sheer (parity trivial). **Combos:** M012 (tempo), M007 |
```json
{"id": "o21", "type": "M021", "cells": [], "params": {"paths": ["p3"]}, "hammerable": false}
```

### M022 — Backstitch Thread (Reverse Path)
| Field | Value |
|---|---|
| Intro / Category | L221 · **P** |
| Rule | Exits tail-first (moves backward); arrow cue on tail |
| Clarification | Tail exit direction `params.tailDir` = direction from `body[n-2]` to `body[n-1]` (JSON માં explicit). Exit lane tail ના આગળના cell થી |
| Tap / bump | Normal tap; lane check from tail |
| Heart effect | normal |
| Hammerable | Thread: yes |
| Hint / solver | Lane origin = tail |
| Visual & audio | Needle drawn at tail end (eye-first), backstitch dashes along thread; tail arrow cue |
| Implementation | Track built tail-reversed |
| Level design | **Do:** looks like it faces wrong way — surprise. **Don't:** mix with M023 in intro block. **Combos:** M020 |
```json
{"id": "o22", "type": "M022", "cells": [], "params": {"paths": ["p2"], "tailDir": "L"}, "hammerable": false}
```

### M023 — Double-Needle Thread (Two-Head Path)
| Field | Value |
|---|---|
| Intro / Category | L231 · **P** |
| Rule | Head both ends; tap near an end ⇒ exits that way (tap nearest-end rule) |
| Clarification | Tapped body index `i`: `i < n/2` ⇒ `body[0]` end (`dir`); `i > (n-1)/2` ⇒ tail end (`params.tailDir`). Exact middle (odd n) ⇒ `body[0]` end |
| Tap / bump | Chosen end ની lane check |
| Heart effect | normal |
| Hammerable | Thread: yes |
| Hint / solver | Two action nodes per thread (`p4@head`, `p4@tail` in `solution`) |
| Visual & audio | Needle at both ends; on touch-down nearest needle glows (feedback before release) |
| Implementation | Peek shows lane for the end nearest to finger |
| Level design | **Do:** one end blocked, other free. **Don't:** both ends free in practice levels (no decision). **Combos:** M022 |
```json
{"id": "o23", "type": "M023", "cells": [], "params": {"paths": ["p4"], "tailDir": "D"}, "hammerable": false}
```

### M024 — Chunky Chenille (Wide Path)
| Field | Value |
|---|---|
| Intro / Category | L241 · **P** |
| Rule | 2-cell-wide body; needs 2-wide clear lane |
| Clarification | `body` = one strand; `params.offset` = perpendicular side `[dx, dy]` (second strand = each body cell + offset). Straight body only in Phase 1 |
| Tap / bump | Tap either strand; both lane columns must be clear |
| Heart effect | normal |
| Hammerable | Thread: yes |
| Hint / solver | Occupancy 2 cells per segment |
| Visual & audio | Thick fluffy chenille, double-width needle |
| Implementation | Stroke width 2 × cell × 0.42 + gap |
| Level design | **Do:** single-cell gaps that block chenille but not normal. **Don't:** chenille on 6×6 boards. **Combos:** M001, M002 |
```json
{"id": "o24", "type": "M024", "cells": [], "params": {"paths": ["p1"], "offset": [0, 1]}, "hammerable": false}
```

### M025 — Rolling Yarn Ball (Patrol Blocker)
| Field | Value |
|---|---|
| Intro / Category | L251 · **C** |
| Rule | Moves 1 cell along fixed loop each Move; blocks where it stands |
| Clarification | Step 3 tick માં advance (M025 slot). Next loop cell પર thread body હોય ⇒ તે Move માં ball wait કરે (stays) |
| Tap / bump | Not tappable. Lane check uses ball position at tap time |
| Heart effect | Bump −1 |
| Hammerable | **Yes** |
| Hint / solver | State = loop index |
| Visual & audio | Small yarn ball rolling (Purl's toy), trail dotted on its loop; "roll" soft |
| Implementation | Loop cells list cyclic; animation 200 ms after main move |
| Level design | **Do:** loop crossing 2 lanes alternately. **Don't:** loop length 2 (flicker). **Combos:** M021, M007 |
```json
{"id": "o25", "type": "M025", "cells": [[2, 2]], "params": {"loop": [[2, 2], [3, 2], [3, 3], [2, 3]], "index": 0}, "hammerable": true}
```

### M026 — Sequins (Collect Gems)
| Field | Value |
|---|---|
| Intro / Category | L261 · **G** |
| Rule | Win also requires every gem collected (lane passing gem collects it) |
| Tap / bump | Sequin cells non-blocking. Successful exit lane પસાર ⇒ collect (bump lane collect નહીં) |
| Heart effect | none |
| Hammerable | No |
| Hint / solver | Goal state; solver must collect all |
| Visual & audio | Shiny sequin, HUD counter "✦ 2/5"; collect ⇒ sparkle "ting" |
| Implementation | `goals.gems` = count; Win check step 6 |
| Level design | **Do:** sequin on route only one thread can take. **Don't:** sequin reachable only via snipped thread (snip doesn't collect) — validator. **Combos:** M014, M008 |
```json
{"id": "o26", "type": "M026", "cells": [[4, 1]], "params": {}, "hammerable": false}
```

### M027 — Spreading Tangle (Spreader)
| Field | Value |
|---|---|
| Intro / Category | L271 · **C** |
| Rule | Every N Moves grows 1 cell into first free neighbour (fixed order U,R,D,L) |
| Clarification | Tangle cells oldest-first scan; પહેલો cell જેનો free neighbour (U,R,D,L ક્રમમાં) હોય તે grow. Free = no body, no obstacle |
| Tap / bump | Tangle cells block lanes |
| Heart effect | Bump −1 |
| Hammerable | **Yes — one cell** per snip (tapped tangle cell removed; બાકીના cells રહે, standard §16.18) |
| Hint / solver | State = cell set + counter |
| Visual & audio | Messy loose-lint tangle; growth ⇒ fuzz "rustle" |
| Implementation | Growth step 3 tick |
| Level design | **Do:** pressure to clear near threads first. **Don't:** N = 1 before T4. **Combos:** M016, M025 |
```json
{"id": "o27", "type": "M027", "cells": [[7, 7]], "params": {"n": 3, "counter": 3}, "hammerable": true}
```

### M028 — Tagged Threads (Numbered Paths)
| Field | Value |
|---|---|
| Intro / Category | L281 · **P** |
| Rule | Must exit in ascending number order; wrong = locked tap |
| Clarification | Snipped tagged thread ⇒ sequence માંથી remove (next lowest remaining number allowed) |
| Tap / bump | Only lowest remaining number tappable; others locked tap |
| Heart effect | none (locked); bump normal for correct number |
| Hammerable | Thread: yes |
| Hint / solver | Order constraint |
| Visual & audio | Paper price tag tied to needle with number 1–6 |
| Implementation | `order` int per thread |
| Level design | **Do:** order conflicts with geometry. **Don't:** > 6 tagged threads. **Combos:** M003 |
```json
{"id": "o28", "type": "M028", "cells": [], "params": {"order": {"p1": 1, "p4": 2, "p2": 3}}, "hammerable": false}
```

### M029 — Hem Wall (Edge Wall)
| Field | Value |
|---|---|
| Intro / Category | L291 · **B** |
| Rule | Board edge segments walled; lanes hitting edge wall bump. not hammerable |
| Tap / bump | Lane reaching walled edge ⇒ snag at edge |
| Heart effect | Bump −1 |
| Hammerable | **No** |
| Hint / solver | Static exits set |
| Visual & audio | Thick double-stitched hem along frame segment |
| Implementation | `edges`: list of `{side, from, to}` |
| Level design | **Do:** combine with Yarn Basket (M020), Pompom Tunnel. **Don't:** wall all edges without inner exit. **Combos:** M020, M030, M031 |
```json
{"id": "o29", "type": "M029", "cells": [], "params": {"edges": [{"side": "R", "from": 0, "to": 4}]}, "hammerable": false}
```

### M030 — Color Hem Gap (Color Edge)
| Field | Value |
|---|---|
| Intro / Category | L301 · **B** |
| Rule | Edge opening only for one color |
| Tap / bump | Matching colour exits; other colours snag at edge |
| Heart effect | Bump −1 |
| Hammerable | No |
| Hint / solver | Static per colour (Ombre dynamic) |
| Visual & audio | Coloured hem segment with colour pattern |
| Implementation | Edge segment `color` |
| Level design | **Do:** colour sorting with eyelets. **Don't:** colour with no thread. **Combos:** M005, M041 |
```json
{"id": "o30", "type": "M030", "cells": [], "params": {"edges": [{"side": "U", "from": 2, "to": 5}], "color": "red"}, "hammerable": false}
```

### M031 — Zipper Edge (Closing Edge)
| Field | Value |
|---|---|
| Intro / Category | L311 · **C** |
| Rule | Open edge segment closes permanently after N Moves |
| Tap / bump | N > 0 ⇒ open; N = 0 ⇒ Hem Wall |
| Heart effect | Bump −1 after closing |
| Hammerable | No |
| Hint / solver | Counter state |
| Visual & audio | Zipper along edge with pull-tab moving each Move; close ⇒ "zzzip" |
| Implementation | Tick step 3 |
| Level design | **Do:** "use it before it closes". **Don't:** closing the only remaining exit for a needed thread. **Combos:** M007 |
```json
{"id": "o31", "type": "M031", "cells": [], "params": {"edges": [{"side": "D", "from": 0, "to": 3}], "n": 6}, "hammerable": false}
```

### M032 — Double Fabric Layers (Two Layers)
| Field | Value |
|---|---|
| Intro / Category | L321 · **L** |
| Rule | Upper-layer paths drawn above; lower path locked while any upper path covers its body; lanes interact only within own layer |
| Clarification | Thread `layer`: 0 = under fabric, 1 = top fabric. Obstacles `layer` default 0. **True over/under weaving નથી** — માત્ર 2 flat layers |
| Tap / bump | Overlap cell tap ⇒ upper thread (tap priority). Covered lower thread ⇒ locked tap |
| Heart effect | normal per layer |
| Hammerable | Upper threads: yes; covered lower thread not targetable |
| Hint / solver | Per-layer occupancy |
| Visual & audio | Top layer = threads on translucent tulle sheet with shadow; lower layer 85% brightness |
| Implementation | Two occupancy grids; paint order layer 0 → tulle → layer 1 |
| Level design | **Do:** few overlap cells (2–4). **Don't:** lower threads fully hidden. **Combos:** M015, M033 |
```json
{"id": "o32", "type": "M032", "cells": [], "params": {"layers": 2}, "hammerable": false}
```
(Level root `"layers": 2`; each thread `"layer": 0|1`.)

### M033 — Safety-Pin Cage (Color Cage)
| Field | Value |
|---|---|
| Intro / Category | L331 · **K** |
| Rule | Caged path locked until all paths of cage color exit |
| Tap / bump | Caged thread ⇒ locked tap until colour cleared |
| Heart effect | none |
| Hammerable | Cage: no; caged thread: yes (snip) |
| Hint / solver | Colour count state |
| Visual & audio | Coloured safety pins pinning thread; open ⇒ pins spring open "ping" |
| Implementation | Cage colour ≠ caged thread colour required |
| Level design | **Do:** colour order puzzles. **Don't:** cage colour threads depend on caged thread. **Combos:** M041, M048 |
```json
{"id": "o33", "type": "M033", "cells": [], "params": {"paths": ["p5"], "color": "green"}, "hammerable": false}
```

### M034 — Quilt Block Rotor (Rotor 2×2)
| Field | Value |
|---|---|
| Intro / Category | L341 · **T** |
| Rule | Tap rotor ⇒ 2×2 contents rotate 90° CW (paths fully inside only) |
| Clarification | 2×2 અંદર સંપૂર્ણ રહેલા threads (cells + `dir`) અને obstacles rotate. આંશિક અંદર હોય એવો thread ⇒ rotor tap = locked tap (rotate નહીં, Move નહીં). Rotor cell પર tap priority rotor ને (§16.19). Rotation પછી needle પોતાના body તરફ ⇒ tangled ⇒ locked tap |
| Tap / bump | Rotor centre handle tap = 1 Move |
| Heart effect | none |
| Hammerable | No |
| Hint / solver | State = contents rotation |
| Visual & audio | Quilt patch square with a button handle at centre; rotate "fabric swish" |
| Implementation | Rotation (x,y) → (x0 + 1 − (y−y0), y0 + (x−x0)) within block |
| Level design | **Do:** short (1–2 cell) threads inside. **Don't:** rotor with nothing fully inside. **Combos:** M013, M045 |
```json
{"id": "o34", "type": "M034", "cells": [[3, 3], [4, 3], [3, 4], [4, 4]], "params": {}, "hammerable": false}
```

### M035 — Skein Spawner (Spawner Path)
| Field | Value |
|---|---|
| Intro / Category | L351 · **P** |
| Rule | On exit spawns a short child path at marked cells (if free, else waits) |
| Clarification | Marked cells બધા free થાય તે Move ના step 1 exit effects પછી spawn. Child thread `params.child` definition |
| Tap / bump | Parent normal; child normal after spawn (spawn animation, tappable next input) |
| Heart effect | normal |
| Hammerable | Parent snip ⇒ exit ⇒ spawn triggers |
| Hint / solver | Pending spawn state |
| Visual & audio | Skein (bundle) icon on parent; marked cells dotted outline; spawn ⇒ mini skein unrolls "flump" |
| Implementation | Win requires child exited too |
| Level design | **Do:** child blocks something later. **Don't:** child marked cells never free. **Combos:** M020 |
```json
{"id": "o35", "type": "M035", "cells": [[6, 6], [6, 7]], "params": {"paths": ["p3"], "child": {"id": "p3c", "color": "teal", "dir": "D", "body": [[6, 7], [6, 6]]}}, "hammerable": false}
```

### M036 — Bead-Stringer Thread (Hungry Path)
| Field | Value |
|---|---|
| Intro / Category | L361 · **P** |
| Rule | Can exit only if lane passes a food cell (food consumed) |
| Clarification | Food = **Loose Bead** cell (non-blocking for all). Lane clear પણ bead નહીં ⇒ snag (bump) at edge. Non-stringer threads bead consume નથી કરતા |
| Tap / bump | Lane with bead ⇒ exit + bead consumed. No bead ⇒ bump |
| Heart effect | Bump −1 |
| Hammerable | Thread: yes; bead: no |
| Hint / solver | Food set state |
| Visual & audio | Thread with beading needle; bead on lane strung onto thread during unravel "clink" |
| Implementation | Peek: red if no bead on clear lane, text icon "needs bead" |
| Level design | **Do:** 2 stringers, 1 shared bead (order). **Don't:** more stringers than beads. **Combos:** M014, M008 |
```json
{"id": "o36", "type": "M036", "cells": [[7, 2]], "params": {"paths": ["p4"]}, "hammerable": false}
```

### M037 — Glue Dot (Mud Trap)
| Field | Value |
|---|---|
| Intro / Category | L371 · **D** |
| Rule | Lane reaching mud stops path there (relocates, 1 Move); next tap continues from mud |
| Clarification | Needle glue cell પર અટકે, body follow કરે (thread નવી position). Next tap: same `dir`, glue cell ignore (stuck નહીં ફરી) |
| Tap / bump | Relocate = 1 Move, no heart. Path to glue blocked ⇒ bump |
| Heart effect | normal |
| Hammerable | No |
| Hint / solver | Thread position state |
| Visual & audio | Clear hot-glue dot; thread sticks "squish" |
| Implementation | Relocation counts for pedal plates & fluff touching |
| Level design | **Do:** park thread on plate (M019). **Don't:** glue right at edge. **Combos:** M019 |
```json
{"id": "o37", "type": "M037", "cells": [[4, 6]], "params": {}, "hammerable": false}
```

### M038 — Elastic Hop Pad (Jump Pad)
| Field | Value |
|---|---|
| Intro / Category | L381 · **G** |
| Rule | Lane over pad leaps the next 1 cell (can jump a 1-cell blocker, not a path) |
| Tap / bump | Next cell = obstacle blocker ⇒ jumped. Next cell = thread body ⇒ bump |
| Heart effect | normal |
| Hammerable | No |
| Hint / solver | Lane resolver |
| Visual & audio | Elastic band trampoline; thread arcs "boing" |
| Implementation | Track arc (quadraticBezierTo) for visual |
| Level design | **Do:** jump over Wooden Button. **Don't:** pad pointing into Hem Wall. **Combos:** M001, M005 |
```json
{"id": "o38", "type": "M038", "cells": [[2, 1]], "params": {}, "hammerable": false}
```

### M039 — Twin Skeins (Mirror Twins)
| Field | Value |
|---|---|
| Intro / Category | L391 · **P** |
| Rule | Tap one ⇒ twin moves mirrored; both must be clear |
| Clarification | Twin `dir` = mirror of tapped `dir` across `params.axis` (V: L↔R; H: U↔D). Blocked ⇒ both snag, **−1 total** (M011 જેમ) |
| Tap / bump | One action, 1 Move |
| Heart effect | −1 total |
| Hammerable | Snip one ⇒ link breaks |
| Hint / solver | Pair action node |
| Visual & audio | Matching skeins with mirror sparkle line between |
| Implementation | Lanes evaluated same pre-move state |
| Level design | **Do:** symmetric boards with one asymmetry. **Don't:** with M011 in same level before T5. **Combos:** M014 |
```json
{"id": "o39", "type": "M039", "cells": [], "params": {"paths": ["p2", "p8"], "axis": "V"}, "hammerable": false}
```

### M040 — Lamplight Evening (Night Board)
| Field | Value |
|---|---|
| Intro / Category | L401 · **G** |
| Rule | Visual: only area near last moved path + long-press preview lit. Rules unchanged |
| Clarification | Lit radius = 2.5 cells around last moved thread route; Thread Peek lights preview lane + target thread |
| Tap / bump | Unchanged (dark threads tappable) |
| Heart effect | Unchanged |
| Hammerable | n/a |
| Hint / solver | Unchanged; Hint glow always visible |
| Visual & audio | Cozy evening, warm lamp vignette (pre-baked radial gradient image, not per-frame blur) |
| Implementation | Overlay layer; accessibility "Reduce darkness" setting ⇒ 60% min brightness |
| Level design | **Do:** medium boards. **Don't:** Daily Challenge. **Combos:** any static |
```json
{"id": "o40", "type": "M040", "cells": [], "params": {"radius": 2.5}, "hammerable": false}
```

### M041 — Ombre Thread (Chameleon Path)
| Field | Value |
|---|---|
| Intro / Category | L411 · **P** |
| Rule | Color cycles (R→G→B) each Move; interacts with M005/M030/M033 |
| Clarification | Colours `red → green → blue → red` (step 3 tick). Lane evaluated with colour at tap time |
| Tap / bump | Normal; colour checks at gates/edges/cages |
| Heart effect | normal |
| Hammerable | Thread: yes |
| Hint / solver | Global move mod 3 |
| Visual & audio | Gradient-dyed yarn, current colour + pattern bold, next colour small swatch on needle |
| Implementation | Pattern changes with colour (colour-blind) |
| Level design | **Do:** timing with Color Eyelet. **Don't:** > 2 ombre per level. **Combos:** M005, M030, M033 |
```json
{"id": "o41", "type": "M041", "cells": [], "params": {"paths": ["p6"], "cycle": ["red", "green", "blue"], "index": 0}, "hammerable": false}
```

### M042 — Fragile Lace Bridge (Fragile Bridge)
| Field | Value |
|---|---|
| Intro / Category | L421 · **L** |
| Rule | Bridge allows 1 crossing then becomes Single Blocker |
| Clarification | Crossing = એક successful lane નીચેથી પસાર થાય. પછી cell = M001 Wooden Button behaviour (જો thread હજી bridge પર હોય તો તે thread નીકળ્યા પછી blocker active; તે thread ની પોતાની exit block નહીં) |
| Tap / bump | Before: like M015. After: blocker |
| Heart effect | normal |
| Hammerable | Intact: no · broken (blocker): **yes** |
| Hint / solver | Bridge state |
| Visual & audio | Delicate lace arch; crossing ⇒ lace tears "rip-soft", becomes knot lump |
| Implementation | Convert to M001 runtime type |
| Level design | **Do:** two threads want same bridge. **Don't:** two crossings required. **Combos:** M015 |
```json
{"id": "o42", "type": "M042", "cells": [[5, 3]], "params": {"axis": "V"}, "hammerable": false}
```

### M043 — Multi-Clasp (Multi-Lock)
| Field | Value |
|---|---|
| Intro / Category | L431 · **K** |
| Rule | Lock needs 2–3 keys (all key-paths exit) |
| Tap / bump | Blocks until all listed key threads exit; badge shows remaining |
| Heart effect | Bump −1 |
| Hammerable | No |
| Hint / solver | Remaining key set |
| Visual & audio | Clasp with 2–3 charm slots; each key exit fills a slot "click" |
| Implementation | Extends M004 |
| Level design | **Do:** keys in different board areas. **Don't:** key thread behind its own lock. **Combos:** M004, M010 |
```json
{"id": "o43", "type": "M043", "cells": [[0, 4]], "params": {"keyPaths": ["p1", "p5", "p9"]}, "hammerable": false}
```

### M044 — Twisting Pompom Tunnel (Turning Portal)
| Field | Value |
|---|---|
| Intro / Category | L441 · **D** |
| Rule | Portal pair that rotates lane direction 90° on exit side |
| Clarification | `params.turn` = "CW" or "CCW", applied when lane leaves the other portal |
| Tap / bump | Like M008 with turn; destination blocked ⇒ bump |
| Heart effect | normal |
| Hammerable | No |
| Hint / solver | Lane resolver |
| Visual & audio | Swirled two-tone pompoms; emerging thread spirals |
| Implementation | Loop guard |
| Level design | **Do:** reach otherwise unreachable edge. **Don't:** mix with M008 same colour. **Combos:** M029 |
```json
{"id": "o44", "type": "M044", "cells": [[1, 5], [8, 2]], "params": {"pair": "T1", "turn": "CW"}, "hammerable": false}
```

### M045 — Treadle Gear Lever (Gear Lever)
| Field | Value |
|---|---|
| Intro / Category | L451 · **T** |
| Rule | One lever rotates multiple turntables (M013) together |
| Tap / bump | Lever tap = 1 Move ⇒ દરેક linked Spool Spinner નો thread 90° CW |
| Heart effect | none |
| Hammerable | No |
| Hint / solver | Combined state |
| Visual & audio | Sewing-machine treadle with gears; all spools spin "clatter-whirr" |
| Implementation | Spinners without thread (exited) ignored |
| Level design | **Do:** 2–3 spinners wanting different counts. **Don't:** > 3 linked. **Combos:** M013 |
```json
{"id": "o45", "type": "M045", "cells": [[0, 0]], "params": {"spinners": ["o13a", "o13b"]}, "hammerable": false}
```

### M046 — Knitted Loop (Loop Path)
| Field | Value |
|---|---|
| Intro / Category | L461 · **K** |
| Rule | Closed loop; locked until linked key-path exits, then opens at marked head |
| Clarification | Open ⇒ `params.head` cell becomes `body[0]` with `params.dir`; body order from head around loop |
| Tap / bump | Locked tap until open, then normal |
| Heart effect | none while locked |
| Hammerable | Thread: yes (even locked) |
| Hint / solver | Lock state |
| Visual & audio | Ring of knit stitches; open ⇒ stitch drops, needle appears |
| Implementation | Precompute open body list |
| Level design | **Do:** loop around obstacles. **Don't:** loop enclosing its key thread. **Combos:** M004 |
```json
{"id": "o46", "type": "M046", "cells": [], "params": {"paths": ["p7"], "keyPath": "p2", "head": [4, 2], "dir": "U"}, "hammerable": false}
```

### M047 — Growing Knit Thread (Growing Path)
| Field | Value |
|---|---|
| Intro / Category | L471 · **C** |
| Rule | Tail grows 1 cell every N Moves into free cell behind tail (no growth if blocked) |
| Clarification | "Behind tail" = `body[n-1] + (body[n-1] − body[n-2])` |
| Tap / bump | Normal thread |
| Heart effect | normal |
| Hammerable | Thread: yes |
| Hint / solver | Body length state |
| Visual & audio | Knitting stitches appear at tail "knit-click" |
| Implementation | Step 3 tick |
| Level design | **Do:** clear early before it blocks lanes. **Don't:** N = 1. **Combos:** M027 |
```json
{"id": "o47", "type": "M047", "cells": [], "params": {"paths": ["p3"], "n": 3, "counter": 3}, "hammerable": false}
```

### M048 — Color Bundle (Color Group Tap)
| Field | Value |
|---|---|
| Intro / Category | L481 · **P** |
| Rule | Tapping a group-marked path moves all same-color group paths; any blocked ⇒ all bump (−1) |
| Tap / bump | One Move; all lanes evaluated same pre-move state |
| Heart effect | −1 total |
| Hammerable | Snip one ⇒ removed from group |
| Hint / solver | Group action node |
| Visual & audio | Small bundle band icon on needles; group outline glow on press |
| Implementation | Peek shows all group lanes |
| Level design | **Do:** groups of 2–3. **Don't:** group with mutual blocking. **Combos:** M011, M033 |
```json
{"id": "o48", "type": "M048", "cells": [], "params": {"paths": ["p2", "p5", "p9"], "color": "purple"}, "hammerable": false}
```

### M049 — Grand Pincushion Guardian (Guardian)
| Field | Value |
|---|---|
| Intro / Category | L491 · **X** |
| Rule | Multi-cell blocker, HP = linked paths count; each linked exit −1 HP; 0 ⇒ vanish. not hammerable |
| Tap / bump | Blocks lanes; not tappable |
| Heart effect | Bump −1 |
| Hammerable | **No** |
| Hint / solver | HP state |
| Visual & audio | Tomato pincushion 2×2–3×3 with pins = HP; linked threads have pin icon; −1 ⇒ pin pulled "ping"; 0 ⇒ poof of stuffing |
| Implementation | Linked snip ⇒ counts as exit ⇒ −1 HP |
| Level design | **Do:** linked threads spread out. **Don't:** linked thread blocked by guardian itself only. **Combos:** Finale mix |
```json
{"id": "o49", "type": "M049", "cells": [[4, 4], [5, 4], [4, 5], [5, 5]], "params": {"linked": ["p1", "p3", "p6", "p8"]}, "hammerable": false}
```

### Finale — The Grand Quilt (Phase 1 Finale, L500)
| Field | Value |
|---|---|
| Rule | Guardian + mix of ≥ 8 Phase-1 mechanics; composition = Guardian + 9 other mechanic instances (= T5 max 10, standard §16.35) |
| Design | [02 §9](./02_LEVEL_PROGRESSION_0001_0500.md) |
| JSON | `"slot": "finale"`, `"tag": "finale"`, M049 + 9 other instances (≥ 8 distinct `type` values) |

## 4. Unit-test requirement
દરેક M-ID માટે `packages/puzzle_core/test/mechanics/m0xx_test.dart` ફરજિયાત: (a) rule happy path, (b) bump / locked behaviour, (c) Undo restores state, (d) Golden Scissors interaction (incl. Undo history cleared after snip), (e) solver finds 0-heart solution on intro level. QA IDs: [07 §14](./07_FRONTEND_IMPLEMENTATION_AND_QA.md).

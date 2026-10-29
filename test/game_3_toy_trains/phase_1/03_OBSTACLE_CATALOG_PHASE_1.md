# 03 · Obstacle Catalog — Phase 1 (M001–M049) — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 1 ના બધા 49 mechanics + L500 Finale નું developer-ready catalog — દરેક card માં standard §10 ના બધા ફરજિયાત fields.

**Related docs:** [Shared Core Standard §10](../../SHARED_CORE_STANDARD.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [02 Level Progression](./02_LEVEL_PROGRESSION_0001_0500.md) · [04 Boosters](./04_BOOSTERS_COINS_SHOP.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Conventions (નિયમો)

- **Exact rule** column = standard નો generic rule શબ્દશઃ. Theme text એ જ rule નું train-રૂપાંતર છે; વિરોધાભાસ હોય તો standard સાચું.
- Ordering standard મુજબ જ: M00k નું intro = L(10k + 1). Game 3 માં કોઈ swap નથી.
- **Move** = train tap (exit/bump), Cold Engine wake, Sand Drift stop, અથવા interactive cell tap (M009 lever, M013 turntable, M018 switch, M034 yard, M045 gear lever). Locked tap = Move નથી.
- Move-based counters 01 §5.11 ના fixed order માં tick થાય. કોઈ wall-clock timer નથી.
- **Heart-loss events:** bump, M017 at 0, group bump (M011/M039/M048: −1 total). Cowcatcher Shield (Shield) પહેલા absorb કરે.
- **Track Crane (Hammer):** કોઈપણ 1 train (exit ગણાય — key/guardian/cloud/thaw effects trigger) **અથવા** `hammerable: true` obstacle. Standard explicit: M004 barrier, M029 fence, M049 guardian **not** hammerable. Standard જ્યાં કંઈ કહેતું નથી ત્યાં launch default આ catalog માં લખ્યો છે (B-blockers M001/M002, M016, M025, M027, broken M042 = Yes; gates, tiles, interactive cells, locks, edges = No).
- **JSON (schema v3):** દરેક mechanic `mechanics[]` માં entry, `type` = `"M0xx"`. Path-variants (P, અને path-attached C/K જેમ કે M003, M017, M046, M047) train ને `params.path` / `params.paths` થી refer કરે. `paths[].mods` Phase 1 માં `{}` (Phase 3+ modifiers માટે reserved).
- **Hint/solver:** Green Signal Hint (Hint) JSON `solution` prefix ⇒ next step; else on-device solver (50 ms, 50k nodes); fail ⇒ "Try Reverse Gear" toast (Hint consume નહીં).
- **Colour-blind:** દરેક colour-dependent mechanic colour + pattern/icon બંને બતાવે (06 §2).

## 2. Summary Table

| ID | Themed name | Intro | Cat | Exact rule (standard) | Hammerable |
|---|---|---|---|---|---|
| M001 | Buffer Stop | L11 | B | 1 cell; lane blocks. hammerable | Yes |
| M002 | Cargo Crate Row | L21 | B | 2–4 straight cells; lane blocks. hammerable (આખી wall) | Yes |
| M003 | Snowed-In Train | L31 | C | Path locked until K (1–3) adjacent (orthogonal) paths exit; badge shows K | n/a (train → crane removes train) |
| M004 | Ticket & Barrier | L41 | K | Key icon on a path; matching-color Lock cell blocks until key-path exits, then opens permanently. Lock not hammerable | No |
| M005 | Colour Platform Gate | L51 | B | Cell passable only by same-color path; others bump | No |
| M006 | One-Way Rail | L61 | D | Passable only in arrow direction; else bump | No |
| M007 | Level Crossing | L71 | C | Closed gate opens permanently after N Moves (badge N) | No |
| M008 | Tunnel Pair | L81 | D | Lane entering portal A continues from portal B same dir. Path occupying B ⇒ blocked | No |
| M009 | Signal Lever & Semaphores | L91 | T | Tap lever (1 Move) ⇒ all linked gates flip open/closed. Non-monotone | No |
| M010 | Steam Cloud | L101 | C | Paths under fog hidden & locked; a fog area clears when any path whose body touches it exits | No |
| M011 | Coupled Engines | L111 | P | 2 paths linked; tap either ⇒ both try; both lanes must be clear else both bump (−1 heart total) | n/a (train → crane removes train) |
| M012 | Cold Engine | L121 | P | 1st tap wakes (1 Move), 2nd tap exits | n/a (train → crane removes train) |
| M013 | Turntable | L131 | T | Path head on turntable; tap turntable ⇒ rotates that path 90° CW (1 Move) | No |
| M014 | Curve Rail | L141 | D | `/` or `\` cell; lane turns 90° | No |
| M015 | Wooden Overpass | L151 | L | Path cells lying on bridge do not block perpendicular lanes passing under | No |
| M016 | Rock Pile | L161 | C | HP 1–3; −1 HP whenever an exiting lane passes an orthogonally adjacent cell; HP 0 ⇒ removed. hammerable | Yes |
| M017 | Steam Pressure Train | L171 | C | Must exit within N Moves; at 0 ⇒ −1 heart, counter resets to N | n/a (train → crane removes train) |
| M018 | Track Switch | L181 | T | Cell turns lane L or R per state; tap switch toggles (1 Move) | No |
| M019 | Weighbridge Plate | L191 | T | Linked gate open while some path body covers plate; plate-path exits ⇒ gate closes | No |
| M020 | Engine Shed | L201 | G | Internal cell acting as exit; lane reaching it ⇒ path exits into it | No |
| M021 | Phantom Express | L211 | P | Solid on even Move count, ghost (non-blocking, not tappable) on odd | n/a (train → crane removes train) |
| M022 | Shunting Train | L221 | P | Exits tail-first (moves backward); arrow cue on tail | n/a (train → crane removes train) |
| M023 | Push-Pull Train | L231 | P | Head both ends; tap near an end ⇒ exits that way (tap nearest-end rule) | n/a (train → crane removes train) |
| M024 | Wide Load Freight | L241 | P | 2-cell-wide body; needs 2-wide clear lane | n/a (train → crane removes train) |
| M025 | Handcar Patrol | L251 | C | Moves 1 cell along fixed loop each Move; blocks where it stands | Yes |
| M026 | Mail Sack Pickup | L261 | G | Win also requires every gem collected (lane passing gem collects it) | No |
| M027 | Creeping Ivy | L271 | C | Every N Moves grows 1 cell into first free neighbour (fixed order U,R,D,L) | Yes |
| M028 | Timetable Order | L281 | P | Must exit in ascending number order; wrong = locked tap | n/a (train → crane removes train) |
| M029 | Table Edge Fence | L291 | B | Board edge segments walled; lanes hitting edge wall bump. not hammerable | No |
| M030 | Colour Station Exit | L301 | B | Edge opening only for one color | No |
| M031 | Last Call Exit | L311 | C | Open edge segment closes permanently after N Moves | No |
| M032 | Viaduct Deck | L321 | L | Upper-layer paths drawn above; lower path locked while any upper path covers its body; lanes interact only within own layer | No |
| M033 | Locked Siding | L331 | K | Caged path locked until all paths of cage color exit | No |
| M034 | Rotating Yard 2×2 | L341 | T | Tap rotor ⇒ 2×2 contents rotate 90° CW (paths fully inside only) | No |
| M035 | Depot Dispatcher | L351 | P | On exit spawns a short child path at marked cells (if free, else waits) | n/a (train → crane removes train) |
| M036 | Coal Tender | L361 | P | Can exit only if lane passes a food cell (food consumed) | n/a (train → crane removes train) |
| M037 | Sand Drift | L371 | D | Lane reaching mud stops path there (relocates, 1 Move); next tap continues from mud | No |
| M038 | Jump Ramp | L381 | G | Lane over pad leaps the next 1 cell (can jump a 1-cell blocker, not a path) | No |
| M039 | Twin Expresses | L391 | P | Tap one ⇒ twin moves mirrored; both must be clear | n/a (train → crane removes train) |
| M040 | Night Run | L401 | G | Visual: only area near last moved path + long-press preview lit. Rules unchanged | n/a |
| M041 | Rainbow Engine | L411 | P | Color cycles (R→G→B) each Move; interacts with M005/M030/M033 | n/a (train → crane removes train) |
| M042 | Rickety Trestle | L421 | L | Bridge allows 1 crossing then becomes Single Blocker | Broken: Yes |
| M043 | Multi-Ticket Barrier | L431 | K | Lock needs 2–3 keys (all key-paths exit) | No |
| M044 | Bend Tunnel | L441 | D | Portal pair that rotates lane direction 90° on exit side | No |
| M045 | Master Gear Lever | L451 | T | One lever rotates multiple turntables (M013) together | No |
| M046 | Loop Line Train | L461 | K | Closed loop; locked until linked key-path exits, then opens at marked head | n/a (train → crane removes train) |
| M047 | Auto-Coupler Freight | L471 | C | Tail grows 1 cell every N Moves into free cell behind tail (no growth if blocked) | n/a (train → crane removes train) |
| M048 | Convoy Group | L481 | P | Tapping a group-marked path moves all same-color group paths; any blocked ⇒ all bump (−1) | n/a (train → crane removes train) |
| M049 | Clock Tower Guardian | L491 | X | Multi-cell blocker, HP = linked paths count; each linked exit −1 HP; 0 ⇒ vanish. not hammerable | No |
| — | Grand Central Finale | L500 | X | Guardian + mix of ≥ 8 Phase-1 mechanics | — |

Categories: **B** Static Blocker · **K** Key/Lock · **C** Counter (Move-based) · **T** Toggle/Interactive · **P** Path-variant · **D** Direction changer · **L** Layer · **G** Goal/Helper · **X** Boss.

## 3. Mechanic Cards

### M001 · Buffer Stop

| Field | Value |
|---|---|
| ID · Themed name | `M001` · **Buffer Stop** |
| Intro level | L11 (block 11–20) |
| Category | B Static Blocker |
| Exact rule (standard) | 1 cell; lane blocks. hammerable |
| Rule (theme) | લાકડાનું લાલ-સફેદ buffer stop એક cell રોકે છે. કોઈ train નો lane આ cell પર પહોંચે ⇒ blocked. |
| Tap / bump behaviour | Buffer Stop પર tap = કંઈ નહીં (non-interactive, no Move). Lane એના પર પહોંચે ⇒ train buffer સુધી જઈ clack, roll back. |
| Heart effect | Bump ⇒ −1 Heart (Shield absorb કરી શકે). |
| Hammerable? | **Yes** (`hammerable: true`). Track Crane ⇒ cell ખાલી. |
| Hint / solver notes | Static: reverse construction થી solvability ensured. Solver માટે permanent blocked cell. |
| Visual & audio | Red-white striped wooden buffer with two round sprung pads. Bump: `sfx_buffer_clack`, pads compress 2 px. |
| Implementation notes | `StaticBlocker` — `blocksLane(cell, train) => true`. Board picture cache માં draw (static). |
| Level design — Do | Intro (L11): 1 buffer, 6 trains; buffer એવી જગ્યાએ કે player ને order વિચારવો પડે. |
| Level design — Don't | Buffer ને એવી રીતે ન મૂકો કે કોઈ train નો lane કાયમ blocked રહે (validator: unsolvable). |
| Combos | M002 Crate Row, M038 Jump Ramp (ramp 1-cell buffer કૂદાવી શકે), M016 Rock Pile. |

```json
{"id": "o1", "type": "M001", "cells": [[4, 2]], "params": {}, "hammerable": true}
```

### M002 · Cargo Crate Row

| Field | Value |
|---|---|
| ID · Themed name | `M002` · **Cargo Crate Row** |
| Intro level | L21 (block 21–30) |
| Category | B Static Blocker |
| Exact rule (standard) | 2–4 straight cells; lane blocks. hammerable (આખી wall) |
| Rule (theme) | 2–4 લાકડાના cargo crates એક સીધી લાઇન (horizontal કે vertical) માં. દરેક crate cell lane block કરે. |
| Tap / bump behaviour | Non-interactive. Lane કોઈપણ crate cell પર પહોંચે ⇒ bump. |
| Heart effect | Bump ⇒ −1 Heart. |
| Hammerable? | **Yes** — Track Crane આખી row (બધા crates) એક સાથે ઉપાડે. |
| Hint / solver notes | Static blocker set. Solver: permanent blocked cells. |
| Visual & audio | Stacked pine crates with stencil 'FRAGILE'. Hammer: crane hook lifts row, `sfx_crane_lift`. |
| Implementation notes | `cells` must be collinear & contiguous (2–4) — loader assert. One obstacle instance ⇒ D માં O = 1. |
| Level design — Do | Rows થી 'corridors' બનાવો જ્યાં trains ને ક્રમમાં કાઢવી પડે. |
| Level design — Don't | 4-cell row ને 6×6 board પર edge-to-edge ન મૂકો (અડધું board dead). |
| Combos | M001, M008 Tunnel Pair (row ની આજુ-બાજુ), M029 Table Edge Fence. |

```json
{"id": "o2", "type": "M002", "cells": [[2, 5], [3, 5], [4, 5]], "params": {"axis": "h"}, "hammerable": true}
```

### M003 · Snowed-In Train

| Field | Value |
|---|---|
| ID · Themed name | `M003` · **Snowed-In Train** |
| Intro level | L31 (block 31–40) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Path locked until K (1–3) adjacent (orthogonal) paths exit; badge shows K |
| Rule (theme) | Train પર બરફ જામેલો છે; badge K (1–3). એની બાજુની (orthogonal adjacent body cells વાળી) K trains નીકળે ત્યારે બરફ પીગળે. |
| Tap / bump behaviour | K > 0 હોય ત્યારે tap ⇒ **locked tap** (wobble, no heart, no Move). K = 0 ⇒ સામાન્ય train. |
| Heart effect | Locked હોય ત્યારે કોઈ heart loss નથી. Thaw પછી bump ⇒ −1. |
| Hammerable? | Train = path ⇒ Track Crane કોઈપણ train (snowed-in પણ) ઉપાડી શકે (exit ગણાય). |
| Hint / solver notes | State: remaining K. Adjacent set level start પર fix (`params.neighbors`). Hint ક્યારેય locked train glow ન કરે. |
| Visual & audio | Snow cap + ice crystals on cars, badge ❄️K. Each neighbour exit: crack sound `sfx_ice_crack`, K−1. K=0: melt drip animation. |
| Implementation notes | Neighbour set = level start પર જે trains ની body cell orthogonally adjacent હોય. Hammer થી neighbour remove થાય તો પણ K−1. Hammer on the snowed-in train itself = exit. |
| Level design — Do | K = neighbours count કરતાં ઓછું કે બરાબર રાખો. |
| Level design — Don't | બધા neighbours પણ snowed-in હોય એવો deadlock ન બનાવો (validator). |
| Combos | M004 (ticket train snowed-in), M010 Steam Cloud, M028 Timetable Order. |

```json
{"id": "o3", "type": "M003", "cells": [], "params": {"path": "p4", "k": 2, "neighbors": ["p2", "p5", "p6"]}, "hammerable": false}
```

### M004 · Ticket & Barrier

| Field | Value |
|---|---|
| ID · Themed name | `M004` · **Ticket & Barrier** |
| Intro level | L41 (block 41–50) |
| Category | K Key/Lock |
| Exact rule (standard) | Key icon on a path; matching-color Lock cell blocks until key-path exits, then opens permanently. Lock not hammerable |
| Rule (theme) | Train પર golden **ticket** (colour-coded) છે. એ જ colour નો station **barrier** cell lane block કરે. Ticket train exit થાય ⇒ barrier કાયમ માટે ઊંચો થાય. |
| Tap / bump behaviour | Barrier non-interactive. Lane closed barrier પર ⇒ bump. |
| Heart effect | Closed barrier પર bump ⇒ −1. |
| Hammerable? | Barrier **No**. Ticket train ને Track Crane થી ઉપાડો ⇒ exit ગણાય ⇒ barrier ખૂલે. |
| Hint / solver notes | Monotone (barrier ફરી બંધ નથી થતો). Solver state bit `open`. |
| Visual & audio | Barrier arm red/white with coloured ticket slot + icon (colour-blind shape). Open: arm lifts, `sfx_ticket_punch` + bell. |
| Implementation notes | Key-path exit event ⇒ `open = true`. Ticket icon train ની engine પર render. Colour + shape બંને match બતાવો. |
| Level design — Do | Ticket train ને બીજી 1–2 trains પાછળ રાખી chain બનાવો. |
| Level design — Don't | Ticket train નો પોતાનો lane એ જ barrier થી blocked ન રાખો (self-deadlock). |
| Combos | M003, M043 Multi-Ticket Barrier, M010. |

```json
{"id": "o4", "type": "M004", "cells": [[5, 3]], "params": {"color": "blue", "keyPath": "p2"}, "hammerable": false}
```

### M005 · Colour Platform Gate

| Field | Value |
|---|---|
| ID · Themed name | `M005` · **Colour Platform Gate** |
| Intro level | L51 (block 51–60) |
| Category | B Static Blocker |
| Exact rule (standard) | Cell passable only by same-color path; others bump |
| Rule (theme) | રંગીન platform gate: એ જ colour ની train પસાર થઈ શકે; બીજા colour ની train માટે blocker. |
| Tap / bump behaviour | Non-interactive. Different colour lane ⇒ bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No** (launch default `hammerable: false`). |
| Hint / solver notes | Static per colour. M041 Rainbow Engine સાથે state-dependent (colour at Move time). |
| Visual & audio | Painted arch with colour + pattern stripe. Same colour pass: soft chime `sfx_gate_pass`. |
| Implementation notes | `blocksLane(cell, train) => train.color != color`. Train બીજી train ના body ને gate પર block કરે તે સામાન્ય rule. |
| Level design — Do | 2–3 colours, દરેક gate ના બાજુમાં matching train. |
| Level design — Don't | Colour-blind check: pattern વગર gate ન બતાવો. |
| Combos | M041 Rainbow Engine, M030 Colour Station Exit, M033. |

```json
{"id": "o5", "type": "M005", "cells": [[3, 3]], "params": {"color": "red"}, "hammerable": false}
```

### M006 · One-Way Rail

| Field | Value |
|---|---|
| ID · Themed name | `M006` · **One-Way Rail** |
| Intro level | L61 (block 61–70) |
| Category | D Direction changer |
| Exact rule (standard) | Passable only in arrow direction; else bump |
| Rule (theme) | Arrow વાળો rail piece: lane માત્ર arrow ની દિશામાં પસાર થઈ શકે. બીજી કોઈ દિશા (ઉલટી કે perpendicular) ⇒ blocker. |
| Tap / bump behaviour | Non-interactive. Wrong-direction lane ⇒ bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Static per travel direction. |
| Visual & audio | Rail tile with carved arrow; Route Peek lane passing correctly = green, wrong = red ✕. Bump: `sfx_buffer_clack`. |
| Implementation notes | `blocksLane(cell, travelDir) => travelDir != arrow`. Travel dir = current lane segment dir (portals/curves પછી). |
| Level design — Do | Arrow વિરુદ્ધ train ને બીજા route (tunnel/curve) થી કાઢવી પડે એવા puzzle. |
| Level design — Don't | Train ના car ને arrow tile પર initially ન મૂકો. |
| Combos | M008, M014, M018. |

```json
{"id": "o6", "type": "M006", "cells": [[2, 4]], "params": {"arrow": "R"}, "hammerable": false}
```

### M007 · Level Crossing

| Field | Value |
|---|---|
| ID · Themed name | `M007` · **Level Crossing** |
| Intro level | L71 (block 71–80) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Closed gate opens permanently after N Moves (badge N) |
| Rule (theme) | બંધ level crossing gate; badge N. દરેક Move (exit, bump, interactive tap) પછી N−1. N = 0 ⇒ gate કાયમ ખૂલે. |
| Tap / bump behaviour | Non-interactive. Closed હોય ત્યારે lane ⇒ bump. |
| Heart effect | Closed gate bump ⇒ −1. (Bump પણ Move છે, પણ heart ખર્ચીને રાહ જોવી ક્યારેય જરૂરી નથી — validator.) |
| Hammerable? | **No**. |
| Hint / solver notes | State: N. Solver state માં counter include. |
| Visual & audio | Crossing barrier with flashing lamps + wooden counter flag showing N. Open: bell `sfx_crossing_bell`. |
| Implementation notes | Tick step 3 (01 §5.11). Wall-clock timer નહીં. Locked taps tick નથી કરતા. |
| Level design — Do | N ≤ crossing ની જરૂર પડે તે પહેલાં exit થઈ શકે એટલી trains. |
| Level design — Don't | N એટલો મોટો ન રાખો કે player ને bump કરીને wait કરવું પડે. |
| Combos | M001, M017, M031. |

```json
{"id": "o7", "type": "M007", "cells": [[4, 1]], "params": {"n": 4}, "hammerable": false}
```

### M008 · Tunnel Pair

| Field | Value |
|---|---|
| ID · Themed name | `M008` · **Tunnel Pair** |
| Intro level | L81 (block 81–90) |
| Category | D Direction changer |
| Exact rule (standard) | Lane entering portal A continues from portal B same dir. Path occupying B ⇒ blocked |
| Rule (theme) | બે matching tunnel mouths (A, B — same number plaque). Lane A માં પ્રવેશે ⇒ B માંથી એ જ દિશામાં આગળ (B ⇒ A પણ). |
| Tap / bump behaviour | Non-interactive. B cell પર train નો car હોય ⇒ lane blocked ⇒ bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Lane graph માં teleport edge. Lane cell revisit (infinite loop) ⇒ blocked; generator આવું બનાવતો નથી. |
| Visual & audio | Stone tunnel portal pair with numbered plaque. Cars enter A in sequence and emerge from B, `sfx_tunnel_whoosh`. |
| Implementation notes | Renderer: route = two polyline segments; cars clipped at tunnel mouth. Exit animation ≤ 450 ms. |
| Level design — Do | Board ના બે વિસ્તારોને જોડી 'દૂરનો blocker' puzzle. |
| Level design — Don't | Portal B ને સીધું edge-adjacent ન મૂકો જ્યાં કોઈ effect ન હોય. |
| Combos | M044 Bend Tunnel, M006, M026. |

```json
{"id": "o8", "type": "M008", "cells": [[1, 3], [6, 5]], "params": {"pair": 1}, "hammerable": false}
```

### M009 · Signal Lever & Semaphores

| Field | Value |
|---|---|
| ID · Themed name | `M009` · **Signal Lever & Semaphores** |
| Intro level | L91 (block 91–100) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | Tap lever (1 Move) ⇒ all linked gates flip open/closed. Non-monotone |
| Rule (theme) | Signal lever cell + 1–3 linked semaphore gates. Lever tap ⇒ બધા linked semaphores flip (open ↔ closed). |
| Tap / bump behaviour | Lever tap = **1 Move** (counters tick). Closed semaphore પર lane ⇒ bump. Lever cell પોતે blocker (fixture). |
| Heart effect | Lever tap: no heart. Closed semaphore bump ⇒ −1. |
| Hammerable? | Lever **No**, semaphore **No**. |
| Hint / solver notes | Non-monotone: solver toggles explore. `solution` માં lever id ⇒ Hint lever glow કરે. |
| Visual & audio | Lever with brass knob; semaphore arm up + green lamp = open, arm down + red lamp = closed. `sfx_lever_clunk`. |
| Implementation notes | Gate cells પર train initially ન હોય (generator). Lever cell non-passable. |
| Level design — Do | એક lever બે gates (એક ખૂલે, એક બંધ થાય) — order puzzle. |
| Level design — Don't | Gate state ઉલટાવવાથી previously cleared route હંમેશા બંધ થાય એવું deadlock. |
| Combos | M018, M019, M045. |

```json
{"id": "o9", "type": "M009", "cells": [[0, 7]], "params": {"gates": [[3, 2], [5, 6]], "initial": ["closed", "open"]}, "hammerable": false}
```

### M010 · Steam Cloud

| Field | Value |
|---|---|
| ID · Themed name | `M010` · **Steam Cloud** |
| Intro level | L101 (block 101–110) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Paths under fog hidden & locked; a fog area clears when any path whose body touches it exits |
| Rule (theme) | વરાળનો વાદળ (1+ cells area). નીચેની trains છુપાયેલી અને locked. કોઈ train જેની body cloud ને touch કરે (cloud cell માં કે orthogonally adjacent) exit થાય ⇒ આખો cloud area clear. |
| Tap / bump behaviour | Cloud નીચેની train પર tap ⇒ locked tap. Cloud cells blocker નથી, પણ hidden trains ના cars lane block કરે. |
| Heart effect | Hidden car સાથે bump ⇒ −1 (Route Peek લાલ બતાવે ⇒ fair). |
| Hammerable? | Cloud **No**. Hidden train select ન થઈ શકે; touching train ને crane થી ઉપાડો ⇒ exit ⇒ cloud clear. |
| Hint / solver notes | Solver full info. Hint hidden train ને ક્યારેય glow ન કરે. |
| Visual & audio | Pre-rendered white puff sprites, slow drift. Clear: puff burst + `sfx_steam_hiss`. |
| Implementation notes | Touch = exit સમયે body cell ∈ area ∪ area ના orthogonal neighbours. Thursday 'Fog Day' વધારે clouds (05). |
| Level design — Do | Cloud ની બાજુમાં 'opener' train મૂકો. |
| Level design — Don't | Opener train વગરનો cloud (permanent lock = validator fail). |
| Combos | M003, M026, M040 Night Run. |

```json
{"id": "o10", "type": "M010", "cells": [[5, 5], [6, 5], [5, 6], [6, 6]], "params": {"area": 1}, "hammerable": false}
```

### M011 · Coupled Engines

| Field | Value |
|---|---|
| ID · Themed name | `M011` · **Coupled Engines** |
| Intro level | L111 (block 111–120) |
| Category | P Path-variant |
| Exact rule (standard) | 2 paths linked; tap either ⇒ both try; both lanes must be clear else both bump (−1 heart total) |
| Rule (theme) | બે trains brass coupling chain થી જોડાયેલી. કોઈ એક પર tap ⇒ બંને એક સાથે દોડે. બંને lanes clear જોઈએ; નહીં તો બંને clack કરી પાછી આવે. |
| Tap / bump behaviour | Tap either = 1 Move. Both clear ⇒ both exit in one animation. |
| Heart effect | Any blocked ⇒ both bump, **−1 heart total**. |
| Hammerable? | Crane એક train ઉપાડે ⇒ એ exit; બાકી train સામાન્ય (unlinked) બને. |
| Hint / solver notes | Atomic 2-train move. Lanes pre-move board પર evaluate: A નો lane B ના cars ને hit કરે ⇒ blocked. |
| Visual & audio | Brass coupling chain between engines. `sfx_double_toot`. |
| Implementation notes | Simultaneous lane check (both trains present). Both routes animate on the same controller. |
| Level design — Do | એક coupled train ની lane બીજી train થી blocked — પહેલાં એ clear કરવી પડે. |
| Level design — Don't | Pair ના lanes એકબીજાના cars માંથી પસાર થાય એવું (never solvable). |
| Combos | M039, M048, M004. |

```json
{"id": "o11", "type": "M011", "cells": [], "params": {"paths": ["p3", "p7"]}, "hammerable": false}
```

### M012 · Cold Engine

| Field | Value |
|---|---|
| ID · Themed name | `M012` · **Cold Engine** |
| Intro level | L121 (block 121–130) |
| Category | P Path-variant |
| Exact rule (standard) | 1st tap wakes (1 Move), 2nd tap exits |
| Rule (theme) | ઠંડું engine (boiler off). પહેલો tap boiler ચાલુ કરે (1 Move), બીજો tap train ચલાવે. |
| Tap / bump behaviour | 1st tap = wake (1 Move, lane check નહીં). 2nd tap = normal exit/bump. |
| Heart effect | Wake: no heart. 2nd tap blocked ⇒ −1. |
| Hammerable? | Path ⇒ crane થી ઉપાડી શકાય (exit). |
| Hint / solver notes | State bit `awake`. Hint wake step ને પણ glow કરે. |
| Visual & audio | Grey engine, chimney cap closed; wake: puff + `sfx_boiler_ignite`, colour fades in 200 ms. |
| Implementation notes | Wake Move-based ticks કરે (01 §5.11). Reverse Gear Undo wake ⇒ asleep again. |
| Level design — Do | Counter mechanics (M007, M017) સાથે 'spare Move' તરીકે. |
| Level design — Don't | એક level માં ઘણા cold engines (tap fatigue). |
| Combos | M007, M017, M021. |

```json
{"id": "o12", "type": "M012", "cells": [], "params": {"path": "p5"}, "hammerable": false}
```

### M013 · Turntable

| Field | Value |
|---|---|
| ID · Themed name | `M013` · **Turntable** |
| Intro level | L131 (block 131–140) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | Path head on turntable; tap turntable ⇒ rotates that path 90° CW (1 Move) |
| Rule (theme) | Engine turntable પર ઊભું છે. Turntable cell પર tap ⇒ engine 90° clockwise ફરે (dir U→R→D→L→U). |
| Tap / bump behaviour | Turntable cell tap = **1 Move** (tap priority: turntable cell ⇒ turntable, 01 §5.9). Train ચલાવવા બીજા car પર tap. |
| Heart effect | Rotation: no heart. પછી blocked exit ⇒ −1. |
| Hammerable? | Turntable **No**. Train crane થી ઉપાડી શકાય. |
| Hint / solver notes | State: dir (4 values). Rotation પછી engine નો નવો `dir` પોતાના carriage (`body[1]`) તરફ ⇒ train **"tangled"** ⇒ train tap = locked tap (no heart, no Move, bump નહીં) જ્યાં સુધી turntable ફરી rotate ન થાય (standard §16.19, §17.39; 01 §8). Solver એ state માં exit option skip કરે. |
| Visual & audio | Round wooden turntable with rail bridge; rotation 180 ms `Curves.easeInOut`, `sfx_turntable_creak`. |
| Implementation notes | માત્ર engine `dir` rotate; carriages જ્યાં છે ત્યાં. Turntable ખાલી (train exited) ⇒ tap = locked tap. |
| Level design — Do | Train ને 2–3 rotations પછી જ clear direction મળે. |
| Level design — Don't | Turntable પર engine સિવાયનો car ન મૂકો. |
| Combos | M045 Master Gear Lever, M018, M008. |

```json
{"id": "o13", "type": "M013", "cells": [[4, 4]], "params": {"path": "p2"}, "hammerable": false}
```

### M014 · Curve Rail

| Field | Value |
|---|---|
| ID · Themed name | `M014` · **Curve Rail** |
| Intro level | L141 (block 141–150) |
| Category | D Direction changer |
| Exact rule (standard) | `/` or `\` cell; lane turns 90° |
| Rule (theme) | Fixed curved rail piece (`/` કે `\`). Lane એ cell પર પહોંચે ⇒ 90° વળે. |
| Tap / bump behaviour | Non-interactive. Curve cell પોતે blocker નથી. |
| Heart effect | — (curve પછીનો blocker ⇒ સામાન્ય bump −1). |
| Hammerable? | **No**. |
| Hint / solver notes | `/`: R→U, U→R, L→D, D→L. `\`: R→D, D→R, L→U, U→L. |
| Visual & audio | Curved wooden rail piece; wheels squeal `sfx_curve_squeal` as cars pass. |
| Implementation notes | Route polyline curve cell centre પર corner; cars heading smoothing (07 §5). |
| Level design — Do | Lane ને board ના બીજા ભાગમાં વાળી blocker sequence બનાવો. |
| Level design — Don't | Curves થી lane ને એ જ train ના cars પર પાછો ન વાળો. |
| Combos | M008, M018, M006. |

```json
{"id": "o14", "type": "M014", "cells": [[6, 2]], "params": {"orient": "/"}, "hammerable": false}
```

### M015 · Wooden Overpass

| Field | Value |
|---|---|
| ID · Themed name | `M015` · **Wooden Overpass** |
| Intro level | L151 (block 151–160) |
| Category | L Layer |
| Exact rule (standard) | Path cells lying on bridge do not block perpendicular lanes passing under |
| Rule (theme) | Overpass cell: એના પર ઊભેલી train નો car perpendicular દિશાના lanes ને block નથી કરતો (lane નીચેથી પસાર). |
| Tap / bump behaviour | Non-interactive. Deck axis ની દિશાનો lane deck પરના car ને hit કરે ⇒ bump. |
| Heart effect | Parallel bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Direction-dependent blocking: lane ⊥ deck axis ⇒ pass under. |
| Visual & audio | Raised wooden deck with pillars; train passing under draws below deck. `sfx_bridge_rumble`. |
| Implementation notes | `axis` = deck direction (cars on it lie along axis). Perpendicular lanes pass under the car. |
| Level design — Do | 'Crossing traffic' puzzle: deck પરની train ને પછી કાઢવી ફાયદાકારક. |
| Level design — Don't | Overpass cell train ના corner car પર ન મૂકો. |
| Combos | M032, M042 Rickety Trestle. |

```json
{"id": "o15", "type": "M015", "cells": [[3, 4]], "params": {"axis": "h"}, "hammerable": false}
```

### M016 · Rock Pile

| Field | Value |
|---|---|
| ID · Themed name | `M016` · **Rock Pile** |
| Intro level | L161 (block 161–170) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | HP 1–3; −1 HP whenever an exiting lane passes an orthogonally adjacent cell; HP 0 ⇒ removed. hammerable |
| Rule (theme) | પથ્થરોનો ઢગલો (HP 1–3). કોઈ train **exit** થાય અને એનો lane rock ના orthogonally adjacent cell માંથી પસાર થાય ⇒ vibration થી HP −1. HP 0 ⇒ rock ગાયબ. |
| Tap / bump behaviour | Non-interactive. Rock cell blocker ⇒ lane પહોંચે તો bump. |
| Heart effect | Bump ⇒ −1. Bump (failed lane) HP ઘટાડતો નથી — માત્ર successful exit lane. |
| Hammerable? | **Yes** (`hammerable: true`). |
| Hint / solver notes | State: HP. Same exit lane multiple adjacent cells pass કરે તો પણ −1 per exit (per rock). |
| Visual & audio | Grey rock pile with crack overlay per HP. HP−1: dust puff + `sfx_rock_crack`. |
| Implementation notes | On exit: lane cells set ∩ N4(rock) ≠ ∅ ⇒ hp−1. Tunnel route ના બંને segments ગણાય. |
| Level design — Do | Rock ની બાજુની lanes વાળી 2–3 trains પહેલાં કાઢવાથી રસ્તો ખૂલે. |
| Level design — Don't | HP > adjacent-lane trains ની સંખ્યા. |
| Combos | M001, M008, M038. |

```json
{"id": "o16", "type": "M016", "cells": [[5, 2]], "params": {"hp": 2}, "hammerable": true}
```

### M017 · Steam Pressure Train

| Field | Value |
|---|---|
| ID · Themed name | `M017` · **Steam Pressure Train** |
| Intro level | L171 (block 171–180) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Must exit within N Moves; at 0 ⇒ −1 heart, counter resets to N |
| Rule (theme) | Boiler pressure gauge N વાળી train. દરેક Move પછી N−1. N Moves માં exit ન થાય ⇒ pressure release: −1 heart અને gauge પાછો N. |
| Tap / bump behaviour | Normal train (tap any car). |
| Heart effect | Counter 0 ⇒ **−1 heart** (heart-loss event; Shield absorb કરે). Bump ⇒ −1 as usual. |
| Hammerable? | Path ⇒ crane ઉપાડી શકે (counter disappears). |
| Hint / solver notes | State: counter. Validator: optimal solution counter 0 થાય તે પહેલાં exit કરાવે (0 hearts). |
| Visual & audio | Brass pressure gauge above engine with N; N ≤ 2 ⇒ needle shakes, red tint. 0: whistle shriek `sfx_pressure_release` + steam. |
| Implementation notes | Tick step 3; heart loss step 5. Wall-clock timer નહીં. Undo counter revert કરે, heart નહીં. |
| Level design — Do | N = (minimum Moves to free it) + 2 slack. |
| Level design — Don't | બે pressure trains જેમના N એક સાથે tight હોય (frustrating). |
| Combos | M007, M012, M009. |

```json
{"id": "o17", "type": "M017", "cells": [], "params": {"path": "p6", "n": 5}, "hammerable": false}
```

### M018 · Track Switch

| Field | Value |
|---|---|
| ID · Themed name | `M018` · **Track Switch** |
| Intro level | L181 (block 181–190) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | Cell turns lane L or R per state; tap switch toggles (1 Move) |
| Rule (theme) | Points (switch) cell: lane આ cell પર પહોંચે ⇒ travel direction થી relative **Left** કે **Right** વળે (state મુજબ). Switch tap ⇒ L ↔ R. |
| Tap / bump behaviour | Switch cell tap = **1 Move**. Switch cell blocker નથી. |
| Heart effect | Toggle: no heart. વળ્યા પછી blocked ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | State: L/R. Non-monotone (N count). |
| Visual & audio | Points lever lamp shows arrow (L/R) + rail blades animate 120 ms. `sfx_points_click`. |
| Implementation notes | Turn relative to incoming travel dir: L = 90° CCW, R = 90° CW. Train initially switch cell પર નથી (generator). |
| Level design — Do | બે trains જેમને switch ની જુદી સ્થિતિ જોઈએ (toggle between exits). |
| Level design — Don't | Switch ને board edge પર એવી રીતે ન મૂકો કે એક state હંમેશા edge બહાર જાય (trivial). |
| Combos | M009, M014, M013. |

```json
{"id": "o18", "type": "M018", "cells": [[3, 3]], "params": {"state": "L"}, "hammerable": false}
```

### M019 · Weighbridge Plate

| Field | Value |
|---|---|
| ID · Themed name | `M019` · **Weighbridge Plate** |
| Intro level | L191 (block 191–200) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | Linked gate open while some path body covers plate; plate-path exits ⇒ gate closes |
| Rule (theme) | Weighbridge plate: જ્યાં સુધી કોઈ train નો car plate પર ઊભો છે ત્યાં સુધી linked depot gate ખુલ્લો. એ train exit ⇒ gate બંધ. |
| Tap / bump behaviour | Plate non-interactive (tap ⇒ nothing). Gate closed ⇒ lane bump. |
| Heart effect | Closed gate bump ⇒ −1. |
| Hammerable? | Plate **No**, gate **No**. Plate-train ને crane ઉપાડે ⇒ exit ⇒ gate બંધ. |
| Hint / solver notes | Non-monotone: plate-train ને મોડું કાઢવું જરૂરી. Solver ordering explore. |
| Visual & audio | Iron weighbridge plate with needle dial; gate = wooden depot door. Close: `sfx_gate_thud`. |
| Implementation notes | Gate open = ∃ train car on plate (recomputed step 4). Phase 1 માં trains plate પર ફક્ત initially (trains move only off-board, Sand Drift સિવાય). |
| Level design — Do | 'Hold the door' puzzle: plate-train છેલ્લી કાઢો. |
| Level design — Don't | Plate-train નો lane gate ની પાછળ (gate ખુલ્લો રાખવા train ને રહેવું પડે અને એ નીકળી ન શકે). |
| Combos | M009, M037 Sand Drift (train mud stop પછી plate પર આવી શકે), M020. |

```json
{"id": "o19", "type": "M019", "cells": [[2, 6]], "params": {"gate": [5, 1]}, "hammerable": false}
```

### M020 · Engine Shed

| Field | Value |
|---|---|
| ID · Themed name | `M020` · **Engine Shed** |
| Intro level | L201 (block 201–210) |
| Category | G Goal/Helper |
| Exact rule (standard) | Internal cell acting as exit; lane reaching it ⇒ path exits into it |
| Rule (theme) | Board ની અંદરનું engine shed (inner exit). Lane shed cell પર પહોંચે ⇒ train shed માં ઊતરી જાય (exit). |
| Tap / bump behaviour | Shed non-interactive. Shed ના પહેલાંના lane cells clear હોવા જોઈએ. |
| Heart effect | — |
| Hammerable? | **No**. |
| Hint / solver notes | Lane terminates at shed (edge જેવું). |
| Visual & audio | Small brick shed with open doors; cars disappear inside sequentially. `sfx_shed_doors`. |
| Implementation notes | Exit animation: route ends at shed centre; cars clipped by shed mask. |
| Level design — Do | Board centre ની trains ને ટૂંકો રસ્તો આપો; edge clutter ઘટાડો. |
| Level design — Don't | Shed ને edge-adjacent ન મૂકો (redundant). |
| Combos | M014, M018, M029 Table Edge Fence. |

```json
{"id": "o20", "type": "M020", "cells": [[5, 5]], "params": {}, "hammerable": false}
```

### M021 · Phantom Express

| Field | Value |
|---|---|
| ID · Themed name | `M021` · **Phantom Express** |
| Intro level | L211 (block 211–220) |
| Category | P Path-variant |
| Exact rule (standard) | Solid on even Move count, ghost (non-blocking, not tappable) on odd |
| Rule (theme) | Phantom train: `moveCount` even ⇒ solid (block કરે, tap થાય); odd ⇒ ghost (અર્ધપારદર્શક, બીજી lanes આરપાર, tap ⇒ locked). |
| Tap / bump behaviour | Ghost phase tap ⇒ locked tap. Solid phase ⇒ normal. |
| Heart effect | Solid phase bump ⇒ −1. Ghost phase કોઈને block નથી કરતી. |
| Hammerable? | Path ⇒ crane (બંને phases માં selectable). |
| Hint / solver notes | State = move parity. Cold Engine wake / lever tap થી parity બદલી શકાય. |
| Visual & audio | Ghost: 35% alpha + shimmer; solid: full. Phase flip: `sfx_phantom_chime`. |
| Implementation notes | Solid iff `moveCount % 2 == 0` (start = 0 ⇒ solid). Lane check uses parity **before** the Move increments. |
| Level design — Do | Parity puzzle: player ને 'spare' Move (lever/wake) વાપરવો પડે. |
| Level design — Don't | એક level માં 3+ phantoms (visual noise). |
| Combos | M012, M009, M018. |

```json
{"id": "o21", "type": "M021", "cells": [], "params": {"path": "p3"}, "hammerable": false}
```

### M022 · Shunting Train

| Field | Value |
|---|---|
| ID · Themed name | `M022` · **Shunting Train** |
| Intro level | L221 (block 221–230) |
| Category | P Path-variant |
| Exact rule (standard) | Exits tail-first (moves backward); arrow cue on tail |
| Rule (theme) | Shunting train રિવર્સમાં દોડે: lane tail (છેલ્લા car) થી શરૂ, tail direction = body[n-2] → body[n-1]. |
| Tap / bump behaviour | Tap any car ⇒ reverse exit/bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | Path ⇒ crane. |
| Hint / solver notes | Lane computed from tail. Engine arrow dimmed, tail shows reverse arrow. |
| Visual & audio | Yellow-black shunting stripes, reverse lamp on tail. `sfx_reverse_beep`. |
| Implementation notes | Route polyline built head→tail (reverse of normal). `dir` field ignored for lane; renderer arrow on tail. |
| Level design — Do | Player ની 'engine જ્યાં જુએ ત્યાં જાય' ની આદતને પડકાર આપો — tutorial card clear હોય. |
| Level design — Don't | Intro level માં shunting train ને સામાન્ય train જેવો દેખાવ ન આપો. |
| Combos | M023, M020, M014. |

```json
{"id": "o22", "type": "M022", "cells": [], "params": {"path": "p8"}, "hammerable": false}
```

### M023 · Push-Pull Train

| Field | Value |
|---|---|
| ID · Themed name | `M023` · **Push-Pull Train** |
| Intro level | L231 (block 231–240) |
| Category | P Path-variant |
| Exact rule (standard) | Head both ends; tap near an end ⇒ exits that way (tap nearest-end rule) |
| Rule (theme) | બંને છેડે cab વાળી push-pull train. Tap થયેલા car ની નજીકના છેડા તરફ train દોડે. |
| Tap / bump behaviour | Tapped car index i: i < (n−1)/2 ⇒ engine end (body[0], `dir`); i > (n−1)/2 ⇒ tail end (reverse lane). Exact middle (odd n) ⇒ engine end. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | Path ⇒ crane. |
| Hint / solver notes | Two possible moves per train. Hint glows the correct **end car**. |
| Visual & audio | Cab at both ends, both arrows; tapped end arrow flashes. `sfx_double_horn`. |
| Implementation notes | `tailDir` explicit (for straight trains equals reverse of `dir`). Middle-tap tie rule must match solver move encoding `p4@head` / `p4@tail`. |
| Level design — Do | એક છેડો blocked, બીજો ખુલ્લો — player ને સાચો છેડો પસંદ કરવો પડે. |
| Level design — Don't | 2-car push-pull (middle ambiguity વધારે); 3+ cars વાપરો. |
| Combos | M022, M011. |

```json
{"id": "o23", "type": "M023", "cells": [], "params": {"path": "p4", "tailDir": "L"}, "hammerable": false}
```

### M024 · Wide Load Freight

| Field | Value |
|---|---|
| ID · Themed name | `M024` · **Wide Load Freight** |
| Intro level | L241 (block 241–250) |
| Category | P Path-variant |
| Exact rule (standard) | 2-cell-wide body; needs 2-wide clear lane |
| Rule (theme) | બે tracks પહોળી માલગાડી. Body = primary line + side line. Exit માટે બંને parallel lanes clear જોઈએ. |
| Tap / bump behaviour | Tap any of its cells ⇒ exit/bump. |
| Heart effect | Any of the 2 lanes blocked ⇒ bump −1. |
| Hammerable? | Path ⇒ crane (whole freight). |
| Hint / solver notes | Lane set = 2 parallel lanes. Straight body only (no bends). |
| Visual & audio | Flatbed freight with oversized timber load spanning 2 tracks. `sfx_heavy_chug`. |
| Implementation notes | `side` = second line offset relative to `dir` (R = clockwise side). Occupied cells = body ∪ shifted body. Portals/curves: wide lane through M008/M014 = bump unless both lanes enter matching pair (Phase 1: generator avoids). |
| Level design — Do | Wide freight ને છેલ્લે કાઢવાનું puzzle (બંને lanes ખાલી કરો). |
| Level design — Don't | Wide freight + Tunnel Pair / Curve Rail lane (Phase 1 માં disallow). |
| Combos | M002, M029. |

```json
{"id": "o24", "type": "M024", "cells": [], "params": {"path": "p9", "side": "R"}, "hammerable": false}
```

### M025 · Handcar Patrol

| Field | Value |
|---|---|
| ID · Themed name | `M025` · **Handcar Patrol** |
| Intro level | L251 (block 251–260) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Moves 1 cell along fixed loop each Move; blocks where it stands |
| Rule (theme) | Handcar trolley એક fixed loop (cells ની cycle) પર દર Move પછી 1 cell આગળ વધે. જ્યાં ઊભી છે ત્યાં blocker. |
| Tap / bump behaviour | Handcar tap ⇒ nothing (non-interactive). Lane handcar cell પર ⇒ bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **Yes** (launch default) — crane handcar ઉપાડી લે. |
| Hint / solver notes | State: index on loop. Lane blocked evaluation uses position **before** tick. |
| Visual & audio | Two-figure pump handcar, see-saw animation each tick. `sfx_handcar_squeak`. |
| Implementation notes | Next cell occupied by a train ⇒ handcar waits (no move that tick). Loop cells shown as faint dashed track. |
| Level design — Do | Timing (Move-count) puzzle: player lever/wake થી handcar ખસેડી રસ્તો ખોલે. |
| Level design — Don't | Handcar loop પર trains initially ન મૂકો. |
| Combos | M012, M009, M021. |

```json
{"id": "o25", "type": "M025", "cells": [[2, 2], [3, 2], [3, 3], [2, 3]], "params": {"start": 0}, "hammerable": true}
```

### M026 · Mail Sack Pickup

| Field | Value |
|---|---|
| ID · Themed name | `M026` · **Mail Sack Pickup** |
| Intro level | L261 (block 261–270) |
| Category | G Goal/Helper |
| Exact rule (standard) | Win also requires every gem collected (lane passing gem collects it) |
| Rule (theme) | Board પર mail sacks. કોઈ train **exit** થાય અને એનો lane sack cell માંથી પસાર થાય ⇒ sack collected. Win = બધી trains exit + બધા sacks collected. |
| Tap / bump behaviour | Sack non-interactive, non-blocking. |
| Heart effect | — |
| Hammerable? | **No** (crane થી ઉપાડેલી train નો lane collect કરતો નથી). |
| Hint / solver notes | Goal state bitset. Validator: બધા sacks reachable by some exit lane order. |
| Visual & audio | Canvas mail sack with stamp; collect: flies to HUD goal counter `✉ 2/3`, `sfx_mail_pop`. |
| Implementation notes | `goals.gems` = sack count. Bump lanes collect નથી કરતા. Board પર છેલ્લી train exit થાય પણ sacks બાકી ⇒ unwinnable state ⇒ "Missed a mail sack — Reverse Gear or Retry" toast. |
| Level design — Do | Sack ને એવી lane પર રાખો જે માત્ર ચોક્કસ order માં available હોય. |
| Level design — Don't | Sack જેના પર કોઈ lane ક્યારેય પસાર ન થાય. |
| Combos | M008, M014, M018. |

```json
{"id": "o26", "type": "M026", "cells": [[4, 6]], "params": {}, "hammerable": false}
```

### M027 · Creeping Ivy

| Field | Value |
|---|---|
| ID · Themed name | `M027` · **Creeping Ivy** |
| Intro level | L271 (block 271–280) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Every N Moves grows 1 cell into first free neighbour (fixed order U,R,D,L) |
| Rule (theme) | લીલી ivy patch: દર N Moves પછી 1 નવો cell ઉગાડે. Ivy cells blocker. |
| Tap / bump behaviour | Non-interactive. Lane ivy cell પર ⇒ bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **Yes** (standard §16.18) — crane ivy નો **એક cell** ઉપાડે (tapped cell); બાકીની patch રહે અને ઉગતી રહે. |
| Hint / solver notes | State: cell set + counter. Growth order deterministic: patch cells in creation order, each tries U, R, D, L; first free cell wins. |
| Visual & audio | Leafy ivy tiles; growth: sprout pop 150 ms `sfx_leaf_rustle`. Badge shows Moves until next growth. |
| Implementation notes | Free = in-board, no train car, no obstacle, not edge-wall. Growth can block lanes ⇒ validator solves with growth. |
| Level design — Do | Ivy ને 'pressure' તરીકે — ઝડપથી ચોક્કસ trains કાઢો. |
| Level design — Don't | Ivy ને ticket barrier / shed ને કાયમ ઢાંકે એવું. |
| Combos | M017, M007, M016. |

```json
{"id": "o27", "type": "M027", "cells": [[7, 7]], "params": {"n": 3}, "hammerable": true}
```

### M028 · Timetable Order

| Field | Value |
|---|---|
| ID · Themed name | `M028` · **Timetable Order** |
| Intro level | L281 (block 281–290) |
| Category | P Path-variant |
| Exact rule (standard) | Must exit in ascending number order; wrong = locked tap |
| Rule (theme) | Numbered trains (timetable badge 1, 2, 3…). માત્ર સૌથી નાનો બાકી number ધરાવતી train જઈ શકે. બીજી numbered train પર tap ⇒ locked. |
| Tap / bump behaviour | Out-of-order ⇒ locked tap (no heart, no Move). Unnumbered trains free. |
| Heart effect | Correct-order train blocked ⇒ bump −1. |
| Hammerable? | Path ⇒ crane કોઈપણ numbered train ઉપાડી શકે; પછી sequence = બાકીમાં સૌથી નાનો number. |
| Hint / solver notes | Order constraint. Hint next numbered/free train. |
| Visual & audio | Station departure board badge with number; next-allowed badge glows. `sfx_timetable_flip`. |
| Implementation notes | `order[0]` = #1. Allowed = first remaining in `order`. |
| Level design — Do | Order અને lane dependency વિરોધી દિશામાં (player ને વિચારવું પડે). |
| Level design — Don't | Order જે lanes થી અશક્ય (validator). |
| Combos | M003, M011, M004. |

```json
{"id": "o28", "type": "M028", "cells": [], "params": {"order": ["p2", "p5", "p1"]}, "hammerable": false}
```

### M029 · Table Edge Fence

| Field | Value |
|---|---|
| ID · Themed name | `M029` · **Table Edge Fence** |
| Intro level | L291 (block 291–300) |
| Category | B Static Blocker |
| Exact rule (standard) | Board edge segments walled; lanes hitting edge wall bump. not hammerable |
| Rule (theme) | Table edge ના અમુક segments પર લાકડાની fence. Lane એ edge segment પર પહોંચે ⇒ fence સાથે clack. |
| Tap / bump behaviour | Non-interactive. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No** (standard). |
| Hint / solver notes | Edge exit disabled for those segments. |
| Visual & audio | Picket fence along table edge. `sfx_buffer_clack`. |
| Implementation notes | Cells = boundary cells; `side` = which edge (corner cells need explicit side). Lane final cell boundary + side match ⇒ blocked. |
| Level design — Do | Engine Shed (M020) / Tunnel ને જરૂરી બનાવો. |
| Level design — Don't | એક train ના બધા possible exits fenced. |
| Combos | M020, M008, M014. |

```json
{"id": "o29", "type": "M029", "cells": [[0, 3], [0, 4]], "params": {"side": "L"}, "hammerable": false}
```

### M030 · Colour Station Exit

| Field | Value |
|---|---|
| ID · Themed name | `M030` · **Colour Station Exit** |
| Intro level | L301 (block 301–310) |
| Category | B Static Blocker |
| Exact rule (standard) | Edge opening only for one color |
| Rule (theme) | Edge segment પર રંગીન station gate: માત્ર એ colour ની train ત્યાંથી નીકળી શકે; બીજા colours ⇒ bump. |
| Tap / bump behaviour | Non-interactive. |
| Heart effect | Wrong colour ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Edge per-colour filter. Rainbow Engine colour at Move time. |
| Visual & audio | Coloured station arch on table edge + colour-blind pattern. `sfx_gate_pass` / `sfx_buffer_clack`. |
| Implementation notes | Same edge representation as M029 + `color`. |
| Level design — Do | Colour routing: train ને curve/switch થી પોતાના colour exit સુધી પહોંચાડો. |
| Level design — Don't | Colour exits જ્યાં એ colour ની કોઈ train પહોંચી ન શકે. |
| Combos | M041, M018, M005. |

```json
{"id": "o30", "type": "M030", "cells": [[7, 0], [8, 0]], "params": {"side": "U", "color": "green"}, "hammerable": false}
```

### M031 · Last Call Exit

| Field | Value |
|---|---|
| ID · Themed name | `M031` · **Last Call Exit** |
| Intro level | L311 (block 311–320) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Open edge segment closes permanently after N Moves |
| Rule (theme) | Edge segment 'last call' bell સાથે ખુલ્લો; N Moves પછી કાયમ બંધ (fence બની જાય). |
| Tap / bump behaviour | Non-interactive. |
| Heart effect | Closed પછી bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | State: N. Validator: solution uses it before closure (or never needs it). |
| Visual & audio | Station gate with countdown flag N; closing: gate slam `sfx_gate_slam`. |
| Implementation notes | Tick step 3. At 0 ⇒ converts to M029 segment state. |
| Level design — Do | Urgency: 'પહેલા કઈ train?' decision. |
| Level design — Don't | N < moves needed to reach the needed train. |
| Combos | M007, M017, M029. |

```json
{"id": "o31", "type": "M031", "cells": [[10, 4], [10, 5]], "params": {"side": "R", "n": 5}, "hammerable": false}
```

### M032 · Viaduct Deck

| Field | Value |
|---|---|
| ID · Themed name | `M032` · **Viaduct Deck** |
| Intro level | L321 (block 321–330) |
| Category | L Layer |
| Exact rule (standard) | Upper-layer paths drawn above; lower path locked while any upper path covers its body; lanes interact only within own layer |
| Rule (theme) | બે level: ground tracks (layer 0) અને viaduct deck (layer 1). Viaduct trains ઉપર દોરાય. Ground train જેના કોઈ car ઉપર viaduct train હોય ⇒ locked. Lanes માત્ર પોતાના layer ની trains/obstacles સાથે interact. |
| Tap / bump behaviour | Overlap cell ⇒ upper train ને tap (tap priority). Covered ground train ⇒ locked tap. |
| Heart effect | Bump within layer ⇒ −1. |
| Hammerable? | Path ⇒ crane (upper first if overlap cell tapped). |
| Hint / solver notes | Layer-separated lane check. Lock = cover relation. |
| Visual & audio | Viaduct trains with arch shadow; covered ground trains 60% dim. `sfx_viaduct_echo`. |
| Implementation notes | Level `layers: 2`; paths `layer: 0|1`; obstacles `params.layer` default 0. Lock recomputed step 4. |
| Level design — Do | Upper trains ને unlock order તરીકે વાપરો. |
| Level design — Don't | Ground train ને 3+ upper trains નીચે (visual clutter at 29 dp). |
| Combos | M015, M042, M028. |

```json
{"id": "o32", "type": "M032", "cells": [], "params": {"layers": 2}, "hammerable": false}
```

### M033 · Locked Siding

| Field | Value |
|---|---|
| ID · Themed name | `M033` · **Locked Siding** |
| Intro level | L331 (block 331–340) |
| Category | K Key/Lock |
| Exact rule (standard) | Caged path locked until all paths of cage color exit |
| Rule (theme) | Train રંગીન siding cage માં બંધ. Cage colour ની **બધી** trains exit થાય ⇒ cage ખૂલે. |
| Tap / bump behaviour | Caged train ⇒ locked tap. |
| Heart effect | — |
| Hammerable? | Cage **No**. Caged train ને crane ઉપાડી શકે (path). |
| Hint / solver notes | Lock until colour-set empty. Rainbow Engine: colour **at the moment of check** (step 4) — Rainbow train બીજા colour માં હોય તો ગણાતી નથી. |
| Visual & audio | Colour-painted siding fence around train + colour icon. Open: fence folds `sfx_cage_open`. |
| Implementation notes | Caged train નો પોતાનો colour cage colour થી અલગ હોવો જોઈએ (loader assert). |
| Level design — Do | Colour chains: blue cage ⇒ blue trains ⇒ એમાંની એક yellow cage ખોલે. |
| Level design — Don't | Cage colour ની કોઈ train બીજા cage માં (circular). |
| Combos | M004, M041, M005. |

```json
{"id": "o33", "type": "M033", "cells": [], "params": {"path": "p7", "color": "yellow"}, "hammerable": false}
```

### M034 · Rotating Yard 2×2

| Field | Value |
|---|---|
| ID · Themed name | `M034` · **Rotating Yard 2×2** |
| Intro level | L341 (block 341–350) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | Tap rotor ⇒ 2×2 contents rotate 90° CW (paths fully inside only) |
| Rule (theme) | 2×2 rotating yard platform. Yard tap ⇒ અંદરનું બધું (trains જે સંપૂર્ણ અંદર છે + single-cell obstacles) 90° CW ફરે; trains નો `dir` પણ CW ફરે. |
| Tap / bump behaviour | Yard = interactive mechanic ⇒ **interactive cell wins** (standard §16.19): yard hub (centre handle) અને train car વગરના yard cells પર tap ⇒ yard rotate = **1 Move**; hub hit area train car ની ઉપર હોય તો પણ tap yard ને જ મળે. કોઈ train **આંશિક રીતે** yard માં હોય ⇒ yard jammed ⇒ yard tap = **locked tap** (no heart, no Move). |
| Heart effect | Rotation: no heart. |
| Hammerable? | **No**. |
| Hint / solver notes | Non-monotone (4 states). |
| Visual & audio | Wooden square platform with corner bolts, rotate 220 ms `Curves.easeInOut`, `sfx_yard_rotate`. |
| Implementation notes | Tap priority (§16.19): hub handle (yard centre, hit radius 0.4 cell) અને free yard cells ⇒ yard (interactive wins); hub hit area ની બહારના train car ⇒ train tap (અંદરની train ને exit કરાવવા). Partial train ⇒ yard locked tap. Trains inside are length 2–4. |
| Level design — Do | Small train 2-car ને ફેરવીને નવો exit. |
| Level design — Don't | Yard ને ઘણી trains આંશિક રીતે overlap કરે (jammed forever ⇒ validator). |
| Combos | M013, M045, M006. |

```json
{"id": "o34", "type": "M034", "cells": [[3, 3], [4, 3], [3, 4], [4, 4]], "params": {}, "hammerable": false}
```

### M035 · Depot Dispatcher

| Field | Value |
|---|---|
| ID · Themed name | `M035` · **Depot Dispatcher** |
| Intro level | L351 (block 351–360) |
| Category | P Path-variant |
| Exact rule (standard) | On exit spawns a short child path at marked cells (if free, else waits) |
| Rule (theme) | Dispatcher train exit થાય ⇒ depot marker cells પર નવી નાની train (2 cars) spawn થાય. Marker cells occupied હોય તો spawn રાહ જુએ (free થાય એ Move ના અંતે). |
| Tap / bump behaviour | Dispatcher: normal. Child: normal train. |
| Heart effect | — |
| Hammerable? | Crane થી dispatcher ઉપાડો ⇒ exit ⇒ child spawn થાય. |
| Hint / solver notes | Train count changes; solver includes pending spawn. |
| Visual & audio | Depot marker = dashed outline + whistle icon; spawn: child rolls out of mini depot, `sfx_depot_bell`. |
| Implementation notes | Spawn check in step 4 every Move until spawned. Win requires child exit too. |
| Level design — Do | Child ને બીજી train ના lane માં spawn કરાવો (order matters). |
| Level design — Don't | Child spawn cells કાયમ occupied. |
| Combos | M020, M028. |

```json
{"id": "o35", "type": "M035", "cells": [[2, 8], [3, 8]], "params": {"path": "p1", "child": {"color": "orange", "dir": "D", "body": [[2, 8], [3, 8]]}}, "hammerable": false}
```

### M036 · Coal Tender

| Field | Value |
|---|---|
| ID · Themed name | `M036` · **Coal Tender** |
| Intro level | L361 (block 361–370) |
| Category | P Path-variant |
| Exact rule (standard) | Can exit only if lane passes a food cell (food consumed) |
| Rule (theme) | કોલસા વગરની tender train. Exit માટે એનો lane કોઈ **coal pile** cell માંથી પસાર થવો જોઈએ; exit પર coal consumed. |
| Tap / bump behaviour | Lane clear પણ lane માં coal નથી ⇒ **bump** (buffer clack, −1 heart, Move +1; standard §16.6). Lane blocked ⇒ bump. |
| Heart effect | Bump (no coal અથવા blocked lane) ⇒ −1. |
| Hammerable? | Path ⇒ crane (coal not consumed). |
| Hint / solver notes | Coal piles = resource. બે tenders એક pile share કરે ⇒ order puzzle. Solver/Hint જાણે છે કે no-coal tap = bump (§16.6), એટલે તે ક્યારેય suggest ન થાય. |
| Visual & audio | Empty tender with coal icon; coal pile = black lumps on tile; consumed: lumps fly into tender `sfx_coal_shovel`. |
| Implementation notes | One M036 entry per tender: `params.path` = tender, `cells` = coal piles it can use. Coal cells non-blocking for every train; only the tender consumes. A pile listed for two tenders is shared — consumed once, gone for both. |
| Level design — Do | Coal ની lane ને પહેલાં ખાલી કરવી પડે. |
| Level design — Don't | Tender જેનો lane કોઈ coal પર ન જાય. |
| Combos | M008, M014, M018. |

```json
{"id": "o36", "type": "M036", "cells": [[6, 3]], "params": {"path": "p4"}, "hammerable": false}
```

### M037 · Sand Drift

| Field | Value |
|---|---|
| ID · Themed name | `M037` · **Sand Drift** |
| Intro level | L371 (block 371–380) |
| Category | D Direction changer |
| Exact rule (standard) | Lane reaching mud stops path there (relocates, 1 Move); next tap continues from mud |
| Rule (theme) | Sand drift cell: lane ત્યાં પહોંચે ⇒ train આગળ વધીને engine sand cell પર અટકે (carriages પાછળ follow કરે). આગળનો tap ત્યાંથી એ જ `dir` માં આગળ વધે. |
| Tap / bump behaviour | Stop = 1 Move (relocation, no heart). Next tap: lane starts after sand cell (same sand ફરી stop નથી કરતું). |
| Heart effect | Sand સુધીનો lane blocked ⇒ bump −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Train position changes ⇒ solver state includes body cells. |
| Visual & audio | Sand pile tile; wheels sink, sand puff `sfx_sand_scrunch`. |
| Implementation notes | Relocation: body shifts along route polyline by distance to sand cell. Relocated cars may now cover a Weighbridge plate (M019) or block others. |
| Level design — Do | Mid-board stop જે બીજી train ને block/unblock કરે. |
| Level design — Don't | Sand સીધી edge cell પર (useless). |
| Combos | M019, M026, M016. |

```json
{"id": "o37", "type": "M037", "cells": [[4, 7]], "params": {}, "hammerable": false}
```

### M038 · Jump Ramp

| Field | Value |
|---|---|
| ID · Themed name | `M038` · **Jump Ramp** |
| Intro level | L381 (block 381–390) |
| Category | G Goal/Helper |
| Exact rule (standard) | Lane over pad leaps the next 1 cell (can jump a 1-cell blocker, not a path) |
| Rule (theme) | લાકડાનો ramp: lane ramp cell પરથી પસાર ⇒ આગળનો 1 cell કૂદે. એ cell માં 1-cell static blocker (Buffer Stop, Rock Pile, Crate Row નો cell) હોય તો પણ પાર. Train car હોય ⇒ bump. |
| Tap / bump behaviour | Non-interactive, non-blocking. |
| Heart effect | Jumped cell માં train car ⇒ bump −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Lane skip of exactly 1 cell. |
| Visual & audio | Ramp with spring; train hops with arc (y-offset in renderer), `sfx_boing_clack`. |
| Implementation notes | Jumped cell's Mail Sack is **not** collected (lane skips it). Gates/barriers in jumped cell: treated as 1-cell blocker ⇒ jumped. |
| Level design — Do | Buffer stop પાછળ trains ને shortcut. |
| Level design — Don't | Ramp પછી તરત edge (no effect). |
| Combos | M001, M016, M026. |

```json
{"id": "o38", "type": "M038", "cells": [[3, 6]], "params": {}, "hammerable": false}
```

### M039 · Twin Expresses

| Field | Value |
|---|---|
| ID · Themed name | `M039` · **Twin Expresses** |
| Intro level | L391 (block 391–400) |
| Category | P Path-variant |
| Exact rule (standard) | Tap one ⇒ twin moves mirrored; both must be clear |
| Rule (theme) | Twin expresses (mirrored colours/livery). એક પર tap ⇒ બીજી **mirrored** (board ની vertical axis પર mirror) દિશામાં સાથે દોડે. બંને lanes clear જોઈએ. |
| Tap / bump behaviour | Tap either = 1 Move. Twin `dir` = mirror of tapped train's `dir` (stored explicitly in JSON). |
| Heart effect | Any blocked ⇒ both bump, **−1 heart total** (same as M011). |
| Hammerable? | Crane એકને ઉપાડે ⇒ બીજી સામાન્ય train. |
| Hint / solver notes | Atomic 2-train move. |
| Visual & audio | Matching silver liveries with mirrored stripe; `sfx_twin_whistle`. |
| Implementation notes | Behaviour = M011 with mirrored layout guaranteed by generator; difference is visual + layout symmetry. |
| Level design — Do | Symmetric boards (Saturday silhouettes). |
| Level design — Don't | Twins whose mirrored lanes cross each other. |
| Combos | M011, M048. |

```json
{"id": "o39", "type": "M039", "cells": [], "params": {"paths": ["p2", "p9"], "axis": "v"}, "hammerable": false}
```

### M040 · Night Run

| Field | Value |
|---|---|
| ID · Themed name | `M040` · **Night Run** |
| Intro level | L401 (block 401–410) |
| Category | G Goal/Helper |
| Exact rule (standard) | Visual: only area near last moved path + long-press preview lit. Rules unchanged |
| Rule (theme) | રાતનો playmat: માત્ર છેલ્લી moved train ની આસપાસ (radius 2 cells) અને Route Peek lane પ્રકાશિત. Rules બદલાતા નથી. |
| Tap / bump behaviour | Normal; dark cells પણ tap થઈ શકે. |
| Heart effect | Normal. |
| Hammerable? | — |
| Hint / solver notes | Solver unaffected. Hint glow full brightness. |
| Visual & audio | Dark overlay (pre-baked radial gradient mask), engine headlamps. `bgm_night_box`. |
| Implementation notes | Overlay drawn above board picture; accessibility setting 'Reduce darkness' ⇒ 50% overlay. |
| Level design — Do | Simple layouts + memory element. |
| Level design — Don't | Night Run + Steam Cloud + many counters (unreadable). |
| Combos | M010, M026. |

```json
{"id": "o40", "type": "M040", "cells": [], "params": {"radius": 2}, "hammerable": false}
```

### M041 · Rainbow Engine

| Field | Value |
|---|---|
| ID · Themed name | `M041` · **Rainbow Engine** |
| Intro level | L411 (block 411–420) |
| Category | P Path-variant |
| Exact rule (standard) | Color cycles (R→G→B) each Move; interacts with M005/M030/M033 |
| Rule (theme) | Rainbow engine નો colour દર Move પછી red → green → blue → red ફરે. Colour Platform Gate, Colour Station Exit, Locked Siding સાથે current colour પ્રમાણે interact. |
| Tap / bump behaviour | Normal. Lane check uses colour **before** the tick of this Move. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | Path ⇒ crane. |
| Hint / solver notes | State: colour index (mod 3). |
| Visual & audio | Colour shifts with 150 ms tween + pattern changes too (colour-blind: R=circle, G=diamond, B=triangle). |
| Implementation notes | Tick step 3 (after action). Locked taps don't tick. |
| Level design — Do | Colour gate timing with spare Moves. |
| Level design — Don't | Rainbow + 3 colour gates in a row. |
| Combos | M005, M030, M033. |

```json
{"id": "o41", "type": "M041", "cells": [], "params": {"path": "p6", "start": "red"}, "hammerable": false}
```

### M042 · Rickety Trestle

| Field | Value |
|---|---|
| ID · Themed name | `M042` · **Rickety Trestle** |
| Intro level | L421 (block 421–430) |
| Category | L Layer |
| Exact rule (standard) | Bridge allows 1 crossing then becomes Single Blocker |
| Rule (theme) | કાચો લાકડાનો trestle (bridge cell). પહેલી train ની successful exit lane એના પરથી પસાર ⇒ trestle તૂટીને Buffer-Stop જેવો blocker (M001) બને. |
| Tap / bump behaviour | Non-interactive. |
| Heart effect | Broken trestle bump ⇒ −1. |
| Hammerable? | Intact: **No**. Broken (= Single Blocker): **Yes**. |
| Hint / solver notes | State bit `broken`. Bump lanes don't break it. |
| Visual & audio | Wobbly trestle; crossing creaks, then collapses into a pile of planks `sfx_trestle_collapse`. |
| Implementation notes | Intact trestle passable in both axis directions (lane cell, non-blocking). Train cars never start on it. JSON `hammerable: false` = intact state; break થાય ત્યારે engine instance ને `hammerable = true` કરે (broken M042 hammerable, standard §16.18). Track Crane થી કાઢેલી train crossing ગણાતી નથી (§16.31). |
| Level design — Do | 'Only one can cross' choice puzzles. |
| Level design — Don't | બે trains ને જ trestle જરૂરી (unsolvable). |
| Combos | M015, M032, M001. |

```json
{"id": "o42", "type": "M042", "cells": [[5, 4]], "params": {"axis": "v"}, "hammerable": false}
```

### M043 · Multi-Ticket Barrier

| Field | Value |
|---|---|
| ID · Themed name | `M043` · **Multi-Ticket Barrier** |
| Intro level | L431 (block 431–440) |
| Category | K Key/Lock |
| Exact rule (standard) | Lock needs 2–3 keys (all key-paths exit) |
| Rule (theme) | 2–3 ticket slots વાળો barrier: બધી ticket trains exit થાય ત્યારે જ ખૂલે. |
| Tap / bump behaviour | Non-interactive. Closed ⇒ bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Monotone; slot fill count shown. |
| Visual & audio | Barrier with 2–3 ticket slots; each punched slot lights. `sfx_ticket_punch`. |
| Implementation notes | Crane-removed key train counts as exit. |
| Level design — Do | Key trains board ના અલગ ખૂણામાં. |
| Level design — Don't | Key train પોતે barrier પાછળ. |
| Combos | M004, M003, M028. |

```json
{"id": "o43", "type": "M043", "cells": [[6, 6]], "params": {"keyPaths": ["p2", "p4", "p8"]}, "hammerable": false}
```

### M044 · Bend Tunnel

| Field | Value |
|---|---|
| ID · Themed name | `M044` · **Bend Tunnel** |
| Intro level | L441 (block 441–450) |
| Category | D Direction changer |
| Exact rule (standard) | Portal pair that rotates lane direction 90° on exit side |
| Rule (theme) | Tunnel pair જેમાંથી બહાર નીકળતી વખતે lane 90° વળે (`turn: CW|CCW`, A→B; B→A ઉલટું). |
| Tap / bump behaviour | Non-interactive. Exit side cell occupied ⇒ blocked. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Teleport + rotate edge. |
| Visual & audio | Curved stone tunnel mouths with arrow plaque. `sfx_tunnel_whoosh`. |
| Implementation notes | A→B: newDir = rotate(dir, turn); B→A: rotate(dir, inverse turn). |
| Level design — Do | Multi-step routing with M014/M018. |
| Level design — Don't | Bend Tunnel + Wide Load Freight (Phase 1 disallow). |
| Combos | M008, M018, M030. |

```json
{"id": "o44", "type": "M044", "cells": [[1, 1], [8, 5]], "params": {"turn": "CW"}, "hammerable": false}
```

### M045 · Master Gear Lever

| Field | Value |
|---|---|
| ID · Themed name | `M045` · **Master Gear Lever** |
| Intro level | L451 (block 451–460) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | One lever rotates multiple turntables (M013) together |
| Rule (theme) | Gear lever cell જે 2–3 linked turntables ને એક સાથે 90° CW ફેરવે. |
| Tap / bump behaviour | Gear lever tap = **1 Move**. Turntables still individually tappable (each tap = 1 Move). |
| Heart effect | No heart. |
| Hammerable? | **No**. |
| Hint / solver notes | Composite rotation; solver explores. |
| Visual & audio | Brass gear lever; linked turntables connected by faint gear-chain lines. `sfx_gear_grind`. |
| Implementation notes | Empty turntables rotate nothing. Rotation પછી engine `dir` પોતાના `body[1]` તરફ ⇒ એ train **"tangled"** ⇒ locked tap જ્યાં સુધી ફરી rotate ન થાય (standard §17.39, 01 §8). |
| Level design — Do | Two trains needing opposite rotation counts — mix lever + single turntable taps. |
| Level design — Don't | 5+ linked turntables. |
| Combos | M013, M034. |

```json
{"id": "o45", "type": "M045", "cells": [[0, 0]], "params": {"turntables": ["o13a", "o13b"]}, "hammerable": false}
```

### M046 · Loop Line Train

| Field | Value |
|---|---|
| ID · Themed name | `M046` · **Loop Line Train** |
| Intro level | L461 (block 461–470) |
| Category | K Key/Lock |
| Exact rule (standard) | Closed loop; locked until linked key-path exits, then opens at marked head |
| Rule (theme) | 4 cars ની train 2×2 ring track પર closed loop માં (engine + 3 carriages, ring). Linked ticket train exit થાય ⇒ loop marked engine પર ખૂલે અને train સામાન્ય train (marked `dir`) બને. **આ સિવાય game માં કોઈ loop/figure-8 track નથી.** |
| Tap / bump behaviour | Locked ⇒ locked tap. Opened ⇒ normal train. |
| Heart effect | Opened train bump ⇒ −1. |
| Hammerable? | Path ⇒ crane (loop train પણ, exit ગણાય). |
| Hint / solver notes | Lock until key exit (monotone). |
| Visual & audio | Ring track with padlock + ticket colour; open: ring rail splits at engine, `sfx_loop_unlock`. |
| Implementation notes | Path body = 4 cells forming a 2×2 ring (`body[0]` = marked engine, body[3] adjacent to body[0]). After open: body ordered from engine, dir = `openDir`; ring closure edge removed. |
| Level design — Do | Loop ને board ના centre માં 'boss' જેવું. |
| Level design — Don't | Loop open dir જે તરત body[1] પર પડે. |
| Combos | M004, M043, M049. |

```json
{"id": "o46", "type": "M046", "cells": [], "params": {"path": "p5", "keyPath": "p2", "headIndex": 0, "openDir": "U"}, "hammerable": false}
```

### M047 · Auto-Coupler Freight

| Field | Value |
|---|---|
| ID · Themed name | `M047` · **Auto-Coupler Freight** |
| Intro level | L471 (block 471–480) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Tail grows 1 cell every N Moves into free cell behind tail (no growth if blocked) |
| Rule (theme) | દર N Moves પછી tail પાછળ 1 નવો freight wagon આપમેળે જોડાય (free cell હોય તો). Wagons 4 થી વધી શકે — એકમાત્ર exception. |
| Tap / bump behaviour | Normal. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | Path ⇒ crane. |
| Hint / solver notes | Body grows ⇒ blocks more lanes over time. |
| Visual & audio | Wagon slides in from tail with coupling clink `sfx_coupler_clink`; badge shows Moves to next wagon. |
| Implementation notes | Behind tail = tail + (tail − body[n−2]). Not free (occupied / off-board / blocker) ⇒ no growth that cycle, counter resets. |
| Level design — Do | Urgency to clear freight early. |
| Level design — Don't | Growth into cells that would permanently trap others. |
| Combos | M027, M017. |

```json
{"id": "o47", "type": "M047", "cells": [], "params": {"path": "p3", "n": 4}, "hammerable": false}
```

### M048 · Convoy Group

| Field | Value |
|---|---|
| ID · Themed name | `M048` · **Convoy Group** |
| Intro level | L481 (block 481–490) |
| Category | P Path-variant |
| Exact rule (standard) | Tapping a group-marked path moves all same-color group paths; any blocked ⇒ all bump (−1) |
| Rule (theme) | Convoy flag વાળી same-colour trains એક group. કોઈ એક પર tap ⇒ group ની બધી trains સાથે દોડે; કોઈ એક blocked ⇒ બધી bump, −1 heart total. |
| Tap / bump behaviour | Tap any group train = 1 Move. |
| Heart effect | Any blocked ⇒ −1 total. |
| Hammerable? | Crane એક group train ઉપાડે ⇒ group ના બાકી members ચાલુ રહે. |
| Hint / solver notes | Atomic group move; simultaneous lane check. |
| Visual & audio | Matching convoy flags on engines; group outline pulse on long-press. `sfx_convoy_horns`. |
| Implementation notes | Non-group trains of the same colour behave normally. |
| Level design — Do | Group ના એક member નો lane છેલ્લે ખૂલે. |
| Level design — Don't | Group lanes crossing each other. |
| Combos | M011, M039, M005. |

```json
{"id": "o48", "type": "M048", "cells": [], "params": {"paths": ["p1", "p4", "p6"], "color": "purple"}, "hammerable": false}
```

### M049 · Clock Tower Guardian

| Field | Value |
|---|---|
| ID · Themed name | `M049` · **Clock Tower Guardian** |
| Intro level | L491 (block 491–500) |
| Category | X Boss |
| Exact rule (standard) | Multi-cell blocker, HP = linked paths count; each linked exit −1 HP; 0 ⇒ vanish. not hammerable |
| Rule (theme) | મોટો station clock tower (2×2 કે 3×3). HP = linked trains (clock-hand badge). દરેક linked train exit ⇒ HP −1 (chime). HP 0 ⇒ tower ગાયબ. |
| Tap / bump behaviour | Non-interactive (tap ⇒ shows linked trains highlight, no Move). |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No** (standard). Crane linked train ઉપાડે ⇒ exit ⇒ HP −1. |
| Hint / solver notes | Monotone HP. |
| Visual & audio | Brick clock tower with HP as hour marks; each hit: chime + crack `sfx_clock_chime`; vanish: tower folds into toy box. |
| Implementation notes | HP = `linked.length`. Linked trains marked with clock icon. |
| Level design — Do | Linked trains board ના ચારે ખૂણે. |
| Level design — Don't | Linked train જેનો lane tower પોતે block કરે અને બીજો રસ્તો નથી. |
| Combos | M004, M046, finale mix. Sunday Daily 'Mini Boss'. |

```json
{"id": "o49", "type": "M049", "cells": [[4, 4], [5, 4], [4, 5], [5, 5]], "params": {"linked": ["p1", "p3", "p7", "p9"]}, "hammerable": false}
```

### L500 · Grand Central Finale

| Field | Value |
|---|---|
| ID · Themed name | `—` (level tag `finale`) · **Grand Central Finale** |
| Intro level | L500 |
| Category | X Boss |
| Exact rule (standard) | Guardian + mix of ≥ 8 Phase-1 mechanics |
| Rule (theme) | Clock Tower Guardian (M049) centre માં + **9 બીજા mechanic instances** (= tier max 10, standard §16.35), જેમાં ઓછામાં ઓછા 8 જુદા Phase-1 mechanics. નવો rule કોઈ નથી — માત્ર combination. Full layout: [02 §7](./02_LEVEL_PROGRESSION_0001_0500.md) |
| Tap / bump behaviour | દરેક mechanic પોતાના card મુજબ |
| Heart effect | Standard 3 hearts, standard revive |
| Hammerable? | Guardian No; બાકી દરેક card મુજબ |
| Hint / solver notes | Hand-tuned, solver-verified (0 hearts, 0 boosters), D ≈ 62 ±3 |
| Visual & audio | Station-at-dusk board skin, brass band BGM sting at Guardian vanish, confetti + Grand Central Chest |
| Implementation notes | Same engine; no special-case code. `slot: "finale"` + `tag: "finale"` ⇒ 50 coins, Phase Chest flow (§16.15) |
| Level design — Do | 3 acts (outer ring ⇒ routing ⇒ guardian), clear visual focus |
| Level design — Don't | Night Run / Steam Cloud on finale (readability at 11×11) |
| Combos | M004, M008, M009, M013, M018, M026, M029, M042, M049 |

```json
{"schema": 3, "level": 500, "phase": 1, "slot": "finale", "tag": "finale", "grid": [11, 11], "layers": 1, "hearts": 3,
 "mechanics": [{"id": "g1", "type": "M049", "cells": [[4,4],[5,4],[6,4],[4,5],[5,5],[6,5],[4,6],[5,6],[6,6]], "params": {"linked": ["p3","p8","p12","p17","p21","p25"]}, "hammerable": false}],
 "goals": {"gems": 2}, "par_moves": 32}
```

## 4. Full Level JSON Example (schema v3, L141 intro of M014)

```json
{
  "schema": 3, "level": 141, "phase": 1, "seed": "0x00A1B2C3D4E5F607",
  "slot": "intro", "tag": "normal", "grid": [8, 8], "layers": 1, "hearts": 3,
  "paths": [
    {"id": "p1", "color": "green", "dir": "R", "body": [[3,2],[2,2],[1,2]], "layer": 0, "mods": {}},
    {"id": "p2", "color": "red", "dir": "U", "body": [[6,5],[6,6]], "layer": 0, "mods": {}}
  ],
  "mechanics": [
    {"id": "o1", "type": "M014", "cells": [[6,2]], "params": {"orient": "/"}, "hammerable": false}
  ],
  "goals": {"gems": 0},
  "par_moves": 2, "difficulty": 5.2,
  "solution": ["p1", "p2"]
}
```
(Abbreviated teaching snippet: p1 lane → Curve Rail at (6,2) turns U → exits top; then p2 lane U → curve turns R → exits right. Real L141 follows T2: 7×7–9×9, 10–18 trains, D 14–26.)


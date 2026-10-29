# 03 · Obstacle Catalog — Phase 2 (M051–M099) — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 2 ના બધા 49 mechanics + L1000 Finale નું developer-ready catalog — દરેક card માં standard §10 ના બધા ફરજિયાત fields, toy-railway themed names, exact standard rule, અને standard જ્યાં edge case ખુલ્લો રાખે ત્યાં game definition.

**Related docs:** [Shared Core Standard §10, §12, §16](../../SHARED_CORE_STANDARD.md) · [01 Phase 2 Rules](./01_PHASE_2_SCOPE_AND_RULES.md) · [02 Progression 0501–1000](./02_LEVEL_PROGRESSION_0501_1000.md) · [Phase 1 Catalog](../phase_1/03_OBSTACLE_CATALOG_PHASE_1.md) · [06 Frontend & QA](./06_FRONTEND_AND_QA_PHASE_2.md)

---

## 1. Conventions (નિયમો)

- **Exact rule (standard)** row = standard §10 નો generic rule શબ્દશઃ. "Rule (theme)" એ જ rule નું train-રૂપાંતર. વિરોધ હોય તો standard સાચું.
- **Edge case (game definition)** row = standard જ્યાં ચૂપ છે ત્યાં આ game નો binding નિર્ણય (engine + solver + QA આ જ વાપરે). આખી list: §5.
- Ordering standard મુજબ: M0kk intro = L(10·kk + 1), દા.ત. M051 → L511, M099 → L991. કોઈ swap નથી.
- **Move**, tick order, completed-vs-bump lanes, dead-end sheet, lanes vs beams: [01 §5–§8](./01_PHASE_2_SCOPE_AND_RULES.md). Tick order (standard §16.17): action → `moveCount += 1` → M007, M017, M031, M025, M027, M047, M041, M057, M058, M063, M067, M068, M075, M079, M082, M090, M096 → derived states → heart loss → win → 0-heart.
- **Track Crane (Hammer):** 1 train (exit ગણાય) **અથવા** `hammerable: true` obstacle. Standard §16.18 defaults: Phase 2 માં **માત્ર M053/M054 Push Carts hammerable**; બાકી gates, tiles, interactive cells, locks, edges, Guardians, M074 = No. Rule-implied exception: **M097 first domino** (standard rule "hammer or linked exit") = Yes. Hidden/covered/invisible train target ન થઈ શકે (§16.8). Hammered train lane travel કરતો નથી.
- **Intro rule:** x1 intro = intro mechanic + ≤ 1 earlier mechanic. Composite mechanics નો partner (M054/M055 ⇒ M053 cart; M085/M086/M089 ⇒ M084 lamp; M083 ⇒ M024; M080 ⇒ M011; M078 ⇒ M020; M099 ⇒ M084, its sensor is built-in) એ 1 slot વાપરે.
- **JSON (schema v3):** `mechanics[]` entry, `type` = `"M0xx"`, `cells`, `params`, `hammerable`. Path-variants train ને `params.path` / `params.paths` થી refer કરે. Layered obstacles `params.layer` (default 0). Edge segments `{"side": "top|right|bottom|left", "from": i, "to": j}` (inclusive cell indices). Phase 2 level root માં `"phase": 2`, `"slot"` + `"tag"` (standard §16.15).
- **N?** (D formula, non-monotone): **Yes** = toggles, periodic/counter tiles, movers, plates, beams; **No** = static tiles, monotone unlocks (open once, never close), goals, path variants whose extra taps already count in `S`.
- **Colour-blind:** colour-dependent mechanic colour + pattern + engine icon બતાવે ([Phase 1 06 §1.2](../phase_1/06_UI_UX_SCREENS.md)). Paint/mix પછી pattern + icon પણ બદલાય.

## 2. Summary Table

| ID | Themed name | Intro | Cat | Exact rule (standard) | Hammerable | N? |
|---|---|---|---|---|---|---|
| — | Onboarding (Big Yard) | L501–510 | — | Zoom/pan tutorial, 12×12 boards, no new mechanic | — | — |
| M051 | Diagonal Express | L511 | P | 8-direction heads; diagonal lanes | n/a (train) | No |
| M052 | Corner Buffer | L521 | D | Deflects diagonal lanes 90° | No | No |
| M053 | Push Cart | L531 | T | Lane hitting block pushes it 1 cell if free behind (1 Move, path stays, no heart). Blocked ⇒ bump | **Yes** | Yes |
| M054 | Frosty Rails | L541 | D | Pushed blocks slide until hitting something | Ice No · cart Yes | No |
| M055 | Cart Weighbridge | L551 | T | Push Block on plate ⇒ linked gate open while block stays | No | Yes |
| M056 | Viaduct Ramp | L561 | L | Lane entering ramp moves path to other layer | No | No |
| M057 | Alternating Signal | L571 | C | Gate open/closed alternates every N Moves (periodic) | No | Yes |
| M058 | Spinning Arrow Rail | L581 | D | One-way tile rotates 90° CW each Move | No | Yes |
| M059 | Paint Shed | L591 | P | Lane passing paint recolors the path | No | No |
| M060 | Swap Platform | L601 | T | Tap pad ⇒ 2 linked paths swap positions (same shape only) | No | Yes |
| M061 | Small Engine Shed | L611 | G | Inner exit accepting N paths, then closes | No | Yes |
| M062 | Delivery Platform Quota | L621 | G | Goal: ≥ Q paths of a color exit via marked edge | No | No |
| M063 | Magnet Post | L631 | C | Each Move pulls the nearest path in its row/col 1 cell toward it if free | No | Yes |
| M064 | Seesaw Barriers | L641 | T | 2 linked gates; exactly one open; flips whenever a lane passes the open one | No | Yes |
| M065 | Hidden Ticket | L651 | K | Key under fog / under another path; revealed when cover clears | No | No |
| M066 | Triple-Coupled Engines | L661 | P | 3-path chain (M011 ×3) | n/a (train) | No |
| M067 | Worn Sleepers | L671 | C | Cell becomes hole-blocker after lanes pass it N times | No | Yes |
| M068 | Smoke Trail Train | L681 | C | Exiting path leaves temporary blockers on its lane for 2 Moves | n/a (train) | Yes |
| M069 | Triple-Deck Viaduct | L691 | L | Ground / mid / top (extends M032) | No | No |
| M070 | Roundhouse Lever | L701 | T | Lever rotates every path's dir 90° CW | No | Yes |
| M071 | Departure Quota Gate | L711 | B | Edge opens after Q total exits | No | No |
| M072 | Colour Timetable | L721 | P | Colors must exit in shown repeating pattern | n/a (train) | No |
| M073 | Cushion Train | L731 | P | Bubble absorbs bumps *into* this path: 1st lane hitting it pops bubble (no heart loss for that bumping path, which returns); then behaves normally | n/a (train) | No |
| M074 | Iron Girder Wall | L741 | B | Not hammerable; removed only by linked lever | No | No |
| M075 | Creeping Steam | L751 | C | Fog expands 1 cell every N Moves (fixed order) | No | Yes |
| M076 | Tunnel Network | L761 | D | 3+ portals cycle A→B→C | No | No |
| M077 | Popper Crate | L771 | X | Linked path exit ⇒ clears hammerable obstacles in 3×3 | No | No |
| M078 | Island Station | L781 | B | Board edges walled; only inner exits (M020) | No | No |
| M079 | Spinning Playmat | L791 | T | Every N Moves whole board rotates 90° CW (paths' dirs rotate too) | No | Yes |
| M080 | Twin Ticket Barriers | L801 | K | 2 locks that open only if both keys exit on same Move (via M011 chain) | No | No |
| M081 | Copycat Engine | L811 | P | Takes dir of last moved path | n/a (train) | Yes |
| M082 | Conveyor Track | L821 | D | Path fully on belt shifts 1 cell along belt each Move if free | No | Yes |
| M083 | Heavy Weighbridge | L831 | T | Only Wide Path (M024) can hold it | No | Yes |
| M084 | Signal Lamp | L841 | B | Beam line acts as blocker; beam stops at first path/blocker | No | Yes |
| M085 | Light Sensor Box | L851 | T | Beam hits receiver ⇒ linked gate open while hit | No | Yes |
| M086 | Signal Mirror | L861 | D | Mirror for beams and lanes | No | No |
| M087 | Jam Spill | L871 | P | Head on glue ⇒ 1st tap unsticks, 2nd exits | No | No |
| M088 | Track Clamp | L881 | K | Mine blocks lane until linked key-path exits (defuse) | No | No |
| M089 | Crystal Prism | L891 | D | Beam splits into two 90° beams | No | No |
| M090 | Tick-Tock Gate | L901 | C | Open on odd Move count, closed on even | No | Yes |
| M091 | Rotating Yard 3×3 | L911 | T | M034 at 3×3 | No | Yes |
| M092 | Uncoupling Train | L921 | P | Each tap exits 1 segment (multi-tap, each = 1 Move) | n/a (train) | No |
| M093 | Splitting Train | L931 | P | Tap ⇒ splits at midpoint into 2 paths facing opposite; then each exits normally | n/a (train) | No |
| M094 | Paint Mixer Shed | L941 | P | Two paints mix (R+B = Purple etc.) | No | No |
| M095 | Colour Quota Gate | L951 | B | M071 per color | No | No |
| M096 | Shadow Train | L961 | P | Visible & tappable only on even Move count; never blocks when invisible | n/a (train) | Yes |
| M097 | Domino Crates | L971 | B | Clearing first domino (hammer or linked exit) clears chain in order | First domino **Yes**, rest No | No |
| M098 | Marching Clock Tower | L981 | X | M049 + M025 patrol | No | Yes |
| M099 | Master Station Gate | L991 | K | Needs all key types + laser receiver | No | No |
| — | Grand Terminus Finale | L1000 | X | Moving Guardian + ≥ 10 mixed mechanics | — | — |

Categories: **B** Static Blocker · **K** Key/Lock · **C** Counter (Move-based) · **T** Toggle/Interactive · **P** Path-variant · **D** Direction changer · **L** Layer · **G** Goal/Helper · **X** Boss.

## 3. Mechanic Cards

### M051 · Diagonal Express

| Field | Value |
|---|---|
| ID · Themed name | `M051` · **Diagonal Express** |
| Intro level | L511 (block 511–520) |
| Category | P Path-variant |
| Exact rule (standard) | 8-direction heads; diagonal lanes |
| Rule (theme) | ત્રાંસા (diagonal) track પર ઊભી express train. Engine `UL/UR/DL/DR` તરફ મુખ રાખે; exit lane ત્રાંસી લાઇનમાં table ના ખૂણા/edge સુધી. |
| Tap / bump behaviour | Tap any car ⇒ diagonal lane clear હોય તો exit (1 Move); blocked ⇒ bump. |
| Heart effect | Bump ⇒ −1 (Cowcatcher Shield absorb કરી શકે). |
| Hammerable? | n/a — train; Track Crane ઉપાડી શકે (exit). |
| Hint / solver notes | Lane tracer 8-dir vectors ([01 §3](./01_PHASE_2_SCOPE_AND_RULES.md)). Solver state unchanged (dir is static unless rotated). |
| Visual & audio | Engine body 45° rotated; diagonal rail ties; whistle pitch +2 semitones (`sfx_whistle_diag`). |
| Implementation notes | `Dir8` enum; `vector`, `rotateCw()`. Body consecutive cars king-adjacent (validator). Carriages follow polyline incl. 45° joints. |
| Edge case (game definition) | **Coupling-cross:** diagonal step blocked if both corner cells are consecutive cars of one train. No other corner-squeeze rule. M006/M014/M018 + diagonal lane ⇒ bump. M024 Wide Load never diagonal. |
| Level design — Do | Intro: 6–8 diagonal trains among orthogonal ones; at least one diagonal escape that is visually surprising (corner exit). |
| Level design — Don't | Two diagonal trains whose lanes cross a coupling of each other in a cycle (deadlock — validator catches). |
| Combos | M052 Corner Buffer, M008 Tunnel Pair (diagonal continues), M053 diagonal shove. |

```json
{
  "paths": [
    {"id": "p7", "color": "teal", "dir": "DR", "body": [[4,4],[3,3],[2,3]], "layer": 0, "mods": {}},
    {"id": "p9", "color": "pink", "dir": "UL", "body": [[8,2],[9,3]], "layer": 0, "mods": {}}
  ],
  "mechanics": [
    {"id": "o1", "type": "M051", "cells": [], "params": {"paths": ["p7", "p9"]}, "hammerable": false}
  ]
}
```
(M051 entry = marker listing diagonal trains for tutorial + D count; the path's `dir` is authoritative.)

### M052 · Corner Buffer

| Field | Value |
|---|---|
| ID · Themed name | `M052` · **Corner Buffer** |
| Intro level | L521 (block 521–530) |
| Category | D Direction changer |
| Exact rule (standard) | Deflects diagonal lanes 90° |
| Rule (theme) | ખૂણાવાળું rubber buffer block. Diagonal lane એને અથડાઈને 90° વળી જાય (billiard bounce જેવું). |
| Tap / bump behaviour | Non-interactive. Diagonal lane buffer cell માં પ્રવેશે ⇒ ત્યાંથી નવી diagonal દિશામાં ચાલુ. Orthogonal lane ⇒ bump. |
| Heart effect | Orthogonal lane bump ⇒ −1. Deflection itself no heart. |
| Hammerable? | **No** (tile). |
| Hint / solver notes | Static; lane tracer reflects. |
| Visual & audio | Red rubber corner pad with a white chevron showing bounce face; `sfx_boing_soft` on deflect. |
| Implementation notes | `params.face`: `"h"` = horizontal face ⇒ `dy` flips (DR→UR); `"v"` = vertical face ⇒ `dx` flips (DR→DL). Lane continues from the buffer cell. Rotations (M079, M091) swap `h`↔`v`. |
| Edge case (game definition) | Train bodies never rest on a Corner Buffer (validator). Beams (orthogonal) are **stopped** by a Corner Buffer. Two buffers in sequence allowed (max 4 deflections per lane; validator). |
| Level design — Do | Use to rescue a diagonal train whose straight diagonal is blocked. |
| Level design — Don't | Deflection loops (buffer → buffer back to start) — tracer visited-set stops it as bump; avoid in design. |
| Combos | M051, M053 (cart blocks a deflected lane), M076. |

```json
{"id": "o2", "type": "M052", "cells": [[9,2]], "params": {"face": "h"}, "hammerable": false}
```

### M053 · Push Cart

| Field | Value |
|---|---|
| ID · Themed name | `M053` · **Push Cart** |
| Intro level | L531 (block 531–540) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | Lane hitting block pushes it 1 cell if free behind (1 Move, path stays, no heart). Blocked ⇒ bump |
| Rule (theme) | પૈડાંવાળી લાકડાની cart (crate સાથે). Train નો lane cart સુધી પહોંચે અને cart ની પાછળ જગ્યા હોય ⇒ train cart ને 1 cell ધક્કો મારે અને પોતે ત્યાં જ રહે. |
| Tap / bump behaviour | Tap train ⇒ lane નો **પહેલો** blocking item cart હોય: behind free ⇒ push (1 Move, train stays); behind not free ⇒ bump. Cart પર સીધો tap = કંઈ નહીં (no Move). |
| Heart effect | Push: **no heart**. Bump: −1. |
| Hammerable? | **Yes** (standard §16.18). Crane lifts cart off. |
| Hint / solver notes | Non-monotone (cart position in state). Solver state includes cart cells. Hint glows the pushing train with a "push" arrow. |
| Visual & audio | Pine cart, 4 red wheels; push: train nudges 1/3 cell forward, cart rolls 1 cell (180 ms), `sfx_cart_roll`. |
| Implementation notes | Push direction = lane direction (diagonal allowed). Free-cell definition: [01 §5](./01_PHASE_2_SCOPE_AND_RULES.md). Cart blocks lanes & beams. Cart moved ⇒ step 4 recompute (plates, beams). |
| Edge case (game definition) | **Open board edge behind cart ⇒ cart is pushed off the table into the Toy Box (removed)** — otherwise the pushing train's own lane could never clear. Walled edge (M029 fence, M078, closed M031/M071/M095 segment) ⇒ not free ⇒ bump. Carts cannot enter sheds, tunnels, island exits. Train only pushes, never pulls. Group trains (M011/M066) pushing different carts: all pushes must be possible else group bump. |
| Level design — Do | Intro: 1 cart directly in front of a key train with free space behind; later carts that must be pushed **out of** someone else's lane. |
| Level design — Don't | Forget that the pusher's lane still contains the cart after a push — the design must give the pusher a later way out (more pushes to an open edge, a lateral push by another train, rotation, Crane as optional only). |
| Combos | M054, M055, M084 (cart blocks beam), M063. |

```json
{"id": "o3", "type": "M053", "cells": [[5,6]], "params": {"layer": 0}, "hammerable": true}
```

### M054 · Frosty Rails

| Field | Value |
|---|---|
| ID · Themed name | `M054` · **Frosty Rails** |
| Intro level | L541 (block 541–550) |
| Category | D Direction changer |
| Exact rule (standard) | Pushed blocks slide until hitting something |
| Rule (theme) | બરફ જામેલા rails. Push Cart ice પર આવે ⇒ ઊભું ન રહે, આગળ સરકતું જાય. |
| Tap / bump behaviour | Non-interactive floor. Trains ice પર સામાન્ય (sliding માત્ર carts). |
| Heart effect | — (push itself no heart). |
| Hammerable? | Ice tile **No**; carts on it **Yes** (M053). |
| Hint / solver notes | Push result = slide end cell; solver computes deterministically. |
| Visual & audio | Pale blue frosted rail ties with sparkle; slide `sfx_ice_slide` (duration ∝ distance, max 450 ms). |
| Implementation notes | After a push, while cart's cell is ice **and** next cell (same dir) free ⇒ advance. Stops on the first non-ice cell it enters, or on the last ice cell before a non-free cell. |
| Edge case (game definition) | A cart already resting on ice moves only when pushed (no spontaneous slide). Sliding past an **open** board edge ⇒ cart falls into the Toy Box (same rule as M053); walled edge ⇒ stops on the last cell. Slide is part of the same Move (no extra ticks). |
| Level design — Do | Ice corridors where the cart must stop exactly on a Cart Weighbridge (M055) placed at the corridor end. |
| Level design — Don't | Ice under trains as decoration only (confuses players into thinking trains slide). |
| Combos | M053, M055, M063. |

```json
{"id": "o4", "type": "M054", "cells": [[3,7],[4,7],[5,7],[6,7]], "params": {}, "hammerable": false}
```

### M055 · Cart Weighbridge

| Field | Value |
|---|---|
| ID · Themed name | `M055` · **Cart Weighbridge** |
| Intro level | L551 (block 551–560) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | Push Block on plate ⇒ linked gate open while block stays |
| Rule (theme) | Cart વજન માપવાનું plate. Push Cart plate પર હોય ત્યાં સુધી linked yard gate ખુલ્લો. |
| Tap / bump behaviour | Plate non-interactive, non-blocking. Linked gate closed ⇒ lanes bump. |
| Heart effect | Closed gate bump ⇒ −1. |
| Hammerable? | **No** (plate & gate). Hammering the cart off the plate closes the gate. |
| Hint / solver notes | Non-monotone (gate follows cart). Step 4 derived. |
| Visual & audio | Brass weighing plate with dial; needle swings when cart arrives; gate = white picket yard gate; `sfx_gate_creak`. |
| Implementation notes | `open = any cart on any plate cell`. Trains on plate **don't** count (that's M019). |
| Edge case (game definition) | Gate cell occupied by a train body can never close on it — validator forbids trains resting on M055 gate cells. Multiple plates linked to one gate ⇒ OR. |
| Level design — Do | Plate at the end of an ice corridor (M054) — elegant one-push solution. |
| Level design — Don't | Require pushing the cart off the plate later to free a lane and simultaneously needing the gate open (contradiction). |
| Combos | M053, M054, M084 (cart on plate also blocks a beam). |

```json
{"id": "o5", "type": "M055", "cells": [[7,7]], "params": {"gates": [[10,3]]}, "hammerable": false}
```

### M056 · Viaduct Ramp

| Field | Value |
|---|---|
| ID · Themed name | `M056` · **Viaduct Ramp** |
| Intro level | L561 (block 561–570) |
| Category | L Layer |
| Exact rule (standard) | Lane entering ramp moves path to other layer |
| Rule (theme) | Ground track ને viaduct deck સાથે જોડતો ઢાળ. Ramp માં પ્રવેશતો lane બીજા layer પર આગળ ચાલે. |
| Tap / bump behaviour | Non-interactive. Lane on layer `a` enters ramp along its axis ⇒ remaining lane traced on layer `b` (and vice versa). Entry perpendicular to axis ⇒ bump. |
| Heart effect | Blocked on new layer ⇒ bump −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Lane tracer switches layer set; solver unchanged otherwise. |
| Visual & audio | Wooden incline with handrails; train tilts while climbing; `sfx_ramp_clack`. |
| Implementation notes | `params.layers: [a, b]`, `params.axis: "h"|"v"`. Ramp cell exists on both layers (blocks neither). Train exits board on the new layer; its own `layer` updates only for relocation (M037 sand stop after ramp ⇒ train rests on new layer). |
| Edge case (game definition) | Ramps orthogonal only (diagonal lane ⇒ bump). A train that relocates (Sand Drift/Conveyor) after a ramp keeps the new layer and is subject to the lock rule of that layer. |
| Level design — Do | Show a lower train trapped by ground blockers that escapes over a ramp to the clear deck. |
| Level design — Don't | Ramp landing directly on top of a lower-layer train's body (looks like overlap error) on intro. |
| Combos | M032, M069, M015. |

```json
{"id": "o6", "type": "M056", "cells": [[4,9]], "params": {"layers": [0, 1], "axis": "h"}, "hammerable": false}
```

### M057 · Alternating Signal

| Field | Value |
|---|---|
| ID · Themed name | `M057` · **Alternating Signal** |
| Intro level | L571 (block 571–580) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Gate open/closed alternates every N Moves (periodic) |
| Rule (theme) | Railway signal જે દર N Moves પછી લીલું/લાલ બદલે. લાલ હોય ત્યારે gate બંધ. |
| Tap / bump behaviour | Non-interactive. Red ⇒ lane bump; green ⇒ pass. |
| Heart effect | Red bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | State = `moveCount mod (2N)`; non-monotone. Hint prefers orders that reach green without bumps. |
| Visual & audio | Semaphore-style lamp post; badge shows Moves until change; `sfx_signal_click`. |
| Implementation notes | Tick step 3 (M057 slot): if `moveCount % N == 0` ⇒ toggle. `params.n` (2–5), `params.startOpen`. |
| Edge case (game definition) | Lane check (step 1) uses the state **before** this Move's tick. Undo restores state via moveCount. |
| Level design — Do | Pair a red signal with a train that needs exactly 2 other exits first — teaches counting. |
| Level design — Don't | N = 1 (feels random). |
| Combos | M090 Tick-Tock Gate, M007, M017. |

```json
{"id": "o7", "type": "M057", "cells": [[6,0]], "params": {"n": 3, "startOpen": false}, "hammerable": false}
```

### M058 · Spinning Arrow Rail

| Field | Value |
|---|---|
| ID · Themed name | `M058` · **Spinning Arrow Rail** |
| Intro level | L581 (block 581–590) |
| Category | D Direction changer |
| Exact rule (standard) | One-way tile rotates 90° CW each Move |
| Rule (theme) | One-Way Rail (M006) જેવું, પણ arrow plate દરેક Move પછી 90° CW ફરે. |
| Tap / bump behaviour | Non-interactive. Lane passes only in current arrow direction; else bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | State = `moveCount mod 4`; non-monotone. |
| Visual & audio | Brass turntable-plate with painted arrow; rotates 120 ms after each Move; `sfx_ratchet`. |
| Implementation notes | Tick step 3 (M058 slot). `params.arrow` initial `U/R/D/L`. |
| Edge case (game definition) | Diagonal lane ⇒ always bump. Rotation applies after every Move incl. interactive taps and pushes. |
| Level design — Do | 2 trains needing the same tile in different directions — order matters. |
| Level design — Don't | More than 2 spinning arrows on one lane (unreadable). |
| Combos | M006, M057, M079. |

```json
{"id": "o8", "type": "M058", "cells": [[5,5]], "params": {"arrow": "R"}, "hammerable": false}
```

### M059 · Paint Shed

| Field | Value |
|---|---|
| ID · Themed name | `M059` · **Paint Shed** |
| Intro level | L591 (block 591–600) |
| Category | P Path-variant |
| Exact rule (standard) | Lane passing paint recolors the path |
| Rule (theme) | નાનું paint-spray shed. Train એમાંથી પસાર થાય ⇒ નવો રંગ (pattern + icon પણ બદલાય). |
| Tap / bump behaviour | Non-blocking floor. Recolour applies from the paint cell onward for the rest of that lane (later Colour Platform Gates / exits use the new colour). |
| Heart effect | — |
| Hammerable? | **No**. |
| Hint / solver notes | Train colour is solver state. |
| Visual & audio | Shed with dripping colour tin; cars get spray particles; `sfx_spray`. |
| Implementation notes | `params.color`. Overwrites colour (mixing = M094). |
| Edge case (game definition) | Recolour **committed only on completed lanes** (exit or relocate); bump ⇒ train returns with old colour. M041 Rainbow Engine painted ⇒ continues cycling from the new colour. |
| Level design — Do | Train blocked by a red Colour Platform Gate passes after a red Paint Shed earlier on its lane. |
| Level design — Don't | Paint immediately before board edge with nothing after it (meaningless) except for M062/M095 quotas. |
| Combos | M005, M030, M062, M094, M095. |

```json
{"id": "o9", "type": "M059", "cells": [[3,2]], "params": {"color": "red"}, "hammerable": false}
```

### M060 · Swap Platform

| Field | Value |
|---|---|
| ID · Themed name | `M060` · **Swap Platform** |
| Intro level | L601 (block 601–610) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | Tap pad ⇒ 2 linked paths swap positions (same shape only) |
| Rule (theme) | Station platform button: tap ⇒ બે linked trains જગ્યા બદલે. |
| Tap / bump behaviour | Pad tap = **1 Move**; each train takes the other's `body` + `dir` (colour, tickets, mods stay with the train). |
| Heart effect | — |
| Hammerable? | **No**. |
| Hint / solver notes | Non-monotone (2 states). |
| Visual & audio | Turn-plate button with two linked colour dots; trains lift, cross-fade, drop (300 ms); `sfx_swap_whoosh`. |
| Implementation notes | `params.paths: [a, b]`. Validator: equal length + identical normalized shape (translation). Interactive tap priority > train car. |
| Edge case (game definition) | Pad becomes **locked tap** if either linked train has exited, is covered by an upper layer, or is hidden. Lock states (Snowed-In K, Cold, tickets) travel with the train. |
| Level design — Do | One train has a clear lane in the other's spot — swap first, then exit both. |
| Level design — Don't | Swap that is reversible and useless (pure noise). |
| Combos | M004 (move key train to a free lane), M065, M010. |

```json
{"id": "o10", "type": "M060", "cells": [[0,11]], "params": {"paths": ["p3", "p14"]}, "hammerable": false}
```

### M061 · Small Engine Shed

| Field | Value |
|---|---|
| ID · Themed name | `M061` · **Small Engine Shed** |
| Intro level | L611 (block 611–620) |
| Category | G Goal/Helper |
| Exact rule (standard) | Inner exit accepting N paths, then closes |
| Rule (theme) | નાનું engine shed (inner exit) જેમાં માત્ર N trains સમાય; badge = બાકી જગ્યા. |
| Tap / bump behaviour | Lane reaching shed with capacity > 0 ⇒ exit into it, capacity −1. Capacity 0 ⇒ shed closed ⇒ acts as blocker (bump). |
| Heart effect | Closed shed bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Counter in state (monotone down) — counted N because it changes outcomes. |
| Visual & audio | Shed with number board; doors close at 0; `sfx_shed_doors`. |
| Implementation notes | `params.capacity` (1–4). Capacity decremented in step 1 per entering train. |
| Edge case (game definition) | Group exits (M011/M066) entering one shed: checked per train in group order — insufficient capacity ⇒ whole group bumps. Wide Load (M024) never targets a 1-cell shed (validator). |
| Level design — Do | 3 trains aiming at a shed of capacity 2 — player chooses which one goes elsewhere. |
| Level design — Don't | Capacity that equals all trains aiming at it (no decision). |
| Combos | M020, M078, M062. |

```json
{"id": "o11", "type": "M061", "cells": [[6,6]], "params": {"capacity": 2}, "hammerable": false}
```

### M062 · Delivery Platform Quota

| Field | Value |
|---|---|
| ID · Themed name | `M062` · **Delivery Platform Quota** |
| Intro level | L621 (block 621–630) |
| Category | G Goal/Helper |
| Exact rule (standard) | Goal: ≥ Q paths of a color exit via marked edge |
| Rule (theme) | Table edge પર marked delivery platform: ઓછામાં ઓછી Q trains એ colour ની ત્યાંથી નીકળવી જોઈએ (win condition). |
| Tap / bump behaviour | Non-blocking edge marker. HUD goal chip "🔵 2/3". |
| Heart effect | — |
| Hammerable? | **No**. Crane-removed trains don't count (no lane). |
| Hint / solver notes | Goal bitcount in state; solver win = all exited ∧ quotas met. |
| Visual & audio | Painted platform strip with colour + icon flags; count tick `sfx_platform_bell`. |
| Implementation notes | `params.edge`, `params.color`, `params.q`. Colour = colour **at exit time** (after Paint). |
| Edge case (game definition) | Quota can become unreachable ⇒ "Track jammed" sheet ([01 §8](./01_PHASE_2_SCOPE_AND_RULES.md)); no heart, no fail screen. Quota counts only completed exits through that segment. |
| Level design — Do | Use Paint Sheds or turntables to aim the right colour at the platform. |
| Level design — Don't | Quota = all trains of that colour with only one possible lane each (no choice). |
| Combos | M059, M013, M071. |

```json
{"id": "o12", "type": "M062", "cells": [], "params": {"edge": {"side": "right", "from": 3, "to": 6}, "color": "blue", "q": 3}, "hammerable": false}
```

### M063 · Magnet Post

| Field | Value |
|---|---|
| ID · Themed name | `M063` · **Magnet Post** |
| Intro level | L631 (block 631–640) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Each Move pulls the nearest path in its row/col 1 cell toward it if free |
| Rule (theme) | લાલ horseshoe magnet post. દરેક Move પછી પોતાની row/column ની સૌથી નજીકની train ને 1 cell પોતાની તરફ ખેંચે. |
| Tap / bump behaviour | Magnet = blocker for lanes; non-interactive. |
| Heart effect | Bump into magnet ⇒ −1. Pull: no heart. |
| Hammerable? | **No** (standard §16.18 default). |
| Hint / solver notes | Non-monotone; train positions in state. |
| Visual & audio | Red/silver magnet with field ripples; pulled train slides 1 cell sideways (150 ms); `sfx_magnet_zip`. |
| Implementation notes | Tick step 3 (M063 slot). Scan U, R, D, L from magnet; each scan stops at the first train car (candidate) or any non-free item (blocker, cart, closed gate, edge). Nearest candidate wins; tie ⇒ order U, R, D, L. Whole train translates 1 cell toward magnet if every destination cell is free (own cells count as free). |
| Edge case (game definition) | Candidate already adjacent (distance 1) ⇒ no pull. A train is pulled **at most once per Move** (magnets processed in JSON order). Same layer only. Carts are not pulled. |
| Level design — Do | Magnet that slowly drags a blocker train out of a key lane — player can wait by doing other useful Moves. |
| Level design — Don't | Magnet pulling a train into a deadlock on every Move (validator will reject, but avoid). |
| Combos | M053, M019 (pull onto plate), M082. |

```json
{"id": "o13", "type": "M063", "cells": [[11,5]], "params": {"layer": 0}, "hammerable": false}
```

### M064 · Seesaw Barriers

| Field | Value |
|---|---|
| ID · Themed name | `M064` · **Seesaw Barriers** |
| Intro level | L641 (block 641–650) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | 2 linked gates; exactly one open; flips whenever a lane passes the open one |
| Rule (theme) | બે level-crossing arms એક seesaw બીમ થી જોડાયેલા: એક ઊંચું તો બીજું નીચું. ખુલ્લા arm માંથી train પસાર થાય ⇒ seesaw ઢળે, બંને બદલાય. |
| Tap / bump behaviour | Non-interactive. Lane hits closed arm ⇒ bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Non-monotone (1 bit). |
| Visual & audio | Twin striped arms on a wooden beam; flip `sfx_seesaw_thunk`. |
| Implementation notes | `cells: [A, B]`, `params.open: 0|1` (index). Flip applied at end of step 1, only for **completed** lanes through the open arm. |
| Edge case (game definition) | Lane that passes the open arm and then reaches the closed arm in the same trace ⇒ bump (closed state used during trace) ⇒ no flip. Bump lanes never flip. Group exit passing the open arm twice ⇒ flips twice (net unchanged), evaluated in group order. |
| Level design — Do | 2 trains each needing a different arm — the order decides everything. |
| Level design — Don't | Both arms on the same lane (unwinnable for that lane). |
| Combos | M009 lever, M057, M071. |

```json
{"id": "o14", "type": "M064", "cells": [[4,3],[8,3]], "params": {"open": 0}, "hammerable": false}
```

### M065 · Hidden Ticket

| Field | Value |
|---|---|
| ID · Themed name | `M065` · **Hidden Ticket** |
| Intro level | L651 (block 651–660) |
| Category | K Key/Lock |
| Exact rule (standard) | Key under fog / under another path; revealed when cover clears |
| Rule (theme) | Golden ticket Steam Cloud (M010) નીચે અથવા કોઈ train ના car નીચે છુપાયેલી. Cover હટે ⇒ ticket દેખાય; પછી કોઈ lane એના પરથી પસાર થાય ⇒ collected ⇒ matching barrier કાયમ ખૂલે. |
| Tap / bump behaviour | Ticket cell non-blocking. Barrier cell blocks until collected. |
| Heart effect | Closed barrier bump ⇒ −1. |
| Hammerable? | Barrier **No**. Crane on the covering train ⇒ exit ⇒ ticket revealed (crane itself doesn't collect). |
| Hint / solver notes | Monotone (`revealed`, `collected`). Hint never points at a hidden ticket. |
| Visual & audio | Covered: faint glint only after Route Peek nearby; reveal: ticket pops up with shimmer; collect: `sfx_ticket_punch`. |
| Implementation notes | `cells: [ticketCell]`, `params.color`, `params.barrier: [[x,y]]`, `params.cover: "fog"|"path"`. Collect on completed lane over the revealed cell (same rule as M026 sacks). |
| Edge case (game definition) | Covered ticket cannot be collected even if a lane technically crosses its cell. Cover = fog area or a train car on that cell (any layer above counts as cover). Ticket revealed by Creeping Steam clearing also counts. |
| Level design — Do | Ticket under a train whose own exit is easy — teaches "look under". |
| Level design — Don't | Ticket whose only collecting lane is the barrier-blocked train itself. |
| Combos | M010, M075, M004. |

```json
{"id": "o15", "type": "M065", "cells": [[5,8]], "params": {"color": "yellow", "barrier": [[11,8]], "cover": "path"}, "hammerable": false}
```

### M066 · Triple-Coupled Engines

| Field | Value |
|---|---|
| ID · Themed name | `M066` · **Triple-Coupled Engines** |
| Intro level | L661 (block 661–670) |
| Category | P Path-variant |
| Exact rule (standard) | 3-path chain (M011 ×3) |
| Rule (theme) | ત્રણ engines એક જ radio-coupling chain થી જોડાયેલા. એક પર tap ⇒ ત્રણેય સાથે દોડવાનો પ્રયત્ન કરે; બધા lanes clear હોય તો જ. |
| Tap / bump behaviour | Tap any ⇒ all 3 lanes checked simultaneously; any blocked ⇒ all 3 bump. |
| Heart effect | Group bump ⇒ **−1 total** (standard §16.7). |
| Hammerable? | n/a — trains; Crane removes 1 (exit) ⇒ remaining 2 stay linked as an M011 pair. |
| Hint / solver notes | Group members block each other's lanes. |
| Visual & audio | Shared brass chain icon on all 3 cabs; `sfx_triple_toot` chord. |
| Implementation notes | `params.paths: [a, b, c]`. Lanes traced against board with all 3 still present. |
| Edge case (game definition) | Members on different layers allowed only if none covers another. Pushes inside a group exit: every member's action must succeed (exit or push), else group bump. |
| Level design — Do | Free the 3 lanes in a staged order. |
| Level design — Don't | Two members facing each other on one line. |
| Combos | M011, M080, M048. |

```json
{"id": "o16", "type": "M066", "cells": [], "params": {"paths": ["p2", "p9", "p17"]}, "hammerable": false}
```

### M067 · Worn Sleepers

| Field | Value |
|---|---|
| ID · Themed name | `M067` · **Worn Sleepers** |
| Intro level | L671 (block 671–680) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Cell becomes hole-blocker after lanes pass it N times |
| Rule (theme) | ઘસાયેલા લાકડાના sleepers; badge N. N વખત trains પસાર થાય ⇒ track તૂટીને ખાડો (blocker) બને. |
| Tap / bump behaviour | Non-blocking until collapse; then blocks lanes (bump). |
| Heart effect | Bump into hole ⇒ −1. |
| Hammerable? | **No** (sleepers or hole). |
| Hint / solver notes | Counter in state. |
| Visual & audio | Cracked ties with N notch marks; collapse: planks drop into a gap, `sfx_plank_crack`. |
| Implementation notes | Passes counted in step 1 (completed lanes only, incl. Push Cart slides? **No** — only train lanes). Collapse applied in step 3 (M067 slot) when `passes ≥ n`. |
| Edge case (game definition) | Collapse deferred while a train body or cart occupies the cell. Group exit crossing it twice counts 2. Beams pass worn sleepers and holes (holes are floor gaps). |
| Level design — Do | N = 1 bridge-like path that only one of two trains can use. |
| Level design — Don't | Worn cell on the only lane of 2+ trains with N < count (unsolvable — validator). |
| Combos | M042, M068, M071. |

```json
{"id": "o17", "type": "M067", "cells": [[7,4]], "params": {"n": 2}, "hammerable": false}
```

### M068 · Smoke Trail Train

| Field | Value |
|---|---|
| ID · Themed name | `M068` · **Smoke Trail Train** |
| Intro level | L681 (block 681–690) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Exiting path leaves temporary blockers on its lane for 2 Moves |
| Rule (theme) | કાળો coal-smoke છોડતું જૂનું steam engine. એ નીકળે પછી એના track પર ધુમાડો 2 Moves સુધી રહે અને lanes રોકે. |
| Tap / bump behaviour | Smoke cells block lanes (bump). |
| Heart effect | Bump into smoke ⇒ −1. |
| Hammerable? | n/a — train (crane-removed train leaves **no** smoke, §16.8). Smoke itself not targetable. |
| Hint / solver notes | Smoke TTL in state (non-monotone). |
| Visual & audio | Puffy grey smoke tiles fading 2 → 1 → gone; `sfx_chuff_heavy`. |
| Implementation notes | On completed exit: lane cells (from cell ahead of engine to last in-board cell; not original body cells) become smoke `ttl = 2`, flagged `new`. Step 3 (M068 slot): skip `new` (clear flag), else `ttl −= 1`, 0 ⇒ remove. |
| Edge case (game definition) | ⇒ Smoke blocks exactly the **next 2 Moves'** actions. Beams pass through smoke. Carts cannot be pushed into smoke (not free). Relocation (Sand Drift) leaves no smoke (not an exit). |
| Level design — Do | Smoke across a crossing lane forces the player to do 2 other Moves first. |
| Level design — Don't | Smoke train as the only remaining train's blocker with no other Moves available (soft-lock — validator). |
| Combos | M057, M090, M067. |

```json
{"id": "o18", "type": "M068", "cells": [], "params": {"path": "p6"}, "hammerable": false}
```

### M069 · Triple-Deck Viaduct

| Field | Value |
|---|---|
| ID · Themed name | `M069` · **Triple-Deck Viaduct** |
| Intro level | L691 (block 691–700) |
| Category | L Layer |
| Exact rule (standard) | Ground / mid / top (extends M032) |
| Rule (theme) | ત્રણ માળનો viaduct: ground (0), mid (1), top (2). ઉપરની train નીચેની ને ઢાંકે ⇒ નીચેની locked. |
| Tap / bump behaviour | Tap overlap cell ⇒ highest layer train. Lower train with any covered cell ⇒ locked tap. |
| Heart effect | Same-layer bumps only ⇒ −1. |
| Hammerable? | **No** (board property). Crane targets only uncovered trains. |
| Hint / solver notes | Lock recomputed step 4; lanes per layer. |
| Visual & audio | Stacked trestle decks with drop shadows (pre-baked per layer); covered trains darker + lock badge. |
| Implementation notes | Level `layers: 3`; paths `layer: 0|1|2`; obstacles `params.layer`. Render order 0 → 1 → 2 ([06 §6](./06_FRONTEND_AND_QA_PHASE_2.md)). |
| Edge case (game definition) | Lock if covered by **any** higher layer (not only the next). Ramps (M056) connect any 2 layers listed. Beams stay on emitter layer. |
| Level design — Do | Peel top → mid → ground in waves. |
| Level design — Don't | A top train whose lane is blocked only by trains it covers on mid (cross-layer confusion; lanes don't interact anyway, but readability suffers). |
| Combos | M032, M056, M065 (cover = train). |

```json
{"schema": 3, "level": 691, "phase": 2, "slot": "intro", "tag": "normal", "grid": [12, 12], "layers": 3,
 "paths": [{"id": "p1", "color": "green", "dir": "R", "body": [[4,4],[3,4],[2,4]], "layer": 2, "mods": {}},
           {"id": "p2", "color": "red", "dir": "U", "body": [[3,5],[3,4],[3,3]], "layer": 1, "mods": {}}],
 "mechanics": [{"id": "o19", "type": "M069", "cells": [], "params": {}, "hammerable": false}]}
```

### M070 · Roundhouse Lever

| Field | Value |
|---|---|
| ID · Themed name | `M070` · **Roundhouse Lever** |
| Intro level | L701 (block 701–710) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | Lever rotates every path's dir 90° CW |
| Rule (theme) | Roundhouse ની મોટી lever: ખેંચો ⇒ table પરની **દરેક** train નું engine 90° CW ફરે (carriages જગ્યાએ). |
| Tap / bump behaviour | Lever tap = **1 Move**. Trains whose new `dir` points into own `body[1]` ⇒ locked tap until rotated again. |
| Heart effect | — |
| Hammerable? | **No**. |
| Hint / solver notes | Global state `rot mod 4` (non-monotone). |
| Visual & audio | Big red lever with roundhouse emblem; all engines swivel 180 ms; `sfx_roundhouse_clunk`. |
| Implementation notes | Rotates `dir` of all trains on all layers (incl. diagonal, §3.1 of 01). Bodies unchanged. |
| Edge case (game definition) | M022 Shunting and M023 Push-Pull trains are **excluded** from levels containing M070 (their exit direction is body-derived) — validator. Hidden/covered trains rotate too. |
| Level design — Do | Board where half the trains are free now and the other half after 1–2 pulls. |
| Level design — Don't | More than 2 Roundhouse Levers (4-state product explodes readability). |
| Combos | M013, M045, M081. |

```json
{"id": "o20", "type": "M070", "cells": [[0,0]], "params": {}, "hammerable": false}
```

### M071 · Departure Quota Gate

| Field | Value |
|---|---|
| ID · Themed name | `M071` · **Departure Quota Gate** |
| Intro level | L711 (block 711–720) |
| Category | B Static Blocker |
| Exact rule (standard) | Edge opens after Q total exits |
| Rule (theme) | Table edge પર બંધ station gate; departure board પર "Q trains departed" થાય ⇒ કાયમ ખૂલે. |
| Tap / bump behaviour | Non-interactive. Closed ⇒ lanes hitting that edge segment bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No** (edge). |
| Hint / solver notes | Monotone (opens once). |
| Visual & audio | Flip-board counter "3/5"; open: gates swing, `sfx_station_bell`. |
| Implementation notes | `params.edge`, `params.q`. Counts **all** exits (edge, sheds, crane removals = exits per standard). Open evaluated step 4. |
| Edge case (game definition) | Uncoupling Train (M092) counts 1 exit when its last segment leaves; Splitting Train (M093) halves count 1 each after split. |
| Level design — Do | Gate guarding the only exit of 2–3 trains; others must leave first. |
| Level design — Don't | Q > number of trains that can exit elsewhere. |
| Combos | M029, M095, M062. |

```json
{"id": "o21", "type": "M071", "cells": [], "params": {"edge": {"side": "bottom", "from": 0, "to": 4}, "q": 6}, "hammerable": false}
```

### M072 · Colour Timetable

| Field | Value |
|---|---|
| ID · Themed name | `M072` · **Colour Timetable** |
| Intro level | L721 (block 721–730) |
| Category | P Path-variant |
| Exact rule (standard) | Colors must exit in shown repeating pattern |
| Rule (theme) | Station board પર રંગોનું repeating timetable (દા.ત. 🔴🔵🔵). Trains એ જ ક્રમમાં ઉપડે. |
| Tap / bump behaviour | Train whose colour ≠ next pattern colour ⇒ **locked tap** (no Move). |
| Heart effect | Correct-colour train blocked ⇒ bump −1. |
| Hammerable? | n/a — trains; Crane valid targets = only trains of the next pattern colour. |
| Hint / solver notes | Pattern index in state. Similar to M028. |
| Visual & audio | Departure board strip with highlighted next slot; wrong colour: `sfx_locked_knock`. |
| Implementation notes | `params.pattern: ["red","blue","blue"]`; index advances per exit (`i % len`). Applies to all trains in level (`params.scope: "all"`). |
| Edge case (game definition) | Lock check uses colour **at tap time** (Paint along the lane doesn't change which slot it fills). Group exits must match consecutive pattern slots in group order, else group locked. Dead end (needed colour gone) ⇒ "Track jammed". |
| Level design — Do | Pattern length 2–3 with 2 colours. |
| Level design — Don't | Combine with M041 Rainbow Engine on intro. |
| Combos | M028, M059 (do not combine on same level — validator), M011. |

```json
{"id": "o22", "type": "M072", "cells": [], "params": {"pattern": ["red", "blue", "blue"], "scope": "all"}, "hammerable": false}
```

### M073 · Cushion Train

| Field | Value |
|---|---|
| ID · Themed name | `M073` · **Cushion Train** |
| Intro level | L731 (block 731–740) |
| Category | P Path-variant |
| Exact rule (standard) | Bubble absorbs bumps *into* this path: 1st lane hitting it pops bubble (no heart loss for that bumping path, which returns); then behaves normally |
| Rule (theme) | ફૂલેલા rubber cushion વાળી train. બીજી train એને અથડાય ⇒ cushion "pop", અથડાનાર train પાછી roll થાય, **heart નહીં જાય**. પછી સામાન્ય train. |
| Tap / bump behaviour | Bumping train: returns (1 Move), no heart; cushion removed. Cushion train's own bumps = normal. |
| Heart effect | First hit into it: **0 hearts**. After pop: normal −1. |
| Hammerable? | n/a — train (Crane removes it). |
| Hint / solver notes | `cushion` bit; solver may use the free pop as a timing Move. |
| Visual & audio | Inflated striped cushion on the buffers; pop `sfx_cushion_pop` + confetti puff. |
| Implementation notes | `params.path`. Shield charge **not** consumed (no heart-loss event). Stars unaffected. |
| Edge case (game definition) | Group bump where some members hit cushions and others hit normal blockers ⇒ −1 total, cushions hit still pop. Group bump with **all** blocked members hitting cushions ⇒ 0 hearts. A Push Cart can't be pushed into a train, so carts never pop cushions. |
| Level design — Do | Use the free pop to advance an Alternating Signal or Spinning Arrow by 1 Move. |
| Level design — Don't | Teach "bumping is good" broadly — keep 1 cushion per level on intro. |
| Combos | M057, M058, M090. |

```json
{"id": "o23", "type": "M073", "cells": [], "params": {"path": "p11"}, "hammerable": false}
```

### M074 · Iron Girder Wall

| Field | Value |
|---|---|
| ID · Themed name | `M074` · **Iron Girder Wall** |
| Intro level | L741 (block 741–750) |
| Category | B Static Blocker |
| Exact rule (standard) | Not hammerable; removed only by linked lever |
| Rule (theme) | Riveted iron girder (1–4 cells). Track Crane પણ ઉપાડી ન શકે; linked bridge-lever ખેંચો ⇒ girder કાયમ માટે નીચે ઊતરે. |
| Tap / bump behaviour | Lever tap = **1 Move** ⇒ wall removed; lever then inert (locked tap). Wall non-interactive. |
| Heart effect | Bump into girder ⇒ −1. |
| Hammerable? | **No** (standard). |
| Hint / solver notes | Monotone (removed once); lever Move counted in `S`. |
| Visual & audio | Grey riveted girder; lever with girder emblem; removal `sfx_girder_lower`. |
| Implementation notes | `cells` = wall cells (collinear 1–4), `params.lever: [x,y]`. Lever tap priority > train car. |
| Edge case (game definition) | One lever may link several girders (`params.lever` shared). Lever on a covered layer cell still tappable (interactive top priority) — validator keeps levers uncovered. |
| Level design — Do | Girder that also blocks a beam — removing it lights a sensor. |
| Level design — Don't | Lever pull with no downside (always do it first) on every level — pair with Roundhouse/timing. |
| Combos | M084, M085, M009. |

```json
{"id": "o24", "type": "M074", "cells": [[6,3],[6,4],[6,5]], "params": {"lever": [1, 10]}, "hammerable": false}
```

### M075 · Creeping Steam

| Field | Value |
|---|---|
| ID · Themed name | `M075` · **Creeping Steam** |
| Intro level | L751 (block 751–760) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Fog expands 1 cell every N Moves (fixed order) |
| Rule (theme) | Steam Cloud (M010) જે ધીમે ધીમે ફેલાય: દર N Moves પછી 1 cell. ઢંકાયેલી trains hidden & locked. |
| Tap / bump behaviour | Same as M010 (hidden & locked under steam; area clears when a touching train exits). |
| Heart effect | — |
| Hammerable? | **No**. |
| Hint / solver notes | Steam cell set in state (non-monotone: grows + clears). |
| Visual & audio | Rolling steam with leading-edge curl showing next cell; badge N; `sfx_steam_hiss`. |
| Implementation notes | Step 3 (M075 slot): if `moveCount % n == 0` ⇒ take steam cells in creation order; first cell having an in-board neighbour (U, R, D, L) that is not steam and not a blocking obstacle/cart ⇒ that neighbour becomes steam. |
| Edge case (game definition) | Steam may spread onto trains (hides + locks them). Cleared area stops spreading; if no steam cells remain, nothing spreads. Clearing uses Phase 1 M010 "touch" rule (body cell in area or orthogonally adjacent at exit). |
| Level design — Do | Race: release the trains near the steam first. |
| Level design — Don't | N = 1 on P2-B large boards (overwhelming). Never on L1000. |
| Combos | M010, M065, M028. |

```json
{"id": "o25", "type": "M075", "cells": [[2,2],[2,3]], "params": {"n": 3}, "hammerable": false}
```

### M076 · Tunnel Network

| Field | Value |
|---|---|
| ID · Themed name | `M076` · **Tunnel Network** |
| Intro level | L761 (block 761–770) |
| Category | D Direction changer |
| Exact rule (standard) | 3+ portals cycle A→B→C |
| Rule (theme) | 3+ tunnel mouths એક ring માં જોડાયેલા: A માં ગયેલી train B માંથી, B વાળી C માંથી, C વાળી A માંથી એ જ દિશામાં નીકળે. |
| Tap / bump behaviour | Lane entering portal k continues from portal (k+1) mod n, same dir. Exit portal occupied ⇒ blocked (bump). |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Static routing. Tracer visited-set prevents infinite loops (repeat ⇒ bump). |
| Visual & audio | Stone tunnel portals with matching letter plaques A/B/C + colour; `sfx_tunnel_echo`. |
| Implementation notes | `cells` in ring order, `params.ring: "cycle"`. Diagonal lanes keep direction. |
| Edge case (game definition) | Beams stop at portals. Push Carts can't enter portals. Wide Load through network: bump (validator excludes). |
| Level design — Do | Show that A→B is not reversible (B→C). |
| Level design — Don't | 4+ portals on intro. |
| Combos | M008, M044, M052. |

```json
{"id": "o26", "type": "M076", "cells": [[2,9],[10,1],[6,12]], "params": {"ring": "cycle"}, "hammerable": false}
```

### M077 · Popper Crate

| Field | Value |
|---|---|
| ID · Themed name | `M077` · **Popper Crate** |
| Intro level | L771 (block 771–780) |
| Category | X Boss |
| Exact rule (standard) | Linked path exit ⇒ clears hammerable obstacles in 3×3 |
| Rule (theme) | Party-popper confetti crate. Linked train ઉપડે ⇒ "POP!" ⇒ crate ની આસપાસ 3×3 માં બધા hammerable obstacles (Buffer Stops, Crate Rows, Rock Piles, Push Carts …) ઊડી જાય, crate પણ. |
| Tap / bump behaviour | Crate = blocker; non-interactive. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No** (default). |
| Hint / solver notes | Monotone trigger. |
| Visual & audio | Striped crate with a pull-string to the linked train; pop: confetti burst (pre-baked sprite sheet), `sfx_popper`. |
| Implementation notes | `params.linked: "pId"`. Trigger step 4 after linked train's exit (crane removal counts). Trains in the 3×3 unaffected. |
| Edge case (game definition) | Only obstacles with `hammerable: true` are cleared; the popper itself always clears. If the 3×3 contains the **first domino** (M097), the whole domino chain clears. Popper in the 3×3 of another popper is not chain-triggered (it's not hammerable). |
| Level design — Do | Cluster of 3 Buffer Stops boxing in a train. |
| Level design — Don't | Linked train trapped by the very obstacles the popper clears. |
| Combos | M001, M002, M016, M053, M097. |

```json
{"id": "o27", "type": "M077", "cells": [[7,7]], "params": {"linked": "p4"}, "hammerable": false}
```

### M078 · Island Station

| Field | Value |
|---|---|
| ID · Themed name | `M078` · **Island Station** |
| Intro level | L781 (block 781–790) |
| Category | B Static Blocker |
| Exact rule (standard) | Board edges walled; only inner exits (M020) |
| Rule (theme) | આખી table ફરતે fence; trains માત્ર table ની વચ્ચેના Engine Sheds (M020/M061) માં જ જઈ શકે. |
| Tap / bump behaviour | Lane reaching any board edge ⇒ bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Static. Every train needs a lane ending in a shed. |
| Visual & audio | Painted picket fence on all four edges; island platform art in the middle. |
| Implementation notes | Level-level flag entry; implies M029 on all edge segments. ≥ 1 M020 or M061 required (validator). |
| Edge case (game definition) | Edge-based mechanics (M030, M031, M062, M071, M095) not allowed with M078. Coin Rush boards never use it. |
| Level design — Do | 2–4 sheds with directional "approach" lanes, Curve Rails/Signal Mirrors to aim. |
| Level design — Don't | Only one shed with no capacity planning. |
| Combos | M020, M061, M014, M086. |

```json
{"id": "o28", "type": "M078", "cells": [], "params": {}, "hammerable": false}
```

### M079 · Spinning Playmat

| Field | Value |
|---|---|
| ID · Themed name | `M079` · **Spinning Playmat** |
| Intro level | L791 (block 791–800) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | Every N Moves whole board rotates 90° CW (paths' dirs rotate too) |
| Rule (theme) | આખું playmat lazy-susan પર છે: દર N Moves પછી 90° CW ફરે. |
| Tap / bump behaviour | Automatic (not tapped). |
| Heart effect | — |
| Hammerable? | **No**. |
| Hint / solver notes | Global rotation state (non-monotone). |
| Visual & audio | Board spins 400 ms after the Move animation; brass gear sound `sfx_playmat_spin`; Reduce motion ⇒ 150 ms cross-fade. |
| Implementation notes | Step 3 (M079 slot) if `moveCount % n == 0`: every cell `(x, y) → (W−1−y, x)`; train dirs, arrows, emitter dirs rotate CW; mirrors `/`↔`\`; Corner Buffer `h`↔`v`; edge segments rotate side (top → right …). Requires square grid. Camera re-fits. |
| Edge case (game definition) | Rotation happens even if it puts a train's lane into its own body (that train is then locked until next rotation). Undo restores via snapshot. |
| Level design — Do | N = 3–4; the player plans which trains to send before the spin. |
| Level design — Don't | Combine with M070 on the same board. |
| Combos | M057, M058, M014. |

```json
{"id": "o29", "type": "M079", "cells": [], "params": {"n": 4}, "hammerable": false}
```

### M080 · Twin Ticket Barriers

| Field | Value |
|---|---|
| ID · Themed name | `M080` · **Twin Ticket Barriers** |
| Intro level | L801 (block 801–810) |
| Category | K Key/Lock |
| Exact rule (standard) | 2 locks that open only if both keys exit on same Move (via M011 chain) |
| Rule (theme) | બે barriers જે માત્ર ત્યારે ખૂલે જ્યારે બંને ticket trains **એક જ Move** માં ઉપડે — એટલે ticket trains Coupled Engines (M011) છે. |
| Tap / bump behaviour | Barriers block lanes until opened (permanent). |
| Heart effect | Closed barrier bump ⇒ −1. |
| Hammerable? | Barriers **No**. |
| Hint / solver notes | Monotone. |
| Visual & audio | Twin barrier arms with linked ticket slots; open together `sfx_twin_bell`. |
| Implementation notes | `cells: [lockA, lockB]`, `params.keyPaths: [a, b]` — must be an M011 pair (validator). |
| Edge case (game definition) | **Track Crane on either key train removes both coupled key trains together** (counts as both keys exiting on the same Move) ⇒ barriers open; uses 1 Crane charge. Prevents a booster-caused soft-lock. |
| Level design — Do | Coupled key trains whose lanes are cleared in stages. |
| Level design — Don't | Key trains that also need to pass through the twin barriers. |
| Combos | M011, M066, M043. |

```json
{"id": "o30", "type": "M080", "cells": [[3,11],[9,11]], "params": {"keyPaths": ["p5", "p6"]}, "hammerable": false}
```

### M081 · Copycat Engine

| Field | Value |
|---|---|
| ID · Themed name | `M081` · **Copycat Engine** |
| Intro level | L811 (block 811–820) |
| Category | P Path-variant |
| Exact rule (standard) | Takes dir of last moved path |
| Rule (theme) | નકલખોર engine (mirror-eyes): છેલ્લી જે train ચાલી એની દિશા અપનાવી લે. |
| Tap / bump behaviour | Normal tap ⇒ exits along its **current** (copied) dir. Copied dir into own `body[1]` ⇒ locked tap. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | n/a — train. |
| Hint / solver notes | `dir` in state (non-monotone). |
| Visual & audio | Engine with swivelling "eyes" chimney; swivels 120 ms after each qualifying Move; `sfx_copycat_chirp`. |
| Implementation notes | `params.path`. Update at end of step 1. Initial dir = JSON `dir`. |
| Edge case (game definition) | "Moved" = a **completed** lane (exit or relocate) of another train; bumps, pushes (train stays), and interactive taps don't change it. Group exit ⇒ last member in group order. Diagonal dirs copied too. Copycat's own exit doesn't affect other copycats until it completes (then it is the last mover). |
| Level design — Do | Send a train in direction X to "teach" the copycat its escape. |
| Level design — Don't | 3+ copycats (state explosion). |
| Combos | M070, M051, M013. |

```json
{"id": "o31", "type": "M081", "cells": [], "params": {"path": "p8"}, "hammerable": false}
```

### M082 · Conveyor Track

| Field | Value |
|---|---|
| ID · Themed name | `M082` · **Conveyor Track** |
| Intro level | L821 (block 821–830) |
| Category | D Direction changer |
| Exact rule (standard) | Path fully on belt shifts 1 cell along belt each Move if free |
| Rule (theme) | Rubber conveyor belt track: train **આખી** belt પર હોય ⇒ દરેક Move પછી belt દિશામાં 1 cell સરકે (જગ્યા હોય તો). |
| Tap / bump behaviour | Non-interactive floor (non-blocking). Trains on it tap normally. |
| Heart effect | — |
| Hammerable? | **No**. |
| Hint / solver notes | Train positions in state (non-monotone). |
| Visual & audio | Animated belt chevrons (static when Reduce motion); `sfx_belt_hum` short. |
| Implementation notes | `cells` (straight run), `params.dir`. Step 3 (M082 slot): trains whose **all** cars are on belt cells (same layer) translate 1 cell in `dir` if every destination cell is free (own cells free; destination may be off the belt but must be in-board). Process front-most train first. |
| Edge case (game definition) | Translation off board never happens (edge = not free). Partly-off-belt trains stop shifting. Push Carts are not moved by belts. Jam Spill (M087) re-sticks if the head lands on jam. |
| Level design — Do | Belt that delivers a train onto a Weighbridge plate after 2 Moves. |
| Level design — Don't | Long belts carrying several trains (hard to read). |
| Combos | M019, M063, M087. |

```json
{"id": "o32", "type": "M082", "cells": [[2,6],[3,6],[4,6],[5,6],[6,6]], "params": {"dir": "R"}, "hammerable": false}
```

### M083 · Heavy Weighbridge

| Field | Value |
|---|---|
| ID · Themed name | `M083` · **Heavy Weighbridge** |
| Intro level | L831 (block 831–840) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | Only Wide Path (M024) can hold it |
| Rule (theme) | ભારે માલ માટેનું weighbridge: માત્ર Wide Load Freight (M024) નું વજન gate ખોલે. |
| Tap / bump behaviour | Plate non-blocking; linked gate open while a Wide Load body covers the plate. |
| Heart effect | Closed gate bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Non-monotone (follows Wide Load presence). |
| Visual & audio | Large steel plate with "HEAVY" stencil; dial swings only for freight. |
| Implementation notes | `params.gates`. Normal trains and Push Carts on it ⇒ no effect. |
| Edge case (game definition) | Wide Load exiting closes the gate in step 4 of that Move. Validator: Wide Load must initially cover, or be relocatable onto, the plate. |
| Level design — Do | Freight holding the gate while 2 trains pass, freight last. |
| Level design — Don't | Freight that must leave before the gated trains (unsolvable). |
| Combos | M024, M037, M082. |

```json
{"id": "o33", "type": "M083", "cells": [[4,9],[5,9]], "params": {"gates": [[12,2]]}, "hammerable": false}
```

### M084 · Signal Lamp

| Field | Value |
|---|---|
| ID · Themed name | `M084` · **Signal Lamp** |
| Intro level | L841 (block 841–850) |
| Category | B Static Blocker |
| Exact rule (standard) | Beam line acts as blocker; beam stops at first path/blocker |
| Rule (theme) | તેજ signal lamp એક દિશામાં light beam ફેંકે. Beam ના cells માં કોઈ train નો lane પ્રવેશે ⇒ bump. Beam પહેલી train કે blocker પર અટકે. |
| Tap / bump behaviour | Lamp cell = blocker. Lane entering any beam cell ⇒ bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Beam recomputed step 4 (non-monotone: grows when blockers leave). |
| Visual & audio | Brass lamp with lens; beam = warm amber line; `sfx_lamp_hum` on change. |
| Implementation notes | `params.dir` (orthogonal), `params.layer`. Beam rules: [01 §6](./01_PHASE_2_SCOPE_AND_RULES.md). Lane check uses previous step-4 beam. |
| Edge case (game definition) | When the train that stops a beam exits, its own lane is not affected by the extending beam in that same Move. Beam colour is cosmetic (never interacts with colour gates). Beam cells may cross other beams (no interaction). |
| Level design — Do | Beam that is blocked by a train you must keep until last. |
| Level design — Don't | Beam crossing the only lane of a train with no way to block it. |
| Combos | M085, M086, M089, M053. |

```json
{"id": "o34", "type": "M084", "cells": [[0,5]], "params": {"dir": "R", "layer": 0}, "hammerable": false}
```

### M085 · Light Sensor Box

| Field | Value |
|---|---|
| ID · Themed name | `M085` · **Light Sensor Box** |
| Intro level | L851 (block 851–860) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | Beam hits receiver ⇒ linked gate open while hit |
| Rule (theme) | Signal box ની light sensor: beam પડે ત્યાં સુધી linked gate ખુલ્લો; beam અટકે ⇒ gate બંધ. |
| Tap / bump behaviour | Sensor = blocker for lanes. Gate per state. |
| Heart effect | Closed gate bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Non-monotone (derived from beams step 4). |
| Visual & audio | Green-glass sensor box; lit: bulb glows + gate lifts, `sfx_sensor_ding`. |
| Implementation notes | `params.gates`. Hit from any side. Evaluated after beam trace in step 4. |
| Edge case (game definition) | Gate cells never hold a resting train (validator). Multiple sensors on one gate ⇒ OR. |
| Level design — Do | Player must *remove* a train from the beam path to open the gate — inverse thinking. |
| Level design — Don't | Sensor lit at start and never changeable (decoration). |
| Combos | M084, M086, M074. |

```json
{"id": "o35", "type": "M085", "cells": [[11,5]], "params": {"gates": [[6,0]]}, "hammerable": false}
```

### M086 · Signal Mirror

| Field | Value |
|---|---|
| ID · Themed name | `M086` · **Signal Mirror** |
| Intro level | L861 (block 861–870) |
| Category | D Direction changer |
| Exact rule (standard) | Mirror for beams and lanes |
| Rule (theme) | ત્રાંસો polished mirror: light beam અને train lane બંનેને 90° વાળે. |
| Tap / bump behaviour | Non-interactive. Lane/beam turns per orientation. |
| Heart effect | Diagonal lane ⇒ bump −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Static tile. |
| Visual & audio | Silver mirror on a wooden stand; beam reflection glint. |
| Implementation notes | `params.orient`: `/` maps R→U, U→R, L→D, D→L; `\` maps R→D, D→R, L→U, U→L. Lane continues from mirror cell. |
| Edge case (game definition) | Diagonal lanes ⇒ bump. Train bodies never rest on a mirror. Mirror rotation by M079/M091 swaps `/`↔`\`. A mirror (or prism) cell currently carrying a beam counts as a beam cell ⇒ a lane entering it bumps. |
| Level design — Do | One mirror that serves both a lane and a beam — order puzzle. |
| Level design — Don't | Beam loop setups on intro. |
| Combos | M084, M085, M014. |

```json
{"id": "o36", "type": "M086", "cells": [[8,5]], "params": {"orient": "/"}, "hammerable": false}
```

### M087 · Jam Spill

| Field | Value |
|---|---|
| ID · Themed name | `M087` · **Jam Spill** |
| Intro level | L871 (block 871–880) |
| Category | P Path-variant |
| Exact rule (standard) | Head on glue ⇒ 1st tap unsticks, 2nd exits |
| Rule (theme) | Strawberry jam ઢોળાયેલો: engine jam પર હોય ⇒ પહેલો tap wheels છોડાવે (1 Move), બીજો tap ચલાવે. |
| Tap / bump behaviour | 1st tap = unstick (1 Move, no lane check). 2nd tap = normal exit/bump. |
| Heart effect | Unstick: no heart. |
| Hammerable? | **No** (jam tile). Crane may remove the stuck train (exit). |
| Hint / solver notes | `stuck` bit per train. Hint glows the unstick step. |
| Visual & audio | Red glossy jam puddle; wheels drip; unstick `sfx_jam_squelch`. |
| Implementation notes | `cells: [jamCell]`. Stuck at level start if `body[0]` on jam. Other lanes pass jam freely. |
| Edge case (game definition) | Train **re-sticks** if its head newly arrives on jam via relocation (M037, M082, M063, M060 swap). Unstuck trains passing over jam on their exit lane are unaffected. |
| Level design — Do | Use unstick as a timing Move for M057/M090. |
| Level design — Don't | Several stuck trains with nothing else to do (just tedium). |
| Combos | M012, M090, M082. |

```json
{"id": "o37", "type": "M087", "cells": [[3,3]], "params": {}, "hammerable": false}
```

### M088 · Track Clamp

| Field | Value |
|---|---|
| ID · Themed name | `M088` · **Track Clamp** |
| Intro level | L881 (block 881–890) |
| Category | K Key/Lock |
| Exact rule (standard) | Mine blocks lane until linked key-path exits (defuse) |
| Rule (theme) | Rails પર લાગેલો yellow wheel-clamp; linked inspector train ઉપડે ⇒ clamp ખૂલે (defuse). |
| Tap / bump behaviour | Clamp cell blocks lanes until defused; then permanently passable. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No** (lock). Crane on the key train ⇒ exit ⇒ defused. |
| Hint / solver notes | Monotone. |
| Visual & audio | Yellow clamp with a numbered tag matching the key train's tag; defuse `sfx_clamp_release`. |
| Implementation notes | `params.keyPath`. Linked by id (not colour — differs from M004). |
| Edge case (game definition) | Clamp never "explodes" — no damage ever (no forced damage rule). Diagonal lanes blocked the same. |
| Level design — Do | Several clamps with different key trains — routing puzzle. |
| Level design — Don't | Key train's own lane through its clamp. |
| Combos | M004, M043, M099. |

```json
{"id": "o38", "type": "M088", "cells": [[7,10]], "params": {"keyPath": "p12"}, "hammerable": false}
```

### M089 · Crystal Prism

| Field | Value |
|---|---|
| ID · Themed name | `M089` · **Crystal Prism** |
| Intro level | L891 (block 891–900) |
| Category | D Direction changer |
| Exact rule (standard) | Beam splits into two 90° beams |
| Rule (theme) | કાચનો prism: આવતો beam બે ભાગમાં વહેંચાય — ડાબે અને જમણે (90°). |
| Tap / bump behaviour | Prism = blocker for lanes. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Static; beam tracer branches. |
| Visual & audio | Faceted crystal with rainbow sparkle when lit. |
| Implementation notes | Incoming dir `d` ⇒ two beams from prism cell in `rotateCw(d)` and `rotateCcw(d)`; no straight output. |
| Edge case (game definition) | Beams hitting a prism from several sides each split independently. Visited-set per `(cell, dir)` stops loops. |
| Level design — Do | One lamp lighting two sensors at once. |
| Level design — Don't | Prism cascades > 2 on one board. |
| Combos | M084, M085, M086. |

```json
{"id": "o39", "type": "M089", "cells": [[6,5]], "params": {}, "hammerable": false}
```

### M090 · Tick-Tock Gate

| Field | Value |
|---|---|
| ID · Themed name | `M090` · **Tick-Tock Gate** |
| Intro level | L901 (block 901–910) |
| Category | C Counter (Move-based) |
| Exact rule (standard) | Open on odd Move count, closed on even |
| Rule (theme) | Pendulum clock gate: tick (odd) પર ખુલ્લો, tock (even) પર બંધ. |
| Tap / bump behaviour | Closed ⇒ bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Parity in state. |
| Visual & audio | Small pendulum above the gate; ticks per Move. |
| Implementation notes | Lane check uses `moveCount` **before** increment (standard §16.17): open iff `moveCount % 2 == 1`. ⇒ First Move (moveCount 0) gate closed. |
| Edge case (game definition) | Locked taps don't change parity (not Moves). Undo reverts parity. |
| Level design — Do | Use with Jam/Cushion as "spare Move" sources. |
| Level design — Don't | Two Tick-Tock Gates on one lane (same parity — redundant). |
| Combos | M021, M096, M057. |

```json
{"id": "o40", "type": "M090", "cells": [[9,9]], "params": {}, "hammerable": false}
```

### M091 · Rotating Yard 3×3

| Field | Value |
|---|---|
| ID · Themed name | `M091` · **Rotating Yard 3×3** |
| Intro level | L911 (block 911–920) |
| Category | T Toggle/Interactive |
| Exact rule (standard) | M034 at 3×3 |
| Rule (theme) | 3×3 મોટું rotating yard: tap ⇒ અંદરનું બધું (સંપૂર્ણ અંદર trains + single-cell obstacles) 90° CW ફરે. |
| Tap / bump behaviour | Yard tap (hub at centre or free yard cell) = 1 Move. Any train partly inside ⇒ jammed ⇒ locked tap. |
| Heart effect | — |
| Hammerable? | **No**. |
| Hint / solver notes | 4 states (non-monotone). |
| Visual & audio | Large wooden turntable disc with 9 rail stubs; rotation 220 ms, `sfx_yard_grind`. |
| Implementation notes | Rotation about centre cell; trains' dirs rotate CW. Tap priority per standard §16.19 (interactive > train car). |
| Edge case (game definition) | After rotation, a train whose head faces its own body ⇒ locked tap (§16.19). Push Carts inside rotate with the yard. Diagonal trains inside rotate (UR→DR …). |
| Level design — Do | 2 trains inside that each need a different orientation. |
| Level design — Don't | Yard covering the whole centre of a 12×12 on intro. |
| Combos | M034, M053, M086. |

```json
{"id": "o41", "type": "M091", "cells": [[5,5],[6,5],[7,5],[5,6],[6,6],[7,6],[5,7],[6,7],[7,7]], "params": {}, "hammerable": false}
```

### M092 · Uncoupling Train

| Field | Value |
|---|---|
| ID · Themed name | `M092` · **Uncoupling Train** |
| Intro level | L921 (block 921–930) |
| Category | P Path-variant |
| Exact rule (standard) | Each tap exits 1 segment (multi-tap, each = 1 Move) |
| Rule (theme) | Train ના coupling hooks ઢીલા: દરેક tap પર આગળનો segment છૂટો પડીને ઉપડે; બાકીના પાછળ રહે. |
| Tap / bump behaviour | Tap ⇒ front segment's lane clear ⇒ that segment exits (1 Move); else whole train bumps. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | n/a — train; Crane removes all remaining segments (one exit). |
| Hint / solver notes | Segment index in state; each extra tap counted in `S`. |
| Visual & audio | Visible gaps between segments; uncouple `sfx_hook_clink`. |
| Implementation notes | `params.segments` (sizes, sum = length, default all 1). After a segment leaves, new head = first car of next segment, new `dir` = direction from new head to the vacated cell ahead of it. |
| Edge case (game definition) | Train-level effects (key/ticket, Guardian HP, Snowed-In neighbour, quota exits) trigger only when the **last** segment exits. Paint applies to the departing segment only. Segments always king-adjacent ⇒ new dir always one of 8. |
| Level design — Do | Front segment clears a crossing that the rear needs (after it bends). |
| Level design — Don't | 5 single-car segments on a straight line (just 5 taps). |
| Combos | M028, M071, M049. |

```json
{"id": "o42", "type": "M092", "cells": [], "params": {"path": "p3", "segments": [2, 1, 1]}, "hammerable": false}
```

### M093 · Splitting Train

| Field | Value |
|---|---|
| ID · Themed name | `M093` · **Splitting Train** |
| Intro level | L931 (block 931–940) |
| Category | P Path-variant |
| Exact rule (standard) | Tap ⇒ splits at midpoint into 2 paths facing opposite; then each exits normally |
| Rule (theme) | Push-pull જેવી double-ended train જે વચ્ચેથી છૂટી પડે: આગળનો ભાગ આગળ જુએ, પાછળનો ભાગ ઊંધી દિશામાં. |
| Tap / bump behaviour | 1st tap = split (1 Move, no lane check, never bumps). Then 2 normal trains. |
| Heart effect | Split: none. Later bumps −1. |
| Hammerable? | n/a — train; before split Crane removes whole train, after split one half. |
| Hint / solver notes | `split` bit; extra Move in `S`. |
| Visual & audio | Central coupling with a red lever; split: halves spring 4 dp apart, `sfx_split_clack`. |
| Implementation notes | Length L (2–5): front = first `ceil(L/2)` cars, keeps `dir`; rear = remaining cars, head = old tail, `dir` = direction from second-last car to tail (outward). New ids `<id>a` (front), `<id>b` (rear). |
| Edge case (game definition) | Rear of length 1 (L = 2, 3) has `dir` from the old second-last car to it. Linked effects (ticket, Guardian link, M011 link) belong to the train and trigger when **both** halves have exited. Validator: no split may produce a half facing its own other half. |
| Level design — Do | Train wedged between two blockers both ways — split lets both halves escape opposite ways. |
| Level design — Don't | Split train with both directions blocked forever. |
| Combos | M023, M049, M071. |

```json
{"id": "o43", "type": "M093", "cells": [], "params": {"path": "p10"}, "hammerable": false}
```

### M094 · Paint Mixer Shed

| Field | Value |
|---|---|
| ID · Themed name | `M094` · **Paint Mixer Shed** |
| Intro level | L941 (block 941–950) |
| Category | P Path-variant |
| Exact rule (standard) | Two paints mix (R+B = Purple etc.) |
| Rule (theme) | Mixer shed: train ના હાલના રંગમાં નવો paint ભળે — red + blue = purple, red + yellow = orange, blue + yellow = green. |
| Tap / bump behaviour | Non-blocking floor. |
| Heart effect | — |
| Hammerable? | **No**. |
| Hint / solver notes | Colour in state. |
| Visual & audio | Shed with two swirling tins; mixed colour swirl particles. |
| Implementation notes | `params.color` (red/blue/yellow). New colour = `MIX[current][paint]` if defined, else `paint` (overwrite like M059). Pattern + icon switch to the new colour's ([Phase 1 06 §1.2](../phase_1/06_UI_UX_SCREENS.md)). |
| Edge case (game definition) | Mix table only for primaries red/blue/yellow; any other current colour (green, purple, orange, teal, pink) ⇒ overwrite. Mixing same colour ⇒ unchanged. Committed only on completed lanes. |
| Level design — Do | Purple Colour Platform Gate reachable only after red train passes a blue mixer. |
| Level design — Don't | More than 2 mixes on one lane. |
| Combos | M059, M005, M095. |

```json
{"id": "o44", "type": "M094", "cells": [[4,6]], "params": {"color": "blue"}, "hammerable": false}
```

### M095 · Colour Quota Gate

| Field | Value |
|---|---|
| ID · Themed name | `M095` · **Colour Quota Gate** |
| Intro level | L951 (block 951–960) |
| Category | B Static Blocker |
| Exact rule (standard) | M071 per color |
| Rule (theme) | Departure Quota Gate (M071) જેવો, પણ માત્ર એક colour ની Q trains ઉપડે ત્યારે ખૂલે. |
| Tap / bump behaviour | Closed edge segment ⇒ bump. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Monotone. |
| Visual & audio | Station gate with coloured flip-board "🟢 1/3". |
| Implementation notes | `params.edge`, `params.color`, `params.q`. Colour = exit-time colour (after paint/mix). Crane removals count (exit). |
| Edge case (game definition) | Crane-removed trains count with their current colour. Dead end ⇒ "Track jammed". |
| Level design — Do | Combine with Paint Sheds to manufacture the needed colour. |
| Level design — Don't | Q equal to all trains of that colour when they also need the gated edge. |
| Combos | M071, M059, M094. |

```json
{"id": "o45", "type": "M095", "cells": [], "params": {"edge": {"side": "top", "from": 8, "to": 12}, "color": "green", "q": 3}, "hammerable": false}
```

### M096 · Shadow Train

| Field | Value |
|---|---|
| ID · Themed name | `M096` · **Shadow Train** |
| Intro level | L961 (block 961–970) |
| Category | P Path-variant |
| Exact rule (standard) | Visible & tappable only on even Move count; never blocks when invisible |
| Rule (theme) | ચાંદની રાતની shadow train: even Move count પર દેખાય અને tap થાય; odd પર સંપૂર્ણ અદૃશ્ય અને બીજી trains એની આરપાર જાય. |
| Tap / bump behaviour | Even: normal train. Odd: invisible, tap on its cells = tap on empty cell (ignored, no wobble), never blocks lanes/beams. |
| Heart effect | Visible bump ⇒ −1. |
| Hammerable? | n/a — train; Crane can target only while visible. |
| Hint / solver notes | Parity before increment (§16.17). Differs from M021 (ghost still drawn). |
| Visual & audio | Visible: indigo silhouette with soft edge; invisible: only a faint 10% outline when Route Peek is held. |
| Implementation notes | Visible iff `moveCount % 2 == 0` (pre-increment). Step 3 (M096 slot) updates render state only. |
| Edge case (game definition) | Invisible shadow train doesn't cover lower layers (no lock), doesn't stop beams, doesn't press plates. Revive/Undo keep parity rules. |
| Level design — Do | Shadow train blocking a key lane — wait one Move, then send the key train through. |
| Level design — Don't | Shadow trains on L1000 (readability). |
| Combos | M021, M090, M084. |

```json
{"id": "o46", "type": "M096", "cells": [], "params": {"path": "p15"}, "hammerable": false}
```

### M097 · Domino Crates

| Field | Value |
|---|---|
| ID · Themed name | `M097` · **Domino Crates** |
| Intro level | L971 (block 971–980) |
| Category | B Static Blocker |
| Exact rule (standard) | Clearing first domino (hammer or linked exit) clears chain in order |
| Rule (theme) | ઊભા પાતળા crates ની હાર. પહેલો crate પડે (Track Crane અથવા linked train ઉપડે) ⇒ બાકીના ક્રમમાં ગબડી જાય. |
| Tap / bump behaviour | Each domino blocks lanes until cleared. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **First domino: Yes** (rule-implied); other dominos **No**. |
| Hint / solver notes | Monotone. |
| Visual & audio | Tall painted crates; topple cascade 80 ms per crate; `sfx_domino_cascade`. |
| Implementation notes | `cells` in chain order (2–6, need not be straight), `params.linked` (train id, optional). Clear on linked exit in step 4, or instantly on Crane. |
| Edge case (game definition) | Whole chain clears within the same Move (animation staggered only). Popper Crate (M077) 3×3 containing the first domino triggers the chain. |
| Level design — Do | Chain winding across 3 lanes — one exit frees all. |
| Level design — Don't | Linked train blocked by its own chain. |
| Combos | M077, M049, M001. |

```json
{"id": "o47", "type": "M097", "cells": [[2,4],[3,4],[4,5],[5,6]], "params": {"linked": "p2"}, "hammerable": true}
```
(`hammerable: true` applies to `cells[0]` only — engine enforces.)

### M098 · Marching Clock Tower

| Field | Value |
|---|---|
| ID · Themed name | `M098` · **Marching Clock Tower** |
| Intro level | L981 (block 981–990) |
| Category | X Boss |
| Exact rule (standard) | M049 + M025 patrol |
| Rule (theme) | Clock Tower Guardian (M049) પૈડાં પર: દરેક Move પછી fixed loop પર 1 step ચાલે. HP = linked trains; દરેક linked exit ⇒ −1 HP; 0 ⇒ ગાયબ. |
| Tap / bump behaviour | Non-interactive blocker (tap ⇒ highlight linked trains, no Move). |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No** (Guardian). |
| Hint / solver notes | Position + HP in state (non-monotone movement). |
| Visual & audio | Clock tower on a wooden wagon base; marching `sfx_tower_step`; chime per HP. |
| Implementation notes | `cells` = footprint at start, `params.loop` = anchor positions, `params.linked`. Footprint 2×2 or 3×3. |
| Edge case (game definition) | Movement ticks in the **M025 slot** of step 3 (standard lists M025, not M098). Next footprint overlapping any train, cart, blocker or another mover ⇒ wait that Move (§16.14). HP update step 4. |
| Level design — Do | Linked trains whose lanes open as the tower walks away. |
| Level design — Don't | Loop that permanently parks the tower on a required lane. |
| Combos | M049, M025, M084 (tower blocks beam). |

```json
{"id": "o48", "type": "M098", "cells": [[5,5],[6,5],[5,6],[6,6]], "params": {"loop": [[5,5],[6,5],[7,5],[7,6],[7,7],[6,7],[5,7],[4,7],[4,6],[4,5]], "linked": ["p1","p4","p9","p13"]}, "hammerable": false}
```

### M099 · Master Station Gate

| Field | Value |
|---|---|
| ID · Themed name | `M099` · **Master Station Gate** |
| Intro level | L991 (block 991–1000) |
| Category | K Key/Lock |
| Exact rule (standard) | Needs all key types + laser receiver |
| Rule (theme) | Grand station નો master gate: બધા colour ના ticket trains ઉપડી જાય **અને** gate નું built-in light sensor beam થી પ્રકાશિત હોય ⇒ કાયમ માટે ખૂલે. |
| Tap / bump behaviour | Gate blocks until opened. |
| Heart effect | Bump ⇒ −1. |
| Hammerable? | **No**. |
| Hint / solver notes | Monotone once opened. |
| Visual & audio | Ornate iron gate with ticket slots (one per colour) + green sensor lens; open fanfare `sfx_master_gate`. |
| Implementation notes | `cells` = gate cells, `params.keyPaths` (one train per key colour), `params.sensor` = sensor cell (behaves as M085 receiver, blocker for lanes). |
| Edge case (game definition) | Opens **permanently** at the first step 4 where all key trains have exited **and** the sensor is lit (later beam loss doesn't close it). Built-in sensor ⇒ intro needs only M084 as the earlier mechanic. Key trains removed by Crane count. |
| Level design — Do | Light the sensor last after collecting tickets. |
| Level design — Don't | Key trains that stand in the beam they need. |
| Combos | M084, M086, M004. |

```json
{"id": "o49", "type": "M099", "cells": [[13,6],[13,7]], "params": {"keyPaths": ["p2","p7","p19"], "sensor": [12,4]}, "hammerable": false}
```

### L1000 · Grand Terminus Finale

| Field | Value |
|---|---|
| ID · Themed name | `—` (`slot`/`tag` `finale`) · **Grand Terminus Finale** |
| Intro level | L1000 |
| Category | X Boss |
| Exact rule (standard) | Moving Guardian + ≥ 10 mixed mechanics |
| Rule (theme) | M098 Marching Clock Tower + 13 જુદા Phase-2 mechanics (14 instances), 3-deck 14×14 board. નવો rule નથી — માત્ર combination. Layout: [02 §6](./02_LEVEL_PROGRESSION_0501_1000.md) |
| Tap / bump behaviour | દરેક mechanic પોતાના card મુજબ |
| Heart effect | Standard 3 hearts, standard revive |
| Hammerable? | Tower No; Push Cart Yes; બાકી card મુજબ |
| Hint / solver notes | Hand-tuned, solver-verified (0 hearts, 0 boosters), D 86.5 (target 84 ±3), 46 Moves |
| Visual & audio | Station-at-night (lamp-lit) board skin, brass band sting at tower vanish, confetti + Grand Central Chest |
| Implementation notes | Same engine; no special-case code. `slot: "finale"` + `tag: "finale"` ⇒ 50 coins + Grand Central Chest flow (§16.15) |
| Level design — Do | 3 acts (top deck ⇒ light & cart puzzle ⇒ tower) |
| Level design — Don't | M040, M075, M096 on finale |
| Combos | M051, M052, M053, M055, M057, M065, M069, M074, M076, M084, M086, M098, M099 |

```json
{"schema": 3, "level": 1000, "phase": 2, "seed": "0x3E81A9C07D52F114", "slot": "finale", "tag": "finale",
 "grid": [14, 14], "layers": 3, "hearts": 3,
 "mechanics": [
  {"id": "g1", "type": "M098", "cells": [[6,6],[7,6],[6,7],[7,7]], "params": {"loop": [[6,6],[7,6],[8,6],[8,7],[8,8],[7,8],[6,8],[5,8],[5,7],[5,6]], "linked": ["p3","p8","p12","p17","p21","p25","p30","p36"]}, "hammerable": false},
  {"id": "o1", "type": "M084", "cells": [[0,2]], "params": {"dir": "R", "layer": 0}, "hammerable": false},
  {"id": "o2", "type": "M086", "cells": [[10,2]], "params": {"orient": "\\"}, "hammerable": false},
  {"id": "o3", "type": "M099", "cells": [[13,9],[13,10]], "params": {"keyPaths": ["p5","p14"], "sensor": [10,11]}, "hammerable": false}
 ],
 "goals": {"gems": 0}, "par_moves": 46, "difficulty": 86.5}
```
(Excerpt — remaining 10 mechanic entries and 40 paths in the shipped pack.)

## 4. Full Level JSON Example (schema v3, L531 intro of M053 — teaching excerpt)

```json
{
  "schema": 3, "level": 531, "phase": 2, "seed": "0x0213F0A4C55B7E19",
  "slot": "intro", "tag": "normal", "grid": [11, 11], "layers": 1, "hearts": 3,
  "paths": [
    {"id": "p1", "color": "red", "dir": "R", "body": [[2,3],[1,3]], "layer": 0, "mods": {}},
    {"id": "p2", "color": "blue", "dir": "D", "body": [[6,1],[6,0]], "layer": 0, "mods": {}}
  ],
  "mechanics": [
    {"id": "o1", "type": "M053", "cells": [[9,3]], "params": {"layer": 0}, "hammerable": true}
  ],
  "goals": {"gems": 0},
  "par_moves": 4, "difficulty": 8.2,
  "solution": ["p2", "p1", "p1", "p1"]
}
```
Walkthrough: `p2` lane D (column 6) clear ⇒ exits (Move 1). `p1` lane R hits cart at (9,3); behind (10,3) free ⇒ cart → (10,3), p1 stays (Move 2, no heart). `p1` again: behind the cart is the open right edge ⇒ cart rolls off into the Toy Box (Move 3). `p1` again: row 3 clear ⇒ exits (Move 4). D = 0.6·2 + 1.5·0 + 2.0·1 + 3.0·1 + 1.0·(4−2) = **8.2**. (Abbreviated teaching snippet; real L531 follows P2-A: 24–34 trains, D 44–60.)

## 5. Edge Cases Defined by This Game (standard silent — binding here)

| # | Topic | Definition |
|---|---|---|
| 1 | Diagonal coupling-cross | Diagonal step blocked iff both corner cells are consecutive cars of one train (M051) |
| 2 | Orthogonal-only tiles | M006, M014, M018, M056, M086 + diagonal lane ⇒ bump; M024 never diagonal |
| 3 | Corner Buffer faces | `h` flips dy, `v` flips dx; orthogonal lane ⇒ bump; beams stopped (M052) |
| 4 | Push edge | **Open** board edge behind cart ⇒ cart pushed off into the Toy Box (removed); walled/closed edge ⇒ bump; carts never enter sheds/tunnels (M053, M054) |
| 5 | Ice | Resting carts don't slide spontaneously; slide is same Move; slides off open edges (M054) |
| 6 | Ramp axis | Ramp entered only along its axis; relocation after ramp keeps new layer (M056) |
| 7 | Completed lanes only | Paint, mix, seesaw flip, ticket collect, sleeper wear, smoke, quotas, copycat update ignore bump lanes |
| 8 | Swap lock | Pad locked if a linked train exited/covered/hidden; lock states travel with train (M060) |
| 9 | Shed capacity & groups | Checked per train in group order; insufficient ⇒ group bump (M061) |
| 10 | Track jammed | Unreachable win ⇒ sheet with Undo/Restart, no heart, no fail screen (M062, M072, M095) |
| 11 | Magnet scan | Order U,R,D,L; scan stops at non-free item; adjacent ⇒ no pull; ≤ 1 pull per train per Move; carts not pulled (M063) |
| 12 | Seesaw trace | Closed state used during trace; group double-pass flips twice (M064) |
| 13 | Hidden Ticket | Floor ticket; collected by completed lane after reveal; any higher-layer car counts as cover (M065) |
| 14 | Triple chain + Crane | Crane on one ⇒ other two remain an M011 pair (M066) |
| 15 | Sleeper collapse | Deferred while occupied; beams pass holes (M067) |
| 16 | Smoke TTL | Created flagged `new`, not decremented same Move ⇒ blocks next 2 Moves; beams pass (M068) |
| 17 | Roundhouse exclusions | M022/M023 excluded from M070 levels |
| 18 | Quota counting | M071 counts all exits incl. sheds & Crane; M092 counts once; M093 halves count separately |
| 19 | Colour Timetable | Tap-time colour; Crane only on next-colour trains; groups consume consecutive slots (M072) |
| 20 | Cushion & groups | Group bump 0 hearts only if all blocked members hit cushions (M073) |
| 21 | Girder lever | One lever may drop several girders; lever inert after (M074) |
| 22 | Steam spread | Oldest-first, U,R,D,L, may cover trains, not blockers/carts (M075) |
| 23 | Popper | Clears only `hammerable: true` items + itself; triggers domino chain via first domino (M077) |
| 24 | Island Station | No edge-based mechanics with M078 |
| 25 | Playmat rotation | `(x,y)→(W−1−y,x)`, mirrors/buffers/edges rotate; square grids only (M079) |
| 26 | Twin barriers + Crane | Crane on one key train removes both coupled key trains (same Move) (M080) |
| 27 | Copycat "moved" | Completed lane of another train; group ⇒ last member (M081) |
| 28 | Conveyor | All cars on belt, front-first, no off-board, carts not moved (M082) |
| 29 | Beam rules | Orthogonal, stops at trains/blockers/carts/closed gates/portals; passes floor tiles; turns only at M086, splits only at M089; lit mirror/prism cell blocks lanes; lane uses previous step-4 beam |
| 30 | Jam re-stick | Head newly arriving via relocation/swap re-sticks (M087) |
| 31 | Uncoupling effects | Train-level effects only on last segment; new dir toward vacated cell (M092) |
| 32 | Split geometry | Front = ceil(L/2) keeps dir; rear head = old tail facing outward; links trigger when both halves exited (M093) |
| 33 | Mix table | Only red/blue/yellow mix; others overwrite (M094) |
| 34 | Shadow invisibility | Invisible ⇒ no lock, no beam stop, no plate press; Crane only while visible (M096) |
| 35 | Domino timing | Whole chain clears in same Move; only first domino hammerable (M097) |
| 36 | Marching tower tick | Ticks in M025 slot of step 3 (M098) |
| 37 | Master gate | Built-in sensor; permanent once keys done ∧ sensor lit simultaneously (M099) |
| 38 | Hint auto-pan | Camera centres Hint target if off-screen; no other auto-camera |

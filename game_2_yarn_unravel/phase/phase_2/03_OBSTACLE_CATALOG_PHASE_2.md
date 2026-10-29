# 03 — Obstacle Catalog: Phase 2 (M051–M099 + Finale)
> Purpose: Phase 2 ના 49 mechanics ના yarn-themed cards — દરેક card માં standard §10 ના બધા ફરજિયાત fields (rule, tap/bump, heart, hammer, hint/solver, visual/audio, JSON schema v3, implementation, level-design usage) + standard એ ખુલ્લા રાખેલા edge cases ની engine definitions.

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) (§10 Phase 2, §12 Level JSON, §16) · [./README.md](./README.md) · [./01_PHASE_2_SCOPE_AND_RULES.md](./01_PHASE_2_SCOPE_AND_RULES.md) · [./02_LEVEL_PROGRESSION_0501_1000.md](./02_LEVEL_PROGRESSION_0501_1000.md) · [../phase_1/03_OBSTACLE_CATALOG_PHASE_1.md](../phase_1/03_OBSTACLE_CATALOG_PHASE_1.md) · [./06_FRONTEND_AND_QA_PHASE_2.md](./06_FRONTEND_AND_QA_PHASE_2.md)

---

## 1. Conventions (બધા cards માટે)

- **Rule = standard §10 exact rule** (English, unchanged). **Definition** row = standard એ ખુલ્લો રાખેલો edge case; અહીં engine-binding રીતે નક્કી કર્યો છે (rule ને contradict કરતું નથી). બધી definitions નો સાર [§4](#4-edge-case-definitions-summary) માં.
- Phase 1 conventions યથાવત ([../phase_1/03 §1](../phase_1/03_OBSTACLE_CATALOG_PHASE_1.md)): Thread = path, Needle = head; locked tap = wobble + "tick", no Heart, no Move; **snag (bump) = −1 Heart** (Thimble Shield હોય તો charge −1), Move +1, **board state બદલાતી નથી**.
- **Golden Scissors (Hammer):** 1 visible thread (exit ગણાય, exit-triggered effects લાગે, lane traverse નહીં) અથવા `hammerable: true` obstacle. Covered / hidden / invisible threads target ન થાય (standard §16.8).
- Move resolution order (Phase 2): [01 §7](./01_PHASE_2_SCOPE_AND_RULES.md). Lanes vs beams: [01 §6](./01_PHASE_2_SCOPE_AND_RULES.md). Push "free cell": [01 §5](./01_PHASE_2_SCOPE_AND_RULES.md).
- **JSON (schema v3):** obstacle = `mechanics[]` entry `{"id","type":"M0xx","cells","params","hammerable"}` (optional `"layer"`, default 0). Thread-variants (P category, thread પર લાગતા C/K) = `mechanics[]` entry with `params.paths` — `paths[].mods` `{}` રહે. Coordinates `[x, y]`, `body[0]` = needle. Phase 2 `dir` values: `U, D, L, R, UL, UR, DL, DR`.
- **Non-monotone (N in D formula):** card ના "Hint / solver" row માં "N" લખેલું હોય તે mechanic.
- Unit test: દરેક ID માટે `packages/puzzle_core/test/mechanics/m0xx_test.dart` — (a) happy path, (b) snag/locked, (c) Golden Scissors interaction, (d) solver finds 0-heart solution on intro level.

## 2. Summary Table

| ID | Themed name | Generic | Intro | Cat | Hammerable |
|---|---|---|---|---|---|
| M051 | Bias-Cut Thread | Diagonal Paths | 511 | P | Thread: yes |
| M052 | Felt Corner Bumper | Corner Bumper | 521 | D | No |
| M053 | Bobbin Crate | Push Block | 531 | T | Yes |
| M054 | Satin Glide Patch | Ice Floor | 541 | D | No |
| M055 | Crate Dock Plate | Block Plate | 551 | T | No (plate & gate) |
| M056 | Pleat Ramp | Ramp | 561 | L | No |
| M057 | Loom Shuttle Gate | Traffic Light | 571 | C | No |
| M058 | Spinning Stitch Arrow | Rotating Arrow | 581 | D | No |
| M059 | Dye Pot | Paint Cell | 591 | P | No |
| M060 | Swap Hoop | Swap Pad | 601 | T | No (threads: yes) |
| M061 | Drawstring Pouch | Capacity Hole | 611 | G | No |
| M062 | Sorting Hem | Edge Quota | 621 | G | No |
| M063 | Magnet Pin Dish | Magnet Blocker | 631 | C | No |
| M064 | Seesaw Latches | Seesaw Gates | 641 | T | No |
| M065 | Hidden Charm | Hidden Key | 651 | K | No (charm) |
| M066 | Ribbon-Tied Trio | Chained Triplet | 661 | P | Thread: yes (one) |
| M067 | Worn Fabric Patch | Collapsing Floor | 671 | C | No |
| M068 | Lint Trail | Trail Blocker | 681 | C | No (lint) · thread: yes |
| M069 | Triple Fabric Layers | Three Layers | 691 | L | n/a (threads: yes if uncovered) |
| M070 | Great Spool Lever | Global Rotator | 701 | T | No |
| M071 | Drawstring Hem | Quota Edge | 711 | B | No |
| M072 | Pattern Card Sequence | Color Sequence | 721 | P | Thread: only if next in pattern |
| M073 | Cushioned Thread | Bubble Path | 731 | P | Thread: yes |
| M074 | Brass Bar Wall | Armored Wall | 741 | B | **No** |
| M075 | Creeping Fluff | Creeping Fog | 751 | C | No |
| M076 | Pompom Tunnel Network | Portal Network | 761 | D | No |
| M077 | Confetti Popper | Bomb Blocker | 771 | X | Yes (no blast) |
| M078 | Closed Hoop Frame | Center-Only Exit | 781 | B | No |
| M079 | Turning Quilt Frame | Board Rotator | 791 | T | No |
| M080 | Twin Clasps | Twin Locks | 801 | K | No (key threads: not targetable) |
| M081 | Copycat Thread | Mimic Path | 811 | P | Thread: yes |
| M082 | Feed Dog Belt | Conveyor | 821 | D | No |
| M083 | Heavy Treadle Plate | Heavy Plate | 831 | T | No |
| M084 | Sewing Lamp Emitter | Laser Emitter | 841 | B | No |
| M085 | Sun-Catcher Receiver | Laser Receiver | 851 | T | No |
| M086 | Vanity Mirror | Beam Mirror | 861 | D | No |
| M087 | Hook-and-Loop Pad | Glue Pad | 871 | P | No (pad) · thread: yes |
| M088 | Thistle Burr | Lane Mine | 881 | K | No |
| M089 | Crystal Bead Prism | Prism | 891 | D | No |
| M090 | Odd-Stitch Gate | Parity Gate | 901 | C | No |
| M091 | Grand Quilt Block Rotor | Rotor 3×3 | 911 | T | No |
| M092 | Chain-Stitch Thread | Segmented Path | 921 | P | Thread: yes (whole) |
| M093 | Split-Ply Thread | Splitter Path | 931 | P | Thread: yes |
| M094 | Dye Mixing Pot | Color Mixer | 941 | P | No |
| M095 | Color Drawstring Hem | Color Quota Edge | 951 | B | No |
| M096 | Shadow-Work Thread | Shadow Path | 961 | P | Thread: only when visible |
| M097 | Button Domino Row | Domino Chain | 971 | B | First domino only |
| M098 | Wandering Pincushion Guardian | Moving Guardian | 981 | X | **No** |
| M099 | Master Jewel Clasp | Master Lock | 991 | K | **No** |
| — | The Heirloom Tapestry | Phase 2 Finale | 1000 | X | — |

---

## 3. Mechanic Cards

### M051 — Bias-Cut Thread (Diagonal Paths)
| Field | Value |
|---|---|
| Intro / Category | L511 · **P** |
| Rule | 8-direction heads; diagonal lanes |
| Definition | `dir` ∈ `UL, UR, DL, DR` (+ orthogonal). Body cells 8-connected. Lane = diagonal steps until off-board (corner exit allowed). **Squeeze rule:** diagonal step blocked only if both side cells are consecutive body cells of one thread (a crossing diagonal link). **No-crossing:** two threads' diagonal links never cross in one 2×2 (validator). Orthogonal-only devices (M006, M014, M018, M058, M086) snag diagonal lanes |
| Tap / bump | Tap any body cell ⇒ needle pulls diagonally; blocked ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | Thread: yes |
| Hint / solver | Lane resolver with 8 unit vectors; static (not N) |
| Visual & audio | Bias-cut fabric strip texture (45° weave), needle drawn rotated 45°. Unravel "fwip" pitched +2 semitones |
| Implementation | `Dir8` enum with `(dx, dy)`; `LaneResolver.step()` checks squeeze via `linkCrosses(a, b)` precomputed set of diagonal links |
| Level design | **Do:** intro L511 — 3 diagonal threads that escape through gaps orthogonal threads cannot. **Don't:** diagonal needles pointing into corners blocked by Hem Wall only (locked forever). **Combos:** M052, M053, M014 (orthogonal contrast) |
```json
{"id": "o51", "type": "M051", "cells": [], "params": {"paths": ["p4"]}, "hammerable": false}
```
Thread entry: `{"id": "p4", "color": "teal", "dir": "UR", "body": [[5,6],[4,7],[3,8]], "layer": 0, "mods": {}}`.

### M052 — Felt Corner Bumper (Corner Bumper)
| Field | Value |
|---|---|
| Intro / Category | L521 · **D** |
| Rule | Deflects diagonal lanes 90° |
| Definition | `params.face`: `"H"` reflects dy (UR↔DR, UL↔DL), `"V"` reflects dx (UR↔UL, DR↔DL) — દરેક 90° turn છે. Lane enters bumper cell and continues from it in the new dir. **Orthogonal lane** entering bumper ⇒ bumper acts as Single Blocker (snag) |
| Tap / bump | Not tappable (no-op). Deflected route blocked later ⇒ snag at that blocker |
| Heart effect | none (snag only if new route blocked) |
| Hammerable | No |
| Hint / solver | Deterministic lane; loop guard (visited `(cell, dir)`) |
| Visual & audio | Felt-covered corner cushion with stitched edge; thread bounces "boff" |
| Implementation | `Deflector8` table in lane resolver; track polyline adds the corner point |
| Level design | **Do:** bank-shot exits around Ruler Strips. **Don't:** 4 bumpers forming a closed diamond (infinite loop; validator). **Combos:** M051, M086 (lanes) |
```json
{"id": "o52", "type": "M052", "cells": [[7, 3]], "params": {"face": "H"}, "hammerable": false}
```

### M053 — Bobbin Crate (Push Block)
| Field | Value |
|---|---|
| Intro / Category | L531 · **T** |
| Rule | Lane hitting block pushes it 1 cell if free behind (1 Move, path stays, no heart). Blocked ⇒ bump |
| Definition | "Hitting" = crate is the first non-passable thing on the lane. "Free behind" per [01 §5](./01_PHASE_2_SCOPE_AND_RULES.md): in-board, no thread body on crate layer, no obstacle except floor-type (M019, M054, M055, M067 pre-collapse, M082, M083). Pushed across an **open** board edge ⇒ crate falls off and is **removed** (counts nothing); **walled / closed edge** behind ⇒ snag (standard §17.29). Diagonal lane ⇒ diagonal push. Lane cells before the crate apply lane effects (Dye Pot, Sequins) because the outcome is not a snag. Crates block beams and lanes; belts do not move crates |
| Tap / bump | Tap thread ⇒ push (crate slides 1 cell, thread jiggles forward & back). Crate itself not tappable |
| Heart effect | Push: none. Blocked push ⇒ snag −1 |
| Hammerable | **Yes** — crate removed |
| Hint / solver | **N** — crate positions in state; Hint may glow the pushing thread |
| Visual & audio | Small wooden crate full of bobbins; push "scrape-clack" |
| Implementation | `MoveResult.push(crateId, from, to)` |
| Level design | **Do:** intro — 1 crate blocking an exit, push once to clear the lane. **Don't:** crates pushable into corners where they lock the only exit forever (generator avoids dead states on solution path; CI only requires one 0-heart solution). **Combos:** M054, M055, M063 |
```json
{"id": "o53", "type": "M053", "cells": [[4, 5]], "params": {}, "hammerable": true}
```

### M054 — Satin Glide Patch (Ice Floor)
| Field | Value |
|---|---|
| Intro / Category | L541 · **D** |
| Rule | Pushed blocks slide until hitting something |
| Definition | After the 1-cell push, if the crate's new cell is a glide patch it keeps moving cell-by-cell in the push direction while the next cell is free; it **stops on the first non-glide cell it enters** or before a non-free cell / walled edge; sliding across an **open** board edge ⇒ crate falls off and is removed (§17.29). Threads are **not** affected by glide patches (floor-type; thread bodies may lie on it) |
| Tap / bump | Not tappable. Whole slide = part of the same 1 Move |
| Heart effect | none |
| Hammerable | No |
| Hint / solver | Deterministic slide; part of crate state transitions (N via M053) |
| Visual & audio | Shiny satin square; crate glides "shhhk" with small sparkle trail |
| Implementation | `slideCrate()` loop with max `W + H` steps guard; animation 60 ms/cell, total clamped ≤ 450 ms |
| Level design | **Do:** long satin runway that carries a crate onto a Dock Plate. **Don't:** satin loops with no stopper (crate reaches edge; still legal but wastes design). **Combos:** M053, M055 |
```json
{"id": "o54", "type": "M054", "cells": [[2, 5], [3, 5], [4, 5], [5, 5]], "params": {}, "hammerable": false}
```

### M055 — Crate Dock Plate (Block Plate)
| Field | Value |
|---|---|
| Intro / Category | L551 · **T** |
| Rule | Push Block on plate ⇒ linked gate open while block stays |
| Definition | Only Bobbin Crates count (thread bodies on the plate do **not** — that is M019). Gate state recomputed in step 4 after every Move. A closing gate never closes on a thread body (validator: gate cells never hold bodies) |
| Tap / bump | Plate not tappable. Closed gate blocks lanes ⇒ snag |
| Heart effect | Snag on closed gate −1 |
| Hammerable | No (plate & gate). Hammering the crate on it ⇒ gate closes |
| Hint / solver | **N** — gate derived from crate positions |
| Visual & audio | Wooden dock outline with bobbin-shaped slot; gate = brass presser foot. Crate docks "clunk-click" |
| Implementation | `gateOpen = crates.any((c) => c.cell == plate)` |
| Level design | **Do:** push crate onto dock to open a gate other threads need. **Don't:** the only crate route crosses the gated cell itself. **Combos:** M053, M054, M064 |
```json
{"id": "o55", "type": "M055", "cells": [[6, 6]], "params": {"gate": [9, 2]}, "hammerable": false}
```

### M056 — Pleat Ramp (Ramp)
| Field | Value |
|---|---|
| Intro / Category | L561 · **L** |
| Rule | Lane entering ramp moves path to other layer |
| Definition | Ramp links two adjacent layers `params.layers: [a, b]`. A lane on layer `a` that enters the ramp cell continues from that cell on layer `b` (and vice versa); the rest of the lane is evaluated against layer `b` occupancy. If clear ⇒ thread exits (the visual dives under/over the pleat). If blocked on layer `b` ⇒ snag, thread returns to its original layer (snag never changes state). Requires level `layers ≥ 2` |
| Tap / bump | Not tappable |
| Heart effect | Snag only if blocked after the ramp |
| Hammerable | No |
| Hint / solver | Static lane rule (layer-aware resolver) |
| Visual & audio | Folded fabric pleat forming a slope; thread slides through "swish" |
| Implementation | Lane state `(cell, dir, layer)`; renderer clips segment past ramp to target layer paint order |
| Level design | **Do:** upper-layer thread escapes via lower-layer gap. **Don't:** ramp whose both sides are permanently blocked. **Combos:** M032, M069 |
```json
{"id": "o56", "type": "M056", "cells": [[5, 4]], "params": {"layers": [0, 1]}, "hammerable": false}
```

### M057 — Loom Shuttle Gate (Traffic Light)
| Field | Value |
|---|---|
| Intro / Category | L571 · **C** |
| Rule | Gate open/closed alternates every N Moves (periodic) |
| Definition | `open(m) = ((m ~/ N) % 2 == 0) == startOpen`, where `m` = Moves made so far (value at tap time, before the step 2 increment). Badge shows Moves left until flip. Gate cells never hold thread bodies |
| Tap / bump | Not tappable. Closed ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | No |
| Hint / solver | **N** — state from move counter |
| Visual & audio | Loom shuttle sliding across the cell (closed) / parked aside (open); flip "clack" |
| Implementation | Pure function of `moveCount`; no stored state |
| Level design | **Do:** N = 2–3, threads that must "wait" via another useful Move. **Don't:** requiring a waiting Move when no other non-snag Move exists (validator forbids forced damage). **Combos:** M090, M021 |
```json
{"id": "o57", "type": "M057", "cells": [[3, 7]], "params": {"n": 2, "startOpen": false}, "hammerable": false}
```

### M058 — Spinning Stitch Arrow (Rotating Arrow)
| Field | Value |
|---|---|
| Intro / Category | L581 · **D** |
| Rule | One-way tile rotates 90° CW each Move |
| Definition | Arrow `U→R→D→L` at step 3 (M058 slot) of every Move (incl. snags and lever taps). Diagonal lanes always snag (never arrow direction) |
| Tap / bump | Not tappable. Lane against arrow ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | No |
| Hint / solver | **N** — arrow = `(start + m) % 4` |
| Visual & audio | Stitch Arrow on a small turning bobbin disc; ticks with "tik" |
| Implementation | Derived from `moveCount` (stateless) |
| Level design | **Do:** two arrows out of phase. **Don't:** arrow next to every exit. **Combos:** M006, M057 |
```json
{"id": "o58", "type": "M058", "cells": [[6, 4]], "params": {"start": "U"}, "hammerable": false}
```

### M059 — Dye Pot (Paint Cell)
| Field | Value |
|---|---|
| Intro / Category | L591 · **P** |
| Rule | Lane passing paint recolors the path |
| Definition | Colour change applies from the dye cell onward **during lane evaluation** (later Color Eyelets / Color Hem Gaps see the new colour). Applied only for non-snag outcomes (exit, push, relocation, basket); on snag the thread keeps its old colour (snag never changes state). Dye pot cell is passable floor (not floor-type for crates) |
| Tap / bump | Not tappable |
| Heart effect | none |
| Hammerable | No |
| Hint / solver | Thread colour in state |
| Visual & audio | Little enamel dye pot; thread dips and changes hue + pattern "blub" |
| Implementation | `LaneWalker.color` mutable copy; committed on success |
| Level design | **Do:** recolour to pass a Color Eyelet just after the pot. **Don't:** pot where recolour never matters. **Combos:** M005, M030, M094 |
```json
{"id": "o59", "type": "M059", "cells": [[4, 2]], "params": {"color": "red"}, "hammerable": false}
```

### M060 — Swap Hoop (Swap Pad)
| Field | Value |
|---|---|
| Intro / Category | L601 · **T** |
| Rule | Tap pad ⇒ 2 linked paths swap positions (same shape only) |
| Definition | "Same shape" = same length, same relative cell offsets and same `dir` (translation-equivalent) — validator. Swap = the two threads exchange body cells; colour, mods, keys travel with the thread. Both must be on board, same layer, and uncovered; else pad tap = locked tap |
| Tap / bump | Hoop tap = 1 Move, no lane check |
| Heart effect | none |
| Hammerable | No (threads: yes; after one exits, pad becomes inert/locked) |
| Hint / solver | **N** — swap is self-inverse |
| Visual & audio | Embroidery hoop on a side cell; both threads lift & cross "twirl" |
| Implementation | Hoop is interactive obstacle (hit-test before threads) |
| Level design | **Do:** key-thread trapped, twin in free area — swap to free the key. **Don't:** swap that has no effect on solvability. **Combos:** M004, M005 |
```json
{"id": "o60", "type": "M060", "cells": [[0, 11]], "params": {"paths": ["p2", "p9"]}, "hammerable": false}
```

### M061 — Drawstring Pouch (Capacity Hole)
| Field | Value |
|---|---|
| Intro / Category | L611 · **G** |
| Rule | Inner exit accepting N paths, then closes |
| Definition | Works as Yarn Basket (M020) until N threads have exited into it; then becomes a non-hammerable blocker cell. Badge N. Hammered threads do not use the pouch |
| Tap / bump | Lane reaching open pouch ⇒ exit into it. Closed ⇒ snag |
| Heart effect | Snag on closed −1 |
| Hammerable | No |
| Hint / solver | Counter in state (monotone) |
| Visual & audio | Drawstring fabric pouch; tightens with "zrrp" when full |
| Implementation | `remaining--` in step 1 |
| Level design | **Do:** more candidate threads than capacity ⇒ choose which. **Don't:** N greater than reachable threads. **Combos:** M078, M062 |
```json
{"id": "o61", "type": "M061", "cells": [[6, 6]], "params": {"n": 3}, "hammerable": false}
```

### M062 — Sorting Hem (Edge Quota)
| Field | Value |
|---|---|
| Intro / Category | L621 · **G** |
| Rule | Goal: ≥ Q paths of a color exit via marked edge |
| Definition | Marked edge segment = list of edge cells + side. Counts lanes that leave the board through that segment (portal-routed exits count by the segment actually crossed). Hammered threads don't count (no lane). Other exits allowed. If remaining same-colour threads < remaining quota ⇒ "Goal can't be met" banner (no auto-fail; Restart) |
| Tap / bump | Not tappable; HUD shows `blue 1/3` |
| Heart effect | none |
| Hammerable | No |
| Hint / solver | Goal in win check; solver prunes impossible states |
| Visual & audio | Hem edge with coloured basting stitches + tiny bin; exit pop "tink" |
| Implementation | `goals.edgeQuota[]` counters |
| Level design | **Do:** colour threads that can exit two ways. **Don't:** combine with M072 in one level. **Combos:** M030, M059 |
```json
{"id": "o62", "type": "M062", "cells": [[0, 3], [0, 4], [0, 5]], "params": {"side": "L", "color": "blue", "q": 3}, "hammerable": false}
```

### M063 — Magnet Pin Dish (Magnet Blocker)
| Field | Value |
|---|---|
| Intro / Category | L631 · **C** |
| Rule | Each Move pulls the nearest path in its row/col 1 cell toward it if free |
| Definition | At step 3 (M063 slot): scan 4 rays (U, R, D, L) from the dish; each ray stops at the first non-empty cell — if it is a thread body that thread is a candidate. Choose smallest distance; tie ⇒ order U, R, D, L. Distance 1 ⇒ no pull. Whole thread translates 1 cell toward the dish only if all destination cells are free (own cells allowed); else nothing. Same layer only. Multiple dishes: JSON order. The dish itself is a blocker |
| Tap / bump | Not tappable. Snag on dish −1 |
| Heart effect | Snag −1 |
| Hammerable | **No** (not in standard §16.18 hammerable defaults) |
| Hint / solver | **N** — positions change each Move |
| Visual & audio | Red horseshoe magnet in a pin dish; pulled thread slides "zzt" |
| Implementation | `MagnetTick` after counters; animation 150 ms after main move |
| Level design | **Do:** magnet drags a thread out of an exit lane over Moves. **Don't:** magnet pulling a thread into a deadlock. **Combos:** M053, M082 |
```json
{"id": "o63", "type": "M063", "cells": [[10, 5]], "params": {}, "hammerable": false}
```

### M064 — Seesaw Latches (Seesaw Gates)
| Field | Value |
|---|---|
| Intro / Category | L641 · **T** |
| Rule | 2 linked gates; exactly one open; flips whenever a lane passes the open one |
| Definition | "Passes" = a non-snag lane traverses the open gate cell (exit, push-lane, ramp, relocation). Flip happens in step 1 after the Move (the passing thread is unaffected mid-move). Snags never flip |
| Tap / bump | Not tappable. Closed latch ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | No |
| Hint / solver | **N** — 1 bit |
| Visual & audio | Pair of brass hook-and-eye latches on a little seesaw; flip "tick-tock" |
| Implementation | `openIndex ^= 1` when lane cell == open gate |
| Level design | **Do:** two threads needing opposite latches in sequence. **Don't:** both latches on the same lane. **Combos:** M055, M009 |
```json
{"id": "o64", "type": "M064", "cells": [[3, 3], [8, 3]], "params": {"open": 0}, "hammerable": false}
```

### M065 — Hidden Charm (Hidden Key)
| Field | Value |
|---|---|
| Intro / Category | L651 · **K** |
| Rule | Key under fog / under another path; revealed when cover clears |
| Definition | Hidden Charm = loose charm item on a cell, covered either by Wool Fluff / Creeping Fluff or by a thread body (any layer above it). Once uncovered, the **first non-snag lane passing the charm cell picks it up**; the matching-colour clasp(s) open permanently. Hammered threads don't pick up (no lane). Matching clasp shows "?" until the charm is revealed |
| Tap / bump | Charm not tappable; clasp closed ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | No (charm / clasp) |
| Hint / solver | Solver full-information; Hint never points at a hidden thread |
| Visual & audio | Small brass charm peeking out when uncovered; pickup "jingle" |
| Implementation | `charm.covered = fogCovers(cell) || bodyCovers(cell)`; recompute step 4 |
| Level design | **Do:** clear the covering thread first, then route another thread over the charm. **Don't:** charm reachable only by the thread covering it. **Combos:** M010, M075, M004 |
```json
{"id": "o65", "type": "M065", "cells": [[7, 8]], "params": {"color": "gold", "locks": [[11, 2]]}, "hammerable": false}
```

### M066 — Ribbon-Tied Trio (Chained Triplet)
| Field | Value |
|---|---|
| Intro / Category | L661 · **P** |
| Rule | 3-path chain (M011 ×3) |
| Definition | Tap any of the 3 ⇒ all 3 lanes evaluated on the pre-move state (members block each other, standard §16.7). All clear ⇒ all exit (1 Move). Any blocked ⇒ all snag, **−1 Heart total**. Golden Scissors on one member ⇒ that thread exits, ribbon breaks, remaining two become an M011 pair |
| Tap / bump | as above |
| Heart effect | −1 total per failed trio tap |
| Hammerable | Thread: yes (one) |
| Hint / solver | Trio = one action node |
| Visual & audio | Satin ribbon bow tied across three needles; success ⇒ bow flutters off |
| Implementation | Reuse `ChainGroup(size: 3)` from M011 |
| Level design | **Do:** three lanes cleared by different earlier Moves. **Don't:** trio whose members block each other permanently. **Combos:** M011, M080 |
```json
{"id": "o66", "type": "M066", "cells": [], "params": {"paths": ["p3", "p7", "p12"]}, "hammerable": false}
```

### M067 — Worn Fabric Patch (Collapsing Floor)
| Field | Value |
|---|---|
| Intro / Category | L671 · **C** |
| Rule | Cell becomes hole-blocker after lanes pass it N times |
| Definition | One "pass" = one Move whose non-snag lane traverses the cell (a thread's whole body sliding over it in that Move = 1 pass). Snags don't count. Counter hits 0 in step 1 ⇒ cell becomes a **Torn Hole** blocker (not hammerable, not floor-type). Thread bodies may start on the patch; push-crates may stand on it until it collapses (a crate on the cell when it collapses is not possible: passes require an empty lane cell) |
| Tap / bump | Not tappable. Torn Hole ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | No |
| Hint / solver | Counter state (monotone) |
| Visual & audio | Threadbare fabric patch with badge N; tears "rrrip" into a dark hole with frayed edge |
| Implementation | Lane walker records crossed cells; decrement once per Move |
| Level design | **Do:** N = 1–2 on a shared corridor — order which threads use it. **Don't:** the only exit for 3 threads with N = 1. **Combos:** M042, M068 |
```json
{"id": "o67", "type": "M067", "cells": [[5, 9]], "params": {"n": 2}, "hammerable": false}
```

### M068 — Lint Trail (Trail Blocker)
| Field | Value |
|---|---|
| Intro / Category | L681 · **C** |
| Rule | Exiting path leaves temporary blockers on its lane for 2 Moves |
| Definition | Applies to marked threads (`params.paths`). On exit, every **on-board lane cell beyond its original body** (cells the needle traveled through) gets lint with TTL 2. TTL decrements at step 3 (M068 slot) of each **later** Move (not the exit Move) ⇒ lint blocks the next 2 Moves and is gone before the 3rd. Lint blocks lanes (snag) and beams; crates cannot be pushed onto lint |
| Tap / bump | Lint not tappable |
| Heart effect | Snag on lint −1 |
| Hammerable | Lint: no · Thread: yes (hammered ⇒ no lane ⇒ no lint) |
| Hint / solver | **N** — TTL in state |
| Visual & audio | Fuzzy lint balls along the trail, fading in 2 steps; "fluff" |
| Implementation | `lint: Map<Cell, int>`; render alpha = TTL / 2 |
| Level design | **Do:** two threads sharing a corridor — use a lever / other thread in between. **Don't:** require waiting when no non-snag Move exists (validator). **Combos:** M057, M090 |
```json
{"id": "o68", "type": "M068", "cells": [], "params": {"paths": ["p5"], "ttl": 2}, "hammerable": false}
```

### M069 — Triple Fabric Layers (Three Layers)
| Field | Value |
|---|---|
| Intro / Category | L691 · **L** |
| Rule | Ground / mid / top (extends M032) |
| Definition | `layer` 0 Lining (ground), 1 Fabric (mid), 2 Tulle (top). Thread locked while **any higher-layer** thread covers any of its body cells. Tap priority = highest layer. Lanes, obstacles and beams interact only within own layer; Pleat Ramp (M056) moves lanes between adjacent layers. Obstacles default layer 0 |
| Tap / bump | Covered thread ⇒ locked tap |
| Heart effect | normal per layer |
| Hammerable | Uncovered threads: yes; covered: not targetable |
| Hint / solver | 3 occupancy grids |
| Visual & audio | Linen (100%), cotton sheet (90% brightness under tulle), tulle top with soft drop shadow; layer toggle "eye" button highlights one layer (view only) |
| Implementation | Paint order 0 → sheet → 1 → tulle → 2; static layer cache per layer group ([06 §4](./06_FRONTEND_AND_QA_PHASE_2.md)) |
| Level design | **Do:** 2–5 overlap cells, top-layer first. **Don't:** ground-layer thread fully hidden by two layers (unreadable). **Combos:** M056, M015 |
```json
{"id": "o69", "type": "M069", "cells": [], "params": {"layers": 3}, "hammerable": false}
```
(Level root `"layers": 3`; each thread `"layer": 0|1|2`.)

### M070 — Great Spool Lever (Global Rotator)
| Field | Value |
|---|---|
| Intro / Category | L701 · **T** |
| Rule | Lever rotates every path's dir 90° CW |
| Definition | Tap lever = 1 Move ⇒ every on-board thread's `dir` (all layers, incl. fog-hidden, locked, and both ends of M023) rotates 90° CW (`U→R→D→L`, `UR→DR→DL→UL`). Bodies don't move |
| Tap / bump | Lever tap 1 Move |
| Heart effect | none |
| Hammerable | No |
| Hint / solver | **N** — global rotation index mod 4 |
| Visual & audio | Large wooden spool lever on the frame; all needles swivel together "whirr-click" |
| Implementation | Store `globalRot` 0–3; effective dir = rotate(baseDir, globalRot + localRot) |
| Level design | **Do:** half the threads face walls; one turn frees them. **Don't:** > 1 Great Spool Lever per level before L751. **Combos:** M013, M051 |
```json
{"id": "o70", "type": "M070", "cells": [[0, 0]], "params": {}, "hammerable": false}
```

### M071 — Drawstring Hem (Quota Edge)
| Field | Value |
|---|---|
| Intro / Category | L711 · **B** |
| Rule | Edge opens after Q total exits |
| Definition | Edge segment walled (like Hem Wall M029) until Q threads have exited by any means (Golden Scissors exits count — standard §16.8 "exit ગણાય"). Opens permanently in step 1. Badge `Q − exits` |
| Tap / bump | Lane hitting closed hem ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | No |
| Hint / solver | Monotone counter |
| Visual & audio | Drawstring channel along the edge; opens with cord pull "fwup" |
| Implementation | `exitsTotal` global counter |
| Level design | **Do:** Q = 3–6, the gated threads near the end. **Don't:** Q > threads that can exit elsewhere. **Combos:** M078, M095 |
```json
{"id": "o71", "type": "M071", "cells": [[13, 4], [13, 5], [13, 6]], "params": {"side": "R", "q": 4}, "hammerable": false}
```

### M072 — Pattern Card Sequence (Color Sequence)
| Field | Value |
|---|---|
| Intro / Category | L721 · **P** |
| Rule | Colors must exit in shown repeating pattern |
| Definition | `params.pattern` e.g. `["red","blue","blue"]` repeats. Threads whose colour is in the pattern can be tapped only when their colour = next expected; else **locked tap**. Threads with colours not in the pattern are unrestricted and don't advance it. Golden Scissors can target only a thread whose colour is next (else not targetable); a hammered exit advances the pattern. Chameleon/Ombre (M041) colour = colour at tap time |
| Tap / bump | Wrong colour ⇒ locked tap (no Move). Right colour, blocked lane ⇒ snag (pattern not advanced) |
| Heart effect | Snag −1 |
| Hammerable | Thread: only if next in pattern |
| Hint / solver | Pattern index in state |
| Visual & audio | Knitting chart card pinned at top showing coloured stitches; current stitch glows |
| Implementation | `patternIndex` advanced in step 1 |
| Level design | **Do:** pattern length 2–3, 2 colours. **Don't:** pattern where needed colour is locked behind another needed colour (deadlock; validator). **Combos:** M028, M059 |
```json
{"id": "o72", "type": "M072", "cells": [], "params": {"pattern": ["red", "blue", "blue"]}, "hammerable": false}
```

### M073 — Cushioned Thread (Bubble Path)
| Field | Value |
|---|---|
| Intro / Category | L731 · **P** |
| Rule | Bubble absorbs bumps *into* this path: 1st lane hitting it pops bubble (no heart loss for that bumping path, which returns); then behaves normally |
| Definition | Popping is the one exception where a "bump" changes state (the cushion is removed); it costs a Move but no Heart and no Thimble Shield charge. Stars unaffected. Snags into other blockers are normal. If a chained group (M011/M066) bumps into it, the group returns, cushion pops, no Heart |
| Tap / bump | Tapping the cushioned thread itself ⇒ normal exit/snag rules |
| Heart effect | First hit: none · later hits: −1 |
| Hammerable | Thread: yes |
| Hint / solver | 1 bit; solver may use pops as free Moves |
| Visual & audio | Thread wrapped in a puffy quilted cushion sleeve; pop "poomf" + feathers |
| Implementation | `MoveResult.cushionPop(pathId)` |
| Level design | **Do:** use pop as a deliberate "free waiting Move". **Don't:** many cushions (trivialises parity puzzles). **Combos:** M057, M090 |
```json
{"id": "o73", "type": "M073", "cells": [], "params": {"paths": ["p8"]}, "hammerable": false}
```

### M074 — Brass Bar Wall (Armored Wall)
| Field | Value |
|---|---|
| Intro / Category | L741 · **B** |
| Rule | Not hammerable; removed only by linked lever |
| Definition | Linked lever tap = 1 Move ⇒ the wall is removed **permanently**; lever then inert (one-shot, monotone). Cells 1–4 straight (like M002) |
| Tap / bump | Wall blocks lanes and beams ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | **No** |
| Hint / solver | 1 bit |
| Visual & audio | Polished brass bar with rivets; lever = brass key-wind; bar retracts "clank" |
| Implementation | Lever is interactive obstacle in same `mechanics[]` entry |
| Level design | **Do:** decide when to open (opening may unblock a magnet or beam). **Don't:** lever placed behind the wall it opens. **Combos:** M063, M084 |
```json
{"id": "o74", "type": "M074", "cells": [[4, 6], [5, 6], [6, 6]], "params": {"lever": [0, 12]}, "hammerable": false}
```

### M075 — Creeping Fluff (Creeping Fog)
| Field | Value |
|---|---|
| Intro / Category | L751 · **C** |
| Rule | Fog expands 1 cell every N Moves (fixed order) |
| Definition | Every N Moves (step 3 (M075 slot)) the fluff area grows by 1 cell: from the **oldest** fluff cell first, into the first in-board neighbour in order U, R, D, L that is not fluff and not a blocker/wall/emitter. Growth may cover thread bodies ⇒ those threads become hidden & locked (M010 rule). Clear rule = M010: any visible thread whose body touches the area exits ⇒ whole area (incl. growth) clears; cleared area never regrows |
| Tap / bump | Fogged thread ⇒ locked tap |
| Heart effect | none |
| Hammerable | No; hidden threads not targetable |
| Hint / solver | **N** — fluff set in state |
| Visual & audio | Wool Fluff with a slowly unrolling carded edge; badge N; growth "puff" |
| Implementation | Ordered list of cells (age); grow function deterministic |
| Level design | **Do:** "clear it before it eats the key thread". **Don't:** N = 1 on boards > 12×12 (too punishing). **Combos:** M010, M065 |
```json
{"id": "o75", "type": "M075", "cells": [[9, 9], [10, 9]], "params": {"area": "f2", "n": 3}, "hammerable": false}
```

### M076 — Pompom Tunnel Network (Portal Network)
| Field | Value |
|---|---|
| Intro / Category | L761 · **D** |
| Rule | 3+ portals cycle A→B→C |
| Definition | Ordered list of n ≥ 3 pompoms. Lane entering pompom i continues from pompom (i+1) mod n, same `dir` (diagonal included). Target pompom occupied by a thread body ⇒ snag at i (M008 rule). Network is one-directional (C→A wraps, A never sends to C). Beams don't use pompoms. Loop guard: max 2 × cells steps |
| Tap / bump | Not tappable |
| Heart effect | Snag −1 |
| Hammerable | No |
| Hint / solver | Static lane rule |
| Visual & audio | 3–4 pompoms same colour with numbered tags (1→2→3); thread hops "poof-poof" |
| Implementation | Extends `PortalResolver` with `next(i)` |
| Level design | **Do:** escape that needs going through 2 pompoms. **Don't:** n > 4 (readability). **Combos:** M008, M078 |
```json
{"id": "o76", "type": "M076", "cells": [[1, 1], [11, 2], [6, 11]], "params": {"network": "N1"}, "hammerable": false}
```

### M077 — Confetti Popper (Bomb Blocker)
| Field | Value |
|---|---|
| Intro / Category | L771 · **X** |
| Rule | Linked path exit ⇒ clears hammerable obstacles in 3×3 |
| Definition | Popper is a 1-cell blocker. When its linked thread exits (incl. Golden Scissors exit), in step 1 every `hammerable: true` obstacle whose cells intersect the 3×3 centred on the popper is removed, and the popper itself is removed. Threads, non-hammerable obstacles and gates are unaffected. Golden Scissors on the popper removes it **without** a blast |
| Tap / bump | Not tappable; blocks lanes ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | **Yes** (no blast) |
| Hint / solver | Monotone |
| Visual & audio | Party popper with fabric confetti; linked thread has a confetti tag; blast "pop!" + confetti burst (≤ 450 ms) |
| Implementation | Chain: blast can remove another popper but does **not** trigger it (no cascade) |
| Level design | **Do:** popper among Wooden Buttons / Ruler Strips / Bobbin Crates. **Don't:** popper whose linked thread is boxed in by the same obstacles. **Combos:** M001, M053, M097 |
```json
{"id": "o77", "type": "M077", "cells": [[6, 6]], "params": {"linked": "p11"}, "hammerable": true}
```

### M078 — Closed Hoop Frame (Center-Only Exit)
| Field | Value |
|---|---|
| Intro / Category | L781 · **B** |
| Rule | Board edges walled; only inner exits (M020) |
| Definition | Level-level flag. All edges act as Hem Wall (M029). Valid exits: Yarn Basket (M020), Drawstring Pouch (M061). Validator: ≥ 1 inner exit reachable per thread on the solution |
| Tap / bump | Lane reaching edge ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | No |
| Hint / solver | Static |
| Visual & audio | Board framed by a round wooden hoop **ring drawn outside** the square grid (grid stays fully visible; no clipped cells); baskets glow |
| Implementation | `edgeWalled = all` |
| Level design | **Do:** 2–3 baskets, deflectors to route. **Don't:** Golden Scissors as the only escape. **Combos:** M020, M061, M076 |
```json
{"id": "o78", "type": "M078", "cells": [], "params": {"edges": "all"}, "hammerable": false}
```

### M079 — Turning Quilt Frame (Board Rotator)
| Field | Value |
|---|---|
| Intro / Category | L791 · **T** |
| Rule | Every N Moves whole board rotates 90° CW (paths' dirs rotate too) |
| Definition | Only square boards (validator W = H). At step 3 (M079 slot) when `m % N == 0`: every cell maps `(x, y) → (W − 1 − y, x)`; thread dirs, arrows, mirrors (`/`↔`\`), bumper faces (`H`↔`V`), edge segments and emitter dirs rotate. Gates / counters keep state. View auto-fits before the 400 ms rotation animation |
| Tap / bump | Not tappable (automatic); badge "turns in N" |
| Heart effect | none |
| Hammerable | No |
| Hint / solver | **N** — rotation index mod 4 |
| Visual & audio | Quilting frame with crank handle turning itself; "creak-thunk" |
| Implementation | Store logical coords + `boardRot`; renderer applies rotation transform; hit-test inverse |
| Level design | **Do:** N = 3–4; exits that are only open after a turn. **Don't:** with M040 or M096 (disorienting). **Combos:** M029, M071 |
```json
{"id": "o79", "type": "M079", "cells": [], "params": {"n": 4}, "hammerable": false}
```

### M080 — Twin Clasps (Twin Locks)
| Field | Value |
|---|---|
| Intro / Category | L801 · **K** |
| Rule | 2 locks that open only if both keys exit on same Move (via M011 chain) |
| Definition | The two key threads are a Ribbon-Tied Pair (M011). Pair exit ⇒ both clasps open permanently. The twin-key threads are **not targetable by Golden Scissors** (snipping one would make the clasps unopenable). Clasps not hammerable |
| Tap / bump | Clasp closed ⇒ snag |
| Heart effect | Snag −1; failed pair −1 total |
| Hammerable | No |
| Hint / solver | Monotone bit |
| Visual & audio | Two mirror-image brass clasps joined by a chain; open together "ka-ching" |
| Implementation | Validator: key threads share one M011 entry |
| Level design | **Do:** pair lanes cleared at different times. **Don't:** twin clasps blocking the pair's own lanes. **Combos:** M011, M066 |
```json
{"id": "o80", "type": "M080", "cells": [[2, 9], [10, 9]], "params": {"keyPaths": ["p6", "p7"], "chain": "o11"}, "hammerable": false}
```

### M081 — Copycat Thread (Mimic Path)
| Field | Value |
|---|---|
| Intro / Category | L811 · **P** |
| Rule | Takes dir of last moved path |
| Definition | "Last moved path" = the tapped thread of the most recent Move whose outcome **moved it** (exit, segment exit, relocation onto Glue Dot). Snags, pushes, lever taps don't count (snag never changes state). Updated in step 1. Before any such Move ⇒ its initial `dir`. Copycats never copy each other's change in the same Move |
| Tap / bump | Normal thread with current mimic dir |
| Heart effect | normal |
| Hammerable | Thread: yes (hammer doesn't update "last moved") |
| Hint / solver | **N** — `lastDir` in state |
| Visual & audio | Thread with kitten-ear needle charm; needle swivels to copy "mew-click" |
| Implementation | `lastMovedDir` stored in board state |
| Level design | **Do:** set up a copycat by first pulling a thread in the needed direction. **Don't:** copycat whose all 8 dirs are blocked. **Combos:** M051, M070 |
```json
{"id": "o81", "type": "M081", "cells": [], "params": {"paths": ["p10"]}, "hammerable": false}
```

### M082 — Feed Dog Belt (Conveyor)
| Field | Value |
|---|---|
| Intro / Category | L821 · **D** |
| Rule | Path fully on belt shifts 1 cell along belt each Move if free |
| Definition | Belt = ordered cell list (open line or loop). At step 3 (M082 slot), a thread whose **all** body cells are belt cells moves each body cell to the next belt index if the leading destination cell is free (on loops the tail-vacated cell counts). End of an open belt ⇒ no shift. `dir` unchanged. Crates are not moved by belts. Belt cells are floor-type |
| Tap / bump | Belt not tappable |
| Heart effect | none |
| Hammerable | No |
| Hint / solver | **N** — positions change |
| Visual & audio | Sewing-machine feed-dog teeth strip with arrows; shift "chk" |
| Implementation | Process threads in belt order from front to back to avoid self-collision |
| Level design | **Do:** belt carries a thread into a clear lane after k Moves. **Don't:** belt pushing a thread into a permanent jam. **Combos:** M063, M085 |
```json
{"id": "o82", "type": "M082", "cells": [[2, 12], [3, 12], [4, 12], [5, 12], [6, 12]], "params": {"loop": false}, "hammerable": false}
```

### M083 — Heavy Treadle Plate (Heavy Plate)
| Field | Value |
|---|---|
| Intro / Category | L831 · **T** |
| Rule | Only Wide Path (M024) can hold it |
| Definition | Like Foot Pedal Plate (M019) but the linked gate is open only while a **Chunky Chenille** body (either strand) covers the plate. Normal threads and crates on it don't count. Recomputed step 4 |
| Tap / bump | Gate closed ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | No |
| Hint / solver | **N** |
| Visual & audio | Cast-iron treadle plate; chenille presses it "thunk" |
| Implementation | `gateOpen = chenilleBodies.any(covers(plate))` |
| Level design | **Do:** chenille must stay until others pass. **Don't:** plate covered only by the gated chenille itself. **Combos:** M024, M019 |
```json
{"id": "o83", "type": "M083", "cells": [[5, 3]], "params": {"gate": [9, 8]}, "hammerable": false}
```

### M084 — Sewing Lamp Emitter (Laser Emitter)
| Field | Value |
|---|---|
| Intro / Category | L841 · **B** |
| Rule | Beam line acts as blocker; beam stops at first path/blocker |
| Definition | Emitter = 1-cell blocker with orthogonal `dir`. Beam = cells from the next cell in `dir` up to (not incl.) the first thread body, blocker, closed gate, crate, lint, pompom, emitter, or receiver (receiver is "hit"). Beam passes empty, floor-type, open gates, baskets, dye pots. Recomputed at step 4 and level start; a moving thread's lane is checked against the **pre-move** beam. Lane entering a beam cell ⇒ snag. Beams on emitter layer only. Beam never damages directly |
| Tap / bump | Emitter not tappable; snag on emitter or beam −1 |
| Heart effect | Snag −1 |
| Hammerable | No |
| Hint / solver | Beam derived from state (no extra state) |
| Visual & audio | Brass sewing lamp; warm light ribbon (pre-baked gradient, no blur); hum loop low volume |
| Implementation | `BeamTracer.trace(state)` returns `Set<Cell>` + hits; cached until next Move |
| Level design | **Do:** a thread body currently "shading" the beam keeps a corridor open — remove it last. **Don't:** beam crossing every exit at start. **Combos:** M085, M086, M089 |
```json
{"id": "o84", "type": "M084", "cells": [[0, 6]], "params": {"dir": "R"}, "hammerable": false}
```

### M085 — Sun-Catcher Receiver (Laser Receiver)
| Field | Value |
|---|---|
| Intro / Category | L851 · **T** |
| Rule | Beam hits receiver ⇒ linked gate open while hit |
| Definition | Receiver = 1-cell blocker that terminates beams. Linked gate(s) open while any beam ends on it after step 4; else closed. Gate cells never hold bodies |
| Tap / bump | Not tappable |
| Heart effect | Snag on closed gate −1 |
| Hammerable | No |
| Hint / solver | **N** — derived from beam |
| Visual & audio | Stained-glass sun-catcher that glows when lit; gate = lace curtain opening "shimmer" |
| Implementation | `receiverLit = beamHits.contains(receiver)` |
| Level design | **Do:** receiver dark at start because a thread body shades the beam; that thread's exit **unshades** the beam and opens the gate (threads can never move into beam cells). **Don't:** receiver that can never be lit. **Combos:** M084, M086, M099 |
```json
{"id": "o85", "type": "M085", "cells": [[12, 6]], "params": {"gates": [[6, 0]]}, "hammerable": false}
```

### M086 — Vanity Mirror (Beam Mirror)
| Field | Value |
|---|---|
| Intro / Category | L861 · **D** |
| Rule | Mirror for beams and lanes |
| Definition | `orient` `/` or `\`, same turn table as Hook Deflector (M014) for both orthogonal lanes and beams. Diagonal lanes ⇒ snag (mirror acts as blocker). Loop guard for beams (visited `(cell, dir)`) and lanes |
| Tap / bump | Not tappable |
| Heart effect | Snag only if bent route blocked |
| Hammerable | No |
| Hint / solver | Static |
| Visual & audio | Small oval hand mirror with wooden frame; beam glints "ting" |
| Implementation | Shared `reflect(dir, orient)` with M014 |
| Level design | **Do:** one mirror serving both a thread exit and a beam route. **Don't:** mirror loops. **Combos:** M084, M085, M014 |
```json
{"id": "o86", "type": "M086", "cells": [[6, 6]], "params": {"orient": "\\"}, "hammerable": false}
```

### M087 — Hook-and-Loop Pad (Glue Pad)
| Field | Value |
|---|---|
| Intro / Category | L871 · **P** |
| Rule | Head on glue ⇒ 1st tap unsticks, 2nd exits |
| Definition | Pad is floor-type. A needle on a pad is "stuck": 1st tap = 1 Move, unsticks (no lane check). Next tap = normal exit/snag. A needle that **ends a Move** on a pad (via belt, magnet, relocation, swap) becomes stuck again. Unstuck state persists while the needle stays |
| Tap / bump | 1st tap: unstick (1 Move, no Heart). 2nd: normal |
| Heart effect | none for unstick; snag −1 normally |
| Hammerable | Pad: no · Thread: yes |
| Hint / solver | **N** — stuck bit per thread |
| Visual & audio | Fuzzy hook-and-loop square under needle; unstick "rrrip-tch" |
| Implementation | `stuck` recomputed when needle cell changes (step 3/4) |
| Level design | **Do:** use unstick taps as free tempo Moves for M057/M090. **Don't:** > 4 pads per level. **Combos:** M012, M082 |
```json
{"id": "o87", "type": "M087", "cells": [[3, 4]], "params": {}, "hammerable": false}
```

### M088 — Thistle Burr (Lane Mine)
| Field | Value |
|---|---|
| Intro / Category | L881 · **K** |
| Rule | Mine blocks lane until linked key-path exits (defuse) |
| Definition | 1-cell blocker linked to a **specific thread** (not a colour). Linked thread exit (incl. Golden Scissors exit) ⇒ burr removed permanently. Blocks lanes and beams while armed |
| Tap / bump | Not tappable; snag −1 |
| Heart effect | Snag −1 |
| Hammerable | **No** (defuse only) |
| Hint / solver | Monotone bit |
| Visual & audio | Spiky thistle burr caught in the fabric; linked thread has a tiny comb icon; defuse "brush-pop" |
| Implementation | Same hook as M004 with `keyPath` |
| Level design | **Do:** burrs on the only diagonal escape. **Don't:** burr on its own key thread's lane (deadlock; validator). **Combos:** M004, M065 |
```json
{"id": "o88", "type": "M088", "cells": [[8, 4]], "params": {"keyPath": "p14"}, "hammerable": false}
```

### M089 — Crystal Bead Prism (Prism)
| Field | Value |
|---|---|
| Intro / Category | L891 · **D** |
| Rule | Beam splits into two 90° beams |
| Definition | Beam entering prism with dir d ⇒ two beams leave the prism cell in dirs rotate(d, −90°) and rotate(d, +90°); incoming beam does not continue. For **lanes** the prism is a blocker (snag). Loop guard shared |
| Tap / bump | Not tappable |
| Heart effect | Snag −1 (lanes) |
| Hammerable | No |
| Hint / solver | Static |
| Visual & audio | Faceted crystal bead; split light in two warm ribbons "chime" |
| Implementation | `BeamTracer` uses a work-queue of `(cell, dir)` |
| Level design | **Do:** one emitter feeding two receivers. **Don't:** split beams that wall off half the board. **Combos:** M084, M085, M086 |
```json
{"id": "o89", "type": "M089", "cells": [[6, 3]], "params": {}, "hammerable": false}
```

### M090 — Odd-Stitch Gate (Parity Gate)
| Field | Value |
|---|---|
| Intro / Category | L901 · **C** |
| Rule | Open on odd Move count, closed on even |
| Definition | Move count = Moves made so far (value at tap time). Start 0 ⇒ closed for the first Move. Gate cells never hold bodies |
| Tap / bump | Closed ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | No |
| Hint / solver | **N** — parity |
| Visual & audio | Gate with a stitch counter showing "odd"/"even" dot; flip "click" |
| Implementation | Stateless `moveCount.isOdd` |
| Level design | **Do:** pair with Sheer Silk (M021, solid on even). **Don't:** require a wasting Move when none exists. **Combos:** M021, M096, M087 |
```json
{"id": "o90", "type": "M090", "cells": [[7, 0]], "params": {}, "hammerable": false}
```

### M091 — Grand Quilt Block Rotor (Rotor 3×3)
| Field | Value |
|---|---|
| Intro / Category | L911 · **T** |
| Rule | M034 at 3×3 |
| Definition | Tap centre handle = 1 Move ⇒ contents fully inside the 3×3 (threads with all cells inside, incl. `dir`; obstacles) rotate 90° CW: `(x, y) → (x0 + 2 − (y − y0), y0 + (x − x0))`. Any thread partially inside ⇒ rotor tap = locked tap. Diagonal dirs rotate too. Centre cell = handle (a thread body on the centre is allowed; tapping it hits the handle, so threads on the centre must have length ≥ 2) |
| Tap / bump | Handle tap 1 Move |
| Heart effect | none |
| Hammerable | No |
| Hint / solver | **N** |
| Visual & audio | Nine-patch quilt block with a big button handle; "fabric swish" |
| Implementation | Reuse M034 rotation with size 3 |
| Level design | **Do:** 1–3 short threads inside. **Don't:** crates inside next to satin patches (confusing). **Combos:** M034, M051 |
```json
{"id": "o91", "type": "M091", "cells": [[4, 4], [5, 4], [6, 4], [4, 5], [5, 5], [6, 5], [4, 6], [5, 6], [6, 6]], "params": {}, "hammerable": false}
```

### M092 — Chain-Stitch Thread (Segmented Path)
| Field | Value |
|---|---|
| Intro / Category | L921 · **P** |
| Rule | Each tap exits 1 segment (multi-tap, each = 1 Move) |
| Definition | `params.segments` = segment lengths from the needle (sum = body length). Tap ⇒ front segment's lane evaluated; clear ⇒ front segment exits (lane effects apply: sequins, chalk, dye); remaining body's first cell becomes the new needle with the **same `dir`**. Blocked ⇒ snag (nothing exits). Thread counts as exited (win, keys, guardian HP, knots, quotas) only when the **last** segment exits. Golden Scissors snips the whole thread |
| Tap / bump | as above |
| Heart effect | Snag −1 |
| Hammerable | Thread: yes (whole) |
| Hint / solver | **N** — segment index |
| Visual & audio | Chain-stitch loops with visible joins; each segment pops off "tk" |
| Implementation | `MoveResult.segmentExit(pathId, k)` |
| Level design | **Do:** 2–3 segments where later segments' lanes differ (bent body). **Don't:** > 4 segments. **Combos:** M098, M049 |
```json
{"id": "o92", "type": "M092", "cells": [], "params": {"paths": ["p9"], "segments": [2, 2, 3]}, "hammerable": false}
```

### M093 — Split-Ply Thread (Splitter Path)
| Field | Value |
|---|---|
| Intro / Category | L931 · **P** |
| Rule | Tap ⇒ splits at midpoint into 2 paths facing opposite; then each exits normally |
| Definition | Body length even, ≥ 4 (validator). 1st tap = 1 Move, always succeeds (no lane check): front half `body[0 … L/2−1]` keeps needle and `dir` (id `p<n>a`); back half becomes a new thread whose needle is the **original tail cell** (order reversed) and `dir` = opposite of original (id `p<n>b`). Both keep colour; key/charm tags stay on the front half. Win requires both halves to exit |
| Tap / bump | 1st tap split; then normal rules per half |
| Heart effect | none for split |
| Hammerable | Before split: whole thread · After: each half |
| Hint / solver | **N** |
| Visual & audio | Two-ply twisted yarn; untwists into two with "sproing" |
| Implementation | Path ids deterministic for Hint `solution` (`"p5"` then `"p5a"`, `"p5b"`) |
| Level design | **Do:** straight thread between two blockers that only halves can clear. **Don't:** split halves facing each other's body (validator). **Combos:** M022, M023 |
```json
{"id": "o93", "type": "M093", "cells": [], "params": {"paths": ["p5"]}, "hammerable": false}
```

### M094 — Dye Mixing Pot (Color Mixer)
| Field | Value |
|---|---|
| Intro / Category | L941 · **P** |
| Rule | Two paints mix (R+B = Purple etc.) |
| Definition | Unlike M059 (replace), the mixing pot **mixes** its colour into the thread's colour: red+blue = purple, red+yellow = orange, blue+yellow = green; same colour ⇒ unchanged; any other combination ⇒ brown. Applied during lane evaluation, committed only on non-snag outcomes (as M059) |
| Tap / bump | Not tappable |
| Heart effect | none |
| Hammerable | No |
| Hint / solver | Colour in state |
| Visual & audio | Wooden mixing bowl with two-tone swirl; "swirl-blub" |
| Implementation | `mix(a, b)` table in `puzzle_core`; colour-blind pattern = combined pattern icon |
| Level design | **Do:** M059 then M094 in one lane to make purple for a purple Eyelet. **Don't:** brown outcomes required (no brown gates in Phase 2). **Combos:** M059, M005, M095 |
```json
{"id": "o94", "type": "M094", "cells": [[8, 7]], "params": {"color": "blue"}, "hammerable": false}
```

### M095 — Color Drawstring Hem (Color Quota Edge)
| Field | Value |
|---|---|
| Intro / Category | L951 · **B** |
| Rule | M071 per color |
| Definition | Edge segment walled until Q threads **of `params.color`** have exited (any route; Golden Scissors exits count, as M071). Then opens permanently **for all colours**. Several segments may each have their own colour |
| Tap / bump | Lane hitting closed hem ⇒ snag |
| Heart effect | Snag −1 |
| Hammerable | No |
| Hint / solver | Monotone per-colour counters |
| Visual & audio | Drawstring hem with a coloured cord + count badge |
| Implementation | `exitsByColor[c]` |
| Level design | **Do:** dye pots changing which colour counts. **Don't:** quota colour absent. **Combos:** M071, M059, M094 |
```json
{"id": "o95", "type": "M095", "cells": [[0, 12], [1, 12], [2, 12]], "params": {"side": "D", "color": "purple", "q": 2}, "hammerable": false}
```

### M096 — Shadow-Work Thread (Shadow Path)
| Field | Value |
|---|---|
| Intro / Category | L961 · **P** |
| Rule | Visible & tappable only on even Move count; never blocks when invisible |
| Definition | Move count = Moves made so far (start 0 ⇒ visible). On odd counts the thread is not drawn, not tappable (tap on its cells falls through to whatever else is there; empty ⇒ ignored, no Move) and blocks nothing (lanes and beams pass). HUD shows a small "shadow threads hidden" chip on odd counts (rule unchanged) |
| Tap / bump | Even: normal. Odd: not present |
| Heart effect | normal when visible |
| Hammerable | Only when visible |
| Hint / solver | **N** — parity |
| Visual & audio | Embroidery shadow-work: sheer white thread with colour showing through; fades 150 ms |
| Implementation | Independent from M021 (solid on even / visible ghost on odd); both read `moveCount`. Renderer skips the thread on odd counts; hit-test skips it |
| Level design | **Do:** "make an odd Move to let a lane pass". **Don't:** use in Daily Stitch; > 3 per level. **Combos:** M021, M090 |
```json
{"id": "o96", "type": "M096", "cells": [], "params": {"paths": ["p13"]}, "hammerable": false}
```

### M097 — Button Domino Row (Domino Chain)
| Field | Value |
|---|---|
| Intro / Category | L971 · **B** |
| Rule | Clearing first domino (hammer or linked exit) clears chain in order |
| Definition | Ordered cell list; each cell a blocker. Trigger: Golden Scissors on the **first** domino, or exit of `params.linked` thread. All dominoes removed in the same Move (step 1), animated in order 60 ms apart (≤ 450 ms). Only the first domino is targetable by Golden Scissors |
| Tap / bump | Dominoes block lanes and beams |
| Heart effect | Snag −1 |
| Hammerable | First domino only |
| Hint / solver | Monotone bit |
| Visual & audio | Row of standing wooden buttons tipping like dominoes "tk-tk-tk" |
| Implementation | Max chain 6 (animation budget) |
| Level design | **Do:** chain that snakes across 2 corridors. **Don't:** chain whose linked thread is boxed in by the chain itself. **Combos:** M077, M001 |
```json
{"id": "o97", "type": "M097", "cells": [[3, 2], [4, 2], [5, 2], [5, 3], [5, 4]], "params": {"linked": "p2"}, "hammerable": true}
```

### M098 — Wandering Pincushion Guardian (Moving Guardian)
| Field | Value |
|---|---|
| Intro / Category | L981 · **X** |
| Rule | M049 + M025 patrol |
| Definition | Multi-cell guardian (2×2) whose anchor follows a fixed loop 1 step per Move at step 3 (M025/M098 slot); whole shape translates. If any destination cell is occupied (thread body, blocker, crate) ⇒ waits that Move (standard §16.14). HP = linked threads; each linked exit (incl. Golden Scissors exit; Chain-Stitch counts on last segment) −1; 0 ⇒ vanish. Lane check uses position at tap time |
| Tap / bump | Not tappable; snag −1 |
| Heart effect | Snag −1 |
| Hammerable | **No** |
| Hint / solver | **N** — loop index + HP |
| Visual & audio | Tomato pincushion on little wooden wheels; pins = HP; roll "rumble", pin pull "ping" |
| Implementation | Guardian occupancy updated after patrol; beams recomputed at step 4 |
| Level design | **Do:** loop crossing 2–3 corridors alternately. **Don't:** loop of 2 positions (flicker). **Combos:** M049, M092, M084 |
```json
{"id": "o98", "type": "M098", "cells": [[5, 5], [6, 5], [5, 6], [6, 6]], "params": {"linked": ["p1", "p4", "p9", "p15"], "loop": [[5, 5], [6, 5], [7, 5], [7, 6], [7, 7], [6, 7], [5, 7], [5, 6]], "index": 0}, "hammerable": false}
```

### M099 — Master Jewel Clasp (Master Lock)
| Field | Value |
|---|---|
| Intro / Category | L991 · **K** |
| Rule | Needs all key types + laser receiver |
| Definition | `params.keys` = list of key colours (M004 key threads / M065 charms). Opens **permanently** at step 4 of the first Move after which every listed key has been collected (key thread exited / charm picked) **and** its linked Sun-Catcher (M085) is lit. Before that: blocker for lanes and beams. Progress shown as gem sockets |
| Tap / bump | Not tappable; snag −1 |
| Heart effect | Snag −1 |
| Hammerable | **No** |
| Hint / solver | Monotone once open; receiver part N |
| Visual & audio | Ornate jewel clasp with coloured gem sockets + small sun-catcher window; opens "grand chime" |
| Implementation | `open = keysDone && receiverLit` evaluated in step 4; latch true |
| Level design | **Do:** last gate of the finale act. **Don't:** receiver beam that a key thread must permanently block. **Combos:** M004, M065, M085 |
```json
{"id": "o99", "type": "M099", "cells": [[7, 13]], "params": {"keys": ["gold", "rose", "teal"], "receiver": "o85"}, "hammerable": false}
```

### Finale — The Heirloom Tapestry (Phase 2 Finale, L1000)
| Field | Value |
|---|---|
| Rule | Moving Guardian + ≥ 10 mixed mechanics |
| Grid / threads / layers | 14×14 · 40 · 3 |
| D target | 84 (P2-B high 70 × 1.2), ±3 |
| Mix | M098 + M051, M053, M055, M064, M069, M076, M082, M084, M085, M086, M089, M092, M099 |
| Validator | 0 hearts & 0 boosters solvable; node limit 2M; depth ≤ 120 |
| Design | [02 §9](./02_LEVEL_PROGRESSION_0501_1000.md) |
| JSON | `"slot": "finale"`, `"tag": "finale"`, `"phase": 2`, M098 + ≥ 10 other `type` values |

## 4. Edge-Case Definitions Summary

Standard rule ખુલ્લો રાખે છે ત્યાં આ catalog નીચેના engine definitions નક્કી કરે છે (બધી games માં સરખા રાખવા માટે standard §16 માં ઉમેરવા યોગ્ય):

| # | ID | Definition |
|---|---|---|
| D1 | M051 | 8-connected bodies; squeeze rule (diagonal step blocked only by a crossing diagonal link of one thread); no-crossing validator; orthogonal-only devices snag diagonal lanes |
| D2 | M052 | Face `H`/`V` reflect table; orthogonal lanes treat bumper as blocker |
| D3 | M053 | Open edge ⇒ crate falls off & removed; walled edge / blocked ⇒ snag (§17.29); "free" = empty or floor-type; diagonal push allowed; lane effects before crate apply |
| D4 | M054 | Slide stops on first non-glide cell; threads unaffected |
| D5 | M055 | Only crates hold dock plates |
| D6 | M056 | Lane continues on the other layer from the ramp cell; snag returns thread to its layer |
| D7 | M057 / M090 / M096 | Move count = Moves made so far at tap time (start 0) |
| D8 | M059 / M094 | Recolour committed only on non-snag outcomes; mixing table + "brown" fallback |
| D9 | M060 | Same shape = translation-equivalent incl. `dir`; properties travel with thread |
| D10 | M062 | Hammered threads don't count; impossible-goal banner, no auto-fail |
| D11 | M063 | 4-ray line-of-sight nearest, tie U,R,D,L; distance 1 no pull; rigid translation |
| D12 | M064 | Flip only on non-snag lane through open latch |
| D13 | M065 | Charm is a loose cell item, picked by first non-snag lane after uncovering |
| D14 | M067 | 1 pass per Move; collapsed hole not hammerable |
| D15 | M068 | Lint on lane cells beyond original body; TTL decrements on later Moves only |
| D16 | M070 | Rotates all threads incl. hidden/locked and both M023 ends |
| D17 | M071 / M095 | Golden Scissors exits count; M095 opens for all colours |
| D18 | M072 | Non-pattern colours unrestricted; hammer only on next colour |
| D19 | M073 | Pop costs a Move, no Heart, no Shield charge |
| D20 | M074 | Lever one-shot, permanent removal |
| D21 | M075 | Grows from oldest cell, U,R,D,L, not into blockers; cleared area never regrows |
| D22 | M076 | One-directional cycle; beams don't use pompoms |
| D23 | M077 | Hammered popper: no blast; blast doesn't trigger other poppers |
| D24 | M079 | Square boards only; full orientation remap |
| D25 | M080 | Twin-key threads not targetable by Golden Scissors |
| D26 | M081 | "Moved" = exit / segment exit / relocation; snags & pushes don't count |
| D27 | M082 | Path must be fully on belt; crates not moved; open-belt end = stop |
| D28 | M084–M089 | Beam stop/pass lists; pre-move beam for lanes; recompute at step 4; beams ignore portals; prism blocks lanes |
| D29 | M087 | Pad re-sticks a needle that ends a Move on it |
| D30 | M088 | Burr linked to a specific thread; not hammerable |
| D31 | M091 | Partially-inside thread ⇒ locked rotor tap; centre-cell threads length ≥ 2 |
| D32 | M092 | Same `dir` for next segment; exit triggers on last segment |
| D33 | M093 | Even length ≥ 4; back half needle = original tail, dir opposite |
| D34 | M097 | Whole chain cleared in one Move; only first domino hammerable |
| D35 | M098 | Whole-shape translation; waits if any destination cell occupied |
| D36 | M099 | Latches open permanently at step 4 when all keys + receiver lit |

## 5. Unit-test requirement
દરેક M-ID (M051–M099) માટે `packages/puzzle_core/test/mechanics/m0xx_test.dart` ફરજિયાત (§1 list), ઉપરાંત દરેક Definition (D1–D36) માટે એક explicit test case. QA IDs: [06 §9.3](./06_FRONTEND_AND_QA_PHASE_2.md).

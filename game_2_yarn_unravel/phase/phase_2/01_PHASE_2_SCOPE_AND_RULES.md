# 01 — Phase 2 Scope & Rule Additions
> Purpose: Phase 2 માં core rules માં થતા **ઉમેરા** — pinch-zoom/pan, 8-direction (diagonal) threads, 3 layers, push objects, lanes vs beams, extended Move resolution order, tiers P2-A/P2-B અને economy ફેરફારો (માત્ર standard માં લખેલા).

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) (§1–§2, §6, §9.3, §10 Phase 2) · [./README.md](./README.md) · [../phase_1/01_GAME_CONCEPT_AND_RULES.md](../phase_1/01_GAME_CONCEPT_AND_RULES.md) · [./02_LEVEL_PROGRESSION_0501_1000.md](./02_LEVEL_PROGRESSION_0501_1000.md) · [./03_OBSTACLE_CATALOG_PHASE_2.md](./03_OBSTACLE_CATALOG_PHASE_2.md) · [./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)

> Phase 1 ના બધા rules (tap → unravel, snag −1 Heart, locked taps, tap priority, Thread Peek, hearts/revive, stars, boosters) **યથાવત** છે. આ file માં "Definition" લખેલું હોય તે standard એ ખુલ્લો રાખેલો edge case છે જેને અહીં engine માટે નક્કી કર્યો છે.

---

## 1. Phase 2 Overview

| Item | Value |
|---|---|
| Levels | 501–1000 (50 blocks × 10) |
| L501–510 | Onboarding: zoom/pan tutorial, 12×12 boards, **no new mechanic** |
| New mechanics | M051–M099 at L511, 521 … 991 (x1 slot) |
| L1000 | Phase 2 Finale: Moving Guardian (M098) + ≥ 10 mixed mechanics |
| Max board | 14×14 · max threads 40 · max layers 3 |
| LiveOps | Album, Star Race, Piggy Bank, Cloud Sync, Cosmetics ([04](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md), [05](./05_OFFLINE_AND_CLOUD_SYNC.md)) |

## 2. Pinch-Zoom & Pan (boards ≥ 12×12)

Standard §9.3: Phase 2 માં ≥ 12×12 boards પર **pinch-zoom + pan** ચાલુ, **auto-fit start**.

| Rule | Value |
|---|---|
| Enabled when | `max(W, H) ≥ 12`. 11×11 અને નાના boards: Phase 1 જેવું fit-only (zoom disabled) |
| Start state | **Auto-fit**: આખો board screen માં (16 dp gutters). `fitCell = floor(min((screenW − 32) / W, availH / H))` |
| Fit cell size (360 dp width) | 12×12 ⇒ 27 dp · 13×13 ⇒ 25 dp · 14×14 ⇒ 23 dp (Phase 1 નો 29 dp min rule Phase 1 grids માટે જ છે — standard §12) |
| Zoom range | `scale ∈ [1.0, maxScale]`, `maxScale = max(1.0, 48 / fitCell)` ⇒ zoomed cell max 48 dp |
| Pinch | 2 pointers ⇒ scale around focal point; clamp to range |
| Pan | Zoomed (`scale > 1`) હોય ત્યારે 1-finger drag ≥ 18 dp (touch slop) ⇒ pan; board edge + 24 dp થી આગળ pan નહીં (clamp) |
| Fit button | HUD માં "⤢ Fit" (spool icon) ⇒ 250 ms animate to scale 1.0 |
| Double-tap | **Zoom માટે વપરાતો નથી** (thread tap સાથે conflict) |
| Move? | Zoom, pan, Fit = **Move નથી**, counters tick થતા નથી |
| Tap vs pan | Pointer down → up within slop & < 350 ms ⇒ tap. Slop પાર ⇒ pan (tap/peek cancel). ≥ 350 ms હલ્યા વગર ⇒ Thread Peek |
| Hit area at fit | Tap ⇒ જે cell માં પડે તે cell. fitCell < 29 dp હોય ત્યારે board edge થી 0.1 cell બહારનો tap પણ edge cell ને મળે (enlarged slop); વધુ ચોકસાઈ માટે zoom |
| Animation follow | Unravel દરમિયાન camera auto-pan **નથી** (motion sickness); thread view બહાર જાય તો edge પર small arrow cue |
| Reduce motion | Fit animation instant |
| Persist | Level દીઠ zoom state persist નહીં; દરેક attempt auto-fit થી શરૂ |

Onboarding (L501–504) zoom/pan/Fit/Peek-while-zoomed શીખવે છે — [02 §3](./02_LEVEL_PROGRESSION_0501_1000.md).

## 3. 8-Direction Threads (M051 થી)

Standard §1: Phase 2 થી `dir` ∈ `U, D, L, R, UL, UR, DL, DR`.

| Dir | (dx, dy) | Dir | (dx, dy) |
|---|---|---|---|
| U | (0, −1) | UR | (1, −1) |
| R | (1, 0) | DR | (1, 1) |
| D | (0, 1) | DL | (−1, 1) |
| L | (−1, 0) | UL | (−1, −1) |

90° CW rotation (Spool Spinner M013, rotors, Great Spool Lever M070, Turning Quilt Frame M079): `U→R→D→L→U`, `UR→DR→DL→UL→UR`.

**Definitions (engine):**
1. **Diagonal lane:** head ના આગળના cell `(x+dx, y+dy)` થી diagonal steps, board edge સુધી. Lane board બહાર જાય (કોઈ પણ edge અથવા corner) ⇒ exit.
2. **Body connectivity:** Phase 2 માં body cells **8-connected** હોઈ શકે (consecutive cells king-move adjacent). Phase 1 levels orthogonal જ રહે.
3. **No-crossing rule:** બે threads ના diagonal links એક જ 2×2 corner માં ક્રોસ ન થઈ શકે (validator). 
4. **Squeeze rule:** Diagonal lane step `(x,y)→(x+1,y+1)` ત્યારે જ blocked જ્યારે બે side cells `(x+1,y)` અને `(x,y+1)` **એક જ thread ના consecutive body cells** હોય (diagonal link lane ને ક્રોસ કરે). બાજુના cells અલગ threads/obstacles થી ભરેલા હોય તો lane પસાર થઈ શકે (squeeze allowed).
5. **Phase 1 orthogonal devices + diagonal lane:** Stitch Arrow (M006) અને Spinning Stitch Arrow (M058): diagonal lane ⇒ arrow direction નથી ⇒ snag. Hook Deflector (M014), Vanity Mirror (M086), Thread Guide Switch (M018): diagonal lane ⇒ snag (blocker). Pompom Tunnels (M008/M076): diagonal lane same `dir` માં continue. Elastic Hop Pad (M038): diagonal hop next 1 diagonal cell.
6. **Chunky Chenille (M024)** diagonal હોઈ શકે નહીં (validator).
7. Unravel animation: diagonal steps સીધી line (√2 length), corners soft curve ([06 §4](./06_FRONTEND_AND_QA_PHASE_2.md)).

## 4. Layers (up to 3)

| Rule | Value |
|---|---|
| Layers | `layer ∈ {0, 1, 2}` — 0 Lining (bottom), 1 Fabric (middle), 2 Tulle (top). Level root `"layers": 1–3` |
| Lock | Thread locked જ્યાં સુધી **કોઈપણ ઉપરના layer** (higher index) નો thread તેના કોઈ body cell ને cover કરે (M032 rule extended — M069) |
| Tap priority | Overlap cell ⇒ સૌથી ઉપરના layer નો thread (standard §2.9) |
| Lanes | ફક્ત પોતાના layer ના threads/obstacles સાથે interact. Obstacles `layer` default 0 |
| Layer change | ફક્ત Pleat Ramp (M056) દ્વારા |
| Golden Scissors | Covered thread target ન થાય (standard §16.8) |
| Beams | Emitter ના layer પર જ ચાલે (§6) |

## 5. Push Objects (Bobbin Crate family)

| Rule | Value |
|---|---|
| Push | Lane પહેલો non-passable object તરીકે **Bobbin Crate (M053)** ને hit કરે ⇒ crate ની પાછળનો cell (lane direction માં) free હોય તો crate 1 cell ખસે. **1 Move, thread જગ્યાએ જ રહે, heart નહીં** |
| Blocked push | પાછળનો cell free નથી (અને open edge નથી) ⇒ normal **snag (−1 Heart)** |
| Free cell (Definition) | Board ની અંદર, કોઈ thread body નહીં (crate ના layer પર), અને obstacle નહીં **અથવા** floor-type obstacle: Foot Pedal Plate M019, Satin Glide Patch M054, Crate Dock Plate M055, Worn Fabric Patch M067 (collapse પહેલાં), Feed Dog Belt M082, Heavy Treadle Plate M083 |
| Push at board edge (standard §17.29) | Crate ને **open** board edge પાર ધકેલાય ⇒ crate board પરથી પડી જાય અને **remove** થાય (કંઈ count નહીં: quota, plate વગેરે). **Walled / closed edge** (Hem Wall M029, closed Zipper Edge M031, Center-Only Exit M078 edges, Color Hem Gap નો બીજો colour) અથવા પાછળ blocked cell ⇒ **snag (−1 Heart)** |
| Diagonal push | Diagonal lane ⇒ crate diagonal ખસે (squeeze rule §3 લાગુ) |
| Slide | Satin Glide Patch (M054) પર crate સરકતું રહે ([03 M054](./03_OBSTACLE_CATALOG_PHASE_2.md)) |
| Lane passes paint/dye before crate | Dye recolor લાગુ થાય (non-bump outcome) — [03 M059](./03_OBSTACLE_CATALOG_PHASE_2.md) |
| Solver | Crate positions = state (T category ⇒ solver ફરજિયાત) |

## 6. Lanes vs Beams

| Concept | **Lane** (pull lane) | **Beam** (lamp beam) |
|---|---|---|
| Source | Thread ની needle `dir` | Sewing Lamp Emitter (M084) નો `dir` (orthogonal only) |
| When computed | Tap time પર, pre-move state થી | **દરેક Move ના tick step 4** (derived states, §7) અને level start પર |
| Effect | Thread move/exit/snag | Beam cells = **blockers** for lanes; Sun-Catcher (M085) gate control |
| Stops at | પહેલો blocker / thread (⇒ snag) | પહેલો thread body, blocker, closed gate, Bobbin Crate, emitter, Pompom Tunnel, receiver (stops, hits receiver) |
| Passes over | empty cells, open gates, floor-type cells, baskets | same (empty, open gates, floor-type, baskets) |
| Mirrors | Hook Deflector (M014) lanes only · Vanity Mirror (M086) lanes **and** beams | M086 only; Prism M089 splits beams; Prism lanes માટે blocker |
| Portals | follow | **follow નહીં** (beam stops) |
| Layer | thread ના layer | emitter ના layer |
| Heart | snag −1 | beam પોતે damage **નથી** આપતો (lane beam cell પર ⇒ snag) |

**Definitions:** (a) Moving thread નું lane pre-move beam set સામે evaluate થાય; beam Move દરમિયાન recompute **નથી** થતો. (b) Beam loop guard: visited `(cell, dir)` set; repeat ⇒ beam ends. (c) Beam renderer: [06 §4.3](./06_FRONTEND_AND_QA_PHASE_2.md).

## 7. Move Resolution Order (Phase 2 extended — standard §16.17)

Phase 1 order ([../phase_1/01 §5.5](../phase_1/01_GAME_CONCEPT_AND_RULES.md)) એ જ રહે; Phase 2 mechanics તેમાં નિશ્ચિત જગ્યાએ ઉમેરાય. Tap target પહેલાં (tap priority: interactive cell > thread, top layer first). Locked / tangled ⇒ locked tap, Move નહીં, stop.

| Step | Action |
|---|---|
| 1 | **Action resolve** on pre-move state: lane evaluate (diagonals, squeeze, portals/network, deflectors, bumpers, ramps, beams as blockers, dye pots) ⇒ Exit / Snag / Relocate / **Push** / **Segment exit** / **Split** / Interactive toggle / **Bubble pop**. Exit- and lane-triggered effects (keys/clasps, seesaw flips, worn-patch counts, lint trail placement, popper blasts, domino chains, guardian HP, quotas, pattern advance, ramp layer change) — **માત્ર exit / relocate પર; bumped Move માં lane-based કંઈ બદલાતું નથી** (§17.30). Parity mechanics (M021, M090, M096) increment **પહેલાંની** Move count વાપરે |
| 2 | `moveCount += 1` |
| 3 | **Counters tick** બરાબર આ ક્રમે: M007 → M017 → M031 → M025 (+ M098 Moving Guardian, same slot §17.32) → M027 → M047 → M041, પછી Phase 2: M057 → M058 → M063 → M067 → M068 → M075 → M079 → M082 → M090 → M096 |
| 4 | **Derived states recompute:** plates (M019/M055/M083), beams (M084/M086/M089), receivers (M085), fog, cages, locks, Master Jewel Clasp (M099) |
| 5 | **Heart loss** (Thimble Shield પહેલાં absorb) |
| 6 | **Win check** (all threads exited + goals: Sequins, Sorting Hem quotas) |
| 7 | **0-heart check** ⇒ Second Chance |

Animation (≤ 450 ms) result પર ચાલે; input queue = 1. Soft-lock (solver: no winning sequence) ⇒ "Stuck" sheet Restart, heart loss નહીં, `E-GAME-004` (§17.31).

## 8. Tier Table (standard §9.3)

| Tier | Levels | Grid | Threads (paths) | Max obstacle instances | D band |
|---|---|---|---|---|---|
| T5 (Phase 1, reference) | 401–500 | 10×10–11×11 | 22–30 | 6–10 | 38–52 |
| **P2-A** | 501–750 | 10×10–13×13 | 24–34 | 6–12 | 45–60 |
| **P2-B** | 751–1000 | 12×12–14×14 | 28–40 | 8–14 | 52–70 |

- Standard rule "Phase n+1 નો lowest band ≥ Phase n ના T-last mid": T5 mid = (38 + 52) / 2 = 45 ⇒ P2-A band **45 થી શરૂ** થાય (45–60). વિગત: [02 §5](./02_LEVEL_PROGRESSION_0501_1000.md).
- D formula unchanged: `D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S`. Phase 2 non-monotone (N) mechanics: M053–M055 push, M057, M058, M060, M063, M064, M068, M070, M075, M079, M081, M082, M087, M090, M091, M092, M093, M096, M098.
- x9 Hard = block high ×1.1; Finale = band high ×1.2 = **84** (standard §16.13).

## 9. Economy Changes in Phase 2 (only what the standard defines)

| Item | Phase 2 value | Standard ref |
|---|---|---|
| Craft Basket (Gift Box) L510, 520 … 990 | **300 Coins** + 1 booster by `(L/10) mod 3` (1 Needle Glow Hint, 2 Golden Scissors, 0 Thimble Shield) | §6.1 |
| Grand Sewing Chest (Phase Chest) L1000 | **1,000 Coins + 2 of each booster + Phase 2 badge** ("Heirloom Weaver"), Craft Basket ની જગ્યાએ | §6.1 |
| Golden Bobbin Rush (Coin Rush) | after L525, 550 … 1000 (first clear only); **30 threads**, 10/thread + 100 full clear ⇒ max **400** | §6.1, §16.9 |
| Clear coins | unchanged: Easy 15 · Normal 20 · Hard 30 · Finale 50; first ★★★ +20 | §6.1 |
| New sink | **Cosmetic skins / board themes 800–4,000 Coins** (Wardrobe) | §6.2 |
| New IAP | **Piggy Bank ₹49**, stored coins max 1,000 | §7.2 |
| Boosters, Heart Refill, Darning Patch, Spin, Daily, Streak, Ads, VIP, Coin packs | **unchanged** | §5–§8 |

Upper-bound arithmetic (computed, not measured): 10-level block = 8 Normal (160) + 1 Easy (15) + 1 Hard (30) = 205 clear Coins; all ★★★ = +200; Craft Basket 300; Golden Bobbin Rush 400 per 25 levels ⇒ 160 per 10 ⇒ max ≈ **86.5 Coins/level** (2X Win ads વગર). Real average analytics થી માપવો; standard sanity target ~60–70 Coins/level.

Album completion, Star Race prizes, Piggy rules અને cosmetic prices: [04](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md).

## 10. Phase 1 Mechanics in Phase 2 Boards

| Phase 1 mechanic | Phase 2 interaction (Definition) |
|---|---|
| M013 Spool Spinner, M034/M091 rotors, M045 | Diagonal `dir` 90° CW rotate (§3) |
| M015 Stitch Bridge / M042 | Diagonal lanes bridge cell પરથી પસાર થઈ શકે (bridge cells don't block lanes on other layer rule same) |
| M020 Yarn Basket | Diagonal lane basket cell પર પહોંચે ⇒ exit |
| M024 Chunky Chenille | Orthogonal only; heavy plate M083 holds |
| M026 Sequins | Diagonal lane collects |
| M032 Double Fabric Layers | M069 દ્વારા 3 layers સુધી extend |
| M040 Lamplight Evening | Zoom સાથે compatible; Phase 2 માં beam levels સાથે ન વાપરવું (readability) |
| M049 Guardian | M098 moving version; static M049 continues |

## 11. Edge Cases (Phase 2)

| # | Situation | Rule |
|---|---|---|
| E2-1 | Pinch શરૂ થાય ત્યારે 1st finger tap pending | Tap cancel, no Move |
| E2-2 | Pan દરમિયાન 350 ms હોલ્ડ | Peek **trigger નહીં** (movement > slop) |
| E2-3 | Diagonal lane exits exactly at board corner | Exit (next step off-board) |
| E2-4 | Crate push into a cell where beam ends | Beam cell is not a physical blocker for crates ⇒ push allowed; beam recomputed in tick step 4 |
| E2-5 | Lane passes a beam cell created by the moving thread's own exit | Not possible: beam pre-move evaluated (§6 a) |
| E2-6 | Board rotation (M079) while zoomed | View auto-fits (scale 1.0) before rotation animation |
| E2-7 | Golden Scissors on Bobbin Crate on Dock Plate | Crate removed ⇒ step 4 plate recompute ⇒ gate closes |
| E2-9 | Hint on board ≥ 12×12 | Glow target off-screen ⇒ view pans to target (250 ms) — camera move only |
| E2-10 | Sorting Hem (M062) goal impossible after a Move | Banner "Goal can't be met — try Restart"; no auto-fail |
| E2-11 | Bobbin Crate pushed toward an open board edge | Crate falls off and is removed (§17.29); walled edge ⇒ snag |
| E2-12 | Snag (bump) on a lane crossing dye / worn patch / seesaw / item | Nothing lane-based changes (§17.30): no recolor, no wear, no flip, no pickup, no quota, no Mimic update |
| E2-13 | Rotation (M013/M070/M079) or M081/M093 leaves needle pointing into own body | Thread "tangled" ⇒ locked tap until dir changes again (§17.39) |
| E2-14 | Max zoom | Cell 48 dp; touch slop 18 dp; Fit button; no double-tap zoom (§17.23) |

# 02 · Level Progression 0001–0500 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 1 ના 500 levels નું structure — tiers, 10-level block pattern, FTUE L1–10, booster tutorials, દરેક 50 blocks નું full table અને L500 Phase Finale.

**Related docs:** [Shared Core Standard §9](../../SHARED_CORE_STANDARD.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) · [04 Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md) · [05 Daily & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) · [Scaling to 10,000](../SCALING_TO_10000_LEVELS.md)

---

## 1. Principles (સિદ્ધાંતો)

- **દર 10 levels એ નવું:** દરેક block ના **x1** level પર નવું mechanic (L11, L21 … L491). કુલ 49 mechanics M001–M049 + L500 Finale.
- Difficulty ક્યારેય tier-to-tier ઘટે નહીં; block અંદર saw-tooth (x5 breather, x9 peak).
- દરેક level 0 hearts + 0 boosters થી solvable (CI validator). Hand-tuned: **L1–30, દરેક x1 intro, દરેક x9 Hard, L500 Finale**; બાકી generator (`tools/levelgen`) + designer review.
- Intro (x1) levels માં માત્ર intro mechanic + ≤ 1 જૂનું mechanic (validator).

## 2. Tier Table (Phase 1)

| Tier | Levels | Grid | Trains | Max obstacle instances | D band |
|---|---|---|---|---|---|
| FTUE-a | 1–3 | 4×4–5×5 | 2–4 | 0 | 1–4 |
| FTUE-b | 4–10 | 5×5–6×6 | 4–8 | 0 | 3–8 |
| T1 | 11–100 | 6×6–8×8 | 6–14 | 1–4 | 6–18 |
| T2 | 101–200 | 7×7–9×9 | 10–18 | 3–6 | 14–26 |
| T3 | 201–300 | 8×8–10×10 | 14–22 | 4–8 | 22–36 |
| T4 | 301–400 | 9×9–10×10 | 18–26 | 5–9 | 30–44 |
| T5 | 401–500 | 10×10–11×11 | 22–30 | 6–10 | 38–52 |

- Phase 1 max grid **11×11** ⇒ 360 dp phone પર (16 dp gutters) cell ≥ **29 dp** — zoom/pan Phase 1 માં નથી.
- FTUE targets: L1–3 optimal ≤ **4 Moves**, L4–10 ≤ **8 Moves** (CI). Analytics target: L1–3 median clear ≤ 10 s, L4–10 ≤ 20 s.

### 2.1 Difficulty score D
```
D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
P = trains, C = longest dependency chain (solver), O = obstacle instances,
N = non-monotone mechanic instances (lever, plate, switch, turntable, countdown …),
S = solution Moves − P (extra interactive Moves)
```
Generator level નો D slot target band (±3) માં ન હોય ⇒ reject. આ doc માં `C` = longest chain ની **dependency edges** ની સંખ્યા (બધી trains સ્વતંત્ર ⇒ C = 0) — FTUE D values એ રીતે compute કર્યા છે.

Slot bands (tier D band ને ત્રણ ભાગમાં): **low** = નીચલો ⅓, **mid** = વચ્ચેનો ⅓, **high** = ઉપલો ⅓. **x9 Hard** target = tier high-end × 1.10. **Finale** target = T5 high-end × 1.20 (≈ 62).

## 3. 10-Level Block Pattern (દર block `N1…N0`)

Level JSON માં બંને fields (standard §16.15): `slot` = block role, `tag` = coins label.

| Slot | Role | Difficulty | `slot` / `tag` (coins) |
|---|---|---|---|
| x1 | **Intro:** નવું mechanic, માત્ર એ જ obstacle, tutorial hand + tooltip card | low | `intro` / `normal` (20) |
| x2–x4 | Practice: નવું + જૂના mix | low → mid | `practice` / `normal` (20) |
| x5 | Breather | low | `breather` / `easy` (15) |
| x6–x8 | Ramp | mid → high | `ramp` / `normal` (20) |
| x9 | **Hard** level — red "Hard" badge on map node | high +10% | `hard` / `hard` (30) |
| x0 | Milestone — **Conductor's Gift Crate** | mid | `milestone` / `normal` (20) |

L500 = Phase Finale (Boss board, `slot` / `tag` = `finale` / `finale`, 50 coins) — Gift Crate ની જગ્યાએ **Grand Central Chest**.

## 4. FTUE Levels 1–10 (level-by-level)

FTUE માં કોઈ obstacle નથી ("clean tracks"). Ads: interstitial ક્યારેય નહીં (L1–10), gameplay banner L11 થી.

| L | Grid | Trains (cars) | Optimal Moves | C | D | Tutorial step (`ftue_step`) |
|---|---|---|---|---|---|---|
| 1 | 4×4 | 2 (2+2) | 2 | 1 | 2.7 | `tap_train`: hand points at free train ⇒ "Tap a train to send it to the station!" |
| 2 | 4×4 | 3 (2,2,3) | 3 | 1 | 3.3 | `route_peek`: "Press and hold a train to peek at its track" (green/red line) |
| 3 | 5×5 | 4 (2,2,3,3) | 4 | 1 | 3.9 | `hint_intro`: **Green Signal Hint (Hint)** — 3 free granted, forced first use |
| 4 | 5×5 | 4 | 4 | 2 | 5.4 | `hearts`: blocked train demo ⇒ tooltip "Blocked trains clack their buffers: −1 heart" (demo is shown as animation, player not forced to bump) |
| 5 | 5×5 | 5 | 5 | 1 | 4.5 | `breather` (tag easy) — "Any car works: tap engine or carriage" |
| 6 | 6×6 | 5 (with L-shaped train) | 5 | 2 | 6.0 | `curved_cars`: carriages on a bend follow the engine |
| 7 | 6×6 | 6 | 6 | 2 | 6.6 | `stars`: Level Complete explains ★★★ = no heart lost |
| 8 | 6×6 | 6 | 6 | 2 | 6.6 | `undo_intro`: **Reverse Gear Undo (Undo)** — 3 free; after the first Move a tooltip says "Changed your mind? Reverse Gear takes back your last Move (hearts don't come back)" and the player uses it once |
| 9 | 6×6 | 7 | 7 | 2 | 7.2 | none (FTUE peak, no Hard badge) |
| 10 | 6×6 | 8 | 8 | 1 | 6.3 | `gift_crate`: first **Conductor's Gift Crate** (150 coins + 1 Green Signal Hint) |

Starting wallet: **200 coins**; boosters granted at their tutorial: 3 Hint (L3), 3 Undo (L8), 1 Shield (L15), 1 Hammer (L25).

## 5. Booster & Feature Unlock Timeline

| Level | Unlock / event |
|---|---|
| L2 | Route Peek (free long-press) tutorial |
| L3 | **Green Signal Hint (Hint)** tutorial + 3 free |
| L8 | **Reverse Gear Undo (Undo)** tutorial + 3 free |
| L10 | First Conductor's Gift Crate · **Lucky Turntable unlock** (after clear) |
| L11 | First mechanic M001 Buffer Stop; gameplay banner starts |
| L15 | **Cowcatcher Shield (Shield)** tutorial + 1 free (x5 breather level: tooltip, activate before first tap) · **Daily Timetable Run unlock** (after clear) · Starter Pack offer window (48 h) · first eligible interstitial (L15 win) |
| L25 | **Track Crane (Hammer)** tutorial + 1 free (x5 breather: crane lifts one crate/train) · first Golden Express Coin Rush (after L25 clear) |
| L50 | Gift Crate first, then Coin Rush (no interstitial on this win) |
| L500 | Grand Central Chest + Coin Rush + Phase Complete screen |

Lucky Turntable (Spin) Home screen પર **L10 clear પછી** દેખાય (1 free/day; FTUE ને disturb ન કરે, standard §16.32).

## 6. Full Block Table (50 blocks)

`x0 reward` = Conductor's Gift Crate (coins + booster by `(L/10) mod 4`: 1=Hint, 2=Hammer, 3=Shield, 0=Undo). Coin Rush = **after** that level's clear (25 ના દરેક multiple). Grid / Trains / D band = tier values (CI enforced). Hard = x9 level (red badge, 30 coins).

| # | Levels | Tier | New mechanic at x1 | Grid | Trains | D band | x0 reward | Coin Rush | Hard (x9) |
|---|---|---|---|---|---|---|---|---|---|
| 1 | 1–10 | FTUE | — (FTUE: clean tracks, no obstacle) | 4×4–6×6 | 2–8 | 1–8 | L10: 150 + 1 Green Signal Hint | — | — (FTUE, no badge) |
| 2 | 11–20 | T1 | **M001** Buffer Stop (L11) | 6×6–8×8 | 6–14 | 6–18 | L20: 150 + 1 Track Crane | — | L19 |
| 3 | 21–30 | T1 | **M002** Cargo Crate Row (L21) | 6×6–8×8 | 6–14 | 6–18 | L30: 150 + 1 Cowcatcher Shield | after L25 | L29 |
| 4 | 31–40 | T1 | **M003** Snowed-In Train (L31) | 6×6–8×8 | 6–14 | 6–18 | L40: 150 + 1 Reverse Gear Undo | — | L39 |
| 5 | 41–50 | T1 | **M004** Ticket & Barrier (L41) | 6×6–8×8 | 6–14 | 6–18 | L50: 150 + 1 Green Signal Hint | after L50 | L49 |
| 6 | 51–60 | T1 | **M005** Colour Platform Gate (L51) | 6×6–8×8 | 6–14 | 6–18 | L60: 150 + 1 Track Crane | — | L59 |
| 7 | 61–70 | T1 | **M006** One-Way Rail (L61) | 6×6–8×8 | 6–14 | 6–18 | L70: 150 + 1 Cowcatcher Shield | — | L69 |
| 8 | 71–80 | T1 | **M007** Level Crossing (L71) | 6×6–8×8 | 6–14 | 6–18 | L80: 150 + 1 Reverse Gear Undo | after L75 | L79 |
| 9 | 81–90 | T1 | **M008** Tunnel Pair (L81) | 6×6–8×8 | 6–14 | 6–18 | L90: 150 + 1 Green Signal Hint | — | L89 |
| 10 | 91–100 | T1 | **M009** Signal Lever & Semaphores (L91) | 6×6–8×8 | 6–14 | 6–18 | L100: 150 + 1 Track Crane | after L100 | L99 |
| 11 | 101–110 | T2 | **M010** Steam Cloud (L101) | 7×7–9×9 | 10–18 | 14–26 | L110: 180 + 1 Cowcatcher Shield | — | L109 |
| 12 | 111–120 | T2 | **M011** Coupled Engines (L111) | 7×7–9×9 | 10–18 | 14–26 | L120: 180 + 1 Reverse Gear Undo | — | L119 |
| 13 | 121–130 | T2 | **M012** Cold Engine (L121) | 7×7–9×9 | 10–18 | 14–26 | L130: 180 + 1 Green Signal Hint | after L125 | L129 |
| 14 | 131–140 | T2 | **M013** Turntable (L131) | 7×7–9×9 | 10–18 | 14–26 | L140: 180 + 1 Track Crane | — | L139 |
| 15 | 141–150 | T2 | **M014** Curve Rail (L141) | 7×7–9×9 | 10–18 | 14–26 | L150: 180 + 1 Cowcatcher Shield | after L150 | L149 |
| 16 | 151–160 | T2 | **M015** Wooden Overpass (L151) | 7×7–9×9 | 10–18 | 14–26 | L160: 180 + 1 Reverse Gear Undo | — | L159 |
| 17 | 161–170 | T2 | **M016** Rock Pile (L161) | 7×7–9×9 | 10–18 | 14–26 | L170: 180 + 1 Green Signal Hint | — | L169 |
| 18 | 171–180 | T2 | **M017** Steam Pressure Train (L171) | 7×7–9×9 | 10–18 | 14–26 | L180: 180 + 1 Track Crane | after L175 | L179 |
| 19 | 181–190 | T2 | **M018** Track Switch (L181) | 7×7–9×9 | 10–18 | 14–26 | L190: 180 + 1 Cowcatcher Shield | — | L189 |
| 20 | 191–200 | T2 | **M019** Weighbridge Plate (L191) | 7×7–9×9 | 10–18 | 14–26 | L200: 180 + 1 Reverse Gear Undo | after L200 | L199 |
| 21 | 201–210 | T3 | **M020** Engine Shed (L201) | 8×8–10×10 | 14–22 | 22–36 | L210: 210 + 1 Green Signal Hint | — | L209 |
| 22 | 211–220 | T3 | **M021** Phantom Express (L211) | 8×8–10×10 | 14–22 | 22–36 | L220: 210 + 1 Track Crane | — | L219 |
| 23 | 221–230 | T3 | **M022** Shunting Train (L221) | 8×8–10×10 | 14–22 | 22–36 | L230: 210 + 1 Cowcatcher Shield | after L225 | L229 |
| 24 | 231–240 | T3 | **M023** Push-Pull Train (L231) | 8×8–10×10 | 14–22 | 22–36 | L240: 210 + 1 Reverse Gear Undo | — | L239 |
| 25 | 241–250 | T3 | **M024** Wide Load Freight (L241) | 8×8–10×10 | 14–22 | 22–36 | L250: 210 + 1 Green Signal Hint | after L250 | L249 |
| 26 | 251–260 | T3 | **M025** Handcar Patrol (L251) | 8×8–10×10 | 14–22 | 22–36 | L260: 210 + 1 Track Crane | — | L259 |
| 27 | 261–270 | T3 | **M026** Mail Sack Pickup (L261) | 8×8–10×10 | 14–22 | 22–36 | L270: 210 + 1 Cowcatcher Shield | — | L269 |
| 28 | 271–280 | T3 | **M027** Creeping Ivy (L271) | 8×8–10×10 | 14–22 | 22–36 | L280: 210 + 1 Reverse Gear Undo | after L275 | L279 |
| 29 | 281–290 | T3 | **M028** Timetable Order (L281) | 8×8–10×10 | 14–22 | 22–36 | L290: 210 + 1 Green Signal Hint | — | L289 |
| 30 | 291–300 | T3 | **M029** Table Edge Fence (L291) | 8×8–10×10 | 14–22 | 22–36 | L300: 210 + 1 Track Crane | after L300 | L299 |
| 31 | 301–310 | T4 | **M030** Colour Station Exit (L301) | 9×9–10×10 | 18–26 | 30–44 | L310: 250 + 1 Cowcatcher Shield | — | L309 |
| 32 | 311–320 | T4 | **M031** Last Call Exit (L311) | 9×9–10×10 | 18–26 | 30–44 | L320: 250 + 1 Reverse Gear Undo | — | L319 |
| 33 | 321–330 | T4 | **M032** Viaduct Deck (L321) | 9×9–10×10 | 18–26 | 30–44 | L330: 250 + 1 Green Signal Hint | after L325 | L329 |
| 34 | 331–340 | T4 | **M033** Locked Siding (L331) | 9×9–10×10 | 18–26 | 30–44 | L340: 250 + 1 Track Crane | — | L339 |
| 35 | 341–350 | T4 | **M034** Rotating Yard 2x2 (L341) | 9×9–10×10 | 18–26 | 30–44 | L350: 250 + 1 Cowcatcher Shield | after L350 | L349 |
| 36 | 351–360 | T4 | **M035** Depot Dispatcher (L351) | 9×9–10×10 | 18–26 | 30–44 | L360: 250 + 1 Reverse Gear Undo | — | L359 |
| 37 | 361–370 | T4 | **M036** Coal Tender (L361) | 9×9–10×10 | 18–26 | 30–44 | L370: 250 + 1 Green Signal Hint | — | L369 |
| 38 | 371–380 | T4 | **M037** Sand Drift (L371) | 9×9–10×10 | 18–26 | 30–44 | L380: 250 + 1 Track Crane | after L375 | L379 |
| 39 | 381–390 | T4 | **M038** Jump Ramp (L381) | 9×9–10×10 | 18–26 | 30–44 | L390: 250 + 1 Cowcatcher Shield | — | L389 |
| 40 | 391–400 | T4 | **M039** Twin Expresses (L391) | 9×9–10×10 | 18–26 | 30–44 | L400: 250 + 1 Reverse Gear Undo | after L400 | L399 |
| 41 | 401–410 | T5 | **M040** Night Run (L401) | 10×10–11×11 | 22–30 | 38–52 | L410: 300 + 1 Green Signal Hint | — | L409 |
| 42 | 411–420 | T5 | **M041** Rainbow Engine (L411) | 10×10–11×11 | 22–30 | 38–52 | L420: 300 + 1 Track Crane | — | L419 |
| 43 | 421–430 | T5 | **M042** Rickety Trestle (L421) | 10×10–11×11 | 22–30 | 38–52 | L430: 300 + 1 Cowcatcher Shield | after L425 | L429 |
| 44 | 431–440 | T5 | **M043** Multi-Ticket Barrier (L431) | 10×10–11×11 | 22–30 | 38–52 | L440: 300 + 1 Reverse Gear Undo | — | L439 |
| 45 | 441–450 | T5 | **M044** Bend Tunnel (L441) | 10×10–11×11 | 22–30 | 38–52 | L450: 300 + 1 Green Signal Hint | after L450 | L449 |
| 46 | 451–460 | T5 | **M045** Master Gear Lever (L451) | 10×10–11×11 | 22–30 | 38–52 | L460: 300 + 1 Track Crane | — | L459 |
| 47 | 461–470 | T5 | **M046** Loop Line Train (L461) | 10×10–11×11 | 22–30 | 38–52 | L470: 300 + 1 Cowcatcher Shield | — | L469 |
| 48 | 471–480 | T5 | **M047** Auto-Coupler Freight (L471) | 10×10–11×11 | 22–30 | 38–52 | L480: 300 + 1 Reverse Gear Undo | after L475 | L479 |
| 49 | 481–490 | T5 | **M048** Convoy Group (L481) | 10×10–11×11 | 22–30 | 38–52 | L490: 300 + 1 Green Signal Hint | — | L489 |
| 50 | 491–500 | T5 | **M049** Clock Tower Guardian (L491) | 10×10–11×11 | 22–30 | 38–52 | L500: **Phase Chest:** 1,000 + 2× each booster + badge | after L500 | L499 |

**Totals:** 49 mechanics · 49 Hard levels (L19…L499) · 49 Gift Crates (L10…L490) + 1 Grand Central Chest (L500) · 20 Coin Rushes (after L25, 50, 75 … 500).

### 6.1 Example block walkthrough — Block 2 (L11–20, M001 Buffer Stop)

| L | Slot | Content |
|---|---|---|
| 11 | x1 Intro | 6×6, 6 trains, 1 Buffer Stop. Tutorial hand: "Buffer Stops block the track. Send the other train first." |
| 12–14 | Practice | 6×6–7×7, 7–9 trains, 1–2 Buffer Stops |
| 15 | Breather + Shield tutorial | 6×6, 7 trains, 1 Buffer Stop, tag easy |
| 16–18 | Ramp | 7×7, 9–11 trains, 2–3 Buffer Stops, longer chains |
| 19 | Hard | 8×8, 12 trains, 3 Buffer Stops, D ≈ 19.8 ±3 |
| 20 | Milestone | 7×7, 10 trains — Gift Crate 150 + 1 Track Crane |

### 6.2 Tier notes (designer guidance)

| Tier | Focus |
|---|---|
| T1 (11–100) | Static blockers, keys, colours, one-way, first counters/portals/levers. Chains short (C ≤ 4) |
| T2 (101–200) | Visibility (Steam Cloud), multi-train linking, interactive direction changes (Turntable, Track Switch, Weighbridge) |
| T3 (201–300) | Train variants (Phantom, Shunting, Push-Pull, Wide Load), patrol & growth counters, Mail Sacks goal |
| T4 (301–400) | Edge rules (fence/colour/last call), layers, rotation, spawning, Sand Drift & Jump Ramp lane modifiers |
| T5 (401–500) | Night Run, Rainbow Engine colour cycling, fragile/multi-lock, gear levers, Loop Line, convoys, Guardian |

## 7. L500 — Phase 1 Finale: "Grand Central Rush Hour"

| Field | Value |
|---|---|
| Tag | `finale` (50 coins first clear) |
| Grid | 11×11 |
| Trains | 28 (engine + 1–4 carriages) |
| Boss | **M049 Clock Tower Guardian** — 3×3 at centre `(4,4)–(6,6)`, HP 6 (6 linked trains, gold clock-hand badge) |
| Mechanics (≥ 8) | M004 Ticket & Barrier ×1, M008 Tunnel Pair ×1, M009 Signal Lever & Semaphores ×1, M013 Turntable ×1, M018 Track Switch ×1, M026 Mail Sack Pickup ×2, M029 Table Edge Fence ×1, M042 Rickety Trestle ×1 (+ Guardian) = 10 instances |
| D target | ≈ 62 ±3 (T5 high 52 × 1.2). Example: P 28, C 8, O 10, N 3, S 4 ⇒ 16.8 + 12 + 20 + 9 + 4 = **61.8** |
| Solution | ~32 Moves (28 exits + lever + turntable + switch + 1 re-toggle); solver-verified, 0 hearts, 0 boosters |
| Flow | Act 1 (outer ring trains + Mail Sacks) ⇒ Act 2 (lever/switch/turntable routing through Tunnel Pair) ⇒ Act 3 (6 linked trains exit, Clock Tower chimes per HP, vanishes, last 4 trains depart through centre) |
| Hearts/revive | Standard 3 hearts, standard revive rules |
| Rewards | **Grand Central Chest**: 1,000 coins + 2 each booster (2 Hint, 2 Undo, 2 Shield, 2 Hammer) + "Phase 1 Conductor" badge; then Golden Express Coin Rush; then Phase Complete screen (06) |
| Ads | No interstitial on this win (reward screens defer) |

## 8. Level Content Rules (CI checklist summary)

- Solvable 0 hearts / 0 boosters (solver, node limit 2M, depth ≤ 3×P).
- D in slot band ±3; grid/trains/obstacle count within tier.
- No train initially locked forever (every lock has a reachable unlock).
- Min cell ≥ 29 dp at 360 dp width.
- Intro levels: only the intro mechanic + ≤ 1 earlier mechanic.
- `solution` + `par_moves` stored in JSON (Hint, Tuesday Par).
- Levels shipped as `assets/levels/phase_1.json.gz` (schema v3, 03 JSON examples).

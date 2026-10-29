# 01 · Phase 2 Scope & Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 2 (L501–1000) માં core rules માં થતા **ઉમેરા** — pinch-zoom & pan, diagonal trains, 3 layers, Push Carts, Signal Lamp light beams (lanes vs beams), Phase 2 tick order, P2-A/P2-B tiers, economy deltas અને cosmetics shop.

**Related docs:** [Shared Core Standard §2, §9, §10, §16](../../SHARED_CORE_STANDARD.md) · [Phase 1 Rules](../phase_1/01_GAME_CONCEPT_AND_RULES.md) · [Phase 2 README](./README.md) · [02 Progression](./02_LEVEL_PROGRESSION_0501_1000.md) · [03 Catalog](./03_OBSTACLE_CATALOG_PHASE_2.md) · [04 LiveOps](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [06 Frontend & QA](./06_FRONTEND_AND_QA_PHASE_2.md)

> ⚖️ Phase 1 ના બધા rules ([01](../phase_1/01_GAME_CONCEPT_AND_RULES.md) §5–§8) યથાવત્: tap → exit, bump −1 heart, locked tap (no heart, no Move), input queue = 1, Route Peek મફત, 0 hearts / 0 boosters solvable, wall-clock timer નહીં. આ doc માત્ર ઉમેરા લખે છે. Standard સાથે વિરોધ દેખાય તો **standard સાચું**.

---

## 1. Phase 2 at a Glance

| Rule area | Phase 2 addition | Section |
|---|---|---|
| Camera | Pinch-zoom + pan on boards ≥ 12×12, auto-fit start | §2 |
| Directions | 8 directions (diagonal from M051, L511) | §3 |
| Layers | Ground / mid / top (M069, L691) + Viaduct Ramp (M056) | §4 |
| Push physics | Push Cart (M053) + Frosty Rails (M054) + cart plates | §5 |
| Light | Signal Lamp beams (M084+) — beams ≠ lanes | §6 |
| Move definition | Push, swap, split, uncouple, unstick = Moves | §7 |
| Tick order | Phase 2 counters appended to Phase 1 order | §7.2 |
| Dead-end | "Track jammed" sheet when win unreachable | §8 |
| Tiers | P2-A, P2-B | §9 |
| Economy | Gift Crate 300, L1000 Chest, cosmetics, Piggy | §10–§11 |

## 2. Pinch-Zoom & Pan (ઝૂમ અને પૅન)

Phase 1 નું max 11×11 board 360 dp phone (16 dp gutters) પર cell ≥ 29 dp આપે છે. Phase 2 ના 12×12–14×14 boards પર fit-scale cell 29 dp થી નાનું થાય ⇒ **zoom/pan ફરજિયાત** (standard §9.3).

| Grid | Fit cell @ 360 dp (328 dp usable) | Zoom/pan |
|---|---|---|
| 10×10 | 32.8 dp | Off (Phase 1 જેવું) |
| 11×11 | 29.8 dp | Off |
| 12×12 | 27.3 dp | **On** |
| 13×13 | 25.2 dp | **On** |
| 14×14 | 23.4 dp | **On** |

Rules:
1. **Auto-fit start:** level start, Restart અને Revive પછી board આખું દેખાય (scale 1.0 = fit).
2. **Range:** min scale 1.0 (fit) — fit થી નાનું નહીં; max scale = `48 dp / fitCell` (દા.ત. 14×14 ⇒ ≈ 2.05×). Cell 48 dp થી મોટું નહીં.
3. **Gestures:** 2-finger pinch = zoom (focal point આસપાસ); 1-finger drag (slop ≥ 8 dp) **અથવા** 2-finger drag = pan, માત્ર scale > 1.0 હોય ત્યારે. Drag slop પાર થાય ⇒ tap અને Route Peek long-press cancel.
4. **Not a Move:** zoom, pan, fit-reset Move નથી, counters tick નથી કરતા, heart પર અસર નથી (standard §1).
5. **Fit button:** HUD પર "⤢ Fit" button (scale > 1.0 હોય ત્યારે જ દેખાય) ⇒ 250 ms animate to fit.
6. **Pan bounds:** board edge ની બહાર max 24 dp overscroll; board હંમેશા viewport માં.
7. **No auto-camera on Moves:** train exit/bump વખતે camera ખસતો નથી (player નિયંત્રણમાં). **Exception:** Green Signal Hint (Hint) target viewport ની બહાર હોય ⇒ camera 300 ms માં target ને center કરે (Hint પછી).
8. **Route Peek at zoom:** preview line viewport ની બહાર જાય ⇒ viewport edge પર arrow chip "→ track continues".
9. **Input during animation:** zoom/pan animation દરમિયાન પણ ચાલુ; tap queue rule (1) યથાવત્.
10. **Off-screen indicators:** viewport ની બહાર counters (Alternating Signal 1 Move બાકી, Creeping Steam next spread) હોય ⇒ edge પર small pulse dot.

Tutorial: L501 (pinch), L502 (pan), L503 (Route Peek at zoom), L504 (Hint auto-pan), L505 (Fit button) — [02 §3](./02_LEVEL_PROGRESSION_0501_1000.md).

## 3. Diagonal Trains (ત્રાંસી ટ્રેનો) — from M051 (L511)

### 3.1 Directions
| `dir` | Vector `(dx, dy)` | Arrow | Phase |
|---|---|---|---|
| `U` / `D` / `L` / `R` | (0,−1) / (0,1) / (−1,0) / (1,0) | ↑ ↓ ← → | 1 |
| `UL` / `UR` | (−1,−1) / (1,−1) | ↖ ↗ | 2 |
| `DL` / `DR` | (−1,1) / (1,1) | ↙ ↘ | 2 |

90° CW rotation (turntables, Roundhouse Lever, Spinning Playmat, Bend Tunnel): `(dx, dy) → (−dy, dx)` ⇒ `U→R→D→L→U`, `UR→DR→DL→UL→UR`.

### 3.2 Diagonal lane & body
- **Exit lane** = head cell થી `(dx, dy)` steps, board બહાર જાય ત્યાં સુધી (x **અથવા** y બહાર જાય એ પહેલું). Diagonal train corner પરથી table ની બહાર નીકળે.
- **Body:** consecutive cars **king-adjacent** (`max(|Δx|, |Δy|) = 1`). Body orthogonal અને diagonal steps mix કરી શકે (વળાંકવાળો track). Length 2–5 (engine + 1–4 carriages) — Phase 1 જેવું.
- **Coupling-cross rule (game definition):** diagonal step `c → c + (dx, dy)` **blocked** ગણાય જો બે corner cells `c + (dx, 0)` અને `c + (0, dy)` **એક જ train ના consecutive cars** હોય (એ train નું diagonal coupling lane ને કાપે છે). એ સિવાય diagonal step માત્ર destination cell તપાસે (corner squeeze rule નથી).
- Route Peek diagonal line બતાવે; coupling-cross block પર ✕ coupling ના મધ્યમાં.

### 3.3 Phase 1 mechanics with diagonal lanes
| Mechanic | Diagonal lane behaviour |
|---|---|
| M005 Colour Platform Gate, M004/M043 barriers, blockers, sacks, coal | Cell-based — diagonal lane એ જ રીતે interact કરે |
| M006 One-Way Rail | Arrow orthogonal ⇒ diagonal lane = "not arrow direction" ⇒ **bump** |
| M014 Curve Rail, M018 Track Switch | Orthogonal-only tiles ⇒ diagonal lane **bump** (diagonal માટે M052 Corner Buffer) |
| M008 Tunnel Pair, M076 Tunnel Network | Same `dir` માં ચાલુ (diagonal પણ) |
| M044 Bend Tunnel, M013 Turntable, M045, M070, M079 | 90° CW rotation §3.1 |
| M015/M042 bridges, M032/M069 layers | Cell-based, unchanged |
| M024 Wide Load Freight | **Orthogonal only** (validator) |
| M038 Jump Ramp | Diagonal lane પણ આગલો 1 cell (diagonal) કૂદે |

## 4. Layers (લેયર્સ) — up to 3 (M069, L691)

| Layer | Index | Theme |
|---|---|---|
| Ground | 0 | Tabletop track |
| Mid | 1 | Viaduct Deck (M032 નું upper) |
| Top | 2 | Triple-Deck top viaduct (M069) |

- **Lock:** lower-layer train **locked** જ્યાં સુધી તેનો કોઈપણ body cell ઉપરના **કોઈ પણ** layer ની train થી ઢંકાયેલો હોય (M032 rule 3 layers સુધી વિસ્તૃત).
- **Lanes interact only within own layer** (trains, blockers, gates `params.layer`).
- **Tap priority:** overlap cell ⇒ ઊંચામાં ઊંચું layer (standard §2.9). Interactive cell > train car (standard §16.19).
- **Viaduct Ramp (M056):** lane ramp cell માં પ્રવેશે ⇒ બાકીનો lane બીજા layer પર ચાલે ([03 M056](./03_OBSTACLE_CATALOG_PHASE_2.md)).
- **Beams** emitter ના layer પર જ ચાલે (§6).
- Track Crane (Hammer) ઢંકાયેલી train target ન કરી શકે (standard §16.8).
- Render: ground → mid → top; ઢંકાયેલી train 30% darker tint + lock badge.

## 5. Push Carts (ધક્કો મારતા carts) — M053, L531

**Push resolution** (train tap, step 1 of Move):
1. Lane trace કરો; **પહેલો blocking item** Push Cart હોય ⇒ push check.
2. Cart ની પાછળનો cell (lane direction માં, diagonal પણ) **free** હોય ⇒ cart 1 cell ખસે, **train પોતાની જગ્યાએ રહે**, **1 Move**, **no heart**.
3. પાછળનો cell free ન હોય ⇒ સામાન્ય **bump** (−1 heart).
4. Cart Frosty Rails (M054) પર આવે ⇒ free cells પર સરકતું રહે; પહેલા non-free cell પહેલાં અથવા non-ice cell પર પહોંચે ત્યાં અટકે; open edge પાર કરે ⇒ Toy Box માં પડે.
5. **Design note:** push પછી પણ cart ધક્કો મારનાર train ના lane માં જ છે ⇒ એ train ને પછી નીકળવા વધુ pushes (open edge સુધી), બીજી train નો lateral push, rotation, અથવા switch જોઈએ. Validator 0-heart solution ચકાસે.

**Free cell (cart માટે, game definition — whitelist):** board ની અંદર, same layer પર કોઈ train body / cart / smoke (M068) નહીં, અને cell = **ખાલી floor** અથવા આમાંનું એક floor tile: plates (M019/M055/M083), Frosty Rails (M054), Paint / Mixer (M059/M094), Jam (M087), Sand Drift (M037), Mail Sack (M026), Hidden Ticket (M065), Conveyor (M082), intact Worn Sleepers (M067). બાકીનું બધું (blockers, gates, sheds, tunnels, mirrors, Corner Buffers, ramps, lamps, sensors, prisms, magnets, rails/switches, holes) **not free**. **Open board edge** (fence વગરની) cart ની પાછળ હોય ⇒ cart table પરથી Toy Box માં પડી જાય (removed) — નહીં તો ધક્કો મારનાર train નો lane કાયમ cart થી blocked રહે. Walled edge (M029 fence, M078 Island Station, બંધ M031/M071/M095 segment) ⇒ **not free** ⇒ bump.

Cart = blocker for lanes & beams; **hammerable: true** (standard §16.18). Cart Move પછી derived states (plates, beams) step 4 માં recompute.

## 6. Signal Lamp Light Beams (લાઇટ beams) — M084, L841

**Lanes vs beams:** *lane* = train નો exit track (Move વખતે trace થાય). *Beam* = Signal Lamp (emitter) માંથી નીકળતી સ્થિર light line, **step 4** (derived states) માં દર Move પછી recompute થાય.

| Rule | Value |
|---|---|
| Beam direction | Emitter `params.dir` — **orthogonal only** (`U/D/L/R`) |
| Beam stops at | પહેલો train car (same layer), blocker, Push Cart, closed gate, emitter, board edge. Receiver (M085) beam "hit" થાય અને ત્યાં અટકે |
| Beam passes over | Empty floor, open gates, plates, ice, paint, jam, sand, sacks, tickets, One-Way Rail, Curve Rail (**no turn**), Track Switch (no turn) |
| Beam turns at | **M086 Signal Mirror** only (90°). Beam-carrying mirror/prism cell = beam cell for lanes (lane entering ⇒ bump) |
| Beam splits at | **M089 Crystal Prism** (two ±90° beams) |
| Portals / sheds | Beam **અટકે** (tunnels light pass નથી કરતી) |
| Beam as lane blocker | Lane કોઈ beam cell માં પ્રવેશે ⇒ **bump** (−1). Lane trace beam state **as of previous step 4** વાપરે |
| Beam & exiting train | Train beam ને રોકતી હોય અને exit થાય ⇒ step 4 માં beam લાંબો થાય (એ જ Move ના lane ને અસર નહીં) |
| Loops | Mirrors થી loop ⇒ `(cell, dir)` visited-set; repeat ⇒ beam ત્યાં અટકે |
| Layers | Beam emitter ના layer પર જ |
| Hammer | Emitter / mirror / prism / receiver **not hammerable**; beam itself target નથી |

Render: beam = 2 strokes (wide 25% alpha glow + 2 dp core), **pre-baked** — per-frame blur નહીં ([06 §5](./06_FRONTEND_AND_QA_PHASE_2.md)). Colour-blind: beam પર moving dash pattern (Reduce motion ⇒ static dash).

## 7. Moves & Tick Order (Phase 2)

### 7.1 New Move types
Phase 1 Moves (exit, bump, interactive tap, Cold Engine wake, Sand Drift stop) ઉપરાંત — દરેક = **1 Move**, counters tick કરે:

| Move | Mechanic |
|---|---|
| Push (train stays, cart moves) | M053/M054 |
| Swap Platform tap | M060 |
| Roundhouse Lever / Girder lever / Gear-style lever tap | M070, M074 |
| Rotating Yard 3×3 tap | M091 |
| Jam unstick (1st tap) | M087 |
| Uncouple (front segment departs) | M092 |
| Split | M093 |
| Cushion pop by a bumping train (no heart) | M073 |

Zoom/pan/Fit, Route Peek, boosters, pause = Move નથી.

### 7.2 Tick order (standard §16.17 — binding)
દરેક Move:
1. **Action resolve** — exit / bump / push / interactive state change / relocate. Paint, seesaw flip, ticket collect, trail creation, quota count આ step માં (માત્ર completed lanes).
2. `moveCount += 1`.
3. **Counters tick** (fixed order): M007 → M017 → M031 → M025 → M027 → M047 → M041 → **M057 → M058 → M063 → M067 → M068 → M075 → M079 → M082 → M090 → M096**.
4. **Derived states** — plates (M019/M055/M083), beams (M084–M086/M089) & receivers, fog/steam (M010/M075), cages, locks (M004/M043/M080/M088/M099), guardian HP.
5. **Heart loss** (Cowcatcher Shield પહેલાં absorb).
6. **Win check.**
7. **0-heart check.**

Parity mechanics (M021, M090, M096) Move increment **પહેલાં** ની parity વાપરે. M090/M096 ની "tick" step 3 માં માત્ર visual state update છે; lane check step 1 માં pre-increment parity થી થાય.

### 7.3 Completed vs bump lanes (game definition)
Paint (M059/M094), Seesaw flip (M064), Hidden Ticket collect (M065), Worn Sleepers pass count (M067), Smoke Trail (M068), Quota counts (M062/M071/M095) — **માત્ર completed lanes** (exit અથવા relocate) થી. Bump lane (train પાછી roll) કોઈ state બદલતો નથી — Phase 1 M026 "bump lanes collect નથી કરતા" જેવું જ.

## 8. Dead-End Rule — "Track Jammed" (game definition)

Win શક્ય ન રહે એવી state (દા.ત. બધી trains નીકળી ગઈ પણ Delivery Platform quota બાકી, Colour Timetable નો જરૂરી colour હવે board પર નથી, Twin barriers અલગ Moves માં ખૂલ્યા વગર કાયમ બંધ) step 6 પછી detect થાય ⇒ **"Track jammed"** sheet: [Reverse Gear Undo] [Restart]. Heart કપાતું નથી, Level Failed screen નથી, Restart મફત. Validator ensures 0-heart solution exists; આ sheet માત્ર ખોટા ક્રમ પછી દેખાય.

## 9. Tier Table — Phase 2 (standard §9.3)

| Tier | Levels | Grid | Trains | Max obstacle instances | D band |
|---|---|---|---|---|---|
| P2-A | 501–750 | 10×10–13×13 | 24–34 | 6–12 | 44–60 |
| P2-B | 751–1000 | 12×12–14×14 | 28–40 | 8–14 | 52–70 |

Slot bands (Phase 1 convention, band ને ત્રણ ભાગ):

| Tier | low | mid | high | x9 Hard target (high × 1.1) | Finale target (high × 1.2) |
|---|---|---|---|---|---|
| P2-A | 44–49.3 | 49.3–54.7 | 54.7–60 | **66** | — |
| P2-B | 52–58 | 58–64 | 64–70 | **77** | **84** (L1000) |

- D formula યથાવત્: `D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S` (C = dependency edges, standard §16.16). Generator ±3 tolerance.
- Non-decreasing check: P2-A low (44) ≥ T5 mid lower bound (42.7) ✓.
- L501–510 onboarding = **12×12** બધા (P2-A range ની અંદર).
- Min cell rule (≥ 29 dp) માત્ર Phase 1 grids માટે; Phase 2 માં ≥ 12×12 ⇒ zoom ફરજિયાત, ≤ 11×11 ⇒ ≥ 29 dp ચકાસાય.
- N (non-monotone) count કયા Phase 2 mechanics માં ગણાય: [03 §2](./03_OBSTACLE_CATALOG_PHASE_2.md) "N?" column.

## 10. Economy Changes in Phase 2 (માત્ર standard માં લખેલા)

| Item | Phase 2 value | Standard ref |
|---|---|---|
| Conductor's Gift Crate (L510–990) | **300 coins** + 1 booster `(L/10) mod 4` (1 = Green Signal Hint, 2 = Track Crane, 3 = Cowcatcher Shield, 0 = Reverse Gear Undo) | §6.1 |
| Grand Central Chest (L1000) | **1,000 coins** + 2 Hint + 2 Undo + 2 Shield + 2 Hammer + "Phase 2 Conductor" badge — Gift Crate ની જગ્યાએ | §6.1 |
| L1000 reward order | Grand Central Chest → Golden Express Coin Rush → Phase Complete | §16.20 |
| Golden Express Coin Rush | After L525, 550 … 1000 (first clear only), **30 trains**, 10/train, +100 full clear ⇒ max 400 | §6.1, §16.9 |
| Clear coins | Easy 15 / Normal 20 / Hard 30 / Finale 50 (L1000), first ★★★ +20 | §6.1 |
| Cosmetics (new sink) | Train liveries + board themes **800–4,000 coins** | §6.2 |
| Piggy Bank (new IAP) | ₹49 consumable, stored coins **max 1,000** | §7.2 |

યથાવત્: booster prices/caps, Heart Refill 120 (max 2/attempt), ad revive 1/level, Daily +100, Express Streak ladder, Lucky Turntable odds, ads rules, VIP Conductor Pass ₹20/month auto-renewing, coin packs, Starter Pack.

## 11. Cosmetics Shop (નવો coin sink)

Shop માં નવો **"Liveries & Tables"** tab (L10 clear પછી). Full catalog + prices: [04 §5](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md).

- 6 train liveries + 3 board themes, 800–4,000 coins; 1 VIP-only livery (VIP Conductor Pass active હોય ત્યાં સુધી).
- **Gameplay-neutral:** livery train નો **gameplay colour, pattern અને engine icon બદલતી નથી** (colour-blind safety) — માત્ર material, chimney/cab shape, trim, whistle sound. Board theme grid contrast ≥ 3:1 રાખે.
- Coins only (IAP થી સીધી ખરીદી નહીં). Purchase = op-log op (offline OK, [05](./05_OFFLINE_AND_CLOUD_SYNC.md)).

## 12. Theme Glossary Additions (Generic → Train term)

| Generic | Toy Trains term |
|---|---|
| Diagonal path | Diagonal Express |
| Push Block / Ice Floor | Push Cart / Frosty Rails |
| Laser Emitter / Receiver / Beam Mirror / Prism | Signal Lamp / Light Sensor Box / Signal Mirror / Crystal Prism |
| Laser beam | Light beam |
| Three Layers | Triple-Deck Viaduct (ground / mid / top) |
| Moving Guardian | Marching Clock Tower |
| Sticker Album | Depot Sticker Album |
| Weekly Star Race | Weekly Star Race (race-track HUD with 5 toy engines) |
| Piggy Bank | Piggy Bank (wooden piggy money box) |
| Cosmetic skins / board themes | Liveries / Table themes |
| Phase 2 Finale | Grand Terminus Finale (L1000) |
| All M051–M099 names | [03 catalog](./03_OBSTACLE_CATALOG_PHASE_2.md) |

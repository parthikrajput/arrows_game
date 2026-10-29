# 01 — Phase 2 Scope & Rule Additions
> Phase 2 (L501–1000) માં core rules પર ઉમેરાતા નિયમો: pinch-zoom & pan, diagonal snakes, 3 layers, push blocks, sunbeams (lanes vs beams), P2 tier table, Phase 2 economy changes અને Remote Config.

**Related docs:** [Phase 2 index](./README.md) · [Shared Core Standard §2, §9–§10, §16](../../SHARED_CORE_STANDARD.md) · [Phase 1 Rules](../phase_1/01_GAME_CONCEPT_AND_RULES.md) · [02 Progression](./02_LEVEL_PROGRESSION_0501_1000.md) · [03 Catalog](./03_OBSTACLE_CATALOG_PHASE_2.md) · [04 LiveOps](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [06 Frontend & QA](./06_FRONTEND_AND_QA_PHASE_2.md)

---

## 1. Overview (શું બદલાતું નથી, શું ઉમેરાય છે)
**બદલાતું નથી (standard §2–§8):** tap → slither out, blocked → head bonk (−1 Heart Berry), 3 hearts, Second Chance (ad revive level દીઠ 1, Heart Berry Refill 120 coins × max 2/attempt), stars, 4 boosters + free Tongue-Flick Preview (prices, caps), turn-based (wall-clock timer માત્ર Golden Slither Rush), no forced damage, locked taps, input queue 1, interstitial rules, VIP ₹20/month.

**ઉમેરાય છે:**
| # | Addition | Section | First level |
|---|---|---|---|
| 1 | Pinch-zoom + pan (boards ≥ 12×12) | §2 | L501 |
| 2 | Diagonal snakes (8 directions) | §3 | L511 (M051) |
| 3 | Three layers (Ground / Canopy / Treetop) | §4 | L691 (M069) |
| 4 | Push Blocks (Rolling Coconut) + slide/plates | §5 | L531 (M053) |
| 5 | Sunbeams (beam emitters, receivers, mirrors, prisms) | §6 | L841 (M084) |
| 6 | P2-A / P2-B tiers | §7 | L501 |
| 7 | Economy: Gift Basket 300, L1000 Chest, Cosmetics sink, Piggy Bank | §8 | Update |
| 8 | Phase 2 tick order | §10 | L571 (M057) |

## 2. Pinch-Zoom & Pan
### 2.1 When
- Board `max(W, H) ≥ 12` ⇒ zoom + pan **enabled**. 10×10 / 11×11 Phase 2 boards Phase 1 જેવા auto-fit, zoom નહીં.
- Level start: **auto-fit** (આખું board દેખાય, scale = `fitScale`). Settings → "Remember zoom" OFF (default) ⇒ દરેક attempt auto-fit થી.

### 2.2 Gestures (tap સાથે conflict વગર)
| Gesture | Action | Move? |
|---|---|---|
| 1-finger tap (slop ≤ 18 dp, < 350 ms) | Snake / obstacle tap (Phase 1 rules) | Phase 1 મુજબ |
| 1-finger long-press ≥ 350 ms, slop ≤ 18 dp | Tongue-Flick Preview | ❌ |
| 1-finger drag > 18 dp (zoomed in હોય ત્યારે) | Pan; tap/preview cancel | ❌ |
| 1-finger drag at `fitScale` | Ignore (pan કરવા જેવું કંઈ નથી) | ❌ |
| 2-finger pinch | Zoom (focal point = fingers' midpoint) | ❌ |
| 2-finger drag | Pan | ❌ |
| Double-tap | **કોઈ zoom નહીં** (બે taps = બે game taps; accidental zoom ટાળવા) | — |
| "Fit" button (HUD top-right, 🔍) | Animate to `fitScale` 250 ms | ❌ |

- Zoom/pan = Move નથી (standard §1). Animation દરમિયાન zoom/pan allowed; tap queue rule (input queue 1) યથાવત.
- Second finger નીચે આવે ⇒ pending 1-finger tap/long-press **cancel** (pinch શરૂ).

### 2.3 Limits
| Parameter | Value |
|---|---|
| `minScale` | `fitScale` (board કરતાં નાનું zoom-out નહીં) |
| `maxScale` | cell size **48 dp** થાય તે scale (standard §17.23) |
| Pan bounds | Board edge viewport માં ઓછામાં ઓછું 24 dp અંદર રહે; બહાર overscroll નહીં (rubber-band 40 dp, release પર snap back) |
| Exit animation | Snake viewport બહાર જાય તો camera ખસતો **નથી** (motion sickness ટાળવા); exit edge પર 300 ms leaf-puff indicator |
| Bump | Blocker viewport બહાર હોય ⇒ screen edge પર red chevron 400 ms (blocker ની દિશામાં) |
| Hint target off-screen | Camera 300 ms ease માં target ને center કરે (scale બદલાય નહીં, unless target cell < 29 dp ⇒ scale ઉપર જેથી cell = 36 dp) |

### 2.4 Cell Size Rule (Phase 2)
Standard §12 નો "min cell ≥ 29 dp" rule Phase 1 grids માટે છે. Phase 2 grids માટે આ game નો rule (CI validator, reference viewport 360 × 560 dp board area, 16 dp gutters):
- `fitCell = floor((360 − 32) / max(W, H))` ⇒ 12×12 = 27 dp, 13×13 = 25 dp, 14×14 = 23 dp. **Rule: `fitCell ≥ 22 dp`** (14×14 max ⇒ pass).
- `fitCell < 29 dp` હોય ત્યારે tap fit-scale પર પણ ચાલે; hit-slop 0.6 cell (Phase 1: 0.5) અને **ambiguous tap guard:** tap point થી 0.6 cell માં **બે અલગ snakes** ના body segments હોય અને બંને ની distance નો ફરક < 0.15 cell ⇒ tap ignore + "Zoom in to pick" toast (Move નહીં, heart નહીં).
- `maxScale` પર cell 48 dp ⇒ accessibility target (≥ 44 dp) હંમેશા પહોંચી શકાય. Touch slop 18 dp, "Fit" button, double-tap zoom નહીં (standard §17.23).

### 2.5 Tutorial (L501–503)
Step-by-step: [02 §3](./02_LEVEL_PROGRESSION_0501_1000.md#3-onboarding--levels-501510-level-by-level). Intro card Grandpa Tortoise: "The garden grew! Pinch to look closer, drag with two fingers to look around."

## 3. Diagonal Snakes (M051 થી)
### 3.1 Directions
`dir ∈ {U, D, L, R, UL, UR, DL, DR}`. Unit vectors (`x` → right, `y` → down):

| dir | (dx, dy) | dir | (dx, dy) |
|---|---|---|---|
| U | (0, −1) | UL | (−1, −1) |
| D | (0, 1) | UR | (1, −1) |
| L | (−1, 0) | DL | (−1, 1) |
| R | (1, 0) | DR | (1, 1) |

### 3.2 Body Connectivity
- Phase 2 levels માં snake body cells **8-connected:** consecutive cells `body[i]`, `body[i+1]` વચ્ચે Chebyshev distance = 1 (orthogonal **અથવા** diagonal step).
- Orthogonal-dir snake નું body પણ diagonal links રાખી શકે (bendy snake). પણ **`body[1]` = `body[0] − dir`** (neck હંમેશા head ની બરાબર પાછળ) — validator rule, જેથી head ની દિશા એક નજરમાં સમજાય.
- Exit animation: tail head ના track ને follow કરે (track = body cells + lane), diagonal segment length = √2 cell.

### 3.3 Diagonal Lane
- Lane = `head + k·(dx, dy)`, k = 1, 2, … જ્યાં સુધી `x` **અથવા** `y` board બહાર ન જાય. Exit = lane board ની કોઈ પણ edge (corner સહિત) પાર કરે.
- **No X-crossing rule (diagonal squeeze):** diagonal step `c → c + (dx, dy)` blocked છે જો target cell blocked હોય **અથવા** `c + (dx, 0)` અને `c + (0, dy)` બંને cells એક જ snake ના **consecutive** body cells હોય (એટલે કે તે snake ની diagonal link lane ને X આકારે કાપે). બે અલગ snakes ના cells corner-touch કરે ⇒ blocked **નથી** (lane વચ્ચેથી સરકી શકે).
- Orthogonal lane cells માંથી પસાર થાય ⇒ diagonal links થી કદી block થતો નથી (link કોઈ cell occupy નથી કરતી).
- Bump: head blocker ના આગળના diagonal cell સુધી જઈ 0.25 cell bonk (Phase 1 §5.2 જેવું).

### 3.4 Phase 1 Mechanics × Diagonal Lanes (binding interaction table)
| Mechanic | Diagonal lane behaviour |
|---|---|
| Blockers, gates, cages, locks, Grumpy Mongoose (M001, M002, M004, M005, M007, M009, M033, M043, M049) | Same: cell blocked/passable rule direction-independent |
| M006 Bamboo One-Way / M058 Spinning Leaf Arrow | Arrow orthogonal ⇒ diagonal lane **હંમેશા blocked** (bump) |
| M008 Rabbit Burrows / M044 Twisty Burrow / M076 Burrow Network | Same dir માં બીજા burrow થી continue (M044: dir 90° rotate, diagonal પણ: UR CW ⇒ DR) |
| M014 Mushroom Bumper, M018 Fern Fork, M086 Dewdrop Mirror Leaf | **Validator ban:** diagonal lane આ cells સુધી ન પહોંચે (orthogonal mirrors ની diagonal reflection સમજવામાં અઘરી). Runtime fallback = blocker (bump) |
| M052 Rubber Root Bumper | Diagonal lanes 90° deflect (catalog card) |
| M015 Root Bridge / M042 Dry Twig Bridge | Bridge પરનું body diagonal lane ને block **કરે** (diagonal ≠ perpendicular) |
| M020 Home Burrow, M061 Sleepy Den | Diagonal lane ત્યાં પહોંચે ⇒ exit |
| M024 Giant Anaconda | Diagonal Anaconda **નથી** (validator ban) |
| M029–M031 edges, M071/M095 | Diagonal lane edge cell પાર કરે તે side ગણાય; corner cell પરથી બહાર ⇒ lane ના **છેલ્લા board cell** ની બહારની બંને edges માંથી કોઈ એક walled/closed હોય તો blocked |
| M038 Bouncy Fern Pad | Next diagonal cell jump |
| M013 Spinning Lilypad / M034, M091 stumps / M070 / M079 | Rotation 90° CW: `U→R→D→L→U`, `UR→DR→DL→UL→UR`. નવો dir પોતાના body તરફ ⇒ "tangled" locked tap (standard §17.39) |

### 3.5 Tap & Hit-test
Body segment capsules (center-to-center line, radius 0.42 cell) પર nearest-segment hit-test; cell floor math ની જગ્યાએ (diagonal links cell boundaries ક્રોસ કરે છે). Tie ⇒ ઉપરનું layer, પછી `body[0]` નજીક.

## 4. Three Layers (M069 થી; M032 નું extension)
### 4.1 Definition
| `layer` | Name | Visual | Shadow |
|---|---|---|---|
| 0 | **Ground** (જમીન) | Grass level, covered હોય ત્યારે 35% desaturate | none |
| 1 | **Canopy** (ડાળીઓ) | Branch shadow ઉપર (Phase 1 M032 જેવું) | offset 0.08 cell |
| 2 | **Treetop** (ઝાડની ટોચ) | Leafy platform tint, snakes 6% મોટા દેખાય | offset 0.16 cell |

Level JSON: `"layers": 3`, દરેક path પર `"layer": 0 | 1 | 2`.

### 4.2 Rules (exact)
1. **Lock:** layer `k` નો snake **locked** જ્યાં સુધી layer `> k` (કોઈ પણ ઉપરનું) નો કોઈ snake તેના **કોઈ પણ** body cell ને cover કરે. (Ground snake ને Canopy અથવા Treetop, બંનેમાંથી કોઈ પણ ઢાંકે તો locked.)
2. **Lanes:** lane માત્ર પોતાના layer ના snakes થી block થાય (ground lane ground snakes થી, વગેરે).
3. **Obstacles:** default **બધા layers** block/affect કરે (standard §16.34). `params.layer` (int અથવા list) થી override.
4. **Tap priority:** cell માં ઘણા layers ⇒ સૌથી ઊંચા layer નો snake (standard §2 rule 9).
5. **Hammer:** covered snake target નથી (standard §16.8).
6. **Frost Coil (M003) adjacency** layer-independent (standard §16.29).
7. **M056 Liana Ramp** જ lane ને બીજા layer પર લઈ જઈ શકે (catalog card).
8. Validator: કોઈ snake ના ≥ 1 cells હંમેશા uncovered (પૂરેપૂરો ઢંકાયેલો snake નહીં); x1 intro L691 માં ≤ 2 Treetop snakes.

## 5. Push Blocks (M053 Rolling Coconut થી)
### 5.1 Exact Rule
1. Snake ના lane ને Rolling Coconut મળે ⇒ coconut ની પાછળ (lane direction માં આગળનો cell) **free** હોય તો coconut **1 cell** ખસે. Snake પોતાની જગ્યાએ **રહે** (head coconut સુધી જઈ ધક્કો મારી પાછો આવે). = **1 Move, heart નહીં.**
2. પાછળનો cell free નથી ⇒ normal **bump (−1)**.
3. **Free cell** = board ની અંદર, કોઈ પણ layer નો snake body નહીં, બીજો coconut નહીં, અને cell પર માત્ર આ mechanics (અથવા કંઈ નહીં): empty floor, M054 Slick Moss, M055 Coconut Cradle, M019 Mossy Pressure Stone, M083 Heavy Mossy Stone, M026 gem, M059/M094 paint. બાકીના mechanic cells (gates — open હોય તો પણ, burrows, mushrooms, holes, edges બહાર) = **not free**.
4. **Board edge (standard §17.29):** coconut ને **open** board edge પાર ધક્કો ⇒ coconut board પરથી **પડી જાય અને remove** થાય (કશું count નથી થતું: quota, gem, plate). Edge **walled/closed** (M029 Hedge Border, closed M031, M030 other-colour arch, M078) ⇒ not free ⇒ bump. (આ rule વગર pusher નો lane કાયમ blocked રહી શકે.)
5. Push direction = coconut ને અડતી વખતે lane ની direction (mirror/burrow પછીની, diagonal પણ).
6. એક Move માં એક જ coconut ખસે (chain push નહીં: coconut પાછળ coconut ⇒ not free ⇒ bump).
7. Coconut બધા layers ના lanes block કરે; hammerable ✅ (standard §16.18).
8. M054 Slick Moss: ધક્કા પછી coconut slick moss cell પર હોય ⇒ આગળનો cell free હોય ત્યાં સુધી સરકતો રહે; non-moss cell પર પહોંચે ⇒ ત્યાં અટકે. Slide દરમિયાન open edge પાર ⇒ પડીને remove (rule 4). (Ice પર snakes slide **નથી** કરતા.)
9. Push animation 220 ms (slide: 120 ms/cell, max 450 ms total — standard §2 rule 8 ની 450 ms limit).

### 5.2 Solver Notes
Coconut positions solver state માં (`encode()`), non-monotone ⇒ D માં N તરીકે ગણાય. Push Move = S +1.

## 6. Sunbeams — Beams vs Lanes (M084–M089, M099)
### 6.1 Concepts
| Term | Meaning |
|---|---|
| **Lane** | Snake નો exit route (standard §1). Tap થાય ત્યારે જ trace થાય |
| **Beam (Sunbeam)** | Sunbeam Crystal (M084) માંથી નીકળતી સ્થિર પ્રકાશ રેખા. દરેક Move પછી step 4 (derived states) માં ફરી compute. Beam cells **blocker** છે |

### 6.2 Beam Trace (exact)
1. Emitter cell `e`, `dir` (orthogonal only). Beam `e + dir` થી શરૂ.
2. દરેક cell પર:
   - Snake body (કોઈ પણ layer) ⇒ beam **ત્યાં અટકે** (તે cell beam માં નથી).
   - Transparent cell (empty floor, gems, paint, glue, plates, slick moss, intact collapsing floor, open gate, bridge cell જેના પર snake body નથી) ⇒ beam cell, આગળ.
   - M086 Dewdrop Mirror Leaf ⇒ M014 mapping મુજબ 90° વળે (`/`: R→U, L→D, U→R, D→L; `\`: R→D, L→U, U→L, D→R).
   - M089 Crystal Prism Flower ⇒ incoming dir ના 90° CW અને 90° CCW બે beams.
   - M085 Sunflower Receiver ⇒ receiver **lit**, beam અટકે.
   - M099 Sun Temple Master Lock cell, તેની `sunSide` થી ⇒ built-in sun slot **lit**, beam અટકે (standard §17.32); બીજી બાજુ થી ⇒ opaque.
   - બીજું કંઈ (blocker, closed gate, coconut, burrow, mushroom, hole, emitter) ⇒ beam અટકે.
   - Board edge ⇒ beam અટકે.
3. Loop guard: same `(cell, dir)` બીજી વાર ⇒ તે branch અટકે (validator પણ beam loops reject કરે).
4. Beams **બધા layers** પર અસર કરે (sunlight canopy માંથી પણ પડે).

### 6.3 Lanes vs Beams
| Situation | Result |
|---|---|
| Lane કોઈ beam cell માં પ્રવેશે | **Bump** (beam = blocker), −1 |
| Snake body beam ને રોકે, તે snake exit થાય | Exit Move પછી step 4 માં beam લાંબો થાય (exit lane ના trace દરમિયાન beam જૂની state મુજબ) |
| Snake નો lane beam ની સાથે-સાથે (parallel, બાજુના cells) | કોઈ અસર નહીં |
| Coconut push કરીને beam રોકવો | ✅ (coconut opaque); step 4 recompute |
| Board Rotator (M079) | Emitter dir પણ rotate, step 4 recompute |
| Long-press Preview | Lane beam cell પર લાલ ✕ (blocked) |

Lane trace હંમેશા Move ની **શરૂઆતની** beam state વાપરે; beam update Move ના અંતે (step 4). ⇒ deterministic.

## 7. Tier Table (Phase 2, standard §9.3)
| Tier | Levels | Grid | Snakes | Max obstacle instances | D band | Biomes |
|---|---|---|---|---|---|---|
| T5 (ref) | 401–500 | 10×10–11×11 | 22–30 | 6–10 | 38–52 | Moonlit Jungle |
| **P2-A** | 501–750 | 10×10–13×13 | 24–34 | 6–12 | 45–60 | Waterfall Gorge, Sunbeam Rainforest, Treetop Village |
| **P2-B** | 751–1000 | 12×12–14×14 | 28–40 | 8–14 | 52–70 | Ancient Ruins, Crystal Caves, Sun Temple |

- **Non-decrease rule:** Phase 2 lowest band ≥ T5 mid (45) ⇒ P2-A band **45** થી શરૂ (standard §9.3). Block-wise sub-bands: [02 §6](./02_LEVEL_PROGRESSION_0501_1000.md#6-block-table--levels-5011000-all-50-blocks).
- x9 Hard = band max × 1.1, Finale = band max × 1.2 (standard §16.13) ⇒ L1000 target ≈ 84.
- Golden Slither Rush paths: **30** (standard §16.9 "T5/Phase 2").
- D formula, C definition, slot/tag mapping: standard §9.4, §16.15, §16.16 (Phase 1 જેવું).

## 8. Economy Changes in Phase 2 (માત્ર standard મુજબના)
| Item | Phase 2 value | Standard |
|---|---|---|
| Level clear coins | Easy 15 / Normal 20 / Hard 30 / Finale 50 (unchanged) | §6.1 |
| First ★★★ | +20 (unchanged) | §6.1 |
| Jungle Gift Basket L510–L990 | **300 coins** + 1 booster `(L/10) mod 3` (1 = Glow Firefly Hint, 2 = Magic Stone Hammer, 0 = Safety Shell Shield) | §6.1 |
| Jungle Treasure Chest L1000 | **1,000 coins + 2 of each booster + Phase 2 badge "Sun Temple Hero"** (Gift Basket ની જગ્યાએ) | §6.1 |
| Golden Slither Rush | after L525, 550 … 1000 (first clear), 30 snakes, 10/snake, full clear +100 ⇒ max 400 | §6.1, §16.9 |
| Finale order (L1000) | Chest → Rush → Phase Complete | §16.20 |
| **New sink: Cosmetics** | Snake skins + board themes **800–4,000 coins** ([04 §5](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md#5-cosmetics-shop-style-tab)) | §6.2 |
| **New IAP: Piggy Bank** | ₹49, stored coins max 1,000 ([04 §4](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md#4-piggy-bank)) | §7.2 |
| Boosters, Heart Berry Refill, Streak Saver Leaf, coin packs, VIP, Starter Pack | Unchanged | §5, §7 |

- **LiveOps rewards** (standard §6.1, §17.26; Remote Config defaults): Sticker Album volume rewards **300 / 400 / 600 / 800 / 1,000 coins + 1 cosmetic**; Weekly Star Race 1st 1,000 + frame + 3 of each booster · 2nd 500 + 2 Hammer + 1 Hint · 3rd 250 + 1 Shield · 4th–5th 50; ghosts get no rewards — [04](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md).
- Balance sanity (standard §6.2): Phase 2 average clear+star+gift+rush ≈ 60–70 coins/level યથાવત; cosmetics optional sink હોવાથી booster value ઘટતી નથી.

## 9. Remote Config Keys (Phase 2)
| Key | Default |
|---|---|
| `maxPhase` | 1 at update ship ⇒ 2 after rollout |
| `gift_coins_phase2` | 300 |
| `chest_coins` | 1000 |
| `rush_paths_phase2` | 30 |
| `featureFlags` | `{album: true, race: true, piggy: true, cosmetics: true, cloudSync: true}` |
| `piggy_cap` / `piggy_per_level` / `piggy_unlock_level` / `piggy_min_buy` | 1000 / 10 / 30 / 350 |
| `race_unlock_level` / `race_target_levels` / `race_cohort_size` | 60 / 15 / 5 |
| `album_volume_coins` | [300, 400, 600, 800, 1000] |
| `cosmetic_prices` | map sku → coins ([04 §5.2](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md#52-catalog)) |
| `zoom_max_cell_dp` / `zoom_fit_min_cell_dp` | 48 / 22 |
| `sync_backoff_max_s` | 300 |

## 10. Move Resolution Order (Phase 2, standard §16.17)
દરેક Move:
1. **Validate & resolve action:** locked? ⇒ locked tap (stop). નહીં તો exit / bump / push (M053, slide M054) / relocate (M037) / wake (M012) / unstick (M087) / segment exit (M092) / split (M093) / bubble pop (M073) / swap (M060) / interactive tap (levers M009, M045, M070, M074; rotors M013, M034, M091). **Exit triggers** (keys, HP, quotas M061/M062/M071/M095, seesaw flip M064, paint M059/M094, collapsing pass count M067, trail creation M068, puffball M077, twin locks M080, dominoes M097, sequence advance M072) અહીં જ. Mimic (M081) dir update action ના અંતે.
2. `moveCount += 1`.
3. **Counters tick** (fixed order): M007, M017, M031, M025 (+ M098 Prowling Mongoose તે જ slot પર), M027, M047, M041, પછી **M057, M058, M063, M067, M068, M075, M079, M082, M090, M096**.
4. **Derived states:** plates (M019, M055, M083), beams (M084 → M086/M089 → M085), fog (M010, M075), cages (M033), locks (M004, M043, M065, M080, M088, M099), gates linked to receivers.
5. **Heart loss** (Safety Shell Shield પહેલાં absorb).
6. **Win check.**
7. **0-heart check** ⇒ Second Chance.

- Parity mechanics (M021, M090, M096) Move increment **પહેલાં** ની parity વાપરે (standard §16.17).
- M067 ની standard tick-list position: pass count step 1 (lane trigger) માં વધે, cell collapse step 3 માં M067 slot પર થાય. M068 trail: step 1 માં બને, step 3 માં ttl ઘટે (creation Move નો tick skip ⇒ આગલા 2 Moves block).
- Phase 1 tick order: [01 §5.9](../phase_1/01_GAME_CONCEPT_AND_RULES.md#59-move-resolution-order-deterministic) (same standard §16.17 list).
- **Bumped Moves change nothing lane-based** (standard §17.30): paint/mixing (M059/M094), seesaw flips (M064), key/item pickup (M065), floor wear (M067), trails (M068), quotas (M061/M062/M071/M095), Mimic (M081) updates માત્ર snake **exit અથવા relocate** થાય ત્યારે. Bump ⇒ only Move counter + heart.
- **Soft-lock** (standard §17.31): solver ને booster વગર winning sequence ન મળે ⇒ "Stuck" sheet (Restart), heart loss નહીં, fail screen નહીં, `E-GAME-004` logged.
- **Tangled** (standard §17.39): rotation (M013, M070, M079, M081 Mimic, M093 split) પછી snake નો `dir` પોતાના body તરફ ⇒ locked tap જ્યાં સુધી dir ફરી ન બદલાય (bump નહીં).

## 11. Edge Cases (Phase 2 rules)
| # | Situation | Behaviour |
|---|---|---|
| P2-E1 | Pinch શરૂ થાય ત્યારે 1-finger tap pending | Tap cancel, Move નહીં |
| P2-E2 | Zoom દરમિયાન snake exit animation | Animation board coordinates માં ચાલુ; camera independent |
| P2-E3 | Diagonal lane exactly corner cell (W−1, 0) થી UR | Exit (corner edge cross) — M029 corner walls હોય તો §3.4 rule |
| P2-E4 | Diagonal lane બે અલગ snakes ના corner-touching cells વચ્ચે | Pass (no X-crossing rule માત્ર same-snake link પર) |
| P2-E5 | Coconut push into cell જ્યાં canopy snake body છે | Not free (any layer) ⇒ bump |
| P2-E6 | Coconut on slick moss slides into beam path | Slide ચાલુ (beam coconut ને રોકતો નથી); step 4 માં beam coconut પર અટકે |
| P2-E7 | Treetop snake ground + canopy બંને ને cover કરે | બંને locked; treetop exit પછી canopy unlocked, canopy હજુ ground ઢાંકે તો ground locked |
| P2-E8 | Hint target treetop નીચે hidden? | Hint locked/covered snake ક્યારેય point ન કરે (solver valid move જ આપે) |
| P2-E9 | Lane beam cell માં, Shield active | Bump ⇒ Shield charge −1 (normal heart-loss event) |
| P2-E10 | Ambiguous tap guard (§2.4) વારંવાર | 3 વાર ⇒ "Fit" button pulse + zoom tip એક વાર |
| P2-E11 | Coconut pushed toward open edge with nothing behind | Falls off & removed, 1 Move, no heart (§5.1 rule 4) |
| P2-E12 | Coconut pushed toward Hedge Border (walled) edge | Bump −1 |

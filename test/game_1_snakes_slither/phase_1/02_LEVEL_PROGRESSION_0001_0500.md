# 02 — Level Progression (Levels 1–500)
> Phase 1 ના 500 levels ની ગોઠવણ: tiers, 10-level block pattern, FTUE L1–10, booster tutorials, દરેક block નું table અને L500 Finale.

**Related docs:** [Phase 1 index](./README.md) · [Shared Core Standard §9](../../SHARED_CORE_STANDARD.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) · [04 Boosters & Shop](./04_BOOSTERS_COINS_SHOP.md) · [Scaling to 10,000](../SCALING_TO_10000_LEVELS.md)

---

## 1. Principles (સિદ્ધાંતો)
1. **દર 10 levels એ નવું:** Block `N1…N0` ના x1 slot પર એક નવું mechanic (M001 L11 … M049 L491).
2. **Fair:** દરેક level 0 hearts lost + 0 boosters થી solvable (CI validator + solver).
3. **Tier-to-tier difficulty ક્યારેય ઘટે નહીં:** block ની અંદર માત્ર x5 breather અને x0 milestone "આરામ" આપે.
4. **Turn-based:** કોઈ level માં seconds limit નથી; FTUE seconds માત્ર analytics target.
5. **Hand-tuned:** L1–30, દરેક x1 intro, દરેક x9 Hard, L500 Finale. બાકી `tools/levelgen` generator + designer review.

## 2. Tier Table (standard §9.3)
| Tier | Levels | Biome | Grid | Snakes | Max obstacle instances | D band |
|---|---|---|---|---|---|---|
| FTUE | 1–3 | Pip's Backyard | 4×4–5×5 | 2–4 | 0 | 1–4 |
| FTUE | 4–10 | Pip's Backyard | 5×5–6×6 | 4–8 | 0 | 3–8 |
| T1 | 11–100 | Garden Meadow | 6×6–8×8 | 6–14 | 1–4 | 6–18 |
| T2 | 101–200 | Bamboo Grove | 7×7–9×9 | 10–18 | 3–6 | 14–26 |
| T3 | 201–300 | Mango Orchard | 8×8–10×10 | 14–22 | 4–8 | 22–36 |
| T4 | 301–400 | Misty Swamp | 9×9–10×10 | 18–26 | 5–9 | 30–44 |
| T5 | 401–500 | Moonlit Jungle | 10×10–11×11 | 22–30 | 6–10 | 38–52 |

- Phase 1 max **11×11** ⇒ 360 dp phone પર (16 dp gutters) cell ≥ 29 dp. Pinch-zoom Phase 1 માં નથી.
- **Sub-bands (આ game નું tuning, tier range ની અંદર જ):** દરેક tier ને early / mid / late ભાગમાં વહેંચ્યું છે જેથી grid, snakes અને D ધીરે-ધીરે વધે. Block-wise ranges §7 table માં.

### 2.1 Difficulty Score D (standard §9.4)
```
D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
P = snake count, C = longest dependency chain (solver), O = obstacle instances,
N = non-monotone mechanic instances (lever, plate, countdown, …), S = solution Moves − P
```
- Generator નો level તેના slot target band (±3) માં ન આવે ⇒ reject.
- આ docs માં `C` = longest "must-exit-before" chain ની **links** ની સંખ્યા (બધા snakes independent ⇒ C = 0). FTUE examples (§4) આ interpretation થી ગણ્યા છે.

## 3. 10-Level Block Pattern (standard §9.2)
| Slot | Role | Difficulty target (block D band ની અંદર) | Tag (coins) | Map UI |
|---|---|---|---|---|
| x1 | **Intro:** નવું mechanic + ≤ 1 જૂનું mechanic, Grandpa Tortoise intro card + tutorial hand | low (band નો નીચલો 25%) | Normal (20) | "NEW!" leaf badge |
| x2 | Practice: નવું + જૂના mix | low | Normal | — |
| x3 | Practice | low → mid | Normal | — |
| x4 | Practice | mid | Normal | — |
| x5 | **Breather** | low | **Easy (15)** | — |
| x6 | Ramp | mid | Normal | — |
| x7 | Ramp | mid → high | Normal | — |
| x8 | Ramp | high | Normal | — |
| x9 | **Hard** | high +10% (band max × 1.1) | **Hard (30)** | Red paw badge |
| x0 | **Milestone** (Jungle Gift Basket) | mid | Normal | Gift basket icon |

- Phase Finale L500: Boss board, band high +20%, tag Finale (50 coins).
- Mechanic pool (x2–x0): block નું નવું mechanic દરેક level માં ≥ 1 instance; બાકીના instances છેલ્લા 5 unlocked mechanics માંથી 60% weight અને બાકીના જૂના mechanics માંથી 40% weight.
- Level JSON: `tag` = coin label (`easy` / `normal` / `hard` / `finale`); `slot` = block role (`intro` / `practice` / `breather` / `ramp` / `hard` / `milestone` / `finale`). દરેક level JSON માં **બંને** fields ફરજિયાત (standard §12 schema v3, §16.15). Mapping: breather ⇒ easy; intro/practice/ramp/milestone ⇒ normal; hard ⇒ hard; finale ⇒ finale. FTUE exception: L9 = `ramp` / `normal` (standard §16.3).

## 4. FTUE — Levels 1–10 (level-by-level)
Clean board (0 obstacles). Design rule (CI): L1–3 optimal ≤ 4 Moves, L4–10 ≤ 8 Moves. Analytics target: L1–3 median clear ≤ 10 s, L4–10 ≤ 20 s.

| L | Grid | Snakes | Chain C | Optimal Moves | D | Slot / tag | Tutorial step (`ftue_step`) |
|---|---|---|---|---|---|---|---|
| 1 | 4×4 | 2 (straight, both free) | 0 | 2 | 1.2 | intro / normal | `1_tap_to_slither`: Pip wave કરે; hand snake A પર pulse — "Tap a snake to slither out!", પછી snake B. Hearts HUD hidden |
| 2 | 4×4 | 3 (1 blocks another) | 1 | 3 | 3.3 | practice / normal | `2_order_matters`: hand free snake પર. Player blocked snake tap કરે તો bonk + tooltip "Ouch! A bonk costs 1 Heart Berry." Hearts HUD અહીંથી દેખાય |
| 3 | 5×5 | 4 | 1 | 4 | 3.9 | practice / normal | `3_hint`: **Glow Firefly Hint tutorial** — 3 free Hints grant, hand Hint button પર, firefly snake glow કરે, player tap કરે (1 Hint વપરાય ⇒ 2 બાકી) |
| 4 | 5×5 | 4 (one bend) | 2 | 4 | 5.4 | practice / normal | `4_hearts`: hearts HUD highlight — "3 berries per try. Run out? You get a Second Chance." |
| 5 | 5×5 | 5 | 1 | 5 | 4.5 | breather / **easy** | `5_preview`: **Tongue-Flick Preview** — "Press and hold a snake to see its path" (green/red dotted). Free, Move નથી |
| 6 | 6×6 | 6 (1 caterpillar) | 2 | 6 | 6.6 | ramp / normal | `6_tap_anywhere`: hand body ના વચ્ચે tap બતાવે; "Caterpillars wiggle the same way!" |
| 7 | 6×6 | 6 (long, bendy) | 2 | 6 | 6.6 | ramp / normal | `7_moves`: Move counter tooltip (એક વાર) |
| 8 | 6×6 | 7 | 2 | 7 | 7.2 | ramp / normal | `8_undo`: **Coil-Back Undo tutorial** — 3 free Undo grant; hand snake X tap કરાવે (exit), પછી Undo highlight ⇒ X પાછો coil થઈ મૂળ જગ્યાએ (1 Undo વપરાય ⇒ 2 બાકી). "Undo brings back a Move, not a Heart." |
| 9 | 6×6 | 8 | 2 | 8 | 7.8 | ramp / normal | `9_think_ahead`: tooltip "Hold a snake to check its path before you tap!" (FTUE માં Hard tag નથી — standard §16.3; પહેલું Hard = L19, ત્યાં red paw badge tooltip) |
| 10 | 6×6 | 8 | 1 | 8 | 6.3 | milestone / normal | `10_gift_basket`: પહેલું Jungle Gift Basket (150 coins + 1 Hint), basket shake ⇒ tap to open |

- L1–10 દરમિયાન: interstitial **ક્યારેય નહીં**, gameplay banner નહીં (banner L11 થી).
- Tooltips "Got it" થી બંધ. Guided steps (L1, L3, L8) skip નથી, પણ 2 s inactivity પછી hand ફરી pulse.
- Optimal Moves = snake count (FTUE માં interactive obstacle નથી ⇒ S = 0).

## 5. Booster Tutorials & Unlocks
| Level | Booster / feature | Grant | Tutorial |
|---|---|---|---|
| L3 | 🪲✨ Glow Firefly Hint (Hint) | 3 free | Guided use (1 વપરાય) |
| L8 | 🌀 Coil-Back Undo (Undo) | 3 free | Guided use (1 વપરાય) |
| L15 (start) | 🐚 Safety Shell Shield (Shield) | 1 free | Tooltip + button highlight; use optional ("Wear the shell before a risky tap — the next 2 bonks are free") |
| L15 (clear) | 📅 Daily Jungle Puzzle unlock | — | Home પર Daily card unlock animation ([05](./05_DAILY_CHALLENGE_AND_STREAK.md)) |
| L15 (clear) | Starter Pack offer (48 h window) | — | Home પર એક વાર popup ([04 §8](./04_BOOSTERS_COINS_SHOP.md#8-shop)) |
| L15 (win) | પહેલું eligible interstitial | — | [04 §9](./04_BOOSTERS_COINS_SHOP.md#9-ads-rules) |
| L25 (start) | 🔨 Magic Stone Hammer (Hammer) | 1 free | Tooltip + highlight; use optional ("Smash one rock or lift one snake out") |
| L25 (clear) | પહેલું Golden Slither Rush | — | Rush intro card (1 screen rules) |

L15 અને L25 બંને x5 Easy breather ⇒ નવું booster શીખવા ઓછું pressure. Booster bar માં locked boosters grey + lock + "Unlocks at L15/L25".

## 6. Intro Level (x1) Rules
- Grandpa Tortoise intro card: mechanic name, 1-line rule, 3-frame mini animation (loop). "Got it" પછી level શરૂ.
- Level માં માત્ર નવું mechanic + ≤ 1 જૂનું mechanic (validator), 1–2 instances.
- Tutorial hand: solver `solution[0]` highlight; mechanic interactive હોય (lever, lilypad, …) તો hand તેના પર.
- x1 levels block ના grid range નું **નીચલું** size વાપરે.
- Intro cards Settings → "Jungle Guide" માં ફરી જોઈ શકાય (બધા unlocked mechanics).

## 7. Block Table — Levels 1–500 (all 50 blocks)
- **Gift (x0):** Jungle Gift Basket coins + 1 booster; booster = `(L/10) mod 4` → 1 = Hint, 2 = Hammer, 3 = Shield, 0 = Undo.
- **Golden Slither Rush:** level number નથી; marked level clear પછી bonus round. x0 level (L50, L100, …) પર હોય તો **Gift Basket પહેલાં, પછી Rush** (વચ્ચે interstitial નહીં).
- **Hard:** દરેક block નો x9 (red badge, 30 coins).
- Grid / Snakes / D band = block target range (x9 Hard ⇒ band max × 1.1 સુધી).

| Block | Levels | Tier | New mechanic (x1) | Grid | Snakes | D band | Gift (x0) | Golden Slither Rush | Hard (x9) |
|---|---|---|---|---|---|---|---|---|---|
| 1 | 1–10 | FTUE | — (clean board; Hint L3, Undo L8 tutorials) | 4×4–6×6 | 2–8 | 1–8 | 150 + 1 Hint | — | — (L9 = Normal; first Hard L19) |
| 2 | 11–20 | T1 | L11 · M001 Garden Rock | 6×6–7×7 | 6–10 | 6–12 | 150 + 1 Hammer | — | L19 |
| 3 | 21–30 | T1 | L21 · M002 Fallen Log | 6×6–7×7 | 6–10 | 6–12 | 150 + 1 Shield | after L25 | L29 |
| 4 | 31–40 | T1 | L31 · M003 Frost Coil | 6×6–7×7 | 6–10 | 6–12 | 150 + 1 Undo | — | L39 |
| 5 | 41–50 | T1 | L41 · M004 Bamboo Cage & Key | 6×6–8×8 | 8–12 | 9–15 | 150 + 1 Hint | after L50 | L49 |
| 6 | 51–60 | T1 | L51 · M005 Flower Gate | 6×6–8×8 | 8–12 | 9–15 | 150 + 1 Hammer | — | L59 |
| 7 | 61–70 | T1 | L61 · M006 Bamboo One-Way | 6×6–8×8 | 8–12 | 9–15 | 150 + 1 Shield | — | L69 |
| 8 | 71–80 | T1 | L71 · M007 Lotus Bud Gate | 7×7–8×8 | 10–14 | 12–18 | 150 + 1 Undo | after L75 | L79 |
| 9 | 81–90 | T1 | L81 · M008 Rabbit Burrows | 7×7–8×8 | 10–14 | 12–18 | 150 + 1 Hint | — | L89 |
| 10 | 91–100 | T1 | L91 · M009 Branch Lever & Twig Gates | 7×7–8×8 | 10–14 | 12–18 | 150 + 1 Hammer | after L100 | L99 |
| 11 | 101–110 | T2 | L101 · M010 Jungle Mist | 7×7–8×8 | 10–14 | 14–20 | 180 + 1 Shield | — | L109 |
| 12 | 111–120 | T2 | L111 · M011 Vine-Tied Twins | 7×7–8×8 | 10–14 | 14–20 | 180 + 1 Undo | — | L119 |
| 13 | 121–130 | T2 | L121 · M012 Sleepy Python | 7×7–8×8 | 10–14 | 14–20 | 180 + 1 Hint | after L125 | L129 |
| 14 | 131–140 | T2 | L131 · M013 Spinning Lilypad | 7×7–9×9 | 12–16 | 17–23 | 180 + 1 Hammer | — | L139 |
| 15 | 141–150 | T2 | L141 · M014 Mushroom Bumper | 7×7–9×9 | 12–16 | 17–23 | 180 + 1 Shield | after L150 | L149 |
| 16 | 151–160 | T2 | L151 · M015 Root Bridge | 7×7–9×9 | 12–16 | 17–23 | 180 + 1 Undo | — | L159 |
| 17 | 161–170 | T2 | L161 · M016 Termite Mound | 7×7–9×9 | 12–16 | 17–23 | 180 + 1 Hint | — | L169 |
| 18 | 171–180 | T2 | L171 · M017 Restless Caterpillar | 8×8–9×9 | 14–18 | 20–26 | 180 + 1 Hammer | after L175 | L179 |
| 19 | 181–190 | T2 | L181 · M018 Fern Fork Switch | 8×8–9×9 | 14–18 | 20–26 | 180 + 1 Shield | — | L189 |
| 20 | 191–200 | T2 | L191 · M019 Mossy Pressure Stone | 8×8–9×9 | 14–18 | 20–26 | 180 + 1 Undo | after L200 | L199 |
| 21 | 201–210 | T3 | L201 · M020 Home Burrow | 8×8–9×9 | 14–18 | 22–29 | 210 + 1 Hint | — | L209 |
| 22 | 211–220 | T3 | L211 · M021 Phantom Snake | 8×8–9×9 | 14–18 | 22–29 | 210 + 1 Hammer | — | L219 |
| 23 | 221–230 | T3 | L221 · M022 Reverse Slither | 8×8–9×9 | 14–18 | 22–29 | 210 + 1 Shield | after L225 | L229 |
| 24 | 231–240 | T3 | L231 · M023 Two-Headed Hydra | 8×8–10×10 | 16–20 | 26–32 | 210 + 1 Undo | — | L239 |
| 25 | 241–250 | T3 | L241 · M024 Giant Anaconda | 8×8–10×10 | 16–20 | 26–32 | 210 + 1 Hint | after L250 | L249 |
| 26 | 251–260 | T3 | L251 · M025 Patrolling Beetle | 8×8–10×10 | 16–20 | 26–32 | 210 + 1 Hammer | — | L259 |
| 27 | 261–270 | T3 | L261 · M026 Jungle Gems | 8×8–10×10 | 16–20 | 26–32 | 210 + 1 Shield | — | L269 |
| 28 | 271–280 | T3 | L271 · M027 Creeping Vine | 9×9–10×10 | 18–22 | 29–36 | 210 + 1 Undo | after L275 | L279 |
| 29 | 281–290 | T3 | L281 · M028 Hatch Order Snakes | 9×9–10×10 | 18–22 | 29–36 | 210 + 1 Hint | — | L289 |
| 30 | 291–300 | T3 | L291 · M029 Hedge Border | 9×9–10×10 | 18–22 | 29–36 | 210 + 1 Hammer | after L300 | L299 |
| 31 | 301–310 | T4 | L301 · M030 Flower Arch Exit | 9×9 | 18–22 | 30–37 | 250 + 1 Shield | — | L309 |
| 32 | 311–320 | T4 | L311 · M031 Closing Hedge Gap | 9×9 | 18–22 | 30–37 | 250 + 1 Undo | — | L319 |
| 33 | 321–330 | T4 | L321 · M032 Canopy & Ground | 9×9 | 18–22 | 30–37 | 250 + 1 Hint | after L325 | L329 |
| 34 | 331–340 | T4 | L331 · M033 Petal Cage | 9×9–10×10 | 20–24 | 34–40 | 250 + 1 Hammer | — | L339 |
| 35 | 341–350 | T4 | L341 · M034 Whirl Stump | 9×9–10×10 | 20–24 | 34–40 | 250 + 1 Shield | after L350 | L349 |
| 36 | 351–360 | T4 | L351 · M035 Mama Snake | 9×9–10×10 | 20–24 | 34–40 | 250 + 1 Undo | — | L359 |
| 37 | 361–370 | T4 | L361 · M036 Hungry Caterpillar | 9×9–10×10 | 20–24 | 34–40 | 250 + 1 Hint | — | L369 |
| 38 | 371–380 | T4 | L371 · M037 Sticky Swamp Mud | 10×10 | 22–26 | 37–44 | 250 + 1 Hammer | after L375 | L379 |
| 39 | 381–390 | T4 | L381 · M038 Bouncy Fern Pad | 10×10 | 22–26 | 37–44 | 250 + 1 Shield | — | L389 |
| 40 | 391–400 | T4 | L391 · M039 Pond Twins | 10×10 | 22–26 | 37–44 | 250 + 1 Undo | after L400 | L399 |
| 41 | 401–410 | T5 | L401 · M040 Jungle Night | 10×10 | 22–26 | 38–45 | 300 + 1 Hint | — | L409 |
| 42 | 411–420 | T5 | L411 · M041 Chameleon Snake | 10×10 | 22–26 | 38–45 | 300 + 1 Hammer | — | L419 |
| 43 | 421–430 | T5 | L421 · M042 Dry Twig Bridge | 10×10 | 22–26 | 38–45 | 300 + 1 Shield | after L425 | L429 |
| 44 | 431–440 | T5 | L431 · M043 Big Knot Cage | 10×10–11×11 | 24–28 | 42–48 | 300 + 1 Undo | — | L439 |
| 45 | 441–450 | T5 | L441 · M044 Twisty Burrow | 10×10–11×11 | 24–28 | 42–48 | 300 + 1 Hint | after L450 | L449 |
| 46 | 451–460 | T5 | L451 · M045 Root Gear Lever | 10×10–11×11 | 24–28 | 42–48 | 300 + 1 Hammer | — | L459 |
| 47 | 461–470 | T5 | L461 · M046 Tail-Biter Loop | 10×10–11×11 | 24–28 | 42–48 | 300 + 1 Shield | — | L469 |
| 48 | 471–480 | T5 | L471 · M047 Growing Caterpillar | 11×11 | 26–30 | 45–52 | 300 + 1 Undo | after L475 | L479 |
| 49 | 481–490 | T5 | L481 · M048 Snake Parade | 11×11 | 26–30 | 45–52 | 300 + 1 Hint | — | L489 |
| 50 | 491–500 | T5 | L491 · M049 Grumpy Mongoose · L500 Finale | 11×11 | 26–30 | 45–52 (L500: ≈ 62) | **Jungle Treasure Chest** (L500): 1,000 + 2× each booster + Phase 1 badge | after L500 | L499 |

### 7.1 Block Table Notes
- 20 Golden Slither Rush rounds (L25 … L500), 49 Gift Baskets (L10 … L490), 1 Treasure Chest (L500).
- Block 2 (L11–20) થી gameplay bottom banner (VIP active ન હોય તો).
- T boundary (L100 → L101): L100 milestone mid (≈ 15), L101 intro low (≈ 14–15) ⇒ jump નાનો.
- Gift/Chest/Rush reward માત્ર **first clear** પર. Replay ⇒ નહીં.

## 8. Phase Finale — L500 "Mongoose King's Garden"
| Field | Value |
|---|---|
| Slot / tag | `finale` / `finale` (50 coins) |
| Grid | 11×11, 1 layer (Canopy ન વાપરવું — readability) |
| Snakes | 30 (6 caterpillar skins) |
| Target D | T5 high 52 × 1.2 ≈ **62** (±3) |
| Obstacle instances | 10 (T5 max) = Mongoose King + 9 Phase-1 mechanics |
| Hearts | 3 (normal Second Chance rules) |
| Reward | 50 clear coins (+20 first ★★★) ⇒ **Jungle Treasure Chest** (1,000 coins + 2 Hint + 2 Undo + 2 Shield + 2 Hammer + "Garden Hero" badge) ⇒ Golden Slither Rush (30 snakes) ⇒ Phase Complete screen |

### 8.1 Mechanics Used (Guardian + 9 = 10 instances)
| # | Mechanic | Role in finale |
|---|---|---|
| 1 | M049 Grumpy Mongoose (King skin, 3×3 at (4,4)–(6,6)) | HP 6 = 6 linked snakes; center lanes block |
| 2 | M004 Bamboo Cage & Key | Outer ring: key snake top-right corridor ખોલે |
| 3 | M009 Branch Lever & Twig Gates (1 lever, 2 gates) | Non-monotone: ખોટા time એ flip ⇒ corridor બંધ (Undo/રીતસર flip ફરી કરીને સુધારી શકાય) |
| 4 | M010 Jungle Mist (3×2, bottom-left) | 2 hidden linked snakes |
| 5 | M013 Spinning Lilypad | 1 linked snake ને ring corridor તરફ ફેરવવો |
| 6 | M016 Termite Mound (HP 2) | Left corridor; 2 નજીકના exits પછી ખુલે |
| 7 | M020 Home Burrow (center-bottom) | Mongoose vanish પછી જ પહોંચાય |
| 8 | M026 Jungle Gems (3 gems) | Win goal; gems Mongoose ની આસપાસ |
| 9 | M028 Hatch Order Snakes (1–3) | Top row ordering |
| 10 | M041 Chameleon Snake | Gem row માં, colour cycle એ Hatch Order સાથે timing puzzle (Flower Gate ન મૂકવો — instance cap) |

### 8.2 Flow (designer intent, 3 acts)
1. **Act 1 — Outer ring:** Hatch Order top row, key snake ⇒ Bamboo Cage ખુલે, Termite Mound 2 hits.
2. **Act 2 — Middle ring:** Lever flip + Lilypad rotate, Jungle Mist clear ⇒ hidden linked snakes દેખાય.
3. **Act 3 — Core:** 6 linked snakes exit ⇒ Mongoose HP 6 → 0 ⇒ "poof + leaves" vanish ⇒ gems lane ખુલે ⇒ છેલ્લા snakes Home Burrow માં.
- Par ≈ 34 Moves (30 snakes + lever + lilypad + extra interactive taps); solver `solution` JSON માં (Hint).

### 8.3 Presentation
- Map પર L500 node = Mongoose King statue; L491 clear પછી "Boss ahead" banner.
- Start: Grandpa Tortoise card — "The Mongoose King guards the last garden. Free his 6 friends to make him leave!"
- Music `music_finale.m4a`; Mongoose ઉપર HP pips (6).
- Win: Mongoose King hat ઉતારી bow કરે (friendly ending, no violence) ⇒ Treasure Chest.

## 9. Level Data & Validation
File: `assets/levels/phase_1.json.gz` (500 levels, schema v3). Example (L1):
```json
{
  "schema": 3, "level": 1, "phase": 1, "seed": "0x0000000000000001",
  "tag": "normal", "slot": "intro", "grid": [4, 4], "layers": 1, "hearts": 3,
  "paths": [
    {"id": "p1", "color": "green",  "dir": "R", "body": [[2,1],[1,1],[0,1]], "layer": 0, "mods": {}},
    {"id": "p2", "color": "yellow", "dir": "D", "body": [[1,3],[1,2]],       "layer": 0, "mods": {"skin": "caterpillar"}}
  ],
  "mechanics": [],
  "goals": {"gems": 0},
  "par_moves": 2, "difficulty": 1.2,
  "solution": ["p1", "p2"]
}
```
CI validator (standard §12): 0-heart/0-booster solvable · D in slot band (±3) · કોઈ snake હંમેશ માટે locked નહીં · min cell ≥ 29 dp · x1 = intro mechanic + ≤ 1 earlier · FTUE optimal Moves rule · `tag`/`slot` level number સાથે consistent · Finale instance cap. Generator, seeds અને 10,000-level plan: [SCALING_TO_10000_LEVELS.md](../SCALING_TO_10000_LEVELS.md).

## 10. Progression Analytics
Events: `level_start`, `level_win`, `level_fail`, `ftue_step` (standard §15). Dashboards: per-level win rate, median attempts, hearts lost, booster use rate. Review trigger: win rate < 35% (x9 Hard: < 25%) ⇒ designer review; fix next app/content update માં pre-validated level swap થી (Remote Config `levelOverrides` ⇒ bundled alternate file `phase_1_alt.json.gz`).

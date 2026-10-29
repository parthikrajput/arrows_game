# 02 — Level Progression: Levels 0001–0500 (Phase 1)
> Purpose: Phase 1 ના 500 levels નું structure — tiers, 10-level block pattern, FTUE L1–10 level-by-level, booster tutorials, દરેક 10-level block નું નવું mechanic, rewards અને L500 Phase Finale.

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) (§9 Levels, §10 Mechanics, §12 Pipeline) · [./README.md](./README.md) · [./01_GAME_CONCEPT_AND_RULES.md](./01_GAME_CONCEPT_AND_RULES.md) · [./03_OBSTACLE_CATALOG_PHASE_1.md](./03_OBSTACLE_CATALOG_PHASE_1.md) · [./04_BOOSTERS_COINS_SHOP.md](./04_BOOSTERS_COINS_SHOP.md) · [../../SCALING_TO_10000_LEVELS.md](../../SCALING_TO_10000_LEVELS.md)

---

## 1. Phase 1 at a glance

| Item | Value |
|---|---|
| Levels | 1–500 (bundled `assets/levels/phase_1.json.gz`, schema v3) |
| New mechanics | 49 (M001–M049), દરેક block ના **x1** level પર: L11, 21, 31 … 491 |
| Finale | L500 "The Grand Quilt" — Phase 1 Finale (Guardian + ≥ 8 Phase-1 mechanics) |
| Hand-tuned levels | L1–30, દરેક x1 intro, દરેક x9 Hard, L500 Finale. બાકી: `tools/levelgen` + designer pass |
| CI validator | solvable with 0 hearts lost & 0 boosters · D in band (±3) · no thread locked forever · min cell ≥ 29 dp · intro level = intro mechanic + ≤ 1 earlier mechanic |
| Max board | 11×11 (Phase 1). Pinch-zoom/pan Phase 2 (≥ 12×12) માં |

## 2. Tier Table (standard §9.3)

| Tier | Levels | Grid | Threads (paths) | Max obstacle instances | D band |
|---|---|---|---|---|---|
| FTUE | 1–3 | 4×4–5×5 | 2–4 | 0 | 1–4 |
| FTUE | 4–10 | 5×5–6×6 | 4–8 | 0 | 3–8 |
| T1 | 11–100 | 6×6–8×8 | 6–14 | 1–4 | 6–18 |
| T2 | 101–200 | 7×7–9×9 | 10–18 | 3–6 | 14–26 |
| T3 | 201–300 | 8×8–10×10 | 14–22 | 4–8 | 22–36 |
| T4 | 301–400 | 9×9–10×10 | 18–26 | 5–9 | 30–44 |
| T5 | 401–500 | 10×10–11×11 | 22–30 | 6–10 | 38–52 |

Difficulty score (CI): `D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S` (standard §9.4). Generator level નો D slot target band (±3) માં ન આવે ⇒ reject.

Clear coins (first clear, `tag`): Easy **15** · Normal **20** · Hard **30** · Finale **50**. First ★★★ +20 (level દીઠ એક વાર).

## 3. The 10-Level Block Pattern

દરેક block `N1…N0` (દા.ત. 41–50) આ જ pattern follow કરે:

| Slot | Role | Difficulty | JSON `slot` / `tag` (§16.15) | UI |
|---|---|---|---|---|
| x1 | **Intro** — નવું mechanic, માત્ર તે જ obstacle (+ ≤ 1 જૂનું), Purl tutorial hand + tooltip card | Band low | `intro` / `normal` | "NEW" ribbon on map node |
| x2–x4 | Practice — નવું + જૂના mix | low → mid | `practice` / `normal` | — |
| x5 | Breather | low | `breather` / **`easy`** | — |
| x6–x8 | Ramp | mid → high | `ramp` / `normal` | — |
| x9 | **Hard** level | band high +10% | `hard` / **`hard`** | red "Hard" badge on map + pre-level card |
| x0 | Milestone | mid | `milestone` / `normal` | Craft Basket (Gift Box) after win |

> **FTUE block (1–10):** FTUE tier rules (L1–3 ≤ 4 Moves, L4–10 ≤ 8 Moves) પ્રાથમિક. L5 = Easy breather. L9 = FTUE નો સૌથી અઘરો board પણ tag **Normal** (red Hard badge પહેલી વાર **L19** પર). L10 = પહેલું Craft Basket.

## 4. FTUE: Levels 1–10 (level-by-level)

Design targets (standard §9.3): optimal solution L1–3 ≤ 4 Moves, L4–10 ≤ 8 Moves (CI). Analytics targets: median clear L1–3 ≤ 10 s, L4–10 ≤ 20 s (માપવાના targets, guarantee નહીં). Obstacles: none. Banner: none (gameplay banner L11 થી). Interstitial: L1–10 માં ક્યારેય નહીં.

| Level | Grid | Threads | Optimal Moves | D | Layout idea | Tutorial step (`ftue_step`) |
|---|---|---|---|---|---|---|
| 1 | 4×4 | 2 | 2 | 1–2 | બે સીધા threads, બંને lanes clear | `tap_thread`: Purl paw thread તરફ; "Tap a thread to pull it out!" (thread પર ગમે ત્યાં tap ચાલે) |
| 2 | 4×4 | 3 | 3 | 2–3 | Thread B નો lane thread A બ્લોક કરે | `order_matters`: A highlight ⇒ "Clear the way first" |
| 3 | 5×5 | 4 | 4 | 3–4 | એક L-shaped (bent) thread | `hint_intro`: **Needle Glow Hint** button pulse, 3 free Hints grant, forced first use (tutorial use free, count 3 રહે) |
| 4 | 5×5 | 4 | 4 | 3–5 | 2-deep dependency | `peek_intro`: "Hold to Peek: green = clear, red = snag" |
| 5 | 5×5 | 5 | 5 | 3–5 | Breather (Easy), મોટા ભાગના lanes clear | `hearts_info`: hearts tooltip "A snag costs 1 heart" (text only, forced bump નહીં) |
| 6 | 5×5 | 6 | 6 | 4–6 | લાંબા bent threads, corners | — |
| 7 | 6×6 | 6 | 6 | 5–7 | 3-deep chain | `stars_info`: Level Complete પર "0 hearts lost = ★★★" |
| 8 | 6×6 | 7 | 7 | 5–7 | crossing lanes | — |
| 9 | 6×6 | 8 | 8 | 6–8 | FTUE hardest (tag Normal) | — |
| 10 | 6×6 | 8 | 8 | 5–7 | milestone (mid) | `gift_box`: પહેલું **Craft Basket**: 150 Coins + 1 Hint ((10/10) mod 3 = 1 ⇒ Hint) |

FTUE rules:
- Tutorial overlay માત્ર જરૂરી ભાગ highlight કરે; L1–3 માં "Skip" નથી, L4+ tooltip tap થી dismiss.
- L1–10 માં bump થાય તો normal −1 Heart (rules એકસરખા). L1–3 ના boards એવા કે ખોટો order માત્ર 1 thread પર જ શક્ય.
- દરેક step પૂરું ⇒ `ftue_step{step}` analytics event.

## 5. Booster Tutorials & Feature Unlocks

| Level | Unlock / Event | Grant | Notes |
|---|---|---|---|
| L3 | **Needle Glow Hint** (Hint) tutorial | 3 Hint | forced first use |
| L4 | **Thread Peek** (Path Preview) tutorial | — | મફત feature |
| L10 | પહેલું Craft Basket (Gift Box) · L10 clear પછી **Spinning Wheel (Lucky Spin) unlock** | 150 Coins + 1 Hint | Spin button Home પર L10 clear પછી દેખાય (§16.32) |
| L11 | પહેલું mechanic M001 Wooden Button; gameplay bottom banner શરૂ | — | |
| L15 | **Thimble Shield** (Shield) tutorial · L15 clear પછી **Daily Challenge unlock** · Starter Pack offer (48 h) · પહેલી interstitial-eligible win | 1 Shield | Purl hearts પર thimble મૂકે: "Next 2 snags are free" |
| L20 | Craft Basket 150 + 1 Golden Scissors ((20/10) mod 3 = 2 ⇒ Hammer) | | Golden Scissors button L25 સુધી locked — inventory માં જમા, badge "Unlocks at 25" |
| L25 | **Golden Scissors** (Hammer) tutorial · win પછી પહેલું Golden Bobbin Rush (Coin Rush) | 1 Hammer | highlighted Wooden Button snip કરો |

Starting wallet (standard §6.2): 200 Coins (first launch) + 3 Hint + 1 Shield + 1 Hammer (દરેક tutorial વખતે ઉપર મુજબ grant).

Spinning Wheel (Lucky Spin) **L10 clear પછી** unlock થાય (standard §16.32, FTUE ને disturb ન કરે). L1–10 દરમિયાન Home પર spin button દેખાતું નથી; L10 Craft Basket પછી Home પર પહેલી વાર "Spinning Wheel unlocked" tooltip.

## 6. Craft Basket & Golden Bobbin Rush insertion

- **Craft Basket (Gift Box):** દરેક x0 win પછી (L10, 20 … 490). Coins: L10–100 **150** · L110–200 **180** · L210–300 **210** · L310–400 **250** · L410–490 **300**. Booster: `(L/10) mod 3` ⇒ 1 = Hint, 2 = Hammer, 0 = Shield.
- **Grand Sewing Chest (Phase Chest):** L500 પર Gift Box ની જગ્યાએ — **1,000 Coins + 2 of each booster + Phase 1 badge**.
- **Golden Bobbin Rush (Coin Rush):** L25, 50, 75 … 500 ના **first clear** પછી જ (replay પર નહીં; bonus round, level number નથી). Threads per tier: T1 20 · T2 22 · T3 25 · T4 28 · T5 30 (§16.9/§16.33). L50/L100/L150… (x0 અને 25 નો ગુણાંક બંને): **પહેલા Craft Basket, પછી Coin Rush**. L500: પહેલા Grand Sewing Chest, પછી Coin Rush.
- Reward screen વાળી win પર interstitial **defer** ⇒ આગલી eligible win. Coin Rush પછી interstitial ક્યારેય નહીં. વિગત: [04](./04_BOOSTERS_COINS_SHOP.md).

## 7. Full Block Table (all 50 blocks)

Columns: **Grid** = tier range. **Threads** = tier range નો block window (tier માં ramp). **D band** = x1–x8 slot targets (x1/x5 low end, x6–x8 high end; x0 mid). **x9 Hard** = block high +10%. x0 reward §6 મુજબ. Coin Rush column = તે block માં કયા win પછી.

| Block | Tier | New mechanic (x1) | Grid | Paths | D band (x1–x8) | x9 Hard (D target) | x0 reward | Coin Rush |
|---|---|---|---|---|---|---|---|---|
| 1–10 | FTUE | — (clean board, tutorials) | 4×4–6×6 | 2–8 | 1–8 | L9 (FTUE, tag Normal) | L10: Gift Box 150 + 1 Hint | — |
| 11–20 | T1 | M001 Wooden Button (L11) | 6×6–8×8 | 6–10 | 6–12 | L19 (≈13.2) | L20: Gift Box 150 + 1 Hammer | — |
| 21–30 | T1 | M002 Ruler Strip (L21) | 6×6–8×8 | 6–10 | 7–13 | L29 (≈14.0) | L30: Gift Box 150 + 1 Shield | after L25 |
| 31–40 | T1 | M003 Knotted Thread (L31) | 6×6–8×8 | 7–11 | 8–14 | L39 (≈14.9) | L40: Gift Box 150 + 1 Hint | — |
| 41–50 | T1 | M004 Charm & Clasp (L41) | 6×6–8×8 | 8–12 | 8–14 | L49 (≈15.7) | L50: Gift Box 150 + 1 Hammer | after L50 |
| 51–60 | T1 | M005 Color Eyelet (L51) | 6×6–8×8 | 8–12 | 9–15 | L59 (≈16.5) | L60: Gift Box 150 + 1 Shield | — |
| 61–70 | T1 | M006 Stitch Arrow (L61) | 6×6–8×8 | 8–12 | 10–16 | L69 (≈17.3) | L70: Gift Box 150 + 1 Hint | — |
| 71–80 | T1 | M007 Basting Seam (L71) | 6×6–8×8 | 9–13 | 10–16 | L79 (≈18.2) | L80: Gift Box 150 + 1 Hammer | after L75 |
| 81–90 | T1 | M008 Pompom Tunnel (L81) | 6×6–8×8 | 10–14 | 11–17 | L89 (≈19.0) | L90: Gift Box 150 + 1 Shield | — |
| 91–100 | T1 | M009 Presser Lever (L91) | 6×6–8×8 | 10–14 | 12–18 | L99 (≈19.8) | L100: Gift Box 150 + 1 Hint | after L100 |
| 101–110 | T2 | M010 Wool Fluff (L101) | 7×7–9×9 | 10–14 | 14–20 | L109 (≈22.0) | L110: Gift Box 180 + 1 Hammer | — |
| 111–120 | T2 | M011 Ribbon-Tied Pair (L111) | 7×7–9×9 | 10–14 | 15–21 | L119 (≈22.7) | L120: Gift Box 180 + 1 Shield | — |
| 121–130 | T2 | M012 Coiled Thread (L121) | 7×7–9×9 | 11–15 | 15–21 | L129 (≈23.5) | L130: Gift Box 180 + 1 Hint | after L125 |
| 131–140 | T2 | M013 Spool Spinner (L131) | 7×7–9×9 | 11–15 | 16–22 | L139 (≈24.2) | L140: Gift Box 180 + 1 Hammer | — |
| 141–150 | T2 | M014 Hook Deflector (L141) | 7×7–9×9 | 12–16 | 17–23 | L149 (≈24.9) | L150: Gift Box 180 + 1 Shield | after L150 |
| 151–160 | T2 | M015 Stitch Bridge (L151) | 7×7–9×9 | 12–16 | 17–23 | L159 (≈25.7) | L160: Gift Box 180 + 1 Hint | — |
| 161–170 | T2 | M016 Tailor's Chalk (L161) | 7×7–9×9 | 13–17 | 18–24 | L169 (≈26.4) | L170: Gift Box 180 + 1 Hammer | — |
| 171–180 | T2 | M017 Fraying Thread (L171) | 7×7–9×9 | 13–17 | 19–25 | L179 (≈27.1) | L180: Gift Box 180 + 1 Shield | after L175 |
| 181–190 | T2 | M018 Thread Guide Switch (L181) | 7×7–9×9 | 14–18 | 19–25 | L189 (≈27.9) | L190: Gift Box 180 + 1 Hint | — |
| 191–200 | T2 | M019 Foot Pedal Plate (L191) | 7×7–9×9 | 14–18 | 20–26 | L199 (≈28.6) | L200: Gift Box 180 + 1 Hammer | after L200 |
| 201–210 | T3 | M020 Yarn Basket (L201) | 8×8–10×10 | 14–18 | 22–29 | L209 (≈31.9) | L210: Gift Box 210 + 1 Shield | — |
| 211–220 | T3 | M021 Sheer Silk Thread (L211) | 8×8–10×10 | 14–18 | 23–30 | L219 (≈32.8) | L220: Gift Box 210 + 1 Hint | — |
| 221–230 | T3 | M022 Backstitch Thread (L221) | 8×8–10×10 | 15–19 | 24–31 | L229 (≈33.6) | L230: Gift Box 210 + 1 Hammer | after L225 |
| 231–240 | T3 | M023 Double-Needle Thread (L231) | 8×8–10×10 | 15–19 | 24–31 | L239 (≈34.5) | L240: Gift Box 210 + 1 Shield | — |
| 241–250 | T3 | M024 Chunky Chenille (L241) | 8×8–10×10 | 16–20 | 25–32 | L249 (≈35.3) | L250: Gift Box 210 + 1 Hint | after L250 |
| 251–260 | T3 | M025 Rolling Yarn Ball (L251) | 8×8–10×10 | 16–20 | 26–33 | L259 (≈36.2) | L260: Gift Box 210 + 1 Hammer | — |
| 261–270 | T3 | M026 Sequins (L261) | 8×8–10×10 | 17–21 | 27–34 | L269 (≈37.0) | L270: Gift Box 210 + 1 Shield | — |
| 271–280 | T3 | M027 Spreading Tangle (L271) | 8×8–10×10 | 17–21 | 27–34 | L279 (≈37.9) | L280: Gift Box 210 + 1 Hint | after L275 |
| 281–290 | T3 | M028 Tagged Threads (L281) | 8×8–10×10 | 18–22 | 28–35 | L289 (≈38.7) | L290: Gift Box 210 + 1 Hammer | — |
| 291–300 | T3 | M029 Hem Wall (L291) | 8×8–10×10 | 18–22 | 29–36 | L299 (≈39.6) | L300: Gift Box 210 + 1 Shield | after L300 |
| 301–310 | T4 | M030 Color Hem Gap (L301) | 9×9–10×10 | 18–22 | 30–37 | L309 (≈40.7) | L310: Gift Box 250 + 1 Hint | — |
| 311–320 | T4 | M031 Zipper Edge (L311) | 9×9–10×10 | 18–22 | 31–38 | L319 (≈41.6) | L320: Gift Box 250 + 1 Hammer | — |
| 321–330 | T4 | M032 Double Fabric Layers (L321) | 9×9–10×10 | 19–23 | 32–39 | L329 (≈42.4) | L330: Gift Box 250 + 1 Shield | after L325 |
| 331–340 | T4 | M033 Safety-Pin Cage (L331) | 9×9–10×10 | 19–23 | 32–39 | L339 (≈43.3) | L340: Gift Box 250 + 1 Hint | — |
| 341–350 | T4 | M034 Quilt Block Rotor (L341) | 9×9–10×10 | 20–24 | 33–40 | L349 (≈44.1) | L350: Gift Box 250 + 1 Hammer | after L350 |
| 351–360 | T4 | M035 Skein Spawner (L351) | 9×9–10×10 | 20–24 | 34–41 | L359 (≈45.0) | L360: Gift Box 250 + 1 Shield | — |
| 361–370 | T4 | M036 Bead-Stringer Thread (L361) | 9×9–10×10 | 21–25 | 35–42 | L369 (≈45.8) | L370: Gift Box 250 + 1 Hint | — |
| 371–380 | T4 | M037 Glue Dot (L371) | 9×9–10×10 | 21–25 | 35–42 | L379 (≈46.7) | L380: Gift Box 250 + 1 Hammer | after L375 |
| 381–390 | T4 | M038 Elastic Hop Pad (L381) | 9×9–10×10 | 22–26 | 36–43 | L389 (≈47.5) | L390: Gift Box 250 + 1 Shield | — |
| 391–400 | T4 | M039 Twin Skeins (L391) | 9×9–10×10 | 22–26 | 37–44 | L399 (≈48.4) | L400: Gift Box 250 + 1 Hint | after L400 |
| 401–410 | T5 | M040 Lamplight Evening (L401) | 10×10–11×11 | 22–26 | 38–45 | L409 (≈49.5) | L410: Gift Box 300 + 1 Hammer | — |
| 411–420 | T5 | M041 Ombre Thread (L411) | 10×10–11×11 | 22–26 | 39–46 | L419 (≈50.4) | L420: Gift Box 300 + 1 Shield | — |
| 421–430 | T5 | M042 Fragile Lace Bridge (L421) | 10×10–11×11 | 23–27 | 40–47 | L429 (≈51.2) | L430: Gift Box 300 + 1 Hint | after L425 |
| 431–440 | T5 | M043 Multi-Clasp (L431) | 10×10–11×11 | 23–27 | 40–47 | L439 (≈52.1) | L440: Gift Box 300 + 1 Hammer | — |
| 441–450 | T5 | M044 Twisting Pompom Tunnel (L441) | 10×10–11×11 | 24–28 | 41–48 | L449 (≈52.9) | L450: Gift Box 300 + 1 Shield | after L450 |
| 451–460 | T5 | M045 Treadle Gear Lever (L451) | 10×10–11×11 | 24–28 | 42–49 | L459 (≈53.8) | L460: Gift Box 300 + 1 Hint | — |
| 461–470 | T5 | M046 Knitted Loop (L461) | 10×10–11×11 | 25–29 | 43–50 | L469 (≈54.6) | L470: Gift Box 300 + 1 Hammer | — |
| 471–480 | T5 | M047 Growing Knit Thread (L471) | 10×10–11×11 | 25–29 | 43–50 | L479 (≈55.5) | L480: Gift Box 300 + 1 Shield | after L475 |
| 481–490 | T5 | M048 Color Bundle (L481) | 10×10–11×11 | 26–30 | 44–51 | L489 (≈56.3) | L490: Gift Box 300 + 1 Hint | — |
| 491–500 | T5 | M049 Grand Pincushion Guardian (L491) | 10×10–11×11 | 26–30 | 45–52 | L499 (≈57.2) | L500: **Phase Chest** 1,000 + 2× each booster + Phase 1 badge | after L500 |

Notes:
- Intro level (x1) D = block band low; validator: intro mechanic + ≤ 1 earlier mechanic.
- Max obstacle instances tier મુજબ (§2). Intro level માં નવા mechanic ના max 3 instances.
- Hard levels (x9) hand-tuned; pre-level card પર mechanic mix ના icons.
- Mechanic names = Yarn themed names; rules ચોક્કસ standard §10 મુજબ (cards: [03](./03_OBSTACLE_CATALOG_PHASE_1.md)).

## 8. Mechanic Mix Guidelines per Tier

| Tier | Mix rule |
|---|---|
| T1 (11–100) | Static blockers + પહેલા stateful (Knotted Thread, Charm & Clasp, Basting Seam, Presser Lever). x2–x8: નવું + 1–2 જૂના |
| T2 (101–200) | Fluff / Ribbon-Tied / Coiled / Spinner / Deflector / Bridge / Chalk / Fraying / Switch / Pedal. Level દીઠ max 3 અલગ mechanics |
| T3 (201–300) | Path-variants (Sheer Silk, Backstitch, Double-Needle, Chenille, Tagged) મુખ્ય. Level દીઠ max 4 mechanics |
| T4 (301–400) | Edges + Double Fabric Layers + cages / rotors / spawners. Max 4 mechanics |
| T5 (401–500) | Combination tier. Lamplight Evening (M040) 5 માંથી max 1 level (visual fatigue). Max 5 mechanics |

- Non-monotone mechanics (Presser Lever, Foot Pedal Plate, Thread Guide Switch, Spool Spinner…) D માં `N` વધારે — T4 પહેલાં level દીઠ max 4 instances.
- Lamplight Evening (M040) Daily Challenge માં વાપરવું નહીં (visual-only; Daily બધા માટે readable રહે).

## 9. L500 — Phase 1 Finale "The Grand Quilt"

| Field | Value |
|---|---|
| Tag | `finale` (first clear **50** Coins) |
| Grid | 11×11 (Phase 1 max) |
| Threads | 30 (T5 max) |
| D | band high +20% ⇒ target ≈ **62** (52 × 1.2), ±3 |
| Boss | **Grand Pincushion Guardian** (M049), centre 3×3 cells, HP = 6 linked threads |
| Mechanic mix (≥ 8) | Guardian + 9 other mechanic instances (= T5 max 10 instances, §16.35): M004 Charm & Clasp, M009 Presser Lever, M013 Spool Spinner, M015 Stitch Bridge, M020 Yarn Basket, M022 Backstitch Thread, M028 Tagged Threads, M032 Double Fabric Layers, M038 Elastic Hop Pad (1 instance each) |
| Hearts | 3; revive / Heart Refill rules standard મુજબ |
| Solvable | 0 hearts lost, 0 boosters (CI) |
| Presentation | Board frame patchwork quilt બને; Guardian HP bar board ઉપર (6 pins); દરેક linked thread exit ⇒ 1 pin બહાર ખેંચાય |
| Reward flow | Level Complete (50 Coins + star bonus) ⇒ **Grand Sewing Chest** (1,000 Coins + 2 Hint + 2 Shield + 2 Hammer + "Master Quilter" Phase 1 badge) ⇒ Golden Bobbin Rush ⇒ **Phase Complete** screen |
| After | Phase 2 build ન હોય (Remote Config `maxPhase = 1`) તો "New patterns coming soon" teaser + Daily Challenge CTA. Phase 2: [../phase_2/README.md](../phase_2/README.md) |

Finale design intent:
1. Opening: માત્ર 4 threads free (Peek થી શોધી શકાય) — બાકી Tagged order, Clasps અને Upper layer પાછળ.
2. Mid: Presser Lever gates ખોલો ⇒ Spool Spinner થી 2 needles rotate ⇒ Stitch Bridge નીચેથી lanes.
3. Guardian linked threads 6 માંથી 3 Yarn Basket (inner exit) દ્વારા જ exit થઈ શકે.
4. End: Guardian vanish ⇒ center lanes ખુલે ⇒ છેલ્લા 8 threads quick cascade (satisfying finish).

## 10. Level Data Pipeline (summary)
Offline `tools/levelgen` (xoshiro128\*\* seed) ⇒ reverse construction ⇒ solver (stateful mechanics) ⇒ D compute ⇒ designer tuning ⇒ CI validator ⇒ `phase_1.json.gz`. Solver output `solution` + `par_moves` JSON માં (Needle Glow Hint અને Tue Par Moves માટે). Phase 3+ on-device generation: [../../SCALING_TO_10000_LEVELS.md](../../SCALING_TO_10000_LEVELS.md).

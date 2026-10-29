# 01 — Phase 2 Scope & Rule Changes (ફેઝ 2 નિયમ ફેરફારો)
Levels 501–1000 માં Phase 1 rules ઉપર ઉમેરાતા નિયમો: pinch-zoom/pan, diagonal lines, ત્રીજું Canopy layer, push blocks, sunbeams, tick order, Phase 2 tier table અને Standard મુજબના economy ફેરફારો.

**Related docs:** [Shared Core Standard §9–§12, §16](../../SHARED_CORE_STANDARD.md) · [Phase 2 README](./README.md) · [Phase 1 Rules](../phase_1/01_GAME_CONCEPT_AND_RULES.md) · [02 Level Progression 501–1000](./02_LEVEL_PROGRESSION_0501_1000.md) · [03 Obstacle Catalog Phase 2](./03_OBSTACLE_CATALOG_PHASE_2.md) · [04 LiveOps](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [06 Frontend & QA](./06_FRONTEND_AND_QA_PHASE_2.md)

---

## 1. What Stays the Same (શું બદલાતું નથી)

Phase 1 ના **બધા** core rules Phase 2 માં યથાવત્ — [phase_1/01](../phase_1/01_GAME_CONCEPT_AND_RULES.md):

- Tap → Exit / Blocked → Bump (−1 Heart), turn-based (wall-clock timer માત્ર Golden Nectar Rush 30 s), deterministic, **no forced damage** (0 hearts / 0 boosters solvable — CI).
- 3 Hearts, ad revive **level દીઠ 1**, Honey Heart Refill **120 coins, attempt દીઠ max 2**, 10-s Second Chance.
- Stars, 4 boosters (Nectar Glow Hint (Hint), Dewdrop Rewind (Undo), Queen's Royal Shield (Shield), Leaf Blower (Hammer)) + free Scent Trail Preview (Path Preview) — effect, caps, prices યથાવત્.
- Layer Rule LR-1…LR-9 (ants ground, bees air, ક્યારેય collide નહીં; bee lanes ને માત્ર bee lines + `tall: true`). Phase 2 માત્ર **ઉમેરે** છે (§6).
- Ads (interstitial દર 5 wins, 120 s cooldown, reward screens પર defer), Beekeeper VIP Pass ₹20/month "while active", compliance.

## 2. Rule Changes at a Glance (ફેરફારોનો સારાંશ)

| # | Change | From | Section |
|---|---|---|---|
| 1 | Pinch-zoom + pan, auto-fit start | Grid ≥ 12×12 (L501+) | §4 |
| 2 | Diagonal heads `UL, UR, DL, DR` + diagonal lanes (ants, bees, canopy) | L511 (M051) | §5 |
| 3 | Third layer **Canopy** (`layer: 2`, Canopy Scout Bees) | L691 (M069) | §6 |
| 4 | Push blocks (Rolling Acorn / Garden Pumpkin) + slick leaves + socket plates | L531 / L541 / L551 | §7 |
| 5 | Sunbeams (lens, receiver, mirror, prism) — layer-bound beams | L841 / L851 / L861 / L891 | §8 |
| 6 | Tick order Phase 2 additions + derived-state sub-order | L571+ | §9 |
| 7 | Tap target resolution for 3 layers + new controls | L601+ | §10 |
| 8 | Tier table P2-A / P2-B | L501 | §3 |
| 9 | Economy: Gift Box 300 (L510–990), Royal Honey Chest at L1000, Rush 30 lines, Piggy, cosmetics sink | L501 | §11 |

## 3. Tier Table — Phase 2 (Standard §9.3)

| Tier | Levels | Grid | Lines (paths) | Max obstacle instances | D band |
|---|---|---|---|---|---|
| T5 (ref.) | 401–500 | 10×10–11×11 | 22–30 | 6–10 | 38–52 |
| **P2-A** | 501–750 | 10×10–13×13 | 24–34 | 6–12 | 45–60 |
| **P2-B** | 751–1000 | 12×12–14×14 | 28–40 | 8–14 | 52–70 |

- Slot rules (Standard §9.2) યથાવત્: x1 intro low, x5 breather (`easy`), x9 Hard = high × 1.1 (`hard`), x0 milestone (`normal`), L1000 Finale = high × 1.2 (`finale`).
- L501–510 onboarding block: 12×12, D 45–47 (P2-A band માં, Standard "difficulty decreases નહીં" — T5 mid 45 — નો નિયમ પાળવા lower bound 45 રાખ્યું).
- Lines count (P) માં ants + bees + canopy બધા ગણાય. D formula યથાવત્: `D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S`.
- Full block table: [02 §5](./02_LEVEL_PROGRESSION_0501_1000.md).

## 4. Pinch-Zoom & Pan (ઝૂમ અને પેન)

Phase 1 max 11×11 (cell ≥ 29 dp). Phase 2 grids 14×14 સુધી ⇒ 360 dp width (16 dp gutters) પર fit cell = `328 / 14 ≈ 23.4 dp` ⇒ zoom જરૂરી.

| Rule | Value |
|---|---|
| Enabled | Grid **≥ 12×12** (નાના grids પર zoom off, Phase 1 જેવું) |
| Start | **Auto-fit**: આખું board દેખાય (`scaleFit`) |
| Zoom range | `scaleFit` … `max(scaleFit, 48 dp / cellFit)` (max zoom પર cell = **48 dp**, Standard §17.23) |
| Gestures | 2-finger pinch = zoom (focal point સ્થિર) · 1-finger drag (zoomed) = pan · **double-tap zoom નથી** (Standard §17.23; double-tap = બે સામાન્ય taps) |
| Tap vs drag | **Touch slop 18 dp**: finger movement > 18 dp ⇒ drag (tap cancel). Long-press 350 ms preview: movement > 18 dp ⇒ preview cancel |
| Pan clamp | Board edge screen માં 24 dp થી વધુ અંદર ન જાય (board ખોવાય નહીં) |
| "Fit" button | HUD ના ઉપર જમણે 🔍 — tap ⇒ animated fit (250 ms) |
| Move? | Zoom/pan **Move નથી**, counters tick નહીં, input queue પર અસર નહીં |
| Exit animation | Line zoomed viewport ની બહાર જાય ⇒ camera follow **નહીં** (no auto-pan); off-screen lane preview edge arrow થી |
| Tutorial | L501 (pinch), L502 (pan), L503 (Fit button) — [02 §4](./02_LEVEL_PROGRESSION_0501_1000.md) |
| Accessibility | Settings → "Zoom buttons" ON ⇒ +/− buttons (pinch વગર) |

Tap hit-test inverse transform થી (zoom/pan પછી પણ એક જ cell): [06 §4](./06_FRONTEND_AND_QA_PHASE_2.md).

## 5. Diagonal Lines (M051, L511+)

### 5.1 Directions
`dir ∈ {U, D, L, R, UL, UR, DL, DR}`; `(dx, dy)`: U (0,−1), D (0,1), L (−1,0), R (1,0), UL (−1,−1), UR (1,−1), DL (−1,1), DR (1,1). Ants, bees અને canopy ત્રણેય diagonal હોઈ શકે.

### 5.2 Diagonal lane & body
- Lane = head + `(dx, dy)` પગલાં, board બહાર સુધી. Body cells 8-connected; exit animation માં body head ના trail ને follow કરે.
- **No-cutting rule:** diagonal પગલું `a → b` blocked જો `(a.x+dx, a.y)` અને `(a.x, a.y+dy)` બંને cells **એક જ same-layer line** ના **consecutive** body cells હોય. બે અલગ obstacles વચ્ચેથી diagonal squeeze allowed. Bump ⇒ head `a` પર bonk.
- Orthogonal-only devices — M006 Bamboo One-Way Tube, M014 Curled Leaf Deflector, M058 Spinning Seed Arrow, M086 Beetle-Shell Mirror — પર diagonal lane ⇒ **bump**. M052 Pinecone Bumper diagonal lanes ને જ વાળે (orthogonal ⇒ bump).
- Diagonal-aware Phase 1 mechanics: M008/M044/M076 portals (same diagonal dir; M044 rotates 90°), M013/M034/M045/M091 rotations (UR→DR→DL→UL), M018 Clover Switch (90° turn), M037 mud, M038 spring (diagonal next cell jump). M024 Double-File lines diagonal **નહીં** (validator).

### 5.3 Corner exit
Corner cell થી diagonal lane board છોડે ⇒ **બંને** adjacent sides cross કરે છે: એ corner cell ના કોઈ પણ side પર edge wall (M029/M030/M031/M071/M095 closed) હોય ⇒ bump; edge quota (M062) કોઈ પણ side marked હોય ⇒ 1 વાર ગણાય.

## 6. Three Layers — Canopy (M069, L691+)

### 6.1 Layers

| Layer | JSON `layer` | Insect | Visual offset | Introduced |
|---|---|---|---|---|
| Ground | 0 | Ant lines | 0 dp | L1 |
| Air | 1 | Bee lines | 6 dp up | L41 (M032 slot exception) |
| **Canopy** | **2** | **Canopy Scout Bee lines** (ઊંચે ઉડતી scout મધમાખીઓ, scale 0.9, આછો મોટો shadow) | 12 dp up | **L691 (M069)** |

Level JSON: `"layers": 3`. L1–690 માં `layer: 2` નહીં (validator).

### 6.2 Phase 2 Layer Rules (LR-P2, Phase 1 LR-1…LR-9 ઉપરાંત)

| # | Rule |
|---|---|
| LR-P2-1 | દરેક line **માત્ર પોતાના layer** ની lines સાથે collide (ants ↔ bees ↔ canopy ક્યારેય નહીં). |
| LR-P2-2 | Blocking formula (Standard §16.28) યથાવત્: `blocks(m, line) = m.layerAffects(line.layer)`, default `layer == 0 \|\| tall`. ⇒ **`tall: true` mechanics ત્રણેય layers block; `tall: false` માત્ર ground.** Canopy lane = canopy lines + tall mechanics. |
| LR-P2-3 | **Cover lock (M032 extended):** line locked જ્યાં સુધી કોઈ **ઊંચા layer** ની line તેના કોઈ body cell ઉપર હોય. Canopy કોઈથી cover-locked થતું નથી. |
| LR-P2-4 | **Tap priority:** interactive control > canopy > air > ground. |
| LR-P2-5 | Bee body (layer 1 અથવા 2) `tall: true` **blocking** mechanic ના cell પર નહીં (LR-8 extended). |
| LR-P2-6 | `params.layer` mechanics (M020, M061, M084, M087) layer 2 value L691+ જ. M056 ramp pair `[1, 2]` = Warm Updraft (L691+). |
| LR-P2-7 | Fog (M010/M075) ત્રણેય layers ને hide + lock કરે. M003 adjacency layer-independent (Standard §16.29) — canopy lines પણ ગણાય. |
| LR-P2-8 | Leaf Blower targeting: canopy > air > hammerable obstacle > ground. |

### 6.3 Why canopy (design note)
Underground tunnel layer ને બદલે "ઊંચું layer" પસંદ કર્યું કારણ કે (a) Standard `layer` indices 0 = ground, 1 = air fixed છે અને "ground / mid / top" (M069) સીધું 0/1/2 માં map થાય; (b) `tall` નો અર્થ એક જ રહે છે ("ઊંચું ⇒ ઉડનારાઓને નડે"); (c) cover-lock અને tap priority index order થી જ ચાલે — `puzzle_core` માં માત્ર `Layer.canopy` enum value ઉમેરાય.

## 7. Push Blocks (M053–M055, M083)

| Rule | Value |
|---|---|
| Push trigger | Line tap; lane નો **પહેલો blocker** push block હોય અને lane ત્યાં સુધી clear |
| Result | Block lane દિશામાં 1 cell ખસે (diagonal lane ⇒ diagonal). **Line ખસતી નથી.** 1 Move, heart નહીં |
| Destination free | Board અંદર (અથવા **open edge** બહાર — નીચે) · block ને અસર કરતા layers માં body નહીં (Acorn `tall:false` ⇒ ground; Pumpkin `tall:true` ⇒ ત્રણેય) · કોઈ blocking mechanic / બીજો block નહીં · underlying cell ખાલી, M054 slick leaf અથવા M055 socket plate જ |
| Not free | ⇒ normal **bump** (−1 Heart). Chain push નહીં (block પાછળ block ⇒ bump) |
| Board edge (Standard §17.29) | Block ને **open** board edge પાર push કરો ⇒ block **બહાર પડે અને remove** થાય (કંઈ count નથી થતું; 1 Move, heart નહીં). Walled/closed edge (M029/M030/M031/M071/M078/M095 closed) ⇒ bump. M054 slide edge સુધી પહોંચે ⇒ open edge પર એ જ રીતે પડી જાય |
| Slick leaf (M054) | Slick cell પર પહોંચેલો block એ જ દિશામાં સરકે જ્યાં સુધી આગળનો cell not free અથવા non-slick cell પર પહોંચે |
| Plates | M055 socket plate = block થી દબાય; M019 Acorn Plate = ant body થી (block ત્યાં જઈ શકતો નથી); M083 Stone Slab = Double-File ant line થી |
| Hammerable | **Yes** (Standard §16.18) — M053/M054 push blocks (Rolling Acorn, Garden Pumpkin) Leaf Blower થી remove; slick leaf (M054 floor) અને socket plate (M055) નહીં |
| Group | Chained/trio member નો push બીજા member ના bump સાથે ⇒ આખું group bump (push પણ revert) |
| Undo | Dewdrop Rewind block position + slide revert |

## 8. Light Beams — Sunbeams & Dew Prisms (M084–M086, M089, M099)

### 8.1 Beam model
- **Sunbeam Lens (M084)** `params.dir` (U/D/L/R — beams orthogonal only) અને `params.layer` (0 = ground sunbeam ઘાસ પર, 1 = air, 2 = canopy) સાથે beam મોકલે. Validator: `layer ≥ 1 ⇒ lens tall: true`.
- Beam એ જ layer માં cell-by-cell આગળ વધે અને **અટકે**: (a) beam layer ની પહેલી line body, (b) beam layer ને block કરતું mechanic (`layerAffects(beamLayer)` — closed gates, blockers, push blocks, lens પોતે), (c) board edge, (d) Sun-Seeker Sunflower (absorb).
- Devices: Beetle-Shell Mirror (M086) 90° reflect, Dew Prism (M089) ⇒ ડાબે + જમણે 2 beams, Pinecone Bumper (M052) ⇒ beam stop. Device beam ને ત્યારે જ અસર કરે જ્યારે `layerAffects(beamLayer)` (layer ≥ 1 beams માટે device `tall: true` જોઈએ).
- Loop guard: `(cell, dir)` revisit ⇒ beam ત્યાં stop (validator loops reject કરે).

### 8.2 Lanes vs beams
| Case | Result |
|---|---|
| Lane beam cell (same layer) cross કરે | **Bump** at that cell (−1). Beam = blocker |
| Lane બીજા layer ના beam cell પરથી | Unaffected (ground beam bees ને નડતું નથી; air beam ants ને નહીં) |
| Line body beam ને રોકે, પછી exit | Exit lane **pre-move** beam state વાપરે; beam step (4b) માં લંબાય |
| Beam receiver hit | M085 linked gates open **while hit**; M099 Royal Hive Door condition |
| Line body beam cell પર | શક્ય નથી — body હોય ત્યાં beam અટકે જ (body = beam end) |

### 8.3 No cycles
Receiver-linked gate (M085) કોઈ beam route પર મૂકી શકાય નહીં (validator, બધા gates open ધારીને static route) ⇒ beam ↔ gate feedback loop અશક્ય ⇒ step (4) single pass deterministic.

## 9. Tick Order & Derived State (Standard §16.17 — binding)

દરેક Move:

1. **Action resolve** — tap/control, lane trace (pre-move state), exit/bump/push/slide/split/swap/unstick, on-exit hooks (keys, M003, fog clear, M035 spawn, M049/M098 HP, M077 puffball, M097 domino, M061 capacity, M064 seesaw flips, M073 bubble pop, M068 drop creation queued).
2. `moveCount += 1`.
3. **Counters tick** (Phase 1): M007, M017, M031, M025 (+ **M098** patrol M025 slot માં, Standard §17.32), M027, M047, M041 → (Phase 2, ક્રમમાં): **M057, M058, M063, M067, M068, M075, M079, M082, M090, M096**.
4. **Derived states** sub-order: (4a) plates M019/M055/M083 → their gates · (4b) beams M084/M086/M089 · (4c) receivers M085 → their gates · (4d) fog M010/M075 visibility · (4e) cages M033 · (4f) locks/edges M004, M043, M065, M071, M080, M088, M095, M099 · (4g) cover-lock & mimic dir (M081).
5. Heart loss (Queen's Royal Shield પહેલાં absorb).
6. **Win check** (બધી lines exit + goals: M026 gems, M062 quota).
7. 0-heart check ⇒ Second Chance.

- Parity mechanics (M021, M090, M096) Move increment **પહેલાંનો** parity વાપરે (Standard).
- M090/M096 step 3 માં "tick" = parity re-evaluation (state store નથી), list order માટે સામેલ.
- Goal impossible (M062 quota અશક્ય) ⇒ step 6 પછી "Goal can't be completed" banner: Dewdrop Rewind / Restart; **heart નહીં, auto-fail નહીં** (Standard §17.8).
- **Bumped Moves lane-based કંઈ બદલતા નથી** (Standard §17.30): paint, mixing, seesaw flips, key/item pickup, floor wear, trails, quotas, Mimic updates માત્ર line exit કે relocate થાય ત્યારે. Bump Move માત્ર `moveCount` + counters tick કરે.
- **Soft-lock** (Standard §17.31): solver ને boosters વગર winning sequence ન મળે ⇒ "Stuck" sheet (Dewdrop Rewind / Restart); heart loss નહીં, fail screen નહીં; logged `E-GAME-004`.

## 10. Tap Target Resolution — Phase 2 order

1. Interactive control: Twig Lever, Root Gear Lever, Clover Switch, Spinning Daisy, Lily-Pad Rotor hub, **Twin Mushroom Swap (M060), Compass Flower Lever (M070), Ivy Lever (M074), Giant Lily-Pad Rotor hub (M091)**.
2. Canopy line body (visible; M096 invisible shadow skip).
3. Air line body.
4. Ground line body.
5. Nothing ⇒ ignore (6 dp slop rule Phase 1 મુજબ, zoom પછી screen dp માં).

Locked results (cover, fog, tangled, wrong garland color, rotor partial) ⇒ wobble + "tsk", no Move, no heart.

## 11. Economy Changes in Phase 2 (Standard §6–§7 મુજબ જ)

| Item | Phase 2 value | Source |
|---|---|---|
| Queen's Gift Box (x0, L510–L990) | **300 coins** + 1 booster `(L/10) mod 4` (1 Hint, 2 Leaf Blower, 3 Shield, 0 Undo) | Standard §6.1 |
| Royal Honey Chest (L1000) | **1,000 coins + 2 of each booster + "Garden Trails II" badge**, Gift Box ની જગ્યાએ | Standard §6.1 |
| Golden Nectar Rush | L525, 550, …, 1000 first clear પછી; **30 lines**, 10/line, +100 ⇒ max 400 | Standard §6.1, §16.9 |
| Clear coins | Easy 15 / Normal 20 / Hard 30 / Finale 50; first ★★★ +20 | Standard §6.1 |
| Golden Honeycomb Bank (Piggy Bank) | +10 per first-clear level (accrual **L31+**), break from **350** stored, IAP ₹49, max 1,000 stored coins (Standard §17.26) | Standard §7.2 — [04 §4](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) |
| Cosmetics (insect skins, garden themes) | **800–4,000 coins** (coin sink) | Standard §6.2 — [04 §5](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) |
| Weekly Star Race rewards | 1st 1,000 + frame + 3 each booster · 2nd 500 + 2 Leaf Blower + 1 Hint · 3rd 250 + 1 Shield · 4th–5th 50 | Standard §6.1 ([04 §3](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)); ghosts ને rewards નહીં |
| Flora & Fauna Compendium volume complete | **300 / 400 / 600 / 800 / 1,000 coins** (Vol 1–5) + 1 cosmetic each | Standard §6.1, §17.26 — [04 §2](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) |

બાકી બધું (booster prices, Heart Refill 120, Queen's Favor 200, Sunflower Spin odds, shop ad +50 ×5/day, IAP packs) **યથાવત્**.

## 12. Daily Garden Almanac in Phase 2

- Difficulty: `max(15, highestCleared − 10)` ના x6 slot params (Standard §16.11) ⇒ Phase 2 players ને Phase 2 boards; **માત્ર unlocked mechanics**.
- Saturday Big Board = tier max grid (P2-B ⇒ 14×14, zoom on). Sunday Mini Boss = Great Orb Spider (M049) (Standard; M098 નહીં).
- Daily silhouettes 7 (Leaf … Beehive) યથાવત્; mask-board પર diagonal lines allowed (L511+ players).

## 13. Phase 2 Edge Cases (ખાસ કિસ્સા)

| # | Situation | Result |
|---|---|---|
| P2-E1 | Pinch દરમિયાન line exit animation ચાલુ | Animation ચાલુ રહે; zoom smooth; queued tap viewport transform થી resolve |
| P2-E2 | Long-press કરતાં finger 12 dp ખસે | Preview cancel ⇒ pan શરૂ; tap fire નહીં |
| P2-E3 | Diagonal lane બે pebbles વચ્ચેથી (diagonal adjacent) | Pass (squeeze allowed) |
| P2-E4 | Diagonal lane બીજી ant line ની diagonal link કાપે | Bump (no-cutting) |
| P2-E5 | Canopy line air line ઉપર, air line ant ઉપર | ક્રમ: canopy → air → ant; વચ્ચેનાં taps locked |
| P2-E6 | Tall Sunflower Stalk canopy lane માં | Bump (tall ત્રણેય layers) |
| P2-E7 | Ground sunbeam bee lane cross | Bee unaffected |
| P2-E8 | Push block board edge પર, આગળ open edge | Block બહાર પડે, removed (Move +1, heart નહીં); walled/closed edge ⇒ bump |
| P2-E9 | Leaf Blower Pumpkin ને M054 leaf પર | Block removed, leaf રહે |
| P2-E10 | M062 quota અશક્ય | Banner, Undo/Restart, heart નહીં |
| P2-E11 | Dewdrop Rewind after board rotation (M079) | Rotation revert (Move undo) |
| P2-E12 | Zoom દરમિયાન Golden Nectar Rush | Rush boards ≤ 11×11 ⇒ zoom off |

# 02 — Level Progression, Levels 1–500 (લેવલ પ્રોગ્રેશન)
Phase 1 ના 500 levels નું blueprint: tiers, 10-level block pattern, FTUE, booster tutorials, દરેક 10-level block નો full table અને L500 Finale.

**Related docs:** [Shared Core Standard §9, §10, §12](../../SHARED_CORE_STANDARD.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) · [04 Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md) · [05 Daily & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) · [Scaling to 10,000](../SCALING_TO_10000_LEVELS.md)

---

## 1. Tier Table (ટિયર)

| Tier | Levels | Grid | Lines (paths) | Max obstacle instances | D band |
|---|---|---|---|---|---|
| FTUE | 1–3 | 4×4–5×5 | 2–4 | 0 | 1–4 |
| FTUE | 4–10 | 5×5–6×6 | 4–8 | 0 | 3–8 |
| T1 | 11–100 | 6×6–8×8 | 6–14 | 1–4 | 6–18 |
| T2 | 101–200 | 7×7–9×9 | 10–18 | 3–6 | 14–26 |
| T3 | 201–300 | 8×8–10×10 | 14–22 | 4–8 | 22–36 |
| T4 | 301–400 | 9×9–10×10 | 18–26 | 5–9 | 30–44 |
| T5 | 401–500 | 10×10–11×11 | 22–30 | 6–10 | 38–52 |

- Phase 1 max **11×11** ⇒ 360 dp phone (16 dp gutters) પર cell ≥ **29 dp** ([06 §4](./06_UI_UX_SCREENS.md)). Pinch-zoom Phase 1 માં નથી.
- **D** = `0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S` (Standard §9.4). Generator level નો D slot target band (±3) માં ન આવે તો reject.
- Lines count માં ants + bees બંને ગણાય (P).

## 2. The 10-Level Block Pattern (દર 10 levels એ નવું)

| Slot | Role | Difficulty | JSON `slot` | JSON `tag` | Clear coins |
|---|---|---|---|---|---|
| x1 | **Intro:** નવું mechanic, ફક્ત તે + ≤ 1 જૂનું; tutorial hand/tooltip | Band low | `intro` | `normal` | 20 |
| x2–x4 | Practice: નવું + જૂના mix | low → mid | `practice` | `normal` | 20 |
| x5 | Breather | low | `breather` | `easy` | 15 |
| x6–x8 | Ramp | mid → high | `ramp` | `normal` | 20 |
| x9 | **Hard** (red badge) | high +10% | `hard` | `hard` | 30 |
| x0 | Milestone — **Queen's Gift Box** | mid | `milestone` | `normal` | 20 |

- L500 = Phase Finale, `slot: finale`, `tag: finale`, band high +20%, clear coins **50**.
- Level JSON માં બંને fields ફરજિયાત: `slot` = block role, `tag` = coin label ([Standard §16.15](../../SHARED_CORE_STANDARD.md)). `tag: intro` જેવું કોઈ value નથી.
- FTUE (L1–10) પણ આ pattern અનુસરે, પણ **Hard tag નથી** ([Standard §16.3](../../SHARED_CORE_STANDARD.md)): L5 `breather`/`easy`, L9 `ramp`/`normal` (D 7–8, ≤ 8 Moves). પહેલું Hard = **L19**.

## 3. Layer Schedule & the M004/M032 Swap (Ant/Bee introduction)

| Levels | Layers | Bee share of lines | Notes |
|---|---|---|---|
| 1–40 | `layers: 1` — **ants only** | 0% | Pebbles, Twig Fences, Dew-Stuck Lines |
| 41 | `layers: 2` intro | 2–3 bee lines | **M032 Bee Lines** (M004 slot). Tooltip: "Bees fly over ants — they never bump each other." 1 cover-lock teaching moment. |
| 42–50 | 2 | 20–30% | L42: પહેલું **Sunflower Stalk** (M001 `tall: true`) — tooltip "Tall plants block bees too." |
| 51–100 | 2 (≥ 70% levels) | 20–35% | Tall variants of M001/M002/M005/M007/M009 gates allowed |
| 101–300 | 2 (≥ 80% levels) | 25–45% | Air-relevant mechanics (fog, path-variants, hive) |
| 301–500 | 2 (≥ 85% levels) | 30–50% | **M004 Dew Key & Thorn Lock at L321** (M032 slot); cross-layer keys |

- Standard §10 exception: Game 4 માં bees L41 (M004 slot) અને Key & Lock L321 (M032 slot). JSON `type` engine ID રાખે ([03 §1.2](./03_OBSTACLE_CATALOG_PHASE_1.md)).
- **L41–320 માં key/lock mechanics નથી.** M043 (L431) અને M046 (L461) key mechanics L321 પછી જ આવે છે — dependency order સાચો રહે છે.
- x5 breather levels: bee share ≤ 25% (સરળ).

## 4. FTUE — Levels 1–10 (પહેલા 10 levels)

Design rule (CI): L1–3 optimal ≤ 4 Moves, L4–10 ≤ 8 Moves. Analytics target: L1–3 median clear ≤ 10 s, L4–10 ≤ 20 s. બધા FTUE levels **hand-tuned**, માત્ર ant lines, કોઈ obstacle નહીં. Interstitial ads L1–10 માં ક્યારેય નહીં; gameplay banner L11 થી.

| L | Grid | Lines | D | Slot / Tag | Teaches / tutorial step (`ftue_step`) |
|---|---|---|---|---|---|
| 1 | 4×4 | 2 | 1–2 | intro / normal | Hand on line: "Tap a line — the ants march out!" બંને lines independent. (step 1) |
| 2 | 4×4 | 3 | 2–3 | practice / normal | Order: એક line બીજીની lane માં. Hand "Clear the way first." (step 2) |
| 3 | 5×5 | 4 | 3–4 | practice / normal | **Nectar Glow Hint tutorial** — 3 free Hints grant; hand on Hint button, scripted 1 use. (step 3) |
| 4 | 5×5 | 4–5 | 3–5 | practice / normal | **Scent Trail Preview** — "Hold a line to see its trail" (long-press 350 ms). (step 4) |
| 5 | 5×5 | 5 | 3–4 | breather / easy | Breather; Hearts HUD tooltip "A bonk costs 1 heart" (bump forced નથી). (step 5) |
| 6 | 6×6 | 6 | 4–6 | ramp / normal | Chain depth 2. |
| 7 | 6×6 | 6–7 | 5–7 | ramp / normal | Chain depth 3; stars explanation on Level Complete. (step 6) |
| 8 | 6×6 | 7 | 5–7 | ramp / normal | **Dewdrop Rewind (Undo) tutorial** — 3 free Undo grant; પહેલા exit પછી hand on Undo, line પાછી આવે, ફરી tap. (step 7) |
| 9 | 6×6 | 8 | 7–8 | ramp / normal | 8 lines, chain depth 3. FTUE માં Hard badge **નથી** (પહેલો red "Hard" badge L19). |
| 10 | 6×6 | 8 | 6–7 | milestone / normal | પહેલો **Queen's Gift Box**: 150 coins + 1 Nectar Glow Hint. Level Map unlock tooltip. (step 8) |

## 5. Booster Tutorials & Feature Unlocks (અનલૉક સમયપત્રક)

| Level | Unlock / event | Grant |
|---|---|---|
| L3 | Nectar Glow Hint (Hint) tutorial | 3 Hint |
| L8 | Dewdrop Rewind (Undo) tutorial | 3 Undo |
| L11 | પહેલું obstacle (Garden Pebble); gameplay banner ads શરૂ | — |
| L15 | Queen's Royal Shield (Shield) tutorial (x5 breather પર, scripted activate) | 1 Shield |
| L15 clear | **Daily Garden Almanac** unlock; **Starter Pack** offer (48 h); interstitial first eligible win | — |
| L25 | Leaf Blower (Hammer) tutorial (scripted: 1 Twig Fence ઉડાડો) | 1 Hammer |
| L25 clear | પહેલો **Golden Nectar Rush** | — |
| L41 | Bee Lines intro (air layer) | — |
| L500 | Royal Honey Chest + Phase badge | 1,000 + 2 each booster |

- Starting wallet: **200 coins**; tutorial grants ઉપર મુજબ (કુલ 3 Hint + 3 Undo + 1 Shield + 1 Hammer).
- Booster unlock પહેલાં booster bar માં તે button **locked** (lock icon). Gift Box / streak થી unlock પહેલાં મળેલું booster inventory માં જમા રહે અને unlock થાય ત્યારે વાપરી શકાય (દા.ત. L20 Gift Box Leaf Blower, L25 પહેલાં).

## 6. Full Block Table, L1–500 (દરેક 10-level block)

Columns: **New mechanic** = x1 intro (ID + themed name; ⇄ = swapped slot). **Grid / Lines / D band** = block x1→x8 target range (slot band ±3). **Hard** = x9 level + target D (block high +10%). **Gift Box** = x0 reward (coins + booster `(L/10) mod 4`: 1 = Nectar Glow Hint, 2 = Leaf Blower, 3 = Queen's Royal Shield, 0 = Dewdrop Rewind). **Rush** = Golden Nectar Rush insertion.

| # | Levels | New mechanic (x1) | Grid | Lines | D band | Hard (x9) | Gift Box (x0) | Coin Rush |
|---|---|---|---|---|---|---|---|---|
| 1 | 1–10 | — (FTUE: ants only, no obstacles) | 4×4–6×6 | 2–8 | 1–8 | — (L9 Normal, §16.3) | 150 + Nectar Glow Hint | — |
| 2 | 11–20 | **M001** Garden Pebble | 6×6–7×7 | 6–7 | 6–7 | L19 (D 8) | 150 + Leaf Blower | — |
| 3 | 21–30 | **M002** Twig Fence | 6×6–7×7 | 6–8 | 7–9 | L29 (D 10) | 150 + Queen's Royal Shield | after L25 |
| 4 | 31–40 | **M003** Dew-Stuck Line | 6×6–7×7 | 7–9 | 9–10 | L39 (D 11) | 150 + Dewdrop Rewind | — |
| 5 | 41–50 | **M032** ⇄ Bee Lines (Air Layer) | 6×6–7×7 | 8–10 | 10–11 | L49 (D 12) | 150 + Nectar Glow Hint | after L50 |
| 6 | 51–60 | **M005** Petal Gate | 6×6–8×8 | 9–11 | 11–13 | L59 (D 14) | 150 + Leaf Blower | — |
| 7 | 61–70 | **M006** Bamboo One-Way Tube | 7×7–8×8 | 10–12 | 13–14 | L69 (D 15) | 150 + Queen's Royal Shield | — |
| 8 | 71–80 | **M007** Morning Glory Gate | 7×7–8×8 | 11–13 | 14–15 | L79 (D 16) | 150 + Dewdrop Rewind | after L75 |
| 9 | 81–90 | **M008** Burrow Tunnel Pair | 7×7–8×8 | 12–14 | 15–17 | L89 (D 19) | 150 + Nectar Glow Hint | — |
| 10 | 91–100 | **M009** Twig Lever & Vine Gates | 7×7–8×8 | 13–14 | 17–18 | L99 (D 20) | 150 + Leaf Blower | after L100 |
| 11 | 101–110 | **M010** Morning Mist | 7×7–8×8 | 10–11 | 14–15 | L109 (D 16) | 180 + Queen's Royal Shield | — |
| 12 | 111–120 | **M011** Petal-Linked Pair | 7×7–8×8 | 10–12 | 15–16 | L119 (D 18) | 180 + Dewdrop Rewind | — |
| 13 | 121–130 | **M012** Napping Line | 7×7–8×8 | 11–13 | 16–18 | L129 (D 20) | 180 + Nectar Glow Hint | after L125 |
| 14 | 131–140 | **M013** Spinning Daisy | 7×7–8×8 | 12–14 | 18–19 | L139 (D 21) | 180 + Leaf Blower | — |
| 15 | 141–150 | **M014** Curled Leaf Deflector | 7×7–8×8 | 13–14 | 19–20 | L149 (D 22) | 180 + Queen's Royal Shield | after L150 |
| 16 | 151–160 | **M015** Twig Bridge | 8×8–9×9 | 14–15 | 20–21 | L159 (D 23) | 180 + Dewdrop Rewind | — |
| 17 | 161–170 | **M016** Crumbly Dirt Clod | 8×8–9×9 | 14–16 | 21–22 | L169 (D 24) | 180 + Nectar Glow Hint | — |
| 18 | 171–180 | **M017** Rain-Alert Line | 8×8–9×9 | 15–17 | 22–24 | L179 (D 26) | 180 + Leaf Blower | after L175 |
| 19 | 181–190 | **M018** Clover Switch | 8×8–9×9 | 16–18 | 24–25 | L189 (D 28) | 180 + Queen's Royal Shield | — |
| 20 | 191–200 | **M019** Acorn Pressure Plate | 8×8–9×9 | 17–18 | 25–26 | L199 (D 29) | 180 + Dewdrop Rewind | after L200 |
| 21 | 201–210 | **M020** Anthill & Hive Entrance | 8×8–9×9 | 14–15 | 22–23 | L209 (D 25) | 210 + Nectar Glow Hint | — |
| 22 | 211–220 | **M021** Hide-and-Seek Line | 8×8–9×9 | 14–16 | 23–25 | L219 (D 28) | 210 + Leaf Blower | — |
| 23 | 221–230 | **M022** Backward-Walking Line | 8×8–9×9 | 15–17 | 25–26 | L229 (D 29) | 210 + Queen's Royal Shield | after L225 |
| 24 | 231–240 | **M023** Two-Way Scout Line | 8×8–9×9 | 16–18 | 26–28 | L239 (D 31) | 210 + Dewdrop Rewind | — |
| 25 | 241–250 | **M024** Double-File Line | 8×8–9×9 | 17–18 | 28–29 | L249 (D 32) | 210 + Nectar Glow Hint | after L250 |
| 26 | 251–260 | **M025** Patrolling Ladybug | 9×9–10×10 | 18–19 | 29–30 | L259 (D 33) | 210 + Leaf Blower | — |
| 27 | 261–270 | **M026** Sugar Crumbs & Nectar Drops | 9×9–10×10 | 18–20 | 30–32 | L269 (D 35) | 210 + Queen's Royal Shield | — |
| 28 | 271–280 | **M027** Creeping Moss | 9×9–10×10 | 19–21 | 32–33 | L279 (D 36) | 210 + Dewdrop Rewind | after L275 |
| 29 | 281–290 | **M028** Marching Order | 9×9–10×10 | 20–22 | 33–35 | L289 (D 38) | 210 + Nectar Glow Hint | — |
| 30 | 291–300 | **M029** Brick Edging | 9×9–10×10 | 21–22 | 35–36 | L299 (D 40) | 210 + Leaf Blower | after L300 |
| 31 | 301–310 | **M030** Painted Garden Gate | 9×9–10×10 | 18–19 | 30–31 | L309 (D 34) | 250 + Queen's Royal Shield | — |
| 32 | 311–320 | **M031** Latching Gate | 9×9–10×10 | 18–20 | 31–33 | L319 (D 36) | 250 + Dewdrop Rewind | — |
| 33 | 321–330 | **M004** ⇄ Dew Key & Thorn Lock | 9×9–10×10 | 19–21 | 33–34 | L329 (D 37) | 250 + Nectar Glow Hint | after L325 |
| 34 | 331–340 | **M033** Flower-Bud Cage | 9×9–10×10 | 20–22 | 34–36 | L339 (D 40) | 250 + Leaf Blower | — |
| 35 | 341–350 | **M034** Lily-Pad Rotor | 9×9–10×10 | 21–22 | 36–37 | L349 (D 41) | 250 + Queen's Royal Shield | after L350 |
| 36 | 351–360 | **M035** Brood Line | 9×9–10×10 | 22–23 | 37–38 | L359 (D 42) | 250 + Dewdrop Rewind | — |
| 37 | 361–370 | **M036** Hungry Line | 9×9–10×10 | 22–24 | 38–40 | L369 (D 44) | 250 + Nectar Glow Hint | — |
| 38 | 371–380 | **M037** Mud Puddle | 9×9–10×10 | 23–25 | 40–41 | L379 (D 45) | 250 + Leaf Blower | after L375 |
| 39 | 381–390 | **M038** Mushroom Spring | 9×9–10×10 | 24–26 | 41–43 | L389 (D 47) | 250 + Queen's Royal Shield | — |
| 40 | 391–400 | **M039** Mirror-Twin Lines | 9×9–10×10 | 25–26 | 43–44 | L399 (D 48) | 250 + Dewdrop Rewind | after L400 |
| 41 | 401–410 | **M040** Twilight Garden | 10×10–11×11 | 22–23 | 38–39 | L409 (D 43) | 300 + Nectar Glow Hint | — |
| 42 | 411–420 | **M041** Rainbow Pollen Line | 10×10–11×11 | 22–24 | 39–41 | L419 (D 45) | 300 + Leaf Blower | — |
| 43 | 421–430 | **M042** Dry Leaf Bridge | 10×10–11×11 | 23–25 | 41–42 | L429 (D 46) | 300 + Queen's Royal Shield | after L425 |
| 44 | 431–440 | **M043** Bramble Multi-Lock | 10×10–11×11 | 24–26 | 42–44 | L439 (D 48) | 300 + Dewdrop Rewind | — |
| 45 | 441–450 | **M044** Twisting Burrow | 10×10–11×11 | 25–26 | 44–45 | L449 (D 50) | 300 + Nectar Glow Hint | after L450 |
| 46 | 451–460 | **M045** Root Gear Lever | 10×10–11×11 | 26–27 | 45–46 | L459 (D 51) | 300 + Leaf Blower | — |
| 47 | 461–470 | **M046** Ring-Around Line | 10×10–11×11 | 26–28 | 46–48 | L469 (D 53) | 300 + Queen's Royal Shield | — |
| 48 | 471–480 | **M047** Recruiting Line | 10×10–11×11 | 27–29 | 48–49 | L479 (D 54) | 300 + Dewdrop Rewind | after L475 |
| 49 | 481–490 | **M048** Colony Call | 10×10–11×11 | 28–30 | 49–51 | L489 (D 56) | 300 + Nectar Glow Hint | — |
| 50 | 491–500 | **M049** Great Orb Spider | 10×10–11×11 | 29–30 | 51–52 | L499 (D 57) | **Royal Honey Chest** (1,000 + 2 each booster + badge) | after L500 |

Notes:
- Tier boundary પર (L101, L201, L301, L401) lines/D band નવા tier ના low પર શરૂ થાય પણ grid મોટી થાય — Standard tier table મુજબ. Overall difficulty curve grid + mechanics count થી વધે છે.
- **Coin Rush column** = દર 25 levels (25, 50, 75, 100, …, 500). x0 levels (50, 100, …) પર પહેલાં Gift Box/Chest, પછી Rush.
- દરેક block નું x1 intro **hand-tuned**; x9 Hard અને Finale પણ hand-tuned; L1–30 બધા hand-tuned (Standard §12). બાકીના generator + designer pass.

## 7. Post-Level Reward Order (Gift Box, Rush, ads)

Win પછી screens નો ક્રમ (એક જ win પર):

1. **Level Complete** (stars, coins, 2X Win rewarded option).
2. **Queen's Gift Box** — જો level x0 હોય (L10, L20, …, L490). L500 પર તેની જગ્યાએ **Royal Honey Chest**.
3. **Golden Nectar Rush** — જો level 25 નો ગુણાંક હોય (L25, L50, …, L500). L50/L100/… પર Gift Box **પછી**.
4. Next level / Level Map.

- Win screen પર Gift Box / Rush / Chest હોય ⇒ interstitial **defer** (આગલી eligible win પર). Rush પછી interstitial **ક્યારેય નહીં**.
- Rush level number નથી — Level Map પર "honey jar" marker તરીકે દેખાય; "Skip" button ⇒ Rush ત્યાં end, ત્યાં સુધીના coins રહે ("Later" નહીં). Details: [04 §8](./04_BOOSTERS_COINS_SHOP.md).
- Replay wins પર Gift Box / Rush ફરી નથી મળતા (first clear only).

## 8. L500 Phase Finale — "Queen's Garden Gala"

| Item | Spec |
|---|---|
| Grid | 11×11 |
| Lines | 28–30 (≥ 30% bees) |
| D | ≈ 62 (T5 high 52 +20%) — validator band 59–65 |
| Boss | **Great Orb Spider (M049)** 2×2 web at centre, HP = 4 linked lines (2 ants + 2 bees) |
| Mechanics mix (Guardian + 9 others = T5 max 10, [Standard §16.35](../../SHARED_CORE_STANDARD.md)) | M004 Dew Key & Thorn Lock, M009 Twig Lever & Vine Gates (1 tall gate), M013 Spinning Daisy, M020 Hive Entrance, M026 Nectar Drops (goal 3), M028 Marching Order, M037 Mud Puddle, M041 Rainbow Pollen Line, M047 Recruiting Line (બરાબર 9 instances; designer set બદલી શકે પણ count નહીં) |
| Flow | Phase 1: ground ants ખાલી કરી key મેળવો → Phase 2: lever થી tall gate ખોલી bees ને hive સુધી → Phase 3: spider ની linked lines exit ⇒ spider ચાલ્યો જાય → છેલ્લી lines ઉજવણી સાથે બહાર |
| Visual | Gala theme: lantern flowers, Queen Bee cameo hive પર; finale music sting |
| Reward | Clear coins **50** (`tag: finale`) + **Royal Honey Chest**: 1,000 coins + 2 Hint + 2 Undo + 2 Shield + 2 Hammer + "Garden Trails I" badge; પછી Golden Nectar Rush (L500 = 25 નો ગુણાંક) |
| After | **Phase Complete** screen ([06](./06_UI_UX_SCREENS.md)); Phase 2 locked રહે ત્યાં સુધી app update ([Phase 2](../phase_2/README.md)) |

Validator: 0 hearts / 0 boosters solvable, solver node limit 2M, depth ≤ 3×P.

## 9. Level Pipeline (ટૂંકમાં)

- `tools/levelgen` (Dart CLI, shared `puzzle_core`) ⇒ `assets/levels/phase_1.json.gz`.
- **Reverse construction** per layer (Standard §12): empty board થી lines એક પછી એક મૂકો; દરેક નવી line ની exit lane **અત્યાર સુધી મૂકેલી lines થી ખાલી** રહે ⇒ છેલ્લે મૂકેલી line પહેલી exit થઈ શકે; **solution order = placement નો reverse**. Air layer માટે blockers = bee lines + tall obstacles જ.
- Stateful mechanics (C, T, K, X) ⇒ solver ફરજિયાત (BFS/IDA*, node limit 2M, depth ≤ 3×P). Output `solution` + `par_moves`.
- CI validator: 0-heart/0-booster solvable · D in band · no line initially locked forever (cover-lock સહિત) · cell ≥ 29 dp · intro levels = intro mechanic + ≤ 1 earlier · L1–40 `layers: 1` · L1–320 no `M004` · tall only L42+ ([03 §4](./03_OBSTACLE_CATALOG_PHASE_1.md)).
- Phase 3+ scaling: [SCALING_TO_10000_LEVELS.md](../SCALING_TO_10000_LEVELS.md).

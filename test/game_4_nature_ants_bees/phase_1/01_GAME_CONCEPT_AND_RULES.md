# 01 — Game Concept & Rules (ગેમ કોન્સેપ્ટ અને નિયમો)
"Ants & Bees: Garden Trails" નો concept, art direction, core loop અને **બધા gameplay rules** (ant/bee layer rule સહિત) — rules engine માટે developer-ready reference.

**Related docs:** [Shared Core Standard](../../SHARED_CORE_STANDARD.md) · [Game README](../README.md) · [Phase 1 README](./README.md) · [02 Level Progression](./02_LEVEL_PROGRESSION_0001_0500.md) · [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) · [04 Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md) · [06 UI/UX Screens](./06_UI_UX_SCREENS.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Concept (કોન્સેપ્ટ)

| Item | Value |
|---|---|
| Title | **Ants & Bees: Garden Trails** |
| Genre | Path-clear logic puzzle (turn-based, deterministic) |
| Audience | Age 10–50 (mixed audience — [Standard §7.3](../../SHARED_CORE_STANDARD.md)) |
| Platform | Android + iOS, Flutter 3.x, portrait only |
| Session | 1 level ≈ 20 s (FTUE) થી 2–4 min (T5) |

**Pitch:** સન્ની બગીચાની grid પર કીડીઓની લાઈનો (ant lines) જમીન પર અને મધમાખીઓની લાઈનો (bee lines) હવામાં ગોઠવાયેલી છે. દરેક લાઈનનું **head insect** જે દિશામાં મોં રાખે છે તે દિશામાં જ લાઈન બહાર જઈ શકે. Player યોગ્ય ક્રમમાં લાઈનો પર tap કરીને આખો બગીચો ખાલી કરે છે. અથડામણ (bump) થાય તો head insect "bonk" કરીને પાછી આવે અને 1 Heart જાય.

**USP:** બે layers — **Ground (કીડીઓ)** અને **Air (મધમાખીઓ)** — જે એકબીજાને ક્યારેય નડતાં નથી, પણ ઊંચા (`tall`) obstacles બંનેને નડે છે. એક જ cell પર કીડી નીચે અને મધમાખી ઉપર હોઈ શકે, એટલે board "બે puzzles એકસાથે" જેવું લાગે છે (L41 થી).

## 2. Art Direction (આર્ટ દિશા)

- **Style:** 2D `CustomPainter` rendering, **"soft 3D" look** — radial/linear gradients, rim highlight, અને **pre-baked** soft shadows (sprite atlas માં). Real 3D / shaders / per-frame blur **નથી** ([Standard §13](../../SHARED_CORE_STANDARD.md)).
- **Board:** લીલી lawn tile grid (હળવા checker tone), cell corners પર ઝાકળ (dew) ના નાના dots, board ફરતે soil-brown rim.
- **Ants (Ground layer):** ગોળમટોળ 3-segment body (head, thorax, abdomen), abdomen line ના `color` માં ચમકતું; head insect ના માથે નાના antennae અને color-blind **glyph** ([06 §2.1](./06_UI_UX_SCREENS.md)). Shadow: ટૂંકો, ઘાટો contact shadow.
- **Bees (Air layer):** પીળી-કાળી પટ્ટી, પટ્ટીમાં એક band line ના `color` માં; પારદર્શક પાંખો. Bee lines ground થી **6 dp ઉપર offset** માં દોરાય અને તેમનો shadow 6 dp નીચે-જમણે, હળવો અને મોટો — જેથી "હવામાં છે" તે તરત સમજાય.
- **Obstacles:** Ground-only (`tall: false`) obstacles નીચા અને પહોળા (pebble, twig), **Tall** (`tall: true`) obstacles ઊંચા stem સાથે (sunflower stalk, bramble) + લાંબો shadow + ટોચે નાનું **wing-icon "blocks bees" marker**.
- **Palette:** Lawn green, honey gold, sky cyan, soft earth — hex values [06 §2](./06_UI_UX_SCREENS.md) માં.
- **Audio mood:** હળવું acoustic garden loop, પક્ષીઓનો ધીમો ambient; SFX: ant "tip-tap" march, bee "bzzz" fly-off, soft "bonk", locked "tsk".

## 3. Core Loop (મુખ્ય લૂપ)

```
Home → Level Map → Level (tap lines → clear board) → Level Complete (coins, stars)
   ↑                                                     │
   └── Gift Box (x0) / Golden Nectar Rush (દર 25) / Daily / Shop ←┘
```
1. Level ખૂલે → board, 3 Hearts, booster bar.
2. Player lines પર tap કરે (દરેક tap = 1 Move) → lines બહાર જાય.
3. બધી lines exit (+ goals) ⇒ **Win** → coins + stars → next level.
4. Hearts 0 ⇒ Second Chance → Revive અથવા Level Failed → Retry (મફત).

## 4. Terms & Data Model (શબ્દો)

| Term | Game 4 meaning | Engine (puzzle_core) |
|---|---|---|
| Path | **Line** — એક ant line અથવા bee line; `body[0]` = **head insect** | `Path` |
| Ant line | Ground layer path, JSON `"layer": 0` | `layer == 0` |
| Bee line | Air layer path, JSON `"layer": 1` | `layer == 1` |
| Exit lane | Head ના આગળના cell થી `dir` દિશામાં board edge સુધીના cells (line ના **પોતાના layer** માં) | `laneCells(path)` |
| Move | Line પર tap (exit અથવા bump) અથવા interactive obstacle પર tap | `MoveCounter` |
| Tall obstacle | Mechanic instance `"tall": true` — બંને layers ને અસર કરે | `Mechanic.tall` |
| Board | W×H grid, `(x, y)`, origin top-left | `Board` |

Level JSON schema v3 વાપરે ([Standard §12](../../SHARED_CORE_STANDARD.md)). Game 4 extension: mechanic instance પર optional `"tall": bool` (default `false`); bees ધરાવતા levels માં `"layers": 2`.

## 5. The Layer Rule (લેયર નિયમ — fixed, canonical)

> **આ rule આખા spec માં એકસરખો છે. બીજા docs આ section ને refer કરે છે.**

| # | Rule |
|---|---|
| LR-1 | **Ants = Ground layer (`layer: 0`). Bees = Air layer (`layer: 1`).** |
| LR-2 | **Ants અને bees એકબીજા સાથે ક્યારેય collide થતાં નથી.** Ant lane bee body થી block થતી નથી; bee lane ant body થી block થતી નથી. |
| LR-3 | **Ant lane** block થાય: (a) કોઈપણ **ant line** ના body cell થી, (b) **બધા** blocking obstacles થી (`tall: false` અને `tall: true` બંને), (c) ant-blocking edge walls થી. |
| LR-4 | **Bee lane** block થાય **માત્ર**: (a) કોઈપણ **bee line** ના body cell થી, (b) **`tall: true`** obstacles થી. `tall: false` obstacles bee lane માટે અદ્રશ્ય છે. |
| LR-5 | Non-blocking cell mechanics (one-way, portal, deflector, switch, mud, spring, વગેરે) bee lane ને **ત્યારે જ** અસર કરે જ્યારે instance `tall: true` હોય. જે mechanics નું catalog card "tall: false (fixed)" કહે છે તે **ant-only** છે. |
| LR-6 | **Cover lock** (M032 rule): જે ant line ના કોઈ body cell ની બરાબર ઉપર bee line નો body cell હોય તે ant line **locked** છે (locked tap) — જ્યાં સુધી તેને ઢાંકતી બધી bee lines exit ન થાય. |
| LR-7 | **Tap priority:** એક cell માં bee અને ant બંને હોય તો tap **bee line (ઉપરનું layer)** ને મળે. |
| LR-8 | એક cell માં **એક layer માં** max 1 line body cell. Bee body `tall: true` obstacle વાળા cell માં હોઈ શકે નહીં; `tall: false` obstacle ઉપર હોઈ શકે. (Validator) |
| LR-9 | L1–40 માં માત્ર ant lines (`layers: 1`). Bees L41 થી ([02](./02_LEVEL_PROGRESSION_0001_0500.md)). |

દરેક mechanic card ([03](./03_OBSTACLE_CATALOG_PHASE_1.md)) માં **Ants / Bees / Tall** fields આ rule મુજબ લખેલા છે.

## 6. Gameplay Rules (રમતના નિયમો)

### 6.1 Tap → Exit
- Player line ના **કોઈપણ body cell** પર tap કરે (LR-7 priority સાથે).
- Exit lane (પોતાના layer માં) clear ⇒ head insect lane પર આગળ ચાલે/ઉડે, બાકીના insects head ને follow કરે, આખી line board edge પાર કરીને remove થાય.
- Ant line: **march** animation (legs cycle); bee line: **fly** animation (wing flutter + હળવો sine bob).
- Animation duration ≤ **450 ms** (Move પૂરો થાય પછી જ નવો input; input queue = 1, છેલ્લો tap queue થાય).
- **Exits:** Phase 1 માં બધી lines **board edge** થી જ બહાર જાય. Interior burrow/hive માં exit **માત્ર** M020 "Anthill & Hive Entrance" થી, L201 પછી.

### 6.2 Blocked → Bump
- Lane માં blocker (LR-3/LR-4 મુજબ) ⇒ head insect blocker ની આગળના cell સુધી જાય, **"bonk"** (shake + haptic + bonk sound), અને આખી line **મૂળ cells માં પાછી** આવે.
- **−1 Heart** (Shield active હોય તો Shield charge −1). Board state બદલાતી નથી, પણ **Move counter +1**.
- Lane નો પહેલો cell જ blocked હોય તો head જગ્યાએ જ "bonk" wobble કરે.

### 6.3 Moves
- Move = line tap (exit કે bump) અથવા interactive obstacle tap (lever, daisy, switch, rotor).
- Move **નથી**: booster use, pause, long-press preview, locked tap, zoom.
- Move-based mechanics (counters) દરેક Move પછી 1 tick થાય — **wall-clock timer ક્યાંય નથી**.

### 6.4 Locked taps
- Locked line (dew-stuck, fogged, out-of-order, cover-locked, caged, unlinked loop, ghost phase) પર tap ⇒ soft wobble + "tsk" locked sound. **Heart નથી કપાતું, Move નથી ગણાતો.**
- પહેલી વાર દરેક lock reason માટે 1-line tooltip (દા.ત. "A bee is resting on this line").

### 6.5 Tap target resolution (order)
1. **Interactive control** — Twig Lever / Root Gear Lever cell, Clover Switch cell, Spinning Daisy cell, Lily-Pad Rotor hub (4 cells ના shared corner થી 16 dp radius). Lever/switch cells પર line body હોતી નથી (validator); daisy cell પર તેની linked line નું head હોય — daisy tap = rotate, line ના બીજા cells tap = exit.
2. **Air layer line** body cell (bee) — LR-7.
3. **Ground layer line** body cell (ant).
4. બીજું કંઈ નહીં ⇒ ignore (no Move, no sound).

LR-7 (bee above ant) lines વચ્ચે હંમેશા લાગુ. Leaf Blower targeting order: bee line > hammerable obstacle > ant line ([04 §2.4](./04_BOOSTERS_COINS_SHOP.md)).

### 6.6 Free Path Preview — "Scent Trail Preview"
- Line પર long-press **≥ 350 ms** ⇒ તેની exit lane dotted line થી દેખાય: **લીલી = clear**, **લાલ = blocked** (blocker cell પર ✕ icon, clear lane end પર ✓ icon — color-blind support).
- Bee line ની lane **wavy dotted** (હવાઈ), ant line ની **straight dotted** (જમીન).
- મફત, Move નથી, booster નથી. Finger ઉપાડતાં preview બંધ; long-press પછી finger ઉપાડવાથી tap fire **નથી** થતો.

### 6.7 Win
- બધી lines (ants + bees) exit થાય **અને** level ના goals (દા.ત. M026 Sugar Crumbs & Nectar Drops) પૂરા થાય ⇒ Win.
- છેલ્લી line exit animation પૂરી થાય પછી 300 ms "garden sparkle" અને Level Complete.

### 6.8 Determinism & fairness
- એક જ state + એક જ Move ⇒ હંમેશા એક જ પરિણામ. Randomness માત્ર level generation (seed) માં.
- **No forced damage:** દરેક level **0 hearts lost, 0 boosters** થી solvable (CI validator).
- Simultaneous movement નથી.

## 7. Hearts, Revive & Fail

| Rule | Value |
|---|---|
| Hearts per attempt | **3** (ક્યારેય 3 થી વધુ નહીં) |
| Bump / heart-loss event | −1 Heart (Queen's Royal Shield active ⇒ shield charge −1) |
| 0 Hearts | **Second Chance** popup, 10-sec countdown ring |
| Revive: Rewarded Ad | +1 Heart, **level દીઠ 1 વાર** (`adReviveUsed[level]`; restart થી reset નહીં, level clear થાય પછી reset) |
| Revive: Honey Heart Refill (Heart Refill) | **120 coins** → +1 Heart, **attempt દીઠ max 2** |
| Countdown પૂરો / "No thanks" | **Level Failed** → Retry (3 hearts, board reset) અથવા Home |
| Ad unavailable | Ad button disabled + "Ad unavailable"; coin option ચાલુ |
| Revive પછી | Board reset **નહીં** — ત્યાંથી જ ચાલુ |

Fail penalty નથી, lives/energy system નથી, Retry હંમેશા મફત.

## 8. Stars (★)

| Stars | Condition |
|---|---|
| ★★★ | 0 hearts lost |
| ★★ | 1 heart lost |
| ★ | 2+ hearts lost **અથવા** કોઈપણ revive (ad કે Heart Refill) વાપર્યું |

- Boosters stars ને અસર નથી કરતા. Shield એ absorb કરેલો bump "heart lost" ગણાતો નથી.
- Replay થી stars improve થાય; level clear coins માત્ર પહેલી વાર ([04](./04_BOOSTERS_COINS_SHOP.md)).
- Daily Tuesday "Par Moves": par થી વધુ Moves ⇒ 1 ★ ઓછો ([05](./05_DAILY_CHALLENGE_AND_STREAK.md)).

## 9. Boosters (ટૂંકમાં)

| Themed name (generic) | Effect (summary) |
|---|---|
| **Nectar Glow Hint (Hint)** | આગલો સાચો Move (line કે lever) glow કરે |
| **Dewdrop Rewind (Undo)** | છેલ્લો 1 Move revert; heart પાછું નહીં |
| **Queen's Royal Shield (Shield)** | આગલા 2 heart-loss events absorb |
| **Leaf Blower (Hammer)** | 1 line (exit ગણાય) અથવા `hammerable: true` obstacle remove |
| Scent Trail Preview (Path Preview) | Free long-press preview (§6.6) |

Caps, prices, unlocks: [04 Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md).

## 10. Edge Cases (ખાસ કિસ્સા)

| # | Situation | Result |
|---|---|---|
| E1 | Bee lane એ cell પરથી પસાર થાય જ્યાં ant line છે | Clear (LR-2). Bee ઉપરથી ઉડી જાય. |
| E2 | Ant lane `tall: false` pebble ને મળે | Bump −1 Heart. Bee lane એ જ pebble ઉપરથી clear. |
| E3 | Bee lane `tall: true` sunflower stalk ને મળે | Bump −1 Heart. |
| E4 | Covered ant line ના uncovered cell પર tap | Locked tap (LR-6): wobble, no Move, no heart. |
| E5 | Covered cell પર tap | Bee line ને tap (LR-7) — તેનું exit/bump. |
| E6 | Animation દરમિયાન 3 taps | છેલ્લો 1 tap queue; બાકીના drop. |
| E7 | Long-press 350 ms પછી release | Preview બંધ, tap fire નહીં. |
| E8 | Bump જ્યારે Shield પાસે 1 charge | Charge 0, heart સલામત, Shield icon fade. |
| E9 | 0 hearts અને revive ad already used આ level માં | Ad button hidden-state "Used"; Heart Refill (જો attempt માં < 2) ચાલુ. |
| E10 | Bump પછી Dewdrop Rewind (Undo) | Move counter અને Move-based counters 1 tick પાછા; **heart પાછું મળતું નથી**. |
| E11 | M017 counter 0 થાય અને એ જ Move માં hearts 0 | Second Chance popup (normal flow). |
| E12 | App background માં જાય animation દરમિયાન | Animation તરત final state પર snap, state save. |
| E13 | Leaf Blower થી covered ant line ને target | Covered ant line Leaf Blower target **નથી** ([Standard §16.8](../../SHARED_CORE_STANDARD.md)): covered cell ⇒ bee target; uncovered ant cell ⇒ invalid target (wobble, booster consume નહીં). ઢાંકતી bees exit થાય પછી જ target બને. |
| E14 | Fog નીચે છુપાયેલી line | Leaf Blower / Hint target નહીં બને (દેખાતી નથી). |
| E15 | Level માં bee lines પણ ground-only obstacles જ | Bees ને કંઈ નડતું નથી સિવાય bee lines — validator D band થી trivial levels reject કરે. |

## 11. Theme Glossary (થીમ શબ્દકોશ)

| Generic | Game 4 themed name |
|---|---|
| Path | Line (Ant line / Bee line) |
| Head | Head insect (લીડર) |
| Exit | March off (ants) / Fly off (bees) |
| Bump | Bonk |
| Coins | Honey Coins |
| Hint / Undo / Shield / Hammer | Nectar Glow Hint / Dewdrop Rewind / Queen's Royal Shield / Leaf Blower |
| Path Preview | Scent Trail Preview |
| Heart Refill | Honey Heart Refill |
| Milestone Gift Box | Queen's Gift Box |
| Phase Chest | Royal Honey Chest |
| Coin Rush | Golden Nectar Rush |
| Daily Challenge | Daily Garden Almanac |
| Streak Saver | Queen's Favor |
| Streak Trophy | Golden Honeybee Trophy |
| Lucky Spin | Sunflower Spin |
| VIP No-Ads Pass | Beekeeper VIP Pass (No-Ads) |
| Inner Exit (M020) | Anthill & Hive Entrance |
| Guardian (M049) | Great Orb Spider |
| Phase Finale (L500) | Queen's Garden Gala |

M001–M049 themed names: [03 Obstacle Catalog §2](./03_OBSTACLE_CATALOG_PHASE_1.md).

# 01 — Game Concept & Rules
> Snakes Slither નો concept, characters, art direction, core loop અને **બધા gameplay rules** (developer-ready, standard §1–§4 ને themed રૂપમાં).

**Related docs:** [Phase 1 index](./README.md) · [Shared Core Standard](../../SHARED_CORE_STANDARD.md) · [02 Level Progression](./02_LEVEL_PROGRESSION_0001_0500.md) · [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) · [04 Boosters & Shop](./04_BOOSTERS_COINS_SHOP.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Concept (ખ્યાલ)
- **Genre:** Path-clear logic puzzle, turn-based, single-player, offline.
- **Fantasy:** એક jungle garden માં ઘણા cute સાપ અને ઇયળો ગૂંચવાઈને બેઠા છે. દરેક ને બહાર jungle picnic પર જવું છે. Player નક્કી કરે કે **કયો સાપ પહેલાં** સરકે, જેથી કોઈ બીજાને માથું ન અથડાવે.
- **Core challenge:** Dependency ordering — "આ સાપ નીકળે તો પેલાનો રસ્તો ખુલે". Obstacles (rocks, logs, burrows, levers, fog…) દર 10 levels એ નવો twist ઉમેરે.
- **No pressure:** Puzzle માં કોઈ clock નથી. Player ગમે તેટલું વિચારી શકે. ભૂલ = 1 Heart, Retry હંમેશા મફત.

## 2. Characters & Art Direction
### 2.1 Cast
| Character | Role | Look |
|---|---|---|
| **Pip** | Mascot, tutorial guide (baby green snake) | મોટી ચમકતી આંખો, નાનો leaf hat |
| **Grandpa Tortoise** | Tooltips/intro cards નો narrator | ચશ્મા, ધીમો અવાજ (text only, no VO in Phase 1) |
| **Snakes** | Main pieces (paths) | Rounded clay-like tube body, 2 આંખો, blink loop, cheeks |
| **Caterpillars** | Visual variant of a snake (same rules) | Segmented beads body, નાની antennae, પગની હાર; `mods.skin = "caterpillar"` |
| **Grumpy Mongoose** | M049 Guardian / Finale boss | Cute, ગુસ્સાવાળું મોં, ક્યારેય scary નહીં (age 10+) |

Snake અને caterpillar માત્ર skin છે: hit-box, lane, rules બંનેના એકસરખા. Level JSON માં 0–40% paths caterpillar skin (variety માટે).

### 2.2 Art Direction
- **Style:** Soft 3D minimal / claymorphism — pastel colours, soft pre-baked shadows, rounded bevels. Flat 2D vector render (`CustomPainter`), 3D feel gradient + highlight stroke થી.
- **Board:** Garden patch — light grass tiles, dotted grid, rounded corners. Biome tint tier પ્રમાણે (§2.3).
- **Readability first:** Head હંમેશા body કરતાં મોટું; આંખો head ની દિશામાં જુએ ⇒ `dir` એક નજરમાં ખબર પડે. દરેક colour સાથે pattern (colour-blind; [06 §3](./06_UI_UX_SCREENS.md#3-accessibility)).
- **Animation feel:** Exit = slither wiggle (sine wave body), Bump = head bonk + squash + shake, Locked = soft side wobble, Win = snakes wave goodbye + confetti leaves.

### 2.3 Biomes (Level Map regions)
| Levels | Biome | Board tint |
|---|---|---|
| 1–10 | Pip's Backyard | `#E8F5E9` |
| 11–100 | Garden Meadow | `#E8F5E9` |
| 101–200 | Bamboo Grove | `#E6F2DF` |
| 201–300 | Mango Orchard | `#FFF4E0` |
| 301–400 | Misty Swamp | `#E3EFEA` |
| 401–500 | Moonlit Jungle | `#E4E8F5` |

## 3. Core Loop
```
 Level Map ─► Level Start (3 hearts) ─► Inspect board (long-press preview free)
      ▲                                   │
      │                                   ▼
      │                         Tap a snake ─► Clear lane? ──yes──► Slither out (Move +1)
      │                                   │                          │
      │                                   no                         ▼
      │                                   ▼                 All snakes out + goals? ──no──┐
      │                         Head bonk, −1 Heart (Move +1)        │yes                 │
      │                                   │                          ▼                    │
      │                         Hearts = 0? ──yes──► Second Chance   Level Complete       │
      │                                   │no                (stars, coins, Gift Basket,  │
      │                                   └──────────────────► Rush, interstitial rules)  │
      └───────────────────────────────────────────────────────────────┘ ◄────────────────┘
```
Meta loop: coins ⇒ boosters/Shop · Daily Challenge ⇒ Streak · Gift Basket (દર 10) · Golden Slither Rush (દર 25) · Lucky Lily Wheel (રોજ).

## 4. Board & Snake Model
| Element | Rule |
|---|---|
| Board | W×H square cells, `(x, y)`, x → right, y → down, origin top-left. Phase 1: 4×4 થી 11×11 |
| Snake (path) | Ordered cell list, `body[0]` = head. Cells orthogonally connected, એક cell માં એક જ snake (એક layer માં) |
| `dir` | Head facing: `U, D, L, R` (Phase 1 માં diagonal નથી) |
| Exit lane | Head ના આગળના cell થી `dir` દિશામાં board edge સુધીના cells |
| Length | 2–8 cells (FTUE 2–4) |
| Colour | 8 palette colours ([06 §2.1](./06_UI_UX_SCREENS.md#21-colours)); colour rules માત્ર M005/M030/M033/M041/M048 માટે મહત્વના |

## 5. Gameplay Rules (બધા rules)
### 5.1 Tap → Slither Out (Exit)
1. Player snake ના **કોઈપણ body cell** (head, body કે tail) પર tap કરે.
2. Engine exit lane તપાસે. Lane ના બધા cells ખાલી (કોઈ snake નહીં, કોઈ blocking obstacle નહીં) ⇒ **Exit**.
3. Animation: head `dir` માં સીધો lane પર સરકે, body એ જ track પર head ને follow કરે (slither wiggle), tail board edge પાર કરે ત્યારે snake remove. Duration ≤ 450 ms (lane length પ્રમાણે 250–450 ms).
4. SFX "slither-whoosh" + light haptic. Move counter +1.

### 5.2 Blocked → Head Bonk (Bump)
1. Lane માં બીજો snake અથવા blocking obstacle હોય ⇒ head blocker ના પહેલાંના cell સુધી સરકે, **bonk** (squash + 3-cycle shake), અને body સાથે મૂળ જગ્યાએ પાછો slide થાય.
2. **−1 Heart** (Safety Shell Shield active હોય તો Shield charge −1 અને heart બચે).
3. Board state બદલાતી નથી, પણ **Move counter +1** (move-based mechanics tick થાય).
4. SFX "bonk" + medium haptic. Blocker 120 ms red flash.
5. Blocker head ના તરત આગળ હોય તો head માત્ર 0.25 cell આગળ જઈ bonk કરે.

### 5.3 Win
- બધા snakes exit (Magic Stone Hammer થી remove થયેલા પણ exit ગણાય) **અને** level goals પૂરા (દા.ત. M026 Jungle Gems બધા collect) ⇒ Win.
- Win check દરેક Move ના અંતે (§5.9 step 8) અને દરેક Hammer use પછી.

### 5.4 Moves
| Action | Move? |
|---|---|
| Snake tap ⇒ exit | ✅ +1 |
| Snake tap ⇒ bump | ✅ +1 |
| Interactive obstacle tap (lever, lilypad, fern fork, whirl stump, root gear) | ✅ +1 |
| Snake tap ⇒ state change only (M012 wake, M037 mud relocate) | ✅ +1 |
| Locked tap (§5.5) | ❌ |
| Booster use (Hint, Shield, Hammer) | ❌ |
| Long-press preview, pause, settings | ❌ |

Move counter HUD માં નાના text તરીકે દેખાય (`Moves 7`); Daily Tuesday માં `7 / par 9`.

### 5.5 Locked Taps
જે snake હાલ tap થઈ શકે તેમ નથી — Frost Coil (M003), Jungle Mist નીચે (M010), ખોટો Hatch Order (M028), ghost Phantom Snake (M021), Petal Cage (M033), Canopy નીચે ground snake (M032), Tail-Biter Loop locked (M046), Spinning Lilypad / Whirl Stump પર અધૂરો snake અથવા rotation પછી head પોતાના body તરફ ("tangled", M013/M034; standard §16.19, §17.39) — તેના પર tap:
- Soft side wobble (≤ 200 ms) + "nuh-uh" rattle SFX + selection haptic.
- Lock reason icon 600 ms (❄️ / ☁️ / 🔢 / 👻 / 🌸 / 🍃 / 🔗 / 🌀).
- **Heart નહીં કપાય, Move નહીં ગણાય.**
- **Locked tap નથી:** Hungry Caterpillar (M036) નો lane clear હોય પણ lane માં food ન હોય ⇒ **bump (−1 Heart)**, standard §16.6. Hint/solver આ જાણે.

### 5.6 One Move at a Time
- એક Move ની animation (≤ 450 ms) પૂરી થાય પછી જ બીજો input resolve થાય.
- **Input queue = 1:** animation દરમિયાન આવેલો **છેલ્લો** tap queue થાય; પહેલાંના queued tap discard. Booster buttons animation દરમિયાન disabled (dim).

### 5.7 Tap Priority & Hit-Test
1. Tap point ⇒ cell `(floor(x/cell), floor(y/cell))`.
2. Cell માં બે layers ના snakes હોય (M032 Canopy) ⇒ **ઉપરના layer** નો snake.
3. **Interactive cell > snake cell** (standard §16.5, §16.19): lever, Spinning Lilypad (M013), fern fork, Whirl Stump (M034) cell પર tap હંમેશા obstacle ને જાય, ભલે તેના પર snake નો cell હોય. M013: head lilypad પર હોય ⇒ head cell tap = lilypad rotate; snake ના બાકીના body cells tap = snake tap (validator: આવા snake ની length ≥ 2).
4. ખાલી cell પર tap ⇒ 0.5 cell hit-slop માં સૌથી નજીકનો snake body segment (small cells 29 dp પર મદદ). કંઈ ન મળે ⇒ ignore.

### 5.8 Tongue-Flick Preview (free Path Preview)
- Snake પર long-press ≥ 350 ms ⇒ snake જીભ બહાર કાઢે (tongue flick) અને exit lane dotted line થી દેખાય: **લીલો** = clear, **લાલ** = blocked (blocker cell પર ✕ marker).
- Lane mirror/burrow/fern fork થી વળે તો dotted line એ જ route બતાવે. Jungle Mist (fog) માં lane પહોંચે ત્યાં dotted line grey "?" સાથે અટકે (hidden information leak ન થાય).
- Finger ઉઠાવો ⇒ preview બંધ, **કોઈ Move નહીં**. Long-press પછી release એ tap ગણાતો નથી.

### 5.9 Move Resolution Order (deterministic)
દરેક Move engine માં આ ચોક્કસ order માં resolve થાય (standard §2 rule 5 — same state + same Move = same result):
1. **Validate:** target locked? ⇒ locked tap (§5.5), stop.
2. **Resolve action:** exit / bump / relocate (mud) / wake / interactive toggle / rotate.
3. **Exit triggers (immediate):** keys (M004/M043/M046), Frost Coil counts (M003), Jungle Mist clear (M010), Petal Cage (M033), Mongoose HP (M049), Termite Mound HP (M016), Jungle Gems (M026), food consumed (M036), Mama Snake spawn queue (M035), Dry Twig Bridge crossing (M042), Mossy Pressure Stone release (M019), Hatch Order advance (M028).
4. `moveCount += 1`. (Parity mechanics — M021 Phantom Snake — increment **પહેલાં** ની parity વાપરે.)
5. **Tick move-based counters** in fixed order (standard §16.17): M007 Lotus Bud Gate → M017 Restless Caterpillar (0 ⇒ heart-loss event queue, reset N) → M031 Closing Hedge Gap → M025 Patrolling Beetle → M027 Creeping Vine → M047 Growing Caterpillar → M041 Chameleon colour.
6. **Derived states:** Mossy Pressure Stone gates (M019), Jungle Mist (M010), Petal Cages (M033), locks, Mama Snake pending spawns (M035).
7. **Heart loss:** queued heart-loss events apply (Safety Shell Shield પહેલાં absorb કરે).
8. **Check Win** (§5.3). Win ⇒ stop (હવે hearts check નહીં).
9. **Check Hearts:** hearts = 0 ⇒ Second Chance (§6).

Mechanic-specific details: [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md).

## 6. Hearts, Second Chance & Fail
| Rule | Value |
|---|---|
| Hearts per attempt | **3** (HUD માં 3 heart-berries; ક્યારેય 3 થી વધુ નહીં) |
| Heart-loss events | Bump; M017 Restless Caterpillar counter 0. Shield active ⇒ Shield charge −1 instead |
| Hearts 0 | **Second Chance** popup, 10-sec countdown ring (popup UI timer, puzzle timer નથી) |
| Option A — Watch ad | +1 Heart. **Level number દીઠ 1 વાર** (`adReviveUsed[level]`), restart થી reset **નહીં**; level clear થાય ત્યારે reset |
| Option B — Heart Berry Refill | **120 coins** ⇒ +1 Heart. **Attempt દીઠ max 2** |
| Countdown 0 / "No thanks" | **Level Failed** ⇒ Retry (3 hearts, board reset) અથવા Home |
| Ad unavailable | Ad button disabled + "Ad unavailable"; coin option ચાલુ |
| Coins < 120 | Refill button ⇒ mini shop sheet (countdown pause) |
| Revive પછી | Board reset **નહીં**, ત્યાંથી જ ચાલુ |
| Fail penalty | કોઈ નહીં. Lives/energy system નથી. Retry મફત |

Revive/Refill પછી ફરી hearts 0 થાય ⇒ popup ફરી ખૂલે; માત્ર જે options બાકી હોય તે enabled. બંને ખૂટે ⇒ popup ની જગ્યાએ સીધું Level Failed.

## 7. Stars (★)
| Result | Stars |
|---|---|
| 0 hearts lost | ★★★ |
| 1 heart lost | ★★ |
| 2+ hearts lost **અથવા** કોઈ revive / Heart Berry Refill | ★ |

- Shield એ absorb કરેલો event "heart lost" ગણાતો નથી.
- Boosters stars ને અસર નથી કરતા.
- Replay થી stars improve થાય (ક્યારેય ઘટે નહીં — best saved). Clear coins માત્ર પહેલી વાર; first ★★★ bonus (+20) એક જ વાર ([04 §5](./04_BOOSTERS_COINS_SHOP.md#5-coins-economy)).

## 8. Boosters During Play (summary)
| Themed booster | Generic | Gameplay effect | Cap/attempt |
|---|---|---|---|
| 🪲✨ Glow Firefly Hint | Hint | Firefly ઉડીને solver નો આગલો સાચો Move (snake કે lever) glow કરે. Move નથી | 3 |
| 🐚 Safety Shell Shield | Shield | આગલા 2 heart-loss events absorb; attempt પૂરો ⇒ lapse | 1 |
| 🔨 Magic Stone Hammer | Hammer | 1 snake (exit ગણાય) અથવા hammerable obstacle remove | 2 |
| 👅 Tongue-Flick Preview | Path Preview | Free long-press lane preview | — |

પૂરી વિગત, unlocks, prices: [04 Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md).

## 9. Edge Cases
| # | Situation | Behaviour |
|---|---|---|
| E1 | Tap during exit/bump animation | Input queue 1: છેલ્લો tap animation પછી resolve |
| E2 | Double-tap same snake fast | પહેલો tap resolve; બીજો queued tap target હવે નથી (exited) ⇒ ignore |
| E3 | Tap exactly on border between two snakes | Cell math (floor) નક્કી કરે; tie ન થાય |
| E4 | Last snake exit + M017 counter 0 same Move | Snake exit થયો ⇒ counter નથી; Win |
| E5 | Bump with Shield 1 charge left | Charge 0, heart બચે, Shield icon ફૂટે ("shell crack" SFX) |
| E6 | Heart loss when hearts 1 and Shield inactive | Hearts 0 ⇒ Second Chance |
| E7 | App backgrounded mid-level | Pause overlay; Second Chance countdown pause; state memory માં, process kill ⇒ level restart (attempt state persist નથી; `adReviveUsed` persist છે) |
| E8 | App killed during rewarded ad (revive) | Reward callback ન આવ્યો ⇒ revive ન મળ્યું, `adReviveUsed` set **નહીં** |
| E9 | Rewarded ad closed early | Reward નહીં; popup પાછું, countdown ચાલુ (ad ખૂલતાં pause થયેલો) |
| E10 | Hammer finality | Hammer use irreversible છે; Hammer ક્યારેય revert / re-apply થતો નથી (standard §16.23) |
| E11 | Hint when no solution from current state (e.g. after Hammer misuse) | On-device solver fail ⇒ "Try Restart" toast, Hint consume નહીં |
| E14 | Hammer on last snake | Exit ગણાય ⇒ Win (goals પૂરા હોય તો) |
| E15 | Snake fully hidden under Jungle Mist | Hammer target ન બને (hidden); Hint પણ તેને point ન કરે |
| E16 | Device rotation | Portrait lock (phones); tablets portrait + landscape, board re-fit, state same |
| E17 | Text scale 200% | HUD texts wrap/scale; board size પર અસર નહીં ([06 §3](./06_UI_UX_SCREENS.md#3-accessibility)) |
| E18 | Level JSON corrupt/missing | `E-LVL-001`/`E-LVL-002` non-fatal (AppLogger ⇒ Crashlytics) + **"Level unavailable"** dialog + Retry/Home. Level ક્યારેય skip કે cleared mark ન થાય; validator CI થી ship પહેલાં પકડાય ([Logging standard](../../LOGGING_AND_ERROR_TRACKING.md)) |

## 10. Win/Fail Flow Summary
```
Win  ─► Level Complete (stars, coins, 2X ad) ─► [x0: Jungle Gift Basket] ─► [L%25==0: Golden Slither Rush]
     ─► interstitial check (defer if Basket/Rush/Chest shown) ─► Next level / Map
Fail ─► Second Chance (ad 1/level · refill 120 ×2/attempt) ─► Level Failed ─► Retry / Home (no interstitial)
```
L500: Level Complete ⇒ Jungle Treasure Chest (Gift Basket ની જગ્યાએ) ⇒ Golden Slither Rush ⇒ Phase Complete screen.

## 11. Theme Glossary (Generic → Snakes Slither)
| Generic term | Snakes Slither term | ગુજરાતી |
|---|---|---|
| Board | Garden patch | બગીચાનો પેચ |
| Path | Snake / Caterpillar | સાપ / ઇયળ |
| Head / Tail | Head / Tail | માથું / પૂંછડી |
| Exit | Slither out | સરકીને બહાર |
| Bump | Head bonk | માથું અથડાવું |
| Locked tap | Nuh-uh wobble | ના-ના ધ્રુજારી |
| Heart | Heart Berry | હાર્ટ બેરી |
| Move | Move | ચાલ |
| Hint | Glow Firefly Hint | આગિયો |
| Shield | Safety Shell Shield | કવચ |
| Hammer | Magic Stone Hammer | જાદુઈ પથ્થર હથોડી |
| Path Preview | Tongue-Flick Preview | જીભ ફફડાટ |
| Heart Refill | Heart Berry Refill | હાર્ટ બેરી રીફિલ |
| Second Chance | Second Chance ("Pip needs a berry!") | બીજો મોકો |
| Milestone Gift Box | Jungle Gift Basket | જંગલ ભેટ ટોપલી |
| Phase Chest | Jungle Treasure Chest | જંગલ ખજાનો |
| Coin Rush | Golden Slither Rush | સોનેરી દોડ |
| Lucky Spin | Lucky Lily Wheel | કમળ ચક્ર |
| Daily Challenge | Daily Jungle Puzzle | રોજની પઝલ |
| Streak | Jungle Streak | સળંગ દિવસો |
| Streak Saver | Streak Saver Leaf | સ્ટ્રીક બચાવ પાંદડું |
| Streak Trophy | Golden Coil Trophy (Bronze → Silver → Gold → Platinum → Diamond) | ટ્રોફી |
| Coins | Coins (gold leaf coins) | સિક્કા |
| VIP No-Ads Pass | VIP No-Ads Pass | VIP પાસ |
| Guardian | Grumpy Mongoose | નોળિયો |
| Phase Finale | Mongoose King's Garden | નોળિયા રાજાનો બગીચો |
| M001–M049 | જુઓ [03 summary table](./03_OBSTACLE_CATALOG_PHASE_1.md#1-summary-table-m001m049) | |

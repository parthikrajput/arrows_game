# 01 · Game Concept & Gameplay Rules — Toy Trains: Wooden Railway Puzzle
> હેતુ: game નો concept, art direction, core loop અને **બધા gameplay rules** (tap / exit / bump / win / Moves / locked taps / tap priority / preview / hearts / stars / edge cases) એક જ જગ્યાએ.

**Related docs:** [Shared Core Standard](../../SHARED_CORE_STANDARD.md) · [Phase 1 README](./README.md) · [02 Level Progression](./02_LEVEL_PROGRESSION_0001_0500.md) · [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) · [04 Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md) · [06 UI/UX Screens](./06_UI_UX_SCREENS.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

> ⚖️ આ document ના બધા rules [SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) §1–§4 નું train-theme રૂપાંતર છે. કોઈ વિરોધાભાસ દેખાય તો **standard સાચું** ગણવું.

---

## 1. Concept (કન્સેપ્ટ)

**Toy Trains: Wooden Railway Puzzle** એક turn-based **path-clear puzzle** છે. લાકડાના playmat (tabletop board) પર રંગીન લાકડાની toy trains ગોઠવાયેલી છે. દરેક train નું **engine** (head) એક દિશા તરફ મુખ રાખે છે અને પાછળ 1–4 **carriages** જોડાયેલા છે. Player train પર tap કરે ⇒ train પોતાના **exit lane** (engine ની સામે દોરેલો સીધો track) પર દોડીને table ની edge પરથી **Toy Box Station** માં ઊતરી જાય. બધી trains board પરથી નીકળી જાય ⇒ level win.

- Genre: Logic / path-clear puzzle (turn-based, no wall-clock timer)
- Audience: 10–50 years (mixed audience; compliance [04 §10](./04_BOOSTERS_COINS_SHOP.md))
- Session: 30 s – 3 min per level
- Platform: Android + iOS, Flutter ([07](./07_FRONTEND_IMPLEMENTATION_AND_QA.md))

## 2. Art Direction (આર્ટ ડાયરેક્શન)

| Element | Direction |
|---|---|
| Board | Honey-oak tabletop પર ઝાંખું grid (peg dots). Board edge = table edge; edge ની બહાર toy-box opening |
| Trains | Scandinavian-style લાકડાની toy trains: satin gloss paint, બ્રાસ screws, ગોળ wheels. Engine પર chimney + cab + direction arrow (cowcatcher પર). Carriages = rounded boxes, couplings દેખાય |
| Track | Train ની નીચે અને આગળ (exit lane) લાકડાના ties + બે steel-tone rails. Exit lane track ઝાંખો (40% alpha), Route Peek વખતે તેજ |
| Obstacles | Toy railway props: buffer stops, crates, level crossings, signals, tunnels, turntables, trestles, clock tower |
| Motion | Exit: chug-chug start, wheels spin, carriages follow; Bump: buffers "clack", short shake, train rolls back (`Curves.easeOutBack`) |
| Lighting | Soft top-light, pre-baked shadows (no per-frame blur) |
| Colour-blind | દરેક train colour ને pattern/icon (06 §2) |

Audio palette: wooden "clack" (bump), "toot-toot" whistle (exit), chug loop (moving), soft bell (level crossing open), brass "ding" (coins), music box BGM.

## 3. Core Loop (કોર લૂપ)

```
Home ─► Level Map ─► Level N (play) ─► Win ─► Level Complete (+coins, ★)
                         │                         │
                         │ 0 hearts                ├─ x0: Conductor's Gift Crate
                         ▼                         ├─ L25/50/75…: Golden Express Coin Rush
                   Second Chance ─► Fail ─► Retry  └─ every 5 wins: interstitial (rules 04 §8)
Daily Timetable Run (L15+) ─► Express Streak ─► rewards
Coins ─► Shop ─► boosters ─► easier hard levels
```

## 4. Board, Trains & Exit Lanes (બોર્ડ અને ટ્રેનો)

| Generic (standard) | Train term | Rule |
|---|---|---|
| Board | Playmat / tabletop | W×H square grid, `(x, y)`, origin top-left, `x` → right, `y` → down |
| Path | Train | Ordered cell list `body[0]` = engine. **1 cell = 1 car.** Length 2–5 (engine + 1–4 carriages). Exception: M047 Auto-Coupler Freight grows (03) |
| Path `dir` | Engine facing | Phase 1: `U, D, L, R` only |
| Exit Lane | Track ahead | Engine ની આગળના cell થી `dir` દિશામાં board edge સુધીના cells |
| Body shape | Carriages on track | Body સીધું કે વળાંકવાળું (L / S shape) હોઈ શકે — carriages વળાંકવાળા track પર ઊભા છે |

⚠️ **Loops નથી:** Trains ક્યારેય board પર ગોળ-ગોળ ફરતી નથી, figure-8 track નથી, free-running circuit નથી. દરેક train હંમેશા **સીધું** (lane પ્રમાણે) board બહાર જાય. Lane માત્ર mechanic થી વળે (M008 Tunnel Pair, M014 Curve Rail, M018 Track Switch, M044 Bend Tunnel). એકમાત્ર "loop" = **M046 Loop Line Train** અને તેનો exact rule (03): locked ring જે linked ticket-train exit થાય પછી marked engine પર ખુલે અને પછી સામાન્ય train ની જેમ સીધી નીકળે.

## 5. Gameplay Rules (ગેમપ્લે નિયમો)

### 5.1 Tap → Exit
Player train ના **કોઈપણ car** (engine કે carriage) પર tap કરે. Exit lane ખાલી હોય તો engine `dir` દિશામાં દોડે, carriages body polyline પર engine ને follow કરે, અને આખી train board edge પરથી ઊતરી remove થાય. **1 Move.**

### 5.2 Blocked → Bump
Lane માં બીજી train નો car અથવા blocking obstacle હોય તો train blocker સુધી આગળ વધે, buffers "clack" (shake + `HapticFeedback.mediumImpact` + sound), અને **મૂળ જગ્યાએ પાછી roll** થાય. **−1 Heart** (Cowcatcher Shield active હોય તો Shield charge −1). Board state બદલાતી નથી, પણ **Move counter +1** (move-based counters tick થાય).

### 5.3 Interactive cells = Move
Lever (M009), Turntable (M013), Track Switch (M018), Rotating Yard (M034), Master Gear Lever (M045) જેવા interactive cells પર tap = **1 Move** (standard §1). એ Move પણ Move-based counters ને tick કરે. Interactive tap ક્યારેય heart નથી કાપતું.

### 5.4 Win
બધી trains exit થાય **અને** level નો extra goal (M026 Mail Sacks બધા collected) પૂરો થાય ⇒ Win.

### 5.5 Turn-based, deterministic
- Puzzle માં **કોઈ wall-clock timer નથી.** "Timed" દેખાતી વસ્તુઓ (Level Crossing countdown, Steam Pressure, Last Call Exit…) **Move counter** પર ચાલે: 1 Move = 1 tick.
- એકમાત્ર exception: **Golden Express Coin Rush** (30 s bonus round, puzzle નથી).
- એક જ state + એક જ Move = હંમેશા એક જ પરિણામ. Randomness માત્ર generation seed થી.

### 5.6 No forced damage
કોઈ obstacle પાર કરવા heart ગુમાવવું કે booster વાપરવું **ફરજિયાત નથી**. દરેક level 0 hearts lost + 0 boosters થી solvable (CI validator, 07 §12).

### 5.7 Locked taps
જે train અત્યારે tap થઈ શકે તેમ નથી (Snowed-In, Steam Cloud નીચે, Timetable order ખોટો, Locked Siding, Viaduct નીચે દબાયેલી, Phantom ghost phase…) તેના પર tap ⇒ soft wobble + "locked" wooden knock sound. **Heart કપાતું નથી, Move ગણાતો નથી**, counters tick નથી થતા.

### 5.8 One move at a time
Move animation (≤ 450 ms) પૂરું થાય પછી જ નવું input apply થાય. Input queue = 1: animation દરમિયાન આવેલો **છેલ્લો** tap queue થાય, બાકીના drop.

### 5.9 Tap priority
1. એક cell માં બે layers ની trains overlap થાય (M032 Viaduct Deck) ⇒ **ઉપરના layer** ની train ને tap મળે.
2. Interactive cell પર train નો car ઊભો હોય (દા.ત. M013 Turntable પર engine, M034 Rotating Yard નો hub) ⇒ એ cell નો tap **interactive cell** ને જાય (standard §16.19: interactive mechanic cell > તેના પર ઊભેલો train car); train ને drive કરવા તેના બીજા કોઈ car પર tap કરો. Tutorial card આ બતાવે.
3. Rotating Yard / Turntable માં train **આંશિક રીતે** અંદર હોય ⇒ yard/turntable tap = **locked tap**. Rotation પછી engine નો `dir` પોતાના carriage તરફ હોય ⇒ train **"tangled"** ⇒ train tap = locked tap (bump નહીં) જ્યાં સુધી ફરી rotate ન થાય (standard §17.39).
4. Push-Pull Train (M023): બરાબર વચ્ચેના car પર tap ⇒ `body[0]` વાળો છેડો.

### 5.10 Free Route Peek (Path Preview)
Train પર long-press (≥ 350 ms) ⇒ exit lane dotted line થી દેખાય: **લાલ = blocked** (blocker cell પર ✕), **લીલો = clear**. મફત, Move નથી, booster નથી. Release ⇒ preview બંધ.

### 5.11 Move resolution order (engine contract)
દરેક Move (exit, bump, interactive tap, Cold Engine wake, Sand Drift stop) નીચેના fixed order માં resolve થાય:

1. Action resolve: exit / bump / interactive state change.
2. `moveCount += 1`.
3. Move-based mechanics tick (fixed order, standard §16.17): M007 → M017 → M031 → M025 → M027 → M047 → M041 (Phase 2 order: [Phase 2 rules](../phase_2/01_PHASE_2_SCOPE_AND_RULES.md)). Parity mechanics (M021 Phantom Express) આ Move ના increment **પહેલાં** ની `moveCount` parity વાપરે.
4. Derived states recompute: M003 thaw, M004/M043 barriers, M010 clouds, M019 plates, M033 sidings, M049 HP, M035 spawn.
5. Heart-loss events apply (bump, M017 at 0) — Shield પહેલા absorb કરે.
6. Win check, પછી 0-heart check (win પહેલાં ચકાસાય: છેલ્લી train exit થઈ એ જ Move માં heart 0 થાય તો પણ Win).

## 6. Hearts, Revive & Fail (હાર્ટ્સ)

| Rule | Value |
|---|---|
| Hearts per attempt | **3** (ક્યારેય 3 થી વધુ નહીં) |
| Heart-loss event | Bump, M017 Steam Pressure reaching 0, Chained/Twin/Convoy group bump (−1 total) |
| Cowcatcher Shield | Active હોય તો heart ને બદલે Shield charge −1 |
| 0 Hearts | **Second Chance** ("Back on Track?") popup, 10-sec countdown ring |
| Option A — Rewarded Ad | +1 Heart. **Level દીઠ 1 વાર** (`adReviveUsed[level]`; restart થી reset નથી; level clear પછી reset) |
| Option B — Heart Refill | **120 coins** → +1 Heart. **Attempt દીઠ max 2** |
| Countdown પૂરો / "No thanks" | **Level Failed** → Retry (3 hearts, board reset) અથવા Home |
| Ad unavailable | Ad button disabled + "Ad unavailable"; coin option ચાલુ |
| Revive પછી | Board reset **નથી** થતું; ત્યાંથી જ રમત ચાલુ |

Fail ની penalty નથી (lives/energy system નથી). Retry હંમેશા મફત.

## 7. Stars (★)

| Result | Stars |
|---|---|
| 0 hearts lost | ★★★ |
| 1 heart lost | ★★ |
| 2+ hearts lost **અથવા** કોઈ revive / Heart Refill | ★ |

- Boosters stars ને અસર **નથી** કરતા (Shield absorb કરેલો bump heart lost ગણાતો નથી).
- Replay થી stars improve થાય; clear coins માત્ર પહેલી વાર; first ★★★ bonus (+20) level દીઠ એક વાર.
- Daily Tuesday "Par Moves" modifier: par થી વધુ Moves ⇒ ★ એક ઓછો (05).

## 8. Edge Cases (એજ કેસ)

| Case | Behaviour |
|---|---|
| Tap animation દરમિયાન | Queue = 1 (છેલ્લો tap). Undo/booster button animation દરમિયાન disabled |
| Lane ખાલી પણ train locked (Snowed-In વગેરે) | Locked tap (§5.7), no heart, no Move |
| Train નો lane પોતાની carriage તરફ (turntable rotation પછી engine body[1] તરફ) | **"Tangled"** ⇒ locked tap (standard §17.39; "facing own carriage" wobble, no heart, no Move, bump નહીં) જ્યાં સુધી ફરી rotate ન થાય. CI: solution આ state માં tap માંગતું નથી |
| Coupled / Twin / Convoy group માંથી એક blocked | આખું group bump, −1 heart **કુલ** |
| છેલ્લો bump heart 0 કરે અને Shield active | Shield absorb, heart 0 નથી થતું |
| છેલ્લી train exit + M017 0 એક જ Move માં | Win (§5.11 step 6) |
| Track Crane (Hammer) થી train remove | Exit ગણાય — **non-lane** effects trigger: Ticket barrier ખુલે, Guardian HP −1, Steam Cloud clear, Snowed-In counters ઘટે, Depot spawn, Locked Siding colour count. **Lane** effects નહીં: Mail Sacks collect નહીં, Coal consume નહીં, Rock Pile HP નહીં, Trestle crossing નહીં (standard §16.31). Mail Sacks બાકી હોય ત્યારે **છેલ્લી train** પર Track Crane disabled |
| Track Crane પછી Reverse Gear (Undo) | Track Crane use ⇒ Undo history clear; crane ક્યારેય undo / re-apply થતો નથી (standard §16.23) |
| Solver જુએ કે કોઈ winning sequence બાકી નથી (soft-lock) | "Stuck" sheet: Reverse Gear Undo / Restart; heart loss નહીં, Level Failed screen નહીં; `E-GAME-004` log (standard §17.31) |
| Reverse Gear (Undo) bump પછી | Board + move counters revert, **heart પાછું નહીં** |
| App background mid-animation | Animation instantly complete, state save, resume પર pause screen |
| Hint solver fail | "Try Reverse Gear" toast, Hint consume નહીં |
| 0 hearts + Second Chance offline + coins < 120 | બંને disabled ⇒ "No thanks" જ; countdown પછી Level Failed |
| Revive ad આ level માં વપરાઈ ગઈ | Ad button hidden, "Revive used for this level" caption |
| Shield active + attempt end | બાકી charge lapse |

## 9. Theme Glossary (Generic → Train term)

| Generic (standard) | Toy Trains term |
|---|---|
| Path / head / body | Train / engine / carriages (cars) |
| Exit lane | Track ahead |
| Exit | Departs to Toy Box Station |
| Bump | Buffer clack |
| Hearts | Hearts (HUD પર wooden heart tokens) |
| Hint | **Green Signal Hint** |
| Undo | **Reverse Gear Undo** |
| Shield | **Cowcatcher Shield** |
| Hammer | **Track Crane** |
| Path Preview (free) | **Route Peek** |
| Heart Refill | Heart Refill (wooden repair kit icon) |
| Second Chance | "Back on Track?" popup |
| Milestone Gift Box | **Conductor's Gift Crate** |
| Phase Chest | **Grand Central Chest** |
| Coin Rush | **Golden Express Coin Rush** |
| Daily Challenge | **Daily Timetable Run** |
| 7-Day Streak | **Express Streak** |
| Lucky Spin | **Lucky Turntable** |
| VIP No-Ads Pass | **VIP Conductor Pass** |
| Guardian (M049) | Clock Tower Guardian |
| Mechanics M001–M049 | Themed names: [03 catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) |

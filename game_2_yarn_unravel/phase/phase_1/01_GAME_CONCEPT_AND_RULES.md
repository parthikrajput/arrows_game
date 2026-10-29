# 01 — Game Concept & Gameplay Rules (Yarn Unravel: Cozy Thread Puzzle)
> Purpose: game નો concept, art direction, core loop અને **બધા gameplay rules** (tap/exit/bump/win/moves/locked taps/tap priority/preview, hearts/revive/fail, stars, edge cases) એક જગ્યાએ — developer-ready.

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) · [./README.md](./README.md) · [./02_LEVEL_PROGRESSION_0001_0500.md](./02_LEVEL_PROGRESSION_0001_0500.md) · [./03_OBSTACLE_CATALOG_PHASE_1.md](./03_OBSTACLE_CATALOG_PHASE_1.md) · [./04_BOOSTERS_COINS_SHOP.md](./04_BOOSTERS_COINS_SHOP.md) · [./07_FRONTEND_IMPLEMENTATION_AND_QA.md](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

> **Source of truth:** બધા rules અને numbers [SHARED_CORE_STANDARD](../../SHARED_CORE_STANDARD.md) §1–§4 મુજબ છે. આ file તેમને yarn theme માં સમજાવે છે; કોઈ conflict દેખાય તો standard સાચું ગણવું.

---

## 1. Concept (કલ્પના)

| Item | Value |
|---|---|
| Title | **Yarn Unravel: Cozy Thread Puzzle** |
| Genre | Path-clear (tap-away) logic puzzle, turn-based, cozy/ASMR feel |
| Audience | Age 10–50 (mixed audience ⇒ age gate + Families policy, જુઓ [04 §10](./04_BOOSTERS_COINS_SHOP.md)) |
| Platform | Android 8.0+ / iOS 14+, Flutter 3.x, portrait only |
| Session | Level દીઠ 10 s (FTUE) થી 2–4 min (T5) |

**One-line pitch:** લાકડાની ફ્રેમવાળા લંબચોરસ **craft board** (linen કાપડ ખેંચેલું) પર રંગબેરંગી ઊનના દોરા પડ્યા છે. દરેક દોરાના એક છેડે સ્ટીલની **needle (સોય)** છે જે દિશા બતાવે છે. દોરા પર tap કરો — રસ્તો ખુલ્લો હોય તો needle બહાર તરફ ખેંચાય અને આખો દોરો તેની પાછળ સરસ રીતે ઉકેલાઈને (unravel) board બહાર નીકળી જાય. રસ્તો બંધ હોય તો દોરો **snag** થાય (અટકે), "twang" અવાજ સાથે પાછો spring થાય અને 1 Heart જાય. બધા દોરા કાઢો ⇒ level clear.

**USP (game ને અલગ શું બનાવે):**
1. Soft wool texture + needle head — arrow કરતાં વધુ tactile; unravel animation માં દોરો ખરેખર needle ને follow કરે.
2. 49 sewing/craft themed mechanics (buttons, pins, spools, pompoms, zippers, thimbles…) દર 10 levels એ એક નવું.
3. Cozy, no-pressure: wall-clock timer નથી, fail ની penalty નથી, retry મફત.
4. Colour-blind safe: દરેક thread colour નો અલગ pattern + needle icon.

## 2. Art Direction (દેખાવ)

- **Board:** લંબચોરસ craft board — હળવા birch લાકડાની ફ્રેમ, અંદર cream linen કાપડ, દરેક cell ના center પર ઝાંખું cross-stitch dot. **Round embroidery hoop વાપરવો નહીં** (square grid તેમાં fit થતો નથી); hoop માત્ર Home screen decoration તરીકે.
- **Threads:** 1 cell = દોરાનો 1 segment. Stroke width = cell × 0.42, round caps/joins, twisted-ply texture (pre-baked ImageShader અથવા dashed highlight — જુઓ [07 §5](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)). Corners પર soft curve (radius = cell × 0.35).
- **Needle head:** `body[0]` cell પર ચાંદી રંગની નાની needle, તેની eye માં colour icon (heart, leaf, drop…). Needle ની ટોચ `dir` તરફ.
- **Tail:** છેડે નાનો fluffy tuft (ઊનનો ગુચ્છો).
- **Mascot:** **Purl** — ક્યૂટ કાળી-સફેદ kitten જે tutorial hand, win celebration અને Gift Box માં આવે. Gameplay board પર ક્યારેય નહીં (rules પર અસર નહીં).
- **Palette:** warm cream, birch wood, pastel wool colours (tokens: [06 §2](./06_UI_UX_SCREENS.md)).
- **Audio:** yarn tug "fwp" (tap), thread unravel "zzzip-fwip" (exit), damped thread-snag "twang" (bump, ≤ 3 kHz dominant), muted thread pluck (locked), lo-fi acoustic + music-box loop with crackling fireplace bed, Win = music-box + kitten purr. Event IDs અને full mapping: [../../SOUND_EFFECTS_IMPLEMENTATION.md](../../SOUND_EFFECTS_IMPLEMENTATION.md) §9 · [07 §7](./07_FRONTEND_IMPLEMENTATION_AND_QA.md).

## 3. Core Loop

```
Home → Level Map → [Level N] → tap threads → Win → Level Complete (coins, ★)
   ↑                                         │      ├─ x0: Craft Basket (Gift Box)
   │                                         │      ├─ every 25: Golden Bobbin Rush (Coin Rush)
   │                                         │      └─ L500: Grand Sewing Chest (Phase Chest)
   └──────── Daily Challenge / Spin / Shop ←─┘
          0 Hearts → Second Chance → (revive) or Level Failed → Retry (free)
```

Meta loop: levels → coins → boosters (Shop) → harder levels; Daily Challenge → 7-day streak → Thimble Trophy.

## 4. Board, Paths & Directions

| Concept | Rule (standard §1) | Yarn term |
|---|---|---|
| Board | W×H square-cell grid, `(x, y)`, origin top-left, `x` right, `y` down | Craft board |
| Path | Ordered cell list, `body[0]` = head, `dir` ∈ `U, D, L, R` (Phase 1) | Thread (દોરો), head = Needle |
| Exit Lane | Head ના આગળના cell થી `dir` દિશામાં board edge સુધીના cells | Pull lane |
| Path cell occupancy | એક cell માં એક layer પર એક જ path body | — |

## 5. Gameplay Rules (નિયમો)

### 5.1 Tap → Exit (Unravel)
1. Player thread ના **કોઈપણ body cell** પર tap કરે (needle પર જ tap કરવું જરૂરી નથી).
2. Engine exit lane તપાસે. Lane ખાલી ⇒ needle `dir` દિશામાં ખેંચાય, બાકીનો દોરો **એ જ રસ્તે** needle ને follow કરે (snake-style follow, corners પર દોરો વળાંક લઈને સીધો થાય), board edge બહાર નીકળી remove થાય.
3. Visual: thread ઉકેલાતાં edge પાસે નાનું ઊનનું દડું (yarn ball) વીંટાય છે — માત્ર decoration.
4. Move counter +1.

### 5.2 Blocked → Bump (Snag)
1. Lane માં બીજો thread (same layer) અથવા blocking obstacle હોય ⇒ needle blocker સુધી જાય, **snag** થાય (દોરો તંગ થઈને twang), અને spring/ease animation થી મૂળ જગ્યાએ પાછો આવે.
2. **−1 Heart** (Thimble Shield active હોય તો Shield charge −1, Heart નહીં).
3. Board state બદલાતી નથી; Move counter **+1** (Move-based counters tick થાય).
4. Feedback: shake + `HapticFeedback.mediumImpact()` + "twang" SFX + blocker પર લાલ pulse.
5. Real rope physics નથી — cheap ease forward + decaying spring back (જુઓ [07 §5.4](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)).

### 5.3 Win
બધા threads exit થાય **અને** level ના વધારાના goals (દા.ત. M026 Sequins collect) પૂરા થાય ⇒ Win. છેલ્લો thread નીકળે એટલે input lock, 600 ms celebration (Purl + confetti of tiny buttons), પછી Level Complete screen.

### 5.4 Moves
- **Move** = thread પર tap (exit કે bump) **અથવા** interactive obstacle (Presser Lever, Spool Spinner, Thread Guide Switch, Quilt Block Rotor, Treadle Gear Lever…) પર tap.
- Boosters, pause, Thread Peek (preview), zoom = Move **નથી**.
- Move limit નથી (fail Moves થી થતું નથી). Moves HUD માં બતાવાય; Move-based obstacles (C category) અને Tue Daily "Par Moves" તેનો ઉપયોગ કરે.
- **Turn-based:** core puzzle માં wall-clock timer **નથી**. "Timed" દેખાતા obstacles (Basting Seam, Fraying Thread, Zipper Edge…) Move counter પર ચાલે. એકમાત્ર timer: Golden Bobbin Rush (Coin Rush, 30 s bonus round, puzzle નથી).

### 5.5 Move Resolution Order (deterministic, standard §16.17)
Tap target પહેલાં નક્કી થાય (tap priority §5.8); locked હોય ⇒ locked tap (§5.7), Move નહીં, stop. Valid Move ને engine હંમેશા આ ક્રમે resolve કરે (same state + same Move ⇒ same result):

| Step | Action |
|---|---|
| 1 | **Action resolve:** current state પર exit lane evaluate (portals, deflectors, switches, hop pads, inner exits સહિત) ⇒ Exit / Bump / Relocate (M037) / Interactive toggle. Exit effects (keys/clasps, Knotted counters, Wool Fluff clear, Guardian HP, Chalk HP, Sequins collect, spawns) અહીં. Parity mechanics (M021 Sheer Silk) આ step માં **increment પહેલાંની** Move count parity વાપરે. |
| 2 | `moveCount += 1` |
| 3 | **Counters tick** બરાબર આ ક્રમે: M007 → M017 → M031 → M025 → M027 → M047 → M041 |
| 4 | **Derived states:** plates, fog, cages, locks recompute |
| 5 | **Heart loss** (bump ⇒ −1; Fraying Thread M017 0 ⇒ −1). Thimble Shield પહેલાં absorb કરે |
| 6 | **Win check** |
| 7 | **0-heart check** ⇒ Hearts 0 ⇒ Second Chance |

Animation (≤ 450 ms) result પર ચાલે; input queue = 1 (છેલ્લો tap queue થાય).

### 5.6 Simultaneous movement નથી
એક Move ની animation પૂરી થાય (≤ 450 ms) પછી જ નવો input process થાય. Animation દરમિયાન આવેલો **છેલ્લો** tap queue થાય (queue size 1), બાકીના drop.

### 5.7 Locked Taps
જે thread હાલ tap થઈ શકે તેમ નથી (Knotted Thread, Wool Fluff નીચે, Tagged Threads માં ખોટો નંબર, Safety-Pin Cage, Knitted Loop locked, lower layer covered, Sheer Silk ghost phase) તેના પર tap ⇒ **soft wobble + "tick" locked sound**. **Heart કપાતું નથી, Move ગણાતો નથી.** Hint પણ locked thread ક્યારેય suggest નથી કરતો.

### 5.8 Tap Priority (Layers & interactive cells, standard §16.19 / §17.39)
- એક cell માં બે layers ના threads overlap થાય (M015 Stitch Bridge, M032 Double Fabric Layers) તો **ઉપરના layer** ના thread ને tap મળે.
- **Interactive mechanic cell > thread cell:** lever, turntable (M013), switch (M018), rotor (M034) ના cell પર thread ઊભો હોય તો tap mechanic ને મળે. Turntable: needle cell ⇒ turntable, બાકીના body cells ⇒ thread.
- Rotor / Turntable: thread આંશિક રીતે અંદર હોય ⇒ **locked tap** (bump નહીં).
- **Tangled:** rotation પછી needle નો નવો `dir` પોતાના body તરફ હોય ⇒ thread "tangled" ⇒ **locked tap** (heart નહીં, Move નહીં) જ્યાં સુધી dir ફરી ન બદલાય. Bump નથી.
- M023 Double-Needle Thread: બરાબર વચ્ચે tap ⇒ `body[0]` વાળો છેડો.
- ⚠️ **True over/under weaving નથી.** Threads એકબીજામાં ગૂંથાયેલા (knit/weave) હોય એવી કોઈ rule નથી. Overlap માત્ર standard ના Layer mechanics — **M015 Bridge** અને **M032 Two Layers** — થી જ થાય. Layer વગર બે threads એક cell share કરી શકતા નથી. Visual art માં પણ "આ thread બીજાની નીચે ગૂંથાયેલો છે" એવું દેખાડવું નહીં, જેથી player ખોટો rule ન માની લે.

### 5.9 Free Thread Peek (Path Preview)
- Thread પર long-press ≥ **350 ms** ⇒ exit lane dotted chain-stitch line થી દેખાય: **લીલી** = clear, **લાલ** = blocked (blocker cell પર લાલ ×).
- મફત, Move નથી, booster નથી. Release પર preview hide.
- Locked thread પર long-press ⇒ preview grey + lock icon.

## 6. Hearts, Revive & Fail

| Rule | Value |
|---|---|
| Hearts per attempt | **3** (max 3, ક્યારેય વધુ નહીં). HUD: 3 stitched-felt hearts |
| Heart-loss event | Bump (snag) અથવા Fraying Thread (M017) 0 ⇒ −1 Heart. Thimble Shield active ⇒ Shield charge −1 |
| 0 Hearts | **Second Chance** popup, 10-sec countdown ring |
| Option A: Rewarded Ad | +1 Heart. **Level દીઠ 1 વાર** — level number દીઠ, restart થી reset **નહીં**, level clear થાય ત્યારે reset. Save: `adReviveUsed[level]` |
| Option B: Heart Refill | **120 Coins** ⇒ +1 Heart. **Attempt દીઠ max 2** |
| Countdown પૂરો / "No thanks" | **Level Failed** ⇒ Retry (full 3 hearts, board reset) અથવા Home |
| Ad unavailable | Ad button disabled + "Ad unavailable" text; coin option ચાલુ |
| Revive પછી | Board reset **નથી** — ત્યાંથી જ રમત ચાલુ |

Fail penalty નથી (lives/energy system નથી). Retry હંમેશા મફત.

## 7. Stars (★)

| Result | Stars |
|---|---|
| 0 hearts lost | ★★★ |
| 1 heart lost | ★★ |
| 2+ hearts lost **અથવા** કોઈપણ revive / Heart Refill | ★ |

- Boosters stars ને અસર નથી કરતા (Thimble Shield એ absorb કરેલો bump heart lost ગણાતો નથી).
- Replay થી stars improve થઈ શકે; clear coins માત્ર પહેલી વાર, First ★★★ bonus (+20) level દીઠ એક વાર.

## 8. Boosters (summary)
વિગત: [04_BOOSTERS_COINS_SHOP.md](./04_BOOSTERS_COINS_SHOP.md).

| Themed name (generic) | Short effect |
|---|---|
| **Needle Glow Hint** (Hint) | Solver નો આગલો સાચો Move glow કરે |
| **Thimble Shield** (Shield) | આગલા 2 heart-loss events absorb |
| **Golden Scissors** (Hammer) | 1 thread અથવા `hammerable` obstacle snip કરીને remove |
| **Thread Peek** (Path Preview) | મફત long-press preview (booster નથી) |

## 9. Edge Cases

| # | Situation | Rule |
|---|---|---|
| E1 | Animation દરમિયાન 3 taps | છેલ્લો tap queue, બાકી drop |
| E2 | Same thread double-tap (exit ચાલુ છે) | બીજો tap ignore (thread already removed from state) |
| E3 | Locked thread tap | wobble + tick, Heart/Move નહીં |
| E4 | Bump વખતે Shield 1 charge બાકી | Shield charge 0, Heart સલામત; Shield icon fade |
| E5 | Last Heart bump + Shield નથી | Hearts 0 ⇒ Second Chance; Second Chance દરમિયાન board frozen |
| E6 | Ad revive already used (`adReviveUsed[level]=true`) | Ad option hidden, "Revive used for this level" text; Heart Refill ચાલુ (attempt cap 2) |
| E7 | Coins < 120 at Second Chance | Heart Refill button → mini Shop sheet (coin packs); countdown pause થાય sheet ખુલ્લું હોય ત્યારે |
| E8 | App background during animation | animation snap to end state, game auto-pause |
| E9 | App killed mid-level | attempt discard; resume = level start (hearts 3). `adReviveUsed` persist રહે |
| E13 | Golden Scissors on last thread | thread exit ગણાય ⇒ Win check. Sequins (M026) બાકી હોય ત્યારે છેલ્લા thread પર Golden Scissors **disabled** (§16.31) |
| E13a | Golden Scissors exit effects | Non-lane effects fire (key/clasp unlock, Knotted adjacency, Guardian HP, spawns, cage colour count); lane effects નહીં (Sequins, food, Chalk HP, bridge crossing) — §16.31 |
| E13b | Golden Scissors finality | Snip irreversible છે — ક્યારેય revert કે re-apply થતો નથી (§16.23) |
| E13c | Solver detects no winning sequence (soft-lock) | "Stuck" sheet: Restart; heart loss નહીં, fail screen નહીં; logged `E-GAME-004` (§17.31) |
| E14 | Golden Scissors on non-hammerable | target highlight નહીં; tap ⇒ "Can't snip this" toast, booster consume નહીં |
| E15 | Win + Hearts 0 same Move? | અશક્ય — bump board બદલતો નથી અને exit heart લેતો નથી. Fraying Thread (M017) −1 ત્યારે જ થાય જ્યારે તે thread હજી board પર હોય ⇒ તે Move માં Win શક્ય નથી. Fraying Thread પોતે exit થાય તો step 1 માં remove, step 3 tick તેના પર લાગતું નથી |
| E16 | Long-press 350 ms પછી release thread પર | preview hide; tap **trigger નથી** થતો |
| E17 | Tap between two cells / outside board | nearest cell centre ≤ 0.5 cell; નહીં તો ignore |
| E18 | Two threads' needles face each other | બંને blocked ⇒ level design error (CI validator reject) |

## 10. Theme Glossary (Generic → Yarn)

| Generic (standard) | Yarn Unravel term |
|---|---|
| Board | Craft board (linen on birch frame) |
| Path | Thread (ઊનનો દોરો) |
| Head | Needle (સોય) |
| Tail | Tuft |
| Exit | Unravel / pull out |
| Bump | Snag (twang & spring back) |
| Exit Lane | Pull lane |
| Hearts | Hearts (stitched felt) |
| Coins | Coins (wool-coin art, name "Coins") |
| Hint / Shield / Hammer | Needle Glow Hint / Thimble Shield / Golden Scissors |
| Path Preview | Thread Peek |
| Gift Box | Craft Basket |
| Coin Rush | Golden Bobbin Rush |
| Phase Chest | Grand Sewing Chest |
| Lucky Spin | Spinning Wheel |
| Streak Saver | Darning Patch |
| Streak Trophy | Thimble Trophy |
| Second Chance | "Tangled Up!" popup |
| Guardian (M049) | Grand Pincushion Guardian |
| Mechanics M001–M049 | Craft names — full list [03](./03_OBSTACLE_CATALOG_PHASE_1.md) |

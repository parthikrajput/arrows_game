# Shared Core Standard (Single Source of Truth)

> Game-wise copy for **Toy Trains** (`game_3_toy_trains`). This file lives in this game folder and is the version used here. The same document exists in the other three game folders; when a shared rule or number changes, update all four copies. Links to other games point to the sibling game folders.

> ચારેય games (Snakes, Yarn, Trains, Ants & Bees) એક જ **puzzle engine** પર ચાલે છે. આ document એ engine ના **નિયમો, numbers અને mechanics library** નો એકમાત્ર source of truth છે.
> દરેક game folder આ નિયમોને પોતાની theme માં (નામ, art, sound) રજૂ કરે છે. **કોઈ number બદલવો હોય તો પહેલા અહીં બદલો, પછી ચારેય games માં.** બધા economy numbers Firebase Remote Config થી live tune થઈ શકે છે; અહીં લખેલા values એ launch defaults છે.

**Version:** 3.0 (2026-10-27) — અગાઉના GAME_DESIGN_V2, GAME_DESIGN_SPEC, POWERUPS_SHOP_ECONOMY વગેરેના વિરોધાભાસો દૂર કરીને બનાવેલ.

---

## 1. Terms (શબ્દો)

| Term | Meaning |
|---|---|
| **Board** | W×H square-cell grid. Cell = `(x, y)`, `x` → right, `y` → down, origin top-left. |
| **Path** | Game નું મુખ્ય piece (snake / thread / train / ant-or-bee line). Ordered cell list `body[0]` = head. દરેક path પાસે `dir` (head facing) છે: `U, D, L, R` (Phase 2 થી `UL, UR, DL, DR` પણ). |
| **Exit Lane** | Head ના આગળના cell થી `dir` દિશામાં board ની edge સુધીના cells. |
| **Move** | Player નો એક action જે board state બદલે: path પર tap (exit કે bump) **અથવા** interactive obstacle (lever, turntable, વગેરે) પર tap. Boosters, pause, zoom = Move નથી. |
| **Bump** | Path નો exit lane blocked હોય ત્યારે path આગળ સરકી, અથડાઈને પાછો મૂળ જગ્યાએ આવે. **−1 Heart.** Board state બદલાતી નથી (પણ Move counter +1). |
| **Attempt** | Level ની એક play (Start/Restart થી Win/Fail સુધી). |
| **Mechanic** | Obstacle અથવા path-variant. Library ID `M001…`. દરેક game તેને પોતાનું themed નામ આપે છે. |

## 2. Core Gameplay Rules (બધી games માં એકસરખા)

1. **Tap → Exit:** Player path ના **કોઈપણ body cell** પર tap કરે. Exit lane ખાલી હોય તો path head ની દિશામાં સરકીને (body head ને follow કરે) board બહાર જાય અને remove થાય.
2. **Blocked → Bump:** Lane માં બીજો path અથવા blocking obstacle હોય તો path blocker સુધી જાય, અથડાય (shake + haptic + sound), અને પાછો મૂળ જગ્યાએ આવે. **−1 Heart.**
3. **Win:** બધા paths exit થાય (અને level નો વધારાનો goal હોય, જેમ કે gems, તો તે પણ પૂરો થાય).
4. **Turn-based, no real-time pressure:** Core puzzle માં **wall-clock timer નથી**. "Timed" દેખાતા obstacles **Move counter** પર ચાલે છે (દરેક Move = 1 tick). એકમાત્ર exception: **Coin Rush** bonus round (30 sec, puzzle નથી).
5. **Deterministic:** એક જ state + એક જ Move = હંમેશા એક જ પરિણામ. Randomness માત્ર level generation વખતે seed થી.
6. **No forced damage:** કોઈ obstacle ને પાર કરવા heart ગુમાવવું કે booster વાપરવું **ફરજિયાત નથી**. દરેક level **0 hearts lost, 0 boosters** થી solvable હોવું જોઈએ (CI validator ચકાસે).
7. **Locked taps:** જે path હાલ tap થઈ શકે તેમ નથી (frozen, fogged, out-of-order) તેના પર tap = soft wobble + "locked" sound. **Heart કપાતું નથી, Move ગણાતો નથી.**
8. **Simultaneous movement નથી:** એક Move પૂરો થાય (animation ≤ 450 ms) પછી જ બીજો input લેવાય. Input queue = 1 (animation દરમિયાન આવેલો છેલ્લો tap queue થાય).
9. **Tap priority:** એક cell માં બે layers ના paths overlap થાય તો **ઉપરના layer** ના path ને tap મળે.
10. **Free Path Preview:** Path પર long-press (≥ 350 ms) કરવાથી તેનો exit lane dotted line થી દેખાય (લાલ = blocked, લીલો = clear). મફત છે, Move નથી.

## 3. Hearts, Revive & Fail

| Rule | Value |
|---|---|
| Hearts per attempt | **3** (max 3; ક્યારેય 3 થી વધુ નહીં) |
| Bump / heart-loss event | −1 Heart (Shield active હોય તો Shield charge −1) |
| 0 Hearts | **Second Chance** popup ખૂલે, 10-sec countdown ring |
| Option A: Rewarded Ad | +1 Heart. **Level દીઠ 1 વાર** (level number દીઠ, restart કરવાથી reset **નથી** થતું; level clear થાય પછી reset). Save file માં `adReviveUsed[level]` |
| Option B: Heart Refill | **120 coins** → +1 Heart. **Attempt દીઠ max 2 વાર** |
| Countdown પૂરો / "No thanks" | **Level Failed** screen → Retry (full 3 hearts, board reset) અથવા Home |
| Ad unavailable (offline / no-fill) | Ad button disabled + "Ad unavailable" text; coin option ચાલુ |
| Revive પછી | Board **reset થતું નથી**, game ત્યાંથી જ ચાલુ |

Fail ની કોઈ penalty નથી (lives/energy system નથી). Retry હંમેશા મફત.

## 4. Stars (★)
- ★★★ = 0 hearts lost · ★★ = 1 heart lost · ★ = 2+ hearts lost **અથવા** કોઈપણ revive/Heart Refill વાપર્યું.
- Boosters stars ને અસર નથી કરતા.
- Replay થી stars improve થઈ શકે; coins માત્ર પહેલી વાર મળે (નીચે જુઓ).

## 5. Boosters (3) + Free Tools

| Booster (generic) | Effect | Unlock | Per-attempt cap | Single | 3-Pack |
|---|---|---|---|---|---|
| **Hint** 💡 | Solver મુજબ આગલો સાચો Move glow કરે (path અથવા lever). Move ગણાતો નથી. | L3 (tutorial, 3 free) | 3 | 60 | **150** |
| **Shield** 🛡️ | Activate કરો ત્યારથી current attempt માં આગલા **2** heart-loss events absorb કરે. Attempt પૂરો થાય ત્યારે બાકી charge lapse થાય. એક સમયે 1 Shield. | L15 (1 free) | 1 | 80 | **200** |
| **Hammer** 🔨 | કોઈપણ **1 path** (exit ગણાય) **અથવા** `hammerable: true` obstacle ને remove કરે. Guardian/Armored/Edge Walls hammerable નથી. | L25 (1 free) | 2 | 100 | **250** |

- **Heart Refill (120)** booster inventory માં નથી; માત્ર Second Chance popup માં.
- **Path Preview** (long-press) મફત feature છે, booster નથી.
- Booster bar: 3 buttons (Hint, Shield, Hammer), inventory count badge; count 0 હોય તો tap → mini shop sheet.
- Theme names: દરેક game પોતાનું નામ આપે (દા.ત. Snakes: "Glow Firefly Hint"), પણ **effect, caps, prices અહીંના જ**.

## 6. Coins Economy

### 6.1 Inflow (launch defaults)
| Source | Coins | Notes |
|---|---|---|
| Level first clear | Easy **15** / Normal **20** / Hard **30** / Phase Finale **50** | Difficulty label level JSON માં (`tag`). Replay = 0 coins |
| First ★★★ on a level | **+20** | એક level દીઠ એક જ વાર |
| 2X Win (rewarded ad) | base clear coins ×2 | Star bonus double નથી થતો |
| Milestone Gift Box (L10, L20, …) | L10–100: **150** · L110–200: **180** · L210–300: **210** · L310–400: **250** · L410–490: **300** · Phase 2 (L510–990): **300** | + 1 booster: `(L/10) mod 3` → 1=Hint, 2=Hammer, 0=Shield |
| Phase Chest (L500, L1000, …) | **1,000** + 2 each booster (2 Hint + 2 Shield + 2 Hammer) + phase badge | Gift Box ની જગ્યાએ |
| Coin Rush (after L25, 50, 75 …) | **10/path**, 20–30 paths, full clear **+100** → max 300–400 | Bonus round, level number નથી |
| Daily Challenge clear | **+100** | દિવસ દીઠ 1 વાર |
| 7-Day Streak | §8 ladder (week total 1,150 + boosters) | |
| Lucky Spin | §6.3 | |
| Shop free coins (rewarded) | **+50** | **max 5/day** |
| Phase 2: Album volume complete | 300 / 400 / 600 / 800 / 1,000 (Vol 1–5) + 1 cosmetic | §17.26 |
| Phase 2: Weekly Star Race | 1st 1,000 + frame + 3 of each booster · 2nd 500 + 2 Hammer + 1 Hint · 3rd 250 + 1 Shield · 4th–5th 50 | Ghosts get no rewards |

### 6.2 Outflow (sinks)
Boosters (§5), Heart Refill (120), Streak Saver (200), Phase 2: cosmetic skins/board themes (800–4,000).

**Starting wallet:** 200 coins + 3 Hint + 1 Shield + 1 Hammer (દરેક tutorial વખતે ગ્રાન્ટ થાય).

**Balance sanity:** સરેરાશ ~60–70 coins/level (clear + star + gift/rush share) ⇒ 1 Hint ≈ 1 level; 1 Hammer ≈ 1.5 levels. Boosters "earnable but valuable" રહે.

### 6.3 Lucky Spin
1 free spin/day (day key §8.4) + 1 extra via rewarded ad (max 2/day). 8 segments:

| Prize | Probability |
|---|---|
| 20 coins | 30% |
| 50 coins | 25% |
| 75 coins | 12% |
| 100 coins | 15% |
| 1 Hint | 10% |
| 1 Shield | 5% |
| 1 Hammer | 2.5% |
| 500 coins (Jackpot) | 0.5% |

Odds Settings → "Spin odds" માં બતાવવા ફરજિયાત (store policy). Server-free: result = `PRNG(seed = hash(installId, dayKey, spinIndex))`.

## 7. Monetization

### 7.1 Ads (AdMob, `google_mobile_ads`)
| Format | Rule |
|---|---|
| **Interstitial** | **દર 5 numbered-level wins** પર 1. Levels 1–10 દરમિયાન **ક્યારેય નહીં** (પહેલું eligible: L15 win). Last full-screen ad (interstitial કે rewarded) પછી **min 120 sec**. Win screen પર Gift Box / Coin Rush / Phase Chest હોય તો **defer** → આગલી eligible win. Fail, Daily Challenge, Coin Rush પછી ક્યારેય નહીં. Counter `winsSinceInterstitial` save file માં persist. Daily cap 20. |
| **Rewarded** (opt-in only) | 2X Win · Revive (level દીઠ 1) · Shop +50 coins (5/day) · Lucky Spin extra (1/day) · Streak Saver |
| **Banner** | Adaptive anchored banner, **ફક્ત Home અને Level Map** + gameplay bottom **L11 થી**. Booster bar ની નીચે ≥ 8 dp gap + divider (accidental-click policy). Board / buttons ને ક્યારેય overlap નહીં |
| **Preload** | App start પર rewarded + interstitial preload; show પછી તરત reload. Load fail → exponential backoff (max 3 retries/session) |

### 7.2 IAP (`in_app_purchase`)
| Product | Type | Price (India) | Content |
|---|---|---|---|
| **VIP No-Ads Pass** | Auto-renewing subscription, 1 month | **₹20/month** | Active હોય ત્યાં સુધી interstitial + banner બંધ. Rewarded ads optional રહે. Expire થાય તો ads પાછી આવે ("કાયમી" નહીં) |
| Coins S | Consumable | ₹49 | 350 coins |
| Coins M (Popular) | Consumable | ₹149 | 1,000 coins |
| Coins L | Consumable | ₹299 | 2,200 coins |
| Coins XL (Best Value) | Consumable | ₹699 | 5,500 coins |
| Starter Pack | One-time, L15 પછી 48 h | ₹79 | 800 coins + 3 Hint + 2 Hammer + 2 Shield |
| Piggy Bank (Phase 2) | Consumable | ₹49 | Stored coins (max 1,000) |

Restore purchases button (Settings), server-side receipt validation (Phase 1: Firebase Cloud Function `verifyPurchase`). ⚠️ Business note: ₹20 subscription નો net (GST + store fee પછી) ≈ ₹14; Remote Config થી price test કરવો.

### 7.3 Compliance (Target age 10–50 ⇒ mixed audience)
- First launch: **neutral age gate** (birth year). Under-13 ⇒ `tagForChildDirectedTreatment`, non-personalized ads, max ad content rating **G**, analytics personalization off.
- Google Play **Families policy**: Families Self-Certified Ads SDK only (AdMob OK); no personal data from children.
- **UMP consent** form (EEA/UK) app start પર, ads load પહેલાં.
- Lucky Spin odds disclosure; no real-money gambling.

## 8. Daily Challenge & 7-Day Streak

### 8.1 Daily Challenge
- Unlock: **L15** clear પછી.
- Day દીઠ 1 puzzle; seed = `hash(gameId, dayKey)` ⇒ દુનિયાભરમાં એ જ local date પર એ જ puzzle (offline પણ).
- Difficulty: player ના `highestClearedLevel` ના tier પ્રમાણે (generator params of `max(15, highestCleared − 10)`), **માત્ર unlocked mechanics** વપરાય.
- Weekday modifier (પ્લેયર બંને ભાગ જોઈ શકે):

| Day | Modifier |
|---|---|
| Mon | Classic (કોઈ modifier નહીં) |
| Tue | **Par Moves:** par થી વધુ Moves ⇒ ★ ઓછો (fail નહીં) |
| Wed | **One Heart:** 1 heart, revive allowed |
| Thu | **Fog Day:** M010 fog વધારે |
| Fri | **Key Hunt:** keys/locks વધારે |
| Sat | **Big Board:** player tier ના max grid size |
| Sun | **Mini Boss:** Guardian (M049) જો unlocked, નહીં તો Big Board |

- Retry unlimited; reward (+100 coins + streak day) એક વાર. Boosters allowed.
- Shape: Daily board 7 silhouettes (Mon–Sun) માંથી એક shape માં paths ગોઠવાય (sticker album Phase 2 માં વપરાય).

### 8.2 Streak (Daily Challenge clear થી આગળ વધે — માત્ર login નહીં)
| Day | Reward |
|---|---|
| 1 | 50 coins |
| 2 | 75 coins |
| 3 | 100 coins + 1 Hint |
| 4 | 150 coins |
| 5 | 150 coins + 1 Shield |
| 6 | 200 coins + 1 Hammer |
| 7 | **450 coins + 1 Hint + 1 Shield + 1 Hammer + Streak Trophy** (દરેક 7-day cycle પર trophy level વધે: Bronze → Silver → Gold → …) |

- Day 7 પછી ⇒ નવો cycle Day 1 થી; `totalStreakDays` counter ચાલુ રહે (leaderboard માટે).
- **Miss rule:** Exactly 1 day miss ⇒ પાછા આવો ત્યારે **Streak Saver** offer: 1 rewarded ad **અથવા** 200 coins. **7-day cycle દીઠ 1 વાર.** Saver વાપરવાથી missed day ના reward **મળતા નથી**, streak ત્યાંથી ચાલુ રહે.
- 2+ days miss ⇒ Day 1 reset (Saver offer નહીં).

### 8.3 Leaderboards (Phase 1)
Google Play Games Services / Apple Game Center (`games_services`): **Highest Level**, **Total Stars**, **Total Streak Days**. Friends = platform friends. Custom backend નહીં. (Local progress hackable છે ⇒ leaderboard માત્ર fun; rewards leaderboard rank પર આધારિત નથી.)

### 8.4 Day Key & Anti-Cheat
- `dayKey` = device **local date** `YYYY-MM-DD` (midnight reset).
- Save: `lastClaimDayKey`, `lastTrustedUtc`, `lastServerUtc` (online હોય ત્યારે Firebase/HTTP `Date` header થી).
- Device clock `lastTrustedUtc − 2h` થી પાછળ ⇒ **Time-travel lock:** Daily claim, Streak, Spin બંધ જ્યાં સુધી clock `lastTrustedUtc` થી આગળ ન જાય.
- એક `dayKey` માટે claim એક જ વાર; બે claims વચ્ચે **min 20 h real elapsed** (server time અથવા monotonic uptime થી).
- Timezone change allowed, પણ ઉપરના rules ⇒ double-claim નહીં.
- Offline: Daily રમી શકાય, reward local grant થાય; online થાય ત્યારે server time થી verify (mismatch ⇒ streak freeze, coins revoke નહીં).

## 9. Level Structure & Difficulty

### 9.1 Phases (દરેક phase = 500 levels)
| Phase | Levels | Content |
|---|---|---|
| **Phase 1 (Launch)** | 1–500 | 49 mechanics M001–M049 (L11, 21 … 491) + L500 Phase Finale |
| **Phase 2** | 501–1000 | L501–510 onboarding (zoom, bigger boards) + 49 mechanics M051–M099 (L511, 521 … 991) + L1000 Finale + LiveOps (Album, Star Race, Piggy, Cloud Sync, Cosmetics) |
| **Phase 3–20** | 1001–10,000 | દરેક phase: 1 signature system + 4 new base mechanics + 45 **variants** (base × modifier). §11 |

### 9.2 10-Level Block Pattern ("દર 10 levels એ નવું")
દરેક block `N1…N0` (દા.ત. 11–20):
| Slot | Role | Difficulty |
|---|---|---|
| x1 | **Intro:** નવું mechanic, માત્ર તે જ obstacle, tutorial hand/tooltip | Band low |
| x2–x4 | Practice: નવું + જૂના mix | low → mid |
| x5 | Breather | low (tag Easy) |
| x6–x8 | Ramp | mid → high |
| x9 | **Hard** level (red badge) | high +10% (tag Hard) |
| x0 | Milestone (Gift Box) | mid |

Phase Finale (L500, L1000, …): Boss board, band high +20%, tag Finale.

### 9.3 Tier Table (Phase 1 & 2)
| Tier | Levels | Grid | Paths | Max obstacle instances | D band |
|---|---|---|---|---|---|
| FTUE | 1–3 | 4×4–5×5 | 2–4 | 0 | 1–4 |
| FTUE | 4–10 | 5×5–6×6 | 4–8 | 0 | 3–8 |
| T1 | 11–100 | 6×6–8×8 | 6–14 | 1–4 | 6–18 |
| T2 | 101–200 | 7×7–9×9 | 10–18 | 3–6 | 14–26 |
| T3 | 201–300 | 8×8–10×10 | 14–22 | 4–8 | 22–36 |
| T4 | 301–400 | 9×9–10×10 | 18–26 | 5–9 | 30–44 |
| T5 | 401–500 | 10×10–11×11 | 22–30 | 6–10 | 38–52 |
| P2-A | 501–750 | 10×10–13×13 | 24–34 | 6–12 | 45–60 |
| P2-B | 751–1000 | 12×12–14×14 | 28–40 | 8–14 | 52–70 |

- Phase 1 max **11×11** ⇒ 360 dp phone પર (16 dp gutters) cell ≥ 29 dp. Phase 2 (≥ 12×12) માં **pinch-zoom + pan** ચાલુ, auto-fit start.
- Difficulty decreases નહીં: Phase n+1 નો lowest band ≥ Phase n ના T-last mid.
- FTUE target (analytics થી માપવું): L1–3 median clear ≤ **10 s**, L4–10 median ≤ **20 s**. Design rule (deterministic, CI): L1–3 optimal solution ≤ 4 Moves, L4–10 ≤ 8 Moves.

### 9.4 Difficulty Score D (CI માં compute)
```
D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
P = path count, C = longest dependency chain (solver), O = obstacle instances,
N = non-monotone mechanic instances (lever, plate, countdown, …), S = solution Moves − P (extra interactive moves)
```
Generator level નો D તેના slot target band (±3) માં ન આવે તો reject.

## 10. Mechanics Library (Phase 1 & 2)
Fields દરેક game ના OBSTACLE_CATALOG માં ફરજિયાત: **ID, themed name, intro level, category, rule, tap/bump behaviour, heart effect, hammerable?, Hint/solver notes, visual & audio, JSON schema, implementation notes, level-design usage.**

Categories: **B** Static Blocker · **K** Key/Lock · **C** Counter (Move-based) · **T** Toggle/Interactive · **P** Path-variant · **D** Direction changer · **L** Layer · **G** Goal/Helper · **X** Boss.

> Theme mapping rule: દરેક game દરેક ID ને theme-યોગ્ય નામ/art આપે. **Game 4 (Ants & Bees)** માટે exception: bees = Air layer એ M004 slot (L41) પર આવે અને Key & Lock M032 slot (L321) પર જાય — game 4 catalog માં swap સ્પષ્ટ લખવો. બીજી કોઈ ordering change માન્ય નથી.

### Phase 1 (M001–M049)
| ID | Intro | Cat | Generic mechanic | Exact rule |
|---|---|---|---|---|
| M001 | 11 | B | Single Blocker | 1 cell; lane blocks. hammerable |
| M002 | 21 | B | Long Wall | 2–4 straight cells; lane blocks. hammerable (આખી wall) |
| M003 | 31 | C | Frozen Path | Path locked until K (1–3) **adjacent** (orthogonal) paths exit; badge shows K |
| M004 | 41 | K | Key & Lock | Key icon on a path; matching-color Lock cell blocks until key-path exits, then opens permanently. Lock not hammerable |
| M005 | 51 | B | Color Gate | Cell passable only by same-color path; others bump |
| M006 | 61 | D | One-Way Tile | Passable only in arrow direction; else bump |
| M007 | 71 | C | Countdown Gate | Closed gate opens permanently after N Moves (badge N) |
| M008 | 81 | D | Portal Pair | Lane entering portal A continues from portal B same dir. Path occupying B ⇒ blocked |
| M009 | 91 | T | Lever + Toggle Gates | Tap lever (1 Move) ⇒ all linked gates flip open/closed. Non-monotone |
| M010 | 101 | C | Fog Patch | Paths under fog hidden & locked; a fog area clears when any path whose body touches it exits |
| M011 | 111 | P | Chained Pair | 2 paths linked; tap either ⇒ both try; both lanes must be clear else both bump (−1 heart total) |
| M012 | 121 | P | Sleeping Path | 1st tap wakes (1 Move), 2nd tap exits |
| M013 | 131 | T | Turntable | Path head on turntable; tap turntable ⇒ rotates that path 90° CW (1 Move) |
| M014 | 141 | D | Mirror | `/` or `\` cell; lane turns 90° |
| M015 | 151 | L | Bridge | Path cells lying on bridge do not block perpendicular lanes passing under |
| M016 | 161 | C | Cracked Rock | HP 1–3; −1 HP whenever an exiting lane passes an orthogonally adjacent cell; HP 0 ⇒ removed. hammerable |
| M017 | 171 | C | Countdown Path | Must exit within N Moves; at 0 ⇒ −1 heart, counter resets to N |
| M018 | 181 | T | Switch Junction | Cell turns lane L or R per state; tap switch toggles (1 Move) |
| M019 | 191 | T | Pressure Plate | Linked gate open **while** some path body covers plate; plate-path exits ⇒ gate closes |
| M020 | 201 | G | Inner Exit (Hole) | Internal cell acting as exit; lane reaching it ⇒ path exits into it |
| M021 | 211 | P | Phasing Path | Solid on even Move count, ghost (non-blocking, not tappable) on odd |
| M022 | 221 | P | Reverse Path | Exits tail-first (moves backward); arrow cue on tail |
| M023 | 231 | P | Two-Head Path | Head both ends; tap near an end ⇒ exits that way (tap nearest-end rule) |
| M024 | 241 | P | Wide Path | 2-cell-wide body; needs 2-wide clear lane |
| M025 | 251 | C | Patrol Blocker | Moves 1 cell along fixed loop each Move; blocks where it stands |
| M026 | 261 | G | Collect Gems | Win also requires every gem collected (lane passing gem collects it) |
| M027 | 271 | C | Spreader | Every N Moves grows 1 cell into first free neighbour (fixed order U,R,D,L) |
| M028 | 281 | P | Numbered Paths | Must exit in ascending number order; wrong = locked tap |
| M029 | 291 | B | Edge Wall | Board edge segments walled; lanes hitting edge wall bump. not hammerable |
| M030 | 301 | B | Color Edge | Edge opening only for one color |
| M031 | 311 | C | Closing Edge | Open edge segment closes permanently after N Moves |
| M032 | 321 | L | Two Layers | Upper-layer paths drawn above; lower path locked while any upper path covers its body; lanes interact only within own layer |
| M033 | 331 | K | Color Cage | Caged path locked until all paths of cage color exit |
| M034 | 341 | T | Rotor 2×2 | Tap rotor ⇒ 2×2 contents rotate 90° CW (paths fully inside only) |
| M035 | 351 | P | Spawner Path | On exit spawns a short child path at marked cells (if free, else waits) |
| M036 | 361 | P | Hungry Path | Can exit only if lane passes a food cell (food consumed) |
| M037 | 371 | D | Mud Trap | Lane reaching mud stops path there (relocates, 1 Move); next tap continues from mud |
| M038 | 381 | G | Jump Pad | Lane over pad leaps the next 1 cell (can jump a 1-cell blocker, not a path) |
| M039 | 391 | P | Mirror Twins | Tap one ⇒ twin moves mirrored; both must be clear |
| M040 | 401 | G | Night Board | Visual: only area near last moved path + long-press preview lit. Rules unchanged |
| M041 | 411 | P | Chameleon Path | Color cycles (R→G→B) each Move; interacts with M005/M030/M033 |
| M042 | 421 | L | Fragile Bridge | Bridge allows 1 crossing then becomes Single Blocker |
| M043 | 431 | K | Multi-Lock | Lock needs 2–3 keys (all key-paths exit) |
| M044 | 441 | D | Turning Portal | Portal pair that rotates lane direction 90° on exit side |
| M045 | 451 | T | Gear Lever | One lever rotates multiple turntables (M013) together |
| M046 | 461 | K | Loop Path | Closed loop; locked until linked key-path exits, then opens at marked head |
| M047 | 471 | C | Growing Path | Tail grows 1 cell every N Moves into free cell behind tail (no growth if blocked) |
| M048 | 481 | P | Color Group Tap | Tapping a group-marked path moves all same-color group paths; any blocked ⇒ all bump (−1) |
| M049 | 491 | X | Guardian | Multi-cell blocker, HP = linked paths count; each linked exit −1 HP; 0 ⇒ vanish. not hammerable |
| — | 500 | X | **Phase 1 Finale** | Guardian + mix of ≥ 8 Phase-1 mechanics |

### Phase 2 (M051–M099) — Levels 501–1000
| ID | Intro | Cat | Generic mechanic | Exact rule |
|---|---|---|---|---|
| — | 501–510 | — | Onboarding | Zoom/pan tutorial, 12×12 boards, no new mechanic |
| M051 | 511 | P | Diagonal Paths | 8-direction heads; diagonal lanes |
| M052 | 521 | D | Corner Bumper | Deflects diagonal lanes 90° |
| M053 | 531 | T | Push Block | Lane hitting block pushes it 1 cell if free behind (1 Move, path stays, no heart). Blocked ⇒ bump |
| M054 | 541 | D | Ice Floor | Pushed blocks slide until hitting something |
| M055 | 551 | T | Block Plate | Push Block on plate ⇒ linked gate open while block stays |
| M056 | 561 | L | Ramp | Lane entering ramp moves path to other layer |
| M057 | 571 | C | Traffic Light | Gate open/closed alternates every N Moves (periodic) |
| M058 | 581 | D | Rotating Arrow | One-way tile rotates 90° CW each Move |
| M059 | 591 | P | Paint Cell | Lane passing paint recolors the path |
| M060 | 601 | T | Swap Pad | Tap pad ⇒ 2 linked paths swap positions (same shape only) |
| M061 | 611 | G | Capacity Hole | Inner exit accepting N paths, then closes |
| M062 | 621 | G | Edge Quota | Goal: ≥ Q paths of a color exit via marked edge |
| M063 | 631 | C | Magnet Blocker | Each Move pulls the nearest path in its row/col 1 cell toward it if free |
| M064 | 641 | T | Seesaw Gates | 2 linked gates; exactly one open; flips whenever a lane passes the open one |
| M065 | 651 | K | Hidden Key | Key under fog / under another path; revealed when cover clears |
| M066 | 661 | P | Chained Triplet | 3-path chain (M011 ×3) |
| M067 | 671 | C | Collapsing Floor | Cell becomes hole-blocker after lanes pass it N times |
| M068 | 681 | C | Trail Blocker | Exiting path leaves temporary blockers on its lane for 2 Moves |
| M069 | 691 | L | Three Layers | Ground / mid / top (extends M032) |
| M070 | 701 | T | Global Rotator | Lever rotates every path's dir 90° CW |
| M071 | 711 | B | Quota Edge | Edge opens after Q total exits |
| M072 | 721 | P | Color Sequence | Colors must exit in shown repeating pattern |
| M073 | 731 | P | Bubble Path | Bubble absorbs bumps *into* this path: 1st lane hitting it pops bubble (no heart loss for that bumping path, which returns); then behaves normally |
| M074 | 741 | B | Armored Wall | Not hammerable; removed only by linked lever |
| M075 | 751 | C | Creeping Fog | Fog expands 1 cell every N Moves (fixed order) |
| M076 | 761 | D | Portal Network | 3+ portals cycle A→B→C |
| M077 | 771 | X | Bomb Blocker | Linked path exit ⇒ clears hammerable obstacles in 3×3 |
| M078 | 781 | B | Center-Only Exit | Board edges walled; only inner exits (M020) |
| M079 | 791 | T | Board Rotator | Every N Moves whole board rotates 90° CW (paths' dirs rotate too) |
| M080 | 801 | K | Twin Locks | 2 locks that open only if both keys exit on same Move (via M011 chain) |
| M081 | 811 | P | Mimic Path | Takes dir of last moved path |
| M082 | 821 | D | Conveyor | Path fully on belt shifts 1 cell along belt each Move if free |
| M083 | 831 | T | Heavy Plate | Only Wide Path (M024) can hold it |
| M084 | 841 | B | Laser Emitter | Beam line acts as blocker; beam stops at first path/blocker |
| M085 | 851 | T | Laser Receiver | Beam hits receiver ⇒ linked gate open while hit |
| M086 | 861 | D | Beam Mirror | Mirror for beams and lanes |
| M087 | 871 | P | Glue Pad | Head on glue ⇒ 1st tap unsticks, 2nd exits |
| M088 | 881 | K | Lane Mine | Mine blocks lane until linked key-path exits (defuse) |
| M089 | 891 | D | Prism | Beam splits into two 90° beams |
| M090 | 901 | C | Parity Gate | Open on odd Move count, closed on even |
| M091 | 911 | T | Rotor 3×3 | M034 at 3×3 |
| M092 | 921 | P | Segmented Path | Each tap exits 1 segment (multi-tap, each = 1 Move) |
| M093 | 931 | P | Splitter Path | Tap ⇒ splits at midpoint into 2 paths facing opposite; then each exits normally |
| M094 | 941 | P | Color Mixer | Two paints mix (R+B = Purple etc.) |
| M095 | 951 | B | Color Quota Edge | M071 per color |
| M096 | 961 | P | Shadow Path | Visible & tappable only on even Move count; never blocks when invisible |
| M097 | 971 | B | Domino Chain | Clearing first domino (hammer or linked exit) clears chain in order |
| M098 | 981 | X | Moving Guardian | M049 + M025 patrol |
| M099 | 991 | K | Master Lock | Needs all key types + laser receiver |
| — | 1000 | X | **Phase 2 Finale** | Moving Guardian + ≥ 10 mixed mechanics |

## 11. Phases 3–20 Plan (Levels 1001–10,000)
દરેક phase: 4 new base mechanics + 1 signature system; 49 slots = 4 intro slots (x1 of blocks 1, 13, 25, 37) + 45 **variant** slots. **Variant = existing base mechanic × modifier**. Modifiers: `Frozen(K)`, `Colored`, `Fogged`, `Chained`, `Countdown(N)`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`. દરેક variant નવું intro tutorial card મેળવે.

| Phase | Levels | Signature system | 4 new base mechanics |
|---|---|---|---|
| 3 | 1001–1500 | **Cycles** (board A/B state every 5 Moves) | Cycle Gate, Cycle Bridge, Cycle Portal, Cycle Color |
| 4 | 1501–2000 | **Multi-floor** (up to 3 floors, stairs) | Stairs, Glass Floor, Drop Hole, Elevator |
| 5 | 2001–2500 | **Push Physics+** | Crate Holes, Sliding Ice Crates, Crate Keys, Heavy Crate |
| 6 | 2501–3000 | **Light & Beams+** | Color Filter, Beam Splitter Lock, Beam Timer, Dark Cells |
| 7 | 3001–3500 | **Rotation** | Sub-board Rotor, Rotating Edges, Spin Path, Rotation Lock |
| 8 | 3501–4000 | **Growth** | Vine Spread+, Pruner Tile, Seed Path, Bloom Gate |
| 9 | 4001–4500 | **Split & Merge** | Merger Pad, Twin Splitter, Segment Lock, Rejoin Gate |
| 10 | 4501–5000 | **Sequencing** | Rhythm Gate, Pattern Lock, Order Edge, Echo Sequence |
| 11 | 5001–5500 | **Linked Boards** (2 mini boards) | Board Link Edge, Cross-board Key, Mirror Board, Relay Portal |
| 12 | 5501–6000 | **Gravity** | Gravity Lever, Falling Blockers, Anti-grav Tile, Weight Path |
| 13 | 6001–6500 | **Hidden Info** | Scout Path, Mimic Fog, False Wall, Reveal Plate |
| 14 | 6501–7000 | **Mirror Worlds** | Mirror Axis, Reflect Lock, Twin Board, Inverse Path |
| 15 | 7001–7500 | **Conveyors & Tracks** | Belt Junction, Reversible Belt, Belt Lever, Track Loop |
| 16 | 7501–8000 | **Keys Deluxe** | Key Chain, Key Crafting, Skeleton Key, Key Swap |
| 17 | 8001–8500 | **Guardians** | Twin Guardian, Shield Guardian, Spawner Guardian, Guardian Core |
| 18 | 8501–9000 | **Remix A** (P1–P6 systems) | 4 combo-mechanics chosen by data |
| 19 | 9001–9500 | **Remix B** (P7–P12 systems) | 4 combo-mechanics |
| 20 | 9501–10000 | **Grand Master** | all systems; L10000 Grand Finale |

Phase 3+ level content: on-device generation (§12). નવો phase release = app update + Remote Config `maxPhase`.

## 12. Level Pipeline & Generator
- **Phase 1–2 (L1–1000):** offline generator (Dart CLI, `tools/levelgen`) + designer hand-tuning ⇒ JSON ⇒ CI validator ⇒ app bundle (`assets/levels/phase_1.json.gz`, `phase_2.json.gz`). Hand-tuned: L1–30, દરેક x1 intro, x9 Hard, Finale.
- **Phase 3+:** on-device generation from `seed = hash64(gameId, level, GENERATOR_VERSION)`; attempt k uses `seed + k` (k = 0…63). CI pre-validates **all** seeds L1001–10000; failures પ્રથમ સફળ `k` ⇒ `seed_overrides.json` (app માં shipped). ⇒ device પર retry loop નહીં, 100% deterministic.
- **PRNG:** custom **xoshiro128\*\*** (Dart, 32-bit ops) — Dart `Random` નહીં (cross-version guarantee નથી). `GENERATOR_VERSION` બદલાય તો already-reached levels JSON cache માં freeze થાય.
- **Reverse construction:** empty board થી શરૂ કરીને paths એક પછી એક place કરો. દરેક નવો path એવી રીતે મૂકો કે તેનો exit lane **અત્યાર સુધી મૂકેલા paths થી ખાલી** રહે. ⇒ છેલ્લે મૂકેલો path પહેલો exit થઈ શકે; **solution order = placement નો reverse**. Static blockers માટે આ solvability guarantee આપે છે.
- **Stateful mechanics (C, T, K, X):** construction પછી **solver ફરજિયાત:** BFS/IDA* over state `(remaining paths, mechanic states, move parity/counters)`, node limit 2M (CI), depth ≤ 3×P. Unsolved / over-limit ⇒ reject. Solver output: optimal Move sequence ⇒ JSON `solution` (Hint અને par માટે).
- **Validator checks (CI):** solvable with 0 hearts & 0 boosters · D in band · no path initially locked forever · min cell ≥ 29 dp for Phase 1 grids · intro levels contain only intro mechanic + ≤ 1 earlier mechanic.
- **On-device Hint:** player state solution prefix પર હોય ⇒ next step; નહીં તો on-device solver (isolate, 50 ms budget, node limit 50k); fail ⇒ "Try Restart" toast (Hint consume નહીં).

### Level JSON (schema v3)
```json
{
  "schema": 3, "level": 141, "phase": 1, "seed": "0x00A1B2C3D4E5F607",
  "slot": "intro", "tag": "normal", "grid": [8, 8], "layers": 1, "hearts": 3,
  "paths": [
    {"id": "p1", "color": "green", "dir": "R", "body": [[3,2],[2,2],[1,2]], "layer": 0, "mods": {}}
  ],
  "mechanics": [
    {"id": "o1", "type": "M014", "cells": [[6,2]], "params": {"orient": "/"}, "hammerable": false}
  ],
  "goals": {"gems": 0},
  "par_moves": 9, "difficulty": 17.4,
  "solution": ["p1", "o2", "p3"]
}
```
`body[0]` = head. Coordinates `[x, y]`.

## 13. Shared Tech Stack (ચારેય games)
| Area | Decision |
|---|---|
| Framework | Flutter 3.x stable, Dart 3, Impeller |
| Rendering | `CustomPainter` + `Ticker`-driven game loop (**Flame નહીં**) |
| State | `flutter_bloc` (Riverpod નહીં) |
| Engine package | `packages/puzzle_core` (pure Dart): board model, rules, mechanics, solver, generator, PRNG — **ચારેય games share** |
| Persistence | `hive_ce` (typed adapters), save schema versioned |
| Ads / Consent | `google_mobile_ads` (UMP included) |
| IAP | `in_app_purchase` + Firebase Function receipt validation |
| Analytics / Crash / Config | `firebase_analytics`, `firebase_crashlytics`, `firebase_remote_config` |
| Leaderboards | `games_services` (Play Games / Game Center) |
| Audio | `audioplayers` (`AudioPool` for SFX) — full spec: [SOUND_EFFECTS_IMPLEMENTATION.md](./SOUND_EFFECTS_IMPLEMENTATION.md) |
| Logging / errors | `AppLogger` + Crashlytics + `firebase_performance` — full spec: [LOGGING_AND_ERROR_TRACKING.md](./LOGGING_AND_ERROR_TRACKING.md) |
| Haptics | Flutter `HapticFeedback` (third-party vibrate package નહીં) |
| Localization | `flutter_localizations` + ARB: English + ગુજરાતી + हिन्दी |
| Phase 2 backend | Firebase Auth (anonymous → Google/Apple link), Cloud Firestore, Cloud Functions |

**Performance budget:** 60 fps on low-tier Android (2 GB RAM, e.g. Redmi 9A class) with 30 paths; 120 fps on ProMotion iOS / 120 Hz Android flagships; frame raster p95 < 8 ms (mid-tier). Static board layer `PictureRecorder` cache; per-frame માત્ર moving path repaint; blur shadows pre-baked (per-frame `MaskFilter.blur` નહીં); `Color.withValues(alpha:)` (deprecated `withOpacity` નહીં). Full spec (device tiers, on-demand Ticker, startup order, memory, perf CI, QA PERF-01…26): [PERFORMANCE_OPTIMIZATION.md](./PERFORMANCE_OPTIMIZATION.md).

## 14. Save Data (Hive, schema v1)
`progress{highestCleared, stars[level], adReviveUsed[level]}`, `wallet{coins, boosters{hint,shield,hammer}}`, `streak{day, cycleSaverUsed, lastClaimDayKey, totalDays, trophyTier}`, `time{lastTrustedUtc, lastServerUtc}`, `ads{winsSinceInterstitial, lastFullscreenUtc, dailyShopAds, dailySpinAds, dayKey}`, `iap{vipActiveUntil, starterPackShown}`, `settings{sound, music, haptics, language, ageBand}`. Phase 2: `album`, `piggy`, `cosmetics`, `syncQueue`.

## 15. Analytics Events (minimum)
`level_start{level, attempt}`, `level_win{level, moves, hearts_lost, stars, duration_s}`, `level_fail{level, moves}`, `booster_use{type, level}`, `revive{type: ad|coins, level}`, `ad_show{format, placement}`, `iap_purchase{sku}`, `daily_clear{dayKey, modifier}`, `streak_update{day}`, `ftue_step{step}`.

## 16. Clarifications (edge cases, binding for all games)
1. **Booster before unlock:** Gift Box booster ઓ (દા.ત. L20 Hammer) inventory માં ઉમેરાય; button "Unlocks at L25" locked બતાવે.
2. **Daily modifier fallback:** જે weekday modifier નું mechanic unlock ન હોય (Thu Fog → M010, Fri Key → M004 / Game 4 માં M032 slot, Sun → M049) ⇒ **Classic**.
3. **FTUE:** L1–10 માં Hard tag નથી (L9 = Normal). પહેલું Hard = L19.
4. **Interstitial counter** L11 થી wins ગણે ⇒ પહેલું eligible = L15 win.
5. **Turntable (M013) / Rotor:** turntable cell પર path નો head હોય; turntable rotation ફક્ત `dir` બદલે. Tap target: head cell ⇒ turntable; બાકીના body cells ⇒ path. Validator: આવા path ની length ≥ 2.
6. **Hungry Path (M036):** lane clear પણ food ન હોય ⇒ **bump** (−1). Hint/solver આ જાણે.
7. **Linked groups (M011, M039, M048, M066):** group ના paths એકબીજાની lanes block કરે; group bump = **−1 heart total**.
8. **Hammer target:** fog-hidden કે ઉપરના layer થી ઢંકાયેલો path target ન થઈ શકે. Hammered path exit ગણાય પણ lane travel કરતો નથી (gems collect નહીં, cracked rock/bridge પર અસર નહીં).
9. **Coin Rush:** paths per tier T1 20 · T2 22 · T3 25 · T4 28 · T5/Phase 2 30. ફક્ત **first clear** પર trigger.
10. **Lucky Spin:** ~~first launch~~ → જુઓ #32 (L10).
11. **Daily revive key:** `adReviveUsed["daily:<dayKey>"]`. Daily difficulty = level `max(15, highestCleared − 10)` ના **x6 slot** params.
12. **Fragile Bridge (M042):** "crossing" = કોઈ path નો lane bridge cell પરથી પસાર થાય ⇒ crossing પૂર્ણ થાય પછી blocker બને; bridge પર પડેલો path હોય ત્યાં સુધી blocker બનતો નથી.
13. **Hard / Finale D targets** tier band ના max થી ઉપર જઈ શકે (x9 = high×1.1, Finale = high×1.2); validator આ allow કરે.
14. **Patrol (M025):** next cell occupied ⇒ તે Move માં wait. **Spreader (M027):** multiple cells હોય તો oldest cell પહેલાં grow.
15. **JSON `slot` vs `tag`:** `slot` = `intro|practice|breather|ramp|hard|milestone|finale` (block role). `tag` = `easy|normal|hard|finale` (coins). Mapping: breather ⇒ easy; intro/practice/ramp/milestone ⇒ normal; hard ⇒ hard; finale ⇒ finale.
16. **D formula `C`** = longest dependency chain ની **edges** ની સંખ્યા (બધા paths independent ⇒ 0).
17. **Tick order (દરેક Move):** (1) action resolve → (2) `moveCount += 1` → (3) counters tick: M007, M017, M031, M025, M027, M047, M041 (Phase 2: M057, M058, M063, M067, M068, M075, M079, M082, M090, M096 એ ક્રમમાં પછી) → (4) derived states (plates, beams, fog, cages, locks) → (5) heart loss (Shield પહેલાં absorb કરે) → (6) **win check** → (7) 0-heart check. Parity mechanics (M021, M090, M096) Move increment **પહેલાં** ની parity વાપરે.
18. **Hammerable defaults:** M001, M002, M016, M025, M027 (એક cell), broken M042, M053/M054 blocks. બાકીના gates, tiles, interactive cells, locks, edges, Guardians, M074 = not hammerable.
19. **Tap priority:** interactive mechanic cell (lever, turntable, switch, rotor) > તેના પર ઊભેલા path નો cell. Rotor/Turntable: path આંશિક રીતે અંદર હોય અથવા rotation પછી head પોતાના body તરફ હોય ⇒ locked tap. M023: બરાબર વચ્ચે tap ⇒ `body[0]` વાળો છેડો.
20. **Phase Finale (L500, L1000):** ક્રમ Phase Chest → Coin Rush → Phase Complete screen.
21. **Daily seed:** પઝલ એ જ local date + એ જ tier ના players માટે સરખી. Generation attempt `k = 0…63` (`seed + k`), પ્રથમ valid; 64 fail ⇒ fallback = Classic preset bundle (`daily_fallback.json`, 30 boards).
22. **Coin Rush:** app background ⇒ timer pause; "Skip" button (collected coins રહે). **Second Chance countdown** coin-confirm sheet ખુલ્લી હોય ત્યારે pause.
23. **Hammer finality:** Hammer action irreversible છે (Hammer ક્યારેય revert કે re-apply થતો નથી).
24. **Interstitial counter:** L11+ ની **બધી** numbered-level wins (replays સહિત) ગણાય.
25. **Coin Rush bumps:** heart loss નહીં, ફક્ત wobble.
26. **Streak trophy tiers:** Bronze → Silver → Gold → Platinum → Diamond (Diamond પછી Diamond રહે, counter વધે).
27. **Ad revive on Daily:** `dayKey` દીઠ 1 વાર (§16.11 key).
28. **Game 4 extension:** mechanic instance પર `tall: bool` (default false) અને path `layer` 0 = ground (ants), 1 = air (bees). `puzzle_core` blocking check: `blocks(mechanic, path) = mechanic.layerAffects(path.layer)`. બીજી games માં `tall` વપરાતું નથી.
29. **Frozen (M003) adjacency** layer-independent (કોઈપણ layer નો adjacent path ગણાય).
30. **Save schema v1 additions allowed:** `giftsClaimed`, `dailyBoardCache`, `sessionResume`, `monotonicRef`, `reduceMotion`, `starterPackUntil`, `lastFullIntroDayKey` ([SPLASH_AND_INSTANT_LAUNCH §5.3](./SPLASH_AND_INSTANT_LAUNCH.md#53-intro-plan)).

31. **Hammer exit triggers:** hammered path non-lane exit effects trigger કરે (key unlock, Frozen adjacency, Guardian HP, Spawner, Cage color count), lane effects નહીં (gems, food, Cracked Rock HP, bridge crossing). Gems બાકી હોય ત્યારે **છેલ્લા path** પર Hammer disabled.
32. **Lucky Spin unlock:** L10 clear પછી (FTUE ને disturb ન કરે). (§16.10 ને replace કરે છે.)
33. **Coin Rush path count:** §16.9 tier table જ (formula નહીં).
34. **M032 Two Layers (Games 1–3):** obstacles default બંને layers ને block કરે.
35. **Phase Finale composition:** Guardian + 9 other mechanic instances (= tier max 10).
36. **Timers clarification:** Second Chance 10-sec ring અને Coin Rush એ UI/bonus timers છે; puzzle state પર wall-clock timer નથી.
37. **Daily:** 2X Win offer નથી. Streak Saver એ દિવસની Daily clear **પહેલાં** accept કરવો પડે.
38. **Tech:** `cloud_functions` package (receipt validation, Phase 2 sync) §13 stack માં સામેલ.


## 17. Phase 2+ Clarifications (binding; derived from the first complete Phase 2 spec)
1. **Diagonals (M051):** path bodies 8-connected. Diagonal lane step blocked only if both side cells belong to one path's crossing diagonal link (validator rejects crossing links). Orthogonal-only devices (M006, M014, M018, M058, M086) ⇒ diagonal lane bump. Wide Path (M024) never diagonal.
2. **M052 Corner Bumper:** has H/V face defining bounce; orthogonal lanes treat it as blocker.
3. **Push blocks (M053–M055):** blocks never leave the board; "free" = empty cell or floor-type cell; diagonal push allowed. M054 slide stops on first non-ice cell. M055 plate held only by blocks.
4. **M056 Ramp:** lane continues on the other layer from the ramp cell.
5. **Parity / periodic (M057, M090, M096):** use Move count *before* the current Move (starts at 0).
6. **Recolor (M059, M094):** only if Move does not end in bump. Mixing primaries red/yellow/blue; other combos ⇒ brown.
7. **M060 Swap:** "same shape" = identical after translation, incl. `dir`.
8. **M062/M071/M095 quotas:** Hammered paths do **not** count for M062; they **do** count for M071/M095. Impossible quota ⇒ banner hint, not auto-fail.
9. **M063 Magnet:** pulls nearest path in line of sight in 4 dirs (tie order U, R, D, L); never pulls from distance 1.
10. **M065 Hidden Key:** loose item; first successful lane passing it after reveal collects it.
11. **M067:** max 1 pass counted per Move. **M068:** trail blockers only on lane cells beyond original body, last next 2 Moves.
12. **M070:** rotates every path incl. hidden ones. **M072:** colors not in pattern unrestricted; Hammer may target only next-in-pattern color.
13. **M073 Bubble:** pop costs a Move, no heart, no Shield charge.
14. **M074:** linked lever is one-shot. **M075:** grows from oldest fog cell; cleared cells never regrow.
15. **M076:** portal network one-way cycle; beams ignore portals. **M077:** hammered bomb doesn't blast; no chain blasts.
16. **M079:** square boards only. **M080:** twin-key paths not Hammer targets.
17. **M081 "moved":** exit, segment exit or relocation (not bump/push).
18. **M082:** path must lie fully on belt; blocks not carried.
19. **Beams (M084–M089):** lanes checked against beam state *before* the Move; beams recomputed in tick step (4). Prism blocks lanes.
20. **M087:** pad re-sticks a head that ends a Move on it. **M088:** mine linked to one specific path; not hammerable.
21. **M091:** partial path inside ⇒ locked tap. **M092:** each segment keeps `dir`; exit effects fire on last segment. **M093:** length even ≥ 4; back half's head = original tail facing opposite.
22. **M097:** whole chain clears in one Move; only first domino hammerable. **M098:** moves as one shape; waits if any target cell occupied. **M099:** opens permanently when all keys + receiver lit.
23. **Zoom/pan:** max zoom ⇒ 48 dp cells; 18 dp touch slop; "Fit" button; no double-tap zoom.
24. **Phase 3–20 bands (plateau):** દરેક Phase 3–20 નો D band **60–76** (fixed plateau; difficulty નવા mechanics/systems થી આવે, numbers થી નહીં), Hard/Finale multipliers §16.13. Grid 12×12–14×14 per board/floor (zoom). Mechanic IDs: Phase p base mechanics `M((p−1)·50+1)…+4` (Phase 3 = M101–M104). Slot map §17.38.
25. **Daily silhouettes** ⇒ separate "Daily" album page (collection only, no coins); volumes stay milestone-based.
26. **LiveOps defaults (Remote Config):** Album volume rewards 300/400/600/800/1,000 coins + 1 cosmetic (retroactive incl. rewards). Star Race: join closes Sun 12:00; cohort closes after 2 h, ghosts labelled; server plausibility ≥ 250 ms per Move, ≥ 15 s between reports; top-3 replay check. Piggy: accrual from L31, break allowed from 350 stored coins. Cosmetics total 800–4,000 each; VIP skin only while VIP active.
27. **Sync:** accounts never merged on link; negative coin balance after cross-device spend shows 0 + "Coins owed" (repaid from future earnings); under-13 ⇒ anonymous sync only.
28. **Phase 2 perf:** 60 fps on low tier with 40 paths; on-device Hint solver node limit 500k for Phase 2 boards (50 ms budget still applies, fallback "Try Restart").
29. **Push block at open edge (M053/M054):** block pushed across an **open** board edge falls off and is removed (counts nothing). Walled/closed edge or blocked cell behind ⇒ bump. (Without this the pusher's lane would stay blocked forever.)
30. **Bumped Moves change nothing lane-based:** paint, mixing, seesaw flips, key/item pickup, floor wear, trails, quotas, Mimic updates happen only when the path exits or relocates.
31. **Soft-lock sheet:** when solver detects no winning sequence (without boosters) ⇒ "Stuck" sheet offering Restart; no heart loss, no fail screen; logged `E-GAME-004`.
32. **M098** ticks in the M025 slot of the tick order. **M099** has a built-in receiver; its intro level needs only M084 as the earlier mechanic.
33. **M068** trail created on Move n blocks during Moves n+1 and n+2.
34. **Phase 3+:** in each phase, block 50's x1 is a **review level** (49 content slots for 50 blocks). Per-phase `phase_N_meta.bin` ships per level: attempt `k`, par, D, CRC, solution ⇒ device Hint never needs the CI-size solver. Live tuning may switch only between ≤ 3 pre-validated generator profiles.
35. **hash64** = two independent 32-bit FNV-1a lanes (different offset bases) concatenated ⇒ identical on Dart VM and JS tooling.
36. **Account link conflict:** if the sign-in already has a cloud save, player chooses **which save to keep** (device or cloud); no automatic merge.
37. **Save boxes (Phase 2):** `race`, `account` added to §14 list (with `album`, `piggy`, `cosmetics`, `syncQueue`). `ageBand` is device-local, never synced.
38. **Phase 3+ slot map:** block 1 x1 = signature system intro; x1 of blocks 2, 14, 26, 38 = new base mechanics; x1 of remaining blocks 3–49 (excluding 14, 26, 38) = 45 variants; block 50 x1 = review/"Mastery Mix" level.
39. **Rotation into own body (M013, M070, M079, M081, M093):** a path whose new `dir` points into its own body is "tangled" ⇒ locked tap until changed.
40. **M072 Color Sequence:** colors with no remaining paths are skipped (no deadlock).

---
*Changing any value here ⇒ update all four game folders in the same commit.*

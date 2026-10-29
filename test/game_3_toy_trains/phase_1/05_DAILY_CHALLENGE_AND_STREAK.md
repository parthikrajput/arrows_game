# 05 · Daily Timetable Run & Express Streak — Toy Trains: Wooden Railway Puzzle
> હેતુ: Daily Challenge ("Daily Timetable Run") ના rules, weekday modifiers, seed, difficulty, silhouettes, 7-day Express Streak ladder, miss/saver rules, day key + anti-cheat, offline behaviour, leaderboards અને edge cases.

**Related docs:** [Shared Core Standard §8](../../SHARED_CORE_STANDARD.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) · [04 Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md) · [06 UI/UX Screens](./06_UI_UX_SCREENS.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Daily Timetable Run — Rules

| Rule | Value |
|---|---|
| Unlock | **L15** clear પછી (Home પર "Daily" ticket button દેખાય) |
| Puzzles per day | 1 |
| Seed | `hash(gameId = "toy_trains", dayKey)` ⇒ દુનિયાભરમાં એ જ local date પર એ જ puzzle (offline પણ) |
| Difficulty | Level `max(15, highestClearedLevel − 10)` ના block નો **x6 (ramp) slot** generator params (એ level ના tier: grid, trains, D band; standard §16.11) |
| Mechanics | **માત્ર unlocked mechanics** (intro level ≤ highestClearedLevel) |
| Hearts | 3 (Wednesday: 1) + standard Second Chance (Heart Refill 120 coins ×2/attempt; ad revive **`dayKey` દીઠ 1 વાર**, key `adReviveUsed["daily:<dayKey>"]`, standard §16.11/§16.27) |
| Boosters | Allowed (standard caps) |
| Retry | Unlimited, free |
| Reward | **+100 coins** + 1 Express Streak day — **દિવસ દીઠ એક વાર** (first clear) |
| Stars | Standard star rules; Tuesday Par modifier lowers ★ |
| Ads | Interstitial **ક્યારેય નહીં** (Daily પછી). 2X Win button નથી (Daily reward fixed +100; 2X માત્ર numbered-level clear coins પર) |
| Analytics | `daily_clear{dayKey, modifier}` |

Daily generator = Phase 1 offline generator ની same Dart code (`packages/puzzle_core`), on-device, solver-validated (attempt k = 0…63 seeds; first solvable). 64 attempts fail ⇒ fallback Classic preset bundle (`daily_fallback.json`, 30 boards; `E-LVL-003`, standard §16.21). Same seed + same `highestCleared` band ⇒ same board.

> નોંધ: બે players નો `highestCleared` tier અલગ હોય તો board અલગ બને (difficulty personal). "દુનિયાભરમાં એ જ puzzle" = એ જ tier ના players માટે.

## 2. Weekday Modifiers (Player બંને ભાગ જોઈ શકે: modifier card + board)

| Day | Modifier | Train-theme card |
|---|---|---|
| Mon | **Classic** — કોઈ modifier નહીં | "Regular Service" |
| Tue | **Par Moves** — par (`par_moves`) થી વધુ Moves ⇒ ★ એક ઓછો (fail નહીં) | "On-Time Run": HUD પર "Moves 7 / Par 9" |
| Wed | **One Heart** — 1 heart, revive allowed | "Fragile Cargo" |
| Thu | **Fog Day** — M010 Steam Cloud વધારે (unlocked હોય તો; નહીં તો Classic) | "Steam Day" |
| Fri | **Key Hunt** — M004/M043 Ticket barriers વધારે (unlocked હોય તો; નહીં તો Classic) | "Ticket Inspection" |
| Sat | **Big Board** — player tier નો max grid size | "Big Junction" |
| Sun | **Mini Boss** — M049 Clock Tower Guardian (unlocked હોય તો; નહીં તો **Classic**, standard §16.2) | "Clock Tower Sunday" |

Fallback rule (standard §16.2): જે weekday modifier નું mechanic unlocked ન હોય (Thu → M010, Fri → M004, Sun → M049) ⇒ **Classic**. L15 player (M001 only unlocked): Thu/Fri/Sun fall back to Classic because M010 (L101) / M004 (L41) / M049 (L491) are not yet unlocked.

## 3. Board Silhouettes (Mon–Sun)

Daily board ની trains 7 silhouettes (weekday મુજબ) માંથી એક shape માં ગોઠવાય. (Silhouettes Phase 2 sticker album માં વપરાશે.)

| Day | Silhouette |
|---|---|
| Mon | Steam Engine (side view) |
| Tue | Semaphore Signal |
| Wed | Arched Bridge |
| Thu | Station Clock |
| Fri | Golden Ticket |
| Sat | Water Tower |
| Sun | Roundhouse |

Silhouette = cell mask (`assets/daily/silhouettes.json`); generator places train cars only inside mask; outside cells are decorative tabletop.

## 4. Express Streak (Daily clear થી આગળ વધે — માત્ર login નહીં)

| Day | Reward |
|---|---|
| 1 | 50 coins |
| 2 | 75 coins |
| 3 | 100 coins + 1 Green Signal Hint |
| 4 | 125 coins + 2 Reverse Gear Undo |
| 5 | 150 coins + 1 Cowcatcher Shield |
| 6 | 200 coins + 1 Track Crane |
| 7 | **450 coins + 1 Green Signal Hint + 1 Cowcatcher Shield + 1 Track Crane + Streak Trophy** |

Week total: 1,150 coins + 2 Hint + 2 Undo + 2 Shield + 2 Hammer + trophy.

- **Trophy tiers (standard §16.26):** દરેક completed 7-day cycle પર trophy level વધે: **Bronze → Silver → Gold → Platinum → Diamond** Engine trophy. Diamond પછી Diamond જ રહે (cycle counter વધતો રહે).
- **After Day 7:** નવો cycle Day 1 થી; `totalStreakDays` ચાલુ રહે (leaderboard). `cycleSaverUsed` reset.
- Streak reward = Daily +100 ઉપરાંત (Daily clear પર એક સાથે grant).

## 5. Miss & Streak Saver

| Situation | Result |
|---|---|
| Consecutive days Daily clear | Streak +1 |
| **Exactly 1 day missed** | પાછા આવો ત્યારે **Streak Saver** offer: 1 rewarded ad **અથવા** 200 coins. **7-day cycle દીઠ 1 વાર.** Saver વાપર્યું ⇒ missed day નો reward **મળતો નથી**, streak ત્યાંથી ચાલુ (આજે clear ⇒ next day number) |
| 1 day missed, saver already used this cycle | Day 1 reset |
| Saver declined | Day 1 reset (આજનો clear = Day 1) |
| **2+ days missed** | Day 1 reset, Saver offer **નહીં** |

Saver example: Day 4 cleared Mon, Tue missed, Wed open app ⇒ Saver ⇒ Wed clear = Day 5 (Tue reward forfeited).

**Saver timing (standard §16.37):** Saver એ દિવસની Daily clear **પહેલાં** accept કરવો પડે. Saver accept કર્યા વગર આજનું Daily clear કર્યું ⇒ offer બંધ, આજનો clear = Day 1.

## 6. Day Key & Anti-Cheat

- `dayKey` = device **local date** `YYYY-MM-DD` (local midnight reset).
- Save: `lastClaimDayKey`, `lastTrustedUtc`, `lastServerUtc` (online હોય ત્યારે Firebase / HTTP `Date` header).
- Device clock `< lastTrustedUtc − 2h` ⇒ **Time-travel lock:** Daily claim, Streak, Lucky Turntable બંધ જ્યાં સુધી clock `lastTrustedUtc` થી આગળ ન જાય. Banner: "Your device clock looks off. Daily rewards will return when the clock is correct."
- એક `dayKey` માટે claim **એક જ વાર**; બે claims વચ્ચે **min 20 h real elapsed** (server time અથવા monotonic uptime).
- Timezone change allowed, પણ ઉપરના rules ⇒ double-claim નહીં.
- Monotonic: store `uptimeAtClaim` + `bootId`; reboot ⇒ fall back to server time when online, else wall clock with `lastTrustedUtc` guard.

## 7. Offline Behaviour

- Daily રમી શકાય (seed local). Reward local grant.
- Online થાય ત્યારે server time થી verify: mismatch (claim time > server time + 2 h, અથવા 20 h rule broken) ⇒ **streak freeze** (streak counter આગળ ન વધે જ્યાં સુધી valid claim), **coins revoke નહીં**.
- Rewarded-ad options (Saver ad, extra spin) offline ⇒ disabled; Saver coins option ચાલુ.

## 8. Leaderboards (Phase 1)

`games_services` (Google Play Games / Apple Game Center):

| Leaderboard | Value |
|---|---|
| Highest Level | `highestCleared` |
| Total Stars | sum of `stars[level]` |
| Total Streak Days | `totalStreakDays` |

Friends = platform friends. Custom backend નહીં. Local progress hackable ⇒ leaderboard માત્ર fun; rewards rank પર આધારિત નથી. Sign-in optional (Leaderboards screen પર prompt).

## 9. Edge Cases

| Case | Expected |
|---|---|
| Daily played across midnight (start 23:58, clear 00:03) | Clear credited to the dayKey at **start** of the attempt; new day's puzzle available after |
| Clear twice same day | 2nd clear: no coins, no streak; "Already claimed today" |
| Timezone travel east → same dayKey twice? | 20 h rule blocks 2nd claim; puzzle playable, reward deferred |
| Clock moved forward 3 days | Claim allowed once (wall clock ahead), next online check: server mismatch ⇒ streak freeze |
| Clock moved back > 2 h | Time-travel lock (Daily claim, Streak, Spin) |
| `highestCleared` changes mid-day | Today's board fixed at first open (cache `dailyBoard{dayKey}`) |
| L15 not cleared | Daily button locked with "Clear Level 15" |
| Wednesday 1 heart + Shield | Shield absorbs as usual |
| Sunday, Guardian not unlocked | Classic fallback (§16.2) |
| App reinstall | Streak lost unless Phase 2 Cloud Sync; installId new ⇒ spin seed changes |
| Saver offer while offline | Ad option disabled, 200-coin option enabled |
| Day 7 claimed | Trophy tier +1, cycle resets to Day 1 next day |

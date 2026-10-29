# 05 — Daily Challenge & 7-Day Streak ("Daily Stitch")
> Purpose: Daily Challenge ના rules, weekday modifiers, seed, difficulty, themed silhouettes, 7-day streak ladder, miss/Darning Patch (Streak Saver) rules, day key + anti-cheat, offline behaviour, leaderboards અને edge cases.

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) (§8) · [./README.md](./README.md) · [./04_BOOSTERS_COINS_SHOP.md](./04_BOOSTERS_COINS_SHOP.md) · [./06_UI_UX_SCREENS.md](./06_UI_UX_SCREENS.md) · [./07_FRONTEND_IMPLEMENTATION_AND_QA.md](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Overview

| Item | Value |
|---|---|
| Themed name | **Daily Stitch** (Daily Challenge) |
| Unlock | **L15 clear** પછી |
| Puzzles per day | 1 |
| Seed | `hash(gameId, dayKey)`, `gameId = "yarn_unravel"` ⇒ દુનિયાભરમાં એ જ local date પર એ જ puzzle (offline પણ) |
| Reward | **+100 Coins** + streak day (દિવસ દીઠ એક વાર) |
| Retry | Unlimited; reward એક જ વાર |
| Boosters | Allowed (caps standard મુજબ) |
| Hearts / revive | 3 hearts (Wed સિવાય). Ad revive **`dayKey` દીઠ 1 વાર** (key `adReviveUsed["daily:<dayKey>"]`, §16.11/§16.27); Heart Refill normal rules (max 2/attempt) |
| 2X Win | Daily પર **offer નથી** (§16.37) |
| Stars | Daily માં stars દેખાય (Tue Par Moves rule), પણ Total Stars leaderboard માં ગણાય નહીં |
| Ads after | Interstitial **ક્યારેય નહીં** (Daily પછી) |

## 2. Difficulty Scaling

- Generator params = level `max(15, highestCleared − 10)` ના tier/slot params (x6 "Ramp" slot band).
- **માત્ર unlocked mechanics** (intro level ≤ `highestCleared`) વપરાય.
- Lamplight Evening (M040) Daily માં excluded (visual-only; readability).
- Same `dayKey` ⇒ same seed; પરંતુ players ના `highestCleared` અલગ હોય તો board અલગ બને (seed એ જ, params અલગ). Leaderboard Daily score પર નથી, એટલે fairness issue નથી.
- Generation on-device: `tools/levelgen` નું same Dart generator `puzzle_core` માં; attempt `k = 0…63` (`seed + k`) — પહેલો valid board (solver ok, D in band). 64 fail ⇒ fallback: bundled `daily_fallback.json` (30 boards) માંથી `dayIndex mod 30`.

## 3. Weekday Modifiers

Player ને Daily card પર weekday + modifier બંને દેખાય. Fallback rule (standard §16.2): જે modifier નું mechanic unlock ન હોય ⇒ **Classic** (Thu, Fri, Sun ત્રણેય).

| Day | Modifier (standard) | Yarn flavour text | Fallback if mechanic locked |
|---|---|---|---|
| Mon | **Classic** | "Plain Knit Monday" | — |
| Tue | **Par Moves:** par (`par_moves`) થી વધુ Moves ⇒ ★ ઓછો (fail નહીં) | "Tidy Tuesday — finish in N pulls" | — |
| Wed | **One Heart:** 1 heart, revive allowed | "Careful Wednesday" | — |
| Thu | **Fog Day:** M010 Wool Fluff વધારે | "Fluffy Thursday" | M010 locked (`highestCleared < 101`) ⇒ Classic |
| Fri | **Key Hunt:** Charm & Clasp (keys/locks) વધારે | "Charm Friday" | M004 locked (`< 41`) ⇒ Classic |
| Sat | **Big Board:** player tier ના max grid | "Big Quilt Saturday" | — |
| Sun | **Mini Boss:** Grand Pincushion Guardian (M049) જો unlocked | "Pincushion Sunday" | M049 locked (`< 491`) ⇒ **Classic** (standard §16.2) |

Tue stars: ★★★ = moves ≤ par **અને** hearts rule મુજબ ★★★; par થી વધુ ⇒ hearts-based stars − 1 (min ★).

Wed: hearts = 1; Heart Refill/ad revive +1 (max hearts 1 → revive brings back to 1). Shield works normally.

## 4. Daily Silhouettes (themed shapes Mon–Sun)

Daily board ના threads 7 silhouettes માંથી એક shape માં ગોઠવાય (cells outside silhouette = empty decoration, lanes ત્યાંથી પસાર થઈ શકે). Clear થાય ત્યારે silhouette knitted-patch તરીકે reveal (Phase 2 Sticker Album માં સંગ્રહ).

| Day | Silhouette | Art reveal |
|---|---|---|
| Mon | Mitten | red knitted mitten patch |
| Tue | Teacup | teacup with cozy |
| Wed | Sock | striped sock |
| Thu | Cloud-shaped Scarf | scarf with fluff |
| Fri | Heart Locket | charm-heart |
| Sat | Sweater | cable-knit sweater |
| Sun | Kitten (Purl) | Purl with yarn ball |

## 5. 7-Day Streak

Streak **Daily Stitch clear** થી આગળ વધે (માત્ર login થી નહીં).

| Streak day | Reward |
|---|---|
| 1 | 50 Coins |
| 2 | 75 Coins |
| 3 | 100 Coins + 1 Needle Glow Hint |
| 4 | 125 Coins + 2 Seam Ripper Undo |
| 5 | 150 Coins + 1 Thimble Shield |
| 6 | 200 Coins + 1 Golden Scissors |
| 7 | **450 Coins + 1 Needle Glow Hint + 1 Thimble Shield + 1 Golden Scissors + Thimble Trophy** |

Week total: 1,150 Coins (+ boosters). Daily clear +100 એ streak reward થી અલગ (દરરોજ).

**Thimble Trophy tiers (standard §16.26):** દરેક પૂરા થયેલા 7-day cycle પર trophy level વધે: **Bronze → Silver → Gold → Platinum → Diamond**. Diamond પછી Diamond જ રહે, cycle counter વધે (badge પર "×N").

### 5.1 After Day 7
Day 7 claim ⇒ next clear = નવો cycle **Day 1**; `totalStreakDays` counter ચાલુ (leaderboard). `cycleSaverUsed` reset to false on new cycle.

### 5.2 Miss rules
| Situation | Result |
|---|---|
| Daily clear સળંગ દિવસે | streak +1 |
| **Exactly 1 day miss** | પાછા આવો ત્યારે **Darning Patch** (Streak Saver) offer: 1 rewarded ad **અથવા** 200 Coins. **7-day cycle દીઠ 1 વાર.** Saver ⇒ missed day reward **મળતા નથી**, streak ત્યાંથી ચાલુ (આજે clear ⇒ next day number). Saver એ દિવસની Daily clear **પહેલાં** accept કરવો પડે (§16.37); offer Daily card ખોલતાં જ બતાવાય |
| 1 day miss + saver already used this cycle | Day 1 reset |
| Saver decline / આજની Daily પહેલાં clear કરી દીધી | Day 1 reset (આજનો clear Day 1); clear પછી Saver offer નહીં |
| **2+ days miss** | Day 1 reset, Saver offer નહીં |

Example: Day 3 claimed Monday, Tuesday missed, Wednesday open ⇒ Darning Patch offer ⇒ accept ⇒ Wednesday clear = Day 4 reward.

## 6. Day Key

- `dayKey` = device **local date** `YYYY-MM-DD` (local midnight reset).
- Save: `lastClaimDayKey`, `lastTrustedUtc`, `lastServerUtc` (online હોય ત્યારે Firebase / HTTP `Date` header થી).
- Daily Stitch, Spinning Wheel free spin, Shop free-Coins counter — બધાં આ જ `dayKey` વાપરે.

## 7. Anti-Cheat (Time-travel lock)

| Rule | Behaviour |
|---|---|
| Device clock < `lastTrustedUtc − 2h` | **Time-travel lock:** Daily claim, Streak, Spin બંધ જ્યાં સુધી clock `lastTrustedUtc` થી આગળ ન જાય. Banner: "Your device clock looks off. Daily rewards resume when it's corrected." |
| Claim per `dayKey` | એક જ વાર |
| બે claims વચ્ચે | **min 20 h real elapsed** (server time, અથવા offline હોય તો monotonic uptime + last server anchor) |
| Timezone change | Allowed; ઉપરના rules ⇒ double-claim નહીં |
| Reinstall | Local save ગયું ⇒ streak lost (Phase 1 cloud sync નથી) |

`lastTrustedUtc` update: online server time મળે ત્યારે, અથવા device clock `lastTrustedUtc` થી આગળ હોય ત્યારે `max(lastTrustedUtc, deviceUtc)`.

## 8. Offline Behaviour

- Daily Stitch offline રમી શકાય (seed local).
- Reward local grant થાય. Online થાય ત્યારે server time થી verify: mismatch (claim time > server time + 2 h, અથવા 20 h rule broken) ⇒ **streak freeze** (streak આગળ ન વધે જ્યાં સુધી next valid day), **Coins revoke નહીં**.
- Darning Patch ad option offline ⇒ disabled ("Ad unavailable"), 200 Coins option ચાલુ.

## 9. Leaderboards (Phase 1)

`games_services` (Google Play Games Services / Apple Game Center):

| Leaderboard | Value submitted | When |
|---|---|---|
| Highest Level | `highestCleared` | each new first clear |
| Total Stars | sum of best stars L1–500 | on star improve |
| Total Streak Days | `totalStreakDays` | each streak update |

Friends = platform friends. Custom backend નહીં. Local progress hackable ⇒ leaderboard માત્ર fun; કોઈ reward rank પર આધારિત નથી. Sign-in failure ⇒ leaderboard button shows "Sign in to Play Games" — game blocked નહીં.

## 10. Edge Cases

| # | Case | Expected |
|---|---|---|
| D1 | Player clears Daily at 23:59, next Daily at 00:01 | dayKey અલગ, પણ 20 h rule ⇒ second claim locked until 20 h elapsed; card: "Next reward in hh:mm" (Daily playable, reward pending) |
| D2 | Clock set back 1 day | Time-travel lock |
| D3 | Clock set forward 1 day, claim, then reset | forward claim ⇒ online verify mismatch ⇒ streak freeze; reset back ⇒ time-travel lock until real time passes `lastTrustedUtc` |
| D4 | Fly India → US (timezone −10.5 h) | dayKey may repeat; one claim per dayKey + 20 h rule ⇒ no double |
| D5 | Daily failed (hearts 0, no revive) | Retry unlimited, no streak change. Ad revive already used for this `dayKey` ⇒ only Heart Refill offered |
| D6 | Daily cleared, replay | allowed, no reward |
| D7 | Saver offered, app closed | offer persists for that dayKey (until that day's clear); next day = 2 days missed ⇒ reset |
| D8 | Saver with ad, ad fails mid-way | no grant, offer stays |
| D9 | Day 7 claim during time-travel lock | blocked until lock clears |
| D10 | `highestCleared` = 15 on Sunday | Mini Boss locked ⇒ Classic |
| D11 | Generator fails 64 seeds | fallback board `dayIndex mod 30` |
| D12 | Streak day 4 reward when booster inventory huge | no cap on inventory; grant normally |
| D13 | VIP active | Daily same; no interstitial anyway |
| D14 | Under-13 band | Darning Patch rewarded ad non-personalized; otherwise same |

## 11. Analytics
`daily_clear{dayKey, modifier}`, `streak_update{day}`, plus `daily_start{dayKey, modifier}`, `streak_saver{method: ad|coins}`, `time_travel_lock{deltaH}` (game-specific extras).

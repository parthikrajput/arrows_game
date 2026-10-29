# 05 — Daily Jungle Puzzle & 7-Day Jungle Streak
> Daily Challenge ના rules, weekday modifiers, seed, difficulty, silhouettes, streak ladder, miss/saver rules, day key & anti-cheat, offline behaviour, leaderboards અને edge cases.

**Related docs:** [Phase 1 index](./README.md) · [Shared Core Standard §8](../../SHARED_CORE_STANDARD.md) · [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) · [04 Boosters & Shop](./04_BOOSTERS_COINS_SHOP.md) · [06 Screens](./06_UI_UX_SCREENS.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Overview
| Item | Value |
|---|---|
| Name | Daily Jungle Puzzle (Daily Challenge) |
| Unlock | **L15 clear** પછી |
| Frequency | Local date (`dayKey`) દીઠ 1 puzzle, local midnight reset |
| Reward | **+100 coins** + streak day reward (એક વાર/day) |
| Retry | Unlimited; reward એક વાર |
| Boosters | Allowed (normal caps) |
| Hearts | 3 (Wednesday 1) + normal Second Chance |
| Interstitial | Daily પછી **ક્યારેય નહીં**; Daily win `winsSinceInterstitial` માં ગણાતી નથી |
| Streak | **Daily clear** થી આગળ વધે (માત્ર login થી નહીં) |

## 2. Daily Rules
1. Home પર Daily card: today's silhouette preview, modifier chip, streak day, reward.
2. Play ⇒ core rules ([01](./01_GAME_CONCEPT_AND_RULES.md)) + today's modifier.
3. Win ⇒ Daily Result: +100 coins (first clear of `dayKey`), streak advance + day reward, calendar stamp. 2X Win button **નથી** (Daily clear coins fixed).
4. Fail ⇒ Level Failed-style screen: Retry / Home (no penalty).
5. Revive: rewarded revive **dayKey દીઠ 1** (`progress.adReviveUsed["daily:<dayKey>"]`, standard §16.11/§16.27), Heart Berry Refill attempt દીઠ max 2.
6. Already claimed today ⇒ card "Come back tomorrow" + next reset countdown (UI clock only, puzzle timer નથી); replay allowed (no reward).
7. Daily stars (★ rules standard §4 + Tuesday par) calendar માં બતાવાય; Total Stars leaderboard માં ગણાતા **નથી** (માત્ર numbered levels).

## 3. Weekday Modifiers
Card પર day name + modifier chip + 1-line explanation (player બંને ભાગ જુએ).

| Day | Modifier | Rule | Fallback (mechanic locked હોય તો) |
|---|---|---|---|
| Mon | **Classic** | કોઈ modifier નહીં | — |
| Tue | **Par Moves** | `par_moves` થી વધુ Moves ⇒ ★ એક ઓછો (min ★). Fail નહીં. HUD `Moves 7 / par 9` | — |
| Wed | **One Heart** | 1 heart; revive allowed (ad 1/day, refill ×2) | — |
| Thu | **Fog Day** | M010 Jungle Mist instances વધારે (tier max obstacle instances ના 50% mist) | M010 locked (highest < 101) ⇒ Classic |
| Fri | **Key Hunt** | M004 Bamboo Cage & Key / M043 Big Knot Cage વધારે (50% instances) | M004 locked (highest < 41) ⇒ Classic |
| Sat | **Big Board** | Player tier નો max grid size | — |
| Sun | **Mini Boss** | M049 Grumpy Mongoose (unlocked હોય તો) | M049 locked ⇒ **Classic** |

> Fallback rule standard §16.2 મુજબ: જે modifier નું mechanic unlock ન હોય ⇒ **Classic** (Thu, Fri, Sun ત્રણેય).

## 4. Seed, Generation & Difficulty Scaling
- `seed = hash64(gameId, dayKey)`, `gameId = "snakes_slither"`, `hash64` = two independent 32-bit FNV-1a lanes concatenated (standard §17.35) ⇒ `xoshiro128**` PRNG (Dart `Random` નહીં). Generation attempt `k = 0…63` (`seed + k`), પ્રથમ valid board (§16.21).
- **Difficulty:** generator params of level `max(15, highestCleared − 10)` (એ level ના tier + sub-band, [02 §7](./02_LEVEL_PROGRESSION_0001_0500.md#7-block-table--levels-1500-all-50-blocks)). Slot target = એ level ના block નો **x6 slot** params (standard §16.11).
- **Mechanics pool:** માત્ર unlocked mechanics (intro level ≤ `highestCleared`).
- Same `dayKey` + same params-level ⇒ દુનિયાભરમાં identical board (offline પણ). અલગ progress ⇒ અલગ params ⇒ અલગ board.
- Generated board આખો દિવસ cache (`daily.cachedBoard{dayKey, paramsLevel}`); દિવસ દરમિયાન player progress વધે તો પણ board બદલાતો નથી.
- On-device generation (isolate). Phase 1 generator CI માં 3 years of dayKeys × દરેક 10th params-level pre-validate; fail seeds ⇒ `daily_seed_overrides.json` (`k` attempt index) app માં shipped ⇒ device પર retry loop નહીં.

## 5. Silhouettes (Mon–Sun)
Snakes board પર day ના shape માં ગોઠવાય (mask cells ની બહાર snakes નથી; lanes normal rules). Phase 2 Sticker Album માં collect થાય.

| Day | Silhouette | Mask idea |
|---|---|---|
| Mon | 🦋 Butterfly | Two wings, symmetric |
| Tue | 🍃 Leaf | Diagonal leaf with stem |
| Wed | 🐢 Turtle | Round shell + head |
| Thu | ☁️ Cloud | Puffy cloud (Fog Day match) |
| Fri | 🥚 Snake Egg | Oval |
| Sat | 🥭 Mango | Big oval with leaf (Big Board) |
| Sun | ☀️ Sun | Circle + rays (Mini Boss center) |

Mask fill ≥ 60% board cells; validator ensures shape readable at 11×11.

## 6. 7-Day Jungle Streak Ladder
| Day | Reward |
|---|---|
| 1 | 50 coins |
| 2 | 75 coins |
| 3 | 100 coins + 1 Glow Firefly Hint |
| 4 | 150 coins |
| 5 | 150 coins + 1 Safety Shell Shield |
| 6 | 200 coins + 1 Magic Stone Hammer |
| 7 | **450 coins + 1 Hint + 1 Shield + 1 Hammer + Golden Coil Trophy** |

- Week total = **1,150 coins** + boosters (Daily clear +100 × 7 અલગ).
- Trophy tier દરેક પૂરા 7-day cycle પર વધે: Bronze → Silver → Gold → Platinum → Diamond (Diamond પછી Diamond જ રહે, cycle counter વધે; standard §16.26). `streak.trophyTier`.
- **Day 7 પછી** ⇒ નવો cycle Day 1; `totalStreakDays` ચાલુ (leaderboard).
- Streak reward Daily clear સાથે જ grant (અલગ claim button નહીં); calendar stamp animation.
- Locked booster reward (દા.ત. Hammer, player < L25) ⇒ inventory માં જમા.

## 7. Miss & Streak Saver Rules
| Situation | Result |
|---|---|
| Yesterday cleared | Today clear ⇒ next day |
| **Exactly 1 day missed** | પાછા આવો ત્યારે **Streak Saver Leaf** offer: 1 rewarded ad **અથવા** 200 coins. **7-day cycle દીઠ 1 વાર** (`streak.cycleSaverUsed`) |
| Saver accepted | Streak ત્યાંથી ચાલુ (missed day નો reward **નહીં**; today clear ⇒ next day number) |
| Saver declined / not affordable / already used this cycle | Today clear ⇒ **Day 1** |
| 2+ days missed | **Day 1 reset**, Saver offer નહીં |

- Offer: today ના પહેલા app open પર popup + Daily card પર "Save streak" button આખો `dayKey`. Today's Daily clear **પહેલાં** accept કરવું પડે; Saver વગર clear ⇒ Day 1.
- Saver Move/heart સાથે સંબંધ નથી; માત્ર streak.
- Example: Day 4 clear Mon, Tue miss, Wed open ⇒ Saver ⇒ Wed clear = Day 5 reward (150 coins + 1 Shield). Tuesday માટે કોઈ reward નથી મળતો.

```dart
enum StreakGap { sameDay, consecutive, missedOne, missedMany }

StreakGap gapFor(String lastClaimDayKey, String todayKey) {
  final last = DateTime.parse(lastClaimDayKey);
  final today = DateTime.parse(todayKey);
  final days = DateTime.utc(today.year, today.month, today.day)
      .difference(DateTime.utc(last.year, last.month, last.day))
      .inDays;
  if (days <= 0) return StreakGap.sameDay;
  if (days == 1) return StreakGap.consecutive;
  if (days == 2) return StreakGap.missedOne;
  return StreakGap.missedMany;
}
```

## 8. Day Key & Anti-Cheat
| Rule | Detail |
|---|---|
| `dayKey` | Device **local date** `YYYY-MM-DD` (local midnight reset) |
| Saved | `streak.lastClaimDayKey`, `time.lastTrustedUtc`, `time.lastServerUtc` |
| Trusted time | Online હોય ત્યારે Firebase/HTTP `Date` header ⇒ `lastServerUtc`; `lastTrustedUtc = max(lastTrustedUtc, now)` |
| **Time-travel lock** | Device clock < `lastTrustedUtc − 2h` ⇒ Daily claim, Streak, Lucky Lily Wheel બંધ જ્યાં સુધી clock `lastTrustedUtc` થી આગળ ન જાય. UI: "Your clock seems off — jungle time will return soon" |
| One claim per key | એક `dayKey` માટે claim એક જ વાર |
| **Min 20 h** | બે claims વચ્ચે ≥ 20 h real elapsed: (a) online ⇒ server time delta; (b) offline same boot ⇒ monotonic uptime delta; (c) offline after reboot ⇒ wall-clock delta provisional, online થાય ત્યારે verify |
| Timezone change | Allowed; ઉપરના rules ⇒ double-claim શક્ય નહીં |

## 9. Offline Behaviour
- Daily રમી શકાય (seed local), reward **local grant**, `daily.pendingVerify = true`.
- Online થાય ⇒ server time થી verify: claim time ≥ previous + 20 h અને dayKey consistent ⇒ ok. Mismatch ⇒ **streak freeze** (streak day advance અટકે, `streak.frozen = true` until next valid claim); coins **revoke નહીં**.
- Leaderboard submits offline queue (`games_services` pending) ⇒ online પર flush.

## 10. Leaderboards (Phase 1)
| Board | Value | Submit when |
|---|---|---|
| Highest Level | `progress.highestCleared` | New highest |
| Total Stars | Sum of best stars L1–500 | Stars change |
| Total Streak Days | `streak.totalDays` | Daily clear |

- `games_services`: Google Play Games Services / Apple Game Center. Friends = platform friends. Custom backend નહીં.
- Signed-out ⇒ Leaderboards screen પર "Sign in" button; game કદી auto-block નહીં.
- Local progress hackable ⇒ leaderboard માત્ર fun; કોઈ reward rank પર આધારિત નહીં.

## 11. Edge Cases
| # | Case | Behaviour |
|---|---|---|
| D1 | 23:59 એ Daily શરૂ, 00:01 એ win | Board start `dayKey` નો; reward start dayKey પર claim (જો તે key unclaimed). Next key નો Daily અલગ |
| D2 | Midnight દરમિયાન app open | Home resume પર dayKey refresh, card update |
| D3 | Clock 1 day આગળ કરી claim, પછી પાછો | Forward claim local grant; online verify ⇒ 20 h rule fail ⇒ streak freeze; clock પાછો ⇒ time-travel lock |
| D4 | Timezone UTC+5:30 ⇒ UTC−8 travel | dayKey પાછો જઈ શકે ⇒ same key already claimed ⇒ no double claim |
| D5 | Daily cleared, then Saver offer? | Saver માત્ર missed-one gap વખતે, clear પહેલાં |
| D6 | Saver ad fails to load | Coins option ચાલુ; ad button disabled "Ad unavailable" |
| D7 | Saver chosen with < 200 coins | Mini shop (coins) — Saver offer day ભર valid |
| D8 | Player unlocks new mechanic mid-day | Today's cached board same; કાલથી નવો pool |
| D9 | Sunday, M049 locked | Classic (standard §16.2) |
| D10 | Thursday, M010 locked | Classic |
| D11 | App reinstall (Phase 1 no cloud) | Streak lost (local); Settings warning text |
| D12 | Wednesday One Heart + Shield | Shield absorbs 2 events normally |
| D13 | Daily generator fails on device (64 attempts) | `E-LVL-003` logged ⇒ fallback = Classic preset bundle `daily_fallback.json` (30 boards), board chosen by `dayKey` hash (standard §16.21) |
| D14 | Time-travel lock active at midnight | Daily playable? **No** — card locked with clock message (claim impossible) |

## 12. Analytics
`daily_clear{dayKey, modifier}`, `streak_update{day}` (standard §15) + `daily_start{dayKey, modifier, paramsLevel}`, `streak_saver{via: ad|coins|declined}`, `time_lock{deltaH}`.

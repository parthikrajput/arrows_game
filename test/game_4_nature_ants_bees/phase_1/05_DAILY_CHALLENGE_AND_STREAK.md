# 05 — Daily Garden Almanac & 7-Day Streak (દૈનિક પડકાર અને સ્ટ્રીક)
Daily Challenge ("Daily Garden Almanac") ના rules, weekday modifiers, seed, difficulty, silhouettes, streak ladder, Queen's Favor (Streak Saver), day key / anti-cheat, offline, leaderboards અને edge cases.

**Related docs:** [Shared Core Standard §8](../../SHARED_CORE_STANDARD.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [03 Obstacle Catalog](./03_OBSTACLE_CATALOG_PHASE_1.md) · [04 Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md) · [06 UI/UX Screens](./06_UI_UX_SCREENS.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Overview (સારાંશ)

| Item | Value |
|---|---|
| Unlock | **L15 clear** પછી |
| Puzzles | દિવસ દીઠ 1 (local date `dayKey`) |
| Reward | **+100 coins + 1 streak day** — `dayKey` દીઠ **1 વાર** |
| Retry | Unlimited, મફત |
| Boosters | Allowed (caps સામાન્ય levels જેવા) |
| Revive | Allowed: rewarded-ad revive **`dayKey` દીઠ 1 વાર** (key `adReviveUsed["daily:<dayKey>"]`, Standard §16.11/§16.27), Honey Heart Refill attempt દીઠ max 2 |
| 2X Win | Daily માં **2X Win offer નથી** ([Standard §16.37](../../SHARED_CORE_STANDARD.md)) |
| Ads | Daily પછી **interstitial ક્યારેય નહીં**; Daily screen પર banner નહીં |
| Streak | Daily **clear** થી આગળ વધે (માત્ર login થી નહીં) |

## 2. Daily Rules (નિયમો)
- Gameplay rules સામાન્ય levels જેવા જ ([01](./01_GAME_CONCEPT_AND_RULES.md)), layer rule સહિત.
- 3 Hearts (Wednesday સિવાય), stars (★) બતાવાય પણ **Total Stars** માં ગણાતા નથી અને coins પર અસર નહીં.
- Daily clear થયા પછી એ જ દિવસે ફરી રમી શકાય ("Practice" label), reward ફરી નહીં.
- Puzzle midnight local time સુધી માન્ય. Midnight પાર રમતા હોઈએ ⇒ ચાલુ attempt પૂરો કરી શકાય; clear થાય તો reward **attempt શરૂ થયેલા** dayKey માટે (જો તે dayKey claim ન થયો હોય).

## 3. Difficulty & Mechanic Pool (મુશ્કેલી)
- `Ld = max(15, highestCleared − 10)` — generator params `Ld` ના tier/slot પ્રમાણે (Grid, Lines, D band, [02 §1](./02_LEVEL_PROGRESSION_0001_0500.md)).
- **Bracket** = `Ld` નો 10-level block (દા.ત. Ld 137 ⇒ block 131–140). એક જ `dayKey` + bracket ⇒ દુનિયાભરમાં એક જ puzzle.
- **Mechanic pool = માત્ર unlocked mechanics**: intro level ≤ bracket નો last level. Game 4 ખાસ:
  - **Bees (M032) માત્ર Ld ≥ 41** — એ પહેલાં daily માં ફક્ત ant lines (`layers: 1`).
  - **Key & Lock (M004) માત્ર Ld ≥ 321** (swap).
  - `tall: true` instances માત્ર Ld ≥ 42.
- Generator params = level `Ld` ના **x6 slot** params (Grid, Lines, D band; Standard §16.11). Hard x9 નહીં.

## 4. Weekday Modifiers (અઠવાડિયાના modifiers)

Player daily card પર modifier નામ + 1-line explanation જુએ.

| Day | Modifier | Rule | Fallback (mechanic locked હોય તો) |
|---|---|---|---|
| Mon | **Classic** | કોઈ modifier નહીં | — |
| Tue | **Par Moves** | `par_moves` થી વધુ Moves ⇒ 1 ★ ઓછો (fail નહીં) | — |
| Wed | **One Heart** | 1 Heart; revive allowed | — |
| Thu | **Fog Day** | Morning Mist (M010) areas વધારે (2–3 areas) | Ld < 101 ⇒ **Classic** |
| Fri | **Key Hunt** | Dew Key & Thorn Lock (M004) / Multi-Lock વધારે | Ld < 321 ⇒ **Classic** (Game 4 swap) |
| Sat | **Big Board** | Player tier નો max grid size | — |
| Sun | **Mini Boss** | Great Orb Spider (M049) | Ld < 491 ⇒ **Classic** ([Standard §16.2](../../SHARED_CORE_STANDARD.md)) |

## 5. Themed Silhouettes (Mon–Sun આકાર)
Daily board માં lines એક garden silhouette ના mask માં ગોઠવાય (mask બહારના cells = ખાલી soil, playable નહીં). Phase 2 માં આ silhouettes Flora & Fauna Compendium ના **અલગ "Daily" page** પર collect થાય (collection only, coins નહીં); album volumes milestone-based જ રહે ([Standard §17.25](../../SHARED_CORE_STANDARD.md), [Phase 2 04 §2](../phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)).

| Day | Silhouette | Notes |
|---|---|---|
| Mon | 🍃 Leaf | પાંદડું, diagonal vein |
| Tue | 🌷 Tulip | ફૂલ + દાંડી |
| Wed | ⬡ Honeycomb | ષટ્કોણ |
| Thu | 🍄 Mushroom | ગોળ cap + દાંડી |
| Fri | 🐞 Ladybug | ગોળ body, વચ્ચે line |
| Sat | 🌻 Sunflower | મોટું ગોળ (Big Board માટે યોગ્ય) |
| Sun | 🛖 Beehive (skep) | ગુંબજ આકાર |

Mask edges એ board edge ગણાય (exit lanes mask બહાર જાય ત્યાં exit valid); mask ના અંદરના holes Phase 1 માં નથી.

## 6. Seed & Generation (deterministic)
- `seed = hash64("ants_bees", dayKey)` (Standard: `hash(gameId, dayKey)`), PRNG **xoshiro128\*\*** (Dart `Random` નહીં).
- Generator input: `(seed, bracket, weekdayModifier, silhouette)`. Attempt `k = 0…63` uses `seed + k`; પહેલો validator-pass candidate વપરાય ⇒ દરેક device પર એક જ result (same `GENERATOR_VERSION`).
- 64 attempts fail ⇒ fallback: bundled `daily_fallback.json` માંથી `dayKey` hash index (Classic). CI daily seeds આગામી 400 days × 50 brackets pre-validate કરે.
- Solver `solution` + `par_moves` generate થાય (Nectar Glow Hint અને Tuesday માટે).

## 7. Streak Ladder (7-Day Streak)

| Day | Reward |
|---|---|
| 1 | 50 coins |
| 2 | 75 coins |
| 3 | 100 coins + 1 Nectar Glow Hint |
| 4 | 125 coins + 2 Dewdrop Rewind |
| 5 | 150 coins + 1 Queen's Royal Shield |
| 6 | 200 coins + 1 Leaf Blower |
| 7 | **450 coins + 1 Nectar Glow Hint + 1 Queen's Royal Shield + 1 Leaf Blower + Golden Honeybee Trophy** |

- Week total **1,150 coins** + boosters. Streak reward Daily clear reward (+100) ઉપરાંત.
- **Golden Honeybee Trophy** tier દરેક પૂરા 7-day cycle પર વધે: Bronze → Silver → Gold → Platinum → Diamond (પછી Diamond ★2, ★3…). `trophyTier` save.
- Day 7 પછી ⇒ નવો cycle **Day 1** થી; `totalStreakDays` ચાલુ રહે (leaderboard).
- Booster unlock પહેલાં મળેલું booster (દા.ત. Day 6 Leaf Blower, L25 પહેલાં) inventory માં રહે.

## 8. Miss Rules & Queen's Favor (Streak Saver)

| Situation | Result |
|---|---|
| Exactly **1** day miss | પાછા આવો ત્યારે **Queen's Favor** offer: **1 rewarded ad અથવા 200 coins**. **7-day cycle દીઠ 1 વાર** (`cycleSaverUsed`). Saver ⇒ streak day index જળવાય, missed day નો reward **મળતો નથી**; આજનો clear આગલો day ગણાય |
| 1 day miss, saver already used આ cycle માં | Day 1 reset |
| Offer decline / dismiss | Day 1 reset (offer એ જ dayKey પર ફરી બતાવાય ત્યાં સુધી કે Daily clear ન થાય) |
| **2+** days miss | Day 1 reset, saver offer નહીં |
| Ad unavailable | 200 coins option જ; coins પણ નથી ⇒ "Get coins" (Shop) |

- Queen's Favor એ દિવસના Daily clear **પહેલાં** accept કરવો પડે ([Standard §16.37](../../SHARED_CORE_STANDARD.md)). Offer accept કર્યા વગર Daily clear ⇒ streak Day 1 થી (offer expire).

ઉદાહરણ: Mon Day 3 clear, Tue miss, Wed Queen's Favor (Wed clear પહેલાં) ⇒ Wed clear = Day 4 (Tue નો reward નહીં).

## 9. Day Key & Anti-Cheat

- `dayKey` = device **local date** `YYYY-MM-DD` (midnight reset).
- Save: `lastClaimDayKey`, `lastTrustedUtc`, `lastServerUtc` (online હોય ત્યારે Firebase / HTTP `Date` header).
- **Time-travel lock:** device clock < `lastTrustedUtc − 2h` ⇒ Daily claim, Streak, Sunflower Spin બંધ જ્યાં સુધી clock `lastTrustedUtc` થી આગળ ન જાય. UI: "Garden clock looks off — check your device time."
- એક `dayKey` માટે claim એક જ વાર; બે claims વચ્ચે **min 20 h real elapsed** (server time અથવા monotonic uptime).
- Timezone change allowed, પણ ઉપરના rules ⇒ double-claim નહીં.
- Monotonic uptime reboot પછી reset ⇒ ત્યારે `lastServerUtc` (online) અથવા wall clock + time-travel lock fallback.

## 10. Offline
- Daily offline રમી શકાય (on-device generation), reward local grant.
- Online થાય ત્યારે server time થી verify; mismatch (claim time server પ્રમાણે < 20 h gap અથવા future date) ⇒ **streak freeze** (આગલો claim server-valid થાય ત્યાં સુધી streak આગળ નહીં), coins revoke **નહીં**.
- Queen's Favor ad offline ⇒ ad option disabled, coins option ચાલુ.

## 11. Leaderboards (Phase 1)
- `games_services` (Google Play Games / Apple Game Center): **Highest Level**, **Total Stars**, **Total Streak Days**.
- Friends = platform friends. Custom backend નહીં.
- Local progress hackable ⇒ leaderboard માત્ર fun; **કોઈ reward rank પર આધારિત નથી**.
- Sign-in optional; sign-in વગર leaderboard button ⇒ sign-in prompt.

## 12. Edge Cases (ખાસ કિસ્સા)

| # | Case | Expected |
|---|---|---|
| D1 | Player L15 clear કર્યા પહેલાં Daily tap | Locked card "Clear Level 15 to unlock" |
| D2 | `highestCleared = 45` (Ld = 35) | Daily માં **bees નહીં** (Ld < 41), Fri ⇒ Classic, Thu ⇒ Classic |
| D3 | `highestCleared = 60` (Ld = 50) | Bees allowed, Sunflower Stalk allowed, keys નહીં |
| D4 | Daily clear 23:59, next 00:01 | Next claim blocked until 20 h elapsed (anti-cheat); UI "Next Almanac in HH:MM" |
| D5 | Clock 1 દિવસ પાછળ કર્યો | Time-travel lock (if < lastTrustedUtc − 2h) |
| D6 | Timezone +5:30 → −8:00 travel | dayKey local; 20 h rule double-claim અટકાવે |
| D7 | Wed One Heart, bump | 0 hearts ⇒ Second Chance (revive allowed) |
| D8 | Tue, Moves = par + 1, 0 hearts lost | ★★ |
| D9 | Sunday, Ld 300 | Mini Boss locked ⇒ Classic |
| D10 | Offline clear, online પછી server says same-day duplicate | Streak freeze, coins રહે |
| D11 | Day 7 clear | Trophy tier +1, next day = Day 1, `totalStreakDays` +1 |
| D12 | Saver used, again 1 day miss same cycle | Day 1 reset |
| D13 | Generator 64 attempts fail | `daily_fallback.json` Classic puzzle |
| D14 | App update changes `GENERATOR_VERSION` mid-day | આજનો puzzle cache (`dailyBoardCache[dayKey]`, Standard §16.30) થી, નવું version કાલથી |

## 13. Analytics
`daily_clear{dayKey, modifier}`, `streak_update{day}`, plus `level_start/level_win/level_fail` with `level = "daily-YYYY-MM-DD"`. Saver: `revive`-like custom `streak_saver{type: ad|coins}`.

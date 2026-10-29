# Snakes Slither — Game 1 Design Spec (v3)
> આખા spec નો overview: game શું છે, કોના માટે છે, મુખ્ય numbers, folder map અને કયો topic કયા document માં છે.

**Related docs:** [Shared Core Standard](../SHARED_CORE_STANDARD.md) · [Sound effects](../SOUND_EFFECTS_IMPLEMENTATION.md) · [Logging & error tracking](../LOGGING_AND_ERROR_TRACKING.md) · [Phase 1 index](./phase_1/README.md) · [Phase 2 index](./phase_2/README.md) · [Scaling to 10,000 levels](./SCALING_TO_10000_LEVELS.md)

**Version:** 3.0 (2026-10-27) · **Engine rules:** [SHARED_CORE_STANDARD.md](../SHARED_CORE_STANDARD.md) v3.0 (કોઈ number અહીં અલગ હોય તો standard સાચું ગણાય).

---

## 1. Title & Naming
- **Working title:** **Snakes Slither** 🐍
- જૂનું નામ "Snake Out!" એક હાલની competitor game ના નામ સાથે ટકરાય છે, તેથી હવે કોઈ document માં વાપરવું નહીં.
- ⚠️ **Final store name pending:** Launch પહેલાં Google Play + App Store search અને trademark search (India + US + EU) કરવો. ત્યાં સુધી "Snakes Slither" માત્ર working title છે. Package id: `com.<studio>.snakesslither` (studio id નક્કી થયા પછી).

## 2. Pitch (એક લાઈનમાં)
Board પર ગૂંચવાયેલા cute, રંગબેરંગી સાપ અને ઇયળોને સાચા order માં tap કરો — રસ્તો ખુલ્લો હોય તો સાપ મરોડ લઈને (slither wiggle) બહાર સરકી જાય, રસ્તો બંધ હોય તો માથું "બોંક" કરીને પાછો આવે અને 1 Heart જાય.

## 3. Audience & USP
| Item | Detail |
|---|---|
| Target age | 10–50 (mixed audience ⇒ neutral age gate, §7.3 of standard) |
| Genre | Path-clear logic puzzle, turn-based, relaxing (ASMR feel) |
| Session | 1 level ≈ 10 s (FTUE) થી 2–3 min (T5); કોઈ wall-clock timer નહીં |
| USP 1 | કાળા તીરની જગ્યાએ **જીવંત characters**: આંખો blink, head bonk, body wiggle — દરેક tap નું દ્રશ્ય feedback |
| USP 2 | **દર 10 levels એ નવું jungle mechanic** (49 mechanics in Phase 1) — દરેક નો tutorial card |
| USP 3 | Fair puzzle: દરેક level **0 hearts lost, 0 boosters** થી solvable (CI validator ચકાસે) |
| USP 4 | Daily Challenge (weekday modifier + jungle silhouettes) + 7-day Streak ladder |

## 4. Platform & Tech (one-liner)
Android + iOS · Flutter 3.x (Dart 3, Impeller) · `CustomPainter` + `Ticker` game loop (Flame નહીં) · `flutter_bloc` · shared pure-Dart engine `packages/puzzle_core` · `hive_ce` saves · AdMob + UMP · `in_app_purchase` · Firebase Analytics/Crashlytics/Remote Config · `games_services` leaderboards · `audioplayers` ([Sound standard](../SOUND_EFFECTS_IMPLEMENTATION.md)) · `AppLogger` + Crashlytics ([Logging standard](../LOGGING_AND_ERROR_TRACKING.md)) · offline-first.

## 5. Key Numbers Summary
બધા values = launch defaults (Remote Config થી tune થઈ શકે). Source: shared standard.

| Area | Value |
|---|---|
| Hearts per attempt | 3 (max 3) · Bump = −1 Heart |
| Revive (rewarded ad) | +1 Heart, **level number દીઠ 1 વાર** (restart થી reset નહીં) |
| Heart Berry Refill (Heart Refill) | 120 coins → +1 Heart, **attempt દીઠ max 2**, માત્ર Second Chance popup માં |
| Stars | ★★★ 0 hearts lost · ★★ 1 lost · ★ 2+ lost અથવા કોઈ revive/refill |
| Glow Firefly Hint (Hint) | Unlock L3 (3 free) · cap 3/attempt · 60 single / 150 for 3 |
| Coil-Back Undo (Undo) | Unlock L8 (3 free) · no cap · 40 / 100 |
| Safety Shell Shield (Shield) | Unlock L15 (1 free) · cap 1 · absorbs next 2 heart-loss events · 80 / 200 |
| Magic Stone Hammer (Hammer) | Unlock L25 (1 free) · cap 2 · 100 / 250 |
| Tongue-Flick Preview (Path Preview) | Free, long-press ≥ 350 ms, Move નથી |
| Starting wallet | 200 coins (+ દરેક booster tutorial વખતે free boosters) |
| Level clear coins | Easy 15 / Normal 20 / Hard 30 / Finale 50 · first ★★★ +20 |
| Gift Box (L10, L20 …) | 150 → 300 coins + 1 booster · L500 = Phase Chest 1,000 + 2 of each booster |
| Coin Rush | after L25, 50, 75 … (first clear only) · 30 s · snakes per tier: T1 20 · T2 22 · T3 25 · T4 28 · T5/Phase 2 30 · 10 coins/snake · full clear +100 |
| Daily Challenge | Unlock L15 · +100 coins/day · 7-day Streak ladder (week = 1,150 coins + boosters) |
| Interstitial | દર 5 numbered-level wins, L1–10 માં ક્યારેય નહીં, min 120 s gap, daily cap 20 |
| VIP No-Ads Pass | ₹20/month auto-renewing subscription (active હોય ત્યાં સુધી interstitial + banner બંધ) |
| Phase 1 | Levels 1–500 · 49 mechanics M001–M049 (L11 … L491) + L500 Finale · max grid 11×11 |
| Phase 2 | Levels 501–1000 · 49 mechanics M051–M099 + LiveOps |
| Phases 3–20 | Levels 1001–10,000 · on-device deterministic generation |

## 6. Folder Map
```
game_1_snakes_slither/
├── README.md                                  ← આ file (overview + coverage matrix)
├── SCALING_TO_10000_LEVELS.md                 ← 500 → 10,000 levels plan (generator, phases 3–20)
├── phase_1/                                   ← Launch scope: Levels 1–500
│   ├── README.md                              ← Phase 1 scope + doc index
│   ├── 01_GAME_CONCEPT_AND_RULES.md
│   ├── 02_LEVEL_PROGRESSION_0001_0500.md
│   ├── 03_OBSTACLE_CATALOG_PHASE_1.md
│   ├── 04_BOOSTERS_COINS_SHOP.md
│   ├── 05_DAILY_CHALLENGE_AND_STREAK.md
│   ├── 06_UI_UX_SCREENS.md
│   └── 07_FRONTEND_IMPLEMENTATION_AND_QA.md
└── phase_2/                                   ← Levels 501–1000 + LiveOps
    ├── README.md                              ← Phase 2 scope + backend prerequisites + doc index
    ├── 01_PHASE_2_SCOPE_AND_RULES.md
    ├── 02_LEVEL_PROGRESSION_0501_1000.md
    ├── 03_OBSTACLE_CATALOG_PHASE_2.md
    ├── 04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md
    ├── 05_OFFLINE_AND_CLOUD_SYNC.md
    └── 06_FRONTEND_AND_QA_PHASE_2.md
```

## 7. Coverage Matrix
Required topics અને કયો document તેને cover કરે છે:

| # | Required topic | Primary doc | Supporting docs |
|---|---|---|---|
| 1 | Whole-spec overview | [README.md](./README.md) (આ file) | [phase_1/README.md](./phase_1/README.md), [phase_2/README.md](./phase_2/README.md) |
| 2 | Game concept & gameplay rules | [01_GAME_CONCEPT_AND_RULES.md](./phase_1/01_GAME_CONCEPT_AND_RULES.md) | Standard §1–§4 |
| 3 | 500-level progression, new mechanic every 10 levels | [02_LEVEL_PROGRESSION_0001_0500.md](./phase_1/02_LEVEL_PROGRESSION_0001_0500.md) | Standard §9 |
| 4 | Obstacles: how they work & their rules | [03_OBSTACLE_CATALOG_PHASE_1.md](./phase_1/03_OBSTACLE_CATALOG_PHASE_1.md) | Standard §10 |
| 5 | Hint, Undo, power-ups, coin rewards & Shop | [04_BOOSTERS_COINS_SHOP.md](./phase_1/04_BOOSTERS_COINS_SHOP.md) | Standard §5–§7 |
| 6 | Daily Challenge & 7-day Streak | [05_DAILY_CHALLENGE_AND_STREAK.md](./phase_1/05_DAILY_CHALLENGE_AND_STREAK.md) | Standard §8 |
| 7 | All screens (Home, Gameplay, Shop, Level Map, …) | [06_UI_UX_SCREENS.md](./phase_1/06_UI_UX_SCREENS.md) | — |
| 8 | 500 → 10,000 content & scalability | [SCALING_TO_10000_LEVELS.md](./SCALING_TO_10000_LEVELS.md) | [phase_2/README.md](./phase_2/README.md), Standard §11–§12 |
| 9 | Frontend implementation rules & testing checklist | [07_FRONTEND_IMPLEMENTATION_AND_QA.md](./phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) | Standard §13–§15 |
| 10 | Sound effects | [SOUND_EFFECTS_IMPLEMENTATION.md](../SOUND_EFFECTS_IMPLEMENTATION.md) | [phase_1/07](./phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md), [phase_2/06](./phase_2/06_FRONTEND_AND_QA_PHASE_2.md) |
| 11 | Logging & error tracking | [LOGGING_AND_ERROR_TRACKING.md](../LOGGING_AND_ERROR_TRACKING.md) | [phase_1/07](./phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md), [phase_2/06](./phase_2/06_FRONTEND_AND_QA_PHASE_2.md) |

## 8. Theme Quick Reference
| Generic | Snakes Slither name |
|---|---|
| Path | Snake (visual variant: Caterpillar — rules એકસરખા) |
| Exit | Slither out (head સીધો exit lane પર, body follow કરે) |
| Bump | Head bonk (shake + slide back) |
| Board | Garden patch (grass grid) |
| Hint / Undo / Shield / Hammer | Glow Firefly Hint / Coil-Back Undo / Safety Shell Shield / Magic Stone Hammer |
| Path Preview | Tongue-Flick Preview |
| Heart Refill | Heart Berry Refill |
| Gift Box / Coin Rush / Phase Chest | Jungle Gift Basket / Golden Slither Rush / Jungle Treasure Chest |
| Lucky Spin | Lucky Lily Wheel |
| Guardian (M049) | Grumpy Mongoose |

પૂરું glossary: [01_GAME_CONCEPT_AND_RULES.md §11](./phase_1/01_GAME_CONCEPT_AND_RULES.md#11-theme-glossary-generic--snakes-slither).

## 9. v3 Changes (જૂના docs સામે શું સુધાર્યું)
1. **Title:** "Snake Out! Slither Puzzle" → working title "Snakes Slither" (name collision; store/trademark check pending).
2. **Duplicates દૂર:** જૂના folder માં એક જ file root, `phase_1/` અને `phase_2/` માં 2–3 વાર હતી (`GAME_DESIGN_V2.md` ત્રણ વાર, બે અલગ obstacle lists). હવે દરેક topic નો **એક જ** document.
3. **Boosters unified:** જૂના docs માં નામ અલગ-અલગ (Glow Hint / Smart Hint / Magic Hammer / Path Radar) અને 4th booster "Snake Charmer Flute" (350 coins, 3 snakes auto-exit). હવે standard ના 4 boosters: Hint, **Undo (નવો, required)**, Shield, Hammer + free Preview. Flute દૂર.
4. **Booster prices contradictory હતા** (માત્ર 3-pack prices, single નહીં; Flute 350). હવે single + 3-pack: 60/150, 40/100, 80/200, 100/250.
5. **Revive exploit:** જૂના docs માં "once per level" અને "once per level attempt" બંને લખેલું — restart કરીને અમર્યાદિત ad revive શક્ય હતું. હવે **level number દીઠ 1**, `adReviveUsed[level]` save માં.
6. **Heart Refill:** જૂનામાં shop item અને streak reward (Day 4) હતું. હવે માત્ર Second Chance popup માં, 120 coins, attempt દીઠ max 2.
7. **Wall-clock timers દૂર:** Chameleon Signal "દર 3 સેકન્ડે", Crab Claw, Electric Eel "2 સેકન્ડ", Zen Gong "5 સેકન્ડ", Burning Sun Tiles, Shrinking Forest "સમય સાથે", Daily "60 સેકન્ડ limit" — બધું દૂર. Timed mechanics હવે **Move counter** પર. એકમાત્ર timer: Golden Slither Rush (30 s bonus).
8. **Forced damage દૂર:** "Thorn Bush Spikes — ખોટા time એ heart કપાય" જેવા obstacles દૂર; કોઈ mechanic heart ગુમાવવાનું ફરજિયાત નથી.
9. **Obstacle list unified:** બે અલગ 50-item lists (અલગ order, અલગ rules) → standard library M001–M049 ના exact rules + jungle themed names. Intro levels L11, 21 … 491 (x1 slot).
10. **Tier table:** જૂનામાં Phase 1 માં 14×14+ અને 45–60 snakes — 360 dp phone પર unplayable. હવે max 11×11, 30 snakes, min cell 29 dp.
11. **FTUE "3–7 સેકન્ડ" rule:** design rule તરીકે deterministic નહોતો. હવે CI rule = L1–3 optimal ≤ 4 Moves, L4–10 ≤ 8 Moves; seconds માત્ર analytics target.
12. **Coin Rush:** જૂનામાં "L25 એ bonus level, 200–500 coins". હવે numbered level નથી; L25, 50, 75 … પછી bonus round, 10/snake + 100 full clear (max 300–400). Gift Box સાથે આવે તો Gift Box પહેલાં.
13. **Streak:** જૂનો ladder (Day 7 = 1,500 + bundle, Day 4 heart refill) અને "1 day miss = reset" vs "150 coins saver" વિરોધાભાસ. હવે standard ladder (week 1,150 coins) + Streak Saver 200 coins/ad, exactly 1 miss, cycle દીઠ 1 વાર.
14. **Interstitial:** જૂનામાં L5, L10 પર ad. હવે L1–10 માં ક્યારેય નહીં, પહેલું eligible L15, 120 s cooldown, reward screens પર defer.
15. **VIP:** "ads કાયમી બંધ" ખોટું — ₹20/month auto-renewing subscription; expire થાય તો ads પાછી.
16. **Tech:** "CustomPainter or Flame", "BLoC/Riverpod", "Hive/SharedPreferences" options → એક જ decision (CustomPainter + Ticker, flutter_bloc, hive_ce).
17. **Compliance ઉમેર્યું:** neutral age gate, UMP consent, Families policy, Lucky Spin odds disclosure.
18. **Leaderboard:** "real-time global ranking" → `games_services` (Highest Level, Total Stars, Total Streak Days); rewards rank પર આધારિત નહીં.
19. **QA:** જૂના checklist માં run કર્યા વગર "Pass" marks હતા. હવે દરેક item "Not run".
20. **Links:** `file:///` links દૂર; બધી relative links.

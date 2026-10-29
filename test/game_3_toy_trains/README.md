# Toy Trains: Wooden Railway Puzzle — Design Spec Overview (v3)
> હેતુ: Game 3 ના આખા design spec નો overview — pitch, audience, USP, tech, key numbers, folder map, 9 required topics નો coverage matrix અને v3 માં શું સુધાર્યું.

**Related docs:** [Shared Core Standard](../SHARED_CORE_STANDARD.md) · [Phase 1 README](./phase_1/README.md) · [Phase 2 README](./phase_2/README.md) · [Scaling to 10,000 Levels](./SCALING_TO_10000_LEVELS.md)

---

## 1. Pitch

લાકડાના tabletop playmat પર રંગબેરંગી toy trains ગૂંચવાઈને ઊભી છે. દરેક engine એક દિશામાં જુએ છે અને પાછળ 1–4 carriages જોડાયેલા છે. Train પર tap કરો ⇒ જો આગળનો track ખાલી હોય તો "toot-toot" કરતી train table ની edge પરથી Toy Box Station માં ઊતરી જાય; આગળ કોઈ train કે obstacle હોય તો buffers "clack" — train પાછી roll થાય અને 1 heart જાય. સાચો ક્રમ શોધો, બધી trains રવાના કરો.

- **Title:** Toy Trains: Wooden Railway Puzzle
- **Genre:** Turn-based path-clear logic puzzle (no wall-clock timer in puzzles)
- **Audience:** 10–50 years (mixed audience ⇒ neutral age gate, Families policy)
- **Session:** 30 s – 3 min per level; 500 launch levels

## 2. USP

1. **Tactile wooden-toy feel:** satin-painted trains, carriages that follow the engine around bends, buffer-clack bumps, music-box soundtrack.
2. **Every 10 levels something new:** 49 railway-themed mechanics (Buffer Stops, Level Crossings, Tunnel Pairs, Turntables, Track Switches, Clock Tower Guardian…) on a strict 10-level block rhythm.
3. **Fair puzzles:** every level solvable with 0 hearts lost and 0 boosters (CI solver-validated); free Route Peek preview; deterministic rules.
4. **Respectful monetization:** no interstitials in L1–10, 120 s cooldown, VIP ₹20/month, all rewarded ads opt-in.

## 3. Platform & Tech (one-liner)

Flutter 3.x / Dart 3 (Impeller), `CustomPainter` + Ticker loop, `flutter_bloc`, shared pure-Dart `packages/puzzle_core`, `hive_ce`, AdMob + UMP, `in_app_purchase` + Firebase receipt validation, Firebase Analytics/Crashlytics/Remote Config, `games_services` — Android + iOS, offline-first. Details: [07](./phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md).

## 4. Key Numbers

| Topic | Value (launch default, Remote Config tunable) |
|---|---|
| Hearts | 3 per attempt; bump −1; ad revive +1 (**1 per level**); Heart Refill 120 coins (**max 2 per attempt**) |
| Stars | ★★★ 0 lost · ★★ 1 lost · ★ 2+ lost or any revive/refill |
| Green Signal Hint (Hint) | unlock L3 (3 free) · cap 3/attempt · 60 / 3-pack 150 |
| Reverse Gear Undo (Undo) | unlock L8 (3 free) · no cap · 40 / 3-pack 100 |
| Cowcatcher Shield (Shield) | unlock L15 (1 free) · absorbs next 2 heart losses · cap 1 · 80 / 3-pack 200 |
| Track Crane (Hammer) | unlock L25 (1 free) · removes 1 train or hammerable obstacle · cap 2 · 100 / 3-pack 250 |
| Route Peek (Path Preview) | free long-press ≥ 350 ms |
| Level clear coins | Easy 15 / Normal 20 / Hard 30 / Finale 50; first ★★★ +20 |
| Conductor's Gift Crate | every x0: 150 → 300 coins + 1 booster |
| Golden Express Coin Rush | after L25, 50, 75 …: 30 s, 10/train, +100 full clear |
| Daily Timetable Run | unlock L15, +100 coins; Express Streak week = 1,150 coins + boosters + trophy |
| Ads | interstitial every 5 wins, never L1–10, 120 s cooldown; VIP Conductor Pass ₹20/month auto-renewing |
| **Phase 1** | L1–500 · M001–M049 · max 11×11 · L500 Grand Central Finale |
| **Phase 2** | L501–1000 · M051–M099 · zoom/pan · LiveOps |
| **Phases 3–20** | L1001–10,000 · on-device generation · 4 base mechanics + 45 variants per phase |

## 5. Folder Map

```
game_3_toy_trains/
├─ README.md                         ← this overview
├─ SCALING_TO_10000_LEVELS.md        ← 500 → 10,000 content & scalability plan
├─ phase_1/                          ← Launch: Levels 1–500
│  ├─ README.md
│  ├─ 01_GAME_CONCEPT_AND_RULES.md
│  ├─ 02_LEVEL_PROGRESSION_0001_0500.md
│  ├─ 03_OBSTACLE_CATALOG_PHASE_1.md
│  ├─ 04_BOOSTERS_COINS_SHOP.md
│  ├─ 05_DAILY_CHALLENGE_AND_STREAK.md
│  ├─ 06_UI_UX_SCREENS.md
│  └─ 07_FRONTEND_IMPLEMENTATION_AND_QA.md
└─ phase_2/                          ← Levels 501–1000 + LiveOps
   └─ README.md (+ Phase 2 docs)
```
Canonical numbers: [../SHARED_CORE_STANDARD.md](../SHARED_CORE_STANDARD.md).

## 6. Coverage Matrix

| # | Required topic | Covered in |
|---|---|---|
| 1 | Whole-spec overview | This file · [phase_1/README.md](./phase_1/README.md) |
| 2 | Game concept & gameplay rules | [01 Game Concept & Rules](./phase_1/01_GAME_CONCEPT_AND_RULES.md) |
| 3 | 500-level progression, new obstacle/mechanic every 10 levels | [02 Level Progression 0001–0500](./phase_1/02_LEVEL_PROGRESSION_0001_0500.md) |
| 4 | How obstacles work & their rules | [03 Obstacle Catalog Phase 1](./phase_1/03_OBSTACLE_CATALOG_PHASE_1.md) |
| 5 | Hint, Undo, power-ups, coin rewards & Shop | [04 Boosters, Coins & Shop](./phase_1/04_BOOSTERS_COINS_SHOP.md) |
| 6 | Daily challenge & 7-day streak | [05 Daily Challenge & Streak](./phase_1/05_DAILY_CHALLENGE_AND_STREAK.md) |
| 7 | All screens incl. Home, Gameplay, Shop, Level Map | [06 UI/UX Screens](./phase_1/06_UI_UX_SCREENS.md) |
| 8 | 500 → 10,000 content & scalability planning | [SCALING_TO_10000_LEVELS.md](./SCALING_TO_10000_LEVELS.md) · [phase_2/README.md](./phase_2/README.md) |
| 9 | Frontend implementation rules & testing checklist | [07 Frontend Implementation & QA](./phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) |

## 7. v3 Changes (old docs ની સરખામણીમાં શું સુધાર્યું)

1. **એક જ title:** "Toy Trains: Wooden Railway Puzzle" (જૂના docs માં "Train Out! Railway Switch" અને "Toy Trains & Railway Tracks" બે નામ હતા).
2. **Docs reorganized:** root + phase_1 માં duplicate copies હતી; હવે એક overview, phase_1 ના 7 numbered docs, phase_2 અને scaling doc.
3. **Boosters standard મુજબ:** Express Clear Magnet (3 trains auto-clear) દૂર; **Reverse Gear Undo** ઉમેર્યો (જૂના docs "No Undo" કહેતા હતા — standard માં Undo જરૂરી છે). Themed names બધી files માં એકસરખા.
4. **Mechanics = standard M001–M049, standard order:** જૂનું 50-obstacle list (Boom Barrier L21, Icy Rails L31, Steam Boiler L91 …) બદલીને standard IDs/intro levels; "(Fat)" freight, aqueduct water flow, magnetic buffers, ventilation fan, roundabout loop track, shifting tracks જેવા non-standard physics દૂર. Loops માત્ર M046 Loop Line Train.
5. **No wall-clock timers in puzzles:** Traffic light "every 3 seconds", Station Clock "5-second freeze", Overheated Rails, Swinging Crane timing, Third Rail spark — દૂર; counters હવે Move-based (Level Crossing, Steam Pressure, Last Call Exit).
6. **No forced damage:** "Spike Derailer" જેવા unavoidable heart-loss obstacles દૂર; દરેક level 0 hearts / 0 boosters solvable (CI).
7. **Interactive taps = Moves** (lever, turntable, switch, rotating yard, gear lever) explicit; locked taps no heart / no Move; tap priority + input queue rules ઉમેર્યા.
8. **Revive & hearts:** ad revive 1 per **level** (not per attempt), Second Chance 10 s (જૂનું 5 s), Heart Refill 120 coins max 2/attempt — માત્ર Second Chance popup માં (shop item નહીં, streak reward નહીં).
9. **Economy fixed:** Coin Rush 30 s, 10/train, +100 (max 300–400; જૂનું 200–500); Gift Crate schedule 150→300 + booster rotation; Lucky Turntable odds table + disclosure; Starter Pack, coin pack prices standard મુજબ.
10. **Streak fixed:** ladder 50/75/100/125/150/200/450 (week 1,150; જૂનું day 7 = 1,500) + Streak Saver (1 miss, 1×/cycle); streak Daily clear થી આગળ વધે; time-travel lock + 20 h rule.
11. **Ads fixed:** interstitial દર 5 wins, L1–10 માં ક્યારેય નહીં (જૂનું L5, L10 …), 120 s cooldown, reward screens પર defer; banner માત્ર Home/Map + gameplay L11+.
12. **VIP:** ₹20/month **auto-renewing subscription**, ads off માત્ર active હોય ત્યાં સુધી (જૂનું "કાયમી બંધ" અને VIP daily coins દૂર).
13. **Compliance:** neutral age gate, UMP before ads, Families policy, under-13 child-directed ads.
14. **Code quality:** Dart samples Flutter 3.x / Dart 3 compile-correct (`withValues(alpha:)`, `shouldRepaint`, cached board picture); QA checklist માં બધા items "Not run" (કોઈ fake "Pass" નહીં).

# Yarn Unravel: Cozy Thread Puzzle — Design Spec Overview
> Purpose: Game 2 ની આખી specification નો overview — pitch, audience, USP, tech, key numbers, folder map, required topics નું coverage matrix અને v3 માં શું સુધાર્યું.

**Related docs:** [../SHARED_CORE_STANDARD.md](../SHARED_CORE_STANDARD.md) (rules & numbers — single source of truth) · [../README.md](../README.md) (4-game hub) · [../SOUND_EFFECTS_IMPLEMENTATION.md](../SOUND_EFFECTS_IMPLEMENTATION.md) · [../LOGGING_AND_ERROR_TRACKING.md](../LOGGING_AND_ERROR_TRACKING.md) · [./phase_1/README.md](./phase_1/README.md) · [./phase_2/README.md](./phase_2/README.md) · [./SCALING_TO_10000_LEVELS.md](./SCALING_TO_10000_LEVELS.md)

**Spec version:** v3 (2026-10-27) — SHARED_CORE_STANDARD v3.0 પર આધારિત.

---

## 1. Pitch
લાકડાની ફ્રેમવાળા લંબચોરસ **craft board** પર રંગબેરંગી ઊનના દોરા પડ્યા છે; દરેક દોરાના છેડે નાની સ્ટીલની **needle** દિશા બતાવે છે. દોરા પર tap કરો — રસ્તો ખુલ્લો હોય તો needle બહાર ખેંચાય અને આખો દોરો તેની પાછળ સરસ રીતે **unravel** થઈ board બહાર નીકળે. રસ્તો બંધ હોય તો દોરો **snag** થાય, "twang" સાથે પાછો spring થાય અને 1 Heart જાય. બધા દોરા કાઢો ⇒ level clear. Cozy, turn-based, no-pressure path-clear puzzle.

## 2. Audience & USP

| Item | Value |
|---|---|
| Audience | Age 10–50, casual / cozy-puzzle players (mixed audience ⇒ age gate, Families policy) |
| Genre | Path-clear (tap-away) logic puzzle |
| Session | 10 s (FTUE levels) to 2–4 min (late levels) |
| USP 1 | Tactile wool threads with needle head; unravel animation where the thread truly follows its needle |
| USP 2 | 49 sewing/craft mechanics in Phase 1 (buttons, clasps, pompom tunnels, spools, zippers, thimbles, pincushion boss) — one new every 10 levels |
| USP 3 | No wall-clock pressure, no lives system, free retries |
| USP 4 | Colour-blind safe: every thread colour has a pattern + needle icon |

## 3. Platform & Tech (one-liner)
Flutter 3.x / Dart 3 (Impeller), `CustomPainter` + Ticker loop, `flutter_bloc`, shared pure-Dart engine `packages/puzzle_core`, `hive_ce`, AdMob + UMP, `in_app_purchase` + Firebase Function receipt check, Firebase Analytics/Crashlytics/Remote Config, `games_services`; Android 8.0+ / iOS 14+, portrait. Details: [phase_1/07](./phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md).

## 4. Key Numbers

| Topic | Value |
|---|---|
| Hearts | 3 per attempt (max 3); bump (snag) −1 |
| Revive | Rewarded ad +1 Heart **once per level** · Heart Refill **120 Coins**, max **2 per attempt** (Second Chance only) |
| Stars | ★★★ 0 lost · ★★ 1 lost · ★ 2+ lost or any revive |
| Needle Glow Hint (Hint) | unlock L3 · cap 3/attempt · 60 / 3-pack 150 |
| Seam Ripper Undo (Undo) | unlock L8 · no cap · 40 / 3-pack 100 |
| Thimble Shield (Shield) | unlock L15 · cap 1 · absorbs 2 · 80 / 3-pack 200 |
| Golden Scissors (Hammer) | unlock L25 · cap 2 · 100 / 3-pack 250 |
| Thread Peek (Path Preview) | free long-press ≥ 350 ms |
| Clear coins | Easy 15 / Normal 20 / Hard 30 / Finale 50; first ★★★ +20 |
| Craft Basket (Gift Box) | every x0: 150 → 300 Coins + 1 booster |
| Golden Bobbin Rush (Coin Rush) | after L25, 50, 75 …; 30 s; 10/thread; +100 full clear |
| Daily Stitch | unlock L15; +100 Coins; 7-day streak (week 1,150 Coins + boosters) |
| Ads | interstitial every 5 wins (never L1–10), 120 s cooldown, deferred on reward screens; banner Home/Map/Gameplay L11+ |
| VIP No-Ads Pass | ₹20/month auto-renewing (ads off while active) |

| Phase | Levels | Content | Doc |
|---|---|---|---|
| Phase 1 (Launch) | 1–500 | M001–M049 + L500 Finale | [phase_1/](./phase_1/README.md) |
| Phase 2 | 501–1000 | onboarding 501–510 + M051–M099 + L1000 Finale + LiveOps | [phase_2/](./phase_2/README.md) |
| Phases 3–20 | 1001–10,000 | signature system + 4 base mechanics + 45 variants per phase | [SCALING_TO_10000_LEVELS.md](./SCALING_TO_10000_LEVELS.md) |

## 5. Folder Map
```
game_2_yarn_unravel/
├── README.md                          ← this file (overview + coverage matrix)
├── SCALING_TO_10000_LEVELS.md         500 → 10,000 levels plan (Phases 3–20)
├── phase_1/   Levels 1–500 (Launch)
│   ├── README.md                      scope + index
│   ├── 01_GAME_CONCEPT_AND_RULES.md
│   ├── 02_LEVEL_PROGRESSION_0001_0500.md
│   ├── 03_OBSTACLE_CATALOG_PHASE_1.md
│   ├── 04_BOOSTERS_COINS_SHOP.md
│   ├── 05_DAILY_CHALLENGE_AND_STREAK.md
│   ├── 06_UI_UX_SCREENS.md
│   └── 07_FRONTEND_IMPLEMENTATION_AND_QA.md
└── phase_2/   Levels 501–1000 + LiveOps
    ├── README.md                      scope + index
    ├── 01_PHASE_2_SCOPE_AND_RULES.md
    ├── 02_LEVEL_PROGRESSION_0501_1000.md
    ├── 03_OBSTACLE_CATALOG_PHASE_2.md
    ├── 04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md
    ├── 05_OFFLINE_AND_CLOUD_SYNC.md
    └── 06_FRONTEND_AND_QA_PHASE_2.md
```

Shared (repo root, બધી games માટે): [../SHARED_CORE_STANDARD.md](../SHARED_CORE_STANDARD.md) · [../SOUND_EFFECTS_IMPLEMENTATION.md](../SOUND_EFFECTS_IMPLEMENTATION.md) · [../LOGGING_AND_ERROR_TRACKING.md](../LOGGING_AND_ERROR_TRACKING.md)

## 6. Coverage Matrix (required topics)

| # | Required topic | Covered in |
|---|---|---|
| 1 | Whole-spec overview | **This file** · [phase_1/README.md](./phase_1/README.md) · [phase_2/README.md](./phase_2/README.md) |
| 2 | Game concept & gameplay rules | [phase_1/01_GAME_CONCEPT_AND_RULES.md](./phase_1/01_GAME_CONCEPT_AND_RULES.md) |
| 3 | 500-level progression, new obstacle/mechanic every 10 levels | [phase_1/02_LEVEL_PROGRESSION_0001_0500.md](./phase_1/02_LEVEL_PROGRESSION_0001_0500.md) (Phase 2 levels: [phase_2/02_LEVEL_PROGRESSION_0501_1000.md](./phase_2/02_LEVEL_PROGRESSION_0501_1000.md)) |
| 4 | How obstacles work & their rules | [phase_1/03_OBSTACLE_CATALOG_PHASE_1.md](./phase_1/03_OBSTACLE_CATALOG_PHASE_1.md) · [phase_2/03_OBSTACLE_CATALOG_PHASE_2.md](./phase_2/03_OBSTACLE_CATALOG_PHASE_2.md) |
| 5 | Hint, Undo, power-ups, coin rewards & Shop | [phase_1/04_BOOSTERS_COINS_SHOP.md](./phase_1/04_BOOSTERS_COINS_SHOP.md) |
| 6 | Daily challenge & 7-day streak | [phase_1/05_DAILY_CHALLENGE_AND_STREAK.md](./phase_1/05_DAILY_CHALLENGE_AND_STREAK.md) |
| 7 | All screens incl. Home, Gameplay, Shop, Level Map | [phase_1/06_UI_UX_SCREENS.md](./phase_1/06_UI_UX_SCREENS.md) |
| 8 | 500 → 10,000 content & scalability planning | [SCALING_TO_10000_LEVELS.md](./SCALING_TO_10000_LEVELS.md) |
| 9 | Frontend implementation rules & testing checklist | [phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md](./phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) |
| 10 | Sound effects | [../SOUND_EFFECTS_IMPLEMENTATION.md](../SOUND_EFFECTS_IMPLEMENTATION.md) (Yarn theme mapping: §9) · game mapping: [phase_1/07](./phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) |
| 11 | Logging & error tracking | [../LOGGING_AND_ERROR_TRACKING.md](../LOGGING_AND_ERROR_TRACKING.md) · game error table: [phase_1/07](./phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) |

## 7. Themed Names (used identically in every file)

| Generic | Yarn Unravel |
|---|---|
| Path / head | Thread / Needle |
| Exit / Bump | Unravel / Snag |
| Hint · Undo · Shield · Hammer | Needle Glow Hint · Seam Ripper Undo · Thimble Shield · Golden Scissors |
| Path Preview | Thread Peek |
| Gift Box · Phase Chest · Coin Rush · Lucky Spin | Craft Basket · Grand Sewing Chest · Golden Bobbin Rush · Spinning Wheel |
| Daily Challenge · Streak Saver · Streak Trophy | Daily Stitch · Darning Patch · Thimble Trophy |
| Currency | Coins |
| Mascot (decoration only) | Purl the kitten |

Mechanic names M001–M049: [phase_1/03 §2](./phase_1/03_OBSTACLE_CATALOG_PHASE_1.md).

## 8. v3 Changes (old docs vs this spec)

1. **One title:** "Yarn Unravel: Cozy Thread Puzzle" (old docs used "Yarn Jam! ASMR Unravel", "Yarn Unravel: Cozy Wool & Stitch Puzzles" and "Yarn Unravel & Wool Threads").
2. **Undo added** (Seam Ripper Undo). Old docs said "No Undo button"; standard requires Undo.
3. **Booster set fixed** to the standard 4: the non-standard "Spinning Bobbin Magnet" (auto-pull 3 threads) removed; "Path Radar" is now the free Thread Peek, not a booster. Caps and prices from the standard.
4. **Revive rule fixed:** ad revive once per **level** (old text said "once per level attempt" — contradictory); Heart Refill 120 Coins only inside Second Chance, max 2/attempt (old: bought from Shop).
5. **Mechanic schedule fixed:** new mechanic at every x1 level (11, 21 … 491) with standard IDs M001–M049; old catalog had irregular intro levels (18, 26, 34, 42 …) and 50+ loosely defined obstacles.
6. **No real-time rules:** old obstacles with wall-clock timing (swinging gauge "every 2 seconds", presser foot "for 5 seconds", rhythmic shears, rotary-cutter timer, 50% slow-down patch) removed. All counters are Move-based; Coin Rush is the only timer.
7. **No over/under weaving:** old "thread pressed under another thread" collision idea replaced with explicit Layer mechanics (M015 Stitch Bridge, M032 Double Fabric Layers).
8. **Board shape:** rectangular craft board instead of a round/oval embroidery hoop (a square grid cannot fit a hoop without clipping); min cell 29 dp on 360 dp phones.
9. **Economy aligned:** Gift Box 150–300 by range + `(L/10) mod 4` booster; Coin Rush max 300–400 (old: 200–500); VIP ₹20/month auto-renewing, never "permanent".
10. **Removed unsourced metrics** (D1 ≥ 52%, D7 ≥ 24%, ARPU, "8.5 minutes session"); FTUE times are now analytics targets plus deterministic Move limits.
11. **Docs reorganised:** duplicate copies (root vs phase_1), a V2 blueprint that described another game's theme, and Phase 2 files mixed into Phase 1 were removed; one doc per topic, relative links only (no `file:///`).
12. **Compliance added:** neutral age gate, UMP consent, Families policy, spin odds disclosure.
13. **QA checklist** with IDs and all statuses "Not run" (no pre-filled Pass marks).

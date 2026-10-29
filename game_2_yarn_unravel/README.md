# Yarn Unravel: Cozy Thread Puzzle — Design Spec Overview
> Purpose: Game 2 ની આખી specification નો overview — pitch, audience, USP, tech, key numbers, folder map, required topics નું coverage matrix અને v3 માં શું સુધાર્યું.

**Related docs:** [./VFX_IMPLEMENTATION.md](./VFX_IMPLEMENTATION.md) · [./SHARED_CORE_STANDARD.md](./SHARED_CORE_STANDARD.md) (rules & numbers — single source of truth) · [../README.md](../README.md) (4-game hub) · [./SOUND_EFFECTS_IMPLEMENTATION.md](./SOUND_EFFECTS_IMPLEMENTATION.md) · [./LOGGING_AND_ERROR_TRACKING.md](./LOGGING_AND_ERROR_TRACKING.md) · [./phase/README.md](./phase/README.md) · [./phase/phase_1/README.md](./phase/phase_1/README.md) · [./phase/phase_2/README.md](./phase/phase_2/README.md) · [./SCALING_TO_10000_LEVELS.md](./SCALING_TO_10000_LEVELS.md)

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
Flutter 3.x / Dart 3 (Impeller), `CustomPainter` + Ticker loop, `flutter_bloc`, shared pure-Dart engine `packages/puzzle_core`, `hive_ce`, AdMob + UMP, `in_app_purchase` + Firebase Function receipt check, Firebase Analytics/Crashlytics/Remote Config, `games_services`; Android 8.0+ / iOS 14+, portrait. Details: [phase_1/07](./phase/phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md).

## 4. Key Numbers

| Topic | Value |
|---|---|
| Hearts | 3 per attempt (max 3); bump (snag) −1 |
| Revive | Rewarded ad +1 Heart **once per level** · Heart Refill **120 Coins**, max **2 per attempt** (Second Chance only) |
| Stars | ★★★ 0 lost · ★★ 1 lost · ★ 2+ lost or any revive |
| Needle Glow Hint (Hint) | unlock L3 · cap 3/attempt · 60 / 3-pack 150 |
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
| Phase 1 (Launch) | 1–500 | M001–M049 + L500 Finale | [phase_1/](./phase/phase_1/README.md) |
| Phase 2 | 501–1000 | onboarding 501–510 + M051–M099 + L1000 Finale + LiveOps | [phase_2/](./phase/phase_2/README.md) |
| Phase 3 | 1001–1500 | Day & Night Loom (Cycles) + M101–M104 + L1500 Finale | [phase_3/](./phase/phase_3/README.md) |
| Phase 4 | 1501–2000 | Sewing Room Floors (Multi-Floor) + M151–M154 + L2000 Finale | [phase_4/](./phase/phase_4/README.md) |
| Phase 5 | 2001–2500 | Crate Workshop (Push Physics+) + M201–M204 + L2500 Finale | [phase_5/](./phase/phase_5/README.md) |
| Phase 6 | 2501–3000 | Lamplight Atelier (Light & Beams+) + M251–M254 + L3000 Finale | [phase_6/](./phase/phase_6/README.md) |
| Phase 7 | 3001–3500 | Turning Table (Rotation) + M301–M304 + L3500 Finale | [phase_7/](./phase/phase_7/README.md) |
| Phase 8 | 3501–4000 | Garden Knitting (Growth) + M351–M354 + L4000 Finale | [phase_8/](./phase/phase_8/README.md) |
| Phase 9 | 4001–4500 | Ply & Twist (Split & Merge) + M401–M404 + L4500 Finale | [phase_9/](./phase/phase_9/README.md) |
| Phase 10 | 4501–5000 | Pattern Book (Sequencing) + M451–M454 + L5000 Finale | [phase_10/](./phase/phase_10/README.md) |
| Phase 11 | 5001–5500 | Twin Hoops (Linked Boards) + M501–M504 + L5500 Finale | [phase_11/](./phase/phase_11/README.md) |
| Phase 12 | 5501–6000 | Hanging Loom (Gravity) + M551–M554 + L6000 Finale | [phase_12/](./phase/phase_12/README.md) |
| Phase 13 | 6001–6500 | Mystery Basket (Hidden Info) + M601–M604 + L6500 Finale | [phase_13/](./phase/phase_13/README.md) |
| Phase 14 | 6501–7000 | Looking-Glass Quilt (Mirror Worlds) + M651–M654 + L7000 Finale | [phase_14/](./phase/phase_14/README.md) |
| Phase 15 | 7001–7500 | Feed Dog Factory (Conveyors & Tracks) + M701–M704 + L7500 Finale | [phase_15/](./phase/phase_15/README.md) |
| Phase 16 | 7501–8000 | Jewel Box (Keys Deluxe) + M751–M754 + L8000 Finale | [phase_16/](./phase/phase_16/README.md) |
| Phase 17 | 8001–8500 | Pincushion Court (Guardians) + M801–M804 + L8500 Finale | [phase_17/](./phase/phase_17/README.md) |
| Phase 18 | 8501–9000 | Remix A (Phases 1–6 Synergy) + M851–M854 + L9000 Finale | [phase_18/](./phase/phase_18/README.md) |
| Phase 19 | 9001–9500 | Remix B (Phases 7–12 Synergy) + M901–M904 + L9500 Finale | [phase_19/](./phase/phase_19/README.md) |
| Phase 20 | 9501–10,000 | Grand Master (The Endless Tapestry) + M951–M954 + L10,000 Grand Finale | [phase_20/](./phase/phase_20/README.md) |

## 5. Folder Map
`
game_2_yarn_unravel/
├── README.md                          ← this file (overview + coverage matrix)
├── SCALING_TO_10000_LEVELS.md         500 → 10,000 levels plan (Phases 3–20)
├── specs/                             ← Phase 1 SDD specifications (12 files)
└── phase/                             ← Master container for all 20 phases (10,000 levels)
    ├── README.md                      ← Master Phase Index (P1–P20 complete catalog)
    ├── phase_1/                       ← Launch: Levels 1–500 (README + 7 numbered docs)
    ├── phase_2/                       ← Levels 501–1000 + LiveOps (README + Phase 2 docs)
    ├── phase_3/ … phase_17/           ← Levels 1001–8500 (7 standardized docs per phase)
    ├── phase_18/                      ← Levels 8501–9000: Remix A (P1–P6 Systems Fusion)
    ├── phase_19/                      ← Levels 9001–9500: Remix B (P7–P12 Systems Fusion)
    └── phase_20/                      ← Levels 9501–10,000: Grand Master & L10000 Finale
```

Shared (repo root, બધી games માટે): [./SHARED_CORE_STANDARD.md](./SHARED_CORE_STANDARD.md) · [./SOUND_EFFECTS_IMPLEMENTATION.md](./SOUND_EFFECTS_IMPLEMENTATION.md) · [./LOGGING_AND_ERROR_TRACKING.md](./LOGGING_AND_ERROR_TRACKING.md)

## 6. Coverage Matrix (required topics)

| # | Required topic | Covered in |
|---|---|---|
| 1 | Whole-spec overview | **This file** · [phase/README.md](./phase/README.md) · [phase_1/README.md](./phase/phase_1/README.md) · [phase_2/README.md](./phase/phase_2/README.md) · [phase_3/README.md](./phase/phase_3/README.md) · [phase_4/README.md](./phase/phase_4/README.md) · [phase_5/README.md](./phase/phase_5/README.md) · [phase_6/README.md](./phase/phase_6/README.md) · [phase_7/README.md](./phase/phase_7/README.md) · [phase_8/README.md](./phase/phase_8/README.md) · [phase_9/README.md](./phase/phase_9/README.md) · [phase_10/README.md](./phase/phase_10/README.md) · [phase_11/README.md](./phase/phase_11/README.md) · [phase_12/README.md](./phase/phase_12/README.md) · [phase_13/README.md](./phase/phase_13/README.md) · [phase_14/README.md](./phase/phase_14/README.md) · [phase_15/README.md](./phase/phase_15/README.md) · [phase_16/README.md](./phase/phase_16/README.md) · [phase_17/README.md](./phase/phase_17/README.md) · [phase_18/README.md](./phase/phase_18/README.md) · [phase_19/README.md](./phase/phase_19/README.md) · [phase_20/README.md](./phase/phase_20/README.md) |
| 2 | Game concept & gameplay rules | [phase_1/01_GAME_CONCEPT_AND_RULES.md](./phase/phase_1/01_GAME_CONCEPT_AND_RULES.md) |
| 3 | 500-level progression, new obstacle/mechanic every 10 levels | [phase_1/02_LEVEL_PROGRESSION_0001_0500.md](./phase/phase_1/02_LEVEL_PROGRESSION_0001_0500.md) · [phase_2/02](./phase/phase_2/02_LEVEL_PROGRESSION_0501_1000.md) · [phase_3/02](./phase/phase_3/02_LEVEL_PLAN_1001_1500.md) · [phase_4/02](./phase/phase_4/02_LEVEL_PLAN_1501_2000.md) · [phase_5/02](./phase/phase_5/02_LEVEL_PLAN_2001_2500.md) · [phase_6/02](./phase/phase_6/02_LEVEL_PLAN_2501_3000.md) · [phase_7/02](./phase/phase_7/02_LEVEL_PLAN_3001_3500.md) · [phase_8/02](./phase/phase_8/02_LEVEL_PLAN_3501_4000.md) · [phase_9/02](./phase/phase_9/02_LEVEL_PLAN_4001_4500.md) · [phase_10/02](./phase/phase_10/02_LEVEL_PLAN_4501_5000.md) · [phase_11/02](./phase/phase_11/02_LEVEL_PLAN_5001_5500.md) · [phase_12/02](./phase/phase_12/02_LEVEL_PLAN_5501_6000.md) · [phase_13/02](./phase/phase_13/02_LEVEL_PLAN_6001_6500.md) · [phase_14/02](./phase/phase_14/02_LEVEL_PLAN_6501_7000.md) · [phase_15/02](./phase/phase_15/02_LEVEL_PLAN_7001_7500.md) · [phase_16/02](./phase/phase_16/02_LEVEL_PLAN_7501_8000.md) · [phase_17/02](./phase/phase_17/02_LEVEL_PLAN_8001_8500.md) · [phase_18/02](./phase/phase_18/02_LEVEL_PLAN_8501_9000.md) · [phase_19/02](./phase/phase_19/02_LEVEL_PLAN_9001_9500.md) · [phase_20/02](./phase/phase_20/02_LEVEL_PLAN_9501_10000.md) |
| 4 | How obstacles work & their rules | [phase_1/03_OBSTACLE_CATALOG_PHASE_1.md](./phase/phase_1/03_OBSTACLE_CATALOG_PHASE_1.md) · [phase_2/03_OBSTACLE_CATALOG_PHASE_2.md](./phase/phase_2/03_OBSTACLE_CATALOG_PHASE_2.md) |
| 5 | Hint, Shield, Hammer power-ups, coin rewards & Shop | [phase_1/04_BOOSTERS_COINS_SHOP.md](./phase/phase_1/04_BOOSTERS_COINS_SHOP.md) |
| 6 | Daily challenge & 7-day streak | [phase_1/05_DAILY_CHALLENGE_AND_STREAK.md](./phase/phase_1/05_DAILY_CHALLENGE_AND_STREAK.md) |
| 7 | All screens incl. Home, Gameplay, Shop, Level Map | [phase_1/06_UI_UX_SCREENS.md](./phase/phase_1/06_UI_UX_SCREENS.md) |
| 8 | 500 → 10,000 content & scalability planning | [SCALING_TO_10000_LEVELS.md](./SCALING_TO_10000_LEVELS.md) |
| 9 | Frontend implementation rules & testing checklist | [phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md](./phase/phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) |
| 10 | Sound effects | [./SOUND_EFFECTS_IMPLEMENTATION.md](./SOUND_EFFECTS_IMPLEMENTATION.md) (Yarn theme mapping: §9) · game mapping: [phase_1/07](./phase/phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) |
| 10a | VFX / game feel | [./VFX_IMPLEMENTATION.md](./VFX_IMPLEMENTATION.md) · spec: [specs/ui/vfx-and-juice.md](./specs/ui/vfx-and-juice.md) |
| 11 | Logging & error tracking | [./LOGGING_AND_ERROR_TRACKING.md](./LOGGING_AND_ERROR_TRACKING.md) · game error table: [phase_1/07](./phase/phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) |

## 7. Themed Names (used identically in every file)

| Generic | Yarn Unravel |
|---|---|
| Path / head | Thread / Needle |
| Exit / Bump | Unravel / Snag |
| Hint · Shield · Hammer | Needle Glow Hint · Thimble Shield · Golden Scissors |
| Path Preview | Thread Peek |
| Gift Box · Phase Chest · Coin Rush · Lucky Spin | Craft Basket · Grand Sewing Chest · Golden Bobbin Rush · Spinning Wheel |
| Daily Challenge · Streak Saver · Streak Trophy | Daily Stitch · Darning Patch · Thimble Trophy |
| Currency | Coins |
| Mascot (decoration only) | Purl the kitten |

Mechanic names M001–M049: [phase_1/03 §2](./phase/phase_1/03_OBSTACLE_CATALOG_PHASE_1.md).

## 8. v3 Changes (old docs vs this spec)

1. **One title:** "Yarn Unravel: Cozy Thread Puzzle" (old docs used "Yarn Jam! ASMR Unravel", "Yarn Unravel: Cozy Wool & Stitch Puzzles" and "Yarn Unravel & Wool Threads").
2. **Boosters = standard ના 3:** Hint, Shield, Hammer (+ free Thread Peek). Undo booster નથી.
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

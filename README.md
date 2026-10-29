# 4-Game Path-Clear Puzzle Suite (Flutter)
> ચાર mobile puzzle games ના design + technical documentation નું hub. ચારેય games એક જ shared puzzle engine (`puzzle_core`) પર બને છે અને theme (art, names, sounds) અલગ છે.

**Related docs:** દરેક game folder માં `SHARED_CORE_STANDARD.md` (નિયમો અને numbers નો source of truth) ની પોતાની copy છે

---

## 1. Games

| # | Game | Theme | Folder |
|---|---|---|---|
| 1 | **Snakes Slither** *(working title)* | ક્યૂટ સાપ અને ઇયળો board પરથી સરકીને બહાર નીકળે | [game_1_snakes_slither/](./game_1_snakes_slither/README.md) |
| 2 | **Yarn Unravel: Cozy Thread Puzzle** | ઊનના દોરા craft board પરથી ખેંચીને કાઢવા | [game_2_yarn_unravel/](./game_2_yarn_unravel/README.md) |
| 3 | **Toy Trains: Wooden Railway Puzzle** | લાકડાની toy trains tabletop પરથી બહાર દોડે | [game_3_toy_trains/](./game_3_toy_trains/README.md) |
| 4 | **Ants & Bees: Garden Trails** | કીડીઓ (ground) અને મધમાખીઓ (air) ની લાઇનો બગીચામાંથી બહાર જાય | [game_4_nature_ants_bees/](./game_4_nature_ants_bees/README.md) |

Core loop (ચારેયમાં સરખો): path પર tap → exit lane ખાલી હોય તો path board બહાર જાય. Lane blocked હોય તો bump થાય અને −1 Heart. બધા paths બહાર કાઢો એટલે level clear. વિગત: [SHARED_CORE_STANDARD §2](./SHARED_CORE_STANDARD.md#2-core-gameplay-rules-બધી-games-માં-એકસરખા).

## 2. Folder Structure

```
c:\test\
├── README.md                      ← આ file (hub)
└── game_N_<name>\                 (ચારેય games માં સરખું structure)
    ├── README.md                  (1) Overview + coverage matrix
    ├── SCALING_TO_10000_LEVELS.md (8) 500 → 10,000 levels plan (Phases 3–20)
    ├── SHARED_CORE_STANDARD.md    rules, numbers, mechanics library, phases 3–20, tech stack (game-wise copy)
    ├── SOUND_EFFECTS_IMPLEMENTATION.md  SFX/music engine, event catalog, audio QA (game-wise copy)
    ├── VFX_IMPLEMENTATION.md      VFX/game feel: effect classes, tier limits, VFX QA (game-wise copy)
    ├── LOGGING_AND_ERROR_TRACKING.md  crash/error logging, tap tracking, replay (game-wise copy)
    ├── PERFORMANCE_OPTIMIZATION.md  budgets, device tiers, rendering rules, perf QA (game-wise copy)
    ├── SPLASH_AND_INSTANT_LAUNCH.md  instant launch, native splash, themed intro (game-wise copy)
    ├── CLAUDE.md, PRODUCT_OVERVIEW.md, specs\, .claude\n    ├── phase_1\   Levels 1–500 (Launch)
    │   ├── README.md
    │   ├── 01_GAME_CONCEPT_AND_RULES.md          (2)
    │   ├── 02_LEVEL_PROGRESSION_0001_0500.md     (3)
    │   ├── 03_OBSTACLE_CATALOG_PHASE_1.md        (4)
    │   ├── 04_BOOSTERS_COINS_SHOP.md             (5)
    │   ├── 05_DAILY_CHALLENGE_AND_STREAK.md      (6)
    │   ├── 06_UI_UX_SCREENS.md                   (7)
    │   └── 07_FRONTEND_IMPLEMENTATION_AND_QA.md  (9)
    └── phase_2\   Levels 501–1000 + LiveOps
        ├── README.md
        ├── 01_PHASE_2_SCOPE_AND_RULES.md
        ├── 02_LEVEL_PROGRESSION_0501_1000.md
        ├── 03_OBSTACLE_CATALOG_PHASE_2.md
        ├── 04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md
        ├── 05_OFFLINE_AND_CLOUD_SYNC.md
        └── 06_FRONTEND_AND_QA_PHASE_2.md
```

(1)–(9) = દરેક game માં cover થવા જરૂરી 9 topics: overview, concept & rules, 500-level progression, obstacles, boosters/coins/shop, daily & streak, screens, scaling to 10,000, frontend & QA.

## 3. Phases (દરેક phase = 500 નવા levels)

| Phase | Levels | New content | Extra features |
|---|---|---|---|
| **1 – Launch** | 1–500 | L1–10 clean FTUE. L11 થી દર 10 levels એ 1 નવું mechanic (M001–M049, L11…L491). L500 Phase Finale | 3 boosters (Hint, Shield, Hammer), Shop, Daily Challenge, 7-day Streak, Lucky Spin, Leaderboards (Play Games / Game Center), AdMob + VIP ₹20/month |
| **2** | 501–1000 | L501–510 zoom onboarding. 49 નવા mechanics (M051–M099, L511…L991). L1000 Finale | Sticker Album, Weekly Star Race, Piggy Bank, Cloud Sync, Cosmetic skins |
| **3–20** | 1001–10,000 | દરેક phase: 1 signature system + 4 નવા base mechanics + 45 variants (base × modifier) | On-device seeded generation, CI-validated seeds |

## 4. Key Rules (summary — વિગત shared standard માં)

- **3 Hearts** per attempt. **Revive by ad: level દીઠ 1 વાર** (restart થી reset નહીં). **Heart Refill: 120 coins**, attempt દીઠ max 2.
- **Turn-based:** puzzle માં wall-clock timer નથી. "Timed" obstacles Moves ગણે છે. Exception: Coin Rush bonus round (30 sec).
- દરેક level **0 hearts lost + 0 boosters** થી solvable હોય, અને CI solver તે ચકાસે.
- **Interstitial:** દર 5 wins પર 1. L1–10 માં ક્યારેય નહીં, વચ્ચે min 120 sec, reward screens પર defer.
- **Compliance:** age gate (target 10–50), Families policy, UMP consent.

## 5. v3 Reorganization (2026-10-27)

- Root ના duplicates (`GAME_DESIGN_V2.md`, `FUTURE_ROADMAP_PHASE2.md`, `GAME_X_*.md` copies) અને દરેક folder માં પડેલી byte-identical copies કાઢી નાખી. Snake-themed V2 doc બધી games માં copy થયેલું હતું; તેની જગ્યાએ હવે theme-neutral `SHARED_CORE_STANDARD.md` છે.
- Docs વચ્ચે અલગ-અલગ લખેલા booster names/prices, Shield charges, Day-7 reward, Gift Box coins, revive scope, FTUE timings, obstacle unlock levels અને tier tables, બધું એક જ values માં unify કર્યું.
- બે અલગ obstacle lists (master doc vs catalog) ની જગ્યાએ હવે એક જ mechanics library છે.
- Real-time timer obstacles ને Move-based બનાવ્યા. Forced-damage obstacles દૂર કર્યા.
- Revive exploit બંધ કર્યો. Streak માટે anti-cheat ઉમેર્યું.
- Phase 2 = Levels 501–1000 + LiveOps (પહેલાં "10,000 levels" સીધા Phase 2 માં હતા).
- README ની `file:///` links ને relative links માં બદલી.

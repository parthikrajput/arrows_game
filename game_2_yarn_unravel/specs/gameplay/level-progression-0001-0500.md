Source docs: phase_1/02_LEVEL_PROGRESSION_0001_0500.md, ../../SHARED_CORE_STANDARD.md

# Spec: Level Progression (Levels 0001–0500)

## Status
Draft

## Type
New Feature

## Goal
Define and implement the 500-level progression system, FTUE onboarding sequence (Levels 1–10), 10-level block architecture, tier scaling, milestone reward delivery, and Level 500 Phase Finale for Yarn Unravel Phase 1.

## Current State
Design documented in phase_1/02_LEVEL_PROGRESSION_0001_0500.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- 500 levels bundled locally in `assets/levels/phase_1.json.gz` using level schema v3.
- Progression spans 6 tiers: FTUE, T1, T2, T3, T4, and T5.
- Fixed 10-level block rhythm introducing 49 mechanics on x1 slots (Levels 11, 21 ... 491).
- Hard levels placed on every x9 slot starting at Level 19.
- Craft Basket (Gift Box) awarded on every x0 milestone; Golden Bobbin Rush (Coin Rush) triggered every 25 levels; Grand Sewing Chest awarded at Level 500.

## Proposed Change
Implement the level progression repository, tier pacing, tutorial overlays, and milestone triggers:

### 1. Tier Architecture & Limits
| Tier | Level Range | Grid Bounds | Threads (Paths) | Max Obstacles | Difficulty (D) Band |
|---|---|---|---|---|---|
| **FTUE** | 1–3 | 4×4 – 5×5 | 2–4 | 0 | 1–4 |
| **FTUE** | 4–10 | 5×5 – 6×6 | 4–8 | 0 | 3–8 |
| **T1** | 11–100 | 6×6 – 8×8 | 6–14 | 1–4 | 6–18 |
| **T2** | 101–200 | 7×7 – 9×9 | 10–18 | 3–6 | 14–26 |
| **T3** | 201–300 | 8×8 – 10×10 | 14–22 | 4–8 | 22–36 |
| **T4** | 301–400 | 9×9 – 10×10 | 18–26 | 5–9 | 30–44 |
| **T5** | 401–500 | 10×10 – 11×11 | 22–30 | 6–10 | 38–52 |

- **Difficulty Metric:** `D = 0.6*P + 1.5*C + 2.0*O + 3.0*N + 1.0*S`
  - `P`: Thread count
  - `C`: Crossing / overlap points (Layer mechanics)
  - `O`: Total obstacle instances
  - `N`: Count of distinct mechanic types
  - `S`: Minimal solver steps required
- **CI Validation:** Any level generated with D falling outside slot target band `[D_min - 3, D_max + 3]` is rejected.

### 2. The 10-Level Block Pattern
Every block of 10 levels (`N1` to `N0`) strictly adheres to this cadence:
- **x1 (Intro):** Introduces the new mechanic in isolation (plus at most 1 earlier familiar mechanic). D target is band low. Displays Purl tutorial hand and card. Map node carries "NEW" ribbon. Tag: `normal`, slot: `intro`.
- **x2–x4 (Practice):** Mixes new mechanic with earlier mechanics. Increasing path count. Tag: `normal`, slot: `practice`.
- **x5 (Breather):** Low difficulty board with mostly unobstructed pull lanes. Tag: `easy` (15 clear coins), slot: `breather`.
- **x6–x8 (Ramp):** High-density boards ramping difficulty toward band high. Tag: `normal`, slot: `ramp`.
- **x9 (Hard):** Peak difficulty for the block (`band_high * 1.10`). Hand-crafted layout. Tag: `hard` (30 clear coins), slot: `hard`. Level map displays prominent red "Hard" badge and warning card prior to launch. (First Hard level is L19; L9 retains `normal` tag).
- **x0 (Milestone):** Balanced milestone board. Win triggers Craft Basket (Gift Box) popup. Tag: `normal`, slot: `milestone`.

### 3. FTUE Onboarding Sequence (Levels 1–10)
- **Design Constraint:** Optimal solution requires <= 4 moves for L1–3, <= 8 moves for L4–10. Zero obstacles. No ad banners. Zero interstitial ads.
- **Level 1 (4x4, 2 threads):** Two straight non-crossing threads. Tutorial step `tap_thread`: Purl paw points to thread; "Tap a thread to pull it out!"
- **Level 2 (4x4, 3 threads):** Thread B blocks Thread A's exit lane. Tutorial step `order_matters`: Thread A highlights; "Clear the way first".
- **Level 3 (5x5, 4 threads):** One L-shaped bent thread. Tutorial step `hint_intro`: Unlocks Needle Glow Hint; grants 3 free Hints; forced first use without consuming inventory.
- **Level 4 (5x5, 4 threads):** 2-deep dependency. Tutorial step `peek_intro`: Introduces Thread Peek; "Hold to Peek: green = clear, red = snag".
- **Level 5 (5x5, 5 threads):** Breather board. Tutorial step `hearts_info`: Tooltip indicates "A snag costs 1 heart" (informational only; no forced snag).
- **Level 6 (5x5, 6 threads):** Long bent threads navigating corners.
- **Level 7 (6x6, 6 threads):** 3-deep dependency chain. Tutorial step `stars_info`: Level Complete card highlights "0 hearts lost = ★★★".
- **Level 8 (6x6, 7 threads):** Crossing lane dependencies.
- **Level 9 (6x6, 8 threads):** FTUE peak test (tagged `normal`).
- **Level 10 (6x6, 8 threads):** FTUE Milestone. Grants first Craft Basket (150 Coins + 1 Hint). Spinning Wheel (Lucky Spin) permanently unlocks on Home screen upon completion.

### 4. Booster Tutorials & Feature Unlocks
- **Level 3:** Needle Glow Hint tutorial (3 free Hints granted).
- **Level 4:** Thread Peek tutorial (free preview tool).
- **Level 10:** First Craft Basket; Spinning Wheel (Lucky Spin) unlocks on Home screen.
- **Level 11:** M001 Wooden Button introduced; gameplay bottom banner ads activate.
- **Level 15:** Thimble Shield tutorial (1 free Shield granted); Daily Stitch mode unlocks; 48-hour Starter Pack offer triggers; first interstitial-eligible win occurs.
- **Level 20:** Craft Basket grants 150 coins + 1 Golden Scissors (held in inventory with button locked "Unlocks at 25").
- **Level 25:** Golden Scissors tutorial (1 free Hammer granted; snips highlighted Wooden Button); first Golden Bobbin Rush triggers upon win.

### 5. Milestone Rewards & Coin Rush Scheduling
- **Craft Basket (Gift Box):** Triggered upon winning every x0 level:
  - Levels 10–100: **150 Coins**
  - Levels 110–200: **180 Coins**
  - Levels 210–300: **210 Coins**
  - Levels 310–400: **250 Coins**
  - Levels 410–490: **300 Coins**
  - Includes 1 rotating booster via formula `(Level / 10) mod 3`: `1 = Hint, 2 = Hammer, 0 = Shield`.
- **Golden Bobbin Rush (Coin Rush):** Inserted immediately after first clear of Levels 25, 50, 75, 100 ... 500 (never on replays). 30-second bonus round awarding 10 coins per thread pulled + 100 full clear bonus. Thread counts scale by tier: T1 20, T2 22, T3 25, T4 28, T5 30.
- **Level 500 Phase Finale ("The Grand Quilt"):** Hand-tuned board featuring Grand Pincushion Guardian (M049) combined with >= 8 distinct Phase 1 mechanics. Clearing awards Grand Sewing Chest: **1,000 Coins + 2 Hints + 2 Shields + 2 Hammers + Phase 1 Master Badge**, followed by the L500 Coin Rush bonus round.

### 6. Progression Persistence (`ProgressCubit`)
- Stores current level, `highestClearedLevel`, stars mapping `starsByLevel: Map<int, int>`, and `adReviveUsed: Map<int, bool>`.
- Offline first; compressed JSON bundle parsed via compute isolate during splash warm-up.

## Affected Files
- `packages/puzzle_core/lib/src/model/level.dart` (to be created)
- `packages/puzzle_core/lib/src/gen/difficulty.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/bloc/progress_cubit.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/data/level_repository.dart` (to be created)
- `apps/yarn_unravel/lib/features/level_map/view/level_map_view.dart` (to be created)

## Risks
- D-formula coefficients must align with actual player completion times across low and high tiers.
- If generator produces an unsolvable configuration, fallback must seamlessly load pre-validated reserve levels.

## Open Questions
- None. Levels 1 to 500 layout, tier boundaries, and milestone rewards match SHARED_CORE_STANDARD.md §9 and §10.


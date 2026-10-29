Source docs: phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md, ../../SHARED_CORE_STANDARD.md

# Spec: Frontend Implementation Architecture and QA

## Status
Draft

## Type
New Feature

## Goal
Implement the Flutter 3.x client application, pure-Dart `packages/puzzle_core` engine package, BLoC state architecture, `CustomPainter` rendering loop, Hive persistence layer, analytics reporting, and the Phase 1 QA validation matrix.

## Current State
Design documented in phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- Pure-Dart engine package `packages/puzzle_core` shared across 4 games (no Flutter dependencies).
- Rendering uses `CustomPainter` with an on-demand `Ticker` game loop (Flame is strictly excluded).
- State management uses `flutter_bloc` (Riverpod is excluded).
- Local persistence uses `hive_ce` with versioned typed adapters.
- Quality assurance framework includes 90+ test cases across rules, economy, ads, performance, and accessibility.

## Proposed Change
Implement the core project architecture and testing harness:

### 1. Project Structure & Architecture
- **Multi-Package Layout:**
  - `packages/puzzle_core`: Pure Dart. Contains models (`BoardState`, `Cell`, `Snake`, `Move`), rules engine (`Engine`, `MoveResolver`), all 49 mechanics, BFS/IDA* solver, level generator, `xoshiro128**` PRNG, and difficulty evaluator.
  - `apps/snakes_slither`: Flutter app layer. Features, BLoCs, UI views, renderers, audio, ads, IAP, and persistence.
  - `tools/levelgen` & `tools/validator`: Offline CLI tools for generating and validating level JSON files.
  - `functions`: Firebase Cloud Functions for receipt verification (`verifyPurchase`).

### 2. State Management (`flutter_bloc`)
- `BootstrapCubit`: First-run initialization, age gate evaluation, UMP consent, and save loading.
- `ProgressCubit`: Tracks `highestCleared`, per-level star ratings, and `adReviveUsed` maps.
- `WalletCubit`: Manages gold leaf coin balance and booster inventory (Hint, Shield, Hammer).
- `GameBloc`: Encapsulates single-attempt puzzle state:
  - Events: `LevelStarted`, `SnakeTapped`, `ObstacleTapped`, `AnimationCompleted`, `PreviewStarted`, `PreviewEnded`, `HintRequested`, `ShieldActivated`, `HammerModeToggled`, `HammerTargetSelected`, `ReviveWithAd`, `ReviveWithCoins`, `ReviveDeclined`, `Paused`, `Resumed`, `Restarted`.
  - State: `GameStatus` (intro, playing, animating, hammerTarget, secondChance, won, failed), `BoardState`, `hearts`, `shieldCharges`, `moves`, `heartsLost`, `usedRevive`, `refillsUsed`, `hintTarget`, `queuedTap`.
- `RushBloc`: 30-second bonus round loop and coin accrual.
- `DailyBloc`: Daily board loading, weekday modifier execution, and claim state.
- `StreakCubit`: 7-day streak ladder, Streak Saver Leaf verification, trophy progression.
- `SpinCubit`: Lucky Lily Wheel PRNG execution and prize dispatch.
- `ShopBloc`: IAP catalog loading, purchase flows, receipt verification, and purchase restoration.
- `AdsCubit`: Interstitial cadence counter, cooldown timers, rewarded ad displays, and banner lifecycle.
- `SettingsCubit`: Audio, haptic, language, and accessibility toggles.

### 3. Rendering Pipeline (`CustomPainter` + `Ticker`)
- **On-Demand Ticker:** Ticker runs only when animations are active (`isAnimating == true`). When board is static, Ticker stops completely (0 fps rendered, ~0% CPU).
- **Static Board Cache (`PictureRecorder`):**
  - Grid background, boundaries, static obstacles, and non-moving snakes are recorded into a `ui.Picture` once per Move.
  - Pre-baked soft drop shadows are burned into the static picture (no runtime `MaskFilter.blur` on frames).
- **Dynamic Layer:**
  - Active frame paints only moving snakes, trail particles, and tongue-flick previews.
  - Snake bodies rendered using `buildTrack` and `ui.PathMetric` sampling to achieve smooth bezier/sine-wave slithering wiggles.
  - Transparency uses `Paint()..color = c.withValues(alpha: a)` (avoiding deprecated `withOpacity`).

### 4. Input & Hit-Testing (`BoardView`)
- Combines `TapGestureRecognizer` and `LongPressGestureRecognizer` (configured with 350 ms duration).
- Long-press triggers `onLongPressStart` and claims the gesture arena; releasing a long press does NOT trigger a tap.
- Hit-testing precedence:
  1. Interactive mechanic cells (levers, turntables, rotors).
  2. Upper canopy snakes (in layered M032 levels).
  3. Snake body segments (head, body, or tail).
  4. Nearest snake within 0.5-cell hit-slop.
- Input queue capacity is 1: taps during active animations queue the latest tap only.

### 5. Persistence (`hive_ce`, Schema v1)
- Box `save`: Contains `SaveData` with keys `progress`, `wallet`, `streak`, `time`, `ads`, `iap`, `settings`, and game extensions `ext`.
- Box `save_backup`: Mirror copy written after every successful level win.
- Flush triggered on `AppLifecycleState.paused`.
- In-memory attempt state is never persisted (killing the app restarts the level attempt; `adReviveUsed[level]` remains persisted).

### 6. Analytics Events
- Core minimum events: `level_start`, `level_win`, `level_fail`, `booster_use`, `revive`, `ad_show`, `iap_purchase`, `daily_clear`, `streak_update`, `ftue_step`.
- Game custom events: `coins_earn`, `coins_spend`, `gift_open`, `chest_open`, `rush_end`, `spin_result`, `streak_saver`, `time_lock`, `hint_fail`, `ad_fail`.

### 7. Phase 1 QA Validation Checklist
Initial status for all items is **"Not run"**:
- **Rules Engine:** QA-RULE-01 to QA-RULE-13 (Tap slither, bonk, body tap, locked tap, queue-1, long-press preview, canopy layer priority, win conditions, determinism, Hungry Caterpillar bump, tangled rotation, tick order M007->M017->M031, soft-lock sheet).
- **Hearts & Revives:** QA-HEART-01 to QA-HEART-07 (Second Chance 10s ring, ad revive once per level, refill max 2, revive preserves board state).
- **Star Ratings:** QA-STAR-01 to QA-STAR-04 (0/1/2 lost hearts = 3/2/1 stars, Shield hit preservation, replay improvements).
- **Boosters:** QA-BOOST-HINT-01 to 03, QA-BOOST-SHLD-01 to 03, QA-BOOST-HAMR-01 to 04, QA-BOOST-05 to 06 (Caps, targeting, stone smash, inventory sheets, guided tutorials).
- **Economy:** QA-COIN-01 to 04, QA-GIFT-01 to 03, QA-RUSH-01 to 06, QA-SPIN-01 to 04, QA-SHOP-01 to 02 (Clears, 2X, gift rotations, rush 30s timer, spin odds).
- **Monetization & Ads:** QA-IAP-01 to 03, QA-VIP-01 to 03, QA-ADS-01 to 08, QA-CONS-01 to 03 (Sandbox coin packs, Starter pack, VIP monthly subscription, interstitial 5-win cadence, L1-10 exemption, 120s cooldown, banner 8 dp gap, age gate, UMP consent).
- **Persistence & Offline:** QA-SAVE-01 to 03, QA-OFF-01 to 02 (Crash recovery, backup restore, schema migrations, offline gameplay).
- **Performance:** QA-PERF-01 to 04 (60 fps on Redmi 9A 2GB RAM, raster p95 < 8 ms, 120 fps ProMotion, cold start TTID).
- **Mechanics Suite:** QA-MECH-M001 to QA-MECH-M049 (Unit test cases in `puzzle_core` and intro level play for every mechanic).
- **Finale & End-to-End:** QA-FIN-01 (Level 500 Mongoose King Finale resolution).

## Affected Files
- `apps/snakes_slither/lib/main.dart` (to be created)
- `apps/snakes_slither/lib/app/app.dart` (to be created)
- `apps/snakes_slither/lib/app/router.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/render/board_painter.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/render/snake_renderer.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/render/game_scene.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/input/board_view.dart` (to be created)
- `apps/snakes_slither/lib/data/save/save_data.dart` (to be created)
- `apps/snakes_slither/lib/data/save/migrations.dart` (to be created)
- `packages/puzzle_core/lib/puzzle_core.dart` (to be created)

## Risks
- Impeller shader compilation vs image decode jank: assets must be precached via `precacheImage` before route navigation.
- Vulkan support on Android: older devices without Vulkan will fall back to OpenGL ES; performance must be validated on low-tier reference devices.

## Open Questions
- None. The stack, BLoC hierarchy, rendering architecture, and QA checklist align with SHARED_CORE_STANDARD §13–§15.

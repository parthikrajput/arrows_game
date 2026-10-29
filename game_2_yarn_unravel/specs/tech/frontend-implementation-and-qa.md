Source docs: phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md, ../../SHARED_CORE_STANDARD.md

# Spec: Frontend Implementation Architecture and QA

## Status
Draft

## Type
New Feature

## Goal
Implement the Flutter 3.x client application, pure-Dart `packages/puzzle_core` engine package, BLoC state architecture, `CustomPainter` rendering loop, Hive persistence layer, analytics reporting, and the Phase 1 QA validation matrix for Yarn Unravel.

## Current State
Design documented in phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- Pure-Dart engine package `packages/puzzle_core` shared across 4 games (zero Flutter dependencies).
- Rendering uses `CustomPainter` with an on-demand `Ticker` game loop (Flame is strictly excluded).
- State management uses `flutter_bloc` (Riverpod is excluded).
- Local persistence uses `hive_ce` with versioned typed adapters.
- Quality assurance framework includes 90+ test cases across rules, economy, ads, performance, and accessibility.

## Proposed Change
Implement the core project architecture and testing harness:

### 1. Project Structure & Architecture
- **Multi-Package Layout:**
  - `packages/puzzle_core`: Pure Dart. Contains models (`BoardState`, `Cell`, `ThreadPath`, `Move`), rules engine (`Engine`, `MoveResolver`), all 49 mechanics, BFS/IDA* solver, level generator, `xoshiro128**` PRNG, and difficulty evaluator. Zero Flutter imports.
  - `apps/yarn_unravel`: Flutter app layer. Features, BLoCs, UI views, custom renderers, audio, ads, IAP, and persistence.
  - `tools/levelgen` & `tools/validator`: Offline CLI tools for generating and validating level JSON files.
  - `functions`: Firebase Cloud Functions for receipt verification (`verifyPurchase`).

### 2. State Management (`flutter_bloc`)
- `BootstrapCubit`: First-run initialization, age gate evaluation, UMP consent, and save loading.
- `ProgressCubit`: Tracks `highestCleared`, per-level star ratings, and `adReviveUsed` maps.
- `WalletCubit`: Manages gold coin balance and booster inventory (Needle Glow Hint, Thimble Shield, Golden Scissors).
- `GameBloc`: Encapsulates single-attempt puzzle state:
  - Events: `LevelStarted`, `ThreadTapped`, `ObstacleTapped`, `AnimationCompleted`, `PreviewStarted`, `PreviewEnded`, `HintRequested`, `ShieldActivated`, `HammerModeToggled`, `HammerTargetSelected`, `ReviveWithAd`, `ReviveWithCoins`, `ReviveDeclined`, `Paused`, `Resumed`, `Restarted`.
  - State: `GameStatus` (intro, playing, animating, hammerTarget, secondChance, won, failed), `BoardState`, `hearts`, `shieldCharges`, `moves`, `heartsLost`, `usedRevive`, `refillsUsed`, `hintTarget`, `queuedTap`.
- `RushBloc`: 30-second Golden Bobbin Rush bonus round loop and coin accrual.
- `DailyBloc`: Daily Stitch board loading, weekday modifier execution, and claim state.
- `StreakCubit`: 7-day streak ladder, Darning Patch verification, Thimble Trophy progression.
- `SpinCubit`: Spinning Wheel PRNG execution and prize dispatch.
- `ShopBloc`: IAP catalog loading, purchase flows, receipt verification, and purchase restoration.
- `AdsCubit`: Interstitial cadence counter, cooldown timers, rewarded ad displays, and banner lifecycle.
- `SettingsCubit`: Audio, haptic, language, and accessibility toggles.

### 3. Rendering Pipeline (`CustomPainter` + `Ticker`)
- **On-Demand Ticker:** Ticker runs only when animations are active (`isAnimating == true`). When board is static, Ticker stops completely (0 fps rendered, ~0% CPU).
- **Static Board Cache (`PictureRecorder`):**
  - Birch wood frame, cream linen background cloth, cross-stitch grid dots, static obstacles, and non-moving threads are recorded into a `ui.Picture` once per Move.
  - Pre-baked soft drop shadows are burned into the static picture (no runtime `MaskFilter.blur` on frames).
- **Dynamic Layer:**
  - Active frame paints only moving threads, trail particles, and Thread Peek chain-stitch previews.
  - Thread unspooling rendered using `PathMetric.extractPath` to smoothly unravel along the needle's trajectory around corners.
  - Snag animation uses ease-forward followed by decaying spring oscillation.
  - Transparency uses `Paint()..color = c.withValues(alpha: a)` (avoiding deprecated `withOpacity`).

### 4. Input & Hit-Testing (`BoardView`)
- Combines `TapGestureRecognizer` and `LongPressGestureRecognizer` (configured with 350 ms duration).
- Long-press triggers `onLongPressStart` and claims the gesture arena; releasing a long press does NOT trigger a tap.
- Hit-testing precedence:
  1. Interactive obstacles (levers, spinners, switches, rotors).
  2. Upper layer thread on layered cells (M015 Stitch Bridge, M032 Double Fabric Layers).
  3. Thread body segment.
  4. Nearest cell within 0.5-cell hit slop.
- Input queue capacity is 1: maximum 1 tap queued during active animation; surplus taps are discarded.

### 5. Persistence (`hive_ce`)
- Saves stored locally using versioned typed adapters:
  - `SaveProgress`: `highestCleared`, `starsByLevel`, `adReviveUsed`, `phaseChestClaimed`.
  - `SaveWallet`: `coins`, `hints`, `shields`, `hammers`.
  - `SaveStreak`: `currentStreak`, `lastCompletedDate`, `lastClaimedDate`, `longestStreak`, `trophyTier`.
  - `SaveSettings`: `sfxEnabled`, `musicEnabled`, `hapticsEnabled`, `language`, `reduceMotion`, `batterySaver`.
- Double-buffering file writes to prevent corruption on sudden termination.

### 6. QA Verification Matrix (14 Categories)
- **QA-01 (Engine Rules):** 100% pass on 500 levels in CI validator (solvable with 0 hearts and 0 boosters).
- **QA-02 (Deterministic Move Resolution):** State transitions match Step 1 to 7 sequence identically.
- **QA-03 (Snag & Hearts):** Bump snags thread, consumes 1 heart, triggers 120 ms red pulse and damped "twang".
- **QA-04 (Second Chance):** 10s countdown ring triggers at 0 hearts; ad revive works once per level; Heart Refill capped at 2.
- **QA-05 (Boosters):** Hint glows next move; Shield absorbs 2 hits; Golden Scissors removes target without lane traversal side effects.
- **QA-06 (Economy):** Coin inflow and outflow match table; Gift Basket grants correct rotating booster `(L/10) mod 3`.
- **QA-07 (Ads):** No interstitials in L1–10; 120s cooldown enforced; deferred on reward screens.
- **QA-08 (Performance):** 60 fps on Low Tier (Redmi 9A, 2 GB RAM); static board consumes ~0% CPU.
- **QA-09 (Accessibility):** Color-blind patterns distinct; 48 dp touch targets verified; text scaling to 1.3x verified.
- **QA-10 (Compliance):** Neutral age gate blocks tracking for under-13 players; UMP consent flow operational.

## Affected Files
- `apps/yarn_unravel/lib/main.dart` (to be created)
- `apps/yarn_unravel/lib/app.dart` (to be created)
- `apps/yarn_unravel/lib/router.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/render/yarn_board_painter.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/render/needle_painter.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/data/save_repository.dart` (to be created)
- `tools/validator/bin/validate_levels.dart` (to be created)

## Risks
- Impeller shader compilation must be pre-warmed during native splash handoff to eliminate first-tap shader hitching.
- Thread `PathMetric` calculations must be cached per moving thread to avoid redundant path slicing on 60 fps frames.

## Open Questions
- None. Architecture and QA guidelines match SHARED_CORE_STANDARD.md §12–§15.


Source docs: ../../SPLASH_AND_INSTANT_LAUNCH.md, phase_1/06_UI_UX_SCREENS.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Splash and Instant Launch ("Hearth & Thread")

## Status
Draft

## Type
New Feature

## Goal
Implement instant application startup for Yarn Unravel with zero loading screens, native Android/iOS system splash handoff, and the game-themed "Hearth & Thread" Flutter intro animation, achieving Time-To-Interactive <= 600 ms on mid-tier devices.

## Current State
Design documented in ../../SPLASH_AND_INSTANT_LAUNCH.md, phase_1/06, and phase_1/07, not yet implemented.
- Old pattern of a Flutter loading route with a progress bar is abolished.
- System draws initial pixels immediately via Android 12 SplashScreen API and iOS `LaunchScreen.storyboard`.
- Flutter first frame IS Home (or Age Gate on fresh install).
- "Hearth & Thread" intro animation plays on top of a fully laid out, tappable Home screen with 0 ms added to interactivity.
- Full intro runs 1,200 ms on the day's first cold start; short intro runs 450 ms thereafter; 150 ms crossfade for Reduce Motion.

## Proposed Change
Implement the native startup components, early engine initialization, and the "Hearth & Thread" intro engine:

### 1. Launch Budgets
| Metric | Low Tier (Redmi 9A, 2 GB) | Mid Tier (Galaxy A14 / Redmi Note 12) | High Tier (Pixel 8 / Galaxy S23) |
|---|---|---|---|
| Tap to First Pixels (System Splash) | System-drawn, immediate | Immediate | Immediate |
| **Cold Start to Home First Frame (TTID)** | **<= 1,200 ms** | **<= 600 ms** | **<= 400 ms** |
| Time to Interactive (TTFD) | = TTID (Home interactive on frame 1) | = TTID | = TTID |
| Warm Start | <= 300 ms | <= 200 ms | <= 150 ms |
| Hot Start | <= 100 ms | <= 100 ms | <= 100 ms |
| Work Before `runApp` (Dart) | <= 80 ms | <= 50 ms | <= 30 ms |
| Interactive Delay from Intro | **0 ms** | **0 ms** | **0 ms** |
| Intro Frame Rate | 60 fps, jank < 1% | 60 fps (90/120 Hz if available) | 120 fps |
| Alarm Threshold | TTID > 1,500 ms -> `W-PERF-004` | > 1,000 ms -> `W-PERF-004` | > 800 ms -> `W-PERF-004` |

### 2. Native Android Launch Architecture (Kotlin)
- **Dependencies:** `androidx.core:core-splashscreen:1.0.1`.
- **System Theme:**
  - `windowSplashScreenBackground`: `@color/splash_bg` (`#3A2A22`, `splashHearth`).
  - `windowSplashScreenAnimatedIcon`: `@drawable/splash_mark` (vector on API 23–30, AVD on API 31+). Duration <= 600 ms.
  - `postSplashScreenTheme`: `@style/Theme.Game.Normal` with identical window background color.
- **AVD Animation (600 ms):** Rose yarn ball with a silver needle through it. Loose strand wiggles (0–250 ms); wrap lines rotate 0° to 30° (150–450 ms); needle glints (400–600 ms).
- **Early Engine Boot (`GameApp.kt`):**
  - Flutter engine is spawned in `Application.onCreate` before `MainActivity` creation.
  - Dart entrypoint executed immediately, passing startup flags in `args`: `tier`, `animatorScale`, `processStartUptimeMs`, `engineStartUptimeMs`.
  - Cached in `FlutterEngineCache` with key `"main"`.
- **Splash Coordination (`MainActivity.kt`):**
  - Calls `installSplashScreen()`. Holds system splash via `setKeepOnScreenCondition` until Flutter reports `flutterUiShown == true` (or safety cap of 4,000 ms triggers `W-PERF-004`).
  - Calls `reportFullyDrawn()` when the first Flutter frame renders.

### 3. Native iOS Launch Architecture (Swift)
- `LaunchScreen.storyboard` configured with background `#3A2A22` and static vector mark.
- `AppDelegate.swift` instantiates `FlutterEngine` during `didFinishLaunchingWithOptions`, pre-warming Dart execution prior to root view presentation.

### 4. Dart Bootstrap Pipeline (`main.dart`)
- **Strict Budget:** Dart code executing prior to `runApp` must complete in <= 50 ms on mid-tier:
  - Step 1: `WidgetsFlutterBinding.ensureInitialized()` (10 ms).
  - Step 2: Initialize `AppLogger` ring buffer (2 ms).
  - Step 3: Initialize Hive and open essential metadata boxes: `settings` and `progress` (25 ms).
  - Step 4: Dispatch `runApp(GameApp())`.
- Deferred Work (async in background after Frame 1):
  - Firebase Analytics, Crashlytics, and Remote Config initialization.
  - Level JSON bundle decompression (`phase_1.json.gz`).
  - Mobile Ads SDK pre-initialization.
  - Sound pool audio sample caching.

### 5. "Hearth & Thread" Intro Animation (Flutter Overlay)
Plays on top of the already interactive Home screen. Tap anywhere or tap Play immediately dismisses/completes the intro.
- **Track Timing & Choreography (1,200 ms Full Intro):**
  - `squash` (0–200 ms): Ball squash (scaleY 1 -> 0.9 -> 1.05) then hop.
  - `roll` (150–750 ms): Rose yarn ball rolls along a bezier curve to the basket on Home, rotating 0° to -540° and shrinking radius from 96 dp to 56 dp.
  - `thread` (150–750 ms): Thread drawn behind the ball (`PathMetric.extractPath`); becomes the stitched underline beneath the logo.
  - `hearth` (200–800 ms): Radial fire glow blooms from bottom center (alpha 0 -> 0.45 -> 0.12).
  - `room` (200–900 ms): Background color transitions from `#3A2A22` (`splashHearth`) to `#FFF9F0` (`bgLinen`).
  - `hoop` (350–600 ms): Decorative embroidery hoop spins into place (rotation -25° to 0°, scale 0.8 to 1).
  - `play` (400–600 ms): Play button "sewn on": drops in (y -40 dp to 0) with crossed stitch strokes; light haptic at 600 ms.
  - `wordmark` (450–950 ms): "Yarn Unravel" drawn as running stitch (dashed outline, needle sprite leading, then filled).
  - `subtitle` (750–1,000 ms): "Cozy Thread Puzzle" fades in.
  - `purl` (800–1,150 ms): Purl's kitten paw pops up from bottom edge, bats the ball (ball wobbles ±6°), drops back.
  - `fluff` (600–1,000 ms): Wool tuft particles drift from thread (0/24/40 by tier; Low = 0).
- **Short Intro (450 ms):** Played on subsequent launches that day: roll + thread (0–400 ms), room color transition (0–400 ms), play button drop (100–300 ms), wordmark fade (150–450 ms). No squash, hearth, hoop spin, Purl paw, or fluff particles.
- **First-Run Behavior:** At 400–600 ms, Age Gate card slides up; thread runs along top edge of card.

## Affected Files
- `apps/yarn_unravel/android/app/src/main/kotlin/.../MainActivity.kt` (to be created)
- `apps/yarn_unravel/android/app/src/main/kotlin/.../GameApp.kt` (to be created)
- `apps/yarn_unravel/android/app/src/main/res/drawable/splash_mark.xml` (to be created)
- `apps/yarn_unravel/ios/Runner/AppDelegate.swift` (to be created)
- `apps/yarn_unravel/lib/features/home/render/hearth_and_thread_intro.dart` (to be created)
- `apps/yarn_unravel/lib/main.dart` (to be created)

## Risks
- Holding the Android 12 SplashScreen for too long triggers an OS warning; `setKeepOnScreenCondition` must timeout safely at 4,000 ms.
- Background glow and running stitch animations must stay strictly within 60 fps budget on low-tier GPUs.

## Open Questions
- None. Token values, choreography, and launch architecture match SPLASH_AND_INSTANT_LAUNCH.md §8.


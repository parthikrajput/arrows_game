Source docs: ../../SPLASH_AND_INSTANT_LAUNCH.md, phase_1/06_UI_UX_SCREENS.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Splash and Instant Launch ("Jungle Dawn")

## Status
Draft

## Type
New Feature

## Goal
Implement instant application startup for Snakes Slither with zero loading screens, native Android/iOS system splash handoff, and the game-themed "Jungle Dawn" Flutter intro animation, achieving Time-To-Interactive <= 600 ms on mid-tier devices.

## Current State
Design documented in ../../SPLASH_AND_INSTANT_LAUNCH.md, phase_1/06, and phase_1/07, not yet implemented.
- Old pattern of a Flutter loading route with a progress bar is abolished.
- System draws initial pixels immediately via Android 12 SplashScreen API and iOS `LaunchScreen.storyboard`.
- Flutter first frame IS Home (or Age Gate on fresh install).
- "Jungle Dawn" intro animation plays on top of a fully laid out, tappable Home screen with 0 ms added to interactivity.
- Full intro runs 1,200 ms on the day's first cold start; short intro runs 450 ms thereafter; 150 ms crossfade for Reduce Motion.

## Proposed Change
Implement the native startup components, early engine initialization, and the "Jungle Dawn" intro engine:

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
  - `windowSplashScreenBackground`: `@color/splash_bg` (`#FF12301F`, `splashCanopy`).
  - `windowSplashScreenAnimatedIcon`: `@drawable/splash_mark` (vector on API 23–30, AVD on API 31+). Duration <= 700 ms.
  - `postSplashScreenTheme`: `@style/Theme.Game.Normal` with identical window background color.
- **Early Engine Boot (`GameApp.kt`):**
  - Flutter engine is spawned in `Application.onCreate` before `MainActivity` creation.
  - Dart entrypoint executed immediately, passing startup flags in `args`: `tier`, `animatorScale`, `processStartUptimeMs`, `engineStartUptimeMs`.
  - Cached in `FlutterEngineCache` with key `"main"`.
- **Splash Coordination (`MainActivity.kt`):**
  - Calls `installSplashScreen()`. Holds system splash via `setKeepOnScreenCondition` until Flutter reports `flutterUiShown == true` (or safety cap of 4,000 ms triggers `W-PERF-004`).
  - Calls `reportFullyDrawn()` when the first Flutter frame renders.
- **Invisible Handoff (`SplashExit.kt`):**
  - On API 31+, fades out system splash over 120 ms while applying a 12 px GPU blur to the native icon, smoothly dissolving into Flutter frame 0.

### 3. Native Animated Vector Drawable (AVD)
- Canvas: 288x288 dp viewport, artwork contained within the central 192 dp circle.
- Silhouette: Pip coiled into a ring with a leaf hat. Outer silhouette remains static while secondary parts animate.
- Timeline (<= 600 ms):
  - 0–200 ms: Eyelids open via path morph.
  - 200–380 ms: Tongue flicks out and back.
  - 300–600 ms: Leaf hat tilts 0° -> -8° -> 0°.
- Rest pose (eyes open, tongue in, hat straight) exactly matches Flutter frame 0.

### 4. Flutter Startup Pipeline (`main()`)
1. **Pre-`runApp` (strictly <= 50 ms):**
   - Parse `LaunchInfo` from arguments.
   - Install buffered error hooks (`AppLogger.installBufferedHooks`).
   - Spawn `Firebase.initializeApp()` without awaiting.
   - Initialize Hive and open ONLY Home-essential boxes (`settings`, `progress`, `wallet`).
   - Resolve `IntroPlan` and execute `runApp(GameApp(intro: intro))`.
2. **Deferred Work Post-Frame 1:**
   - *Stage A (Light, post-frame callback):* Attach Crashlytics to buffered errors; activate cached Remote Config values; listen to IAP purchase stream; record `StartupTrace`.
   - *Stage B (Heavy, runs after intro completes or at 1,500 ms):* UMP consent update; MobileAds initialization and ad preload; Remote Config background fetch (applies next session); Home audio and music preload; silent `games_services` sign-in; next-level data prefetch.

### 5. "Jungle Dawn" Intro Timeline (Game 1)
- **Intro Modes:**
  - *Full (1,200 ms):* Played on fresh install and on the first cold start of each local calendar day (`dayKey`).
  - *Short (450 ms):* Played on subsequent cold starts during the same day. Omits rays, leaf bursts, and letter staggers.
  - *Fade (150 ms):* Clean crossfade from `splashCanopy` to Home when Reduce Motion is enabled.
- **Full Mode Timeline Tracks (1,200 ms):**
  - `uncoil` (0–380 ms): Pip's coiled body unrolls into an S-curve, travelling along a pre-built vector track to Pip's perch beside the logo (`easeInOutCubic`).
  - `canopyFront` (120–700 ms): Front deep-green foliage splits and slides off-screen left and right (`easeInOutCubic`).
  - `canopyMid` (160–760 ms): Mid-canopy foliage slides outward with parallax (`easeInOutCubic`).
  - `dawn` (200–900 ms): Background color transitions from `splashCanopy` (`#12301F`) to `bgSage` (`#E8F5E9`).
  - `rays` (350–1,000 ms): 3 diagonal sunbeams sweep across the scene with additive blending.
  - `play` (380–600 ms): Primary Play button pops in at its final position (`easeOutBack`). Light haptic pulse at 600 ms.
  - `leafBurst` (600–900 ms): Burst of green leaf particles erupts from the Play button (12/24/40 particles by tier).
  - `wordmark` (420–820 ms): "SNAKES SLITHER" letters pop in with 30 ms stagger.
  - `subtitle` (700–1,000 ms): Localized tagline fades into position.
  - `settle` (900–1,200 ms): Pip blinks; ambient dew sparkles glint on leaves.
- **First Run Behavior:**
  - Full intro runs; at 380–600 ms, the Age Gate card slides up from the bottom instead of the Play button. Pip perches atop the card.

### 6. Interactive Tap Catcher & Skip Mechanics
- `IntroTapCatcher` covers the viewport while the intro runs:
  - Any tap during the intro calls `intro.skip()`, accelerating the animation to its conclusion within 120 ms.
  - If a tap lands within the **final bounding rectangle** of the Play button, it immediately registers and launches the next level without losing the user's action.
  - Android Back button during intro accelerates to end state rather than exiting the application.

### 7. Jank Guard
- `SchedulerBinding.instance.addTimingsCallback` inspects the first 5 frames of the intro.
- If any frame takes > 50 ms total span, the intro immediately aborts into skip mode (settles within 120 ms) and logs warning `W-PERF-005` with device tier and frame timings.

### 8. Splash QA Checklist
All items initialized with status **"Not run"**:
- SPL-01: Cold start from launcher displays system splash immediately with zero white/black flashes.
- SPL-02: Cold start TTID measured within budgets across low, mid, and high reference devices.
- SPL-03: Warm and hot starts restore Home in <= 300 ms without replaying intro.
- SPL-04: Frame 0 screenshot matches system splash screenshot within 1 dp position and 2% scale.
- SPL-05: Native splash handoff executes 120 ms fade with GPU blur on API 31+.
- SPL-06: Full "Jungle Dawn" intro follows timeline timings and lands on exact Home layout.
- SPL-07: Second cold start of the day plays the 450 ms short intro without particles.
- SPL-08: Tapping Play button at 100 ms, 300 ms, or 600 ms launches the level without lost taps.
- SPL-09: Tapping elsewhere or pressing Back skips intro in <= 120 ms without exiting app.
- SPL-10: First run ends intro on Age Gate; UMP consent form displays only after Age Gate submission.
- SPL-11: OS "Remove animations" or in-game Reduce Motion triggers 150 ms fade mode.
- SPL-12: Airplane mode cold start matches online launch timings.
- SPL-13: Logcat verifies Remote Config fetch, ads, audio, and leaderboards defer past frame 1.
- SPL-14: Low-tier intro achieves 60 fps with jank < 1% and particles clamped to <= 12.
- SPL-15: 120 Hz displays render intro at 120 fps with identical total duration.
- SPL-16: Simulated startup delay triggers jank guard skip and logs `W-PERF-005`.
- SPL-17: Backgrounding app at 300 ms and resuming immediately jumps to Home end state.
- SPL-18: Rotating or resizing during intro completes intro and relayouts Home.
- SPL-19: Corrupt save file restores backup and displays notification after intro completes.
- SPL-20: Exceptions thrown in first 200 ms are buffered and transmitted to Crashlytics.
- SPL-21: System status/nav icons start light on dark canopy and transition to dark on sage.
- SPL-22: Photosensitivity review confirms zero regions flashing > 3 times per second.
- SPL-23: Gujarati and Hindi subtitles render correctly under vector wordmark.
- SPL-24: Intro painter is disposed after 1,200 ms; idle Home produces 0 extra frames.

## Affected Files
- `apps/snakes_slither/android/app/src/main/kotlin/com/studio/snakesslither/GameApp.kt` (to be created)
- `apps/snakes_slither/android/app/src/main/kotlin/com/studio/snakesslither/MainActivity.kt` (to be created)
- `apps/snakes_slither/android/app/src/main/kotlin/com/studio/snakesslither/SplashExit.kt` (to be created)
- `apps/snakes_slither/android/app/src/main/res/drawable-v31/splash_mark.xml` (to be created)
- `apps/snakes_slither/lib/intro/intro_controller.dart` (to be created)
- `apps/snakes_slither/lib/intro/intro_timeline.dart` (to be created)
- `apps/snakes_slither/lib/intro/game_intro_painter.dart` (to be created)
- `apps/snakes_slither/lib/intro/intro_tap_catcher.dart` (to be created)
- `tools/intro/svg_to_dart.dart` (to be created)

## Risks
- Vector path extraction: vector SVG conversion to Dart paths must exactly mirror Android vector drawable coordinates.
- System bar theme switching: contrast of status bar icons must cleanly flip when background luminance transitions from dark green to light sage.

## Open Questions
- None. Launch architecture, Android Kotlin integration, and "Jungle Dawn" timeline are defined in SPLASH_AND_INSTANT_LAUNCH.md.

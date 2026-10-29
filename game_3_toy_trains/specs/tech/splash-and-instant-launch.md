Source docs: ../../SPLASH_AND_INSTANT_LAUNCH.md, phase_1/06_UI_UX_SCREENS.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Splash and Instant Launch ("Toy Box Lid") (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Implement instant application startup for Toy Trains with zero loading screens, seamless native Android/iOS system splash handoff, and the themed "Toy Box Lid" ("All Aboard") Flutter intro animation, achieving Time-To-Interactive <= 600 ms on mid-tier hardware.

## Current State
Design documented in ../../SPLASH_AND_INSTANT_LAUNCH.md, phase_1/06, and phase_1/07, not yet implemented.
- Old pattern of a Flutter loading route with a progress bar is eliminated.
- System renders initial pixels immediately via Android 12 SplashScreen API and iOS `LaunchScreen.storyboard`.
- Flutter first frame IS Home (or Age Gate on fresh install).
- "Toy Box Lid" intro plays directly on top of a fully laid-out, interactive Home screen with 0 ms added to time-to-interactive.
- Full intro runs 1,200 ms on the day's first cold start; short intro runs 450 ms thereafter; 150 ms crossfade for Reduce Motion.

## Proposed Change
Implement the native startup components, early engine initialization, and the "Toy Box Lid" intro engine:

### 1. Launch Budgets
| Metric | Low Tier (Redmi 9A, 2 GB) | Mid Tier (Galaxy A14) | High Tier (Pixel 8 / S23) |
|---|---|---|---|
| Tap to First Pixels (System Splash) | System-drawn, immediate | Immediate | Immediate |
| **Cold Start to Home First Frame (TTID)** | **<= 1,200 ms** | **<= 600 ms** | **<= 400 ms** |
| Time to Interactive (TTFD) | = TTID (interactive frame 1) | = TTID | = TTID |
| Warm Start | <= 300 ms | <= 200 ms | <= 150 ms |
| Hot Start | <= 100 ms | <= 100 ms | <= 100 ms |
| Work Before `runApp` (Dart) | <= 80 ms | <= 50 ms | <= 30 ms |
| Interactive Delay from Intro | **0 ms** | **0 ms** | **0 ms** |
| Intro Frame Rate | 60 fps, jank < 1% | 60 fps (90/120 Hz) | 120 fps |
| Alarm Threshold | TTID > 1,500 ms -> `W-PERF-004` | > 1,000 ms -> `W-PERF-004` | > 800 ms -> `W-PERF-004` |

### 2. Native Launch Architecture
- **Android Implementation (Kotlin):**
  - Dependency: `androidx.core:core-splashscreen:1.0.1`.
  - System Theme:
    - `windowSplashScreenBackground`: `@color/splash_toybox` (`#FF2B2118`).
    - `windowSplashScreenAnimatedIcon`: `@drawable/splash_train_mark` (AVD on API 31+). Duration <= 700 ms.
    - `postSplashScreenTheme`: `@style/Theme.ToyTrains.Normal` matching the honey-oak table color.
  - Early Engine Boot (`ToyTrainsApp.kt`):
    - Flutter engine initialized in `Application.onCreate` prior to `MainActivity` launch.
    - Dart entrypoint spawned with arguments: `tier`, `animatorScale`, `processStartUptimeMs`.
  - Seamless Handoff (`MainActivity.kt`):
    - System splash held until Flutter dispatches `flutterUiShown == true`.
    - Native view fades out smoothly over 120 ms with a 12 px blur onto Flutter Frame 0.

### 3. Native Animated Vector Drawable (AVD) (<= 700 ms)
- Viewport: 288×288 dp, mark centered inside a 192 dp circle.
- Artwork: Red wooden locomotive in 3/4 perspective with brass dome and cowcatcher.
- Timeline:
  - 0–700 ms: Wheels (3 spoke sets) rotate 0° to 360°.
  - 100–500 ms: Steam puff expands and fades above chimney.
  - 450–700 ms: Brass headlamp illuminates and settles.

### 4. Flutter "Toy Box Lid" Intro Timeline
- **Design Tokens:**
  - `splashToyBox`: `#2B2118` (dark wooden lid interior)
  - `lidWood`: `#6B4A33` (beveled lid edge)
  - `engineRed`: `#D84315` (locomotive paint)
  - `brass`: `#C9A227` (metallic shimmer)
  - `steam`: `#FFFFFF` (steam particles)
  - `signalGreen`: `#43A047` (signal lamp)
  - `tableOak`: `#F3E9DC` (Home tabletop background)
  - `ctaGreen`: `#2E7D32` (Play button)

- **Full Intro Animation (1,200 ms):**
  1. **`chug` (0–200 ms):** Engine rolls back slightly (-6 dp) and puffs steam (`Curves.easeOutCubic`).
  2. **`lid` (0–600 ms):** Dark wooden lid swings up and outward (perspective `Matrix4.identity()..setEntry(3, 2, 0.0012)..rotateX(-1.745 rad)`, `Curves.easeInOutCubic`), revealing the playmat.
  3. **`table` (100–700 ms):** Background canvas transitions from `splashToyBox` to `tableOak`.
  4. **`ties` (150–850 ms):** 24 track ties pop into place ahead of engine, spaced 22 ms apart with scale pop (`Curves.easeOutBack`).
  5. **`drive` (200–850 ms):** Engine scales down (1.0 -> 0.45) and drives along track into its Home hero position, coupling 3 trailing carriages (`Curves.easeInOutCubic`).
  6. **`steam` (200–1,000 ms):** Continuous steam puffs trail the engine (12/24/40 particles by tier, 450 ms life).
  7. **`play` (400–600 ms):** Station signal arm drops (0° to 45°) and lamp turns green on Play button; triggers `HapticFeedback.lightImpact` at 600 ms.
  8. **`blocks` (600–950 ms):** Carriages drop 9 wooden letter blocks spelling "TOY TRAINS" that hop into place with squash and stretch (`Curves.easeOutBack`, 25 ms stagger).
  9. **`subtitle` (800–1,050 ms):** "Wooden Railway Puzzle" subtitle fades up into position.
  10. **`shimmer` (900–1,200 ms):** Brass specular light sweep passes across the title wordmark.

- **Short Intro (450 ms):** Subsequent cold starts the same day skip ties, steam, and shimmer: lid swings open (0–350 ms), engine arrives (0–400 ms), and Play signal drops (100–300 ms).
- **First Run Flow:** Intro terminates with the engine resting beside the Age Gate dialog, where the green signal lamp rests on the Continue button.

### 5. Input Interactivity & Jank Guard
- `IntroTapCatcher` intercepts touches during active intro:
  - Tapping anywhere immediately skips the intro (fast-forwards to end state within 120 ms).
  - If tap lands inside the Play button's target bounds, it registers the click and launches the next level without delay.
- **Jank Guard:** `SchedulerBinding` observes the first 5 frames. If any frame spans > 50 ms, the intro automatically aborts to end state and logs `W-PERF-005`.

## Affected Files
- `apps/toy_trains/android/app/src/main/kotlin/com/example/toytrains/ToyTrainsApp.kt` (to be created)
- `apps/toy_trains/android/app/src/main/kotlin/com/example/toytrains/MainActivity.kt` (to be created)
- `apps/toy_trains/lib/features/intro/intro_controller.dart` (to be created)
- `apps/toy_trains/lib/features/intro/toy_box_intro_painter.dart` (to be created)
- `apps/toy_trains/lib/features/intro/intro_tap_catcher.dart` (to be created)

## Risks
- Matrix4 perspective calculations on older Mali GPUs causing clip errors; validated using bounding box clamps.

## Open Questions
- None. Timelines, tokens, and native handoff match SPLASH_AND_INSTANT_LAUNCH.md.

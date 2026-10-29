Source docs: SPLASH_AND_INSTANT_LAUNCH.md, SHARED_CORE_STANDARD.md

# Spec: Instant Launch Pipeline and "Garden Flight" Intro

## Status
Draft

## Type
New Feature

## Goal
Implement the zero-loading instant launch sequence, native Android/iOS system splash handoff, and the "Garden Flight" animated brand intro for Ants & Bees: Garden Trails Phase 1.

## Current State
Design documented in SPLASH_AND_INSTANT_LAUNCH.md and SHARED_CORE_STANDARD.md, not yet implemented.
- Eliminates traditional loading screens with progress bars.
- Uses Android 12+ `SplashScreen` API and iOS `LaunchScreen.storyboard` for instantaneous frame-0 rendering.
- "Garden Flight" intro animates the mark, parting grass, a flying bee with nectar sparkles, and 8 marching ants into the Home screen.
- Deferred startup ensures no blocking network requests (Firebase, AdMob, UMP) delay initial rendering.

## Proposed Change
Implement the native platform configurations and Dart intro pipeline in `apps/ants_bees/lib/intro/`:

### 1. Platform Native Splash (Frame 0)
- **Background Color:** Dark Garden Green `#1B5E20`.
- **Mark:** Centered vector mark of worker ant and honeybee facing each other within a 192 dp circular boundary.
- **Android (`MainActivity.kt`):**
  - Integrated via `androidx.core.splashscreen.SplashScreen`.
  - Holds system splash on screen until `onFlutterUiDisplayed()` callback triggers.
  - 120 ms native exit transition with alpha fade to Flutter Frame 0.
- **iOS (`LaunchScreen.storyboard`):**
  - Uses static vector PDF matching Android splash coordinates and `#1B5E20` background.
  - Seamless handoff to Flutter Frame 0 without blank frame or flicker.

### 2. "Garden Flight" Themed Motion Intro
The intro sequence transforms the launch mark into the active Home screen:

#### A. Full Intro (1,200 ms — First Cold Start of the Day)
| Track | Timing (ms) | Animation Details | Easing |
|---|---|---|---|
| `handoff` | 0–120 | Frame 0 matches system splash; native splash fades into Flutter canvas | linear |
| `grassFront` | 100–800 | Front garden blades scale (1.0 → 1.6) and part left/right (±60% screen width), fading out | easeInOutCubic |
| `grassMid` | 150–850 | Mid grass layer parts with slower parallax (scale 1.0 → 1.3, alpha 1 → 0). Skipped on Low tier | easeInOutCubic |
| `lawn` | 200–900 | Background transitions from dark green `#1B5E20` to soft sunny lawn gradient `#81C784` | easeInOutCubic |
| `sunSweep` | 250–1,000 | Warm golden sunlight sweep from top-right corner (max alpha 0.3) | linear |
| `flight` | 250–950 | Bee launches from mark, flying a lazy S-curve across the screen. Leaves nectar sparkle trail (12/24/40 particles by tier, life 400 ms) | easeInOutCubic |
| `play` | 400–600 | A golden honey drop falls from top screen and splats into the Play button, popping it into place. Light haptic at 600 ms | easeIn (drop), easeOutBack (button) |
| `wordmark` | 450–950 | "Ants & Bees" letters pop in with 28 ms stagger (scale 0.6 → 1.0, y +20 dp → 0) | easeOutBack |
| `ants` | 500–1,050 | 8 worker ants march in single-file from the left along a dotted path below the title | easeOutCubic |
| `subtitle` | 700–1,000 | "Garden Trails" localized subtitle fades in | easeOutCubic |
| `dewGlints` | 900–1,200 | 6 tiny morning dew glints shimmer on lawn tiles (Mid/High tier only) | easeOutCubic |

#### B. Short Intro (450 ms — Subsequent Starts Same Day)
Triggered when `lastFullIntroDayKey == today`:
- Grass parts in 350 ms; lawn background transitions in 400 ms.
- Play button swells into place in 100–300 ms (no falling drop).
- Wordmark fades and rises in 150–450 ms; ants appear in place under subtitle.
- All particle systems, sun sweeps, and dew glints are omitted.

#### C. First Run (Fresh Install)
- Honey drop falls onto the Continue button of the Neutral Age Gate dialog instead of the Play button.
- Ants march along the top edge of the Age Gate card.

### 3. User Interruptibility & Skip Rules
- **Tap Play Button:** Tapping the Play button at any time during intro (e.g. at 200 ms or 500 ms) immediately skips the remaining intro and opens the current level.
- **Tap Elsewhere / Back Button:** Immediately rushes intro animation to completion within <= 120 ms.
- **OS Accessibility:** If "Reduce Motion" or "Remove animations" is enabled in system settings, intro is replaced by a 150 ms crossfade directly to Home.

### 4. Startup Performance Budgets
| Metric | Low Tier | Mid Tier | High Tier |
|---|---|---|---|
| **TTID (Time to Initial Display)** | <= 1,200 ms | <= 800 ms | <= 400 ms |
| **TTFD (Time to Fully Interactive)** | <= 2,200 ms | <= 1,600 ms | <= 1,200 ms |
| **Memory Spike during Intro** | <= 40 MB | <= 60 MB | <= 80 MB |
| **Intro Jank Ratio** | < 1.0% | < 0.5% | < 0.1% |

### 5. Deferred Startup Architecture (Stage B)
To meet startup budgets, the following services are deferred until after the first frame:
- Firebase Analytics, Crashlytics, and Remote Config fetch.
- AdMob SDK initialization and UMP consent check.
- Audio engine and SFX asset preloading.
- Platform leaderboards (`games_services`) login.

## Affected Files
- `apps/ants_bees/android/app/src/main/kotlin/com/studio/game/MainActivity.kt` (to be modified)
- `apps/ants_bees/ios/Runner/LaunchScreen.storyboard` (to be created)
- `apps/ants_bees/lib/intro/garden_flight_intro.dart` (to be created)
- `apps/ants_bees/lib/intro/gen/splash_paths.g.dart` (generated path vector)
- `apps/ants_bees/lib/core/startup/startup_tracer.dart` (to be created)

## Risks
- Android 12 SplashScreen icon masking can clip custom marks if not formatted strictly to the central 192 dp circular viewport.

## Open Questions
- None. Intro tracks, timings, and budgets conform to SPLASH_AND_INSTANT_LAUNCH.md §10.

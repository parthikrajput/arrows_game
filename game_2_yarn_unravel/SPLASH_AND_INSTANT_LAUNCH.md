# Splash & Instant Launch (all 4 games)

> Game-wise copy for **Yarn Unravel** (`game_2_yarn_unravel`). This file lives in this game folder and is the version used here. The same document exists in the other three game folders; when a shared rule or number changes, update all four copies. Links to other games point to the sibling game folders.

> How each game opens straight from the launcher icon to a playable Home screen with **no loading screen and no waiting**, while still giving a premium, animated first impression. One shared launch pipeline (native Android in Kotlin + Flutter) and **4 game-themed splash intros** with full timelines.

**Related docs:** [SHARED_CORE_STANDARD.md §13](./SHARED_CORE_STANDARD.md#13-shared-tech-stack-ચારેય-games) (stack) · [PERFORMANCE_OPTIMIZATION.md §2, §8](./PERFORMANCE_OPTIMIZATION.md#8-app-startup) (budgets, startup order — updated to match this doc) · [LOGGING_AND_ERROR_TRACKING.md](./LOGGING_AND_ERROR_TRACKING.md) (`W-PERF-` codes) · [SOUND_EFFECTS_IMPLEMENTATION.md](./SOUND_EFFECTS_IMPLEMENTATION.md) · each game's `phase_1/06_UI_UX_SCREENS.md` (Home layout = intro end state)

**Precedence:** launch budgets and the startup order in this doc replace the old "Splash / Loading screen" specs and the "cold start ≤ 3 s" budgets. If another doc still describes a loading screen with a progress bar, this doc wins.

---

## 1. Goal and the Core Idea

### 1.1 Why the game takes 2–3 s to open today
The current specs build a **Flutter loading screen** that waits for work before showing Home:

| Current spec | What blocks Home |
|---|---|
| Game 1 [07 §7.1](../game_1_snakes_slither/phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) | Firebase init + **Remote Config fetch with a 3 s timeout** before Home |
| Game 2 [06 §6](./phase/phase_1/06_UI_UX_SCREENS.md) | Remote Config fetch (≤ 2 s timeout), level pack decompress, audio pool, ads preload, all behind a progress bar |
| Games 1–4 `06` Splash sections | Progress bar + "≤ 2.5–3 s target", i.e. the splash is designed to *last* until loading finishes |
| [PERFORMANCE §8](./PERFORMANCE_OPTIMIZATION.md#8-app-startup) | `await Firebase.initializeApp()` before `runApp` |

On top of that, the native launch screen, the Flutter splash route and Home are three separate screens, so the player sees a static icon, then a progress bar, then Home.

### 1.2 The new rule: the splash never waits
1. **There is no loading screen.** The Flutter splash/loading route and its progress bar are deleted.
2. **The first Flutter frame *is* Home** (or the Age Gate on first run). Everything Home needs is small local data, read in ≤ 50 ms before `runApp`.
3. **The splash animation is a transition into Home, not a wait before it.** Home is laid out and tappable from its first frame. The intro animates Home's own elements into place on top of it.
4. **Nothing on the network, ads or audio runs before the first frame.** All of it starts after the first frame, and the heavy parts start after the intro ends.
5. **The system draws the first pixels.** The Android starting window (system splash) appears the moment the icon is tapped, before our process has even finished starting. That's the "within milliseconds" part. The only thing between it and Home is Flutter engine boot, which is what the native work in §4 makes as short as possible.

### 1.3 What "instant" honestly means
A cold start of any Flutter app has a floor: the process must start and the engine must load the compiled Dart code. It can't be 0 ms. What we guarantee:

- **Tap → first pixels:** immediate (system-drawn splash, independent of our code).
- **Tap → Home first frame (cold):** the budgets in §2; no step of ours adds wait on top of engine boot.
- **Intro animation:** adds **0 ms** to time-to-interactive. Taps during the intro are never lost (§5.5).
- **Warm / hot starts** (app already in memory): Home is back within one or a few frames; no intro plays.

---

## 2. Launch Budgets

Measured on release builds (`flutter build appbundle --release`), installed from the AAB, launched from the launcher.

| Metric | Low tier (Redmi 9A class, Android 10) | Mid tier (Galaxy A14 / Redmi Note 12) | High tier (Pixel 8 / Galaxy S23) | How to measure |
|---|---|---|---|---|
| Tap → first pixels (system splash) | System-drawn, no app work | same | same | Visual check (§13 SPL-01) |
| **Cold start → Home first frame (TTID)** | **≤ 1,200 ms** | **≤ 600 ms** | **≤ 400 ms** | Macrobenchmark `StartupTimingMetric` (§12.2), `adb shell am start -W` |
| Home interactive (TTFD) | = TTID (Home is interactive on its first frame) | = TTID | = TTID | `reportFullyDrawn()` (§4.5) |
| Warm start (process alive, activity recreated) | ≤ 300 ms | ≤ 200 ms | ≤ 150 ms | Macrobenchmark `StartupMode.WARM` |
| Hot start (activity in background) | ≤ 100 ms | ≤ 100 ms | ≤ 100 ms | Macrobenchmark `StartupMode.HOT` |
| Work before `runApp` (Dart) | ≤ 80 ms | ≤ 50 ms | ≤ 30 ms | `StartupTrace` marks (§12.1) |
| Wait added by the intro | **0 ms** | 0 ms | 0 ms | By design (§5.5), checked by SPL-08 |
| Intro frame rate | 60 fps, jank < 1% | 60 fps (90/120 Hz where available) | 120 fps on 120 Hz | `FrameTiming` (§12.1) |
| Field alarm | Cold TTID p75 > 1,500 ms ⇒ `W-PERF-004` | > 1,000 ms ⇒ `W-PERF-004` | > 800 ms ⇒ `W-PERF-004` | Firebase Performance `app_start` |

These are targets to verify on the device matrix, not measured values. Before implementing, record a baseline of the current build with the same tools (§12.2) so the gain can be shown.

---

## 3. Launch Pipeline

### 3.1 Cold start (process not running)
```
t=0   Tap icon
      │ System draws starting window: game splash colour + animated icon (AVD, API 31+)
      │ ── in parallel ─────────────────────────────────────────────────────────────
      │ Process start ─► GameApp.onCreate (Kotlin)
      │                    • compute LaunchInfo (tier, animator scale, process start time)
      │                    • create FlutterEngine, run Dart main(args)  ◄── Dart starts early
      │                  MainActivity.onCreate
      │                    • installSplashScreen(), keep splash until Flutter's first frame
      │ Dart main():  open Hive (Home data only) ─► pick IntroPlan ─► runApp(Home)
      ▼
TTID  Flutter first frame = intro frame 0 (looks identical to the system splash)
      │ Kotlin exit animation: system splash view fades out over 100–150 ms (invisible handoff)
      │ Flutter intro plays on top of a live, tappable Home (full 1,200 ms / short 450 ms)
      │ DeferredInit stage A starts (light work)
      ▼
+1.2 s Intro ends ─► DeferredInit stage B (consent, ads, Remote Config fetch, audio, sign-in)
```

### 3.2 Other start types
| Start type | What the player sees | Intro |
|---|---|---|
| **First run** (fresh install) | System splash ⇒ full intro ⇒ intro ends on the **Age Gate** card instead of the Play button | Full |
| **Cold, first cold start of the local day** | System splash ⇒ full intro ⇒ Home | Full (1,200 ms) |
| **Cold, later the same day** | System splash ⇒ short intro ⇒ Home | Short (450 ms) |
| **Cold, reduce motion** (OS "Remove animations", animator scale 0, or in-game Reduce Motion) | System splash ⇒ 150 ms crossfade ⇒ Home | Fade |
| **Warm** (process alive, engine cached) | Android 12+ may show the system splash for a moment; it fades in 100 ms over the already-running Home | None (Dart state survived; `main()` doesn't rerun) |
| **Hot** | App returns to its last screen, no splash | None |
| **Launched into a level** (resume from `sessionResume`) | Same as cold; intro ends on Home, resume prompt appears after the intro | Per row above |

"Local day" uses the same `dayKey` function as the Daily Challenge. The last full-intro day is saved in `settings.lastFullIntroDayKey` (new save field, §5.3).

---

## 4. Native Android (Kotlin)

Native code does four jobs only: the **system splash** (colour + animated icon), **starting the Flutter engine early**, **holding the splash until Flutter's first frame**, and the **invisible handoff** from the system splash to Flutter. The intro itself runs in Flutter, because Home is a Flutter screen: animating Home's own widgets avoids a second native layer over the `FlutterView`, which would double the compositing cost and make the two layers drift out of sync.

### 4.1 Dependencies (`android/app/build.gradle.kts`)
```kotlin
android {
    compileSdk = 35
    defaultConfig {
        minSdk = 23
        targetSdk = 35
    }
}

dependencies {
    implementation("androidx.core:core-splashscreen:1.0.1")
}
```
`core-splashscreen` gives the Android 12 splash API on all supported versions. On API 23–30 the icon is shown static; the animated icon (AVD) plays on API 31+.

### 4.2 Theme and colours (`android/app/src/main/res/values/`)
`colors.xml` (one value per game, see each game's section; no `values-night` override, so the splash looks the same in dark mode):
```xml
<resources>
    <!-- Game 1: splashCanopy. Game 2: splashHearth. Game 3: splashToyBox. Game 4: bgMoss -->
    <color name="splash_bg">#FF12301F</color>
</resources>
```
`themes.xml`:
```xml
<resources>
    <style name="Theme.Game.Starting" parent="Theme.SplashScreen">
        <item name="windowSplashScreenBackground">@color/splash_bg</item>
        <item name="windowSplashScreenAnimatedIcon">@drawable/splash_mark</item>
        <item name="windowSplashScreenAnimationDuration">700</item>
        <item name="postSplashScreenTheme">@style/Theme.Game.Normal</item>
    </style>

    <style name="Theme.Game.Normal" parent="@android:style/Theme.Black.NoTitleBar">
        <!-- Same colour as the splash, so nothing flashes between the splash and Flutter's first frame -->
        <item name="android:windowBackground">@color/splash_bg</item>
        <item name="android:statusBarColor">@android:color/transparent</item>
        <item name="android:navigationBarColor">@android:color/transparent</item>
        <item name="android:windowLightStatusBar">false</item>
    </style>
</resources>
```
- `drawable/splash_mark.xml` = static vector (API 23–30). `drawable-v31/splash_mark.xml` = animated vector (API 31+). Both come from the same SVG (§4.7).
- `windowSplashScreenAnimationDuration` is informational on API 33+ (the AVD's own duration is used). Keep the AVD ≤ 700 ms.

### 4.3 Manifest
```xml
<application
    android:name=".GameApp"
    android:label="@string/app_name"
    android:icon="@mipmap/ic_launcher">

    <activity
        android:name=".MainActivity"
        android:exported="true"
        android:launchMode="singleTop"
        android:theme="@style/Theme.Game.Starting"
        android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
        android:hardwareAccelerated="true"
        android:windowSoftInputMode="adjustResize">
        <intent-filter>
            <action android:name="android.intent.action.MAIN" />
            <category android:name="android.intent.category.LAUNCHER" />
        </intent-filter>
    </activity>

    <!-- Moves Mobile Ads SDK start-up work off the main thread -->
    <meta-data
        android:name="com.google.android.gms.ads.flag.OPTIMIZE_INITIALIZATION"
        android:value="true" />
    <meta-data
        android:name="com.google.android.gms.ads.flag.OPTIMIZE_AD_LOADING"
        android:value="true" />
</application>
```
Remove from the Flutter template: the `io.flutter.embedding.android.NormalTheme` meta-data (`postSplashScreenTheme` replaces it) and any `io.flutter.embedding.android.SplashScreenDrawable` meta-data (deprecated). Remove the `flutter_native_splash` package if it was added.

### 4.4 Start the engine early (`GameApp.kt`)
The Flutter engine is created in `Application.onCreate`, and Dart `main()` starts right away. Dart then opens Hive and builds Home **while** Android is still creating the activity and its window. The system splash is already on screen by then, so this doesn't delay the first pixels.

```kotlin
package com.studio.game

import android.app.ActivityManager
import android.app.Application
import android.content.Context
import android.os.Build
import android.os.Process
import android.os.SystemClock
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class GameApp : Application() {
    override fun onCreate() {
        super.onCreate()
        val engine = FlutterEngine(this)
        engine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault(),
            LaunchInfo.toDartArgs(this),
        )
        FlutterEngineCache.getInstance().put(ENGINE_ID, engine)
    }

    companion object {
        const val ENGINE_ID = "main"
    }
}

object LaunchInfo {
    /** Passed to Dart `main(List<String> args)`; no platform-channel round trip needed before the first frame. */
    fun toDartArgs(context: Context): List<String> {
        val am = context.getSystemService(ActivityManager::class.java)
        val memory = ActivityManager.MemoryInfo().also { am.getMemoryInfo(it) }
        val totalGb = memory.totalMem / (1024.0 * 1024.0 * 1024.0)
        // Same rule as PERFORMANCE_OPTIMIZATION §3.2
        val tier = when {
            am.isLowRamDevice || totalGb <= 3.0 -> "low"
            totalGb <= 6.0 -> "mid"
            else -> "high"
        }
        val animatorScale = Settings.Global.getFloat(
            context.contentResolver, Settings.Global.ANIMATOR_DURATION_SCALE, 1f,
        )
        val processStart = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) Process.getStartUptimeMillis() else -1L
        return listOf(
            "tier=$tier",
            "animatorScale=$animatorScale",
            "processStartUptimeMs=$processStart",
            "engineStartUptimeMs=${SystemClock.uptimeMillis()}",
        )
    }
}
```
- The tier passed here is used on first run only. After that, the tier saved in Hive (including any runtime demotion, PERFORMANCE §3.2) wins.
- If a background component (push receiver, WorkManager job) is added later, start the engine only when the process starts for an activity, so a background wake-up doesn't boot Flutter for nothing.

### 4.5 Hold the splash until Flutter's first frame (`MainActivity.kt`)
```kotlin
package com.studio.game

import android.animation.ValueAnimator
import android.os.Build
import android.os.Bundle
import android.os.SystemClock
import android.util.Log
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private var flutterUiShown = false
    private var createdAt = 0L

    override fun onCreate(savedInstanceState: Bundle?) {
        val splash = installSplashScreen()          // must run before super.onCreate
        super.onCreate(savedInstanceState)
        createdAt = SystemClock.uptimeMillis()

        splash.setKeepOnScreenCondition {
            val waited = SystemClock.uptimeMillis() - createdAt
            if (!flutterUiShown && waited > SAFETY_CAP_MS) {
                Log.w(TAG, "W-PERF-004 first Flutter frame not ready after ${waited} ms")
            }
            !flutterUiShown && waited <= SAFETY_CAP_MS
        }
        splash.setOnExitAnimationListener { provider ->
            SplashExit.play(provider, reduceMotion = !animatorsEnabled())
        }
    }

    override fun getCachedEngineId(): String = GameApp.ENGINE_ID

    override fun onFlutterUiDisplayed() {
        super.onFlutterUiDisplayed()
        flutterUiShown = true
        reportFullyDrawn()                          // Home is interactive on its first frame
    }

    private fun animatorsEnabled(): Boolean =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) ValueAnimator.areAnimatorsEnabled() else true

    private companion object {
        const val TAG = "Launch"
        const val SAFETY_CAP_MS = 4_000L
    }
}
```
- **Safety cap:** if Dart hasn't drawn after 4 s (a bug, not a normal path), the splash is released anyway. The window behind it has the same colour, so the player sees no break, and the problem is logged as `W-PERF-004`.
- With a cached engine, `FlutterActivity` doesn't destroy the engine when the activity is destroyed. A warm start reuses it, so Dart state (and Home) is already there.
- Launch from the **launcher** when testing. Android 12+ skips the splash icon when an app is started from Android Studio or `adb` without the launcher intent.

### 4.6 The handoff (`SplashExit.kt`)
Flutter's first frame is drawn to look identical to the system splash (same colour, same mark, same position and size, §5.10). So the handoff is just a short fade of the system splash view. On API 31+ the native icon also softens with a GPU blur as it fades, so even a slight mismatch reads as a deliberate dissolve.

```kotlin
package com.studio.game

import android.animation.ValueAnimator
import android.graphics.RenderEffect
import android.graphics.Shader
import android.os.Build
import android.view.animation.DecelerateInterpolator
import androidx.core.splashscreen.SplashScreenViewProvider

object SplashExit {
    private const val HANDOFF_MS = 120L
    private const val REDUCED_MS = 150L
    private const val MAX_BLUR_PX = 12f

    fun play(provider: SplashScreenViewProvider, reduceMotion: Boolean) {
        val duration = if (reduceMotion) REDUCED_MS else HANDOFF_MS
        provider.view.animate()
            .alpha(0f)
            .setDuration(duration)
            .setInterpolator(DecelerateInterpolator())
            .withEndAction { provider.remove() }
            .start()

        if (!reduceMotion && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val icon = provider.iconView
            ValueAnimator.ofFloat(0f, MAX_BLUR_PX).apply {
                this.duration = duration
                addUpdateListener { animator ->
                    val radius = animator.animatedValue as Float
                    icon.setRenderEffect(
                        if (radius > 0f) RenderEffect.createBlurEffect(radius, radius, Shader.TileMode.CLAMP) else null,
                    )
                }
                start()
            }
        }
    }
}
```
The exit animation **never waits for the AVD to finish**. Each AVD is designed so its silhouette stays the same throughout (only eyes, wings, wheels or steam move, §7–§10), so cutting it at any frame looks clean.

### 4.7 Animated icon (AVD) rules
| Rule | Value |
|---|---|
| Canvas | 288 × 288 dp viewport, no icon background. All artwork inside the centre **192 dp circle** (Android 12 rule; anything outside is masked) |
| Duration | ≤ 700 ms, plays once, ends on the **rest pose** = the frame Flutter draws as intro frame 0 |
| Silhouette | Outer shape must not change during the animation (only secondary parts move) |
| Colours | Solid fills only; no gradients that need `aapt:attr` bitmaps; ≤ 6 colours |
| Size | ≤ 20 KB XML, ≤ 300 path nodes |
| Flashing | No more than 3 flashes per second (photosensitivity); players are 10+ |
| Source | One SVG per game: `assets/brand/splash_mark.svg`. AVD made in Shape Shifter or Android Studio Vector Asset; static `splash_mark.xml` = the rest pose |

Example skeleton (game 4 wings, `drawable-v31/splash_mark.xml`):
```xml
<animated-vector xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:aapt="http://schemas.android.com/aapt">
    <aapt:attr name="android:drawable">
        <vector android:width="288dp" android:height="288dp"
            android:viewportWidth="288" android:viewportHeight="288">
            <group android:name="wing_left" android:pivotX="132" android:pivotY="128">
                <path android:fillColor="#E6FFFFFF" android:pathData="M132,128 C110,96 92,104 100,124 C106,138 124,136 132,128 Z" />
            </group>
            <!-- body, stripes, sunflower ... (rest pose) -->
        </vector>
    </aapt:attr>
    <target android:name="wing_left">
        <aapt:attr name="android:animation">
            <objectAnimator android:propertyName="rotation"
                android:duration="40" android:repeatCount="13" android:repeatMode="reverse"
                android:valueFrom="0" android:valueTo="-28" />
        </aapt:attr>
    </target>
</animated-vector>
```

### 4.8 Kept out of native, on purpose
| Not done natively | Why |
|---|---|
| Custom native intro view over the `FlutterView` | Two renderers would have to stay frame-synced; adds a compositing layer; Home widgets can't be the intro's end state |
| Lottie / video splash | Lottie JSON parse and video decoder start-up cost 50–300 ms on low tier, exactly the time we're removing |
| `Thread.sleep` / minimum display time | Never. The splash leaves as soon as Flutter can draw |
| Waiting on Firebase, Remote Config, ads or consent in Kotlin | Same reason; all deferred (§5.2) |

---

## 5. Flutter Side

### 5.1 `main()`
```dart
Future<void> main(List<String> args) async {
  final launch = LaunchInfo.parse(args);
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.installBufferedHooks();                 // errors kept in a ring buffer until Crashlytics is ready
  final firebaseReady = Firebase.initializeApp(     // started, not awaited
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await openHomeBoxes();                            // only what Home shows: settings, progress, wallet
  final intro = IntroPlan.resolve(launch, SettingsRepo.current, DateTime.now());
  runApp(GameApp(launch: launch, intro: intro));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    StartupTrace.firstFrame(launch);
    DeferredInit.run(firebaseReady: firebaseReady, introDone: intro.done);
  });
}
```
- **Before `runApp`, allowed:** Hive init, opening the boxes Home reads, save migrations that change Home-visible fields (≤ 50 ms; larger migrations run after the intro), reading `LaunchInfo`.
- **Before `runApp`, forbidden:** any `await` on Firebase, Remote Config, network, ads, consent, IAP queries, audio loading, level pack decode, image decoding, font loading, `games_services`.
- `AppLogger.installBufferedHooks()` sets `FlutterError.onError` and `PlatformDispatcher.instance.onError` right away and buffers records; when `firebaseReady` completes, the buffer is flushed to Crashlytics. No crash in the first second is lost.
- Avoid large top-level `final` initialisers and big `const` tables that run at isolate start; build them lazily.

### 5.2 Deferred start-up work
| Stage | Starts | Work |
|---|---|---|
| **A** (light) | Post-frame callback of the first frame | Attach Crashlytics when `firebaseReady` completes · Remote Config `activate()` of last fetched values (no fetch) · IAP `purchaseStream` listener (pending purchases) · `StartupTrace` report |
| **B** (heavy) | `introDone` **or** 1,500 ms after first frame, whichever comes first | UMP `requestConsentInfoUpdate` (form shown only after the intro, never over it) · then `MobileAds.instance.initialize()` and ad preload · Remote Config `fetchAndActivate()` in background (values apply next session, PERFORMANCE §8) · Home audio + `music_home` (fades in over 600 ms when ready) · `games_services` silent sign-in · current level data + gameplay atlas prefetch (`Isolate.run`) |
| First run | After the Age Gate is submitted | Age band ⇒ consent ⇒ ads, as in the game's 07 startup order |

Rule: during the intro, the UI isolate does nothing but the intro. JSON decode, decompression and any loop over level data go to `Isolate.run`.

### 5.3 Intro plan
```dart
enum IntroMode { full, short, fade }

class IntroPlan {
  IntroPlan(this.mode, {required this.endsOnAgeGate});
  final IntroMode mode;
  final bool endsOnAgeGate;
  final Completer<void> _done = Completer<void>();
  Future<void> get done => _done.future;
  void complete() { if (!_done.isCompleted) _done.complete(); }

  static IntroPlan resolve(LaunchInfo launch, Settings settings, DateTime now) {
    final firstRun = settings.ageBand == null;
    if (launch.animatorScale == 0 || settings.reduceMotion) {
      return IntroPlan(IntroMode.fade, endsOnAgeGate: firstRun);
    }
    final today = dayKey(now);
    if (firstRun || settings.lastFullIntroDayKey != today) {
      SettingsRepo.update((s) => s.lastFullIntroDayKey = today);  // async write, not awaited
      return IntroPlan(IntroMode.full, endsOnAgeGate: firstRun);
    }
    return IntroPlan(IntroMode.short, endsOnAgeGate: false);
  }
}
```
- `MediaQuery.disableAnimationsOf(context)` is also checked when the intro widget builds; if true, the mode drops to `fade`.
- New save field `settings.lastFullIntroDayKey` (String?, device-local, not synced). Add it to the standard's allowed save additions (SHARED_CORE_STANDARD §16.30).

### 5.4 Intro engine (shared code, copied into each game's `lib/intro/`)
One `AnimationController` drives everything. Each timeline track is an `Interval` on that controller, so Home's widgets use normal `FadeTransition` / `SlideTransition` / `ScaleTransition` (no `setState`, no rebuild per frame), and the intro painter repaints from the same controller.

```dart
class IntroTrack {
  const IntroTrack(this.startMs, this.endMs, [this.curve = Curves.linear]);
  final int startMs;
  final int endMs;
  final Curve curve;
}

class IntroTimeline<T extends Enum> {
  const IntroTimeline({required this.totalMs, required this.tracks});
  final int totalMs;
  final Map<T, IntroTrack> tracks;
}

class IntroController<T extends Enum> {
  IntroController({required TickerProvider vsync, required this.timeline})
      : anim = AnimationController(vsync: vsync, duration: Duration(milliseconds: timeline.totalMs));

  final IntroTimeline<T> timeline;
  final AnimationController anim;
  final Map<T, Animation<double>> _cache = {};

  Animation<double> track(T id) => _cache.putIfAbsent(id, () {
        final t = timeline.tracks[id]!;
        return CurvedAnimation(
          parent: anim,
          curve: Interval(t.startMs / timeline.totalMs, t.endMs / timeline.totalMs, curve: t.curve),
        );
      });

  double v(T id) => track(id).value;

  /// Tap during the intro: everything rushes to its end state.
  void skip() {
    if (anim.isAnimating) {
      anim.animateTo(1, duration: const Duration(milliseconds: 120), curve: Curves.easeOut);
    }
  }

  void dispose() => anim.dispose();
}
```
- **Fade mode:** a single 150 ms opacity tween from the splash colour to Home; no tracks.
- When the controller completes: `IntroPlan.complete()`, the painter and skip layer are removed from the tree, the controller is disposed. Home goes back to "no frames when nothing moves" (PERFORMANCE §4.1).

### 5.5 Home integration and input
```dart
Stack(
  children: [
    HomeContent(intro: intro),                       // final layout from frame 0; elements animate via intro.track(...)
    if (!introFinished) ...[
      IgnorePointer(
        child: RepaintBoundary(
          child: CustomPaint(size: Size.infinite, painter: GameIntroPainter(intro)),
        ),
      ),
      IntroTapCatcher(intro: intro, playRect: playButtonFinalRect, onPlay: startNextLevel),
    ],
  ],
)
```
- **Nothing is lost by tapping early:** `IntroTapCatcher` covers the screen only while the intro runs. Any tap calls `intro.skip()`. If the tap lands inside the Play button's **final** rect, it also starts Play. Every other control works normally once the intro ends (≤ 120 ms after a skip).
- Play reaches its final position by **600 ms** in the full intro and **300 ms** in the short intro (see the timelines).
- Back button during the intro: skip, not exit.
- First run: the end state is the Age Gate card; the tap catcher skips but never submits the Age Gate.

### 5.6 Rendering rules
| Rule | Detail |
|---|---|
| One painter | `GameIntroPainter` (`repaint: intro.anim`); everything not part of Home's widgets is drawn here |
| Vector first | Marks, wordmarks, foliage, tracks and threads are `Path`s generated at build time from SVG (§5.10); no image decode is needed for frame 0 |
| Sprites | Particles, glows, light rays come from one intro atlas (`assets/intro/atlas.webp`, 512 × 512, ≤ 120 KB). Decode starts in `main()` without awaiting; a sprite track whose start time arrives before the atlas is ready is skipped (the intro still works) |
| Particles | Pre-allocated pool; drawn with one `drawAtlas` call per frame; caps per tier below |
| Blend | Glows/rays use `BlendMode.plus`; no `MaskFilter.blur`, no `BackdropFilter`, no `saveLayer` per particle |
| Text | Brand wordmark is a vector `Path` (same in all languages). Localised subtitles are normal `Text` widgets faded in |
| Colours | `Color.lerp` between tokens; `Color.withValues(alpha:)` (no `withOpacity`) |
| Easing set | `Curves.easeOutCubic` (arrivals), `Curves.easeInOutCubic` (camera/background), `Curves.easeOutBack` (pops, overshoot 1.70158), `Curves.easeIn` (falls), `Curves.linear` (light sweeps) |

**Quality by tier** (same timeline on every tier; only effects scale):

| Effect | Low | Mid | High |
|---|---|---|---|
| Particles on screen (max) | 12 | 24 | 40 |
| Parallax layers | 2 | 3 | 3 |
| Light rays / sweeps | 1 | 2 | 3 |
| Native handoff blur (API 31+) | Off | On | On |
| Ambient extras (fireflies, dew glints, second bee…) | Off | On | On |

### 5.7 Jank guard
`SchedulerBinding.instance.addTimingsCallback` watches the first 5 intro frames. If any has `totalSpan` > 50 ms (the device is still busy starting up), the intro switches to **skip** (rush to end in 120 ms) and logs `W-PERF-005` with the tier and frame times. The callback is removed when the intro ends.

### 5.8 System bars
- During the splash and the start of the intro: transparent bars, light icons (all four splash colours are dark).
- Games 1–3 end on a light Home background: when the painted background's luminance crosses 0.5, call `SystemChrome.setSystemUIOverlayStyle` once with dark icons. Game 4 stays dark ⇒ light icons throughout.
- The app runs edge-to-edge (`SystemUiMode.edgeToEdge`), so the Flutter view and the system splash share the same centre point.

### 5.9 Error and edge states (replacing the old Splash states)
| Situation | Behaviour |
|---|---|
| Save corrupt | Restore `save_backup` before `runApp` (same ≤ 50 ms budget); after the intro, toast/dialog per the game's 06/07 docs. If both are bad: fresh save + `E-SAVE-` log |
| Large save migration (e.g. Phase 1 → 2 sticker grants) | Runs after the intro in an isolate; Home shows Home-visible fields immediately |
| Offline | No difference; nothing in the launch path uses the network |
| Process killed during the intro | Next cold start follows §3.2 normally (`lastFullIntroDayKey` already written ⇒ short intro) |
| App sent to background during the intro | Controller stops with `TickerMode`; on resume the intro jumps to its end state |
| Orientation / size change during intro | Intro jumps to its end state; Home relayouts |

### 5.10 Frame 0 identity and asset pipeline
- **Frame 0 must match the system splash:** background = `splash_bg`, the mark at the **window centre**, drawn in a **192 dp** circle, in its rest pose. QA overlays both screenshots (SPL-04).
- `tools/intro/svg_to_dart.dart` (build-time) converts `assets/brand/splash_mark.svg`, the wordmark SVG and the scene SVGs into Dart `Path` builders (`lib/intro/gen/*.g.dart`). No SVG parsing at runtime, no `flutter_svg` in the launch path.
- The same `splash_mark.svg` produces the AVD and the static vector (§4.7). A CI step checks that the generated Dart path's bounds match the static vector's bounds within 1 dp.
- Intro asset budget per game: generated paths ≤ 60 KB of Dart code, atlas ≤ 120 KB, AVD ≤ 20 KB.

---

## 6. Shared Motion Language

All four intros follow the same beat structure, so the shared engine, QA and timing rules apply to every game. Each game fills the beats with its own world.

| Beat | Full (1,200 ms) | Short (450 ms) | Purpose |
|---|---|---|---|
| **B0 Handoff** | 0 | 0 | Frame 0 = system splash; native fade 120 ms |
| **B1 Hero action** | 0–450 | 0–300 | The mark comes alive and moves toward its Home position |
| **B2 World reveal** | 100–900 | 0–400 | Splash colour transforms into the Home scene (camera move, parting layers, opening lid) |
| **B3 Title** | 400–1,000 | 150–450 | Wordmark builds in; subtitle fades in |
| **B4 Call to action** | 380–600 (Play final at 600) | 100–300 | Play button (or Age Gate card) lands; light haptic |
| **B5 Settle** | 600–1,200 | — | Small ambient flourish that blends into Home's idle loop |

- **Haptic:** one `HapticFeedback.lightImpact()` when Play lands (only if `settings.haptics` is on). None in fade mode.
- **Audio:** no SFX during the intro (audio isn't loaded yet, and a sound at launch is jarring in public). `music_home` fades in when stage B has loaded it.
- **Photosensitivity:** no full-screen flashes; sparkles and glints ≤ 3 per second in any one screen region.
- **Short mode** drops particles, rays and B5, and replaces per-letter staggers with one fade + 8 dp rise.

---

## 7. Game 1 — Snakes Slither: "Jungle Dawn"

**Concept:** the app opens in the dark of the jungle canopy. Pip, coiled in the logo, opens their eyes, uncoils and slithers out; the canopy parts like curtains and dawn light floods the garden, turning the deep green into Home's soft sage.

### 7.1 Tokens
| Token | Hex | Use |
|---|---|---|
| `splashCanopy` | `#12301F` | `splash_bg`, frame 0 background |
| `canopyFront` | `#0E2618` | Front foliage layer |
| `canopyMid` | `#1F4D2E` | Mid foliage layer |
| `dawnRay` | `#FFF3C4` | Light rays (additive, max alpha 0.35) |
| `bgSage` | `#E8F5E9` | Home background (end state) |
| `primary` / `coinGold` | `#2E7D32` / `#FFCA28` | Play button, leaf-burst particles (existing tokens) |

### 7.2 Mark and AVD (≤ 600 ms)
Mark: Pip coiled into a ring, head resting on the coil, leaf hat. Rest pose = eyes open.
| Time | AVD part | Motion |
|---|---|---|
| 0–200 ms | Eyelids | Closed ⇒ open (path morph, same outline) |
| 200–380 ms | Tongue | Flick out and back (scaleX 0 ⇒ 1 ⇒ 0) |
| 300–600 ms | Leaf hat | Tilt 0° ⇒ −8° ⇒ 0° |

### 7.3 Full intro (1,200 ms)
| Track | ms | What happens | From → To | Curve |
|---|---|---|---|---|
| `uncoil` | 0–380 | Pip's coiled body unrolls into an S-curve; the head travels along a pre-built path to Pip's perch beside the logo. Body = points sampled along the path (`PathMetric`) | Coil at centre, 192 dp → Home perch, Home size | easeInOutCubic |
| `canopyFront` | 120–700 | Front foliage splits and slides off-screen left/right | 0 → ±110% width | easeInOutCubic |
| `canopyMid` | 160–760 | Mid foliage slides out slower (parallax) | 0 → ±70% width, alpha 1 → 0 | easeInOutCubic |
| `dawn` | 200–900 | Background colour | `splashCanopy` → `bgSage` | easeInOutCubic |
| `rays` | 350–1,000 | 3 light rays from the top-right sweep across | alpha 0 → 0.35 → 0, rotation −6° → +4° | linear |
| `play` | 380–600 | Play button pops in at its final spot | scale 0.4 → 1.0, alpha 0 → 1 | easeOutBack |
| `leafBurst` | 600–900 | Leaf particles burst from Play; haptic at 600 | 12/24/40 particles by tier, life 300 ms | easeOutCubic |
| `wordmark` | 420–820 | "SNAKES SLITHER" letters, 30 ms stagger | y +24 dp → 0, scale 0.6 → 1.0, alpha 0 → 1 (first 40%) | easeOutBack |
| `subtitle` | 700–1,000 | Localised tagline | alpha 0 → 1, y +8 dp → 0 | easeOutCubic |
| `settle` | 900–1,200 | Pip blinks once; 4 dew sparkles on leaves (Mid/High) | — | — |

### 7.4 Short intro (450 ms)
`uncoil` 0–300 · `canopyFront`+`canopyMid` 0–350 · `dawn` 0–400 · `play` 100–300 · `wordmark` 150–450 (single fade + rise) · no rays, particles or settle.

### 7.5 First run
Same full intro; at 380–600 the **Age Gate card** rises from the bottom (y +100% → 0, easeOutCubic) instead of Play popping. Pip ends on the card's top edge.

---

## 8. Game 2 — Yarn Unravel: "Hearth & Thread"

**Concept:** a dim evening by the fireplace. A rose yarn ball hops, then rolls across the screen, unspooling a thread that stitches the logo into place while the fire's glow warms the room into Home's cream linen. Purl the kitten bats the ball as the scene settles.

### 8.1 Tokens
| Token | Hex | Use |
|---|---|---|
| `splashHearth` | `#3A2A22` | `splash_bg`, frame 0 background |
| `hearthGlow` | `#FFB86B` | Radial fire glow (max alpha 0.45) |
| `threadRose` | `#E25C6A` | Yarn ball + thread (existing thread `red`) |
| `needleSilver` | `#C9CED6` | Needle leading the stitch |
| `bgLinen` | `#FFF9F0` | Home background (end state) |
| `primaryBtn` | `#E07A5F` | Play button (existing) |

### 8.2 Mark and AVD (≤ 600 ms)
Mark: rose yarn ball with a needle through it and one loose strand. Rest pose = round ball, strand curled right.
| Time | AVD part | Motion |
|---|---|---|
| 0–250 ms | Loose strand | Wiggle (path morph between 3 curls, same length) |
| 150–450 ms | Highlight wrap lines | Rotate around the ball 0° → 30° (inside the ball outline) |
| 400–600 ms | Needle | Glint (small white diamond scale 0 → 1 → 0) |

### 8.3 Full intro (1,200 ms)
| Track | ms | What happens | From → To | Curve |
|---|---|---|---|---|
| `squash` | 0–200 | Ball anticipation squash, then hop | scaleY 1 → 0.9 → 1.05, scaleX 1 → 1.06 → 0.97 | easeOutCubic |
| `roll` | 150–750 | Ball rolls along a curve to the basket on Home; it rotates as it rolls and shrinks as it unspools | radius 96 dp → 56 dp, rotation 0 → −540° | easeInOutCubic |
| `thread` | 150–750 | Thread drawn behind the ball (`PathMetric.extractPath` 0 → length); its path becomes the stitched underline beneath the wordmark | 0 → 100% length | easeInOutCubic (same as `roll`) |
| `hearth` | 200–800 | Fire glow blooms from the bottom centre | alpha 0 → 0.45 → 0.12 | easeOutCubic |
| `room` | 200–900 | Background colour | `splashHearth` → `bgLinen` | easeInOutCubic |
| `hoop` | 350–600 | Embroidery hoop decoration spins into place | rotation −25° → 0°, scale 0.8 → 1 | easeOutBack |
| `play` | 400–600 | Play button "sewn on": drops in and two stitch strokes cross on it; haptic at 600 | y −40 dp → 0, alpha 0 → 1; stitches 0 → 100% | easeOutBack |
| `wordmark` | 450–950 | "Yarn Unravel" drawn as a running stitch (dashed outline), needle sprite leading, then filled | outline 0 → 100%, fill alpha 0 → 1 (last 20%) | linear (stitch), easeOutCubic (fill) |
| `subtitle` | 750–1,000 | "Cozy Thread Puzzle" (localised) | alpha 0 → 1, y +8 dp → 0 | easeOutCubic |
| `purl` | 800–1,150 | Purl's paw pops up from the bottom edge, bats the ball (ball wobble ±6°), drops back | paw y +100% → 0 → +100% | easeOutBack / easeIn |
| `fluff` | 600–1,000 | Wool tuft particles drift from the thread (Mid/High) | 0/24/40 by tier (Low: 0 — tufts are ambient), life 400 ms | easeOutCubic |

### 8.4 Short intro (450 ms)
`roll` + `thread` 0–400 · `room` 0–400 · `play` 100–300 · `wordmark` 150–450 (fade + rise, no stitching) · no squash, hearth, hoop spin, Purl or fluff.

### 8.5 First run
At 400–600 the Age Gate card slides up (easeOutCubic); the thread's last segment runs along the card's top edge instead of under the wordmark.

---

## 9. Game 3 — Toy Trains: "All Aboard"

**Concept:** the screen is the inside of a wooden toy box lid. The little red engine chugs, the lid swings open onto the honey-oak tabletop, track ties pop into place ahead of the engine as it drives to its spot, its carriages drop the wooden letter blocks of the title, and the station signal turns green on the Play button.

### 9.1 Tokens
| Token | Hex | Use |
|---|---|---|
| `splashToyBox` | `#2B2118` | `splash_bg`, frame 0 background (lid inside) |
| `lidWood` | `#6B4A33` | Lid edge / outer face during the swing |
| `engineRed` | `#D84315` | Engine (existing train `Red`) |
| `brass` | `#C9A227` | Brass details, wordmark shimmer (existing) |
| `steam` | `#FFFFFF` | Steam puffs (alpha ≤ 0.8) |
| `signalGreen` | `#43A047` | Signal lamp (existing `previewGreen`) |
| `tableOak` | `#F3E9DC` | Home background (end state) |
| `ctaGreen` | `#2E7D32` | Play button (existing) |

### 9.2 Mark and AVD (≤ 700 ms)
Mark: red wooden engine, front three-quarter view, chimney and brass dome. Rest pose = wheels at 0°, no steam.
| Time | AVD part | Motion |
|---|---|---|
| 0–700 ms | Wheels (3 groups) | Rotate 0° → 360° (spokes inside the wheel outline) |
| 100–500 ms | Steam puff | Puff grows and fades above the chimney, inside the 192 dp circle |
| 450–700 ms | Headlamp | Brightens and settles (fill colour tween) |

### 9.3 Full intro (1,200 ms)
| Track | ms | What happens | From → To | Curve |
|---|---|---|---|---|
| `chug` | 0–200 | Engine backs up slightly, puff of steam | x 0 → −6 dp → 0 | easeOutCubic |
| `lid` | 0–600 | The dark lid swings up and away (perspective `Matrix4` with `setEntry(3, 2, 0.0012)`, rotate X), revealing the tabletop | 0° → −100°; inner face `splashToyBox`, outer `lidWood` | easeInOutCubic |
| `table` | 100–700 | Tabletop background under the lid | `splashToyBox` → `tableOak` | easeInOutCubic |
| `ties` | 150–850 | 24 track ties pop in one by one ahead of the engine, 22 ms apart; rails extend behind them | each tie scale 0 → 1 | easeOutBack |
| `drive` | 200–850 | Engine shrinks to track scale and drives along the track to its Home spot; 3 carriages couple on behind | scale 1 → 0.45, position along track path | easeInOutCubic |
| `steam` | 200–1,000 | Steam puffs from the chimney while driving | 12/24/40 particles by tier, life 450 ms, rise 30 dp | easeOutCubic |
| `play` | 400–600 | Play button = station signal; the arm drops and the lamp lights green; haptic at 600 | button scale 0.6 → 1; arm 0° → 45°; lamp glow alpha 0 → 0.5 | easeOutBack |
| `blocks` | 600–950 | The carriages drop "TOY TRAINS" as 9 wooden letter blocks that hop onto the title row, 25 ms stagger, landing with a small squash | arc jump 12–24 dp, squash scaleY 0.9 → 1 | easeOutBack |
| `subtitle` | 800–1,050 | "Wooden Railway Puzzle" (localised) | alpha 0 → 1, y +8 dp → 0 | easeOutCubic |
| `shimmer` | 900–1,200 | Brass light band sweeps across the wordmark (Mid/High: 2 bands) | band x −20% → 120% | linear |

### 9.4 Short intro (450 ms)
`lid` 0–350 · `table` 0–400 · `drive` 0–400 (no ties popping; track appears with the table) · `play` 100–300 · title blocks 150–450 (fade + rise) · no chug, steam or shimmer.

### 9.5 First run
The engine stops beside the Age Gate card, which slides up at 400–600; the signal lamp sits on the card's Continue button and lights green when a year is selected.

---

## 10. Game 4 — Ants & Bees: "Garden Awakening"

**Concept:** night-green garden. The bee lifts off its sunflower, the camera flies forward through tall grass blades into the lawn, two bees draw a nectar-gold trail that becomes the title's underline, a line of ants marches in under the subtitle, and a honey drop falls into the Play button.

### 10.1 Tokens
| Token | Hex | Use |
|---|---|---|
| `bgMoss` | `#1B4332` | `splash_bg`, frame 0, Home gradient top (existing) |
| `bgLawn` | `#2D6A4F` | Home gradient bottom (existing) |
| `grassFront` | `#14352A` | Foreground grass blades |
| `grassMid` | `#236046` | Mid grass blades |
| `nectarGold` | `#FFD166` | Bee trail sparkles (existing) |
| `honeyGold` | `#F4A261` | Honey drop, Play button (existing) |
| `dewDot` | `#D8F3DC` | Dew glints (existing) |

### 10.2 Mark and AVD (≤ 600 ms)
Mark: bee hovering over a sunflower head. Rest pose = wings level, petals open.
| Time | AVD part | Motion |
|---|---|---|
| 0–560 ms | Wings | Flutter: rotation 0° ↔ −28°, 40 ms half-cycle (14 half-cycles) |
| 0–400 ms | Petals | Bloom from 85% to 100% scale around the flower centre (inside outline) |
| 300–600 ms | Bee body | Bob ±4 dp |

### 10.3 Full intro (1,200 ms)
| Track | ms | What happens | From → To | Curve |
|---|---|---|---|---|
| `liftoff` | 0–300 | Bee lifts off the sunflower and banks right; sunflower shrinks toward its Home decoration spot | bee y 0 → −40 dp, rotation 0° → 12°; flower scale 1 → 0.5 | easeOutCubic |
| `grassFront` | 100–800 | Camera flies through the grass: front blades scale up and spread outward, then fade | scale 1 → 1.6, x spread ±60%, alpha 1 → 0 | easeInOutCubic |
| `grassMid` | 150–850 | Mid blades, slower (parallax); Low tier skips this layer | scale 1 → 1.3, alpha 1 → 0 | easeInOutCubic |
| `lawn` | 200–900 | Background becomes Home's gradient | bottom colour `bgMoss` → `bgLawn` (top stays `bgMoss`) | easeInOutCubic |
| `sun` | 250–1,000 | Soft sunlight sweep from the top-right | alpha 0 → 0.3 → 0.1 | linear |
| `flight` | 250–950 | Bee flies a lazy S across the screen; a second bee joins at 400 ms (Mid/High). Nectar sparkle trail behind them; the trail's last stretch becomes the wordmark underline | path position 0 → 1; trail 12/24/40 particles, life 400 ms | easeInOutCubic |
| `play` | 400–600 | A honey drop falls from the top edge and splats into the Play button, which swells into place; haptic at 600 | drop y −100% → button; button scale 0.5 → 1.1 → 1 | easeIn (fall), easeOutBack (swell) |
| `wordmark` | 450–950 | "Ants & Bees" letters pop, 28 ms stagger | scale 0.6 → 1, alpha 0 → 1, y +20 dp → 0 | easeOutBack |
| `ants` | 500–1,050 | 8 ants march in from the left along a dotted line under "Garden Trails" (localised), 40 ms apart | path position 0 → final | easeOutCubic |
| `subtitle` | 700–1,000 | "Garden Trails" text | alpha 0 → 1 | easeOutCubic |
| `dew` | 900–1,200 | 6 dew glints on the lawn, staggered (Mid/High) | scale 0 → 1 → 0, 200 ms each | easeOutCubic |

### 10.4 Short intro (450 ms)
`grassFront` 0–350 · `lawn` 0–400 · `liftoff` 0–300 · `play` 100–300 (no drop, scale only) · `wordmark` 150–450 (fade + rise) · ants appear in place with the subtitle · no trail, sun or dew.

### 10.5 First run
The honey drop falls onto the Age Gate card's Continue button instead; the ants march along the card's top edge.

---

## 11. iOS Note
iOS uses `LaunchScreen.storyboard`: a solid `splash_bg` colour and the static mark (PDF vector) centred at 192 pt. The Flutter side is identical (frame 0 matches the storyboard, same intros). No native Swift animation is needed; the storyboard can't animate, and Flutter's first frame takes over the same way.

---

## 12. Measurement, Logging and Analytics

### 12.1 In-app
- `StartupTrace` marks: `processStart` (from `LaunchInfo`), `engineStart`, `dartMain`, `hiveOpen`, `runApp`, `firstFrame`, `introEnd`, `stageBStart`. Reported to the Firebase Performance trace `app_start` (attributes `tier`, `game`, `startType`, `introMode`) once Firebase is ready.
- Intro frames go through the existing `FrameMonitor` (PERFORMANCE §12.2) with screen name `intro`.
- New log codes (add to [LOGGING](./LOGGING_AND_ERROR_TRACKING.md) `perf` row): `W-PERF-004` slow cold start (thresholds §2) or splash safety cap hit · `W-PERF-005` intro jank guard triggered.
- Analytics: `intro_shown{mode, tier, skipped, ms_to_skip}` (once per cold start). No other events.

### 12.2 Lab
- **Macrobenchmark** module `:benchmark` (`androidx.benchmark:benchmark-macro-junit4`):
```kotlin
@RunWith(AndroidJUnit4::class)
class StartupBenchmark {
    @get:Rule val rule = MacrobenchmarkRule()

    @Test fun coldStart() = rule.measureRepeated(
        packageName = "com.studio.game",
        metrics = listOf(StartupTimingMetric(), FrameTimingMetric()),
        iterations = 10,
        startupMode = StartupMode.COLD,
    ) {
        pressHome()
        startActivityAndWait()
    }
}
```
  Run COLD / WARM / HOT on the low, mid and high reference devices for every release candidate; results go into the perf CI baseline (PERFORMANCE §12.3, > 10% regression fails the pipeline).
- Quick manual check: `adb shell am start -W -S -n com.studio.game/.MainActivity` (`TotalTime`).
- Field: Play Console Android vitals "slow cold start" rate must not rise after release.

---

## 13. QA Checklist

| ID | Test | Expected | Status |
|---|---|---|---|
| SPL-01 | Tap icon (cold), all 4 games, launcher launch | System splash with game colour + mark appears immediately; no white/black flash at any point | Not run |
| SPL-02 | Cold start TTID, 10 runs, low / mid / high device | Median within §2 budgets | Not run |
| SPL-03 | Warm and hot start | Within §2 budgets; no intro replays | Not run |
| SPL-04 | Frame 0 vs system splash screenshot overlay (API 31+ and API 29) | Same colour; mark centre within 1 dp, size within 2% | Not run |
| SPL-05 | Handoff on API 31+ | Native fade 120 ms with blur (Mid/High), no visible jump | Not run |
| SPL-06 | Full intro, each game | Every track per §7–§10 timings (screen recording at 60 fps, frame-step check); ends on Home exactly matching 06 Home layout | Not run |
| SPL-07 | Short intro (second cold start same day) | 450 ms version; no particles | Not run |
| SPL-08 | Tap Play at 100 ms, 300 ms, 600 ms | Intro skips and the level starts; no tap lost, no double start | Not run |
| SPL-09 | Tap elsewhere during intro / Back during intro | Intro rushes to end ≤ 120 ms; app does not exit | Not run |
| SPL-10 | First run (fresh install) | Full intro ends on the Age Gate; consent form appears only after the Age Gate, never over the intro | Not run |
| SPL-11 | OS "Remove animations" on / in-game Reduce Motion on | 150 ms fade only; no haptic | Not run |
| SPL-12 | Airplane mode cold start | Same timings as online | Not run |
| SPL-13 | Remote Config, ads, consent, audio, `games_services` | None start before first frame; heavy ones start at intro end (logcat/trace order) | Not run |
| SPL-14 | Low tier intro frames | 60 fps, jank < 1%, particles ≤ 12 | Not run |
| SPL-15 | 120 Hz device | Intro at 120 fps; same duration as on 60 Hz | Not run |
| SPL-16 | Jank guard (Remote Config test flag adds 80 ms busy work on the first frames) | Intro skips to end, `W-PERF-005` logged | Not run |
| SPL-17 | Background the app at 300 ms, return | Intro at end state; Home correct | Not run |
| SPL-18 | Rotate / resize (tablet, split screen) during intro | Intro jumps to end; layout correct | Not run |
| SPL-19 | Corrupt save | No loading screen; Home from backup; message after the intro | Not run |
| SPL-20 | Crash thrown in the first 200 ms (test build) | Report reaches Crashlytics after Firebase init (buffered) | Not run |
| SPL-21 | System bars | Light icons on dark splash; games 1–3 switch to dark icons once the background turns light | Not run |
| SPL-22 | Photosensitivity review of all 4 intros | No region flashes > 3 times per second | Not run |
| SPL-23 | Gujarati / Hindi locale | Wordmark unchanged (vector); localised subtitle renders correctly | Not run |
| SPL-24 | Intro over, idle Home 10 s | Intro painter removed; Home's own rules apply (no extra frames from the intro) | Not run |

Release gate: SPL-01, 02, 04, 08, 10, 13 are P0 and must pass on the low-tier reference device, along with the PERFORMANCE release gate.

---

## 14. Changes to Other Docs

| Doc | Change |
|---|---|
| Each game `phase_1/06_UI_UX_SCREENS.md` Splash section | Loading screen with progress bar removed; points here |
| Each game `phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md` | Startup order defers Remote Config fetch / ads / consent past the first frame; cold-start budgets replaced by §2 |
| [PERFORMANCE_OPTIMIZATION.md](./PERFORMANCE_OPTIMIZATION.md) §2, §8, PERF-13 | Cold-start budget and `main()` updated to this doc |
| [SHARED_CORE_STANDARD.md](./SHARED_CORE_STANDARD.md) §16.30 | `lastFullIntroDayKey` added to allowed save fields |
| [LOGGING_AND_ERROR_TRACKING.md](./LOGGING_AND_ERROR_TRACKING.md) | `W-PERF-004`, `W-PERF-005` added |

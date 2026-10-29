# 07 — Frontend Implementation & QA
> Purpose: Flutter implementation rules (architecture, BLoCs, game loop, renderer, input, audio/haptics, ads/IAP/consent, persistence, analytics, performance, errors) અને release QA checklist.

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) (§12 Pipeline, §13 Tech, §14 Save, §15 Analytics) · [./README.md](./README.md) · [./01_GAME_CONCEPT_AND_RULES.md](./01_GAME_CONCEPT_AND_RULES.md) · [./03_OBSTACLE_CATALOG_PHASE_1.md](./03_OBSTACLE_CATALOG_PHASE_1.md) · [./04_BOOSTERS_COINS_SHOP.md](./04_BOOSTERS_COINS_SHOP.md) · [./06_UI_UX_SCREENS.md](./06_UI_UX_SCREENS.md) · [../../SOUND_EFFECTS_IMPLEMENTATION.md](../../SOUND_EFFECTS_IMPLEMENTATION.md) · [../../LOGGING_AND_ERROR_TRACKING.md](../../LOGGING_AND_ERROR_TRACKING.md)

---

## 1. Architecture

| Area | Decision (standard §13) |
|---|---|
| Framework | Flutter 3.x stable, Dart 3, Impeller |
| Rendering | `CustomPainter` + `Ticker`-driven loop (`AnimationController`) — **Flame નહીં** |
| State | `flutter_bloc` (Riverpod નહીં) |
| Engine | `packages/puzzle_core` (pure Dart, shared by all 4 games): board model, rules, mechanics M001–M099, solver, generator, xoshiro128\*\* PRNG |
| App | `apps/yarn_unravel`: theme, renderer, screens, services |
| Persistence | `hive_ce` typed adapters, save schema v1 |
| Ads / Consent | `google_mobile_ads` (UMP included) |
| IAP | `in_app_purchase` + Firebase Function `verifyPurchase` |
| Analytics / Crash / Config | `firebase_analytics`, `firebase_crashlytics`, `firebase_remote_config` |
| Leaderboards | `games_services` |
| Audio | `audioplayers` — `AudioService` + `AudioPool` (spec: [SOUND_EFFECTS_IMPLEMENTATION](../../SOUND_EFFECTS_IMPLEMENTATION.md)) |
| Logging / errors | `AppLogger` + Crashlytics + `firebase_performance` (spec: [LOGGING_AND_ERROR_TRACKING](../../LOGGING_AND_ERROR_TRACKING.md)) |
| Haptics | Flutter `HapticFeedback` (third-party vibrate package નહીં) |
| Localization | `flutter_localizations` + ARB (en, gu, hi) |

Layering rule: `puzzle_core` has **no Flutter import** (pure Dart, unit-testable, used by `tools/levelgen` CLI). Theme strings/art live only in `apps/yarn_unravel`.

## 2. Folder Tree
```
repo/
├── packages/puzzle_core/
│   ├── lib/
│   │   ├── src/model/      board.dart, thread_path.dart, mechanic.dart, level.dart (schema v3)
│   │   ├── src/rules/      lane_resolver.dart, move_resolver.dart, effects.dart
│   │   ├── src/mechanics/  m001_single_blocker.dart … m049_guardian.dart (one file per ID)
│   │   ├── src/solver/     bfs_solver.dart, ida_star.dart, hint_service.dart
│   │   ├── src/gen/        generator.dart, reverse_construction.dart, difficulty.dart
│   │   └── src/prng/       xoshiro128ss.dart, hash64.dart
│   └── test/ (rules/, mechanics/m001_test.dart … m049_test.dart, solver/, gen/)
├── apps/yarn_unravel/
│   ├── lib/
│   │   ├── main.dart, app.dart, router.dart
│   │   ├── theme/          tokens.dart, thread_palette.dart, typography.dart
│   │   ├── features/
│   │   │   ├── game/       bloc/, view/board_view.dart, render/ (yarn_board_painter.dart, yarn_stroke.dart, needle_painter.dart, static_layer.dart, thread_track.dart)
│   │   │   ├── home/  level_map/  daily/  shop/  spin/  settings/  onboarding/ (age_gate, consent)
│   │   │   └── rewards/    level_complete, craft_basket, coin_rush, phase_complete
│   │   ├── services/       ads_service.dart, iap_service.dart, consent_service.dart, audio_service.dart,
│   │   │                   haptics.dart, analytics.dart, remote_config.dart, time_service.dart, leaderboard_service.dart
│   │   ├── data/           save_repository.dart, hive_adapters.dart, level_repository.dart
│   │   └── l10n/           app_en.arb, app_gu.arb, app_hi.arb
│   ├── assets/levels/phase_1.json.gz, daily_fallback.json
│   ├── assets/textures/yarn_ply_64.png, linen_256.png
│   └── assets/audio/…
└── tools/levelgen/ (Dart CLI) + tools/validator/ (CI)
```

## 3. BLoCs, States & Events

| BLoC / Cubit | Events / methods | States |
|---|---|---|
| `GameBloc` | `LevelStarted(level, mode)`, `CellTapped(x, y)`, `PeekStarted(x, y)`, `PeekEnded`, `BoosterPressed(type)`, `HammerTargetChosen(target)`, `AnimationFinished`, `ReviveByAd`, `ReviveByCoins`, `SecondChanceDeclined`, `Restarted`, `Paused`, `Resumed` | `GameLoading`, `GamePlaying(board, hearts, shield, moves, goals, inputLocked, hintTarget?, peek?)`, `GameAnimating(moveResult)`, `GameSecondChance(adAvailable, adUsed, refillsLeft, secondsLeft)`, `GameWon(stars, coins, rewardsQueue)`, `GameFailed` |
| `WalletCubit` | `addCoins`, `spendCoins`, `grantBooster`, `consumeBooster` | `WalletState(coins, hint, shield, hammer)` |
| `ProgressCubit` | `recordWin(level, stars)`, `markAdRevive(level)` | `ProgressState(highestCleared, stars, adReviveUsed)` |
| `DailyBloc` | `DailyOpened`, `DailyCleared`, `SaverAccepted(method)`, `ClockChecked` | `DailyLocked`, `DailyAvailable(modifier, silhouette)`, `DailyDone(nextAt)`, `DailySaverOffer`, `DailyTimeLocked` |
| `StreakCubit` | `advance`, `reset`, `useSaver` | `StreakState(day, cycleSaverUsed, totalDays, trophyTier)` |
| `ShopBloc` | `ProductsRequested`, `BuyCoinsItem`, `BuyIap(sku)`, `PurchaseUpdated`, `RestoreRequested` | `ShopLoading`, `ShopReady(products)`, `ShopPending(sku)`, `ShopError(msg)` |
| `SpinCubit` | `spinFree`, `spinWithAd` | `SpinReady(free, adLeft)`, `SpinResult(prize)`, `SpinLocked` |
| `AdsCubit` | `onNumberedWin(level, hasRewardScreen)` | `AdsState(winsSinceInterstitial, lastFullscreenUtc, dailyCounts)` |
| `SettingsCubit` | toggles, language, pattern labels, reduce motion | `SettingsState` |
| `ConsentCubit` | `ageSubmitted(year)`, `umpCompleted` | `ConsentState(ageBand, canRequestAds)` |

`GameBloc` uses `puzzle_core` `MoveResolver` synchronously (pure), then emits `GameAnimating`; the view plays animation and dispatches `AnimationFinished`. Queue: `GameBloc` stores **one** pending tap while `inputLocked`.

## 4. Game Loop

1. `CellTapped` ⇒ hit-test (§6) ⇒ target id.
2. `MoveResolver.resolve(state, target)` ⇒ `MoveResult` (exit / bump / relocate / toggle / locked + route cells + effects + new state). Pure, deterministic ([01 §5.5](./01_GAME_CONCEPT_AND_RULES.md)).
3. Locked ⇒ emit wobble cue, no state change.
4. Else emit `GameAnimating`; SFX/haptic cues animation ના સાચા frame પર (`path_tap` at start, `bump` on contact frame).
5. View: `AnimationController` (Ticker) drives painter; duration ≤ 450 ms.
6. `AnimationFinished` ⇒ commit new state (engine already applied tick order §16.17: resolve → `moveCount+1` → counters → derived states → heart loss (Shield first) → **win check** → 0-heart check), rebuild static layer once, then Win ⇒ `GameWon`, else Hearts 0 ⇒ Second Chance, else process queued tap.
7. Golden Scissors use is irreversible (never reverted / re-applied, §16.23). Soft-lock detected (solver: no winning sequence without boosters) ⇒ "Stuck" sheet (Restart), no heart loss, `AppLogger.error('E-GAME-004')` (§17.31).

## 5. Renderer

### 5.1 Layers
| Layer | Content | Repaint |
|---|---|---|
| Static board picture | linen, frame, grid dots, obstacles, all idle threads | rebuilt only after a Move commits (`PictureRecorder`) |
| Dynamic | moving thread(s), snag pulse, hint glow, peek line | every frame while animating |
| Overlay widgets | HUD, booster bar, tutorial, Lamplight vignette (pre-baked image) | Flutter widgets |

Rules: no per-frame `MaskFilter.blur` (shadows = offset strokes / pre-baked images); `Color.withValues(alpha:)`; wrap board in `RepaintBoundary`; dispose old `ui.Picture`.

### 5.2 Geometry & track
```dart
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BoardGeometry {
  const BoardGeometry({
    required this.cols,
    required this.rows,
    required this.cell,
    required this.origin,
  });

  final int cols;
  final int rows;
  final double cell;
  final Offset origin;

  Offset centerOf(int x, int y) =>
      origin + Offset((x + 0.5) * cell, (y + 0.5) * cell);

  /// Nearest cell within 0.5 cell, else null.
  (int, int)? cellAt(Offset p) {
    final local = p - origin;
    final x = (local.dx / cell).floor();
    final y = (local.dy / cell).floor();
    if (x < 0 || y < 0 || x >= cols || y >= rows) return null;
    return (x, y);
  }
}

/// One thread's travel route for a single Move.
/// Track = tail → … → needle → lane route (→ extension past the edge).
class ThreadTrack {
  ThreadTrack._(this.metric, this.threadLength);

  final ui.PathMetric metric;
  final double threadLength;

  factory ThreadTrack.build({
    required List<Offset> tailToHead,
    required List<Offset> laneRoute,
    required double extension,
  }) {
    // tailToHead[0] = tail cell's back edge (not its centre), so even a
    // 1-cell thread has a visible length > 0.
    assert(tailToHead.length >= 2 && laneRoute.isNotEmpty);
    final path = Path()..moveTo(tailToHead.first.dx, tailToHead.first.dy);
    var threadLength = 0.0;
    for (var i = 1; i < tailToHead.length; i++) {
      path.lineTo(tailToHead[i].dx, tailToHead[i].dy);
      threadLength += (tailToHead[i] - tailToHead[i - 1]).distance;
    }
    for (final p in laneRoute) {
      path.lineTo(p.dx, p.dy);
    }
    if (extension > 0) {
      final last = laneRoute.last;
      final prev = laneRoute.length > 1
          ? laneRoute[laneRoute.length - 2]
          : tailToHead.last;
      final d = last - prev;
      if (d.distance > 0) {
        final end = last + d / d.distance * extension;
        path.lineTo(end.dx, end.dy);
      }
    }
    return ThreadTrack._(path.computeMetrics().first, threadLength);
  }
}
```
- Exit: `laneRoute` = corner points (deflectors, switches) + board-edge point (or Yarn Basket centre); `extension = threadLength`; `maxOffset = threadLength + laneLength`.
- Snag: `laneRoute` ends at contact point (blocker edge − 0.15 cell); `extension = 0`; `maxOffset = laneLength`.
- Pompom Tunnel: two tracks (in-portal clip + out-portal) drawn with the same offset; Elastic Hop Pad: `quadraticBezierTo` arc in route.

### 5.3 Unravel animation (PathMetric.extractPath)
The visible thread at time `t` is `metric.extractPath(offset, offset + threadLength)`. As `offset` grows, the needle leads along the lane and the body follows the same route — exactly the standard's "body follows head".

```dart
class MovingThread {
  MovingThread({
    required this.track,
    required this.color,
    required this.maxOffset,
    required this.isSnag,
  });

  final ThreadTrack track;
  final Color color;
  final double maxOffset;
  final bool isSnag;

  /// Offset along the track for animation progress t ∈ [0, 1].
  double offsetAt(double t) {
    if (!isSnag) return maxOffset * Curves.easeInCubic.transform(t);
    const forward = 0.33; // ~150 ms of a 450 ms snag
    if (t < forward) {
      return maxOffset * Curves.easeOut.transform(t / forward);
    }
    final u = (t - forward) / (1 - forward);
    if (u >= 1) return 0;
    // Cheap "twang": decaying bounce back to rest, never negative.
    return maxOffset * math.exp(-5 * u) * math.cos(2.5 * math.pi * u).abs();
  }
}
```
Durations: exit `clamp(160 + 18 ms × cellsTravelled, 220, 450)`; snag 450 ms (360 ms if contact ≤ 1 cell). Reduce motion ⇒ snag amplitude × 0.5.

### 5.4 Snag (bump) animation
- Forward ease to contact (`Curves.easeOut`), then decaying spring back (`exp(-5u)·|cos(2.5πu)|`) — **no rope physics**.
- Simultaneously: blocker red pulse (scale 1 → 1.12 → 1, 200 ms), board shake 3 dp × 2 cycles (skipped if Reduce motion), `HapticFeedback.mediumImpact()`, "twang" SFX.
- Heart icon crack animation after snag completes (or thimble flash if Shield absorbed).

### 5.5 Yarn stroke (texture) & needle
```dart
abstract final class YarnStroke {
  static Paint _stroke(double width) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  /// [texture]: optional pre-baked ImageShader (yarn ply tile, multiply).
  static void paint(
    Canvas canvas,
    Path path,
    Color color,
    double width,
    Shader? texture,
  ) {
    // Shadow: offset stroke, no blur.
    canvas.save();
    canvas.translate(width * 0.08, width * 0.12);
    canvas.drawPath(
      path,
      _stroke(width)..color = const Color(0xFF3B2A1A).withValues(alpha: 0.18),
    );
    canvas.restore();

    canvas.drawPath(path, _stroke(width)..color = color);

    if (texture != null) {
      canvas.drawPath(
        path,
        _stroke(width)
          ..shader = texture
          ..blendMode = BlendMode.multiply,
      );
    } else {
      _dashedTwist(canvas, path, color, width);
    }
  }

  /// Fallback ply look: short light dashes along the strand.
  static void _dashedTwist(Canvas canvas, Path path, Color color, double width) {
    final highlight = _stroke(width * 0.28)
      ..color = Color.lerp(color, const Color(0xFFFFFFFF), 0.45)!
          .withValues(alpha: 0.85);
    final dash = width * 0.55;
    final gap = width * 0.45;
    for (final metric in path.computeMetrics()) {
      for (var d = 0.0; d < metric.length; d += dash + gap) {
        canvas.drawPath(
          metric.extractPath(d, math.min(d + dash, metric.length)),
          highlight,
        );
      }
    }
  }
}

abstract final class NeedlePainter {
  static void paint(Canvas canvas, Offset at, double angle, double width) {
    final len = width * 1.6;
    canvas.save();
    canvas.translate(at.dx, at.dy);
    canvas.rotate(angle);
    final body = Path()
      ..moveTo(len, 0)
      ..lineTo(-len * 0.4, -width * 0.22)
      ..lineTo(-len * 0.4, width * 0.22)
      ..close();
    canvas.drawPath(body, Paint()..color = const Color(0xFFC9CED6));
    canvas.drawCircle(
      Offset(-len * 0.2, 0),
      width * 0.12,
      Paint()..color = const Color(0xFF6B7280),
    );
    canvas.restore();
  }
}

/// Texture: decode assets/textures/yarn_ply_64.png once at level load.
Shader makeYarnShader(ui.Image tile) => ui.ImageShader(
      tile,
      TileMode.repeated,
      TileMode.repeated,
      Matrix4.identity().storage,
    );
```
Colour-blind pattern (§2.2 of [06](./06_UI_UX_SCREENS.md)) is baked into the static picture per thread (stripes/dots drawn with the same dash helper) and the needle-eye icon is a cached `ui.Image` atlas drawn with `canvas.drawImageRect`.

### 5.6 Static layer cache & painter
```dart
class ThreadRender {
  const ThreadRender({
    required this.path,
    required this.color,
    required this.head,
    required this.headAngle,
  });

  final Path path;
  final Color color;
  final Offset head;
  final double headAngle;
}

ui.Picture buildStaticLayer({
  required Size size,
  required void Function(Canvas canvas) paintBoardAndObstacles,
  required Iterable<ThreadRender> idleThreads,
  required double strokeWidth,
  Shader? texture,
}) {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, Offset.zero & size);
  paintBoardAndObstacles(canvas);
  for (final t in idleThreads) {
    YarnStroke.paint(canvas, t.path, t.color, strokeWidth, texture);
    NeedlePainter.paint(canvas, t.head, t.headAngle, strokeWidth);
  }
  return recorder.endRecording();
}

class YarnBoardPainter extends CustomPainter {
  YarnBoardPainter({
    required this.staticLayer,
    required this.progress,
    required this.strokeWidth,
    required this.boardRect,
    this.moving = const <MovingThread>[],
    this.texture,
  }) : super(repaint: progress);

  final ui.Picture staticLayer;
  final Animation<double> progress;
  final double strokeWidth;
  final Rect boardRect;
  final List<MovingThread> moving;
  final Shader? texture;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPicture(staticLayer);
    if (moving.isEmpty) return;
    canvas.save();
    canvas.clipRect(boardRect); // threads vanish at the frame edge
    final t = progress.value;
    for (final m in moving) {
      final metric = m.track.metric;
      final start = m.offsetAt(t);
      final end = math.min(start + m.track.threadLength, metric.length);
      final segment = metric.extractPath(start, end);
      YarnStroke.paint(canvas, segment, m.color, strokeWidth, texture);
      final tangent = metric.getTangentForOffset(end);
      if (tangent != null) {
        NeedlePainter.paint(
          canvas,
          tangent.position,
          tangent.vector.direction,
          strokeWidth,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant YarnBoardPainter oldDelegate) =>
      oldDelegate.staticLayer != staticLayer ||
      !identical(oldDelegate.moving, moving) ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.boardRect != boardRect ||
      oldDelegate.texture != texture;
}
```
Note: the moving thread is **excluded** from the static picture before its animation starts (rebuild once at Move start; rebuild again at commit). Two picture builds per Move, zero per frame.

### 5.7 Board view (Ticker host)
```dart
class BoardView extends StatefulWidget {
  const BoardView({super.key, required this.staticLayer, required this.strokeWidth, required this.boardRect});

  final ui.Picture staticLayer;
  final double strokeWidth;
  final Rect boardRect;

  @override
  State<BoardView> createState() => BoardViewState();
}

class BoardViewState extends State<BoardView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  List<MovingThread> _moving = const <MovingThread>[];

  Future<void> play(List<MovingThread> threads, Duration duration) async {
    setState(() => _moving = threads);
    _controller.duration = duration;
    try {
      await _controller.forward(from: 0).orCancel;
    } on TickerCanceled {
      // Widget disposed or app backgrounded: caller snaps to end state.
    }
    if (mounted) setState(() => _moving = const <MovingThread>[]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: YarnBoardPainter(
          staticLayer: widget.staticLayer,
          progress: _controller,
          strokeWidth: widget.strokeWidth,
          boardRect: widget.boardRect,
          moving: _moving,
        ),
      ),
    );
  }
}
```

## 6. Input Handling
- `RawGestureDetector` with `TapGestureRecognizer` and `LongPressGestureRecognizer(duration: const Duration(milliseconds: 350))` (Thread Peek). Long-press release never triggers a tap.
- Hit-test order on a cell: (1) Golden Scissors targeting mode ⇒ target picker; (2) interactive obstacle (lever, spinner cell, switch, rotor handle); (3) upper layer thread; (4) lower layer thread; (5) nothing ⇒ ignore.
- Thread hit area = full cell of each body cell (stroke is thinner). Double-Needle Thread: nearest-end by body index; exact middle ⇒ `body[0]` end (§16.19).
- Spinner / rotor with a thread only partially inside, or a **tangled** thread (needle `dir` points into own body after rotation, §17.39) ⇒ locked tap (wobble, no heart, no Move) — never a bump.
- Every tap is wrapped by `TapLoggerScope` (semantic target id, result) for dead/rage-tap detection (LOGGING §6).
- During animation: store last tap only (queue 1).
- Multi-touch: second pointer ignored while first is down.

## 7. Audio & Haptics

Audio implementation, mixer/ducking, settings અને QA નો એકમાત્ર source: **[../../SOUND_EFFECTS_IMPLEMENTATION.md](../../SOUND_EFFECTS_IMPLEMENTATION.md)**. Summary:
- `AudioService` (singleton, app layer) + `AudioPool` per SFX (`PlayerMode.lowLatency`); music 2 × `AudioPlayer` crossfade. `puzzle_core` માત્ર `GameEvent` emit કરે, `GameBloc` તેને `SoundCue(eventId)` માં map કરે.
- SFX = `.wav` PCM 16-bit **mono** 44.1 kHz; music = `.m4a` AAC-LC 128 kbps. **OGG નહીં** (iOS support નથી).
- Max **8** concurrent SFX voices; same event ID min 50 ms gap. Files: `assets/audio/sfx/<event_id>_v<N>.wav`, `assets/audio/music/<track_id>.m4a`, mapping `assets/audio/theme.json`.
- Haptics: Flutter `HapticFeedback` via `HapticService` (checks `settings.haptics`); haptic mapping sound doc §5 મુજબ.
- Yarn rule: "twang" sounds ≤ 3 kHz dominant (તીખા નહીં).

Yarn theme ⇒ standard event IDs (sound doc §9, §5):

| Event ID | Yarn Unravel sound |
|---|---|
| `path_tap` | Yarn tug "fwp" |
| `path_exit` (3 variants) | Thread unravel "zzzip-fwip" |
| `bump` | Thread snag "twang" (damped) |
| `locked_tap` | Muted thread pluck |
| `heart_lost` | Soft fabric rip |
| `shield_absorb` | Thimble "ding" |
| `booster_hint` | Needle glint shimmer |
| `booster_hammer` | Golden scissors snip |
| `gate_open` | Eyelet pop (Color Eyelet, Basting Seam, Presser Lever gates, Zipper Edge) |
| `lock_open` / `key_collect` | Clasp click / charm flies to clasp |
| `portal_whoosh` | Pompom tunnel puff |
| `lever_toggle` / `rotate` / `switch_click` | Presser-foot "clunk" / spool ratchet, quilt swish / thread-guide click |
| `fog_clear` · `gem_collect` · `frozen_free` | Wool Fluff puff · sequin "ting" · knot untie pop |
| `guardian_hit` / `guardian_defeat` | Pin "ping" / pincushion stuffing poof |
| `win_stinger` | Music-box + kitten purr |
| `coins_fly` | Button-coin tinkle |
| Music (`music_home`, `music_map`, `music_gameplay_t1…t5`, `music_rush`, `music_finale`, `music_daily`) | Lo-fi acoustic, music box, crackling fireplace bed |

બાકીના mechanic event IDs (`crack`, `grow`, `spawn`, `eat`, `mud_stop`, `jump`, `color_change`, …) sound doc §5.2 ની list મુજબ `theme.json` માં ફરજિયાત (CI `tools/audio_check`).

## 8. Ads, IAP & Consent Integration
- **Startup order** (after the first frame and the launch intro ([SPLASH_AND_INSTANT_LAUNCH §5.2](../../SPLASH_AND_INSTANT_LAUNCH.md#52-deferred-start-up-work); nothing here blocks Home)): Hive open ⇒ age gate (first launch) ⇒ `ConsentInformation.instance.requestConsentInfoUpdate` ⇒ `ConsentForm.loadAndShowConsentFormIfRequired` ⇒ `MobileAds.instance.updateRequestConfiguration(RequestConfiguration(tagForChildDirectedTreatment: …, maxAdContentRating: …))` ⇒ `MobileAds.instance.initialize()` ⇒ preload rewarded + interstitial.
- Child band: `TagForChildDirectedTreatment.yes`, `MaxAdContentRating.g`, `AdRequest(nonPersonalizedAds: true)`, `FirebaseAnalytics.setAnalyticsCollectionEnabled` stays on but `setUserProperty(allow_personalized_ads: false)` and Google Signals off.
- `AdsService`: single fullscreen gate (`lastFullscreenUtc`), interstitial logic [04 §8](./04_BOOSTERS_COINS_SHOP.md), backoff 2^n s (max 3 retries/session), banner widget only on Home, Level Map, Gameplay (L11+), hidden if VIP.
- **IAP:** listen `InAppPurchase.instance.purchaseStream` at app start; for each `PurchaseDetails` with `purchased/restored` ⇒ call `verifyPurchase` (Cloud Function) ⇒ grant ⇒ `completePurchase`. Consumables via `buyConsumable(autoConsume: true)`; Starter Pack non-consumable; VIP subscription — store expiry from verification response as `iap.vipActiveUntil`; re-verify on every app start online. Offline ⇒ trust cached `vipActiveUntil` until expiry + 3-day grace.
- Restore: `InAppPurchase.instance.restorePurchases()`.

## 9. Persistence (Hive, save schema v1 — standard §14)
| Box | Fields |
|---|---|
| `progress` | `highestCleared`, `stars[level]`, `adReviveUsed[level]` (Daily key `daily:<dayKey>`) |
| `wallet` | `coins`, `boosters{hint, shield, hammer}` |
| `streak` | `day`, `cycleSaverUsed`, `lastClaimDayKey`, `totalDays`, `trophyTier` |
| `time` | `lastTrustedUtc`, `lastServerUtc` |
| `ads` | `winsSinceInterstitial`, `lastFullscreenUtc`, `dailyShopAds`, `dailySpinAds`, `dayKey` |
| `iap` | `vipActiveUntil`, `starterPackShown` |
| `settings` | `sound`, `music`, `haptics`, `language`, `ageBand` |

Rules: `saveVersion` int + migration functions; write-through after every reward grant (atomic `putAll`); backup copy `save_backup.hive` every 10 wins; corrupt ⇒ restore backup ⇒ else fresh save + Crashlytics non-fatal. Game-specific extra keys (allowed, non-standard): `progress.ftueStep`, `iap.starterPackExpiresUtc`, `spin.lastSpinDayKey`.

## 10. Analytics
Standard events: `level_start{level, attempt}`, `level_win{level, moves, hearts_lost, stars, duration_s}`, `level_fail{level, moves}`, `booster_use{type, level}`, `revive{type: ad|coins, level}`, `ad_show{format, placement}`, `iap_purchase{sku}`, `daily_clear{dayKey, modifier}`, `streak_update{day}`, `ftue_step{step}`. Booster `type` values use generic names (`hint|shield|hammer`) for cross-game dashboards. Extras: `coin_rush_end{coins, threads}`, `gift_claim{level}`, `spin{prize}`, `peek_use{level}`.

## 11. Performance Budget
| Metric | Target |
|---|---|
| Low-tier Android (2 GB RAM, Redmi 9A class), 30 threads | 60 fps |
| ProMotion iOS / 120 Hz Android flagship | 120 fps |
| Frame raster p95 (mid-tier) | < 8 ms |
| Static picture rebuild | ≤ 4 ms (11×11, 30 threads) on low-tier |
| Level load (decompress + parse) | ≤ 150 ms |
| On-device Hint solver | 50 ms budget, 50k nodes, isolate |
| Daily generation | ≤ 600 ms in isolate (64 attempts worst) |
| Cold start to Home first frame | ≤ 1,200 ms low-tier, ≤ 600 ms mid-tier ([SPLASH §2](../../SPLASH_AND_INSTANT_LAUNCH.md#2-launch-budgets)) |
| APK/AAB download size | ≤ 60 MB |
Profiling: `flutter run --profile`, DevTools raster thread, Impeller on.

## 12. Error Handling

બધું [../../LOGGING_AND_ERROR_TRACKING.md](../../LOGGING_AND_ERROR_TRACKING.md) મુજબ: દરેક entry `AppLogger` (category + stable code) દ્વારા; gameplay taps `TapLoggerScope` થી wrap (dead/rage/slow tap detectors); global hooks `FlutterError.onError` + `PlatformDispatcher.instance.onError` ⇒ Crashlytics.

| Failure | Code | Behaviour |
|---|---|---|
| Level JSON parse error / missing level | `E-LVL-001` | "Level unavailable" message + **Retry** (re-read bundle). Level ક્યારેય skip / cleared mark **નહીં**; non-fatal + replay context |
| Level schema mismatch | `E-LVL-002` | same as above ("Level unavailable" + Retry) |
| Daily generator 64 attempts fail | `E-LVL-003` | fallback `daily_fallback.json` board (`dayIndex mod 30`) |
| Solver timeout (Hint) | `E-LVL-004` | toast "Try Restart", Hint consume નહીં |
| Soft-lock (no winning sequence) | `E-GAME-004` | "Stuck" sheet: Restart, heart loss નહીં |
| Invariant violated (hearts < 0, etc.) / stuck animation > 2 s | `E-GAME-001` / `E-GAME-003` | soft assert, snap to end state, continue |
| Hive open fail | `E-SAVE-001` | retry once ⇒ backup |
| Save corrupt | `E-SAVE-002` | restore `save_backup.hive`; both bad ⇒ fresh save + "Restore purchases" prompt |
| Save migration fail | `E-SAVE-003` | keep old box read-only, retry next start |
| Hive write fail | `E-SAVE-004` | retry once, then in-memory continue |
| Ad load / show fail | `W-ADS-001` / `W-ADS-002` | button disabled "Ad unavailable", backoff; reward not granted after completion ⇒ `E-ADS-003` |
| Rewarded ad closed early | — | no reward, no penalty |
| IAP error / verification fail / restore fail | `E-IAP-001` / `E-IAP-002` / `E-IAP-004` | no grant, "Purchase couldn't be verified" + support link; purchase un-completed ⇒ retry next start |
| Remote Config fetch timeout | `W-NET-002` | bundled defaults (= standard values) |
| Server time fetch fail | `W-NET-001` | offline rules [05 §8](./05_DAILY_CHALLENGE_AND_STREAK.md) |
| Clock moved backward | `W-TIME-001` | time-travel lock ([05 §7](./05_DAILY_CHALLENGE_AND_STREAK.md)) |
| Audio asset missing / pool fail | `E-AUD-001` / `E-AUD-002` | no crash, sound skipped, game continues |
| Leaderboard sign-in fail | — (`info`) | silent, button shows sign-in |

Error dialogs માં "Report" button ⇒ Settings → Help → "Report a problem" flow (LOGGING §11).

## 13. Level Validator CI
`tools/validator` runs on every PR touching levels or `puzzle_core`:
1. Schema v3 validation.
2. Solvable with **0 hearts lost & 0 boosters** (BFS/IDA\*, node limit 2M, depth ≤ 3×P).
3. D within slot band ±3; D formula standard §9.4.
4. No thread locked forever; no infinite lane loops (portal/deflector).
5. Min cell ≥ 29 dp at 360 dp width (Phase 1 ≤ 11×11).
6. Intro levels: intro mechanic + ≤ 1 earlier mechanic.
7. FTUE: L1–3 optimal ≤ 4 Moves, L4–10 ≤ 8 Moves.
8. Game-specific: spinner-needle thread length ≥ 2 (M013), Sequins reachable via lane, Fraying N feasible, M033 cage colour ≠ caged colour.
9. `solution` and `par_moves` recomputed and must match JSON.

## 14. QA Checklist
All items status **Not run** until executed on the device matrix (§14.1). Status values: Not run / Pass / Fail / Blocked.

### 14.1 Device matrix
| ID | Device | OS | Notes |
|---|---|---|---|
| DM-1 | Redmi 9A (2 GB) | Android 10 | low-tier 60 fps |
| DM-2 | Samsung Galaxy A14 | Android 13 | mid-tier |
| DM-3 | Pixel 7 | Android 14 | 90 Hz |
| DM-4 | Galaxy S23 | Android 14 | 120 Hz |
| DM-5 | iPhone SE (2nd gen) | iOS 16 | small screen |
| DM-6 | iPhone 15 Pro | iOS 17 | ProMotion 120 Hz |
| DM-7 | iPad (9th gen) | iPadOS 17 | 4:3 tablet |
| DM-8 | 21:9 phone (Sony Xperia 10) | Android 13 | tall aspect |

### 14.2 Test cases
| ID | Area | Steps | Expected | Status |
|---|---|---|---|---|
| QA-001 | Rules: tap exit | L1: tap a body cell (not needle) of clear thread | Thread unravels along lane, removed, Moves +1 | Not run |
| QA-002 | Rules: bump | Tap thread with blocked lane | Snag animation ≤ 450 ms, −1 heart, board unchanged, Moves +1 | Not run |
| QA-003 | Rules: win | Clear all threads (+ goals) | Win celebration, Level Complete | Not run |
| QA-004 | Rules: locked tap | Tap Knotted Thread with K>0 | Wobble + tick, hearts and Moves unchanged | Not run |
| QA-005 | Rules: input queue | Tap 3 threads rapidly during animation | Only last tap processed after animation | Not run |
| QA-006 | Rules: tap priority | L321+: tap overlap cell | Upper layer thread acts | Not run |
| QA-007 | Rules: Thread Peek | Long-press 350 ms | Green/red dotted lane, no Move, release no tap | Not run |
| QA-008 | Rules: determinism | Replay same tap sequence twice (test harness) | Identical state hashes | Not run |
| QA-009 | Rules: no timer | Leave level idle 10 min | Nothing changes | Not run |
| QA-010 | Hint | Use Needle Glow Hint on solution prefix | Correct next Move glows; Move not counted; count −1 | Not run |
| QA-011 | Hint off-prefix | Make non-solution moves, use Hint | On-device solver result ≤ 50 ms or "Try Restart" with no consume | Not run |
| QA-012 | Hint cap | Use 3 Hints in one attempt | 4th disabled "3/3" | Not run |
| QA-015 | Shield | Activate Thimble Shield, bump 3 times | First 2 absorbed (no heart, ★ unaffected), 3rd −1 heart | Not run |
| QA-016 | Shield lapse | Activate, win with 1 charge left, next level | Charge gone | Not run |
| QA-017 | Hammer | Golden Scissors on Wooden Button | Removed; booster −1; not a Move | Not run |
| QA-018 | Hammer non-hammerable | Target Hem Wall / Clasp / Guardian | Not selectable, toast, no consume | Not run |
| QA-019 | Hammer cap | Use 2 in one attempt | 3rd disabled | Not run |
| QA-020 | Hammer thread | Snip key-thread | Counts as exit, clasp opens | Not run |
| QA-021 | Booster empty | Tap booster with count 0 | Mini shop sheet | Not run |
| QA-022 | Revive ad | 0 hearts → watch ad | +1 heart, board not reset, `adReviveUsed[level]=true` | Not run |
| QA-023 | Revive once per level | Fail again same level after restart | Ad option hidden | Not run |
| QA-024 | Revive reset | Clear level, replay, fail | Ad option available again | Not run |
| QA-025 | Heart Refill | 0 hearts, pay 120 twice | +1 each; third option hidden; coins −240 | Not run |
| QA-026 | Second Chance timeout | Wait 10 s | Level Failed; Retry gives 3 hearts, reset board | Not run |
| QA-027 | Ad unavailable | Airplane mode at Second Chance | Ad disabled + text; coin option works | Not run |
| QA-028 | Stars | Win with 0 / 1 / 2 hearts lost / revive | ★★★ / ★★ / ★ / ★ | Not run |
| QA-029 | Coins first clear | Clear Easy/Normal/Hard/Finale first time | +15 / +20 / +30 / +50 | Not run |
| QA-030 | Replay coins | Replay cleared level | 0 clear coins; star improvement saved | Not run |
| QA-031 | ★★★ bonus | First ★★★ | +20 once only | Not run |
| QA-032 | 2X Win | Watch 2X ad | Base clear coins doubled, star bonus not | Not run |
| QA-033 | Gift Box | Clear L10, L20, L30, L40, L110 | 150+Hint, 150+Hammer, 150+Shield, 150+Hint, 180+Hammer | Not run |
| QA-034 | Phase Chest | Clear L500 | 1,000 + 2 each booster + badge, then Coin Rush, then Phase Complete | Not run |
| QA-035 | Coin Rush | First clear L25; replay L25 | Rush 30 s, 20 threads (T1), 10/thread, +100 full clear; replay ⇒ no Rush | Not run |
| QA-036 | Rush order | Win L50 | Craft Basket first, then Coin Rush; no interstitial | Not run |
| QA-037 | Rush background | Background app mid-Rush | Timer pauses | Not run |
| QA-038 | Daily unlock | Before/after L15 clear | Locked / available | Not run |
| QA-039 | Daily seed | Two devices same local date, same highestCleared | Same board | Not run |
| QA-040 | Daily modifiers | Force each weekday (debug) | Mon–Sun modifiers per [05 §3] incl. fallbacks | Not run |
| QA-041 | Daily reward | Clear Daily twice | +100 + streak once | Not run |
| QA-042 | Streak ladder | Clear 7 consecutive days (debug clock via server mock) | Rewards Day 1–7 exact; trophy Bronze; Day 8 = Day 1 | Not run |
| QA-043 | Streak miss 1 | Skip 1 day | Darning Patch offer (ad / 200); accept ⇒ continue, missed reward not granted | Not run |
| QA-044 | Saver once per cycle | Miss 1 day twice in a cycle | Second time reset | Not run |
| QA-045 | Streak miss 2+ | Skip 2 days | Reset Day 1, no offer | Not run |
| QA-046 | Time-travel lock | Set clock back 3 h | Daily/Streak/Spin locked until clock passes lastTrustedUtc | Not run |
| QA-047 | 20 h rule | Claim 23:59, again 00:05 | Second claim pending until 20 h | Not run |
| QA-048 | Offline daily | Airplane mode, clear Daily, go online with forward-shifted clock | Reward kept, streak freeze on mismatch | Not run |
| QA-049 | Spin | Before L10 clear check Home; after L10 clear: free spin, ad spin, third attempt | Hidden before L10 clear; then 2 max/day; odds screen visible | Not run |
| QA-050 | Spin determinism | Same installId/dayKey/spinIndex | Same prize | Not run |
| QA-051 | Shop boosters | Buy single and 3-pack of each | Prices 60/150, 40/100, 80/200, 100/250 | Not run |
| QA-052 | Shop free coins | Watch 5 ads | +50 each; 6th disabled | Not run |
| QA-053 | IAP coins | Buy S/M/L/XL (test accounts) | 350/1,000/2,200/5,500 after verification | Not run |
| QA-054 | Starter Pack | Clear L15, wait > 48 h | Offer visible 48 h only; content 800 + 3 Hint + 2 Hammer + 2 Shield; one-time | Not run |
| QA-055 | VIP | Subscribe ₹20 | Interstitial + banner off; rewarded still optional | Not run |
| QA-056 | VIP expiry | Let test subscription expire | Ads return | Not run |
| QA-057 | Restore | Reinstall, Restore purchases | VIP + Starter flag restored | Not run |
| QA-058 | IAP verify fail | Mock Cloud Function failure | No grant, error message | Not run |
| QA-059 | Interstitial L1–10 | Win L1–10 | Never shown | Not run |
| QA-060 | Interstitial cadence | Win L11–L15 | First interstitial after L15 win (if no reward screen, cooldown ok) | Not run |
| QA-061 | Interstitial defer | 5th win = L20 (Gift Box) | Deferred to next win | Not run |
| QA-062 | Interstitial cooldown | Rewarded ad then eligible win < 120 s | Deferred | Not run |
| QA-063 | No interstitial after fail/Daily/Rush | Trigger each | None | Not run |
| QA-064 | Interstitial daily cap | Simulate 21 eligible | Max 20 | Not run |
| QA-065 | Banner placement | Home, Map, Gameplay L10, L11, Shop | Shown Home/Map/Gameplay L11+ only; ≥ 8 dp gap + divider; never overlaps board | Not run |
| QA-066 | Age gate | Enter under-13 year | Child-directed tag, G rating, non-personalized ads | Not run |
| QA-067 | UMP | EEA VPN fresh install | Consent form before any ad request | Not run |
| QA-068 | Families policy | Inspect SDK list | Only Families self-certified ad SDKs | Not run |
| QA-069 | Persistence | Kill app after reward | Reward persisted | Not run |
| QA-070 | Save corruption | Corrupt save file | Backup restored | Not run |
| QA-071 | Save migration | Install v1 save into newer build | Migrated, no loss | Not run |
| QA-072 | Offline play | Airplane mode full session | Levels, Daily, Shop coins items work; IAP/ads disabled gracefully | Not run |
| QA-073 | Performance low-tier | DM-1, L500 (30 threads) | 60 fps, no jank > 2 frames during unravel | Not run |
| QA-074 | Performance 120 Hz | DM-4, DM-6 | 120 fps; raster p95 < 8 ms on DM-2 | Not run |
| QA-075 | Board fit | DM-5, DM-7, DM-8, 11×11 board | Full board visible, cell ≥ 29 dp, no clipping, safe areas respected | Not run |
| QA-076 | Accessibility colour | Grayscale filter on | All threads distinguishable by pattern + icon | Not run |
| QA-077 | Accessibility text | System text 1.3× | No clipped HUD/button text | Not run |
| QA-078 | Accessibility tap | Tap targets audit | UI ≥ 48 dp | Not run |
| QA-079 | Reduce motion | Toggle on | Confetti off, shake reduced | Not run |
| QA-080 | Localization | gu, hi | All strings translated, no overflow | Not run |
| QA-081 | Leaderboards | Sign in, clear level | Highest Level / Stars / Streak submitted | Not run |
| QA-082 | FTUE | Fresh install L1–10 | Tutorial steps fire `ftue_step`; grants 3 Hint (L3) | Not run |
| QA-083 | Booster unlocks | L15, L25 | Shield / Golden Scissors tutorials and grants; L20 Scissors locked until 25 | Not run |
| QA-084 | Analytics | Run session | All standard §15 events with params | Not run |
| QA-085 | Validator CI | Run `tools/validator` on phase_1.json.gz | All 500 levels pass §13 checks | Not run |
| QA-086 | Validator negative | Inject unsolvable / out-of-band level | CI fails with level id | Not run |
| QA-087 | Lamplight | L401 | Lit area follows last moved thread; Peek lit; rules unchanged | Not run |
| QA-088 | Phase Complete | After L500 with `maxPhase=1` | Phase Complete + teaser | Not run |
| QA-090 | Hammer last thread | Sequins level, 1 thread left, 1 sequin uncollected | Golden Scissors disabled on that thread | Not run |
| QA-091 | Hammer exit effects | Snip key-thread / thread lane over Sequin | Clasp opens; Sequin NOT collected, Chalk HP unchanged | Not run |
| QA-092 | Tangled thread | Rotate Spool Spinner so needle faces own body, tap thread | Locked tap (wobble), no heart, no Move | Not run |
| QA-093 | Tap priority interactive | Tap spinner/rotor cell occupied by a thread cell | Mechanic acts, not thread | Not run |
| QA-094 | Tick order | Test harness: Basting Seam + Fraying Thread + Rolling Yarn Ball same Move | Ticks M007 → M017 → M031 → M025 → M027 → M047 → M041; win check before 0-heart check | Not run |
| QA-095 | Hungry Path | Bead-Stringer Thread with clear lane, no bead | Bump (−1 heart), not locked tap | Not run |
| QA-096 | Rush bump | Snag during Golden Bobbin Rush | Wobble only, no heart | Not run |
| QA-097 | Interstitial replays | Replay cleared L11+ levels 5 times | Replays count toward interstitial counter | Not run |
| QA-098 | Daily rules | Daily clear; Daily revive twice same dayKey; Saver after today's clear | No 2X offer; ad revive once per dayKey; Saver not offered after clear | Not run |
| QA-099 | Soft-lock | Debug-inject unwinnable state | "Stuck" sheet Restart, no heart loss, `E-GAME-004` logged | Not run |
| QA-100 | Level unavailable | Corrupt one level entry in debug bundle | "Level unavailable" + Retry; level not skipped/cleared; `E-LVL-001` | Not run |
| QA-101 | Settings | Toggle Sound / Music / Haptics / Share diagnostics; open Report a problem | Each toggle persists and applies; diagnostics off stops Crashlytics/analytics; Report ID shown | Not run |
| QA-102 | Sound suite | Run shared suite AUD-01…AUD-24 ([SOUND §11](../../SOUND_EFFECTS_IMPLEMENTATION.md#11-qa-checklist-status-not-run)) for Yarn Unravel | All AUD items per shared expected results | Not run |
| QA-103 | Logging suite | Run shared suite LOG-01…LOG-22 ([LOGGING §15](../../LOGGING_AND_ERROR_TRACKING.md#15-qa-checklist-status-not-run)) for Yarn Unravel | All LOG items per shared expected results | Not run |

### 14.3 Mechanic tests (one per M-ID)
| ID | Mechanic | Steps | Expected | Status |
|---|---|---|---|---|
| QA-M001 | M001 Wooden Button (Single Blocker) | Run `test/mechanics/m001_test.dart` + play intro L11 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M002 | M002 Ruler Strip (Long Wall) | Run `test/mechanics/m002_test.dart` + play intro L21 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M003 | M003 Knotted Thread (Frozen Path) | Run `test/mechanics/m003_test.dart` + play intro L31 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M004 | M004 Charm & Clasp (Key & Lock) | Run `test/mechanics/m004_test.dart` + play intro L41 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M005 | M005 Color Eyelet (Color Gate) | Run `test/mechanics/m005_test.dart` + play intro L51 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M006 | M006 Stitch Arrow (One-Way Tile) | Run `test/mechanics/m006_test.dart` + play intro L61 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M007 | M007 Basting Seam (Countdown Gate) | Run `test/mechanics/m007_test.dart` + play intro L71 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M008 | M008 Pompom Tunnel (Portal Pair) | Run `test/mechanics/m008_test.dart` + play intro L81 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M009 | M009 Presser Lever (Lever + Toggle Gates) | Run `test/mechanics/m009_test.dart` + play intro L91 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M010 | M010 Wool Fluff (Fog Patch) | Run `test/mechanics/m010_test.dart` + play intro L101 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M011 | M011 Ribbon-Tied Pair (Chained Pair) | Run `test/mechanics/m011_test.dart` + play intro L111 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M012 | M012 Coiled Thread (Sleeping Path) | Run `test/mechanics/m012_test.dart` + play intro L121 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M013 | M013 Spool Spinner (Turntable) | Run `test/mechanics/m013_test.dart` + play intro L131 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M014 | M014 Hook Deflector (Mirror) | Run `test/mechanics/m014_test.dart` + play intro L141 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M015 | M015 Stitch Bridge (Bridge) | Run `test/mechanics/m015_test.dart` + play intro L151 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M016 | M016 Tailor's Chalk (Cracked Rock) | Run `test/mechanics/m016_test.dart` + play intro L161 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M017 | M017 Fraying Thread (Countdown Path) | Run `test/mechanics/m017_test.dart` + play intro L171 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M018 | M018 Thread Guide Switch (Switch Junction) | Run `test/mechanics/m018_test.dart` + play intro L181 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M019 | M019 Foot Pedal Plate (Pressure Plate) | Run `test/mechanics/m019_test.dart` + play intro L191 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M020 | M020 Yarn Basket (Inner Exit (Hole)) | Run `test/mechanics/m020_test.dart` + play intro L201 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M021 | M021 Sheer Silk Thread (Phasing Path) | Run `test/mechanics/m021_test.dart` + play intro L211 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M022 | M022 Backstitch Thread (Reverse Path) | Run `test/mechanics/m022_test.dart` + play intro L221 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M023 | M023 Double-Needle Thread (Two-Head Path) | Run `test/mechanics/m023_test.dart` + play intro L231 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M024 | M024 Chunky Chenille (Wide Path) | Run `test/mechanics/m024_test.dart` + play intro L241 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M025 | M025 Rolling Yarn Ball (Patrol Blocker) | Run `test/mechanics/m025_test.dart` + play intro L251 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M026 | M026 Sequins (Collect Gems) | Run `test/mechanics/m026_test.dart` + play intro L261 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M027 | M027 Spreading Tangle (Spreader) | Run `test/mechanics/m027_test.dart` + play intro L271 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M028 | M028 Tagged Threads (Numbered Paths) | Run `test/mechanics/m028_test.dart` + play intro L281 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M029 | M029 Hem Wall (Edge Wall) | Run `test/mechanics/m029_test.dart` + play intro L291 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M030 | M030 Color Hem Gap (Color Edge) | Run `test/mechanics/m030_test.dart` + play intro L301 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M031 | M031 Zipper Edge (Closing Edge) | Run `test/mechanics/m031_test.dart` + play intro L311 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M032 | M032 Double Fabric Layers (Two Layers) | Run `test/mechanics/m032_test.dart` + play intro L321 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M033 | M033 Safety-Pin Cage (Color Cage) | Run `test/mechanics/m033_test.dart` + play intro L331 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M034 | M034 Quilt Block Rotor (Rotor 2×2) | Run `test/mechanics/m034_test.dart` + play intro L341 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M035 | M035 Skein Spawner (Spawner Path) | Run `test/mechanics/m035_test.dart` + play intro L351 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M036 | M036 Bead-Stringer Thread (Hungry Path) | Run `test/mechanics/m036_test.dart` + play intro L361 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M037 | M037 Glue Dot (Mud Trap) | Run `test/mechanics/m037_test.dart` + play intro L371 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M038 | M038 Elastic Hop Pad (Jump Pad) | Run `test/mechanics/m038_test.dart` + play intro L381 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M039 | M039 Twin Skeins (Mirror Twins) | Run `test/mechanics/m039_test.dart` + play intro L391 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M040 | M040 Lamplight Evening (Night Board) | Run `test/mechanics/m040_test.dart` + play intro L401 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M041 | M041 Ombre Thread (Chameleon Path) | Run `test/mechanics/m041_test.dart` + play intro L411 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M042 | M042 Fragile Lace Bridge (Fragile Bridge) | Run `test/mechanics/m042_test.dart` + play intro L421 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M043 | M043 Multi-Clasp (Multi-Lock) | Run `test/mechanics/m043_test.dart` + play intro L431 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M044 | M044 Twisting Pompom Tunnel (Turning Portal) | Run `test/mechanics/m044_test.dart` + play intro L441 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M045 | M045 Treadle Gear Lever (Gear Lever) | Run `test/mechanics/m045_test.dart` + play intro L451 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M046 | M046 Knitted Loop (Loop Path) | Run `test/mechanics/m046_test.dart` + play intro L461 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M047 | M047 Growing Knit Thread (Growing Path) | Run `test/mechanics/m047_test.dart` + play intro L471 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M048 | M048 Color Bundle (Color Group Tap) | Run `test/mechanics/m048_test.dart` + play intro L481 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M049 | M049 Grand Pincushion Guardian (Guardian) | Run `test/mechanics/m049_test.dart` + play intro L491 on device | Rule per card holds; bump/locked behaviour correct; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |

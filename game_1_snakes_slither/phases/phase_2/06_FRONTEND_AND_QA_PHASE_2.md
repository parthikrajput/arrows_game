# 06 — Frontend & QA (Phase 2)
> Phase 1 architecture પર Phase 2 ના additions: નવા BLoCs, pinch-zoom/pan camera, diagonal lanes & slither rendering, sunbeam renderer, 3 layers, push blocks, નવા save fields, 14×14 / 40 snakes performance, monitoring અને પૂરો Phase 2 QA checklist.

**Related docs:** [Phase 2 index](./README.md) · [Shared Core Standard §12–§16](../../SHARED_CORE_STANDARD.md) · [Phase 1 Frontend & QA](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) · [01 Phase 2 Rules](./01_PHASE_2_SCOPE_AND_RULES.md) · [03 Catalog](./03_OBSTACLE_CATALOG_PHASE_2.md) · [04 LiveOps](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [05 Sync](./05_OFFLINE_AND_CLOUD_SYNC.md)

---

## 1. Architecture Additions
Phase 1 decisions યથાવત (CustomPainter + Ticker, flutter_bloc, `puzzle_core`, hive_ce). Phase 2 ઉમેરે:

| Area | Addition |
|---|---|
| Engine (`puzzle_core`) | `Dir` 8 values, 8-connected bodies, `LaneTracer` (diagonal + squeeze + layer switch + running colour), `BeamTracer`, push resolution, `transform(rotation)`, 49 mechanics `m051_…` – `m099_…`, Phase 2 tick order (standard §16.17) |
| Rendering | `BoardCamera` (zoom/pan), camera-aware painters, `BeamPainter`, layer z-order + covered desaturation, coconut/rotation/swap animations, shadow sprite atlas |
| Input | `RawGestureDetector`: tap + 350 ms long-press + scale (pinch/pan); capsule hit-test; ambiguous tap guard |
| New BLoCs | `AlbumCubit`, `RaceBloc`, `PiggyCubit`, `CosmeticsCubit`, `AccountCubit`, `SyncCubit` |
| Services | `SyncService` + `OpLog` ([05 §9](./05_OFFLINE_AND_CLOUD_SYNC.md#9-sync-engine)), `MonotonicClock` (MethodChannel), `AuthService`, `RaceService` |
| Firebase | + `firebase_auth`, `cloud_firestore` (read-only listeners), `cloud_functions` (callables), App Check |
| Data | `assets/levels/phase_2.json.gz`, `assets/album/stk_*.webp`, cosmetics atlases |

```
Tap ─► ZoomableBoard (camera.toCellSpace) ─► capsule hit-test ─► GameBloc.add(SnakeTapped)
GameBloc ─► Engine.apply() ─► MoveResult{next, animations[exit|bump|push|slide|rotate|swap|split], beams, events}
events ─► WalletCubit / ProgressCubit / AlbumCubit / PiggyCubit ─► SyncService.record(op)
```

## 2. Folder Additions
```
apps/snakes_slither/lib/
├── features/
│   ├── gameplay/render/   board_camera.dart, beam_painter.dart, layer_painter.dart, push_anim.dart
│   ├── gameplay/input/    zoomable_board.dart, capsule_hit_test.dart
│   ├── album/             album_cubit.dart, album_page.dart
│   ├── race/              race_bloc.dart, race_page.dart, race_track_hud.dart
│   ├── piggy/             piggy_cubit.dart, piggy_sheet.dart
│   ├── cosmetics/         cosmetics_cubit.dart, style_tab.dart, skin_renderer.dart
│   └── account/           account_cubit.dart, account_page.dart, delete_account_flow.dart
├── services/sync/         sync_service.dart, op_log.dart, monotonic_clock.dart, auth_service.dart
packages/puzzle_core/lib/src/mechanics/   m051_diagonal_paths.dart … m099_master_lock.dart
packages/puzzle_core/lib/src/beams/       beam_tracer.dart
functions/src/            syncPush.ts, mergeAnonymous.ts, deleteAccount.ts, raceJoin.ts, raceProgress.ts, raceFinalize.ts
```

## 3. Zoom & Pan
### 3.1 Camera Model
- Board space: cell units. Screen: `screen = origin + cellPos × cell`, `cell = fitCell × scale`, `scale ∈ [1, maxScale]`, `maxScale = 56 / fitCell`.
- Zoom around focal `f`: `origin' = f − (f − origin) × (cell' / cell)`.
- Clamp ([01 §2.3](./01_PHASE_2_SCOPE_AND_RULES.md#23-limits)): board viewport કરતાં મોટું ⇒ `origin.dx ∈ [vw − bw − 24, 24]`; નાનું ⇒ centered.
- Static board picture **board space** માં record (cell = 1 × `kRecordCell`), દરેક frame `canvas.translate/scale` થી draw ⇒ zoom/pan પર picture rebuild નહીં (vector replay crisp).

### 3.2 Code
```dart
// lib/features/gameplay/render/board_camera.dart
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class BoardCamera extends ChangeNotifier {
  BoardCamera({required this.cols, required this.rows, this.maxCellDp = 56, this.edgeInsetDp = 24});

  final int cols;
  final int rows;
  final double maxCellDp;
  final double edgeInsetDp;

  Size _viewport = Size.zero;
  double _fitCell = 1;
  double _cell = 1;
  Offset _origin = Offset.zero;

  bool get zoomEnabled => math.max(cols, rows) >= 12;
  double get cell => _cell;
  double get fitCell => _fitCell;
  Offset get origin => _origin;
  bool get isZoomedIn => _cell > _fitCell + 0.01;

  /// Called from layout; does not notify (safe during build).
  void layout(Size viewport) {
    if (viewport == _viewport) return;
    _viewport = viewport;
    const gutter = 16.0;
    _fitCell = math.min((viewport.width - 2 * gutter) / cols, viewport.height / rows).floorToDouble();
    _cell = _fitCell;
    _origin = _centered(_cell);
  }

  Offset _centered(double cell) => Offset(
        (_viewport.width - cols * cell) / 2,
        (_viewport.height - rows * cell) / 2,
      );

  void zoomTo(double targetCell, Offset focal) {
    if (!zoomEnabled) return;
    final double next = targetCell.clamp(_fitCell, math.max(_fitCell, maxCellDp)).toDouble();
    _origin = focal - (focal - _origin) * (next / _cell);
    _cell = next;
    _clamp();
    notifyListeners();
  }

  void panBy(Offset delta) {
    if (!zoomEnabled || !isZoomedIn) return;
    _origin += delta;
    _clamp();
    notifyListeners();
  }

  void fit() {
    _cell = _fitCell;
    _origin = _centered(_cell);
    notifyListeners();
  }

  void _clamp() {
    final bw = cols * _cell;
    final bh = rows * _cell;
    final c = _centered(_cell);
    final dx = bw <= _viewport.width
        ? c.dx
        : _origin.dx.clamp(_viewport.width - bw - edgeInsetDp, edgeInsetDp);
    final dy = bh <= _viewport.height
        ? c.dy
        : _origin.dy.clamp(_viewport.height - bh - edgeInsetDp, edgeInsetDp);
    _origin = Offset(dx.toDouble(), dy.toDouble());
  }

  /// Screen (local) point → board space (cell units, fractional).
  Offset toCellSpace(Offset local) => (local - _origin) / _cell;

  Offset cellCenter(int x, int y) => _origin + Offset((x + 0.5) * _cell, (y + 0.5) * _cell);
}
```

```dart
// lib/features/gameplay/input/zoomable_board.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../render/board_camera.dart';

class ZoomableBoard extends StatefulWidget {
  const ZoomableBoard({
    super.key,
    required this.camera,
    required this.onTapCellSpace,
    required this.onLongPressCellSpace,
    required this.onLongPressEnd,
    required this.child,
  });

  final BoardCamera camera;
  final void Function(Offset cellSpace) onTapCellSpace;
  final void Function(Offset cellSpace) onLongPressCellSpace;
  final VoidCallback onLongPressEnd;
  final Widget child;

  @override
  State<ZoomableBoard> createState() => _ZoomableBoardState();
}

class _ZoomableBoardState extends State<ZoomableBoard> {
  double _startCell = 1;
  Offset _lastFocal = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        widget.camera.layout(constraints.biggest);
        return RawGestureDetector(
          behavior: HitTestBehavior.opaque,
          gestures: <Type, GestureRecognizerFactory>{
            TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              TapGestureRecognizer.new,
              (r) {
                r.onTapUp = (d) => widget.onTapCellSpace(widget.camera.toCellSpace(d.localPosition));
              },
            ),
            LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
              () => LongPressGestureRecognizer(duration: const Duration(milliseconds: 350)),
              (r) {
                r
                  ..onLongPressStart = (d) =>
                      widget.onLongPressCellSpace(widget.camera.toCellSpace(d.localPosition))
                  ..onLongPressEnd = (_) => widget.onLongPressEnd();
              },
            ),
            ScaleGestureRecognizer: GestureRecognizerFactoryWithHandlers<ScaleGestureRecognizer>(
              ScaleGestureRecognizer.new,
              (r) {
                r
                  ..onStart = (d) {
                    _startCell = widget.camera.cell;
                    _lastFocal = d.localFocalPoint;
                  }
                  ..onUpdate = (d) {
                    final cam = widget.camera;
                    if (d.pointerCount >= 2) cam.zoomTo(_startCell * d.scale, d.localFocalPoint);
                    cam.panBy(d.localFocalPoint - _lastFocal); // no-op at fit scale
                    _lastFocal = d.localFocalPoint;
                  };
              },
            ),
          },
          child: widget.child,
        );
      },
    );
  }
}
```
- Tap slop = Flutter `kTouchSlop` (18 dp) ⇒ [01 §2.2](./01_PHASE_2_SCOPE_AND_RULES.md#22-gestures-tap-સાથે-conflict-વગર) સાથે match. Movement > slop ⇒ scale recognizer arena જીતે ⇒ tap/long-press cancel.
- Hit-test: `toCellSpace` ⇒ capsule nearest segment (radius 0.42 cell, slop 0.6 cell at `fitCell < 29`), ambiguous guard ([01 §2.4](./01_PHASE_2_SCOPE_AND_RULES.md#24-cell-size-rule-phase-2)).

### 3.3 Camera & Animations
- Hint off-screen ⇒ `camera.animateTo(target)` (Ticker tween 300 ms, `Curves.easeOutCubic`).
- Exit/bump animations board space માં; camera independent. Off-screen bump ⇒ HUD edge chevron.
- `reducedMotion` ⇒ camera tweens instant.

### 3.4 Accessibility Zoom Buttons
Settings → Accessibility → "Zoom buttons" (auto ON જો switch access / single-pointer device): HUD પર ＋ / − / Fit (48 dp), ＋ = cell × 1.25 at viewport center; pan = 4 arrow buttons (dpad overlay) ⇒ multi-touch વગર પણ Phase 2 પૂરું રમી શકાય.

## 4. Diagonal Lanes & Slither Rendering
```dart
// packages/puzzle_core/lib/src/model/dir.dart (pure Dart, no Flutter)
import 'dart:math' as math;

enum Dir {
  up(0, -1, 'U'),
  right(1, 0, 'R'),
  down(0, 1, 'D'),
  left(-1, 0, 'L'),
  upRight(1, -1, 'UR'),
  downRight(1, 1, 'DR'),
  downLeft(-1, 1, 'DL'),
  upLeft(-1, -1, 'UL');

  const Dir(this.dx, this.dy, this.code);

  final int dx;
  final int dy;
  final String code;

  bool get isDiagonal => dx != 0 && dy != 0;
  double get stepLength => isDiagonal ? math.sqrt2 : 1.0;

  /// 90° clockwise (screen y grows downward).
  Dir get cw => switch (this) {
        Dir.up => Dir.right,
        Dir.right => Dir.down,
        Dir.down => Dir.left,
        Dir.left => Dir.up,
        Dir.upRight => Dir.downRight,
        Dir.downRight => Dir.downLeft,
        Dir.downLeft => Dir.upLeft,
        Dir.upLeft => Dir.upRight,
      };

  static Dir parse(String code) => Dir.values.firstWhere((d) => d.code == code);

  static Dir fromDelta(int dx, int dy) =>
      Dir.values.firstWhere((d) => d.dx == dx.sign && d.dy == dy.sign);
}

typedef GridPos = ({int x, int y});

/// No X-crossing rule (01 §3.3): a diagonal step from [c] is squeezed when the
/// two orthogonal side cells are consecutive body cells of one snake.
bool diagonalSqueezed(GridPos c, Dir d, bool Function(GridPos a, GridPos b) isBodyLink) {
  if (!d.isDiagonal) return false;
  return isBodyLink((x: c.x + d.dx, y: c.y), (x: c.x, y: c.y + d.dy));
}

/// Body length in cell units for 8-connected bodies (diagonal link = √2).
double bodyLengthCells(List<GridPos> body) {
  var total = 0.0;
  for (var i = 1; i < body.length; i++) {
    final diag = body[i].x != body[i - 1].x && body[i].y != body[i - 1].y;
    total += diag ? math.sqrt2 : 1.0;
  }
  return total;
}
```
- Phase 1 renderer નો `bodyLength = (n − 1) × cell` ⇒ Phase 2 માં `bodyLengthCells(body) × cell` (નહીં તો diagonal snakes exit વખતે "ખેંચાય").
- Track = tail → body centers → lane waypoints (Phase 1 `buildTrack` યથાવત; diagonal waypoints `head + k·(dx,dy)`); redirect corners (bumper, mirror) radius 0.3 cell.
- Lane exit length: diagonal lane cells × √2 + body length + 1; duration `min(450, 250 + 25 × laneCells)` ms (standard ≤ 450 ms).
- Sidewinder look: wiggle amplitude perpendicular to local tangent (PathMetrics tangent) — diagonal પણ same code.
- Head sprite rotation = `atan2(dy, dx)`; eyes 8 directions (pre-rendered 8 frames atlas).

## 5. Beam Renderer
```dart
// lib/features/gameplay/render/beam_painter.dart
import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import 'board_camera.dart';

@immutable
class BeamSegment {
  const BeamSegment(this.fromX, this.fromY, this.toX, this.toY);
  final int fromX;
  final int fromY;
  final int toX;
  final int toY;
}

class BeamPainter extends CustomPainter {
  BeamPainter({required this.camera, required this.segments, required this.phase, this.reducedMotion = false})
      : super(repaint: camera);

  final BoardCamera camera;
  final List<BeamSegment> segments; // replaced (new list) when beams change in step 4
  final double phase; // 0..1 shimmer phase from the Ticker
  final bool reducedMotion;

  static const Color _core = Color(0xFFFFE082);
  static const Color _halo = Color(0xFFFFCA28);

  @override
  void paint(Canvas canvas, Size size) {
    final cell = camera.cell;
    final halo = Paint()
      ..color = _halo.withValues(alpha: 0.28)
      ..strokeWidth = cell * 0.55
      ..strokeCap = StrokeCap.round;
    final core = Paint()
      ..color = _core.withValues(alpha: 0.9)
      ..strokeWidth = cell * 0.16
      ..strokeCap = StrokeCap.round;
    final mote = Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: 0.7);

    for (final s in segments) {
      final a = camera.cellCenter(s.fromX, s.fromY);
      final b = camera.cellCenter(s.toX, s.toY);
      canvas.drawLine(a, b, halo); // wide translucent stroke instead of per-frame blur
      canvas.drawLine(a, b, core);
      if (reducedMotion) continue;
      final length = (b - a).distance;
      if (length <= 0) continue;
      final count = math.max(1, (length / cell * 2).round());
      for (var i = 0; i < count; i++) {
        final t = (i / count + phase) % 1.0;
        final p = Offset.lerp(a, b, t)!;
        canvas.drawCircle(p, cell * 0.04, mote);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BeamPainter oldDelegate) =>
      !identical(oldDelegate.segments, segments) ||
      oldDelegate.phase != phase ||
      oldDelegate.reducedMotion != reducedMotion;
}
```
- Z-order: floor/static picture → **beams** → snakes → mist/fog overlay → HUD. Beam cells under a snake body never drawn (beam stops there).
- Beam change (step 4) ⇒ 150 ms "grow/shrink" tween along segment (front cell only).
- Shimmer phase 30 Hz enough; low-tier ⇒ motes off when > 20 beam cells on screen.

## 6. Three Layers, Push Blocks & Board Transforms
| Topic | Rule |
|---|---|
| Layer draw order | Ground snakes → canopy shadows → Canopy snakes → treetop shadows → Treetop snakes |
| Covered desaturation | `ColorFilter.matrix` (saturation 0.65) on covered snake paint — static picture માં baked (cover change = Move commit ⇒ rebuild) |
| Shadows | Pre-rendered shadow sprite atlas (startup પર એક વાર blur ⇒ `ui.Image`), `drawImageRect` થી ⇒ zoom/pan replay cheap (picture માં `MaskFilter` નહીં) |
| Ramp exit | Moving snake z-index ramp cell પાર કરે ત્યાં switch |
| Coconut push/slide | Moving sprite layer; static picture coconut વગર rebuild push શરૂ થાય ત્યારે |
| Whirlwind (M079) | Content layer rotate 400 ms around board center (`canvas.rotate`), પછી static rebuild |
| Global rotator (M070) | Heads swivel 250 ms (neck joint), body static |
| Swap (M060) | Cross-fade 2 snakes 300 ms + toad hop |
| Split (M093) / segment (M092) | Split sparkle 200 ms; segment exit = normal exit motion of sub-body |

## 7. BLoCs, Events & Save Fields
| Bloc / Cubit | Owns | Key events / methods |
|---|---|---|
| `GameBloc` (extended) | Attempt | + `ObstacleTapped` for M060/M070/M074/M091; MoveResult animations `push`, `slide`, `rotateBoard`, `swap`, `split`, `beamUpdate`; `CameraFitRequested` |
| `AlbumCubit` | Stickers, claims, silhouettes | `grantForLevel(l)`, `retroGrant(highest)`, `claimVolume(n)` |
| `RaceBloc` | Cohort, progress, results | `RaceOpened`, `RaceJoinRequested`, `RaceLevelCleared(l, stats)`, `CohortSnapshot(doc)`, `ResultsShown` |
| `PiggyCubit` | Balance, full flag, purchase state | `depositForFirstClear(l)`, `breakRequested()`, `purchaseVerified(grant)` |
| `CosmeticsCubit` | Owned, equipped, VIP entitlement | `buy(sku)`, `equip(sku)`, `onVipChanged(active)` |
| `AccountCubit` | Auth state, providers, delete | `linkGoogle()`, `linkApple()`, `loadExisting()`, `deleteAccount()` |
| `SyncCubit` | Queue length, last sync, error | `onSnapshot(s)`, `onQueueChanged(n)` |

**Save (Hive) additions:** `album`, `piggy`, `cosmetics`, `syncQueue` (standard §14) + `ext.account`, `ext.race`, `time.monoAtServerSync`, `time.bootId` — વિગત [05 §4](./05_OFFLINE_AND_CLOUD_SYNC.md#4-local-save-hive--phase-2-fields). Migration v1 → v2: defaults + album retroactive grant + bootstrap op enqueue. Unknown future version ⇒ read-only + "Update app" (Phase 1 rule).

**Analytics additions:** `zoom_used`, `fit_tap`, `ambiguous_tap`, LiveOps events ([04 §6](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md#6-analytics-liveops)), `sync_push{ops, ms}`, `sync_reject{type}`, `auth_link{provider}`, `account_delete{}`.

## 8. Performance (14×14, 40 snakes)
| Metric | Budget | How |
|---|---|---|
| Frame rate | 60 fps low-tier (Redmi 9A class) on L951–1000 boards (14×14, 40 snakes, 12–14 obstacles, beams) during pan/zoom + exit | Static picture board-space replay; no picture rebuild on camera change |
| Raster p95 | < 8 ms mid-tier (standard §13) | `FrameTiming` capture in profile builds |
| Static rebuild | ≤ 3 ms mid-tier per Move commit (Phase 1: 2 ms; 40 snakes) | Per-layer pictures: rebuild only changed layer |
| Per-frame paint | 1 moving snake (or segment/coconut) + beams shimmer + preview | Others cached |
| Hit-test | ≤ 0.2 ms (≤ 40 × 8 capsules) | Linear scan, early-out by bbox |
| Hint solver | Isolate, 50 ms, 50k nodes (standard §12) | Phase 2 state encode compact (bitsets); fail ⇒ "Try Restart" |
| Level load | ≤ 150 ms (`phase_2.json.gz` lazy decode in isolate, per-level cached) | |
| Memory | ≤ 280 MB peak low-tier (Phase 1: 250 + album thumbnails) | Album images decoded at 256 px thumbnails |
| Sync | `syncPush` batch ≤ 20 s timeout, off main isolate JSON | |

Device matrix: Phase 1 matrix ([Phase 1 07 §11](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md#11-performance-budget)) + 6.1" 360 dp wide Android (fit cell 23 dp check).

## 9. Monitoring & Rollout
- Staged rollout 5% → 20% → 100% with `maxPhase = 1`, પછી Remote Config `maxPhase = 2` (README §4).
- Alerts: Crashlytics crash-free < 99.5% ⇒ halt; Functions error rate > 2% / p95 latency > 3 s; Firestore reads/day budget; `sync_reject` spike; race `excluded` rate.
- Kill switches: `featureFlags.race/piggy/album/cosmetics/cloudSync` (cloudSync OFF ⇒ ops queue locally, no data loss).

## 10. QA Checklist
Priority: P0 = release blocker, P1 = fix before next patch. **Status: બધા "Not run"** (run થયા પછી જ Pass/Fail).

| ID | Area | Steps | Expected | Pri | Status |
|---|---|---|---|---|---|
| QA-ZOOM-01 | Zoom | Open L501 (12×12) | Auto-fit; pinch tutorial; zoom enabled | P0 | Not run |
| QA-ZOOM-02 | Zoom | Pinch in to max | Cell = 56 dp; no further zoom | P0 | Not run |
| QA-ZOOM-03 | Zoom | Pinch out below fit | Stops at fit | P0 | Not run |
| QA-ZOOM-04 | Pan | Zoomed, 1-finger drag 40 dp | Pans; no tap/Move | P0 | Not run |
| QA-ZOOM-05 | Pan | At fit, 1-finger drag | Nothing; no Move | P1 | Not run |
| QA-ZOOM-06 | Zoom | Double-tap on snake | Two taps resolved (queue rule), no zoom | P1 | Not run |
| QA-ZOOM-07 | Zoom | 10×10 / 11×11 Phase 2 board pinch | Zoom disabled | P1 | Not run |
| QA-ZOOM-08 | Zoom | Second finger during 1-finger tap | Tap cancelled | P1 | Not run |
| QA-ZOOM-09 | Zoom | Tap between 2 tight snakes at fit (14×14) | Ambiguous guard toast, no Move | P0 | Not run |
| QA-ZOOM-10 | Zoom | Hint with target off-screen | Camera pans to target 300 ms | P1 | Not run |
| QA-ZOOM-11 | A11y | Zoom buttons ON, finish L501 without multitouch | ＋/−/Fit/dpad work | P1 | Not run |
| QA-DIAG-01 | Diagonal | Tap UR sidewinder with clear lane | Exits diagonally ≤ 450 ms, body length correct (no stretch) | P0 | Not run |
| QA-DIAG-02 | Diagonal | Lane through another snake's diagonal link | Bump (X-crossing) | P0 | Not run |
| QA-DIAG-03 | Diagonal | Lane between two different snakes' corner cells | Passes | P0 | Not run |
| QA-DIAG-04 | Diagonal | Exit from corner cell | Exit | P1 | Not run |
| QA-DIAG-05 | Diagonal | Diagonal lane into Bamboo One-Way | Bump | P1 | Not run |
| QA-LAYER-01 | Layers | Treetop covers canopy covers ground | Ground + canopy locked; peel order works | P0 | Not run |
| QA-LAYER-02 | Layers | Tap overlap cell | Highest layer snake | P0 | Not run |
| QA-LAYER-03 | Layers | Hammer target mode | Covered snakes not targetable | P0 | Not run |
| QA-LAYER-04 | Layers | Liana Ramp exit | Lane switches layer; bump returns to original layer | P0 | Not run |
| QA-PUSH-01 | Push | Push coconut into free cell | Coconut +1 cell, snake stays, Moves +1, hearts same | P0 | Not run |
| QA-PUSH-02 | Push | Push into edge / snake / coconut | Bump −1 | P0 | Not run |
| QA-PUSH-03 | Push | Push onto Slick Moss strip | Slides to end; ≤ 450 ms | P0 | Not run |
| QA-PUSH-04 | Push | Coconut onto Coconut Cradle | Gate opens; Hammer on that coconut blocked (toast) | P0 | Not run |
| QA-BEAM-01 | Beams | Lane into beam cell | Bump −1 | P0 | Not run |
| QA-BEAM-02 | Beams | Exit snake blocking beam | Beam extends after Move (step 4) | P0 | Not run |
| QA-BEAM-03 | Beams | Mirror Leaf + Prism routing to receiver | Receiver lit, gate opens | P0 | Not run |
| QA-BEAM-04 | Beams | Long-press preview across beam | Red ✕ at beam cell | P1 | Not run |
| QA-BEAM-05 | Beams | Reduced motion | No motes, beam static | P1 | Not run |
| QA-TICK-01 | Tick order | Level with M057 + M058 + M063 + M079 | Golden sequence matches standard §16.17 | P0 | Not run |
| QA-TICK-02 | Parity | M090 at moveCount 0, 1, 2 | Closed, open, closed (pre-increment parity) | P0 | Not run |
| QA-MECH-M051 | Mechanic | `m051_test.dart` (catalog §5 cases) + play intro L511 on device | Sidewinder Snake: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M052 | Mechanic | `m052_test.dart` (catalog §5 cases) + play intro L521 on device | Rubber Root Bumper: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M053 | Mechanic | `m053_test.dart` (catalog §5 cases) + play intro L531 on device | Rolling Coconut: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M054 | Mechanic | `m054_test.dart` (catalog §5 cases) + play intro L541 on device | Slick Moss: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M055 | Mechanic | `m055_test.dart` (catalog §5 cases) + play intro L551 on device | Coconut Cradle: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M056 | Mechanic | `m056_test.dart` (catalog §5 cases) + play intro L561 on device | Liana Ramp: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M057 | Mechanic | `m057_test.dart` (catalog §5 cases) + play intro L571 on device | Firefly Lantern Gate: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M058 | Mechanic | `m058_test.dart` (catalog §5 cases) + play intro L581 on device | Spinning Leaf Arrow: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M059 | Mechanic | `m059_test.dart` (catalog §5 cases) + play intro L591 on device | Berry Paint Puddle: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M060 | Mechanic | `m060_test.dart` (catalog §5 cases) + play intro L601 on device | Toad Swap Stone: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M061 | Mechanic | `m061_test.dart` (catalog §5 cases) + play intro L611 on device | Sleepy Den: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M062 | Mechanic | `m062_test.dart` (catalog §5 cases) + play intro L621 on device | Picnic Exit Quota: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M063 | Mechanic | `m063_test.dart` (catalog §5 cases) + play intro L631 on device | Honey Pot: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M064 | Mechanic | `m064_test.dart` (catalog §5 cases) + play intro L641 on device | Seesaw Branch Gates: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M065 | Mechanic | `m065_test.dart` (catalog §5 cases) + play intro L651 on device | Buried Leaf-Key: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M066 | Mechanic | `m066_test.dart` (catalog §5 cases) + play intro L661 on device | Vine-Tied Triplets: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M067 | Mechanic | `m067_test.dart` (catalog §5 cases) + play intro L671 on device | Crumbly Soil: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M068 | Mechanic | `m068_test.dart` (catalog §5 cases) + play intro L681 on device | Slime Trail Snake: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M069 | Mechanic | `m069_test.dart` (catalog §5 cases) + play intro L691 on device | Treetop Tiers: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M070 | Mechanic | `m070_test.dart` (catalog §5 cases) + play intro L701 on device | Wind Totem Lever: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M071 | Mechanic | `m071_test.dart` (catalog §5 cases) + play intro L711 on device | Counting Hedge Gate: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M072 | Mechanic | `m072_test.dart` (catalog §5 cases) + play intro L721 on device | Rainbow Parade: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M073 | Mechanic | `m073_test.dart` (catalog §5 cases) + play intro L731 on device | Dew Bubble Snake: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M074 | Mechanic | `m074_test.dart` (catalog §5 cases) + play intro L741 on device | Temple Stone Wall: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M075 | Mechanic | `m075_test.dart` (catalog §5 cases) + play intro L751 on device | Creeping Mist: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M076 | Mechanic | `m076_test.dart` (catalog §5 cases) + play intro L761 on device | Burrow Network: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M077 | Mechanic | `m077_test.dart` (catalog §5 cases) + play intro L771 on device | Boom Puffball: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M078 | Mechanic | `m078_test.dart` (catalog §5 cases) + play intro L781 on device | Walled Garden: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M079 | Mechanic | `m079_test.dart` (catalog §5 cases) + play intro L791 on device | Whirlwind Garden: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M080 | Mechanic | `m080_test.dart` (catalog §5 cases) + play intro L801 on device | Twin Bamboo Cages: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M081 | Mechanic | `m081_test.dart` (catalog §5 cases) + play intro L811 on device | Copycat Snake: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M082 | Mechanic | `m082_test.dart` (catalog §5 cases) + play intro L821 on device | River Current: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M083 | Mechanic | `m083_test.dart` (catalog §5 cases) + play intro L831 on device | Heavy Mossy Stone: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M084 | Mechanic | `m084_test.dart` (catalog §5 cases) + play intro L841 on device | Sunbeam Crystal: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M085 | Mechanic | `m085_test.dart` (catalog §5 cases) + play intro L851 on device | Sunflower Receiver: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M086 | Mechanic | `m086_test.dart` (catalog §5 cases) + play intro L861 on device | Dewdrop Mirror Leaf: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M087 | Mechanic | `m087_test.dart` (catalog §5 cases) + play intro L871 on device | Tree Sap Puddle: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M088 | Mechanic | `m088_test.dart` (catalog §5 cases) + play intro L881 on device | Thorny Burr Trap: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M089 | Mechanic | `m089_test.dart` (catalog §5 cases) + play intro L891 on device | Crystal Prism Flower: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M090 | Mechanic | `m090_test.dart` (catalog §5 cases) + play intro L901 on device | Tick-Tock Toadstool Gate: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M091 | Mechanic | `m091_test.dart` (catalog §5 cases) + play intro L911 on device | Great Whirl Stump: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M092 | Mechanic | `m092_test.dart` (catalog §5 cases) + play intro L921 on device | Bead Millipede: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M093 | Mechanic | `m093_test.dart` (catalog §5 cases) + play intro L931 on device | Fork-Tail Splitter: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M094 | Mechanic | `m094_test.dart` (catalog §5 cases) + play intro L941 on device | Berry Mixer Puddle: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M095 | Mechanic | `m095_test.dart` (catalog §5 cases) + play intro L951 on device | Rainbow Hedge Gates: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M096 | Mechanic | `m096_test.dart` (catalog §5 cases) + play intro L961 on device | Shadow Snake: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M097 | Mechanic | `m097_test.dart` (catalog §5 cases) + play intro L971 on device | Bamboo Domino Poles: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M098 | Mechanic | `m098_test.dart` (catalog §5 cases) + play intro L981 on device | Prowling Mongoose: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-MECH-M099 | Mechanic | `m099_test.dart` (catalog §5 cases) + play intro L991 on device | Sun Temple Master Lock: rule, bump, locked, Hammer (+guards), solver encode (+tick/rotation/beam where applicable) match catalog card; intro card shows | P0 | Not run |
| QA-FIN-01 | Finale | Play L1000 full | Solvable 0 hearts/0 boosters (solution replay), D ≈ 84 | P0 | Not run |
| QA-FIN-02 | Finale | Win L1000 | Chest (1,000 + 2 each booster + badge, sticker stamp) → Rush 30 snakes → Phase Complete; no interstitial | P0 | Not run |
| QA-FIN-03 | Finale | `maxPhase = 2` after L1000 | "More levels coming soon" | P1 | Not run |
| QA-ECO-01 | Economy | First clear L510 | Gift Basket 300 + Safety Shell Shield | P0 | Not run |
| QA-ECO-02 | Economy | First clear L525 | Golden Slither Rush 30 snakes | P0 | Not run |
| QA-ECO-03 | Economy | Interstitial cadence L501–L520 | Every 5 wins, deferred on Gift/Rush, 120 s cooldown | P0 | Not run |
| QA-ECO-04 | Economy | `maxPhase = 1` at L500 clear | L501 locked, coming-soon card | P0 | Not run |
| QA-ALB-01 | Album | Update from Phase 1 save at L237 | 23 stickers granted, Vol 1 claimable, summary popup once | P0 | Not run |
| QA-ALB-02 | Album | Claim Vol 1 | +250 coins, Fern Frame owned | P0 | Not run |
| QA-ALB-03 | Album | Claim Vol 1 on second device | "Already claimed", no coins | P0 | Not run |
| QA-ALB-04 | Album | First clear L540 | Sticker stamp inside Gift Basket reveal; no extra step | P0 | Not run |
| QA-ALB-05 | Album | Replay L540 | No sticker | P1 | Not run |
| QA-ALB-06 | Album | Clear Daily on Monday | Butterfly silhouette | P1 | Not run |
| QA-ALB-07 | Album | Offline milestone clear | Sticker granted; syncs later | P1 | Not run |
| QA-RACE-01 | Race | `highestCleared` 59 on Saturday | Race banner hidden | P0 | Not run |
| QA-RACE-02 | Race | Join Sat 09:00 online | Cohort of 5 shown (pending/ghost); window ends Sun 23:59 local | P0 | Not run |
| QA-RACE-03 | Race | Join offline | "Connect to join" | P0 | Not run |
| QA-RACE-04 | Race | Join Sun 12:01 | Not allowed | P1 | Not run |
| QA-RACE-05 | Race | Replay old level during race | Not counted | P0 | Not run |
| QA-RACE-06 | Race | Clear 15 new levels | Finish recorded; rank by validated time | P0 | Not run |
| QA-RACE-07 | Race | Rewards 1st–5th (test cohort) | 1st 1,000 + Golden Crown + 3 each booster · 2nd 500 + 2 Hammer + 1 Hint · 3rd 250 + 1 Shield · 4th–5th 50 | P0 | Not run |
| QA-RACE-08 | Race | Ghost finishes 1st | Real players get rank-based rewards; ghost labelled "replay racer" | P0 | Not run |
| QA-RACE-09 | Race | Clears offline, upload before end + 30 min | Counted with estUtc | P0 | Not run |
| QA-RACE-10 | Race | Clears offline, upload after grace | Not counted for race; level progress kept | P1 | Not run |
| QA-RACE-11 | Race | Tampered durationMs 1 s ×3 | Entry excluded, neutral message | P0 | Not run |
| QA-RACE-12 | Race | Reboot device mid-race offline | Server receive time used | P1 | Not run |
| QA-RACE-13 | Race | Change device timezone mid-race | Window unchanged | P1 | Not run |
| QA-PIG-01 | Piggy | Clear L30 | Piggy unlocks; L31 first clear +10 | P0 | Not run |
| QA-PIG-02 | Piggy | Replay / Daily / Rush | No deposit | P0 | Not run |
| QA-PIG-03 | Piggy | Balance 340 | Buy disabled; at 350 enabled | P0 | Not run |
| QA-PIG-04 | Piggy | Balance 1,000 + more clears | Stays 1,000; full popup once | P0 | Not run |
| QA-PIG-05 | Piggy | Buy ₹49 (sandbox) | Forced sync → verify → coins = server balance, piggy 0 | P0 | Not run |
| QA-PIG-06 | Piggy | Buy offline | Disabled "Connect…" | P0 | Not run |
| QA-PIG-07 | Piggy | Under-13 profile full piggy | No auto-popup | P0 | Not run |
| QA-PIG-08 | Piggy | Store copy | Compares with Coins S (350/₹49) and Coins M (1,000/₹149) correctly; no "% off" | P1 | Not run |
| QA-COS-01 | Cosmetics | Buy Emerald Vine 800 | Coins −800, owned, equip | P0 | Not run |
| QA-COS-02 | Cosmetics | Skin on Flower Gate level | Colour + pattern unchanged; gates work | P0 | Not run |
| QA-COS-03 | Cosmetics | VIP skin while VIP active, then expire | Royal Peacock equippable; reverts on expiry | P0 | Not run |
| QA-COS-04 | Cosmetics | Buy same skin on 2 devices offline | One spend after sync | P0 | Not run |
| QA-COS-05 | Cosmetics | Board theme on Jungle Night level | Contrast OK | P1 | Not run |
| QA-COS-06 | Cosmetics | Golden Slither Rush with skin equipped | Rush golden look | P1 | Not run |
| QA-COS-07 | Cosmetics | Price range check | All shop prices 800–4,000 | P1 | Not run |
| QA-SYNC-01 | Sync | First online launch from Phase 1 save | Anonymous uid, bootstrap op, server snapshot equals local | P0 | Not run |
| QA-SYNC-02 | Sync | Same opId sent 3× (network retry) | Applied once | P0 | Not run |
| QA-SYNC-03 | Conflict | Device A L740, device B L720 (both offline) then sync | highestCleared 740 on both | P0 | Not run |
| QA-SYNC-04 | Conflict | Stars: A ★★ L700, B ★★★ L700 | ★★★ both | P0 | Not run |
| QA-SYNC-05 | Conflict | Both devices first-clear L705 offline | Clear coins once (semantic key) | P0 | Not run |
| QA-SYNC-06 | Conflict | Coins: A earns 100, B spends 60 offline | Server = start + 100 − 60 on both | P0 | Not run |
| QA-SYNC-07 | Conflict | Daily claimed on both devices same dayKey | +100 once; streak +1 once | P0 | Not run |
| QA-SYNC-08 | Conflict | Equip different skins on A then B | Later server write wins | P1 | Not run |
| QA-SYNC-09 | Streak | Clock +2 days offline, claim, go online | Streak frozen; coins kept | P0 | Not run |
| QA-SYNC-10 | Auth | Link Google, reinstall, sign in | Full restore (progress, album, cosmetics) | P0 | Not run |
| QA-SYNC-11 | Auth | Link Google already used by other uid | Load-saved-garden dialog; merge without double rewards | P0 | Not run |
| QA-SYNC-12 | Sync | Kill app mid-push | Ops resent; no duplicates | P0 | Not run |
| QA-SYNC-13 | Sync | Firestore emulator: client direct write | Denied by rules | P0 | Not run |
| QA-SYNC-14 | Sync | Over-cap earn op (tampered 5,000) | Rejected; snapshot corrects wallet | P0 | Not run |
| QA-OFF-01 | Offline | Airplane mode L501–L520 | Fully playable; ads disabled text | P0 | Not run |
| QA-OFF-02 | Offline | Airplane: open Shop coin packs | "Store unavailable" | P0 | Not run |
| QA-OFF-03 | Offline | Queue 2,000 ops then online | Batches of 100, "Syncing…" chip, no jank | P1 | Not run |
| QA-OFF-04 | Offline | Connectivity toggles rapidly | Single flush at a time; backoff ≤ 300 s | P1 | Not run |
| QA-OFF-05 | Offline | Remote Config fetch offline | Cached values; `maxPhase` unchanged | P1 | Not run |
| QA-ACC-01 | Account | Delete account online | Cloud data removed, auth deleted, local reset, age gate | P0 | Not run |
| QA-ACC-02 | Account | Delete offline | Button disabled with text | P0 | Not run |
| QA-ACC-03 | Account | Delete Apple-linked account | Apple token revoked | P0 | Not run |
| QA-ACC-04 | Account | Under-13 | Link buttons hidden | P0 | Not run |
| QA-PERF-01 | Perf | L991 on Redmi 9A class, pan + exit | 60 fps (FrameTiming) | P0 | Not run |
| QA-PERF-02 | Perf | Mid-tier raster p95 on L1000 | < 8 ms | P0 | Not run |
| QA-PERF-03 | Perf | Hint on L1000 mid-state | ≤ 50 ms or fallback toast | P1 | Not run |
| QA-PERF-04 | Perf | Memory after Album browse | ≤ 280 MB low-tier | P1 | Not run |

Per-mechanic test cases: [03 §5](./03_OBSTACLE_CATALOG_PHASE_2.md#5-per-mechanic-unit-tests-puzzle_core). Release sign-off = બધા P0 rows Pass (device matrix §8) + [README §8](./README.md#8-phase-2-exit-criteria).

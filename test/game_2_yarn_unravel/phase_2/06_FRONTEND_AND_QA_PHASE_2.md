# 06 — Frontend Implementation & QA (Phase 2)
> Purpose: Phase 2 માટે Flutter implementation ઉમેરા — architecture, નવા BLoCs, zoom/pan input, diagonal lanes, 3-layer + beam renderer, save v2 fields, 14×14 / 40-thread performance, CI validator additions અને QA checklist (બધા status "Not run").

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) (§12, §13, §14, §15) · [./README.md](./README.md) · [./01_PHASE_2_SCOPE_AND_RULES.md](./01_PHASE_2_SCOPE_AND_RULES.md) · [./03_OBSTACLE_CATALOG_PHASE_2.md](./03_OBSTACLE_CATALOG_PHASE_2.md) · [./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [./05_OFFLINE_AND_CLOUD_SYNC.md](./05_OFFLINE_AND_CLOUD_SYNC.md) · [../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) · [../../SOUND_EFFECTS_IMPLEMENTATION.md](../../SOUND_EFFECTS_IMPLEMENTATION.md) · [../../LOGGING_AND_ERROR_TRACKING.md](../../LOGGING_AND_ERROR_TRACKING.md)

> Phase 1 architecture ([../phase_1/07](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)) યથાવત: Flutter 3.x / Dart 3 / Impeller, `CustomPainter` + Ticker (Flame નહીં), `flutter_bloc`, `puzzle_core` pure Dart, `hive_ce`. અહીં ફક્ત ઉમેરા.

---

## 1. Architecture Additions

| Area | Addition |
|---|---|
| `puzzle_core` | `Dir8` directions, diagonal lane resolver + squeeze rule, 3-layer occupancy, crate physics (push/slide), `BeamTracer`, tick scheduler (standard §16.17 order — tick step 3, [01 §7](./01_PHASE_2_SCOPE_AND_RULES.md)), mechanics `m051 … m099`, verifier entry point (`verifyReplay`) usable by Cloud Functions (Dart → JS build) |
| App packages | `firebase_auth`, `cloud_firestore`, `cloud_functions`, `firebase_app_check`, `connectivity_plus`, `uuid` |
| Assets | `assets/levels/phase_2.json.gz`, Scrapbook sticker atlases (5 volumes), Wardrobe skin textures, board theme images |
| Remote Config | `maxPhase`, LiveOps keys ([04 §6](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md)) |
| Audio | Phase 1 `AudioService` + `AudioPool` યથાવત ([../phase_1/07 §7](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md), spec [SOUND_EFFECTS_IMPLEMENTATION](../../SOUND_EFFECTS_IMPLEMENTATION.md)): SFX `.wav` mono, music `.m4a`, max 8 voices, OGG નહીં. Phase 2 additions ≤ +4 MB. Phase 2 tracks `music_gameplay_p2a`, `music_gameplay_p2b` |
| Logging | `AppLogger` + `TapLoggerScope` યથાવત; Phase 2 sync codes `E-SYNC-001/002` ([LOGGING §4](../../LOGGING_AND_ERROR_TRACKING.md)) |

Phase 2 Yarn sound mapping (standard event IDs, sound doc §5.2):

| Event ID | Mechanic(s) | Yarn sound |
|---|---|---|
| `push_block` / `slide_block` | M053 Bobbin Crate / M054 Satin Glide Patch | Crate "scrape-clack" / satin "shhhk" |
| `beam_on` / `beam_hit` | M084, M085, M089 | Lamp click-hum / sun-catcher chime |
| `deflect` | M052, M086 | Felt bump "puff" / mirror glint |
| `color_change` / `merge` | M059, M094 | Dye "bloop" / mixing swirl |
| `split` | M093 | Ply split "fwip-fwip" |
| `board_rotate` | M079 | Quilt frame wooden creak |
| `trail_fade` | M068 | Lint "poof" |
| `domino_chain` | M097 | Button clacks, 60 ms apart |
| `guardian_hit` / `guardian_defeat` | M098 | Pin "ping" / pincushion stuffing poof |
| `lock_open` | M080, M088, M099 | Clasp click (M099: grand chime) |

Folder additions:
```
packages/puzzle_core/lib/src/
  model/dir8.dart, crate.dart, beam.dart
  rules/diagonal_links.dart, beam_tracer.dart, tick_scheduler.dart, crate_physics.dart
  mechanics/m051_diagonal.dart … m099_master_lock.dart
  verify/verify_replay.dart
apps/yarn_unravel/lib/
  features/game/view/board_gesture_layer.dart, board_viewport.dart
  features/game/render/beam_painter.dart, layer_cache.dart, crate_painter.dart
  features/album/  features/star_race/  features/piggy/  features/wardrobe/  features/account/
  services/auth_service.dart, sync_service.dart, sync_queue.dart, race_service.dart, connectivity_service.dart
```

## 2. New BLoCs / Cubits

| BLoC / Cubit | Events / methods | States |
|---|---|---|
| `BoardViewportCubit` | `fitRequested`, `pinchUpdated(focal, scale)`, `panned(delta)`, `focusCell(cell)` (Hint auto-pan) | `ViewportState(scale, offset, maxScale, zoomEnabled)` |
| `AlbumCubit` | `grantSticker(level)`, `claimVolume(n)`, `retroactiveGrant(highestCleared)` | `AlbumState(stickers, volumesClaimed, pendingReveal?)` |
| `StarRaceBloc` | `RaceOpened`, `JoinPressed`, `ClearReported(level, replay)`, `CohortSnapshot(rows)`, `ResultsClaimed` | `RaceLocked(reason)`, `RaceJoinable(window)`, `RaceActive(rows, myClears, endsAt)`, `RaceOfflineQueued(n)`, `RaceResults(rank, rewards)` |
| `PiggyCubit` | `accrue(level)`, `breakRequested`, `purchaseUpdated` | `PiggyState(stored, cap, breakable, pending)` |
| `WardrobeCubit` | `buy(itemId)`, `equip(slot, itemId)`, `vipChanged(active)` | `WardrobeState(owned, equipped, prices)` |
| `SyncBloc` | `SyncRequested`, `ConnectivityChanged(online)`, `SyncSucceeded(snapshot)`, `SyncFailed(error)` | `SyncIdle(lastSyncUtc, pending)`, `SyncRunning`, `SyncWaitingForNetwork(pending)`, `SyncError(retryAt)` |
| `AuthCubit` | `ensureSignedIn`, `link(provider)`, `resolveLinkConflict(keep: device | cloud)` (no merge, §17.36), `deleteAccount` | `AuthState(uid, isAnonymous, linkedProviders, ageBand)` |

`GameBloc` additions: `MoveResult` variants `push`, `segmentExit`, `split`, `cushionPop`; state adds `crates`, `beams`, `layerCount`, `boardRot`, `globalRot`. Reward queue adds `sticker` and `volumeReward` entries (order: Craft Basket/Chest ⇒ sticker ⇒ Golden Bobbin Rush).

## 3. Input: Zoom / Pan / Tap / Peek

Rules: [01 §2](./01_PHASE_2_SCOPE_AND_RULES.md). A raw `Listener` is used (not `InteractiveViewer` + `TapGestureRecognizer`) so tap, 350 ms Thread Peek, pan and pinch are decided by one deterministic state machine.

```dart
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

typedef CellRef = ({int x, int y});

/// Immutable viewport: board is laid out at fit size, then scaled & translated.
@immutable
class BoardViewport {
  const BoardViewport({
    required this.boardSize,
    required this.viewSize,
    required this.maxScale,
    this.scale = 1.0,
    this.offset = Offset.zero,
  });

  final Size boardSize;
  final Size viewSize;
  final double maxScale;
  final double scale;
  final Offset offset;

  Offset toBoard(Offset local) => (local - offset) / scale;

  BoardViewport _with({double? scale, Offset? offset}) => BoardViewport(
        boardSize: boardSize,
        viewSize: viewSize,
        maxScale: maxScale,
        scale: scale ?? this.scale,
        offset: offset ?? this.offset,
      )._clamped();

  BoardViewport zoomAround(Offset focal, double newScale) {
    final s = math.min(maxScale, math.max(1.0, newScale));
    final anchor = toBoard(focal);
    return _with(scale: s, offset: focal - anchor * s);
  }

  BoardViewport panBy(Offset delta) => _with(offset: offset + delta);

  BoardViewport fit() => _with(scale: 1.0, offset: Offset.zero);

  BoardViewport _clamped() {
    const margin = 24.0;
    double axis(double o, double content, double view) {
      if (content <= view) return (view - content) / 2;
      return math.min(margin, math.max(view - content - margin, o));
    }

    final w = boardSize.width * scale;
    final h = boardSize.height * scale;
    final clampedOffset = Offset(
      axis(offset.dx, w, viewSize.width),
      axis(offset.dy, h, viewSize.height),
    );
    if (clampedOffset == offset) return this;
    return BoardViewport(
      boardSize: boardSize,
      viewSize: viewSize,
      maxScale: maxScale,
      scale: scale,
      offset: clampedOffset,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is BoardViewport &&
      other.boardSize == boardSize &&
      other.viewSize == viewSize &&
      other.maxScale == maxScale &&
      other.scale == scale &&
      other.offset == offset;

  @override
  int get hashCode => Object.hash(boardSize, viewSize, maxScale, scale, offset);
}

class BoardGestureLayer extends StatefulWidget {
  const BoardGestureLayer({
    super.key,
    required this.viewport,
    required this.cellSize,
    required this.gridW,
    required this.gridH,
    required this.zoomEnabled,
    required this.onViewport,
    required this.onTapCell,
    required this.onPeekStart,
    required this.onPeekEnd,
    required this.child,
  });

  final BoardViewport viewport;
  final double cellSize; // fit-size cell in logical px
  final int gridW;
  final int gridH;
  final bool zoomEnabled; // max(W, H) >= 12
  final ValueChanged<BoardViewport> onViewport;
  final ValueChanged<CellRef> onTapCell;
  final ValueChanged<CellRef> onPeekStart;
  final VoidCallback onPeekEnd;
  final Widget child;

  @override
  State<BoardGestureLayer> createState() => _BoardGestureLayerState();
}

class _BoardGestureLayerState extends State<BoardGestureLayer> {
  static const double _slop = 18.0;
  static const Duration _peekDelay = Duration(milliseconds: 350);

  final Map<int, Offset> _pointers = <int, Offset>{};
  Offset? _downPos;
  Timer? _peekTimer;
  bool _panning = false;
  bool _peeking = false;
  bool _pinching = false;
  double _pinchStartDist = 0;
  double _pinchStartScale = 1;

  @override
  void dispose() {
    _peekTimer?.cancel();
    super.dispose();
  }

  /// Nearest cell. On small fit cells (< 29 dp) taps up to 0.1 cell outside
  /// the board edge snap to the edge cell (enlarged tap slop).
  CellRef? _cellAt(Offset local) {
    final p = widget.viewport.toBoard(local);
    final c = widget.cellSize;
    final margin = c < 29 ? c * 0.1 : 0.0;
    if (p.dx < -margin ||
        p.dy < -margin ||
        p.dx > widget.gridW * c + margin ||
        p.dy > widget.gridH * c + margin) {
      return null;
    }
    final cx = (p.dx / c).floor().clamp(0, widget.gridW - 1);
    final cy = (p.dy / c).floor().clamp(0, widget.gridH - 1);
    return (x: cx, y: cy);
  }

  void _endPeek() {
    if (_peeking) {
      _peeking = false;
      widget.onPeekEnd();
    }
  }

  void _onDown(PointerDownEvent e) {
    _pointers[e.pointer] = e.localPosition;
    if (_pointers.length == 1) {
      _downPos = e.localPosition;
      _panning = false;
      _pinching = false;
      _peekTimer?.cancel();
      _peekTimer = Timer(_peekDelay, () {
        final pos = _downPos;
        if (pos == null || _panning || _pinching) return;
        final cell = _cellAt(pos);
        if (cell == null) return;
        _peeking = true;
        widget.onPeekStart(cell);
      });
    } else if (_pointers.length == 2 && widget.zoomEnabled) {
      _peekTimer?.cancel();
      _endPeek();
      _pinching = true;
      final pts = _pointers.values.toList();
      _pinchStartDist = (pts[0] - pts[1]).distance;
      _pinchStartScale = widget.viewport.scale;
    }
  }

  void _onMove(PointerMoveEvent e) {
    final prev = _pointers[e.pointer];
    if (prev == null) return;
    _pointers[e.pointer] = e.localPosition;

    if (_pinching && _pointers.length >= 2) {
      final pts = _pointers.values.take(2).toList();
      final dist = (pts[0] - pts[1]).distance;
      if (_pinchStartDist > 0) {
        final focal = (pts[0] + pts[1]) / 2;
        widget.onViewport(
          widget.viewport.zoomAround(focal, _pinchStartScale * dist / _pinchStartDist),
        );
      }
      return;
    }

    final down = _downPos;
    if (down == null) return;
    if (!_panning && (e.localPosition - down).distance > _slop) {
      _panning = true;
      _peekTimer?.cancel();
      _endPeek();
    }
    if (_panning && widget.zoomEnabled && widget.viewport.scale > 1.0) {
      widget.onViewport(widget.viewport.panBy(e.localPosition - prev));
    }
  }

  void _onUp(PointerEvent e, {required bool cancelled}) {
    _pointers.remove(e.pointer);
    if (_pointers.isNotEmpty) return;
    _peekTimer?.cancel();
    final wasPeeking = _peeking;
    _endPeek();
    final down = _downPos;
    if (!cancelled && !wasPeeking && !_panning && !_pinching && down != null) {
      final cell = _cellAt(down);
      if (cell != null) widget.onTapCell(cell);
    }
    _downPos = null;
    _panning = false;
    _pinching = false;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _onDown,
      onPointerMove: _onMove,
      onPointerUp: (e) => _onUp(e, cancelled: false),
      onPointerCancel: (e) => _onUp(e, cancelled: true),
      child: widget.child,
    );
  }
}
```

Notes: `onTapCell` goes to `GameBloc` (`CellTapped`), which applies hit-test order (Golden Scissors targeting ⇒ interactive obstacle ⇒ top layer ⇒ mid ⇒ ground). Pinch on boards < 12×12 is ignored (`zoomEnabled = false`). Hint auto-pan: `BoardViewportCubit.focusCell` animates `offset` only (250 ms, `Curves.easeOutCubic`).

## 4. Renderer Additions

### 4.1 Diagonal geometry (`puzzle_core` + app)
```dart
import 'dart:math' as math;

enum Dir8 {
  u(0, -1),
  ur(1, -1),
  r(1, 0),
  dr(1, 1),
  d(0, 1),
  dl(-1, 1),
  l(-1, 0),
  ul(-1, -1);

  const Dir8(this.dx, this.dy);
  final int dx;
  final int dy;

  bool get isDiagonal => dx != 0 && dy != 0;

  /// 90° clockwise: U→R→D→L, UR→DR→DL→UL.
  Dir8 rotateCw() => Dir8.values[(index + 2) % 8];

  Dir8 get opposite => Dir8.values[(index + 4) % 8];

  /// Screen angle for drawing the needle (y grows downward).
  double get angle => math.atan2(dy.toDouble(), dx.toDouble());
}

typedef Cell = ({int x, int y});

/// Diagonal links between consecutive body cells of the same thread.
class DiagonalLinks {
  final Set<int> _keys = <int>{};

  static int _pack(Cell c) => (c.y << 8) | c.x; // grids ≤ 255 wide
  static int _key(Cell a, Cell b) {
    final pa = _pack(a);
    final pb = _pack(b);
    return pa < pb ? (pa << 16) | pb : (pb << 16) | pa;
  }

  void addBody(List<Cell> body) {
    for (var i = 0; i + 1 < body.length; i++) {
      final a = body[i];
      final b = body[i + 1];
      if (a.x != b.x && a.y != b.y) _keys.add(_key(a, b));
    }
  }

  /// Squeeze rule: a diagonal step is blocked only when the two side cells
  /// are a diagonal link of one thread (that link crosses the step).
  bool stepBlocked(Cell from, Dir8 d) {
    if (!d.isDiagonal) return false;
    final side1 = (x: from.x + d.dx, y: from.y);
    final side2 = (x: from.x, y: from.y + d.dy);
    return _keys.contains(_key(side1, side2));
  }
}
```
Unravel track: diagonal segments are straight `lineTo` between cell centres (length √2 × cell); corners keep Phase 1 soft radius (cell × 0.35). `PathMetric.extractPath` animation unchanged; duration scales with track length, capped 450 ms.

### 4.2 Three layers & caches
| Picture | Content | Rebuilt |
|---|---|---|
| `boardPic` | linen, frame, grid dots, floor-type obstacles (satin, docks, belts, pads, worn patches) | level start, M079 rotation |
| `layerPic[0..2]` | idle threads + layer obstacles of each layer; tulle/sheet overlays between | only the layers touched by the committed Move |
| Dynamic | moving thread(s), crate slide, snag pulse, hint glow, peek line, beams (§4.3) | while animating |

Paint order: `boardPic` → `layerPic[0]` → cotton sheet (90% brightness) → `layerPic[1]` → tulle → `layerPic[2]` → beams → dynamic. Whole stack is drawn inside `canvas.translate(offset) + canvas.scale(scale)` from `BoardViewport`; zoom/pan never rebuilds pictures. Covered (locked) lower threads are drawn at 85% brightness (pre-tinted colour, no per-frame filter).

### 4.3 Beam renderer
Beams change only at tick step 4 (derived states), so they are a separate small painter repainted only when `segments` change (no per-frame pulse; reduce-motion safe; no blur).

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

@immutable
class BeamSegment {
  const BeamSegment(this.from, this.to);
  final Offset from; // board coordinates (fit-size px)
  final Offset to;

  @override
  bool operator ==(Object other) =>
      other is BeamSegment && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);
}

class BeamPainter extends CustomPainter {
  const BeamPainter({
    required this.segments,
    required this.cell,
    required this.scale,
    required this.offset,
  });

  final List<BeamSegment> segments;
  final double cell;
  final double scale;
  final Offset offset;

  static const Color _glow = Color(0xFFFFD27A);
  static const Color _core = Color(0xFFFFF4D6);

  @override
  void paint(Canvas canvas, Size size) {
    if (segments.isEmpty) return;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.scale(scale);
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = cell * 0.34
      ..color = _glow.withValues(alpha: 0.28);
    final core = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = cell * 0.10
      ..color = _core.withValues(alpha: 0.95);
    for (final s in segments) {
      canvas.drawLine(s.from, s.to, glow);
      canvas.drawLine(s.from, s.to, core);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant BeamPainter oldDelegate) =>
      !listEquals(oldDelegate.segments, segments) ||
      oldDelegate.cell != cell ||
      oldDelegate.scale != scale ||
      oldDelegate.offset != offset;
}
```
Beam segments are built from `BeamTracer` output: one segment per straight run (emitter → mirror → prism branches), endpoints at cell centres / cell edges.

### 4.4 Other animations
| Event | Animation (≤ 450 ms total per Move) |
|---|---|
| Push (M053) | thread nudge 80 ms + crate slide 120 ms (+ 60 ms/cell on satin) |
| Segment exit (M092) | front segment unravels; remaining needle "pops" into place 60 ms |
| Split (M093) | ply untwist 200 ms |
| Board rotation (M079) | fit, then 400 ms rotation of the whole stack (`Curves.easeInOut`) |
| Magnets / belts / patrol / creeping fluff | after the main move, 150 ms, sequenced in tick step 3 order (§16.17) |
| Cushion pop (M073) | 180 ms feather burst sprite |

### 4.5 Wardrobe rendering
Thread skin = `ImageShader` texture + highlight params only; hue comes from the thread colour token and pattern icon stays (accessibility). Board theme swaps `boardPic` assets; contrast checked in CI against thread palette (≥ 3:1).

## 5. Save Data v2 (Hive)

| Box | Fields |
|---|---|
| Phase 1 boxes | unchanged (standard §14) |
| `album` | `stickers`, `volumesClaimed`, `dailyPatches` |
| `piggy` | `stored`, `unlocked` |
| `cosmetics` | `owned`, `equipped{threadSkin, boardTheme, needleCharm, profileFrame}`, `equippedAtUtc` |
| `syncQueue` | op maps keyed by op id ([05 §5](./05_OFFLINE_AND_CLOUD_SYNC.md)) |
| `account` (standard §17.37) | `uid`, `provider`, `lastSyncUtc`, `serverCoins`, `serverBoosters`, `bootstrapDone` |
| `race` (standard §17.37) | `weekKey`, `cohortId`, `reportedLevels`, `tzOffsetMin` |

`settings.ageBand` device-local જ રહે — **ક્યારેય sync નહીં** (§17.37).

Migration v1 → v2 runs once before Home, inside a Hive transaction-like sequence (write new boxes, then bump `saveVersion`); interruption ⇒ re-run (idempotent: album grants use v5 op ids). Backup `save_backup.hive` taken before migration.

## 6. Performance (14×14, 40 threads)

| Metric | Target |
|---|---|
| DM-1 (Redmi 9A class), 14×14, 40 threads, 3 layers, unravel animation, fit and 2× zoom | **60 fps** (standard budget is 30 paths; Phase 2 target extends it to 40) |
| ProMotion / 120 Hz | 120 fps |
| Frame raster p95 (mid-tier) | < 8 ms (standard) |
| Layer picture rebuild (one layer, 14×14) | ≤ 4 ms low-tier |
| Pinch/pan frame (no rebuild, transform only) | ≤ 4 ms raster mid-tier |
| Beam trace + receivers (tick step 4) | ≤ 1 ms (O(cells), ≤ 196 cells × branches) |
| Level load (phase_2 decompress + parse one level) | ≤ 150 ms |
| On-device Hint solver | 50 ms budget, 50k nodes, isolate (standard); fail ⇒ "Try Seam Ripper Undo", Hint not consumed |

Techniques: transform-only zoom (pictures replayed, not re-recorded); per-layer picture cache; occupancy grids (`Int16List` per layer) for O(1) hit-test and lane steps; beam painter separate `RepaintBoundary`; textures pre-baked at 2 mip sizes and chosen by `scale` (avoid shimmering at 2×); no `MaskFilter.blur`, `Color.withValues(alpha:)` only. Profile with `flutter run --profile` + DevTools raster thread on DM-1 with the L1000 board.

## 7. Level Validator CI (Phase 2 additions)

Phase 1 checks ([../phase_1/07 §13](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)) plus:
1. Schema v3 with `dir` 8 values; `"phase": 2`; `layers ≤ 3`.
2. Diagonal no-crossing (D1); bodies 8-connected; Chunky Chenille orthogonal only.
3. Solver with crate positions, beams, parity/counters; node limit 2M, depth ≤ 3×P; 0 hearts & 0 boosters.
4. No forced damage: every state on the found solution has a non-snag Move (implied by solution) — and waiting mechanics (M057, M068, M090, M096) never require a snag.
5. Beam / lane loop guards terminate; prism branch count ≤ 8.
6. M079 only on square boards; M093 even length ≥ 4; M060 same shape; M080 keys share M011; M091 centre-cell threads length ≥ 2.
7. Intro levels: intro mechanic + ≤ 1 earlier; ≤ 3 instances of the new mechanic.
8. D in slot window ±3 ([02 §5](./02_LEVEL_PROGRESSION_0501_1000.md)); x9 = high ×1.1; L1000 = 84 ±3.
9. Board fit: 12×12+ boards flagged `zoom: true` (derived); boards ≤ 11×11 keep 29 dp rule.

## 8. Error Handling (additions)

Phase 1 table ([../phase_1/07 §12](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)) યથાવત (`AppLogger` codes, [LOGGING_AND_ERROR_TRACKING](../../LOGGING_AND_ERROR_TRACKING.md)). Corrupt / missing Phase 2 level JSON ⇒ `E-LVL-001`/`E-LVL-002`, "Level unavailable" + Retry — level ક્યારેય skip / cleared mark નહીં.

| Failure | Code | Behaviour |
|---|---|---|
| Auth sign-in fails | `W-NET-001` (warn) | Silent retry on next connectivity; gameplay unaffected |
| `applyOps` rejected ops | `E-SYNC-002` | Remove, apply server snapshot, non-fatal log |
| Link / cloud-save conflict not resolved (dialog dismissed, flush failed) | `E-SYNC-001` | Nothing replaced; local save kept; retry from Settings → Account |
| Star Race report rejected | `E-SYNC-002` | Clear not counted; level progress unaffected; toast "Couldn't verify this clear" |
| Firestore listener error (race) | `W-NET-001` | Fallback to polling `getCohort` every 60 s while screen open |
| Piggy purchase while queue unflushed | — | Button disabled "Connect to break" |
| Piggy IAP error / verify fail | `E-IAP-001` / `E-IAP-002` | No grant, bank unchanged |
| Save migration v1 → v2 failure | `E-SAVE-003` | Restore `save_backup.hive`, retry next launch, Crashlytics non-fatal |
| Soft-lock (no winning sequence) | `E-GAME-004` | "Stuck" sheet Undo / Restart, no heart loss (§17.31) |

## 9. QA Checklist (Phase 2)
All items status **Not run** until executed. Status values: Not run / Pass / Fail / Blocked. Device matrix: Phase 1 DM-1…DM-8 ([../phase_1/07 §14.1](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)).

### 9.1 Core, zoom & rendering
| ID | Area | Steps | Expected | Status |
|---|---|---|---|---|
| QA-P2-001 | Zoom enable | Open L501 (12×12) and an 11×11 Phase 1 level | Pinch works on L501; ignored on 11×11 | Not run |
| QA-P2-002 | Auto-fit | Start any 14×14 level | Whole board visible at scale 1.0 | Not run |
| QA-P2-003 | Pinch clamp | Pinch in/out beyond limits | Scale stays within [1.0, 48 / fitCell] | Not run |
| QA-P2-004 | Pan clamp | Drag zoomed board far | Stops at board edge + 24 dp | Not run |
| QA-P2-005 | Tap vs pan | Drag 10 dp then release; drag 30 dp then release | 10 dp ⇒ tap; 30 dp ⇒ pan, no Move | Not run |
| QA-P2-006 | Peek vs pan | Hold 400 ms still; hold and move 30 dp | Peek shown; moving ⇒ peek ends, no tap | Not run |
| QA-P2-007 | Pinch cancels tap | Touch one finger, add second, release both | No Move, no peek | Not run |
| QA-P2-008 | Fit button | Zoom 2×, tap Fit | Animates to scale 1.0 (instant with reduce motion) | Not run |
| QA-P2-009 | Zoom not a Move | Zoom/pan during M057 level | Moves counter and gates unchanged | Not run |
| QA-P2-010 | Hint auto-pan | Zoomed, Hint target off-screen | View pans to target; Hint count −1 | Not run |
| QA-P2-011 | Diagonal lane | L511: tap diagonal thread with clear lane | Diagonal unravel off edge/corner | Not run |
| QA-P2-012 | Squeeze rule | Test board: diagonal lane past two different threads' side cells; then past one thread's diagonal link | First passes; second snags −1 | Not run |
| QA-P2-013 | Orthogonal devices vs diagonal | Diagonal lane into Stitch Arrow / Hook Deflector | Snag −1 | Not run |
| QA-P2-014 | 3 layers tap priority | L691 overlap cell of 3 layers | Top layer thread acts; covered ones locked tap | Not run |
| QA-P2-015 | Beam render | L841 | Beam drawn, updates after each Move, no frame drops | Not run |
| QA-P2-016 | Move order | Scripted board with magnet + belt + patrol + rotator | Tick order matches standard §16.17 / [01 §7](./01_PHASE_2_SCOPE_AND_RULES.md) step 3 (state hash test) | Not run |
| QA-P2-017 | Determinism | Replay same tap list twice on L1000 (harness) | Identical state hashes | Not run |
| QA-P2-018 | Undo Phase 2 | Push, split, rotation, segment exit then Seam Ripper Undo each | Full revert incl. crates/dirs/layers; Heart not restored | Not run |
| QA-P2-019 | Performance DM-1 | L1000 board, unravel + pinch | 60 fps; raster p95 per §6 | Not run |
| QA-P2-020 | Onboarding L501–510 | Play through | Steps `p2_pinch`, `p2_pan`, `p2_fit`, `p2_peek_zoom`, `p2_hint_pan` logged; L509 Hard badge; L510 Craft Basket 300 + Thimble Shield | Not run |
| QA-P2-021 | Craft Basket Phase 2 | Clear L520, L530, L540 | 300 + Seam Ripper Undo / Needle Glow Hint / Golden Scissors | Not run |
| QA-P2-022 | Grand Sewing Chest | Clear L1000 | 1,000 Coins + 2 each booster + Heirloom Weaver badge, then sticker, then Rush (30 threads) | Not run |
| QA-P2-023 | Golden Bobbin Rush | L525 first clear; replay L525 | 30 threads, max 400; replay ⇒ no Rush | Not run |
| QA-P2-024 | Interstitial defer | Win L530 (Basket + sticker) at 5th win | Interstitial deferred to next eligible win | Not run |
| QA-P2-025 | Validator CI | Run `tools/validator` on phase_2.json.gz | All 500 levels pass §7 | Not run |
| QA-P2-026 | Validator negative | Inject crossing diagonals / unsolvable crate level | CI fails with level id | Not run |
| QA-P2-027 | Crate at open edge | Push Bobbin Crate toward an open edge; then toward a Hem Wall edge | Open edge ⇒ crate falls off & removed, no heart; walled edge ⇒ snag −1 | Not run |
| QA-P2-028 | Bumped Move lane effects | Snag a thread whose lane crosses Dye Pot / Worn Patch / Seesaw open latch | No recolor, no wear, no flip, no pickup (§17.30) | Not run |
| QA-P2-029 | Tangled thread | Great Spool Lever rotation leaves a needle facing its own body; tap it | Locked tap (wobble), no heart, no Move | Not run |
| QA-P2-030 | Soft-lock sheet | Debug-inject unwinnable crate state | "Stuck" sheet Undo/Restart; no heart loss; `E-GAME-004` | Not run |
| QA-P2-031 | Max zoom | Pinch to max on 14×14 | Cell 48 dp; 18 dp slop; double-tap does not zoom | Not run |
| QA-P2-032 | Hammer targets | Golden Scissors on Magnet Pin Dish / Brass Bar Wall / Bobbin Crate / first domino | Dish & wall not targetable; crate & first domino removed | Not run |
| QA-P2-033 | Sound suite | Run shared suite AUD-01…AUD-24 ([SOUND §11](../../SOUND_EFFECTS_IMPLEMENTATION.md#11-qa-checklist-status-not-run)) on Phase 2 build | All AUD items per shared expected results | Not run |
| QA-P2-034 | Logging suite | Run shared suite LOG-01…LOG-22 ([LOGGING §15](../../LOGGING_AND_ERROR_TRACKING.md#15-qa-checklist-status-not-run)) on Phase 2 build | All LOG items per shared expected results | Not run |

### 9.2 LiveOps, sync & offline
| ID | Area | Steps | Expected | Status |
|---|---|---|---|---|
| QA-P2-040 | Album grant | First clear L610; replay | Sticker once; replay none | Not run |
| QA-P2-041 | Album retroactive | Migrate a Phase 1 save at L500 | 50 stickers, Vol 1–3 rewards (1,300 Coins + 3 cosmetics) once | Not run |
| QA-P2-042 | Album re-migration | Force migration twice / second device | No double grant | Not run |
| QA-P2-043 | Volume complete | Clear L1000 with all Vol 5 stickers | 1,000 Coins + Heirloom Gold charm (1 cosmetic) | Not run |
| QA-P2-044 | Daily Patches | Clear Daily on Mon and Tue | Mitten and Teacup marked; no coins | Not run |
| QA-P2-050 | Race unlock | Account at L59 vs L60 | Locked "Reach level 60" vs joinable | Not run |
| QA-P2-051 | Race window | Device time Sat 07:59 / 08:00 / Sun 12:01 (join) / Sun 23:59 | Before: locked; open; join closed after Sun 12:00; ends at 23:59 local | Not run |
| QA-P2-052 | Cohort + ghosts | Join alone in test project | After 2 h, 4 ghost rows with "Ghost" tag | Not run |
| QA-P2-053 | Counting | Replay old level, play Daily, clear new level | Only the new numbered level counts | Not run |
| QA-P2-054 | Rewards | Finish 1st / 2nd / 3rd / 4th in test cohorts | 1,000 + Golden Rosette + 3 each booster · 500 + 2 Golden Scissors + 1 Needle Glow Hint · 250 + 1 Thimble Shield · 50 | Not run |
| QA-P2-055 | Validation: rate | Send 2 reports 5 s apart | 2nd rejected | Not run |
| QA-P2-056 | Validation: plausibility | Report moves < par or duration < moves × 250 ms | Rejected | Not run |
| QA-P2-057 | Validation: podium replay | Tampered move list for 1st place | Flagged, excluded, ranks recomputed | Not run |
| QA-P2-058 | Race offline | Clear 3 levels offline, reconnect in window | 3 clears reported in order, ranked by server time | Not run |
| QA-P2-059 | Race offline late | Reconnect after window + 60 min | Queued race clears discarded; progress kept | Not run |
| QA-P2-060 | Race eligibility | Account at L990 with maxPhase 2 | "Race needs 15 new levels" | Not run |
| QA-P2-070 | Piggy unlock | Clear L30; clear L31 | Piggy shown after L30; +10 after L31 | Not run |
| QA-P2-071 | Piggy cap | Fill to 1,000; clear another level | Stays 1,000, "Full!" | Not run |
| QA-P2-072 | Piggy threshold | Bank 340 vs 350 | Break disabled at 340; enabled at 350 | Not run |
| QA-P2-073 | Piggy break | Buy ₹49 (test SKU) at 1,000 | Wallet +1,000 after server verify; bank 0 | Not run |
| QA-P2-074 | Piggy offline | Offline tap break | Disabled "Connect to break" | Not run |
| QA-P2-075 | Piggy copy | Inspect offer text | Shows stored amount and Coins M comparison only; no unsourced % claims | Not run |
| QA-P2-080 | Wardrobe buy | Buy Mohair Fuzz with 800 Coins | Owned; Coins −800; cannot buy twice | Not run |
| QA-P2-081 | Skin keeps colour | Equip every skin on M005 level | Hue + pattern icons unchanged; gameplay identical | Not run |
| QA-P2-082 | VIP skin | VIP active ⇒ equip Golden Lurex; expire VIP | Equippable while active; reverts on expiry | Not run |
| QA-P2-083 | Board theme contrast | Each theme × thread palette | Contrast ≥ 3:1 (CI report) | Not run |
| QA-P2-090 | Anonymous auth | Fresh install online | uid created silently; bootstrap upload once | Not run |
| QA-P2-091 | Link account | Link Google (Android) / Apple (iOS) | Same uid, data kept | Not run |
| QA-P2-092 | Link conflict | Link credential that already has a cloud save | Choice dialog: keep device save / keep cloud save / Cancel; chosen save kept, other discarded; no merge | Not run |
| QA-P2-093 | Conflict: progress | Device A L620, device B L640 offline, sync both | highestCleared 640; stars max per level | Not run |
| QA-P2-094 | Conflict: same reward | Clear L630 on both devices offline | Coins counted once (same v5 id) | Not run |
| QA-P2-095 | Conflict: double spend | Spend 500 on both devices with 600 balance | Ledger −400 ⇒ shown 0 + "Coins owed 400"; repaid from next earnings | Not run |
| QA-P2-096 | Conflict: streak | Claim same dayKey on two devices | Streak +1 once; coins once | Not run |
| QA-P2-097 | Conflict: streak clock | Set clock +1 day offline, claim, go online | Streak frozen; coins not revoked | Not run |
| QA-P2-098 | Idempotent resend | Kill app during flush; restart | No duplicate ops server-side | Not run |
| QA-P2-099 | Backoff | Block network; observe retries | 2 s, 4 s, 8 s … cap 5 min ±20 % | Not run |
| QA-P2-100 | Offline full play | Airplane mode: levels, Daily, Spin, Wardrobe buy | All work; ads/IAP/Race disabled with text | Not run |
| QA-P2-101 | Rejected op | Inject op with coins 9,999 | Rejected; wallet corrected from snapshot | Not run |
| QA-P2-102 | Delete account | Settings → Delete account | Cloud data + auth deleted; race row "Left the race"; local wiped (or fresh anon) | Not run |
| QA-P2-103 | Data export | Settings → Download my data | JSON share sheet | Not run |
| QA-P2-104 | Under-13 band | Age gate < 13 | No link prompt; generated race names; no auto-popups | Not run |
| QA-P2-105 | Migration v1→v2 | Real Phase 1 saves (5 samples) | Migrated; backup taken; no data loss | Not run |
| QA-P2-106 | ageBand not synced | Under-13 device, sync, inspect `users/{uid}` and ops | No `ageBand` field anywhere server-side | Not run |

### 9.3 Mechanic tests (one per M-ID)
| ID | Mechanic | Steps | Expected | Status |
|---|---|---|---|---|
| QA-M051 | M051 Bias-Cut Thread (Diagonal Paths) | Run `test/mechanics/m051_test.dart` + play intro L511 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M052 | M052 Felt Corner Bumper (Corner Bumper) | Run `test/mechanics/m052_test.dart` + play intro L521 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M053 | M053 Bobbin Crate (Push Block) | Run `test/mechanics/m053_test.dart` + play intro L531 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M054 | M054 Satin Glide Patch (Ice Floor) | Run `test/mechanics/m054_test.dart` + play intro L541 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M055 | M055 Crate Dock Plate (Block Plate) | Run `test/mechanics/m055_test.dart` + play intro L551 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M056 | M056 Pleat Ramp (Ramp) | Run `test/mechanics/m056_test.dart` + play intro L561 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M057 | M057 Loom Shuttle Gate (Traffic Light) | Run `test/mechanics/m057_test.dart` + play intro L571 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M058 | M058 Spinning Stitch Arrow (Rotating Arrow) | Run `test/mechanics/m058_test.dart` + play intro L581 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M059 | M059 Dye Pot (Paint Cell) | Run `test/mechanics/m059_test.dart` + play intro L591 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M060 | M060 Swap Hoop (Swap Pad) | Run `test/mechanics/m060_test.dart` + play intro L601 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M061 | M061 Drawstring Pouch (Capacity Hole) | Run `test/mechanics/m061_test.dart` + play intro L611 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M062 | M062 Sorting Hem (Edge Quota) | Run `test/mechanics/m062_test.dart` + play intro L621 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M063 | M063 Magnet Pin Dish (Magnet Blocker) | Run `test/mechanics/m063_test.dart` + play intro L631 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M064 | M064 Seesaw Latches (Seesaw Gates) | Run `test/mechanics/m064_test.dart` + play intro L641 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M065 | M065 Hidden Charm (Hidden Key) | Run `test/mechanics/m065_test.dart` + play intro L651 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M066 | M066 Ribbon-Tied Trio (Chained Triplet) | Run `test/mechanics/m066_test.dart` + play intro L661 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M067 | M067 Worn Fabric Patch (Collapsing Floor) | Run `test/mechanics/m067_test.dart` + play intro L671 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M068 | M068 Lint Trail (Trail Blocker) | Run `test/mechanics/m068_test.dart` + play intro L681 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M069 | M069 Triple Fabric Layers (Three Layers) | Run `test/mechanics/m069_test.dart` + play intro L691 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M070 | M070 Great Spool Lever (Global Rotator) | Run `test/mechanics/m070_test.dart` + play intro L701 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M071 | M071 Drawstring Hem (Quota Edge) | Run `test/mechanics/m071_test.dart` + play intro L711 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M072 | M072 Pattern Card Sequence (Color Sequence) | Run `test/mechanics/m072_test.dart` + play intro L721 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M073 | M073 Cushioned Thread (Bubble Path) | Run `test/mechanics/m073_test.dart` + play intro L731 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M074 | M074 Brass Bar Wall (Armored Wall) | Run `test/mechanics/m074_test.dart` + play intro L741 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M075 | M075 Creeping Fluff (Creeping Fog) | Run `test/mechanics/m075_test.dart` + play intro L751 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M076 | M076 Pompom Tunnel Network (Portal Network) | Run `test/mechanics/m076_test.dart` + play intro L761 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M077 | M077 Confetti Popper (Bomb Blocker) | Run `test/mechanics/m077_test.dart` + play intro L771 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M078 | M078 Closed Hoop Frame (Center-Only Exit) | Run `test/mechanics/m078_test.dart` + play intro L781 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M079 | M079 Turning Quilt Frame (Board Rotator) | Run `test/mechanics/m079_test.dart` + play intro L791 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M080 | M080 Twin Clasps (Twin Locks) | Run `test/mechanics/m080_test.dart` + play intro L801 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M081 | M081 Copycat Thread (Mimic Path) | Run `test/mechanics/m081_test.dart` + play intro L811 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M082 | M082 Feed Dog Belt (Conveyor) | Run `test/mechanics/m082_test.dart` + play intro L821 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M083 | M083 Heavy Treadle Plate (Heavy Plate) | Run `test/mechanics/m083_test.dart` + play intro L831 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M084 | M084 Sewing Lamp Emitter (Laser Emitter) | Run `test/mechanics/m084_test.dart` + play intro L841 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M085 | M085 Sun-Catcher Receiver (Laser Receiver) | Run `test/mechanics/m085_test.dart` + play intro L851 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M086 | M086 Vanity Mirror (Beam Mirror) | Run `test/mechanics/m086_test.dart` + play intro L861 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M087 | M087 Hook-and-Loop Pad (Glue Pad) | Run `test/mechanics/m087_test.dart` + play intro L871 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M088 | M088 Thistle Burr (Lane Mine) | Run `test/mechanics/m088_test.dart` + play intro L881 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M089 | M089 Crystal Bead Prism (Prism) | Run `test/mechanics/m089_test.dart` + play intro L891 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M090 | M090 Odd-Stitch Gate (Parity Gate) | Run `test/mechanics/m090_test.dart` + play intro L901 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M091 | M091 Grand Quilt Block Rotor (Rotor 3×3) | Run `test/mechanics/m091_test.dart` + play intro L911 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M092 | M092 Chain-Stitch Thread (Segmented Path) | Run `test/mechanics/m092_test.dart` + play intro L921 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M093 | M093 Split-Ply Thread (Splitter Path) | Run `test/mechanics/m093_test.dart` + play intro L931 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M094 | M094 Dye Mixing Pot (Color Mixer) | Run `test/mechanics/m094_test.dart` + play intro L941 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M095 | M095 Color Drawstring Hem (Color Quota Edge) | Run `test/mechanics/m095_test.dart` + play intro L951 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M096 | M096 Shadow-Work Thread (Shadow Path) | Run `test/mechanics/m096_test.dart` + play intro L961 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M097 | M097 Button Domino Row (Domino Chain) | Run `test/mechanics/m097_test.dart` + play intro L971 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M098 | M098 Wandering Pincushion Guardian (Moving Guardian) | Run `test/mechanics/m098_test.dart` + play intro L981 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-M099 | M099 Master Jewel Clasp (Master Lock) | Run `test/mechanics/m099_test.dart` + play intro L991 on device | Rule + Definition per card hold; snag/locked behaviour correct; Seam Ripper Undo restores state; Golden Scissors interaction per card; solver finds 0-heart solution | Not run |
| QA-F1000 | Finale The Heirloom Tapestry (L1000) | Play L1000 on DM-1 and DM-6; run validator | Solvable 0 hearts/0 boosters in CI; D 84 ±3; 60 fps DM-1; reward flow per [02 §9](./02_LEVEL_PROGRESSION_0501_1000.md) | Not run |

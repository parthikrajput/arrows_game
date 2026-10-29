# 06 · Frontend & QA — Phase 2 — Toy Trains: Wooden Railway Puzzle
> હેતુ: Phase 2 માટે Flutter architecture ઉમેરા — નવા BLoCs, zoom/pan input, 8-direction lanes, beam tracer + renderer, 3 layers, નવા save fields, validator ઉમેરા, 14×14 / 40 trains performance, અને **QA checklist** (બધા items status "Not run").

**Related docs:** [Shared Core Standard §12–§16](../../SHARED_CORE_STANDARD.md) · [Phase 1 Frontend & QA](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) · [01 Phase 2 Rules](./01_PHASE_2_SCOPE_AND_RULES.md) · [03 Catalog Phase 2](./03_OBSTACLE_CATALOG_PHASE_2.md) · [04 LiveOps](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [05 Offline & Cloud Sync](./05_OFFLINE_AND_CLOUD_SYNC.md)

> Phase 1 architecture ([07](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)) યથાવત્: Flutter 3.x / Dart 3, `CustomPainter` + Ticker (Flame નહીં), `flutter_bloc`, `packages/puzzle_core` pure Dart, `hive_ce`. અહીં માત્ર ઉમેરા.

---

## 1. Architecture Additions

| Layer | Addition |
|---|---|
| `puzzle_core/model` | `Dir8` (8 directions), `layers` 1–3, `PushCart`, `Beam` state, path flags (`stuck`, `cushion`, `split`, `segmentIndex`, `copiedDir`) |
| `puzzle_core/rules` | `lane_tracer.dart` (8-dir + coupling-cross + layer switch via ramp), `push_resolver.dart`, `beam_tracer.dart`, `board_rotation.dart`, `tick_order.dart` (Phase 2 slots appended, standard §16.17), `dead_end.dart` ("Track jammed") |
| `puzzle_core/mechanics` | `m051_diagonal.dart` … `m099_master_gate.dart` (1 file per mechanic, same `Mechanic` interface) |
| `puzzle_core/replay` | `replay_validator.dart` — no Flutter/IO imports, compiled with `dart compile js` for the race Function |
| App `game/` | `BoardViewport` (zoom/pan), `BeamPainter`, per-layer picture cache, camera cubit |
| App `features/` | `album/`, `race/`, `piggy/`, `cosmetics/`, `account/` |
| App `services/` | `auth_service.dart`, `sync_service.dart` ([05 §7.3](./05_OFFLINE_AND_CLOUD_SYNC.md)), `race_service.dart` |
| Backend | `functions/` (Node 20, TypeScript): `applyOps`, `verifyPurchase`, `joinRace`, `submitRaceClear`, `closeRace`, `claimRaceReward`, `deleteAccount` |

## 2. Folder Tree (additions)

```
packages/puzzle_core/lib/src/
  model/dir8.dart  push_cart.dart  beam.dart
  rules/lane_tracer.dart  push_resolver.dart  beam_tracer.dart  board_rotation.dart  dead_end.dart
  mechanics/m051_diagonal.dart … m099_master_gate.dart
  replay/replay_validator.dart
packages/puzzle_core/test/mechanics/m051_test.dart … m099_test.dart
apps/toy_trains/
  assets/levels/phase_2.json.gz
  assets/cosmetics/liveries/*.webp  tables/*.webp  assets/album/vol1…vol5/*.webp
  lib/game/viewport/board_viewport.dart  camera_cubit.dart
  lib/game/render/beam_painter.dart  layer_picture_cache.dart
  lib/features/album/  race/  piggy/  cosmetics/  account/
  lib/services/auth_service.dart  sync_service.dart  race_service.dart
functions/src/  applyOps.ts  verifyPurchase.ts  race/*.ts  deleteAccount.ts
functions/test/
```

## 3. New BLoCs / Cubits

| BLoC / Cubit | Events / methods | State (key fields) |
|---|---|---|
| `CameraCubit` | `fit()`, `focusCell(cell)` (Hint auto-pan), `userTransformed(matrix)` | `scale`, `offset`, `zoomEnabled`, `maxScale` |
| `AlbumCubit` | `grantSticker(level)`, `retroGrant(highestCleared)`, `markSeen()` | `stickers`, `volumesClaimed`, `unseen` |
| `StarRaceBloc` | `RaceCardOpened`, `JoinPressed`, `LevelFirstCleared(level, moves, durationMs)`, `RaceSnapshotReceived`, `ClaimPressed` | `status {ineligible, open, joined, finished, claimable, claimed}`, `raceId`, `members[5]`, `myCount`, `endsAtUtc`, `offline` |
| `PiggyCubit` | `deposit(level)`, `breakPressed()`, `purchaseResult` | `balance`, `full`, `canBreak (≥ 350)`, `pending` |
| `CosmeticsCubit` | `preview(item)`, `buy(item)`, `equip(slot, item)`, `vipChanged(active)` | `owned`, `equipped{livery, table}`, `previewing` |
| `AuthCubit` | `ensureSignedIn()`, `link(provider)`, `resolveConflict(useExisting)`, `deleteAccount()` | `uid`, `isAnonymous`, `linkedProvider`, `conflict?` |
| `SyncCubit` | wraps `SyncService` | `pendingCount`, `lastSyncUtc`, `online`, `error?` |

`GameBloc` additions: events `PushResolved`, `BoardRotated`, `TrackJammed`; state `layers`, `beams` (from step 4), `camera` hint target. `RewardFlowCubit` queue extended per [04 §1](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md).

## 4. Zoom / Pan Input

Rules: [01 §2](./01_PHASE_2_SCOPE_AND_RULES.md). `InteractiveViewer` wraps the board; the Phase 1 `BoardGestureLayer` (tap + 350 ms long-press) stays **inside** it, so tap `localPosition` is already in untransformed board space (hit-test transform applied by the framework). Drag beyond slop wins the gesture arena ⇒ tap/long-press cancelled.

```dart
import 'package:flutter/material.dart';

class BoardViewport extends StatefulWidget {
  const BoardViewport({
    super.key,
    required this.gridSize,
    required this.boardSize,
    required this.child,
  });

  final int gridSize; // W (= H) of the level
  final Size boardSize; // fitted board size (logical px)
  final Widget child; // board painters + BoardGestureLayer

  @override
  State<BoardViewport> createState() => BoardViewportState();
}

class BoardViewportState extends State<BoardViewport>
    with SingleTickerProviderStateMixin {
  final TransformationController _controller = TransformationController();
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  Animation<Matrix4>? _tween;

  bool get zoomEnabled => widget.gridSize >= 12;

  double get maxScale {
    final fitCell = widget.boardSize.width / widget.gridSize;
    return (48.0 / fitCell).clamp(1.0, 4.0);
  }

  bool get isZoomed => _controller.value.getMaxScaleOnAxis() > 1.001;

  @override
  void initState() {
    super.initState();
    _anim.addListener(() {
      final tween = _tween;
      if (tween != null) _controller.value = tween.value;
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    _controller.dispose();
    super.dispose();
  }

  static Matrix4 _matrix(double scale, double dx, double dy) =>
      Matrix4.identity()
        ..setEntry(0, 0, scale)
        ..setEntry(1, 1, scale)
        ..setEntry(0, 3, dx)
        ..setEntry(1, 3, dy);

  void _animateTo(Matrix4 target) {
    _tween = Matrix4Tween(begin: _controller.value.clone(), end: target)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _anim.forward(from: 0);
  }

  /// "⤢ Fit" button, level start, Restart, Revive.
  void fit() => _animateTo(Matrix4.identity());

  /// Hint auto-pan: centre [boardPoint] if it is outside the viewport.
  void focusOn(Offset boardPoint) {
    final scale = _controller.value.getMaxScaleOnAxis();
    if (scale <= 1.001) return; // whole board already visible
    final view = widget.boardSize; // viewport == fitted board size
    final visible = MatrixUtils.inverseTransformRect(
        _controller.value, Offset.zero & view);
    if (visible.deflate(8).contains(boardPoint)) return;
    final maxDx = 0.0;
    final minDx = view.width - view.width * scale;
    final minDy = view.height - view.height * scale;
    final dx = (view.width / 2 - boardPoint.dx * scale).clamp(minDx, maxDx);
    final dy = (view.height / 2 - boardPoint.dy * scale).clamp(minDy, 0.0);
    _animateTo(_matrix(scale, dx, dy));
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _controller,
      minScale: 1.0,
      maxScale: zoomEnabled ? maxScale : 1.0,
      scaleEnabled: zoomEnabled,
      panEnabled: zoomEnabled,
      boundaryMargin: const EdgeInsets.all(24),
      clipBehavior: Clip.hardEdge,
      child: SizedBox.fromSize(size: widget.boardSize, child: widget.child),
    );
  }
}
```
- `GlobalKey<BoardViewportState>` lets `GameView` call `fit()` / `focusOn()` from `CameraCubit` listeners.
- Zoom/pan never dispatch `GameBloc` events (not Moves).
- Off-screen counter dots: computed from `MatrixUtils.inverseTransformRect` visible rect each time the transform changes (throttled to 10 Hz).

## 5. 8-Direction Lanes & Beams (puzzle_core, pure Dart)

```dart
typedef Cell = ({int x, int y});

/// Clockwise order: index + 2 = 90° CW.
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
  Dir8 rotateCw() => Dir8.values[(index + 2) % 8];
  Dir8 rotateCcw() => Dir8.values[(index + 6) % 8];

  static Dir8 of(int dx, int dy) =>
      Dir8.values.firstWhere((d) => d.dx == dx && d.dy == dy);
}

enum Blocker { path, obstacle, beam, couplingCross }

sealed class LaneResult {
  const LaneResult(this.cells);
  final List<Cell> cells; // cells travelled (excluding the blocker)
}

final class LaneClear extends LaneResult {
  const LaneClear(super.cells);
}

final class LaneBlocked extends LaneResult {
  const LaneBlocked(super.cells, this.at, this.reason);
  final Cell at;
  final Blocker reason;
}

abstract interface class LaneWorld {
  bool inBounds(Cell c);
  Blocker? blockerAt(Cell c, int layer, String movingPathId);
  bool areCoupled(Cell a, Cell b, int layer); // consecutive cars of one path
}

/// Straight/diagonal segment of a lane. Turning tiles (M014, M052, M086,
/// portals, ramps) are handled by the caller, which restarts the trace
/// from the tile with the new direction/layer.
LaneResult traceSegment(
    Cell head, Dir8 dir, int layer, String pathId, LaneWorld world) {
  final cells = <Cell>[];
  var cur = head;
  while (true) {
    final next = (x: cur.x + dir.dx, y: cur.y + dir.dy);
    if (!world.inBounds(next)) return LaneClear(cells);
    if (dir.isDiagonal) {
      final cornerA = (x: next.x, y: cur.y);
      final cornerB = (x: cur.x, y: next.y);
      if (world.areCoupled(cornerA, cornerB, layer)) {
        return LaneBlocked(cells, next, Blocker.couplingCross);
      }
    }
    final blocker = world.blockerAt(next, layer, pathId);
    if (blocker != null) return LaneBlocked(cells, next, blocker);
    cells.add(next);
    cur = next;
  }
}

enum BeamCell { pass, stop, mirrorSlash, mirrorBackslash, prism, receiver }

class BeamSegment {
  const BeamSegment(this.x1, this.y1, this.x2, this.y2); // cell units
  final double x1, y1, x2, y2;
}

class BeamTrace {
  const BeamTrace(this.segments, this.litCells, this.hitReceivers);
  final List<BeamSegment> segments;
  final Set<Cell> litCells; // lanes entering these cells bump
  final Set<Cell> hitReceivers;
}

/// Step 4 of every Move. Beams are orthogonal (01 §6).
BeamTrace traceBeams(
  List<(Cell, Dir8)> emitters,
  BeamCell Function(Cell c) kindAt,
  bool Function(Cell c) inBounds,
) {
  final segments = <BeamSegment>[];
  final lit = <Cell>{};
  final hits = <Cell>{};
  final visited = <(Cell, Dir8)>{};
  final work = <(Cell, Dir8)>[...emitters];

  void addSegment(Cell from, Cell to, Dir8 dir, {required bool toFace}) {
    final ex = to.x + 0.5 + (toFace ? dir.dx * 0.5 : 0);
    final ey = to.y + 0.5 + (toFace ? dir.dy * 0.5 : 0);
    segments.add(BeamSegment(from.x + 0.5, from.y + 0.5, ex, ey));
  }

  while (work.isNotEmpty) {
    final (start, dir) = work.removeLast();
    var cur = start;
    while (true) {
      final next = (x: cur.x + dir.dx, y: cur.y + dir.dy);
      if (!inBounds(next) || !visited.add((next, dir))) {
        addSegment(start, cur, dir, toFace: true);
        break;
      }
      final kind = kindAt(next);
      if (kind == BeamCell.pass) {
        lit.add(next);
        cur = next;
        continue;
      }
      if (kind == BeamCell.stop) {
        addSegment(start, cur, dir, toFace: true);
        break;
      }
      if (kind == BeamCell.receiver) {
        hits.add(next);
        addSegment(start, cur, dir, toFace: true);
        break;
      }
      lit.add(next); // mirror / prism cell carries the beam
      addSegment(start, next, dir, toFace: false);
      switch (kind) {
        case BeamCell.mirrorSlash:
          work.add((next, Dir8.of(-dir.dy, -dir.dx))); // R→U, U→R, L→D, D→L
        case BeamCell.mirrorBackslash:
          work.add((next, Dir8.of(dir.dy, dir.dx))); // R→D, D→R, L→U, U→L
        case BeamCell.prism:
          work
            ..add((next, dir.rotateCw()))
            ..add((next, dir.rotateCcw()));
        case BeamCell.pass:
        case BeamCell.stop:
        case BeamCell.receiver:
          break;
      }
      break;
    }
  }
  return BeamTrace(segments, lit, hits);
}
```

### 5.1 Beam renderer (app)
Beams change only after a Move (step 4) ⇒ drawn on their own `RepaintBoundary` layer, repainted only when `revision` changes; glow is a wide translucent stroke (no `MaskFilter.blur`).

```dart
import 'package:flutter/material.dart';
import 'package:puzzle_core/puzzle_core.dart' show BeamSegment;

class BeamPainter extends CustomPainter {
  BeamPainter({
    required this.segments,
    required this.cellSize,
    required this.color,
    required this.revision,
  });

  final List<BeamSegment> segments;
  final double cellSize;
  final Color color;
  final int revision; // bumps when the beam trace changes

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = cellSize * 0.35
      ..color = color.withValues(alpha: 0.25);
    final core = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..color = color;
    for (final s in segments) {
      final a = Offset(s.x1 * cellSize, s.y1 * cellSize);
      final b = Offset(s.x2 * cellSize, s.y2 * cellSize);
      canvas
        ..drawLine(a, b, glow)
        ..drawLine(a, b, core);
    }
  }

  @override
  bool shouldRepaint(BeamPainter oldDelegate) =>
      oldDelegate.revision != revision ||
      oldDelegate.cellSize != cellSize ||
      oldDelegate.color != color;
}
```
Colour-blind dash pattern: a second pass draws 4 dp dashes along the core (`PathMetrics`), recorded once per revision.

## 6. Three-Layer Rendering

| Item | Decision |
|---|---|
| Picture cache | One `ui.Picture` **per layer** (0, 1, 2) + one for static floor/obstacles; a Move invalidates only layers whose content changed |
| Order | floor → layer 0 trains → layer 0 beams → layer 1 deck + trains → layer 2 deck + trains → HUD badges |
| Covered trains | 30% darker tint + lock badge (baked into that layer's picture) |
| Moving train | Drawn per frame above its own layer, below higher decks (clip by deck mask picture) |
| Ramp (M056) animation | Moving train switches z-order at the ramp cell midpoint |
| Board rotation (M079) | Whole board `Transform.rotate` 400 ms on cached pictures, then re-record once |
| Deck shadows | Pre-baked 9-patch per deck, no runtime blur |

## 7. Save Data Additions (Hive, schema v1 additive — standard §14 Phase 2 fields + game additions)

```
album     { stickers: Set<int>, volumesClaimed: Set<int>, lastSeen: int }          // standard
piggy     { balance: int, full: bool, lastDepositLevel: int }                        // standard
cosmetics { owned: Set<String>, equipped: { livery: String, table: String } }       // standard
syncQueue { <opId>: SyncOp json }  +  syncMeta { nextSeq: int }                     // standard (+meta)
auth      { uid: String?, isAnonymous: bool, linkedProvider: String? }              // game addition
snapshot  { coins, boosters, piggy, streak, updatedAt }   // last server snapshot (projection base)
race      { raceId: String?, weekKey: String?, joinedAtUtc: DateTime?, lastCountedLevel: int? }
```
- Migration from Phase 1 save: create new boxes; `retroGrant` album stickers; first sync uploads a `progressMerge` op with highestCleared + stars.
- `adReviveUsed`, `ads`, `settings`, `session` remain device-local ([05 §6](./05_OFFLINE_AND_CLOUD_SYNC.md)).

## 8. Validator CI Additions (`tools/levelgen validate`, Phase 2)

All Phase 1 checks (0 hearts / 0 boosters solvable, D band ±3, tier limits, no permanently locked train, intro rule, `solution` replays to Win) plus:
- Diagonal bodies king-adjacent; no M024 diagonal; no train resting on M052/M086/M055-gate/M085-gate cells.
- Every pushing train has a solution path out (implied by solver) and no cart starts on a shed/portal.
- Beam trace deterministic & loop-safe; M085/M099 sensors reachable.
- M079 levels square; M070 levels contain no M022/M023; M078 levels contain ≥ 1 shed and no edge mechanics.
- M060 pairs same normalized shape; M080 keys are an M011 pair; M093 split never faces own half.
- Grid ≥ 12×12 ⇒ zoom flag; ≤ 11×11 ⇒ min cell ≥ 29 dp.
- Solver node limit 2M (CI), depth ≤ 3×P; state hash includes carts, beams-derived bits, smoke TTLs, parity, rotation.

## 9. Performance (14×14, 40 trains)

| Metric | Target / technique |
|---|---|
| Low-tier Android (2 GB, Redmi 9A class) — 14×14, 40 trains, 3 layers, 2 beams | **60 fps** during Move animations and pan/zoom |
| ProMotion iOS / 120 Hz Android | 120 fps |
| Frame raster p95 (mid-tier) | **< 8 ms** |
| Pan/zoom | Only `InteractiveViewer` transform changes; layer pictures re-used (no re-record while panning) |
| Per frame during a Move | Only the moving train(s) + effects repaint; ≤ 5 cars × 3 primitives per train |
| Picture record cost | ≤ 4 ms per layer on low-tier (measured in `integration_test` timeline) |
| Beam trace (step 4) | O(beam cells) ≤ 14×14×4 per emitter; < 0.2 ms |
| Level decode | < 150 ms (isolate) |
| Hint | JSON `solution` prefix first; on-device solver isolate 50 ms / 50k nodes; fail ⇒ "Try Restart" toast, Hint not consumed |
| Sync | Off the UI isolate's critical path (async, debounced 2 s during animation) |
| Memory | Cosmetic atlases lazy-loaded (only equipped); album art loaded per open volume |

## 10. QA Checklist

All items **Status: Not run** (no test executed yet).

| ID | Area | Steps | Expected | Status |
|---|---|---|---|---|
| QA-P2-ZM-01 | Zoom enable | Open 11×11 and 12×12 levels | 11×11: no pinch; 12×12: pinch works, starts fitted | Not run |
| QA-P2-ZM-02 | Zoom range | Pinch out/in max on 14×14 | Min = fit; max cell ≈ 48 dp | Not run |
| QA-P2-ZM-03 | Pan vs tap | Drag 10 dp on a train; tap without moving | Drag pans, no Move; tap drives train | Not run |
| QA-P2-ZM-04 | Pan vs Route Peek | Long-press 350 ms then drag | Preview shows, drag cancels preview, no Move | Not run |
| QA-P2-ZM-05 | Not a Move | Zoom/pan/Fit 20 times on a board with M057 | moveCount and signal unchanged | Not run |
| QA-P2-ZM-06 | Fit button | Zoom in, tap ⤢ Fit; Restart; Revive | Animates to fit each time | Not run |
| QA-P2-ZM-07 | Hint auto-pan | Zoom to corner, use Green Signal Hint with target off-screen | Camera centres target; Hint counted once | Not run |
| QA-P2-ZM-08 | Peek edge chip | Long-press a train whose lane leaves viewport | "Track continues →" chip at viewport edge | Not run |
| QA-P2-DG-01 | Diagonal exit | Tap DR train with clear diagonal | Exits via corner/edge, carriages follow 45° joints | Not run |
| QA-P2-DG-02 | Coupling-cross | Diagonal lane between two coupled cars | Bump −1 at coupling | Not run |
| QA-P2-DG-03 | Orthogonal tiles | Diagonal lane into M006 / M014 / M018 / M086 | Bump | Not run |
| QA-P2-LY-01 | 3-layer lock | Mid train covered by top; ground covered by mid | Both locked tap; uncover ⇒ tappable | Not run |
| QA-P2-LY-02 | Tap priority | Tap overlap cell of 3 layers | Top train selected | Not run |
| QA-P2-LY-03 | Crane covered | Track Crane target mode on covered train | Not selectable | Not run |
| QA-P2-BM-01 | Beam blocks lane | Lane crossing a beam | Bump −1 | Not run |
| QA-P2-BM-02 | Beam extends | Exit the train stopping a beam | Same Move lane unaffected; beam longer after | Not run |
| QA-P2-BM-03 | Beam loop | Mirror arrangement forming a loop | Trace terminates; deterministic | Not run |
| QA-P2-BM-04 | Beam passes tiles | Beam over plate, ice, paint, Curve Rail | Passes straight, no turn | Not run |
| QA-P2-TK-01 | Tick order | Golden test with M057, M058, M063, M068, M075, M079, M082, M090, M096 | Matches 01 §7.2 order | Not run |
| QA-P2-TK-02 | Parity | M090 + M096 at moveCount 0, 1, 2 | Uses pre-increment parity | Not run |
| QA-P2-JM-01 | Track jammed | Exit all trains with M062 quota unmet | Sheet [Restart]; no heart lost; no Failed screen | Not run |
| QA-M051 | Mechanic unit + widget test `m051_test.dart` (Diagonal Express, intro L511) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L511 intro on device | Engine matches standard rule: 8-direction heads; diagonal lanes; hammerable = n/a (train); N? = No; tutorial card shown on L511 | Not run |
| QA-M052 | Mechanic unit + widget test `m052_test.dart` (Corner Buffer, intro L521) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L521 intro on device | Engine matches standard rule: Deflects diagonal lanes 90°; hammerable = No; N? = No; tutorial card shown on L521 | Not run |
| QA-M053 | Mechanic unit + widget test `m053_test.dart` (Push Cart, intro L531) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L531 intro on device | Engine matches standard rule: Lane hitting block pushes it 1 cell if free behind (1 Move, path stays, no heart). Blocked ⇒ bump; hammerable = Yes; N? = Yes; tutorial card shown on L531 | Not run |
| QA-M054 | Mechanic unit + widget test `m054_test.dart` (Frosty Rails, intro L541) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L541 intro on device | Engine matches standard rule: Pushed blocks slide until hitting something; hammerable = Ice No · cart Yes; N? = No; tutorial card shown on L541 | Not run |
| QA-M055 | Mechanic unit + widget test `m055_test.dart` (Cart Weighbridge, intro L551) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L551 intro on device | Engine matches standard rule: Push Block on plate ⇒ linked gate open while block stays; hammerable = No; N? = Yes; tutorial card shown on L551 | Not run |
| QA-M056 | Mechanic unit + widget test `m056_test.dart` (Viaduct Ramp, intro L561) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L561 intro on device | Engine matches standard rule: Lane entering ramp moves path to other layer; hammerable = No; N? = No; tutorial card shown on L561 | Not run |
| QA-M057 | Mechanic unit + widget test `m057_test.dart` (Alternating Signal, intro L571) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L571 intro on device | Engine matches standard rule: Gate open/closed alternates every N Moves (periodic); hammerable = No; N? = Yes; tutorial card shown on L571 | Not run |
| QA-M058 | Mechanic unit + widget test `m058_test.dart` (Spinning Arrow Rail, intro L581) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L581 intro on device | Engine matches standard rule: One-way tile rotates 90° CW each Move; hammerable = No; N? = Yes; tutorial card shown on L581 | Not run |
| QA-M059 | Mechanic unit + widget test `m059_test.dart` (Paint Shed, intro L591) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L591 intro on device | Engine matches standard rule: Lane passing paint recolors the path; hammerable = No; N? = No; tutorial card shown on L591 | Not run |
| QA-M060 | Mechanic unit + widget test `m060_test.dart` (Swap Platform, intro L601) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L601 intro on device | Engine matches standard rule: Tap pad ⇒ 2 linked paths swap positions (same shape only); hammerable = No; N? = Yes; tutorial card shown on L601 | Not run |
| QA-M061 | Mechanic unit + widget test `m061_test.dart` (Small Engine Shed, intro L611) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L611 intro on device | Engine matches standard rule: Inner exit accepting N paths, then closes; hammerable = No; N? = Yes; tutorial card shown on L611 | Not run |
| QA-M062 | Mechanic unit + widget test `m062_test.dart` (Delivery Platform Quota, intro L621) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L621 intro on device | Engine matches standard rule: Goal: ≥ Q paths of a color exit via marked edge; hammerable = No; N? = No; tutorial card shown on L621 | Not run |
| QA-M063 | Mechanic unit + widget test `m063_test.dart` (Magnet Post, intro L631) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L631 intro on device | Engine matches standard rule: Each Move pulls the nearest path in its row/col 1 cell toward it if free; hammerable = No; N? = Yes; tutorial card shown on L631 | Not run |
| QA-M064 | Mechanic unit + widget test `m064_test.dart` (Seesaw Barriers, intro L641) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L641 intro on device | Engine matches standard rule: 2 linked gates; exactly one open; flips whenever a lane passes the open one; hammerable = No; N? = Yes; tutorial card shown on L641 | Not run |
| QA-M065 | Mechanic unit + widget test `m065_test.dart` (Hidden Ticket, intro L651) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L651 intro on device | Engine matches standard rule: Key under fog / under another path; revealed when cover clears; hammerable = No; N? = No; tutorial card shown on L651 | Not run |
| QA-M066 | Mechanic unit + widget test `m066_test.dart` (Triple-Coupled Engines, intro L661) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L661 intro on device | Engine matches standard rule: 3-path chain (M011 ×3); hammerable = n/a (train); N? = No; tutorial card shown on L661 | Not run |
| QA-M067 | Mechanic unit + widget test `m067_test.dart` (Worn Sleepers, intro L671) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L671 intro on device | Engine matches standard rule: Cell becomes hole-blocker after lanes pass it N times; hammerable = No; N? = Yes; tutorial card shown on L671 | Not run |
| QA-M068 | Mechanic unit + widget test `m068_test.dart` (Smoke Trail Train, intro L681) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L681 intro on device | Engine matches standard rule: Exiting path leaves temporary blockers on its lane for 2 Moves; hammerable = n/a (train); N? = Yes; tutorial card shown on L681 | Not run |
| QA-M069 | Mechanic unit + widget test `m069_test.dart` (Triple-Deck Viaduct, intro L691) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L691 intro on device | Engine matches standard rule: Ground / mid / top (extends M032); hammerable = No; N? = No; tutorial card shown on L691 | Not run |
| QA-M070 | Mechanic unit + widget test `m070_test.dart` (Roundhouse Lever, intro L701) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L701 intro on device | Engine matches standard rule: Lever rotates every path's dir 90° CW; hammerable = No; N? = Yes; tutorial card shown on L701 | Not run |
| QA-M071 | Mechanic unit + widget test `m071_test.dart` (Departure Quota Gate, intro L711) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L711 intro on device | Engine matches standard rule: Edge opens after Q total exits; hammerable = No; N? = No; tutorial card shown on L711 | Not run |
| QA-M072 | Mechanic unit + widget test `m072_test.dart` (Colour Timetable, intro L721) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L721 intro on device | Engine matches standard rule: Colors must exit in shown repeating pattern; hammerable = n/a (train); N? = No; tutorial card shown on L721 | Not run |
| QA-M073 | Mechanic unit + widget test `m073_test.dart` (Cushion Train, intro L731) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L731 intro on device | Engine matches standard rule: Bubble absorbs bumps *into* this path: 1st lane hitting it pops bubble (no heart loss for that bumping path, which returns); then behaves normally; hammerable = n/a (train); N? = No; tutorial card shown on L731 | Not run |
| QA-M074 | Mechanic unit + widget test `m074_test.dart` (Iron Girder Wall, intro L741) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L741 intro on device | Engine matches standard rule: Not hammerable; removed only by linked lever; hammerable = No; N? = No; tutorial card shown on L741 | Not run |
| QA-M075 | Mechanic unit + widget test `m075_test.dart` (Creeping Steam, intro L751) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L751 intro on device | Engine matches standard rule: Fog expands 1 cell every N Moves (fixed order); hammerable = No; N? = Yes; tutorial card shown on L751 | Not run |
| QA-M076 | Mechanic unit + widget test `m076_test.dart` (Tunnel Network, intro L761) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L761 intro on device | Engine matches standard rule: 3+ portals cycle A→B→C; hammerable = No; N? = No; tutorial card shown on L761 | Not run |
| QA-M077 | Mechanic unit + widget test `m077_test.dart` (Popper Crate, intro L771) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L771 intro on device | Engine matches standard rule: Linked path exit ⇒ clears hammerable obstacles in 3×3; hammerable = No; N? = No; tutorial card shown on L771 | Not run |
| QA-M078 | Mechanic unit + widget test `m078_test.dart` (Island Station, intro L781) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L781 intro on device | Engine matches standard rule: Board edges walled; only inner exits (M020); hammerable = No; N? = No; tutorial card shown on L781 | Not run |
| QA-M079 | Mechanic unit + widget test `m079_test.dart` (Spinning Playmat, intro L791) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L791 intro on device | Engine matches standard rule: Every N Moves whole board rotates 90° CW (paths' dirs rotate too); hammerable = No; N? = Yes; tutorial card shown on L791 | Not run |
| QA-M080 | Mechanic unit + widget test `m080_test.dart` (Twin Ticket Barriers, intro L801) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L801 intro on device | Engine matches standard rule: 2 locks that open only if both keys exit on same Move (via M011 chain); hammerable = No; N? = No; tutorial card shown on L801 | Not run |
| QA-M081 | Mechanic unit + widget test `m081_test.dart` (Copycat Engine, intro L811) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L811 intro on device | Engine matches standard rule: Takes dir of last moved path; hammerable = n/a (train); N? = Yes; tutorial card shown on L811 | Not run |
| QA-M082 | Mechanic unit + widget test `m082_test.dart` (Conveyor Track, intro L821) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L821 intro on device | Engine matches standard rule: Path fully on belt shifts 1 cell along belt each Move if free; hammerable = No; N? = Yes; tutorial card shown on L821 | Not run |
| QA-M083 | Mechanic unit + widget test `m083_test.dart` (Heavy Weighbridge, intro L831) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L831 intro on device | Engine matches standard rule: Only Wide Path (M024) can hold it; hammerable = No; N? = Yes; tutorial card shown on L831 | Not run |
| QA-M084 | Mechanic unit + widget test `m084_test.dart` (Signal Lamp, intro L841) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L841 intro on device | Engine matches standard rule: Beam line acts as blocker; beam stops at first path/blocker; hammerable = No; N? = Yes; tutorial card shown on L841 | Not run |
| QA-M085 | Mechanic unit + widget test `m085_test.dart` (Light Sensor Box, intro L851) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L851 intro on device | Engine matches standard rule: Beam hits receiver ⇒ linked gate open while hit; hammerable = No; N? = Yes; tutorial card shown on L851 | Not run |
| QA-M086 | Mechanic unit + widget test `m086_test.dart` (Signal Mirror, intro L861) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L861 intro on device | Engine matches standard rule: Mirror for beams and lanes; hammerable = No; N? = No; tutorial card shown on L861 | Not run |
| QA-M087 | Mechanic unit + widget test `m087_test.dart` (Jam Spill, intro L871) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L871 intro on device | Engine matches standard rule: Head on glue ⇒ 1st tap unsticks, 2nd exits; hammerable = No; N? = No; tutorial card shown on L871 | Not run |
| QA-M088 | Mechanic unit + widget test `m088_test.dart` (Track Clamp, intro L881) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L881 intro on device | Engine matches standard rule: Mine blocks lane until linked key-path exits (defuse); hammerable = No; N? = No; tutorial card shown on L881 | Not run |
| QA-M089 | Mechanic unit + widget test `m089_test.dart` (Crystal Prism, intro L891) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L891 intro on device | Engine matches standard rule: Beam splits into two 90° beams; hammerable = No; N? = No; tutorial card shown on L891 | Not run |
| QA-M090 | Mechanic unit + widget test `m090_test.dart` (Tick-Tock Gate, intro L901) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L901 intro on device | Engine matches standard rule: Open on odd Move count, closed on even; hammerable = No; N? = Yes; tutorial card shown on L901 | Not run |
| QA-M091 | Mechanic unit + widget test `m091_test.dart` (Rotating Yard 3×3, intro L911) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L911 intro on device | Engine matches standard rule: M034 at 3×3; hammerable = No; N? = Yes; tutorial card shown on L911 | Not run |
| QA-M092 | Mechanic unit + widget test `m092_test.dart` (Uncoupling Train, intro L921) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L921 intro on device | Engine matches standard rule: Each tap exits 1 segment (multi-tap, each = 1 Move); hammerable = n/a (train); N? = No; tutorial card shown on L921 | Not run |
| QA-M093 | Mechanic unit + widget test `m093_test.dart` (Splitting Train, intro L931) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L931 intro on device | Engine matches standard rule: Tap ⇒ splits at midpoint into 2 paths facing opposite; then each exits normally; hammerable = n/a (train); N? = No; tutorial card shown on L931 | Not run |
| QA-M094 | Mechanic unit + widget test `m094_test.dart` (Paint Mixer Shed, intro L941) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L941 intro on device | Engine matches standard rule: Two paints mix (R+B = Purple etc.); hammerable = No; N? = No; tutorial card shown on L941 | Not run |
| QA-M095 | Mechanic unit + widget test `m095_test.dart` (Colour Quota Gate, intro L951) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L951 intro on device | Engine matches standard rule: M071 per color; hammerable = No; N? = No; tutorial card shown on L951 | Not run |
| QA-M096 | Mechanic unit + widget test `m096_test.dart` (Shadow Train, intro L961) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L961 intro on device | Engine matches standard rule: Visible & tappable only on even Move count; never blocks when invisible; hammerable = n/a (train); N? = Yes; tutorial card shown on L961 | Not run |
| QA-M097 | Mechanic unit + widget test `m097_test.dart` (Domino Crates, intro L971) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L971 intro on device | Engine matches standard rule: Clearing first domino (hammer or linked exit) clears chain in order; hammerable = First domino Yes, rest No; N? = No; tutorial card shown on L971 | Not run |
| QA-M098 | Mechanic unit + widget test `m098_test.dart` (Marching Clock Tower, intro L981) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L981 intro on device | Engine matches standard rule: M049 + M025 patrol; hammerable = No; N? = Yes; tutorial card shown on L981 | Not run |
| QA-M099 | Mechanic unit + widget test `m099_test.dart` (Master Station Gate, intro L991) | Fixture boards: happy path, blocked/bump path, every "Edge case (game definition)" in the 03 card, Track Crane interaction, Hint on solution prefix, JSON round-trip; play L991 intro on device | Engine matches standard rule: Needs all key types + laser receiver; hammerable = No; N? = No; tutorial card shown on L991 | Not run |
| QA-FIN-02 | L1000 Finale | Replay stored solution; then play manually | Solvable 0 hearts; tower HP 8 → 0; Grand Central Chest → Coin Rush → Phase Complete (sticker + Vol 5 reward on Phase Complete) | Not run |
| QA-P2-ECO-01 | Gift Crate Phase 2 | Clear L510, L520, L530, L540 | 300 + Shield, 300 + Hint, 300 + Crane, 300 + Shield | Not run |
| QA-P2-ECO-02 | Grand Central Chest (L1000) | Clear L1000 first time; replay | 1,000 + 2 each booster + badge once; replay nothing | Not run |
| QA-P2-ECO-03 | Coin Rush Phase 2 | Clear L525, L550 | Rush with 30 trains; L550 Gift Crate then Rush; no interstitial | Not run |
| QA-ALB-01 | Sticker grant | First-clear L510; replay L510 | Sticker once; replay none | Not run |
| QA-ALB-02 | Retroactive | Phase 1 save at L347 updates to Phase 2 | Stickers L10…L340 granted; Vol 1 + Vol 2 rewards once via catch-up screen | Not run |
| QA-ALB-03 | Volume reward | Complete Vol 4 at L750 | 600 coins + "Lighthouse" Route Peek style once | Not run |
| QA-ALB-04 | Two devices | Grant different stickers offline on 2 devices, sync | Union; volume reward credited once (opId) | Not run |
| QA-ALB-05 | Silhouette frame | Open stickers #1–#8 | Frames cycle Steam Engine … Roundhouse, #8 = Steam Engine | Not run |
| QA-RACE-01 | Eligibility | Before L60, after L60; ≥ 15 levels left vs < 15 | Card locked / joinable / "New tracks coming soon" | Not run |
| QA-RACE-02 | Window | Device time Sat 07:59 / 08:00 / Sun 23:59 / Mon 00:00 | Join only inside window | Not run |
| QA-RACE-03 | Counting | Replay a level, play Daily, Coin Rush, then first-clear | Only first-clear counts | Not run |
| QA-RACE-04 | Ghost fill | Join alone, wait 10 min | Empty seats filled with ghosts; HUD moves | Not run |
| QA-RACE-05 | Ranking | Scripted 5 members reaching 15 | Ranked by server time of 15th clear | Not run |
| QA-RACE-06 | Rewards | Finish 1st…5th; 0 clears | 1st 1,000 + Golden Whistle frame + 3 each booster; 2nd 500 + 2 Crane + 1 Hint; 3rd 250 + 1 Shield; 4–5th 50; 0 clears nothing | Not run |
| QA-RACE-07 | Plausibility | Submit fake moves / too-fast duration / skipped level | Rejected; not counted; `race_reject` logged | Not run |
| QA-RACE-08 | Offline clears | Join, go offline, clear 3, reconnect before close / after close+2 h | Counted at receive time / not counted | Not run |
| QA-RACE-09 | Claim idempotency | Tap Claim twice / on 2 devices | Granted once | Not run |
| QA-RACE-10 | Timezone change | Change timezone mid-race | Window unchanged | Not run |
| QA-PIG-01 | Unlock & deposit | Clear L30, then first-clear L31, replay L31 | Piggy appears after L30; +10 once | Not run |
| QA-PIG-02 | Not spendable | Bank 500, wallet 0, try to buy Hint | Coin sheet; piggy coins not usable | Not run |
| QA-PIG-03 | Cap | Reach 1,000, clear more levels | Stays 1,000; "Piggy full!" | Not run |
| QA-PIG-04 | Break | Break at 1,000 (₹49 sandbox) | +1,000 coins, bank 0, receipt verified | Not run |
| QA-PIG-05 | Min break | Bank 340 vs 350 | Disabled / enabled | Not run |
| QA-PIG-06 | Offline | Break while offline | Disabled with message; deposits continue | Not run |
| QA-PIG-07 | Copy | Inspect piggy sheet text | Compares to Coins S 350/₹49 and Coins M 1,000/₹149; no "% off" claim | Not run |
| QA-COS-01 | Catalog | Open Liveries & Tables after L10 | 6 liveries + 3 tables, prices 800–4,000 | Not run |
| QA-COS-02 | Buy | Buy Heritage Steam with 900 coins | −800; owned; equip | Not run |
| QA-COS-03 | Gameplay-neutral | Equip each livery; colour-blind mode on | Train colour, pattern, engine icon unchanged | Not run |
| QA-COS-04 | VIP livery | VIP active ⇒ equip Conductor's Gold; let VIP expire | Usable while active; reverts to last owned livery | Not run |
| QA-COS-05 | Offline buy | Buy offline, sync | Ledger debited once; owned on all devices | Not run |
| QA-SYNC-01 | Anonymous auth | First online launch | Anonymous uid created; ops flush | Not run |
| QA-SYNC-02 | Link | Link Google (Android) / Apple (iOS) | uid unchanged; restore on 2nd device | Not run |
| QA-SYNC-03 | Credential in use | Link provider that owns another save | Dialog; "Use that save" merges progress, not wallet | Not run |
| QA-SYNC-04 | Idempotency | Drop network after server commit (emulator fault) | Resend acked once; no double coins | Not run |
| QA-SYNC-05 | Progress max | Device A L620 offline, B L640 | Both converge to 640; stars max per level | Not run |
| QA-SYNC-06 | Coins ledger | A earns 300, B spends 200 offline | Server = start + 300 − 200; both converge | Not run |
| QA-SYNC-07 | Negative balance | Both devices spend same 500 coins offline | Ledger negative; UI 0; spends blocked until positive | Not run |
| QA-SYNC-08 | Duplicate first clear | Same level first-cleared on A and B | Coins once; stars max | Not run |
| QA-SYNC-09 | Streak authority | Offline claims with device clock +1 day | Server rejects; streak frozen; coins not revoked | Not run |
| QA-SYNC-10 | Backoff | Functions return `unavailable` ×5 | Retries ≈ 2/4/8/16/32 s (±jitter), cap 5 min | Not run |
| QA-SYNC-11 | Connectivity API | Toggle airplane / Wi-Fi / mobile / VPN | `List<ConnectivityResult>` handled; flush on any non-none | Not run |
| QA-SYNC-12 | Crash safety | Kill app right after a Gift Crate | Coins shown once after relaunch; synced once | Not run |
| QA-SYNC-13 | Rules | Client SDK write to `users/{uid}` | Permission denied | Not run |
| QA-OFF-01 | Full offline | Airplane mode L1→L1000 path sample (L1, 250, 501, 750, 1000) | All playable; boosters, Hint work | Not run |
| QA-OFF-02 | Offline Daily | Clear Daily offline; reconnect | Local grant; server verifies; streak per rules | Not run |
| QA-OFF-03 | Ads offline | Second Chance offline | Ad button disabled "Ad unavailable"; Heart Refill works | Not run |
| QA-OFF-04 | IAP offline | Open Shop offline | IAP disabled message; coin purchases still work | Not run |
| QA-OFF-05 | Queue growth | 300 offline ops then reconnect | Batches of 50; UI responsive | Not run |
| QA-DEL-01 | Account deletion | Settings → Delete account (online) | Cloud data deleted, race anonymized, local save wiped, app restarts at FTUE | Not run |
| QA-DEL-02 | Deletion offline | Try offline | Disabled with message | Not run |
| QA-PERF-01 | 14×14 / 40 trains | Low-tier device, play L1000 | 60 fps during Moves & pan; no jank > 16 ms | Not run |
| QA-PERF-02 | Raster p95 | Mid-tier timeline, 3 layers + 2 beams | p95 < 8 ms | Not run |
| QA-PERF-03 | Board rotation | M079 level rotation | No dropped frames > 2 | Not run |
| QA-PERF-04 | Memory | Equip all liveries sequentially | Only equipped atlas resident | Not run |

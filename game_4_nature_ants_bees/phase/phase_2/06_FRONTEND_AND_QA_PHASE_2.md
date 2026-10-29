# 06 — Frontend Implementation & QA, Phase 2 (ફ્રન્ટએન્ડ અને ચકાસણી)
Phase 2 માટે Flutter architecture ઉમેરાઓ: નવા BLoCs, pinch-zoom/pan viewport, diagonal lanes, 3-layer rendering + tap priority, sunbeam renderer, નવા save fields, 14×14 / 40-line performance અને **QA checklist** (બધા items "Not run").

**Related docs:** [Shared Core Standard §12–§16](../../SHARED_CORE_STANDARD.md) · [Phase 2 README](./README.md) · [01 Phase 2 Rules](./01_PHASE_2_SCOPE_AND_RULES.md) · [03 Obstacle Catalog Phase 2](./03_OBSTACLE_CATALOG_PHASE_2.md) · [04 LiveOps](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) · [05 Offline & Cloud Sync](./05_OFFLINE_AND_CLOUD_SYNC.md) · [Phase 1 Frontend & QA](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Architecture Additions (આર્કિટેક્ચર)

Phase 1 stack યથાવત્ ([phase_1/07 §1](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)): Flutter 3.x / Dart 3 / Impeller, `CustomPainter` + `Ticker` (Flame નહીં), `flutter_bloc`, `hive_ce`, shared `packages/puzzle_core`. Phase 2 ઉમેરે:

| Area | Addition |
|---|---|
| Backend (Standard §13) | `firebase_auth`, `cloud_firestore` (read `state/main`), `cloud_functions` (`applyOps`, `raceJoin`, `raceClaim`, `deleteAccount`, `verifyPurchase`), `firebase_app_check` |
| Connectivity | `connectivity_plus` (`List<ConnectivityResult>` API) |
| IDs | `uuid` (op ids) |
| `puzzle_core` | `Dir8`, `Layer.canopy`, diagonal lane trace (no-cutting), push/slide, beam tracer, Phase 2 mechanics `m051…m099`, tick order Phase 2 |
| Assets | `assets/levels/phase_2.json.gz`, `atlas_canopy.png`, beam/prism sprites, wardrobe skins atlases (lazy-loaded), album sticker art (lazy, 256 px webp) |

```
apps/ants_bees/lib/
├─ blocs/            # + album, race, bank, wardrobe, sync, account, viewport
├─ game/
│  ├─ viewport/      # board_viewport.dart, zoomable_board.dart
│  ├─ painters/      # + beam_painter.dart, canopy layer (layer_painter reused ×3)
│  └─ input/         # tap_resolver.dart (3 layers + new controls)
├─ screens/          # + compendium, star_race, honeycomb_bank, wardrobe, account
└─ services/sync/    # sync_op.dart, sync_service.dart, merge.dart (05)
packages/puzzle_core/lib/src/
├─ model/dir8.dart, layer.dart
├─ rules/lane_trace.dart, push_rules.dart, beam_tracer.dart, tick_order.dart
└─ mechanics/m051_diagonal.dart … m099_master_lock.dart
```

## 2. New BLoCs / Cubits

| BLoC / Cubit | Events / methods | States |
|---|---|---|
| `GameBloc` (extended) | + `SwapPadTapped`, `GlobalRotatorTapped`, `IvyLeverTapped`, `RotorTapped(size)`, `ZoomChanged` (no Move) | `GamePlaying` + `beams`, `layers: 3`, `goalImpossible`, `rotationIndex` |
| `ViewportCubit` | `fit()`, `scaleStart/Update`, `doubleTapAt(cell)`, `toggleZoomButtons` | `{scale, offset, zoomEnabled, maxScale}` |
| `AlbumCubit` | `grantFor(level)`, `retroGrant(highestCleared)`, `markSeen(id)` | `{owned (derived), newIds, volumesComplete}` |
| `RaceBloc` | `RaceOpened`, `RaceJoinPressed`, `RaceClearRecorded(level)`, `RaceRefresh`, `RaceClaimPressed` | `RaceLocked(reason)`, `RaceJoinable`, `RaceActive{cohort, myCount, stale}`, `RaceFinal{rank, reward}`, `RaceClaimed` |
| `BankCubit` | `deposit(level)`, `buy()`, `onPurchaseResult` | `{balance, full, buyable, pending}` |
| `WardrobeCubit` | `preview(sku)`, `buy(sku)`, `equip(sku, slot)`, `onVipChanged` | `{owned, equipped, previewing}` |
| `SyncCubit` | `start()`, `flushNow()`, `onServerState` | `{online, pending, lastSyncUtc, error}` |
| `AccountCubit` | `ensureSignedIn`, `linkGoogle/Apple`, `resolveConflict(choice)`, `deleteAccount` | `Anonymous`, `Linked{providers}`, `LinkConflict{cloudSummary}`, `Deleting`, `Deleted` |

`GameBloc` engine call isolate માં નહીં (apply < 1 ms on 14×14 — §8 budget); Hint solver `Isolate.run` (50 ms, 50k nodes; 3-layer state).

## 3. puzzle_core — Diagonal Lanes, 3 Layers, Beams

```dart
// packages/puzzle_core/lib/src/rules/phase2_core.dart
enum Layer { ground, air, canopy } // index == JSON "layer" (0/1/2)

enum Dir8 {
  u(0, -1),
  d(0, 1),
  l(-1, 0),
  r(1, 0),
  ul(-1, -1),
  ur(1, -1),
  dl(-1, 1),
  dr(1, 1);

  const Dir8(this.dx, this.dy);
  final int dx;
  final int dy;

  bool get isDiagonal => dx != 0 && dy != 0;

  Dir8 rotCw() => switch (this) {
        Dir8.u => Dir8.r,
        Dir8.r => Dir8.d,
        Dir8.d => Dir8.l,
        Dir8.l => Dir8.u,
        Dir8.ur => Dir8.dr,
        Dir8.dr => Dir8.dl,
        Dir8.dl => Dir8.ul,
        Dir8.ul => Dir8.ur,
      };

  Dir8 rotCcw() => rotCw().rotCw().rotCw();
}

final class Cell {
  const Cell(this.x, this.y);
  final int x;
  final int y;

  Cell step(Dir8 d) => Cell(x + d.dx, y + d.dy);

  @override
  bool operator ==(Object other) => other is Cell && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

final class LineModel {
  const LineModel({required this.id, required this.layer, required this.dir, required this.body});
  final String id;
  final Layer layer;
  final Dir8 dir;
  final List<Cell> body; // body[0] = head insect
}

final class Emitter {
  const Emitter(this.cell, this.dir, this.layer);
  final Cell cell;
  final Dir8 dir; // orthogonal only (validator)
  final Layer layer;
}

sealed class BeamEffect {
  const BeamEffect();
}

final class BeamPass extends BeamEffect {
  const BeamPass();
}

final class BeamStop extends BeamEffect {
  const BeamStop();
}

final class BeamTurn extends BeamEffect {
  const BeamTurn(this.dirs); // mirror: 1 dir, prism: 2 dirs
  final List<Dir8> dirs;
}

final class BeamHit extends BeamEffect {
  const BeamHit(this.receiverId);
  final String receiverId;
}

abstract interface class BoardState {
  bool inBounds(Cell c);

  /// Visible, solid line body at [c] in [layer] (ghost / invisible shadow lines excluded).
  LineModel? lineAt(Cell c, Layer layer);

  /// LR-3/LR-4 + LR-P2-2: `layer == ground || tall` already applied by implementation.
  bool blocksLane(Cell c, LineModel line, Dir8 laneDir);

  /// Beam devices / blockers for a beam travelling in [layer].
  BeamEffect beamEffectAt(Cell c, Layer layer, Dir8 dir);

  Iterable<Emitter> get emitters;

  /// Current beam cells (from step 4b of the previous Move).
  bool beamAt(Cell c, Layer layer);
}

/// No-cutting rule (01 §5.2): a diagonal step may not cut between two
/// consecutive body cells of the same same-layer line.
bool cutsLink(BoardState s, Layer layer, Cell from, Dir8 d) {
  final side1 = Cell(from.x + d.dx, from.y);
  final side2 = Cell(from.x, from.y + d.dy);
  final a = s.lineAt(side1, layer);
  final b = s.lineAt(side2, layer);
  if (a == null || b == null || a.id != b.id) return false;
  final i = a.body.indexOf(side1);
  final j = a.body.indexOf(side2);
  return (i - j).abs() == 1;
}

final class LaneResult {
  const LaneResult(this.cells, this.blockedAt);
  final List<Cell> cells; // cells travelled before leaving the board / blocker
  final Cell? blockedAt; // null ⇒ clear
  bool get clear => blockedAt == null;
}

/// Straight (orthogonal or diagonal) lane without redirects; redirects (portals,
/// bumpers, ramps, mirrors) are handled by the full `LaneTracer` with the same checks.
LaneResult traceStraight(BoardState s, LineModel line) {
  final d = line.dir;
  final cells = <Cell>[];
  var cur = line.body.first;
  while (true) {
    final next = cur.step(d);
    if (!s.inBounds(next)) return LaneResult(cells, null);
    if (d.isDiagonal && cutsLink(s, line.layer, cur, d)) return LaneResult(cells, next);
    final other = s.lineAt(next, line.layer);
    if (other != null && other.id != line.id) return LaneResult(cells, next);
    if (s.beamAt(next, line.layer) || s.blocksLane(next, line, d)) {
      return LaneResult(cells, next);
    }
    cells.add(next);
    cur = next;
  }
}

/// LR-P2-3: locked while any HIGHER layer body covers any of its cells.
bool isCoverLocked(BoardState s, LineModel line) {
  for (final higher in Layer.values) {
    if (higher.index <= line.layer.index) continue;
    for (final c in line.body) {
      if (s.lineAt(c, higher) != null) return true;
    }
  }
  return false;
}

final class BeamResult {
  const BeamResult(this.cells, this.litReceivers);
  final Set<(Cell, Layer)> cells;
  final Set<String> litReceivers;
}

/// Step (4b): deterministic beam trace; (cell, dir) revisit stops a branch.
BeamResult traceBeams(BoardState s) {
  final cells = <(Cell, Layer)>{};
  final lit = <String>{};
  for (final e in s.emitters) {
    final visited = <(Cell, Dir8)>{};
    final stack = <(Cell, Dir8)>[(e.cell, e.dir)];
    while (stack.isNotEmpty) {
      final (start, dir) = stack.removeLast();
      var cur = start;
      while (true) {
        final next = cur.step(dir);
        if (!s.inBounds(next) || !visited.add((next, dir))) break;
        if (s.lineAt(next, e.layer) != null) break; // body stops the beam
        final effect = s.beamEffectAt(next, e.layer, dir);
        if (effect is BeamStop) break;
        if (effect is BeamHit) {
          lit.add(effect.receiverId);
          break;
        }
        cells.add((next, e.layer));
        if (effect is BeamTurn) {
          for (final nd in effect.dirs) {
            stack.add((next, nd));
          }
          break;
        }
        cur = next;
      }
    }
  }
  return BeamResult(cells, lit);
}
```

- Corner exit (01 §5.3), ramps (layer switch inside `LaneTracer`), push/slide (`push_rules.dart`) એ જ `BoardState` API વાપરે.
- `tick_order.dart`: Standard §16.17 list as `const phase2TickOrder = ['M007','M017','M031','M025','M098','M027','M047','M041','M057','M058','M063','M067','M068','M075','M079','M082','M090','M096'];` — unit test asserts order.
- JSON parsing: Phase 1 `dir` strings (`U/D/L/R`) ⇒ same `Dir8` values (backward compatible); `layer` 0/1/2 ⇒ `Layer.values[i]`.

## 4. Zoom / Pan Viewport

```dart
// apps/ants_bees/lib/game/viewport/board_viewport.dart
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Board drawn in "fit" coordinates (scale 1 = whole board visible).
/// Screen = offset + boardPoint * scale.
final class BoardViewport extends ChangeNotifier {
  BoardViewport({required this.cols, required Size boardFitSize, required Size viewSize})
      : _board = boardFitSize,
        _view = viewSize {
    fit();
  }

  final int cols;
  Size _board;
  Size _view;
  double _scale = 1;
  Offset _offset = Offset.zero;
  double _startScale = 1;
  Offset _startFocalBoard = Offset.zero;

  static const double _edgeMargin = 24; // 01 §4 pan clamp
  static const double _maxCellDp = 44;

  bool get zoomEnabled => cols >= 12;
  double get scale => _scale;
  Offset get offset => _offset;
  double get maxScale => math.max(1.0, _maxCellDp / (_board.width / cols));

  void resize({required Size boardFitSize, required Size viewSize}) {
    _board = boardFitSize;
    _view = viewSize;
    _clamp();
    notifyListeners();
  }

  Offset toBoard(Offset screen) => (screen - _offset) / _scale;

  void fit() {
    _scale = 1;
    _clamp();
    notifyListeners();
  }

  void onScaleStart(ScaleStartDetails d) {
    _startScale = _scale;
    _startFocalBoard = toBoard(d.localFocalPoint);
  }

  void onScaleUpdate(ScaleUpdateDetails d) {
    if (!zoomEnabled) return;
    _scale = (_startScale * d.scale).clamp(1.0, maxScale);
    // keep the board point under the fingers fixed (pinch) and follow drag (pan)
    _offset = d.localFocalPoint - _startFocalBoard * _scale;
    _clamp();
    notifyListeners();
  }

  /// Double-tap on an EMPTY cell (resolved by the tap handler, no onDoubleTap delay).
  void toggleZoomAt(Offset screen) {
    if (!zoomEnabled) return;
    final focus = toBoard(screen);
    _scale = _scale > 1.0 ? 1.0 : maxScale;
    _offset = screen - focus * _scale;
    _clamp();
    notifyListeners();
  }

  void _clamp() {
    double axis(double off, double content, double view) {
      if (content <= view) return (view - content) / 2;
      return off.clamp(view - content - _edgeMargin, _edgeMargin);
    }

    _offset = Offset(
      axis(_offset.dx, _board.width * _scale, _view.width),
      axis(_offset.dy, _board.height * _scale, _view.height),
    );
  }
}

class ZoomableBoard extends StatefulWidget {
  const ZoomableBoard({
    super.key,
    required this.viewport,
    required this.painter,
    required this.onBoardTap,
  });

  final BoardViewport viewport;
  final CustomPainter painter; // repaints on viewport (Listenable) + game ticker
  final bool Function(Offset boardPoint) onBoardTap; // returns false for empty cell

  @override
  State<ZoomableBoard> createState() => _ZoomableBoardState();
}

class _ZoomableBoardState extends State<ZoomableBoard> {
  DateTime? _lastEmptyTap;

  void _handleTap(TapUpDetails d) {
    final hit = widget.onBoardTap(widget.viewport.toBoard(d.localPosition));
    if (hit) return;
    final now = DateTime.now();
    final last = _lastEmptyTap;
    if (last != null && now.difference(last) < const Duration(milliseconds: 300)) {
      widget.viewport.toggleZoomAt(d.localPosition);
      _lastEmptyTap = null;
    } else {
      _lastEmptyTap = now;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 01 §4: tap vs drag threshold 10 dp.
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        gestureSettings: const DeviceGestureSettings(touchSlop: 10),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: _handleTap,
        onScaleStart: widget.viewport.onScaleStart,
        onScaleUpdate: widget.viewport.onScaleUpdate,
        child: RepaintBoundary(
          child: CustomPaint(painter: widget.painter, size: Size.infinite),
        ),
      ),
    );
  }
}
```

- Painter: `canvas.save(); canvas.translate(vp.offset.dx, vp.offset.dy); canvas.scale(vp.scale); … canvas.restore();` — static board `Picture` zoom પર re-record **નહીં** (vector replay).
- Long-press preview: Phase 1 `LongPressGestureRecognizer(duration: 350 ms)` via `RawGestureDetector` એ જ widget માં; scale gesture શરૂ ⇒ preview cancel.
- `onDoubleTap` વાપરતા નથી (single taps ને 300 ms delay આપે) — double-tap માત્ર empty cells પર manual detect.
- Zoom buttons (accessibility): +/− ⇒ `scale ×/÷ 1.5` around view centre.

## 5. Rendering — 3 Layers, Diagonals, Beams

### 5.1 Paint order
1. Static board `Picture` (lawn, rim, ground obstacles, tall-obstacle bases, slick leaves, brooks, plates) — re-record on `boardVersion`.
2. Ground beams (`BeamPainter`, cached `Picture` per `beamVersion`) → **ant lines**.
3. Tall-obstacle tops → air beams → **bee lines** (6 dp offset).
4. Canopy beams → **canopy lines** (12 dp offset, scale 0.9, lightest shadow).
5. Guardian sprite layer (Great Orb Spider / Great Stag Beetle — above all layers).
6. Overlays: fog/mist (incl. growth telegraph), Twilight mask, cover-lock dim (alpha 0.75 + layer badge), Hint glow, preview lane, targeting dim.

Each line layer = 1 `drawRawAtlas` call (transforms `Float32List` reused, no per-frame allocation). Diagonal segments: atlas `RSTransform` rotation 45° steps (precomputed `scos/ssin` table for 8 dirs). Wing flutter time-based 12 Hz (Phase 1), canopy bees same.

### 5.2 Beam painter
- Beam cells from `traceBeams` ⇒ polyline per branch; glow = pre-baked gradient strip sprite (no `MaskFilter.blur`).
- Beam layer visual: ground beam thin & low (2 dp above lawn), air beam 6 dp up, canopy 12 dp up — same offsets as lines ⇒ "which layer it blocks" readable. Color-blind: beam dash pattern per layer (solid / dash / dot).
- Repaint only when `beamVersion` changes (step 4b result differs).

### 5.3 Tap priority (3 layers)
```dart
// apps/ants_bees/lib/game/input/tap_resolver_p2.dart
import 'package:puzzle_core/puzzle_core.dart';

/// 01 §10: control > canopy > air > ground.
String? resolveLineTap(BoardState state, Cell cell) {
  for (final layer in const [Layer.canopy, Layer.air, Layer.ground]) {
    final line = state.lineAt(cell, layer); // invisible shadow lines return null
    if (line != null) return line.id;
  }
  return null;
}
```
Controls (levers, swap pad, compass flower, ivy lever, rotor hubs) Phase 1 `controlHit` પહેલાં. Leaf Blower targeting: canopy > air > hammerable obstacle > ground.

## 6. Save Data Additions (Hive, schema v1 additive)

Standard §14 Phase 2 fields (`album`, `piggy`, `cosmetics`, `syncQueue`) + Game 4 extras:

| Box | Fields |
|---|---|
| `album` | `seen: List<int>` (milestone levels viewed), `volumesClaimed: List<int>` (owned stickers derived from `highestCleared`) |
| `piggy` (Golden Honeycomb Bank) | `balance`, `depositedLevels` (last 50, for op dedupe), `lastOfferUtc`, `pendingPurchaseId` |
| `cosmetics` | `owned: List<String>`, `equipped{antSkin, beeSkin, boardTheme}`, `skinBeforeVip` |
| `syncQueue` | `Box<String>` op JSON keyed by UUID ([05 §4](./05_OFFLINE_AND_CLOUD_SYNC.md)) |
| `race` *(Game 4 cache addition)* | `raceId`, `cohortSnapshot`, `joinedUtc`, `windowStartUtc`, `windowEndUtc`, `pendingClears`, `lastFetchUtc` |
| `account` *(addition)* | `uid`, `isAnonymous`, `providers` |
| `settings` (+) | `zoomButtons`, `shadowOutlines` |

- Adds are backward compatible (save schema stays v1; missing boxes ⇒ defaults). First Phase 2 launch ⇒ `migrate` op ([05 §2](./05_OFFLINE_AND_CLOUD_SYNC.md)).
- `race`, `account` Standard §14/§16.30 list માં નથી — Standard update માટે report કર્યું.

## 7. Analytics Additions
Phase 1 events + [04 §7](./04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md) LiveOps events + gameplay: `zoom_use{level, maxScale}`, `bump{level, layer: 0|1|2}`, `goal_impossible{level}`, `sync_flush{ops, ms, ok}`, `account_link{provider, result}`.

## 8. Performance — 14×14 boards, 40 lines

| Metric | Target |
|---|---|
| Low-tier Android (2 GB, Redmi 9A class), 14×14, **40 lines**, 3 layers, 2 beams | **60 fps** during exit animation and during pinch |
| ProMotion / 120 Hz | 120 fps |
| Frame raster p95 (mid-tier) | **< 8 ms** (Standard §13) |
| `MoveEngine.apply` (14×14, 40 lines, 14 mechanics, beams + ticks) | < 1 ms mid-tier, < 3 ms low-tier |
| Hint solver (on-device) | ≤ 50 ms, 50k nodes (Standard) — 3-layer state hashing |
| Level load (JSON parse + static picture) | ≤ 200 ms |
| Memory gameplay | ≤ 280 MB low-tier (skins atlases lazy, album art not loaded in gameplay) |

Techniques: static `Picture` cache (zoom = transform only) · 3 `drawRawAtlas` calls for lines (≤ 40 × 8 insects = 320 sprites + 320 shadow quads) · beam `Picture` cached by `beamVersion` · per-layer `RepaintBoundary` only where animation (moving layer) · no `saveLayer` for cover dim (alpha in atlas colors) · pre-baked shadows/glows · `Color.withValues(alpha:)` · atlases ≤ 2048², sprites authored for max zoom 44 dp × 3.0 DPR.

Device matrix: Phase 1 matrix ([phase_1/07 §11](../phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md)) + perf scenes: `perf_14x14_40lines`, `perf_beams_prisms`, `perf_pinch_during_exit`.

## 9. QA Checklist — Phase 2

Status column: બધા **Not run** (કોઈ item execute થયું નથી).

| ID | Area | Steps | Expected | Status |
|---|---|---|---|---|
| QA-Z01 | Zoom enable | Open 11×11 and 12×12 levels | 11×11 no zoom; 12×12 pinch works, starts fit | Not run |
| QA-Z02 | Zoom limits | Pinch beyond max / below fit | Clamped: cell ≈ 44 dp max; fit min | Not run |
| QA-Z03 | Pan clamp | Drag board far | Board edge never > 24 dp inside screen | Not run |
| QA-Z04 | Tap while zoomed | Tap line at 2× zoom | Correct line receives tap (inverse transform) | Not run |
| QA-Z05 | Tap vs drag | Move finger 8 dp / 12 dp | 8 dp ⇒ tap; 12 dp ⇒ pan, no tap | Not run |
| QA-Z06 | Zoom not a Move | Pinch/pan/Fit during M057 level | Moves and counters unchanged | Not run |
| QA-Z07 | Double-tap | Double-tap empty cell; double-tap a line | Empty ⇒ zoom toggle; line ⇒ two taps (no zoom) | Not run |
| QA-Z08 | Preview + zoom | Long-press then start pinch | Preview cancels, zoom proceeds, no tap | Not run |
| QA-Z09 | Onboarding | Play L501–503 fresh | Pinch, pan, Fit tutorials fire once, `ftue_step` logged | Not run |
| QA-DG1 | Diagonal exit | Diagonal ant UR clear | Exits diagonally ≤ 450 ms | Not run |
| QA-DG2 | No-cutting | Diagonal lane across another ant line's diagonal link | Bump at link | Not run |
| QA-DG3 | Squeeze | Diagonal lane between two diagonal-adjacent pebbles | Passes | Not run |
| QA-DG4 | Corner exit | Corner cell, edge wall on one side | Bump | Not run |
| QA-DG5 | Orthogonal-only devices | Diagonal lane into M006/M014/M086 | Bump | Not run |
| QA-L31 | Canopy collision | Canopy lane over air bee and ant | Passes (no collision) | Not run |
| QA-L32 | Canopy tall | Canopy lane into Sunflower Stalk (tall) / pebble | Bump / pass | Not run |
| QA-L33 | Cover chain | Canopy over air over ant; tap order | Only canopy tappable first; then air; then ant | Not run |
| QA-L34 | Tap priority | Tap cell with 3 layers | Canopy line gets tap | Not run |
| QA-L35 | Leaf Blower order | Target 3-layer cell | Canopy removed first | Not run |
| QA-L36 | Validator | L690 JSON with `layer: 2` | CI reject | Not run |
| QA-PB1 | Push | Lane hits acorn, free behind | Block moves 1, line stays, Move +1, no heart | Not run |
| QA-PB2 | Push blocked | Block against edge / block | Bump −1 | Not run |
| QA-PB3 | Slide | Push onto slick strip | Slides to end / before obstacle | Not run |
| QA-BM1 | Beam layers | Ground beam vs bee lane; air beam vs ant lane | Both pass | Not run |
| QA-BM2 | Beam block | Same-layer lane crosses beam | Bump at beam cell | Not run |
| QA-BM3 | Beam extend | Line stopping beam exits | Beam extends in step 4 (after move) | Not run |
| QA-BM4 | Receiver | Route beam to sunflower via mirror | Gate opens while lit | Not run |
| QA-BM5 | Prism | Beam into prism | Two perpendicular beams | Not run |
| QA-TK1 | Tick order | Scripted level with M057+M063+M075+M079+M082 | State after each Move matches golden file | Not run |
| QA-TK2 | Parity | M090 + M096 at moveCount 0..3 | Uses pre-increment parity | Not run |
| QA-M051 | M051 Diagonal Dash Lines (L511) | Diagonal ant UR, clear; then place two-cell ant line forming a diagonal link across its lane; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.1](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M051 edge cases hold; 0-heart solution replays | Not run |
| QA-M052 | M052 Pinecone Bumper (L521) | Diagonal ant UR into cw bumper; orthogonal ant into same bumper; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.2](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M052 edge cases hold; 0-heart solution replays | Not run |
| QA-M053 | M053 Rolling Acorn (L531) | Ant lane hits acorn with free cell behind; then with wall behind; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.3](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M053 edge cases hold; 0-heart solution replays | Not run |
| QA-M054 | M054 Dew-Slick Lily Leaf (L541) | Push acorn onto 4-cell slick strip ending at pebble; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.4](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M054 edge cases hold; 0-heart solution replays | Not run |
| QA-M055 | M055 Seed Socket Plate (L551) | Push acorn onto plate; tall gate opens for bee; push acorn off; gate closes; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.5](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M055 edge cases hold; 0-heart solution replays | Not run |
| QA-M056 | M056 Dandelion Lift (L561) | Ant lane through ramp over a pebble row exits; bee lane through ramp hits ant body ⇒ bump; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.6](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M056 edge cases hold; 0-heart solution replays | Not run |
| QA-M057 | M057 Sleepy Tulip Gate (L571) | N=2 gate: verify open/closed at moveCount 0..5; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.7](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M057 edge cases hold; 0-heart solution replays | Not run |
| QA-M058 | M058 Spinning Seed Arrow (L581) | Arrow start U; tap unrelated line 1 Move; arrow now R; ant lane R passes; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.8](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M058 edge cases hold; 0-heart solution replays | Not run |
| QA-M059 | M059 Pollen Paint Patch (L591) | Red bee through tall purple paint then purple petal gate passes; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.9](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M059 edge cases hold; 0-heart solution replays | Not run |
| QA-M060 | M060 Twin Mushroom Swap (L601) | Swap two same-shape ant lines; key moves with line; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.10](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M060 edge cases hold; 0-heart solution replays | Not run |
| QA-M061 | M061 Little Anthill & Mini Hive (L611) | Cap 2 anthill: 2 ants exit, 3rd bumps; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.11](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M061 edge cases hold; 0-heart solution replays | Not run |
| QA-M062 | M062 Flower Bed Delivery (L621) | Exit 2 red via marked bottom edge; all others elsewhere ⇒ win; exit red elsewhere until impossible ⇒ banner; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.12](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M062 edge cases hold; 0-heart solution replays | Not run |
| QA-M063 | M063 Sugar Cube Lure (L631) | Two ants in lure row at distance 2 and 4: nearest pulled each Move until adjacent; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.13](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M063 edge cases hold; 0-heart solution replays | Not run |
| QA-M064 | M064 Seesaw Twig Gates (L641) | Ant passes open gate; verify flip; bump through open gate does not flip; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.14](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M064 edge cases hold; 0-heart solution replays | Not run |
| QA-M065 | M065 Buried Dew Key (L651) | Key ant under bee: lock shows ?, bee exits, key visible, ant exits, lock opens; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.15](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M065 edge cases hold; 0-heart solution replays | Not run |
| QA-M066 | M066 Petal-Linked Trio (L661) | Trio with one blocked member: all bump, −1 heart; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.16](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M066 edge cases hold; 0-heart solution replays | Not run |
| QA-M067 | M067 Crumbling Soil Patch (L671) | N=2: two ant exits across cell, third ant bumps; bee unaffected; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.17](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M067 edge cases hold; 0-heart solution replays | Not run |
| QA-M068 | M068 Honey-Drip Line (L681) | Exit honey ant; next Move same corridor bump; after 2 Moves clear; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.18](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M068 edge cases hold; 0-heart solution replays | Not run |
| QA-M069 | M069 Canopy Scout Bees (L691) | Stack canopy over air over ant; tap order; tall stalk blocks canopy lane; pebble doesn't; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.19](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M069 edge cases hold; 0-heart solution replays | Not run |
| QA-M070 | M070 Compass Flower Lever (L701) | Rotate all; diagonal UR becomes DR; tangled line locked tap; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.20](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M070 edge cases hold; 0-heart solution replays | Not run |
| QA-M071 | M071 Counting Hedge Gap (L711) | Q=3: 3 exits elsewhere then edge opens; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.21](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M071 edge cases hold; 0-heart solution replays | Not run |
| QA-M072 | M072 Garland Order (L721) | Pattern R,Y,B: tap Y first ⇒ locked; R then Y ok; remove all B ⇒ auto-skip; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.22](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M072 edge cases hold; 0-heart solution replays | Not run |
| QA-M073 | M073 Dew Bubble Line (L731) | Bee lane into bubble bee: no heart, bubble gone; second bump costs heart; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.23](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M073 edge cases hold; 0-heart solution replays | Not run |
| QA-M074 | M074 Old Stone Wall (L741) | Leaf Blower cannot target wall; lever removes it; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.24](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M074 edge cases hold; 0-heart solution replays | Not run |
| QA-M075 | M075 Creeping Mist (L751) | N=3: after 3 Moves fog adds cell in U,R,D,L order; touching exit clears whole area; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.25](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M075 edge cases hold; 0-heart solution replays | Not run |
| QA-M076 | M076 Burrow Network (L761) | 3-portal cycle routes ant A→B, B→C, C→A; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.26](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M076 edge cases hold; 0-heart solution replays | Not run |
| QA-M077 | M077 Puffball Mushroom (L771) | Linked ant exits ⇒ 3×3 pebbles + acorn gone, lock remains; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.27](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M077 edge cases hold; 0-heart solution replays | Not run |
| QA-M078 | M078 Greenhouse Garden (L781) | Ant to edge bumps; to anthill exits; bee to hive exits; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.28](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M078 edge cases hold; 0-heart solution replays | Not run |
| QA-M079 | M079 Turning Flower Bed (L791) | N=4: after 4 Moves positions rotate; edge wall stays; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.29](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M079 edge cases hold; 0-heart solution replays | Not run |
| QA-M080 | M080 Twin Thorn Locks (L801) | Chained key pair exits together ⇒ both locks open; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.30](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M080 edge cases hold; 0-heart solution replays | Not run |
| QA-M081 | M081 Copycat Line (L811) | Exit a D line ⇒ copycat dir D; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.31](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M081 edge cases hold; 0-heart solution replays | Not run |
| QA-M082 | M082 Trickling Brook (L821) | Ant fully on brook shifts 1 per Move until end; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.32](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M082 edge cases hold; 0-heart solution replays | Not run |
| QA-M083 | M083 Stone Slab Plate (L831) | Normal ant on plate: gate closed; wide ant: open; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.33](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M083 edge cases hold; 0-heart solution replays | Not run |
| QA-M084 | M084 Sunbeam Lens (L841) | Air beam blocks bee lane, not ant; ant body does not stop air beam; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.34](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M084 edge cases hold; 0-heart solution replays | Not run |
| QA-M085 | M085 Sun-Seeker Sunflower (L851) | Beam hits sunflower ⇒ gate open; line blocks beam ⇒ gate closes; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.35](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M085 edge cases hold; 0-heart solution replays | Not run |
| QA-M086 | M086 Beetle-Shell Mirror (L861) | Beam R hits / ⇒ goes U; ant lane R ⇒ U; diagonal bee ⇒ bump; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.36](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M086 edge cases hold; 0-heart solution replays | Not run |
| QA-M087 | M087 Tree Sap Drop (L871) | Ant head on sap: first tap unsticks, second exits; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.37](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M087 edge cases hold; 0-heart solution replays | Not run |
| QA-M088 | M088 Bramble Snare (L881) | Snare blocks until key ant exits; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.38](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M088 edge cases hold; 0-heart solution replays | Not run |
| QA-M089 | M089 Dew Prism (L891) | Beam R into prism ⇒ beams U and D; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.39](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M089 edge cases hold; 0-heart solution replays | Not run |
| QA-M090 | M090 Firefly Lantern Gate (L901) | Gate closed at count 0; one Move later open; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.40](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M090 edge cases hold; 0-heart solution replays | Not run |
| QA-M091 | M091 Giant Lily-Pad Rotor (L911) | Rotate 3×3 with line fully inside; partial line ⇒ locked; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.41](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M091 edge cases hold; 0-heart solution replays | Not run |
| QA-M092 | M092 Caravan Line (L921) | Caravan [2,3]: first tap exits 2 cells, second exits rest; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.42](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M092 edge cases hold; 0-heart solution replays | Not run |
| QA-M093 | M093 Scatter Line (L931) | Split 4-cell line ⇒ L half and R half, both exit; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.43](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M093 edge cases hold; 0-heart solution replays | Not run |
| QA-M094 | M094 Petal Mixing Bowl (L941) | Red ant through blue bowl ⇒ purple, passes purple gate; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.44](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M094 edge cases hold; 0-heart solution replays | Not run |
| QA-M095 | M095 Colored Hedge Gap (L951) | Two yellow exits ⇒ edge opens for others; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.45](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M095 edge cases hold; 0-heart solution replays | Not run |
| QA-M096 | M096 Dusk Shadow Line (L961) | Shadow visible at 0, invisible at 1, bee lane passes through at 1; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.46](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M096 edge cases hold; 0-heart solution replays | Not run |
| QA-M097 | M097 Toppling Toadstools (L971) | Hammer d1 ⇒ whole chain cleared; linked exit also clears; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.47](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M097 edge cases hold; 0-heart solution replays | Not run |
| QA-M098 | M098 Great Stag Beetle (L981) | Beetle patrols 1 position/Move, waits if occupied; HP 3 links; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.48](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M098 edge cases hold; 0-heart solution replays | Not run |
| QA-M099 | M099 Royal Hive Door (L991) | Keys done + receiver lit same step ⇒ door opens and stays; repeat with ant, bee (and canopy if L691+) lines and tall true/false where applicable | Result matches [03 §3.49](./03_OBSTACLE_CATALOG_PHASE_2.md) Rule + Ants/Bees/Tall rows; EC-M099 edge cases hold; 0-heart solution replays | Not run |
| QA-EC1 | Gift Box Phase 2 | Clear L510, L520, L530, L540 | 300 + Shield, 300 + Hint, 300 + Leaf Blower, 300 + Shield | Not run |
| QA-EC2 | Chest L1000 | Clear L1000 | Clear 50 + Chest 1,000 + 2 each booster + "Garden Trails II"; order Chest → Rush → Phase Complete | Not run |
| QA-EC3 | Rush Phase 2 | Clear L525 | Rush with 30 lines, 10/line, +100 | Not run |
| QA-EC4 | Hard coins | Clear L519 | 30 coins | Not run |
| QA-AL1 | Sticker grant | First clear L510 | Vol 4 sticker #1 reveal after Gift Box | Not run |
| QA-AL2 | Retroactive | Update with highestCleared 500 | 50 stickers, Vol 1–3 complete rewards (frames) | Not run |
| QA-AL3 | Replay | Replay L510 | No sticker reveal | Not run |
| QA-AL4 | Volume counts | Inspect album | Vol sizes 10/15/25/25/25 = 100 | Not run |
| QA-AL5 | Volume reward | Complete Vol 4 | "Dewdrop" frame + Pressed-Flower Ant skin, no coins | Not run |
| QA-AL6 | Cloud merge | Merge raises highestCleared | Missing stickers granted silently | Not run |
| QA-SR1 | Unlock | highestCleared 59 / 60 | Locked / joinable (Saturday window) | Not run |
| QA-SR2 | Window | Device local Sat 07:59, 08:00, Sun 23:59, Mon 00:00 | Join hidden / open / open / closed | Not run |
| QA-SR3 | Cohort + ghosts | Join alone | Within 10 min 4 racers; info sheet discloses practice racers | Not run |
| QA-SR4 | Counting | First clear, replay, Daily, Rush | Only first clear increments | Not run |
| QA-SR5 | Plausibility | Submit clear with duration 1 s / skipped level | Rejected, count unchanged, `race_reject` | Not run |
| QA-SR6 | Ranking tie | Two reach 15; compare times | Earlier server-accepted time ranks higher | Not run |
| QA-SR7 | Rewards | Finish 1st/2nd/3rd/4th | 1,000+frame+3 each / 500+2 LB+1 Hint / 250+1 Shield / 50 | Not run |
| QA-SR8 | Claim idempotent | Tap Claim twice / two devices | Granted once | Not run |
| QA-SR9 | Offline play | Joined, airplane mode, clear 3 levels, reconnect | 3 clears counted at sync time | Not run |
| QA-SR10 | Late sync | Reconnect after finalize | Late clears ignored for race; podium final | Not run |
| QA-SR11 | Child account | ageBand under-13 | Generated name + preset avatar, no free text | Not run |
| QA-PG1 | Unlock | Clear L29 / L30 | Bank hidden / intro popup | Not run |
| QA-PG2 | Deposit | First clear L31; replay L31; Daily | +10 / 0 / 0 | Not run |
| QA-PG3 | Not spendable | Bank 500, try buying booster with insufficient wallet | Bank coins not usable | Not run |
| QA-PG4 | Cap | Reach 1,000 then clear more | Stays 1,000, "Bank full" | Not run |
| QA-PG5 | Buy threshold | Balance 340 / 350 | Buy disabled / enabled (₹49) | Not run |
| QA-PG6 | Purchase | Buy at 1,000 | Wallet +1,000 (server balance), bank 0 | Not run |
| QA-PG7 | Value text | Bank sheet copy | Compares with Coins S (350 @ ₹49) and Coins M (1,000 @ ₹149) correctly | Not run |
| QA-PG8 | Pending | Store pending purchase | Bank locked "Purchase pending" until resolved | Not run |
| QA-CS1 | Catalog | Open Wardrobe | 6 skins + 3 themes, prices 800–4,000 | Not run |
| QA-CS2 | Buy | Buy Leafcutter Ant with 800 | −800 coins, owned, equip | Not run |
| QA-CS3 | Gameplay neutrality | Equip each skin/theme on M005 level | Colors/glyphs readable, contrast ≥ 3:1, hitboxes same | Not run |
| QA-CS4 | VIP skin | VIP active ⇒ equip Royal Bee; VIP expires | Equip allowed; previous skin restored | Not run |
| QA-CS5 | Album skins | Before/after Vol 4 complete | Not purchasable; equip after completion | Not run |
| QA-CS6 | Offline buy | Buy offline, reconnect | Op applied once; owned on second device | Not run |
| QA-SY1 | Op idempotency | Replay same op batch twice | Server applies once | Not run |
| QA-SY2 | Progress max | Device A L700, B L650 sync | Both 700 | Not run |
| QA-SY3 | Stars max | Level 600: A ★★, B ★★★ | ★★★ both | Not run |
| QA-SY4 | Coins ledger | Earn on A offline, spend on B offline, sync | Server sum; display = server + pending | Not run |
| QA-SY5 | Duplicate first clear | Clear L620 on both devices offline | Clear coins once (`clear:620`) | Not run |
| QA-SY6 | Overdraft | Spend same 800 on two devices offline | Both items owned, balance floored 0, `ledger_overdraft` logged | Not run |
| QA-SY7 | Streak server time | Claim daily with clock +1 day | Streak frozen, coins not revoked | Not run |
| QA-SY8 | Link Google | Anonymous → link | Same uid, providers updated | Not run |
| QA-SY9 | Link conflict | Link to account that has save | Dialog: use that / keep device; no merge | Not run |
| QA-SY10 | Account deletion | Delete account online | Cloud data deleted, local reset, new anonymous user | Not run |
| QA-SY11 | Backoff | Functions unavailable | Retries 1, 2, 4 … ≤ 300 s + jitter; ops kept | Not run |
| QA-OF1 | Offline levels | Airplane mode, play L501–520 | Fully playable, ops queued | Not run |
| QA-OF2 | Offline daily | Airplane mode daily clear | Local reward; verify on reconnect | Not run |
| QA-OF3 | Offline features | Album, Bank deposit, Wardrobe equip offline | Work; Bank purchase disabled; race join disabled | Not run |
| QA-OF4 | Connectivity API | Toggle Wi-Fi/mobile/none | `List<ConnectivityResult>` handled; flush on reconnect | Not run |
| QA-OF5 | Long offline | 6,000 queued ops | Compaction, flush in batches of 100 | Not run |
| QA-OF6 | Offline banner | Offline Home | "Offline — progress saved on device" chip; none in gameplay | Not run |
| QA-PF1 | Perf 14×14 | `perf_14x14_40lines` on Redmi 9A class | ≥ 60 fps, raster p95 < 8 ms mid-tier | Not run |
| QA-PF2 | Pinch perf | Pinch during exit animation | No dropped frames > budget | Not run |
| QA-PF3 | Beams perf | `perf_beams_prisms` | Beam repaint only on change | Not run |
| QA-PF4 | Engine time | 1,000 random Moves on L999 | apply < 3 ms low-tier | Not run |
| QA-PF5 | Hint 3-layer | Hint off-solution on L950 | ≤ 50 ms or toast, not consumed | Not run |

## 10. Unit Tests & CI (Phase 2)

- `puzzle_core` golden tests per M051–M099: JSON fixture + Move script ⇒ expected state hash after each Move (tick order included).
- Determinism: same level + same Move script ⇒ identical hash on Android, iOS, CLI (VM).
- Validator ([03 §4](./03_OBSTACLE_CATALOG_PHASE_2.md)) runs on all 500 Phase 2 levels on every PR touching `assets/levels/` or `puzzle_core`.
- Sync: Firestore emulator + Functions emulator tests for `applyOps` idempotency, natural keys, overdraft floor, streak server-time.
- Integration (`integration_test/`): zoom tutorial L501–503, race join/claim against emulator, bank purchase with test SKU.

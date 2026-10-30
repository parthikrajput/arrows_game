import '../model/board_state.dart';
import '../model/cell.dart';
import '../model/level_def.dart';
import '../model/snake.dart';
import '../prng/xoshiro128ss.dart';

class GeneratorParams {
  const GeneratorParams({
    required this.width,
    required this.height,
    required this.snakeCount,
    this.minLength = 2,
    this.maxLength = 5,
    this.tangle = 0.6,
    this.caterpillarRatio = 0.25,
    this.palette = const [
      SnakeColor.red,
      SnakeColor.green,
      SnakeColor.blue,
      SnakeColor.yellow,
      SnakeColor.purple,
      SnakeColor.orange,
      SnakeColor.pink,
      SnakeColor.teal,
    ],
    this.mask,
  });

  final int width;
  final int height;
  final int snakeCount;
  final int minLength;
  final int maxLength;

  /// 0 = random placement, 1 = always prefer bodies that block earlier lanes.
  final double tangle;
  final double caterpillarRatio;
  final List<SnakeColor> palette;

  /// Allowed body cells (Daily silhouettes). Lanes may still cross outside it.
  final Set<Cell>? mask;
}

/// Reverse construction: snakes are placed last-to-exit first, and each new
/// snake's lane must avoid every snake already placed. Exiting in reverse
/// placement order therefore always works, so every board is solvable with
/// 0 hearts lost and 0 boosters.
abstract final class BoardGenerator {
  static LevelDef generate(String id, GeneratorParams p, int seed, {LevelTag tag = LevelTag.normal}) {
    final rng = Xoshiro128ss(seed);
    final placed = <Snake>[];
    final occupied = <Cell>{};
    final lanes = <Set<Cell>>[];
    final colors = [...p.palette];
    rng.shuffle(colors);

    bool allowed(Cell c) =>
        c.x >= 0 && c.y >= 0 && c.x < p.width && c.y < p.height && !occupied.contains(c) && (p.mask?.contains(c) ?? true);

    final cells = <Cell>[
      for (var y = 0; y < p.height; y++)
        for (var x = 0; x < p.width; x++) Cell(x, y),
    ].where((c) => p.mask?.contains(c) ?? true).toList();

    var guard = p.snakeCount * 60;
    while (placed.length < p.snakeCount && guard-- > 0) {
      _Candidate? best;
      final tries = 1 + (p.tangle * 6).round();
      for (var t = 0; t < tries; t++) {
        final cand = _candidate(rng, p, cells, allowed, occupied);
        if (cand == null) continue;
        var score = 0;
        for (final lane in lanes) {
          if (cand.body.any(lane.contains)) score++;
        }
        if (best == null || score > best.score) best = _Candidate(cand.body, cand.dir, cand.lane, score);
      }
      if (best == null) continue;
      final index = placed.length;
      placed.add(Snake(
        id: 's$index',
        body: List.unmodifiable(best.body),
        dir: best.dir,
        color: colors[index % colors.length],
        caterpillar: rng.nextBool(p.caterpillarRatio),
      ));
      occupied.addAll(best.body);
      lanes.add(best.lane);
    }

    final solution = [for (final s in placed.reversed) s.id];
    return LevelDef(id: id, width: p.width, height: p.height, snakes: placed, tag: tag, solution: solution);
  }

  static _Candidate? _candidate(
    Xoshiro128ss rng,
    GeneratorParams p,
    List<Cell> cells,
    bool Function(Cell) allowed,
    Set<Cell> occupied,
  ) {
    final head = rng.pick(cells);
    if (!allowed(head)) return null;
    final dirs = [...Dir.values];
    rng.shuffle(dirs);
    for (final dir in dirs) {
      final lane = <Cell>{};
      var c = head.step(dir);
      var blocked = false;
      while (c.x >= 0 && c.y >= 0 && c.x < p.width && c.y < p.height) {
        if (occupied.contains(c)) {
          blocked = true;
          break;
        }
        lane.add(c);
        c = c.step(dir);
      }
      if (blocked) continue;

      final neck = head.step(dir.opposite);
      if (!allowed(neck)) continue;
      final target = p.minLength + rng.nextInt(p.maxLength - p.minLength + 1);
      final body = <Cell>[head, neck];
      while (body.length < target) {
        final options = [
          for (final d in Dir.values)
            if (allowed(body.last.step(d)) && !body.contains(body.last.step(d)) && !lane.contains(body.last.step(d)))
              body.last.step(d),
        ];
        if (options.isEmpty) break;
        // Prefer going straight for readable shapes.
        final straight = body.last.step(body[body.length - 2].dirTo(body.last));
        body.add(options.contains(straight) && rng.nextBool(0.55) ? straight : rng.pick(options));
      }
      if (body.length < p.minLength) continue;
      return _Candidate(body, dir, lane, 0);
    }
    return null;
  }

  /// Board without its solution order (for quick checks in tests).
  static BoardState board(LevelDef def) => def.toBoard();
}

class _Candidate {
  const _Candidate(this.body, this.dir, this.lane, this.score);
  final List<Cell> body;
  final Dir dir;
  final Set<Cell> lane;
  final int score;
}

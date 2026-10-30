import 'model.dart';
import 'solver.dart';

class LevelFormatException implements Exception {
  LevelFormatException(this.message);
  final String message;
  @override
  String toString() => 'LevelFormatException: $message';
}

/// Reads and validates level JSON:
/// {"n":1,"tag":"easy","w":5,"h":5,
///  "snakes":[{"body":[[x,y],...],"dir":"R","color":"green","skin":"snake"}],
///  "rocks":[[x,y]]}
class LevelCodec {
  const LevelCodec._();

  static Level decode(Map<String, dynamic> j) {
    try {
      final w = j['w'] as int, h = j['h'] as int;
      final snakes = <int, Snake>{};
      var id = 0;
      for (final raw in (j['snakes'] as List)) {
        final m = raw as Map<String, dynamic>;
        snakes[id] = Snake(
          id: id,
          body: [for (final c in (m['body'] as List)) Cell(c[0] as int, c[1] as int)],
          dir: Dir.parse(m['dir'] as String),
          color: SnakeColor.values.byName(m['color'] as String),
          skin: SnakeSkin.values.byName((m['skin'] as String?) ?? 'snake'),
        );
        id++;
      }
      final rocks = <int, Rock>{};
      var rid = 0;
      for (final c in (j['rocks'] as List? ?? const [])) {
        rocks[rid] = Rock(id: rid, cell: Cell(c[0] as int, c[1] as int));
        rid++;
      }
      final level = Level(
        number: j['n'] as int,
        tag: LevelTag.values.byName((j['tag'] as String?) ?? 'normal'),
        board: BoardState(width: w, height: h, snakes: snakes, rocks: rocks),
      );
      validate(level);
      return level;
    } on LevelFormatException {
      rethrow;
    } catch (e) {
      throw LevelFormatException('Bad level JSON: $e');
    }
  }

  /// Fails on anything that would make a broken or unfair level.
  static void validate(Level level) {
    final b = level.board;
    if (b.width < 4 || b.height < 4 || b.width > 11 || b.height > 11) {
      throw LevelFormatException('L${level.number}: board ${b.width}x${b.height} outside 4..11');
    }
    final used = <Cell>{};
    void claim(Cell c, String what) {
      if (!b.inBounds(c)) throw LevelFormatException('L${level.number}: $what off board at $c');
      if (!used.add(c)) throw LevelFormatException('L${level.number}: overlap at $c');
    }

    for (final s in b.snakes.values) {
      if (s.length < 2 || s.length > 8) {
        throw LevelFormatException('L${level.number}: snake ${s.id} length ${s.length}');
      }
      for (var i = 0; i < s.length; i++) {
        claim(s.body[i], 'snake ${s.id}');
        if (i > 0 && !s.body[i].isNeighbour(s.body[i - 1])) {
          throw LevelFormatException('L${level.number}: snake ${s.id} body not connected');
        }
      }
      // A head facing back into its own neck can never leave.
      if (s.head.step(s.dir) == s.body[1]) {
        throw LevelFormatException('L${level.number}: snake ${s.id} faces its own body');
      }
    }
    for (final r in b.rocks.values) {
      claim(r.cell, 'rock ${r.id}');
    }
    if (b.snakes.isEmpty) throw LevelFormatException('L${level.number}: no snakes');
    if (!Solver.isSolvable(b)) {
      throw LevelFormatException('L${level.number}: not solvable with 0 hearts and 0 boosters');
    }
  }
}

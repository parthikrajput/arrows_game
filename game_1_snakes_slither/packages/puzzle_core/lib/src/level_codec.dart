import 'model.dart';
import 'solver.dart';

class LevelFormatException implements Exception {
  LevelFormatException(this.message);
  final String message;
  @override
  String toString() => 'LevelFormatException: $message';
}

/// Reads level JSON schema v3 (shared core standard §12):
/// {"schema":3,"level":1,"phase":1,"seed":"0x…","slot":"intro","tag":"normal",
///  "grid":[4,4],"layers":1,"hearts":3,
///  "paths":[{"id":"p1","color":"green","dir":"R","body":[[2,1],[1,1]],"layer":0,"mods":{}}],
///  "mechanics":[{"id":"o1","type":"M001","cells":[[3,2]],"params":{},"hammerable":true}],
///  "goals":{"gems":0},"par_moves":2,"difficulty":1.2,"solution":["p1","p2"]}
class LevelCodec {
  const LevelCodec._();

  static const schema = 3;

  /// Mechanics the engine can play today. Others are rejected on load.
  static const supportedMechanics = {'M001'};

  /// Decodes and checks that the level is playable (structure + solvable).
  /// Design rules (tiers, D band, slots) are LevelValidator's job.
  static Level decode(Map<String, dynamic> j) {
    final n = j['level'];
    final where = 'L${n ?? '?'}';
    try {
      if (j['schema'] != schema) {
        throw LevelFormatException('$where: schema must be $schema, got ${j['schema']}');
      }
      final grid = (j['grid'] as List).cast<int>();
      final snakes = <int, Snake>{};
      final seenIds = <String>{};
      void claimId(String id) {
        if (!seenIds.add(id)) throw LevelFormatException('$where: duplicate id "$id"');
      }

      for (final raw in (j['paths'] as List)) {
        final m = raw as Map<String, dynamic>;
        final ref = m['id'] as String;
        claimId(ref);
        if ((m['layer'] as int? ?? 0) != 0) {
          throw LevelFormatException('$where: $ref uses layer ${m['layer']} (not supported yet)');
        }
        final mods = (m['mods'] as Map?) ?? const {};
        final id = snakes.length;
        snakes[id] = Snake(
          id: id,
          ref: ref,
          body: [for (final c in (m['body'] as List)) Cell(c[0] as int, c[1] as int)],
          dir: Dir.parse(m['dir'] as String),
          color: SnakeColor.values.byName(m['color'] as String),
          skin: SnakeSkin.values.byName((mods['skin'] as String?) ?? 'snake'),
        );
      }
      final rocks = <int, Rock>{};
      final types = <String>[];
      for (final raw in (j['mechanics'] as List? ?? const [])) {
        final m = raw as Map<String, dynamic>;
        final ref = m['id'] as String;
        claimId(ref);
        final type = m['type'] as String;
        types.add(type);
        if (!supportedMechanics.contains(type)) {
          throw LevelFormatException('$where: mechanic $type ($ref) is not in the engine yet');
        }
        final cells = (m['cells'] as List);
        if (cells.length != 1) {
          throw LevelFormatException('$where: $type $ref must cover exactly 1 cell');
        }
        final id = rocks.length;
        rocks[id] = Rock(id: id, ref: ref, cell: Cell(cells[0][0] as int, cells[0][1] as int));
      }
      final level = Level(
        number: n as int,
        tag: LevelTag.values.byName(j['tag'] as String),
        slot: LevelSlot.values.byName(j['slot'] as String),
        board: BoardState(width: grid[0], height: grid[1], snakes: snakes, rocks: rocks),
        parMoves: j['par_moves'] as int? ?? 0,
        difficulty: (j['difficulty'] as num? ?? 0).toDouble(),
        solution: ((j['solution'] as List?) ?? const []).cast<String>(),
        mechanicTypes: types,
      );
      validate(level);
      return level;
    } on LevelFormatException {
      rethrow;
    } catch (e) {
      throw LevelFormatException('$where: bad level JSON ($e)');
    }
  }

  /// Decodes a whole level file: {"schema":3,"phase":1,"levels":[...]}.
  /// Levels must be numbered 1..N with no gaps.
  static List<Level> decodeFile(Map<String, dynamic> file) {
    final levels = [
      for (final raw in (file['levels'] as List)) decode(raw as Map<String, dynamic>),
    ];
    for (var i = 0; i < levels.length; i++) {
      if (levels[i].number != i + 1) {
        throw LevelFormatException(
          'level list must be 1..N in order; found L${levels[i].number} '
          'at position ${i + 1}',
        );
      }
    }
    return levels;
  }

  /// Fails on anything that would make a broken or unfair level.
  static void validate(Level level) {
    final b = level.board;
    final where = 'L${level.number}';
    if (b.width < 4 || b.height < 4 || b.width > 11 || b.height > 11) {
      throw LevelFormatException('$where: board ${b.width}x${b.height} outside 4..11');
    }
    final used = <Cell>{};
    void claim(Cell c, String what) {
      if (!b.inBounds(c)) throw LevelFormatException('$where: $what off board at $c');
      if (!used.add(c)) throw LevelFormatException('$where: overlap at $c');
    }

    for (final s in b.snakes.values) {
      final name = s.ref.isEmpty ? 'snake ${s.id}' : s.ref;
      if (s.length < 2 || s.length > 8) {
        throw LevelFormatException('$where: $name length ${s.length} (must be 2..8)');
      }
      for (var i = 0; i < s.length; i++) {
        claim(s.body[i], name);
        if (i > 0 && !s.body[i].isNeighbour(s.body[i - 1])) {
          throw LevelFormatException('$where: $name body is not connected');
        }
      }
      // A head facing back into its own neck can never leave.
      if (s.head.step(s.dir) == s.body[1]) {
        throw LevelFormatException('$where: $name faces its own body');
      }
    }
    for (final r in b.rocks.values) {
      claim(r.cell, r.ref.isEmpty ? 'rock ${r.id}' : r.ref);
    }
    if (b.snakes.isEmpty) throw LevelFormatException('$where: no snakes');
    if (!Solver.isSolvable(b)) {
      throw LevelFormatException('$where: not solvable with 0 hearts and 0 boosters');
    }
  }
}

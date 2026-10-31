import 'level_validator.dart';
import 'model.dart';

/// Checks a level straight from its JSON, without playing it. This works for
/// every Phase 1 mechanic, so the level designer can draft blocks the engine
/// can't play yet. Solvability and the exact D are checked later, once the
/// engine supports the level's mechanics (see LevelValidator).
class LevelDraftCheck {
  const LevelDraftCheck._();

  /// Obstacles that the Hammer may remove (fixed defaults, may not be overridden).
  static const hammerableTypes = {'M001', 'M002', 'M016', 'M025', 'M027'};

  /// Params that name snakes by id.
  static const _pathRefKeys = ['path', 'paths', 'keyPath', 'keyPaths', 'order', 'linked'];

  static const _colors = {'red', 'green', 'blue', 'yellow', 'purple', 'orange', 'pink', 'teal'};

  static List<String> check(Map<String, dynamic> j) {
    final p = <String>[];
    try {
      _check(j, p);
    } catch (e) {
      p.add('bad JSON shape ($e)');
    }
    return p;
  }

  static void _check(Map<String, dynamic> j, List<String> p) {
    if (j['schema'] != 3) p.add('"schema" must be 3');
    final n = j['level'] as int;
    final t = LevelTarget.forLevel(n);

    // Slot and tag.
    final slot = LevelTarget.slotFor(n);
    if (j['slot'] != slot.name) p.add('slot is "${j['slot']}", L$n must be "${slot.name}"');
    final tag = LevelTarget.tagFor(slot);
    if (j['tag'] != tag.name) p.add('tag is "${j['tag']}", slot ${slot.name} needs "${tag.name}"');

    // Grid.
    final grid = (j['grid'] as List).cast<int>();
    final w = grid[0], h = grid[1];
    if (w < t.minGrid || w > t.maxGrid || h < t.minGrid || h > t.maxGrid) {
      p.add('grid ${w}x$h outside ${t.minGrid}x${t.minGrid}–${t.maxGrid}x${t.maxGrid}');
    }
    bool inside(List c) =>
        c[0] is int && c[1] is int && c[0] >= 0 && c[1] >= 0 && c[0] < w && c[1] < h;

    final mechanics = ((j['mechanics'] as List?) ?? const []).cast<Map<String, dynamic>>();
    final types = [for (final m in mechanics) m['type'] as String];
    final usesCanopy = types.contains('M032');

    // Ids.
    final ids = <String>{};
    void claimId(String id) {
      if (!ids.add(id)) p.add('duplicate id "$id"');
    }

    // Snakes.
    final paths = (j['paths'] as List).cast<Map<String, dynamic>>();
    if (paths.length < t.minSnakes || paths.length > t.maxSnakes) {
      p.add('${paths.length} snakes, needs ${t.minSnakes}–${t.maxSnakes}');
    }
    final pathIds = <String>{};
    final occupied = <String, String>{}; // "layer:x,y" → path id
    for (final s in paths) {
      final id = s['id'] as String;
      claimId(id);
      pathIds.add(id);
      if (!_colors.contains(s['color'])) p.add('$id: unknown colour "${s['color']}"');
      if (!{'U', 'D', 'L', 'R'}.contains(s['dir'])) p.add('$id: dir must be U, D, L or R');
      final layer = s['layer'] as int? ?? 0;
      if (layer != 0 && !(layer == 1 && usesCanopy)) {
        p.add('$id: layer $layer needs an M032 Canopy & Ground level');
      }
      final body = (s['body'] as List).cast<List>();
      final maxLen = n <= 10 ? 4 : 8;
      if (body.length < 2 || body.length > maxLen) {
        p.add('$id: length ${body.length} (must be 2–$maxLen)');
      }
      for (var i = 0; i < body.length; i++) {
        final c = body[i];
        if (!inside(c)) {
          p.add('$id: cell $c off the board');
          continue;
        }
        final key = '$layer:${c[0]},${c[1]}';
        final other = occupied[key];
        if (other != null) p.add('$id overlaps $other at $c');
        occupied[key] = id;
        if (i > 0) {
          final prev = body[i - 1];
          if ((c[0] - prev[0]).abs() + (c[1] - prev[1]).abs() != 1) {
            p.add('$id: body is not connected at $c');
          }
        }
      }
      if (body.length >= 2 && s['dir'] is String && {'U', 'D', 'L', 'R'}.contains(s['dir'])) {
        final d = Dir.parse(s['dir'] as String);
        final head = body[0], neck = body[1];
        if (head[0] + d.dx == neck[0] && head[1] + d.dy == neck[1]) {
          p.add('$id faces its own body');
        }
      }
      final mods = (s['mods'] as Map?) ?? const {};
      for (final k in mods.keys) {
        if (k != 'skin') p.add('$id: "mods" is only for the skin; put "$k" in mechanics');
      }
    }

    // Mechanics.
    if (mechanics.length > t.maxObstacles) {
      p.add('${mechanics.length} obstacles, max ${t.maxObstacles}');
    }
    final mechIds = {for (final m in mechanics) m['id'] as String};
    final introType = LevelTarget.blockMechanic(n);
    final introNum = introType == null ? 0 : int.parse(introType.substring(1));
    final childIds = <String>{};
    for (final m in mechanics) {
      final id = m['id'] as String;
      final type = m['type'] as String;
      claimId(id);
      final num = RegExp(r'^M0(\d\d)$').firstMatch(type);
      if (num == null || int.parse(num.group(1)!) < 1 || int.parse(num.group(1)!) > 49) {
        p.add('$id: unknown type "$type" (Phase 1 uses M001–M049)');
        continue;
      }
      if (int.parse(num.group(1)!) > introNum) {
        p.add('$id: $type is not unlocked until a later block');
      }
      for (final c in (m['cells'] as List)) {
        if (!inside(c as List)) p.add('$id: cell $c off the board');
      }
      final hammerable = hammerableTypes.contains(type);
      if (m['hammerable'] != hammerable) p.add('$id: $type must have "hammerable": $hammerable');
      final params = (m['params'] as Map?) ?? const {};
      for (final key in _pathRefKeys) {
        final v = params[key];
        final refs = v is String
            ? [v]
            : v is List
            ? v.whereType<String>()
            : const <String>[];
        for (final r in refs) {
          if (!pathIds.contains(r)) p.add('$id: params.$key names "$r", which is not a snake');
        }
      }
      for (final gate in ((params['gates'] as List?) ?? const [])) {
        if (gate is List && !inside(gate)) p.add('$id: gate $gate off the board');
      }
      for (final r in ((params['turntables'] as List?) ?? const []).whereType<String>()) {
        if (!mechIds.contains(r)) p.add('$id: turntable "$r" is not a mechanic in this level');
      }
      final child = params['child'];
      if (child is Map && child['id'] is String) childIds.add(child['id'] as String);
    }
    if (introType == null) {
      if (mechanics.isNotEmpty) p.add('FTUE levels must have no obstacles');
    } else if (n != 500) {
      final count = types.where((x) => x == introType).length;
      if (count == 0) p.add('every level in this block needs at least 1 $introType');
      if (slot == LevelSlot.intro) {
        if (count > 2) p.add('intro level: $introType must appear 1–2 times, found $count');
        if (types.toSet().difference({introType}).length > 1) {
          p.add('intro level: only $introType plus at most 1 older mechanic');
        }
      }
    }

    // Solution, par and the stated D.
    final solution = ((j['solution'] as List?) ?? const []).cast<String>();
    if (solution.isEmpty) p.add('"solution" is empty');
    for (final (i, ref) in solution.indexed) {
      if (!pathIds.contains(ref) && !mechIds.contains(ref) && !childIds.contains(ref)) {
        p.add('solution step ${i + 1}: "$ref" is not a snake or obstacle in this level');
      }
    }
    if (j['par_moves'] != solution.length) {
      p.add('"par_moves" is ${j['par_moves']}, solution has ${solution.length} moves');
    }
    if (t.maxMoves != null && solution.length > t.maxMoves!) {
      p.add('FTUE optimal moves ${solution.length}, max ${t.maxMoves}');
    }
    final d = (j['difficulty'] as num?)?.toDouble();
    final (minD, maxD) = LevelValidator.dBand(n, slot);
    if (d == null) {
      p.add('"difficulty" is missing');
    } else if (d < minD || d > maxD) {
      p.add('"difficulty" $d outside ${minD.toStringAsFixed(1)}–${maxD.toStringAsFixed(1)}');
    }
  }
}

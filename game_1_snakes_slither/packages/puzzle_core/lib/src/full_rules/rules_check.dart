import 'level_json.dart';
import 'rules.dart';

/// Plays a level under the full Phase 1 rules (M001–M049): the solution must
/// win with no bonk, the stated difficulty must match, and banned mechanic
/// combinations are rejected. Works straight from level JSON.
class RulesCheck {
  const RulesCheck._();

  static List<String> check(Map<String, dynamic> raw) {
    final Level lv;
    try {
      lv = parseLevel(raw);
    } catch (e) {
      return ['rules: cannot read level ($e)'];
    }
    final p = <String>[..._bannedCombos(lv)];
    final sim = Sim(lv);
    final solution = ((raw['solution'] as List?) ?? const []).cast<String>();
    final err = replay(sim, solution);
    if (err != null) p.add('solution does not win: $err');
    final (d, c, _) = difficulty(lv, sim, solution.length);
    final stated = (raw['difficulty'] as num?)?.toDouble();
    if (stated != null && (stated - d).abs() > 0.05) {
      p.add('"difficulty" says $stated, computed $d (C $c)');
    }
    return p;
  }

  static List<String> _bannedCombos(Level lv) {
    final p = <String>[];
    final types = {for (final m in lv.mechs) m.type};
    if (types.contains('M010') && types.contains('M040')) p.add('Jungle Mist + Jungle Night on one board');
    if (types.contains('M024') && types.any(const {'M008', 'M014', 'M018', 'M044'}.contains)) {
      p.add('Giant Anaconda with a lane redirect');
    }
    for (final m in lv.mechs) {
      if (m.type == 'M033' && lv.snakes[m.path].color == m.color) {
        p.add('${m.id}: Petal Cage colour equals the caged snake');
      }
    }
    final sim = Sim(lv);
    final st = sim.initial();
    for (var s = 0; s < lv.snakes.length; s++) {
      if (lv.snakes[s].isChild) continue;
      if (sim.laneOf(st, s).kind == 5) p.add('${lv.snakes[s].id}: lane loops');
    }
    for (final m in lv.mechs) {
      if (!const {'M011', 'M039', 'M048'}.contains(m.type)) continue;
      final lanes = [for (final s in m.paths) sim.laneOf(st, s).lane.toSet()];
      for (var i = 0; i < lanes.length; i++) {
        for (var j = i + 1; j < lanes.length; j++) {
          if (lanes[i].any(lanes[j].contains)) p.add('${m.id}: group lanes cross');
        }
      }
    }
    return p;
  }
}

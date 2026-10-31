import 'rules.dart';

/// Builds a rules level from schema v3 JSON.
Level parseLevel(Map<String, dynamic> j) {
  final g = (j['grid'] as List).cast<int>();
  final lv = Level(g[0], g[1]);
  lv.layers = j['layers'] as int? ?? 1;
  int cellOf(List c) => lv.cell(c[0] as int, c[1] as int);
  final ids = <String, int>{};
  for (final p in (j['paths'] as List).cast<Map<String, dynamic>>()) {
    final s = Snake(p['id'] as String, p['color'] as String,
        [for (final c in p['body'] as List) cellOf(c as List)], dirOf(p['dir'] as String),
        layer: p['layer'] as int? ?? 0);
    s.caterpillar = (p['mods'] as Map?)?['skin'] == 'caterpillar';
    ids[s.id] = lv.snakes.length;
    lv.snakes.add(s);
  }
  final mechIds = <String, int>{};
  final raws = (j['mechanics'] as List? ?? const []).cast<Map<String, dynamic>>();
  for (final m in raws) {
    mechIds[m['id'] as String] = lv.mechs.length;
    final mm = Mech(m['id'] as String, m['type'] as String,
        [for (final c in m['cells'] as List) cellOf(c as List)], Map<String, dynamic>.of((m['params'] as Map? ?? {}).cast<String, dynamic>()));
    lv.mechs.add(mm);
  }
  for (final m in lv.mechs) {
    final p = m.params;
    if (p['path'] is String) m.path = ids[p['path']]!;
    if (p['paths'] is List) m.paths = [for (final x in p['paths'] as List) ids[x]!];
    if (p['linked'] is List) m.paths = [for (final x in p['linked'] as List) ids[x]!];
    if (p['k'] is int) m.k = p['k'] as int;
    if (p['n'] is int) m.n = p['n'] as int;
    if (p['hp'] is int) m.hp = p['hp'] as int;
    if (p['color'] is String) m.color = p['color'] as String;
    if (p['arrow'] is String) m.arrow = dirOf(p['arrow'] as String);
    if (p['axis'] is String) m.axis = p['axis'] == 'H' ? 0 : 1;
    if (p['side'] is String) m.side = dirOf(p['side'] as String);
    if (p['orient'] is String) m.orient = p['orient'] as String;
    if (p['state'] is String) m.state = p['state'] == 'L' ? 0 : 1;
    if (p['start'] is int) m.start = p['start'] as int;
    if (p['keyPath'] is String) m.keyPath = ids[p['keyPath']]!;
    if (p['keyPaths'] is List) m.keyPaths = [for (final x in p['keyPaths'] as List) ids[x]!];
    if (p['order'] is List) m.order = [for (final x in p['order'] as List) ids[x]!];
    if (p['cycle'] is List) m.cycle = (p['cycle'] as List).cast<String>();
    if (p['rot'] is List) m.rot = [for (final x in p['rot'] as List) x == 'CW' ? 1 : -1];
    if (p['gates'] is List) {
      m.gates = [for (final c in p['gates'] as List) cellOf(c as List)];
      if (m.type == 'M009') {
        final init = (p['initial'] as List?)?.cast<String>() ?? [for (final _ in m.gates) 'closed'];
        m.gateInit = 0;
        for (var i = 0; i < init.length; i++) {
          if (init[i] == 'open') m.gateInit |= 1 << i;
        }
      }
    }
    if (p['turntables'] is List) {
      m.turntables = [for (final x in p['turntables'] as List) mechIds[x]!];
    }
    if (p['head'] is List) m.headCell = cellOf(p['head'] as List);
    if (p['dir'] is String) m.loopDir = dirOf(p['dir'] as String);
    if (m.type == 'M022') lv.snakes[m.path].reverse = true;
    if (m.type == 'M023') lv.snakes[m.path].hydra = true;
    if (m.type == 'M024') {
      final s = lv.snakes[m.path];
      s.wideSide = p['side'] == 'R' ? cw(s.dir) : ccw(s.dir);
    }
    if (p['child'] is Map) {
      final c = p['child'] as Map;
      final s = Snake(c['id'] as String, c['color'] as String,
          [for (final x in c['body'] as List) cellOf(x as List)], dirOf(c['dir'] as String))
        ..isChild = true;
      m.child = s;
      m.childIdx = lv.snakes.length;
      lv.snakes.add(s);
    }
  }
  return lv;
}

double roundD(double v) => (v * 10).round() / 10;

/// D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
(double, int, int) difficulty(Level lv, Sim sim, int moves) {
  final p = lv.baseSnakes;
  final c = sim.chain();
  final o = lv.mechs.length;
  final nn = lv.mechs.where((m) => nTypes.contains(m.type)).length;
  final s = moves - p;
  return (roundD(0.6 * p + 1.5 * c + 2.0 * o + 3.0 * nn + 1.0 * s), c, nn);
}

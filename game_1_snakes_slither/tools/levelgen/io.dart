import 'dart:convert';

import 'package:puzzle_core/full_rules.dart';

List<int> xy(Level lv, int c) => [lv.cx(c), lv.cy(c)];

Map<String, dynamic> pathJson(Level lv, Snake s) => {
      'id': s.id,
      'color': s.color,
      'dir': dirNames[s.dir],
      'body': [for (final c in s.body) xy(lv, c)],
      'layer': s.layer,
      'mods': s.caterpillar ? {'skin': 'caterpillar'} : {},
    };

Map<String, dynamic> levelJson(Level lv, int n, String slot, String tag, List<String> solution,
    double d, {int gems = 0}) {
  return {
    'schema': 3,
    'level': n,
    'phase': 1,
    'seed': '0x${n.toRadixString(16).padLeft(16, '0')}',
    'slot': slot,
    'tag': tag,
    'grid': [lv.w, lv.h],
    'layers': lv.layers,
    'hearts': 3,
    'paths': [for (final s in lv.snakes) if (!s.isChild) pathJson(lv, s)],
    'mechanics': [
      for (final m in lv.mechs)
        {
          'id': m.id,
          'type': m.type,
          'cells': [for (final c in m.cells) xy(lv, c)],
          'params': m.params,
          'hammerable': hammerTypes.contains(m.type),
        }
    ],
    'goals': {'gems': gems},
    'par_moves': solution.length,
    'difficulty': d,
    'solution': solution,
  };
}

/// Readable but compact: one line per snake and per mechanic.
String encodeFile(Map<String, dynamic> root) {
  final sb = StringBuffer('{\n "schema": ${root['schema']},\n "phase": ${root['phase']},\n "levels": [\n');
  final levels = (root['levels'] as List).cast<Map<String, dynamic>>();
  for (var i = 0; i < levels.length; i++) {
    final l = levels[i];
    sb.write('  {\n');
    final keys = l.keys.toList();
    for (var k = 0; k < keys.length; k++) {
      final key = keys[k];
      final v = l[key];
      sb.write('   ${jsonEncode(key)}: ');
      if ((key == 'paths' || key == 'mechanics') && (v as List).isNotEmpty) {
        sb.write('[\n');
        for (var e = 0; e < v.length; e++) {
          sb.write('    ${jsonEncode(v[e])}${e < v.length - 1 ? ',' : ''}\n');
        }
        sb.write('   ]');
      } else {
        sb.write(jsonEncode(v));
      }
      sb.write(k < keys.length - 1 ? ',\n' : '\n');
    }
    sb.write('  }${i < levels.length - 1 ? ',' : ''}\n');
  }
  sb.write(' ]\n}\n');
  return sb.toString();
}


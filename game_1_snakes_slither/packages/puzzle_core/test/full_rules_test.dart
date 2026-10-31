import 'package:puzzle_core/full_rules.dart';
import 'package:test/test.dart';

// Small 5×5 boards, one or two per mechanic card. Coordinates are [x, y].

Map<String, dynamic> sn(String id, String dir, List<List<int>> body, {String color = 'green', int layer = 0}) =>
    {'id': id, 'color': color, 'dir': dir, 'body': body, 'layer': layer, 'mods': {}};

Map<String, dynamic> ob(String id, String type, List<List<int>> cells, [Map<String, dynamic>? params]) =>
    {'id': id, 'type': type, 'cells': cells, 'params': params ?? {}, 'hammerable': false};

Map<String, dynamic> board(List<Map<String, dynamic>> paths, [List<Map<String, dynamic>> mechs = const [], int layers = 1]) =>
    {'grid': [5, 5], 'layers': layers, 'paths': paths, 'mechanics': mechs};

/// Upward snake in column x, head at row 3 (lane: rows 2, 1, 0).
Map<String, dynamic> up(String id, int x, {String color = 'green'}) => sn(id, 'U', [[x, 3], [x, 4]], color: color);

/// A snake in the bottom-left corner that can always leave (a spare Move).
Map<String, dynamic> spare(String id, [int y = 4]) => sn(id, 'L', [[0, y], [1, y]]);

class Play {
  Play(Map<String, dynamic> raw) : sim = Sim(parseLevel(raw)) {
    // a malformed test board could make a test pass for the wrong reason
    final lv = sim.lv;
    final seen = <int>{};
    for (final s in lv.snakes.where((s) => !s.isChild)) {
      for (final c in s.body) {
        expect(seen.add(s.layer * 1000 + c), isTrue, reason: '${s.id} overlaps another snake');
      }
      expect(lv.step(s.body[0], s.dir) == s.body[1], isFalse, reason: '${s.id} faces its own neck');
    }
    st = sim.initial();
  }
  final Sim sim;
  late St st;

  /// 'exit', 'move' (legal, not an exit) or 'no' (bump, locked or not allowed).
  String tap(String id) {
    final o = sim.apply(st, id);
    if (o.kind < 0) return 'no';
    st = o.next!;
    return o.kind == 0 ? 'exit' : 'move';
  }

  List<String> taps(List<String> ids) => [for (final id in ids) tap(id)];
  bool get won => sim.won(st);
}

void main() {
  group('blockers', () {
    test('M001 Garden Rock blocks a lane', () {
      expect(Play(board([up('p1', 2)], [ob('o1', 'M001', [[2, 1]])])).tap('p1'), 'no');
    });
    test('M002 Fallen Log blocks along its length', () {
      final p = Play(board([up('p1', 3)], [ob('o1', 'M002', [[1, 1], [2, 1], [3, 1]], {'orient': 'H'})]));
      expect(p.tap('p1'), 'no');
    });
    test('M005 Flower Gate lets only its colour through', () {
      final gate = [ob('o1', 'M005', [[2, 1]], {'color': 'red'})];
      expect(Play(board([up('p1', 2)], gate)).tap('p1'), 'no');
      expect(Play(board([up('p1', 2, color: 'red')], gate)).tap('p1'), 'exit');
    });
    test('M029 Hedge Border closes an edge segment', () {
      expect(Play(board([up('p1', 2)], [ob('o1', 'M029', [[2, 0]], {'side': 'U'})])).tap('p1'), 'no');
    });
    test('M030 Flower Arch Exit opens the edge for one colour', () {
      final arch = [ob('o1', 'M030', [[2, 0]], {'side': 'U', 'color': 'red'})];
      expect(Play(board([up('p1', 2)], arch)).tap('p1'), 'no');
      expect(Play(board([up('p1', 2, color: 'red')], arch)).tap('p1'), 'exit');
    });
  });

  group('keys and locks', () {
    test('M003 Frost Coil thaws after k neighbours leave', () {
      final p = Play(board([up('p1', 2), sn('p2', 'R', [[3, 3], [3, 4]])], [ob('o1', 'M003', [], {'path': 'p1', 'k': 1})]));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
    test('M004 Bamboo Cage opens when its key snake leaves', () {
      final p = Play(board([up('p1', 2), sn('p2', 'L', [[1, 0], [1, 1]])],
          [ob('o1', 'M004', [[2, 1]], {'keyPath': 'p2', 'color': 'green'})]));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
    test('M043 Big Knot Cage needs every key', () {
      final p = Play(board([up('p1', 2), spare('p2', 4), spare('p3', 2)],
          [ob('o1', 'M043', [[2, 1]], {'keyPaths': ['p2', 'p3']})]));
      expect(p.taps(['p1', 'p2', 'p1', 'p3', 'p1']), ['no', 'exit', 'no', 'exit', 'exit']);
    });
    test('M046 Tail-Biter Loop opens after its key leaves', () {
      final p = Play(board([sn('p1', 'U', [[1, 1], [2, 1], [2, 2], [1, 2]]), spare('p2')],
          [ob('o1', 'M046', [], {'path': 'p1', 'keyPath': 'p2', 'head': [1, 1], 'dir': 'U'})]));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
    test('M033 Petal Cage opens when no snake of its colour is left', () {
      final p = Play(board([up('p1', 2), sn('p2', 'L', [[0, 0], [1, 0]], color: 'pink')],
          [ob('o1', 'M033', [], {'path': 'p1', 'color': 'pink'})]));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
    test('M028 Hatch Order snakes leave in number order', () {
      final p = Play(board([up('p1', 2), up('p2', 3)], [ob('o1', 'M028', [], {'order': ['p2', 'p1']})]));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
    test('M049 Grumpy Mongoose vanishes when its linked snakes leave', () {
      final p = Play(board([up('p1', 2), spare('p2')],
          [ob('o1', 'M049', [[2, 0], [3, 0], [2, 1], [3, 1]], {'linked': ['p2']})]));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
  });

  group('counters', () {
    test('M007 Lotus Bud Gate opens after n Moves', () {
      final p = Play(board([up('p1', 2), spare('p2', 4), spare('p3', 2)], [ob('o1', 'M007', [[2, 1]], {'n': 2})]));
      expect(p.taps(['p1', 'p2', 'p1', 'p3', 'p1']), ['no', 'exit', 'no', 'exit', 'exit']);
    });
    test('M016 Termite Mound breaks after a lane passes next to it', () {
      final p = Play(board([up('p1', 2), up('p2', 1)], [ob('o1', 'M016', [[2, 1]], {'hp': 1})]));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
    test('M017 Restless Caterpillar must leave within n Moves', () {
      final raw = board([up('p1', 2), spare('p2', 4), spare('p3', 2)], [ob('o1', 'M017', [], {'path': 'p1', 'n': 2})]);
      expect(Play(raw).taps(['p2', 'p3']), ['exit', 'no']);
      expect(Play(raw).taps(['p2', 'p1', 'p3']), ['exit', 'exit', 'exit']);
    });
    test('M025 Patrolling Beetle blocks where it stands and steps each Move', () {
      final p = Play(board([up('p1', 2), spare('p2', 4), spare('p3', 0)],
          [ob('o1', 'M025', [[1, 1], [2, 1], [2, 2], [1, 2]], {'start': 1})]));
      expect(p.taps(['p1', 'p2', 'p1', 'p3', 'p1']), ['no', 'exit', 'no', 'exit', 'exit']);
    });
    test('M027 Creeping Vine grows every n Moves', () {
      final raw = board([up('p1', 1), sn('p2', 'R', [[4, 4], [3, 4]]), sn('p3', 'R', [[4, 2], [3, 2]])], [ob('o1', 'M027', [[0, 0]], {'n': 2})]);
      expect(Play(raw).taps(['p2', 'p3', 'p1']), ['exit', 'exit', 'no']);
      expect(Play(raw).taps(['p1', 'p2', 'p3']), ['exit', 'exit', 'exit']);
    });
    test('M031 Closing Hedge Gap closes after n Moves', () {
      final raw = board([up('p1', 2), spare('p2')], [ob('o1', 'M031', [[2, 0]], {'side': 'U', 'n': 1})]);
      expect(Play(raw).taps(['p2', 'p1']), ['exit', 'no']);
      expect(Play(raw).taps(['p1', 'p2']), ['exit', 'exit']);
    });
    test('M047 Growing Caterpillar adds a tail cell every n Moves', () {
      final p = Play(board([sn('p1', 'U', [[2, 2], [2, 3]]), spare('p2', 1), spare('p3', 0)],
          [ob('o1', 'M047', [], {'path': 'p1', 'n': 2})]));
      p.taps(['p2', 'p3']);
      expect(p.st.bodies[0].length, 3);
    });
  });

  group('interactive', () {
    test('M009 Branch Lever flips its twig gates (a Move)', () {
      final p = Play(board([up('p1', 2)], [ob('o1', 'M009', [[0, 0]], {'gates': [[2, 1]], 'initial': ['closed']})]));
      expect(p.taps(['p1', 'o1', 'p1']), ['no', 'move', 'exit']);
    });
    test('M013 Spinning Lilypad turns its snake; a tangled turn is not allowed', () {
      final raw = board([sn('p1', 'U', [[2, 2], [2, 3]])], [ob('o1', 'M001', [[2, 0]]), ob('o2', 'M013', [[2, 2]], {'path': 'p1'})]);
      expect(Play(raw).taps(['p1', 'o2', 'p1']), ['no', 'move', 'exit']);
      expect(Play(raw).taps(['o2', 'o2']), ['move', 'no']);
    });
    test('M018 Fern Fork Switch turns lanes and toggles on tap', () {
      final p = Play(board([up('p1', 2)], [ob('o1', 'M018', [[2, 1]], {'state': 'L'}), ob('o2', 'M001', [[0, 1]])]));
      expect(p.taps(['p1', 'o1', 'p1']), ['no', 'move', 'exit']);
    });
    test('M019 Mossy Pressure Stone keeps its gate open while covered', () {
      final raw = board([up('p1', 2), sn('p2', 'U', [[0, 3], [0, 4]])], [ob('o1', 'M019', [[0, 4]], {'gates': [[2, 1]]})]);
      expect(Play(raw).taps(['p1', 'p2']), ['exit', 'exit']);
      expect(Play(raw).taps(['p2', 'p1']), ['exit', 'no']);
    });
    test('M034 Whirl Stump rotates a snake fully inside it', () {
      final p = Play(board([sn('p1', 'L', [[1, 1], [2, 1]])],
          [ob('o1', 'M034', [[1, 1], [2, 1], [1, 2], [2, 2]]), ob('o2', 'M001', [[0, 1]])]));
      expect(p.taps(['p1', 'o1', 'p1']), ['no', 'move', 'exit']);
    });
    test('M045 Root Gear Lever turns its linked lilypads; they have no own tap', () {
      final p = Play(board([sn('p1', 'U', [[2, 2], [2, 3]])], [
        ob('o1', 'M045', [[0, 0]], {'turntables': ['o2']}),
        ob('o2', 'M013', [[2, 2]], {'path': 'p1'}),
        ob('o3', 'M001', [[2, 0]]),
      ]));
      expect(p.taps(['o2', 'p1', 'o1', 'p1']), ['no', 'no', 'move', 'exit']);
    });
  });

  group('direction changers and helpers', () {
    test('M006 Bamboo One-Way passes only along its arrow', () {
      expect(Play(board([up('p1', 2)], [ob('o1', 'M006', [[2, 1]], {'arrow': 'U'})])).tap('p1'), 'exit');
      expect(Play(board([up('p1', 2)], [ob('o1', 'M006', [[2, 1]], {'arrow': 'D'})])).tap('p1'), 'no');
    });
    test('M008 Rabbit Burrows carry a lane to the partner hole', () {
      final p = Play(board([sn('p1', 'R', [[0, 2], [0, 3]]), sn('p2', 'D', [[4, 1], [4, 0]])],
          [ob('o1', 'M008', [[1, 2], [3, 0]], {'pair': 'carrot'})]));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
    test('M014 Mushroom Bumper turns a lane 90°', () {
      final p = Play(board([up('p1', 2), sn('p2', 'D', [[4, 1], [4, 0]])], [ob('o1', 'M014', [[2, 0]], {'orient': '/'})]));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
    test('M015 Root Bridge lets a crossing lane pass under a body', () {
      Map<String, dynamic> raw(String axis) => board([up('p1', 2), sn('p2', 'R', [[3, 1], [2, 1], [1, 1]])],
          [ob('o1', 'M015', [[2, 1]], {'axis': axis})]);
      expect(Play(raw('H')).tap('p1'), 'exit');
      expect(Play(raw('V')).tap('p1'), 'no');
    });
    test('M020 Home Burrow is an exit inside the board', () {
      expect(Play(board([up('p1', 2)], [ob('o1', 'M020', [[2, 1]]), ob('o2', 'M001', [[2, 0]])])).tap('p1'), 'exit');
    });
    test('M026 Jungle Gems must all be collected to win', () {
      final hit = Play(board([up('p1', 2)], [ob('o1', 'M026', [[2, 1]])]))..tap('p1');
      expect(hit.won, isTrue);
      final miss = Play(board([up('p1', 2)], [ob('o1', 'M026', [[0, 0]])]))..tap('p1');
      expect(miss.won, isFalse);
    });
    test('M036 Hungry Caterpillar leaves only through food', () {
      expect(Play(board([up('p1', 2)], [ob('o1', 'M036', [[2, 1]], {'path': 'p1'})])).tap('p1'), 'exit');
      expect(Play(board([up('p1', 2)], [ob('o1', 'M036', [[0, 0]], {'path': 'p1'})])).tap('p1'), 'no');
    });
    test('M037 Sticky Swamp Mud stops a snake for one Move', () {
      expect(Play(board([up('p1', 2)], [ob('o1', 'M037', [[2, 1]])])).taps(['p1', 'p1']), ['move', 'exit']);
    });
    test('M038 Bouncy Fern Pad jumps a one-cell blocker, never a snake', () {
      expect(Play(board([up('p1', 2)], [ob('o1', 'M038', [[2, 2]]), ob('o2', 'M001', [[2, 1]])])).tap('p1'), 'exit');
      expect(Play(board([up('p1', 2), sn('p2', 'R', [[2, 1], [1, 1]])], [ob('o1', 'M038', [[2, 2]])])).tap('p1'), 'no');
    });
    test('M040 Jungle Night changes no rule', () {
      expect(Play(board([up('p1', 2)], [ob('o1', 'M040', [], {'radius': 2})])).tap('p1'), 'exit');
    });
    test('M042 Dry Twig Bridge breaks after one crossing', () {
      final raw = board([up('p1', 2), sn('p2', 'R', [[0, 1], [0, 0]])], [ob('o1', 'M042', [[2, 1]], {'axis': 'H'})]);
      expect(Play(raw).taps(['p1', 'p2']), ['exit', 'no']);
      expect(Play(raw).taps(['p2', 'p1']), ['exit', 'no']);
    });
    test('M044 Twisty Burrow turns the lane on the way out', () {
      final raw = board([sn('p1', 'R', [[0, 2], [0, 3]])], [ob('o1', 'M044', [[1, 2], [3, 0]], {'pair': 'spiral', 'rot': ['CW', 'CW']})]);
      expect(Play(raw).tap('p1'), 'exit');
      final blocked = Map<String, dynamic>.of(raw)..['mechanics'] = [...raw['mechanics'] as List, ob('o2', 'M001', [[3, 2]])];
      expect(Play(blocked).tap('p1'), 'no');
    });
  });

  group('snake variants', () {
    test('M010 Jungle Mist hides snakes until a touching snake leaves', () {
      final p = Play(board([sn('p1', 'U', [[4, 3], [4, 4]]), sn('p2', 'L', [[1, 4], [2, 4]])],
          [ob('o1', 'M010', [[3, 3], [4, 3], [3, 4], [4, 4]])]));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
    test('M011 Vine-Tied Twins leave together or not at all', () {
      final twins = ob('o1', 'M011', [], {'paths': ['p1', 'p2']});
      final free = Play(board([up('p1', 0), up('p2', 2)], [twins]));
      expect(free.tap('p1'), 'exit');
      expect(free.won, isTrue);
      expect(Play(board([up('p1', 0), up('p2', 2)], [twins, ob('o2', 'M001', [[2, 0]])])).tap('p1'), 'no');
    });
    test('M012 Sleepy Python wakes on the first tap', () {
      expect(Play(board([up('p1', 2)], [ob('o1', 'M012', [], {'path': 'p1'})])).taps(['p1', 'p1']), ['move', 'exit']);
    });
    test('M021 Phantom Snake is a ghost on odd Moves', () {
      final p = Play(board([up('p1', 2), sn('p2', 'R', [[3, 1], [2, 1]]), spare('p3')], [ob('o1', 'M021', [], {'path': 'p2'})]));
      expect(p.taps(['p1', 'p3', 'p2', 'p1', 'p2']), ['no', 'exit', 'no', 'exit', 'exit']);
    });
    test('M022 Reverse Slither leaves tail first', () {
      final p = Play(board([sn('p1', 'U', [[2, 1], [2, 2], [2, 3]]), sn('p2', 'L', [[1, 4], [2, 4]])],
          [ob('o1', 'M022', [], {'path': 'p1'}), ob('o2', 'M001', [[2, 0]])]));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
    test('M023 Two-Headed Hydra: a bare id leaves by body[0]', () {
      final raw = board([sn('p1', 'L', [[1, 2], [2, 2], [3, 2], [4, 2]])], [ob('o1', 'M023', [], {'path': 'p1'})]);
      expect(Play(raw).tap('p1'), 'exit');
    });
    test('M024 Giant Anaconda needs a two-wide lane', () {
      final raw = board([sn('p1', 'U', [[2, 2], [2, 3]])], [ob('o1', 'M024', [], {'path': 'p1', 'side': 'R'})]);
      expect(Play(raw).tap('p1'), 'exit');
      final blocked = Map<String, dynamic>.of(raw)..['mechanics'] = [...raw['mechanics'] as List, ob('o2', 'M001', [[3, 0]])];
      expect(Play(blocked).tap('p1'), 'no');
    });
    test('M032 Canopy snakes lock the ground snakes they cover', () {
      final p = Play(board([up('p1', 2), sn('p2', 'R', [[3, 3], [2, 3]], layer: 1)], [ob('o1', 'M032', [], {'obstacleLayer': 'both'})], 2));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
    test('M035 Mama Snake leaves a baby that must also leave', () {
      final p = Play(board([up('p1', 1)], [
        ob('o1', 'M035', [[3, 3], [3, 4]], {'path': 'p1', 'child': {'id': 'p1c', 'color': 'green', 'dir': 'U', 'body': [[3, 3], [3, 4]]}}),
      ]));
      expect(p.tap('p1'), 'exit');
      expect(p.won, isFalse);
      expect(p.tap('p1c'), 'exit');
      expect(p.won, isTrue);
    });
    test('M039 Pond Twins move as a mirrored pair', () {
      final twins = ob('o1', 'M039', [], {'paths': ['p1', 'p2'], 'axis': 'V'});
      final paths = [sn('p1', 'L', [[1, 2], [1, 3]]), sn('p2', 'R', [[3, 2], [3, 3]])];
      expect(Play(board(paths, [twins])).tap('p1'), 'exit');
      expect(Play(board(paths, [twins, ob('o2', 'M001', [[4, 2]])])).tap('p1'), 'no');
    });
    test('M041 Chameleon Snake changes colour every Move', () {
      final p = Play(board([up('p1', 2, color: 'red'), spare('p2')], [
        ob('o1', 'M041', [], {'path': 'p1', 'cycle': ['red', 'green', 'blue'], 'start': 0}),
        ob('o2', 'M005', [[2, 1]], {'color': 'green'}),
      ]));
      expect(p.taps(['p1', 'p2', 'p1']), ['no', 'exit', 'exit']);
    });
    test('M048 Snake Parade members leave together', () {
      final parade = ob('o1', 'M048', [], {'color': 'red', 'paths': ['p1', 'p2']});
      final p = Play(board([up('p1', 0, color: 'red'), up('p2', 2, color: 'red')], [parade]));
      expect(p.tap('p2'), 'exit');
      expect(p.won, isTrue);
    });
  });

  group('RulesCheck', () {
    Map<String, dynamic> level(List<String> solution, double d) => {
          ...board([up('p1', 2), sn('p2', 'L', [[1, 0], [1, 1]])], [ob('o1', 'M004', [[2, 1]], {'keyPath': 'p2', 'color': 'green'})]),
          'solution': solution,
          'difficulty': d,
        };
    test('accepts a winning solution with the right D', () {
      expect(RulesCheck.check(level(['p2', 'p1'], 3.2)), isEmpty);
    });
    test('rejects a solution that bonks', () {
      expect(RulesCheck.check(level(['p1', 'p2'], 3.2)), contains(startsWith('solution does not win')));
    });
    test('rejects a wrong stated D', () {
      expect(RulesCheck.check(level(['p2', 'p1'], 9.9)), contains(startsWith('"difficulty" says 9.9')));
    });
    test('rejects banned combinations', () {
      final raw = {
        ...board([up('p1', 2)], [ob('o1', 'M010', [[0, 0]]), ob('o2', 'M040', [], {'radius': 2})]),
        'solution': ['p1'],
      };
      expect(RulesCheck.check(raw), contains('Jungle Mist + Jungle Night on one board'));
    });
  });
}

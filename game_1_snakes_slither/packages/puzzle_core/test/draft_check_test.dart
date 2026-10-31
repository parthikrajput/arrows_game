import 'package:puzzle_core/puzzle_core.dart';
import 'package:test/test.dart';

/// A block-3 draft (L21 intro, M002 Fallen Log): 6x6, 6 free snakes.
Map<String, dynamic> l21({List<Map<String, dynamic>>? mechanics, Map<String, dynamic>? extra}) => {
  'schema': 3,
  'level': 21,
  'phase': 1,
  'slot': 'intro',
  'tag': 'normal',
  'grid': [6, 6],
  'layers': 1,
  'hearts': 3,
  'paths': [
    for (var y = 0; y < 6; y++)
      {
        'id': 'p${y + 1}',
        'color': 'green',
        'dir': 'R',
        'body': [
          [1, y],
          [0, y],
        ],
        'layer': 0,
        'mods': {},
      },
  ],
  'mechanics':
      mechanics ??
      [
        {
          'id': 'o1',
          'type': 'M002',
          'cells': [
            [3, 5],
            [4, 5],
          ],
          'params': {'orient': 'H'},
          'hammerable': true,
        },
      ],
  'goals': {'gems': 0},
  'par_moves': 6,
  'difficulty': 7.0,
  'solution': ['p1', 'p2', 'p3', 'p4', 'p5', 'p6'],
  ...?extra,
};

void main() {
  test('a well-formed draft passes and is marked as waiting for the engine', () {
    expect(LevelDraftCheck.check(l21()), isEmpty);
    expect(LevelCodec.unsupportedMechanics(l21()), {'M002'});
  });

  test('the app stops loading at the first draft level', () {
    expect(
      LevelCodec.decodeFile({
        'levels': [l21()],
      }),
      isEmpty,
    );
  });

  test('wrong hammerable default, bad path ref, locked mechanic are caught', () {
    final p = LevelDraftCheck.check(
      l21(
        mechanics: [
          {
            'id': 'o1',
            'type': 'M002',
            'cells': [
              [3, 5],
            ],
            'params': {},
            'hammerable': false,
          },
          {
            'id': 'o2',
            'type': 'M003',
            'cells': [],
            'params': {'path': 'p9'},
            'hammerable': false,
          },
        ],
      ),
    );
    expect(p, contains('o1: M002 must have "hammerable": true'));
    expect(p, contains('o2: params.path names "p9", which is not a snake'));
    expect(p, contains('o2: M003 is not unlocked until a later block'));
  });

  test('overlaps, off-board cells, par and D band are caught', () {
    final bad = l21(extra: {'par_moves': 4, 'difficulty': 30.0});
    (bad['paths'] as List)[1]['body'] = [
      [1, 0],
      [1, 1],
    ];
    (bad['mechanics'] as List)[0]['cells'] = [
      [9, 9],
    ];
    final p = LevelDraftCheck.check(bad);
    expect(p, contains(contains('p2 overlaps p1')));
    expect(p, contains('o1: cell [9, 9] off the board'));
    expect(p, contains(contains('"par_moves" is 4')));
    expect(p, contains(contains('"difficulty" 30.0 outside')));
  });

  test('block table limits come from the doc (L41 = 6–8 grid, 8–12 snakes, D 9–15)', () {
    final t = LevelTarget.forLevel(41);
    expect((t.minGrid, t.maxGrid, t.minSnakes, t.maxSnakes, t.minD, t.maxD), (6, 8, 8, 12, 9, 15));
    expect(LevelTarget.forLevel(500).minD, 62);
    expect(LevelValidator.dBand(499, LevelSlot.hard).$2, closeTo(52 * 1.1 + 3, 1e-9));
  });
}

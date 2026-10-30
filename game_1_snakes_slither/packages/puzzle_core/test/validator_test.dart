import 'package:puzzle_core/puzzle_core.dart';
import 'package:test/test.dart';

/// Builds a schema v3 level; solution and par are filled in by the solver.
Map<String, dynamic> lv(
  int n,
  String slot,
  String tag,
  int size,
  List<List<Object>> paths, {
  List<List<int>> rocks = const [],
  double? difficulty,
}) {
  final base = {
    'schema': 3,
    'level': n,
    'slot': slot,
    'tag': tag,
    'grid': [size, size],
    'paths': [
      for (final (i, p) in paths.indexed)
        {'id': 'p${i + 1}', 'color': p[0], 'dir': p[1], 'body': p[2], 'layer': 0, 'mods': {}},
    ],
    'mechanics': [
      for (final (i, c) in rocks.indexed)
        {
          'id': 'o${i + 1}',
          'type': 'M001',
          'cells': [c],
          'params': {},
          'hammerable': true,
        },
    ],
  };
  final l = LevelCodec.decode(base);
  final order = Solver.solve(l.board)!;
  final refs = [for (final id in order) l.board.snakes[id]!.ref];
  return {
    ...base,
    'solution': refs,
    'par_moves': refs.length,
    'difficulty': difficulty ?? Difficulty.of(LevelCodec.decode({...base, 'solution': refs})).d,
  };
}

List<String> problems(Map<String, dynamic> j) =>
    LevelValidator.check(LevelCodec.decode(j)).problems;

final l1 = lv(1, 'intro', 'normal', 4, [
  [
    'green',
    'R',
    [
      [2, 1],
      [1, 1],
      [0, 1],
    ],
  ],
  [
    'yellow',
    'D',
    [
      [1, 3],
      [1, 2],
    ],
  ],
]);

void main() {
  test('D matches the doc examples (L1 = 1.2, L2 = 3.3)', () {
    expect(Difficulty.of(LevelCodec.decode(l1)).d, 1.2);
    final l2 = lv(2, 'practice', 'normal', 4, [
      [
        'red',
        'R',
        [
          [1, 0],
          [0, 0],
        ],
      ],
      [
        'blue',
        'D',
        [
          [3, 1],
          [3, 0],
        ],
      ],
      [
        'purple',
        'R',
        [
          [1, 3],
          [0, 3],
        ],
      ],
    ]);
    final d = Difficulty.of(LevelCodec.decode(l2));
    expect((d.p, d.c, d.d), (3, 1, 3.3));
  });

  test('a valid FTUE level passes', () => expect(problems(l1), isEmpty));

  test('slot/tag must follow the level number', () {
    expect(LevelTarget.slotFor(11), LevelSlot.intro);
    expect(LevelTarget.slotFor(15), LevelSlot.breather);
    expect(LevelTarget.slotFor(9), LevelSlot.ramp);
    expect(LevelTarget.slotFor(19), LevelSlot.hard);
    expect(LevelTarget.slotFor(20), LevelSlot.milestone);
    expect(problems({...l1, 'slot': 'practice'}), contains(startsWith('slot is "practice"')));
    expect(problems({...l1, 'tag': 'easy'}), contains(startsWith('tag is "easy"')));
  });

  test('wrong difficulty, par or solution is reported', () {
    expect(problems({...l1, 'difficulty': 2.0}), contains(contains('computed 1.2')));
    expect(problems({...l1, 'par_moves': 5}), contains(contains('"par_moves" is 5')));
    expect(
      problems({
        ...l1,
        'solution': ['p1'],
      }),
      contains(contains('leaves 1 snake')),
    );
  });

  test('FTUE size and obstacle limits', () {
    final big = lv(
      1,
      'intro',
      'normal',
      6,
      [
        [
          'green',
          'R',
          [
            [2, 1],
            [1, 1],
          ],
        ],
        [
          'blue',
          'D',
          [
            [1, 3],
            [1, 2],
          ],
        ],
      ],
      rocks: [
        [5, 5],
      ],
    );
    final p = problems(big);
    expect(p, contains(startsWith('grid 6x6')));
    expect(p, contains('FTUE levels must have no obstacles'));
  });

  test('block 2 needs Garden Rock; intro uses 1–2', () {
    // 7x7: six free snakes in rows 0–5, rocks only on row 6 (no lane passes it).
    final six = [
      for (var y = 0; y < 6; y++)
        <Object>[
          'green',
          'R',
          [
            [1, y],
            [0, y],
          ],
        ],
    ];
    expect(
      problems(lv(11, 'intro', 'normal', 7, six)),
      contains('every level in this block needs at least 1 M001'),
    );
    expect(
      problems(
        lv(
          11,
          'intro',
          'normal',
          7,
          six,
          rocks: [
            [3, 6],
          ],
        ),
      ),
      isEmpty,
    );
    expect(
      problems(
        lv(
          11,
          'intro',
          'normal',
          7,
          six,
          rocks: [
            [2, 6],
            [3, 6],
            [4, 6],
          ],
        ),
      ),
      contains(contains('must appear 1–2 times')),
    );
  });

  test('unsupported mechanics are rejected on load', () {
    expect(
      () => LevelCodec.decode({
        ...l1,
        'mechanics': [
          {
            'id': 'o1',
            'type': 'M002',
            'cells': [
              [3, 3],
            ],
            'params': {},
            'hammerable': true,
          },
        ],
      }),
      throwsA(isA<LevelFormatException>().having((e) => e.message, 'message', contains('M002'))),
    );
  });
}

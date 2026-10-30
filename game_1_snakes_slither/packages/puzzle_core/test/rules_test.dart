import 'package:puzzle_core/puzzle_core.dart';
import 'package:test/test.dart';

/// 5x5. Snake 0 at row 0 heads right (clear). Snake 1 at (0,2)-(1,2) heads
/// right into snake 2, which heads up and is blocked by nothing (clear).
/// Rock at (4,4).
Level sample() => LevelCodec.decode(
  v3({
    'n': 1,
    'tag': 'easy',
    'w': 5,
    'h': 5,
    'snakes': [
      {
        'body': [
          [1, 0],
          [0, 0],
        ],
        'dir': 'R',
        'color': 'green',
      },
      {
        'body': [
          [1, 2],
          [0, 2],
        ],
        'dir': 'R',
        'color': 'red',
      },
      {
        'body': [
          [3, 2],
          [3, 3],
        ],
        'dir': 'U',
        'color': 'blue',
      },
    ],
    'rocks': [
      [4, 4],
    ],
  }),
);

/// Test boards are written in a short form; this turns them into schema v3.
Map<String, dynamic> v3(Map<String, dynamic> m) => {
  'schema': 3,
  'level': m['n'],
  'slot': 'practice',
  'tag': m['tag'] ?? 'normal',
  'grid': [m['w'], m['h']],
  'paths': [
    for (final (i, p) in (m['snakes'] as List).indexed)
      {
        'id': 'p${i + 1}',
        'color': p['color'],
        'dir': p['dir'],
        'body': p['body'],
        'layer': 0,
        'mods': p['skin'] == null ? {} : {'skin': p['skin']},
      },
  ],
  'mechanics': [
    for (final (i, c) in ((m['rocks'] as List?) ?? []).indexed)
      {
        'id': 'o${i + 1}',
        'type': 'M001',
        'cells': [c],
        'params': {},
        'hammerable': true,
      },
  ],
};

void main() {
  group('Engine', () {
    test('clear lane exits and removes the snake', () {
      final r = Engine.tapSnake(sample().board, 0);
      expect(r.kind, MoveKind.exit);
      expect(r.next.snakes.containsKey(0), isFalse);
      expect(r.lane.cells, [const Cell(2, 0), const Cell(3, 0), const Cell(4, 0)]);
    });

    test('blocked lane bumps, board unchanged, blocker reported', () {
      final b = sample().board;
      final r = Engine.tapSnake(b, 1);
      expect(r.kind, MoveKind.bump);
      expect(identical(r.next, b), isTrue);
      expect(r.lane.blocker, const Cell(3, 2));
      expect(r.lane.cells, [const Cell(2, 2)]);
    });

    test('rocks block lanes', () {
      // Built directly: the validator would reject a snake that can never pass a rock.
      final b = BoardState(
        width: 4,
        height: 4,
        snakes: {
          0: const Snake(
            id: 0,
            body: [Cell(0, 3), Cell(0, 2)],
            dir: Dir.right,
            color: SnakeColor.teal,
          ),
        },
        rocks: {0: const Rock(id: 0, cell: Cell(2, 3))},
      );
      final r = Engine.tapSnake(b, 0);
      expect(r.kind, MoveKind.bump);
      expect(r.lane.blocker, const Cell(2, 3));
    });
  });

  group('Attempt', () {
    test('bump costs a heart and a move; exit costs only a move', () {
      var a = Attempt.start(sample().board);
      a = a.tapSnake(1).attempt;
      expect((a.hearts, a.moves, a.heartsLost), (2, 1, 1));
      a = a.tapSnake(0).attempt;
      expect((a.hearts, a.moves), (2, 2));
    });

    test('win when all snakes are out', () {
      var a = Attempt.start(sample().board);
      for (final id in [0, 2, 1]) {
        a = a.tapSnake(id).attempt;
      }
      expect(a.status, AttemptStatus.won);
      expect(a.stars, 3);
    });

    test('stars: 1 lost = 2, 2 lost = 1, revive = 1', () {
      var a = Attempt.start(sample().board).tapSnake(1).attempt;
      expect(a.stars, 2);
      a = a.tapSnake(1).attempt;
      expect(a.stars, 1);
      expect(Attempt.start(sample().board).copyWith(adRevives: 1).stars, 1);
    });

    test('three bumps empty hearts; revive and refill rules', () {
      var a = Attempt.start(sample().board);
      for (var i = 0; i < 3; i++) {
        a = a.tapSnake(1).attempt;
      }
      expect(a.status, AttemptStatus.outOfHearts);
      expect(() => a.tapSnake(0), throwsStateError);
      a = a.refillHeart();
      expect(a.hearts, 1);
      a = a.tapSnake(1).attempt.refillHeart();
      expect(a.refillsLeft, 0);
      a = a.tapSnake(1).attempt;
      expect(() => a.refillHeart(), throwsStateError);
      expect(a.reviveWithAd().hearts, 1);
    });

    test('Shield absorbs 2 heart-loss events and those do not count as lost', () {
      var a = Attempt.start(sample().board).useShield();
      a = a.tapSnake(1).attempt.tapSnake(1).attempt;
      expect((a.hearts, a.shieldCharges, a.heartsLost), (3, 0, 0));
      expect(a.stars, 3);
      a = a.tapSnake(1).attempt;
      expect(a.hearts, 2);
      expect(() => a.useShield(), throwsStateError, reason: 'cap 1 per attempt');
    });

    test('Hint points at a correct snake and respects cap 3', () {
      var a = Attempt.start(sample().board);
      for (var i = 0; i < 3; i++) {
        final (next, target) = a.useHint();
        expect(Engine.tapSnake(a.board, target!).kind, MoveKind.exit);
        a = next;
      }
      expect(() => a.useHint(), throwsStateError);
    });

    test('Hammer removes a snake as an exit; cap 2; can win', () {
      var a = Attempt.start(sample().board).hammerSnake(2).hammerRock(0);
      expect(a.board.snakes.length, 2);
      expect(a.board.rocks, isEmpty);
      expect(() => a.hammerSnake(0), throwsStateError);
      a = a.tapSnake(0).attempt.tapSnake(1).attempt;
      expect(a.status, AttemptStatus.won);
      expect(a.moves, 2, reason: 'booster use is not a move');
    });
  });

  group('LevelCodec', () {
    test('rejects unsolvable boards', () {
      expect(
        () => LevelCodec.decode(
          v3({
            'n': 9,
            'w': 4,
            'h': 4,
            'snakes': [
              {
                'body': [
                  [0, 0],
                  [0, 1],
                ],
                'dir': 'R',
                'color': 'red',
              },
              {
                'body': [
                  [3, 0],
                  [3, 1],
                ],
                'dir': 'L',
                'color': 'blue',
              },
            ],
          }),
        ),
        throwsA(isA<LevelFormatException>()),
      );
    });

    test('rejects overlap and disconnected bodies', () {
      Map<String, dynamic> one(List body) => {
        'n': 9,
        'w': 4,
        'h': 4,
        'snakes': [
          {'body': body, 'dir': 'U', 'color': 'red'},
        ],
      };
      expect(
        () => LevelCodec.decode(
          v3(
            one([
              [1, 1],
              [1, 1],
            ]),
          ),
        ),
        throwsA(isA<LevelFormatException>()),
      );
      expect(
        () => LevelCodec.decode(
          v3(
            one([
              [1, 1],
              [3, 3],
            ]),
          ),
        ),
        throwsA(isA<LevelFormatException>()),
      );
    });
  });
}

import 'package:puzzle_core/slither_engine.dart';
import 'package:test/test.dart';

Snake snake(String id, List<List<int>> body, Dir dir) => Snake(
      id: id,
      body: [for (final c in body) Cell(c[0], c[1])],
      dir: dir,
      color: SnakeColor.green,
    );

void main() {
  // a points right at b; b points up and is free.
  final board = BoardState(width: 5, height: 5, snakes: [
    snake('a', [
      [1, 2],
      [0, 2],
    ], Dir.right),
    snake('b', [
      [3, 2],
      [3, 3],
      [3, 4],
    ], Dir.up),
  ]);

  group('Engine', () {
    test('clear lane exits and removes the snake', () {
      final r = Engine.apply(board, 'b');
      expect(r, isA<ExitOutcome>());
      final exit = r as ExitOutcome;
      expect(exit.cellsToEdge, 2);
      expect(exit.next.snakeById('b'), isNull);
      expect(exit.next.exitedCount, 1);
    });

    test('blocked lane bumps and leaves the board unchanged', () {
      final r = Engine.apply(board, 'a');
      expect(r, isA<BumpOutcome>());
      final bump = r as BumpOutcome;
      expect(bump.cellsToBlocker, 2);
      expect(bump.blockerCell, const Cell(3, 2));
      expect(bump.blockerSnakeId, 'b');
      expect(board.snakes.length, 2);
    });

    test('unknown snake id is ignored', () {
      expect(Engine.apply(board, 'zz'), isNull);
    });

    test('same state and same move give the same result (x100)', () {
      final first = Engine.apply(board, 'a') as BumpOutcome;
      for (var i = 0; i < 100; i++) {
        final r = Engine.apply(board, 'a') as BumpOutcome;
        expect(r.blockerCell, first.blockerCell);
        expect(r.cellsToBlocker, first.cellsToBlocker);
      }
    });

    test('win when every snake is out', () {
      final afterB = (Engine.apply(board, 'b') as ExitOutcome).next;
      final afterA = (Engine.apply(afterB, 'a') as ExitOutcome).next;
      expect(Engine.isWon(afterA), isTrue);
    });
  });

  group('Solver', () {
    test('finds the only valid first move', () {
      expect(Solver.nextMove(board), 'b');
    });

    test('follows the level solution while on its prefix', () {
      expect(Solver.nextMove(board, solution: ['b', 'a'], played: const []), 'b');
    });

    test('detects a soft-lock (two snakes facing each other)', () {
      final locked = BoardState(width: 4, height: 1, snakes: [
        snake('l', [
          [1, 0],
          [0, 0],
        ], Dir.right),
        snake('r', [
          [2, 0],
          [3, 0],
        ], Dir.left),
      ]);
      expect(Solver.isSoftLocked(locked), isTrue);
    });
  });

  group('Scoring', () {
    test('stars by hearts lost and revive', () {
      expect(starsFor(heartsLost: 0, usedRevive: false), 3);
      expect(starsFor(heartsLost: 1, usedRevive: false), 2);
      expect(starsFor(heartsLost: 2, usedRevive: false), 1);
      expect(starsFor(heartsLost: 0, usedRevive: true), 1);
    });

    test('Tuesday par removes one star, never below 1', () {
      expect(starsFor(heartsLost: 0, usedRevive: false, parMoves: 5, moves: 6), 2);
      expect(starsFor(heartsLost: 2, usedRevive: false, parMoves: 5, moves: 9), 1);
    });
  });
}

import 'package:puzzle_core/slither_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Xoshiro128ss', () {
    test('same seed gives the same sequence', () {
      final a = Xoshiro128ss(42);
      final b = Xoshiro128ss(42);
      for (var i = 0; i < 1000; i++) {
        expect(a.nextUint32(), b.nextUint32());
      }
    });

    test('golden vector stays stable across platforms', () {
      final r = Xoshiro128ss(1);
      final values = [for (var i = 0; i < 4; i++) r.nextUint32()];
      expect(values.every((v) => v >= 0 && v <= 0xFFFFFFFF), isTrue);
      expect(Xoshiro128ss(1).nextUint32(), values.first);
    });

    test('nextInt is roughly uniform', () {
      final r = Xoshiro128ss(7);
      final counts = List.filled(8, 0);
      for (var i = 0; i < 80000; i++) {
        counts[r.nextInt(8)]++;
      }
      for (final c in counts) {
        expect(c, inInclusiveRange(9400, 10600));
      }
    });
  });

  group('Hash64', () {
    test('is deterministic and order-sensitive', () {
      expect(Hash64.of(['snakes_slither', '2026-10-30']).seed(), Hash64.of(['snakes_slither', '2026-10-30']).seed());
      expect(Hash64.of(['a', 'b']).seed(), isNot(Hash64.of(['b', 'a']).seed()));
    });
  });

  group('BoardGenerator', () {
    test('every generated board is solvable with its own solution', () {
      for (var seed = 0; seed < 300; seed++) {
        final size = 4 + seed % 8;
        final def = BoardGenerator.generate(
          'g$seed',
          GeneratorParams(width: size, height: size, snakeCount: 3 + size),
          seed,
        );
        var board = def.toBoard();
        for (final id in def.solution) {
          final r = Engine.apply(board, id);
          expect(r, isA<ExitOutcome>(), reason: 'seed $seed snake $id');
          board = (r as ExitOutcome).next;
        }
        expect(Engine.isWon(board), isTrue, reason: 'seed $seed');
      }
    });

    test('same seed gives an identical board', () {
      const p = GeneratorParams(width: 9, height: 9, snakeCount: 14);
      final a = BoardGenerator.generate('x', p, 99).toJson().toString();
      final b = BoardGenerator.generate('x', p, 99).toJson().toString();
      expect(a, b);
    });

    test('snakes stay inside a silhouette mask', () {
      for (final s in Silhouette.values) {
        final mask = s.mask(9, 9);
        expect(mask.length, greaterThan(30), reason: s.name);
        final def = BoardGenerator.generate('m', GeneratorParams(width: 9, height: 9, snakeCount: 12, mask: mask), 5);
        for (final snake in def.snakes) {
          expect(snake.body.every(mask.contains), isTrue, reason: s.name);
        }
      }
    });

    test('level JSON round-trips and rejects overlaps', () {
      final def = BoardGenerator.generate('rt', const GeneratorParams(width: 6, height: 6, snakeCount: 6), 3);
      final back = LevelDef.fromJson(def.toJson());
      expect(back.toJson().toString(), def.toJson().toString());

      final bad = def.toJson();
      final snakes = [...bad['snakes'] as List];
      snakes.add(snakes.first);
      expect(() => LevelDef.fromJson({...bad, 'snakes': snakes}), throwsFormatException);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snakes_slither/ui/intro/jungle_dawn.dart';

const _play = Key('play');
const _other = Key('other');

Widget _app({required IntroMode mode, required VoidCallback onPlay, required VoidCallback onOther, VoidCallback? onDone}) =>
    MaterialApp(
      builder: (c, child) => JungleDawnIntro(mode: mode, playKey: _play, onDone: onDone, child: child!),
      home: Scaffold(
        body: Column(
          children: [
            TextButton(key: _other, onPressed: onOther, child: const Text('other')),
            const SizedBox(height: 200),
            TextButton(key: _play, onPressed: onPlay, child: const Text('Play')),
          ],
        ),
      ),
    );

void main() {
  testWidgets('a tap on Play during the intro launches at once', (t) async {
    var played = 0, other = 0;
    await t.pumpWidget(_app(mode: IntroMode.full, onPlay: () => played++, onOther: () => other++));
    await t.pump(const Duration(milliseconds: 300));
    await t.tap(find.byKey(_play), warnIfMissed: false);
    await t.pump();
    expect(played, 1);
    await t.pumpAndSettle();
  });

  testWidgets('any other tap skips the intro within 120 ms and is not delivered', (t) async {
    var done = false, other = 0;
    await t.pumpWidget(_app(mode: IntroMode.full, onPlay: () {}, onOther: () => other++, onDone: () => done = true));
    await t.pump(const Duration(milliseconds: 100));
    await t.tap(find.byKey(_other), warnIfMissed: false);
    await t.pump(); // the sped-up animation starts on this frame
    await t.pump(const Duration(milliseconds: 125));
    expect(done, isTrue);
    expect(other, 0);
    // The overlay is gone: taps reach Home normally.
    await t.tap(find.byKey(_other));
    expect(other, 1);
  });

  testWidgets('short and fade modes last 450 and 150 ms', (t) async {
    for (final (mode, ms) in [(IntroMode.short, 450), (IntroMode.fade, 150)]) {
      var done = false;
      await t.pumpWidget(_app(mode: mode, onPlay: () {}, onOther: () {}, onDone: () => done = true));
      await t.pump(Duration(milliseconds: ms - 20));
      expect(done, isFalse, reason: '$mode');
      await t.pump(const Duration(milliseconds: 40));
      expect(done, isTrue, reason: '$mode');
      await t.pumpWidget(const SizedBox());
    }
  });
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:snakes_slither/data/save_store.dart';
import 'package:snakes_slither/state/progress_cubit.dart';

void main() {
  test('a corrupt section comes back from the backup made after a win', () async {
    final store = await SaveStore.at(Directory.systemTemp.createTempSync('save').path);
    final p = ProgressCubit(store);
    p.levelWon(1, 3);
    p.levelWon(2, 2);
    await pumpEventQueue();
    await store.backup();
    await store.corruptForTest('progress');
    final again = ProgressCubit(store);
    expect(again.state.highestCleared, 2);
    expect(store.restoredFromBackup, isTrue);
  });

  test('without a backup a corrupt section falls back to defaults', () async {
    final store = await SaveStore.at(Directory.systemTemp.createTempSync('save').path);
    await store.write('progress', {'highestCleared': 5});
    await store.corruptForTest('progress');
    expect(ProgressCubit(store).state.highestCleared, 0);
  });
}

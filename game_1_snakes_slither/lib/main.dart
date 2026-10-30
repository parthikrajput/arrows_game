import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'data/save_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Phones are portrait-only; tablets may rotate (decided per device later).
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final store = await SaveStore.open();
  runApp(SnakesSlitherApp(store: store));
}

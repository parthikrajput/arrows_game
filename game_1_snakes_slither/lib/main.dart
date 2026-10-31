import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puzzle_core/puzzle_core.dart';

import 'app/app.dart';
import 'data/level_repository.dart';
import 'data/save_store.dart';
import 'logging/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global Flutter framework error handling
  FlutterError.onError = (details) {
    AppLogger.instance.error(
      'ui',
      LogCodes.uiFlutterError,
      details.exceptionAsString(),
      {'stack': details.stack?.toString()},
    );
    FlutterError.presentError(details);
  };

  // Root platform uncaught error handling
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.instance.fatal(
      'game',
      LogCodes.uncaughtException,
      error.toString(),
      {'stack': stack.toString()},
    );
    return true;
  };

  // Phones are portrait-only; tablets may rotate (decided per device later).
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final store = await SaveStore.open();
  final levels = await LevelRepository.loadAsset();
  runApp(SnakesSlitherApp(store: store, levels: levels));
}

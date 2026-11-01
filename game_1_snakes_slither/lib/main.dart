import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puzzle_core/puzzle_core.dart';

import 'app/app.dart';
import 'data/level_repository.dart';
import 'data/save_store.dart';
import 'logging/app_logger.dart';
import 'services/perf/perf.dart';

/// [args] come from the Android host, which starts Dart before the activity
/// exists (device tier, process start time).
Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final launch = LaunchInfo.parse(args);

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

  // Phones are portrait-only; tablets may rotate.
  final shortest = PlatformDispatcher.instance.views.first.physicalSize.shortestSide /
      PlatformDispatcher.instance.views.first.devicePixelRatio;
  await SystemChrome.setPreferredOrientations(
    shortest >= 600 ? DeviceOrientation.values : [DeviceOrientation.portraitUp],
  );
  final store = await SaveStore.open();
  final perf = PerfSettings(store, detected: launch.tier);
  PaintingBinding.instance.imageCache.maximumSizeBytes =
      QualityProfile.of(perf.tier).imageCacheMb * 1024 * 1024;
  final levels = await LevelRepository.loadAsset();
  runApp(SnakesSlitherApp(store: store, levels: levels, perf: perf));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    LaunchInfo.reportFirstFrame();
    launch.checkColdStart(perf.tier);
  });
}

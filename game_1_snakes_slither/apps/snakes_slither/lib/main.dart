import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/app.dart';
import 'app/services.dart';
import 'core/logging/app_logger.dart';
import 'data/levels/level_repository.dart';
import 'data/save/save_repository.dart';
import 'services/ads_service.dart';
import 'services/analytics.dart';
import 'services/audio_service.dart';
import 'services/haptics.dart';
import 'services/store_service.dart';
import 'services/time_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (d) {
    log.e('fatal', 'FlutterError', d.exception, d.stack);
    FlutterError.presentError(d);
  };
  PlatformDispatcher.instance.onError = (e, st) {
    log.e('fatal', 'Uncaught', e, st);
    return true;
  };

  // Phones are portrait-only; tablets (shortest side ≥ 600 dp) may rotate.
  final view = PlatformDispatcher.instance.views.first;
  final shortest = view.physicalSize.shortestSide / view.devicePixelRatio;
  if (shortest < 600) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  GoogleFonts.config.allowRuntimeFetching = true;

  final save = SaveRepository(await HiveSaveStore.open());
  final navigatorKey = GlobalKey<NavigatorState>();
  final time = TimeService(save);
  final audio = AudioService();
  final services = AppServices(
    navigatorKey: navigatorKey,
    save: save,
    time: time,
    audio: audio,
    haptics: Haptics(),
    analytics: Analytics(),
    ads: SimulatedAdsService(navigatorKey),
    store: SimulatedStoreService(navigatorKey),
    levels: LevelRepository(),
  );
  runApp(SnakesSlitherApp(services: services));

  // Nothing below blocks the first frame.
  unawaited(time.touch());
  unawaited(audio.init());
}

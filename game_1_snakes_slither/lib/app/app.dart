import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_core/puzzle_core.dart' show LogCodes;

import '../contracts/ui_feedback.dart';
import '../contracts/view_models.dart';
import '../data/level_repository.dart';
import '../data/save_store.dart';
import '../logging/app_logger.dart';
import '../logging/tap_logger.dart';
import '../services/ads_service.dart';
import '../services/analytics.dart';
import '../services/audio_service.dart';
import '../services/games_service.dart';
import '../services/perf/perf.dart';
import '../services/store_service.dart';
import '../services/time_guard.dart';
import '../state/ads_cubit.dart';
import '../services/admob_service.dart';
import '../state/compliance_cubit.dart';
import '../state/daily_cubit.dart';
import '../state/iap_cubit.dart';
import '../state/progress_cubit.dart';
import '../state/settings_cubit.dart';
import '../state/shop_cubit.dart';
import '../state/streak_cubit.dart';
import '../state/tutorial_cubit.dart';
import '../state/wallet_cubit.dart';
import '../state/wheel_cubit.dart';
import '../contracts/app_keys.dart';
import '../ui/intro/jungle_dawn.dart';
import '../ui/theme/tokens.dart';
import 'router.dart';

class SnakesSlitherApp extends StatefulWidget {
  const SnakesSlitherApp({
    super.key,
    required this.store,
    required this.levels,
    this.ads,
    this.clock,
    this.audio,
    this.analytics,
    this.storeService,
    this.verifier,
    this.games,
    this.perf,
  });
  final SaveStore store;
  final LevelRepository levels;
  final AdsService? ads;

  /// Tests pass a fake clock to cross midnight or wind time back.
  final Clock? clock;

  /// Tests pass a silent one.
  final AudioService? audio;
  final Analytics? analytics;

  /// Tests pass a fake store and verifier.
  final StoreService? storeService;
  final PurchaseVerifier? verifier;
  final GamesService? games;
  final PerfSettings? perf;

  @override
  State<SnakesSlitherApp> createState() => _SnakesSlitherAppState();
}

class _SnakesSlitherAppState extends State<SnakesSlitherApp> {
  final GoRouter _router = buildRouter();
  late final AudioService _audio = widget.audio ?? (AudioService()..init());
  late final Analytics _analytics = widget.analytics ?? Analytics();
  late final GamesService _games =
      widget.games ?? (PlatformGamesService.configured ? PlatformGamesService() : LocalGamesService());

  late final PerfSettings _perf = widget.perf ?? PerfSettings(widget.store);
  late final IntroMode _intro = _introMode();

  /// Full intro on a fresh install and on the first cold start of each local
  /// day, short on later starts, a plain fade when motion is reduced.
  IntroMode _introMode() {
    final reduced =
        SettingsCubit(widget.store).state.reducedMotion ||
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    final now = (widget.clock ?? SystemClock()).now();
    final today = '${now.year}-${now.month}-${now.day}';
    final last = widget.store.read('intro')?['lastDay'] as String?;
    widget.store.write('intro', {'lastDay': today});
    if (reduced) return IntroMode.fade;
    return last == today ? IntroMode.short : IntroMode.full;
  }

  late final AdsService _adsService = widget.ads ?? (hasMobileAds ? AdMobService() : FakeAdsService());

  late final _MemoryObserver _memory = _MemoryObserver(_onMemoryPressure);

  /// Low memory: drop decoded images first.
  void _onMemoryPressure() {
    PaintingBinding.instance.imageCache.clear();
    AppLogger.instance.warn('perf', LogCodes.perfMemoryPressure, 'memory pressure, image cache cleared');
  }

  /// Saves reach disk before the OS may kill a backgrounded app.
  late final AppLifecycleListener _life = AppLifecycleListener(onPause: widget.store.flush, onHide: widget.store.flush);

  @override
  void initState() {
    super.initState();
    _life;
    WidgetsBinding.instance.addObserver(_memory);
    LaunchInfo.channel.setMethodCallHandler((call) async {
      if (call.method == 'memoryPressure') _onMemoryPressure();
    });
    // Silent sign-in and the ad SDK wait until Home is on screen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _games.signIn();
      final c = ComplianceCubit(widget.store).state;
      if (c.ageGateDone) startAds(underAge: c.underAge);
    });
  }

  /// After the intro: tell the player if the save had to be restored.
  void _onIntroDone() {
    if (!widget.store.restoredFromBackup) return;
    final c = _router.routerDelegate.navigatorKey.currentContext;
    if (c == null) return;
    ScaffoldMessenger.maybeOf(c)
        ?.showSnackBar(const SnackBar(content: Text('Your progress was restored from a backup.')));
  }

  /// Consent, then ads. Runs once, after the age gate.
  void startAds({required bool underAge}) {
    _analytics.setChildDirected(underAge);
    _adsService.start(childDirected: underAge);
  }

  int _totalStars(ProgressState p) => p.bestStars.entries.where((e) => e.key <= 500).fold(0, (a, e) => a + e.value);

  void _syncAudio(SettingsData s) {
    _audio.soundEnabled = s.sound;
    _audio.musicEnabled = s.music;
    _audio.haptics.enabled = s.haptics;
  }

  @override
  void dispose() {
    _life.dispose();
    WidgetsBinding.instance.removeObserver(_memory);
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider.value(value: widget.levels),
      RepositoryProvider.value(value: widget.store),
      RepositoryProvider.value(value: _perf),
      RepositoryProvider.value(value: _audio),
      RepositoryProvider.value(value: _analytics),
      RepositoryProvider.value(value: _games),
      RepositoryProvider<StoreService>(
        create: (_) => widget.storeService ?? (useFakeStore ? FakeStoreService() : PlatformStoreService()),
      ),
      RepositoryProvider<AdsService>(create: (_) => _adsService),
      RepositoryProvider(create: (_) => TimeGuard(widget.store, widget.clock ?? SystemClock())),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProgressCubit(widget.store)),
        BlocProvider(create: (_) => WalletCubit(widget.store)),
        BlocProvider(create: (_) => SettingsCubit(widget.store)),
        BlocProvider(create: (_) => ComplianceCubit(widget.store)),
        BlocProvider(
          create: (_) => TutorialCubit(widget.store)..onStep = (s) => _analytics.log('ftue_step', {'step': s}),
        ),
        BlocProvider(create: (c) => AdsCubit(widget.store, c.read<AdsService>(), c.read<TimeGuard>())),
        BlocProvider(
          create: (c) => ShopCubit(
            widget.store,
            c.read<TimeGuard>(),
            c.read<WalletCubit>(),
            c.read<ProgressCubit>(),
            c.read<AdsCubit>(),
          ),
        ),
        BlocProvider(
          create: (c) => WheelCubit(
            widget.store,
            c.read<TimeGuard>(),
            c.read<WalletCubit>(),
            c.read<ProgressCubit>(),
            c.read<AdsCubit>(),
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (c) {
            final iap = IapCubit(
              widget.store,
              c.read<StoreService>(),
              widget.verifier ?? (useFakeStore ? TrustingVerifier() : defaultVerifier()),
              c.read<TimeGuard>(),
              c.read<WalletCubit>(),
              c.read<ProgressCubit>(),
              c.read<AdsCubit>(),
              onTrack: _analytics.log,
            );
            // The store connects after the first frame, never before it.
            WidgetsBinding.instance.addPostFrameCallback((_) => iap.init());
            return iap;
          },
        ),
        BlocProvider(
          create: (c) => StreakCubit(widget.store, c.read<TimeGuard>(), c.read<WalletCubit>(), c.read<AdsCubit>()),
        ),
        BlocProvider(
          create: (c) => DailyCubit(
            widget.store,
            c.read<TimeGuard>(),
            c.read<ProgressCubit>(),
            c.read<WalletCubit>(),
            c.read<StreakCubit>(),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ComplianceCubit, ComplianceState>(
            listenWhen: (a, b) => !a.ageGateDone && b.ageGateDone,
            listener: (_, c) => startAds(underAge: c.underAge),
          ),
          BlocListener<SettingsCubit, SettingsData>(
            // Saved settings apply from the first frame, then on every change.
            listenWhen: (_, _) => true,
            listener: (_, s) => _syncAudio(s),
          ),
          BlocListener<ProgressCubit, ProgressState>(
            listenWhen: (a, b) => a.highestCleared != b.highestCleared || a.bestStars != b.bestStars,
            listener: (_, p) {
              _games.submit(Board.highestLevel, p.highestCleared);
              _games.submit(Board.totalStars, _totalStars(p));
            },
          ),
          BlocListener<StreakCubit, StreakState>(
            listenWhen: (a, b) => a.totalStreakDays != b.totalStreakDays,
            listener: (_, s) => _games.submit(Board.streakDays, s.totalStreakDays),
          ),
        ],
        child: _InitialSync(
          onReady: _syncAudio,
          child: UiFeedbackScope(
            feedback: _audio,
            child: TapLoggerScope(
              child: BlocBuilder<SettingsCubit, SettingsData>(
                buildWhen: (a, b) => a.language != b.language,
                builder: (context, settings) => MaterialApp.router(
                  title: 'Snakes Slither',
                  debugShowCheckedModeBanner: false,
                  theme: buildAppTheme(),
                  routerConfig: _router,
                  locale: Locale(settings.language),
                  supportedLocales: const [Locale('en'), Locale('gu'), Locale('hi')],
                  localizationsDelegates: GlobalMaterialLocalizations.delegates,
                  builder: (context, child) => JungleDawnIntro(
                    mode: _intro,
                    playKey: AppKeys.homePlay,
                    particles: QualityProfile.of(_perf.tier).introParticles,
                    onJank: (ms) => AppLogger.instance.warn('perf', LogCodes.perfIntroJankGuard, 'intro jank guard', {
                      'ms': ms,
                      'tier': _perf.tier.name,
                    }),
                    onDone: _onIntroDone,
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _InitialSync extends StatefulWidget {
  const _InitialSync({required this.onReady, required this.child});
  final void Function(SettingsData) onReady;
  final Widget child;
  @override
  State<_InitialSync> createState() => _InitialSyncState();
}

class _InitialSyncState extends State<_InitialSync> {
  @override
  void initState() {
    super.initState();
    widget.onReady(context.read<SettingsCubit>().state);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// AdMob exists only in the Android and iOS apps.
bool get hasMobileAds =>
    !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

class _MemoryObserver with WidgetsBindingObserver {
  _MemoryObserver(this.onPressure);
  final VoidCallback onPressure;
  @override
  void didHaveMemoryPressure() => onPressure();
}

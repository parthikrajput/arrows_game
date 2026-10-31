import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/level_repository.dart';
import '../data/save_store.dart';
import '../contracts/ui_feedback.dart';
import '../contracts/view_models.dart';
import '../services/ads_service.dart';
import '../services/audio_service.dart';
import '../services/time_guard.dart';
import '../state/ads_cubit.dart';
import '../state/progress_cubit.dart';
import '../state/settings_cubit.dart';
import '../state/shop_cubit.dart';
import '../state/wallet_cubit.dart';
import '../state/wheel_cubit.dart';
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
  });
  final SaveStore store;
  final LevelRepository levels;
  final AdsService? ads;

  /// Tests pass a fake clock to cross midnight or wind time back.
  final Clock? clock;

  /// Tests pass a silent one.
  final AudioService? audio;

  @override
  State<SnakesSlitherApp> createState() => _SnakesSlitherAppState();
}

class _SnakesSlitherAppState extends State<SnakesSlitherApp> {
  final GoRouter _router = buildRouter();
  late final AudioService _audio = widget.audio ?? (AudioService()..init());

  void _syncAudio(SettingsData s) => _audio
    ..soundOn = s.sound
    ..hapticsOn = s.haptics;

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider.value(value: widget.levels),
      RepositoryProvider.value(value: _audio),
      RepositoryProvider<AdsService>(create: (_) => widget.ads ?? FakeAdsService()),
      RepositoryProvider(create: (_) => TimeGuard(widget.store, widget.clock ?? SystemClock())),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProgressCubit(widget.store)),
        BlocProvider(create: (_) => WalletCubit(widget.store)),
        BlocProvider(create: (_) => SettingsCubit(widget.store)),
        BlocProvider(
          create: (c) => AdsCubit(widget.store, c.read<AdsService>(), c.read<TimeGuard>()),
        ),
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
      ],
      child: BlocListener<SettingsCubit, SettingsData>(
        // Saved settings apply from the first frame, then on every change.
        listenWhen: (_, _) => true,
        listener: (_, s) => _syncAudio(s),
        child: _InitialSync(
          onReady: _syncAudio,
          child: UiFeedbackScope(
            feedback: _audio,
            child: MaterialApp.router(
              title: 'Snakes Slither',
              debugShowCheckedModeBanner: false,
              theme: buildAppTheme(),
              routerConfig: _router,
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

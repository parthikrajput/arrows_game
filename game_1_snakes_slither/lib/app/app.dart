import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/level_repository.dart';
import '../data/save_store.dart';
import '../services/ads_service.dart';
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
  });
  final SaveStore store;
  final LevelRepository levels;
  final AdsService? ads;

  /// Tests pass a fake clock to cross midnight or wind time back.
  final Clock? clock;

  @override
  State<SnakesSlitherApp> createState() => _SnakesSlitherAppState();
}

class _SnakesSlitherAppState extends State<SnakesSlitherApp> {
  final GoRouter _router = buildRouter();

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider.value(value: widget.levels),
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
      child: MaterialApp.router(
        title: 'Snakes Slither',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        routerConfig: _router,
      ),
    ),
  );
}

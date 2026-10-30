import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/level_repository.dart';
import '../data/save_store.dart';
import '../services/ads_service.dart';
import '../state/progress_cubit.dart';
import '../state/settings_cubit.dart';
import '../state/wallet_cubit.dart';
import '../ui/theme/tokens.dart';
import 'router.dart';

class SnakesSlitherApp extends StatefulWidget {
  const SnakesSlitherApp({super.key, required this.store, this.ads});
  final SaveStore store;
  final AdsService? ads;

  @override
  State<SnakesSlitherApp> createState() => _SnakesSlitherAppState();
}

class _SnakesSlitherAppState extends State<SnakesSlitherApp> {
  final GoRouter _router = buildRouter();

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (_) => LevelRepository()),
      RepositoryProvider<AdsService>(create: (_) => widget.ads ?? FakeAdsService()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProgressCubit(widget.store)),
        BlocProvider(create: (_) => WalletCubit(widget.store)),
        BlocProvider(create: (_) => SettingsCubit(widget.store)),
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

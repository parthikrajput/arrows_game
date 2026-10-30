import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/slither_engine.dart';

import '../../app/services.dart';
import '../../app/theme/text_styles.dart';
import '../../app/theme/tokens.dart';
import '../../core/widgets/bevel_button.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confetti.dart';
import '../../core/widgets/game_icons.dart';
import '../../core/widgets/garden_background.dart';
import '../../core/widgets/popup.dart';
import '../../services/audio_service.dart';
import '../../state/progress_cubit.dart';
import '../../state/settings_cubit.dart';
import '../../state/wallet_cubit.dart';
import '../gameplay/input/board_view.dart';
import '../gameplay/render/game_scene.dart';
import 'rush_controller.dart';

Route<void> rushRoute(int level) => PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, _, _) => RushPage(level: level),
      transitionsBuilder: (_, a, _, child) => FadeTransition(opacity: a, child: child),
    );

class RushPage extends StatefulWidget {
  const RushPage({super.key, required this.level});
  final int level;

  @override
  State<RushPage> createState() => _RushPageState();
}

class _RushPageState extends State<RushPage> with WidgetsBindingObserver {
  late final RushController _c;
  late final GameScene _scene;
  bool _credited = false;

  AppServices get _s => context.read<AppServices>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _c = RushController(level: widget.level, config: context.read<AppServices>().config)..addListener(_onChange);
    _scene = GameScene(colourBlind: context.read<SettingsCubit>().state.colourBlind, golden: true);
    _sync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _c.dispose();
    _scene.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.paused || s == AppLifecycleState.hidden) _c.pause();
    if (s == AppLifecycleState.resumed) _c.resume();
  }

  RushStage? _lastStage;
  int _lastCount = 3;

  void _onChange() {
    if (_c.stage == RushStage.countdown && _c.countdown != _lastCount) _s.audio.play(Sfx.countdown);
    _lastCount = _c.countdown;
    if (_c.stage != _lastStage && _c.stage == RushStage.results) {
      _s.audio.play(_c.fullClear ? Sfx.winStinger : Sfx.coinsFly);
      _s.analytics.event('rush_end', {'level': widget.level, 'snakes': _c.cleared, 'coins': _c.coins, 'full_clear': _c.fullClear});
    }
    _lastStage = _c.stage;
    setState(() {});
  }

  void _sync() {
    _scene.setBoard(
      cols: _c.board.width,
      rows: _c.board.height,
      snakes: [for (final s in _c.board.snakes) SnakeSprite.of(s)],
    );
  }

  void _onTap(Offset local) {
    final id = _scene.snakeAt(local);
    if (id != null) _resolve(id);
  }

  void _resolve(String id) {
    final o = _c.tap(id);
    final l = _scene.layout;
    final sprite = _scene.spriteById(id);
    if (o == null || l == null || sprite == null) return;
    late final SnakeMotion motion;
    if (o is ExitOutcome) {
      motion = SnakeMotion.exit(l, sprite, o.cellsToEdge, fast: true);
      _s.audio.play(Sfx.pathExit);
      _s.haptics.light();
      _scene.addFloater(Floater('+${_c.config.rushCoinsPerSnake}', l.center(sprite.body.first)));
    } else {
      // Blocked golden snake: wobble only, no heart and no coins.
      motion = SnakeMotion.wobble(sprite, duration: const Duration(milliseconds: 300));
      _s.audio.play(Sfx.lockedTap);
    }
    _scene.play(motion, onDone: () {
      final next = _c.commit(o);
      _sync();
      if (next != null) _resolve(next);
    });
  }

  Future<void> _skip() async {
    final playing = _c.stage == RushStage.playing || _c.stage == RushStage.countdown;
    if (playing) _c.pause();
    final ok = await confirmPopup(
      context,
      title: 'Skip the coins?',
      message: playing ? 'You keep the ${_c.coins} coins collected so far.' : 'The Golden Slither Rush will be gone for this level.',
      yes: 'Skip',
      no: 'Keep playing',
    );
    if (!mounted) return;
    if (!ok) {
      if (playing) _c.resume();
      return;
    }
    if (playing) {
      _c.finish();
    } else {
      context.read<ProgressCubit>().clearRushPending();
      Navigator.of(context).pop();
    }
  }

  void _continue() {
    if (!_credited) {
      _credited = true;
      context.read<WalletCubit>().earn('golden_rush', _c.coins);
      context.read<ProgressCubit>().clearRushPending();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _c.stage == RushStage.results ? _continue() : _skip();
      },
      child: Scaffold(
        body: GardenBackground(
          hillsAt: 0.2,
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    _header(),
                    Expanded(child: BoardView(scene: _scene, onTap: _onTap, semanticsLabel: 'Golden snakes board')),
                    Padding(
                      padding: const EdgeInsets.all(Space.md),
                      child: Text('Tap fast! No hearts to lose.', style: AppText.bodyBold),
                    ),
                  ],
                ),
                if (_c.stage == RushStage.intro) _intro(),
                if (_c.stage == RushStage.countdown || _c.paused) _countdownView(),
                if (_c.stage == RushStage.results) _results(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, Space.sm),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('GOLDEN SLITHER RUSH', style: AppText.h2.copyWith(color: AppColors.coinGoldDark))),
              const Icon(Icons.timer_rounded, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('${(_c.left.inMilliseconds / 1000).ceil()}', style: AppText.hudNumber),
            ],
          ),
          const SizedBox(height: Space.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.pill),
            child: LinearProgressIndicator(
              value: _c.stage == RushStage.intro ? 1 : _c.timeFraction,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.6),
              color: _c.timeFraction < 0.25 ? AppColors.heart : AppColors.coinGold,
            ),
          ),
          const SizedBox(height: Space.sm),
          Row(
            children: [
              const CoinIcon(size: 24),
              const SizedBox(width: 4),
              AnimatedCount(_c.coins, style: AppText.h2),
              const Spacer(),
              Text('snakes ${_c.cleared}/${_c.total}', style: AppText.bodyBold),
              const SizedBox(width: Space.md),
              if (_c.stage == RushStage.playing) TextButton(onPressed: _skip, child: const Text('Skip')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _intro() {
    final cfg = _c.config;
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.scrim,
        child: PopupCard(
          title: 'Golden Slither Rush!',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CoinIcon(size: 64),
              const SizedBox(height: Space.md),
              Text(
                'Tap as many golden snakes as you can in ${cfg.rushSeconds} seconds.\n'
                '+${cfg.rushCoinsPerSnake} coins each · clear them all for +${cfg.rushFullClearBonus}!',
                style: AppText.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Space.xl),
              BevelButton.text('Start', style: BevelStyle.gold, expand: true, logId: 'rush.start', onPressed: _c.start),
              TextButton(onPressed: _skip, child: Text('Skip', style: AppText.caption)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _countdownView() {
    final text = _c.paused ? 'Paused' : (_c.countdown > 0 ? '${_c.countdown}' : 'Go!');
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black26,
        child: Center(
          child: TweenAnimationBuilder<double>(
            key: ValueKey(text),
            tween: Tween(begin: 1.8, end: 1),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Text(text, style: AppText.display.copyWith(fontSize: 96, color: Colors.white, shadows: const [Shadow(blurRadius: 12)])),
          ),
        ),
      ),
    );
  }

  Widget _results() {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.scrim,
        child: Stack(
          children: [
            if (_c.fullClear) const Positioned.fill(child: LeafConfetti()),
            PopupCard(
              title: _c.fullClear ? 'Full clear!' : 'Time\'s up!',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${_c.cleared} golden snakes', style: AppText.h2),
                  const SizedBox(height: Space.md),
                  RewardChip(coins: _c.coins),
                  if (_c.fullClear) ...[
                    const SizedBox(height: Space.sm),
                    Chip2('Full clear +${_c.config.rushFullClearBonus}!', color: AppColors.coinGoldDark, icon: Icons.bolt_rounded),
                  ],
                  const SizedBox(height: Space.xl),
                  BevelButton.text('Continue', expand: true, logId: 'rush.continue', onPressed: _continue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

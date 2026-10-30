import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_core/slither_engine.dart';

import '../../../app/routes.dart';
import '../../../app/services.dart';
import '../../../app/theme/text_styles.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/widgets/bevel_button.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/game_icons.dart';
import '../../../core/widgets/garden_background.dart';
import '../../../core/widgets/pip.dart';
import '../../../core/widgets/popup.dart';
import '../../../data/levels/level_repository.dart';
import '../../../services/audio_service.dart';
import '../../../services/remote_config.dart';
import '../../../state/ads_cubit.dart';
import '../../../state/daily_cubit.dart';
import '../../../state/leaderboard_cubit.dart';
import '../../../state/progress_cubit.dart';
import '../../../state/settings_cubit.dart';
import '../../../state/shop_cubit.dart';
import '../../../state/streak_cubit.dart';
import '../../../state/wallet_cubit.dart';
import '../../daily/daily_modifier_chip.dart';
import '../../rewards/gift_basket_page.dart';
import '../../rush/rush_page.dart';
import '../../tutorial/tutorial_overlay.dart';
import '../bloc/game_bloc.dart';
import '../input/board_view.dart';
import '../render/game_scene.dart';
import 'booster_bar.dart';
import 'hud.dart';
import 'popups/mini_shop.dart';
import 'popups/pause_sheet.dart';
import 'popups/results.dart';
import 'popups/second_chance.dart';

class GameArgs {
  const GameArgs.level(this.level) : daily = null;
  const GameArgs.daily(DailyPuzzle this.daily) : level = 0;

  final int level;
  final DailyPuzzle? daily;

  GameMode get mode => daily != null ? GameMode.daily(daily!.dayKey) : GameMode.level(level);
}

class GameplayPage extends StatefulWidget {
  const GameplayPage({super.key, required this.args});
  final GameArgs args;

  @override
  State<GameplayPage> createState() => _GameplayPageState();
}

class _GameplayPageState extends State<GameplayPage> with WidgetsBindingObserver {
  GameBloc? _bloc;
  LevelUnavailable? _error;
  late final GameScene _scene;
  StreamSubscription<GameState>? _sub;
  late GameState _prev;
  Timer? _animGuard;
  TutorialStep? _tutorial;
  bool _modalOpen = false;
  DateTime _startedAt = DateTime.now();

  final _stackKey = GlobalKey();
  final _boardKey = GlobalKey();
  final _boosterKeys = {for (final t in BoosterType.values) t: GlobalKey()};

  AppServices get _s => context.read<AppServices>();
  GameMode get _mode => widget.args.mode;
  int get _level => widget.args.level;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final settings = context.read<SettingsCubit>().state;
    _scene = GameScene(
      colourBlind: settings.colourBlind,
      tint: AppColors.biomeTint(_mode.isDaily ? 101 : _level),
    );
    _load();
  }

  void _load() {
    try {
      final def = widget.args.daily?.def ?? _s.levels.get(_level);
      final wallet = context.read<WalletCubit>();
      final progress = context.read<ProgressCubit>();
      final bloc = GameBloc(
        mode: _mode,
        def: def,
        hearts: widget.args.daily?.hearts ?? _s.config.heartsPerAttempt,
        deps: GameDeps(consumeBooster: wallet.consumeBooster, adReviveUsed: progress.adReviveUsed, config: _s.config),
      );
      _bloc = bloc;
      _error = null;
      _prev = bloc.state;
      _syncScene(bloc.state);
      _sub = bloc.stream.listen(_onState);
      _startedAt = DateTime.now();
      _s.analytics.event('level_start', {'level': _mode.isDaily ? 'daily' : _level, 'attempt': 1});
      WidgetsBinding.instance.addPostFrameCallback((_) => _startTutorials());
    } on LevelUnavailable catch (e) {
      _error = e;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animGuard?.cancel();
    _sub?.cancel();
    _bloc?.close();
    _scene.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    // Backgrounded mid-level ⇒ pause overlay on return.
    if (s == AppLifecycleState.paused && _bloc?.state.status == GameStatus.playing && !_modalOpen) {
      _pause();
    }
  }

  void _syncScene(GameState s) {
    _scene.setBoard(
      cols: s.board.width,
      rows: s.board.height,
      snakes: [for (final sn in s.board.snakes) SnakeSprite.of(sn)],
    );
  }

  // ───────────────────────── State → presentation ─────────────────────────

  void _onState(GameState s) {
    final prev = _prev;
    _prev = s;
    if (!identical(s.board, prev.board) || s.attempt != prev.attempt) _syncScene(s);
    if (s.anim != null && s.anim!.seq != prev.anim?.seq && s.status == GameStatus.animating) _playAnim(s.anim!);
    if (s.effect != null && s.effect != prev.effect) _onEffect(s.effect!);
    _scene.setHint(s.hintTarget);
    _scene.setHammerMode(s.status == GameStatus.hammerTarget);
    if (s.status != prev.status) {
      switch (s.status) {
        case GameStatus.won:
          _onWon(s);
        case GameStatus.secondChance:
          _onSecondChance();
        case GameStatus.failed:
          _onFailed(s);
        case GameStatus.stuck:
          _onStuck();
        default:
          break;
      }
    }
  }

  void _playAnim(AnimRequest a) {
    final l = _scene.layout;
    final sprite = _scene.spriteById(a.snakeId);
    final bloc = _bloc!;
    if (l == null || sprite == null) {
      bloc.add(AnimationCompleted(a.seq));
      return;
    }
    final motion = switch (a.kind) {
      AnimKind.exit => SnakeMotion.exit(l, sprite, a.cells),
      AnimKind.bump => SnakeMotion.bump(l, sprite, a.cells, a.blocker!),
      AnimKind.wobble => SnakeMotion.wobble(sprite),
      AnimKind.smash => SnakeMotion.smash(sprite),
    };
    switch (a.kind) {
      case AnimKind.exit:
        _s.audio.play(Sfx.pathExit);
        _s.haptics.light();
      case AnimKind.bump:
        // Sound on the contact frame, not on the tap.
        Future.delayed(motion.duration * SnakeMotion.impact, () {
          _s.audio.play(Sfx.bump);
          _s.haptics.medium();
        });
      case AnimKind.wobble:
        _s.audio.play(Sfx.lockedTap);
        _s.haptics.selection();
      case AnimKind.smash:
        _s.audio.play(Sfx.boosterHammer);
        _s.haptics.heavy();
        _s.analytics.event('booster_use', {'type': 'hammer', 'level': _level});
    }
    _scene.play(motion, onDone: () => bloc.add(AnimationCompleted(a.seq)));
    _animGuard?.cancel();
    _animGuard = Timer(motion.duration + const Duration(seconds: 2), () {
      if (bloc.state.status == GameStatus.animating && bloc.state.anim?.seq == a.seq) {
        log.e('E-GAME-003', 'Animation stuck, forcing completion');
        _scene.forceComplete();
      }
    });
  }

  void _onEffect(GameEffect e) {
    switch (e.kind) {
      case EffectKind.heartLost:
        _s.audio.play(Sfx.heartLost);
      case EffectKind.shieldAbsorbed:
        _s.audio.play(Sfx.shieldAbsorb);
        showToast(context, 'Safety Shell saved a heart berry!');
      case EffectKind.shieldActivated:
        _s.audio.play(Sfx.shieldAbsorb);
        _s.analytics.event('booster_use', {'type': 'shield', 'level': _level});
      case EffectKind.hintShown:
        _s.audio.play(Sfx.boosterHint);
        _s.analytics.event('booster_use', {'type': 'hint', 'level': _level});
      case EffectKind.hintFailed:
        _s.analytics.event('hint_fail', {'level': _level});
        showToast(context, 'No safe move from here. Try Restart.');
      case EffectKind.boosterCapReached:
        showToast(context, 'Limit for this try');
      case EffectKind.needBooster:
        _openMiniShop(e.booster);
      case EffectKind.hammerLastSnakeBlocked:
        showToast(context, 'Collect the gems first!');
      case EffectKind.slithered:
        _advanceGuidedTutorial();
    }
  }

  // ───────────────────────── Input ─────────────────────────

  void _onBoardTap(Offset local) {
    final bloc = _bloc;
    if (bloc == null) return;
    final id = _scene.snakeAt(local);
    final cell = _scene.layout?.cellAt(local);
    log.tap('board:cell(${cell?.x},${cell?.y}):${id ?? '-'}');
    if (id == null) return;
    final t = _tutorial;
    if (t != null && t.guided && id != _scene.highlightSnakeId) return;
    _s.audio.play(Sfx.pathTap);
    bloc.add(SnakeTapped(id));
  }

  void _onPreviewStart(Offset local) {
    final bloc = _bloc;
    final l = _scene.layout;
    if (bloc == null || l == null || bloc.state.status != GameStatus.playing) return;
    final id = _scene.snakeAt(local);
    final snake = id == null ? null : bloc.state.board.snakeById(id);
    if (snake == null) return;
    final lane = Engine.trace(bloc.state.board, snake);
    final head = l.center(snake.head);
    final end = lane.isClear
        ? (lane.cells.isEmpty ? head : l.center(lane.cells.last)) + snake.dir.unit * (l.cell * 0.5)
        : l.center(lane.blockerCell!);
    _scene.setPreview(id, [head, end], blocked: !lane.isClear);
    _s.audio.play(Sfx.previewStart);
    _s.haptics.selection();
    if (_tutorial?.id == 'ftue_preview') _dismissTutorial();
  }

  void _onPreviewEnd() => _scene.setPreview(null, null);

  int get _unlockedUpTo {
    final highest = context.read<ProgressCubit>().state.highestCleared;
    return _mode.isDaily ? highest : math.max(highest, _level);
  }

  void _onBooster(BoosterType t) {
    final bloc = _bloc!;
    final cfg = _s.config;
    if (_unlockedUpTo < cfg.boosterUnlockLevel(t)) {
      showToast(context, 'Unlocks at level ${cfg.boosterUnlockLevel(t)}');
      return;
    }
    if (t == BoosterType.hammer && bloc.state.status == GameStatus.hammerTarget) {
      bloc.add(const HammerModeToggled());
      return;
    }
    if (bloc.state.usesOf(t) >= cfg.boosterCap(t)) {
      showToast(context, 'Limit for this try');
      return;
    }
    if (context.read<WalletCubit>().state.count(t) <= 0) {
      _openMiniShop(t);
      return;
    }
    if (_tutorial != null && !_tutorial!.guided) _dismissTutorial();
    bloc.add(switch (t) {
      BoosterType.hint => const HintRequested(),
      BoosterType.shield => const ShieldActivated(),
      BoosterType.hammer => const HammerModeToggled(),
    });
  }

  Future<void> _openMiniShop(BoosterType? t) async {
    _modalOpen = true;
    await showMiniShop(context, booster: t);
    _modalOpen = false;
  }

  // ───────────────────────── Flow ─────────────────────────

  Future<void> _pause() async {
    final bloc = _bloc;
    if (bloc == null || _modalOpen) return;
    if (bloc.state.status == GameStatus.hammerTarget) {
      bloc.add(const HammerModeToggled());
      return;
    }
    if (bloc.state.status != GameStatus.playing && bloc.state.status != GameStatus.animating) return;
    _modalOpen = true;
    final action = await showPauseSheet(context, showMap: !_mode.isDaily);
    _modalOpen = false;
    if (!mounted) return;
    _scene
      ..colourBlind = context.read<SettingsCubit>().state.colourBlind
      ..reducedMotion = MediaQuery.of(context).disableAnimations;
    _syncScene(bloc.state);
    switch (action) {
      case PauseAction.resume:
        break;
      case PauseAction.restart:
        if (bloc.state.moves > 0 &&
            !await confirmPopup(context, title: 'Restart?', message: 'Start this puzzle again with 3 heart berries?', yes: 'Restart')) {
          return;
        }
        _restart();
      case PauseAction.map:
        _goMap(_level);
      case PauseAction.home:
        _goHome();
    }
  }

  void _restart() {
    _bloc?.add(const Restarted());
    _startedAt = DateTime.now();
    _s.analytics.event('level_start', {'level': _mode.isDaily ? 'daily' : _level, 'attempt': (_bloc?.state.attempt ?? 1) + 1});
  }

  void _goHome() => Navigator.of(context).popUntil((r) => r.isFirst);

  void _goMap(int focus) =>
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.map, (r) => r.isFirst, arguments: focus);

  Future<void> _onSecondChance() async {
    final bloc = _bloc!;
    _modalOpen = true;
    final choice = await showSecondChance(context, reviveKey: _mode.reviveKey, refillsLeft: bloc.refillsLeft);
    _modalOpen = false;
    if (!mounted) return;
    switch (choice) {
      case ReviveChoice.ad:
        bloc.add(const ReviveGranted(viaAd: true));
      case ReviveChoice.refill:
        bloc.add(const ReviveGranted(viaAd: false));
      case ReviveChoice.declined:
        bloc.add(const ReviveDeclined());
    }
  }

  Future<void> _onFailed(GameState s) async {
    _s.analytics.event('level_fail', {'level': _mode.isDaily ? 'daily' : _level, 'moves': s.moves});
    _modalOpen = true;
    final action = await showLevelFailed(context, attempt: s.attempt);
    _modalOpen = false;
    if (!mounted) return;
    action == FailedAction.retry ? _restart() : _goHome();
  }

  Future<void> _onStuck() async {
    _modalOpen = true;
    final action = await showStuck(context);
    _modalOpen = false;
    if (!mounted) return;
    action == StuckAction.restart ? _restart() : _goHome();
  }

  Future<void> _onWon(GameState s) async {
    _modalOpen = true;
    _s.audio.play(Sfx.winStinger);
    _s.haptics.heavy();
    final stars = s.stars;
    _s.analytics.event('level_win', {
      'level': _mode.isDaily ? 'daily' : _level,
      'moves': s.moves,
      'hearts_lost': s.heartsLost,
      'stars': stars,
      'duration_s': DateTime.now().difference(_startedAt).inSeconds,
    });
    // Let the last snake finish waving goodbye.
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    if (_mode.isDaily) {
      await _dailyWon(stars);
    } else {
      await _levelWon(s, stars);
    }
  }

  Future<void> _dailyWon(int stars) async {
    final dayKey = _mode.dayKey!;
    final wallet = context.read<WalletCubit>();
    final reward = context.read<DailyCubit>().won(dayKey, stars);
    wallet.earn('daily_clear', reward.coins);
    StreakAdvance? adv;
    if (reward.firstClear && !_s.time.timeTravelLocked) {
      adv = context.read<StreakCubit>().onDailyClear(dayKey);
      if (adv != null) {
        wallet.earn('streak_day_${adv.day}', adv.reward.coins);
        for (final b in adv.reward.boosters) {
          wallet.grantBooster(b);
        }
        context.read<LeaderboardCubit>().submit(Board.streakDays, context.read<StreakCubit>().state.totalDays);
      }
      await _s.time.touch();
    }
    if (!mounted) return;
    if (reward.coins > 0) _s.audio.play(Sfx.coinsFly);
    await showDailyResult(context, stars: stars, coins: reward.coins, streakDay: adv?.day, streakReward: adv?.reward, trophyUp: adv?.trophyUp ?? false);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _levelWon(GameState s, int stars) async {
    final progress = context.read<ProgressCubit>();
    final ads = context.read<AdsCubit>();
    final reward = progress.levelWon(_level, stars, s.def.tag);
    context.read<WalletCubit>().earn('level_clear', reward.total);
    if (reward.total > 0) _s.audio.play(Sfx.coinsFly);
    final win = WinContext(level: _level, hasGiftBasket: reward.giftDue, hasRush: reward.rushDue, hasChest: reward.chestDue);
    ads.recordWin(win);
    context.read<ShopCubit>().openStarterWindowIfDue(progress.state.highestCleared);
    final lb = context.read<LeaderboardCubit>();
    lb.submit(Board.highestLevel, progress.state.highestCleared);
    lb.submit(Board.totalStars, progress.state.totalStars);

    final action = await showLevelComplete(context, reward);
    if (!mounted) return;
    if (reward.giftDue || reward.chestDue) {
      await Navigator.of(context).push(giftBasketRoute(level: _level, chest: reward.chestDue));
      if (!mounted) return;
    }
    if (reward.rushDue) {
      await Navigator.of(context).push(rushRoute(_level));
      if (!mounted) return;
    }
    await ads.maybeShowInterstitial(win);
    if (!mounted) return;
    if (_level >= _s.config.phaseLastLevel) {
      Navigator.of(context).pushReplacementNamed(Routes.phaseComplete);
    } else if (action == CompleteAction.next) {
      Navigator.of(context).pushReplacementNamed(Routes.play, arguments: GameArgs.level(_level + 1));
    } else {
      _goMap(_level + 1);
    }
  }

  // ───────────────────────── Tutorials ─────────────────────────

  Rect? _toStack(GlobalKey key, [Rect? local]) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    final stack = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || stack == null || !box.hasSize) return null;
    final r = local ?? Offset.zero & box.size;
    final tl = stack.globalToLocal(box.localToGlobal(r.topLeft));
    return tl & r.size;
  }

  void _startTutorials() {
    if (!mounted || _mode.isDaily || _bloc == null) return;
    final progress = context.read<ProgressCubit>();
    final wallet = context.read<WalletCubit>();
    bool due(String id, int level) => _level == level && !progress.tutorialDone(id);

    if (due('ftue_tap', 1)) {
      final first = _bloc!.state.def.solution.firstOrNull;
      final rect = first == null ? null : _scene.snakeRect(first);
      if (first != null && rect != null) {
        _scene.setHighlight(first);
        _show(TutorialStep(id: 'ftue_tap', text: 'Tap a snake to help it slither out of the garden!', target: _toStack(_boardKey, rect), guided: true));
        return;
      }
    }
    if (due('ftue_bonk', 2)) {
      _show(const TutorialStep(id: 'ftue_bonk', text: 'Careful! A snake only goes the way its head points. If something is in the way it bonks, and you lose a heart berry.'));
    } else if (due('tut_hint', 3)) {
      wallet.grantBooster(BoosterType.hint, 3);
      _show(TutorialStep(
        id: 'tut_hint',
        text: 'Stuck? The Glow Firefly lights up the next safe snake. Here are 3 for free!',
        target: _toStack(_boosterKeys[BoosterType.hint]!),
      ));
    } else if (due('ftue_preview', 5)) {
      _show(const TutorialStep(id: 'ftue_preview', text: 'Hold your finger on a snake to flick its tongue and preview its path. Green = clear, red = blocked.'));
    } else if (due('tut_shield', 15)) {
      wallet.grantBooster(BoosterType.shield);
      _show(TutorialStep(
        id: 'tut_shield',
        text: 'New! The Safety Shell Shield blocks your next 2 heart losses. Here is one free.',
        target: _toStack(_boosterKeys[BoosterType.shield]!),
      ));
    } else if (due('tut_hammer', 25)) {
      wallet.grantBooster(BoosterType.hammer);
      _show(TutorialStep(
        id: 'tut_hammer',
        text: 'New! The Magic Stone Hammer removes any one snake. Here is one free.',
        target: _toStack(_boosterKeys[BoosterType.hammer]!),
      ));
    }
  }

  void _show(TutorialStep step) => setState(() => _tutorial = step);

  void _dismissTutorial() {
    final t = _tutorial;
    if (t == null) return;
    context.read<ProgressCubit>().completeTutorial(t.id);
    _scene.setHighlight(null);
    setState(() => _tutorial = null);
  }

  void _advanceGuidedTutorial() {
    if (_tutorial?.id != 'ftue_tap') return;
    _dismissTutorial();
    _show(const TutorialStep(id: 'ftue_goal', text: 'Well done! Free every snake to finish the level. Take your time — there is no clock.'));
  }

  // ───────────────────────── Build ─────────────────────────

  @override
  Widget build(BuildContext context) {
    final error = _error;
    if (error != null) return _LevelUnavailableView(error: error, onRetry: () => setState(_load));
    final bloc = _bloc!;
    return BlocProvider.value(
      value: bloc,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _pause();
        },
        child: Scaffold(
          body: GardenBackground(
            hillsAt: 0.22,
            child: Stack(
              key: _stackKey,
              children: [
                SafeArea(child: _layout(context)),
                if (_tutorial != null)
                  Positioned.fill(child: TutorialOverlay(step: _tutorial!, onDismiss: _dismissTutorial)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _layout(BuildContext context) {
    final mq = MediaQuery.of(context);
    final landscapeTablet = mq.size.width > mq.size.height && mq.size.shortestSide >= 600;
    final chip = _mode.isDaily
        ? DailyModifierChip(modifier: widget.args.daily!.modifier)
        : _bloc!.state.def.tag == LevelTag.hard || _bloc!.state.def.tag == LevelTag.finale
            ? Chip2(levelTagLabel(_bloc!.state.def.tag), color: AppColors.danger, icon: Icons.pets_rounded)
            : null;
    final board = Column(
      children: [
        const MovesLabel(),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: BoardView(
                  key: _boardKey,
                  scene: _scene,
                  onTap: _onBoardTap,
                  onLongPressStart: _onPreviewStart,
                  onLongPressEnd: _onPreviewEnd,
                  semanticsLabel: 'Garden board',
                ),
              ),
              const _HammerBanner(),
            ],
          ),
        ),
      ],
    );
    final boosters = BoosterBar(
      unlockedUpTo: _unlockedUpTo,
      onTap: _onBooster,
      vertical: landscapeTablet,
      keys: _boosterKeys,
    );
    return Column(
      children: [
        GameHud(onPause: _pause, chip: chip),
        Expanded(
          child: landscapeTablet ? Row(children: [Expanded(child: board), boosters]) : board,
        ),
        if (!landscapeTablet) boosters,
        if (_mode.isDaily || _level >= _s.config.interstitialMinLevel) ...[
          const Divider(height: 1),
          BannerSlot(level: _mode.isDaily ? 99 : _level),
        ],
      ],
    );
  }
}

class _HammerBanner extends StatelessWidget {
  const _HammerBanner();

  @override
  Widget build(BuildContext context) {
    final on = context.select((GameBloc b) => b.state.status == GameStatus.hammerTarget);
    return AnimatedPositioned(
      duration: Motion.base,
      curve: Motion.baseCurve,
      left: Space.gutter,
      right: Space.gutter,
      top: on ? Space.sm : -80,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Space.md, vertical: Space.sm),
        decoration: BoxDecoration(color: AppColors.textPrimary.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(Radii.md)),
        child: Row(
          children: [
            const BoosterIcon(BoosterType.hammer, size: 28),
            const SizedBox(width: Space.sm),
            Expanded(child: Text('Tap a snake to smash it away', style: AppText.bodyBold.copyWith(color: Colors.white))),
            TextButton(
              onPressed: () => context.read<GameBloc>().add(const HammerModeToggled()),
              child: Text('Cancel', style: AppText.bodyBold.copyWith(color: AppColors.coinGold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelUnavailableView extends StatelessWidget {
  const _LevelUnavailableView({required this.error, required this.onRetry});
  final LevelUnavailable error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GardenBackground(
        child: Center(
          child: PopupCard(
            title: 'Level unavailable',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Pip(pose: PipPose.sad, size: 100),
                Text('Level ${error.level} could not be loaded (${error.code}).', style: AppText.body, textAlign: TextAlign.center),
                const SizedBox(height: Space.xl),
                BevelButton.text('Retry', expand: true, onPressed: onRetry),
                const SizedBox(height: Space.sm),
                TextButton(onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst), child: const Text('Home')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

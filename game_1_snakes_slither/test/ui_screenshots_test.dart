// Renders every Phase 1 screen with sample data to PNG files, to compare
// against the UI canvas. Skipped unless UI_SHOTS points at an output folder:
//   UI_SHOTS=/tmp/shots flutter test test/ui_screenshots_test.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snakes_slither/contracts/view_models.dart';
import 'package:snakes_slither/data/level_repository.dart';
import 'package:snakes_slither/features/gameplay/board_geometry.dart';
import 'package:snakes_slither/ui/board/board_canvas.dart';
import 'package:snakes_slither/ui/popups/popups.dart';
import 'package:snakes_slither/ui/screens/gameplay_screen.dart';
import 'package:snakes_slither/ui/screens/home_screen.dart';
import 'package:snakes_slither/ui/screens/level_map_screen.dart';
import 'package:snakes_slither/ui/screens/settings_screen.dart';
import 'package:snakes_slither/ui/screens/shop_screen.dart';
import 'package:snakes_slither/ui/screens/wheel_screen.dart';
import 'package:snakes_slither/ui/theme/tokens.dart';

final _out = Platform.environment['UI_SHOTS'];
final _w = double.tryParse(Platform.environment['UI_SHOTS_WIDTH'] ?? '') ?? 390;

void main() {
  setUpAll(() async {
    if (_out == null) return;
    for (final f in ['Fredoka', 'Nunito']) {
      final bytes = File('assets/fonts/$f.ttf').readAsBytesSync();
      await (FontLoader(f)..addFont(Future.value(ByteData.sublistView(bytes)))).load();
    }
  });

  final repo = LevelRepository.fromJsonString(File(LevelRepository.assetPath).readAsStringSync());
  const nop = _nop;

  Widget board(int level, {int? hint, PreviewData? preview, bool hammer = false}) => LayoutBuilder(
    builder: (_, box) {
      final b = repo.load(level).board;
      final g = BoardGeometry.fit(columns: b.width, rows: b.height, avail: box.biggest);
      return SizedBox.fromSize(
        size: g.size,
        child: BoardCanvas(
          data: BoardViewData(
            board: b,
            motion: null,
            hintSnakeId: hint,
            preview: preview,
            hammerMode: hammer,
            colourBlind: false,
            reducedMotion: true,
          ),
          geometry: g,
          onMotionDone: (_) {},
        ),
      );
    },
  );

  List<BoosterButtonData> boosters(int level, {Booster? active}) => [
    for (final (b, unlock, count) in [(Booster.hint, 3, 2), (Booster.shield, 15, 1), (Booster.hammer, 25, 0)])
      BoosterButtonData(
        booster: b,
        count: count,
        locked: level < unlock,
        unlockLevel: unlock,
        used: 0,
        cap: 3,
        enabled: true,
        active: active == b,
      ),
  ];

  Widget game(
    int level, {
    bool hard = false,
    Widget? overlay,
    int hearts = 3,
    int? hint,
    PreviewData? preview,
    bool hammer = false,
    int shield = 0,
  }) => Stack(
    children: [
      GameplayScreen(
        hud: HudData(
          level: level,
          isHard: hard,
          hearts: hearts,
          maxHearts: 3,
          shieldCharges: shield,
          moves: 3,
          coins: 1250,
        ),
        boosters: boosters(
          level == 19 && hammer ? 30 : level,
          active: hammer
              ? Booster.hammer
              : hint != null
              ? Booster.hint
              : null,
        ),
        board: board(level, hint: hint, preview: preview, hammer: hammer),
        hammerMode: hammer,
        onPause: nop,
        onBooster: (_) {},
        onCancelHammer: nop,
      ),
      if (overlay != null) ...[const ModalBarrier(color: AppColors.scrim), overlay],
    ],
  );

  const settings = SettingsData(sound: true, music: true, haptics: false, colourBlind: false, reducedMotion: false);
  final l19 = repo.load(19).board;
  final red = l19.snakes.values.firstWhere((s) => s.color == SnakeColor.red);

  final shots = <String, Widget>{
    'home': HomeScreen(
      data: const HomeData(coins: 1250, nextLevel: 37, allCleared: false, wheelUnlocked: true, freeSpinReady: true),
      onPlay: nop,
      onOpenMap: nop,
      onOpenSettings: nop,
      onOpenShop: nop,
      onOpenWheel: nop,
    ),
    'map': LevelMapScreen(
      nodes: [
        for (var n = 1; n <= 30; n++)
          LevelNodeData(
            number: n,
            state: n < 12
                ? NodeState.cleared
                : n == 12
                ? NodeState.current
                : NodeState.locked,
            stars: n < 12 ? (n % 3) + 1 : 0,
            isHard: n == 19 || n == 9,
          ),
      ],
      onLevelTap: (_) {},
      onBack: nop,
    ),
    'play_l12': game(12),
    'play_l19_hard': game(19, hard: true, shield: 2),
    'preview': game(
      19,
      hard: true,
      preview: PreviewData(
        snakeId: red.id,
        lane: const LaneTrace(cells: [Cell(3, 1)], blocker: Cell(4, 1)),
      ),
    ),
    'hint': game(19, hard: true, hint: l19.snakes.values.firstWhere((s) => s.color == SnakeColor.green).id),
    'hammer': game(19, hard: true, hammer: true),
    'pause': game(
      12,
      overlay: PausePopup(settings: settings, onResume: nop, onRestart: nop, onMap: nop, onHome: nop, onToggle: (_) {}),
    ),
    'second_chance': game(
      19,
      hearts: 0,
      overlay: SecondChancePopup(
        data: const SecondChanceData(
          adAvailable: true,
          adUsedForLevel: false,
          refillsLeft: 2,
          refillCost: 120,
          coins: 1250,
        ),
        paused: true,
        onWatchAd: nop,
        onRefill: nop,
        onDecline: nop,
      ),
    ),
    'failed': game(
      19,
      hearts: 0,
      overlay: LevelFailedPopup(onRetry: nop, onHome: nop),
    ),
    'complete': game(
      12,
      overlay: LevelCompletePopup(
        data: const LevelCompleteData(
          level: 12,
          stars: 3,
          clearCoins: 20,
          starBonus: 20,
          canDouble: true,
          doubled: false,
          hasNext: true,
        ),
        adBusy: false,
        onDouble: nop,
        onNext: nop,
        onMap: nop,
      ),
    ),
    'mini_shop': game(
      19,
      overlay: MiniShopSheet(
        data: const MiniShopData(booster: Booster.hint, singlePrice: 60, packPrice: 150, coins: 1250),
        onBuySingle: nop,
        onBuyPack: nop,
        onClose: nop,
      ),
    ),
    'gift': game(
      20,
      overlay: GiftBasketPopup(
        data: const GiftBasketData(level: 20, coins: 100, boosters: {Booster.hint: 1}, isChest: false),
        onCollect: nop,
      ),
    ),
    'shop': ShopScreen(
      data: ShopData(
        coins: 1250,
        tiles: [
          for (final (b, q, p, u) in [
            (Booster.hint, 1, 60, 3),
            (Booster.hint, 3, 150, 3),
            (Booster.shield, 1, 80, 15),
            (Booster.shield, 3, 200, 15),
            (Booster.hammer, 1, 100, 25),
            (Booster.hammer, 3, 250, 25),
          ])
            ShopTileData(booster: b, quantity: q, price: p, locked: 18 < u, unlockLevel: u, affordable: true),
        ],
        freeCoinsLeft: 3,
        freeCoinsAmount: 50,
        adAvailable: true,
        busy: false,
        vipActive: false,
        storeAvailable: false,
      ),
      onBuy: (_) {},
      onFreeCoins: nop,
      onBack: nop,
    ),
    'wheel': WheelScreen(
      data: const WheelData(
        segments: [
          WheelSegmentData(label: '20 coins', odds: .3, coins: 20),
          WheelSegmentData(label: '50 coins', odds: .25, coins: 50),
          WheelSegmentData(label: '100 coins', odds: .15, coins: 100),
          WheelSegmentData(label: '75 coins', odds: .12, coins: 75),
          WheelSegmentData(label: 'Firefly', odds: .1, booster: Booster.hint),
          WheelSegmentData(label: 'Shell', odds: .05, booster: Booster.shield),
          WheelSegmentData(label: 'Hammer', odds: .025, booster: Booster.hammer),
          WheelSegmentData(label: '500 coins', odds: .005, coins: 500),
        ],
        freeAvailable: true,
        adAvailable: true,
        freeUsed: false,
        adUsed: false,
        timeLocked: false,
        busy: false,
        prizeIndex: null,
        spinSeq: 0,
      ),
      onSpinFree: nop,
      onSpinAd: nop,
      onBack: nop,
    ),
    'settings': SettingsScreen(settings: settings, onToggle: (_) {}, onBack: nop),
  };

  for (final e in shots.entries) {
    testWidgets('screenshot ${e.key}', skip: _out == null, (t) async {
      t.view.physicalSize = Size(_w * 2, 844 * 2);
      t.view.devicePixelRatio = 2;
      t.view.padding = const FakeViewPadding(top: 47 * 2, bottom: 34 * 2);
      addTearDown(t.view.reset);
      t.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(t.platformDispatcher.clearAccessibilityFeaturesTestValue);
      final key = GlobalKey();
      await t.pumpWidget(
        RepaintBoundary(
          key: key,
          child: MaterialApp(debugShowCheckedModeBanner: false, theme: buildAppTheme(), home: e.value),
        ),
      );
      await t.runAsync(() async {
        for (final el in find.byType(Image).evaluate()) {
          await precacheImage((el.widget as Image).image, el);
        }
        await Future<void>.delayed(const Duration(milliseconds: 300));
      });
      await t.pump(const Duration(seconds: 2));
      await t.runAsync(() async {
        final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final img = await boundary.toImage(pixelRatio: 2);
        final png = await img.toByteData(format: ui.ImageByteFormat.png);
        Directory(_out!).createSync(recursive: true);
        File('$_out/${e.key}.png').writeAsBytesSync(png!.buffer.asUint8List());
      });
    });
  }
}

void _nop() {}

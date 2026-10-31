# UI tasks: merge port (UI agent: Claude in VS Code)

**Decision (2026-10-31):** one app. Keep the root app's logic (engine, state, level checker, tests) and bring in the finished UI from `apps/snakes_slither/` (the "old app").
The old app is now a **read-only reference**. Port its screens into `lib/ui/` so they run on the contract in `lib/contracts/`. When every screen is ported, `apps/` gets deleted (the user confirms first).

**Look (2026-10-31): premium "Jungle at dusk".** The old app is only a reference for layout, flow and animation. Every screen gets the new look in `design/premium/`: `BRAND_BOOK.md` is the rules, `tokens.json` the values, `icons/` the custom icons and `components/` the specs. The six key screens are designed in "Snakes Slither · Premium UI" (link in `design/premium/README.md`). Match them closely. Screens not drawn there follow the same system.

Give one task at a time, in order: **P1 first**, then P2–P6 in any order. Folder: `game_1_snakes_slither`.

## Rules for every port task

```
Read AGENTS.md first ("UI agent" rules).
Port, don't redesign: keep the old app's look, layout and animations, but
make each widget run on our contract.

- Source: apps/snakes_slither/lib/… (read-only, never edit it).
- Target: lib/ui/… only. Keep every existing constructor in lib/ui exactly
  as it is, and put every key from lib/contracts/app_keys.dart on the
  matching widget.
- Old widgets read blocs and services (context.read<WalletCubit>,
  AppServices, AudioService, AppLogger, routes). In lib/ui that is not
  allowed. Instead:
    · data → take it from the constructor's view-model (lib/contracts/view_models.dart)
    · actions → call the constructor's callbacks
    · sounds/haptics → UiFeedback.of(context).sound(UiSound.tap) / .haptic()
      (lib/contracts/ui_feedback.dart). Gameplay sounds are played by logic.
    · navigation → only through callbacks (no routes in lib/ui)
    · logging → drop it
- Engine types: use ours from lib/contracts/view_models.dart (Snake has an
  int id, SnakeSkin.caterpillar, Cell, Dir, SnakeColor, Booster). Don't
  import package:puzzle_core/slither_engine.dart.
- Fonts must be bundled for offline play: put Fredoka and Nunito (+ Baloo
  Bhai 2, Baloo 2) .ttf files in assets/fonts/ and declare them in
  pubspec.yaml. Don't use google_fonts runtime downloads.
- Need data or a callback the contract lacks? Add a row to
  handoff/CHANGE_REQUESTS.md and use a placeholder meanwhile.
- Done = flutter analyze clean + flutter test green.
```

## P1: premium design system and shared widgets

```
Follow the port rules above.
Build lib/ui/theme/ from design/premium/tokens.json + BRAND_BOOK.md
("Jungle at dusk", dark grounds night → dusk → canopy → moss, emerald
actions, gold rewards). Keep our existing names (AppColors incl.
AppColors.snake(SnakeColor), AppMotion, buildAppTheme) and map them onto the
new tokens; add text styles, spacing, radii and shadows as named constants.
Icons: copy design/premium/icons/** into assets/images/icons/ and render them
with flutter_svg (UI-only package, allowed). Glyphs are single-ink and may be
tinted; game icons are never recoloured.
Widgets in lib/ui/widgets/ follow design/premium/components/*.md exactly:
SsButton (primary/gold/secondary/ghost, 4px lip, sinks 3px on press),
SsIconButton, CoinPill, HeartBerries (+ shield tag), Chip, BoosterButton
(states: ready/active/zero/capped/locked/busy), SsCard, SsPopup (popupIn
300 ms ease-out-back, scrim), LevelNode. Use the old app's
apps/snakes_slither/lib/core/widgets/* only for behaviour ideas
(press animation, confetti), restyled.
Port apps/snakes_slither/lib/core/widgets/{bevel_button,popup,confetti,
garden_background,pip,game_icons,common}.dart into lib/ui/widgets/.
common.dart reads WalletCubit/AdsCubit, so turn those parts into widgets
that take values (e.g. CoinPill(coins: …, onTap: …)).
Bundle the fonts (rules above). Apply the theme app-wide via buildAppTheme().
```

## P2: board and snakes

```
Follow the port rules above.
Port apps/snakes_slither/lib/features/gameplay/render/{board_painter,
game_scene}.dart into lib/ui/board/, behind our BoardCanvas(data, geometry,
onMotionDone).
- Positions: use geometry.rectOf / centerOf / cell (BoardGeometry). Taps are
  mapped with the same geometry, so drawings must line up with it.
- Animations come from data.motion (exit / bump / locked, with lane cells
  and blocker). Call onMotionDone(motion.id) exactly once per motion.
- Overlays: data.preview (dotted lane, green/red, ✕ on blocker),
  data.hintSnakeId (firefly glow), data.hammerMode, data.colourBlind,
  data.reducedMotion. Rocks = data.board.rocks (Garden Rock).
- No gesture detectors on the board (input is ours).
```

## P3: gameplay screen

```
Follow the port rules above.
Port apps/snakes_slither/lib/features/gameplay/view/{hud,booster_bar}.dart
and the layout of gameplay_page.dart into lib/ui/screens/gameplay_screen.dart
(GameplayScreen(hud, boosters, board, hammerMode, onPause, onBooster,
onCancelHammer)). `board` is a ready widget; place it, don't wrap it in
gestures. Booster states come from BoosterButtonData (locked, capReached,
enabled, active, count).
```

## P4: in-game popups

```
Follow the port rules above.
Port into lib/ui/popups/ (you may split popups.dart into one file per popup
and re-export from popups.dart):
- popups/pause_sheet.dart + features/settings/settings_panel.dart → PausePopup, SettingsList
- popups/second_chance.dart → SecondChancePopup (keep our countdown rules:
  pause while `paused`, call onDecline at 0)
- popups/results.dart → LevelCompletePopup, LevelFailedPopup
- popups/mini_shop.dart → MiniShopSheet
- features/rewards/gift_basket_page.dart → GiftBasketPopup (rewards are
  already granted; this is the reveal, then onCollect)
```

## P5: Home and Level Map

```
Follow the port rules above.
Port features/home/home_page.dart → lib/ui/screens/home_screen.dart and
features/level_map/level_map_page.dart → lib/ui/screens/level_map_screen.dart.
Home: show only what HomeData supports today (coins, Play, Map, Shop, Spin
when wheelUnlocked, VIP chip hidden when vipActive). Leave slots for the
Daily card, Ranks and VIP buttons; they arrive with later contracts.
Map: nodes from LevelNodeData (locked / current / cleared + stars, Hard).
```

## P6: Shop and Lucky Lily Wheel

```
Follow the port rules above.
Port features/shop/shop_page.dart → lib/ui/screens/shop_screen.dart and
features/spin/spin_page.dart → lib/ui/screens/wheel_screen.dart.
Shop: Boosters tab from ShopData.tiles + free-coins tile; Coins/Offers tabs
show "Store unavailable" while !data.storeAvailable.
Wheel: segments, odds sheet, spin animation that lands on data.prizeIndex
when data.spinSeq changes, timeLocked message.
```

## Coming next (logic first, then a port task here)
Daily Jungle Puzzle and streak, Golden Slither Rush, VIP and store, age gate and consent, tutorial overlays, leaderboards, Phase Complete, Jungle Guide, Starter Pack. The logic agent ports each one's logic into our architecture, adds its contract and a placeholder, then adds a P-task here.

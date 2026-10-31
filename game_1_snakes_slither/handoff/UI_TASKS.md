# UI tasks, phase by phase (UI agent: Claude in VS Code)

**The design (2026-10-31):** the UI canvas "Snake Slither Game UI" is the design, to be matched exactly.
- Repo copy: `design/ui_canvas/<Screen>.dc.html` (HTML with exact colours, gradients, shadows, radii, fonts and animations).
- Palette and type: `design/ui_canvas/README.md`.
- Art: `design/brand/` (logo, 3D Pip renders, app icon, board and map backgrounds).

Each task says which canvas screens to build. Copy their look 1:1: the same cream backgrounds, green gradient buttons with the 4px lip and the shine, cream cards, leaf decorations, bob/pop/glow/shine animations, Fredoka + Nunito.

The canvas now has only the screens the docs describe, and gameplay is the Phase 1 puzzle (tap snakes out of a tangle). If a screen still seems to differ from the docs, the docs win; note it in handoff/CHANGE_REQUESTS.md.

Do the tasks in order. Folder: `game_1_snakes_slither`.

## Rules for every task

```
Read AGENTS.md first ("UI agent" rules).
Match the named canvas screens exactly. Read their .dc.html for exact values
(colours, gradients, shadows, radii, font sizes, spacing, animation timings).
- Edit only lib/ui/** and assets/fonts|images/**. Keep every existing
  constructor in lib/ui and every key from lib/contracts/app_keys.dart.
- Data comes from the constructor's view-model; actions go through its
  callbacks; sounds use UiFeedback.of(context). No blocs, services or routes
  in lib/ui.
- Bundle Fredoka and Nunito (.ttf in assets/fonts/, declared in pubspec.yaml).
  No runtime font downloads.
- Respect reduce-motion (MediaQuery.disableAnimations): no bobbing, shine or
  confetti; keep functional motion.
- Phones 360–430 wide: no overflow; tablets: centre a max 600 wide column.
- A screen needs data or a callback the contract lacks? Add a row to
  handoff/CHANGE_REQUESTS.md and use a placeholder meanwhile.
- The old app in apps/snakes_slither/ is only a code reference
  (read-only).
- Done = flutter analyze clean + flutter test green.
```

---

## Phase 1: launch (levels 1–500)

### U1: theme and shared widgets
```
Follow the rules above.
From design/ui_canvas/README.md and Brand.dc.html, build lib/ui/theme/:
Forest #075B35, Emerald #13864D, Leaf #A8D94F, Gold #F4B72F, Cream #F7F4E8,
Card #FFFEF8, Text #163B28, plus the exact gradients and shadows the screens
use (button gradient #23A766 → #13864D → #075B35, lip #03432A; card border
#ECE5CF; secondary button #EFE9D6 / #E2D9BE / lip #D6CBAA). Keep our names
(AppColors incl. AppColors.snake, AppMotion, buildAppTheme).
Widgets in lib/ui/widgets/ copied from the canvas: primary button (gradient,
lip, shine sweep, press-down), secondary button, cream card, coin pill with
"+", round icon button, progress bar, bottom nav, leaf decoration, popup card
with the green level badge, star (pop animation), confetti.
```

### U2: Splash and Home
```
Follow the rules above.
Canvas: Main.dc.html (Splash), AgeGate.dc.html, Home.dc.html.
- Splash → Home fade, as in the canvas.
- Home: coin pill, Pip on the platform (bobbing), the big green Play button
  (glow pulse + shine) going to the next level, the Levels card (progress
  from HomeData), the Daily card (locked until L15), and bottom nav. Phase 1
  has no gems, profile or Awards: leave those out, and use the nav slots for
  Home, Map, Shop, Ranks, Settings.
- Spin button when HomeData.wheelUnlocked (badge when freeSpinReady).
```

### U3: Level Map
```
Follow the rules above.
Canvas: LevelMap.dc.html (+ LevelStart.dc.html for the start sheet).
Winding path, node states from LevelNodeData (cleared + stars, current with
Pip, locked, Hard in red, Gift Basket on every 10th), biome header.
```

### U4: Gameplay (puzzle board in the canvas style)
```
Follow the rules above.
Canvas: Play.dc.html (the puzzle gameplay component) shown in
LevelPlay.dc.html (L12), LevelHard.dc.html (L19 Hard), LevelBonk.dc.html
(blocked tap, -1 heart), Preview.dc.html, Hint.dc.html, Hammer.dc.html.
Board.dc.html + Booster.dc.html are the board and booster art.
- HUD: pause, Level N, Moves, hearts (+ shield charges), coins.
- Board: BoardCanvas(data, geometry, onMotionDone). Draw cells with
  geometry.rectOf/centerOf, snakes in the 8 palette colours with patterns,
  Garden Rock, animations from data.motion (exit / bump / locked), preview
  lane, hint glow, hammer mode. Call onMotionDone(motion.id) once per motion.
- Booster bar: Hint, Shield, Hammer from BoosterButtonData (ready, active,
  0 = buy, capped, locked).
- No score, best, D-pad, fruit or length.
```

### U5: In-game popups
```
Follow the rules above.
Canvas: Pause.dc.html, Complete.dc.html, Failed.dc.html,
SecondChance.dc.html, MiniShop.dc.html, Gift.dc.html, Chest.dc.html,
Stuck.dc.html, LevelUnavailable.dc.html.
Map to PausePopup (+ SettingsList), LevelCompletePopup (stars, coins,
Claim 2X, Next, Map), LevelFailedPopup,
SecondChancePopup (10 s ring), MiniShopSheet, GiftBasketPopup (basket or
chest variant).
```

### U6: Shop, Lucky Lily Wheel, VIP, Starter Pack
```
Follow the rules above.
Canvas: Shop.dc.html (Boosters · Coins · Offers), Wheel.dc.html,
Vip.dc.html, Starter.dc.html.
```

### U7: Settings and Leaderboards
```
Follow the rules above.
Canvas: Settings.dc.html, Leaderboards.dc.html.
```

### U8: Daily Puzzle and Streak, Golden Slither Rush, Tutorials, Phase Complete
```
Follow the rules above. Starts when the logic agent has added these
contracts (see handoff/CONTRACT_LOG.md).
Canvas: Daily.dc.html, DailyResult.dc.html, Saver.dc.html, RushIntro.dc.html,
Rush.dc.html, RushResults.dc.html, Tutorial.dc.html, Intro.dc.html,
PhaseComplete.dc.html.
```

---

## Phase 2 (later)
Canvas: `SkinPreview.dc.html`, `Themes.dc.html` (Phase 2 cosmetic snake skins and board themes; the Shop gets a Cosmetics tab then). Weekly Star Race and Sticker Album also come in Phase 2.


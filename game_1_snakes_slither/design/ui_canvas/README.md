# Snake Slither — UI design canvas

Source files for the Snake Slither UI design canvas. It has only the screens the docs describe: every Phase 1 screen from [06 UI/UX Screens](../../phases/phase_1/06_UI_UX_SCREENS.md), in the new look, plus the two Phase 2 cosmetic screens.

Related docs: [README](../../README.md) · [Brand assets](../brand/README.md) · [Phase 1 index](../../phases/phase_1/README.md) · [06 UI/UX Screens](../../phases/phase_1/06_UI_UX_SCREENS.md) · [04 Boosters, Coins, Shop](../../phases/phase_1/04_BOOSTERS_COINS_SHOP.md)

Live canvas: https://claude.ai/artifact/VKYgfZ62KZ2s9m9eoGufNe

## Status (2026-10-31)

This canvas is the official design for the app. The code follows it exactly, phase by phase (`handoff/UI_TASKS.md`).

Cleaned up to match the docs:
- Gameplay is the Phase 1 puzzle: tap snakes out of the tangle. `Play` is the gameplay component (HUD with level, moves, hearts, coins; the garden board; the Hint, Shell and Hammer bar). Every popup draws it behind itself.
- Removed (not in any doc): classic-snake gameplay (score, best, fruit, D-pad), gems, food, the Rewards and Profile screens, and the old screen-flow board.
- Added from the docs: Age Gate (06 §5.2) and real puzzle levels L12 and L19, plus a blocked tap that costs a heart.
- Changed to the docs: Home (settings, coins, free spin, Play next level, Levels x / 500, Daily Puzzle card, nav Home · Shop · Ranks · Map · Settings), Level Map card, Pause, Level Complete (stars, coins, Claim 2X, Next, Map), Level Failed, Daily Jungle Puzzle (7-day streak ladder, Saver, trophy), Shop (Boosters · Coins · Offers with the 04 §8 prices), Leaderboards (Highest Lv · Stars · Streak), Settings (06 §5.6 list).
- Screenshots were removed because they showed the old classic screens. Open the canvas to see the screens.

## Layout

`canvas.json` lists every artboard, its position and its title.

| Row | Boards |
|---|---|
| Brand | `Brand`, `AppIcon`, `Flow` (Phase 1 flow, 06 §6) |
| 1 · Start, home, map | `Main` (Splash), `AgeGate`, `Home`, `LevelMap`, `LevelStart`, `Tutorial`, `Intro` |
| 2 · Gameplay | `LevelPlay` (L12), `LevelHard` (L19), `LevelBonk`, `Preview`, `Hint`, `Hammer`, `MiniShop`, `Stuck` |
| 3 · Popups and results | `Pause`, `SecondChance`, `Failed`, `Complete`, `Gift`, `Chest`, `PhaseComplete`, `LevelUnavailable` |
| 4 · Daily, Rush, Wheel | `Daily`, `DailyPlay`, `DailyResult`, `Saver`, `RushIntro`, `Rush`, `RushResults`, `Wheel` |
| 5 · Shop and more | `Shop`, `Starter`, `Vip`, `Leaderboards`, `Settings` |
| Phase 2 (later) | `SkinPreview`, `Themes` |
| Components | `Play` (gameplay: props mode, level, hearts, moves, par, shield, label), `Board`, `Booster`, `Pip`, `Tortoise`, `Backdrop` |

## Clickable prototype

Open the canvas in Play mode and start from Splash: Splash → Age Gate → Home → Play (Level 37) → tap the board → Level Complete → Next. Tap the hearts on the gameplay HUD to reach Level Failed. Home → Daily card → Play today → Daily Result.

## Values used on the screens

Sample values taken from the Phase 1 docs: 1,250 coins, 3 hearts, boosters unlock at L3 / L15 / L25, booster prices 60 / 150, 80 / 200, 100 / 250, coin packs ₹49 / ₹149 / ₹299 / ₹699, Starter Pack ₹79, VIP ₹20 / month, streak rewards 50 / 75 / 100 / 125 / 150 / 200 / 450. `SHARED_CORE_STANDARD.md` wins if a number differs.

## Colors and type

| Token | Hex |
|---|---|
| Forest (primary) | `#075B35` |
| Emerald (secondary) | `#13864D` |
| Leaf | `#A8D94F` |
| Gold | `#F4B72F` |
| Cream (background) | `#F7F4E8` |
| Card | `#FFFEF8` |
| Text | `#163B28` |

Headlines use Fredoka; body text, labels and numbers use Nunito.

## Format

Each `*.dc.html` file is one artboard: HTML and SVG inside `<x-dc>`, with these parts:

- `{{ }}` bindings, `sc-for` and `sc-if` blocks.
- A `class Component extends DCLogic` script whose `renderVals()` supplies the values.

Images are canvas assets (`/_blob/<id>`). The same images are in [brand](../brand/README.md). The canvas runtime provides `support.js`, which is not in this folder. Open the files in the canvas, not directly in a browser.

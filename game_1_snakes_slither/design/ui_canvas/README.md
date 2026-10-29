# Snakes Slither — UI design canvas

Source files for the Phase 1 UI design canvas (34 screens + 5 components), exported from the live Claude design canvas and aligned with the Phase 1 docs.

Related docs: [README](../../README.md) · [Phase 1 index](../../phases/phase_1/README.md) · [06 UI/UX Screens](../../phases/phase_1/06_UI_UX_SCREENS.md) · [04 Boosters, Coins & Shop](../../phases/phase_1/04_BOOSTERS_COINS_SHOP.md) · [05 Daily & Streak](../../phases/phase_1/05_DAILY_CHALLENGE_AND_STREAK.md)

Live canvas: https://claude.ai/artifact/Uqpn19QTRpb7h3k9f1yvR9

## Layout

`canvas.json` lists every artboard, its position and its title. Titles use the section numbers of [06 §5](../../phases/phase_1/06_UI_UX_SCREENS.md#5-screens).

| Row | Screens |
|---|---|
| 1 · Launch & hub | Main (5.1 Jungle Dawn intro), Home (5.3), LevelMap (5.4), Daily (5.13), Saver, Wheel (5.14) |
| 2 · Gameplay | Tutorial (5.7), Intro (5.7 card), Play (5.5), Preview, Hint, Hammer, Pause (5.6) |
| 3 · Results & rewards | SecondChance (5.8), Failed (5.9), Stuck, Complete (5.10), Gift (5.11), Rush (5.12), PhaseComplete (5.18) |
| 4 · Shop & ranks | Shop (5.15), MiniShop, Vip (5.16), Leaderboards (5.17) |
| 5 · Phase 1 flows | LevelStart (5.4 sheet), RushIntro, RushResults (5.12), DailyResult (5.13), Chest (L500 Treasure Chest), Starter (Starter Pack popup), LevelUnavailable (`E-LVL-001`) |

5.2 Age Gate is not drawn on the canvas (removed on request); the spec still requires it ([04 §11](../../phases/phase_1/04_BOOSTERS_COINS_SHOP.md#11-compliance-target-age-1050--mixed-audience)).

## Phase 1 values used on the canvas

- Boosters: 3 only — Glow Firefly Hint (L3), Safety Shell Shield (L15), Magic Stone Hammer (L25). Shop prices 60/150, 80/200, 100/250.
- Gift Basket L40: 150 coins + 1 Hint (rotation `(L/10) mod 3`).
- Lucky Lily Wheel: 20 / 50 / 100 / 75 / Hint / Shield / Hammer / 500, equal slices, odds in the ⓘ sheet.
- Streak ladder: 50 · 75 · 100+Hint · 150 · 150+Shield · 200+Hammer · 450+all 3+trophy.
- Golden Slither Rush T1: 20 snakes, 30 s, +10 per snake, +100 full clear.
- Treasure Chest L500: 1,000 coins + 2 of each booster + "Garden Hero" badge.
- Starter Pack: ₹79, 800 coins + 3 Hint + 2 Hammer + 2 Shield, 48 h window after L15.
- Stuck sheet: Restart only, no heart loss (`E-GAME-004`).

## Shared components

| File | Props | Used by |
|---|---|---|
| `Board.dc.html` | `mode` (play, thumb, hint, preview, hammer, ftue, intro, rush), `size`, `tint` | Play and every gameplay state, Rush, LevelStart |
| `Pip.dc.html` | `pose` (stand, wave, sleep, coil, face), `size` | Splash and Home (stand logo), Failed (sleep) |
| `Booster.dc.html` | `kind` (hint, shield, hammer), `size`, `dim` | Play tray, Shop, MiniShop, Gift, Chest, Starter |
| `Tortoise.dc.html` | `size` | Tutorial bubble, LevelUnavailable |

## Format

Each `*.dc.html` file is one artboard: HTML/SVG markup inside `<x-dc>` with `{{ }}` bindings, `sc-for` / `sc-if` blocks, `dc-import` for components, and a `class Component extends DCLogic` script whose `renderVals()` supplies the values. `support.js` is provided by the canvas runtime and is not part of this folder, so open the files in the canvas, not directly in a browser.

## Design tokens

- Colours: bgSage `#E8F5E9`, primary `#2E7D32`, coinGold `#FFCA28`, heart `#E53935`, splashCanopy `#12301F`.
- Fonts: Fredoka (headings, numbers) and Nunito (body).
- Snake palette: red `#FF7043`, green `#7CB342`, blue `#29B6F6`, yellow `#FFCA28`, purple `#9575CD`, orange `#FFA726`, pink `#F06292`, teal `#26A69A`.
- Realism: SVG radial and linear gradients, `feGaussianBlur` soft shadows, `feTurbulence` textures for grass, dirt, stone and wood, and layered strokes to shade the snake tubes.

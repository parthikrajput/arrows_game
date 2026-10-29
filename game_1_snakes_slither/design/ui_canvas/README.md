# Snakes Slither — UI design canvas

Source files for the Snakes Slither UI design canvas (27 artboards), exported from the live Claude design canvas.

Related docs: [README](../../README.md) · [UI specs](../../specs/ui/) · [Phase 1](../../phases/phase_1/)

Live canvas: https://claude.ai/artifact/Uqpn19QTRpb7h3k9f1yvR9

## Layout

`canvas.json` lists every artboard, its position and its title (numbers match `specs/ui` / phase_1 `06_UI_UX_SCREENS.md` §5).

| Row | Screens |
|---|---|
| 1 · Launch & hub | Main (Splash), Home, LevelMap, Daily, Saver, Wheel |
| 2 · Gameplay | Tutorial, Intro, Play, Preview, Hint, Hammer, Pause |
| 3 · Results & rewards | SecondChance, Failed, Stuck, Complete, Gift, Rush, PhaseComplete |
| 4 · Shop & ranks | Shop, MiniShop, Vip, Leaderboards |

## Shared components

| File | Props | Used by |
|---|---|---|
| `Board.dc.html` | `mode` (play, thumb, hint, preview, hammer, ftue, intro, rush), `size`, `tint` | Play and every gameplay state, Rush |
| `Pip.dc.html` | `pose` (stand, wave, sleep, face), `size` | Splash, Home, Failed, Tutorial |
| `Booster.dc.html` | `kind` (hint, undo, shield, hammer), `size`, `dim` | Play tray, Shop, MiniShop |

## Format

Each `*.dc.html` file is one artboard: HTML/SVG markup inside `<x-dc>` with `{{ }}` bindings, `sc-for` / `sc-if` blocks, `dc-import` for components, and a `class Component extends DCLogic` script whose `renderVals()` supplies the values. `support.js` is provided by the canvas runtime and is not part of this folder, so open the files in the canvas, not directly in a browser.

## Design tokens

- Colours: bgSage `#E8F5E9`, primary `#2E7D32`, coinGold `#FFCA28`, heart `#E53935`.
- Fonts: Fredoka (headings, numbers) and Nunito (body).
- Snake palette: red `#FF7043`, green `#7CB342`, blue `#29B6F6`, yellow `#FFCA28`, purple `#9575CD`, orange `#FFA726`, pink `#F06292`, teal `#26A69A`.
- Realism: SVG radial and linear gradients, `feGaussianBlur` soft shadows, `feTurbulence` textures for grass, dirt, stone and wood, and layered strokes to shade the snake tubes.

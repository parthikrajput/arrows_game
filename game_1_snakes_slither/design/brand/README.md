# Snake Slither — brand assets

The logo, app icon, mascot, skins, themes and gameplay renders used on the new UI canvas, plus the source files that make them.

Related docs: [UI canvas](../ui_canvas/README.md) · [Old app icon](../app_icon/README.md) · [06 UI/UX Screens](../../phases/phase_1/06_UI_UX_SCREENS.md)

## Files

| File | What it is |
|---|---|
| `snake_slither_logo.png` | 3D game logo: mascot on leaves over a wooden sign, gold "SNAKE" and cream "SLITHER". Transparent PNG. |
| `snake_slither_icon_1024.png` | App icon, 1024 × 1024, no text, full bleed. The stores apply their own masks. |
| `renders/home_platform.png` | Mascot on the green and gold platform (Home). |
| `renders/hero_leaves.png`, `hero_plain.png` | Mascot with or without leaves and grass. |
| `renders/sad.png`, `sleep.png` | Sad mascot (Level Failed) and sleeping mascot. |
| `renders/skin_*.png` | The 6 skins as shop cards: green, red, blue, rainbow, gold, ninja. |
| `renders/preview_*.png` | The 6 skins on the platform with leaves (Skin Preview). |
| `renders/board_forest.jpg` | Gameplay board: segmented snake, apples, bushes and rocks. |
| `renders/map_bg.jpg` | Level Map background. |
| `renders/theme_*.jpg` | Theme previews: forest, desert, snow, space, beach, candy. |

## Source

All 3D renders come from three.js (`three@0.160.0`). The logo is an HTML page with the mascot render and SVG text.

| File | Use |
|---|---|
| `source/mascot.html` | Mascot. Query params: `skin` (green, red, blue, rainbow, gold, ninja), `pose` (hero, sad, sleep), `base` (none, island, platform), `leaves=1`, `bg` (none, forest, cream), `size` or `w` / `h`, `fov`, `ty`. |
| `source/board.html` | Gameplay board and theme previews. Query params: `theme`, `snake=0`, `fruit=0`, `props`, `skin`, `w`, `h`, `fov`, `cy`, `cz`. |
| `source/logo.html` | Logo layout. Needs `out/hero_leaves.png` and the Lilita One font from `@fontsource/lilita-one`. |
| `source/render2.js` | Renders a WebGL page to PNG with Playwright: `node render2.js "mascot.html?size=1024&skin=gold" out.png`. |
| `source/shot.js` | Screenshots an HTML element with a transparent background (used for the logo). |
| `source/v2_*.py` | Generators for the new canvas screens and boards. They write into the canvas project folder; edit the paths at the top before running. |

Example commands:

- App icon: `mascot.html?size=1024&bg=forest&base=island&leaves=1&fov=29&ty=1.4`
- Home mascot: `mascot.html?size=1200&base=platform`

Crop transparent renders to their content before use.

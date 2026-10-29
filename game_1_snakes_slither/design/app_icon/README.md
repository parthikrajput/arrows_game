# Snake Slither — app icon

Premium 3D app icon: a glossy emerald snake coiled on a small grass island, deep forest-green background, soft key light from the upper left and a lime rim light.

> Replaced: the current icon and logo are in [brand](../brand/README.md). This folder keeps the earlier icon for reference.

Related docs: [Brand assets](../brand/README.md) · [UI canvas](../ui_canvas/README.md) · [06 UI/UX Screens](../../phases/phase_1/06_UI_UX_SCREENS.md)

| File | What it is |
|---|---|
| `snake_slither_icon_1024.png` | Final icon, 1024 × 1024, full-bleed (no text, no border, no mask) — upload as-is; Play Store and App Store apply their own masks |
| `snake_preview_sheet.png` | Preview at full size, iOS rounded mask, Android circle and 48 px |
| `snake.html` | three.js source scene. Render: serve this folder with `three@0.160.0` in `node_modules`, open `snake.html?size=2048`, save the canvas, downscale to 1024 |

For Android adaptive icons, keep the snake head inside the central 66% safe zone (it is); the grass island edge may be clipped by round masks, which is intended.

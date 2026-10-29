Source docs: phase_1/06_UI_UX_SCREENS.md, SHARED_CORE_STANDARD.md

# Spec: UI/UX Screens and Visual Architecture

## Status
Draft

## Type
New Feature

## Goal
Specify the design tokens, soft-3D art style, responsive layout engine, accessibility standards, and all 18 screens and dialogs for Ants & Bees: Garden Trails Phase 1.

## Current State
Design documented in phase_1/06_UI_UX_SCREENS.md and SHARED_CORE_STANDARD.md, not yet implemented.
- 2D `CustomPainter` rendering with "soft 3D" visual treatment (radial/linear gradients, rim highlights, and pre-baked soft sprite shadows).
- 18 distinct screens, dialogs, and overlays in portrait mode.
- Strict touch targets >= 44x44 dp; board cells >= 29 dp on 360 dp screens.
- Zero pinch-to-zoom in Phase 1 (supported in Phase 2 for larger boards).
- Full color-blind glyph accessibility on all colored lines and gates.

## Proposed Change
Implement the visual design system, widget library, and screen flows in `apps/ants_bees/lib/features/`:

### 1. Design Tokens
- **Primary Garden Greens:** `gardenLawn` (`#81C784`), `gardenDeep` (`#2E7D32`), `gardenAccent` (`#4CAF50`).
- **Honey & Coin Golds:** `honeyAmber` (`#FFA000`), `honeyGold` (`#FFC107`), `nectarGlow` (`#FFE082`).
- **Air Layer Accents:** `skyCyan` (`#03A9F4`), `skyBreeze` (`#E1F5FE`).
- **Earth & Rims:** `soilBrown` (`#795548`), `richEarth` (`#4E342E`), `barkDark` (`#3E2723`).
- **Status & Alerts:** `heartRed` (`#F44336`), `alertPink` (`#FFEBEE`), `mistSlate` (`#455A64`).
- **Neutral Backgrounds:** `gardenPaper` (`#F9FBE7`), `white` (`#FFFFFF`).

### 2. Accessibility & Ergonomics
- **Color-Blind Glyphs:** Head insects and petal gates feature unique geometric symbols embedded into the texture (Circle = Red, Diamond = Blue, Triangle = Green, Square = Yellow, Star = Purple, Cross = Orange).
- **Layer Distinctions:** Ants walk with clear ground shadows; bees float with 6 dp upward vertical offset, 12 Hz wing flutter, and soft ambient shadow offset down-right.
- **Scent Trail Symbols:** Clear trail ends with a green circle checkmark; blocked trail ends with a red hexagon cross.
- **System Settings:** Honors OS "Reduce Motion" (eliminates screen shake, camera zooms, and reduces particle effects).
- **Target Sizes:** All UI interactive buttons are >= 48x48 dp.

### 3. Responsive Layout Engine
- Supports mobile portrait ratios (16:9 through 21:9).
- On tablets (4:3), board width is constrained to max 540 dp with decorative garden vine side borders.
- Board container dynamically computes cell dimension: $cellSize = \min(availableWidth / cols, availableHeight / rows)$. For 11x11 on 360 dp screen with 16 dp gutters, $cellSize \approx 29.8\text{ dp}$.

### 4. Catalog of 18 Screens and Dialogs
1. **Splash Screen:** Immediate system splash handoff to "Garden Flight" intro (1,200 ms on first start, 450 ms short start).
2. **Home Screen:** Sunny garden title, Beekeeper VIP status, Play button, Sunflower Spin access, Settings icon, and Daily Almanac card.
3. **Level Map Screen:** Winding garden pathway through meadow and orchard biomes with level pins (1–500), star counts, and chapter chests.
4. **Gameplay HUD:** Top bar (Pause button, Level number, Move counter, 3 Hearts display); Board area; Bottom booster bar (Hint, Shield, Hammer, with inventory count badges and unlock locks).
5. **Pause Dialog:** Resume, Retry, Audio toggles, Home button.
6. **Settings Dialog:** Sound FX toggle, Music toggle, Haptics toggle, Battery Saver toggle, Language selector, Age Gate reset, and Restore Purchases.
7. **Level Complete Screen:** Animated 3-star reveal, coin reward increment animation, next level CTA, and replay button.
8. **Level Failed Screen:** 0 hearts empty tray, level indicator, retry button (free), and map CTA.
9. **Second Chance Popup:** 10-second circular countdown ring, "+1 Heart Rewarded Ad" button (1 per level), "Honey Heart Refill 120 Coins" button (max 2/attempt), and "No Thanks" option.
10. **Shop Screen:** Coin bundles, booster multi-packs, Starter Pack (48h timer), Beekeeper VIP pass, and free rewarded ad coins.
11. **Daily Garden Almanac Dialog:** Calendar grid, current weekday modifier card, play daily challenge CTA, and 7-day streak reward track.
12. **Sunflower Spin Dialog:** 8-segment rotary wheel with spinning petal indicator, free spin button, and rewarded ad extra spin button.
13. **Queen's Gift Box Popup:** Flower-box opening animation with confetti, displaying awarded coins and free booster.
14. **Golden Nectar Rush Screen:** 30-second rapid timer header, honey drop counter, and completion bonus banner.
15. **Royal Honey Chest Popup (L500):** Grand golden chest opening with confetti burst, awarding 1,000 coins, 2 of each booster, and the Garden Guardian badge.
16. **Beekeeper VIP Sheet:** Feature perks breakdown, ₹20/month terms disclosure, subscription purchase CTA.
17. **Neutral Age Gate Dialog:** Age verification wheel selector (ages 10–50) with neutral prompt.
18. **Color-Blind Settings Dialog:** Preview swatch showing high-contrast symbol overlays.

## Affected Files
- `apps/ants_bees/lib/features/ui/theme/garden_theme.dart` (to be created)
- `apps/ants_bees/lib/features/ui/theme/color_tokens.dart` (to be created)
- `apps/ants_bees/lib/features/ui/screens/home_screen.dart` (to be created)
- `apps/ants_bees/lib/features/ui/screens/map_screen.dart` (to be created)
- `apps/ants_bees/lib/features/ui/screens/gameplay_screen.dart` (to be created)
- `apps/ants_bees/lib/features/ui/dialogs/pause_dialog.dart` (to be created)
- `apps/ants_bees/lib/features/ui/dialogs/second_chance_dialog.dart` (to be created)
- `apps/ants_bees/lib/features/ui/dialogs/level_complete_dialog.dart` (to be created)
- `apps/ants_bees/lib/features/ui/dialogs/settings_dialog.dart` (to be created)
- `apps/ants_bees/lib/features/ui/widgets/booster_tray.dart` (to be created)

## Risks
- Small cell sizes on 11x11 boards on compact phones (e.g. 320 dp) could cause mistaps if hit slop is insufficient. 0.5-cell hit slop is mandated.

## Open Questions
- None. Screen wireframes and token specifications correspond to phase_1/06_UI_UX_SCREENS.md.

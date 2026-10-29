Source docs: phase_1/06_UI_UX_SCREENS.md, ../../SPLASH_AND_INSTANT_LAUNCH.md

# Spec: UI/UX Screens, Design Tokens and Navigation Flows

## Status
Draft

## Type
New Feature

## Goal
Implement the design tokens, accessibility standards, responsive layout engine, and full screen hierarchy for Snakes Slither Phase 1.

## Current State
Design documented in phase_1/06_UI_UX_SCREENS.md and ../../SPLASH_AND_INSTANT_LAUNCH.md, not yet implemented.
- Visual style: soft 3D minimal / claymorphism, pastel garden colors, pre-baked shadows, bevel 3D buttons.
- Minimum cell size: 29 dp on 360 dp width phone screens with 11x11 maximum grid.
- Accessibility: Persistent color-blind patterns on all snake skins; text scaler support up to 2.0; reduced motion support.
- 18 core screens and popups.
- Instant launch: No Flutter loading screen or progress bar; first frame is Home.

## Proposed Change
Implement the design system and screen widgets in Flutter:

### 1. Design Tokens
- **Palette:**
  - `bgSage` (`#E8F5E9`): Primary app background and Garden Meadow board tint.
  - `bgCream` (`#FFFBF2`): Modal dialogs, cards, popup backgrounds.
  - `surface` (`#FFFFFF`): Bottom sheets, shop tiles.
  - `surfaceAlt` (`#F7F9FA`): Disabled tiles, row backgrounds.
  - `primary` (`#2E7D32`): Green 3D action buttons (contrast >= 4.5:1 against white).
  - `primaryLight` (`#66BB6A`): Top button bevel gradient highlight.
  - `coinGold` (`#FFCA28`) & `coinGoldDark` (`#B8860B`): Coins, stars, borders.
  - `heart` (`#E53935`): Heart berries.
  - `danger` (`#C62828`): Destructive buttons, blocked preview marker (`#D32F2F`).
  - `previewClear` (`#2E7D32`) & `previewBlocked` (`#D32F2F`): Long-press dotted lane colors.
  - `textPrimary` (`#1B2B1F`), `textSecondary` (`#5B6B5F`), `textDisabled` (`#9AA59D`).
  - `scrim`: `Colors.black.withValues(alpha: 0.45)`.
  - `vipPurple` (`#7E57C2`): VIP badge and paywall banners.
- **Snake Palette (Colour + Persistent Pattern + Color-Blind Head Tag):**
  - `red` (`#FF7043`): Polka dots pattern (●)
  - `green` (`#7CB342`): Leaf veins pattern (🍃)
  - `blue` (`#29B6F6`): Cross stripes pattern (≡)
  - `yellow` (`#FFCA28`): Zigzag pattern (⚡)
  - `purple` (`#9575CD`): Diamonds pattern (◆)
  - `orange` (`#FFA726`): Rings pattern (◎)
  - `pink` (`#F06292`): Tiny hearts pattern (♥)
  - `teal` (`#26A69A`): Chevrons pattern (➤)
- **Typography:**
  - Display / Headings / Buttons / HUD tabular digits: `Fredoka` (weights 600).
  - Body text / Captions: `Nunito` (weight 500).
  - Locale Fallbacks: `Baloo Bhai 2` for Gujarati, `Baloo 2` for Hindi.
- **Elevation & Radii:**
  - `elev1` (cards blur 12, offset 0,4); `elev2` (popups blur 24, offset 0,8); `bevelLip` (button bottom shadow offset 0,4).
  - Border radii: `xs 8` (badges), `sm 12` (chips), `md 16` (buttons, tiles), `lg 24` (sheets, popups), `pill 999`.

### 2. Layout & Responsive Sizing
- Phones locked to portrait. Tablets (shortest side >= 600 dp) support portrait and landscape.
- **Board Cell Calculation:**
  `cell = floor(min((availWidth - 32) / cols, availHeight / rows))`
  Where `availHeight = screenHeight - safeTop - safeBottom - HUD(64) - boosterBar(88) - bannerReserve(height + 8) - 16`.
- Minimum cell size is guaranteed >= 29 dp across all 11x11 boards on 360 dp width devices.
- On tablets, board width is clamped to 600 dp with decorative jungle borders. In landscape, HUD stays at top, booster bar docks to right side, banner stays at bottom.

### 3. Screen Specifications & Components
1. **Splash & Launch Intro:** Replaced by native Android 12 SplashScreen API + "Jungle Dawn" Flutter intro transition over live Home screen (no progress bar).
2. **Age Gate & Consent Screen:** Neutral birth-year scroll wheel (no age pre-selection). Under-13 triggers child-directed flags. UMP consent form follows for EEA/UK users.
3. **Home Screen:** Top bar with coin pill and settings cog. Daily Challenge card with today's silhouette and modifier. Central Pip character illustration. Primary "PLAY LEVEL X" button. Quick access buttons: Spin, Shop, Leaderboards. VIP status chip. Bottom anchored banner.
4. **Level Map Screen:** Winding vine path with 500 nodes (`ListView.builder` virtualized). Node states: locked, current (pulsing), cleared with stars, Hard (red paw), Milestone (gift basket), Intro ("NEW!"). Biome headers. Jump-to-current FAB.
5. **Gameplay Screen & HUD:** 64 dp top HUD showing Pause, Level badge, 3 Heart berries (or Shield shell overlay), Coins, Moves counter, Gem counter (M026), and Mongoose HP (M049). Central interactive board. 88 dp bottom booster bar with 3 buttons (Hint, Shield, Hammer) and count badges. Reserved banner area (L11+).
6. **Pause & Settings Dialog:** Resume, Restart (confirmation prompt), Map, Home buttons. Audio toggles (Sound, Music, Haptics). Accessibility toggles (Colour-blind mode, Brighter nights, Battery Saver). Language dropdown. Jungle Guide (unlocked cards). Spin odds. Privacy choices & "Share diagnostics" toggle. "Report a problem" entry.
7. **Tutorial Overlays:** Semi-transparent scrim with cut-out over target, animated tutorial hand, Grandpa Tortoise dialog bubbles. Mechanic intro cards showing name, 1-line rule, 3-frame animation loop, and "Got it" button.
8. **Second Chance Popup:** Pip illustration with broken heart berry. 10-second circular countdown ring (pauses during sheet opens). Rewarded Ad button ("Watch ad +1 Heart", 1/level). Heart Berry Refill button ("120 Coins +1 Heart", max 2/attempt). "No thanks" text button.
9. **Level Failed Popup:** Sad Pip graphic. "Try again" primary button. Home secondary button. Rotating contextual gameplay tip.
10. **Level Complete Popup:** Falling confetti leaves (disabled in reduced-motion). Stars animating in with rising pitches. Coins earned breakdown. 2X Win rewarded ad button (first clears only). "Next Level" primary button. Map secondary button.
11. **Jungle Gift Basket & Treasure Chest Popups:** Animated shaking basket/chest, burst on tap, reward chips flying to wallet. Next button.
12. **Golden Slither Rush Screen:** 3-2-1 countdown, 30s top timer bar, golden snake grid, collected coins counter, snakes remaining counter. Results sheet with full clear bonus badge.
13. **Daily Jungle Puzzle Screen:** Date, silhouette graphic, weekday modifier badge, 7-day streak ladder with coin/booster milestones, Golden Coil Trophy display, Streak Saver status banner, calendar history.
14. **Lucky Lily Wheel Screen:** 8-segment wheel with golden lily jackpot, "Spin free" button, "Watch ad spin" button, "i" odds disclosure modal.
15. **Shop Screen:** 3 tabs: Boosters (coin purchases), Coins (IAP coin packs with Popular/Best Value badges), Offers (Starter Pack 48h countdown, VIP subscription card). Free coins rewarded ad tile (5/day). "Restore purchases" link.
16. **VIP Paywall Screen:** ₹20/month subscription benefits (no banners, no interstitials), store terms, Subscribe primary button.
17. **Leaderboards Screen:** Tabs for Highest Level, Total Stars, Total Streak Days. Local stats card and Play Games / Game Center sign-in button.
18. **Phase Complete Screen:** Level 500 completion. "Garden Hero" badge, final stars tally, "Phase 2 Coming Soon" banner, Replay button.

## Design
- **Screens Affected:** All 18 screens and dialogs listed above.
- **Existing Components Reused:** Common design tokens, `BevelButton`, `CoinPill`, `BadgeIcon`.
- **New Components Created:** `BoardView`, `BoosterBar`, `CountdownRing`, `WheelPainter`, `VineMapPath`, `LoggedTap`.
- **Design Tokens:** Hex tokens defined in Section 1; typography styles in Section 1.
- **Reference Screens:** Follows `phase_1/06_UI_UX_SCREENS.md` wireframes and layouts.
- **Platform Differences:** Portrait orientation locked on mobile phones; adaptive centered board with side-docked controls on tablets; platform-specific back button behavior.

## Affected Files
- `apps/snakes_slither/lib/app/theme/tokens.dart` (to be created)
- `apps/snakes_slither/lib/app/theme/text_styles.dart` (to be created)
- `apps/snakes_slither/lib/features/home/view/home_page.dart` (to be created)
- `apps/snakes_slither/lib/features/level_map/view/level_map_page.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/view/gameplay_page.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/view/hud.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/view/booster_bar.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/view/second_chance_dialog.dart` (to be created)
- `apps/snakes_slither/lib/features/gameplay/view/level_complete_dialog.dart` (to be created)
- `apps/snakes_slither/lib/features/settings/view/settings_page.dart` (to be created)

## Risks
- Banner ads in gameplay: layout height must be rigidly pre-reserved to prevent jumping when AdMob loads.
- Large font scale (up to 2.0x): text widgets must gracefully wrap without truncating critical game information.

## Open Questions
- In `phase_1/06 §5.5`, the gameplay wireframe sketch showed 4 booster buttons ("🪲✨2  🌀2  🐚1  🔨1") from an earlier draft that included a 4th booster (Flute); the actual gameplay specification uses exactly 3 booster buttons (Hint, Shield, Hammer) plus free long-press preview.

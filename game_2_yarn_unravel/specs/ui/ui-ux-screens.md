Source docs: phase_1/06_UI_UX_SCREENS.md, ../../SPLASH_AND_INSTANT_LAUNCH.md, ../../SHARED_CORE_STANDARD.md

# Spec: UI/UX Screens, Design Tokens and Navigation Flows

## Status
Draft

## Type
New Feature

## Goal
Implement the design tokens, color-blind accessibility system, responsive layout engine, and full screen hierarchy for Yarn Unravel Phase 1.

## Current State
Design documented in phase_1/06_UI_UX_SCREENS.md and ../../SPLASH_AND_INSTANT_LAUNCH.md, not yet implemented.
- Visual theme: cozy tactile craft / needlework aesthetic featuring birch wood frames, cream linen cloth, soft wool threads, and pre-baked button bevels.
- Minimum cell size: 29 dp on 360 dp width phone screens for maximum 11x11 grid boards.
- Accessibility: persistent patterns and needle icons on all 8 thread colors; 48 dp touch targets; text scaling support up to 1.3x; reduced motion support.
- 18 core screens, dialogs, and overlays.
- Instant launch: system splash hands off directly to Home without Flutter loading screens.

## Proposed Change
Implement the design system and screen widgets in Flutter:

### 1. Design Tokens
- **Palette:**
  - `bgLinen` (`#FFF9F0`): Primary background and craft board linen fabric.
  - `bgWoodDark` (`#3A2A22`) & `bgWoodLight` (`#6D4C41`): Birch craft board frame and shelf headers.
  - `surface` (`#FFFFFF`): Popup cards, bottom sheets, dialogue backgrounds.
  - `surfaceAlt` (`#F5EBE1`): Inactive buttons, card containers, disabled states.
  - `primaryBtn` (`#E07A5F`): Terracotta/salmon 3D primary action buttons (contrast >= 4.5:1 against white).
  - `primaryBtnLight` (`#F2967D`): Top button bevel highlight.
  - `coinGold` (`#FFCA28`) & `coinGoldDark` (`#B8860B`): Coins, stars, borders.
  - `heart` (`#E25C6A`): Stitched felt hearts.
  - `danger` (`#D32F2F`): Destructive buttons, blocked preview markers.
  - `previewClear` (`#7ED321`) & `previewBlocked` (`#E25C6A`): Thread Peek chain-stitch colors.
  - `textPrimary` (`#2E1E14`), `textSecondary` (`#6E5A4E`), `textDisabled` (`#A89689`).
  - `scrim`: `Colors.black.withValues(alpha: 0.45)`.
  - `vipPurple` (`#7E57C2`): VIP badge and paywall banners.

- **Thread Color-Blind Palette (Color + Persistent Texture + Needle Eye Icon):**
  1. `red` (`#E25C6A`): Cross-stitch pattern (✕) / Heart needle icon
  2. `blue` (`#4A90E2`): Zigzag pattern (⚡) / Teardrop needle icon
  3. `yellow` (`#F5A623`): Polka dots pattern (●) / Star needle icon
  4. `green` (`#7ED321`): Herringbone pattern (≫) / Leaf needle icon
  5. `purple` (`#9013FE`): Diamonds pattern (◆) / Gem needle icon
  6. `orange` (`#F38118`): Stripes pattern (≡) / Sun needle icon
  7. `pink` (`#FF6F91`): Wave pattern (~) / Flower needle icon
  8. `teal` (`#00B4D8`): Chevrons pattern (▲) / Triangle needle icon

- **Typography:**
  - Headings / Buttons / HUD tabular numerals: `Fredoka` (font weight 600).
  - Body copy / subtitles: `Nunito` (font weight 500).
  - Locale Fallbacks: `Baloo Bhai 2` for Gujarati, `Baloo 2` for Hindi.

- **Elevation & Radii:**
  - `elevCard` (blur 12, offset 0, 4); `elevPopup` (blur 24, offset 0, 8); `bevelLip` (button bottom shadow offset 0, 4).
  - Border radii: `xs: 8` (badges), `sm: 12` (chips), `md: 16` (buttons, tiles), `lg: 24` (sheets, dialogs), `pill: 999`.

### 2. Layout & Responsive Sizing
- Phones locked to portrait orientation. Tablets (shortest side >= 600 dp) support portrait and landscape.
- **Board Cell Calculation:**
  `cell = floor(min((availWidth - 32) / cols, availHeight / rows))`
  - On 360 dp width devices with 11x11 grid, `cell >= 29 dp`, ensuring touch targets meet minimum standards.
- Safe Area padding applied to HUD and navigation bars.

### 3. Screen Hierarchy & Flows (18 Screens)
1. **System Splash & Instant Launch:** Immediate native handoff into "Hearth & Thread" intro animation; TTID <= 600 ms.
2. **Age Gate & UMP Consent Dialog:** First-run neutral age selection (below 13 vs 13+) and Google UMP consent banner.
3. **Home Screen:** Shows logo, Purl the kitten mascot, Play Level CTA, Coin balance pill, 7-day streak icon, Spinning Wheel button (after L10), Daily Stitch button (after L15), Shop icon, and Settings icon.
4. **Level Map Screen:** Vertical scrolling craft-ribbon map with wooden nodes, biome backdrops, star ratings, and "Hard" warning ribbons on x9 nodes.
5. **Gameplay Screen:**
   - Top HUD: Pause button, Level Number, Stitched Felt Hearts (3), Move counter.
   - Central View: Craft Board with linen cloth and wooden frame.
   - Bottom HUD: Needle Glow Hint, Thimble Shield, and Golden Scissors booster buttons with inventory counters; bottom banner ad container (L11+).
6. **Pause Dialog:** Resume, Sound/Haptics toggles, Restart (costs 0 coins; retains current heart count for level), and Level Map navigation.
7. **Thread Peek Overlay:** Long-press visual layer displaying green/red chain-stitch preview rays.
8. **Second Chance Popup ("Tangled Up!"):** Triggered at 0 hearts. 10-second countdown ring, Rewarded Ad revive button (1/level), and Heart Refill button (120 Coins).
9. **Level Failed Screen:** Purl offering comforting expression; Free Retry CTA and Home CTA.
10. **Level Complete Screen:** Star reveal celebration, base coin earnings, first ★★★ bonus (+20), 2X Win rewarded ad CTA, Next Level CTA, and Purl button-confetti shower.
11. **Craft Basket Dialog (Gift Box):** Triggered on x0 wins; wooden sewing basket opening to grant coins + rotating booster.
12. **Grand Sewing Chest Dialog:** Level 500 finale popup granting 1,000 Coins + 2 of each booster + Phase 1 Master Badge.
13. **Golden Bobbin Rush Screen:** 30-second bonus round view with giant yarn spools, countdown timer, and live coin counter.
14. **Daily Stitch View:** Weekday challenge board with calendar header, silhouette preview, and modifier badge.
15. **Streak Dialog & Darning Patch:** 7-day reward calendar view and missed-day streak saver popup.
16. **Spinning Wheel Dialog:** Radial prize wheel with 8 wedges, free spin CTA, and odds disclosure info sheet.
17. **Shop Sheet:** Modal bottom sheet displaying coin packs (₹49, ₹99, ₹249), 48h Starter Pack, VIP No-Ads subscription banner, and free coin ad button.
18. **Settings Dialog:** Audio, music, haptic switches; language selector (EN, GU, HI); Reduce Motion toggle; Battery Saver toggle; Restore Purchases button; Privacy Policy link.

## Affected Files
- `apps/yarn_unravel/lib/theme/tokens.dart` (to be created)
- `apps/yarn_unravel/lib/theme/thread_palette.dart` (to be created)
- `apps/yarn_unravel/lib/theme/typography.dart` (to be created)
- `apps/yarn_unravel/lib/features/home/view/home_view.dart` (to be created)
- `apps/yarn_unravel/lib/features/game/view/game_screen.dart` (to be created)
- `apps/yarn_unravel/lib/features/rewards/view/level_complete_dialog.dart` (to be created)
- `apps/yarn_unravel/lib/features/rewards/view/second_chance_dialog.dart` (to be created)
- `apps/yarn_unravel/lib/features/settings/view/settings_dialog.dart` (to be created)

## Risks
- Small 29 dp cells on 11x11 boards must rely on hit-slop and thread body tap priorities to avoid mis-taps.
- Text scaling at 1.3x must not cause button labels to wrap awkwardly or overflow modal containers.

## Open Questions
- None. Token values, color-blind mapping, and screen specifications match phase_1/06 and SHARED_CORE_STANDARD.md.


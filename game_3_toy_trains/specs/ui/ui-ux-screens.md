Source docs: phase_1/06_UI_UX_SCREENS.md, ../../SHARED_CORE_STANDARD.md

# Spec: UI/UX Screens and Design System (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Implement the wooden railway design tokens, typography, color-blind accessibility patterns, responsive layout contracts, and wireframe specs for all 18 Phase 1 screens and dialogs for Toy Trains.

## Current State
Design documented in phase_1/06_UI_UX_SCREENS.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- Honey-oak tabletop visual aesthetic with satin-painted toy trains and brass accents.
- Responsive layout supporting phones (360 dp width) up to tablets without camera zoom/pan in Phase 1 (cell size >= 29 dp).
- Color-blind accessible palette pairing all 8 train colors with unique geometric surface patterns and engine icons.
- Complete specification for 18 primary screens, modal dialogs, and sheets.

## Proposed Change
Build the design system tokens, widget library, and screen layouts in `apps/toy_trains/lib/theme/` and `apps/toy_trains/lib/features/`:

### 1. Design Tokens
- **Color Palette:**
  - `tableOak`: `#F3E9DC` (honey oak tabletop canvas)
  - `tableOakDark`: `#E5D4C0` (grid peg dots, card borders)
  - `trackTie`: `#C89D7C` (wooden railway ties)
  - `trackRail`: `#8D7B68` (steel-tone rails)
  - `ink`: `#2B2B2A` (high-contrast text >= 7:1)
  - `inkMuted`: `#6B5E52` (subtitles and secondary labels)
  - `surface`: `#FFFFFF` (modal sheets and card backgrounds)
  - `brass`: `#C9A227` (coins, VIP badges, button borders)
  - `ctaGreen`: `#2E7D32` (primary CTA buttons)
  - `dangerRed`: `#C62828` (hard badges, blocked route markers)
  - `previewGreen`: `#43A047` (clear route preview dotted line)
  - `heartActive`: `#E53935` (wooden heart tokens)
  - `heartLost`: `#CFD8DC` (depleted heart slots)
  - `shieldBlue`: `#1E88E5` (cowcatcher shield overlay)
  - `rushGold`: `#FFD54F` (Coin Rush tracks and golden train highlights)
  - `scrim`: `Color(0xFF000000).withValues(alpha: 0.55)` (modal backdrops)

- **Train Livery & Color-Blind System:**
  Each train color features an embossed body pattern and an engine cowcatcher icon:
  - **Red:** `#D84315` | Horizontal stripes | Circle ●
  - **Blue:** `#1E88E5` | Polka dots | Triangle ▲
  - **Yellow:** `#FFB300` | Chevrons | Square ■
  - **Green:** `#2E7D32` | Checkerboard | Diamond ◆
  - **Purple:** `#7B1FA2` | Wavy lines | Star ★
  - **Orange:** `#EF6C00` | Diagonal hatching | Cross ✚
  - **Teal:** `#00897B` | Vertical stripes | Pentagon ⬟
  - **Pink:** `#D81B60` | Nested rings | Heart ♥

- **Typography:**
  - Display: `Baloo 2`, 32 sp, weight 800 (win celebrations, level numbers).
  - Title: `Baloo 2`, 22 sp, weight 700 (screen titles, modal headers).
  - Body: `Nunito`, 16 sp, weight 600 (tutorial text, descriptions).
  - Caption / Badge: `Nunito`, 12 sp, weight 700 (difficulty badges, timestamps).
  - Numbers: `Nunito` tabular figures, 16–20 sp, weight 800 (moves, coin counts).

- **Geometry & Animation Tokens:**
  - Radii: Small = 8 dp, Medium = 14 dp, Large = 24 dp.
  - Spacing Scale: 4, 8, 12, 16, 24, 32 dp.
  - Button Micro-interaction: scale down to 0.96 over 80 ms with `Curves.easeOut`.
  - Shadows: Pre-baked 9-patch assets (no expensive runtime GPU blur).

### 2. All 18 Phase 1 Screens & Dialogs
1. **Age Gate:** First cold start; neutral birth year picker ensuring Families Policy compliance.
2. **Home Screen:** Wooden tabletop menu with station signal Play CTA, Level Map entry, Daily Timetable ticket, Shop, Lucky Turntable, and VIP pass badge.
3. **Level Map Screen:** Vertical scrolling railway track with 500 milestone stations, tier biomes, red "Hard" badges (x9), and Gift Crate depots (x0).
4. **Gameplay Screen:**
   - Top Bar: Level badge, Wooden Hearts with Cowcatcher Shield counter, Coin balance, Moves counter / Tuesday Par goal, Pause button.
   - Central Playmat: `CustomPaint` board renderer with grid peg dots and track ties.
   - Bottom Bar: 3 booster buttons (Green Signal Hint, Cowcatcher Shield, Track Crane) with inventory count badges.
5. **Level Complete Screen:** Animated 3-star ranking sequence, earned coin tally, 2X Win rewarded ad CTA, and Next Level button.
6. **Second Chance Popup ("Back on Track?"):** 10-second circular progress ring offering Rewarded Ad revive (1/level) or Heart Refill (120 coins, max 2/attempt).
7. **Level Failed Screen:** Shows shattered train tracks, zero penalties, free Retry button, and Map navigation.
8. **Pause Menu Sheet:** Overlay offering Resume, Restart Level, Map exit, and sound/music/haptic toggles.
9. **Conductor's Gift Crate Popup:** Milestone crate unboxing (every 10 levels) granting 150–300 coins and 1 rotating booster.
10. **Grand Central Chest Popup:** Level 500 finale chest awarding 1,000 coins, 2 of each booster, and the Grand Central Conductor emblem.
11. **Golden Express Coin Rush Screen:** 30-second rapid-fire arcade round with golden express tracks and real-time coin collection HUD.
12. **Daily Timetable Run Screen:** Displays daily railway modifier card ("On-Time Run", "Steam Day", etc.), train silhouette preview, and streak progress.
13. **Express Streak Dialog:** 7-day railway calendar ladder showcasing earned and upcoming booster/coin milestones plus Streak Saver options.
14. **Lucky Turntable Dialog:** Rotating 8-segment turntable wheel with brass ticker, odds disclosure panel, and free/ad spin buttons.
15. **Shop Screen:** Tabbed catalog presenting the ₹49 Starter Pack, booster singles and 3-packs, coin bundles, and the ₹20/month VIP Conductor Pass.
16. **Settings Screen:** Volume sliders, toggles for Haptics, Battery Saver, and Reduce Motion, language selection, How to Play guide, and compliance links.
17. **Tutorial Tooltip & Hand Cards:** Contextual animated pointing finger and wooden station placard explaining new mechanics and boosters.
18. **Mini Booster Purchase Sheet:** Quick bottom sheet triggered when tapping an empty booster slot during active gameplay.

## Affected Files
- `apps/toy_trains/lib/theme/tokens.dart` (to be created)
- `apps/toy_trains/lib/theme/train_palette.dart` (to be created)
- `apps/toy_trains/lib/features/home/home_screen.dart` (to be created)
- `apps/toy_trains/lib/features/level_map/level_map_screen.dart` (to be created)
- `apps/toy_trains/lib/game/gameplay_screen.dart` (to be created)
- `apps/toy_trains/lib/game/widgets/hud.dart` (to be created)
- `apps/toy_trains/lib/game/widgets/booster_bar.dart` (to be created)

## Risks
- Small 29 dp touch targets on 11x11 boards on small screens; mitigated by hit-slop algorithm giving nearest train priority on empty taps.

## Open Questions
- None. Screen wireframes and tokens match phase_1/06 and SHARED_CORE_STANDARD.md.

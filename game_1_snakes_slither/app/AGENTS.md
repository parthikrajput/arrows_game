# Snakes Slither app — rules for every agent

Two agents build this Flutter app. Each owns separate folders, so work never overlaps.

| Folder | Owner | What's there |
|---|---|---|
| `packages/puzzle_core/` | Claude | Game rules engine (pure Dart, no Flutter) |
| `lib/features/`, `lib/state/`, `lib/data/`, `lib/services/`, `lib/app/`, `lib/main.dart` | Claude | Logic, state, saving, navigation, wiring |
| `lib/contracts/` | Claude (shared) | What screens receive. UI reads it, never edits it |
| `lib/ui/` | Antigravity | All screens, popups, board art, animations, theme |
| `assets/fonts/`, `assets/images/` | Antigravity | Fonts, art |
| `test/` | Claude | Logic and flow tests |
| `pubspec.yaml` | Shared | Antigravity may add UI-only packages and font/image assets. Don't remove or change anything else |

## Rules for UI work (Antigravity)
1. Only edit files under `lib/ui/` and `assets/fonts|images/` (plus the pubspec additions above).
2. Every screen and popup gets its data and callbacks through its constructor. **Keep each constructor exactly as it is.** Don't import anything from `lib/features`, `lib/state` or `lib/services`, and don't read blocs.
3. Put every key from `lib/contracts/app_keys.dart` on the matching widget. The tests find widgets by these keys.
4. Board: draw each cell with `geometry.rectOf()` / `geometry.centerOf()` so drawings line up with taps. Call `onMotionDone(motion.id)` exactly once after each animation. Don't add gesture detectors on the board.
5. **The game is the Phase 1 puzzle** (tap snakes out of a tangle), not classic snake.
   - **Look:** follow the brand on the UI canvas: `../design/ui_canvas/screens/*.png`, `../design/brand/` (logo, 3D Pip renders) and the colour and type table in `../design/ui_canvas/README.md`.
   - **What's on each screen, its states and accessibility:** follow `../phases/phase_1/06_UI_UX_SCREENS.md`.
   - **Ignore the canvas's classic-snake parts:** fruit, score and best score, D-pad or swipe, gems, skins, food, themes, Rewards and Profile.
   - **Reuse the canvas's "Archive" puzzle screens** (Hint, Hammer, Rush, Wheel, Board, Booster and others in `../design/ui_canvas/*.dc.html`) as layout references.
   - Copy any art you use into `assets/images/`.
6. Before you finish any task, run `flutter analyze` (no errors or warnings) and `flutter test`, which must stay green.
7. Need a new field, callback or key? Don't add it yourself. Write it in `handoff/CHANGE_REQUESTS.md`, then use a placeholder or skip that piece.
8. Use only the 3 Phase 1 boosters: Glow Firefly Hint 🪲✨, Safety Shell Shield 🐚, Magic Stone Hammer 🔨. The 🌀 icon in the doc 06 wireframes is outdated, so ignore it.

## Rules for logic work (Claude)
- Don't restyle anything under `lib/ui/`. To change a screen's contract, update `lib/contracts/`, update the matching placeholder's constructor, and note it in `handoff/CONTRACT_LOG.md`.
- Shared rule numbers live in `../SHARED_CORE_STANDARD.md`. The engine must match it.

## Commands
`flutter pub get` · `flutter analyze` · `flutter test` · `cd packages/puzzle_core && dart test` · `flutter run`

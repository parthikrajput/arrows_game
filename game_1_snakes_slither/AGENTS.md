# Snakes Slither app — rules for every agent

Three agents build this Flutter app. Each owns separate files, so work never overlaps.

| Role | Who (right now) | Task list |
|---|---|---|
| **Logic agent** | Claude (cloud session) | — (works from the docs) |
| **UI agent** | Claude in VS Code | `handoff/UI_TASKS.md` |
| **Level agent** | Antigravity | `handoff/LEVEL_TASKS.md` |

| Files | Owner | What's there |
|---|---|---|
| `packages/puzzle_core/` | Logic | Rules engine, solver, level checker (pure Dart, no Flutter) |
| `lib/features/`, `lib/state/`, `lib/data/`, `lib/services/`, `lib/app/`, `lib/main.dart` | Logic | Game flow, state, saving, navigation, wiring |
| `lib/contracts/` | Logic (shared) | What screens receive. UI reads it, never edits it |
| `test/` | Logic | Logic, flow and level tests |
| `lib/ui/` | UI | All screens, popups, board art, animations, theme |
| `assets/fonts/`, `assets/images/` | UI | Fonts, art |
| `assets/levels/` | Level | The level file `phase_1.json` |
| `phases/`, `specs/`, `design/`, all `*.md` standards | Nobody (read-only) | Docs and design references. Only change them when the user asks |
| `pubspec.yaml` | Shared | UI may add UI-only packages and font/image assets. Don't remove or change anything else |

## Rules for everyone
- Only edit the files your role owns. Need something from another role? Write it in `handoff/CHANGE_REQUESTS.md`.
- Before finishing any task, run `flutter analyze` (no errors or warnings) and `flutter test`. Both must stay green.
- The game is the **Phase 1 puzzle** (tap snakes out of a tangle), not classic snake.
- Use only the 3 Phase 1 boosters: Glow Firefly Hint 🪲✨, Safety Shell Shield 🐚, Magic Stone Hammer 🔨. The 🌀 icon in the doc 06 wireframes is outdated, so ignore it.

## UI agent
1. Every screen and popup gets its data and callbacks through its constructor. **Keep each constructor exactly as it is.** Don't import anything from `lib/features`, `lib/state` or `lib/services`, and don't read blocs.
2. Put every key from `lib/contracts/app_keys.dart` on the matching widget. The tests find widgets by these keys.
3. Board: draw each cell with `geometry.rectOf()` / `geometry.centerOf()` so drawings line up with taps. Call `onMotionDone(motion.id)` exactly once after each animation. Don't add gesture detectors on the board.
4. Look and content:
   - **Look:** follow the UI canvas brand: `design/ui_canvas/screens/*.png`, `design/brand/` (logo, 3D Pip renders) and the colour and type table in `design/ui_canvas/README.md`.
   - **What's on each screen, its states and accessibility:** follow `phases/phase_1/06_UI_UX_SCREENS.md`.
   - **Ignore the canvas's classic-snake parts:** fruit, score and best score, D-pad or swipe, gems, skins, food, themes, Rewards and Profile.
   - **Reuse the canvas's "Archive" puzzle screens** (Hint, Hammer, Rush, Wheel, Board, Booster and others in `design/ui_canvas/*.dc.html`) as layout references.
   - Copy any art you use into `assets/images/`.

## Level agent
1. Edit only `assets/levels/phase_1.json`. It holds `{"schema": 3, "phase": 1, "levels": [ … ]}`, numbered 1, 2, 3 … with no gaps.
2. Every level uses the schema v3 format from `SHARED_CORE_STANDARD.md` §12.
3. Check your work with `dart run packages/puzzle_core/bin/validate_levels.dart`. Every level must show ✓. `flutter test` runs the same checks.
4. Only use mechanics the engine supports. Right now that's **M001 Garden Rock** only. The checker rejects anything else. Ask for the next mechanic in `handoff/CHANGE_REQUESTS.md`.

## Logic agent
- Don't restyle anything under `lib/ui/`. To change a screen's contract, update `lib/contracts/`, update the matching placeholder's constructor, and note it in `handoff/CONTRACT_LOG.md`.
- Shared rule numbers live in `SHARED_CORE_STANDARD.md`. The engine must match it.

## Commands
`flutter pub get` · `flutter analyze` · `flutter test` · `cd packages/puzzle_core && dart test` · `dart run packages/puzzle_core/bin/validate_levels.dart` · `flutter run`

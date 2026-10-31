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
| `apps/snakes_slither/` | Nobody (read-only) | The old second app. UI is being ported into `lib/ui/` (see `handoff/UI_TASKS.md`); deleted once the port is done |
| `assets/audio/` | Logic | Sound effects (played via `AudioService` / `UiFeedback`) |
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
   For button and popup sounds use `UiFeedback.of(context)` (`lib/contracts/ui_feedback.dart`), never a service.
3. Board: draw each cell with `geometry.rectOf()` / `geometry.centerOf()` so drawings line up with taps. Call `onMotionDone(motion.id)` exactly once after each animation. Don't add gesture detectors on the board.
4. Look and content:
   - **Look:** follow the premium "Jungle at dusk" system in `design/premium/` (`BRAND_BOOK.md`, `tokens.json`, `icons/`, `components/`) and its screen designs (links in `design/premium/README.md`). It replaces the light look of `design/ui_canvas/` and the old app. Logo and Pip renders: `design/brand/`.
   - **What's on each screen, its states and accessibility:** follow `phases/phase_1/06_UI_UX_SCREENS.md`.
   - **Ignore the canvas's classic-snake parts:** fruit, score and best score, D-pad or swipe, gems, skins, food, themes, Rewards and Profile.
   - The old app's screens and the canvas's "Archive" puzzle screens are layout and animation references only; restyle everything to the premium system.
   - Copy any art you use into `assets/images/`.

## Level agent
1. Edit only `assets/levels/phase_1.json`. It holds `{"schema": 3, "phase": 1, "levels": [ … ]}`, numbered 1, 2, 3 … with no gaps.
2. Every level uses the schema v3 format from `SHARED_CORE_STANDARD.md` §12.
3. Check your work with `dart run packages/puzzle_core/bin/validate_levels.dart` (add `--from A --to B` for one task). No level may show ✗. `flutter test` runs the same checks.
4. All Phase 1 mechanics (M001–M049) may be used.
   - **✓** means the engine played the level and confirmed it.
   - **⏳** means a draft whose structure passes. It gets the full check once the logic agent adds its mechanic to the engine. Until then the app stops at the last playable level.
   - Drafts that later fail come back as ✗ to fix.
5. Work through `handoff/LEVEL_TASKS.md` in order (LV1 → LV13).

## Logic agent
- Don't restyle anything under `lib/ui/`. To change a screen's contract, update `lib/contracts/`, update the matching placeholder's constructor, and note it in `handoff/CONTRACT_LOG.md`.
- Shared rule numbers live in `SHARED_CORE_STANDARD.md`. The engine must match it.

## Commands
`flutter pub get` · `flutter analyze` · `flutter test` · `cd packages/puzzle_core && dart test` · `dart run packages/puzzle_core/bin/validate_levels.dart` · `flutter run`

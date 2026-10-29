Source docs: phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md, ../../SHARED_CORE_STANDARD.md

# Spec: Frontend Implementation Architecture & QA Checklist (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Implement the technical architecture, layered CustomPainter renderer with static caching, BLoC state management, pure-Dart engine separation, Hive persistence, service integrations, and QA testing matrix for Toy Trains.

## Current State
Design documented in phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- Pure Dart puzzle engine (`packages/puzzle_core`) separated from Flutter UI widgets.
- No third-party game engines (no Flame); uses Flutter `CustomPainter` driven by an on-demand `Ticker`.
- 3-layer rendering model with pre-cached static background picture to guarantee 60 fps on low-tier hardware.
- Complete QA verification matrix covering engine correctness, save persistence, ads, and compliance.

## Proposed Change
Implement the project architecture and testing harness across `packages/puzzle_core` and `apps/toy_trains/`:

### 1. Architectural Foundation
- **Framework & Engine:** Flutter 3.x stable on Dart 3, utilizing the Impeller rendering backend.
- **State Management:** `flutter_bloc` managing immutable state transitions across features.
- **Engine Layer (`packages/puzzle_core`):**
  - Pure Dart package with zero Flutter dependencies (`dart:ui` is forbidden).
  - Implements board coordinates, train path models, 9-step move resolver, mechanic tick order, BFS solver, and xoshiro128** PRNG generator.
- **Persistence:** `hive_ce` using typed binary adapters for ultra-fast startup (< 50 ms).
- **Audio & Haptics:** `AudioService` wrapping `audioplayers` (`AudioPool` for low-latency WAV SFX; `AudioPlayer` for AAC music) paired with native `HapticFeedback`.
- **Telemetry & Services:** Firebase Analytics, Crashlytics, Remote Config, `google_mobile_ads` with UMP, and `games_services`.
- **Localization:** ARB bundles supporting English, Gujarati (ગુજરાતી), and Hindi (हिन्दी).

### 2. Multi-Layer Renderer Model
`apps/toy_trains/lib/game/render/train_board_painter.dart` implements a 3-layer pipeline:
1. **Static Tabletop Layer (Cached `Picture`):**
   - Draws honey-oak playmat background, peg dot grid, track ties, passive borders, and static railway signs.
   - Recorded once into an immutable `ui.Picture` using `PictureRecorder`. Repainted only on window resize or biome changes.
2. **Dynamic Gameplay Layer (`TrainBoardPainter`):**
   - Renders moving engines, trailing carriage polylines with wheel offsets, interactive levers, rotating turntables, and Route Peek preview paths.
   - Updates during active animations via a `ChangeNotifier` linked to animation controllers.
3. **Overlay & Juice Layer:**
   - Pre-allocated particle pool painting smoke puffs, buffer-clack spark rings, win confetti, and floating coin trajectories using single-call `canvas.drawAtlas`.

- **On-Demand Ticker:** Ticker starts when a move animation or particle effect is triggered and halts completely when the board settles. A static puzzle produces 0 frames per second, conserving battery.

### 3. Input Handling & Gestures
`apps/toy_trains/lib/game/input/board_gesture_layer.dart`:
- Translates screen coordinates to board grid cells `(x, y)` based on current viewport matrix.
- Long-press threshold >= 350 ms activates Route Peek dotted preview.
- Single tap dispatches `TapCell` event to `GameBloc`.
- **Hit-Slop Resolution:** If a tap lands in an empty cell within 0.5 cells of a train car, it selects that train. Interactive railway cells (turntables, switches) always take priority over occupying train cars.
- **Input Queue Limit = 1:** While a move animation is running, at most one subsequent tap is queued; any preceding queued tap is discarded.

### 4. Local Save Schema (`save_version: 1`)
Stored in Hive box `player_save`:
```dart
class PlayerSave {
  int saveVersion = 1;
  int highestClearedLevel = 0;
  Map<int, int> levelStars = {}; // level -> stars (1-3)
  int coins = 200;
  int hints = 3;
  int shields = 1;
  int hammers = 1;
  int streakDays = 0;
  String? lastDailyDayKey;
  Map<String, bool> adRevivesUsed = {}; // "12" -> true, "daily:2026-10-29" -> true
  bool vipActive = false;
  int? vipExpiresEpochMs;
  int luckySpinLastEpochMs = 0;
  UserSettings settings = UserSettings();
}
```

### 5. Level CLI Tool (`tools/levelgen`)
Standalone Dart executable providing:
- `dart run tools/levelgen:generate --phase 1`: Generates levels 1–500 using seeded reverse construction.
- `dart run tools/levelgen:validate --file assets/levels/phase_1.json.gz`: Verifies that all 500 levels are 100% solvable with 0 hearts lost and 0 boosters, verifying D scores and FTUE move limits.
- `dart run tools/levelgen:pack`: Compresses level JSON into bundled `.gz` archive.

### 6. QA Verification Matrix
| ID | Area | Verification Criterion | Status |
|---|---|---|---|
| QA-ENG-01 | Engine | 500/500 levels pass solver validation (0 hearts, 0 boosters). | Not run |
| QA-ENG-02 | Input | Rapid tapping drops older queued taps, never causing out-of-order execution. | Not run |
| QA-ENG-03 | Collision | Buffer clack bump triggers on obstructed lane, deducts 1 heart, rolls back cleanly. | Not run |
| QA-ENG-04 | Boosters | Track Crane lifts train/obstacle; Hint pulses correct move; Shield absorbs 2 hits. | Not run |
| QA-REN-01 | Rendering | Background picture cache rebuilds only on board size change. | Not run |
| QA-REN-02 | Perf | 60 fps maintained on low-tier devices (Redmi 9A class) with 0 frame drops during bump. | Not run |
| QA-AUD-01 | Audio | Tap to sound latency <= 50 ms; music ducks during win stinger. | Not run |
| QA-MON-01 | Ads | Zero interstitials in levels 1–10; strictly 120 s cooldown between interstitials. | Not run |
| QA-CMP-01 | Compliance| Age gate shown on first cold start; under-13 flags applied to ad SDKs. | Not run |

## Affected Files
- `packages/puzzle_core/pubspec.yaml` (to be created)
- `packages/puzzle_core/lib/puzzle_core.dart` (to be created)
- `tools/levelgen/bin/main.dart` (to be created)
- `apps/toy_trains/lib/main.dart` (to be created)
- `apps/toy_trains/lib/game/bloc/game_bloc.dart` (to be created)
- `apps/toy_trains/lib/game/render/train_board_painter.dart` (to be created)
- `apps/toy_trains/lib/data/save_repository.dart` (to be created)

## Risks
- Memory footprint of unpacked level bundles; solved by streaming and parsing on demand in an isolate.

## Open Questions
- None. Architecture patterns and testing contracts align with phase_1/07 and SHARED_CORE_STANDARD.md.

Source docs: phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md, SHARED_CORE_STANDARD.md

# Spec: Frontend Architecture, Engine Integration, and QA Matrix

## Status
Draft

## Type
New Feature

## Goal
Establish the technical architecture for Ants & Bees: Garden Trails Phase 1, including the modular Flutter app structure, integration with the pure-Dart `puzzle_core` engine, custom rendering pipeline, persistence, and automated QA verification.

## Current State
Design documented in phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md and SHARED_CORE_STANDARD.md, not yet implemented.
- Pure Dart engine `packages/puzzle_core` handles all mathematical simulation, collision checks, move resolution, and solver validation.
- Flutter app `apps/ants_bees` manages rendering via `CustomPainter`, state via `flutter_bloc`, local storage via `hive_ce`, and third-party platform plugins.
- CI pipeline validates that all 500 levels are solvable with 0 hearts and 0 boosters.

## Proposed Change
Implement the modular repository structure and quality assurance framework:

### 1. Repository & Package Layout
```
c:\test\game_4_nature_ants_bees\
├── packages\
│   └── puzzle_core\                      # Pure Dart engine (zero Flutter dependencies)
│       ├── lib\src\models\               # Board, Path, Cell, Mechanic, Move
│       ├── lib\src\engine\               # MoveResolver, LayerRules, TurnPipeline
│       ├── lib\src\mechanics\            # M001 to M049 mechanic logic
│       └── lib\src\solver\               # Deterministic CI forward solver & validator
└── apps\
    └── ants_bees\                        # Flutter Application
        ├── lib\features\gameplay\        # GameBloc, BoardRenderer, InputHandler
        ├── lib\features\economy\         # EconomyBloc, Wallet, Shop, Boosters
        ├── lib\features\daily\           # DailyBloc, Almanac, Streak
        ├── lib\features\audio\           # AudioService, HapticService
        ├── lib\features\ads_iap\         # AdService, IapService
        └── lib\core\                     # AppLogger, StorageService (Hive), DeviceTiers
```

### 2. Pure-Dart `puzzle_core` Engine Architecture
- **State Immutability:** Engine accepts `(BoardState, Move)` and produces a new `BoardState` along with an ordered list of `GameEvent`s.
- **Turn Resolution Lifecycle (9 Steps):**
  1. Input validation & tap priority check (LR-7).
  2. Exit lane raycasting (Ant layer check vs LR-3; Bee layer check vs LR-4).
  3. Exit or Bump determination.
  4. Movement path generation (Marching ants / Flying bees / Bonk squash).
  5. Board mutation (path removal or heart deduction).
  6. Trigger mechanics execution (ticking move counters, pressure plates, levers).
  7. Board state consistency check (cover-lock status update).
  8. Win / Fail condition evaluation.
  9. Event stream emission for audio, haptics, and VFX.

### 3. Flutter Rendering Pipeline (`CustomPainter`)
- Multi-layered drawing inside a single `CustomPainter` to minimize compositor layer overhead:
  - **Layer 0 (Static Background):** Pre-rendered lawn grid, cached via `PictureRecorder` when board geometry is static.
  - **Layer 1 (Ground Mechanics & Ants):** Low obstacles (pebbles, moss, twigs) and ant line segments with contact shadows.
  - **Layer 2 (Air Mechanics & Bees):** Tall obstacles (sunflower stalks, spider web) and bee lines with +6 dp vertical offset and offset shadows.
  - **Layer 3 (Dynamic Overlays):** Scent trail preview, booster hints, and active particle systems.
- Driven by an **On-Demand Ticker**: runs when animations, previews, or particles are active, and completely halts (0 fps / 0 CPU) when the board is idle.

### 4. Persistence & Local Save (`Hive`)
- Box `save_data` stores:
  - Player progression: `currentLevelIndex`, `levelStars` (Map<int, int>), `clearedLevels`.
  - Economy: `coinsBalance`, `hintCount`, `shieldCount`, `hammerCount`.
  - Daily & Meta: `dailyStreakDays`, `lastDailyClearedDate`, `queensFavorUsed`.
  - Level-Specific Rules: `adReviveUsed` (Map<int, bool>), `lastFullIntroDayKey`.
- **Atomic Backup:** Every save write flushes to `save_backup.json`. On corrupted launch, state is recovered from backup.

### 5. Automated QA & Validation Matrix
| QA Code | Verification Requirement | Acceptance Threshold |
|---|---|---|
| **QA-ENG-01** | CI Solver verification across all 500 bundled levels | 500/500 pass with 0 hearts lost and 0 boosters |
| **QA-ENG-02** | Layer non-collision verification (LR-2) | Ants and bees never collide or block each other's lanes |
| **QA-ENG-03** | Tall obstacle dual blocking (LR-4) | `tall: true` obstacles block both ants and bees |
| **QA-ENG-04** | Cover-lock evaluation (LR-6) | Ant line covered by bee line cannot be tapped until bee exits |
| **QA-ENG-05** | M004/M032 swap verification | Bees introduce at L41; Dew Key & Thorn Lock introduces at L321 |
| **QA-PERF-01** | Low-tier frame rate | Stable 60 fps during active movement on budget reference hardware |
| **QA-PERF-02** | Static board idle consumption | Exactly 0 frames per second when idle |
| **QA-STORE-01**| Neutral age gate compliance | Required prior to any ad tracking; ages 10–50 compliant |

## Affected Files
- `packages/puzzle_core/pubspec.yaml` (to be created)
- `packages/puzzle_core/lib/puzzle_core.dart` (to be created)
- `apps/ants_bees/pubspec.yaml` (to be created)
- `apps/ants_bees/lib/main.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/render/board_painter.dart` (to be created)
- `apps/ants_bees/lib/features/gameplay/render/layer_compositor.dart` (to be created)
- `apps/ants_bees/lib/core/storage/save_repository.dart` (to be created)

## Risks
- Flutter Web or desktop compilation differences if engine relies on native platform bindings (must keep `puzzle_core` strictly pure Dart).
- Impeller shader compilation jank on older iOS devices (addressed via pre-warmed shader bundles and pre-baked textures).

## Open Questions
- None. System architecture aligns with phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md.

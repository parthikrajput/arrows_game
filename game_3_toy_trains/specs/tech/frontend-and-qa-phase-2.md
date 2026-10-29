Source docs: phase/phase_2/06_FRONTEND_AND_QA_PHASE_2.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/gameplay/phase-2-scope-and-rules.md, specs/tech/backend-cloud-functions-and-release-prerequisites.md.

# Spec: Frontend Implementation & QA Matrix Phase 2 (Toy Trains)

## Status
Draft

## Type
Improvement (extends client state architecture, presentation layer, and QA validation matrix from `specs/tech/frontend-implementation-and-qa.md`)

## Goal
Specify the frontend architecture updates, BLoC state management extensions, Remote Config telemetry parameters, shader warmup pipelines, and the comprehensive QA acceptance matrix for Toy Trains: Wooden Railway Puzzle Phase 2.

## Current State
Design documented in `phase/phase_2/06_FRONTEND_AND_QA_PHASE_2.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 frontend (`specs/tech/frontend-implementation-and-qa.md`) delivered core game loop, FTUE, single-layer/two-layer boards, and local Hive persistence.
- Phase 2 adds pinch-zoom/pan viewport transformations, LiveOps screens (Album, Race, Piggy, Cosmetics), cloud sync listeners, and 49 new mechanics.

## Proposed Change
Extend the Flutter client architecture and testing harness:

### 1. Client Architecture & State Management Extensions
- **New Feature BLoCs & Cubits:**
  - `AlbumBloc`: Manages sticker unlocks, volume progression, and unviewed sticker badges.
  - `RaceBloc`: Coordinates weekend tournament status, cohort leaderboards, and progress reporting.
  - `PiggyBankCubit`: Tracks stored coin count, minimum break threshold, and IAP fulfillment.
  - `CosmeticsCubit`: Handles liveries and playmat theme unlocking, coin purchases, and active selection.
  - `SyncCubit`: Observes network connectivity, flushes `pending_ops_box`, and resolves cloud state merges.
- **Rendering & Viewport Layer:**
  - `BoardPanZoomContainer`: Wraps board `CustomPainter` with custom transformation matrix controller handling pinch gestures, pan drag bounds, and auto-fit resets.
  - `InteractiveCellLayer`: Refactored to handle 3 elevation layers (Ground L0, Mid L1, Top L2) with Z-index raycast hit-testing.

### 2. Remote Config Parameter Definitions
| Config Key | Data Type | Default Value | Description |
|---|---|---|---|
| `maxPhase` | integer | `2` | Controls maximum playable phase. If `< 2`, Level 500 displays "Coming Soon". |
| `featureFlags.album` | boolean | `true` | Enables Depot Sticker Album feature. |
| `featureFlags.race` | boolean | `true` | Enables Weekly Star Race weekend tournament. |
| `featureFlags.piggy` | boolean | `true` | Enables Ticket Piggy Bank IAP. |
| `featureFlags.cosmetics`| boolean | `true` | Enables Train Shed Cosmetics shop tab. |
| `featureFlags.cloudSync`| boolean | `true` | Enables background Firebase sync worker. |
| `piggy_capacity` | integer | `1000` | Max coins stored in Piggy Bank before capping. |
| `piggy_break_min` | integer | `300` | Minimum coins required to break the bank. |
| `piggy_deposit_rate`| integer | `10` | Coins deposited per campaign first clear. |

### 3. Rendering Pipeline & Shader Warmup
- **Impeller Engine Warmup:**
  - Pre-compiles SkSL/Impeller shader programs during initial launch splash:
    - 3-layer viaduct shadow drop shader.
    - 45° diagonal track aliasing filter.
    - Optical beam additive glow and crystal prism refraction.
    - Dynamic zoom matrix scaling and bicubic texture sampling.
- **Frame Budget:** 16.6 ms per frame (60 fps) strictly maintained on low-tier test devices during active 2-finger pinch-zoom operations.

### 4. QA Acceptance Test Matrix (Phase 2)
All items start with status `Not run`:

| QA ID | Test Category | Description & Acceptance Criteria | Status |
|---|---|---|---|
| **QA-P2-01** | Zoom & Pan | Boards >= 12x12 start auto-fitted; 2-finger pinch zooms to max 48 dp/cell; 1-finger drag pans when zoomed; "⤢ Fit" button returns to 1.0; 8 dp slop strictly respected. | Not run |
| **QA-P2-02** | Diagonal Movement | M051 trains exit along 45° diagonals; carriages trail accurately around polyline joints; coupling-cross block prevents clipping through carriages. | Not run |
| **QA-P2-03** | Three Layers | M069 Triple-Deck Viaduct allows simultaneous crossing on Ground, Mid, and Top layers; taps prioritize top visible layer; Track Crane hits top layer only. | Not run |
| **QA-P2-04** | Push Physics | Pushing M053 cart moves it 1 cell if clear behind; pushing onto M054 Frosty Rails slides cart until obstacle collision; blocked cart results in -1 heart bump. | Not run |
| **QA-P2-05** | Signal Light Optics | M084 light beam blocks lanes; occluded by trains; triggers M085 Light Sensor to open gates; M086 mirrors reflect beams and trains 90° CW. | Not run |
| **QA-P2-06** | Sticker Album | Clearing milestone levels awards 1 sticker; Volume complete grants coin reward and exclusive cosmetic; migration retroactively grants stickers for cleared levels. | Not run |
| **QA-P2-07** | Weekly Star Race | L60+ players match into 5-player cohort; progress updates asynchronously; ghost profiles backfill vacant slots; top 3 receive scheduled prizes. | Not run |
| **QA-P2-08** | Piggy Bank | First clears add +10 coins locally; bank caps at 1,000; breaking bank for ₹49 validates receipt, credits stored coins, and resets counter to 0. | Not run |
| **QA-P2-09** | Cloud Sync | Offline play records ops to Hive; flushes to `applyOps` upon reconnecting; conflict resolution picks `max(level)` and `union(stickers, cosmetics)`. | Not run |
| **QA-P2-10** | Account Deletion | Tapping "Delete Account" confirms via double-dialog, wipes Firestore doc and subcollections, purges local Hive boxes, and restarts at FTUE Level 1. | Not run |

## Affected Files
- `lib/features/gameplay/presentation/widgets/board_pan_zoom_container.dart` (to be created)
- `lib/features/meta/album/presentation/bloc/album_bloc.dart` (to be created)
- `lib/features/meta/race/presentation/bloc/race_bloc.dart` (to be created)
- `lib/features/economy/presentation/cubit/piggy_bank_cubit.dart` (to be created)
- `lib/features/economy/presentation/cubit/cosmetics_cubit.dart` (to be created)
- `lib/core/sync/presentation/cubit/sync_cubit.dart` (to be created)

## Risks
- Matrix transformation calculation bugs causing touch misalignment during zoomed states. Mitigation: Inverse transform touch coordinates using `matrix.applyInverse()` before hit-testing.

## Open Questions
- None. All parameters, test cases, and Remote Config keys match `phase/phase_2/06_FRONTEND_AND_QA_PHASE_2.md` and `SHARED_CORE_STANDARD.md`.

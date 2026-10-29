Source docs: LOGGING_AND_ERROR_TRACKING.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Logging, Error Tracking, and Deterministic Replay

## Status
Draft

## Type
New Feature

## Goal
Implement structured logging, Firebase Crashlytics integration, tap tracing, deterministic replay generation, and problem reporting for Ants & Bees: Garden Trails Phase 1.

## Current State
Design documented in LOGGING_AND_ERROR_TRACKING.md and phase_1/07, not yet implemented.
- Logging architecture requires an in-memory ring buffer of the last 200 entries and a rotating local file sink.
- Firebase Crashlytics records unhandled errors and custom breadcrumbs with game context.
- Deterministic tap tracing enables exact reproduction of user sessions and solver edge cases.

## Proposed Change
Implement the telemetry, diagnostics, and replay framework in `apps/ants_bees/lib/core/logging/`:

### 1. In-Memory Ring Buffer & File Sink
- **Circular Buffer:** Stores the latest 200 log entries across all severity levels (`Verbose`, `Debug`, `Info`, `Warn`, `Error`, `Fatal`).
- **File Sink:** Writes structured entries to `logs/app_log.txt` (rotating across 2 files of max 512 KB each).
- **Log Formatting:** `[ISO-8601-Timestamp] [LEVEL] [TAG] [CODE] Message {context_json}`.

### 2. Standardized Error Codes
- **Audio (`E-AUD-*`):**
  - `E-AUD-001`: Audio asset missing from bundle (silent fallback, game does not crash).
  - `E-AUD-002`: SoundPool / AudioPlayer initialization failure.
- **Persistence (`E-SAVE-*`):**
  - `E-SAVE-001`: Main Hive save corrupt; fallback to `save_backup.json` triggered.
  - `E-SAVE-002`: Atomic write flush failed.
- **Monetization & Ads (`E-ADS-*`):**
  - `E-ADS-001`: Rewarded video failed to load when requested.
  - `E-ADS-002`: UMP consent flow timeout or error.
- **Performance Warnings (`W-PERF-*`):**
  - `W-PERF-004`: Cold startup exceeds target tier budget.
  - `W-PERF-005`: Intro animation jank guard triggered (auto-skips intro).

### 3. Firebase Crashlytics Integration
- In release mode, Crashlytics initializes during Stage B (after Flutter first frame rendered).
- Custom keys maintained at all times:
  - `device_tier`: `low` / `mid` / `high`
  - `battery_saver`: `true` / `false`
  - `current_level`: Level index (1–500)
  - `moves_taken`: Move counter for current level attempt
  - `hearts_left`: Current hearts count (0–3)
  - `active_layer`: `ground` / `air` / `both`
- Non-fatal exceptions caught during gameplay (e.g., failed SFX load, ad fetch timeouts) are logged as non-fatal issues with full stack traces.

### 4. Tap Tracing & Deterministic Replay
- Every user interaction during a puzzle attempt is recorded into an attempt trace buffer:
  - `moveIndex`: Sequence number (0..N).
  - `timestampMs`: Milliseconds since level start.
  - `tapCoord`: `(x, y)` grid cell tapped.
  - `layer`: `0` (ground ant line) or `1` (air bee line).
  - `targetType`: `line` / `control` / `booster` / `empty`.
  - `targetId`: Unique ID of tapped entity.
  - `result`: `exit` / `bump` / `locked`.
- **Replay Export String:** Base64-encoded string combining `(gameId, levelIndex, generatorVersion, seed, List<MoveRecord>)`.
- Passing the replay string to `packages/puzzle_core` test harness deterministically reproduces the exact board state and bug condition without visual rendering.

### 5. In-App Diagnostic Bug Reporter
- Triple-tapping the version number in Settings opens the Diagnostic Export modal.
- Generates an obfuscated text dump including:
  - Device model, OS version, Flutter engine commit.
  - Last 200 log entries from the circular ring buffer.
  - Replay string of the most recent level attempt.
  - Option to share via native system share sheet.

## Affected Files
- `apps/ants_bees/lib/core/logging/app_logger.dart` (to be created)
- `apps/ants_bees/lib/core/logging/crashlytics_service.dart` (to be created)
- `apps/ants_bees/lib/core/logging/tap_tracer.dart` (to be created)
- `apps/ants_bees/lib/core/logging/replay_exporter.dart` (to be created)
- `apps/ants_bees/lib/features/ui/dialogs/diagnostic_dialog.dart` (to be created)

## Risks
- Excessive file I/O on low-tier devices if verbose logs are written synchronously (buffered asynchronous disk flushes mandated).

## Open Questions
- None. Logging schema, error codes, and replay formats comply with LOGGING_AND_ERROR_TRACKING.md.

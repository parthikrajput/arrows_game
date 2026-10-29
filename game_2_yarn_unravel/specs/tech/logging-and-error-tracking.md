Source docs: ../../LOGGING_AND_ERROR_TRACKING.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Logging, Error Tracking and Production Debugging

## Status
Draft

## Type
New Feature

## Goal
Implement structured logging via `AppLogger`, Firebase Crashlytics integration, local tap tracing, deterministic replay generation, and in-game issue reporting for Yarn Unravel Phase 1.

## Current State
Design documented in ../../LOGGING_AND_ERROR_TRACKING.md and phase_1/07, not yet implemented.
- Tooling: Firebase Crashlytics (crashes and breadcrumbs), Firebase Analytics (aggregated behavioral signals), Firebase Performance (trace monitoring), and in-house `AppLogger`.
- In-memory ring buffer holds last 300 log entries; local file sink rotates across two 512 KB files (`app_log_0.jsonl` and `_1.jsonl`).
- Tap logging overhead strictly capped at < 0.2 ms per tap; logging errors never crash gameplay.
- Children (under 13) protected: zero PII collected, free-text bug reports and screenshots restricted to age 13+.

## Proposed Change
Implement the logging services, input interception, replay tool, and crash reporting:

### 1. `AppLogger` & File Sink Architecture
- **In-Memory Ring Buffer:** Stores the latest 300 structured `LogEntry` items. On fatal/error events, the last 50 entries are flushed to Firebase Crashlytics breadcrumbs (within the 64 KB Crashlytics payload ceiling).
- **Rotating File Sink:** `appDocuments/logs/app_log_0.jsonl` and `app_log_1.jsonl`. Appends asynchronously; flushes every 5 seconds, immediately on `warn` or higher, and on `AppLifecycleState.paused`. Rotates at 512 KB.
- **Log Levels & Filtering:**
  - `trace`: Animation frames; debug console only (disabled in release).
  - `debug`: Taps, state transitions; ring buffer only in release.
  - `info`: Level start/win/fail, IAP, route changes; ring buffer + file sink.
  - `warn`: Recoverable issues, ad no-fills, rage taps; ring buffer + file + Crashlytics breadcrumb.
  - `error`: Handled exceptions, soft-locks, invariant violations; logged as Crashlytics non-fatal.
  - `fatal`: Uncaught crashes; reported as fatal crash to Crashlytics.
  - Minimum level in release is `info` (dynamically tunable via Remote Config `log_min_level`).

### 2. Standard Categories & Error Codes
Stable error codes stored in `packages/puzzle_core/lib/src/logging/codes.dart`:
- `input` (`I-`): `I-TAP`, `I-DEAD-TAP`, `I-RAGE-TAP`, `I-SLOW-INPUT`, `I-TAP-DURING-ANIM`.
- `game` (`E-GAME-`): `E-GAME-001` invariant violation, `E-GAME-002` move rejected, `E-GAME-003` stuck animation (> 2s), `E-GAME-004` soft-lock (no winning moves).
- `level` (`E-LVL-`): `E-LVL-001` JSON parse failure, `E-LVL-002` schema mismatch, `E-LVL-003` generator 64-attempt timeout, `E-LVL-004` solver timeout.
- `save` (`E-SAVE-`): `E-SAVE-001` Hive open failure, `E-SAVE-002` corrupt save restored from backup, `E-SAVE-003` migration failure, `E-SAVE-004` disk write failure.
- `ads` (`W-ADS-` / `E-ADS-`): `W-ADS-001` load failure, `W-ADS-002` show failure, `E-ADS-003` reward missing after completed callback.
- `iap` (`E-IAP-`): `E-IAP-001` purchase error, `E-IAP-002` verification failure, `E-IAP-003` pending > 24h, `E-IAP-004` restore failure.
- `net` & `time`: `W-NET-001` server time fetch failure, `W-TIME-001` clock moved backwards (time-travel lock).
- `audio`: `E-AUD-001` missing asset, `E-AUD-002` pool creation failure, `E-AUD-003` playback error.
- `ui` & `perf`: `E-UI-001` FlutterError, `W-PERF-001` frame jank > 5%, `W-PERF-002` level load > 1.5s, `W-PERF-004` slow cold start, `W-PERF-005` intro jank guard.

### 3. Global Error Hooks (`main.dart`)
- `FlutterError.onError`: Intercepts widget overflow and build errors, logs `E-UI-001`, forwards to `FirebaseCrashlytics.instance.recordFlutterError`.
- `PlatformDispatcher.instance.onError`: Intercepts root framework errors, logs `E-UNCAUGHT`, records fatal crash to Crashlytics.
- `Isolate.current.addErrorListener`: Captures errors in background solver or generator isolates.

### 4. Deterministic Replay Service
- Generates reproducible `ReplayData` upon level failure or bug report submission:
  - Level seed, level ID, and schema version.
  - Ordered array of player move inputs: `[{t: ms, x: int, y: int, action: String}]`.
  - Booster activations.
- Allows developer CLI (`tools/replay`) to re-simulate exact board states without screen captures.

### 5. Privacy & Child Safety
- Age gate response determines logging privacy mode:
  - Under 13: Advertising ID is scrubbed (`""`); device identifiers omitted; crash reports scrub user inputs; free-form bug reports disabled.
  - Age 13+: Standard Crashlytics session reporting enabled; non-identifying diagnostics allowed.

## Affected Files
- `packages/puzzle_core/lib/src/logging/codes.dart` (to be created)
- `apps/yarn_unravel/lib/services/logger_service.dart` (to be created)
- `apps/yarn_unravel/lib/services/crashlytics_service.dart` (to be created)
- `apps/yarn_unravel/lib/services/replay_service.dart` (to be created)
- `tools/replay/bin/replay.dart` (to be created)

## Risks
- File write frequency must not cause I/O starvation on low-tier eMMC storage.
- Crashlytics breadcrumb rate limits (max 64 KB total breadcrumbs per session) must be strictly observed.

## Open Questions
- None. Error codes and log retention policies follow LOGGING_AND_ERROR_TRACKING.md.


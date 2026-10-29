Source docs: ../../LOGGING_AND_ERROR_TRACKING.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Logging, Error Tracking and Deterministic Replay (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Implement structured application logging, standardized error codes, ring-buffer persistence, Crashlytics integration, deterministic tap tracing, and bug report export for Toy Trains.

## Current State
Design documented in ../../LOGGING_AND_ERROR_TRACKING.md and phase_1/07, not yet implemented.
- Need for deterministic reproduction of edge-case railway collisions and generator anomalies.
- Error logging scattered without unified taxonomy or file rotation.
- Requirement for zero-PII diagnostics in compliance with Google Play Families Policy.

## Proposed Change
Implement the telemetry infrastructure and tap recording harness in `apps/toy_trains/lib/services/logger/`:

### 1. AppLogger & In-Memory Ring Buffer
- **Ring Buffer:** Fixed-capacity in-memory buffer holding the last **500 log events**. Memory footprint bounded < 200 KB.
- **Disk File Sink:** Two rotating files (`app_log_0.txt` and `app_log_1.txt`), max 1 MB each. On buffer flush, writes oldest to newest. Older file rotated when threshold met.
- **Console Output:** Formatted terminal logs in debug mode; stripped in release builds.

### 2. Standardized Error Taxonomy
Every logged issue uses strict prefixes (`E-` for errors, `W-` for warnings, `I-` for info):
| Code | Category | Severity | Description |
|---|---|---|---|
| `E-GAME-001` | Gameplay | Error | Invalid move rejected by engine validation. |
| `E-GAME-002` | Gameplay | Error | Board invariant failure (e.g. disjoint carriage coordinates). |
| `E-GAME-003` | Gameplay | Critical | Infinite redirect loop detected in tunnel/switch pipeline. |
| `E-GAME-004` | Gameplay | Warning | Soft-lock detected by solver; triggers "Stuck" restart prompt. |
| `E-LVL-001` | Content | Error | Level JSON missing, malformed, or decompression failed. |
| `E-LVL-002` | Content | Error | Level checksum validation mismatch. |
| `E-LVL-003` | Generator | Warning | Seed generator 64-attempt exhaustion; classic fallback activated. |
| `E-SAVE-001` | Persistence | Warning | Hive save box corrupt; restored successfully from `save_backup`. |
| `E-SAVE-002` | Persistence | Critical | Both save and backup corrupt; fresh save initialized. |
| `E-AUD-001` | Audio | Warning | Audio pool playback failure or missing sound asset. |
| `E-ADS-001` | Monetization| Info | Ad failed to load; gracefully fallback to alternate UI states. |
| `E-IAP-001` | Monetization| Error | In-app purchase receipt verification failure. |
| `W-PERF-001` | Performance | Warning | Single frame render exceeded 16.6 ms budget. |
| `W-PERF-004` | Performance | Warning | Cold start Time-To-Interactive exceeded platform threshold. |
| `W-PERF-005` | Performance | Warning | First 5 intro frames exceeded 50 ms span; intro skipped. |

### 3. Tap Tracing & Deterministic Replay (`TapLoggerScope`)
- **Tap Record:** Captures level context and player inputs:
  ```json
  {
    "gameId": "toy_trains",
    "level": 42,
    "seed": 9823412049812,
    "generatorVersion": 3,
    "taps": [
      {"t": 120, "x": 4, "y": 2, "action": "tap"},
      {"t": 850, "x": 6, "y": 6, "action": "long_press"}
    ]
  }
  ```
- **Replay Execution:** The recorded tap sequence can be injected directly into `packages/puzzle_core` unit tests or the `tools/levelgen` CLI to reproduce crashes and collision bugs deterministically.

### 4. Crashlytics & Remote Telemetry
- Non-fatal exceptions caught in BLoC boundaries are reported via `FirebaseCrashlytics.instance.recordError` with the current ring-buffer tail attached as custom keys.
- **Privacy Enforcement:** Zero PII logged. No user email, IP address, device serial, or advertising identifiers are included in log metadata.

### 5. "Report a Problem" Diagnostic Package
Accessible from Settings screen:
- Bundles app version, OS build, sanitized ring-buffer logs, and the last 3 replay tap recordings.
- Exports a zipped diagnostic file via OS share sheet for player bug submissions.

## Affected Files
- `apps/toy_trains/lib/services/logger/app_logger.dart` (to be created)
- `apps/toy_trains/lib/services/logger/log_entry.dart` (to be created)
- `apps/toy_trains/lib/services/logger/tap_recorder.dart` (to be created)
- `apps/toy_trains/lib/features/settings/report_problem_dialog.dart` (to be created)

## Risks
- Excessive disk I/O from high log frequency; mitigated by batching file sink writes to a background timer (every 10 seconds or on lifecycle pause).

## Open Questions
- None. Error taxonomy and ring-buffer budgets follow LOGGING_AND_ERROR_TRACKING.md.

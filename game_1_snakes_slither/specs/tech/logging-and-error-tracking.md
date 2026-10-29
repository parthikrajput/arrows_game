Source docs: ../../LOGGING_AND_ERROR_TRACKING.md, phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md

# Spec: Logging, Error Tracking and Production Debugging

## Status
Draft

## Type
New Feature

## Goal
Implement structured logging via `AppLogger`, Firebase Crashlytics integration, local tap tracing, deterministic replay generation, and in-game issue reporting for Snakes Slither Phase 1.

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
- `Isolate.current.addErrorListener`: Captures uncaught isolate exceptions as fatal `E-ISOLATE`.
- Release build symbolication: Android AAB built with `--obfuscate --split-debug-info=build/symbols` and symbols uploaded to Crashlytics.

### 4. Crashlytics Custom Keys
Continuously updated in runtime:
- `game_id`: `"snakes_slither"`.
- `app_version` & `build`: e.g. `"1.0.0"` / `"100"`.
- `screen`: Current route name via `RouteAwareLogger`.
- `level` & `phase`: Active level number and phase index.
- `level_seed`: Active level seed hex.
- `attempt`, `moves`, `hearts`: Current attempt counters.
- `boosters_active`: Currently engaged boosters (e.g. `shield:1`).
- `vip` & `age_band`: VIP status and age category.
- `last_input`: Semantic target and outcome of last tap (e.g. `board:cell(3,2):p1:bump`).
- User identifier: Anonymous UUID v4 `installId` (no PII).

### 5. Tap & Input Tracing (`TapLoggerScope`)
- Global `Listener` at widget root captures pointer down/up.
- Semantic targets: Buttons wrapped in `LoggedTap(id: 'shop.buy.hint3')`. Board taps logged as `board:cell(x,y):<pathId|mechanicId>`.
- Silent issue detectors:
  - **Dead Tap (`I-DEAD-TAP`):** Tap unhandled after 300 ms on non-interactive area. Aggregated to `dead_taps` analytics event if count >= 3.
  - **Rage Tap (`I-RAGE-TAP`):** >= 4 taps within 1.5 seconds in a 48 dp radius. Emits warn log and `rage_tap` analytics event.
  - **Slow Input (`I-SLOW-INPUT`):** Latency from pointer up to handler completion > 200 ms.
  - **Stuck Animation (`E-GAME-003`):** Animation running > 2 seconds forces state commit and logs non-fatal error.
  - **Soft-Lock (`E-GAME-004`):** Remaining snakes > 0, hearts > 0, but solver finds no winning sequence. Displays "Stuck" sheet offering free restart.

### 6. Game Session Replay
- Local storage maintains compact JSON records of the last 3 level attempts (level seed, moves sequence with timestamps and actions, start/end state hashes).
- Replays uploaded upon `E-GAME-*` non-fatal errors, when user files a bug report, or via sampling.
- Replay tool `tools/replay`: Dart CLI tool replays moves in `puzzle_core` step-by-step, verifying FNV-1a 64-bit `state_hash` matching.

### 7. Invariant Checks (Release Soft Asserts)
- Clamps hearts between 0 and 3.
- Clamps coins and booster counts to >= 0.
- Rejects move if snake bodies would illegally overlap on same layer.
- Enforces win flow if `remainingPaths == 0`.

### 8. In-Game "Report a Problem"
- Located in Settings -> Help -> "Report a problem" and error dialogs.
- Collects category, device metadata, last 300 logs, last 3 replays, and save summary.
- Users aged 13+ may optionally enter free text (max 500 characters, masked for phone/email patterns) and attach a screenshot.
- Under-13 users are restricted to category pickers only with no free text and no screenshots.
- Uploads via Callable Cloud Function `submitBugReport` and displays a human-readable Report ID (e.g., `BR-7F3K2Q`).
- "Share diagnostics" toggle in Settings: when turned off, disables Crashlytics, Analytics, and replay uploads.

### 9. QA Checklist
All items initialized with status **"Not run"**:
- LOG-01: Debug build forced exception triggers Crashlytics fatal with keys and breadcrumbs.
- LOG-02: Release build with `--obfuscate` produces readable symbolicated stacks.
- LOG-03: Tapping 20 UI buttons records `I-TAP` down and handled with correct semantic IDs.
- LOG-04: Tapping empty background 5 times logs `I-DEAD-TAP`.
- LOG-05: Tapping same spot 6 times in 1s triggers `I-RAGE-TAP`.
- LOG-06: 300 ms injected delay triggers `I-SLOW-INPUT` warning.
- LOG-07: Save corruption triggers `E-SAVE-002` and restores backup.
- LOG-08: Deleting level JSON triggers `E-LVL-001` non-fatal and displays "Level unavailable" dialog.
- LOG-09: Forcing negative hearts triggers `E-GAME-001` invariant clamp.
- LOG-10: Running `tools/replay` reproduces identical state hashes on failing levels.
- LOG-11: Airplane mode ad failure logs `W-ADS-001` with AdMob error code.
- LOG-12: Declined test IAP logs `E-IAP-001` without exposing full receipt tokens.
- LOG-13: Clock moved back 1 day logs `W-TIME-001` and engages time-travel lock.
- LOG-14: Bug report handles 13+ and under-13 profiles with correct fields.
- LOG-15: Offline bug report queues and uploads upon reconnect.
- LOG-16: Disabling "Share diagnostics" halts Crashlytics and analytics network traffic.
- LOG-17: Remote Config `log_min_level = debug` updates file sink filter dynamically.
- LOG-18: 1,000 taps benchmark measures logging overhead < 0.2 ms per tap.
- LOG-19: Network inspection confirms zero PII in log and bug report payloads.
- LOG-20: Force-killing app mid-level preserves previous log files without corruption.
- LOG-21: Solver isolate failure logs `E-LVL-004` and shows "Try Restart" toast.
- LOG-22: Crashlytics alerts properly reach notification channels.

## Affected Files
- `apps/snakes_slither/lib/logging/app_logger.dart` (to be created)
- `apps/snakes_slither/lib/logging/log_file_sink.dart` (to be created)
- `apps/snakes_slither/lib/logging/tap_logger.dart` (to be created)
- `apps/snakes_slither/lib/logging/logged_tap.dart` (to be created)
- `packages/puzzle_core/lib/src/logging/codes.dart` (to be created)
- `tools/replay/bin/replay.dart` (to be created)
- `functions/src/submit_bug_report.ts` (to be created)

## Risks
- Crashlytics log buffer sizing: breadcrumbs must not exceed 64 KB limit.
- File I/O overhead: file sink must run asynchronously with throttled batch writes to avoid frame drops.

## Open Questions
- None. Logging categories, error codes, and compliance standards align directly with LOGGING_AND_ERROR_TRACKING.md.

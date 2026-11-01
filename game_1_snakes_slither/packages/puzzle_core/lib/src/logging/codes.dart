/// Standard diagnostic, event, and error codes for logging and error tracking.
abstract final class LogCodes {
  // Input tracking
  static const inputTap = 'I-TAP';
  static const inputDeadTap = 'I-DEAD-TAP';
  static const inputRageTap = 'I-RAGE-TAP';
  static const inputSlowInput = 'I-SLOW-INPUT';
  static const inputTapDuringAnim = 'I-TAP-DURING-ANIM';

  // Game logic & invariants
  static const gameInvariantViolation = 'E-GAME-001';
  static const gameMoveRejected = 'E-GAME-002';
  static const gameStuckAnimation = 'E-GAME-003';
  static const gameSoftLock = 'E-GAME-004';

  // Level loading & solving
  static const levelParseError = 'E-LVL-001';
  static const levelSchemaMismatch = 'E-LVL-002';
  static const levelGenTimeout = 'E-LVL-003';
  static const levelSolverTimeout = 'E-LVL-004';

  // Save & storage
  static const saveOpenFailure = 'E-SAVE-001';
  static const saveCorruptRestored = 'E-SAVE-002';
  static const saveMigrationFailure = 'E-SAVE-003';
  static const saveDiskWriteFailure = 'E-SAVE-004';

  // Ads
  static const adsLoadFailure = 'W-ADS-001';
  static const adsShowFailure = 'W-ADS-002';
  static const adsRewardMissing = 'E-ADS-003';

  // IAP
  static const iapPurchaseError = 'E-IAP-001';
  static const iapVerificationFailure = 'E-IAP-002';
  static const iapPendingTimeout = 'E-IAP-003';
  static const iapRestoreFailure = 'E-IAP-004';

  // Network & Time
  static const netServerTimeFailure = 'W-NET-001';
  static const timeTravelDetected = 'W-TIME-001';

  // Audio
  static const audioMissingAsset = 'E-AUD-001';
  static const audioPoolFailure = 'E-AUD-002';
  static const audioPlaybackError = 'E-AUD-003';

  // UI & Performance
  static const uiFlutterError = 'E-UI-001';
  static const uncaughtException = 'E-UNCAUGHT';
  static const isolateException = 'E-ISOLATE';
  static const perfFrameJank = 'W-PERF-001';
  static const perfLevelLoadSlow = 'W-PERF-002';
  static const perfMemoryPressure = 'W-PERF-003';
  static const perfSlowColdStart = 'W-PERF-004';
  static const perfIntroJankGuard = 'W-PERF-005';
}

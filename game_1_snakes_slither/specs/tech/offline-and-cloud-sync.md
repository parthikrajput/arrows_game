Source docs: phase_2/05_OFFLINE_AND_CLOUD_SYNC.md, ../../SHARED_CORE_STANDARD.md §8.4, §13–§14, §17.27, §17.36. Depends on: specs/tech/frontend-implementation-and-qa.md.

# Spec: Tech — Offline-First & Cloud Synchronization

## Status
Draft

## Type
New Feature

## Goal
Implement a robust offline-first synchronization architecture for Snakes Slither Phase 2, combining local Hive persistence, silent Firebase Anonymous Authentication with optional Google/Apple account linking, UUID-v4 idempotent op-log synchronization, deterministic conflict resolution, and in-app account deletion compliance.

## Current State
Design documented in `phase_2/05_OFFLINE_AND_CLOUD_SYNC.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 was strictly local-first with device-only Hive storage. Uninstalling meant progress was lost (except IAP purchases restored via app store receipts).
- Phase 2 introduces cloud backup and multi-device support while retaining 100% offline gameplay capability.

## Proposed Change
Build the synchronization layer in Flutter (`SyncService`, `AuthService`, `OpLogQueue`):

### 1. Offline-First Core Principles
1. **Local Writes First:** Every game action (level clear, coin spend, booster use) is written immediately to Hive boxes. The UI never waits on network responses.
2. **Immutable Op-Log:** Changes generate an idempotent operation with a UUID v4 `opId` stored in a dedicated `sync_queue` Hive box.
3. **Deterministic State Merges:**
   - Level Progress: `max(highestClearedLocal, highestClearedServer)`
   - Stars: Per-level max `max(starsLocal[L], starsServer[L])`
   - Collections (Stickers, Cosmetics): Mathematical set union `local ∪ server`
   - Preferences/Settings: Last-write-wins based on server-validated timestamps
   - Economy/Ledger (Coins, Boosters, Piggy): Server ledger sum is the single source of truth; client displays `serverSnapshot + pendingLocalOps`.

### 2. Identity Management (Firebase Auth)
- **Silent Anonymous Auth:** On first online launch of Phase 2, `signInAnonymously()` creates a persistent Firebase UID without interrupting the user.
- **Account Linking:**
  - Settings -> Account allows linking to Google Play Games / Sign in with Apple.
  - Linking preserves the existing anonymous UID (`linkWithProvider`), avoiding data migration.
  - Under-13 accounts (`ageBand == child`) hide social linking buttons and remain strictly anonymous to comply with Families policies.
- **Account Already Exists Conflict Handling:**
  - If linking reports `credential-already-in-use`, a prompt offers: "Load saved garden from this account?"
  - Choosing load triggers `mergeAnonymous({anonIdToken})` on Cloud Functions, replaying local anonymous ops into the existing account and deleting the orphaned anonymous UID.

### 3. Server Time Authority & Monotonic Clock
- Client tracks `lastServerUtc` paired with device monotonic clock (`SystemClock.elapsedRealtime` / `monoAtServerSync`).
- Estimated server time: `estUtc = lastServerUtc + (currentMono - monoAtLastServerSync)`.
- Device clock changes (time-travel cheats) do not alter `estUtc`.
- On reboot (monotonic reset), client flags `estUtc` as unknown until the next successful server ping.

### 4. Firestore Data Model & Security Rules
- Paths:
  - `users/{uid}`: Schema v2 root containing snapshot object.
  - `users/{uid}/stars/{chunk}`: Chunked star records (`p1` for L1–500, `p2` for L501–1000).
  - `users/{uid}/ops/{opId}`: Processed operations (90-day retention).
  - `users/{uid}/keys/{semanticKey}`: Permanent deduplication keys.
- **Security Rules:** Client has `read` access to its own `users/{uid}` hierarchy, but `write` is completely disabled (`allow write: if false`). All mutations must execute via Cloud Functions (`syncPush`).

### 5. In-App Account Deletion (GDPR & App Store Guideline 5.1.1(v))
- Accessible in Settings -> Account -> "Delete Account".
- Two-step confirmation with a mandatory 5-second countdown.
- Calls `deleteAccount` Cloud Function:
  - Wipes Firestore `users/{uid}` subcollections and race cohort records.
  - Deletes the Firebase Auth user record.
  - Wipes local Hive save boxes and restarts app in fresh FTUE state.

## Affected Files
- `lib/core/sync/sync_service.dart` (to be created)
- `lib/core/sync/op_log_queue.dart` (to be created)
- `lib/core/auth/auth_service.dart` (to be created)
- `lib/core/storage/hive_schema_v2_migration.dart` (to be created)
- `lib/features/settings/presentation/dialogs/delete_account_dialog.dart` (to be created)

## Risks
- Corrupted `sync_queue` Hive box preventing state sync. Solved by maintaining `sync_queue` in an independent box, dropping corrupted queue safely, and re-pulling full server snapshot.
- Intermittent connectivity during IAP verification or Star Race sync. Addressed with exponential backoff retry.

## Open Questions
- None. Synchronization rules, schema, and security rules strictly match `phase_2/05_OFFLINE_AND_CLOUD_SYNC.md`.

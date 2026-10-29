Source docs: phase/phase_2/05_OFFLINE_AND_CLOUD_SYNC.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/frontend-implementation-and-qa.md.

# Spec: Tech — Offline-First Architecture & Cloud Sync

## Status
Draft

## Type
New Feature

## Goal
Specify the offline-first architecture, Firebase Authentication lifecycle (anonymous to Google/Apple link), local Hive save schema v2, UUID-based idempotent operation log (op-log), deterministic cloud sync via Cloud Firestore, account conflict resolution, and account deletion compliance for Yarn Unravel Phase 2.

## Current State
Design documented in `phase/phase_2/05_OFFLINE_AND_CLOUD_SYNC.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 in `specs/tech/frontend-implementation-and-qa.md` relied entirely on local device storage (Hive schema v1) without cloud backup or cross-device synchronization.
- Phase 2 introduces cloud backup and synchronization while preserving 100% offline gameplay integrity.

## Proposed Change
Build the synchronization layer in `lib/core/sync/`:

### 1. Offline-First Core Rules
- **Offline Integrity:** All core puzzle levels (1–1000), Daily Stitch, Spinning Wheel, boosters, Craft Baskets, Scrapbook unlocks, and Wardrobe coin purchases are fully functional offline.
- **Optimistic Local Execution:** Every player action mutates local Hive boxes immediately, appending a corresponding immutable operation (op) to `syncQueue`.
- **Authoritative Server Ledger:** The server is the authority for real currency balances and IAP entitlements; client balances reconcile against the server ledger upon sync.
- **Privacy Compliance:** `settings.ageBand` is strictly device-local and is **never** uploaded to the cloud or included in any op. Under-13 players use anonymous cloud backup only; Google/Apple account linking prompts are suppressed.

### 2. Firebase Authentication Lifecycle
1. **Silent Anonymous Sign-In:** On first online app start, calls `FirebaseAuth.instance.signInAnonymously()`. If offline, app runs locally without blocking; retries silently upon next connection.
2. **Account Linking:** Settings menu provides "Save Progress" button invoking `linkWithProvider(GoogleAuthProvider())` or `OAuthProvider('apple.com')` (mandatory on iOS if Google is offered).
3. **Save Conflict Resolution (`credential-already-in-use`):**
   - If the selected Google/Apple account already owns an existing cloud save, the system presents a clear side-by-side modal displaying progress metrics (Level reached, Stars, Coins, Last Played timestamp).
   - **Options:**
     - **"Keep This Device's Save":** Flushes local queue, signs in with credential, and replaces cloud save with local snapshot via `applyOps` (`replace_with_device`). Previous cloud save is archived for 30 days.
     - **"Keep Cloud Save":** Wipes local save, downloads cloud snapshot, and initializes local Hive boxes.
     - **"Cancel":** Aborts linking; remains signed in anonymously.
   - **No Automated Merging:** Merging two distinct accounts is strictly disallowed to prevent duplicate currency exploits.

### 3. Hive Save Schema v2 (Local Boxes)
Upgrades Hive boxes from schema v1 to v2:

| Box Name | Stored Fields & Types |
|---|---|
| `account` | `uid: String`, `provider: String` (anonymous/google/apple), `lastSyncUtc: int`, `serverCoins: int`, `serverBoosters: Map`, `bootstrapDone: bool` |
| `syncQueue` | Key = `opId` (UUID v4), Value = serialized op Map |
| `album` | `stickers: List<int>`, `volumesClaimed: List<int>`, `dailyPatches: List<String>` |
| `piggy` | `stored: int`, `unlocked: bool` |
| `cosmetics` | `owned: List<String>`, `equipped: Map<String, String>`, `equippedAtUtc: int` |
| `race` | `weekKey: String`, `cohortId: String`, `joinedAt: int`, `clears: List<Map>`, `tzOffsetMin: int` |

### 4. Idempotent Op-Log Specification
Every economy or progress mutation appends an op to `syncQueue`:
```json
{
  "id": "c8a4b2e1-4567-489a-b8d2-123456789abc",
  "type": "coins",
  "delta": 20,
  "reason": "clear_L612",
  "ref": "L612",
  "clientUtcMs": 1793083200000,
  "seq": 418,
  "v": 1
}
```
- **Supported Op Types:** `coins`, `booster`, `level_clear`, `album_sticker`, `album_claim`, `cosmetic_buy`, `piggy_add`, `piggy_smash`, `bootstrap`.
- **Sync Flush:** `SyncWorker` flushes queued ops in batches (max 50 ops per call) via callable Cloud Function `applyOps`. Ops are evicted from `syncQueue` only after server HTTP 200 acknowledgement.

### 5. Account & Data Deletion
- Required by Apple App Store guidelines and Google Play Data Safety.
- Settings menu contains "Delete Account and Data" button with two-step confirmation.
- Calls `deleteUserData` Cloud Function:
  1. Deletes `users/{uid}` document, `users/{uid}/ops` subcollection, and Star Race cohort participation records.
  2. Deletes the Firebase Auth user record.
  3. Clears local Hive databases, resets state, and generates a fresh anonymous guest account.

## Affected Files
- `lib/core/sync/data/sync_repository.dart` (to be created: queue management and batch flushing)
- `lib/core/sync/services/auth_service.dart` (to be created: anonymous auth and provider linking)
- `lib/core/sync/view/conflict_resolution_dialog.dart` (to be created: side-by-side save selection modal)
- `functions/src/sync/apply_ops.ts` (to be created: batch op execution and ledger reconciliation)
- `functions/src/sync/delete_user_data.ts` (to be created: complete data erasure)

## Risks
- Excessive cellular data consumption from aggressive polling. Mitigated by exponential backoff (initial 2 s, doubling up to max 60 s) with network connectivity listeners (`connectivity_plus`).

## Open Questions
None. Architecture conforms to `SHARED_CORE_STANDARD.md` §14 and §17.36.

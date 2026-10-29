Source docs: phase/phase_2/05_OFFLINE_AND_CLOUD_SYNC.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/tech/logging-and-error-tracking.md.

# Spec: Offline-First Data & Cloud Synchronization (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Specify the offline-first persistence and cloud synchronization architecture for Toy Trains: Wooden Railway Puzzle Phase 2, establishing anonymous Firebase Authentication with Google/Apple account linking, append-only operation log (op-log) synchronization, deterministic conflict resolution, and regulatory account deletion workflows.

## Current State
Design documented in `phase/phase_2/05_OFFLINE_AND_CLOUD_SYNC.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 used purely local Hive boxes (`save_box`, `settings_box`) with zero cloud synchronization. If a user uninstalled the app or switched devices, progress was lost.
- Phase 2 introduces cloud sync without ever blocking the instant launch or offline gameplay loops.

## Proposed Change
Implement the local-first cloud synchronization service in Flutter:

### 1. Identity & Authentication Pipeline
- **Initial Launch:** Silently authenticates via **Firebase Auth Anonymous Sign-In** on first network availability. User receives a stable `uid`.
- **Account Linking:**
  - Settings screen provides "Save Progress to Cloud" with buttons:
    - Android: Google Play Games / Google Sign-In.
    - iOS: Sign in with Apple.
  - Links credentials to existing anonymous Firebase account (`linkWithCredential`), preserving all existing offline progress.
  - If the target Google/Apple account already owns existing cloud save data on another device, triggers the Conflict Resolution dialog.

### 2. Operation Log (Op-Log) Synchronization Model
- **Local-First Rule:** All user actions (level complete, coins spent, booster used) immediately commit to local Hive boxes. The UI never waits for network responses.
- **Op Generation:** Every state mutation appends an operation record to local `pending_ops_box`:
  ```json
  {
    "opId": "uuid-v4-string",
    "type": "level_clear | coin_delta | booster_used | sticker_grant | cosmetic_buy",
    "clientSeq": 1042,
    "timestamp": 1729850123456,
    "payload": {
      "level": 512,
      "stars": 3,
      "moves": 24,
      "coinsEarned": 20
    }
  }
  ```
- **Sync Batching:** When online, background sync worker sends batches of up to 50 pending ops to the `applyOps` Cloud Function.
- **Idempotency:** Cloud Function validates `opId` against the processed operations log. Re-sent ops are safely acknowledged without double-processing.

### 3. Cloud Firestore Document Hierarchy
- Root collection: `users/{uid}`
  - Document fields:
    - `highestClearedLevel`: int
    - `coins`: int
    - `boosters`: `{"hint": int, "shield": int, "hammer": int}`
    - `stars`: `{"1": 3, "2": 3, ...}`
    - `album`: `{"stickers": [10, 20...], "volumesClaimed": [1]}`
    - `cosmetics`: `{"equippedLivery": "default", "unlocked": ["vintage_brass"]}`
    - `piggyBank`: `{"storedCoins": 320, "lastBreak": 0}`
    - `schemaVersion`: 2
    - `updatedAt`: FieldValue.serverTimestamp()
  - Subcollection: `users/{uid}/ops/{opId}` (audit log of applied transactions).
- **Security Rules:** Client writes to `users/{uid}` are **strictly denied** (`allow write: if false`). All state mutations must pass through validated Cloud Functions (`applyOps`, `verifyPurchase`).

### 4. Deterministic Conflict Resolution
When merging local Hive state with cloud snapshot (e.g. on new device login):
1. **Level Progress:** `highestClearedLevel = max(local, cloud)`.
2. **Level Stars:** For every level `k`: `stars[k] = max(localStars[k], cloudStars[k])`.
3. **Sticker Album:** `stickers = union(localStickers, cloudStickers)`. Claimed volumes = `union(localClaimed, cloudClaimed)`.
4. **Cosmetics:** `unlocked = union(localUnlocked, cloudUnlocked)`.
5. **Boosters:** Individual balances reconciled via server-side op ledger replay.
6. **Coins:** Reconciled via server ledger balance; local temporary optimistic changes reconciled gracefully.

### 5. Regulatory Account Deletion (GDPR & Apple Guideline 5.1.1(v))
- Settings screen features a red "Delete Account & Data" action.
- Requires confirmation via a two-step destructive warning dialog.
- Flow:
  1. Calls `deleteAccount` Cloud Function.
  2. Cloud Function deletes `users/{uid}`, op subcollections, and race entries.
  3. Deletes Firebase Auth user record.
  4. Client clears all local Hive boxes (`save_box`, `album_box`, `pending_ops_box`).
  5. Navigates user back to fresh FTUE Level 1 state.
- External web deletion URL configured for Google Play Console Data Safety compliance.

## Affected Files
- `lib/core/sync/domain/models/sync_op.dart` (to be created)
- `lib/core/sync/data/sync_repository.dart` (to be created)
- `lib/core/sync/presentation/cubit/sync_cubit.dart` (to be created)
- `functions/src/sync/apply_ops.ts` (to be created)
- `functions/src/auth/delete_account.ts` (to be created)
- `firestore.rules` (changed: add user and ops security rules)

## Risks
- Clock drift or offline cheating. Mitigation: Server uses `serverTimestamp()`; validates sequence numbers monotonically.

## Open Questions
- None. Synchronization rules and privacy protocols match `phase/phase_2/05_OFFLINE_AND_CLOUD_SYNC.md` and `SHARED_CORE_STANDARD.md`.

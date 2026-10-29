Source docs: phase_2/05_OFFLINE_AND_CLOUD_SYNC.md, SHARED_CORE_STANDARD.md. Depends on: specs/tech/frontend-implementation-and-qa.md

# Spec: Offline-First Architecture, Identity, and Cloud Synchronization

## Status
Draft

## Type
New Feature

## Goal
Implement an offline-first synchronization architecture using Firebase Auth, Firestore operation logs (`ops`), idempotent conflict resolution, and privacy-compliant account deletion for Ants & Bees: Garden Trails Phase 2.

## Current State
Design documented in phase_2/05_OFFLINE_AND_CLOUD_SYNC.md and SHARED_CORE_STANDARD.md.
- Extends `specs/tech/frontend-implementation-and-qa.md`.
- Phase 1 used exclusively local persistence via Hive (`save_data`).
- Phase 2 introduces multi-device cloud synchronization, anonymous authentication linking, and server-authoritative ledger reconciliation.

## Proposed Change
Implement the sync client services in `apps/ants_bees/lib/core/sync/` and Firestore models:

### 1. Identity & Firebase Authentication
- **Anonymous Sign-In:** When launched online, app signs in anonymously in the background (`signInAnonymously()`). Offline launches queue authentication until network connection.
- **Provider Account Linking:** In Settings → Account, players can link their anonymous account to Google Sign-In (Android) or Sign in with Apple (iOS) via `linkWithProvider`.
- **Account Conflict Resolution:** If a linked credential already possesses a cloud save, the player is presented with a non-destructive choice:
  - Option A: "Use Cloud Garden" (restores cloud state, replacing local device save).
  - Option B: "Keep This Device's Garden" (cancels linking; current local garden remains unchanged).
- **Child Privacy:** Account linking is hidden for players within the under-13 ageBand (anonymous cloud backup only).

### 2. Firestore Document Model
All client writes are strictly denied; writes execute exclusively through Cloud Functions:
```
users/{uid}/
  state: {
    highestCleared: int,
    stars: Map<string, int>,
    coins: int,
    boosters: {hint: int, shield: int, hammer: int},
    streak: {days: int, lastDate: string, queensFavorUsed: bool},
    bank: {balance: int},
    wardrobe: {owned: List<string>, equipped: {ant: string, bee: string, board: string}},
    updatedAt: timestamp,
    clientRev: int
  }
users/{uid}/ops/{opId}: {
  type: string,
  naturalKey: string,
  payload: map,
  clientTimestamp: timestamp,
  serverTimestamp: timestamp,
  processed: bool
}
```

### 3. Op-Log & Conflict Resolution Rules
Every gameplay mutation creates a local op record with a UUID v4 `opId` and business `naturalKey`:
- **Progress & Stars (`clear:<level>`):** Merged using $max(local, cloud)$. Highest cleared level and star ratings never regress.
- **Coins & Boosters:** Reconciled via server-side balance computation from signed ledger ops (`grant`, `spend`). Coin duplication across offline devices is mathematically prevented.
- **Daily Streak:** Authoritative server time determines calendar streak continuity.
- **Album Stickers:** Deterministically derived from `highestCleared` (union merge).

### 4. Network Queue, Backoff & Sync Lifecycle
- `SyncService` maintains a local queue in Hive `sync_queue`.
- **Batch Dispatch:** When online, pending ops are dispatched to Cloud Function `applyOps` in batches of up to 50 operations.
- **Exponential Backoff:** Network retry intervals: 1s, 2s, 4s, 8s, up to max 60s jittered backoff.
- **Connectivity Listener:** `connectivity_plus` triggers automatic sync upon transitioning from offline to online.

### 5. Regulatory Account Deletion (Google Play & App Store Compliance)
- In-app "Delete My Account & Data" button in Settings.
- Two-step confirmation with permanent deletion warning.
- Calls Cloud Function `deleteAccount()`, which:
  1. Deletes all user documents in Firestore (`users/{uid}/...`).
  2. Cleans up race cohort memberships.
  3. Deletes Firebase Auth user record.
  4. Wipes local device Hive database and restarts app into fresh FTUE state.
- Web-hosted account deletion URL provided on the public store listing.

## Affected Files
- `apps/ants_bees/lib/services/account_service.dart` (to be created)
- `apps/ants_bees/lib/core/sync/sync_service.dart` (to be created)
- `apps/ants_bees/lib/core/sync/op_log_repository.dart` (to be created)
- `apps/ants_bees/lib/core/sync/models/sync_op.dart` (to be created)
- `apps/ants_bees/lib/features/ui/screens/account_settings_dialog.dart` (to be created)

## Risks
- Clock desynchronization between device and server; mitigated by using server timestamping during op application.

## Open Questions
- None. Firestore schema and synchronization rules match phase_2/05_OFFLINE_AND_CLOUD_SYNC.md.

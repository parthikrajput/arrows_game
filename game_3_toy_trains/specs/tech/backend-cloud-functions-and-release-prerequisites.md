Source docs: phase/phase_2/README.md §4, phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, phase/phase_2/05_OFFLINE_AND_CLOUD_SYNC.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/offline-and-cloud-sync.md, specs/meta/liveops-weekly-star-race.md, specs/economy/piggy-bank-and-cosmetics.md.

# Spec: Backend Cloud Functions & Release Prerequisites (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Specify the Cloud Functions architecture, Firestore security rules, server-side replay validator, and the ten release prerequisites (R1–R10) required prior to deploying Phase 2 (Levels 501–1000 + LiveOps) for Toy Trains: Wooden Railway Puzzle.

## Current State
Design documented in `phase/phase_2/README.md` §4 and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 ran purely client-side with local persistence and direct client IAP verification.
- Phase 2 requires server-side coordination for cloud saves, asynchronous tournaments, Piggy Bank fulfillment, and compliance.

## Proposed Change
Deploy backend services on Firebase (Node.js 20 / TypeScript) and fulfill release gating requirements:

### 1. Release Prerequisites Checklist (R1–R10)
| # | Requirement | Implementation Specification |
|---|---|---|
| **R1** | Firebase Auth Setup | Anonymous provider enabled; Google Sign-In (Android/iOS) and Sign in with Apple (iOS) credentials configured; multi-provider account linking enabled. |
| **R2** | Firestore Collections | Provision `users/{uid}`, `users/{uid}/ops/{opId}`, `races/{raceId}`, `races/{raceId}/members/{uid}`, `ghosts/{band}`. Deploy rules denying all direct client writes. |
| **R3** | Cloud Functions Suite | Deploy 7 production Cloud Functions with TypeScript type definitions (§2). |
| **R4** | Replay Validator | Compile pure-Dart `puzzle_core` engine to headless Node module (`dart compile js`) to validate submitted level move sequences. |
| **R5** | Ghost Pool Seeding | Pre-seed `ghosts/{band}` with >= 200 historical traces from QA/soft-launch per 100-level band; configure fallback synthetic generator. |
| **R6** | IAP Product Registration | Register `piggy_bank_49` consumable on Google Play Console and Apple App Store Connect; confirm ₹49 price point. |
| **R7** | Remote Config Defaults | Seed server defaults: `maxPhase = 2`, `featureFlags.race = true`, `featureFlags.album = true`, `featureFlags.piggy = true`, `featureFlags.cloudSync = true`. |
| **R8** | Privacy & Account Deletion | Update Privacy Policy URL, configure Play Console Data Safety form, deploy in-app deletion button (Apple 5.1.1(v)), and host web deletion URL. |
| **R9** | Level Pack CI Solvability | Run automated solver validation across all 500 Phase 2 levels: ensure 500/500 pass with 0 hearts lost and 0 boosters used. |
| **R10**| Load Testing | Conduct simulated stress test against Firebase emulator achieving target concurrency (e.g. 500 req/s on `applyOps` and `submitRaceClear`). |

### 2. Cloud Functions API Contracts

#### A. `applyOps`
- **Trigger:** HTTPS Callable (`functions.https.onCall`).
- **Request:** `{ ops: Array<SyncOp> }`.
- **Validation:** Authenticated `context.auth.uid`. Verifies monotonically increasing `clientSeq`. Rejects unauthorized mutations.
- **Action:** Batches writes to `users/{uid}` fields and records processed `opId` in `users/{uid}/ops/{opId}`.
- **Response:** `{ success: true, processedOps: number, serverTimestamp: number }`.

#### B. `verifyPurchase` (Updated from Phase 1)
- **Trigger:** HTTPS Callable.
- **Request:** `{ sku: string, purchaseToken: string, platform: 'android' | 'ios' }`.
- **Action:** Validates receipt with Google Play Developer API or Apple App Store Server API. If `sku === 'piggy_bank_49'`, reads current `piggyBank.storedCoins`, credits coins to `users/{uid}.coins`, resets `piggyBank.storedCoins = 0`, and writes transaction ledger op.
- **Response:** `{ verified: true, coinsGranted: number, newBalance: number }`.

#### C. `joinRace`
- **Trigger:** HTTPS Callable.
- **Request:** `{ levelBand: string }`.
- **Action:** Finds an open cohort in `races` for the given level band with `< 5` members. If none exists, creates a new race document with 48h expiration. If player is unmatched after 120s, backfills remaining slots with ghost runners.
- **Response:** `{ raceId: string, members: Array<RaceMember>, expiresAt: number }`.

#### D. `submitRaceClear`
- **Trigger:** HTTPS Callable.
- **Request:** `{ raceId: string, level: number, moves: number, durationMs: number, replayData?: string }`.
- **Action:** Validates race active status, human plausible duration (`durationMs >= par_moves * 800 ms`), increments player's race clear count in `races/{raceId}/members/{uid}`. If player reaches 15 clears, marks rank.
- **Response:** `{ currentClears: number, rank: number, isWinner: boolean }`.

#### E. `closeRace`
- **Trigger:** Scheduled Cron (`every monday 00:00 UTC`).
- **Action:** Queries all unfinalized weekend races, determines final rankings, generates reward claim vouchers in `races/{raceId}/rewards`, and sets `status = 'closed'`.

#### F. `claimRaceReward`
- **Trigger:** HTTPS Callable.
- **Request:** `{ raceId: string }`.
- **Action:** Verifies finalized race status and user rank; disburses tournament rewards (coins + boosters) directly into user document; marks voucher claimed.
- **Response:** `{ claimed: true, rewards: RaceReward }`.

#### G. `deleteAccount`
- **Trigger:** HTTPS Callable.
- **Request:** `{ confirmationText: 'DELETE' }`.
- **Action:** Deletes user's Firestore root doc, all subcollection ops, removes user from active race cohorts, and deletes Firebase Auth record.
- **Response:** `{ deleted: true }`.

### 3. Firestore Security Rules
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid}/{document=**} {
      allow read: if request.auth != null && request.auth.uid == uid;
      allow write: if false; // All mutations strictly routed through Cloud Functions
    }
    match /races/{raceId}/{document=**} {
      allow read: if request.auth != null;
      allow write: if false;
    }
    match /ghosts/{band}/{document=**} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

## Affected Files
- `functions/src/index.ts` (to be created: Cloud Functions entry points)
- `functions/src/sync/apply_ops.ts` (to be created)
- `functions/src/billing/verify_purchase.ts` (to be created)
- `functions/src/race/*.ts` (to be created)
- `functions/src/auth/delete_account.ts` (to be created)
- `firestore.rules` (to be created/updated)

## Risks
- Cold start latency for Cloud Functions on initial tournament joining. Mitigation: Min instances set to 1 for `submitRaceClear` during peak weekend race hours.

## Open Questions
- None. All endpoints, validation rules, and prerequisite checklists match `phase/phase_2/README.md` and `phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md`.

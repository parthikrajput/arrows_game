Source docs: phase/phase_2/README.md, phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, phase/phase_2/05_OFFLINE_AND_CLOUD_SYNC.md. Depends on: specs/tech/offline-and-cloud-sync.md, specs/meta/liveops-weekly-star-race.md.

# Spec: Tech — Backend Cloud Functions & Release Prerequisites

## Status
Draft

## Type
New Feature

## Goal
Specify the Firebase backend Cloud Functions, Cloud Firestore security rules, Firebase App Check enforcement, and the 10 release prerequisites (R1–R10) required to ship Yarn Unravel Phase 2 (Levels 501–1000 + LiveOps).

## Current State
Design documented in `phase/phase_2/README.md` (§3) and `phase/phase_2/05_OFFLINE_AND_CLOUD_SYNC.md`, not yet implemented.
- Phase 1 backend was limited to client-side analytics, Crashlytics, Remote Config, and receipt verification for coin packs and VIP subscriptions.
- Phase 2 introduces full cloud persistence, live tournament orchestration, server-side anti-cheat validation, and account deletion endpoints.

## Proposed Change
Deploy backend services to Firebase project and validate against release prerequisites:

### 1. Cloud Functions Architecture (Node.js / TypeScript)
All functions are callable Cloud Functions enforcing Firebase App Check and authenticated user sessions:

| Function Name | Trigger | Request Shape | Response Shape | Responsibilities |
|---|---|---|---|---|
| `applyOps` | Callable | `{ ops: List<OpMap> }` | `{ success: bool, serverSeq: int, rejectedOpIds: List<String> }` | Validates op UUIDs, checks idempotency, executes batch updates to `users/{uid}`, and increments server ledger. |
| `getCloudSave` | Callable | `{}` | `{ snapshot: Map<String, dynamic> }` | Fetches the authoritative user save snapshot for cloud restore or initial device sync. |
| `joinStarRace` | Callable | `{ weekKey: String, tzOffsetMin: int }` | `{ cohortId: String, members: List<MemberState> }` | Assigns player to an active 5-player weekly cohort; spawns ghost players from `ghostTraces` if pool unfulfilled after 10 min. |
| `reportRaceClear` | Callable | `{ weekKey: String, cohortId: String, level: int, stars: int, moves: int, solveDurationMs: int }` | `{ currentStars: int, rank: int }` | Enforces rate limit (>= 25 s per star); verifies moves against pre-computed level par; updates cohort scores. |
| `finalizeStarRaces` | Pub/Sub Schedule (Sun 23:59 UTC) | `{}` | `{ finalizedCohorts: int }` | Sweeps all active cohorts for the ending week, determines final rankings, mints coin/booster rewards into user documents. |
| `verifyPurchase` | Callable | `{ sku: String, purchaseToken: String, platform: 'android'\|'ios' }` | `{ verified: bool, entitlement: String, coinsCredited: int }` | Validates store receipts directly with Google Play Developer API and Apple App Store API; handles `yarn_piggy_bank` (₹49). |
| `deleteUserData` | Callable | `{ confirm: bool }` | `{ deleted: bool }` | Erases `users/{uid}`, subcollections, tournament records, and calls `auth.deleteUser(uid)`. |

### 2. Cloud Firestore Schema & Security Rules
- **Collections:**
  - `users/{uid}`: Authoritative document holding wallet balances, level stars, claimed album volumes, and equipped cosmetics.
  - `users/{uid}/ops/{opId}`: Audit trail of applied operations.
  - `races/{weekKey}/cohorts/{cohortId}`: Active tournament cohorts and member progress.
  - `ghostTraces/{traceId}`: Library of real, anonymized player star acquisition timings.
- **Security Rules:**
  - Direct client writes to any collection are strictly blocked: `allow write: if false;`.
  - Client read access is restricted to their own record:
    ```javascript
    rules_version = '2';
    service cloud.firestore {
      match /databases/{database}/documents {
        match /users/{userId} {
          allow read: if request.auth != null && request.auth.uid == userId;
          allow write: if false;
        }
        match /users/{userId}/ops/{opId} {
          allow read: if request.auth != null && request.auth.uid == userId;
          allow write: if false;
        }
        match /races/{weekKey}/cohorts/{cohortId} {
          allow read: if request.auth != null;
          allow write: if false;
        }
      }
    }
    ```

### 3. Firebase App Check
- Enforced on all callable Cloud Functions.
- **Android:** Play Integrity API.
- **iOS:** App Attest with DeviceCheck fallback.
- Unregistered clients or requests with invalid attestation tokens are rejected with HTTP 401 Unauthorized before invoking function logic.

### 4. Release Prerequisites (R1–R10)
Release gate: All 10 prerequisites must be satisfied prior to toggling Remote Config `maxPhase = 2`:

1. **R1 (Level Asset Validation):** All 500 levels in `assets/levels/phase_2.json.gz` pass CI validator checks without error.
2. **R2 (Engine Unit Tests):** All 49 mechanic controllers (M051–M099) achieve 100% test coverage in `packages/puzzle_core/test/mechanics/`.
3. **R3 (Save Migration Verification):** Local save migration v1 -> v2 tested on real device snapshots with zero data loss.
4. **R4 (Performance Budget Compliance):** 60 fps maintained on low-tier reference devices (DM-1) on 14x14 boards during active pan and pinch gestures.
5. **R5 (Authentication Providers):** Anonymous auth, Google Sign-In, and Sign in with Apple verified on iOS and Android test devices.
6. **R6 (Security Rule Verification):** Firestore security rules pass automated emulator red-team tests preventing direct client document tampering.
7. **R7 (App Check Deployment):** App Check active in enforce mode with zero false-positive rejections in staging.
8. **R8 (Remote Config Parameters):** All Phase 2 parameters verified in staging console (`maxPhase`, `star_race_*`, `piggy_*`, `album_*`, `cosmetic_prices`).
9. **R9 (Store SKU & Policy Approval):** In-app purchase SKU `yarn_piggy_bank` (₹49) approved in Google Play Console and App Store Connect; Privacy labels updated.
10. **R10 (Tournament Dogfooding):** Weekly Star Race successfully runs for 2 consecutive weeks in internal staging with ghost fill operational and zero payout bugs.

## Affected Files
- `functions/src/index.ts` (to be created: Cloud Functions entry point)
- `functions/src/sync/*.ts` (to be created: `applyOps`, `getCloudSave`, `deleteUserData`)
- `functions/src/race/*.ts` (to be created: `joinStarRace`, `reportRaceClear`, `finalizeStarRaces`)
- `functions/src/billing/verify_purchase.ts` (changed: add piggy bank validation)
- `firestore.rules` (to be created: production security rules)

## Risks
- Server cold-start latency on callable functions during high-volume tournament hours. Mitigated by setting minimum instances = 1 for `reportRaceClear`.

## Open Questions
None. All 10 release prerequisites and function signatures match Phase 2 documentation.

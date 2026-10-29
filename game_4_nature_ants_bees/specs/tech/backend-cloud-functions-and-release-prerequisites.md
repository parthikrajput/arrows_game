Source docs: phase_2/README.md, phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, phase_2/05_OFFLINE_AND_CLOUD_SYNC.md, SHARED_CORE_STANDARD.md. Depends on: specs/tech/offline-and-cloud-sync.md

# Spec: Backend Cloud Functions and Phase 2 Release Prerequisites

## Status
Draft

## Type
New Feature

## Goal
Specify the Cloud Functions architecture, Firestore security rules, Firebase App Check enforcement, and the ten release prerequisites (R1–R10) required to launch Phase 2 for Ants & Bees: Garden Trails.

## Current State
Design documented in phase_2/README.md §3, phase_2/04, and phase_2/05, not yet implemented.
- Extends `specs/tech/offline-and-cloud-sync.md`.
- Phase 1 had zero backend dependencies.
- Phase 2 introduces server-side validation, weekly star race matchmaking, secure ledger accounting, and compliance prerequisites.

## Proposed Change
Implement the Cloud Functions suite in TypeScript/Node.js and configure the backend release infrastructure:

### 1. Cloud Functions Architecture (Node.js 20, TypeScript)
| Function Name | Trigger | Auth / App Check | Purpose |
|---|---|---|---|
| `applyOps` | HTTPS Callable | User Auth + App Check | Validates and commits batches of client synchronization operations into Firestore. |
| `raceJoin` | HTTPS Callable | User Auth + App Check | Evaluates race eligibility, assigns racer to a 5-player cohort, and returns initial state. |
| `raceGhostTick`| Cloud Scheduler (every 5 min) | Internal | Advances simulated ghost racers according to historical progression curves. |
| `raceFinalize` | Cloud Scheduler (every 30 min) | Internal | Evaluates cohorts whose window has expired, runs top-3 replay verification, sets final ranks. |
| `raceClaim` | HTTPS Callable | User Auth + App Check | Issues idempotent reward grant for completed race placement. |
| `verifyPurchase`| HTTPS Callable | User Auth + App Check | Validates Google Play Billing and iOS App Store receipts; cracks open Honeycomb Bank. |
| `deleteAccount` | HTTPS Callable | User Auth | Completely wipes user data across Firestore, Auth, and active cohorts. |

### 2. Firestore Security Rules
- Client writes are completely denied across all collections (`write: if false`).
- Document reads are restricted:
  - `users/{uid}/**`: Readable only by authenticated user where `request.auth.uid == uid`.
  - `races/{raceId}/cohorts/{cohortId}/members/{memberId}`: Readable only by members of that same cohort.
- Automatic Time-To-Live (TTL) policy configured on `users/{uid}/ops` collection (deletes processed ops older than 30 days).

### 3. Server Level Index & Plausibility Engine
- Server deploys a bundled binary index `assets/server_level_index.json` containing level metadata for Levels 1–1000:
  - Level slot, tag, and expected coin grant.
  - Par moves ($M_{opt}$) for anti-cheat verification.
- Plausibility engine validates move speeds ($\ge 250\text{ ms/move}$) and timestamps before committing race scores.

### 4. Ten Release Prerequisites (R1–R10 Checklist)
- **R1 (Firebase Auth):** Anonymous authentication enabled; Google Sign-In and Sign in with Apple configured with production OAuth credentials.
- **R2 (Cloud Firestore):** Collections initialized with strict security rules and operational TTL policies.
- **R3 (Cloud Functions):** 7 core functions deployed and unit tested against Firebase Local Emulator Suite.
- **R4 (App Check):** Play Integrity (Android) and App Attest (iOS) enforced with safety monitoring.
- **R5 (Server Level Index):** Levels 1–1000 metadata deployed alongside Cloud Functions.
- **R6 (Store IAP Setup):** Product SKU `piggy_bank` (₹49 consumable) registered in Google Play Console and App Store Connect; Data Safety form updated.
- **R7 (Account Deletion):** In-app account wipe button verified and public deletion URL hosted on company support domain.
- **R8 (Remote Config):** Launch flags deployed: `maxPhase = 2`, `race_enabled = true`, `piggy_enabled = true`.
- **R9 (Emulator Test Suite):** Automated CI tests for concurrent op resolution and race ghosting pass with 100% green status.
- **R10 (Load Testing):** Scheduled race finalization verified under load of 50,000 simulated weekend cohorts with cold-start latency < 1,500 ms.

## Affected Files
- `backend/functions/package.json` (to be created)
- `backend/functions/src/index.ts` (to be created)
- `backend/functions/src/sync/apply_ops.ts` (to be created)
- `backend/functions/src/race/race_handlers.ts` (to be created)
- `backend/functions/src/economy/verify_purchase.ts` (to be created)
- `backend/functions/src/account/delete_account.ts` (to be created)
- `backend/firestore.rules` (to be created)
- `backend/firestore.indexes.json` (to be created)

## Risks
- Sudden spikes in Cloud Function invocations during Sunday evening race finalization; mitigated by caching and scheduled staggered batch processing.

## Open Questions
- None. Prerequisite matrix and backend functions correspond to phase_2/README.md §3.

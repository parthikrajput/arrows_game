Source docs: phase_2/README.md §4, phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, phase_2/05_OFFLINE_AND_CLOUD_SYNC.md, ../../SHARED_CORE_STANDARD.md §13, §17.38. Depends on: specs/tech/frontend-implementation-and-qa.md, specs/tech/offline-and-cloud-sync.md.

# Spec: Tech — Cloud Functions Backend & Release Prerequisites

## Status
Draft

## Type
New Feature

## Goal
Specify the Cloud Functions for Firebase backend endpoints, server data models, security rules, and production deployment release prerequisites (R1–R10) required to launch Phase 2.

## Current State
Design documented in `phase_2/README.md` §4, `phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md`, and `phase_2/05_OFFLINE_AND_CLOUD_SYNC.md`, not yet implemented.
- Phase 1 used a single Cloud Function: `verifyPurchase` for basic IAP receipt validation.
- Phase 2 expands backend responsibilities to support cloud sync, Star Race cohorts, Piggy Bank transactions, and account lifecycle management.

## Proposed Change
Deploy Cloud Functions (Node.js 20 / TypeScript) and verify all 10 release prerequisites before promoting Phase 2 to production:

### 1. Release Prerequisites Checklist (R1–R10)
| # | Prerequisite | Detailed Requirements | Verification Doc |
|---|---|---|---|
| **R1** | Firebase Auth | Anonymous provider enabled; Google Sign-In and Sign in with Apple configured with production fingerprints (SHA-1/SHA-256 for Android, Apple Service ID for iOS). | `phase_2/05 §3` |
| **R2** | Cloud Firestore | Collections `users/{uid}`, `races/{weekKey}`, `ghostPool/{band}` provisioned. Security rules deployed: client read-own only, direct client writes blocked (`allow write: if false`). | `phase_2/05 §5` |
| **R3** | Cloud Functions | Functions `syncPush`, `mergeAnonymous`, `deleteAccount`, `verifyPurchase`, `raceJoin`, `raceProgress`, and scheduled `raceFinalize` deployed. | `phase_2/05`, `04` |
| **R4** | Server Level Data | `phase_2.json.gz` bundled inside the Cloud Functions environment for server-side `par_moves` plausibility checks. | `phase_2/04 §3.7` |
| **R5** | Ghost Pool Seed | >= 200 anonymized historical runs per level band seeded into `ghostPool/{band}/runs` to ensure seamless 5-player cohort fills. | `phase_2/04 §3.5` |
| **R6** | IAP Setup | Consumable IAP `piggy_bank` (₹49) approved and active in Google Play Console and App Store Connect. | `phase_2/04 §4` |
| **R7** | Remote Config | `maxPhase = 2` rollout flag, economy keys, and feature flags (`album`, `race`, `piggy`, `cosmetics`, `cloudSync`) published. | `phase_2/01 §9` |
| **R8** | Privacy & Deletion | Updated Data Safety / App Privacy labels, Privacy Policy live, and in-app account deletion functioning end-to-end. | `phase_2/05 §10` |
| **R9** | Monitoring | Cloud Functions error rate alerts (> 1%), Firestore quota alerts (> 80%), and Crashlytics velocity alerts active. | `phase_2/06 §9` |
| **R10**| CI Gate | 100% of L501–1000 levels pass CI validator, all Rush seeds L525...1000 verified, and P0 QA checklist rows Pass. | `phase_2/06 §10` |

### 2. Cloud Functions API Specifications

#### A. `syncPush` (Callable HTTPS)
- **Purpose:** Batch upload of queued client ops, applying deterministic merges and ledger updates.
- **Request:** `{ ops: List<OpDoc>, clientSnapshotVersion: int }`
- **Response:** `{ appliedOpIds: List<String>, rejectedOpIds: List<String>, serverSnapshot: SnapshotDoc }`
- **Behavior:** Executes in a Firestore transaction. Deduplicates via `users/{uid}/keys/{semanticKey}`. Writes to `users/{uid}/ops/{opId}`.

#### B. `mergeAnonymous` (Callable HTTPS)
- **Purpose:** Merges an anonymous guest account into an existing authenticated account when linking encounters `credential-already-in-use`.
- **Request:** `{ anonIdToken: String }`
- **Response:** `{ success: bool, newSnapshot: SnapshotDoc }`
- **Behavior:** Verifies `anonIdToken`, replays anonymous ops into target UID, deletes anonymous Firebase Auth user and Firestore doc.

#### C. `deleteAccount` (Callable HTTPS)
- **Purpose:** Complete account and data deletion for GDPR / App Store Guideline 5.1.1(v) compliance.
- **Request:** `{ confirmation: bool }`
- **Response:** `{ success: bool }`
- **Behavior:** Deletes `users/{uid}` and all subcollections, removes user from active race cohorts, deletes Firebase Auth record.

#### D. `verifyPurchase` (Callable HTTPS)
- **Purpose:** Cryptographic receipt validation for store IAPs.
- **Request:** `{ sku: String, purchaseToken: String, orderId: String, currentPiggyBalance: int? }`
- **Response:** `{ status: "valid"|"invalid", grantedCoins: int, newSnapshot: SnapshotDoc }`
- **Behavior:** Validates with Google Play / App Store APIs. For `piggy_bank`, calculates `grant = min(currentPiggy, 1000)`, credits wallet, and resets `piggy = 0`.

#### E. `raceJoin` (Callable HTTPS)
- **Purpose:** Assigns player to an active weekend Star Race cohort.
- **Request:** `{ weekKey: String, tzOffsetMin: int, highestCleared: int }`
- **Response:** `{ cohortId: String, members: List<Racer>, windowEndUtc: String, startLevel: int }`
- **Behavior:** Finds matching open cohort in same timezone bucket and level band (±150), or instantiates a new cohort.

#### F. `raceProgress` (Internal Callable / Triggered via `syncPush`)
- **Purpose:** Submits level clears to active race cohort and runs plausibility checks.
- **Payload:** `{ weekKey: String, level: int, moves: int, durationMs: int, monoElapsedMs: int }`
- **Validation:** Evaluates window, sequence, par moves, duration, and rate. Flags or excludes suspicious entries.

#### G. `raceFinalize` (Scheduled Pub/Sub — Every 15 minutes)
- **Purpose:** Resolves completed cohorts, computes final rankings, awards ledger credits, and populates ghost pool with anonymized runs.

## Affected Files
- `functions/src/index.ts` (to be created / extended)
- `functions/src/sync/sync_push.ts` (to be created)
- `functions/src/auth/account_lifecycle.ts` (to be created)
- `functions/src/race/race_manager.ts` (to be created)
- `functions/src/economy/verify_purchase.ts` (to be created)
- `firestore.rules` (to be deployed by firestore-rules-author)

## Risks
- Cloud Functions cold starts causing perceived delay during Star Race join or Piggy Bank purchase. Mitigated by setting minimum instances = 1 for critical functions during weekend race windows.
- Firestore transaction contention on race cohort documents. Handled via exponential retry on the client.

## Open Questions
- None. Backend endpoints, schema, and validation rules strictly match `phase_2/04` and `phase_2/05`.

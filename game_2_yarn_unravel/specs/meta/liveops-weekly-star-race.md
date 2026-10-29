Source docs: phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/tech/offline-and-cloud-sync.md, specs/tech/backend-cloud-functions-and-release-prerequisites.md.

# Spec: Meta — Weekly Star Race ("Cozy Cup")

## Status
Draft

## Type
New Feature

## Goal
Implement the Weekly Star Race ("Cozy Cup") asynchronous live tournament for Yarn Unravel Phase 2, including 5-player weekly cohort matchmaking, 50-star progression tracks, ghost fill with realistic anonymized replay traces, server-side anti-cheat plausibility checks, and automated prize payouts.

## Current State
Design documented in `phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 contained local leaderboards via platform services (`games_services`) without real-time multiplayer tournaments.
- Phase 2 introduces an asynchronous 5-player competition running on a weekly cadence backed by Firebase Cloud Functions.
- Requires internet connectivity for joining and reporting clears, while allowing level gameplay itself to continue offline.

## Proposed Change
Implement the Star Race tournament system:

### 1. Tournament Schedule & Cohort Rules
- **Eligibility:** Unlocks automatically when `highestCleared >= 60`.
- **Cadence:** Weekly event. Starts Monday 00:00 UTC; ends Sunday 23:59 UTC.
- **Goal:** First player in the cohort to reach **50 stars** gained during the active week wins. If no player reaches 50 stars by Sunday 23:59 UTC, standings are ranked by total stars accumulated.
- **Matchmaking (5-Player Cohort):**
  - Upon tapping "Join Cozy Cup", client calls `joinStarRace` Cloud Function.
  - Server matches the player into an open 5-player cohort `cohortId` with similar progress band.
  - **Ghost Fill:** If fewer than 5 real players join within 10 minutes, the server populates remaining slots with ghost players drawn from pre-recorded, anonymized real historical player traces (`ghostTraces` Firestore collection). Ghost progressions mimic realistic human play intervals (3–8 minute gaps).

### 2. Rewards Structure
Prizes paid out automatically upon race finalization:

| Finish Position | Coin Reward | Boosters / Badges |
|---|---|---|
| **1st Place** | **500 Coins** | 1 Golden Scissors + "Cozy Cup Champion" trophy |
| **2nd Place** | **250 Coins** | 1 Needle Glow Hint |
| **3rd Place** | **100 Coins** | 1 Thimble Shield |
| **4th & 5th Place** | **20 Coins** | Participation reward |

### 3. Server-Side Plausibility & Anti-Cheat Validation
All star gains are reported via callable Cloud Function `reportRaceClear`:
- **Speed Limit:** Minimum allowed time per star is **25 seconds** (no human can solve a 12x12 board with 24 threads in under 25 s).
- **Burst Check:** Reports claiming > 3 stars in < 75 seconds are flagged and rejected with code `E-RACE-RATE-LIMIT`.
- **Level Verification:** Client must report the level number, stars earned (1–3), and move count. The server validates that the move count is within plausible bounds of the level's pre-computed par moves.
- **Timezone Anti-Cheat:** Device clock manipulation is prevented by enforcing server timestamps (`request.time`) for all progression increments.

### 4. Offline Handling & Sync Resilience
- If the player goes offline during the week, level completions continue to record stars in the local Hive box `race`.
- When connectivity is restored, the client flushes queued star reports via `reportRaceClear`.
- **Grace Period:** If a tournament week concludes while the player is offline, the client has a 24-hour grace window (until Monday 23:59 UTC) to sync stars earned before Sunday midnight.

### 5. Data Models
- **Local Hive Box (`race`):**
  - `weekKey: String` (e.g., `"2026-W44"`).
  - `cohortId: String`.
  - `joinedAt: int` (epoch ms).
  - `clears: List<Map<String, dynamic>>` (queued clears).
  - `tzOffsetMin: int`.
- **Firestore Collections:**
  - `races/{weekKey}/cohorts/{cohortId}`: Document holding member IDs, current star tallies, and finish timestamps.
  - `races/{weekKey}/cohorts/{cohortId}/members/{uid}`: Detailed member telemetry.

## Affected Files
- `lib/features/star_race/data/star_race_repository.dart` (to be created: join, report, and cache)
- `lib/features/star_race/bloc/star_race_bloc.dart` (to be created: race track UI state and standings)
- `lib/features/star_race/view/cozy_cup_track_widget.dart` (to be created: 5-lane visual race track)
- `functions/src/race/join_star_race.ts` (to be created: cohort matchmaking and ghost fill)
- `functions/src/race/report_race_clear.ts` (to be created: plausibility validation and score update)
- `functions/src/race/finalize_star_races.ts` (to be created: scheduled weekly finalization and payout)

## Risks
- Ghost players appearing unnatural or perfectly uniform. Mitigated by sampling real historical completion times with added Gaussian jitter.

## Open Questions
None. Anti-cheat parameters and reward tiers match `SHARED_CORE_STANDARD.md`.

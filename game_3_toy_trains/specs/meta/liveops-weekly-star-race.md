Source docs: phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/meta/daily-challenge-and-streak.md, specs/gameplay/level-progression-0501-1000.md, specs/tech/backend-cloud-functions-and-release-prerequisites.md.

# Spec: Weekly Star Race Meta-System (Star Express Race)

## Status
Draft

## Type
New Feature

## Goal
Specify the asynchronous competitive Weekly Star Race ("Star Express Race") for Toy Trains: Wooden Railway Puzzle, establishing tournament entry criteria (L60 clear), weekend scheduling, 5-player async cohort matching, ghost profile backfill, Cloud Functions plausibility validation, and reward disbursement.

## Current State
Design documented in `phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 contained only local daily timetable challenges and platform achievements (`specs/meta/daily-challenge-and-streak.md`).
- Players lacked social or competitive goals to motivate weekend sessions.
- Phase 2 introduces lightweight, low-stress asynchronous tournaments requiring online connectivity for matchmaking and progress submission.

## Proposed Change
Implement the Star Express Race client module and server contracts:

### 1. Tournament Schedule & Cohort Rules
- **Unlock Requirement:** Reaching and clearing Level 60.
- **Schedule:** Activates every weekend from Saturday 08:00 to Sunday 23:59 local player time.
- **Cohort Size:** Exactly 5 players per race instance (`races/{raceId}`).
- **Matchmaking Window:**
  - Player taps "Join Race" on Home or Level Map.
  - Server matches player with 4 other active players in the same level band (e.g. Band 501–600).
  - Matchmaking timeout is 120 seconds. If fewer than 5 real players join, vacant slots are backfilled using historical ghost traces (`ghosts/{band}`) or synthetic ghost runners.
- **Race Goal:** First player in the cohort to achieve **15 first-clears** of main campaign levels wins. If nobody reaches 15 clears by Sunday 23:59, rankings are determined by highest level count cleared during the active race window.

### 2. Ghost Backfill & Plausibility
- **Ghost Pool:** Firestore collection `ghosts/{band}` stores anonymous replay progress streams from previous cohorts.
- **Synthetic Ghosts:** If `ghosts/{band}` has fewer than 200 records, the server synthesizes ghost progress using:
  - Base interval = level's `par_moves × 1.8 s` + random human hesitation (15–45 s).
  - Randomized sleep windows between levels (5–30 minutes) to simulate casual mobile play sessions.
- **Anti-Cheat & Server Plausibility Validation:**
  - When the client calls `submitRaceClear(raceId, levelNumber, moves, durationMs, replayDigest)`:
  - Server verifies:
    1. Level number is consecutive with player's known campaign progress.
    2. `durationMs >= par_moves × 800 ms` (rejects instant automated clears).
    3. `moves >= min_moves` for that level seed.
  - Suspicious submissions are flagged and rejected from the tournament leaderboard without banning the local offline campaign.

### 3. Tournament Rewards
Disbursed when a player reaches 15 clears or when claiming results after Sunday 23:59:

| Rank | Coin Reward | Booster Rewards | Special Item |
|---|---|---|---|
| **1st Place** | **500 coins** | 2x Green Signal Hint, 2x Cowcatcher Shield, 2x Track Crane | "Gold Conductor Cap" Avatar Badge |
| **2nd Place** | **250 coins** | 1x Green Signal Hint, 1x Cowcatcher Shield | — |
| **3rd Place** | **100 coins** | 1x Green Signal Hint | — |
| **4th & 5th** | **50 coins** | Consolation coin grant | — |

### 4. UI/UX Screens & Indicators
- **Home & Map Widget:** Animated locomotive icon on tracks showing current position ("2nd - 8/15 trains dispatched").
- **Race Leaderboard Modal:** Displays 5 locomotive tokens on a horizontal wooden track progression bar.
- **Level Complete Toast:** Inline progress indicator ("Star Race: 9/15 (+1)!") shown smoothly without blocking level exit transitions.

## Affected Files
- `lib/features/meta/race/domain/models/race_cohort.dart` (to be created)
- `lib/features/meta/race/presentation/bloc/race_bloc.dart` (to be created)
- `lib/features/meta/race/presentation/screens/race_leaderboard_dialog.dart` (to be created)
- `functions/src/race/join_race.ts` (to be created)
- `functions/src/race/submit_race_clear.ts` (to be created)
- `functions/src/race/close_race.ts` (to be created)

## Design
- Screen: Star Express Race Leaderboard Dialog with brass miniature locomotives sliding along wooden track grooves.
- Design Tokens: Gold `#FFD700`, Bronze `#CD7F32`, Silver `#C0C0C0`, Railway Blue `#1A365D`.

## Risks
- Cheating or clock manipulation on client side. Mitigation: Cloud Functions validate timestamps and duration limits; clock skew check against Firebase server timestamp.

## Open Questions
- None. All cohort sizes, timers, and reward tables match `phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` and `SHARED_CORE_STANDARD.md`.

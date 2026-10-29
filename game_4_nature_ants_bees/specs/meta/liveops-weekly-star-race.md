Source docs: phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, SHARED_CORE_STANDARD.md. Depends on: specs/meta/daily-challenge-and-streak.md

# Spec: LiveOps Weekly Star Race

## Status
Draft

## Type
New Feature

## Goal
Implement the Weekly Star Race ("Garden Dash"), an asynchronous 5-player competitive event running every weekend, featuring matchmaking cohorts, server-side ghost fill, strict anti-cheat plausibility verification, and tiered rewards for Ants & Bees: Garden Trails.

## Current State
Design documented in phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md and SHARED_CORE_STANDARD.md.
- Extends `specs/meta/daily-challenge-and-streak.md`.
- Unlocks when player clears Level 60 (`highestCleared >= 60`).
- No direct synchronous multiplayer; operates via asynchronous 5-member cohorts matched by progression bracket and timezone.

## Proposed Change
Implement the race client modules in `apps/ants_bees/lib/features/race/` and backend callables:

### 1. Event Schedule & Format
- **Time Window:** Saturday 08:00 to Sunday 23:59 device local time (approx. 40 hours). Joining allowed until Sunday 12:00.
- **Cohort Size:** 5 racers per cohort.
- **Race Objective:** First player to clear **15 numbered levels** (first-time clears only) during the race window.
- **Eligibility:** Content remaining: $\text{maxPhaseLastLevel} - \text{highestCleared} \ge 15$. (Players who cleared all available levels see "New gardens coming — race paused").
- **Scoring:** Ranked by levels cleared (descending), then by server timestamp of reaching that count (ascending). Replays, Daily challenges, and Rush bonus rounds do not count toward race total.

### 2. Matchmaking & Ghost Filling
- **Bracket Matching:** Players matched within $\pm 100$ levels of progression and $\pm 3$ hours timezone offset.
- **Ghost Fill Rule:** If a cohort has fewer than 5 real players 2 hours after creation, the server fills remaining slots with simulated racers ("ghosts").
- **Ghost Disclosure:** Ghost racers are explicitly marked with a visible **"Practice racer"** badge. Ghost progress follows an anonymized historical curve. Ghosts occupy leaderboard positions but never claim rewards.
- **Child-Safe Identity:** All players use generated names ("Brave Ladybug 42", "Swift Honeybee 17") and select from 12 preset nature avatars. Free-text names and player chat are strictly disallowed.

### 3. Server-Side Plausibility & Anti-Cheat Validation
Managed via Cloud Function `raceSubmit` (via `applyOps` op `race_clear`):
1. **Sequential Clearance:** Level cleared must equal previous race max + 1.
2. **First-Time Clearance:** Target level must not exist in user's previously cleared level set.
3. **Plausibility Speed Cap:** $\text{durationMs} \ge 250 \times \text{moves}$ (at least 250 ms per move); minimum 15 seconds between race level reports.
4. **Move Threshold:** Total moves taken must be $\ge \text{par\_moves}$ for that level.
5. **Rate Limiting:** Maximum 40 race clears per hour.
6. **Time Skew:** Client timestamp must fall within $[windowStartUtc, windowEndUtc] \pm 5\text{ min}$.
7. **App Check:** Requires valid Play Integrity / DeviceCheck token.
8. **Top-3 Deterministic Replay Verification:** Prior to finalizing rewards, the top 3 finishers have their uploaded session replay verified server-side by `packages/puzzle_core` test harness.

### 4. Race Rewards
| Rank | Rewards |
|---|---|
| **1st Place** | **1,000 coins + "Race Champion" profile frame + 3 Hints + 3 Shields + 3 Leaf Blowers** |
| **2nd Place** | **500 coins + 2 Leaf Blowers + 1 Nectar Glow Hint** |
| **3rd Place** | **250 coins + 1 Queen's Royal Shield** |
| **4th–5th Place**| **50 coins** |

- Claiming requires at least 1 verified level clear during the event. Unclaimed rewards persist for 14 days in Firestore.

## Affected Files
- `apps/ants_bees/lib/features/race/bloc/race_bloc.dart` (to be created)
- `apps/ants_bees/lib/features/race/models/race_cohort.dart` (to be created)
- `apps/ants_bees/lib/features/race/services/race_service.dart` (to be created)
- `apps/ants_bees/lib/features/race/ui/race_hub_dialog.dart` (to be created)
- `apps/ants_bees/lib/features/race/ui/race_podium_screen.dart` (to be created)
- `backend/functions/src/race/` (Cloud Functions)

## Risks
- Time zone spoofing by changing device clock; mitigated by converting local window to server UTC at join time.

## Open Questions
- None. Rules, ghost specifications, and rewards strictly conform to phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md §3.

Source docs: phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md §3, ../../SHARED_CORE_STANDARD.md §17.26. Depends on: specs/meta/daily-challenge-and-streak.md, specs/tech/frontend-implementation-and-qa.md.

# Spec: LiveOps — Weekly Star Race

## Status
Draft

## Type
New Feature

## Goal
Implement the Weekly Star Race competitive asynchronous event: a 5-player race cohort where players compete to be the first to clear 15 new numbered levels between Saturday 08:00 and Sunday 23:59 local time, featuring transparent historical ghost fill, server-side plausibility validation, and podium rewards.

## Current State
Design documented in `phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` §3 and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 leaderboard used system services (`games_services`) for highest level and streaks.
- There was no cohort-based asynchronous racing or time-windowed competitive event.

## Proposed Change
Implement the Weekly Star Race client flow, cohort matching, and server plausibility checks:

### 1. Event Schedule & Cohort Rules
- **Unlock Level:** `highestCleared >= 60`.
- **Event Window:** Every weekend from **Saturday 08:00 to Sunday 23:59:59 local time** (~40 hours).
- **Timezone Grouping:** Players are grouped into cohorts sharing the same UTC offset bucket (15-minute granularity).
- **Join Cutoff:** Sunday 12:00 local time. After this cutoff, the banner displays "Next race Saturday 08:00".
- **Cohort Size:** Exactly 5 racers per cohort.
- **Goal:** First racer to achieve **15 first-time clears on numbered levels**. Replays, Daily Challenges, and Coin Rush bonus rounds do not advance race progress.
- **Content Requirement:** `maxLevel - highestCleared >= 15` at join time.

### 2. Ghost Fill (Historical Runs)
- Zero lobby wait time: player joins immediately.
- Pending cohort slots display "Finding racer..." for up to 10 minutes. If real players do not fill all 5 slots within 10 minutes, empty slots are filled from `ghostPool/{band}` with historical anonymized runs.
- Ghost racers display generated jungle names (e.g. "Mossy Toad", "Swift Gecko") and a distinct **"replay racer" leaf icon** for total transparency (no false claims of live players).

### 3. Server Plausibility Validation (§3.7)
Every `race_clear` uploaded via callable `raceProgress` is evaluated against 6 server rules:
1. **Window:** Clear timestamp falls within `[joinUtc, windowEndUtc]`.
2. **Sequence:** Level equals previous race level + 1 (starting at `highestCleared + 1`).
3. **Moves:** Moves taken >= `par_moves` of that level (from server level metadata).
4. **Duration:** Clear duration >= `max(5000 ms, par_moves * 250 ms)`.
5. **Rate:** Interval between two clears >= previous clear duration - 2 seconds.
6. **Time Budget:** Sum of durations <= elapsed time since join + 60 seconds.
- *Flags:* 1–2 flags keep the clear active under review. 3 flags mark the entry `excluded` (disqualified from ranking and rewards).

### 4. Ranking & Podium Rewards
- Finisher ordering: Completion time of the 15th level.
- Non-finisher ordering: Total levels cleared descending, then timestamp of last clear ascending.
- Ghost racers occupy rank positions; real players receive the reward corresponding to their achieved rank.
- **Rewards Table:**
  | Rank | Reward |
  |---|---|
  | **🥇 1st** | **1,000 coins + Golden Crown frame + 3 of each booster** (3 Hint, 3 Shield, 3 Hammer) |
  | **🥈 2nd** | **500 coins + 2 Magic Stone Hammer + 1 Glow Firefly Hint** |
  | **🥉 3rd** | **250 coins + 1 Safety Shell Shield** |
  | **4th–5th** | **50 coins** |

- Permanent cosmetic **Golden Crown frame** unlocked on first 1st-place finish (subsequent wins increment crown counter on the frame).
- Players who cleared 0 levels receive 0 rewards (participation requires >= 1 level cleared).

### 5. Offline Playing & Synchronization
- **Join Requirement:** Must be online to join a cohort.
- **Mid-Race Offline Play:** Players can play offline; level clears queue in local Hive op-log.
- **Upload Deadline:** Queued clears must sync before `windowEndUtc + 30 minutes` using monotonic server-anchored timestamps (`lastServerUtc + elapsedMonotonic`).
- Device clock changes do not manipulate race time.

## Affected Files
- `lib/features/race/domain/models/race_cohort.dart` (to be created)
- `lib/features/race/presentation/bloc/race_bloc.dart` (to be created)
- `lib/features/race/presentation/screens/star_race_screen.dart` (to be created)
- `lib/features/race/presentation/widgets/race_progress_bar.dart` (to be created)
- `lib/features/race/data/repositories/race_repository.dart` (to be created)

## Design
- Screen: 5-lane vertical running track with animated snake avatars, crown markers, and live progress beads.
- Design tokens: Vibrant tournament banners, trophy gold `#FFD700`, leaderboard podium view.

## Risks
- Latency and offline sync edge cases near the Sunday 23:59 cutoff. Mitigated by the 30-minute upload grace period.

## Open Questions
- None. Rules, cutoffs, and rewards match `phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` §3.

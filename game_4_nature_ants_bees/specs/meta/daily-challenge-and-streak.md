Source docs: phase_1/05_DAILY_CHALLENGE_AND_STREAK.md, SHARED_CORE_STANDARD.md

# Spec: Daily Challenge, Streak System, and Meta Progression

## Status
Draft

## Type
New Feature

## Goal
Implement the Daily Garden Almanac, 7 weekday gameplay modifiers, 7-day streak ladder, Queen's Favor streak saver, anti-cheat validation, and platform leaderboards for Ants & Bees: Garden Trails Phase 1.

## Current State
Design documented in phase_1/05_DAILY_CHALLENGE_AND_STREAK.md and SHARED_CORE_STANDARD.md, not yet implemented.
- Unlocks upon clearing Level 15.
- 1 unique deterministic puzzle per calendar day derived from date seed.
- 7-day streak ladder awarding 1,150 coins plus boosters over a full week.
- Streak saver allows 1 repair per 7-day cycle via ad or 200 coins.
- Offline support with monotonic clock anti-cheat.
- Platform leaderboards via `games_services` for Android Google Play Games and iOS Game Center.

## Proposed Change
Implement the daily and meta modules in `apps/ants_bees/lib/features/daily/`:

### 1. Daily Garden Almanac Overview
- **Unlock Condition:** Cleared Level 15.
- **Access Points:** Level Map banner, Home screen side card.
- **Generation:** Deterministic PRNG seed = `hash64("ants_bees", dateString_YYYY_MM_DD, "daily_v1")`.
- **Completion Reward:** +100 coins (Sunday awards +200 coins) + streak progress step.

### 2. 7 Weekday Modifiers
| Day | Modifier Name | Themed Mechanics & Gameplay Rule |
|---|---|---|
| **Monday** | **Dewy Start** | Morning Mist (M010) covers 2–3 board patches; lines obscured until cleared by adjacent moves. |
| **Tuesday** | **Par Moves** | Solver computes optimal moves $M_{opt}$; Par = $M_{opt} + 3$. Clearing over Par loses 1 Star per extra 2 moves. |
| **Wednesday** | **Swarm Speed** | Clear within target time (e.g. 45 seconds) to receive +50 bonus coins (puzzle logic remains turn-based). |
| **Thursday** | **Dual Flight** | Exactly 50% Ant lines and 50% Bee lines with multiple vertical overlapping intersections. |
| **Friday** | **Key Hunt** | Dew Key & Thorn Lock (M004). Fallback: if player has not unlocked L321, generates Classic Garden Meadow. |
| **Saturday** | **Queen's Challenge** | Hard difficulty ($D$ target +10%), larger grid, tighter dependency chains. |
| **Sunday** | **Bountiful Garden** | Double coin reward: +200 coins base completion reward. |

### 3. 7-Day Streak Ladder
| Day | Coins | Boosters Granted |
|---|---|---|
| **Day 1** | 50 | None |
| **Day 2** | 75 | None |
| **Day 3** | 100 | 1 Nectar Glow Hint |
| **Day 4** | 125 | None |
| **Day 5** | 150 | 1 Queen's Royal Shield |
| **Day 6** | 200 | 1 Leaf Blower |
| **Day 7** | 450 | 1 Hint + 1 Shield + 1 Leaf Blower |
| **Weekly Total** | **1,150** | **2 Hints, 2 Shields, 2 Leaf Blowers** |

- Completing Day 7 rolls the active cycle over to Day 1 the following day while incrementing `totalStreakDays`.

### 4. Queen's Favor (Streak Saver)
- When a player misses exactly 1 calendar day, their streak is paused in a "Broken" state.
- Upon opening the Daily Almanac, player is offered **Queen's Favor**:
  - Option A: Watch 1 rewarded ad.
  - Option B: Spend 200 coins.
- **Restrictions:** Queen's Favor can be used strictly **once per 7-day cycle**. A second missed day in the same cycle permanently resets the streak to Day 1.

### 5. Offline Play & Anti-Cheat
- Daily seeds for the next 3 days are pre-computed and stored locally in Hive.
- **Time Validation:**
  - Online: Network timestamp validated against HTTP Date headers or Firebase server time.
  - Offline: Monotonic clock `SystemClock.elapsedRealtime()` tracks elapsed seconds since last known online validation.
  - If device time is manually adjusted backwards, daily challenge locks until network time reconnects.

### 6. Platform Leaderboards (`games_services`)
Three standard leaderboards integrated with Google Play Games (Android) and Game Center (iOS):
1. `leaderboard_highest_level`: Maximum main progression level cleared (1–500).
2. `leaderboard_total_stars`: Total cumulative stars earned across all levels (up to 1,500).
3. `leaderboard_streak_days`: Longest continuous streak of daily almanac completions.

## Affected Files
- `apps/ants_bees/lib/features/daily/bloc/daily_bloc.dart` (to be created)
- `apps/ants_bees/lib/features/daily/services/daily_generator.dart` (to be created)
- `apps/ants_bees/lib/features/daily/services/time_validator.dart` (to be created)
- `apps/ants_bees/lib/features/daily/ui/daily_almanac_dialog.dart` (to be created)
- `apps/ants_bees/lib/features/daily/ui/streak_ladder_widget.dart` (to be created)
- `apps/ants_bees/lib/services/leaderboard_service.dart` (to be created)

## Risks
- Device clock tampering could artificially unlock streak rewards if monotonic validation fails.
- Key Hunt fallback must be tested thoroughly for players who have not reached Level 321.

## Open Questions
- None. Daily rewards, modifiers, and streak rules follow the unified parameters from SHARED_CORE_STANDARD.md §6.4.

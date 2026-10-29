Source docs: phase_1/05_DAILY_CHALLENGE_AND_STREAK.md, ../../SHARED_CORE_STANDARD.md

# Spec: Daily Timetable Run & Express Streak (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Implement the Daily Timetable Run challenge, weekday train modifiers, board silhouettes, on-device seeded generator with fallback, 7-day Express Streak ladder with Streak Saver, anti-cheat time tracking, and OS leaderboards for Toy Trains.

## Current State
Design documented in phase_1/05_DAILY_CHALLENGE_AND_STREAK.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- Daily Challenge unlocks after level 15 clear.
- Seeded generation based on `hash64("toy_trains", dayKey)`.
- Difficulty personal to player's highest cleared level: `max(15, highestClearedLevel - 10)`.
- 7 weekday modifiers with automatic fallback to Classic when required mechanics are not yet unlocked.
- 7-day Express Streak ladder granting 1,150 coins and boosters upon daily puzzle completion.

## Proposed Change
Implement the daily puzzle engine, streak manager, and services in `apps/toy_trains/lib/features/daily/`:

### 1. Daily Timetable Run Rules
- **Unlock Requirement:** Cleared Level 15. A "Daily" timetable ticket icon appears on the Home screen and Level Map.
- **Cadence & Seeds:** Exactly 1 puzzle per local calendar day (`dayKey` format `YYYY-MM-DD`). Seed derived deterministically: `hash64("toy_trains", dayKey)`.
- **Personalized Difficulty:** Uses generator parameters matching the `x6` (ramp) slot of tier `max(15, highestClearedLevel - 10)`. Players in the same tier receive identical boards.
- **Allowed Mechanics:** Only mechanics unlocked by the player (`intro_level <= highestClearedLevel`).
- **Attempts & Lives:** 3 hearts (Wednesday: 1 heart). Second Chance allows standard 120-coin refill (max 2/attempt) and rewarded ad revive (strictly once per `dayKey`, tracking key `adReviveUsed["daily:<dayKey>"]`).
- **Reward:** **+100 coins** + 1 Express Streak progression point on the first clear of the day. Replays award 0 coins.
- **Advertising Restriction:** Interstitial ads are NEVER shown after completing the Daily Timetable Run. The 2X Win doubler button is omitted.

### 2. Weekday Modifiers
Each day introduces a distinct railway theme and gameplay constraint:
| Day | Modifier Name | Themed Title | Mechanic Rule | Fallback if Locked |
|---|---|---|---|---|
| **Mon** | **Classic** | "Regular Service" | Clean tracks, no special rule. | None |
| **Tue** | **Par Moves** | "On-Time Run" | HUD displays "Moves X / Par Y". Exceeding par drops final rating by 1 star (no failure). | None |
| **Wed** | **One Heart** | "Fragile Cargo" | Board starts with 1 heart instead of 3. Standard Second Chance revive available. | None |
| **Thu** | **Fog Day** | "Steam Day" | Spawns additional Steam Clouds (M010). | Classic (if L < 101) |
| **Fri** | **Key Hunt** | "Ticket Inspection" | Spawns additional Ticket & Barrier gates (M004/M043). | Classic (if L < 41) |
| **Sat** | **Big Board** | "Big Junction" | Board forced to the maximum grid dimensions of player's current tier. | None |
| **Sun** | **Mini Boss** | "Clock Tower Sunday" | Features Clock Tower Guardian (M049) at the center. | Classic (if L < 491) |

- **Fallback Rule:** If the player has not yet unlocked the modifier's mechanic, the day automatically runs the **Classic** ("Regular Service") modifier.

### 3. Board Silhouettes
Trains are constrained inside themed cell masks from `assets/daily/silhouettes.json`:
- **Monday:** Steam Engine (side silhouette)
- **Tuesday:** Semaphore Signal
- **Wednesday:** Arched Railway Bridge
- **Thursday:** Station Clock
- **Friday:** Golden Ticket
- **Saturday:** Water Tower
- **Sunday:** Roundhouse Turntable

### 4. Generator Pipeline & Fallback
1. Generator executes up to 64 seed attempts (`seed + k`, k = 0..63) using on-device solver validation in background isolate.
2. If all 64 attempts fail to produce a solvable board within D target band, fallback loader selects a pre-validated board from `assets/daily/daily_fallback.json` (30 classic boards) and logs warning `E-LVL-003`.

### 5. Express Streak Ladder (7 Days)
Streak advances solely upon clearing the Daily Timetable Run (not on app login):
| Day | Rewards |
|---|---|
| **Day 1** | 50 coins |
| **Day 2** | 75 coins + 1 Green Signal Hint |
| **Day 3** | 100 coins |
| **Day 4** | 125 coins + 1 Cowcatcher Shield |
| **Day 5** | 150 coins |
| **Day 6** | 200 coins + 1 Track Crane |
| **Day 7** | **450 coins** + 1 Green Signal Hint + 1 Cowcatcher Shield + 1 Track Crane + "Weekly Express" Trophy |
| **Total** | **1,150 coins + 2 Hints + 2 Shields + 2 Track Cranes + Trophy** |

- **Streak Saver:** Missing a calendar day displays the Streak Saver sheet. Player can restore their streak for **200 coins** OR by viewing 1 rewarded ad. Permitted once per 7-day cycle. If declined or on second miss, streak resets to Day 1.
- **Anti-Cheat & Cooldown:** Clock tampering detection compares device time against last completed UTC timestamp. Next daily unlocks at local midnight, but enforces a minimum 20-hour cooldown from the previous completion.

### 6. Platform Leaderboards
Integrated via `games_services`:
- `leaderboard_highest_level`: Highest numbered level cleared.
- `leaderboard_total_stars`: Total cumulative stars earned across numbered and daily levels.
- `leaderboard_streak_days`: Longest unbroken daily streak achieved.

## Affected Files
- `apps/toy_trains/lib/features/daily/daily_screen.dart` (to be created)
- `apps/toy_trains/lib/features/daily/streak_widget.dart` (to be created)
- `apps/toy_trains/lib/services/time_service.dart` (to be created)
- `apps/toy_trains/lib/services/leaderboards_service.dart` (to be created)
- `apps/toy_trains/assets/daily/silhouettes.json` (bundled asset)
- `apps/toy_trains/assets/daily/daily_fallback.json` (bundled asset)

## Risks
- Device offline for extended periods may cause clock desync; resolved via local monotonicity check against app uptime and secure prefs.

## Open Questions
- None. Daily structure, rewards, and anti-cheat rules match phase_1/05 and SHARED_CORE_STANDARD.md.

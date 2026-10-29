Source docs: phase_1/05_DAILY_CHALLENGE_AND_STREAK.md, ../../SHARED_CORE_STANDARD.md

# Spec: Daily Jungle Puzzle and 7-Day Jungle Streak

## Status
Draft

## Type
New Feature

## Goal
Implement the Daily Jungle Puzzle mode, 7 weekday modifiers, jungle animal silhouettes, 7-day streak ladder, Streak Saver Leaf, anti-cheat & day key system, and platform leaderboards.

## Current State
Design documented in phase_1/05_DAILY_CHALLENGE_AND_STREAK.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- Unlocked after clearing Level 15.
- 1 puzzle per local date (`dayKey`), resetting at local midnight.
- 7 weekday modifiers (Classic, Par Moves, One Heart, Fog Day, Key Hunt, Big Board, Mini Boss).
- 7-day streak ladder rewarding 1,150 coins + boosters per week, with Golden Coil Trophy progression.
- Streak Saver Leaf offer when missing exactly 1 day (1 rewarded ad or 200 coins).
- Device clock tampering protection via `lastTrustedUtc` and minimum 20-hour claim delta.

## Proposed Change
Implement the daily generator, streak tracker, time verification, and leaderboards:

### 1. Daily Puzzle Rules
- **Access:** Unlocked immediately upon clearing Main Level 15.
- **Frequency:** Exactly 1 puzzle per device local date (`dayKey` in format `YYYY-MM-DD`). Resets at midnight.
- **Rewards:** First clear of the day grants **+100 coins** and advances the streak ladder. Subsequent plays that day award 0 coins. 2X Win button is not offered.
- **Rules & Modifiers:** Core puzzle rules apply. Retry is unlimited and free. Boosters are permitted. Hearts: 3 (except Wednesday which starts with 1).
- **Revive:** Ad revive allowed once per `dayKey` (persisted in `progress.adReviveUsed["daily:<dayKey>"]`). Heart Berry Refill allowed up to 2 times per attempt.
- Interstitial ads are NEVER shown after Daily Challenge plays; daily wins do not count toward the `winsSinceInterstitial` counter.

### 2. Weekday Modifiers
| Day | Modifier | Gameplay Rule | Fallback (If Mechanic Locked) |
|---|---|---|---|
| Mon | **Classic** | Standard rules; no modifier | — |
| Tue | **Par Moves** | Exceeding `par_moves` deducts 1 star (min 1 star; does not cause level failure). HUD shows `Moves X / par Y` | — |
| Wed | **One Heart** | Attempt starts with 1 heart instead of 3. Revive is allowed (1 ad revive, 2 refills) | — |
| Thu | **Fog Day** | Increased M010 Jungle Mist (occupies 50% of obstacle slots) | If M010 locked (`highestCleared < 101`) -> **Classic** |
| Fri | **Key Hunt** | Increased M004 Bamboo Cages & M043 Big Knot Cages (50% of obstacles) | If M004 locked (`highestCleared < 41`) -> **Classic** |
| Sat | **Big Board** | Board size expands to the maximum grid of player's current tier | — |
| Sun | **Mini Boss** | Board features M049 Grumpy Mongoose boss | If M049 locked (`highestCleared < 491`) -> **Classic** |

- Per SHARED_CORE_STANDARD §16.2, if a weekday mechanic is not yet unlocked in the player's main progression, the puzzle cleanly falls back to **Classic**.

### 3. Seed, Generation & Daily Silhouettes
- **Seed:** `seed = hash64("snakes_slither", dayKey)`. PRNG: `xoshiro128**`.
- **Difficulty Scaling:** Uses generator parameters matching level `max(15, highestCleared - 10)` on its **x6 slot** parameters. Only currently unlocked mechanics are included. Board is generated on-device in an isolate and cached for the remainder of that `dayKey`.
- **Fallback:** If on-device generator fails after 64 attempts (`k = 0…63`), loads the matching board from bundled `daily_fallback.json` (30 pre-validated Classic boards).
- **Silhouettes (Mon–Sun):** Paths conform to a themed animal/nature mask (fill >= 60%):
  - Monday: Butterfly 🦋 (symmetric wings)
  - Tuesday: Leaf 🍃 (diagonal leaf with stem)
  - Wednesday: Turtle 🐢 (round shell with head)
  - Thursday: Cloud ☁️ (puffy cloud structure)
  - Friday: Snake Egg 🥚 (oval)
  - Saturday: Mango 🥭 (broad fruit shape)
  - Sunday: Sun ☀️ (central disk with radiating rays)

### 4. 7-Day Jungle Streak Ladder
| Day | Reward |
|---|---|
| Day 1 | 50 coins |
| Day 2 | 75 coins |
| Day 3 | 100 coins + 1 Glow Firefly Hint |
| Day 4 | **150 coins** |
| Day 5 | 150 coins + 1 Safety Shell Shield |
| Day 6 | 200 coins + 1 Magic Stone Hammer |
| Day 7 | **450 coins + 1 Hint + 1 Shield + 1 Hammer + Golden Coil Trophy** |

- Streak advances only upon **Daily Challenge completion** (not mere app login).
- Total weekly earnings: **1,150 coins** + 2 Hints + 2 Shields + 2 Hammers.
- **Trophy Progression:** Completing Day 7 advances the trophy tier: Bronze -> Silver -> Gold -> Platinum -> Diamond. After Diamond, trophy remains Diamond while cycle counter increments.
- Day 7 completion loops back to Day 1, while `totalStreakDays` continues incrementing for leaderboards.

### 5. Miss Rule & Streak Saver Leaf
- **Consecutive Day:** Cleared yesterday -> advances to next day reward.
- **Exactly 1 Day Missed:** Streak Saver Leaf offer is triggered: 1 rewarded ad OR 200 coins. Allowed **once per 7-day cycle** (`streak.cycleSaverUsed`).
  - If accepted: streak continues from the missed position (missed day's reward is NOT granted; today's clear gives the next day's reward). Must be accepted *before* clearing today's Daily.
  - If declined or unavailable: streak resets to Day 1 upon clearing today's puzzle.
- **2+ Days Missed:** Immediate reset to Day 1; no Streak Saver offer is presented.

### 6. Day Key, Anti-Cheat & Time-Travel Lock
- `dayKey` = device local date `YYYY-MM-DD`.
- Persisted timestamps: `streak.lastClaimDayKey`, `time.lastTrustedUtc`, `time.lastServerUtc`.
- Online checks: Whenever online, HTTP Date header updates `lastServerUtc` and `lastTrustedUtc = max(lastTrustedUtc, now)`.
- **Time-Travel Lock:** If device clock is set earlier than `lastTrustedUtc - 2h`, time-travel lock engages: Daily Challenge, Streak claims, and Lucky Lily Wheel are disabled until clock catches up.
- **Minimum 20-Hour Rule:** At least 20 elapsed hours required between streak claims (measured via server UTC or device monotonic uptime).
- **Offline Play:** Daily can be played offline; rewards are granted locally with `pendingVerify = true`. Reconnecting verifies timestamp consistency. Clock tampering freezes streak progression (`streak.frozen = true`) but does not confiscate earned coins.

### 7. Leaderboards (`games_services`)
Three platform leaderboards using Google Play Games Services / Apple Game Center:
1. **Highest Level:** Highest cleared main level number (`progress.highestCleared`).
2. **Total Stars:** Sum of highest stars earned across Levels 1–500 (Daily stars do not count towards Total Stars).
3. **Total Streak Days:** Total cumulative streak days (`streak.totalDays`).

## Affected Files
- `apps/snakes_slither/lib/features/daily/bloc/daily_bloc.dart` (to be created)
- `apps/snakes_slither/lib/features/daily/view/daily_page.dart` (to be created)
- `apps/snakes_slither/lib/features/streak/cubit/streak_cubit.dart` (to be created)
- `apps/snakes_slither/lib/services/time_service.dart` (to be created)
- `apps/snakes_slither/lib/services/games_services.dart` (to be created)
- `apps/snakes_slither/assets/levels/daily_seed_overrides.json` (to be created)
- `apps/snakes_slither/assets/levels/daily_fallback.json` (to be created)

## Risks
- Timezone traversal: players crossing international date lines must not trigger double claims or inadvertent streak breaks. Handled via monotonic elapsed time and unique `dayKey` tracking.
- Ensuring the 30-board fallback pack satisfies all 7 silhouette masks in case on-device PRNG generation times out.

## Open Questions
- In `phase_1/05 §7` wireframe ASCII art, Day 4 had a typo showing 125 coins; the text in §6 and SHARED_CORE_STANDARD §8.2 specify Day 4 is 150 coins. Standard wins.

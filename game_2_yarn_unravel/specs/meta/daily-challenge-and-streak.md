Source docs: phase_1/05_DAILY_CHALLENGE_AND_STREAK.md, ../../SHARED_CORE_STANDARD.md

# Spec: Daily Stitch and 7-Day Streak

## Status
Draft

## Type
New Feature

## Goal
Implement the Daily Stitch challenge mode, 7 weekday modifiers, craft-themed silhouettes, 7-day streak ladder, Darning Patch streak saver, anti-cheat date protection, and platform leaderboards for Yarn Unravel Phase 1.

## Current State
Design documented in phase_1/05_DAILY_CHALLENGE_AND_STREAK.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- Unlocked after clearing Main Level 15.
- 1 puzzle per local calendar day (`dayKey = YYYY-MM-DD`), resetting at midnight.
- 7 weekday modifiers (Classic, Par Moves, One Heart, Fog Day, Key Hunt, Big Board, Mini Boss).
- 7-day streak ladder awarding 1,150 coins + boosters per week, with Thimble Trophy progression.
- Darning Patch (Streak Saver) offer when missing exactly 1 day (1 rewarded ad or 200 coins).
- Device clock tampering protection via `lastTrustedUtc` and minimum 20-hour claim delta.

## Proposed Change
Implement the daily challenge generator, streak tracker, time verification, and leaderboards:

### 1. Daily Stitch Rules
- **Access:** Unlocked immediately upon clearing Main Level 15.
- **Frequency:** Exactly 1 puzzle per device local date (`dayKey`). Resets at local midnight.
- **Rewards:** First clear of the day grants **+100 coins** and advances the 7-day streak ladder. Subsequent plays that day award 0 coins. 2X Win button is not offered.
- **Rules & Attempts:** Core puzzle rules apply. Retries are unlimited and free. Boosters are permitted. Attempt starts with 3 hearts (except Wednesday which starts with 1).
- **Revive:** Rewarded ad revive allowed once per `dayKey` (persisted in `adReviveUsed["daily:<dayKey>"]`). Heart Refill allowed up to 2 times per attempt (120 coins each).
- Interstitial ads are NEVER shown after Daily Stitch plays; daily clears do not increment the `winsSinceInterstitial` counter.

### 2. Weekday Modifiers
| Day | Modifier | Flavour Name | Gameplay Rule | Fallback (If Mechanic Locked) |
|---|---|---|---|---|
| **Mon** | Classic | Plain Knit Monday | Standard rules; clean board layout | — |
| **Tue** | Par Moves | Tidy Tuesday | Exceeding `par_moves` deducts 1 star (min 1 star; does not cause level failure). HUD shows `Moves X / par Y` | — |
| **Wed** | One Heart | Careful Wednesday | Attempt starts with 1 heart instead of 3. Revive allowed (brings back to 1 heart). Shield works normally | — |
| **Thu** | Fog Day | Fluffy Thursday | Increased M010 Wool Fluff (occupies ~50% of obstacle slots) | If M010 locked (`highestCleared < 101`) -> **Classic** |
| **Fri** | Key Hunt | Charm Friday | Increased M004 Charm & Clasp pairs (occupies ~50% of obstacle slots) | If M004 locked (`highestCleared < 41`) -> **Classic** |
| **Sat** | Big Board | Big Quilt Saturday | Board size expands to the maximum grid of player's current tier | — |
| **Sun** | Mini Boss | Pincushion Sunday | Board features M049 Grand Pincushion Guardian | If M049 locked (`highestCleared < 491`) -> **Classic** |

- Per SHARED_CORE_STANDARD §16.2, if a weekday mechanic is not yet unlocked in the player's main progression, the puzzle cleanly falls back to **Classic**.

### 3. Seed, Generation & Themed Silhouettes
- **Seed:** `seed = hash64("yarn_unravel", dayKey)`. PRNG: `xoshiro128**`.
- **Difficulty Scaling:** Uses generator parameters matching level `max(15, highestCleared - 10)` on its **x6 slot** parameters. Only currently unlocked mechanics are included. Lamplight Evening (M040) is excluded from daily generation.
- **Fallback:** If on-device generator fails after 64 attempts (`k = 0…63`), loads the matching board from bundled `daily_fallback.json` (30 pre-validated Classic boards) using `dayIndex mod 30`.
- **Silhouettes (Mon–Sun):** Threads conform to a themed knitting/craft mask (fill >= 60%):
  - Monday: Mitten (red knitted mitten patch)
  - Tuesday: Teacup (teacup with knitted cozy)
  - Wednesday: Sock (striped sock)
  - Thursday: Cloud-shaped Scarf (fluffy textured scarf)
  - Friday: Heart Locket (charm-heart shape)
  - Saturday: Sewing Machine (vintage sewing machine outline)
  - Sunday: Flower Basket (woven basket with wool flowers)
- Clearing reveals the knitted patch artwork.

### 4. 7-Day Stitch Streak Ladder
| Streak Day | Coins | Boosters Granted | Special Milestone |
|---|---|---|---|
| **Day 1** | +50 | — | — |
| **Day 2** | +75 | 1 Needle Glow Hint | — |
| **Day 3** | +100 | — | — |
| **Day 4** | +125 | 1 Thimble Shield | — |
| **Day 5** | +150 | — | — |
| **Day 6** | +200 | 1 Golden Scissors | — |
| **Day 7** | **+450** | **1 Hint + 1 Shield + 1 Hammer** | **Thimble Trophy Tier Upgrade** |
- Completing Day 7 rolls over to Day 1 on the following day while preserving lifetime streak records.
- Total weekly earnings: **1,150 Coins + 2 Hints + 2 Shields + 2 Hammers**.

### 5. Darning Patch (Streak Saver)
- **Eligibility:** Triggers on app launch if exactly 1 calendar day was missed (`currentDate - lastCompletedDate == 2 days`).
- **Options:**
  - Option A: Watch 1 rewarded ad.
  - Option B: Pay 200 coins.
  - Option C: Decline -> streak resets to Day 1.
- **Limit:** Can be used once per missed day incident.
- If 2 or more consecutive days are missed, streak resets to Day 1 without the Darning Patch option.

### 6. Anti-Cheat & Offline Play
- **Date Verification:**
  - App queries world time API / NTP time header on launch when online.
  - Records `lastTrustedUtc`. If current device time is earlier than `lastTrustedUtc`, app enters clock-tamper lock (`W-TIME-001`): daily challenge is greyed out with "Check device time" warning.
  - Minimum 20 hours required between successive daily reward claims.
- **Offline Support:** If fully offline, daily board generates using device calendar date, but streak synchronization waits for online validation.

### 7. Platform Leaderboards (`games_services`)
- Integrated with Google Play Games (Android) and Apple Game Center (iOS):
  1. `leaderboard_highest_level`: Maximum level cleared in main progression.
  2. `leaderboard_total_stars`: Aggregate stars earned across all main levels (max 1,500).
  3. `leaderboard_total_streak_days`: Highest unbroken streak count achieved.
- Daily Challenge completion time or score is intentionally excluded from global leaderboards to maintain fairness across varying tier difficulties.

## Affected Files
- `apps/yarn_unravel/lib/features/daily/bloc/daily_bloc.dart` (to be created)
- `apps/yarn_unravel/lib/features/daily/bloc/streak_cubit.dart` (to be created)
- `apps/yarn_unravel/lib/features/daily/view/daily_challenge_view.dart` (to be created)
- `apps/yarn_unravel/lib/features/daily/view/streak_dialog.dart` (to be created)
- `apps/yarn_unravel/lib/features/daily/view/darning_patch_dialog.dart` (to be created)
- `apps/yarn_unravel/lib/services/time_service.dart` (to be created)
- `apps/yarn_unravel/lib/services/leaderboard_service.dart` (to be created)

## Risks
- Device timezone changes crossing the International Date Line must not trigger spurious clock-tampering locks.
- Offline daily board generation must produce deterministic boards that match the online seed.

## Open Questions
- None. Rules and values strictly follow SHARED_CORE_STANDARD.md §8 and §16.


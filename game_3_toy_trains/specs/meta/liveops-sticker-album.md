Source docs: phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/meta/daily-challenge-and-streak.md, specs/gameplay/level-progression-0001-0500.md, specs/gameplay/level-progression-0501-1000.md.

# Spec: Depot Sticker Album Meta-System (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Specify the Depot Sticker Album collectible meta-system for Toy Trains: Wooden Railway Puzzle, establishing milestone sticker rewards, retroactive grant logic for migrating players, 5 themed album volumes spanning Levels 10–1000, volume completion rewards, and local-first UI/UX integration.

## Current State
Design documented in `phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` and `../../SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 meta (`specs/meta/daily-challenge-and-streak.md`) defined the Daily Timetable Run and Express Streak.
- Players clearing milestone levels (every x0) received Conductor's Gift Crates but had no long-term collectible progression system.
- Phase 2 introduces the Depot Sticker Album, unlocked at Level 10 clear, retroactively rewarding all past milestone clears.

## Proposed Change
Implement the Depot Sticker Album module in Flutter and `packages/puzzle_core`:

### 1. Sticker Grant Rules & Schedule
- **Trigger:** Awarded on the **first clear** of every milestone level (every 10th level: L10, L20, L30 … L1000). Replaying a previously cleared level never awards duplicate stickers.
- **Total Stickers:** Exactly 100 stickers across Levels 1–1000.
- **Silhouette Art & Frames:** Each sticker depicts an illustrated miniature railway vignette set inside one of the 7 Daily Timetable silhouette frames:
  - Frame 0: Steam Engine
  - Frame 1: Semaphore Signal
  - Frame 2: Arched Bridge
  - Frame 3: Station Clock
  - Frame 4: Golden Ticket
  - Frame 5: Water Tower
  - Frame 6: Roundhouse
  - Formula: Sticker `#k` (where `k = level / 10`) uses silhouette frame `(k - 1) mod 7`.
- **Gameplay Neutrality:** Stickers are purely cosmetic collectibles and have no impact on puzzle mechanics or board difficulty.

### 2. Retroactive Grant on First Launch
- When a player installs the Phase 2 update (or loads an existing save):
  ```dart
  for (int lvl = 10; lvl <= highestClearedLevel; lvl += 10) {
    if (!album.hasSticker(lvl)) {
      album.grantSticker(lvl);
    }
  }
  ```
- If any volume is completed during migration, an "Album Catch-Up" modal appears once on Home screen presenting the earned rewards in a single unified claim dialog.

### 3. Album Volumes & Completion Rewards
The 100 stickers are partitioned into 5 chronological volumes:

| Vol | Volume Name | Milestones Covered | Sticker Count | Volume Completion Reward |
|---|---|---|---|---|
| **1** | Toy Box Town | L10–100 | **10** | 250 coins + "Toy Box" Engine Nameplate (Cosmetic) |
| **2** | Countryside Line | L110–250 | **15** | 400 coins + "Meadow" Carriage Bunting (Cosmetic) |
| **3** | Mountain Pass | L260–500 | **25** | 600 coins + "Snowcap" Chimney Trim (Cosmetic) |
| **4** | Seaside Express | L510–750 | **25** | 600 coins + "Lighthouse" Route Peek Line Style (Cosmetic) |
| **5** | Grand Terminus | L760–1000 | **25** | 800 coins + "Grand Terminus" Tabletop Banner (Cosmetic) |
| | **Total** | | **100** | **2,650 coins** + 5 Album-Exclusive Cosmetics |

- Album-exclusive cosmetics cannot be purchased with coins in the shop; they are unlocked solely by completing their respective album volume.
- Economy sanity: 2,650 coins across 1,000 levels averages ~2.65 coins/level, maintaining the economy standard (§6.1).

### 4. UI/UX Interaction Flow
1. **Milestone Win Flow:**
   - Level Complete dialog -> Conductor's Gift Crate opened -> Sticker Stamp modal.
   - Blank wireframe silhouette animates to full color over 600 ms (fade animation if Reduce Motion is enabled) accompanied by wooden stamp `sfx_sticker_stamp`.
   - Action buttons: "View Album" or "Next Level".
2. **Depot Album Screen:**
   - Top tab bar for Volumes 1 to 5 with progress bars (e.g. "18/25").
   - Grid layout (5x5 or 5x3) showing unlocked color art or locked silhouette with level requirement ("L370").
   - Tapping an unlocked sticker opens full-screen high-res card with lore snippet.
3. **Home Screen Entry:**
   - Hardcover leather/wood book icon on Home screen. Displays red badge with `unseenCount` when new stickers await inspection.

### 5. Data Model & Persistence
Local Hive box `album_box` synchronized to Firestore `users/{uid}`:
```json
{
  "album": {
    "stickers": [10, 20, 30, ...],
    "volumesClaimed": [1],
    "unseenStickers": [40],
    "lastUpdated": 1729850000000
  }
}
```

## Affected Files
- `lib/features/meta/album/domain/models/sticker_album.dart` (to be created)
- `lib/features/meta/album/presentation/bloc/album_bloc.dart` (to be created)
- `lib/features/meta/album/presentation/screens/sticker_album_screen.dart` (to be created)
- `lib/features/meta/album/presentation/widgets/sticker_stamp_dialog.dart` (to be created)
- `lib/features/gameplay/presentation/cubit/reward_flow_cubit.dart` (changed: integrate sticker step)

## Design
- Screen: Sticker Album Screen with wooden album border and brass corner brackets.
- Component: Animated wax seal stamp overlay on sticker grant.
- Tokens: Match Phase 1 palette (`#8B5A2B` wood, `#FFD700` brass, cream paper parchment background).

## Risks
- Save migration desynchronization if app is closed during retroactive grant. Mitigation: Idempotent migration loop checking `highestClearedLevel` against existing sticker set.

## Open Questions
- None. All numbers and volume structures match `phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` and `SHARED_CORE_STANDARD.md`.

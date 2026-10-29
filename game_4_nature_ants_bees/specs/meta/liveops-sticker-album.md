Source docs: phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, SHARED_CORE_STANDARD.md. Depends on: specs/meta/daily-challenge-and-streak.md

# Spec: LiveOps Flora & Fauna Compendium (Sticker Album)

## Status
Draft

## Type
New Feature

## Goal
Specify the Flora & Fauna Compendium (Sticker Album), including milestone-based sticker unlocks across 5 themed volumes, retroactive grants for Phase 1 veterans, volume completion rewards, and the separate Daily Almanac silhouette gallery for Ants & Bees: Garden Trails.

## Current State
Design documented in phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md and SHARED_CORE_STANDARD.md.
- Extends `specs/meta/daily-challenge-and-streak.md`.
- No sticker album existed in Phase 1.
- In Phase 2, clearing milestone levels (every 10th level: L10, L20... L1000) unlocks illustrated botanical/insect stickers.

## Proposed Change
Implement the Compendium data structures and UI in `apps/ants_bees/lib/features/album/`:

### 1. Core Album Architecture
- **Sticker Identity:** Exactly 1 sticker per milestone level `s<level>` (e.g. `s10`, `s20`... `s1000`), yielding exactly **100 stickers** across Levels 1–1000.
- **Derived Progress:** Album collection is deterministically derived from `highestCleared` level index.
- **Retroactive Veteran Grant:** Existing Phase 1 players updating to Phase 2 automatically receive all stickers up to their current level (a player at L500 receives all 50 stickers for Volumes 1–3 and their completion rewards upon first Phase 2 launch).
- **Non-Monetized:** Stickers cannot be purchased with coins or real money; they reflect pure puzzle mastery.

### 2. 5 Themed Volumes
| Vol | Volume Name | Milestones | Count | Theme Examples | Completion Rewards |
|---|---|---|---|---|---|
| **1** | **Seedlings & Sprouts** | L10–L100 | 10 | Clover sprout, acorn, dewdrop, seed pod | **300 coins** + "Clover" avatar frame |
| **2** | **Meadow Blossoms** | L110–L250 | 15 | Daisy, tulip, sunflower, morning glory | **400 coins** + "Tulip" avatar frame |
| **3** | **Busy Bugs** | L260–L500 | 25 | Worker ant, honeybee, ladybug, orb spider | **600 coins** + "Honeycomb" avatar frame |
| **4** | **Pond & Brook** | L510–L750 | 25 | Lily pad, dragonfly, water strider, snail | **800 coins** + **Pressed-Flower Ant** skin |
| **5** | **Midsummer Royals**| L760–L1000| 25 | Stag beetle, monarch butterfly, queen bee | **1,000 coins** + **Stained-Glass Bee** skin |

- **Grand Completionist:** Collecting all 5 volumes unlocks the permanent cosmetic title badge: **"Master Naturalist"**.

### 3. Dedicated Daily Almanac Silhouette Page
- In addition to the 100 progression stickers, completing the Daily Garden Almanac awards that weekday's silhouette stamp:
  - Monday: Morning Dew Leaf
  - Tuesday: Spring Tulip
  - Wednesday: Honeycomb Hex
  - Thursday: Garden Mushroom
  - Friday: Spotted Ladybug
  - Saturday: Golden Sunflower
  - Sunday: Royal Beehive
- Displayed in a separate "Daily Garden Journal" tab within the Compendium. Purely cosmetic collection.

### 4. Compendium UI & Interactions
- Accessible via the book icon 📖 on Home and Level Map screens.
- **Volume Grid View:** 5x5 card grid with soft leather botanical book aesthetic.
- Locked slots show a faint silhouette with text: "Clear Level X to collect".
- Unlocked stickers can be tapped to reveal full-card art and a 1-line nature trivia fact in English, Gujarati, or Hindi.
- **Reveal Animation:** Stamp drop animation (1.2 s) with golden pollen particles and stamp SFX.

## Affected Files
- `apps/ants_bees/lib/features/album/models/sticker.dart` (to be created)
- `apps/ants_bees/lib/features/album/models/album_volume.dart` (to be created)
- `apps/ants_bees/lib/features/album/bloc/album_bloc.dart` (to be created)
- `apps/ants_bees/lib/features/album/ui/compendium_screen.dart` (to be created)
- `apps/ants_bees/lib/features/album/ui/sticker_card_dialog.dart` (to be created)

## Risks
- Cloud sync must merge sticker ownership idempotently so players do not receive duplicate coin rewards.

## Open Questions
- None. Volumes, counts, rewards, and IDs match phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md §2.

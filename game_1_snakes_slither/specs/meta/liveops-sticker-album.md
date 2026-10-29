Source docs: phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md §2, ../../SHARED_CORE_STANDARD.md §17.25. Depends on: specs/meta/daily-challenge-and-streak.md, specs/economy/boosters-coins-shop.md.

# Spec: LiveOps — Jungle Sticker Album

## Status
Draft

## Type
New Feature

## Goal
Implement the Jungle Sticker Album meta-progression system, comprising 100 milestone level stickers across 5 volumes, a separate Daily Challenge silhouettes album page, retroactive sticker grants upon Phase 2 update, volume completion coin and cosmetic rewards, and server-authoritative ledger claims.

## Current State
Design documented in `phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` §2 and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 had no sticker collection system (milestone levels awarded Gift Baskets only).
- Daily Challenge silhouettes were cleared daily without permanent visual collection.

## Proposed Change
Build the Sticker Album feature across local Hive persistence, Flutter UI, and Firebase ledger sync:

### 1. Album Structure & Volumes (100 Milestone Stickers)
- **Grant Rule:** 1 sticker awarded on the **first clear** of each 10th level (`L10, L20, ... L1000`). Replays do not award stickers.
- **Grant Moment:** Embedded directly inside the Jungle Gift Basket / Jungle Treasure Chest reveal screen (600 ms stamp animation) without interrupting the standard reward flow.
- **Volumes Table:**
  | Volume | Theme | Levels | Stickers | Completion Reward |
  |---|---|---|---|---|
  | **Vol 1** | Garden Friends | L10–100 | 10 | 250 coins + **Fern Frame** (profile frame) |
  | **Vol 2** | Bamboo & Orchard | L110–250 | 15 | 400 coins + **Bamboo Stripe** snake skin |
  | **Vol 3** | Swamp & Moonlit Jungle | L260–500 | 25 | 600 coins + **Moonlit Pond** board theme |
  | **Vol 4** | Waterfalls & Treetops | L510–750 | 25 | 800 coins + **Treetop Feather** snake skin |
  | **Vol 5** | Ruins, Crystals & Sun Temple | L760–1000 | 25 | 1,000 coins + **Sun Temple Gold** board theme + **Album Master** frame |

- **Exclusivity:** Volume-completion cosmetics are album-exclusive and cannot be purchased in the Shop.
- **Ledger Security:** Coin rewards use semantic ledger keys `album:vol{n}` ensuring exactly one reward grant per account.

### 2. Daily Silhouettes Collection Page (Bonus Page)
- Dedicated album page tracking the 7 Daily Jungle Puzzle silhouettes (Butterfly, Leaf, Turtle, Cloud, Snake Egg, Mango, Sun).
- Clearing that weekday's Daily Jungle Puzzle stamps the corresponding silhouette.
- Completing all 7/7 silhouettes awards the **Weekday Wanderer** profile frame (cosmetic only, 0 coins).

### 3. Retroactive Grant on Phase 2 Update
- On first launch of Phase 2 build, client iterates through all cleared milestones:
  `for L in 10, 20, ... highestCleared (step 10) -> grant sticker locally`.
- Home screen shows a celebration popup: "You've already earned N stickers! 🦋" with an "Open Album" button.
- Completed volumes display an interactive **"Claim"** button in the Album UI to allow players to reveal and claim rewards deliberately.

### 4. UI & Interaction
- **Home Screen:** Album book icon with notification badge indicating unclaimed volume rewards.
- **Album Screen:** Volume navigation tabs, 5x5 grid layout (Vol 1 has 2x5). Unlocked stickers display full color; locked stickers display a dark silhouette with level requirement ("Clear L540").
- **Sticker Card:** Tapping an unlocked sticker opens a full-screen card with localized flavor text and fun fact.

## Affected Files
- `lib/features/album/domain/models/sticker_album.dart` (to be created)
- `lib/features/album/data/repositories/sticker_repository.dart` (to be created)
- `lib/features/album/presentation/bloc/album_bloc.dart` (to be created)
- `lib/features/album/presentation/screens/album_screen.dart` (to be created)
- `lib/features/album/presentation/widgets/sticker_zoom_dialog.dart` (to be created)
- `assets/album/stk_*.webp` (100 sticker images to be added)

## Design
- Screen: Album book with textured jungle parchment pages, wooden frame borders, and volume bookmarks.
- Design tokens: Standard palette, gold foil accents for completed volumes.
- Sound: `sfx_stamp_thump` on sticker grant.

## Risks
- Multi-device sync race conditions where a player claims volume rewards on two devices offline. Solved via semantic keys (`album:vol{n}`) in cloud functions ledger.

## Open Questions
- None. Vol 1 to Vol 5 level boundaries and rewards strictly match `phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` §2.

Source docs: phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md, ../../SHARED_CORE_STANDARD.md. Depends on: specs/meta/daily-challenge-and-streak.md, specs/tech/offline-and-cloud-sync.md.

# Spec: Meta — Scrapbook Sticker Album

## Status
Draft

## Type
New Feature

## Goal
Implement the Scrapbook sticker album feature for Yarn Unravel Phase 2, including milestone sticker grants (L10–L1000), 5 themed volumes, volume completion rewards (Coins + exclusive Wardrobe cosmetics), retroactive grant for existing Phase 1 players, and the Daily Patches collection showcase.

## Current State
Design documented in `phase/phase_2/04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md` and `SHARED_CORE_STANDARD.md`, not yet implemented.
- Phase 1 featured Daily Stitch silhouette stamps in `specs/meta/daily-challenge-and-streak.md` without a persistent collection book.
- Phase 2 introduces a full 100-sticker illustrated Scrapbook awarded at every 10th milestone level.
- Works offline-first with local Hive persistence; syncs changes via idempotent op-log.

## Proposed Change
Build the Scrapbook feature in `lib/features/album/`:

### 1. Album Structure (100 Stickers, 5 Volumes)
Awarded at every 10th milestone level (`level % 10 == 0`) upon first clear (stars do not matter; replays never re-grant):

| Volume | Title & Theme | Level Range | Sticker Count | Completion Reward |
|---|---|---|---|---|
| **Vol 1** | Purl's First Basket (knitting essentials: needles, skeins, thimbles) | L10–100 | **10** | 300 Coins + "Purl Paw" needle charm |
| **Vol 2** | Cozy Cottage (warm mittens, teacup cozy, patchwork quilts) | L110–250 | **15** | 400 Coins + "Cottage Lace" profile frame |
| **Vol 3** | The Grand Quilt Fair (artisan quilt blocks, decorative ribbons) | L260–500 | **25** | 600 Coins + "Fair Rosette" needle charm |
| **Vol 4** | Bias & Lamplight Studio (bias tape, brass lamps, bobbin crates) | L510–750 | **25** | 800 Coins + "Starlight Bead" profile frame |
| **Vol 5** | The Heirloom Chest (delicate lace, antique jewels, grand tapestry) | L760–1000 | **25** | 1,000 Coins + "Heirloom Gold" needle charm |

- Total album completion awards 3,100 one-time Coins + 5 exclusive Wardrobe cosmetics.
- Each volume completion awards exactly Coins + 1 cosmetic (standard §17.26).

### 2. Grant Lifecycle & Win Screen Sequence
- **Trigger:** First clear of any level ending in 0 (L10, 20 … 1000). Idempotent key `sticker:<level>`.
- **Win Screen Sequence:**
  1. Level Complete dialog & stars animation.
  2. Craft Basket / Grand Sewing Chest reveal.
  3. **Sticker Reveal Modal:** Knitted patch outline renders -> stitches fill in with needle animation (600 ms) -> wax stamp "thump" sound into Scrapbook page.
  4. Golden Bobbin Rush (if level is L25, 50, 75 …).
- **Interstitial Ad Rule:** Sticker reveal is a reward screen; interstitial ads are strictly deferred to subsequent wins.

### 3. Retroactive Grant for Existing Players
- On Phase 2 first launch (or save migration v1 -> v2):
  1. Evaluate `highestCleared`. For all milestone levels `<= highestCleared`, mark stickers unlocked.
  2. If any volume is completed by this grant, compute the aggregated rewards (e.g., a player at L500 receives Vol 1–3: 1,300 Coins + 3 cosmetics).
  3. Display a single celebratory "Your Scrapbook is Ready!" modal before Level 501.
  4. Operations use idempotent keys (`album_vol:<n>`) ensuring no duplicate grants across devices.

### 4. Daily Patches Showcase Page
- A dedicated page in the Scrapbook displaying the 7 weekday silhouette badges (Mitten, Teacup, Sock, Scarf, Heart Locket, Sweater, Purl the kitten).
- Unlocked permanently once the player completes the respective weekday Daily Stitch at least once.
- Visual collection showcase only: awards no additional coins or completion chests (Daily Stitch retains its standard +100 Coins reward).

### 5. Local Storage & Sync Schema
- Hive box: `album`.
- Fields:
  - `stickers: List<int>` (unlocked level numbers).
  - `volumesClaimed: List<int>` (claimed volume indices 1–5).
  - `dailyPatches: List<String>` (unlocked weekday patch IDs).
- Sync: Every sticker unlock and volume claim generates an op in `syncQueue` (`type: "album_sticker"`, `type: "album_claim"`).

## Affected Files
- `lib/features/album/data/album_repository.dart` (to be created: Hive persistence and grant logic)
- `lib/features/album/bloc/album_bloc.dart` (to be created: volume progress and claim state)
- `lib/features/album/view/scrapbook_screen.dart` (to be created: 5-tab book view, page grids, ribbon bookmarks)
- `lib/features/album/view/sticker_reveal_dialog.dart` (to be created: animated stitching reveal modal)

## Risks
- Save migration race condition where retroactive grants double-apply on multiple offline devices. Mitigated by idempotent keys (`sticker:<level>`) checked during op-log merge.

## Open Questions
None. Volume counts and rewards match `SHARED_CORE_STANDARD.md` §17.26.

# Change requests (UI → logic)

The UI agent adds a row whenever a screen needs data, a callback or a key the contract doesn't have yet. Claude handles it and moves the row to CONTRACT_LOG.md.

| # | Screen / file | What's needed | Why |
|---|---|---|---|
| 2 | Home nav | `onOpenLeaderboards` | Ranks tab left out of the nav until Leaderboards exist |
| 3 | `LevelFailedPopup`, `PausePopup` | Level number and moves | Canvas shows "Level 37 · Moves 7"; popups use generic text for now |
| 4 | Shop Coins / Offers | Coin packs, Starter Pack and VIP products | Tabs show "Store unavailable" while `storeAvailable` is false |

## Levels → logic (L41–L500 drafts)

How the level file reads the mechanic cards where a card leaves a choice open. Every solution was played in a rules simulator built from 03 and 01 §5.9, with 0 bonks and 0 boosters.

| # | Mechanic | What the levels assume | Why it matters |
|---|---|---|---|
| L1 | M023 Two-Headed Hydra | `solution` uses the bare snake id (`"p7"`), meaning the `body[0]` end. The card's `"p7:A"` / `"p7:B"` tokens fail `LevelDraftCheck` (not a snake id). Hydra levels are built so the `body[0]` end is always the one that leaves | Please let the checker accept `pN:A` / `pN:B`; levels can then switch |
| L2 | D, chain C | `difficulty` uses C = longest snake-blocks-snake chain at the start, tracing the real lane (mirrors, burrows, forks, jump pads, bridges, reverse/wide snakes). Keys, locks and counters are not links. N = count of N ✅ instances (03 §1) | `LevelValidator` compares stated vs computed D; please compute C the same way, or tell the level agent to recompute |
| L3 | Cells the cards don't define | No solution lane ever reaches a lever cell (M009/M045), an empty lilypad after its snake left (M013), an empty Whirl Stump cell (M034), a Mama Snake egg cell before the hatch (M035), or Jungle Mist before it clears (M010) | Levels stay fair whether the engine treats these as blocking or not |
| L4 | M016 Termite Mound | HP drops when a cell of the exit lane (not the body) is next to the mound, max −1 per mound per exit | Card says "lane" |
| L5 | M025 / M029–M031 / M035 / M041 / M046 | M025 `cells` = loop in walking order, `start` = index. Edge mechanics: `cells` are board cells on that edge, the segment is their `side`. M035 child id = mama id + `c`, egg `cells` = child body. M041 `paths[].color` = `cycle[start]`. M046 `body[0]` = `params.head`, body = the closed ring in order | Parsing conventions |
| L6 | M038 Bouncy Fern Pad, M034 Whirl Stump | Each pad has a Garden Rock on the cell it jumps; each stump snake starts facing a Garden Rock, so at least one turn is needed. No solution passes through a "tangled" pose (M013/M034/M045) | Intro rule "new mechanic + ≤ 1 older" counts that rock as the older one |

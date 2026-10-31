# Change requests (UI → logic)

The UI agent adds a row whenever a screen needs data, a callback or a key the contract doesn't have yet. Claude handles it and moves the row to CONTRACT_LOG.md.

| # | Screen / file | What's needed | Why |
|---|---|---|---|
| 1 | Home (`HomeData`) | Daily Puzzle card data (unlocked, today's modifier, streak, reward) + `onOpenDaily` | Card shows "Unlocks at L15 / Coming soon" until Daily logic lands (U8) |
| 2 | Home nav | `onOpenLeaderboards` | Ranks tab left out of the nav until Leaderboards exist |
| 3 | `LevelFailedPopup`, `PausePopup` | Level number and moves | Canvas shows "Level 37 · Moves 7"; popups use generic text for now |
| 4 | Shop Coins / Offers | Coin packs, Starter Pack and VIP products | Tabs show "Store unavailable" while `storeAvailable` is false |

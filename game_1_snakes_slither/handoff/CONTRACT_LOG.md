# Contract log

Every change to `lib/contracts/` or to a placeholder constructor, newest first.

| Date | Change | Files |
|---|---|---|
| 2026-10-31 | Added `UiFeedback` (UI sounds and haptics without services) and `UiFeedbackScope`. Levels now come from `assets/levels/phase_1.json`; the app loads the playable prefix | `lib/contracts/ui_feedback.dart` |
| 2026-10-30 | Added Shop, Lucky Lily Wheel and Gift Basket. `HomeScreen` gained `onOpenShop`, `onOpenWheel` and the `HomeData` fields `wheelUnlocked`, `freeSpinReady`, `vipActive`. `LevelCompleteData.gift`. New `ShopScreen`, `WheelScreen`, `GiftBasketPopup`. New keys `homeShop`, `homeWheel`, `shop*`, `wheel*`, `gift*` | `lib/contracts/*`, `lib/ui/screens/{home,shop,wheel}_screen.dart`, `lib/ui/popups/popups.dart` |
| 2026-10-30 | Milestone 1 contract created: Home, Level Map, Gameplay (HUD, boosters, board), Pause, Second Chance, Level Failed, Level Complete, Mini Shop, Settings list | `lib/contracts/*`, `lib/ui/**` placeholders |

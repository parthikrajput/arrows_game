# Antigravity tasks — Milestone 1 (core playable loop)

Do **A1 first**, because everything else uses its theme. After that, A2–A6 touch different files and can run in any order.

**Look vs. content.** The game is the Phase 1 **puzzle**. Take the *look* from the UI canvas (`design/`) and the *content and behaviour* from the Phase 1 docs. AGENTS.md rule 5 has the details.
Paste one task at a time into Antigravity, with the repo folder `game_1_snakes_slither` open.

---

## A1 — Design system (theme, fonts, shared widgets)

```
Read AGENTS.md first and follow it strictly.

Task: build the Snakes Slither design system for this Flutter app.
Source of truth: phases/phase_1/06_UI_UX_SCREENS.md sections 1–4 (principles,
tokens, accessibility, responsive rules).

Edit only: lib/ui/theme/**, new lib/ui/widgets/**, assets/fonts/**, and the
font/asset entries in pubspec.yaml.

0. Brand palette from design/ui_canvas/README.md: Forest #075B35 (primary),
   Emerald #13864D, Leaf #A8D94F, Gold #F4B72F, Cream #F7F4E8 (background),
   Card #FFFEF8, Text #163B28. Map them onto the existing AppColors names
   (primary, primaryLight, bgSage→cream background, bgCream→card, coinGold,
   textPrimary). Keep the 8 snake colours and the preview red/green from doc
   06 §2.2 unchanged. Match the canvas look (design/ui_canvas/screens/
   Home.png, Complete.png): cream background with soft leaf decorations,
   deep-green 3D buttons, cream cards with soft shadows, gold coin pill.
   Copy the logo and Pip renders you need (design/brand/
   snake_slither_logo.png, renders/home_platform.png, sad.png, sleep.png)
   into assets/images/.
1. Bundle fonts offline: Fredoka (display/headings/buttons/HUD numbers with
   tabular figures), Nunito (body/caption). Also Baloo Bhai 2 (Gujarati) and
   Baloo 2 (Hindi) as fallbacks, line height +10%.
2. lib/ui/theme/tokens.dart: keep every existing name (AppColors, AppMotion,
   buildAppTheme, AppColors.snake). Add text styles (display 32/40, h1 24/32,
   h2 20/28, body 16/24, caption 13/18, button 18/24, hudNumber 20/24), spacing
   (4,8,12,16,24,32,48), radii (xs 8, sm 12, md 16, lg 24, pill 999), shadows
   (elev1, elev2, bevelLip, pressed) and motion curves from §2.6.
3. Light theme only. Background bgSage, cards bgCream. Text contrast ≥ 4.5:1.
4. Shared widgets in lib/ui/widgets/:
   - BevelButton: primary (green, gradient primaryLight→primary, 4 dp bottom
     lip, presses down 3 dp) and secondary/outline variants. Min tap 48×48.
   - CoinPill (🪙 + number), HeartBerries (n of max, optional shield overlay
     with charge number), StarRow (0–3, can animate one by one),
     PopupCard (bgCream, radius lg, elev2, popupIn 300 ms easeOutBack),
     RoundIconButton.
   - All respect MediaQuery text scale (max 2.0; HUD numbers clamp 1.5) and
     reduce-motion (MediaQuery.disableAnimations).
5. Don't change any screen yet (other tasks do that), except swapping the
   theme in.

Done when: flutter analyze is clean, flutter test passes, and the app runs
with the new fonts and colours.
```

---

## A2 — Game board, snakes and animations

```
Read AGENTS.md first and follow it strictly. A1 (design system) is done; use
its tokens.

Task: replace the placeholder in lib/ui/board/board_canvas.dart with the real
board look and animations. You may add files under lib/ui/board/.
Sources: phases/phase_1/01_GAME_CONCEPT_AND_RULES.md §2 (art direction) and
§5.1, 5.2, 5.5, 5.8 (exit, bump, locked, preview feel);
06_UI_UX_SCREENS.md §2.2 (snake colours + patterns) and §3 (accessibility);
VFX_IMPLEMENTATION.md.

Keep the BoardCanvas constructor (data, geometry, onMotionDone) unchanged.
Rules:
- Draw every cell via geometry.rectOf / centerOf, corner radius
  geometry.cornerRadius. Don't add gesture detectors.
- Call onMotionDone(motion.id) exactly once when each motion finishes,
  including when reduced motion shortens it.
- Use CustomPainter. Cache the static board (grass tiles, dotted grid,
  rocks) in a Picture; don't use per-frame blur. Keep 60 fps.

Look (soft 3D clay, pastel):
- Board: light grass garden patch, dotted grid, rounded corners.
- Snake: rounded tube body following its cells, head larger than body,
  2 eyes looking in snake.dir, cheeks, slow blink loop. Body pattern per
  colour (polka dots, leaf veins, cross stripes, zigzag, diamonds, rings,
  tiny hearts, chevrons). Caterpillar skin (snake.skin): segmented beads,
  tiny antennae and legs, same hit-box.
- Colour-blind mode (data.colourBlind): bolder patterns + head tag icon
  (● 🍃 ≡ ⚡ ◆ ◎ ♥ ➤).
- Rock (Garden Rock): rounded grey stone.

Animations (data.motion):
- exit: head slides along motion.lane.cells and off the edge, body follows
  the same track with a sine wiggle; 250–450 ms by distance (AppMotion.exitFor).
- bump: head slides to the cell before motion.lane.blocker (0.25 cell if
  lane.cells is empty), squash + 3-cycle shake, slides back (forward easeOut,
  back elasticOut, 380 ms total). Blocker flashes red for 120 ms.
- locked: soft side wobble ≤ 200 ms.
- Reduced motion: no wiggle, no shake; exit stays but shorter.

Overlays:
- Preview (data.preview): snake flicks its tongue; dotted line along
  lane.cells, green #2E7D32 when clear, red #D32F2F with ✕ on lane.blocker
  when blocked.
- Hint (data.hintSnakeId): firefly lands on that snake, gold glow and pulsing
  ring.
- Hammer mode (data.hammerMode): subtle tint, and snakes/rocks show they can
  be picked.

Done when: analyze is clean, flutter test passes, and every snake looks right
on test boards 1–5 at 360×640 and 412×915.
```

---

## A3 — Gameplay screen (HUD + booster bar)

```
Read AGENTS.md first and follow it strictly. Use the A1 design system widgets.

Task: redesign lib/ui/screens/gameplay_screen.dart per
phases/phase_1/06_UI_UX_SCREENS.md §5.5 and
phases/phase_1/04_BOOSTERS_COINS_SHOP.md §3.

Keep the GameplayScreen constructor unchanged. Keep keys gameplayScreen,
pauseButton, booster(name), hammerCancel (lib/contracts/app_keys.dart).

- HUD 64 dp: pause button, "Lv N" (+ red 🐾 Hard chip when hud.isHard),
  heart berries (hud.hearts of hud.maxHearts; shell overlay with
  hud.shieldCharges when > 0), coin pill (hud.coins), small "Moves N" under it.
- Board: put `board` in the remaining space, unwrapped. The board centres
  itself.
- Booster bar 88 dp: 3 round buttons in order Hint 🪲✨, Shield 🐚,
  Hammer 🔨, each with a count badge.
    locked → grey + lock + "L15"/"L25" (b.unlockLevel)
    capReached → dimmed + "used/cap" (e.g. 3/3); tapping shows the tooltip
      "Limit for this try" (don't call onBooster)
    !enabled → dimmed (move animating)
    active → highlighted (Shield running / Hammer target mode)
    count 0 but enabled → still call onBooster (logic opens the mini shop)
- Hammer mode (hammerMode): banner "Tap a snake or rock · Cancel"; Cancel
  calls onCancelHammer.
- Safe areas, notch, and text scale up to 200% (HUD numbers clamp 1.5).
- Semantics labels, e.g. "Hint booster, 2 left".

Done when: analyze is clean and flutter test passes.
```

---

## A4 — In-game popups

```
Read AGENTS.md first and follow it strictly. Use the A1 design system widgets
(PopupCard, BevelButton, StarRow, HeartBerries).

Task: redesign every widget in lib/ui/popups/popups.dart (you may split it into
one file per popup and re-export from popups.dart). Keep every constructor and
every key unchanged.
Sources: phases/phase_1/06_UI_UX_SCREENS.md §5.6, 5.8, 5.9, 5.10;
04_BOOSTERS_COINS_SHOP.md §3 (mini shop).

- PausePopup (§5.6): "⏸ Paused", Resume (primary), Restart, Map, Home, then
  SettingsList.
- SettingsList: Sound, Music, Haptics, Colour-blind, Reduce motion toggles
  plus the "Progress is saved on this device only" note. Also used on the
  Home settings page.
- SecondChancePopup (§5.8): "Pip needs a berry!", broken heart, a 10-second
  countdown RING (keep the existing timer logic: it pauses while
  widget.paused is true and calls onDecline at 0). Ad button "🎬 Watch ad
  +1 ♥" (disabled states: "Ad unavailable" / "Used for this level"); refill
  button "🫐 120 🪙 +1 ♥ (n left)"; "No thanks".
- LevelFailedPopup (§5.9): sad sleepy Pip, "Oh no!", "The snakes got
  tangled", Try again (primary), Home, tip "Hold a snake to preview its
  path."
- LevelCompletePopup (§5.10): "🎉 Level N Complete!", stars animate in one by
  one, coin breakdown (+clear, +★★★ bonus), "🎬 Claim 2X" only when
  data.canDouble (disabled while adBusy), Next (primary, only if
  data.hasNext), Map. Confetti leaves (off when reduced motion).
- MiniShopSheet: bottom sheet look; booster icon and name, ×1 and ×3 prices,
  coin balance; buttons disabled when you can't afford them; Close.
- Don't put rewarded buttons anywhere without the 🎬 icon and reward text.

Done when: analyze is clean and flutter test passes.
```

---

## A5 — Home, Level Map, Settings page

```
Read AGENTS.md first and follow it strictly. Use the A1 design system.

Task: redesign lib/ui/screens/home_screen.dart and level_map_screen.dart.
Keep constructors and keys (homeScreen, homePlay, homeMap, homeSettings,
homeShop, homeWheel, mapScreen, mapNode(n)) unchanged.
Look: design/ui_canvas/screens/Home.png and LevelMap.png (Pip on the
platform, big green Play, cream cards, leaves). Leave out gems, the profile
avatar and the "Awards" tab; those aren't in Phase 1. A bottom nav is fine if it
holds Shop (onOpenShop), Spin (onOpenWheel, only when data.wheelUnlocked,
badge when data.freeSpinReady) and Settings (onOpenSettings).
Source: phases/phase_1/06_UI_UX_SCREENS.md §5.3, §5.4; biomes in
01_GAME_CONCEPT_AND_RULES.md §2.3.

- Home (§5.3): coin pill + settings button; Pip; big primary "▶ LEVEL N"
  button (when data.allCleared, show "More levels soon", disabled); Map;
  Shop; Spin (rules above). Hide the VIP chip when data.vipActive. Leave a
  slot for the Daily card (coming next) but don't build it yet.
- Level Map (§5.4): winding vine path, virtualized list. Node states: locked
  🔒, current ◉ pulsing with Pip, cleared with 1–3 stars, Hard 🐾 in red.
  Biome header "Pip's Backyard" for levels 1–10. Jump-to-current button.
  Only call onLevelTap for unlocked nodes.

Done when: analyze is clean and flutter test passes.
```

---

## A6 — Shop, Lucky Lily Wheel, Gift Basket

```
Read AGENTS.md first and follow it strictly. Use the A1 design system.

Task: redesign lib/ui/screens/shop_screen.dart, lib/ui/screens/wheel_screen.dart
and GiftBasketPopup in lib/ui/popups/. Keep constructors and keys unchanged
(shopScreen, shopTile(booster, qty), shopFreeCoins, wheelScreen,
wheelSpinFree, wheelSpinAd, giftBasket, giftCollect).
Sources: phases/phase_1/06_UI_UX_SCREENS.md §5.11, §5.14, §5.15;
04_BOOSTERS_COINS_SHOP.md §6, §8, §10. Look: design/ui_canvas/screens/Shop.png
(card grid and tabs) plus the archive Wheel / Gift / Chest boards in
design/ui_canvas/. In the Shop, replace the canvas's Skins, Food and Themes
tabs with Phase 1's Boosters · Coins · Offers.

- Shop: header with back + coin balance. Tabs Boosters · Coins · Offers.
  Boosters tab = data.tiles as a grid (icon, ×1/×3, price; locked → "Unlocks
  at L15/L25"; unaffordable → dimmed; tap → onBuy, optional confirm).
  "🎬 Free +50 🪙 (n left)" tile → onFreeCoins (disabled when 0 left, ad
  unavailable, or busy). Coins and Offers tabs: when !data.storeAvailable,
  show disabled tiles with "Store unavailable". Footer: "Restore purchases ·
  Terms" (no-op for now).
- Wheel: 8 EQUAL-size segments in data.segments order, pointer on top,
  "ⓘ" opens an odds sheet listing every segment's odds in % (required by
  store policy). "Spin free" → onSpinFree; "🎬 Spin again (1 left)" →
  onSpinAd. When data.spinSeq changes, spin 2.5 s with a decelerate curve
  and land on data.prizeIndex, then show the prize popup. The prize is
  already granted, so the animation is decoration only. data.timeLocked →
  show "Your clock seems off — jungle time will return soon" and disable
  both buttons. Reduced motion → no long spin, just reveal.
- GiftBasketPopup: basket shakes in a loop, tap to open (burst), reward chips
  (coins + boosters) fly toward the coin pill, then Collect → onCollect.
  data.isChest → bigger Treasure Chest variant with the "Garden Hero" badge.

Done when: analyze is clean and flutter test passes.
```

# 06 — UI/UX: Design System & All Screens
> Purpose: design tokens, accessibility, responsive/board-fit rules અને Phase 1 ની **દરેક screen** (purpose, ASCII wireframe, components, states, navigation, ads placement).

**Related docs:** [../../SHARED_CORE_STANDARD.md](../../SHARED_CORE_STANDARD.md) · [./README.md](./README.md) · [./01_GAME_CONCEPT_AND_RULES.md](./01_GAME_CONCEPT_AND_RULES.md) · [./04_BOOSTERS_COINS_SHOP.md](./04_BOOSTERS_COINS_SHOP.md) · [./05_DAILY_CHALLENGE_AND_STREAK.md](./05_DAILY_CHALLENGE_AND_STREAK.md) · [./07_FRONTEND_IMPLEMENTATION_AND_QA.md](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Design Principles
1. **Cozy & tactile:** linen, birch wood, felt, soft shadows (pre-baked). Modals `Curves.easeOutBack` 280 ms.
2. **Board first:** gameplay board ક્યારેય ads કે UI થી ઢંકાય નહીં.
3. **One primary action per screen** (big wooden button), secondary as text button.
4. **Readable for 10–50:** min body 16 sp, high contrast text on cream.
5. **Localized:** English / ગુજરાતી / हिन्दी (ARB) — buttons text expand 30% allowance.

## 2. Design Tokens

### 2.1 Colors
| Token | Hex | Use |
|---|---|---|
| `bgLinen` | `#FFF9F0` | app background, board cloth |
| `boardFrame` | `#D4A373` | birch frame |
| `boardFrameDark` | `#A9784A` | frame inner edge |
| `gridDot` | `#E9DAC1` | cross-stitch cell dots |
| `surfaceCard` | `#FFFFFF` | cards, modals |
| `textPrimary` | `#2D2926` | body text (contrast 14:1 on bgLinen) |
| `textSecondary` | `#6B625A` | captions (contrast 5.6:1) |
| `primaryBtn` | `#E07A5F` | terracotta primary CTA |
| `primaryBtnText` | `#FFFFFF` | |
| `secondaryBtn` | `#81B29A` | sage secondary |
| `heartActive` | `#E5484D` | hearts |
| `heartLost` | `#D8D3CD` | lost heart |
| `coinGold` | `#F2C14E` | Coins |
| `hardBadge` | `#C0392B` | Hard level badge |
| `previewClear` | `#2E9E5B` | Thread Peek clear |
| `previewBlocked` | `#D64545` | Thread Peek blocked |
| `overlayScrim` | `#2D2926` @ 55% | modal scrim (`withValues(alpha: 0.55)`) |
| `nightOverlay` | `#1E1B2E` @ 70% | M040 Lamplight Evening |

### 2.2 Thread palette (colour + pattern + needle icon — colour-blind safe)
| JSON color | Name | Hex | Pattern on yarn | Needle-eye icon |
|---|---|---|---|---|
| `red` | Rose | `#E25C6A` | solid twist | ♥ heart |
| `green` | Mint | `#4FAE7B` | diagonal stripes | leaf |
| `blue` | Heather Blue | `#4F7FC0` | dots | drop |
| `yellow` | Butterscotch | `#F2B544` | zigzag | star |
| `purple` | Lavender | `#8E6CC1` | cross-stitch ×× | flower |
| `orange` | Coral | `#F08A4B` | chevrons | sun |
| `teal` | Teal | `#2E9C9C` | waves | moon |
| `brown` | Cocoa | `#8B5E3C` | dashes | button |

Rule: Color Eyelet, Color Hem Gap, Safety-Pin Cage, Charm & Clasp, Color Bundle અને Ombre Thread હંમેશા colour + icon બંને બતાવે.

### 2.3 Typography
| Style | Font | Size / weight |
|---|---|---|
| Display (Level Complete) | Baloo 2 | 34 sp / 700 |
| Title | Baloo 2 | 24 sp / 700 |
| Button | Nunito | 18 sp / 800 |
| Body | Nunito | 16 sp / 600 |
| Caption / badge | Nunito | 13 sp / 700 (min) |
| Gujarati / Hindi | Noto Sans Gujarati / Noto Sans Devanagari | same scale |
Fonts bundled as assets (no runtime download).

### 2.4 Radii, spacing, shadows
| Token | Value |
|---|---|
| `radiusS / M / L` | 8 / 14 / 24 dp |
| `space` scale | 4, 8, 12, 16, 24, 32 dp |
| `gutter` | 16 dp (screen side) |
| `shadowCard` | 0 4 dp, `#000000` @ 12% (pre-rendered 9-patch, no runtime blur on board) |
| `shadowThread` | offset (1.5, 2) dp, `#3B2A1A` @ 18%, drawn as offset stroke (no `MaskFilter.blur`) |
| Button height | 56 dp primary, 44 dp secondary |

## 3. Accessibility
- **Colour-blind:** every thread colour also has a **pattern + needle icon** (§2.2). Settings → "Pattern labels: Always / Auto" (Auto = on for Color mechanics). Thread Peek uses ✓ / × glyphs too, not only green/red.
- **Min tap target:** 48×48 dp for all UI buttons; board cells ≥ 29 dp with tap slop: touch resolves to nearest cell centre within 0.5 cell, and thread hit-test expands stroke to full cell.
- **Text scale:** respects system text scale up to 1.3× (layouts tested at 1.3); above clamps to 1.3 for HUD, body text scrolls.
- **Motion:** Settings → "Reduce motion" ⇒ confetti off, snag shake 50%, modals fade only.
- **Haptics / sound** toggles separate; music separate.
- **Lamplight Evening (M040):** "Reduce darkness" toggle ⇒ min 60% brightness.
- Screen reader: buttons have semantic labels ("Needle Glow Hint, 3 left"); board gives summary ("12 threads left, 2 hearts").

## 4. Responsive Rules & Board Fit
- Portrait only. **Safe areas** (`SafeArea` / `MediaQuery.paddingOf`) for notch, punch-hole, home indicator; banner placed above bottom inset.
- **Phones 16:9 → 21:9:** vertical stack HUD (64 dp) · board (flex) · booster bar (88 dp) · banner (adaptive, ≥ 8 dp gap + divider). Extra height on tall phones goes to board vertical centring.
- **Tablets 4:3:** content column max width 600 dp, centred; board cell cap 64 dp.
- **Board:** a **rectangular craft board** (wood frame + linen). Not a round hoop — a W×H square grid must fit fully with no clipped cells. Frame 8 dp drawn inside the 16 dp gutter.
- Cell size: `cell = floor(min((screenW − 2·16) / W, availH / H))`. Phase 1 max 11×11 ⇒ on 360 dp width: (360 − 32) / 11 = **29.8 dp ≥ 29 dp** (CI validator min). No zoom in Phase 1 (pinch-zoom arrives with ≥ 12×12 in Phase 2).
- Devices < 360 dp width (rare, e.g. 320 dp): boards > 9×9 use reduced gutter 8 dp; if still < 29 dp ⇒ allow 26 dp with enlarged tap slop (logged `small_screen` analytics) — design target stays 29 dp.

## 5. Navigation Map
```
Splash → (first launch) Age gate → UMP Consent → Home
Home ─┬─ Play → Gameplay ─┬─ Win → Level Complete → [Craft Basket] → [Golden Bobbin Rush] → Level Map/next
      │                   ├─ 0 hearts → Second Chance → Level Failed → Retry / Home
      │                   └─ Pause → Settings / Home
      ├─ Level Map → Gameplay
      ├─ Daily Stitch → Daily Gameplay → Daily Complete + Streak calendar
      ├─ Spinning Wheel (modal)
      ├─ Shop → VIP paywall
      ├─ Leaderboards (platform UI)
      └─ Settings
L500 win → Grand Sewing Chest → Golden Bobbin Rush → Phase Complete → Home
```

---

## 6. Splash / Loading
**Purpose:** brand + async init (Hive open, Remote Config fetch ≤ 2 s timeout, level pack decompress, audio pool, ads preload after consent).
```
┌────────────────────────┐
│                        │
│     🧶  Yarn Unravel   │
│   Cozy Thread Puzzle   │
│                        │
│   (Purl rolling ball)  │
│   ▓▓▓▓▓▓░░░░  62%      │
└────────────────────────┘
```
Components: logo, Purl Lottie-free sprite animation (spritesheet), progress bar. States: loading · error (save corrupt ⇒ restore backup prompt) · offline (continue, Remote Config defaults). Nav: first launch ⇒ Age gate; else Home. Ads: none.

## 7. Age Gate & Consent
**Purpose:** neutral age screening (Families policy) + UMP consent.
```
┌────────────────────────┐
│  Welcome!              │
│  What year were you    │
│  born?                 │
│   [  ▲  2009  ▼ ]      │  (wheel picker, no default adult year — starts at current year)
│   [   Continue   ]     │
│  Privacy Policy        │
└────────────────────────┘
```
Logic: age < 13 ⇒ `ageBand = child` ⇒ `tagForChildDirectedTreatment`, non-personalized, rating G, analytics personalization off. Then UMP form (EEA/UK) before any ad request. States: picker · UMP shown · UMP error (proceed with non-personalized). Nav: Home (tutorial L1 auto-start on first launch). Ads: none. Change later: Settings → Privacy (age not re-askable to lower risk of gaming; support contact).

## 8. Home
**Purpose:** hub — play next level, Daily, Spin, Shop.
```
┌──────────────────────────────┐
│ ⚙   🪙 1,240   [+]   👑VIP   │
│                              │
│   (hoop decoration + Purl)   │
│      LEVEL 137               │
│   [   ▶  PLAY   ]            │
│                              │
│ [🧵 Daily Stitch  🔥4]       │
│ [🎡 Spin (free!)] [🛍 Shop]  │
│ [🏆 Leaderboards] [🗺 Map]   │
├──────────────────────────────┤
│        Banner ad             │
└──────────────────────────────┘
```
Components: coin pill (tap ⇒ Shop Coins tab), VIP crown (⇒ paywall; shows "Active until dd MMM" if VIP), Play button with next level number + Hard badge if x9, Daily card (locked "Clear L15" before unlock, streak flame count), Spin (**hidden until L10 clear**, §16.32; badge if free spin available), Starter Pack ribbon (48 h window after L15, countdown). States: normal · Daily locked · Spin hidden (before L10 clear) · time-travel lock banner · offline indicator. Ads: banner bottom (not VIP).

## 9. Level Map
**Purpose:** progress path, replay levels.
```
┌──────────────────────────────┐
│ ←  Level Map      ★ 312     │
│        (139)                 │
│      ╱                       │
│   (138)🔒                    │
│     ╲                        │
│     (137) ← you  ▶           │
│      ╱                       │
│   [136 ★★★] [135 ★★]        │
│   🎁 140  (Craft Basket)     │
├──────────────────────────────┤
│        Banner ad             │
└──────────────────────────────┘
```
Path = stitched dashed seam winding over fabric patches; each 10-block = one patch colour; x1 node "NEW" ribbon with mechanic icon; x9 red "Hard"; x0 basket icon; L500 big quilt node. Tap cleared node ⇒ replay. Virtualized `ListView.builder` (500 nodes). Ads: banner bottom.

## 10. Gameplay HUD
**Purpose:** play a level.
```
┌──────────────────────────────┐
│ ⏸  ♥♥♡ 🛡2   Lv 137  Moves 9 │
│              ✦ 2/4 (goal)    │
│ ┌──────────────────────────┐ │
│ │ ░ birch frame ░░░░░░░░░░ │ │
│ │ ░ · ═══╗ · · · ║ · · ░  │ │
│ │ ░ · · ·║ ◉ · ·═╝ · · ░  │ │
│ │ ░ (threads on linen)  ░  │ │
│ └──────────────────────────┘ │
│ [💡3] [↩️5] [🛡1] [✂️2]       │
│ ───────── divider ────────── │  ≥ 8 dp gap
│        Banner (L11+)         │
└──────────────────────────────┘
```
Components: pause, hearts (felt), Shield badge with charges, level label (+ "Hard"/"Daily: Tidy Tuesday"), Moves counter (Tue: "Moves 9 / Par 12"), goal chip (Sequins / Guardian HP), board canvas, booster bar 4 buttons with count / lock / "used 3/3", banner. States: idle · animating (input queue 1) · peek (long-press) · hammer targeting (dim non-targets, cancel X; last thread disabled while Sequins remain) · hint glow · tutorial overlay · Second Chance (board frozen) · **"Stuck" sheet** (solver finds no winning sequence ⇒ Undo / Restart, no heart loss, no fail screen, `E-GAME-004`, §17.31) · **"Level unavailable"** (level JSON corrupt/missing ⇒ message + Retry; level ક્યારેય skip / cleared mark નહીં, `E-LVL-001`/`E-LVL-002`). Ads: banner L11+ only; never over board.

## 11. Pause / Settings
**Purpose:** pause, settings, legal.
```
┌────────────────────────┐
│   Paused               │
│ [ ▶ Resume ]           │
│ [ ↻ Restart ]          │
│ [ ⌂ Home ]             │
│ Sound ◉  Music ◉  Haptics ◉ │
│ Language: English ▾    │
│ Pattern labels: Auto ▾ │
│ Reduce motion ○        │
│ Privacy ▸ Share diagnostics ◉ │
│ Help ▸ Report a problem │
│ Spin odds · Privacy · Terms │
│ Restore purchases      │
│ Manage consent (UMP)   │
└────────────────────────┘
```
- **Sound / Music / Haptics:** ત્રણ અલગ toggles (`settings.sound`, `settings.music`, `settings.haptics`), [../../SOUND_EFFECTS_IMPLEMENTATION.md](../../SOUND_EFFECTS_IMPLEMENTATION.md) §7.
- **Privacy → "Share diagnostics":** off ⇒ Crashlytics collection off + analytics collection off + replay upload off; local ring buffer device પર જ રહે ([../../LOGGING_AND_ERROR_TRACKING.md](../../LOGGING_AND_ERROR_TRACKING.md) §10). Privacy માં "Delete my data" પણ.
- **Help → "Report a problem":** category picker (+ free text માત્ર 13+), last logs + replays attach, Report ID (`BR-XXXXXX`) બતાવે; offline ⇒ queue (max 3) (LOGGING §11).
Restart from pause = new attempt (hearts 3, board reset; `adReviveUsed[level]` stays). Home from pause = attempt discarded (confirm dialog). Settings also reachable from Home (same sheet without Resume/Restart). Ads: none.

## 12. Tutorial Overlays
**Purpose:** FTUE + booster + mechanic intro (x1).
```
┌──────────────────────────────┐
│ ▓▓▓▓▓▓ scrim ▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │
│ ▓▓  ┌───────┐ ▓▓▓▓▓▓▓▓▓▓▓▓ │
│ ▓▓  │thread │ ← 🐾 Purl paw │
│ ▓▓  └───────┘ ▓▓▓▓▓▓▓▓▓▓▓▓ │
│  "Tap a thread to pull it!" │
└──────────────────────────────┘
```
Mechanic intro card (x1): illustration + 1-line rule + "Got it". Re-viewable via (i) icon in HUD for that level's mechanics. Forced steps L1–3 (cut-out allows only target tap). Ads: none.

## 13. Second Chance ("Tangled Up!")
**Purpose:** 0 hearts ⇒ revive options.
```
┌────────────────────────┐
│     Tangled Up!        │
│    (knotted heart)     │
│    ◔ 10 s ring         │
│ [🎬 Watch ad: +1 ♥ ]   │  (hidden if adReviveUsed[level])
│ [🪙 120: +1 ♥ ] (1/2)  │
│     No thanks          │
└────────────────────────┘
```
States: both options · ad unavailable (disabled + "Ad unavailable") · ad used ("Revive used for this level") · coins insufficient (button ⇒ mini Shop sheet, countdown paused while sheet open) · refill cap reached (2/2, hidden). Countdown end / No thanks ⇒ Level Failed. Ads: rewarded only (opt-in).

## 14. Level Failed
```
┌────────────────────────┐
│   Out of hearts        │
│   (Purl tangled in yarn)│
│ [ ↻ Retry ]  (free)    │
│   Home                 │
│ Tip: Hold a thread to  │
│ Peek its lane.         │
└────────────────────────┘
```
No penalty, no interstitial. Retry = full 3 hearts, board reset. Ads: none.

## 15. Level Complete
```
┌────────────────────────┐
│   Level 137 Complete!  │
│      ★ ★ ★             │
│   +20 🪙   +20 ★★★     │
│ [🎬 2X Coins (+20)]    │
│ [  Next ▶  ]           │
│   Map                  │
└────────────────────────┘
```
States: first clear (coins) · replay (0 coins, "Best ★★") · star improved · 2X used. Next ⇒ (x0) Craft Basket ⇒ (×25) Golden Bobbin Rush ⇒ next level; interstitial check after Next (deferred if a reward screen showed this win). Ads: optional rewarded 2X; interstitial between Complete and next level per rules.

## 16. Craft Basket (Gift Box)
```
┌────────────────────────┐
│   Milestone 140!       │
│   (wicker basket opens)│
│   +180 🪙              │
│   +1 ✂️ Golden Scissors │
│   [  Collect  ]        │
└────────────────────────┘
```
L500 variant: **Grand Sewing Chest** (wooden sewing box, 3-tier trays opening): 1,000 Coins + 2 of each booster + "Master Quilter" badge. Ads: none (and interstitial deferred).

## 17. Golden Bobbin Rush (Coin Rush)
```
┌──────────────────────────────┐
│  GOLDEN BOBBIN RUSH  ⏱ 0:21  │
│  🪙 120   threads 12/22      │
│ ┌──────────────────────────┐ │
│ │ golden threads on indigo │ │
│ │ linen, fairy lights      │ │
│ └──────────────────────────┘ │
│          [Skip]              │
└──────────────────────────────┘
```
Intro card "Pull as many golden threads as you can in 30 s! 10 Coins each, +100 for all" ⇒ "Start". Result card: coins earned ⇒ Collect. No hearts, no boosters, no banner, no interstitial after. Background ⇒ pause.

## 18. Daily Stitch + Streak Calendar
```
┌──────────────────────────────┐
│ ←  Daily Stitch   Tue 27 Oct │
│  "Tidy Tuesday" Par 14 Moves │
│   (Teacup silhouette preview)│
│ [   ▶ Play   ]  +100 🪙      │
│ ── 7-Day Streak ──           │
│ [1✓][2✓][3✓][4●][5][6][7🏆]  │
│  50  75 100+💡 125+↩️↩️ …    │
│  Thimble Trophy: Silver      │
└──────────────────────────────┘
```
States: locked (before L15) · available · cleared today ("Come back tomorrow" + next reset timer) · reward pending (20 h rule) · Darning Patch offer modal (ad / 200 Coins) · time-travel lock banner · offline (play allowed, "will verify when online"). Daily complete screen shows silhouette reveal + streak day claim animation. Ads: Darning Patch rewarded option; no interstitial after Daily.

## 19. Spinning Wheel (Lucky Spin)
```
┌────────────────────────┐
│   Spinning Wheel       │
│   (8 skein segments)   │
│   [ SPIN (free) ]      │
│   [🎬 Spin again ]     │  (1/day)
│   Odds ⓘ               │
└────────────────────────┘
```
States: free available · used (ad spin available) · both used (next spin timer) · time-travel lock. Odds ⓘ ⇒ odds table ([04 §6](./04_BOOSTERS_COINS_SHOP.md)). Ads: rewarded extra spin only.

## 20. Shop
Layout: [04 §7](./04_BOOSTERS_COINS_SHOP.md). Tabs: Boosters · Coins · Offers (Starter Pack when eligible, VIP). Components: coin pill, free +50 Coins (ad, "3/5 left today"), booster cards (single / 3-pack with "Save 30"), coin packs (Popular, Best Value tags), Restore purchases. States: loading products · store unavailable ("Store not available — try later") · purchase pending · success (coin fly) · failure toast. Mini shop sheet (bottom sheet) from booster bar / Second Chance shows only relevant items. Ads: rewarded free coins only; no banner in Shop.

## 21. VIP Paywall
```
┌────────────────────────┐
│ 👑 VIP No-Ads Pass     │
│ ✓ No interstitial ads  │
│ ✓ No banner ads        │
│ ✓ Rewarded ads optional│
│   ₹20 / month          │
│ [ Subscribe ]          │
│ Renews monthly. Cancel │
│ anytime in store.      │
│ Restore · Terms · Privacy │
└────────────────────────┘
```
States: not subscribed · active ("Active, renews dd MMM") · expired ("Ads are back — renew?") · pending. Never say "forever/permanent". Ads: none.

## 22. Leaderboards
Native platform UI via `games_services` (Highest Level, Total Stars, Total Streak Days). In-app entry sheet:
```
┌────────────────────────┐
│ Leaderboards           │
│ [🏅 Highest Level  ]   │
│ [⭐ Total Stars    ]   │
│ [🔥 Streak Days    ]   │
│ (Sign in to Play Games)│
└────────────────────────┘
```
States: signed in · not signed in (sign-in button) · offline (disabled). Ads: none.

## 23. Phase Complete (after L500)
```
┌────────────────────────┐
│  Phase 1 Complete!     │
│  (finished quilt, Purl │
│   wrapped in it)       │
│  Badge: Master Quilter │
│  500 levels · ★ 1,284  │
│ [ Daily Stitch ]       │
│ [ Home ]               │
│ New patterns coming    │
│ soon! (if maxPhase=1)  │
└────────────────────────┘
```
If Phase 2 shipped: "Continue to Level 501" button ([../phase_2/README.md](../phase_2/README.md)). Ads: none.

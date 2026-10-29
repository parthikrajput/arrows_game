# 06 — UI/UX & Screens
> Design tokens, accessibility, responsive rules અને Phase 1 ની **દરેક screen** (purpose, wireframe, components, states, navigation, ads).

**Related docs:** [Phase 1 index](./README.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [04 Boosters & Shop](./04_BOOSTERS_COINS_SHOP.md) · [05 Daily & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Design Principles
1. **Board first:** Gameplay screen પર board સૌથી મોટું; HUD અને booster bar compact.
2. **Soft 3D minimal:** Pastel garden colours, rounded shapes, pre-baked soft shadows, bevel buttons (bottom lip).
3. **One primary action per screen:** મોટું green button; secondary text/outline.
4. **Calm feedback:** Bonk/locked animations ટૂંકા, ક્યારેય aggressive red flashing full-screen નહીં.
5. **Ads never surprise:** Rewarded હંમેશા 🎬 icon + reward text; interstitial માત્ર §5.10 ના "Next" પછી.

## 2. Design Tokens
### 2.1 Colours
| Token | Hex | Use |
|---|---|---|
| `bgSage` | `#E8F5E9` | App background, board tint (Garden) |
| `bgCream` | `#FFFBF2` | Cards, popups |
| `surface` | `#FFFFFF` | Sheets, Shop tiles |
| `surfaceAlt` | `#F7F9FA` | List rows, disabled tile bg |
| `primary` | `#2E7D32` | Primary buttons (white text contrast ≥ 4.5:1) |
| `primaryLight` | `#66BB6A` | Button top highlight gradient, progress fill |
| `onPrimary` | `#FFFFFF` | Text on primary |
| `coinGold` | `#FFCA28` | Coins, stars |
| `coinGoldDark` | `#B8860B` | Coin outline, star outline |
| `heart` | `#E53935` | Heart berries |
| `danger` | `#C62828` | Destructive text, blocked preview (`#D32F2F` line) |
| `previewClear` | `#2E7D32` | Clear lane dotted line |
| `previewBlocked` | `#D32F2F` | Blocked lane + ✕ marker |
| `textPrimary` | `#1B2B1F` | Body text |
| `textSecondary` | `#5B6B5F` | Captions |
| `textDisabled` | `#9AA59D` | Disabled |
| `scrim` | `#000000` @ alpha 0.45 | Popup backdrop (`Colors.black.withValues(alpha: 0.45)`) |
| `nightOverlay` | `#0D1B2A` @ alpha 0.80 | M040 Jungle Night |
| `vipPurple` | `#7E57C2` | VIP badge/paywall |

Phase 1 = light theme only (night look માત્ર M040 levels માં).

### 2.2 Snake Palette (colour + pattern + icon)
| Colour id | Hex | Body pattern | Head tag icon (colour-blind mode) |
|---|---|---|---|
| `red` | `#FF7043` | Polka dots | ● |
| `green` | `#7CB342` | Leaf veins | 🍃 |
| `blue` | `#29B6F6` | Cross stripes | ≡ |
| `yellow` | `#FFCA28` | Zigzag | ⚡ |
| `purple` | `#9575CD` | Diamonds | ◆ |
| `orange` | `#FFA726` | Rings | ◎ |
| `pink` | `#F06292` | Tiny hearts | ♥ |
| `teal` | `#26A69A` | Chevrons | ➤ |

Flower Gate / Flower Arch / Petal Cage / keys પણ એ જ pattern + icon વાપરે.

### 2.3 Typography (bundled fonts, offline)
| Style | Font | Size / line | Weight |
|---|---|---|---|
| `display` | Fredoka | 32 / 40 | 600 |
| `h1` | Fredoka | 24 / 32 | 600 |
| `h2` | Fredoka | 20 / 28 | 600 |
| `body` | Nunito | 16 / 24 | 500 |
| `caption` | Nunito | 13 / 18 | 500 |
| `button` | Fredoka | 18 / 24 | 600 |
| `hudNumber` | Fredoka (tabular figures) | 20 / 24 | 600 |

ગુજરાતી: **Baloo Bhai 2**, हिन्दी: **Baloo 2** (same sizes, line height +10%). Font fallback `fontFamilyFallback` locale પ્રમાણે.

### 2.4 Spacing & Radii
- Spacing scale (dp): 4, 8, 12, 16, 24, 32, 48. Screen side gutter 16.
- Radii: `xs 8` (badges), `sm 12` (chips), `md 16` (buttons, tiles), `lg 24` (popups, sheets top), `pill 999`. Board cell corner = 0.18 × cell.

### 2.5 Shadows (Flutter `BoxShadow`, static widgets only)
| Token | Definition |
|---|---|
| `elev1` (cards) | `BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))` |
| `elev2` (popups) | `BoxShadow(color: Color(0x1F000000), blurRadius: 24, offset: Offset(0, 8))` |
| `bevelLip` (3D buttons) | `BoxShadow(color: Color(0x33000000), blurRadius: 0, offset: Offset(0, 4))` + top `LinearGradient(primaryLight → primary)` |
| `pressed` | `bevelLip` offset `Offset(0, 1)` + translateY 3 dp |

Board/snake shadows `BoxShadow` નહીં: cached board `Picture` માં pre-baked (per-frame `MaskFilter.blur` નહીં) — [07 §4](./07_FRONTEND_IMPLEMENTATION_AND_QA.md#4-game-loop--renderer).

### 2.6 Motion
| Token | Duration | Curve |
|---|---|---|
| `fast` | 150 ms | `Curves.easeOut` |
| `base` | 250 ms | `Curves.easeOutCubic` |
| `move` | 250–450 ms (lane length) | `Curves.easeInOutCubic` |
| `bonk` | 380 ms | forward `Curves.easeOut`, back `Curves.elasticOut` |
| `popupIn` | 300 ms | `Curves.easeOutBack` |

## 3. Accessibility
| Area | Rule |
|---|---|
| Colour-blind | **દરેક snake colour સાથે pattern હંમેશા** (§2.2). Settings "Colour-blind mode" ⇒ patterns bolder + head tag icon. Colour-dependent mechanics (M005, M030, M033, M041, M048) icon પણ બતાવે |
| Tap targets | UI buttons min **48 × 48 dp**. Board cell min 29 dp + 0.5 cell hit-slop ([01 §5.7](./01_GAME_CONCEPT_AND_RULES.md#57-tap-priority--hit-test)) |
| Text scale | UI `MediaQuery.textScaler` respect, max 2.0 (menus); HUD numbers clamp 1.5; board labels (badges) scale with cell, not text scale |
| Contrast | Text ≥ 4.5:1 (body), ≥ 3:1 (large ≥ 24 dp) |
| Reduced motion | System "reduce motion" અથવા Settings ⇒ wiggle amplitude 0, confetti off, screen shake off; functional motion (slither) ચાલુ પણ ટૂંકું |
| Haptics | Settings toggle (default on) |
| Audio | Sound / Music separate toggles; key info ક્યારેય audio-only નહીં |
| Night levels (M040) | "Brighter nights" ⇒ min visibility 40% |
| Screen reader | Menus, Shop, popups: `Semantics` labels (દા.ત. "Hint booster, 2 left"). Board: snakes `Semantics(label: "Green snake facing right, path clear")` — basic support |
| Language | English, ગુજરાતી, हिन्दी; numbers locale-formatted |

## 4. Responsive Rules
| Rule | Value |
|---|---|
| Orientation | Phones: portrait lock. Tablets (shortest side ≥ 600 dp): portrait + landscape |
| Aspect ratios | Phones 16:9 → 21:9 (e.g. 360×640 … 412×915), tablets 4:3 (768×1024) |
| Safe areas | `SafeArea` / `MediaQuery.paddingOf` — notch, Dynamic Island, punch-hole, gesture bar. Banner bottom safe-area ઉપર |
| Board fit | `cell = floor(min((availW − 2×16) / W, availH / H))`; `availH = screenH − safeTop − safeBottom − HUD 64 − boosterBar 88 − bannerReserve (adaptive height + 8 gap, L11+ & non-VIP) − 16` |
| Min cell | **29 dp** (Phase 1 max 11×11 on 360 dp width ⇒ 29.8). Validator + runtime assert; ઓછું થાય તો banner gameplay માં hide (fallback) |
| Max board width | 600 dp (tablets: centered, extra space = garden decoration) |
| Tablet landscape | HUD top, booster bar right side vertical, banner bottom |
| Fold/resize | Re-layout on `MediaQuery` change; board state unaffected |

## 5. Screens
Navigation summary: Splash → Age gate/Consent (first run) → Home ↔ Level Map ↔ Gameplay ⇄ popups; Home ↔ Shop / Daily / Spin / Leaderboards / Settings.

---

### 5.1 Splash (Launch Intro)
**No loading screen.** Tap icon ⇒ system splash (`splashCanopy` + animated Pip mark) ⇒ Home's first frame ⇒ "Jungle Dawn" intro plays on top of a live, tappable Home. Full spec, timelines and Kotlin/Flutter code: [SPLASH_AND_INSTANT_LAUNCH §7](../../SPLASH_AND_INSTANT_LAUNCH.md#7-game-1--snakes-slither-jungle-dawn).
- **Modes:** full 1,200 ms (first cold start of the day) · short 450 ms · 150 ms fade (reduce motion). Tap anywhere skips; tap on Play starts the level.
- **States:** save corrupt ⇒ backup restored before the first frame, message after the intro. Large save migrations run after the intro.
- **Nav:** first run ⇒ intro ends on the Age Gate ⇒ Consent (EEA/UK) ⇒ Home. Returning ⇒ Home (FTUE incomplete: after the intro, straight to L1–10 Gameplay).
- **Ads:** none. Budget: cold start → Home first frame ≤ 600 ms mid-tier, ≤ 1,200 ms low-tier.

### 5.2 Age Gate & Consent
**Purpose:** Neutral age gate (birth year) + UMP consent (EEA/UK).
```
┌───────────────────────────┐
│   When were you born?     │
│   ┌─────────────────┐     │
│   │  ▲  2009  ▼     │     │   (year wheel, no default age hint)
│   └─────────────────┘     │
│      [  Continue  ]       │
│  Privacy Policy · Terms   │
└───────────────────────────┘
        ↓ (EEA/UK)
   [ Google UMP consent form ]
```
- **Components:** year picker (current year − 100 … current year), Continue, links.
- **States:** unanswered (Continue disabled) · under-13 ⇒ child-directed ad settings · 13+.
- **Nav:** ⇒ UMP form (if required) ⇒ Home / L1. Settings → "Privacy choices" ફરી ખોલે.
- **Ads:** none (ads load consent પછી જ).

### 5.3 Home
**Purpose:** Main hub — Play, Daily, Spin, Shop, events.
```
┌───────────────────────────┐
│ 🪙 1,250  [+]     ⚙️      │  top bar
│ ┌───────────────────────┐ │
│ │ 📅 Daily Jungle Puzzle│ │  Daily card (L15+)
│ │ 🦋 Mon · Classic  🔥4 │ │
│ │ +100 🪙   [ Play ]    │ │
│ └───────────────────────┘ │
│        (Pip + garden)     │
│    ┌─────────────────┐    │
│    │  ▶  LEVEL 37    │    │  primary
│    └─────────────────┘    │
│  🌸Spin  🛒Shop  🏆Ranks  │  round buttons
│  [ VIP · No ads ₹20/mo ]  │  (hidden if VIP)
├───────────────────────────┤
│      [ banner ad ]        │
└───────────────────────────┘
```
- **Components:** coin pill (+ ⇒ Shop Coins), settings, Daily card (locked state before L15: "Unlocks at L15"), Play button (next level), Map button (tap on level label), Spin (badge "1" when free), Shop, Leaderboards, VIP chip, Starter Pack bubble (48 h window, countdown).
- **States:** FTUE (L < 4: minimal, only Play) · normal · time-travel lock (Daily & Spin cards show clock warning) · Rush pending banner.
- **Nav in:** Splash, back from any hub screen. **Out:** Gameplay, Level Map, Daily, Spin, Shop, Leaderboards, Settings, VIP paywall.
- **Ads:** adaptive banner bottom (non-VIP).

### 5.4 Level Map
**Purpose:** Progress path through biomes; replay old levels.
```
┌───────────────────────────┐
│ ← Map    Garden Meadow 🪙 │
│      (40)🎁               │
│     ╱                     │
│   (39)🐾  ← Hard          │
│     ╲                     │
│      (38)★★★              │
│     ╱                     │
│   (37) ◉ YOU  (Pip)       │
│     ╲                     │
│      (36)★★               │
│  … scroll …  (41)NEW!     │
├───────────────────────────┤
│      [ banner ad ]        │
└───────────────────────────┘
```
- **Components:** winding vine path (`ListView` virtualized, 500 nodes), node states (locked 🔒, current ◉ pulse, cleared with stars, Hard 🐾 red, milestone 🎁, intro "NEW!", L500 Mongoose statue), biome headers, jump-to-current FAB, Rush pending golden banner.
- **States:** loading (skeleton) · normal · Phase complete (L500 trophy).
- **Nav:** node tap ⇒ Level start sheet (level no., stars best, Play) ⇒ Gameplay. Back ⇒ Home.
- **Ads:** banner bottom.

### 5.5 Gameplay HUD
**Purpose:** Puzzle play.
```
┌───────────────────────────┐
│ ⏸  Lv 37   ♥ ♥ ♥   🪙1250 │  HUD 64 dp
│        Moves 7            │
│ ┌───────────────────────┐ │
│ │ . . . . . . . . .     │ │
│ │ . 🐍━━━━▶ . 🪨 . .     │ │  board (auto-fit)
│ │ . . ┃ . . . . . .     │ │
│ │ . . ▼ . 🐛━━▶ . .     │ │
│ │ . . . . . . . . .     │ │
│ └───────────────────────┘ │
│  🪲✨2   🌀2   🐚1   🔨1   │  booster bar 88 dp
├──────── 8 dp gap ─────────┤
│      [ banner ad ]  (L11+)│
└───────────────────────────┘
```
- **Components:** pause, level label (+ 🐾 Hard / NEW chip), hearts (heart berries; Shield shell overlay with "2"), coins, Moves counter (Tuesday: `7 / par 9`), gem counter (M026 levels), Mongoose HP pips (M049), board `CustomPaint`, booster bar (count badges, locks, caps), Hammer target-mode banner ("Tap a snake or rock · Cancel").
- **States:** intro card (x1) · playing · animating (inputs queued, boosters dim) · hint glow · hammer mode · preview (long-press) · paused · second chance · won · failed.
- **Nav:** pause ⇒ Pause; win ⇒ Level Complete; hearts 0 ⇒ Second Chance; booster 0 ⇒ mini shop sheet.
- **Ads:** banner L11+ (≥ 8 dp gap + divider under booster bar); none during L1–10.

### 5.6 Pause / Settings
**Purpose:** Pause menu + full settings.
```
┌───────────────────────────┐
│        ⏸ Paused           │
│   [ ▶ Resume ]            │
│   [ ↻ Restart ]           │
│   [ 🗺 Map ]  [ 🏠 Home ]  │
│  ───────────────────────  │
│  🔊 Sound      [on ]      │
│  🎵 Music      [on ]      │
│  📳 Haptics    [on ]      │
│  🎨 Colour-blind [off]    │
│  🌙 Brighter nights [off] │
│  🌐 Language  English ▾   │
│  📖 Jungle Guide ›        │
│  🎰 Spin odds ›           │
│  🔐 Privacy choices ›     │
│  📊 Share diagnostics [on]│
│  ♻ Restore purchases ›   │
│  🐞 Help › Report a problem│
│  ℹ Terms · v1.0.0         │
└───────────────────────────┘
```
- **Components:** Resume, Restart (confirm if moves > 0; attempt resets, `adReviveUsed` unchanged), Map, Home, toggles, language, Jungle Guide (unlocked mechanic cards), Spin odds, Privacy (UMP choices + **"Share diagnostics"** toggle: off ⇒ Crashlytics/analytics collection + replay upload off, local log ring buffer device પર જ રહે), Restore, Help → **"Report a problem"** (category picker; free text + screenshot માત્ર 13+; Report ID `BR-xxxxxx` બતાવે), "Progress is saved on this device only" note. Sound / Music / Haptics toggles તરત લાગુ અને `settings.sound/music/haptics` માં persist ([Sound standard §7](../../SOUND_EFFECTS_IMPLEMENTATION.md#7-settings--persistence), [Logging standard §10–§11](../../LOGGING_AND_ERROR_TRACKING.md#10-privacy-children--compliance)).
- **States:** in-game pause vs Home settings (no Resume/Restart).
- **Ads:** none.

### 5.7 Tutorial Overlays
**Purpose:** FTUE steps, booster tutorials, mechanic intro cards.
```
┌───────────────────────────┐
│  ░░░░░░░░░░░░░░░░░░░░░░░  │  scrim with cut-out
│  ░░░░  ┌─────┐  ░░░░░░░░  │
│  ░░░░  │ 🐍  │ 👆 (hand)  │
│  ░░░░  └─────┘  ░░░░░░░░  │
│ ┌───────────────────────┐ │
│ │🐢 "Tap a snake to     │ │  Grandpa Tortoise bubble
│ │   slither out!" [Got it]│ │
│ └───────────────────────┘ │
└───────────────────────────┘
```
- **Components:** scrim + highlight cut-out, animated hand, speech bubble, "Got it". Mechanic intro card: name, rule, 3-frame loop, Got it.
- **States:** guided (only highlighted target tappable) · tooltip (any tap closes).
- **Nav:** inline over Gameplay/Home. **Ads:** none.

### 5.8 Second Chance
**Purpose:** Hearts 0 ⇒ revive offer.
```
┌───────────────────────────┐
│     Pip needs a berry!    │
│        ( 💔 )  ◔ 7        │  10-s ring
│ ┌───────────────────────┐ │
│ │ 🎬 Watch ad  +1 ♥     │ │  (disabled: "Ad unavailable" / "Used for this level")
│ └───────────────────────┘ │
│ ┌───────────────────────┐ │
│ │ 🫐 120 🪙  +1 ♥ (2 left)│ │  Heart Berry Refill
│ └───────────────────────┘ │
│         No thanks         │
└───────────────────────────┘
```
- **Components:** countdown ring (10 s, pauses while ad/shop open or app backgrounded), ad button, refill button (count left this attempt), No thanks.
- **States:** both · ad only · coins only · coins < 120 (refill ⇒ mini shop) · ad loading.
- **Nav:** success ⇒ Gameplay (same board, +1 heart). Timeout/No thanks ⇒ Level Failed.
- **Ads:** rewarded (opt-in).

### 5.9 Level Failed
```
┌───────────────────────────┐
│      Oh no! 🐍💤          │
│   The snakes got tangled  │
│   [ ↻ Try again ]         │
│   [ 🏠 Home ]             │
│  Tip: Hold a snake to     │
│  preview its path.        │
└───────────────────────────┘
```
- **Components:** sad Pip, Retry (3 hearts, board reset), Home, rotating tip (relevant to level mechanic).
- **Nav:** Retry ⇒ Gameplay; Home.
- **Ads:** **no interstitial** (rule). No banner on this popup.

### 5.10 Level Complete
```
┌───────────────────────────┐
│   🎉 Level 37 Complete!   │
│        ★  ★  ☆            │
│   +20 🪙  (+20 ★★★ bonus) │
│ ┌───────────────────────┐ │
│ │ 🎬 Claim 2X  (40 🪙)  │ │  first clear only
│ └───────────────────────┘ │
│      [   Next ▶   ]       │
│         Map               │
└───────────────────────────┘
```
- **Components:** confetti leaves (reduced-motion: off), stars animate one by one, coins breakdown, 2X Win (rewarded; hidden on replay), Next, Map. Snakes wave from edge.
- **Sequence after Next:** Jungle Gift Basket (x0) ⇒ Golden Slither Rush (L%25 == 0) ⇒ interstitial check ([04 §9](./04_BOOSTERS_COINS_SHOP.md#9-ads-rules)) ⇒ next level. L500 ⇒ Treasure Chest ⇒ Rush ⇒ Phase Complete.
- **Ads:** 2X rewarded; interstitial after Next (if eligible, not deferred).

### 5.11 Jungle Gift Basket (+ Treasure Chest)
```
┌───────────────────────────┐
│   🧺 Jungle Gift Basket!  │
│        (shaking)          │
│      tap to open          │
│   → 150 🪙  + 1 🪲✨ Hint  │
│      [ Collect ]          │
└───────────────────────────┘
```
- **Components:** basket (shake loop), open burst, reward chips fly to HUD. L500 variant: Treasure Chest (bigger, 1,000 + 2× each booster + badge).
- **States:** closed · opened · collected.
- **Nav:** ⇒ Rush (if due) else ⇒ next level. **Ads:** none; win interstitial deferred.

### 5.12 Golden Slither Rush
```
┌───────────────────────────┐
│  GOLDEN SLITHER RUSH  ⏱ 23 │
│  🪙 +80        snakes 8/22│
│ ┌───────────────────────┐ │
│ │ golden snakes board   │ │
│ │ (no obstacles)        │ │
│ └───────────────────────┘ │
│   tap fast! no hearts     │
└───────────────────────────┘
Results: "+150 🪙 · Full clear +100!"  [ Continue ]
```
- **Components:** intro card (rules, Start, small Skip ⇒ confirm), 3-2-1, 30 s timer bar, coin counter, snakes counter, results.
- **States:** intro · countdown · playing · paused (backgrounded) · results.
- **Nav:** ⇒ next level / Map. **Ads:** none; no banner; no interstitial after.

### 5.13 Daily Jungle Puzzle + Streak Calendar
```
┌───────────────────────────┐
│ ← Daily Jungle Puzzle     │
│  🦋 Monday · Classic       │
│  Reward +100 🪙            │
│  [  ▶ Play today  ]        │
│  ─── Jungle Streak 🔥4 ─── │
│  D1  D2  D3  D4  D5 D6 D7  │
│  ✅  ✅  ✅  ✅  ⬜ ⬜ 🏆    │
│  50  75 100 125 150 200 450│
│  Saver: available (1/cycle)│
│  Trophy: 🥈 Silver Coil    │
└───────────────────────────┘
```
- **Components:** today card (silhouette, modifier chip + rule text), Play, 7-day ladder with rewards, cycle trophy, Saver status, total streak days, month calendar (stamps, stars).
- **States:** locked (< L15) · available · cleared today ("Come back tomorrow" + reset clock) · saver offer (missed one day) · time-travel lock · offline (verify pending icon).
- **Nav:** Play ⇒ Gameplay (daily mode) ⇒ Daily Result ⇒ back here. **Ads:** Saver rewarded; no interstitial; no banner on result.

### 5.14 Lucky Lily Wheel
```
┌───────────────────────────┐
│ ← Lucky Lily Wheel   ⓘ    │
│        ▼                  │
│     ╭─────────╮           │
│    │ 20│50│100│           │  8 segments
│    │500│ … │🔨 │           │
│     ╰─────────╯           │
│   [ Spin free ]           │
│   🎬 Spin again (1 left)  │
└───────────────────────────┘
```
- **Components:** wheel (deterministic result, decorative spin 2.5 s, `Curves.decelerate`), ⓘ odds sheet (§10 of 04), free spin, ad spin, prize popup.
- **States:** free available · used (next reset clock) · ad available/unavailable · locked (< L10) · time-travel lock.
- **Ads:** rewarded extra spin (1/day).

### 5.15 Shop
```
┌───────────────────────────┐
│ ← Shop          🪙 1,250  │
│ [Boosters][Coins][Offers] │
│ ┌─────┐┌─────┐┌─────┐     │
│ │🪲✨1 ││🪲✨3 ││🌀1  │     │
│ │ 60  ││ 150 ││ 40  │     │
│ └─────┘└─────┘└─────┘     │
│ ┌─────┐┌─────┐┌─────┐     │
│ │🌀3  ││🐚1  ││🐚3  │ …   │
│ └─────┘└─────┘└─────┘     │
│ 🎬 Free +50 🪙 (3 left)   │
│ Restore purchases · Terms │
└───────────────────────────┘
```
- **Components:** tabs (Boosters coins grid; Coins IAP list with Popular/Best Value badges and localized prices; Offers: Starter Pack timer card, VIP card), free coins tile, purchase confirm (coins), store sheet (IAP), success animation.
- **States:** loading products · products unavailable (offline: IAP tiles disabled "Store unavailable") · purchase pending · success · error.
- **Nav in:** Home, coin pill, mini shop "Get coins", Second Chance. **Out:** back to origin. **Ads:** rewarded free coins; no banner.

### 5.16 VIP Paywall
```
┌───────────────────────────┐
│  👑 VIP No-Ads Pass        │
│  ✓ No interstitial ads    │
│  ✓ No banner ads          │
│  ✓ Rewarded ads optional  │
│   ₹20 / month             │
│  Auto-renews monthly.     │
│  Cancel anytime in store. │
│  [ Subscribe ]            │
│  Restore · Terms · Privacy│
└───────────────────────────┘
```
- **Components:** benefits, localized price + period, renewal disclosure, Subscribe, Restore, links. Active state: "VIP active until 27 Nov" + Manage subscription.
- **States:** not subscribed · active · expired (ads back notice) · pending.
- **Ads:** none.

### 5.17 Leaderboards
```
┌───────────────────────────┐
│ ← Leaderboards            │
│ [Highest Lv][Stars][Streak]│
│  You: Lv 37 · 98★ · 12🔥  │
│  [ Open Play Games ▸ ]    │
│  (signed out: [Sign in])  │
└───────────────────────────┘
```
- **Components:** local stats summary, tabs ⇒ `games_services` native leaderboard UI, sign-in.
- **States:** signed in · signed out · offline (queued).
- **Ads:** none.

### 5.18 Phase Complete
```
┌───────────────────────────┐
│ 🏆 Garden Hero!            │
│ You freed every snake in  │
│ Phase 1 (500 levels)      │
│ ★ 1,312 / 1,500           │
│ [ Phase 2 coming soon ]   │  (or "Continue to L501" when maxPhase ≥ 2)
│ [ Replay for ★★★ ]  [Home]│
└───────────────────────────┘
```
- **Components:** badge, total stars, CTA based on Remote Config `maxPhase`, share image (local render, optional).
- **Nav:** Home / Map. **Ads:** none.

## 6. Navigation Map
```
Splash ─► AgeGate ─► Consent ─► Home
Home ─► Gameplay ─► {Pause, Tutorial, SecondChance ─► LevelFailed, LevelComplete ─► GiftBasket ─► Rush} ─► Gameplay(next)
Home ─► LevelMap ─► Gameplay
Home ─► Daily ─► Gameplay(daily) ─► DailyResult ─► Daily
Home ─► Spin | Shop | VIP | Leaderboards | Settings
L500 LevelComplete ─► TreasureChest ─► Rush ─► PhaseComplete ─► Home
```
Back button (Android): popups ⇒ close (Second Chance ⇒ same as "No thanks" confirm), Gameplay ⇒ Pause, hub screens ⇒ Home, Home ⇒ exit confirm.

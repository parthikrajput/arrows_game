# 06 — UI/UX Screens (સ્ક્રીન્સ અને ડિઝાઇન સિસ્ટમ)
Design tokens, accessibility, responsive rules અને Phase 1 ની **દરેક screen** — purpose, ASCII wireframe, components, states, navigation, ads placement.

**Related docs:** [Shared Core Standard §7, §13](../../SHARED_CORE_STANDARD.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [04 Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md) · [05 Daily & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Visual Principles (દ્રશ્ય સિદ્ધાંતો)
- **Soft 3D, rendered in 2D:** gradients + rim light + **pre-baked** shadows (sprite atlas). Per-frame blur નહીં.
- Garden calm: મોટા rounded cards, ઓછું text, મોટા icons.
- Board હંમેશા screen નો મુખ્ય હિસ્સો; UI chrome board ને ક્યારેય overlap નથી કરતું.
- Air layer (bees) ground થી 6 dp offset + મોટો soft shadow ⇒ depth તરત સમજાય.

## 2. Design Tokens

### 2.1 Colors (light theme; Phase 1 માં dark theme નથી)

| Token | Hex | Use |
|---|---|---|
| `bgMoss` | `#1B4332` | App background gradient top |
| `bgLawn` | `#2D6A4F` | Background gradient bottom, map paths |
| `boardTileA` | `#95D5B2` | Board checker A |
| `boardTileB` | `#84C9A3` | Board checker B |
| `boardRim` | `#523A28` | Board soil rim |
| `dewDot` | `#D8F3DC` | Grid corner dots |
| `honeyGold` | `#F4A261` | Primary CTA, coins |
| `nectarGold` | `#FFD166` | Rush, highlights, Hint glow |
| `skyCyan` | `#48CAE4` | Air layer cues, info |
| `petalPink` | `#F7A8B8` | Secondary accents |
| `heartRed` | `#E63946` | Hearts active |
| `heartLost` | `#B7C4B7` | Hearts lost |
| `textDark` | `#081C15` | Primary text on light cards |
| `textLight` | `#FFFFFF` | Text on dark bg |
| `card` | `#FFFDF7` | Cards / popups |
| `scrim` | `#081C15` @ alpha 0.6 | Modal scrim (`Color.withValues(alpha: 0.6)`) |
| `success` | `#2DC653` | Preview clear, success |
| `danger` | `#D62828` | Preview blocked, Hard badge |

**Line colors + color-blind glyph** (glyph head insect ના abdomen પર, હંમેશા ON):

| Color | Hex | Glyph |
|---|---|---|
| red | `#E5484D` | ● circle |
| orange | `#F28C28` | ▲ triangle |
| yellow | `#F2C14E` | ★ star |
| green | `#3FA34D` | ■ square |
| teal | `#2BB3A3` | ◆ diamond |
| blue | `#3A7BD5` | ✚ cross |
| purple | `#8E5BD9` | ⬟ pentagon |
| pink | `#E76FA8` | ♥ heart |

Gates/locks/cages/edges same glyph બતાવે, એટલે color વગર પણ matching શક્ય.

### 2.2 Typography
| Style | Font | Size / weight |
|---|---|---|
| Display | Baloo 2 (Latin, Devanagari) / Baloo Bhai 2 (Gujarati) | 32 / 800 |
| H1 | same | 24 / 700 |
| H2 | same | 20 / 700 |
| Body | Nunito / Noto Sans Gujarati / Noto Sans Devanagari | 16 / 500 |
| Caption | same | 13 / 500 |
| Button | Baloo family | 18 / 700 |
| Number badge | Baloo 2 | 12 / 800 |

Fonts bundled (offline), `flutter_localizations` + ARB: English, ગુજરાતી, हिन्दी.

### 2.3 Radii, spacing, shadows
- Radii: `r8` chips, `r12` buttons, `r20` cards/popups, `pill` CTAs.
- Spacing scale: 4, 8, 12, 16, 24, 32 dp. Screen gutter **16 dp**.
- Shadows (pre-baked 9-patch / atlas): `e1` (y 2, blur 4, alpha 0.20), `e2` (y 4, blur 10, alpha 0.25), `e3` popups (y 8, blur 20, alpha 0.30). Insect shadows: ant contact (y 1, tight), bee air shadow (offset 6,6, wide, alpha 0.18).

## 3. Accessibility (સુલભતા)
- **Color-blind:** line glyphs (§2.1) હંમેશા; Scent Trail Preview માં ✓/✕ icons + straight vs wavy dotted; hearts lost = outline shape પણ.
- **Tap targets:** UI controls min **48×48 dp**. Board cells ≥ 29 dp — hit test cell-accurate + 6 dp slop (nearest line cell પસંદ).
- **Text scale:** system scale 1.0–1.3 support (layouts wrap); > 1.3 ⇒ clamp 1.3 (board labels clamp 1.0).
- **Reduce motion** (Settings + OS flag): bee bob off, wing flutter amplitude ½, screen shakes off (bump = colour flash + haptic).
- **Haptics** toggle; **Reduce darkness** (Twilight Garden overlay alpha 0.5).
- Screen reader labels બધા buttons પર (`Semantics`); board: "Ant line, red, facing right, 3 insects".
- કોઈ information માત્ર sound થી નહીં.

## 4. Responsive Rules
- **Portrait only.** Safe areas (`SafeArea` / `MediaQuery.padding`) top notch/island + bottom gesture bar.
- **Phones 16:9 – 21:9:** layout vertical stack: top bar (56 dp) · info row (28 dp) · board (flex) · booster bar (72 dp) · 8 dp gap + divider · banner (adaptive height).
- **Tablets 4:3:** board max width **600 dp** centred; side areas background art; UI cards max width 480 dp.
- **Board fit:** `cell = floor(min((availW − 32) / cols, availH / rows))`; board centred. Phase 1 max 11×11 ⇒ 360 dp wide phone પર `(360 − 32) / 11 = 29.8` ⇒ **min cell 29 dp** guaranteed. Validator rejects levels below 29 dp on 360×640 reference.
- Short phones (height < 640 dp): info row hide (Moves top bar માં), booster bar 64 dp.
- No pinch-zoom in Phase 1.

## 5. Screen Map (navigation)

```
Splash → (first run) Age Gate → UMP Consent → Home
Home → Level Map → Gameplay → {Level Complete → Gift Box → Golden Nectar Rush} → Level Map / next level
Gameplay → Pause/Settings | Second Chance → Level Failed
Home → Daily Garden Almanac (+ Streak calendar) | Sunflower Spin | Shop | VIP | Leaderboards
L500 win → Phase Complete
```

## 6. Splash (Launch Intro)
**No loading screen.** Tap icon ⇒ system splash (`bgMoss` + animated bee-and-sunflower mark) ⇒ Home's first frame ⇒ "Garden Awakening" intro plays on top of a live, tappable Home. Full spec, timelines and Kotlin/Flutter code: [SPLASH_AND_INSTANT_LAUNCH §10](../../SPLASH_AND_INSTANT_LAUNCH.md#10-game-4--ants--bees-garden-awakening).
- Modes: full 1,200 ms (first cold start of the day) · short 450 ms · 150 ms fade (reduce motion). Tap skips; tap on Play starts the level.
- States: save corrupt ⇒ backup restored before the first frame, toast after the intro · offline = no difference (Remote Config cached values).
- Navigation: first run ⇒ intro ends on the Age Gate; else Home. Budget: cold start → Home first frame ≤ 600 ms mid-tier.
- Ads: none (consent પહેલાં ads load નહીં).

## 7. Age Gate & Consent
**Purpose:** neutral age gate (birth year) + UMP consent (EEA/UK).
```
┌────────────────────────┐
│  Welcome to the garden!│
│  What year were you    │
│  born?                 │
│   ┌──────────────┐     │
│   │   ▲  ----  ▼ │     │  year wheel (no default age)
│   └──────────────┘     │
│   [   Continue   ]     │
└────────────────────────┘
```
- Components: year wheel (blank initial), Continue (disabled until chosen). Then UMP form (Google-provided) જો required.
- States: under-13 ⇒ `ageBand = child`: child-directed ads, rating G, analytics personalization off, no leaderboard sign-in prompt. 13+ ⇒ normal + UMP.
- Navigation: ⇒ Home. Settings → Privacy options થી consent ફરી.
- Ads: none.

## 8. Home
**Purpose:** "Play" તરફ એક tap; daily/spin/shop entry.
```
┌────────────────────────────┐
│ 🍯 2,140   [+]   🗺  ⚙  🏆  │
│                            │
│   (garden scene, hive)     │
│                            │
│   [  ▶ PLAY  Level 137 ]   │  pill CTA
│                            │
│  [📅 Daily]  [🌻 Spin]      │
│  [🛒 Shop ]  [👑 VIP ]      │
│                            │
│ ───────── divider ──────── │
│ [     adaptive banner    ] │
└────────────────────────────┘
```
- Components: coin pill (tap ⇒ Shop Coins tab), settings, leaderboards, PLAY (next level), Daily card (modifier name + streak day, red dot if unclaimed), Spin (dot if free spin ready), Shop, VIP (hidden if active ⇒ "VIP ✓" badge), Starter Pack ribbon (48 h window).
- States: Daily locked (< L15), Spin locked (< L10 clear, [04 §9](./04_BOOSTERS_COINS_SHOP.md)), time-travel lock, offline (Leaderboards disabled).
- Navigation: PLAY ⇒ Gameplay (next level) · Map icon (top bar) ⇒ Level Map · Daily ⇒ §18 · Spin ⇒ §20 · Shop ⇒ §19 · VIP ⇒ §21 · 🏆 ⇒ §22.
- Ads: **banner bottom** (VIP ⇒ none).

## 9. Level Map
**Purpose:** progress path, replay levels, Gift/Rush markers.
```
┌────────────────────────────┐
│ ◀  Garden Trails   🍯 2,140│
│   (141)★★☆                 │
│        (140)🎁             │
│   (139)🔴★☆☆               │  Hard badge
│        (138)★★★            │
│   (137)▶ current           │
│        ...  🍯 Rush marker │
│ ───────── divider ──────── │
│ [     adaptive banner    ] │
└────────────────────────────┘
```
- Components: winding garden path, level nodes (stars, Hard red badge, x0 gift icon, x1 new-mechanic leaf icon), Rush honey-jar markers after 25s, Phase banner at L500.
- States: locked nodes grey; current node bounce; cleared with stars.
- Navigation: tap node ⇒ Level start card (mechanic preview for x1) ⇒ Gameplay.
- Performance: `ListView.builder` virtualised, node art cached.
- Ads: **banner bottom**.

## 10. Gameplay HUD
**Purpose:** puzzle screen.
```
┌──────────────────────────────┐
│ ⏸   ❤ ❤ ❤    Level 137   🍯2,140 │ top bar 56dp
│ Moves 4          🛡x2        │ info row
│ ┌──────────────────────────┐ │
│ │ 🐜🐜🐜→   🌻   ↑🐝        │ │
│ │       BOARD (≤ 11×11)    │ │
│ │  🪨   ←🐜🐜   🐝🐝🐝↓     │ │
│ └──────────────────────────┘ │
│ [💡3]  [🛡1]  [🍃2]           │ booster bar 72dp
│                              │ ≥ 8 dp gap
│ ─────────── divider ──────── │ 1 dp
│ [       adaptive banner    ] │ L11+
└──────────────────────────────┘
```
- Components: pause, hearts (3), level label (Hard ⇒ red chip), coins, Moves counter, Shield charge chip (when active), board (ground + air layers), booster bar (count badges, lock icons), goal chip (gems remaining) when M026.
- States: idle · animating (input queue 1) · preview (long-press) · Leaf Blower targeting (board dim, targets pulse, "Tap a line or obstacle" + cancel) · Hint glow · tutorial overlay · Twilight overlay.
- Navigation: Pause ⇒ Pause sheet; 0 hearts ⇒ Second Chance; win ⇒ Level Complete.
- Ads: **banner L11 થી** only; booster bar ↔ banner **≥ 8 dp gap + 1 dp divider** (accidental-click policy). Banner board/buttons overlap ક્યારેય નહીં. Interstitial ક્યારેય mid-level નહીં.

## 11. Pause / Settings
```
┌────────────────────────┐
│  Paused                │
│  [ ▶ Resume ]          │
│  [ ↻ Restart ]         │
│  [ 🏠 Home ]           │
│  ── Settings ──        │
│  Sound   [on]  Music [on]│
│  Haptics [on]          │
│  Reduce motion [off]   │
│  Reduce darkness [off] │
│  Language  [ગુજરાતી ▾]  │
│  Restore purchases     │
│  Privacy: options (UMP)│
│   Share diagnostics [on]│
│  Help: Report a problem│
│  Spin odds · Credits · v1│
└────────────────────────┘
```
- Pause: modal sheet; Restart ⇒ confirm ("Hearts reset, boosters used stay used").
- Settings (Home ⚙ થી પણ): **Sound / Music / Haptics** toggles (તરત લાગુ, Hive `settings` માં persist — [Sound doc §7](../../SOUND_EFFECTS_IMPLEMENTATION.md#7-settings--persistence)), Restore purchases (IAP restore), **Privacy** → UMP options + **"Share diagnostics"** toggle (off ⇒ Crashlytics/analytics/replay upload બંધ; local log device પર જ), **Help → "Report a problem"** (category picker; free text + screenshot માત્ર 13+; Report ID `BR-XXXXXX` બતાવે) — [Logging §10–§11](../../LOGGING_AND_ERROR_TRACKING.md#10-privacy-children--compliance), Spin odds (§20 table), Credits.
- Ads: none.

## 12. Tutorial Overlays
**Purpose:** FTUE steps (L1–10), booster tutorials (L3, L15, L25), x1 mechanic intros, L41 bee intro.
```
┌──────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░░░░░░ │ scrim with cut-out
│ ░░░░░ ┌──────┐ ░░░░░░░░ │
│ ░░░░░ │ 🐜🐜→ │ ░░░░░░░░ │ highlighted target
│ ░░░░░ └──────┘ 👆 ░░░░░ │ animated hand
│ ┌──────────────────────┐ │
│ │ Tap a line — the ants │ │ tooltip card
│ │ march out!            │ │
│ └──────────────────────┘ │
└──────────────────────────┘
```
- Components: scrim cut-out (only target tappable), hand animation, tooltip (≤ 2 lines), "Got it" (non-forced steps).
- x1 intro card: mechanic art + 1-line rule + **Ants / Bees icon row** (દા.ત. "Blocks ants ✓ · Blocks bees ✕").
- States: forced step (only target active) / soft tip (dismissable). Each step once (`ftue_step` analytics).
- Ads: none during tutorial.

## 13. Second Chance
```
┌────────────────────────┐
│   Out of hearts! 🐜💫   │
│      ( 10 )  ring      │ 10-s countdown
│ [🎬 Watch ad  +1 ❤ ]   │ disabled if used/unavailable
│ [🍯 120  +1 ❤ ] (1/2)  │ Honey Heart Refill
│      No thanks         │
└────────────────────────┘
```
- States: ad available · ad used this level ("Used") · ad unavailable ("Ad unavailable") · refills used 2/2 (button hidden) · insufficient coins ("Get coins" ⇒ coin sheet, countdown pause).
- Navigation: revive ⇒ back to board (no reset); timeout / No thanks ⇒ Level Failed.
- Ads: rewarded only (opt-in).

## 14. Level Failed
```
┌────────────────────────┐
│  The trail is blocked  │
│  (sad ant, bee pats)   │
│  [ ↻ Retry ]  (free)   │
│  [ 🏠 Home ]           │
│  Tip: Hold a line to   │
│  see its trail.        │
└────────────────────────┘
```
- Retry ⇒ 3 hearts, board reset. Tip rotates (preview, layer rule).
- Ads: **no interstitial after fail**.

## 15. Level Complete
```
┌────────────────────────┐
│     Garden cleared!    │
│      ★  ★  ☆           │
│   🍯 +20   ★★★ +20     │
│ [🎬 2X coins]          │
│ [  Next ▶  ]  [Map]    │
└────────────────────────┘
```
- Components: stars animation, clear coins (first clear only), first ★★★ bonus, 2X Win rewarded (doubles base clear coins only), Next, Map.
- States: replay (0 coins, "Best: ★★"), Hard/Finale banner.
- Navigation: ⇒ Gift Box (x0) ⇒ Rush (×25) ⇒ Next.
- Ads: interstitial check **after** this screen on Next/Map (every 5 wins, 120 s cooldown, L1–10 never, deferred if Gift/Rush/Chest on this win).

## 16. Queen's Gift Box
```
┌────────────────────────┐
│  🎁 Queen's Gift Box    │
│   (sunflower opens)    │
│   🍯 +150              │
│   💡 +1 Nectar Glow Hint│
│   [ Collect ]          │
└────────────────────────┘
```
- x0 levels first clear. L500 ⇒ Royal Honey Chest variant (1,000 + 2 each booster + badge).
- Ads: none (interstitial deferred).

## 17. Golden Nectar Rush
```
┌──────────────────────────┐
│ 🍯 Golden Nectar Rush     │
│ ⏱ ▓▓▓▓▓▓▓░░░ 21s   🍯 90 │
│ ┌──────────────────────┐ │
│ │ golden-hour board,    │ │
│ │ 20–30 lines           │ │
│ └──────────────────────┘ │
│       [ Skip ]           │
└──────────────────────────┘
```
- Start card ("Tap lines fast! 10 per line, +100 for all") ⇒ 3-2-1 ⇒ 30 s.
- End card: total coins, Collect. No boosters, no hearts (bump = wobble only). Skip ⇒ ત્યાં સુધીના coins રહે. App background ⇒ timer pause.
- Ads: **no banner, no interstitial after**.

## 18. Daily Garden Almanac + Streak Calendar
```
┌────────────────────────────┐
│ ◀ Daily Garden Almanac     │
│  Thursday · Fog Day 🌫      │
│  (mushroom silhouette)     │
│  [ ▶ Play ]   +100 🍯      │
│ ── 7-Day Streak ──         │
│ [1✓][2✓][3✓][4●][5 ][6 ][7🏆]│
│  50  75 100 125 150 200 450│
│  Trophy: Silver 🥈          │
│  Next Almanac in 06:12     │
└────────────────────────────┘
```
- States: locked (< L15) · ready · cleared (Practice) · time-travel lock · Queen's Favor offer (1-day miss; ad / 200 coins) · streak frozen (offline mismatch).
- Calendar shows boosters under days 3–7.
- Ads: rewarded only (Queen's Favor). No banner, no interstitial.

## 19. Shop
```
┌────────────────────────────┐
│ ◀ Shop            🍯 2,140 │
│ [Offers][Boosters][Coins]  │
│ ┌ Starter Pack  ₹79 ─────┐ │
│ │ 800🍯 3💡 2🍃 2🛡  47:12 │ │
│ └────────────────────────┘ │
│ 💡 Nectar Glow Hint 60 | ×3 150 │
│ 🛡 Royal Shield    80 | ×3 200 │
│ 🍃 Leaf Blower    100 | ×3 250 │
│ 🍯 350 ₹49 · 1,000 ₹149 (Popular)│
│ 🍯 2,200 ₹299 · 5,500 ₹699 (Best)│
│ 🎬 Free 50 coins (3/5 today)   │
└────────────────────────────┘
```
- States: purchase pending (spinner, buttons disabled) · success (coin burst) · failed/cancelled (toast) · insufficient coins (coin tab highlight) · offline (IAP disabled, coin-booster buys ok) · free coins 5/5 used.
- Mini shop sheet (gameplay, count 0): same booster row only.
- Ads: rewarded (free coins). **No banner** in Shop.

## 20. Sunflower Spin
```
┌────────────────────────┐
│   🌻 Sunflower Spin     │
│     (8-petal wheel)    │
│   [ SPIN (free) ]      │
│   [🎬 Extra spin]  ⓘ   │ odds
└────────────────────────┘
```
- Odds sheet (ⓘ): 20 coins 30% · 50 coins 25% · 100 coins 15% · 75 coins 12% · 1 Hint 10% · 1 Shield 5% · 1 Leaf Blower 2.5% · 500 coins 0.5%.
- States: locked (L10 clear પહેલાં, "Clear Level 10 to unlock") · free ready · free used / ad ready · both used ("Come back tomorrow") · time-travel lock.
- Ads: rewarded (extra spin, 1/day).

## 21. Beekeeper VIP Pass (paywall)
```
┌────────────────────────┐
│  👑 Beekeeper VIP Pass  │
│  No interstitial ads   │
│  No banner ads         │
│  ₹20 / month           │
│  Auto-renews monthly.  │
│  Cancel anytime in     │
│  Play Store / App Store│
│  [ Subscribe ]         │
│  Restore · Terms · Privacy │
└────────────────────────┘
```
- Copy સ્પષ્ટ: "while active" — ક્યારેય "forever/કાયમી" નહીં. Rewarded ads optional રહે છે એ લખવું.
- States: active (renewal date, Manage subscription link) · expired · pending.
- Ads: none.

## 22. Leaderboards
```
┌────────────────────────┐
│ ◀ Leaderboards         │
│ [Highest Level][Stars][Streak Days] │
│  (platform UI opens)   │
│  Sign in with Play Games│
└────────────────────────┘
```
- `games_services` native UI; this screen = selector + sign-in prompt. Offline ⇒ disabled. Child ageBand ⇒ sign-in prompt hidden (button only).
- Ads: none.

## 23. Phase Complete (L500)
```
┌────────────────────────┐
│  🏅 Garden Trails I     │
│  Queen's Garden Gala   │
│  cleared!              │
│  ⭐ 1,327 / 1,500       │
│  🍯 +1,000 + boosters  │
│  New gardens coming    │
│  soon!                 │
│  [ Replay for ★ ] [Home]│
└────────────────────────┘
```
- After Royal Honey Chest and L500 Rush. Phase 2 locked message until `maxPhase` Remote Config / update ([Phase 2](../phase_2/README.md)).
- Ads: none.

# 06 · UI/UX Screens — Toy Trains: Wooden Railway Puzzle
> હેતુ: design tokens, accessibility, responsive rules અને Phase 1 ની **દરેક screen** (purpose, ASCII wireframe, components, states, navigation, ads placement).

**Related docs:** [Shared Core Standard](../../SHARED_CORE_STANDARD.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [04 Boosters, Coins & Shop](./04_BOOSTERS_COINS_SHOP.md) · [05 Daily & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Design Tokens

### 1.1 Colours
| Token | Hex | Use |
|---|---|---|
| `tableOak` | `#F3E9DC` | Board / app background (honey oak) |
| `tableOakDark` | `#E5D4C0` | Grid peg dots, card borders |
| `trackTie` | `#C89D7C` | Track ties |
| `trackRail` | `#8D7B68` | Rails, secondary icons |
| `ink` | `#2B2B2A` | Primary text (contrast ≥ 7:1 on `tableOak`) |
| `inkMuted` | `#6B5E52` | Secondary text |
| `surface` | `#FFFFFF` | Cards, sheets |
| `brass` | `#C9A227` | Coins, primary CTA outline, level badge |
| `ctaGreen` | `#2E7D32` | Primary CTA (Play, Next) |
| `dangerRed` | `#C62828` | Hard badge, blocked preview |
| `previewGreen` | `#43A047` | Clear preview line |
| `heartActive` | `#E53935` | Hearts |
| `heartLost` | `#CFD8DC` | Lost heart |
| `shieldBlue` | `#1E88E5` | Shield overlay |
| `rushGold` | `#FFD54F` | Coin Rush trains/background accent |
| `scrim` | `#000000` @ 55% | Modal scrim (`Color(0xFF000000).withValues(alpha: 0.55)`) |

### 1.2 Train colours (each with pattern + icon — colour-blind safe)
| Train colour | Hex | Pattern on cars | Engine icon |
|---|---|---|---|
| Red | `#D84315` | Horizontal stripes | ● circle |
| Blue | `#1E88E5` | Dots | ▲ triangle |
| Yellow | `#FFB300` | Chevrons | ■ square |
| Green | `#2E7D32` | Checks | ◆ diamond |
| Purple | `#7B1FA2` | Waves | ★ star |
| Orange | `#EF6C00` | Diagonal hatch | ✚ cross |
| Teal | `#00897B` | Vertical stripes | ⬟ pentagon |
| Pink | `#D81B60` | Rings | ♥ heart-outline |

Colour gates, barriers, cages, colour exits use the **same icon** as the matching train. Rainbow Engine cycles red ●/green ◆/blue ▲.

### 1.3 Typography
| Style | Font | Size / weight |
|---|---|---|
| Display (level complete) | Baloo 2 | 32 sp / 800 |
| Title | Baloo 2 | 22 sp / 700 |
| Body | Nunito | 16 sp / 600 |
| Caption / badge | Nunito | 12 sp / 700 |
| Numbers (coins, moves) | Nunito tabular figures | 16–20 sp / 800 |
Fonts bundled (Latin + Gujarati + Devanagari: Baloo Bhai 2 / Baloo 2 Devanagari fallback).

### 1.4 Radii, spacing, shadows
| Token | Value |
|---|---|
| Radius S / M / L | 8 / 14 / 24 dp |
| Spacing scale | 4, 8, 12, 16, 24, 32 dp |
| Shadow card | offset (0, 3), colour `#5A3E2B` @ 25%, **pre-baked** 9-patch (no runtime blur on board) |
| Button press | scale 0.96, 80 ms `Curves.easeOut` |
| Modal enter | 220 ms `Curves.easeOutBack` |

## 2. Accessibility

- **Colour-blind:** every train colour also has a pattern + engine icon (§1.2); preview uses colour **and** ✕ / ✓ markers.
- **Min tap target:** 48×48 dp for all UI buttons; board cells ≥ 29 dp (Phase 1) with tap tolerance = whole cell.
- **Text scale:** supports system text scale up to 1.3× (layouts tested 1.0 / 1.3); board labels capped at 1.15×.
- Screen reader labels on all buttons (`Semantics`), e.g. "Green Signal Hint, 2 left".
- **Reduce motion** setting: shortens exit animation to 250 ms, no screen shake, no confetti.
- **Night Run** "Reduce darkness" toggle (03 M040).
- Haptics toggle; sound/music separate toggles.
- No information by sound only (bump also visual shake + heart crack).

## 3. Responsive Rules

| Rule | Value |
|---|---|
| Safe areas | `SafeArea` all screens; HUD below notch/island; banner above home indicator |
| Phones | 16:9 to 21:9 portrait; extra height ⇒ board vertically centred, HUD fixed |
| Tablets | 4:3 portrait: board max width 600 dp centred, side panels empty tabletop art |
| Board fit | `cell = floor(min((width − 32) / cols, (height − hudTop − boosterBar − banner − 24) / rows))` |
| Min cell | **29 dp** Phase 1 (11×11 on 360 dp width, 16 dp gutters). Below ⇒ CI layout test fails |
| Orientation | Portrait locked (Phase 1) |
| Zoom/pan | Not in Phase 1 (Phase 2 ≥ 12×12) |

## 4. Screen List & Navigation Map

```
Splash ─► Age gate & Consent (first launch) ─► Home
Home ─► Level Map ─► Gameplay ─► (Level Complete | Second Chance ─► Level Failed)
Home ─► Daily Timetable Run (+ Streak calendar) ─► Gameplay(daily)
Home ─► Lucky Turntable · Shop · Leaderboards · Settings
Gameplay ─► Pause/Settings · Tutorial overlays · Shop sheet
Level Complete ─► Gift Crate ─► Coin Rush ─► Next level / Phase Complete
Shop ─► VIP paywall
```

## 5. Screens

### 5.1 Splash / Loading
Purpose: brand + load assets, Remote Config, save file.
```
┌──────────────────────┐
│                      │
│     🚂 TOY TRAINS    │
│ Wooden Railway Puzzle│
│   [==== track ===>]  │ ← loading bar = train on track
│                      │
└──────────────────────┘
```
Components: logo, progress train. States: loading (≤ 3 s target), error (save corrupt ⇒ restore backup prompt). Navigation: first launch ⇒ Age gate; else Home. Ads: none (preload starts after consent).

### 5.2 Age Gate & Consent
Purpose: neutral age gate (birth year) + UMP consent (EEA/UK) before any ad load.
```
┌──────────────────────┐
│ Welcome, Conductor!  │
│ What year were you   │
│ born?                │
│   [  ▲ ——— ▼  ]      │ ← year wheel, no default
│   [ Continue ]       │
│ Privacy · Terms      │
└──────────────────────┘
```
States: year not chosen (Continue disabled), under-13 ⇒ `ageBand: child` (child-directed ads, no personalization), 13+ ⇒ UMP form if required. Navigation ⇒ Home. Ads: none.

### 5.3 Home
```
┌──────────────────────────────┐
│ ⚙️            🪙 1,240  [+]   │
│                              │
│   [ animated toy train loop  │ ← background diorama (decorative only)
│     around the station ]     │
│                              │
│     [  ▶ PLAY  Level 42  ]   │
│                              │
│ [📅 Daily 🔥4] [🎡 Spin] [🛒] │
│ [🏆 Leaderboards]            │
├──────────────────────────────┤
│ ▒▒▒▒▒ adaptive banner ▒▒▒▒▒  │
└──────────────────────────────┘
```
Components: Play (current level), coin pill (+ ⇒ Shop), Daily (locked until L15, streak flame), Spin (after L10 clear, red dot if free spin), Shop, Leaderboards, Settings. States: first session (only Play), Starter Pack ribbon (L15+, 48 h), VIP badge. Navigation as map §4. Ads: **banner** (VIP off).

### 5.4 Level Map
```
┌──────────────────────────────┐
│ ←  Map  T1 Countryside  🪙   │
│        (50)─🎁               │
│      (49)🔴                  │ ← Hard x9 red badge
│   (48)★★☆                    │
│  (47)★★★   🚂 ← you          │
│ (46) ...                     │
│ [Block 41–50: Ticket&Barrier]│
├──────────────────────────────┤
│ ▒▒▒▒▒ adaptive banner ▒▒▒▒▒  │
└──────────────────────────────┘
```
Track winding through 5 tier biomes (Countryside, Harbour, Mountains, City, Grand Central). Nodes: stars, Hard badge, Gift Crate icon on x0, new-mechanic signboard on x1, Coin Rush coin on 25s. States: locked / current / cleared. Tap cleared node ⇒ replay. Navigation: node ⇒ Gameplay. Ads: **banner**.

### 5.5 Gameplay HUD
```
┌──────────────────────────────┐
│ ⏸  ❤️❤️❤️(🛡2)  Lv 42  🪙1,240 │
│ Moves 7  · ✉ 1/2 (if goal)    │
│ ┌──────────────────────────┐ │
│ │                          │ │
│ │      BOARD (W×H)         │ │
│ │  trains · tracks ·       │ │
│ │  obstacles               │ │
│ └──────────────────────────┘ │
│ [🟢3] [↩️2] [🛡️1] [🏗️0+]     │ ← booster bar
│ ───────── divider (≥ 8 dp) ──│
│ ▒▒▒ banner (L11+) ▒▒▒        │
└──────────────────────────────┘
```
Components: pause, hearts (+shield badge), level badge (Hard red, Daily ticket, Par counter on Tue), coins, moves, goal counter, board canvas, booster bar (badge counts; locked boosters show padlock + unlock level). States: idle, animating (input queue 1), crane target mode (dim invalid), hint glow, Route Peek, night overlay. Navigation: pause ⇒ Pause; 0 hearts ⇒ Second Chance; win ⇒ Level Complete. Ads: **banner from L11 only**, ≥ 8 dp gap + divider below booster bar; never overlaps board.

### 5.6 Pause / Settings
```
┌──────────────────────┐
│       Paused         │
│ 🔊 Sound   [on ]     │
│ 🎵 Music   [on ]     │
│ 📳 Haptics [on ]     │
│ 🌐 Language [ગુજરાતી]│
│ Reduce motion [off]  │
│ [Resume] [Restart]   │
│ [Home]               │
│ Spin odds · Restore  │
│ Privacy · Consent    │
└──────────────────────┘
```
From Home ⚙️ the same sheet without Resume/Restart. Restart = new attempt (hearts 3; `adReviveUsed` unchanged). Ads: none.

### 5.7 Tutorial Overlays
```
┌──────────────────────┐
│  scrim with cut-out  │
│   ┌────┐             │
│   │🚂👆│ ← hand      │
│   └────┘             │
│ ┌──────────────────┐ │
│ │ NEW! Turntable   │ │
│ │ Tap the turntable│ │
│ │ to turn the      │ │
│ │ engine. 1 Move.  │ │
│ │       [Got it]   │ │
│ └──────────────────┘ │
└──────────────────────┘
```
Types: FTUE steps (02 §4), booster intros (L3, L8, L15, L25), mechanic intro card on every x1 (icon, 1-sentence rule, mini animation). Re-viewable from the "?" in Pause. Ads: none.

### 5.8 Second Chance ("Back on Track?")
```
┌──────────────────────┐
│   🚂💥 Back on Track? │
│      ( 10 ) ring      │
│ [🎬 Watch ad: +1 ❤️ ] │ ← hidden if used this level
│ [🪙120: +1 ❤️ (2 left)]│
│      No thanks        │
└──────────────────────┘
```
States: ad available / unavailable ("Ad unavailable", disabled) / used; refill disabled if coins < 120 (tap ⇒ coin sheet, countdown paused while sheet open) or 2 used. Countdown 10 s then ⇒ Level Failed. Board stays (no reset). Ads: rewarded only (opt-in).

### 5.9 Level Failed
```
┌──────────────────────┐
│  Derailed! Level 42  │
│  You cleared 9/14    │
│  [ ↻ Retry ]         │
│  [ Home ]            │
│  Tip: long-press to  │
│  peek at the track   │
└──────────────────────┘
```
Retry = full 3 hearts, board reset, free. Ads: **none** (no interstitial after fail).

### 5.10 Level Complete
```
┌──────────────────────┐
│   ★ ★ ☆   Level 42   │
│   +20 🪙  (+20 ★★★)   │
│ [🎬 2X coins]         │
│ [ Next ▶ ]  [Map]     │
└──────────────────────┘
```
Stars animate in; coins fly to pill. 2X = rewarded (base coins only). States: first clear / replay (0 coins, star improve only). Next ⇒ (Gift Crate ⇒ Coin Rush when applicable) ⇒ interstitial check (04 §8) ⇒ next level. Ads: rewarded 2X; interstitial **after** Next per cadence, deferred if a reward screen follows.

### 5.11 Conductor's Gift Crate
```
┌──────────────────────┐
│ 📦 Conductor's Gift! │
│  (crate bursts open) │
│   +150 🪙            │
│   +1 🟢 Green Signal │
│   [ Collect ]        │
└──────────────────────┘
```
At L10, 20 … 490 first clear. L500 uses Grand Central Chest variant (1,000 + 2 each booster + badge). Ads: none (interstitial deferred).

### 5.12 Golden Express Coin Rush
```
┌──────────────────────────────┐
│ GOLDEN EXPRESS   ⏱ 0:24  🪙80│
│ ┌──────────────────────────┐ │
│ │  gold trains, tap fast!  │ │
│ └──────────────────────────┘ │
│        [Skip]                │
└──────────────────────────────┘
```
Intro card ("30 seconds — 10 coins per train, +100 for clearing all") ⇒ 3-2-1 ⇒ play ⇒ results (coins, "All cleared +100"). No hearts, no boosters, no banner. Ads: **none** after.

### 5.13 Daily Timetable Run + Streak Calendar
```
┌──────────────────────────────┐
│ ← Daily Timetable · Thu      │
│ Modifier: Steam Day ☁️        │
│ Shape: Station Clock          │
│ Reward: +100 🪙 + streak day  │
│ [ ▶ Play ]   (✔ Claimed)      │
│ Express Streak 🔥 4           │
│ D1 ✔ D2 ✔ D3 ✔ D4 ✔ D5 ☐ D6 ☐ D7 🏆│
│ 150🪙+🛡 next                 │
│ Trophy: Silver Engine         │
└──────────────────────────────┘
```
States: locked (< L15), available, claimed today, Saver offer modal (ad / 200 coins), time-travel lock banner, offline (ad buttons disabled). Ads: none (rewarded Saver only).

### 5.14 Lucky Turntable
```
┌──────────────────────┐
│   🎡 Lucky Turntable │
│   (8-segment wheel)  │
│   [ SPIN (free) ]    │
│   [🎬 Extra spin]    │ ← 1/day
│   Odds ⓘ             │
└──────────────────────┘
```
States: free available / used; extra available / used / ad unavailable; time-travel lock. Odds sheet lists §7 of 04. Ads: rewarded extra only.

### 5.15 Shop
Wireframe and catalog: [04 §9](./04_BOOSTERS_COINS_SHOP.md). Tabs not needed (single scroll). States: purchase pending, success (coin burst), failed, offline (IAP disabled message), VIP active (VIP card shows "Active until DD MMM"). Rewarded +50 counter. Ads: rewarded only, no banner.

### 5.16 VIP Conductor Pass Paywall
```
┌──────────────────────┐
│ 👑 VIP Conductor Pass│
│ ✓ No interstitials   │
│ ✓ No banners         │
│ ✓ Rewarded ads stay  │
│   optional           │
│ ₹20 / month          │
│ Auto-renews monthly. │
│ Cancel anytime in    │
│ Play Store / App     │
│ Store settings.      │
│ [ Subscribe ]        │
│ Restore · Terms ·    │
│ Privacy              │
└──────────────────────┘
```
Not shown to under-13 band unprompted (only via Shop). Ads: none.

### 5.17 Leaderboards
```
┌──────────────────────┐
│ ← Leaderboards       │
│ [Highest Level]      │
│ [Total Stars]        │
│ [Total Streak Days]  │
│ Sign in with Play    │
│ Games / Game Center  │
└──────────────────────┘
```
Each opens the platform UI (`games_services`). States: signed out / signed in / offline. Ads: none.

### 5.18 Phase Complete
```
┌──────────────────────────────┐
│ 🎉 Phase 1 Complete!          │
│ Grand Central Conductor badge │
│ 500 levels · ★ 1,312          │
│ Phase 2 tracks arrive soon!   │
│ [Replay Hard levels] [Home]   │
└──────────────────────────────┘
```
After L500 → Grand Central Chest → Coin Rush. If Remote Config `maxPhase` ≥ 2 ⇒ "Continue to Level 501". Ads: none.

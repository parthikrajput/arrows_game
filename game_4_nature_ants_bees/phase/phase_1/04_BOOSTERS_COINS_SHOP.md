# 04 — Boosters, Coins & Shop (બૂસ્ટર, કોઈન્સ અને શોપ)
3 themed boosters + free preview, Honey Heart Refill, coin inflow/outflow, Gift Box, Golden Nectar Rush, Sunflower Spin, Shop catalog, ads rules અને compliance — બધા numbers Shared Core Standard ના launch defaults (Remote Config થી tune).

**Related docs:** [Shared Core Standard §3, §5–§7](../../SHARED_CORE_STANDARD.md) · [01 Rules](./01_GAME_CONCEPT_AND_RULES.md) · [02 Level Progression](./02_LEVEL_PROGRESSION_0001_0500.md) · [05 Daily & Streak](./05_DAILY_CHALLENGE_AND_STREAK.md) · [06 UI/UX Screens](./06_UI_UX_SCREENS.md) · [07 Frontend & QA](./07_FRONTEND_IMPLEMENTATION_AND_QA.md)

---

## 1. Booster Overview (બૂસ્ટર સારાંશ)

| Themed name (generic) | Icon | Effect | Unlock (tutorial grant) | Per-attempt cap | Single | 3-Pack |
|---|---|---|---|---|---|---|
| **Nectar Glow Hint (Hint)** | ફૂલ પર ચમકતું મધ ટીપું | Solver મુજબ આગલો સાચો Move (line કે lever/daisy/switch/rotor) glow કરે. Move ગણાતો નથી. | L3 (3 free) | 3 | 60 | **150** |
| **Queen's Royal Shield (Shield)** | રાણી મધમાખીનું મુગટવાળું કવચ | Activate કર્યા પછી current attempt ના આગલા **2** heart-loss events absorb. Attempt પૂરો ⇒ બાકી charge lapse. એક સમયે 1. | L15 (1 free) | 1 | 80 | **200** |
| **Leaf Blower (Hammer)** | પાંદડાં ઉડાડતું blower | કોઈપણ **1 line** remove (exit ગણાય) **અથવા** `hammerable: true` obstacle remove. | L25 (1 free) | 2 | 100 | **250** |
| Scent Trail Preview (Path Preview) | — | Long-press ≥ 350 ms ⇒ exit lane preview. **મફત, booster નથી.** | L4 tutorial | — | — | — |

Booster themed names આખા spec માં આ જ છે. Generic name કૌંસમાં પહેલી વાર.

## 2. Booster Rules in Detail (વિગતવાર નિયમો)

### 2.1 Nectar Glow Hint (Hint)
- Player state level ના `solution` prefix પર હોય ⇒ next step glow. નહીં તો on-device solver (isolate, **50 ms** budget, node limit **50k**).
- Solver fail ⇒ "Try Restart" toast, **Hint consume નથી થતો**.
- Glow: target line/interactive cell પર સોનેરી pulse, આગલા Move સુધી (અથવા 6 s visual fade, પછી પણ outline રહે).
- Fog નીચે છુપાયેલી line ને Hint ક્યારેય target નથી કરતો (fog clear કરતો move જ બતાવે).
- Cap 3/attempt. Stars ને અસર નહીં.

### 2.3 Queen's Royal Shield (Shield)
- Tap ⇒ 2 charges, HUD hearts ફરતે સોનેરી aura. Heart-loss event (bump, M017 counter 0, chained/group bump) ⇒ charge −1, heart સલામત.
- Absorbed event "heart lost" ગણાતો નથી ⇒ stars પર અસર નહીં.
- Attempt end (win/fail/restart) ⇒ બાકી charges lapse. Cap 1/attempt.

### 2.4 Leaf Blower (Hammer)
- Button tap ⇒ **targeting mode**: board dim, valid targets pulse (visible lines + hammerable obstacles). ફરી button tap ⇒ cancel (consume નહીં).
- Target **નથી**: fog નીચે છુપાયેલી line, અને bee line થી ઢંકાયેલી (cover-locked) ant line ([Standard §16.8](../../SHARED_CORE_STANDARD.md)). Gems/crumbs બાકી હોય ત્યારે **છેલ્લી line** પર Leaf Blower disabled ([Standard §16.31](../../SHARED_CORE_STANDARD.md)).
- Targeting order ([01 §6.5](./01_GAME_CONCEPT_AND_RULES.md)): **bee line > hammerable obstacle > ant line** (LR-7 મુજબ ઉપરનું layer પહેલાં). Interactive controls (lever, daisy, switch, rotor) Leaf Blower targets નથી.
- Line removal = **exit ગણાય**: non-lane on-exit hooks ચાલે (M003 adjacency, M004/M043/M046 keys, M010 fog clear, M033 cage count, M035 spawn, M049 spider HP). Lane travel નથી ⇒ lane effects **નથી** થતા: M016 damage, M026/M036 collect, M042 bridge crossing ([Standard §16.31](../../SHARED_CORE_STANDARD.md)).
- Hammerable obstacles (Standard §16.18): **M001, M002 (આખી wall), M016, M025, M027 (એક cell), broken M042**. બાકીના બધા not hammerable: gates, tiles, interactive cells, Lock family (M004, M043, M046), Edge Walls (M029–M031), Great Orb Spider (M049) — [03 §1.4](./03_OBSTACLE_CATALOG_PHASE_1.md).
- Leaf Blower use Move નથી (counters tick નથી). Leaf Blower use irreversible છે ([Standard §16.23](../../SHARED_CORE_STANDARD.md)). Cap 2/attempt.

### 2.5 Booster bar
- 3 buttons (Hint · Shield · Leaf Blower), inventory count badge. Count 0 ⇒ tap ⇒ **mini shop sheet** (single + 3-pack).
- Unlock પહેલાં button locked (lock icon, tap ⇒ "Unlocks at Level X" toast). Unlock પહેલાં મળેલું booster inventory માં રહે.
- Cap પહોંચ્યો ⇒ button grey + "Max for this try".

## 3. Honey Heart Refill (Heart Refill)
- **120 coins** ⇒ +1 Heart. **માત્ર Second Chance popup માં**, attempt દીઠ **max 2**. Booster inventory માં નથી, Shop માં વેચાતું નથી.
- Coins ઓછા ⇒ button "Get coins" ⇒ mini coin sheet (popup countdown pause થાય).
- Rewarded-ad revive (level દીઠ 1) અલગ; બંને ★ ને 1 સુધી ઘટાડે ([01 §8](./01_GAME_CONCEPT_AND_RULES.md)).

## 4. Starting Wallet
200 coins + tutorial grants: 3 Hint (L3), 1 Shield (L15), 1 Hammer (L25).

## 5. Coin Inflow (આવક)

| Source | Coins | Notes |
|---|---|---|
| Level first clear | Easy **15** / Normal **20** / Hard **30** / Finale **50** (JSON `tag`; `slot` intro/practice/ramp/milestone ⇒ `normal`) | Replay = 0 |
| First ★★★ on a level | **+20** | Level દીઠ 1 વાર |
| 2X Win (rewarded) | base clear coins ×2 | Star bonus double નહીં |
| Queen's Gift Box (x0) | 150 / 180 / 210 / 250 / 300 (§7) + 1 booster | First clear only |
| Royal Honey Chest (L500) | **1,000** + 2 each booster + phase badge | Gift Box ની જગ્યાએ |
| Golden Nectar Rush | **10/line**, full clear **+100** | દર 25 levels પછી (§8) |
| Daily Garden Almanac clear | **+100** | દિવસ દીઠ 1 વાર |
| 7-Day Streak | 1,150/week + boosters ([05](./05_DAILY_CHALLENGE_AND_STREAK.md)) | |
| Sunflower Spin | §9 | |
| Shop free coins (rewarded) | **+50** | **max 5/day** |
| IAP coin packs | §10 | |

**Balance sanity:** સરેરાશ ~60–70 coins/level (clear + star + gift/rush share) ⇒ 1 Hint ≈ 1 level, 1 Leaf Blower ≈ 1.5 levels.

## 6. Coin Outflow (ખર્ચ)

| Sink | Price |
|---|---|
| Nectar Glow Hint | 60 single / 150 ×3 |
| Queen's Royal Shield | 80 / 200 ×3 |
| Leaf Blower | 100 / 250 ×3 |
| Honey Heart Refill | 120 (Second Chance only) |
| Queen's Favor (Streak Saver) | 200 (અથવા 1 rewarded ad) |
| Phase 2: cosmetics (garden board themes, insect skins) | 800–4,000 ([Phase 2](../phase_2/README.md)) |

## 7. Queen's Gift Box Schedule (દર 10 levels)

| Levels (x0) | Coins | Booster |
|---|---|---|
| L10–L100 | **150** | `(L/10) mod 3`: 1 = Nectar Glow Hint, 2 = Leaf Blower, 0 = Queen's Royal Shield |
| L110–L200 | **180** | same formula |
| L210–L300 | **210** | same |
| L310–L400 | **250** | same |
| L410–L490 | **300** | same |
| L500 | **Royal Honey Chest**: 1,000 + 2 each booster + badge | — |

ઉદાહરણ: L10 → Hint, L20 → Leaf Blower, L30 → Shield, L40 → Hint, L50 → Leaf Blower. Full list: [02 §6](./02_LEVEL_PROGRESSION_0001_0500.md).

## 8. Golden Nectar Rush (Coin Rush)

| Rule | Value |
|---|---|
| Trigger | L25, 50, 75, 100, … 500 નો **first clear** પછી જ (replay પર નહીં; level number નથી) |
| Order | x0 level પર (L50, L100, …) **પહેલાં Gift Box/Chest, પછી Rush** |
| Duration | **30 s** — game નો **એકમાત્ર** wall-clock timer (puzzle નથી) |
| Board | Obstacle-free garden; lines per tier ([Standard §16.9](../../SHARED_CORE_STANDARD.md)): **T1 20 · T2 22 · T3 25 · T4 28 · T5 30** (formula નહીં); L41+ પછી bees પણ |
| Reward | **10 coins / line exit**, બધી lines clear ⇒ **+100** ⇒ max 300–400 |
| Bumps | Heart loss નહીં, ફક્ત wobble (કોઈ coin loss નહીં) |
| Boosters | Disabled |
| Ads | Rush પછી **interstitial ક્યારેય નહીં**; Rush ધરાવતી win પર interstitial defer |
| Skip | "Skip" button ⇒ Rush ત્યાં જ end; ત્યાં સુધી collect કરેલા coins રહે |
| Interrupt | App background ⇒ timer pause; foreground ⇒ ત્યાંથી resume |

## 9. Sunflower Spin (Lucky Spin)

**Unlock: L10 clear પછી** ([Standard §16.32](../../SHARED_CORE_STANDARD.md); FTUE disturb ન થાય). 1 free spin/day (dayKey, [05 §9](./05_DAILY_CHALLENGE_AND_STREAK.md)) + 1 extra via rewarded ad ⇒ **max 2/day**. 8 segments:

| Prize | Probability |
|---|---|
| 20 coins | 30% |
| 50 coins | 25% |
| 100 coins | 15% |
| 75 coins | 12% |
| 1 Nectar Glow Hint | 10% |
| 1 Queen's Royal Shield | 5% |
| 1 Leaf Blower | 2.5% |
| 500 coins (Jackpot) | 0.5% |

- Result = `PRNG(seed = hash(installId, dayKey, spinIndex))` (xoshiro128\*\*), server-free, deterministic.
- Odds **Settings → "Spin odds"** અને spin screen ના "i" button માં ફરજિયાત. Real-money gambling નથી; spin ખરીદી શકાતો નથી.
- Time-travel lock ([05 §9](./05_DAILY_CHALLENGE_AND_STREAK.md)) દરમિયાન spin disabled.

## 10. Shop (શોપ)

### 10.1 Layout (tabs) — wireframe: [06 §19](./06_UI_UX_SCREENS.md)
1. **Offers** — Starter Pack (eligible હોય ત્યારે), Beekeeper VIP Pass card.
2. **Boosters** — 3 boosters × (single, 3-pack).
3. **Coins** — 4 IAP packs + "Free 50 coins (ad)" row.

### 10.2 Catalog

| SKU | Type | Price | Content |
|---|---|---|---|
| `booster_hint_1` / `_3` | Coins | 60 / 150 | 1 / 3 Nectar Glow Hint |
| `booster_shield_1` / `_3` | Coins | 80 / 200 | 1 / 3 Queen's Royal Shield |
| `booster_hammer_1` / `_3` | Coins | 100 / 250 | 1 / 3 Leaf Blower |
| `coins_s` | IAP consumable | ₹49 | 350 coins |
| `coins_m` (Popular) | IAP consumable | ₹149 | 1,000 coins |
| `coins_l` | IAP consumable | ₹299 | 2,200 coins |
| `coins_xl` (Best Value) | IAP consumable | ₹699 | 5,500 coins |
| `starter_pack` | IAP one-time | ₹79 | 800 coins + 3 Hint + 2 Leaf Blower + 2 Shield. **L15 clear પછી 48 h** માટે offer |
| `vip_monthly` — **Beekeeper VIP Pass (No-Ads)** | Auto-renewing subscription, 1 month | **₹20/month** | Active હોય ત્યાં સુધી interstitial + banner બંધ; rewarded ads optional રહે. Expire ⇒ ads પાછી ("કાયમી" નથી) |
| Free coins | Rewarded ad | — | +50, max 5/day |
| Piggy Bank | Phase 2 | ₹49 | [Phase 2](../phase_2/README.md) |

- Restore purchases: **Settings** માં. Receipt validation: Firebase Cloud Function `verifyPurchase`.
- Prices store-localized (`ProductDetails.price`); ઉપરના ₹ India launch defaults.
- Business note: ₹20 subscription નો net (GST + store fee પછી) ≈ ₹14 — Remote Config થી price test.

## 11. Ads Rules (AdMob, `google_mobile_ads`)

| Format | Rule |
|---|---|
| **Interstitial** | દર **5 numbered-level wins** પર 1. L1–10 માં **ક્યારેય નહીં** (પહેલું eligible: L15 win; counter L11 થી ગણાય). Last full-screen ad પછી **min 120 s**. Gift Box / Rush / Chest વાળી win ⇒ **defer** આગલી eligible win પર. Fail, Daily, Rush પછી ક્યારેય નહીં. `winsSinceInterstitial` persist. Daily cap 20. VIP active ⇒ none. |
| **Rewarded** (opt-in) | 2X Win · Revive (level દીઠ 1) · Shop +50 (5/day) · Sunflower Spin extra (1/day) · Queen's Favor |
| **Banner** | Adaptive anchored; **Home, Level Map**, અને gameplay bottom **L11 થી**. Booster bar થી **≥ 8 dp gap + 1 dp divider**. Board/buttons overlap ક્યારેય નહીં. Popups/Shop/Rush/Daily screens પર નહીં. VIP ⇒ none. |
| **Preload** | App start પર rewarded + interstitial preload (consent પછી); show પછી reload; fail ⇒ exponential backoff, max 3 retries/session |

## 12. Compliance (Target age 10–50 ⇒ mixed audience)
- First launch **neutral age gate** (birth year picker, default value નહીં). Under-13 ⇒ `tagForChildDirectedTreatment`, non-personalized ads, max ad content rating **G**, analytics personalization off.
- Google Play **Families policy**: Families Self-Certified Ads SDK only (AdMob OK); બાળકો પાસેથી personal data નહીં.
- **UMP consent** (EEA/UK) app start પર, **ads load પહેલાં**. Settings → "Privacy options" થી ફરી ખોલી શકાય.
- Sunflower Spin odds disclosure; no real-money gambling; IAP buttons પર સ્પષ્ટ price.

## 13. Remote Config Keys (launch defaults)
`hint_price=60`, `hint_pack3=150`, `shield_price=80`, `shield_pack3=200`, `hammer_price=100`, `hammer_pack3=250`, `heart_refill=120`, `heart_refill_max=2`, `interstitial_every=5`, `interstitial_cooldown_s=120`, `interstitial_daily_cap=20`, `shop_free_coins=50`, `shop_free_daily=5`, `rush_seconds=30`, `rush_per_line=10`, `rush_clear_bonus=100`, `streak_saver_coins=200`, `vip_price_tier`. બધા values Standard મુજબ; બદલવા હોય તો પહેલાં Standard બદલો.

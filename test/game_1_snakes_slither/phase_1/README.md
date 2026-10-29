# Phase 1 — Launch Scope (Levels 1–500)
> Snakes Slither ના launch build માં શું છે, શું નથી, અને Phase 1 ના દરેક document નો index.

**Related docs:** [Game overview](../README.md) · [Shared Core Standard](../../SHARED_CORE_STANDARD.md) · [Phase 2 index](../phase_2/README.md) · [Scaling to 10,000](../SCALING_TO_10000_LEVELS.md)

---

## 1. Goal (લક્ષ્ય)
Phase 1 = store launch. 500 hand-tuned + generator-built levels, 49 jungle mechanics (M001–M049), 4 boosters + free preview, coins economy, Shop, ads + VIP, Daily Challenge + 7-day Streak, leaderboards. Backend માત્ર receipt validation (Firebase Cloud Function `verifyPurchase`) — બાકી બધું offline-first, device પર.

## 2. Content Summary
| Item | Phase 1 value |
|---|---|
| Levels | 1–500 (`assets/levels/phase_1.json.gz`) |
| Mechanics | M001 (L11) … M049 (L491), દરેક block ના x1 slot પર; L500 = Phase 1 Finale ("Mongoose King's Garden") |
| Tiers | FTUE (1–10), T1 (11–100), T2 (101–200), T3 (201–300), T4 (301–400), T5 (401–500) |
| Max grid | 11×11 (pinch-zoom નથી; auto-fit, min cell 29 dp) |
| Hand-tuned levels | L1–30, દરેક x1 intro, દરેક x9 Hard, L500 Finale |
| Bonus rounds | Golden Slither Rush × 20 (after L25, 50 … 500) |
| Gift Baskets | 49 (L10 … L490) + Jungle Treasure Chest at L500 |
| Languages | English, ગુજરાતી, हिन्दी (ARB) |

## 3. In Scope (Phase 1 માં છે)
- Core rules engine (standard §2) + 49 mechanics + L500 Finale.
- Hearts, Second Chance (rewarded revive 1/level, Heart Berry Refill 120 coins × max 2/attempt), stars.
- 4 boosters: Glow Firefly Hint, Coil-Back Undo, Safety Shell Shield, Magic Stone Hammer; free Tongue-Flick Preview.
- Booster tutorials: L3, L8, L15, L25.
- Coins: clear rewards, first ★★★ bonus, 2X Win (rewarded), Jungle Gift Basket, Jungle Treasure Chest, Golden Slither Rush, Lucky Lily Wheel, Shop free coins (rewarded, 5/day).
- Shop: booster singles + 3-packs, coin packs (IAP), Starter Pack, VIP No-Ads Pass, Restore purchases.
- Daily Challenge (unlock L15) + weekday modifiers + silhouettes + 7-day Streak + Streak Saver + time-travel lock.
- Leaderboards via `games_services`: Highest Level, Total Stars, Total Streak Days.
- Ads: interstitial (rules §7.1), rewarded, adaptive banner (Home, Level Map, gameplay from L11).
- Compliance: neutral age gate, UMP consent, Families policy, spin odds disclosure.
- Analytics, Crashlytics, Remote Config (economy numbers); logging & error tracking per [LOGGING_AND_ERROR_TRACKING.md](../../LOGGING_AND_ERROR_TRACKING.md) (`AppLogger`, error codes, "Report a problem").
- Sound effects & music per [SOUND_EFFECTS_IMPLEMENTATION.md](../../SOUND_EFFECTS_IMPLEMENTATION.md) (themed `theme.json`, Sound / Music / Haptics toggles).
- Accessibility: colour-blind patterns, text scale, reduced motion, haptics toggle.

## 4. Out of Scope (Phase 2 અથવા પછી)
| Feature | ક્યારે | Doc |
|---|---|---|
| Levels 501–1000, M051–M099, pinch-zoom boards ≥ 12×12 | Phase 2 | [phase_2/README.md](../phase_2/README.md) |
| Sticker Album (Daily silhouettes collect) | Phase 2 | [phase_2/README.md](../phase_2/README.md) |
| Weekly Star Race | Phase 2 | [phase_2/README.md](../phase_2/README.md) |
| Piggy Bank (₹49) | Phase 2 | [phase_2/README.md](../phase_2/README.md) |
| Cloud Sync (Firebase Auth + Firestore) | Phase 2 | [phase_2/README.md](../phase_2/README.md) |
| Cosmetic snake skins / board themes (800–4,000 coins) | Phase 2 | [phase_2/README.md](../phase_2/README.md) |
| Levels 1001–10,000 (on-device generation) | Phase 3+ | [SCALING_TO_10000_LEVELS.md](../SCALING_TO_10000_LEVELS.md) |
| Lives/energy system | ક્યારેય નહીં (Retry હંમેશા મફત) | — |
| Real-money gambling, loot boxes for money | ક્યારેય નહીં | — |

Phase 1 માં cloud save નથી ⇒ app uninstall = local progress જાય (purchases Restore થી પાછી). Settings માં આ સ્પષ્ટ લખવું.

## 5. Document Index
| # | Document | શું છે |
|---|---|---|
| 01 | [01_GAME_CONCEPT_AND_RULES.md](./01_GAME_CONCEPT_AND_RULES.md) | Concept, characters, art direction, core loop, બધા gameplay rules, hearts/revive, stars, edge cases, theme glossary |
| 02 | [02_LEVEL_PROGRESSION_0001_0500.md](./02_LEVEL_PROGRESSION_0001_0500.md) | Tiers, 10-level block pattern, FTUE L1–10, booster tutorials, 50-block table, L500 Finale |
| 03 | [03_OBSTACLE_CATALOG_PHASE_1.md](./03_OBSTACLE_CATALOG_PHASE_1.md) | M001–M049 summary + એક card per mechanic (rules, JSON, implementation, design usage) |
| 04 | [04_BOOSTERS_COINS_SHOP.md](./04_BOOSTERS_COINS_SHOP.md) | Boosters, Heart Refill, coins inflow/outflow, Gift Basket, Coin Rush, Lucky Wheel, Shop, ads, compliance |
| 05 | [05_DAILY_CHALLENGE_AND_STREAK.md](./05_DAILY_CHALLENGE_AND_STREAK.md) | Daily rules, modifiers, seed, silhouettes, streak ladder, saver, anti-cheat, leaderboards |
| 06 | [06_UI_UX_SCREENS.md](./06_UI_UX_SCREENS.md) | Design tokens, accessibility, responsive rules, દરેક screen નું wireframe |
| 07 | [07_FRONTEND_IMPLEMENTATION_AND_QA.md](./07_FRONTEND_IMPLEMENTATION_AND_QA.md) | Flutter architecture, BLoCs, renderer code, audio summary, persistence, analytics, performance, error handling, QA checklist |

## 6. Launch Exit Criteria
| # | Criterion |
|---|---|
| E1 | CI level validator: L1–500 બધા pass (0 hearts / 0 boosters solvable, D in band, min cell ≥ 29 dp) |
| E2 | QA checklist ([07 §14](./07_FRONTEND_IMPLEMENTATION_AND_QA.md#14-qa-checklist)) ના બધા P0 items run અને pass |
| E3 | Performance budget device matrix પર માપેલ (60 fps low-tier, raster p95 < 8 ms mid-tier) |
| E4 | Store listing name trademark/store search પૂરું ([../README.md §1](../README.md#1-title--naming)) |
| E5 | Families policy self-certification, Data safety form, App Privacy labels ભરેલા |
| E6 | `verifyPurchase` Cloud Function production માં, sandbox purchases + restore ચકાસેલ |

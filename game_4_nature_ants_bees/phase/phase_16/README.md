# Phase 16 — Levels 7501–8000 (Royal Keyring)
> Ants & Bees: Garden Trails ના Phase 16 update નું scope, signature system (Keys Deluxe: Royal Keyring), 4 નવા base mechanics (M751–M754), 45 variants, on-device deterministic generation, release prerequisites અને Phase 16 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 15 index](../phase_15/README.md) · [Phase 17 index](../phase_17/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 16 = **Royal Keyring (Keys Deluxe) update** (બહુ-તબક્કાવાર કી ચેઇન્સ, કી ક્રાફ્ટિંગ ફ્લાવર્સ, સ્કેલેટન ડ્યૂ કી રો/કૉલમ ક્લિયરન્સ અને કી સ્વેપ પેડ્સ). Phase 15 ના 7500 levels ક્લિયર કરનાર players માટે **L7501–8000** content:
1. **Signature System:** Keys Deluxe (Royal Keyring — જટિલ કી-લૉક નેટવર્ક્સ, ચાવીઓનું મિશ્રણ અને સ્વેપિંગ).
2. **4 New Base Mechanics:** M751 Dew Key Chain, M752 Key-Crafting Flower, M753 Skeleton Dew Key, M754 Key Swap Pad.
3. **45 Variants:** Base mechanics × Modifiers (`Frozen`, `Colored`, `Fogged`, `Chained`, `Countdown`, `Phasing`, `Armored`, `Layered`, `Mirrored`, `Growing`).
4. **Difficulty Band:** Fixed plateau **D 60–76** (Standard §17.24).

## 2. Content Summary
| Item | Phase 16 Value | Source |
|---|---|---|
| Levels | 7501–8000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Keys Deluxe: Royal Keyring (Multi-tier keys, crafting, key exchange) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M751 (L7511), M752 (L7631), M753 (L7751), M754 (L7871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L7991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L8000 "Queen's Royal Lock Gala" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P16-A (7501–7750) · P16-B (7751–8000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (zoom/pan enabled) | Standard §9.3, §17.23; SCALING §3.5 |
| Lines Count | 28–40 lines across all layers | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Queen's Gift Box | 49 (L7510 … L7990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Royal Honey Chest | L8000: 1,000 coins + 2 of each booster + "Master Keywright" badge | Standard §6.1, SCALING §6 |
| Golden Nectar Rush | 20 rounds (after L7525, 7550 … 8000), 30 lines each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 15
| Area | Phase 15 | Phase 16 |
|---|---|---|
| Core Focus | Stream currents & conveyor drift | **Complex Dependency Networks & Key Logic (Keys Deluxe)** |
| Key Interactions| Simple 1:1 key-to-lock exits | Multi-stage chained keys, 2-part key crafting, row/column skeleton sweeps |
| Key Mobility | Stationary keys on specific lines | **Key Swap Pads: Transfer key privileges between different lines** |
| Seed Metadata | `phase_15_meta.bin` | Shipped `phase_16_meta.bin` (k, par, D, CRC, solution) |

## 4. Release Prerequisites
1. **CI Key-Lock Solver Verification:** L7501–8000 ના તમામ 500 levels advanced key solver માં 0 hearts lost અને 0 boosters થી પાસ થયેલ હોવા જોઈએ.
2. **Metadata Asset:** `phase_16_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ થયેલ હોવા જોઈએ.
3. **Key Transfer Determinism:** Key swap અને crafting triggers તમામ પ્લેટફોર્મ્સ પર એકસમાન રીતે હેન્ડલ થવા જોઈએ.
4. **Remote Config Flag:** `maxPhase = 16` સેટ થતાં Phase 16 અનલૉક થાય.
5. **Tutorial Assets:** M751–M754 ના cards localized (en, gu, hi).

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_16_SCOPE_AND_RULES.md](./01_PHASE_16_SCOPE_AND_RULES.md) | Keys deluxe rules, chain unlocking, key synthesis, swap mechanics, limits |
| 02 | [02_LEVEL_PLAN_7501_8000.md](./02_LEVEL_PLAN_7501_8000.md) | 50-block slot map (L7501–8000), base intros, 45 variants, L7991 review, L8000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md) | Royal Keyring rules, M751–M754 cards, key state transitions, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_16.md](./04_VARIANTS_AND_MODIFIERS_PHASE_16.md) | 45 variant slot definitions (Keys Deluxe mechanics × 10 Modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_16.md](./05_REWARDS_AND_ECONOMY_PHASE_16.md) | Economy inflow/outflow, Gift Boxes, L8000 Phase Chest, Coin Rush rounds |
| 06 | [06_UI_AND_QA_PHASE_16.md](./06_UI_AND_QA_PHASE_16.md) | Keyring HUD indicators, crafting synthesis animations, gold VFX, QA checklist |

---

## 6. Open Decisions
- **OD-P16-01:** Skeleton key row/column wave unlock speed: 120 ms vs 160 ms.


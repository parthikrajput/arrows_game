# Phase 13 — Levels 6001–6500 (Mystery Basket)
> Purpose: Yarn Unravel ના Phase 13 update નું scope, signature system (Hidden Info: Mystery Basket — scout threads, decoy fluff, painted walls, lantern plates), 4 નવા base mechanics (M601–M604), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 13 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 12 index](../phase_12/README.md) · [Phase 14 index](../phase_14/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 13 players માટે **L6001–6500** content લાવે છે:
1. **Signature System: Hidden Info (Mystery Basket):** ક્રાફ્ટ બોર્ડ પર વૂલ ફ્લફ (Wool Fluff) અને ધુમ્મસ નીચે છુપાયેલી માહિતી, સ્કાઉટ દોરાઓ વડે ફોગ ક્લિયરન્સ અને લેન્ટર્ન પ્લેટ્સ વડે છુપાયેલા ટાંકાઓનું દર્શન.
2. **4 New Base Mechanics:** M601 Scout Thread (Scout Path), M602 Decoy Fluff (Mimic Fog), M603 Painted Wall (False Wall), M604 Lantern Plate (Reveal Plate).
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 91–107** (standard §17.24).
5. **Phase Finale:** L6500 "The Unveiled Motif" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 13 Value | Source |
|---|---|---|
| Levels | 6001–6500 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Hidden Info (Mystery Basket, fog of war & reveal plates) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M601 (L6011), M602 (L6131), M603 (L6251), M604 (L6371) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L6491 (Block 50 x1 — "Mystery Basket Mastery") | Standard §17.34, §17.38 |
| Finale | L6500 "The Unveiled Motif" (Finale target D ≈ 128) | SCALING §3.5, §7 |
| Tiers | P13-A (6001–6250) · P13-B (6251–6500) | SCALING §3.5, §6 |
| Grid Bounds | 12×12–14×14 | SCALING §3.5 |
| Total Threads | 28–40 threads | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L6010 … L6490) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L6500: 1,000 coins + 2 of each booster + Phase 13 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L6025, 6050 … 6500), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 12
| Area | Phase 12 | Phase 13 |
|---|---|---|
| Signature System | Gravity (Hanging Loom) | **Hidden Info (Mystery Basket)** — wool fluff fog of war & scouting |
| Board Dynamics | Directional gravity drops | **Information concealment**, decoy fluff illusion, lantern reveals |
| Base Mechanics | M551–M554 (Plumb Lever, Droppers) | **M601–M604 (Scout Thread, Decoy Fluff, Painted Wall, Lantern Plate)** |
| Difficulty Model | D Band 88–104 | **D Band 91–107** (target $D_{\text{finale}} \approx 128$) |

## 4. Release Prerequisites
1. **CI Validation:** L6001–6500 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_13_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 13` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Scout Thread clearing, Decoy Fluff illusions, Painted Wall passing અને Lantern Plate reveals localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_13_SCOPE_AND_RULES.md](./01_PHASE_13_SCOPE_AND_RULES.md) | Hidden Info rules, fog of war mechanics, lantern reveal physics, limits |
| 02 | [02_LEVEL_PLAN_6001_6500.md](./02_LEVEL_PLAN_6001_6500.md) | 50-block slot map (L6001–6500), base intros, 45 variants, L6500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md) | Mystery Basket rules, M601–M604 catalog cards, reveal tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_13.md](./04_VARIANTS_AND_MODIFIERS_PHASE_13.md) | 45 variant slot definitions, hidden-info modifier combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_13.md](./05_REWARDS_AND_ECONOMY_PHASE_13.md) | Economy inflow/outflow, Craft Baskets, L6500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_13.md](./06_UI_AND_QA_PHASE_13.md) | Fluff fog shaders, lantern glow VFX, tier limits, QA checklist |


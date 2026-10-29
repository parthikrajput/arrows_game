# Phase 11 — Levels 5001–5500 (Twin Hoops)
> Purpose: Yarn Unravel ના Phase 11 update નું scope, signature system (Linked Boards: Twin Hoops — seam edges, cross charms, mirror hoops, relay pompoms), 4 નવા base mechanics (M501–M504), 45 variants, ઑન-ડિવાઇસ જનરેશન અને Phase 11 docs નો index.

**Related docs:** [Game overview](../../README.md) · [Phases overview](../README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §6, §7](../../SCALING_TO_10000_LEVELS.md) · [Phase 10 index](../phase_10/README.md) · [Phase 12 index](../phase_12/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 11 players માટે **L5001–5500** content લાવે છે:
1. **Signature System: Linked Boards (Twin Hoops):** ક્રાફ્ટ બોર્ડ પર એકસાથે બે જોડાયેલા મિની એમ્બ્રોઇડરી હૂપ્સ (Hoop A અને Hoop B) જે સીવણની સીમ (Seam Edge) અને રિલે પોમપોમ્સ દ્વારા જોડાયેલા છે.
2. **4 New Base Mechanics:** M501 Seam Edge (Board Link Edge), M502 Cross Charm (Cross-board Key), M503 Mirror Hoop (Mirror Board), M504 Relay Pompom (Relay Portal).
3. **45 Variants:** Base mechanics × 10 craft modifiers (`Knotted`, `Dyed`, `Fluffed`, `Ribbon-Tied`, વગેરે).
4. **Difficulty Band:** Fixed plateau **D 85–101** (standard §17.24).
5. **Phase Finale:** L5500 "The Twin Hoops Symphony" + Grand Sewing Chest.

## 2. Content Summary
| Item | Phase 11 Value | Source |
|---|---|---|
| Levels | 5001–5500 (On-device generated via seed) | Standard §11; SCALING §6, §7 |
| Signature System | Linked Boards (Twin Hoops, dual interconnected hoops) | Standard §11, SCALING §7 |
| Base Mechanics | 4: M501 (L5011), M502 (L5131), M503 (L5251), M504 (L5371) | Standard §11, §17.38; SCALING §7 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §8 |
| Review Level | L5491 (Block 50 x1 — "Twin Hoops Mastery") | Standard §17.34, §17.38 |
| Finale | L5500 "The Twin Hoops Symphony" (Finale target D ≈ 121) | SCALING §3.5, §7 |
| Tiers | P11-A (5001–5250) · P11-B (5251–5500) | SCALING §3.5, §6 |
| Grid Bounds | Dual boards: 8×8 to 10×10 each (combined cells equivalent to 12×12–14×14) | SCALING §3.5 |
| Total Threads | 28–40 threads | SCALING §3.5 |
| Obstacle Instances | 8–14 instances | SCALING §3.5 |
| Craft Basket (Gift Box) | 49 (L5010 … L5490) × **300 coins** + 1 booster | Standard §6.1, SCALING §7 |
| Grand Sewing Chest | L5500: 1,000 coins + 2 of each booster + Phase 11 badge | Standard §6.1, SCALING §7 |
| Golden Bobbin Rush | 20 rounds (after L5025, 5050 … 5500), 30 threads each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 10
| Area | Phase 10 | Phase 11 |
|---|---|---|
| Signature System | Sequencing (Pattern Book) | **Linked Boards (Twin Hoops)** — dual interconnected mini boards |
| Board Dynamics | Strict sequential exit timing | **Cross-board transitions**, seam edge warps, dual-board keys |
| Base Mechanics | M451–M454 (Metronome Gate, Pattern Clasp, Ordered Hem, Echo Card) | **M501–M504 (Seam Edge, Cross Charm, Mirror Hoop, Relay Pompom)** |
| Difficulty Model | D Band 82–98 | **D Band 85–101** (target $D_{\text{finale}} \approx 121$) |

## 4. Release Prerequisites
1. **CI Validation:** L5001–5500 ના 500 levels CI validator દ્વારા pre-validated હોવા જોઈએ.
2. **Metadata Asset:** `phase_11_meta.bin` અને `seed_overrides.json` asset bundle માં સામેલ હોવા જોઈએ.
3. **Remote Config Flag:** `maxPhase = 11` set થયેલ હોવું જોઈએ.
4. **Tutorial Cards:** Seam Edge transitions, Cross Charm keys, Mirror Hoop twins અને Relay Pompoms localized tutorials.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_11_SCOPE_AND_RULES.md](./01_PHASE_11_SCOPE_AND_RULES.md) | Linked Boards rules, seam edge physics, cross-hoop transitions, limits |
| 02 | [02_LEVEL_PLAN_5001_5500.md](./02_LEVEL_PLAN_5001_5500.md) | 50-block slot map (L5001–5500), base intros, 45 variants, L5500 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md) | Twin Hoops rules, M501–M504 catalog cards, link tick order |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_11.md](./04_VARIANTS_AND_MODIFIERS_PHASE_11.md) | 45 variant slot definitions, linked-hoop modifier combinations |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_11.md](./05_REWARDS_AND_ECONOMY_PHASE_11.md) | Economy inflow/outflow, Craft Baskets, L5500 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_11.md](./06_UI_AND_QA_PHASE_11.md) | Twin Hoop camera framing, seam edge VFX, tier limits, QA checklist |


# Phase 11 — Levels 5001–5500 (Two Ponds)
> Snakes Slither ના Phase 11 update નું scope, signature system (Linked Boards: Two Ponds), 4 નવા base mechanics (M501–M504), 45 variants, release prerequisites અને Phase 11 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 10 index](../phase_10/README.md) · [Phase 12 index](../phase_12/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 11 = **Dual-Grid Spatial Puzzle Update (Two Ponds)**. Phase 10 પૂર્ણ કરનાર players માટે **L5001–5500** content:
1. **Signature System:** Two Ponds (એકસાથે બે સ્વતંત્ર મીની-ગ્રીડ્સ બોર્ડ 1 અને બોર્ડ 2, જે વિશિષ્ટ બ્રિજ, ક્રોસ-બોર્ડ કી અને પોર્ટલ વડે જોડાયેલા છે).
2. **4 New Base Mechanics:**
   - M501: Vine Bridge Edge / Board Link Edge (બોર્ડ 1 ની લિંક્ડ કિનારી પરથી બહાર નીકળતો સાપ તરત જ બોર્ડ 2 ની વિરુદ્ધ કિનારી પરથી અંદર પ્રવેશે છે).
   - M502: Messenger Key / Cross-board Key (બોર્ડ 1 પરનો કી-સ્નેક બહાર નીકળતાં જ બોર્ડ 2 પરનું લોક ખુલે છે).
   - M503: Pond Reflection / Mirror Board (બોર્ડ 1 પરના સાપને ટેપ કરતાં બોર્ડ 2 પરનો તેનો મિરર-ટ્વિન પણ એકસાથે સરકે છે; બંનેનો રસ્તો સાફ હોવો અનિવાર્ય).
   - M504: Relay Burrow / Relay Portal (એક પોર્ટલનું મોં બોર્ડ 1 પર અને બીજું મોં બોર્ડ 2 પર સ્થિત).
3. **45 Variants:** Base mechanics × 10 generic modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L5500 "Mirror of the Deep Water" + Jungle Treasure Chest.

---

## 2. Content Summary
| Item | Phase 11 Value | Source |
|---|---|---|
| Levels | 5001–5500 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Two Ponds (Linked Dual Boards, cross-board state transfer) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M501 (L5011), M502 (L5131), M503 (L5251), M504 (L5371) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L5491 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L5500 "Mirror of the Deep Water" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P11-A (5001–5250) · P11-B (5251–5500) | SCALING §3.5 |
| Max Grid | 2 Mini-Grids ($7\times 7$ થી $8\times 8$ પ્રત્યેક, પોટ્રેટમાં સ્ટેક્ડ અથવા લેન્ડસ્કેપમાં સાઇડ-બાય-સાઇડ) | Standard §9.3, §17.23 |
| Snakes Count | 28–42 snakes (બંને બોર્ડ પર વહેંચાયેલા) | SCALING §3.5 |
| Obstacle Instances | 8–15 instances કુલ | SCALING §3.5 |
| Jungle Gift Basket | 49 (L5010 … L5490) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Jungle Treasure Chest | L5500: 1,000 coins + 2 of each booster + Phase 11 badge | Standard §6.1, SCALING §6 |
| Golden Slither Rush | 20 rounds (after L5025, 5050 … 5500), 30 snakes each | Standard §6.1, §16.9 |

---

## 3. What's New vs Phase 10
| Area | Phase 10 | Phase 11 |
|---|---|---|
| Signature System | Sequencing (Jungle Drum Festival) | **Linked Boards (Two Ponds)** |
| Viewport Layout | Single continuous board | **Dual Mini-Grids**: સ્ક્રીન પર બે સ્વતંત્ર તળાવ (Pond 1 & Pond 2) |
| Snake Travel | Board boundary = Exit | **Inter-Board Transit (M501 & M504)**: એક બોર્ડમાંથી નીકળી સાપ બીજા બોર્ડમાં પ્રવેશે |
| State Causality | Local to 1 board | **Cross-Board Trigger (M502)**: એક બોર્ડની ક્રિયા બીજા બોર્ડના દરવાજા ખોલે |
| Multi-Tap Action | 1 snake per tap | **Synchronous Mirror Action (M503)**: એક ટેપથી બંને બોર્ડના સાપ સમાંતર ચાલે |

---

## 4. Release Prerequisites
1. **CI Generator Run:** L5001–5500 ના તમામ seeds pre-validated with dual-grid solvers.
2. **Metadata Asset:** `phase_11_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 11`.
5. **Tutorial Assets:** Vine Bridge (M501) અને Cross-board Key (M502) ના tutorial cards localized.

---

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_11_SCOPE_AND_RULES.md](./01_PHASE_11_SCOPE_AND_RULES.md) | Scope, limits, rules, dual-grid viewport architecture. |
| 02 | [02_LEVEL_PLAN_5001_5500.md](./02_LEVEL_PLAN_5001_5500.md) | 500-level slot allocation, 50 blocks, intros, review, finale. |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md) | Signature system rules, M501–M504 mechanics, transit logic. |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_11.md](./04_VARIANTS_AND_MODIFIERS_PHASE_11.md) | 45 variant catalog (Block 503–549), modifier combinations. |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_11.md](./05_REWARDS_AND_ECONOMY_PHASE_11.md) | Economy balance, Gift Baskets, Finale Chest, Golden Slither Rush. |
| 06 | [06_UI_AND_QA_PHASE_11.md](./06_UI_AND_QA_PHASE_11.md) | Dual viewport UI, Transit VFX, Cross-board SFX, QA checklist. |

---

## 6. Open Decisions
- **OD-P11-01:** Portrait Screen Orientation માં Dual-Grid લેઆઉટ — ઊભી રીતે બે તળાવ ઉપર-નીચે રાખવા કે સ્લાઇડિંગ કેમેરા વ્યુ રાખવો? Default: બંને તળાવ વર્ટિકલ સ્ટેક્ડ (ઉપર-નીચે) રહેશે જેથી સંપૂર્ણ બોર્ડ એકસાથે દૃશ્યમાન રહે.
- **OD-P11-02:** M503 Mirror Board માં જો એક સાપ બ્લોક થાય અને બીજો મુક્ત હોય તો વર્તન શું હોવું જોઈએ? Default: બંને સાપ અટકી જશે અને 0 Hearts કપાશે (સંપૂર્ણ સિંક્રનાઇઝ્ડ સેફ્ટી).


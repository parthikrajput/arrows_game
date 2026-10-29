# Phase 16 — Levels 7501–8000 (Treasure Keys)
> Snakes Slither ના Phase 16 update નું scope, signature system (Keys Deluxe: Treasure Keys), 4 નવા base mechanics (M751–M754), 45 variants, release prerequisites અને Phase 16 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 15 index](../phase_15/README.md) · [Phase 17 index](../phase_17/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 16 = **Advanced Lock & Key Metagame Update (Treasure Keys)**. Phase 15 પૂર્ણ કરનાર players માટે **L7501–8000** content:
1. **Signature System:** Treasure Keys (ચાવીઓની શૃંખલા, અર્ધ-ચાવીઓનું જોડાણ, માસ્ટર સ્કેલેટન કી અને સાપો વચ્ચે ચાવીઓની અદલાબદલી).
2. **4 New Base Mechanics:**
   - M751: Key Vine / Key Chain (ચાવીઓ ક્રમબદ્ધ શૃંખલામાં ખુલે છે: દરવાજો 1 ખુલતાં ચાવી 2 મુક્ત થાય છે).
   - M752: Key Bundle / Key Crafting (બે જુદા જુદા સાપ અર્ધ-ચાવી [Half-Key A & B] વહન કરે છે; બંને બહાર નીકળતાં સંપૂર્ણ ચાવી બનીને લૉક ખોલે છે).
   - M753: Golden Master Leaf / Skeleton Key (સાર્વત્રિક ગોલ્ડન કી જે પછીથી આવતા કોઈપણ પ્રથમ દરવાજાને અનલૉક કરે છે).
   - M754: Key Swap Stone / Key Swap (ટેપ કરવાથી બે સાપો પોતાની ચાવીઓની પરસ્પર અદલાબદલી કરે છે; ટેપ = 1 મૂવ).
3. **45 Variants:** Base mechanics × 10 generic modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L8000 "Vault of the Ten Thousand Keys" + Jungle Treasure Chest.

---

## 2. Content Summary
| Item | Phase 16 Value | Source |
|---|---|---|
| Levels | 7501–8000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Treasure Keys (Key chaining, half-key crafting, skeleton keys, key swaps) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M751 (L7511), M752 (L7631), M753 (L7751), M754 (L7871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L7991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L8000 "Vault of the Ten Thousand Keys" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P16-A (7501–7750) · P16-B (7751–8000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Snakes Count | 28–42 snakes | SCALING §3.5 |
| Obstacle Instances | 8–15 instances (ચેઇન લૉક્સ, ક્રાફ્ટિંગ ગેટ્સ, સ્વેપ સ્ટોન્સ) | SCALING §3.5 |
| Jungle Gift Basket | 49 (L7510 … L7990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Jungle Treasure Chest | L8000: 1,000 coins + 2 of each booster + Phase 16 badge | Standard §6.1, SCALING §6 |
| Golden Slither Rush | 20 rounds (after L7525, 7550 … 8000), 30 snakes each | Standard §6.1, §16.9 |

---

## 3. What's New vs Phase 15
| Area | Phase 15 | Phase 16 |
|---|---|---|
| Signature System | Conveyors & Tracks (River Delta) | **Keys Deluxe (Treasure Keys)** |
| Key Logic | Simple 1-key to 1-lock | **Chained Cascades (M751)**: તાળું ખુલતાં નવી ચાવી પ્રગટ થાય |
| Key Assembly | Pre-existing whole keys | **Key Crafting (M752)**: 2 અર્ધ-ચાવીઓ મળીને સંપૂર્ણ ચાવી બને |
| Lock Matching | Strict color/shape match | **Skeleton Key (M753)**: સાર્વત્રિક કી જે ગમે તે પ્રથમ લોક ખોલે |
| In-Board Transfer | Fixed badges on snakes | **Key Swap Mechanic (M754)**: સાપો વચ્ચે ચાવીઓની સક્રિય અદલાબદલી |

---

## 4. Release Prerequisites
1. **CI Generator Run:** L7501–8000 ના તમામ seeds pre-validated with key-dependency solvers.
2. **Metadata Asset:** `phase_16_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 16`.
5. **Tutorial Assets:** Key Chain (M751) અને Key Crafting (M752) ના tutorial cards localized.

---

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_16_SCOPE_AND_RULES.md](./01_PHASE_16_SCOPE_AND_RULES.md) | Scope, limits, rules, key-dependency DAG architecture. |
| 02 | [02_LEVEL_PLAN_7501_8000.md](./02_LEVEL_PLAN_7501_8000.md) | 500-level slot allocation, 50 blocks, intros, review, finale. |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md) | Signature system rules, M751–M754 mechanics, crafting logic. |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_16.md](./04_VARIANTS_AND_MODIFIERS_PHASE_16.md) | 45 variant catalog (Block 753–799), modifier combinations. |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_16.md](./05_REWARDS_AND_ECONOMY_PHASE_16.md) | Economy balance, Gift Baskets, Finale Chest, Golden Slither Rush. |
| 06 | [06_UI_AND_QA_PHASE_16.md](./06_UI_AND_QA_PHASE_16.md) | Key inventory ribbon, Half-key badge UI, VFX/SFX, QA checklist. |

---

## 6. Open Decisions
- **OD-P16-01:** M754 Key Swap Stone — શું સાપો એકબીજાની અડીને હોવા જરૂરી છે કે બોર્ડ પર ગમે ત્યાં હોઈ શકે? Default: બે સાપો જે આ પ્લેટની આસપાસના સેલ પર સ્થિર હોય તેમની વચ્ચે જ અદલાબદલી થાય છે.
- **OD-P16-02:** M753 Skeleton Key — જો બોર્ડ પર બે લોક એકસાથે ખુલ્લા હોય તો કયું લોક ખુલે? Default: જે લેનમાં સાપ આગળ વધે તે લેનનું સૌથી પ્રથમ લોક ખુલે છે.


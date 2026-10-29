# Phase 16 — Levels 7501–8000 (Ticket Office)
> Toy Trains: Wooden Railway Puzzle ના Phase 16 update નું scope, signature system (Multi-Key Networks & Ticket Crafting: Ticket Office / Keys Deluxe), 4 નવા railway base mechanics (M751–M754), 45 variants, release prerequisites અને Phase 16 ના તમામ દસ્તાવેજોનો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 15 index](../phase_15/README.md) · [Phase 17 index](../phase_17/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 16 = **Advanced Multi-Key Logistics & Ticket Crafting Update (Ticket Office)**. Phase 15 પૂર્ણ કરનાર ખેલાડીઓ માટે **L7501–8000** content:
1. **Signature System:** Ticket Office (Keys Deluxe: બહુ-સ્તરીય ટિકિટ સાંકળો, અડધી ટિકિટોનું જોડાણ/પંચિંગ, યુનિવર્સલ માસ્ટર પાસ અને ટિકિટ સ્વેપ પેડ્સ).
2. **4 New Base Mechanics:**
   - M751: Ticket Chain / Key Chain (ટિકિટ A વડે બેરિયર ખુલતાં તેમાંથી નવી ટિકિટ B બહાર આવે છે, ક્રમિક ચેઇન રીએક્શન).
   - M752: Ticket Punch / Key Crafting (પાટા પરથી એકત્ર કરેલી બે અડધી ટિકિટો પંચ સ્ટેશન પર જોડાઈને ૧ સંપૂર્ણ માન્ય ટિકિટ બને છે).
   - M753: Master Pass / Skeleton Key (વિશિષ્ટ ગોલ્ડન પાસ ધરાવતી ટ્રેન જે પોતાના માર્ગમાં આવતા પ્રથમ કોઈ પણ બેરિયરને ખોલે છે અને વપરાઈ જાય છે).
   - M754: Ticket Swap Pad / Key Swap (ટેપ કરવાથી (1 Move) બે જોડાયેલી ટ્રેનો વચ્ચે ટિકિટ પ્રતીકોની આપ-લે થાય છે).
3. **45 Variants:** Base mechanics × 10 generic railway modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L8000 "Master Ticket Bureau Terminal" + Grand Central Chest.

## 2. Content Summary
| Item | Phase 16 Value | Source |
|---|---|---|
| Levels | 7501–8000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Ticket Office (Multi-Key Networks & Ticket Crafting) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M751 (L7511), M752 (L7631), M753 (L7751), M754 (L7871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L7991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L8000 "Master Ticket Bureau Terminal" (Finale target D ≈ 91)| SCALING §3.5, §6 |
| Tiers | P16-A (7501–7750) · P16-B (7751–8000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (Pinch-zoom + Pan સક્ષમ) | Standard §9.3, §17.23 |
| Train Count | 36–52 trains | SCALING §3.5 |
| Obstacle Instances | 8–16 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L7510 … L7990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L8000: 1,000 coins + 2 of each booster + Phase 16 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L7525, 7550 … 8000), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 15
| Area | Phase 15 | Phase 16 |
|---|---|---|
| Signature System | Moving Platforms (Conveyors) | **Ticket Office (Keys Deluxe)** |
| Key Logic | Single-use tickets | **Chained Key Dependencies:** ટિકિટ A -> બેરિયર A -> ટિકિટ B |
| Key Crafting | None | **Ticket Punch (M752):** બે હાફ-ટિકિટ્સ ભેગી થઈ ફુલ ટિકિટ બને છે |
| Universal Key | None | **Master Pass (M753):** કોઈ પણ એક દરવાજો ખોલતી સ્કેલેટન કી ટ્રેન |
| Key Reallocation| Fixed keys | **Ticket Swap Pad (M754):** ટ્રેનો વચ્ચે ચાવીઓની અદલાબદલી |

## 4. Release Prerequisites
1. **CI Generator Run:** L7501–8000 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_16_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 16`.
5. **Tutorial Assets:** Ticket Chain, Ticket Punch, Master Pass, Ticket Swap localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_16_SCOPE_AND_RULES.md](./01_PHASE_16_SCOPE_AND_RULES.md) | Ticket Office rules, chained barriers, half-ticket crafting, master pass |
| 02 | [02_LEVEL_PLAN_7501_8000.md](./02_LEVEL_PLAN_7501_8000.md) | 50-block slot map, M751–M754 intros, 45 variants, L7991 review, L8000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md) | Keys Deluxe rules, M751–M754 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_16.md](./04_VARIANTS_AND_MODIFIERS_PHASE_16.md) | 45 variant slots (Ticket Office base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_16.md](./05_REWARDS_AND_ECONOMY_PHASE_16.md) | Economy inflow/outflow, Gift Crates, L8000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_16.md](./06_UI_AND_QA_PHASE_16.md) | Ticket stub inventory UI, Golden Master Pass flare, swap pad VFX, QA |

# Phase 14 — Levels 6501–7000 (Pond Reflections)
> Snakes Slither ના Phase 14 update નું scope, signature system (Mirror Worlds: Pond Reflections), 4 નવા base mechanics (M651–M654), 45 variants, release prerequisites અને Phase 14 ના દરેક document નો index.

**Related docs:** [Game overview](../../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 13 index](../phase_13/README.md) · [Phase 15 index](../phase_15/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 14 = **Mirror Symmetry & Twin World Puzzle Update (Pond Reflections)**. Phase 13 પૂર્ણ કરનાર players માટે **L6501–7000** content:
1. **Signature System:** Pond Reflections (બોર્ડના મધ્યમાંથી પસાર થતી જળ-અક્ષ જે બોર્ડને બે સપ્રમાણ અર્ધભાગોમાં વિભાજીત કરે છે અને બંને બાજુના સાપોને પ્રતિબિંબિત કરે છે).
2. **4 New Base Mechanics:**
   - M651: Pond Axis / Mirror Axis (એક બાજુના સાપને ટેપ કરતાં અક્ષની સામેની બાજુનો મિરર-સાપ પણ આપોઆપ સમાંતર ચાલે છે; બંનેનો માર્ગ સાફ હોવો અનિવાર્ય).
   - M652: Reflection Lock / Reflect Lock (સામેની વિરુદ્ધ બાજુનો કી-સાપ બહાર નીકળે ત્યારે જ આ બાજુનું લોક ખુલે છે).
   - M653: Twin Pond / Twin Board (બે એકસમાન પ્રતિબિંબિત બોર્ડ્સ; બંનેને સમાન ટેપ સિક્વન્સ પ્રતિબંધો સાથે ક્લિયર કરવાના રહે છે).
   - M654: Upside-down Snake / Inverse Path (વિશિષ્ટ ઊંધો સાપ જે પોતાના મિરર જોડીદારની તદ્દન વિરુદ્ધ દિશામાં ચાલે છે).
3. **45 Variants:** Base mechanics × 10 generic modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L7000 "Obsidian Mirror Convergence" + Jungle Treasure Chest.

---

## 2. Content Summary
| Item | Phase 14 Value | Source |
|---|---|---|
| Levels | 6501–7000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Pond Reflections (Mirror Worlds, bilateral symmetry, inverted vectors) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M651 (L6511), M652 (L6631), M653 (L6751), M654 (L6871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L6991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L7000 "Obsidian Mirror Convergence" (Finale target D ≈ 91) | SCALING §3.5, §6 |
| Tiers | P14-A (6501–6750) · P14-B (6751–7000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (સેન્ટ્રલ મિરર અક્ષ સાથે) | Standard §9.3, §17.23 |
| Snakes Count | 28–42 snakes (બંને અર્ધભાગમાં સપ્રમાણ વહેંચાયેલા) | SCALING §3.5 |
| Obstacle Instances | 8–15 instances કુલ | SCALING §3.5 |
| Jungle Gift Basket | 49 (L6510 … L6990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Jungle Treasure Chest | L7000: 1,000 coins + 2 of each booster + Phase 14 badge | Standard §6.1, SCALING §6 |
| Golden Slither Rush | 20 rounds (after L6525, 6550 … 7000), 30 snakes each | Standard §6.1, §16.9 |

---

## 3. What's New vs Phase 13
| Area | Phase 13 | Phase 14 |
|---|---|---|
| Signature System | Hidden Info (Mystery Mists) | **Mirror Worlds (Pond Reflections)** |
| Board Symmetry | Asymmetric single layout | **Bilateral Axis Symmetry**: મધ્ય અક્ષની બંને બાજુ સપ્રમાણતા |
| Dual-Action Input | 1 snake per tap | **Synchronous Mirror Slither (M651)**: એક ટેપથી 2 સાપ સમાંતર આગળ વધે |
| Inverse Kinematics | Forward directional paths | **Inverse Pathing (M654)**: વિરુદ્ધ દિશામાં સરકતો સાપ |
| Cross-Axis Lock | Fog reveal conditions | **Opposite-Side Reflection Lock (M652)**: વિરુદ્ધ કિનારાનું તાળું |

---

## 4. Release Prerequisites
1. **CI Generator Run:** L6501–7000 ના તમામ seeds pre-validated with mirror-pair solvers.
2. **Metadata Asset:** `phase_14_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 14`.
5. **Tutorial Assets:** Mirror Axis (M651) અને Reflection Lock (M652) ના tutorial cards localized.

---

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_14_SCOPE_AND_RULES.md](./01_PHASE_14_SCOPE_AND_RULES.md) | Scope, limits, rules, bilateral mirror engine. |
| 02 | [02_LEVEL_PLAN_6501_7000.md](./02_LEVEL_PLAN_6501_7000.md) | 500-level slot allocation, 50 blocks, intros, review, finale. |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md) | Signature system rules, M651–M654 mechanics, synchronous safety logic. |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_14.md](./04_VARIANTS_AND_MODIFIERS_PHASE_14.md) | 45 variant catalog (Block 653–699), modifier combinations. |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_14.md](./05_REWARDS_AND_ECONOMY_PHASE_14.md) | Economy balance, Gift Baskets, Finale Chest, Golden Slither Rush. |
| 06 | [06_UI_AND_QA_PHASE_14.md](./06_UI_AND_QA_PHASE_14.md) | Water axis ripple UI, Mirror twin shaders, QA checklist. |

---

## 6. Open Decisions
- **OD-P14-01:** M654 Inverse Path Snake visual indication — ઊંધા સાપને ખેલાડી કેવી રીતે ઓળખી શકે? Default: સાપના પેટ પર ઊંધી કલર સ્ટ્રીપ અને માથા પર વિરુદ્ધ દિશાનો એરો આઇકન.
- **OD-P14-02:** Central Mirror Axis પર સાપ અથડાય ત્યારે શું તે દીવાલ ગણાય? Default: હા, અક્ષ એ પાણીનું વિભાજક છે; સાપ તેને પાર કરી શકતો નથી સિવાય કે વિશિષ્ટ બ્રિજ ટાઇલ હોય.

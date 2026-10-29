# Phase 14 — Levels 6501–7000 (Alpine Pass)
> Toy Trains: Wooden Railway Puzzle ના Phase 14 update નું scope, signature system (Mirror Worlds & Alpine Reflection: Alpine Pass / Looking-Glass Line), 4 નવા railway base mechanics (M651–M654), 45 variants, release prerequisites અને Phase 14 ના તમામ દસ્તાવેજોનો index.

**Related docs:** [Game Overview](../../README.md) · [Phases Overview](../README.md) · [Shared Core Standard §11, §12](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §2–§6](../../SCALING_TO_10000_LEVELS.md) · [Phase 13 index](../phase_13/README.md) · [Phase 15 index](../phase_15/README.md)

---

## 1. Goal (લક્ષ્ય)
Phase 14 = **High Alpine Pass & Mirror Worlds Reflection Update (Alpine Pass)**. Phase 13 પૂર્ણ કરનાર ખેલાડીઓ માટે **L6501–7000** content:
1. **Signature System:** Alpine Pass / Looking-Glass Line (Mirror Worlds: બોર્ડની મધ્યમાં બર્ફીલો મિરર અક્ષ, સમાંતર પ્રતિબિંબિત ટ્રેનો, રીફ્લેક્શન લોક્સ અને ઇન્વર્સ એન્જિન્સ).
2. **4 New Base Mechanics:**
   - M651: Mirror Rail Axis / Alpine Mirror Track (એક ટ્રેન ટેપ કરતાં અક્ષની સામે રહેલી તેની પ્રતિબિંબિત ટ્વિન ટ્રેન આપોઆપ મિરર દિશામાં સાથે ચાલે છે; બંને પાટા ક્લિયર હોવા આવશ્યક છે).
   - M652: Reflection Lock / Glacier Lock (આલ્પાઇન બેરિયર ત્યારે જ ખુલે છે જ્યારે તેના મિરર અક્ષ પર રહેલો જોડીદાર બેરિયર પણ ખુલે છે).
   - M653: Alpine Twin Yard / Mirror Board (ડુપ્લિકેટ પ્રતિબિંબિત યાર્ડ જે પ્રત્યેક મૂવને સમાન રીતે શેર કરે છે).
   - M654: Reverse Engine / Inverse Path (પ્રતિબિંબિત અર્ધ-ભાગમાં રહેલી ટ્રેન પોતાના એરોની બરાબર વિરુદ્ધ દિશામાં એક્ઝિટ લે છે).
3. **45 Variants:** Base mechanics × 10 generic railway modifiers.
4. **Difficulty Band:** Fixed plateau **D 60–76** (standard §17.24).
5. **Phase Finale:** L7000 "Great Alpine Pass Mountain Junction" + Grand Central Chest.

## 2. Content Summary
| Item | Phase 14 Value | Source |
|---|---|---|
| Levels | 6501–7000 (On-device generated via seed) | Standard §11, §12; SCALING §2–§4 |
| Signature System | Alpine Pass (Looking-Glass Line / Mirror Worlds) | Standard §11, SCALING §6 |
| Base Mechanics | 4: M651 (L6511), M652 (L6631), M653 (L6751), M654 (L6871) | Standard §11, §17.38; SCALING §6 |
| Variants | 45 variant slots (x1 of remaining blocks) | Standard §11, §17.38; SCALING §7 |
| Review Level | L6991 (Block 50 x1 — "Mastery Mix", કોઈ નવું item નહીં) | Standard §17.34, §17.38 |
| Finale | L7000 "Great Alpine Pass Mountain Junction" (Target D ≈ 91)| SCALING §3.5, §6 |
| Tiers | P14-A (6501–6750) · P14-B (6751–7000) | SCALING §3.5 |
| Max Grid | 12×12–14×14 (સપ્રમાણ Symmetrical S-grid) | Standard §9.3, §17.23 |
| Train Count | 36–50 trains | SCALING §3.5 |
| Obstacle Instances | 8–16 instances | SCALING §3.5 |
| Conductor's Gift Crate | 49 (L6510 … L6990) × **300 coins** + 1 booster | Standard §6.1, SCALING §6 |
| Grand Central Chest | L7000: 1,000 coins + 2 of each booster + Phase 14 badge | Standard §6.1, SCALING §6 |
| Golden Express Coin Rush | 20 rounds (after L6525, 6550 … 7000), 30 trains each | Standard §6.1, §16.9 |

## 3. What's New vs Phase 13
| Area | Phase 13 | Phase 14 |
|---|---|---|
| Signature System | Weather Station (Fog on the Line) | **Alpine Pass (Looking-Glass Line)** |
| Board Symmetry | Asymmetric fog areas | **Mirror Symmetry:** મધ્યમાં બર્ફીલી રિજ અક્ષ પર ડાબે/જમણે સપ્રમાણ ગ્રીડ |
| Dual Control | Independent taps | **Mirror Rail Axis (M651):** સિંગલ ટેપથી અક્ષની બંને બાજુની ટ્રેનો સપ્રમાણ ગતિ કરે છે |
| Paired Barriers | Independent code gates | **Reflection Lock (M652):** બંને બાજુના બેરિયર્સ સંતુલિત ખુલે તો જ રસ્તો મળે |
| Direction Inversion| Standard arrow exits | **Reverse Engine (M654):** મિરર અર્ધ-ભાગમાં ટ્રેન પોતાના એરોથી ઉલટી દિશામાં ચાલે |

## 4. Release Prerequisites
1. **CI Generator Run:** L6501–7000 ના તમામ seeds pre-validated.
2. **Metadata Asset:** `phase_14_meta.bin` અને `seed_overrides.json` બંડલમાં હાજર હોવા જોઈએ.
3. **Cross-Platform Determinism:** ARM64 Android, iOS અને CI x64 પર સમાન hashes.
4. **Remote Config Flag:** `maxPhase = 14`.
5. **Tutorial Assets:** Mirror Rail Axis, Reflection Locks, Reverse Engines localized.

## 5. Document Index
| # | Document | વિગત |
|---|---|---|
| 01 | [01_PHASE_14_SCOPE_AND_RULES.md](./01_PHASE_14_SCOPE_AND_RULES.md) | Alpine pass symmetry rules, mirror axes, reflection locks, inverse paths |
| 02 | [02_LEVEL_PLAN_6501_7000.md](./02_LEVEL_PLAN_6501_7000.md) | 50-block slot map, M651–M654 intros, 45 variants, L6991 review, L7000 Finale |
| 03 | [03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md](./03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md) | Mirror Worlds rules, M651–M654 catalog cards, tick order, solver impact |
| 04 | [04_VARIANTS_AND_MODIFIERS_PHASE_14.md](./04_VARIANTS_AND_MODIFIERS_PHASE_14.md) | 45 variant slots (Alpine Mirror base × modifiers) |
| 05 | [05_REWARDS_AND_ECONOMY_PHASE_14.md](./05_REWARDS_AND_ECONOMY_PHASE_14.md) | Economy inflow/outflow, Gift Crates, L7000 Phase Chest, Coin Rush |
| 06 | [06_UI_AND_QA_PHASE_14.md](./06_UI_AND_QA_PHASE_14.md) | Alpine Glacier Axis shader, reflection link sparks, inverse arrow VFX, QA |
